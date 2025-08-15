#!/bin/bash
# Emergency Markdown Quality Fix Script
# Comprehensive fix for all markdown violations

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

echo -e "${BLUE}=== Emergency Markdown Quality Fix ===${NC}"
echo "Repository: $REPO_ROOT"
echo

# Track fixes
total_files=0
fixed_files=0
code_block_fixes=0
indented_code_fixes=0
trailing_space_fixes=0

# Function to fix code blocks without language specifiers
fix_code_blocks() {
    local file="$1"
    local temp_file=$(mktemp)
    local fixed=false
    
    # Fix code blocks without language specifiers
    if grep -q '^```$' "$file"; then
        echo -e "${YELLOW}Fixing code blocks in: $file${NC}"
        
        # Use more sophisticated logic to add appropriate language
        while IFS= read -r line; do
            if [[ "$line" == '```' ]]; then
                # Look ahead to determine language
                local next_line=""
                if IFS= read -r next_line; then
                    if [[ "$next_line" =~ ^[[:space:]]*\{.*\}[[:space:]]*$ ]]; then
                        echo '```json' >> "$temp_file"
                        echo "$next_line" >> "$temp_file"
                    elif [[ "$next_line" =~ ^[[:space:]]*\<.*\>[[:space:]]*$ ]]; then
                        echo '```xml' >> "$temp_file"
                        echo "$next_line" >> "$temp_file"
                    elif [[ "$next_line" =~ ^[[:space:]]*#.*$ ]] || [[ "$next_line" =~ ^[[:space:]]*\$.*$ ]] || [[ "$next_line" =~ ^[[:space:]]*cd.*$ ]] || [[ "$next_line" =~ ^[[:space:]]*npm.*$ ]] || [[ "$next_line" =~ ^[[:space:]]*git.*$ ]]; then
                        echo '```bash' >> "$temp_file"
                        echo "$next_line" >> "$temp_file"
                    elif [[ "$next_line" =~ ^[[:space:]]*HTTP.*$ ]] || [[ "$next_line" =~ ^[[:space:]]*GET.*$ ]] || [[ "$next_line" =~ ^[[:space:]]*POST.*$ ]]; then
                        echo '```http' >> "$temp_file"
                        echo "$next_line" >> "$temp_file"
                    elif [[ "$next_line" =~ ^[[:space:]]*\-.*$ ]] || [[ "$next_line" =~ ^[[:space:]]*[0-9]+\..*$ ]]; then
                        echo '```text' >> "$temp_file"
                        echo "$next_line" >> "$temp_file"
                    elif [[ "$next_line" =~ ^[[:space:]]*console\.log.*$ ]] || [[ "$next_line" =~ ^[[:space:]]*function.*$ ]] || [[ "$next_line" =~ ^[[:space:]]*const.*$ ]]; then
                        echo '```javascript' >> "$temp_file"
                        echo "$next_line" >> "$temp_file"
                    elif [[ "$next_line" =~ ^[[:space:]]*def.*$ ]] || [[ "$next_line" =~ ^[[:space:]]*import.*$ ]] || [[ "$next_line" =~ ^[[:space:]]*from.*$ ]]; then
                        echo '```python' >> "$temp_file"
                        echo "$next_line" >> "$temp_file"
                    else
                        echo '```text' >> "$temp_file"
                        echo "$next_line" >> "$temp_file"
                    fi
                    fixed=true
                    ((code_block_fixes++))
                else
                    echo '```text' >> "$temp_file"
                fi
            else
                echo "$line" >> "$temp_file"
            fi
        done < "$file"
        
        if [[ "$fixed" = true ]]; then
            mv "$temp_file" "$file"
            ((fixed_files++))
        else
            rm -f "$temp_file"
        fi
    else
        rm -f "$temp_file"
    fi
}

# Function to fix indented code blocks
fix_indented_code() {
    local file="$1"
    local temp_file=$(mktemp)
    local in_indented_block=false
    local fixed=false
    
    while IFS= read -r line; do
        # Check for start of indented code block (4+ spaces at start, followed by code-like content)
        if [[ "$line" =~ ^[[:space:]]{4,}[a-zA-Z0-9#\$\{] ]] && [[ "$in_indented_block" = false ]]; then
            echo '```text' >> "$temp_file"
            echo "${line#    }" >> "$temp_file"  # Remove 4 spaces
            in_indented_block=true
            fixed=true
            ((indented_code_fixes++))
        # Continue indented block
        elif [[ "$line" =~ ^[[:space:]]{4,} ]] && [[ "$in_indented_block" = true ]]; then
            echo "${line#    }" >> "$temp_file"  # Remove 4 spaces
        # End of indented block
        elif [[ "$in_indented_block" = true ]] && [[ ! "$line" =~ ^[[:space:]]{4,} ]]; then
            echo '```' >> "$temp_file"
            echo "$line" >> "$temp_file"
            in_indented_block=false
        else
            echo "$line" >> "$temp_file"
        fi
    done < "$file"
    
    # Close any remaining block
    if [[ "$in_indented_block" = true ]]; then
        echo '```' >> "$temp_file"
    fi
    
    if [[ "$fixed" = true ]]; then
        mv "$temp_file" "$file"
        ((fixed_files++))
    else
        rm -f "$temp_file"
    fi
}

# Function to remove trailing spaces
fix_trailing_spaces() {
    local file="$1"
    
    if grep -q '[[:space:]]\+$' "$file"; then
        echo -e "${YELLOW}Removing trailing spaces from: $file${NC}"
        sed -i '' 's/[[:space:]]*$//' "$file"
        ((trailing_space_fixes++))
        ((fixed_files++))
    fi
}

# Main fix function
fix_file() {
    local file="$1"
    ((total_files++))
    
    # Skip ignored files
    case "$file" in
        */node_modules/*|*/.git/*|**/.tmp/*|**/CHANGELOG.md|*/system-configs/.claude/agents/*.md)
            return 0
            ;;
    esac
    
    echo "Processing: $file"
    
    # Apply fixes
    fix_trailing_spaces "$file"
    fix_code_blocks "$file"
    fix_indented_code "$file"
}

# Find and fix all markdown files
echo -e "${BLUE}Finding markdown files...${NC}"
find "$REPO_ROOT" -name "*.md" -type f \
    ! -path "*/node_modules/*" \
    ! -path "*/.git/*" \
    ! -path "**/.tmp/*" \
    ! -path "**/CHANGELOG.md" \
    ! -path "*/system-configs/.claude/agents/*.md" \
    | while read -r file; do
        fix_file "$file"
    done

echo
echo -e "${GREEN}=== Fix Summary ===${NC}"
echo "Total files processed: $total_files"
echo "Files with fixes: $fixed_files"
echo "Code block language fixes: $code_block_fixes"
echo "Indented code block fixes: $indented_code_fixes"
echo "Trailing space fixes: $trailing_space_fixes"
echo
echo -e "${GREEN}✅ Emergency markdown fixes completed!${NC}"