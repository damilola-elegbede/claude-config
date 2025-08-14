# Audio Completion Notifications Hook

## Overview

This hook system provides automatic audio notifications for different Claude Code events, improving user experience by providing immediate auditory feedback without requiring manual intervention.

## Configuration

### Audio Configuration

- **Completion Sound**: `/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Swish.m4r`
- **Stop Sound**: `/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Chord.m4r`
- **Notification Sound**: `/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Aurora.m4r`
- **Implementation**: Direct afplay commands in Claude Code hooks

### Settings Configuration

Add to `/Users/damilola/.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "afplay -v 1.0 '/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Swish.m4r' 2>/dev/null &"
          }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "afplay -v 1.0 '/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Chord.m4r' 2>/dev/null &"
          }
        ]
      }
    ],
    "SubagentStop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "afplay -v 1.0 '/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Chord.m4r' 2>/dev/null &"
          }
        ]
      }
    ],
    "Notification": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "afplay -v 1.0 '/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Aurora.m4r' 2>/dev/null &"
          }
        ]
      }
    ]
  }
}
```

## Hook Types and Sounds

### PostToolUse Hooks (Swish.m4r)

- Triggers on all tool operations (matcher: "*")
- Plays Classic Swish sound for immediate feedback

### Stop Hooks (Chord.m4r)

- **Stop**: When Claude stops execution
- **SubagentStop**: When subagents stop execution
- Plays Modern Chord sound for completion

### Notification Hooks (Aurora.m4r)

- Triggers when Claude needs permission to use a tool
- Triggers when prompt input has been idle for 60+ seconds
- Plays Modern Aurora sound for attention

## Universal Matching

- All tools trigger PostToolUse notifications (matcher: "*")
- No tools are excluded from audio feedback
- Provides consistent auditory feedback for all operations

## Troubleshooting

### No Audio Playing

1. Check if audio files exist:
   - `ls -la "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Swish.m4r"`
   - `ls -la "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Chord.m4r"`
   - `ls -la "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Aurora.m4r"`
2. Test audio manually:
   - `afplay -v 1.0 "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Swish.m4r"`
   - `afplay -v 1.0 "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Chord.m4r"`
   - `afplay -v 1.0 "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Aurora.m4r"`
3. Verify hook configuration in settings.json

### Too Many Notifications

The hooks use matcher patterns to filter which tools trigger notifications. If you're still getting too many notifications, you can:

1. Modify the matcher patterns in settings.json to be more specific
2. Remove specific tools from the matcher (e.g., change "Write|Edit|MultiEdit|Bash|TodoWrite" to "Write|Edit|MultiEdit")
3. Add time-based filtering or other logic if needed

### Disabling Notifications

To temporarily disable:

1. Comment out the hooks section in settings.json
2. Or remove the PostToolUse, Stop, and SubagentStop hooks entirely

## Testing

### Manual Testing

Test the hook with these Claude Code operations:

1. **Write Operation Test**:
   - Use Claude Code Write tool to create a new file
   - Should trigger audio notification

2. **Edit Operation Test**:
   - Use Claude Code Edit tool to modify an existing file
   - Should trigger audio notification

3. **MultiEdit Operation Test**:
   - Use Claude Code MultiEdit tool to make multiple changes
   - Should trigger audio notification

4. **Bash Operation Test**:
   - Use Claude Code Bash tool to execute commands
   - Should trigger audio notification

5. **TodoWrite Operation Test**:
   - Use Claude Code TodoWrite tool to update tasks
   - Should trigger audio notification

### Automated Testing

To test the audio notifications directly:

```bash
# Test PostToolUse hooks (Swish.m4r)
afplay -v 1.0 '/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Swish.m4r' 2>/dev/null &

# Test Stop hooks (Chord.m4r)
afplay -v 1.0 '/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Chord.m4r' 2>/dev/null &

# Test Notification hooks (Aurora.m4r)
afplay -v 1.0 '/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Aurora.m4r' 2>/dev/null &
```

### Expected Behavior

- **Swish sound**: Plays after each tool operation (matcher: "*")
- **Chord sound**: Plays when Claude stops or subagents stop
- **Aurora sound**: Plays when Claude needs permission or is waiting for input
- All tools trigger audio feedback (universal matcher)
- Audio playback runs in background (non-blocking)
- Graceful failure if audio system is unavailable

### Test Results Verification

- ✅ All tool operations trigger Swish.m4r audio notifications (matcher: "*")
- ✅ Stop hooks trigger Chord.m4r audio notifications
- ✅ SubagentStop hooks trigger Chord.m4r audio notifications
- ✅ Notification hooks trigger Aurora.m4r for permission/idle events
- ✅ Direct afplay commands handle missing audio files gracefully
