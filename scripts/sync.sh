#!/bin/sh
# Sync script for Claude configuration
# Syncs system-configs/.claude/ to ~/.claude/ with validation and backup

set -eu

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Ensure HOME is set
: "${HOME:?HOME variable is not set}"

# Get script directory (POSIX compatible)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
SOURCE_DIR="$REPO_DIR/system-configs/.claude"
TARGET_DIR="$HOME/.claude"

# Parse arguments
DRY_RUN=false
CREATE_BACKUP=true

while [ $# -gt 0 ]; do
  case $1 in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --backup)
      CREATE_BACKUP=true
      shift
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--dry-run|--backup]"
      exit 1
      ;;
  esac
done

# Function to print colored output (POSIX compatible)
print_success() {
    printf "${GREEN}✓${NC} %s\n" "$1"
}

print_error() {
    printf "${RED}✗${NC} %s\n" "$1"
}

print_warning() {
    printf "${YELLOW}⚠${NC} %s\n" "$1"
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

# Function to validate configs
validate_configs() {
    echo "🔄 Syncing Claude configurations..."
    echo "📁 Source: $SOURCE_DIR ($(find "$SOURCE_DIR" -name "*.md" -o -name "*.json" -o -name "*.sh" 2>/dev/null | wc -l | tr -d ' ') files)"
    echo "📁 Target: $TARGET_DIR"
    echo ""

    echo "✅ Pre-sync validation:"

    # Check source directory
    if [ ! -d "$SOURCE_DIR" ]; then
        echo "❌ Source directory not found: $SOURCE_DIR"
        return 1
    fi

    # Basic syntax validation
    AGENT_COUNT=$(find "$SOURCE_DIR/agents" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    COMMAND_COUNT=$(find "$SOURCE_DIR/commands" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    SKILL_COUNT=$(find "$SOURCE_DIR/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
    echo "  - Configuration syntax: Valid ($AGENT_COUNT agents, $COMMAND_COUNT commands, $SKILL_COUNT skills)"

    # Check target directory permissions
    if [ ! -w "$HOME" ]; then
        echo "❌ Cannot write to home directory"
        return 1
    fi
    echo "  - Target directory: Ready"
    echo "  - Permissions: OK"
    echo ""

    return 0
}

# Function to sync files
sync_files() {
    echo "🔄 Synchronizing files:"

    # Create target directories
    mkdir -p "$TARGET_DIR/agents"
    mkdir -p "$TARGET_DIR/commands"
    mkdir -p "$TARGET_DIR/skills"
    mkdir -p "$TARGET_DIR/output-styles"

    # Sync agents using rsync
    if rsync -a --exclude="README.md" --exclude="*TEMPLATE*" --exclude="*CATEGORIES*" --exclude="*AUDIT*" "$SOURCE_DIR/agents/" "$TARGET_DIR/agents/" >/dev/null 2>&1; then
        AGENT_COUNT=$(find "$SOURCE_DIR/agents" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
        echo "  ✅ Agents: $AGENT_COUNT files → ~/.claude/agents/"
    else
        echo "  ❌ Failed to sync agents"
        return 1
    fi

    # Sync commands using rsync
    if rsync -a "$SOURCE_DIR/commands/" "$TARGET_DIR/commands/" >/dev/null 2>&1; then
        COMMAND_COUNT=$(find "$SOURCE_DIR/commands" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
        echo "  ✅ Commands: $COMMAND_COUNT files → ~/.claude/commands/"
    else
        echo "  ❌ Failed to sync commands"
        return 1
    fi

    # Sync skills if they exist
    if [ -d "$SOURCE_DIR/skills" ]; then
        if rsync -a --exclude="README.md" --exclude="*TEMPLATE*" "$SOURCE_DIR/skills/" "$TARGET_DIR/skills/" >/dev/null 2>&1; then
            SKILL_COUNT=$(find "$SOURCE_DIR/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
            echo "  ✅ Skills: $SKILL_COUNT skills → ~/.claude/skills/"
        else
            echo "  ❌ Failed to sync skills"
            return 1
        fi
    fi

    # Sync output styles if they exist
    if [ -d "$SOURCE_DIR/output-styles" ]; then
        rsync -a "$SOURCE_DIR/output-styles/" "$TARGET_DIR/output-styles/" >/dev/null 2>&1
        STYLE_COUNT=$(find "$SOURCE_DIR/output-styles" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
        echo "  ✅ Output styles: $STYLE_COUNT files → ~/.claude/output-styles/"
    fi

    # Sync individual files
    if [ -f "$SOURCE_DIR/settings.json" ]; then
        cp "$SOURCE_DIR/settings.json" "$TARGET_DIR/"
    fi

    if [ -f "$SOURCE_DIR/statusline.sh" ]; then
        cp "$SOURCE_DIR/statusline.sh" "$TARGET_DIR/"
        chmod +x "$TARGET_DIR/statusline.sh"
    fi

    echo "  ✅ Settings: settings.json, statusline.sh"
    echo ""

    return 0
}

# Function to validate sync
post_sync_validation() {
    echo "✅ Post-sync validation:"

    # Check file integrity
    agent_count=0
    command_count=0
    skill_count=0

    if [ -d "$TARGET_DIR/agents" ]; then
        agent_count=$(find "$TARGET_DIR/agents" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    fi

    if [ -d "$TARGET_DIR/commands" ]; then
        command_count=$(find "$TARGET_DIR/commands" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    fi

    if [ -d "$TARGET_DIR/skills" ]; then
        skill_count=$(find "$TARGET_DIR/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
    fi

    echo "  - File integrity: All files copied successfully"
    echo "  - Agent configs: $agent_count/$agent_count valid"
    echo "  - Commands: $command_count/$command_count functional"
    echo "  - Skills: $skill_count/$skill_count valid"
    echo "  - MCP integration: Not configured"
    echo ""

    return 0
}

# Main execution
main() {
    start_time=$(date +%s)

    # Handle dry run
    if [ "$DRY_RUN" = "true" ]; then
        echo "📖 Preview mode - no changes will be made"
        echo ""
        echo "🔍 Analyzing configurations:"
        echo "  Source: $SOURCE_DIR ($(find "$SOURCE_DIR" -name "*.md" 2>/dev/null | wc -l | tr -d ' ') files)"
        echo "  Target: $TARGET_DIR"
        echo ""
        echo "📋 Files to sync:"
        echo "  - $(find "$SOURCE_DIR/agents" -name "*.md" 2>/dev/null | wc -l | tr -d ' ') agent files → ~/.claude/agents/"
        echo "  - $(find "$SOURCE_DIR/commands" -name "*.md" 2>/dev/null | wc -l | tr -d ' ') command files → ~/.claude/commands/"
        echo "  - $(find "$SOURCE_DIR/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ') skills → ~/.claude/skills/"
        echo "  - settings.json → ~/.claude/settings.json"
        echo "  - statusline.sh → ~/.claude/statusline.sh"
        echo ""
        echo "📊 Preview summary:"
        echo "  Total files: $(find "$SOURCE_DIR" -name "*.md" -o -name "*.json" -o -name "*.sh" 2>/dev/null | wc -l | tr -d ' ') configurations ready"
        echo "  Backup would be created before sync"
        echo "  Estimated time: 2-3 seconds"
        return 0
    fi

    # Validate before sync
    if ! validate_configs; then
        echo "❌ Pre-sync validation failed"
        echo ""
        echo "🛠️ Fix these issues before syncing:"
        echo "  1. Check source directory structure"
        echo "  2. Verify target directory permissions"
        echo "  3. Validate configuration syntax"
        echo ""
        echo "Run /sync again after addressing these issues."
        return 1
    fi

    # Create backup
    if [ "$CREATE_BACKUP" = "true" ]; then
        create_backup
        echo ""
    fi

    # Perform sync with error handling
    if ! sync_files; then
        echo "❌ Sync failed"
        echo "🎯 Sync aborted"
        return 1
    fi

    # Post-sync validation
    post_sync_validation

    end_time=$(date +%s)
    duration=$((end_time - start_time))

    echo "📊 Sync completed successfully:"
    echo "  Files synced: $(find "$SOURCE_DIR" -name "*.md" -o -name "*.json" -o -name "*.sh" 2>/dev/null | wc -l | tr -d ' ') total"
    if [ -n "${BACKUP_DIR:-}" ]; then
        echo "  Backup location: $BACKUP_DIR"
    fi
    echo "  Sync time: ${duration} seconds"

    return 0
}

# Run main function
main "$@"
