# /sync Command

## Description
Repository-specific command that synchronizes Claude configuration files from this repository to your user settings. This command copies the latest CLAUDE.md and command files to your home directory, ensuring your global Claude configuration stays up-to-date with the repository version.

## Usage
```
/sync
```

## Behavior
When you use `/sync`, I will:

1. **Validate agent YAML compliance**:
   - Run YAML validation on all agent files
   - Ensure all required fields are present
   - Check description length (<200 chars)
   - Verify color and specialization level values
   - Stop sync if validation fails

2. **Backup existing files** (if any):
   - Create backups of `~/CLAUDE.md` as `~/CLAUDE.md.backup`
   - Create backups of `~/.claude/commands/` as `~/.claude/commands.backup/`
   - Create backups of `~/.claude/agents/` as `~/.claude/agents.backup/`
   - Create backups of `~/.claude/settings.json` as `~/.claude/settings.json.backup`

3. **Replace configuration directories**:
   - Copy `./CLAUDE.md` to `~/CLAUDE.md`
   - **Remove old agents**: Delete `~/.claude/agents/` directory completely
   - **Remove old commands**: Delete all files in `~/.claude/commands/` (preserving the directory)
   - Copy all files from `./.claude/agents/` to `~/.claude/agents/`
   - Copy all files from `./.claude/commands/` to `~/.claude/commands/` (explicitly excluding `sync.md`)
   - Copy `./settings.json` to `~/.claude/settings.json` (merge with existing settings)
   - **Important**: This ensures no deprecated agents or commands remain. Use methods like:
     - `rm -rf ~/.claude/agents/ && cp -r ./.claude/agents/ ~/.claude/agents/`
     - `rm -f ~/.claude/commands/*.md && rsync -av --exclude='sync.md' ./.claude/commands/ ~/.claude/commands/`

4. **Verify the sync**:
   - Check that files were copied successfully
   - Report any errors or conflicts
   - Show summary of synced files
   - Confirm 26 agents are present (consolidated system)

## Files Synced
- `CLAUDE.md` - Main configuration with coding standards
- `.claude/commands/*.md` - All command files (except sync.md which is repo-specific)
- `.claude/agents/*.md` - All 26 specialized agent configurations (consolidated system)
- `.claude/agents/AGENT_CATEGORIES.md` - Agent category definitions and color mappings
- `settings.json` - Claude Code settings with audio notification hooks

## Important Notes
- **This command is specific to the claude-config repository**
- It will NOT be copied to your global commands during sync
- Always creates backups before overwriting existing files
- **Completely replaces agent and command directories** to remove deprecated files
- **Validates YAML compliance** before syncing to ensure agent quality
- Use this after pulling latest changes from the repository
- Run from within the claude-config repository only
- Old/deprecated agents and commands are removed to prevent confusion
- Ensures exactly 26 agents in the consolidated system

## Example Output
```
/sync
Validating agent YAML compliance...
✓ All 26 agents have valid YAML front-matter

Creating backups...
✓ Backed up ~/CLAUDE.md to ~/CLAUDE.md.backup
✓ Backed up ~/.claude/commands/ to ~/.claude/commands.backup/
✓ Backed up ~/.claude/agents/ to ~/.claude/agents.backup/
✓ Backed up ~/.claude/settings.json to ~/.claude/settings.json.backup

Syncing configuration files...
✓ Copied CLAUDE.md to ~/CLAUDE.md
✓ Removed old agents from ~/.claude/agents/
✓ Removed old commands from ~/.claude/commands/
✓ Copied 11 command files to ~/.claude/commands/ (excluding sync.md)
✓ Copied 26 agent files to ~/.claude/agents/ (consolidated system)
✓ Copied AGENT_CATEGORIES.md to ~/.claude/agents/
✓ Copied settings.json to ~/.claude/settings.json
✓ Explicitly excluded: sync.md (repo-specific command)

Sync completed successfully!
Audio notifications and specialized agents are now configured and ready to use.
```

## Implementation Details
When implementing the sync, ensure validation passes and old files are removed:
```bash
# First validate YAML compliance
python3 scripts/validate-agent-yaml.py || exit 1

# Remove old agents directory completely
rm -rf ~/.claude/agents/

# Copy new agents directory (includes AGENT_CATEGORIES.md)
cp -r ./.claude/agents/ ~/.claude/agents/

# Remove old command files (but preserve directory)
rm -f ~/.claude/commands/*.md

# Copy commands except sync.md
for file in ./.claude/commands/*.md; do
    filename=$(basename "$file")
    if [ "$filename" != "sync.md" ]; then
        cp "$file" ~/.claude/commands/
    fi
done

# Or use rsync with deletion and exclusion
rsync -av --delete --exclude='sync.md' ./.claude/commands/ ~/.claude/commands/
```

## Troubleshooting
- If sync fails, check file permissions
- If YAML validation fails, run `python3 scripts/fix-agent-descriptions.py`
- Ensure you're in the claude-config repository
- Backups are always created with timestamp if multiple syncs occur
- If audio notifications don't work after sync, check the settings.json hooks configuration
- Settings.json merge preserves existing configurations while adding new hooks
- Verify exactly 26 agents are present after sync (consolidated system)