# Audio Completion Notifications Hook

## Overview

This hook system provides automatic audio notifications for different Claude Code events,
improving user experience by providing immediate auditory feedback without requiring
manual intervention.

## Configuration

### Audio Configuration

- **Completion Sound** (PostToolUse):
`/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Swish.m4r`
- **Session Start Sound** (SessionStart):
`/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Presto.m4r`
- **Subagent Start Sound** (SubagentStart):
`/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Swish.m4r`
- **Subagent Stop Sound** (SubagentStop):
`/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Chord.m4r`
- **Pre-Compact Warning** (PreCompact):
`/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Aurora.m4r`
- **Stop Sound** (Stop):
`/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Chord.m4r`
- **Session End Sound** (SessionEnd):
`/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Choo Choo.m4r`
- **Notification Sound** (Notification):
`/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Aurora.m4r`
- **Permission Request Sound** (PermissionRequest):
`/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Keys.m4r`
- **Implementation**: Direct afplay commands in Claude Code hooks

### Quality Gate Hooks

In addition to audio hooks, `PreToolUse` hooks enforce quality policies:

- **--no-verify blocker**: Command-based hook that blocks `--no-verify` and `--no-gpg-sign` flags on Bash commands (exit code 2 = block)
- **Destructive git detector**: Prompt-based hook (haiku model) that analyzes Bash commands for destructive git operations (`reset --hard`, `push --force`, `clean -f`, `branch -D`)

### Settings Configuration

Add to `$HOME/.claude/settings.json`:

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
    ],
    "SessionEnd": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "afplay -v 1.0 '/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Choo Choo.m4r' 2>/dev/null &"
          },
          {
            "type": "command",
            "command": "${HOME}/.claude/exit_hook.sh"
          }
        ]
      }
    ],
    "PermissionRequest": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "afplay -v 1.0 '/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Keys.m4r' 2>/dev/null &"
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

### SessionStart Hooks (Presto.m4r)

- **SessionStart**: When a new Claude session begins
- Plays Modern Presto sound for startup confirmation

### SubagentStart Hooks (Swish.m4r)

- **SubagentStart**: When a subagent or teammate spawns
- Plays Classic Swish sound to indicate agent launch

### SubagentStop Hooks (Chord.m4r)

- **SubagentStop**: When a subagent or teammate finishes
- Plays Modern Chord sound for agent completion

### PreCompact Hooks (Aurora.m4r)

- **PreCompact**: When context is about to be compacted
- Plays Modern Aurora sound as a warning

### Stop Hooks (Chord.m4r)

- **Stop**: When Claude stops execution
- Plays Modern Chord sound for completion

### SessionEnd Hooks (Choo Choo.m4r)

- **SessionEnd**: When session ends
- Plays Classic Choo Choo sound for session end
- Also runs exit_hook.sh for cleanup

### Notification Hooks (Aurora.m4r)

- Triggers when prompt input has been idle for 60+ seconds
- Plays Modern Aurora sound for attention

### PermissionRequest Hooks (Keys.m4r)

- Triggers when Claude needs permission to use a tool
- Plays Modern Keys sound to alert user action is needed

## Universal Matching

- All tools trigger PostToolUse notifications (matcher: "*")
- No tools are excluded from audio feedback
- Provides consistent auditory feedback for all operations

## Troubleshooting

### No Audio Playing

1. Check if audio files exist:

   ```bash
   ls -la "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Swish.m4r"
   ls -la "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Chord.m4r"
   ls -la "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Choo Choo.m4r"
   ls -la "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Aurora.m4r"
   ls -la "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Keys.m4r"
   ```

2. Test audio manually:

   ```bash
   afplay -v 1.0 "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Swish.m4r"
   afplay -v 1.0 "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Chord.m4r"
   afplay -v 1.0 "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Choo Choo.m4r"
   afplay -v 1.0 "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Aurora.m4r"
   afplay -v 1.0 "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Keys.m4r"
   ```

3. Verify hook configuration in settings.json

### Too Many Notifications

The hooks use matcher patterns to filter which tools trigger notifications. If
you're still getting too many notifications, you can:

1. Modify the matcher patterns in settings.json to be more specific
2. Remove specific tools from the matcher (e.g., change
   "Write|Edit|MultiEdit|Bash|TodoWrite" to "Write|Edit|MultiEdit")

3. Add time-based filtering or other logic if needed

### Disabling Notifications

To temporarily disable:

1. Comment out the entire hooks section in settings.json
2. Or remove specific hooks (PostToolUse, Stop, Notification, SessionEnd, PermissionRequest)

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

# Test SessionEnd hooks (Choo Choo.m4r)
afplay -v 1.0 '/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Choo Choo.m4r' 2>/dev/null &

# Test Notification hooks (Aurora.m4r)
afplay -v 1.0 '/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Aurora.m4r' 2>/dev/null &

# Test PermissionRequest hooks (Keys.m4r)
afplay -v 1.0 '/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Keys.m4r' 2>/dev/null &
```

### Expected Behavior

- **Swish sound**: Plays after each tool operation (matcher: "*")
- **Chord sound**: Plays when Claude stops execution
- **Choo Choo sound**: Plays when session ends
- **Aurora sound**: Plays when prompt input has been idle
- **Keys sound**: Plays when Claude needs permission to use a tool
- All tools trigger audio feedback (universal matcher)
- Audio playback runs in background (non-blocking)
- Graceful failure if audio system is unavailable

### Test Results Verification

- PostToolUse hooks trigger Swish.m4r audio notifications (matcher: "*")
- Stop hooks trigger Chord.m4r audio notifications
- SessionEnd hooks trigger Choo Choo.m4r audio notifications
- Notification hooks trigger Aurora.m4r for idle events
- PermissionRequest hooks trigger Keys.m4r when permission is needed
- Direct afplay commands handle missing audio files gracefully
