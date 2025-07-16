# Audio Completion Notifications Hook

## Overview
This hook system provides automatic audio notifications for different Claude Code events, improving user experience by providing immediate auditory feedback without requiring manual intervention.

## Configuration

### Audio Configuration
- **Completion Sound**: `/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Swish.m4r`
- **Stop Sound**: `/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Ding.m4r`
- **Implementation**: Direct afplay commands in Claude Code hooks

### Settings Configuration
Add to `/Users/damilola/.claude/settings.json`:
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit|Bash|TodoWrite",
        "hooks": [
          {
            "type": "command",
            "command": "afplay '/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Swish.m4r' 2>/dev/null &"
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
            "command": "afplay '/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Ding.m4r' 2>/dev/null &"
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
            "command": "afplay '/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Ding.m4r' 2>/dev/null &"
          }
        ]
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
afplay '/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Swish.m4r' 2>/dev/null &

# Test Stop hooks (Ding.m4r)
afplay '/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Ding.m4r' 2>/dev/null &
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
- ✅ Direct afplay commands handle missing audio files gracefully
- ✅ Audio playback is non-blocking