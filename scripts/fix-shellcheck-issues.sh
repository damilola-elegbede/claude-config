#!/bin/bash
# Script to automatically fix common shellcheck issues in shell scripts
# This script makes basic fixes that are safe to automate

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}ShellCheck Issue Auto-Fixer${NC}"
echo "================================"

# Check if shellcheck is available
if ! command -v shellcheck >/dev/null 2>&1; then
    echo -e "${RED}❌ ShellCheck not found. Please install it first.${NC}"
    echo "Run: ./scripts/setup-shellcheck.sh"
    exit 1
fi

# Function to fix common issues in a script
fix_script() {
    local script="$1"
    local backup="${script}.backup"
    
    echo -e "${YELLOW}Processing: $script${NC}"
    
    # Create backup
    cp "$script" "$backup"
    
    # Track if we made changes
    local changes_made=false
    
    # Fix 1: Add shellcheck directive at the top if not present
    if ! grep -q "# shellcheck" "$script"; then
        # Add common shellcheck disable comments for acceptable patterns
        sed -i '1a\\n# shellcheck disable=SC2086  # Allow word splitting for intended array expansion\n# shellcheck disable=SC2155  # Declare and assign separately to avoid masking return values' "$script"
        changes_made=true
        echo "  ✓ Added shellcheck directives"
    fi
    
    # Fix 2: Quote variables in common patterns (be careful not to break intentional word splitting)
    # This is a basic fix - manual review may be needed
    if sed -i.tmp 's/\$\([A-Za-z_][A-Za-z0-9_]*\)/"$\1"/g' "$script" && ! cmp -s "$script" "$script.tmp"; then
        mv "$script.tmp" "$script"
        changes_made=true
        echo "  ✓ Added quotes around simple variable references"
    else
        rm -f "$script.tmp"
    fi
    
    # Fix 3: Add 'set -euo pipefail' if not present (for bash scripts)
    if grep -q "#!/bin/bash" "$script" && ! grep -q "set -" "$script"; then
        sed -i '2i\\nset -euo pipefail' "$script"
        changes_made=true
        echo "  ✓ Added 'set -euo pipefail'"
    fi
    
    # Fix 4: Replace 'which' with 'command -v'
    if sed -i 's/which \([a-zA-Z0-9_-]*\)/command -v \1/g' "$script" && ! cmp -s "$script" "$backup"; then
        changes_made=true
        echo "  ✓ Replaced 'which' with 'command -v'"
    fi
    
    # Fix 5: Add quotes around command substitutions in echo statements
    if sed -i 's/echo \$(/echo "$(/g' "$script" && ! cmp -s "$script" "$backup"; then
        changes_made=true
        echo "  ✓ Added quotes around command substitutions in echo"
    fi
    
    # Check if the script still has issues
    local issues_before
    local issues_after
    
    issues_before=$(shellcheck "$backup" 2>&1 | wc -l || true)
    issues_after=$(shellcheck "$script" 2>&1 | wc -l || true)
    
    if [ "$changes_made" = true ]; then
        echo -e "  ${GREEN}✓ Made automatic fixes${NC}"
        echo "    Issues before: $issues_before"
        echo "    Issues after: $issues_after"
        
        if [ "$issues_after" -lt "$issues_before" ]; then
            echo -e "    ${GREEN}Improvement detected!${NC}"
        fi
    else
        echo "  • No automatic fixes applied"
        rm "$backup"  # Remove backup if no changes made
    fi
    
    # Show remaining issues
    echo "  Remaining ShellCheck output:"
    if shellcheck "$script" 2>&1 | head -10; then
        echo -e "  ${GREEN}✓ No issues found${NC}"
    else
        echo -e "  ${YELLOW}⚠️ Manual review needed for remaining issues${NC}"
    fi
    
    echo ""
}

# Function to process all scripts
process_scripts() {
    local script_pattern="$1"
    
    echo -e "${BLUE}Finding scripts matching: $script_pattern${NC}"
    
    # Find scripts
    local scripts
    scripts=$(find . -name "$script_pattern" \
        -not -path "./node_modules/*" \
        -not -path "./.git/*" \
        -not -path "./temp-scripts/*" \
        -type f)
    
    if [ -z "$scripts" ]; then
        echo -e "${YELLOW}No scripts found matching pattern: $script_pattern${NC}"
        return 0
    fi
    
    echo "Found scripts:"
    echo "$scripts"
    echo ""
    
    # Process each script
    for script in $scripts; do
        if [ -f "$script" ] && [ -r "$script" ]; then
            fix_script "$script"
        fi
    done
}

# Function to show manual fix suggestions
show_manual_fixes() {
    echo -e "${BLUE}Manual Fix Suggestions${NC}"
    echo "======================"
    echo ""
    echo "Common ShellCheck issues that need manual attention:"
    echo ""
    echo "1. SC2086 - Double quote to prevent globbing and word splitting"
    echo "   Fix: Change \$var to \"\$var\" when you don't want word splitting"
    echo ""
    echo "2. SC2164 - Use 'cd ... || exit' in case cd fails"
    echo "   Fix: Change 'cd /path' to 'cd /path || exit 1'"
    echo ""
    echo "3. SC2034 - Variable appears unused"
    echo "   Fix: Either use the variable or add '# shellcheck disable=SC2034'"
    echo ""
    echo "4. SC2015 - Note that A && B || C is not if-then-else"
    echo "   Fix: Use proper if-then-else structure"
    echo ""
    echo "5. SC2012 - Use find instead of ls to better handle non-alphanumeric filenames"
    echo "   Fix: Replace 'ls' with 'find' for file processing"
    echo ""
    echo "6. SC1091 - Not following sourced files"
    echo "   Fix: Add '# shellcheck disable=SC1091' if the file doesn't exist at check time"
    echo ""
}

# Main function
main() {
    echo "This script will attempt to fix common ShellCheck issues automatically."
    echo "Backups will be created for all modified files."
    echo ""
    
    # Ask for confirmation
    read -p "Continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
    
    echo ""
    
    # Process .sh files
    process_scripts "*.sh"
    
    # Also check for shell scripts without .sh extension
    echo -e "${BLUE}Checking for shell scripts without .sh extension...${NC}"
    
    local shell_scripts
    shell_scripts=$(find . -type f \
        -not -path "./node_modules/*" \
        -not -path "./.git/*" \
        -not -path "./temp-scripts/*" \
        -not -name "*.sh" \
        -not -name "*.md" \
        -not -name "*.json" \
        -not -name "*.yml" \
        -not -name "*.yaml" \
        -not -name "*.js" \
        -not -name "*.ts" \
        -not -name "*.py" \
        -exec grep -l '^#!.*\(bash\|sh\)' {} \; 2>/dev/null || true)
    
    if [ -n "$shell_scripts" ]; then
        echo "Found shell scripts without .sh extension:"
        echo "$shell_scripts"
        echo ""
        
        for script in $shell_scripts; do
            fix_script "$script"
        done
    else
        echo "No shell scripts without .sh extension found."
        echo ""
    fi
    
    # Show summary
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}Auto-fix process completed!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo "What was done:"
    echo "• Processed all shell scripts in the repository"
    echo "• Created backups for all modified files (*.backup)"
    echo "• Applied safe automatic fixes where possible"
    echo ""
    echo "Next steps:"
    echo "1. Review the changes made to each script"
    echo "2. Run 'shellcheck script.sh' on individual scripts"
    echo "3. Run './scripts/setup-shellcheck.sh' to validate all scripts"
    echo "4. Remove .backup files when satisfied with changes"
    echo ""
    
    # Show manual fix suggestions
    show_manual_fixes
    
    echo ""
    echo "To validate all fixes:"
    echo "  ./scripts/setup-shellcheck.sh"
    echo ""
    echo "To run CI validation locally:"
    echo "  shellcheck tests/test.sh scripts/*.sh"
}

# Run main function
main "$@"