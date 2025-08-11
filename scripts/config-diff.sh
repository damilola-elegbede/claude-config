#!/bin/bash

# /config-diff command implementation
# Compares Claude configuration files between repository and user settings

set -e

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

# Parse arguments
DETAILED_MODE=false
if [[ "$1" == "--detailed" ]]; then
    DETAILED_MODE=true
fi

# Counters for summary
NEW_FILES=0
MODIFIED_FILES=0
USER_ONLY_FILES=0
UNCHANGED_FILES=0

# Arrays to store file lists
declare -a NEW_COMMANDS=()
declare -a MODIFIED_COMMANDS=()
declare -a USER_ONLY_COMMANDS=()
declare -a UNCHANGED_COMMANDS=()

declare -a NEW_AGENTS=()
declare -a MODIFIED_AGENTS=()
declare -a USER_ONLY_AGENTS=()
declare -a UNCHANGED_AGENTS=()

# Utility functions
print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

print_subheader() {
    echo -e "${CYAN}$1:${NC}"
}

print_status() {
    local status="$1"
    local message="$2"
    case "$status" in
        "NEW") echo -e "  ${GREEN}$message${NC}" ;;
        "MODIFIED") echo -e "  ${YELLOW}$message${NC}" ;;
        "DELETED") echo -e "  ${RED}$message${NC}" ;;
        "SAME") echo -e "  $message" ;;
        *) echo -e "  $message" ;;
    esac
}

get_file_info() {
    local file="$1"
    if [[ -f "$file" ]]; then
        local size=$(wc -l < "$file" 2>/dev/null || echo "0")
        local date=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$file" 2>/dev/null || echo "unknown")
        echo "$size lines (modified: $date)"
    else
        echo "NOT FOUND"
    fi
}

files_are_different() {
    local file1="$1"
    local file2="$2"
    
    if [[ ! -f "$file1" ]] || [[ ! -f "$file2" ]]; then
        return 0  # Different if one doesn't exist
    fi
    
    # Use diff to check if files are different
    if ! diff -q "$file1" "$file2" >/dev/null 2>&1; then
        return 0  # Different
    else
        return 1  # Same
    fi
}

show_detailed_diff() {
    local file1="$1"
    local file2="$2"
    local label="$3"
    
    if [[ "$DETAILED_MODE" == "true" ]]; then
        echo -e "\n${PURPLE}--- $label ---${NC}"
        if [[ -f "$file1" ]] && [[ -f "$file2" ]]; then
            diff -u "$file2" "$file1" 2>/dev/null || true
        elif [[ -f "$file1" ]] && [[ ! -f "$file2" ]]; then
            echo "New file in repository:"
            head -20 "$file1"
            if [[ $(wc -l < "$file1") -gt 20 ]]; then
                echo "... (showing first 20 lines)"
            fi
        elif [[ ! -f "$file1" ]] && [[ -f "$file2" ]]; then
            echo "File only exists in user configuration"
        fi
    fi
}

# Compare CLAUDE.md
compare_claude_md() {
    print_subheader "CLAUDE.md"
    
    local repo_info=$(get_file_info "$REPO_CLAUDE_MD")
    local user_info=$(get_file_info "$USER_CLAUDE_MD")
    
    echo "  Repository: $repo_info"
    echo "  User:       $user_info"
    
    if [[ -f "$REPO_CLAUDE_MD" ]] && [[ -f "$USER_CLAUDE_MD" ]]; then
        if files_are_different "$REPO_CLAUDE_MD" "$USER_CLAUDE_MD"; then
            local repo_lines=$(wc -l < "$REPO_CLAUDE_MD")
            local user_lines=$(wc -l < "$USER_CLAUDE_MD")
            local diff_percent=$((($user_lines - $repo_lines) * 100 / $user_lines))
            
            if [[ $repo_lines -lt $user_lines ]]; then
                print_status "MODIFIED" "Status: DIFFERENT - Repository version streamlined by ${diff_percent#-}%"
            elif [[ $repo_lines -gt $user_lines ]]; then
                print_status "MODIFIED" "Status: DIFFERENT - Repository version expanded by ${diff_percent}%"
            else
                print_status "MODIFIED" "Status: DIFFERENT - Same length, content differs"
            fi
            ((MODIFIED_FILES++))
            
            show_detailed_diff "$REPO_CLAUDE_MD" "$USER_CLAUDE_MD" "CLAUDE.md"
        else
            print_status "SAME" "Status: IDENTICAL"
            ((UNCHANGED_FILES++))
        fi
    elif [[ -f "$REPO_CLAUDE_MD" ]] && [[ ! -f "$USER_CLAUDE_MD" ]]; then
        print_status "NEW" "Status: NEW - Will be created in user config"
        ((NEW_FILES++))
        show_detailed_diff "$REPO_CLAUDE_MD" "$USER_CLAUDE_MD" "CLAUDE.md"
    elif [[ ! -f "$REPO_CLAUDE_MD" ]] && [[ -f "$USER_CLAUDE_MD" ]]; then
        print_status "DELETED" "Status: User file will be preserved (no repo version)"
        ((USER_ONLY_FILES++))
    fi
}

# Compare command files
compare_commands() {
    print_subheader "Commands"
    
    # Files to exclude from comparison (repo-specific)
    local excluded_files=("sync.md" "config-diff.md")
    
    # Get all command files from both directories
    local repo_commands=()
    local user_commands=()
    
    if [[ -d "$REPO_COMMANDS_DIR" ]]; then
        while IFS= read -r -d '' file; do
            local basename=$(basename "$file")
            if [[ ! " ${excluded_files[@]} " =~ " ${basename} " ]]; then
                repo_commands+=("$basename")
            fi
        done < <(find "$REPO_COMMANDS_DIR" -name "*.md" -print0 2>/dev/null || true)
    fi
    
    if [[ -d "$USER_COMMANDS_DIR" ]]; then
        while IFS= read -r -d '' file; do
            local basename=$(basename "$file")
            if [[ ! " ${excluded_files[@]} " =~ " ${basename} " ]]; then
                user_commands+=("$basename")
            fi
        done < <(find "$USER_COMMANDS_DIR" -name "*.md" -print0 2>/dev/null || true)
    fi
    
    # Sort arrays
    IFS=$'\n' repo_commands=($(sort <<<"${repo_commands[*]}")); unset IFS
    IFS=$'\n' user_commands=($(sort <<<"${user_commands[*]}")); unset IFS
    
    # Compare files
    for cmd in "${repo_commands[@]}"; do
        local repo_file="$REPO_COMMANDS_DIR/$cmd"
        local user_file="$USER_COMMANDS_DIR/$cmd"
        
        if [[ -f "$user_file" ]]; then
            if files_are_different "$repo_file" "$user_file"; then
                MODIFIED_COMMANDS+=("$cmd")
                ((MODIFIED_FILES++))
            else
                UNCHANGED_COMMANDS+=("$cmd")
                ((UNCHANGED_FILES++))
            fi
        else
            NEW_COMMANDS+=("$cmd")
            ((NEW_FILES++))
        fi
    done
    
    # Find user-only commands
    for cmd in "${user_commands[@]}"; do
        local repo_file="$REPO_COMMANDS_DIR/$cmd"
        if [[ ! -f "$repo_file" ]]; then
            USER_ONLY_COMMANDS+=("$cmd")
            ((USER_ONLY_FILES++))
        fi
    done
    
    # Display results
    local total_commands=$((${#NEW_COMMANDS[@]} + ${#MODIFIED_COMMANDS[@]} + ${#USER_ONLY_COMMANDS[@]} + ${#UNCHANGED_COMMANDS[@]}))
    echo "  Total commands: $total_commands"
    
    if [[ ${#NEW_COMMANDS[@]} -gt 0 ]]; then
        print_status "NEW" "New in repo: ${#NEW_COMMANDS[@]} files (${NEW_COMMANDS[*]})"
    fi
    
    if [[ ${#MODIFIED_COMMANDS[@]} -gt 0 ]]; then
        print_status "MODIFIED" "Modified: ${#MODIFIED_COMMANDS[@]} files (${MODIFIED_COMMANDS[*]})"
    fi
    
    if [[ ${#USER_ONLY_COMMANDS[@]} -gt 0 ]]; then
        print_status "DELETED" "User-only: ${#USER_ONLY_COMMANDS[@]} files (${USER_ONLY_COMMANDS[*]})"
    fi
    
    if [[ ${#UNCHANGED_COMMANDS[@]} -gt 0 ]]; then
        print_status "SAME" "Unchanged: ${#UNCHANGED_COMMANDS[@]} files"
    fi
    
    # Show detailed diffs for modified commands
    if [[ "$DETAILED_MODE" == "true" ]]; then
        for cmd in "${MODIFIED_COMMANDS[@]}"; do
            show_detailed_diff "$REPO_COMMANDS_DIR/$cmd" "$USER_COMMANDS_DIR/$cmd" ".claude/commands/$cmd"
        done
    fi
}

# Compare agent files
compare_agents() {
    print_subheader "Agents"
    
    # Files to exclude from comparison (documentation files)
    local excluded_files=("README.md" "AGENT_TEMPLATE.md" "AGENT_CATEGORIES.md" "AUDIT_VERIFICATION_PROTOCOL.md")
    
    # Get all agent files from both directories
    local repo_agents=()
    local user_agents=()
    
    if [[ -d "$REPO_AGENTS_DIR" ]]; then
        while IFS= read -r -d '' file; do
            local basename=$(basename "$file")
            if [[ ! " ${excluded_files[@]} " =~ " ${basename} " ]]; then
                repo_agents+=("$basename")
            fi
        done < <(find "$REPO_AGENTS_DIR" -name "*.md" -print0 2>/dev/null || true)
    fi
    
    if [[ -d "$USER_AGENTS_DIR" ]]; then
        while IFS= read -r -d '' file; do
            local basename=$(basename "$file")
            if [[ ! " ${excluded_files[@]} " =~ " ${basename} " ]]; then
                user_agents+=("$basename")
            fi
        done < <(find "$USER_AGENTS_DIR" -name "*.md" -print0 2>/dev/null || true)
    fi
    
    # Sort arrays
    IFS=$'\n' repo_agents=($(sort <<<"${repo_agents[*]}")); unset IFS
    IFS=$'\n' user_agents=($(sort <<<"${user_agents[*]}")); unset IFS
    
    # Compare files
    for agent in "${repo_agents[@]}"; do
        local repo_file="$REPO_AGENTS_DIR/$agent"
        local user_file="$USER_AGENTS_DIR/$agent"
        
        if [[ -f "$user_file" ]]; then
            if files_are_different "$repo_file" "$user_file"; then
                MODIFIED_AGENTS+=("$agent")
                ((MODIFIED_FILES++))
            else
                UNCHANGED_AGENTS+=("$agent")
                ((UNCHANGED_FILES++))
            fi
        else
            NEW_AGENTS+=("$agent")
            ((NEW_FILES++))
        fi
    done
    
    # Find user-only agents
    for agent in "${user_agents[@]}"; do
        local repo_file="$REPO_AGENTS_DIR/$agent"
        if [[ ! -f "$repo_file" ]]; then
            USER_ONLY_AGENTS+=("$agent")
            ((USER_ONLY_FILES++))
        fi
    done
    
    # Display results
    local total_agents=$((${#NEW_AGENTS[@]} + ${#MODIFIED_AGENTS[@]} + ${#USER_ONLY_AGENTS[@]} + ${#UNCHANGED_AGENTS[@]}))
    echo "  Total agents: $total_agents"
    
    if [[ ${#NEW_AGENTS[@]} -gt 0 ]]; then
        print_status "NEW" "New in repo: ${#NEW_AGENTS[@]} agents"
        if [[ ${#NEW_AGENTS[@]} -le 10 ]]; then
            echo "    (${NEW_AGENTS[*]})"
        fi
    fi
    
    if [[ ${#MODIFIED_AGENTS[@]} -gt 0 ]]; then
        print_status "MODIFIED" "Modified: ${#MODIFIED_AGENTS[@]} agents"
        if [[ ${#MODIFIED_AGENTS[@]} -le 5 ]]; then
            echo "    (${MODIFIED_AGENTS[*]})"
        fi
    fi
    
    if [[ ${#USER_ONLY_AGENTS[@]} -gt 0 ]]; then
        print_status "DELETED" "User-only: ${#USER_ONLY_AGENTS[@]} agents (${USER_ONLY_AGENTS[*]})"
    fi
    
    if [[ ${#UNCHANGED_AGENTS[@]} -gt 0 ]]; then
        print_status "SAME" "Unchanged: ${#UNCHANGED_AGENTS[@]} agents"
    fi
    
    # Show detailed diffs for a few modified agents
    if [[ "$DETAILED_MODE" == "true" ]]; then
        local count=0
        for agent in "${MODIFIED_AGENTS[@]}"; do
            if [[ $count -lt 3 ]]; then  # Show only first 3 to avoid overwhelming output
                show_detailed_diff "$REPO_AGENTS_DIR/$agent" "$USER_AGENTS_DIR/$agent" ".claude/agents/$agent"
                ((count++))
            else
                echo -e "\n${PURPLE}... and $((${#MODIFIED_AGENTS[@]} - 3)) more modified agents${NC}"
                break
            fi
        done
    fi
}

# Compare settings.json
compare_settings() {
    print_subheader "Settings.json"
    
    if [[ -f "$REPO_SETTINGS" ]] && [[ -f "$USER_SETTINGS" ]]; then
        if files_are_different "$REPO_SETTINGS" "$USER_SETTINGS"; then
            print_status "MODIFIED" "Status: DIFFERENT - Repository has updated settings"
            ((MODIFIED_FILES++))
            
            # Try to identify what's different (basic analysis)
            if grep -q "hooks" "$REPO_SETTINGS" 2>/dev/null && ! grep -q "hooks" "$USER_SETTINGS" 2>/dev/null; then
                echo "    - New hooks configuration available in repository"
            fi
            
            show_detailed_diff "$REPO_SETTINGS" "$USER_SETTINGS" "settings.json"
        else
            print_status "SAME" "Status: IDENTICAL"
            ((UNCHANGED_FILES++))
        fi
    elif [[ -f "$REPO_SETTINGS" ]] && [[ ! -f "$USER_SETTINGS" ]]; then
        print_status "NEW" "Status: NEW - Will be created in user config"
        ((NEW_FILES++))
        show_detailed_diff "$REPO_SETTINGS" "$USER_SETTINGS" "settings.json"
    elif [[ ! -f "$REPO_SETTINGS" ]] && [[ -f "$USER_SETTINGS" ]]; then
        print_status "DELETED" "Status: User settings will be preserved (no repo version)"
        ((USER_ONLY_FILES++))
    else
        print_status "SAME" "Status: Neither version exists"
    fi
}

# Generate summary and recommendations
generate_summary() {
    echo
    print_header "Summary"
    
    local total_files=$((NEW_FILES + MODIFIED_FILES + USER_ONLY_FILES + UNCHANGED_FILES))
    local files_to_update=$((NEW_FILES + MODIFIED_FILES))
    
    echo "  Total files analyzed: $total_files"
    echo "  Files requiring update: $files_to_update"
    echo "  - New files: $NEW_FILES"
    echo "  - Modified files: $MODIFIED_FILES"
    echo "  - User-only files: $USER_ONLY_FILES (will be preserved)"
    echo "  - Unchanged files: $UNCHANGED_FILES"
    
    echo
    print_subheader "Recommendation"
    
    if [[ $files_to_update -gt 0 ]]; then
        print_status "MODIFIED" "Run /sync to update to latest configuration"
        
        # Specific recommendations
        if [[ ${#MODIFIED_AGENTS[@]} -gt 0 ]]; then
            echo "  - ${#MODIFIED_AGENTS[@]} agents will be updated with latest improvements"
        fi
        
        if [[ ${#NEW_COMMANDS[@]} -gt 0 ]]; then
            echo "  - ${#NEW_COMMANDS[@]} new commands will be available: ${NEW_COMMANDS[*]}"
        fi
        
        if [[ -f "$REPO_CLAUDE_MD" ]] && [[ -f "$USER_CLAUDE_MD" ]] && files_are_different "$REPO_CLAUDE_MD" "$USER_CLAUDE_MD"; then
            local repo_lines=$(wc -l < "$REPO_CLAUDE_MD")
            local user_lines=$(wc -l < "$USER_CLAUDE_MD")
            if [[ $repo_lines -lt $user_lines ]]; then
                echo "  - CLAUDE.md will be streamlined (reduced from $user_lines to $repo_lines lines)"
            else
                echo "  - CLAUDE.md will be updated with latest configuration"
            fi
        fi
        
        if [[ $USER_ONLY_FILES -gt 0 ]]; then
            echo "  - Your custom files will be preserved"
        fi
        
        # Impact assessment
        echo
        print_subheader "Impact Assessment"
        if [[ ${#MODIFIED_AGENTS[@]} -gt 30 ]]; then
            print_status "MODIFIED" "HIGH IMPACT - Many agents will be updated"
        elif [[ ${#MODIFIED_AGENTS[@]} -gt 10 ]]; then
            print_status "MODIFIED" "MEDIUM IMPACT - Several agents will be updated"
        else
            print_status "MODIFIED" "LOW IMPACT - Few agents affected"
        fi
        
    else
        print_status "SAME" "No sync needed - configurations are up to date"
    fi
}

# Main execution
main() {
    echo -e "${BLUE}Claude Configuration Diff Report${NC}"
    echo "Comparing repository configuration with user settings"
    echo "Repository: $REPO_ROOT"
    echo "User config: $USER_HOME"
    echo
    
    if [[ "$DETAILED_MODE" == "true" ]]; then
        echo -e "${YELLOW}Running in detailed mode - showing line-by-line differences${NC}"
        echo
    fi
    
    print_header "Configuration Diff Summary"
    
    compare_claude_md
    echo
    
    compare_commands
    echo
    
    compare_agents
    echo
    
    compare_settings
    
    generate_summary
    
    # Final status
    echo
    if [[ $((NEW_FILES + MODIFIED_FILES)) -gt 0 ]]; then
        echo -e "${YELLOW}Use '/sync' to apply these changes to your configuration${NC}"
    else
        echo -e "${GREEN}Your configuration is up to date!${NC}"
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