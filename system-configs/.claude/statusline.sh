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
# - Uses stable terminal identifier (TTY + process info or session_id)
# - Each terminal independently tracks what version it has seen
# - Shows ✨ when this specific terminal sees a new version OR first run with unknown version
# - For unknown versions: creates pseudo-version from git commit or date
# - Stars persist throughout the terminal session for each pseudo-version
# - No interference between different terminal windows
# - Auto-cleanup of tracking files after 7 days
#
# STAR LOGIC:
# - Known versions: stars when terminal first sees that specific version
# - Unknown versions: stars on first run per terminal (using git commit or date as pseudo-version)
# - Each terminal gets its own tracking file ensuring proper isolation

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
  session_id=""
else
  # Valid JSON input - extract information using jq
  model_name=$(echo "$input" | jq -r '.model.display_name // "Claude"')
  current_dir=$(basename "$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "'"$PWD"'"')")
  output_style=$(echo "$input" | jq -r '.output_style.name // "default"')
  version=$(echo "$input" | jq -r '.version // "unknown"')
  session_id=$(echo "$input" | jq -r '.session_id // ""')
fi

# Get git branch (fallback if git command fails)
git_branch=$(git branch --show-current 2>/dev/null || echo "")
[[ -n "$git_branch" ]] || git_branch="no-git"

# Get terminal identifier - prioritize session_id for terminal isolation
if [[ -n "$session_id" ]]; then
    # Use session_id when available (enables test isolation) — sanitize
    safe_session_id="$(printf '%s' "$session_id" | tr '/\n' '_' | tr -cd 'A-Za-z0-9._-')"
    terminal_id="session_${safe_session_id}"
elif tty_path=$(tty 2>/dev/null); then
    # Use TTY path as primary identifier
    raw_id="$tty_path"
    # Add process group ID for additional uniqueness
    if pgid=$(ps -o pgid= -p $$ 2>/dev/null); then
        raw_id="${raw_id}_pg${pgid// /}"
    fi
    # Replace slashes/newlines and whitelist safe chars to prevent path traversal
    terminal_id="$(printf '%s' "$raw_id" | tr '/\n' '_' | tr -cd 'A-Za-z0-9._-')"
else
    # For non-TTY environments, create a stable ID based on terminal and working directory
    # Both grandparent PID and pwd hash are required - no fallbacks
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
    
    # Use grandparent PID (terminal emulator) for stability
    raw_id="terminal_${gppid}_${pwd_hash}"
    terminal_id="$(printf '%s' "$raw_id" | tr '/\n' '_' | tr -cd 'A-Za-z0-9._-')"
fi

[[ -n "$terminal_id" ]] || terminal_id="fallback_$$"

# Version tracking files
version_dir="$HOME/.claude"
terminal_versions_dir="$version_dir/terminal_versions"
terminal_version_file="$terminal_versions_dir/${terminal_id}"

# Handle version tracking - create pseudo-version for unknown cases
tracking_version="$version"

if [[ "$version" == "unknown" ]]; then
    # For unknown versions, create a stable pseudo-version based on git commit
    # This allows proper version comparison instead of always showing stars
    if git_commit=$(git rev-parse --short HEAD 2>/dev/null); then
        tracking_version="unknown-${git_commit}"
    else
        # Fallback to date-based pseudo-version (changes daily)
        tracking_version="unknown-$(date '+%Y%m%d')"
    fi
fi

version_display="$version"

# Create terminal versions directory if needed
mkdir -p -m 700 "$terminal_versions_dir" 2>/dev/null || true

# Per-Terminal Version Tracking: Store only version, show stars based on logic
show_stars=false

if [[ ! -f "$terminal_version_file" ]]; then
    # New terminal - show stars and record version
    tmp_file="$(mktemp "$terminal_versions_dir/.tmp.XXXXXX" 2>/dev/null || printf '%s' "$terminal_versions_dir/.tmp.$$")"
    umask 077
    printf '%s' "$tracking_version" > "$tmp_file" 2>/dev/null || true
    chmod 600 "$tmp_file" 2>/dev/null || true
    mv -f "$tmp_file" "$terminal_version_file" 2>/dev/null || true
    show_stars=true
else
    # Read stored version
    stored_version=$(cat "$terminal_version_file" 2>/dev/null || echo "")
    
    if [[ "$stored_version" != "$tracking_version" ]]; then
        # Version changed - show stars and update file
        tmp_file="$(mktemp "$terminal_versions_dir/.tmp.XXXXXX" 2>/dev/null || printf '%s' "$terminal_versions_dir/.tmp.$$")"
        umask 077
        printf '%s' "$tracking_version" > "$tmp_file" 2>/dev/null || true
        chmod 600 "$tmp_file" 2>/dev/null || true
        mv -f "$tmp_file" "$terminal_version_file" 2>/dev/null || true
        show_stars=true
    else
        # Same version - no stars
        show_stars=false
    fi
fi

# Set version display based on star status
if [[ "$show_stars" == "true" ]]; then
    if [[ "$version" == "unknown" ]]; then
        version_display="Claude ✨"
    else
        version_display="$version ✨"
    fi
fi

# Clean up old terminal files (older than 7 days)
if [[ -d "$terminal_versions_dir" ]]; then
  find -P "$terminal_versions_dir" -type f -mtime +7 -delete 2>/dev/null || true
fi

# Clean up legacy files from old implementations
rm -f "$version_dir/acknowledged_version" "$version_dir/notified_session" 2>/dev/null || true
find -P "$version_dir" -name "session_version_*" -type f -delete 2>/dev/null || true
# Clean up old temporary session files from previous implementations (but not current session files)
# Only clean up files that match the old pattern from previous implementation
if [[ -d "$terminal_versions_dir" ]]; then
    # Only delete old-style session files that have the pattern "session_DATE" but are older than 1 day
    # This preserves current session files while cleaning up old temporary files
    # Exclude the current session file from deletion
    if [[ -n "$terminal_version_file" && -f "$terminal_version_file" ]]; then
        find -P "$terminal_versions_dir" -name "session_*" -type f \
            ! -name "$(basename "$terminal_version_file")" \
            -mtime +1 -delete 2>/dev/null || true
    else
        find -P "$terminal_versions_dir" -name "session_*" -type f -mtime +1 -delete 2>/dev/null || true
    fi
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
