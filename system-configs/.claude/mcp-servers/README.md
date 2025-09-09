# MCP Server Configuration Files

This directory contains modular MCP (Model Context Protocol) server configurations for Claude Code CLI.

## Overview

Each `.mcp.*.json` file contains the configuration for a single MCP server, allowing for selective loading per
Claude session rather than loading all servers by default.

## Available Servers

### 📁 `.mcp.filesystem.json`

- **Purpose**: Local file system operations
- **Package**: `@modelcontextprotocol/server-filesystem`
- **Auth**: None required
- **Access**: `/Users/damilola/Documents` directory tree
- **Tools**: Read, write, edit, search, and manage files

### 🐙 `.mcp.github.json`

- **Purpose**: GitHub integration and repository management
- **Package**: `@modelcontextprotocol/server-github`
- **Auth**: Requires `GITHUB_TOKEN` environment variable
- **Tools**: Manage repos, PRs, issues, commits, and GitHub operations

### 🎨 `.mcp.shadcn.json`

- **Purpose**: UI component library integration
- **Package**: `shadcn-ui-mcp-server`
- **Auth**: None required
- **Tools**: Access to shadcn/ui components and patterns

### 📚 `.mcp.context7.json`

- **Purpose**: Up-to-date library documentation retrieval
- **Package**: `@upstash/context7-mcp`
- **Auth**: Requires `CONTEXT7_API_KEY` environment variable
- **Tools**: Fetch current documentation for any library

### 🔊 `.mcp.elevenlabs.json`

- **Purpose**: Text-to-speech and voice synthesis
- **Package**: `elevenlabs-streaming-mcp-server`
- **Auth**: Requires `ELEVENLABS_API_KEY` environment variable
- **Tools**: Generate audio from text, list voices

### 📝 `.mcp.notion.json`

- **Purpose**: Notion workspace integration
- **Package**: `@notionhq/notion-mcp-server`
- **Auth**: Requires `NOTION_API_KEY` environment variable
- **Tools**: Access and manage Notion pages, databases, and content

## Usage

### Session-Based Loading

MCP servers are designed to be loaded per-session based on your needs. By default, Claude starts with no MCP servers loaded.

To use MCP servers in a session:

1. **Manual Configuration**: Copy the desired `.mcp.*.json` file(s) to your project root as `.mcp.json`
2. **Merge Multiple Servers**: Combine multiple server configurations into a single `.mcp.json`
3. **Environment Setup**: Ensure required API keys are set in your environment

### Example: Single Server

```bash
# Use only filesystem server
cp system-configs/.claude/mcp-servers/.mcp.filesystem.json .mcp.json
claude
```

### Example: Multiple Servers

Merge multiple configurations using `jq`:

```bash
# Combine filesystem and github servers
jq -s '.[0] * .[1]' \
  system-configs/.claude/mcp-servers/.mcp.filesystem.json \
  system-configs/.claude/mcp-servers/.mcp.github.json \
  > .mcp.json
claude
```

### Required Environment Variables

Set these environment variables before starting Claude with the respective servers:

```bash
export GITHUB_TOKEN="your-github-token"
export CONTEXT7_API_KEY="your-context7-key"
export ELEVENLABS_API_KEY="your-elevenlabs-key"
export NOTION_API_KEY="your-notion-key"
```

## File Structure

Each configuration file follows this structure:

```json
{
  "mcpServers": {
    "server-name": {
      "command": "npx",
      "args": ["-y", "package-name", ...additional-args],
      "env": {
        "API_KEY": "${API_KEY}"  // Optional, if auth required
      }
    }
  }
}
```

## Benefits

- **Selective Loading**: Only load servers needed for your current task
- **Faster Startup**: Reduced initialization overhead
- **Security**: Minimize exposed API keys and attack surface
- **Debugging**: Isolate server-specific issues
- **Resource Efficiency**: Lower memory and CPU usage

## Notes

- The `-y` flag in npx ensures servers auto-install if not present
- Server names must match between the filename and the JSON key
- Environment variables use `${VAR_NAME}` syntax for runtime substitution
- Servers communicate with Claude via JSON-RPC over stdio

## Sync Command Integration

The `/sync` command automatically handles this modular structure, syncing individual MCP server files to
`~/.claude/mcp-servers/` while preserving the modular organization.
