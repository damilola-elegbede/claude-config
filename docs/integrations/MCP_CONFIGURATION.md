# MCP (Model Context Protocol) Configuration

## Overview

MCP servers provide Claude with access to external tools and services through a standardized
protocol. The configuration has been separated from the main `settings.json` to provide better
organization and maintainability.

## Configuration Location

**File**: `~/.mcp.json` (in your home directory)

**Source**: Repository root `/.mcp.json`

## Configuration Structure

```json
{
  "mcpServers": {
    "server-name": {
      "command": "npx",
      "args": ["-y", "package-name"],
      "env": {
        "API_KEY": "${API_KEY}"
      }
    }
  }
}
```

## Available MCP Servers

### 1. Filesystem

- **Purpose**: File system operations
- **Package**: `@modelcontextprotocol/server-filesystem`
- **Access**: Documents directory by default

### 2. GitHub

- **Purpose**: GitHub repository operations
- **Package**: `@modelcontextprotocol/server-github`
- **Environment**: Requires `GITHUB_TOKEN`

### 3. ShadCN UI

- **Purpose**: UI component library access
- **Package**: `shadcn-ui-mcp-server`
- **Usage**: UI/UX development

### 4. Context7

- **Purpose**: Documentation and API lookups
- **Package**: `@upstash/context7-mcp`
- **Environment**: Requires `CONTEXT7_API_KEY`

### 5. ElevenLabs

- **Purpose**: Text-to-speech and voice generation
- **Package**: `elevenlabs-streaming-mcp-server`
- **Environment**: Requires `ELEVENLABS_API_KEY`

### 6. Notion API

- **Purpose**: Notion workspace integration
- **Package**: `@notionhq/notion-mcp-server`
- **Environment**: Requires `NOTION_API_KEY`

## Deployment

The `.mcp.json` file is automatically deployed and configured when running `/sync`:

```bash
# From claude-config repository
/sync

# Deploys:
# - .mcp.json → ~/.mcp.json (for Claude Desktop)
# - MCP servers → Claude CLI user scope (via claude mcp add)
# - settings.json → ~/.claude/settings.json (without MCP config)
# - Other configurations → ~/.claude/
```

The `/sync` command automatically:

1. Copies `.mcp.json` to home directory for Claude Desktop
2. Runs `claude mcp list` to check existing servers
3. Adds any missing servers using `claude mcp add --scope user`
4. Validates all MCP servers are connected

## Adding New MCP Servers

1. Edit `.mcp.json` in the repository root
2. Add your server configuration:

   ```json
   "your-server": {
     "command": "npx",
     "args": ["-y", "your-mcp-package"],
     "env": {
       "YOUR_API_KEY": "${YOUR_API_KEY}"
     }
   }
   ```

3. Run `/sync` to deploy
4. Restart Claude Desktop

## Environment Variables

Required environment variables should be set in your shell configuration:

```bash
# ~/.zshrc or ~/.bashrc
export GITHUB_TOKEN="your-github-token"
export CONTEXT7_API_KEY="your-context7-key"
export ELEVENLABS_API_KEY="your-elevenlabs-key"
export NOTION_API_KEY="your-notion-api-key"
```

## Migration from settings.json

Previously, MCP servers were configured in `settings.json`. They have been moved to `.mcp.json` for:

- Better separation of concerns
- Easier MCP server management
- Cleaner settings structure
- Simplified sharing of MCP configurations

## Troubleshooting

### MCP Servers Not Loading

1. Verify `.mcp.json` exists in home directory
2. Check JSON syntax: `cat ~/.mcp.json | jq`
3. Ensure environment variables are set
4. Restart Claude Desktop

### Package Installation Issues

- npx packages are downloaded on first use
- Ensure Node.js is installed: `brew install node`
- Check network connectivity
- Try manual test: `npx -y package-name --help`

## Benefits of Separate Configuration

1. **Modularity**: MCP servers separate from other settings
2. **Portability**: Easy to share MCP configurations
3. **Version Control**: Track MCP changes independently
4. **Clarity**: Clear distinction between app settings and external integrations
5. **Flexibility**: Can symlink or manage `.mcp.json` separately

---

**Last Updated**: Configuration moved from settings.json to .mcp.json for better organization
