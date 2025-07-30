#!/bin/bash
# YAML Front-Matter Validation Script for Agent Files
# This script validates YAML front-matter in all agent markdown files

# set -e removed to allow processing all files even on errors

# Debug mode for CI
if [ -n "$CI" ]; then
    echo "Running in CI environment"
    set -x  # Enable command tracing in CI
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo "$(dirname "$SCRIPT_DIR")")"
AGENTS_DIR="$REPO_ROOT/.claude/agents"
ERRORS=0
WARNINGS=0

# Color codes for output
# Detect if we're in a CI environment or if output is not a terminal
if [ -n "$CI" ] || [ ! -t 1 ]; then
    RED=''
    GREEN=''
    YELLOW=''
    NC=''
else
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    NC='\033[0m' # No Color
fi

echo "Validating YAML front-matter in agent files..."
echo "================================================"

# Check if we're in the right directory
if [ ! -d "$AGENTS_DIR" ]; then
    printf "${RED}Error: Cannot find agents directory at %s${NC}\n" "$AGENTS_DIR"
    exit 1
fi

# Function to validate YAML front-matter
validate_yaml() {
    local file="$1"
    local filename=$(basename "$file")
    local has_errors=false
    
    # Skip non-agent documentation files
    case "$filename" in
        README.md|AGENT_SELECTION_GUIDE.md|ENHANCEMENT_SUMMARY.md|PARALLEL_EXECUTION_GUIDE.md|\
        SECURITY_ACCESS_PATTERNS.md|TOOL_ACCESS_GUIDE.md|TOOL_ACCESS_STANDARDIZATION_SUMMARY.md|\
        YAML_*.md|AGENT_TEMPLATE.md|AGENT_CATEGORIES.md|AUDIT_VERIFICATION_PROTOCOL.md)
            return 0
            ;;
    esac
    
    echo -n "Checking $filename... "
    local warnings_in_file=0
    
    # Check if file starts with ---
    if ! head -n 1 "$file" | grep -q "^---$"; then
        printf "${RED}ERROR: Missing opening YAML delimiter '---'${NC}\n"
        ERRORS=$((ERRORS + 1))
        has_errors=true
    fi
    
    # Extract YAML front-matter
    local yaml_content=""
    local in_yaml=false
    local line_num=0
    local closing_found=false
    
    while IFS= read -r line; do
        line_num=$((line_num + 1))
        
        if [ $line_num -eq 1 ] && [ "$line" = "---" ]; then
            in_yaml=true
            continue
        fi
        
        if [ "$in_yaml" = true ] && [ "$line" = "---" ]; then
            closing_found=true
            break
        fi
        
        if [ "$in_yaml" = true ]; then
            yaml_content+="$line"$'\n'
        fi
    done < "$file"
    
    if [ "$closing_found" = false ]; then
        printf "${RED}ERROR: Missing closing YAML delimiter '---'${NC}\n"
        ERRORS=$((ERRORS + 1))
        has_errors=true
    fi
    
    # Validate required fields
    if ! echo "$yaml_content" | grep -q "^name:"; then
        printf "${RED}ERROR: Missing required field: name${NC}\n"
        ERRORS=$((ERRORS + 1))
        has_errors=true
    fi
    
    if ! echo "$yaml_content" | grep -q "^description:"; then
        printf "${RED}ERROR: Missing required field: description${NC}\n"
        ERRORS=$((ERRORS + 1))
        has_errors=true
    fi
    
    # Check for multiline descriptions (warning only)
    if echo "$yaml_content" | grep -q "^description: |"; then
        printf "${YELLOW}WARNING: Using multiline description (consider single-line format)${NC}\n"
        WARNINGS=$((WARNINGS + 1))
        warnings_in_file=$((warnings_in_file + 1))
    fi
    
    # Check description length
    desc_line=$(echo "$yaml_content" | grep "^description:" | head -1)
    if [ ${#desc_line} -gt 500 ]; then
        printf "${YELLOW}WARNING: Very long description line (%d chars)${NC}\n" "${#desc_line}"
        WARNINGS=$((WARNINGS + 1))
        warnings_in_file=$((warnings_in_file + 1))
    fi
    
    # If no errors found
    if [ "$has_errors" = false ] && [ $warnings_in_file -eq 0 ]; then
        printf "${GREEN}VALID${NC}\n"
    fi
    
    return 0
}

# Check if specific file provided
if [ $# -eq 1 ]; then
    # Validate single file
    if [ -f "$1" ]; then
        validate_yaml "$1"
    else
        printf "${RED}Error: File not found: %s${NC}\n" "$1"
        exit 1
    fi
else
    # Process all .md files
    for file in "$AGENTS_DIR"/*.md; do
        if [ -f "$file" ]; then
            validate_yaml "$file"
        fi
    done
fi

echo ""
echo "================================================"
echo "Validation Summary:"
# Use tr to remove leading/trailing whitespace from wc output
FILE_COUNT=$(ls -1 "$AGENTS_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
echo "  Files checked: $FILE_COUNT"
printf "  Errors: ${RED}%d${NC}\n" "$ERRORS"
printf "  Warnings: ${YELLOW}%d${NC}\n" "$WARNINGS"

if [ $ERRORS -gt 0 ]; then
    printf "\n${RED}FAILED: Validation failed with %d errors${NC}\n" "$ERRORS"
    exit 1
else
    printf "\n${GREEN}SUCCESS: All agent files have valid YAML front-matter${NC}\n"
    exit 0
fi