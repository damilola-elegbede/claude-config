# Audio Notifications Setup Guide

## Quick Setup

To enable audio notifications for Claude Code, follow these steps:

### 1. Copy Hook Script
Copy the hook script to your Claude configuration directory:
```bash
cp audio_notification_hook.sh ~/.claude/audio_notification_hook.sh
chmod +x ~/.claude/audio_notification_hook.sh
```

### 2. Update Settings
Merge the hook configuration from `settings.json` into your `~/.claude/settings.json` file:

```json
{
  "model": "sonnet",
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "/Users/damilola/.claude/audio_notification_hook.sh PostToolUse Write true"
          }
        ]
      },
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "/Users/damilola/.claude/audio_notification_hook.sh PostToolUse Edit true"
          }
        ]
      },
      {
        "matcher": "MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "/Users/damilola/.claude/audio_notification_hook.sh PostToolUse MultiEdit true"
          }
        ]
      },
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "/Users/damilola/.claude/audio_notification_hook.sh PostToolUse Bash true"
          }
        ]
      },
      {
        "matcher": "TodoWrite",
        "hooks": [
          {
            "type": "command",
            "command": "/Users/damilola/.claude/audio_notification_hook.sh PostToolUse TodoWrite true"
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
            "command": "/Users/damilola/.claude/audio_notification_hook.sh Stop"
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
            "command": "/Users/damilola/.claude/audio_notification_hook.sh SubagentStop"
          }
        ]
      }
    ]
  }
}
```

### 3. Test Setup
Test the audio notifications:
```bash
# Test completion sound (Swish.m4r)
~/.claude/audio_notification_hook.sh PostToolUse Write true

# Test stop sound (Ding.m4r)
~/.claude/audio_notification_hook.sh Stop
```

## What You Get

### Audio Feedback
- **Swish.m4r**: Plays when Claude completes significant operations (Write, Edit, MultiEdit, Bash, TodoWrite)
- **Ding.m4r**: Plays when Claude stops or subagents stop

### Smart Filtering
- Only significant operations trigger audio notifications
- Read operations, searches, and informational queries are excluded
- Prevents notification fatigue

### Reliable Operation
- Background audio playback (non-blocking)
- Graceful failure if audio system is unavailable
- Works across all Claude Code sessions

## Troubleshooting

See `AUDIO_HOOK_README.md` for detailed troubleshooting information.

## Customization

You can customize the audio notifications by:
1. Modifying the hook script to use different sounds
2. Adjusting the `is_significant_completion()` function for different filtering
3. Adding or removing tool matchers in settings.json

## Requirements

- macOS (uses system alert tones)
- Claude Code with hooks support
- Audio system enabled