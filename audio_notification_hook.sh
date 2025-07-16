#!/bin/bash

# Audio Notification Hook for Claude Code
# Plays different audio notifications based on hook type and tool usage

# Configuration
TONE_DIR="/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic"
COMPLETION_CHIME="$TONE_DIR/Swish.m4r"
STOP_CHIME="$TONE_DIR/Ding.m4r"

HOOK_TYPE="$1"  # PostToolUse, Stop, or SubagentStop
TOOL_NAME="$2"
TOOL_SUCCESS="$3"

# Function to play audio notification
play_audio() {
    local audio_file="$1"
    if [[ -f "$audio_file" ]]; then
        afplay "$audio_file" 2>/dev/null &
    fi
}

# Function to check if tool represents significant completion
is_significant_completion() {
    local tool="$1"
    
    case "$tool" in
        "Write"|"MultiEdit"|"Edit")
            # File modification operations
            return 0
            ;;
        "Bash")
            # Command execution - check if it's significant
            # This is a simplified check - could be enhanced with more context
            return 0
            ;;
        "TodoWrite")
            # Task management operations
            return 0
            ;;
        "Git")
            # Version control operations
            return 0
            ;;
        *)
            # Read operations, searches, etc. - not significant
            return 1
            ;;
    esac
}

# Main logic
case "$HOOK_TYPE" in
    "PostToolUse")
        if [[ "$TOOL_SUCCESS" == "true" ]] && is_significant_completion "$TOOL_NAME"; then
            play_audio "$COMPLETION_CHIME"
        fi
        ;;
    "Stop"|"SubagentStop")
        play_audio "$STOP_CHIME"
        ;;
    *)
        # Default behavior for backward compatibility
        if [[ "$TOOL_SUCCESS" == "true" ]] && is_significant_completion "$TOOL_NAME"; then
            play_audio "$COMPLETION_CHIME"
        fi
        ;;
esac

# Exit successfully to allow tool execution to continue
exit 0