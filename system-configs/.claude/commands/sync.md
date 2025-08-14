# /sync Command

## Description

Repository-specific command that synchronizes Claude configuration files from this repository to your user settings. This command copies the latest CLAUDE.md and command files to your home directory, ensuring your global Claude configuration stays up-to-date with the repository version.

## Usage

```bash
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
   - Copy `./system-configs/CLAUDE.md` to `~/CLAUDE.md`
   - **Remove old agents**: Delete `~/.claude/agents/` directory completely
   - **Remove old commands**: Delete all files in `~/.claude/commands/` (preserving the directory)
   - Copy only actual agent files from `./system-configs/.claude/agents/` to `~/.claude/agents/` (excluding documentation/template files)
   - Copy all files from `./system-configs/.claude/commands/` to `~/.claude/commands/` (explicitly excluding `sync.md` and `config-diff.md`)
   - Copy `./system-configs/settings.json` to `~/.claude/settings.json` (merge with existing settings)
   - **Important**: This ensures no deprecated agents or commands remain, and only actual agents are synced
   - **Excluded from agents sync**:
     - `AGENT_TEMPLATE.md` (template file, not an agent)
     - `AGENT_CATEGORIES.md` (documentation file)
     - `AUDIT_VERIFICATION_PROTOCOL.md` (documentation file)
     - `README.md` (documentation file)
     - Any other non-agent documentation files

4. **Verify the sync**:
   - Check that files were copied successfully
   - Report any errors or conflicts
   - Show summary of synced files
   - Confirm actual agent files are present (excluding documentation)
   - Deploy execution-evaluator to validate sync success

## Files Synced

- `system-configs/CLAUDE.md` - Main configuration with coding standards
- `system-configs/.claude/commands/*.md` - All command files (except repo-specific commands below)
- `system-configs/.claude/agents/*.md` - Only actual agent configurations (excludes documentation/template files)
- `system-configs/settings.json` - Claude Code settings with audio notification hooks

## Files NOT Synced

- `system-configs/.claude/agents/AGENT_TEMPLATE.md` - Template file for creating new agents
- `system-configs/.claude/agents/AGENT_CATEGORIES.md` - Documentation of agent categories
- `system-configs/.claude/agents/AUDIT_VERIFICATION_PROTOCOL.md` - Audit documentation
- `system-configs/.claude/agents/README.md` - Agent directory documentation
- `system-configs/.claude/commands/sync.md` - Repository-specific sync command
- `system-configs/.claude/commands/config-diff.md` - Repository-specific config comparison command

## Important Notes

- **This command is specific to the claude-config repository**
- It will NOT be copied to your global commands during sync
- Always creates backups before overwriting existing files
- **Completely replaces agent and command directories** to remove deprecated files
- **Validates YAML compliance** before syncing to ensure agent quality
- Use this after pulling latest changes from the repository
- Run from within the claude-config repository only
- Old/deprecated agents and commands are removed to prevent confusion
- Ensures only actual agent files are synced (excludes documentation)

## Example Output

```text
/sync
Validating agent YAML compliance...
✓ All 35 agents have valid YAML front-matter

Creating backups...
✓ Backed up ~/CLAUDE.md to ~/CLAUDE.md.backup
✓ Backed up ~/.claude/commands/ to ~/.claude/commands.backup/
✓ Backed up ~/.claude/agents/ to ~/.claude/agents.backup/
✓ Backed up ~/.claude/settings.json to ~/.claude/settings.json.backup

Syncing configuration files...
✓ Copied system-configs/CLAUDE.md to ~/CLAUDE.md
✓ Removed old agents from ~/.claude/agents/
✓ Removed old commands from ~/.claude/commands/
✓ Copied 35 command files to ~/.claude/commands/ (excluding sync.md and config-diff.md)
✓ Copied 35 agent files to ~/.claude/agents/
✓ Copied system-configs/settings.json to ~/.claude/settings.json
✓ Excluded documentation files: AGENT_TEMPLATE.md, AGENT_CATEGORIES.md, AUDIT_VERIFICATION_PROTOCOL.md, README.md
✓ Excluded repo-specific: sync.md, config-diff.md

Sync completed successfully!
Audio notifications and specialized agents are now configured and ready to use.
```

## Implementation Details

When implementing the sync, ensure validation passes and only actual agent files are copied:

```bash
# First validate YAML compliance
python3 scripts/validate-agent-yaml.py || exit 1

# Remove old agents directory completely
rm -rf ~/.claude/agents/

# Create fresh agents directory
mkdir -p ~/.claude/agents/

# Copy only actual agent files (exclude documentation/template files)
for file in ./system-configs/.claude/agents/*.md; do
    filename=$(basename "$file")
    # Skip non-agent files
    if [[ "$filename" != "AGENT_TEMPLATE.md" && \
          "$filename" != "AGENT_CATEGORIES.md" && \
          "$filename" != "AUDIT_VERIFICATION_PROTOCOL.md" && \
          "$filename" != "README.md" ]]; then
        cp "$file" ~/.claude/agents/
    fi
done

# Remove old command files (but preserve directory)
rm -f ~/.claude/commands/*.md

# Copy commands except sync.md and config-diff.md
shopt -s nullglob
for file in ./system-configs/.claude/commands/*.md; do
    filename=$(basename "$file")
    if [[ -f "$file" ]] && [[ "$filename" != "sync.md" && "$filename" != "config-diff.md" ]]; then
        cp "$file" ~/.claude/commands/
    fi
done
```

## Troubleshooting

- If sync fails, check file permissions
- If YAML validation fails, run `python3 scripts/fix-agent-descriptions.py`
- Ensure you're in the claude-config repository
- Backups are always created with timestamp if multiple syncs occur
- If audio notifications don't work after sync, check the settings.json hooks configuration
- Settings.json merge preserves existing configurations while adding new hooks
