#!/bin/bash
# Claude Code Exit Hook
# Resets the star flag in terminal version files when a Claude session ends
# This ensures stars only show on the first run of a new Claude session

# Get terminal identifier based on grandparent PID and working directory
if ! pwd_hash=$(printf '%s' "$PWD" | cksum | cut -d' ' -f1 2>/dev/null); then
    # Silently exit if we can't get PWD hash
    exit 0
fi

# Get grandparent PID - required for terminal identification
if ! ppid=$(ps -o ppid= -p $$ 2>/dev/null | tr -d ' '); then
    # Silently exit if we can't get parent PID
    exit 0
fi

if ! gppid=$(ps -o ppid= -p $ppid 2>/dev/null | tr -d ' '); then
    # Silently exit if we can't get grandparent PID
    exit 0
fi

# Use grandparent PID (terminal emulator) + pwd hash for stability
raw_id="terminal_${gppid}_${pwd_hash}"
terminal_id="$(printf '%s' "$raw_id" | tr '/\n' '_' | tr -cd 'A-Za-z0-9._-')"

[[ -n "$terminal_id" ]] || terminal_id="fallback_$$"

# Version tracking files
version_dir="$HOME/.claude"
terminal_versions_dir="$version_dir/terminal_versions"
terminal_version_file="$terminal_versions_dir/${terminal_id}"

# If the terminal version file exists, update flag to 0
if [[ -f "$terminal_version_file" ]]; then
    # Read current content
    stored_content=$(cat "$terminal_version_file" 2>/dev/null || echo "")
    
    # Parse VERSION:FLAG format
    if [[ "$stored_content" =~ ^([^:]+):([01])$ ]]; then
        stored_version="${BASH_REMATCH[1]}"
        # Update file with flag set to 0
        tmp_file="$(mktemp "$terminal_versions_dir/.tmp.XXXXXX" 2>/dev/null || printf '%s' "$terminal_versions_dir/.tmp.$$")"
        umask 077
        printf '%s:0' "$stored_version" > "$tmp_file" 2>/dev/null || true
        chmod 600 "$tmp_file" 2>/dev/null || true
        mv -f "$tmp_file" "$terminal_version_file" 2>/dev/null || true
    fi
fi

exit 0