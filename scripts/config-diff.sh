#!/bin/bash

# /config-diff command implementation
# Compares Claude configuration files between repository and user settings

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration paths
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
USER_HOME="$HOME"

REPO_CLAUDE_MD="$REPO_ROOT/CLAUDE.md"
REPO_COMMANDS_DIR="$REPO_ROOT/.claude/commands"
REPO_AGENTS_DIR="$REPO_ROOT/.claude/agents"
REPO_SETTINGS="$REPO_ROOT/settings.json"

USER_CLAUDE_MD="$USER_HOME/CLAUDE.md"
USER_COMMANDS_DIR="$USER_HOME/.claude/commands"
USER_AGENTS_DIR="$USER_HOME/.claude/agents"
USER_SETTINGS="$USER_HOME/.claude/settings.json"

# Counters for summary
IDENTICAL_FILES=0
DIFFERENT_FILES=0
MISSING_FILES=0
EXTRA_FILES=0

# Main comparison function
main() {
    echo -e "${BLUE}=== Claude Configuration Diff Report ===${NC}"
    echo "Comparing repository configuration with user settings"
    echo "Repository: $REPO_ROOT"
    echo "User config: $USER_HOME"
    echo
    
    # Compare CLAUDE.md
    echo -e "${CYAN}CLAUDE.md:${NC}"
    if [[ -f "$REPO_CLAUDE_MD" ]] && [[ -f "$USER_CLAUDE_MD" ]]; then
        if diff -q "$REPO_CLAUDE_MD" "$USER_CLAUDE_MD" >/dev/null 2>&1; then
            echo "  ✅ Identical"
            ((IDENTICAL_FILES++))
        else
            echo "  ⚠️  Different"
            ((DIFFERENT_FILES++))
            if [[ "$1" == "--detailed" ]]; then
                echo "  Differences:"
                diff -u "$USER_CLAUDE_MD" "$REPO_CLAUDE_MD" | head -20
            fi
        fi
    elif [[ -f "$REPO_CLAUDE_MD" ]]; then
        echo "  ❌ Missing in user config"
        ((MISSING_FILES++))
    else
        echo "  ❌ Missing in repository"
    fi
    
    echo
    
    # Compare Commands
    echo -e "${CYAN}Commands:${NC}"
    
    # Count command files (excluding sync.md and config-diff.md which are repo-only)
    repo_cmd_count=0
    user_cmd_count=0
    
    if [[ -d "$REPO_COMMANDS_DIR" ]]; then
        # Count all except sync.md and config-diff.md for comparison
        shopt -s nullglob
        repo_commands=("$REPO_COMMANDS_DIR"/*.md)
        for cmd in "${repo_commands[@]}"; do
            basename_cmd=$(basename "$cmd")
            if [[ "$basename_cmd" != "sync.md" ]] && [[ "$basename_cmd" != "config-diff.md" ]]; then
                ((repo_cmd_count++))
            fi
        done
        shopt -u nullglob
    fi
    
    if [[ -d "$USER_COMMANDS_DIR" ]]; then
        shopt -s nullglob
        user_commands=("$USER_COMMANDS_DIR"/*.md)
        user_cmd_count=${#user_commands[@]}
        shopt -u nullglob
    fi
    
    echo "  Repository: $repo_cmd_count files (excluding sync.md and config-diff.md)"
    echo "  User: $user_cmd_count files"
    
    if [[ $repo_cmd_count -eq $user_cmd_count ]]; then
        echo "  ✅ Count matches"
        ((IDENTICAL_FILES++))
    else
        echo "  ⚠️  Count mismatch"
        ((DIFFERENT_FILES++))
    fi
    
    # List any missing commands
    if [[ -d "$REPO_COMMANDS_DIR" ]] && [[ -d "$USER_COMMANDS_DIR" ]]; then
        missing_cmds=""
        shopt -s nullglob
        repo_commands=("$REPO_COMMANDS_DIR"/*.md)
        if [[ ${#repo_commands[@]} -gt 0 ]]; then
            for cmd in "${repo_commands[@]}"; do
                basename_cmd=$(basename "$cmd")
                if [[ "$basename_cmd" != "sync.md" ]] && [[ "$basename_cmd" != "config-diff.md" ]] && [[ ! -f "$USER_COMMANDS_DIR/$basename_cmd" ]]; then
                    missing_cmds="$missing_cmds    - $basename_cmd\n"
                    ((MISSING_FILES++))
                fi
            done
        fi
        shopt -u nullglob
        if [[ -n "$missing_cmds" ]]; then
            echo "  Missing in user config:"
            echo -e "$missing_cmds"
        fi
    fi
    
    echo
    
    # Compare Agents
    echo -e "${CYAN}Agents:${NC}"
    
    # Count agent files (excluding documentation files)
    repo_agent_count=0
    user_agent_count=0
    
    if [[ -d "$REPO_AGENTS_DIR" ]]; then
        # Exclude documentation files
        shopt -s nullglob
        repo_agents=("$REPO_AGENTS_DIR"/*.md)
        for agent in "${repo_agents[@]}"; do
            basename_agent=$(basename "$agent")
            if [[ ! "$basename_agent" =~ (AGENT_TEMPLATE|AGENT_CATEGORIES|AUDIT_VERIFICATION|README) ]]; then
                ((repo_agent_count++))
            fi
        done
        shopt -u nullglob
    fi
    
    if [[ -d "$USER_AGENTS_DIR" ]]; then
        shopt -s nullglob
        user_agents=("$USER_AGENTS_DIR"/*.md)
        user_agent_count=${#user_agents[@]}
        shopt -u nullglob
    fi
    
    echo "  Repository: $repo_agent_count files (excluding docs)"
    echo "  User: $user_agent_count files"
    
    if [[ $repo_agent_count -eq $user_agent_count ]]; then
        echo "  ✅ Count matches"
        ((IDENTICAL_FILES++))
    else
        echo "  ⚠️  Count mismatch"
        ((DIFFERENT_FILES++))
    fi
    
    echo
    
    # Compare settings.json
    echo -e "${CYAN}Settings.json:${NC}"
    if [[ -f "$REPO_SETTINGS" ]] && [[ -f "$USER_SETTINGS" ]]; then
        if diff -q "$REPO_SETTINGS" "$USER_SETTINGS" >/dev/null 2>&1; then
            echo "  ✅ Identical"
            ((IDENTICAL_FILES++))
        else
            echo "  ⚠️  Different"
            ((DIFFERENT_FILES++))
        fi
    elif [[ -f "$REPO_SETTINGS" ]]; then
        echo "  ❌ Missing in user config"
        ((MISSING_FILES++))
    elif [[ -f "$USER_SETTINGS" ]]; then
        echo "  ℹ️  User has settings, repository doesn't"
        ((EXTRA_FILES++))
    else
        echo "  ℹ️  No settings.json in either location"
    fi
    
    echo
    echo -e "${BLUE}=== Summary ===${NC}"
    
    # Calculate sync status
    if [[ $DIFFERENT_FILES -eq 0 ]] && [[ $MISSING_FILES -eq 0 ]] && [[ $EXTRA_FILES -eq 0 ]]; then
        echo -e "${GREEN}✅ Your configuration is fully synchronized!${NC}"
    else
        echo -e "${YELLOW}⚠️  Configuration differences detected:${NC}"
        [[ $IDENTICAL_FILES -gt 0 ]] && echo "  ✅ Identical: $IDENTICAL_FILES items"
        [[ $DIFFERENT_FILES -gt 0 ]] && echo "  ⚠️  Different: $DIFFERENT_FILES items"
        [[ $MISSING_FILES -gt 0 ]] && echo "  ❌ Missing: $MISSING_FILES items"
        [[ $EXTRA_FILES -gt 0 ]] && echo "  ℹ️  Extra in user: $EXTRA_FILES items"
        echo
        echo -e "${CYAN}Run '/sync' to update your configuration${NC}"
    fi
}

# Verify we're in the right repository
if [[ ! -f "$REPO_ROOT/CLAUDE.md" ]] || [[ ! -d "$REPO_ROOT/.claude" ]]; then
    echo -e "${RED}Error: This command must be run from the claude-config repository${NC}"
    echo "Current directory: $(pwd)"
    echo "Expected repository structure not found"
    exit 1
fi

# Run main function
main "$@"