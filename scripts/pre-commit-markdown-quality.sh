#!/bin/bash
# Pre-commit hook for markdown quality enforcement
# Prevents commits with markdown violations

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel)"
CONFIG_FILE="$REPO_ROOT/.markdownlint-cli2.jsonc"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}🔍 Running pre-commit markdown quality checks...${NC}"

# Get list of staged markdown files
staged_md_files=$(git diff --cached --name-only --diff-filter=ACM | grep '\.md$' | grep -v '^system-configs/.claude/agents/' || true)

if [[ -z "$staged_md_files" ]]; then
    echo -e "${GREEN}✅ No markdown files to check${NC}"
    exit 0
fi

echo "Checking staged markdown files:"
echo "$staged_md_files" | sed 's/^/  - /'
echo

# Create temporary directory for staged files
temp_dir=$(mktemp -d)
trap "rm -rf $temp_dir" EXIT

# Copy staged files to temp directory
for file in $staged_md_files; do
    if [[ -f "$file" ]]; then
        temp_file="$temp_dir/$file"
        mkdir -p "$(dirname "$temp_file")"
        git show ":$file" > "$temp_file"
    fi
done

# Run markdownlint on staged files
violations=0
violation_files=()

cd "$temp_dir"
for file in $staged_md_files; do
    if [[ -f "$file" ]]; then
        file_violations=$(npx markdownlint-cli2 "$file" --config "$CONFIG_FILE" 2>&1 | grep -c ":" || echo "0")
        if [[ $file_violations -gt 0 ]]; then
            violations=$((violations + file_violations))
            violation_files+=("$file")
        fi
    fi
done

cd "$REPO_ROOT"

# Report results
if [[ $violations -eq 0 ]]; then
    echo -e "${GREEN}✅ All staged markdown files pass quality checks${NC}"
    exit 0
else
    echo -e "${RED}❌ Found $violations markdown violations in ${#violation_files[@]} files${NC}"
    echo
    echo "Violating files:"
    for file in "${violation_files[@]}"; do
        echo -e "  ${RED}✗${NC} $file"
    done
    echo
    echo -e "${YELLOW}📋 To fix violations:${NC}"
    echo "  1. Run: ./scripts/validate-markdown-quality.sh fix"
    echo "  2. Review: ./scripts/validate-markdown-quality.sh validate"
    echo "  3. Stage your fixes: git add <files>"
    echo "  4. Commit again"
    echo
    echo -e "${YELLOW}💡 To bypass this check (not recommended):${NC}"
    echo "  git commit --no-verify"
    echo
    exit 1
fi