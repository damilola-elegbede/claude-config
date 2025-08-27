#!/bin/bash
# Claude Code StatusLine Configuration
# Shows: model | git_branch | directory | output_mode | version
# Highlights version when updated

# Read Claude session data from stdin
input=$(cat)

# Extract information using jq
model_name=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
current_dir=$(basename "$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "/"')")
output_style=$(echo "$input" | jq -r '.output_style.name // "default"')
version=$(echo "$input" | jq -r '.version // "unknown"')

# Get git branch (fallback if git command fails)
git_branch=$(git branch --show-current 2>/dev/null || echo "no-git")

# Version update detection
version_file="$HOME/.claude/last_version"
last_version=""
version_display="$version"

# Read last seen version
if [[ -f "$version_file" ]]; then
    last_version=$(cat "$version_file" 2>/dev/null || echo "")
fi

# Check if version has changed
if [[ "$version" != "$last_version" && "$version" != "unknown" ]]; then
    # Version updated! Add star emoji
    version_display="$version ✨"
    # Update stored version
    echo "$version" > "$version_file" 2>/dev/null || true
fi

# Reset any previous formatting first
printf '\033[0m'

# Output with colors
# Model: red | Branch: orange | Dir: cyan | Style: yellow | Version: green (with ✨ if updated)
# Using • (bullet) as separator
printf '\033[31m%s\033[0m \033[90m•\033[0m \033[38;5;208m%s\033[0m \033[90m•\033[0m \033[36m%s\033[0m \033[90m•\033[0m \033[33m%s\033[0m \033[90m•\033[0m \033[32m%s\033[0m\n' \
  "$model_name" \
  "$git_branch" \
  "$current_dir" \
  "$output_style" \
  "$version_display"