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
```

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
```

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

MCP Servers Synced:
  - From: .mcp.json
  - To: Claude Desktop config (~/Library/Application Support/Claude/claude_desktop_config.json)
  - Method: JSON merge with backup

Excluded:
  - README.md files
  - AGENT_TEMPLATE.md
  - AGENT_CATEGORIES.md
  - AUDIT_VERIFICATION_PROTOCOL.md
  - *.tmp, *.backup files
```

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
```

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
```

### Phase 3: MCP Server Sync

```bash
# Claude Desktop config path
CLAUDE_CONFIG_PATH="$HOME/Library/Application Support/Claude/claude_desktop_config.json"

# Sync MCP servers to Claude Desktop
if [[ -f ".mcp.json" ]]; then
  echo "🔄 Syncing MCP servers to Claude Desktop..."

  # Create backup of existing config
  if [[ -f "$CLAUDE_CONFIG_PATH" ]]; then
    timestamp=$(date +%Y%m%d_%H%M%S)
    backup_path="${CLAUDE_CONFIG_PATH}.backup.$timestamp"
    cp "$CLAUDE_CONFIG_PATH" "$backup_path"
    echo "💾 Backup created: $backup_path"
  fi

  # Create Claude config directory if it doesn't exist
  mkdir -p "$(dirname "$CLAUDE_CONFIG_PATH")"

  # Read current config or create empty structure
  if [[ -f "$CLAUDE_CONFIG_PATH" ]]; then
    current_config=$(cat "$CLAUDE_CONFIG_PATH")
  else
    current_config='{"mcpServers": {}}'
  fi

  # Validate current config JSON
  if ! echo "$current_config" | jq empty 2>/dev/null; then
    echo "⚠️  Invalid JSON in existing config, creating fresh config"
    current_config='{"mcpServers": {}}'
  fi

  # Read .mcp.json servers
  mcp_servers=$(jq '.mcpServers' .mcp.json)

  # Merge MCP servers into current config, preserving other settings
  merged_config=$(echo "$current_config" | jq --argjson servers "$mcp_servers" '
    .mcpServers = $servers
  ')

  # Validate merged config
  if echo "$merged_config" | jq empty 2>/dev/null; then
    # Write updated config
    echo "$merged_config" > "$CLAUDE_CONFIG_PATH"
    echo "✅ Claude Desktop MCP configuration updated"

    # Show what was configured
    echo "📡 MCP Servers configured:"
    echo "$merged_config" | jq -r '.mcpServers | keys[]' | while read server; do
      echo "  ✓ $server"
    done
  else
    echo "❌ Failed to merge MCP configuration - JSON validation failed"
    # Restore backup if it exists
    if [[ -f "$backup_path" ]]; then
      cp "$backup_path" "$CLAUDE_CONFIG_PATH"
      echo "🔄 Restored from backup"
    fi
    return 1
  fi
else
  echo "⚠️  No .mcp.json found - skipping MCP server sync"
fi
```

### Phase 4: Validation

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

# Verify Claude Desktop MCP config
if [[ -f "$CLAUDE_CONFIG_PATH" ]]; then
  if jq empty "$CLAUDE_CONFIG_PATH" 2>/dev/null; then
    echo "✅ Claude Desktop config is valid JSON"
    mcp_count=$(jq '.mcpServers | length' "$CLAUDE_CONFIG_PATH")
    echo "📡 MCP servers configured: $mcp_count"
  else
    echo "❌ Claude Desktop config has invalid JSON"
    return 1
  fi
else
  echo "⚠️  Claude Desktop config not found"
fi
```

## Examples

### Basic Sync

```text
User: /sync
Claude: 🔄 Syncing Claude configurations...
📁 Source: system-configs/.claude/ (50 files)
📁 Destination: ~/.claude/
✅ Agents synced (28 files)
✅ Commands synced (15 files)
✅ Output styles synced (8 files)
✅ Settings and statusline synced

🔄 Syncing MCP servers to Claude Desktop...
💾 Backup created: ~/Library/Application Support/Claude/claude_desktop_config.json.backup.20240818_164500
✅ Claude Desktop MCP configuration updated

📡 MCP Servers configured:
  ✓ filesystem
  ✓ github
  ✓ shadcn-ui
  ✓ context7
  ✓ elevenlabs
  ✓ notionApi

🎯 All configurations and MCP servers deployed successfully
```

### Dry Run

```text
User: /sync --dry-run
Claude: 📖 Preview mode - no changes will be made
Would sync:
- 28 agent files to ~/.claude/agents/
- 18 command files to ~/.claude/commands/
- 8 output style files to ~/.claude/output-styles/
- settings.json to ~/.claude/settings.json
- statusline.sh to ~/.claude/statusline.sh (executable)
```

### Backup and Sync

```text
User: /sync --backup
Claude: 💾 Creating backup: ~/.claude.backup.20240818_164500
🔄 Syncing configurations...
✅ Backup created and sync completed
```

## Execution Verification

Deploy execution-evaluator to verify:

- ✅ **Source validated** - system-configs/.claude/ directory exists and accessible
- ✅ **Destination prepared** - ~/.claude/ directory structure created successfully
- ✅ **Files synchronized** - All configuration files copied with correct permissions
- ✅ **Agents deployed** - All agent definitions properly synchronized
- ✅ **Commands available** - All custom commands deployed and accessible
- ✅ **Settings applied** - settings.json and statusline.sh configured correctly
- ✅ **MCP servers synced** - All servers from .mcp.json merged into Claude Desktop config
- ✅ **MCP config validated** - Claude Desktop configuration JSON syntax verified
- ✅ **Validation passed** - JSON syntax and file integrity verified
- ✅ **Backup created** - Previous configuration safely backed up (if requested)

## Notes

- Uses rsync for efficient file synchronization
- Automatically sets executable permissions on statusline.sh
- Validates JSON files after sync
- Excludes documentation and template files
- Built-in backup functionality for safety
- No external configuration files needed
