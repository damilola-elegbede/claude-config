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

2. **Copy configuration files**:
   - Copy `./CLAUDE.md` to `~/CLAUDE.md`
   - Copy all files from `./.claude/commands/` to `~/.claude/commands/`
   - Exclude the `/sync` command itself (repo-specific only)

3. **Verify the sync**:
   - Check that files were copied successfully
   - Report any errors or conflicts
   - Show summary of synced files

## Files Synced
- `CLAUDE.md` - Main configuration with coding standards
- `.claude/commands/plan.md` - Planning workflow command
- `.claude/commands/commit.md` - Git commit command
- `.claude/commands/push.md` - Git push command
- `.claude/commands/test.md` - Universal test runner
- `.claude/commands/context.md` - Repository analyzer

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

Syncing configuration files...
✓ Copied CLAUDE.md to ~/CLAUDE.md
✓ Copied 5 command files to ~/.claude/commands/
✓ Excluded sync.md (repo-specific)

Sync completed successfully!
```

## Troubleshooting
- If sync fails, check file permissions
- Ensure you're in the claude-config repository
- Backups are always created with timestamp if multiple syncs occur