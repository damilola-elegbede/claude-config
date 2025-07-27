#!/bin/bash
# YAML Front-Matter Validation Script for Agent Files
# This script validates YAML front-matter in all agent markdown files

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_DIR="$SCRIPT_DIR"
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

echo "🔍 Validating YAML front-matter in agent files..."
echo "================================================"

# Check if we're in the right directory
if [ ! -d "$AGENTS_DIR" ]; then
    echo -e "${RED}Error: Cannot find agents directory at $AGENTS_DIR${NC}"
    exit 1
fi

# Function to validate YAML front-matter
validate_yaml() {
    local file="$1"
    local filename=$(basename "$file")
    local has_errors=false
    
    # Skip non-agent documentation files
    case "$filename" in
        AGENT_SELECTION_GUIDE.md|ENHANCEMENT_SUMMARY.md|PARALLEL_EXECUTION_GUIDE.md|\
        SECURITY_ACCESS_PATTERNS.md|TOOL_ACCESS_GUIDE.md|TOOL_ACCESS_STANDARDIZATION_SUMMARY.md|\
        YAML_*.md|AGENT_TEMPLATE.yaml)
            return 0
            ;;
    esac
    
    echo -n "Checking $filename... "
    
    # Check if file starts with ---
    if ! head -n 1 "$file" | grep -q "^---$"; then
        echo -e "${RED}✗ Missing opening YAML delimiter '---'${NC}"
        ((ERRORS++))
        return 1
    fi
    
    # Extract YAML front-matter
    local yaml_content=""
    local in_yaml=false
    local line_num=0
    local closing_found=false
    
    while IFS= read -r line; do
        ((line_num++))
        
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
        echo -e "${RED}✗ Missing closing YAML delimiter '---'${NC}"
        ((ERRORS++))
        return 1
    fi
    
    # Validate required fields
    if ! echo "$yaml_content" | grep -q "^name:"; then
        echo -e "${RED}✗ Missing required field: name${NC}"
        ((ERRORS++))
        has_errors=true
    fi
    
    if ! echo "$yaml_content" | grep -q "^description:"; then
        echo -e "${RED}✗ Missing required field: description${NC}"
        ((ERRORS++))
        has_errors=true
    fi
    
    # Check for multiline descriptions (warning only)
    if echo "$yaml_content" | grep -q "^description: |"; then
        echo -e "${YELLOW}⚠ Warning: Using multiline description (consider single-line format)${NC}"
        ((WARNINGS++))
    fi
    
    # Check description length
    desc_line=$(echo "$yaml_content" | grep "^description:" | head -1)
    if [ ${#desc_line} -gt 500 ]; then
        echo -e "${YELLOW}⚠ Warning: Very long description line (${#desc_line} chars)${NC}"
        ((WARNINGS++))
    fi
    
    # If no errors found
    if [ "$has_errors" = false ] && [ $WARNINGS -eq 0 ]; then
        echo -e "${GREEN}✓ Valid${NC}"
    fi
    
    return 0
}

# Check if specific file provided
if [ $# -eq 1 ]; then
    # Validate single file
    if [ -f "$1" ]; then
        validate_yaml "$1"
    else
        echo -e "${RED}Error: File not found: $1${NC}"
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
echo "  Files checked: $(ls -1 "$AGENTS_DIR"/*.md 2>/dev/null | wc -l)"
echo -e "  Errors: ${RED}$ERRORS${NC}"
echo -e "  Warnings: ${YELLOW}$WARNINGS${NC}"

if [ $ERRORS -gt 0 ]; then
    echo -e "\n${RED}❌ Validation failed with $ERRORS errors${NC}"
    exit 1
else
    echo -e "\n${GREEN}✅ All agent files have valid YAML front-matter${NC}"
    exit 0
fi