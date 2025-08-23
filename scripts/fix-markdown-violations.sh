#!/bin/bash
# Advanced Markdown Violation Remediation Script
# Automatically fixes common markdownlint violations

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo "$(dirname "$SCRIPT_DIR")")"
CONFIG_FILE="$REPO_ROOT/.markdownlint-cli2.jsonc"

# Colors for output
if [ -n "${CI:-}" ] || [ ! -t 1 ]; then
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    NC=''
else
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    BLUE='\033[0;34m'
    NC='\033[0m'
fi

# Fix counters
fixes_applied=0
files_modified=0

echo -e "${BLUE}=== Advanced Markdown Violation Remediation ===${NC}"
echo "Repository: $REPO_ROOT"
echo

# Function to apply fix and count it
apply_fix() {
    local description="$1"
    local file="$2"
    local command="$3"

    if eval "$command"; then
        ((fixes_applied++))
        echo -e "${GREEN}✓${NC} $description: $file"
        return 0
    else
        echo -e "${RED}✗${NC} Failed to fix $description: $file"
        return 1
    fi
}

# Function to fix trailing spaces (MD009)
fix_trailing_spaces() {
    echo -e "${YELLOW}Fixing trailing spaces MD009...${NC}"

    find "$REPO_ROOT" -name "*.md" -type f \
        ! -path "*/node_modules/*" \
        ! -path "*/.git/*" \
        ! -path "*/system-configs/.claude/agents/*.md" \
        -print0 | while IFS= read -r -d '' file; do

        if grep -q '[[:space:]]$' "$file"; then
            apply_fix "Remove trailing spaces" "$file" \
                "sed -i '' 's/[[:space:]]*$//' '$file'"
            ((files_modified++))
        fi
    done
}

# Function to fix blank lines around headings (MD022)
fix_heading_spacing() {
    echo -e "${YELLOW}Fixing heading spacing MD022...${NC}"

    find "$REPO_ROOT" -name "*.md" -type f \
        ! -path "*/node_modules/*" \
        ! -path "*/.git/*" \
        ! -path "*/system-configs/.claude/agents/*.md" \
        -print0 | while IFS= read -r -d '' file; do

        # Add blank line before headings (except at start of file)
        if grep -n '^#' "$file" | grep -v '^1:' | head -1 | grep -q .; then
            apply_fix "Add blank lines before headings" "$file" \
                "sed -i '' '/^#/{ x; /^$/!{ s/^/\n/; }; x; }' '$file'"
        fi

        # Add blank line after headings
        if grep -Pzo '(?s)^#+[^\n]*\n(?!\n|\s*$)' "$file" >/dev/null 2>&1; then
            apply_fix "Add blank lines after headings" "$file" \
                "sed -i '' '/^#/{N; /\n[^[:space:]#]/s/\n/\n\n/;}' '$file'"
        fi
    done
}

# Function to fix blank lines around lists (MD032)
fix_list_spacing() {
    echo -e "${YELLOW}Fixing list spacing MD032...${NC}"

    find "$REPO_ROOT" -name "*.md" -type f \
        ! -path "*/node_modules/*" \
        ! -path "*/.git/*" \
        ! -path "*/system-configs/.claude/agents/*.md" \
        -print0 | while IFS= read -r -d '' file; do

        # This is a simplified fix - complex list detection would need more sophisticated parsing
        if grep -q '^[[:space:]]*[-*+][[:space:]]' "$file"; then
            # Add blank line before first list item if not already present
            apply_fix "Fix list spacing" "$file" \
                "sed -i '' '/^[[:space:]]*[-*+][[:space:]]/{x; /^$/!{s/^/\n/;}; x;}' '$file'"
        fi
    done
}

# Function to fix blank lines around fenced code blocks (MD031)
fix_code_block_spacing() {
    echo -e "${YELLOW}Fixing code block spacing MD031...${NC}"

    find "$REPO_ROOT" -name "*.md" -type f \
        ! -path "*/node_modules/*" \
        ! -path "*/.git/*" \
        ! -path "*/system-configs/.claude/agents/*.md" \
        -print0 | while IFS= read -r -d '' file; do

        # Add blank lines around fenced code blocks
        if grep -q '^```' "$file"; then
            apply_fix "Fix code block spacing" "$file" \
                "sed -i '' '/^```/{x; /^$/!{s/^/\n/;}; x;}' '$file'"
        fi
    done
}

# Function to add language specifiers to code blocks (MD040)
fix_code_block_languages() {
    echo -e "${YELLOW}Fixing code block language specifiers MD040...${NC}"

    find "$REPO_ROOT" -name "*.md" -type f \
        ! -path "*/node_modules/*" \
        ! -path "*/.git/*" \
        ! -path "*/system-configs/.claude/agents/*.md" \
        -print0 | while IFS= read -r -d '' file; do

        # Look for code blocks without language specifiers
        if grep -q '^```$' "$file"; then
            # Attempt to guess language based on context and filename
            local lang="text"

            # Check if it's likely shell/bash content
            if grep -A5 '^```$' "$file" | grep -q -E '(^[#$] |^npm |^git |^curl |^chmod |^mkdir |^cd )'; then
                lang="bash"
            # Check if it's JSON content
            elif grep -A3 '^```$' "$file" | grep -q -E '^\s*[{[]'; then
                lang="json"
            # Check if it's YAML content
            elif grep -A3 '^```$' "$file" | grep -q -E '^\s*[a-zA-Z_]+\s*:'; then
                lang="yaml"
            # Check if it's JavaScript/TypeScript
            elif grep -A5 '^```$' "$file" | grep -q -E '(function|const|let|var|import|export)'; then
                lang="javascript"
            fi

            apply_fix "Add language specifier: $lang" "$file" \
                "sed -i '' 's/^```$/```${lang}/' '$file'"
        fi
    done
}

# Function to ensure files end with newline (MD047)
fix_file_endings() {
    echo -e "${YELLOW}Fixing file endings MD047...${NC}"

    find "$REPO_ROOT" -name "*.md" -type f \
        ! -path "*/node_modules/*" \
        ! -path "*/.git/*" \
        ! -path "*/system-configs/.claude/agents/*.md" \
        -print0 | while IFS= read -r -d '' file; do

        # Check if file doesn't end with newline
        if [[ -s "$file" ]] && [[ "$(tail -c1 "$file" | wc -l)" -eq 0 ]]; then
            apply_fix "Add final newline" "$file" \
                "echo '' >> '$file'"
        fi
    done
}

# Function to fix emphasis used as headings (MD036)
fix_emphasis_headings() {
    echo -e "${YELLOW}Fixing emphasis used as headings MD036...${NC}"

    find "$REPO_ROOT" -name "*.md" -type f \
        ! -path "*/node_modules/*" \
        ! -path "*/.git/*" \
        ! -path "*/system-configs/.claude/agents/*.md" \
        -print0 | while IFS= read -r -d '' file; do

        # Look for standalone bold/italic text that should be headings
        # This is a conservative approach - only fixes obvious cases
        if grep -q '^\*\*[^*]\+\*\*$' "$file"; then
            apply_fix "Convert emphasis to headings" "$file" \
                "sed -i '' 's/^\*\*\([^*]\+\)\*\*$/### \1/' '$file'"
        fi
    done
}

# Function to fix table spacing (MD058)
fix_table_spacing() {
    echo -e "${YELLOW}Fixing table spacing MD058...${NC}"

    find "$REPO_ROOT" -name "*.md" -type f \
        ! -path "*/node_modules/*" \
        ! -path "*/.git/*" \
        ! -path "*/system-configs/.claude/agents/*.md" \
        -print0 | while IFS= read -r -d '' file; do

        # Add blank lines around tables
        if grep -q '|.*|' "$file"; then
            apply_fix "Fix table spacing" "$file" \
                "sed -i '' '/^|.*|/{x; /^$/!{s/^/\n/;}; x;}' '$file'"
        fi
    done
}

# Main execution
main() {
    local fix_mode="${1:-all}"

    case "$fix_mode" in
        "all")
            echo -e "${BLUE}Running all automatic fixes...${NC}"
            fix_trailing_spaces
            fix_file_endings
            fix_code_block_languages
            fix_heading_spacing
            fix_list_spacing
            fix_code_block_spacing
            fix_emphasis_headings
            fix_table_spacing
            ;;
        "trailing-spaces")
            fix_trailing_spaces
            ;;
        "headings")
            fix_heading_spacing
            ;;
        "lists")
            fix_list_spacing
            ;;
        "code-blocks")
            fix_code_block_spacing
            fix_code_block_languages
            ;;
        "file-endings")
            fix_file_endings
            ;;
        "emphasis")
            fix_emphasis_headings
            ;;
        "tables")
            fix_table_spacing
            ;;
        *)
            echo "Usage: $0 [all|trailing-spaces|headings|lists|code-blocks|file-endings|emphasis|tables]"
            echo
            echo "Available fix modes:"
            echo "  all             - Apply all automatic fixes default"
            echo "  trailing-spaces - Remove trailing whitespace MD009"
            echo "  headings        - Fix heading spacing MD022"
            echo "  lists           - Fix list spacing MD032"
            echo "  code-blocks     - Fix code block issues MD031, MD040"
            echo "  file-endings    - Ensure files end with newline MD047"
            echo "  emphasis        - Convert emphasis to headings MD036"
            echo "  tables          - Fix table spacing MD058"
            exit 1
            ;;
    esac

    echo
    echo -e "${BLUE}=== Remediation Summary ===${NC}"
    echo "Fixes applied: $fixes_applied"
    echo "Files modified: $files_modified"

    if [[ $fixes_applied -gt 0 ]]; then
        echo
        echo -e "${GREEN}✅ Automatic fixes completed!${NC}"
        echo "Run the following to validate results:"
        echo "  ./scripts/validate-markdown-quality.sh validate"
        echo
        echo "To commit the fixes:"
        echo "  git add ."
        echo "  git commit -m 'fix: apply automatic markdown quality fixes'"
    else
        echo -e "${YELLOW}ℹ️  No automatic fixes were applicable${NC}"
        echo "Manual review may be required for remaining violations."
    fi
}

# Execute main function
main "$@"
