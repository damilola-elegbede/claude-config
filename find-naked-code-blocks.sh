#!/bin/bash
# Find naked code blocks (``` without language specifier)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${YELLOW}Finding naked code blocks (``` without language specifier)...${NC}"
echo

# Find all markdown files and check for naked code blocks
find . -name "*.md" -type f \
    ! -path "*/node_modules/*" \
    ! -path "*/.git/*" \
    ! -path "*/system-configs/.claude/agents/*.md" \
    -exec grep -l '^```$' {} \; | while read file; do
    
    echo -e "${RED}File: $file${NC}"
    
    # Show lines with naked code blocks with context
    grep -n -B2 -A2 '^```$' "$file" | head -20
    echo
done