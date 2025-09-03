#!/bin/bash
# Claude Code StatusLine Configuration
# Shows: model | git_branch | directory | output_mode | version
# Per-terminal version tracking: Each terminal shows ✨ when IT first sees a new version
#
# HOW IT WORKS:
# - Uses Claude session_id as terminal identifier (perfect for Claude Code)
# - Each Claude instance independently tracks what version it has seen
# - Shows ✨ only when this specific terminal/session sees a new version
# - Stars persist throughout the entire Claude session
# - No interference between different terminal windows
# - Auto-cleanup of tracking files after 7 days

# Read Claude session data from stdin
input=$(cat)

# Extract information using jq
model_name=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
current_dir=$(basename "$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "/"')")
output_style=$(echo "$input" | jq -r '.output_style.name // "default"')
version=$(echo "$input" | jq -r '.version // "unknown"')
session_id=$(echo "$input" | jq -r '.session_id // ""')

# Get git branch (fallback if git command fails)
git_branch=$(git branch --show-current 2>/dev/null || echo "no-git")

# Get terminal identifier (TTY or fallback to session_id)
tty_path=$(tty 2>/dev/null)
if [[ "$tty_path" != "not a tty" && -n "$tty_path" ]]; then
    terminal_id=$(echo "$tty_path" | sed 's/\//_/g')
else
    # Fallback to session_id when not in a terminal
    terminal_id="session_${session_id:-default}"
fi

# Version tracking files
version_dir="$HOME/.claude"
terminal_versions_dir="$version_dir/terminal_versions"
terminal_version_file="$terminal_versions_dir/${terminal_id}"
version_display="$version"

# Create terminal versions directory if needed
mkdir -p "$terminal_versions_dir" 2>/dev/null || true

# Read what version this terminal has seen
terminal_last_version=""
if [[ -f "$terminal_version_file" ]]; then
    terminal_last_version=$(cat "$terminal_version_file" 2>/dev/null || echo "")
fi

# Check if this terminal is seeing a new version
if [[ "$version" != "$terminal_last_version" && "$version" != "unknown" ]]; then
    # New version for THIS terminal - show stars!
    version_display="$version ✨"
    # Record that this terminal has now seen this version
    echo "$version" > "$terminal_version_file" 2>/dev/null || true
fi

# Clean up old terminal files (older than 7 days)
find "$terminal_versions_dir" -type f -mtime +7 -delete 2>/dev/null || true

# Clean up legacy files from old implementations
rm -f "$version_dir/acknowledged_version" "$version_dir/notified_session" 2>/dev/null || true
find "$version_dir" -name "session_version_*" -type f -delete 2>/dev/null || true

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