---
description: Sync Claude configs with validation and rollback
argument-hint: [--dry-run|--backup|--force]
---

# /sync Command

## Usage

```bash
/sync                           # Sync system-configs/.claude/ to ~/.claude/
/sync --dry-run                 # Preview changes without syncing
/sync --backup                  # Create backup before syncing
/sync --force                   # Overwrite existing files without prompting
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
  ✅ Skills: 5 files → ~/.claude/skills/
  ✅ Output styles: 8 files → ~/.claude/output-styles/
  ✅ Settings: settings.json, statusline.sh

📡 MCP Server Configuration:
  💾 Backup: ~/Library/Application Support/Claude/claude_desktop_config.json.backup
  ✅ Updated Claude Desktop config with MCP servers:
    - filesystem
    - github
    - shadcn-ui
    - context7
    - elevenlabs
    - notionApi

✅ Post-sync validation:
  - File integrity: All files copied successfully
  - Agent configs: 28/28 valid
  - Commands: 22/22 functional
  - Skills: 5/5 valid
  - MCP integration: 6/6 connected

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
  - 5 skill files → ~/.claude/skills/
  - 8 output style files → ~/.claude/output-styles/
  - settings.json → ~/.claude/settings.json
  - statusline.sh → ~/.claude/statusline.sh

📡 MCP servers to configure:
  - filesystem, github, shadcn-ui
  - context7, elevenlabs, notionApi

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
  - MCP config invalid: .mcp.json contains malformed JSON

🛠️ Fix these issues before syncing:
  1. Repair YAML syntax in mobile-engineer.md
  2. Check ~/.claude directory permissions
  3. Validate .mcp.json syntax

Run /sync again after addressing these issues.
```

### Rollback Scenario Output

```text
⚠️ Sync issue detected during MCP deployment...

❌ Error: Claude Desktop config update failed
  - Invalid MCP server configuration
  - Backup restore initiated

🔄 Rolling back changes:
  ✅ Files restored from: ~/.claude.backup.20250909_143022
  ✅ MCP config reverted to previous state
  ✅ Permissions reset

🎯 Sync aborted - configurations restored

🔧 Action required:
  1. Check MCP server definitions in .mcp.json
  2. Verify Claude Desktop config permissions

Run /sync again after fixing the configuration.
```

## Behavior

### What Gets Synced

```yaml
Source: ./system-configs/.claude/
Destination: ~/.claude/

Files Synced:
  - agents/*.md           → ~/.claude/agents/
  - commands/*.md         → ~/.claude/commands/
  - skills/*.md           → ~/.claude/skills/
  - output-styles/*.md    → ~/.claude/output-styles/
  - settings.json         → ~/.claude/settings.json
  - statusline.sh         → ~/.claude/statusline.sh

MCP Servers Synced:
  - From: .mcp.json
  - To: Claude Desktop config (~/Library/Application Support/Claude/claude_desktop_config.json)
  - Method: JSON merge with backup

Excluded:
  - README.md files
  - AGENT_TEMPLATE.md
  - AGENT_CATEGORIES.md
  - SKILL_TEMPLATE.md (in docs/skills/)
  - AUDIT_VERIFICATION_PROTOCOL.md
  - *.tmp, *.backup files
```

### Validation Strategy

```yaml
Pre-sync Validation:
  - Basic syntax check for YAML front-matter
  - JSON validation for settings.json
  - Directory permissions and access
  - MCP configuration syntax

Post-sync Validation:
  - File integrity verification
  - Basic configuration syntax check
  - MCP server connectivity test
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
- **MCP deployment**: <1 second

### Benefits of Direct Execution

- **Simplified process**: No complex agent orchestration for file copying
- **Faster execution**: Direct operations without agent startup overhead
- **Clear output**: Simple progress indication without wave complexity
- **Reliable rollback**: Straightforward backup and restore process
- **Resource efficient**: Minimal system resource usage

## Prerequisites

- Source directory `system-configs/.claude/` must exist and contain valid configurations
- Target directory permissions must allow read/write access
- `jq` command-line JSON processor recommended for MCP operations
- `rsync` must be available for efficient file synchronization

## Notes

- **Direct execution**: Performs file operations directly without agent deployment
- **Automatic backup**: Creates backup before any changes for rollback capability
- **Basic validation**: Essential checks without complex multi-agent validation
- **Simple rollback**: Straightforward restore from backup on failure
- **Clear logging**: Direct progress indication and error reporting
- **Integration friendly**: Compatible with existing workflows and CI/CD pipelines
- **Performance optimized**: Fast execution through direct file operations

The /sync command provides reliable configuration deployment through direct execution, focusing on the essential
task of copying files efficiently with basic validation and rollback capabilities.
