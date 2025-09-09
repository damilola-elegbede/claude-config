#!/bin/bash
# Sync script for Claude configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
SOURCE_DIR="$REPO_DIR/system-configs"
TARGET_DIR="$HOME/.claude"

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Function to create backup
create_backup() {
    if [ -d "$TARGET_DIR" ]; then
        BACKUP_DIR="$HOME/.claude.backup.$(date +%Y%m%d_%H%M%S)"
        echo "Creating backup at $BACKUP_DIR..."
        cp -r "$TARGET_DIR" "$BACKUP_DIR"
        print_success "Backup created at $BACKUP_DIR"
    fi
}

# Function to sync files
sync_files() {
    echo "Syncing configuration files..."

    # Create target directory if it doesn't exist
    mkdir -p "$TARGET_DIR"

    # Sync CLAUDE.md to home directory
    if [ -f "$SOURCE_DIR/CLAUDE.md" ]; then
        # Backup existing ~/CLAUDE.md if present
        if [ -f "$HOME/CLAUDE.md" ]; then
            BACKUP_DIR="${BACKUP_DIR:-$HOME/.claude.backup.$(date +%Y%m%d_%H%M%S)}"
            mkdir -p "$BACKUP_DIR"
            cp "$HOME/CLAUDE.md" "$BACKUP_DIR/CLAUDE.md.bak"
            print_success "Backed up existing ~/CLAUDE.md to $BACKUP_DIR/CLAUDE.md.bak"
        fi
        cp "$SOURCE_DIR/CLAUDE.md" "$HOME/CLAUDE.md"
        print_success "Synced CLAUDE.md to ~/CLAUDE.md"
    fi

    # Sync .claude directory contents
    if [ -d "$SOURCE_DIR/.claude" ]; then
        # Create subdirectories
        mkdir -p "$TARGET_DIR/agents"
        mkdir -p "$TARGET_DIR/commands"

        # Sync agents (excluding templates and README)
        if [ -d "$SOURCE_DIR/.claude/agents" ]; then
            find "$SOURCE_DIR/.claude/agents" -name "*.md" -not -name "*TEMPLATE*" -not -name "README.md" -exec cp {} "$TARGET_DIR/agents/" \; 2>/dev/null || true
            AGENT_COUNT=$(find "$SOURCE_DIR/.claude/agents" -name "*.md" -not -name "*TEMPLATE*" -not -name "README.md" 2>/dev/null | wc -l | tr -d ' ')
            print_success "Synced $AGENT_COUNT agents"
        else
            print_warning "No agents directory found at $SOURCE_DIR/.claude/agents"
        fi

        # Sync commands
        if [ -d "$SOURCE_DIR/.claude/commands" ]; then
            cp "$SOURCE_DIR/.claude/commands"/*.md "$TARGET_DIR/commands/" 2>/dev/null || true
            COMMAND_COUNT=$(find "$SOURCE_DIR/.claude/commands" -name "*.md" | wc -l | tr -d ' ')
            print_success "Synced $COMMAND_COUNT commands"
        fi

        # Sync settings.json
        if [ -f "$SOURCE_DIR/.claude/settings.json" ]; then
            cp "$SOURCE_DIR/.claude/settings.json" "$TARGET_DIR/"
            print_success "Synced settings.json"
        fi

        # Sync mcp-servers directory (for reference, not auto-loading)
        if [ -d "$SOURCE_DIR/.claude/mcp-servers" ]; then
            mkdir -p "$TARGET_DIR/mcp-servers"
            find "$SOURCE_DIR/.claude/mcp-servers" -name "*.json" -exec cp {} "$TARGET_DIR/mcp-servers/" \;
            find "$SOURCE_DIR/.claude/mcp-servers" -name "*.md" -exec cp {} "$TARGET_DIR/mcp-servers/" \;
            MCP_COUNT=$(find "$SOURCE_DIR/.claude/mcp-servers" -name "*.json" | wc -l | tr -d ' ')
            print_success "Synced $MCP_COUNT MCP server configurations (stored for reference, not auto-loaded)"
        fi

        # DO NOT create .mcp.json - we don't want automatic loading

        # Sync other configuration files (excluding output-styles)
        find "$SOURCE_DIR/.claude" -maxdepth 1 -type f -name "*.sh" -exec cp {} "$TARGET_DIR/" \; 2>/dev/null || true
    fi
}

# Function to validate sync
validate_sync() {
    echo "Validating sync..."

    # Check critical files
    if [ -f "$HOME/CLAUDE.md" ] && [ -f "$TARGET_DIR/settings.json" ]; then
        print_success "Critical files synced successfully"
    else
        print_error "Some critical files missing"
        return 1
    fi

    # Count synced items
    SYNCED_AGENTS=$(find "$TARGET_DIR/agents" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    SYNCED_COMMANDS=$(find "$TARGET_DIR/commands" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    SYNCED_MCP=$(find "$TARGET_DIR/mcp-servers" -name "*.json" 2>/dev/null | wc -l | tr -d ' ')

    echo "Sync complete:"
    echo "  - Agents: $SYNCED_AGENTS"
    echo "  - Commands: $SYNCED_COMMANDS"
    echo "  - MCP Servers: $SYNCED_MCP (stored for reference, not auto-loaded)"
}

# Main execution
main() {
    echo "Claude Configuration Sync"
    echo "========================="
    echo

    # Parse arguments
    if [ "$1" == "--backup" ]; then
        create_backup
    elif [ "$1" == "--dry-run" ]; then
        echo "Dry run mode - no files will be copied"
        find "$SOURCE_DIR" -type f \( -name "*.md" -o -name "*.json" -o -name "*.sh" \) -not -path "*/output-styles/*" -not -name "*TEMPLATE*" -not -name "README.md" | wc -l | xargs echo "Would sync files:"
        exit 0
    fi

    # Perform sync
    sync_files
    validate_sync

    print_success "Sync completed successfully!"
}

# Run main function
main "$@"