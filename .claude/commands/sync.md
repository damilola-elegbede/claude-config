---
description: Sync Claude configs with validation and backup
argument-hint: [--dry-run|--backup]
---

# /sync Command

## Usage

```bash
/sync                           # Sync system-configs/.claude/ to ~/.claude/
/sync --dry-run                 # Preview changes without syncing
/sync --backup                  # Create backup before syncing (default behavior)
```

## Description

Synchronize all Claude configuration files from `system-configs/.claude/` to `~/.claude/` using direct execution
with basic validation. The command performs file copying with backup creation and simple validation checks, without
deploying multiple agents for a straightforward rsync operation.

## Expected Output

### Standard Sync Output

```text
🔄 Syncing Claude configurations...
📁 Source: system-configs/.claude/ (61 files)
📁 Target: ~/.claude/

✅ Pre-sync validation:
  - Configuration syntax: Valid (28 agents, 22 commands, 5 skills)
  - Target directory: Ready
  - Permissions: OK

💾 Creating backup: ~/.claude.backup.20250909_143022

🔄 Synchronizing files:
  ✅ Agents: 28 files → ~/.claude/agents/
  ✅ Commands: 22 files → ~/.claude/commands/
  ✅ Skills: 5 skills → ~/.claude/skills/
  ✅ Output styles: 8 files → ~/.claude/output-styles/
  ✅ Settings: settings.json, statusline.sh, exit_hook.sh
  ✅ CLAUDE.md → ~/CLAUDE.md

✅ Post-sync validation:
  - File integrity: All files copied successfully
  - Agent configs: 28/28 valid
  - Commands: 22/22 functional
  - Skills: 5/5 valid

📊 Sync completed successfully:
  Files synced: 61 total
  Backup location: ~/.claude.backup.20250909_143022
  Sync time: 2.3 seconds
```

### Dry Run Output

```text
📖 Preview mode - no changes will be made

🔍 Analyzing configurations:
  Source: system-configs/.claude/ (61 files)
  Target: ~/.claude/

📋 Files to sync:
  - 28 agent files → ~/.claude/agents/
  - 22 command files → ~/.claude/commands/
  - 5 skills → ~/.claude/skills/
  - 8 output style files → ~/.claude/output-styles/
  - settings.json → ~/.claude/settings.json
  - statusline.sh → ~/.claude/statusline.sh
  - exit_hook.sh → ~/.claude/exit_hook.sh
  - CLAUDE.md → ~/CLAUDE.md

📊 Preview summary:
  Total files: 61 configurations ready
  Backup would be created before sync
  Estimated time: 2-3 seconds
```

### Validation Error Output

```text
❌ Pre-sync validation failed:

🔍 Issues found:
  - Agent syntax error: mobile-engineer.md (line 15: invalid YAML)
  - Permission denied: ~/.claude/ directory not writable

🛠️ Fix these issues before syncing:
  1. Repair YAML syntax in mobile-engineer.md
  2. Check ~/.claude directory permissions

Run /sync again after addressing these issues.
```

## Behavior

### What Gets Synced

```yaml
Source: ./system-configs/.claude/
Destination: ~/.claude/

Files Synced:
  - agents/*.md           → ~/.claude/agents/
  - commands/*.md         → ~/.claude/commands/
  - skills/*/             → ~/.claude/skills/*/ (entire skill directories)
    - Includes: SKILL.md, references/, scripts/, assets/, etc.
  - output-styles/*.md    → ~/.claude/output-styles/
  - settings.json         → ~/.claude/settings.json
  - statusline.sh         → ~/.claude/statusline.sh
  - exit_hook.sh          → ~/.claude/exit_hook.sh (optional, validated with sh -n)

Also Synced (from system-configs/):
  - CLAUDE.md             → ~/CLAUDE.md (main Claude configuration)

Excluded:
  - README.md files
  - AGENT_TEMPLATE.md
  - AGENT_CATEGORIES.md
  - SKILL_TEMPLATE.md (in docs/skills/)
  - AUDIT_VERIFICATION_PROTOCOL.md
  - *.tmp, *.backup files

Skills Directory Structure (Anthropic Format):
  Each skill is a directory containing:
  - SKILL.md (required) - Main skill instructions
  - references/ (optional) - API docs, workflow guides
  - scripts/ (optional) - Executable scripts
  - assets/ (optional) - Supporting files
  - examples/ (optional) - Example outputs

  Example:
    skills/code-review/
    ├── SKILL.md
    ├── SECURITY.md
    ├── PERFORMANCE.md
    └── scripts/
        └── run-linters.sh
```

### Validation Strategy

```yaml
Pre-sync Validation:
  - Basic syntax check for YAML front-matter
  - JSON validation for settings.json
  - POSIX shell syntax check for shell scripts (statusline.sh, exit_hook.sh)
  - Directory permissions and access

Post-sync Validation:
  - File integrity verification
  - Basic configuration syntax check
  - Permissions verification
```

## Implementation

The `/sync` command executes the standalone `scripts/sync.sh` script, which handles all synchronization logic.

```bash
#!/bin/sh
# Execute the sync script from the repository
./scripts/sync.sh "$@"
```

## Performance Metrics

### Execution Time

- **Direct execution**: 2-4 seconds
- **File validation**: <1 second
- **Backup creation**: <1 second
- **File synchronization**: 1-2 seconds

### Benefits of Direct Execution

- **Simplified process**: No complex agent orchestration for file copying
- **Faster execution**: Direct operations without agent startup overhead
- **Clear output**: Simple progress indication
- **Automatic backup**: Creates backup before changes for manual recovery if needed
- **Resource efficient**: Minimal system resource usage

## Prerequisites

- Source directory `system-configs/.claude/` must exist and contain valid configurations
- Target directory permissions must allow read/write access
- `rsync` must be available for efficient file synchronization

## Notes

- **Direct execution**: Performs file operations directly without agent deployment
- **Automatic backup**: Creates backup before any changes (restore manually if needed)
- **Basic validation**: Essential checks without complex multi-agent validation
- **Clear logging**: Direct progress indication and error reporting
- **Integration friendly**: Compatible with existing workflows and CI/CD pipelines
- **Performance optimized**: Fast execution through direct file operations

The /sync command provides reliable configuration deployment through direct execution, focusing on the essential
task of copying files efficiently with basic validation and backup capabilities.
