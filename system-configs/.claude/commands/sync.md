# /sync Command

## Description

Synchronizes Claude configuration files from `system-configs/.claude/` to `~/.claude/`.
Deploys agents, commands, output-styles, and settings with validation and backup creation.

## Usage

```bash
/sync                    # Sync system-configs/.claude/ to ~/.claude/
/sync --dry-run          # Preview changes without syncing
/sync --backup           # Create backup before syncing
/sync --force            # Overwrite existing files without prompting
```bash

## Behavior
## Agent Orchestration

### Parallel Validation Phase

Deploy specialized agents for configuration validation:

```yaml
code-reviewer:
  role: Validate configuration syntax and structure
  input: All config files to be synced
  output: Validation results, syntax errors

security-auditor:
  role: Security review of configurations
  input: Settings.json, agent definitions, commands
  output: Security assessment, sensitive data warnings

platform-engineer:
  role: Environment compatibility check
  input: Target environment, config requirements
  output: Compatibility report, setup requirements
```bash

### Parallel Execution Benefits

```yaml
Validation Strategy:
  - All agents validate simultaneously
  - Security-auditor has veto power
  - Total time: 2-3 seconds (vs 8-10 sequential)
```

When invoked, I will synchronize all Claude configuration files from
`system-configs/.claude/` to `~/.claude/`. This includes agents, commands,
output-styles, settings.json, and statusline.sh with automatic validation.

## What Gets Synced

```yaml
Source: ./system-configs/.claude/
Destination: ~/.claude/

Files Synced:
  - agents/*.md           → ~/.claude/agents/
  - commands/*.md         → ~/.claude/commands/
  - output-styles/*.md    → ~/.claude/output-styles/
  - settings.json         → ~/.claude/settings.json
  - statusline.sh         → ~/.claude/statusline.sh

Excluded:
  - README.md files
  - AGENT_TEMPLATE.md
  - AGENT_CATEGORIES.md
  - AUDIT_VERIFICATION_PROTOCOL.md
  - *.tmp, *.backup files
```bash

## Sync Process

### Phase 1: Pre-Sync Validation

```bash
# Validate source directory exists
if [[ ! -d "system-configs/.claude" ]]; then
  echo "❌ Source directory not found: system-configs/.claude"
  exit 1
fi

# Create destination directory if needed
mkdir -p ~/.claude/{agents,commands,output-styles}

# Backup existing files if --backup specified
if [[ "$backup" == "true" ]]; then
  timestamp=$(date +%Y%m%d_%H%M%S)
  cp -r ~/.claude ~/.claude.backup.$timestamp
fi
```bash

### Phase 2: Sync Files

```bash
# Sync with rsync for efficiency
rsync -av \
  --exclude="README.md" \
  --exclude="AGENT_TEMPLATE.md" \
  --exclude="AGENT_CATEGORIES.md" \
  --exclude="AUDIT_VERIFICATION_PROTOCOL.md" \
  --exclude="*.tmp" \
  --exclude="*.backup" \
  system-configs/.claude/ ~/.claude/

# Set executable permissions for statusline.sh
chmod +x ~/.claude/statusline.sh 2>/dev/null || true
```bash

### Phase 3: Validation

```bash
# Validate JSON files
if ! jq empty ~/.claude/settings.json 2>/dev/null; then
  echo "❌ Invalid JSON in settings.json"
  return 1
fi

# Verify critical files exist
for file in agents commands output-styles settings.json statusline.sh; do
  if [[ ! -e ~/.claude/$file ]]; then
    echo "⚠️  Missing: ~/.claude/$file"
  fi
done
```bash

## Examples

### Basic Sync

```bash
User: /sync
Claude: 🔄 Syncing Claude configurations...
📁 Source: system-configs/.claude/ (50 files)
📁 Destination: ~/.claude/
✅ Agents synced (41 files)
✅ Commands synced (15 files)
✅ Output styles synced (8 files)
✅ Settings and statusline synced
🎯 All configurations deployed successfully
```bash

### Dry Run

```bash
User: /sync --dry-run
Claude: 📖 Preview mode - no changes will be made
Would sync:
- 41 agent files to ~/.claude/agents/
- 18 command files to ~/.claude/commands/
- 8 output style files to ~/.claude/output-styles/
- settings.json to ~/.claude/settings.json
- statusline.sh to ~/.claude/statusline.sh (executable)
```bash

### Backup and Sync

```bash
User: /sync --backup
Claude: 💾 Creating backup: ~/.claude.backup.20240818_164500
🔄 Syncing configurations...
✅ Backup created and sync completed
```bash

## Execution Verification

Deploy execution-evaluator to verify:

- ✅ **Source validated** - system-configs/.claude/ directory exists and accessible
- ✅ **Destination prepared** - ~/.claude/ directory structure created successfully
- ✅ **Files synchronized** - All configuration files copied with correct permissions
- ✅ **Agents deployed** - All agent definitions properly synchronized
- ✅ **Commands available** - All custom commands deployed and accessible
- ✅ **Settings applied** - settings.json and statusline.sh configured correctly
- ✅ **Validation passed** - JSON syntax and file integrity verified
- ✅ **Backup created** - Previous configuration safely backed up (if requested)

## Notes

- Uses rsync for efficient file synchronization
- Automatically sets executable permissions on statusline.sh
- Validates JSON files after sync
- Excludes documentation and template files
- Built-in backup functionality for safety
- No external configuration files needed
