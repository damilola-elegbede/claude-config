#!/bin/bash
# Claude Code StatusLine Configuration
# Shows: model | git_branch | directory | output_mode | usage% | last_prompt_summary
# Color scheme: red | orange | bright cyan (from LSCOLORS) | yellow | default | green

# Read Claude session data from stdin
input=$(cat)

# Extract information using jq
mode=$(echo "$input" | jq -r '.mode // "normal"')
model_name=$(echo "$input" | jq -r '.model.display_name // "Unknown Model"')
current_dir=$(basename "$(echo "$input" | jq -r '.workspace.current_dir // "/"')")
output_style=$(echo "$input" | jq -r '.output_style.name // "default"')
usage_percent=$(echo "$input" | jq -r '.usage.percentage_before_compacting // 0')
last_prompt=$(echo "$input" | jq -r '.last_prompt.summary // "Ready"')

# Get git branch (fallback if git command fails)
git_branch=$(git branch --show-current 2>/dev/null || echo "no-git")

# Color codes
# \033[31m = red (model)
# \033[38;5;208m = orange (git branch)
# \033[96m = bright cyan (directory - matches LSCOLORS 'G' for directories)
# \033[33m = yellow (output mode)
# \033[0m = default (usage percent)
# \033[32m = green (last prompt)
# \033[0m = reset

printf '\033[31m%s\033[0m | \033[38;5;208m%s\033[0m | \033[96m%s\033[0m | \033[33m%s\033[0m | %s%% | \033[32m%s\033[0m' \
  "$model_name" \
  "$git_branch" \
  "$current_dir" \
  "$output_style" \
  "$usage_percent" \
  "$last_prompt"