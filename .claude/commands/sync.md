# /sync Command

## Description
Repository-specific command that synchronizes Claude configuration files from this repository to your user settings. This command copies the latest CLAUDE.md and command files to your home directory, ensuring your global Claude configuration stays up-to-date with the repository version.

## Usage
```
/sync
```

## Behavior
When you use `/sync`, I will:

1. **Backup existing files** (if any):
   - Create backups of `~/CLAUDE.md` as `~/CLAUDE.md.backup`
   - Create backups of `~/.claude/commands/` as `~/.claude/commands.backup/`
   - Create backups of `~/.claude/agents/` as `~/.claude/agents.backup/`
   - Create backups of `~/.claude/settings.json` as `~/.claude/settings.json.backup`
   - Create backups of `~/.claude/AUDIO_HOOK_README.md` as `~/.claude/AUDIO_HOOK_README.md.backup`

2. **Copy configuration files**:
   - Copy `./CLAUDE.md` to `~/CLAUDE.md`
   - Copy all files from `./.claude/commands/` to `~/.claude/commands/` (explicitly excluding `sync.md`)
   - Copy all files from `./.claude/agents/` to `~/.claude/agents/`
   - Copy `./settings.json` to `~/.claude/settings.json` (merge with existing settings)
   - Copy `./AUDIO_HOOK_README.md` to `~/.claude/AUDIO_HOOK_README.md`
   - **Important**: When copying commands, use pattern like `cp ./.claude/commands/[!s]*.md ~/.claude/commands/` or explicitly exclude sync.md

3. **Verify the sync**:
   - Check that files were copied successfully
   - Report any errors or conflicts
   - Show summary of synced files

## Files Synced
- `CLAUDE.md` - Main configuration with coding standards
- `.claude/commands/*.md` - All command files (except sync.md which is repo-specific)
- `.claude/agents/*.md` - All specialized agent configurations
- `settings.json` - Claude Code settings with audio notification hooks
- `AUDIO_HOOK_README.md` - Audio notification setup and troubleshooting guide

## Important Notes
- **This command is specific to the claude-config repository**
- It will NOT be copied to your global commands during sync
- Always creates backups before overwriting existing files
- Use this after pulling latest changes from the repository
- Run from within the claude-config repository only

## Example Output
```
/sync
Creating backups...
✓ Backed up ~/CLAUDE.md to ~/CLAUDE.md.backup
✓ Backed up ~/.claude/commands/ to ~/.claude/commands.backup/
✓ Backed up ~/.claude/agents/ to ~/.claude/agents.backup/
✓ Backed up ~/.claude/settings.json to ~/.claude/settings.json.backup
✓ Backed up ~/.claude/AUDIO_HOOK_README.md to ~/.claude/AUDIO_HOOK_README.md.backup

Syncing configuration files...
✓ Copied CLAUDE.md to ~/CLAUDE.md
✓ Copied 11 command files to ~/.claude/commands/ (excluding sync.md)
✓ Copied 19 agent files to ~/.claude/agents/
✓ Copied settings.json to ~/.claude/settings.json
✓ Copied AUDIO_HOOK_README.md to ~/.claude/AUDIO_HOOK_README.md
✓ Explicitly excluded: sync.md (repo-specific command)

Sync completed successfully!
Audio notifications and specialized agents are now configured and ready to use.
```

## Implementation Details
When implementing the sync, ensure sync.md is explicitly excluded:
```bash
# Copy commands except sync.md
for file in ./.claude/commands/*.md; do
    filename=$(basename "$file")
    if [ "$filename" != "sync.md" ]; then
        cp "$file" ~/.claude/commands/
    fi
done

# Or use find with exclusion
find ./.claude/commands -name "*.md" ! -name "sync.md" -exec cp {} ~/.claude/commands/ \;
```

## Troubleshooting
- If sync fails, check file permissions
- Ensure you're in the claude-config repository
- Backups are always created with timestamp if multiple syncs occur
- If audio notifications don't work after sync, see `AUDIO_HOOK_README.md` for troubleshooting
- Settings.json merge preserves existing configurations while adding new hooks