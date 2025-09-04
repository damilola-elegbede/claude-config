#!/bin/bash
# Claude Code StatusLine Configuration
# Shows: model | git_branch | directory | output_mode | version
# Per-terminal version tracking: Each terminal shows ✨ when IT first sees a new version
#
# FALLBACK BEHAVIOR:
# - When Claude Code passes empty/invalid JSON: shows "Claude" model, current dir, "default" style
# - When Claude Code passes valid JSON: uses provided data with smart defaults
# - Invalid/unknown versions default to 1.0.100
# - Always maintains per-terminal version tracking and git branch detection
#
# HOW IT WORKS:
# - Uses stable terminal identifier (grandparent PID + pwd hash)
# - Terminal files store VERSION:FLAG format (e.g., "1.0.102:1")
# - FLAG=1 means show stars, FLAG=0 means don't show stars
# - Shows ✨ when FLAG=1 in the terminal's tracking file
# - New terminals create file with FLAG=1
# - Version changes update file with FLAG=1
# - Same version keeps existing flag
# - No interference between different terminal windows
# - Auto-cleanup of tracking files after 7 days
#
# STAR LOGIC:
# - File format: VERSION:FLAG (e.g., "1.0.102:1")
# - New terminal: creates file with VERSION:1 (show stars)
# - Version change: updates file with NEW_VERSION:1 (show stars)
# - Same version: reads existing flag from file
# - Unknown/invalid version: defaults to 1.0.100:1

# Read Claude session data from stdin
input=$(cat)

# Ensure jq is available
if ! command -v jq >/dev/null 2>&1; then
  printf 'jq is required for statusline.sh\n' >&2
  exit 0
fi

# Check if input is empty or invalid JSON and set fallback values
if [[ -z "$input" ]] || ! echo "$input" | jq . >/dev/null 2>&1; then
  # No data or invalid JSON from Claude Code - use sensible defaults
  model_name="Claude"
  current_dir=$(basename "$PWD")
  output_style="default"
  version="unknown"
else
  # Valid JSON input - extract information using jq
  model_name=$(echo "$input" | jq -r '.model.display_name // "Claude"')
  current_dir=$(basename "$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "'"$PWD"'"')")
  output_style=$(echo "$input" | jq -r '.output_style.name // "default"')
  version=$(echo "$input" | jq -r '.version // "unknown"')
fi

# Get git branch (fallback if git command fails)
git_branch=$(git branch --show-current 2>/dev/null || echo "")
[[ -n "$git_branch" ]] || git_branch="no-git"

# Get terminal identifier based on grandparent PID and working directory
if ! pwd_hash=$(printf '%s' "$PWD" | cksum | cut -d' ' -f1 2>/dev/null); then
    printf 'Error: Unable to generate PWD hash for statusline\n' >&2
    exit 1
fi

# Get grandparent PID - required for terminal identification
if ! ppid=$(ps -o ppid= -p $$ 2>/dev/null | tr -d ' '); then
    printf 'Error: Unable to get parent PID for statusline\n' >&2
    exit 1
fi

if ! gppid=$(ps -o ppid= -p $ppid 2>/dev/null | tr -d ' '); then
    printf 'Error: Unable to get grandparent PID for statusline\n' >&2
    exit 1
fi

# Use grandparent PID (terminal emulator) + pwd hash for stability
raw_id="terminal_${gppid}_${pwd_hash}"
terminal_id="$(printf '%s' "$raw_id" | tr '/\n' '_' | tr -cd 'A-Za-z0-9._-')"

[[ -n "$terminal_id" ]] || terminal_id="fallback_$$"

# Version tracking files
version_dir="$HOME/.claude"
terminal_versions_dir="$version_dir/terminal_versions"
terminal_version_file="$terminal_versions_dir/${terminal_id}"

# Handle unknown/invalid version - use default 1.0.100
if [[ "$version" == "unknown" ]] || [[ -z "$version" ]]; then
    version="1.0.100"
fi

# Extract semantic version (e.g., "1.0.102" from "1.0.102:uuid:uuid")
semantic_version="${version%%:*}"

# Validate semantic version format - use default if invalid
if [[ ! "$semantic_version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    semantic_version="1.0.100"
    version="1.0.100"  # Also update display version
fi

version_display="$version"

# Create terminal versions directory if needed
mkdir -p -m 700 "$terminal_versions_dir" 2>/dev/null || true

# Per-Terminal Version Tracking: Store VERSION:FLAG format
# Only show stars if this is a new Claude session (file doesn't exist)
show_stars=false

if [[ ! -f "$terminal_version_file" ]]; then
    # New Claude session - create file with VERSION:1 (show stars)
    tmp_file="$(mktemp "$terminal_versions_dir/.tmp.XXXXXX" 2>/dev/null || printf '%s' "$terminal_versions_dir/.tmp.$$")"
    umask 077
    printf '%s:1' "$semantic_version" > "$tmp_file" 2>/dev/null || true
    chmod 600 "$tmp_file" 2>/dev/null || true
    mv -f "$tmp_file" "$terminal_version_file" 2>/dev/null || true
    show_stars=true
else
    # File exists - read and parse the content
    stored_content=$(cat "$terminal_version_file" 2>/dev/null || echo "")
    
    # Parse VERSION:FLAG format
    if [[ "$stored_content" =~ ^([^:]+):([01])$ ]]; then
        stored_version="${BASH_REMATCH[1]}"
        stored_flag="${BASH_REMATCH[2]}"
    else
        # Old format or corrupted - treat as version only
        stored_version="$stored_content"
        stored_flag="0"
    fi
    
    # Check if version changed
    if [[ "$stored_version" != "$semantic_version" ]]; then
        # Version changed - update file with new VERSION:1 (show stars for new version)
        tmp_file="$(mktemp "$terminal_versions_dir/.tmp.XXXXXX" 2>/dev/null || printf '%s' "$terminal_versions_dir/.tmp.$$")"
        umask 077
        printf '%s:1' "$semantic_version" > "$tmp_file" 2>/dev/null || true
        chmod 600 "$tmp_file" 2>/dev/null || true
        mv -f "$tmp_file" "$terminal_version_file" 2>/dev/null || true
        show_stars=true  # Show stars for new version
    else
        # Same version - use stored flag
        if [[ "$stored_flag" == "1" ]]; then
            show_stars=true
        else
            show_stars=false
        fi
    fi
fi

# Set version display based on star status (persistent for the session)
if [[ "$show_stars" == "true" ]]; then
    version_display="$version ✨"
fi

# Clean up old terminal files (older than 7 days)
if [[ -d "$terminal_versions_dir" ]]; then
  find -P "$terminal_versions_dir" -type f -mtime +7 -delete 2>/dev/null || true
fi

# Clean up legacy files from old implementations
rm -f "$version_dir/acknowledged_version" "$version_dir/notified_session" 2>/dev/null || true

# Reset any previous formatting first
printf '\033[0m'

# Output with colors
# Model: red | Branch: orange | Dir: cyan | Style: yellow | Version: green (with ✨ if new)
# Using • (bullet) as separator
printf '\033[31m%s\033[0m \033[90m•\033[0m \033[38;5;208m%s\033[0m \033[90m•\033[0m \033[36m%s\033[0m \033[90m•\033[0m \033[33m%s\033[0m \033[90m•\033[0m \033[32m%s\033[0m\n' \
  "$model_name" \
  "$git_branch" \
  "$current_dir" \
  "$output_style" \
  "$version_display"
