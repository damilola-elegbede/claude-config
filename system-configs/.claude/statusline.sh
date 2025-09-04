#!/bin/bash
# Claude Code StatusLine Configuration
# Shows: model | git_branch | directory | output_mode | version
# Per-terminal version tracking: Each terminal shows ✨ when IT first sees a new version
#
# FALLBACK BEHAVIOR:
# - When Claude Code passes empty/invalid JSON: shows "Claude" model, current dir, "default" style
# - When Claude Code passes valid JSON: uses provided data with smart defaults
# - Always maintains per-terminal version tracking and git branch detection
#
# HOW IT WORKS:
# - Uses stable terminal identifier (grandparent PID + pwd hash)
# - Each terminal file stores VERSION;FLAG format (e.g., "1.0.102;1")
# - FLAG values: 1 = show stars (first time), 0 = don't show stars
# - Shows ✨ only once per version per terminal
# - No interference between different terminal windows
# - Auto-cleanup of tracking files after 7 days or when process ends
#
# STAR LOGIC:
# - New terminal with new version: writes "1.0.104;1" → shows stars
# - During session: keeps showing stars while flag=1
# - On Claude exit: exit hook updates "1.0.104;1" to "1.0.104;0"
# - Next launch: reads "1.0.104;0" → no stars
# - Version update: replaces with "1.0.105;1" → shows stars
# - Unknown version: prints error and exits

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

# Check for unknown version and print error
if [[ "$version" == "unknown" ]]; then
    printf '\033[31m⚠️ ERROR: Claude Code is not reporting version properly (got "unknown")\033[0m\n' >&2
    printf '\033[31mPlease restart Claude Code or report this issue\033[0m\n' >&2
    exit 1
fi

# Extract semantic version (e.g., "1.0.102" from "1.0.102:uuid:uuid")
semantic_version="${version%%:*}"

# Validate semantic version format
if [[ ! "$semantic_version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    printf '\033[31m⚠️ ERROR: Invalid version format: %s\033[0m\n' "$version" >&2
    printf '\033[31mExpected format: X.Y.Z or X.Y.Z:uuid:uuid\033[0m\n' >&2
    exit 1
fi

version_display="$version"

# Create terminal versions directory if needed
mkdir -p -m 700 "$terminal_versions_dir" 2>/dev/null || true

# Per-Terminal Version Tracking: Store VERSION;FLAG format
# FLAG: 1 = show stars (first time), 0 = don't show stars
show_stars=false

if [[ ! -f "$terminal_version_file" ]]; then
    # New terminal - create file with flag=1 (show stars)
    tmp_file="$(mktemp "$terminal_versions_dir/.tmp.XXXXXX" 2>/dev/null || printf '%s' "$terminal_versions_dir/.tmp.$$")"
    umask 077
    printf '%s;1' "$semantic_version" > "$tmp_file" 2>/dev/null || true
    chmod 600 "$tmp_file" 2>/dev/null || true
    mv -f "$tmp_file" "$terminal_version_file" 2>/dev/null || true
    show_stars=true
else
    # Read stored content (VERSION;FLAG format)
    stored_content=$(cat "$terminal_version_file" 2>/dev/null || echo "")
    
    # Parse version and flag
    stored_version="${stored_content%;*}"
    stored_flag="${stored_content#*;}"
    
    # Validate flag (default to 1 if invalid)
    if [[ "$stored_flag" != "0" && "$stored_flag" != "1" ]]; then
        stored_flag="1"
    fi
    
    if [[ "$stored_version" != "$semantic_version" ]]; then
        # Version changed - create new entry with flag=1 (show stars)
        tmp_file="$(mktemp "$terminal_versions_dir/.tmp.XXXXXX" 2>/dev/null || printf '%s' "$terminal_versions_dir/.tmp.$$")"
        umask 077
        printf '%s;1' "$semantic_version" > "$tmp_file" 2>/dev/null || true
        chmod 600 "$tmp_file" 2>/dev/null || true
        mv -f "$tmp_file" "$terminal_version_file" 2>/dev/null || true
        show_stars=true
    else
        # Same version - check flag
        if [[ "$stored_flag" == "1" ]]; then
            # Flag is 1 - keep showing stars for this session
            # Flag will be updated to 0 on exit
            show_stars=true
        else
            # Flag is 0 - no stars
            show_stars=false
        fi
    fi
fi

# Set version display based on star status (persistent for the session)
if [[ "$show_stars" == "true" ]]; then
    version_display="$version ✨"
fi

# Clean up old terminal files (older than 7 days OR if gppid no longer running)
if [[ -d "$terminal_versions_dir" ]]; then
  # Clean files older than 7 days
  find -P "$terminal_versions_dir" -type f -mtime +7 -delete 2>/dev/null || true
  
  # Clean files for terminals that are no longer running
  for file in "$terminal_versions_dir"/terminal_*; do
    if [[ -f "$file" ]]; then
      # Extract gppid from filename (terminal_GPPID_HASH format)
      filename=$(basename "$file")
      if [[ "$filename" =~ ^terminal_([0-9]+)_ ]]; then
        file_gppid="${BASH_REMATCH[1]}"
        # Check if this PID is still running
        if ! ps -p "$file_gppid" >/dev/null 2>&1; then
          # Process no longer exists - safe to delete
          rm -f "$file" 2>/dev/null || true
        fi
      fi
    fi
  done
fi

# Clean up legacy files from old implementations
rm -f "$version_dir/acknowledged_version" "$version_dir/notified_session" 2>/dev/null || true
find -P "$version_dir" -name "session_version_*" -type f -delete 2>/dev/null || true
# Clean up all session_* files from previous implementations
if [[ -d "$terminal_versions_dir" ]]; then
    find -P "$terminal_versions_dir" -name "session_*" -type f -delete 2>/dev/null || true
fi

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
