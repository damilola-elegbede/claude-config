#!/bin/bash
# Claude Code Exit Hook - Updates terminal version flags from 1 to 0
# This ensures stars only show once per version per terminal

# Get terminal identifier (same logic as statusline.sh)
if ! pwd_hash=$(printf '%s' "$PWD" | cksum | cut -d' ' -f1 2>/dev/null); then
    exit 0  # Fail silently
fi

# Get grandparent PID
if ! ppid=$(ps -o ppid= -p $$ 2>/dev/null | tr -d ' '); then
    exit 0  # Fail silently
fi

if ! gppid=$(ps -o ppid= -p $ppid 2>/dev/null | tr -d ' '); then
    exit 0  # Fail silently
fi

# Use grandparent PID (terminal emulator) + pwd hash for stability
raw_id="terminal_${gppid}_${pwd_hash}"
terminal_id="$(printf '%s' "$raw_id" | tr '/\n' '_' | tr -cd 'A-Za-z0-9._-')"

[[ -n "$terminal_id" ]] || exit 0

# Version tracking file
terminal_version_file="$HOME/.claude/terminal_versions/${terminal_id}"

# If file exists and contains VERSION;1, update to VERSION;0
if [[ -f "$terminal_version_file" ]]; then
    content=$(cat "$terminal_version_file" 2>/dev/null || echo "")
    
    # Parse version and flag
    version="${content%;*}"
    flag="${content#*;}"
    
    # If flag is 1, update to 0
    if [[ "$flag" == "1" && -n "$version" ]]; then
        tmp_file="$(mktemp "$HOME/.claude/terminal_versions/.tmp.XXXXXX" 2>/dev/null || printf '%s' "$HOME/.claude/terminal_versions/.tmp.$$")"
        umask 077
        printf '%s;0' "$version" > "$tmp_file" 2>/dev/null || true
        chmod 600 "$tmp_file" 2>/dev/null || true
        mv -f "$tmp_file" "$terminal_version_file" 2>/dev/null || true
    fi
fi

exit 0