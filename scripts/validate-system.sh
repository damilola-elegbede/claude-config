#!/bin/bash

# Comprehensive System Validation Script
# Ensures agent ecosystem integrity and robustness

set -euo pipefail

AGENTS_DIR=".claude/agents"
COMMANDS_DIR=".claude/commands"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Claude Configuration System Validator ===${NC}"
echo

# Track overall health
total_issues=0

# 1. Validate Agent YAML Structure
echo -e "${YELLOW}1. Validating Agent YAML Structure...${NC}"
agent_yaml_issues=0

for agent_file in "$AGENTS_DIR"/*.md; do
    basename_file=$(basename "$agent_file")
    # Skip non-agent files
    if [[ -f "$agent_file" ]] && [[ "$basename_file" != "README.md" ]] && [[ "$basename_file" != "AGENT_TEMPLATE.md" ]] && [[ "$basename_file" != "AGENT_CATEGORIES.md" ]] && [[ "$basename_file" != "AUDIT_VERIFICATION_PROTOCOL.md" ]]; then
        agent_name=$(basename "$agent_file" .md)

        # Check required fields
        if ! grep -q "^name: $agent_name$" "$agent_file"; then
            echo -e "${RED}❌ $agent_name: name field mismatch${NC}"
            ((agent_yaml_issues++))
        fi

        # Check all required fields exist
        for field in "description" "tools" "model" "color" "category"; do
            if ! grep -q "^$field:" "$agent_file"; then
                echo -e "${RED}❌ $agent_name: missing $field field${NC}"
                ((agent_yaml_issues++))
            fi
        done

        # Check SYSTEM BOUNDARY warning
        if ! grep -q "SYSTEM BOUNDARY:" "$agent_file"; then
            echo -e "${RED}❌ $agent_name: missing SYSTEM BOUNDARY warning${NC}"
            ((agent_yaml_issues++))
        fi

        # Check for Task tool usage
        if grep -q "tools:.*Task" "$agent_file"; then
            echo -e "${RED}❌ $agent_name: illegally references Task tool${NC}"
            ((agent_yaml_issues++))
        fi
    fi
done

if [[ $agent_yaml_issues -eq 0 ]]; then
    echo -e "${GREEN}✅ All agents have valid YAML structure${NC}"
else
    echo -e "${RED}Found $agent_yaml_issues YAML structure issues${NC}"
    ((total_issues+=agent_yaml_issues))
fi

# 2. Validate Category-Color Mapping
echo
echo -e "${YELLOW}2. Validating Category-Color Consistency...${NC}"
category_issues=0

# Define correct mappings using case statement instead
get_expected_color() {
    case "$1" in
        "development") echo "blue" ;;
        "infrastructure") echo "orange" ;;
        "quality") echo "green" ;;
        "security") echo "red" ;;
        "analysis") echo "yellow" ;;
        "architecture") echo "purple" ;;
        "design") echo "pink" ;;
        "operations") echo "cyan" ;;  # Operations and coordination
        *) echo "unknown" ;;
    esac
}

for agent_file in "$AGENTS_DIR"/*.md; do
    basename_file=$(basename "$agent_file")
    # Skip non-agent files
    if [[ -f "$agent_file" ]] && [[ "$basename_file" != "README.md" ]] && [[ "$basename_file" != "AGENT_TEMPLATE.md" ]] && [[ "$basename_file" != "AGENT_CATEGORIES.md" ]] && [[ "$basename_file" != "AUDIT_VERIFICATION_PROTOCOL.md" ]]; then
        agent_name=$(basename "$agent_file" .md)

        # Extract category and color (handles variable spacing)
        category=$(grep "^category:" "$agent_file" | awk -F: '{gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2}')
        color=$(grep "^color:" "$agent_file" | awk -F: '{gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2}')

        # Check mapping
        expected_color=$(get_expected_color "$category")
        if [[ "$color" != "$expected_color" ]]; then
            echo -e "${RED}❌ $agent_name: category '$category' should have color '$expected_color', found '$color'${NC}"
            ((category_issues++))
        fi
    fi
done

if [[ $category_issues -eq 0 ]]; then
    echo -e "${GREEN}✅ All agents have correct category-color mappings${NC}"
else
    echo -e "${RED}Found $category_issues category-color mismatches${NC}"
    ((total_issues+=category_issues))
fi

# 3. Validate Agent References
echo
echo -e "${YELLOW}3. Validating Agent References...${NC}"

# Run the agent reference validator
if ./scripts/validate-agent-references-v2.sh > /tmp/agent-ref-validation.log 2>&1; then
    echo -e "${GREEN}✅ All agent references are valid${NC}"
else
    ref_issues=$?
    echo -e "${RED}Found agent reference issues:${NC}"
    grep "❌" /tmp/agent-ref-validation.log || true
    ((total_issues+=ref_issues))
fi

# 4. Check for Duplicate Agents
echo
echo -e "${YELLOW}4. Checking for Duplicate Agent Names...${NC}"
duplicate_issues=0

agent_names=()
for agent_file in "$AGENTS_DIR"/*.md; do
    basename_file=$(basename "$agent_file")
    # Skip non-agent files
    if [[ -f "$agent_file" ]] && [[ "$basename_file" != "README.md" ]] && [[ "$basename_file" != "AGENT_TEMPLATE.md" ]] && [[ "$basename_file" != "AGENT_CATEGORIES.md" ]] && [[ "$basename_file" != "AUDIT_VERIFICATION_PROTOCOL.md" ]]; then
        agent_name=$(basename "$agent_file" .md)
        agent_names+=("$agent_name")
    fi
done

# Check for duplicates
if [[ ${#agent_names[@]} -gt 0 ]]; then
    duplicates=$(printf '%s\n' "${agent_names[@]}" | sort | uniq -d)
    if [[ -n "$duplicates" ]]; then
        while read -r dup; do
            echo -e "${RED}❌ Duplicate agent name: $dup${NC}"
            ((duplicate_issues++))
        done <<< "$duplicates"
    fi
fi

if [[ $duplicate_issues -eq 0 ]]; then
    echo -e "${GREEN}✅ No duplicate agent names found${NC}"
else
    ((total_issues+=duplicate_issues))
fi

# 5. Validate Command Structure
echo
echo -e "${YELLOW}5. Validating Command Structure...${NC}"
command_issues=0

for cmd_file in "$COMMANDS_DIR"/*.md; do
    if [[ -f "$cmd_file" ]]; then
        cmd_name=$(basename "$cmd_file" .md)

        # Check for basic structure
        if ! grep -q "^# /$cmd_name" "$cmd_file"; then
            echo -e "${RED}❌ $cmd_name: missing or incorrect command header${NC}"
            ((command_issues++))
        fi

        if ! grep -q "## Description" "$cmd_file"; then
            echo -e "${RED}❌ $cmd_name: missing Description section${NC}"
            ((command_issues++))
        fi

        if ! grep -q "## Usage" "$cmd_file"; then
            echo -e "${RED}❌ $cmd_name: missing Usage section${NC}"
            ((command_issues++))
        fi
    fi
done

if [[ $command_issues -eq 0 ]]; then
    echo -e "${GREEN}✅ All commands have valid structure${NC}"
else
    echo -e "${RED}Found $command_issues command structure issues${NC}"
    ((total_issues+=command_issues))
fi

# 6. Check Field Ordering Consistency
echo
echo -e "${YELLOW}6. Checking YAML Field Order Consistency...${NC}"
order_issues=0

# Expected order: name, description, tools, model, color, category
for agent_file in "$AGENTS_DIR"/*.md; do
    basename_file=$(basename "$agent_file")
    # Skip non-agent files
    if [[ -f "$agent_file" ]] && [[ "$basename_file" != "README.md" ]] && [[ "$basename_file" != "AGENT_TEMPLATE.md" ]] && [[ "$basename_file" != "AGENT_CATEGORIES.md" ]] && [[ "$basename_file" != "AUDIT_VERIFICATION_PROTOCOL.md" ]]; then
        agent_name=$(basename "$agent_file" .md)

        # Extract YAML section
        yaml_section=$(sed -n '/^---$/,/^---$/p' "$agent_file" | sed '1d;$d')

        # Check order
        expected_order="name description tools model color category"
        actual_order=$(echo "$yaml_section" | grep -E "^(name|description|tools|model|color|category):" | cut -d':' -f1 | tr '\n' ' ' | sed 's/ $//')

        if [[ "$actual_order" != "$expected_order" ]]; then
            echo -e "${YELLOW}⚠️  $agent_name: field order is '$actual_order' (expected: '$expected_order')${NC}"
            ((order_issues++))
        fi
    fi
done

if [[ $order_issues -eq 0 ]]; then
    echo -e "${GREEN}✅ All agents have consistent field ordering${NC}"
else
    echo -e "${YELLOW}Found $order_issues field ordering inconsistencies (non-critical)${NC}"
fi

# Summary
echo
echo -e "${BLUE}=== Validation Summary ===${NC}"
echo -e "Total agents validated: $(find "$AGENTS_DIR" -name "*.md" -type f ! -name "README.md" ! -name "AGENT_TEMPLATE.md" ! -name "AGENT_CATEGORIES.md" | wc -l)"
echo -e "Total commands validated: $(find "$COMMANDS_DIR" -name "*.md" -type f | wc -l)"
echo

if [[ $total_issues -eq 0 ]]; then
    echo -e "${GREEN}✅ System validation PASSED! All checks completed successfully.${NC}"
    exit 0
else
    echo -e "${RED}❌ System validation FAILED with $total_issues critical issues.${NC}"
    echo
    echo "Next steps:"
    echo "1. Fix category-color mismatches with provided sed commands"
    echo "2. Update agent references to use existing agents"
    echo "3. Add missing YAML fields and SYSTEM BOUNDARY warnings"
    echo "4. Remove any Task tool references from agents"
    exit 1
fi
