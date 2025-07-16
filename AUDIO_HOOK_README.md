# Audio Completion Notifications Hook

## Overview
This hook system provides automatic audio notifications for different Claude Code events, improving user experience by providing immediate auditory feedback without requiring manual intervention.

## Configuration

### Hook Script Location
- **Script**: `/Users/damilola/.claude/audio_notification_hook.sh`
- **Completion Sound**: `/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Swish.m4r`
- **Stop Sound**: `/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Ding.m4r`

### Settings Configuration
Add to `/Users/damilola/.claude/settings.json`:
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [{"type": "command", "command": "/Users/damilola/.claude/audio_notification_hook.sh PostToolUse Write true"}]
      },
      {
        "matcher": "Edit",
        "hooks": [{"type": "command", "command": "/Users/damilola/.claude/audio_notification_hook.sh PostToolUse Edit true"}]
      },
      {
        "matcher": "MultiEdit",
        "hooks": [{"type": "command", "command": "/Users/damilola/.claude/audio_notification_hook.sh PostToolUse MultiEdit true"}]
      },
      {
        "matcher": "Bash",
        "hooks": [{"type": "command", "command": "/Users/damilola/.claude/audio_notification_hook.sh PostToolUse Bash true"}]
      },
      {
        "matcher": "TodoWrite",
        "hooks": [{"type": "command", "command": "/Users/damilola/.claude/audio_notification_hook.sh PostToolUse TodoWrite true"}]
      }
    ],
    "Stop": [
      {
        "matcher": "*",
        "hooks": [{"type": "command", "command": "/Users/damilola/.claude/audio_notification_hook.sh Stop"}]
      }
    ],
    "SubagentStop": [
      {
        "matcher": "*",
        "hooks": [{"type": "command", "command": "/Users/damilola/.claude/audio_notification_hook.sh SubagentStop"}]
      }
    ]
  }
}
```

## Hook Types and Sounds

### PostToolUse Hooks (Swish.m4r)
- **Write**: File creation operations
- **Edit**: File modification operations
- **MultiEdit**: Multiple file edits
- **Bash**: Command execution
- **TodoWrite**: Task management operations

### Stop Hooks (Ding.m4r)
- **Stop**: When Claude stops execution
- **SubagentStop**: When subagents stop execution

## Excluded Tools
- **Read**: File reading operations
- **Grep**: Search operations
- **Glob**: File pattern matching
- **LS**: Directory listing

## Troubleshooting

### No Audio Playing
1. Check if audio files exist: 
   - `ls -la "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Swish.m4r"`
   - `ls -la "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Ding.m4r"`
2. Test audio manually: 
   - `afplay "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Swish.m4r"`
   - `afplay "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Ding.m4r"`
3. Check script permissions: `ls -la ~/.claude/audio_notification_hook.sh`
4. Verify hook configuration in settings.json

### Too Many Notifications
The hook includes smart filtering to avoid notification fatigue. If you're still getting too many notifications, you can:
1. Modify the `is_significant_completion()` function in the hook script
2. Add more restrictive filtering logic
3. Remove specific tool matchers from settings.json

### Disabling Notifications
To temporarily disable:
1. Comment out the hooks section in settings.json
2. Or rename the hook script file

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
To test the hook script directly:
```bash
# Test PostToolUse hooks (Swish.m4r)
/Users/damilola/.claude/audio_notification_hook.sh PostToolUse Write true
/Users/damilola/.claude/audio_notification_hook.sh PostToolUse Edit true
/Users/damilola/.claude/audio_notification_hook.sh PostToolUse Bash true

# Test Stop hooks (Ding.m4r)
/Users/damilola/.claude/audio_notification_hook.sh Stop
/Users/damilola/.claude/audio_notification_hook.sh SubagentStop
```

### Expected Behavior
- **Swish sound**: Plays after each significant tool operation (Write, Edit, MultiEdit, Bash, TodoWrite)
- **Ding sound**: Plays when Claude stops or subagents stop
- No audio for Read, Grep, Glob, LS operations
- Audio playback runs in background (non-blocking)
- Graceful failure if audio system is unavailable

### Test Results Verification
- ✅ Write operations trigger Swish.m4r audio notifications
- ✅ Edit operations trigger Swish.m4r audio notifications  
- ✅ MultiEdit operations trigger Swish.m4r audio notifications
- ✅ Bash operations trigger Swish.m4r audio notifications
- ✅ TodoWrite operations trigger Swish.m4r audio notifications
- ✅ Stop hooks trigger Ding.m4r audio notifications
- ✅ SubagentStop hooks trigger Ding.m4r audio notifications
- ✅ Hook script handles missing audio files gracefully
- ✅ Audio playback is non-blocking