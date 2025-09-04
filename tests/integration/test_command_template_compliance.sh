#!/bin/bash
# Integration test for command template compliance validation
# Tests that command-audit functionality validates all commands against COMMAND_TEMPLATE.md

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test that all existing commands are validated against template requirements
test_existing_commands_template_compliance() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"
    local template_file="$ORIGINAL_DIR/docs/commands/COMMAND_TEMPLATE.md"
    local compliance_issues=0

    echo "  Checking all commands for template compliance..."

    # Ensure template exists
    if [ ! -f "$template_file" ]; then
        echo "    Error: COMMAND_TEMPLATE.md not found"
        return 1
    fi

    # Check each command file
    for cmd_file in "$commands_dir"/*.md; do
        [ -e "$cmd_file" ] || continue  # Skip if no .md files
        
        local cmd_name=$(basename "$cmd_file" .md)
        
        # Skip template and documentation files that shouldn't be validated
        if [[ "$cmd_name" == "README" || "$cmd_name" == "TEMPLATE" ]]; then
            continue
        fi

        echo "    Validating: $cmd_name.md"

        # Check if command follows new template format (has YAML frontmatter)
        if grep -q "^---$" "$cmd_file"; then
            # New template format validation
            local yaml_content=$(sed -n '/^---$/,/^---$/p' "$cmd_file" | sed '1d;$d')
            
            # Required: description field
            if ! echo "$yaml_content" | grep -q "^description:"; then
                echo "      ❌ Missing required 'description' field"
                compliance_issues=$((compliance_issues + 1))
            else
                # Check description length for autocomplete
                local desc=$(echo "$yaml_content" | grep "^description:" | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/[ \t]*$//')
                local desc_length=$(echo -n "$desc" | wc -c)
                if [ "$desc_length" -gt 60 ]; then
                    echo "      ⚠️  Description too long ($desc_length chars > 60)"
                fi
                echo "      ✅ Valid description: $desc"
            fi

            # Optional: argument-hint format validation
            if echo "$yaml_content" | grep -q "^argument-hint:"; then
                local hint=$(echo "$yaml_content" | grep "^argument-hint:" | cut -d':' -f2- | sed 's/^[ \t]*//')
                if [[ "$hint" =~ ^\[.*\]$ ]]; then
                    echo "      ✅ Valid argument-hint: $hint"
                else
                    echo "      ❌ Invalid argument-hint format (should use [brackets]): $hint"
                    compliance_issues=$((compliance_issues + 1))
                fi
            fi

            # Content structure validation
            local content_after_frontmatter=$(sed -n '/^---$/,/^---$/!p' "$cmd_file")
            
            # Should have main heading after frontmatter
            if ! echo "$content_after_frontmatter" | grep -q "^# "; then
                echo "      ⚠️  Consider adding main heading after frontmatter"
            fi

            # Check for expected template sections
            if grep -q "## Context" "$cmd_file"; then
                echo "      ✅ Has Context section"
            fi
            
            if grep -q "## Expected Output" "$cmd_file"; then
                echo "      ✅ Has Expected Output section"
            fi

        else
            # Legacy format - check basic structure
            echo "      ℹ️  Using legacy format (no YAML frontmatter)"
            
            # Check for basic documentation sections
            if ! grep -q "^# " "$cmd_file"; then
                echo "      ❌ Missing main heading"
                compliance_issues=$((compliance_issues + 1))
            fi
        fi

        # Universal validation (applies to all formats)
        
        # Check for code blocks (should have language tags)
        local code_blocks=$(grep -n '^```$' "$cmd_file" | wc -l)
        local tagged_blocks=$(grep -n '^```[a-z]' "$cmd_file" | wc -l)
        if [ "$code_blocks" -gt 0 ] && [ "$tagged_blocks" -lt "$code_blocks" ]; then
            echo "      ⚠️  Some code blocks missing language tags"
        fi

        # Check file size (should be reasonable)
        local line_count=$(wc -l < "$cmd_file")
        if [ "$line_count" -gt 400 ]; then
            echo "      ⚠️  Large command file ($line_count lines > 400)"
        fi

        echo
    done

    if [ $compliance_issues -eq 0 ]; then
        echo "  ✅ All commands pass template compliance checks"
        return 0
    else
        echo "  ❌ Found $compliance_issues template compliance issues"
        return 1
    fi
}

# Test that command-audit command itself is properly implemented
test_command_audit_implementation() {
    local audit_file="$ORIGINAL_DIR/system-configs/.claude/commands/command-audit.md"

    echo "  Validating command-audit implementation..."

    # Ensure command-audit exists
    if [ ! -f "$audit_file" ]; then
        echo "    ❌ command-audit.md not found"
        return 1
    fi

    # Command-audit should follow its own template requirements
    if grep -q "^---$" "$audit_file"; then
        local yaml_content=$(sed -n '/^---$/,/^---$/p' "$audit_file" | sed '1d;$d')
        
        if ! echo "$yaml_content" | grep -q "^description:"; then
            echo "    ❌ command-audit missing required description field"
            return 1
        fi
        
        echo "    ✅ command-audit follows template format"
    else
        echo "    ⚠️  command-audit uses legacy format"
    fi

    # Verify command-audit contains validation logic for template compliance
    local required_validations=(
        "COMMAND_TEMPLATE.md"
        "frontmatter"
        "description.*field"
        "YAML"
        "Template Compliance"
    )

    for validation in "${required_validations[@]}"; do
        if grep -q "$validation" "$audit_file"; then
            echo "    ✅ Includes $validation validation"
        else
            echo "    ❌ Missing $validation validation"
            return 1
        fi
    done

    return 0
}

# Test that the validation logic handles edge cases correctly
test_validation_edge_cases() {
    setup_test_env
    
    local test_commands_dir="$TEST_DIR/commands"
    mkdir -p "$test_commands_dir"

    echo "  Testing validation edge cases..."

    # Edge case 1: Empty frontmatter
    cat > "$test_commands_dir/empty-frontmatter.md" << 'EOF'
---
---

# Command with empty frontmatter
Should fail validation.
EOF

    # Edge case 2: Malformed YAML
    cat > "$test_commands_dir/malformed-yaml.md" << 'EOF'
---
description: Valid description
argument-hint [missing colon]
---

# Malformed YAML Command
Has syntax error in YAML.
EOF

    # Edge case 3: Very long description
    cat > "$test_commands_dir/long-description.md" << 'EOF'
---
description: This is a very long description that exceeds the sixty character limit for autocomplete compatibility
---

# Long Description Command
Tests length validation.
EOF

    # Edge case 4: Perfect template compliance
    cat > "$test_commands_dir/perfect-command.md" << 'EOF'
---
description: Perfect template compliant command
argument-hint: [file-path]
---

# Perfect Command Purpose
This command follows the template exactly.

## Context
Clear context and guidelines.

## Expected Output
Well-defined output expectations using $ARGUMENTS placeholder.
EOF

    # Simulate validation logic
    local valid_commands=0
    local invalid_commands=0

    for cmd_file in "$test_commands_dir"/*.md; do
        local cmd_name=$(basename "$cmd_file" .md)
        local is_valid=true

        if grep -q "^---$" "$cmd_file"; then
            local yaml_content=$(sed -n '/^---$/,/^---$/p' "$cmd_file" | sed '1d;$d')
            
            # Check for empty frontmatter
            if [ -z "$(echo "$yaml_content" | tr -d '[:space:]')" ]; then
                echo "    ❌ $cmd_name: Empty frontmatter"
                is_valid=false
            fi
            
            # Check required description
            if ! echo "$yaml_content" | grep -q "^description:"; then
                echo "    ❌ $cmd_name: Missing description field"
                is_valid=false
            else
                # Check description length
                local desc_length=$(echo "$yaml_content" | grep "^description:" | cut -d':' -f2- | sed 's/^[ \t]*//' | wc -c)
                if [ "$desc_length" -gt 60 ]; then
                    echo "    ⚠️  $cmd_name: Description too long"
                fi
            fi
            
            # Check YAML syntax
            if ! echo "$yaml_content" | grep -qE '^[a-zA-Z-]+:'; then
                echo "    ❌ $cmd_name: Invalid YAML syntax"
                is_valid=false
            fi
        fi

        if [ "$is_valid" = true ]; then
            valid_commands=$((valid_commands + 1))
            echo "    ✅ $cmd_name: Valid"
        else
            invalid_commands=$((invalid_commands + 1))
        fi
    done

    echo "    Results: $valid_commands valid, $invalid_commands invalid commands"

    cleanup_test_env

    # Should find exactly 1 valid command (perfect-command)
    if [ "$valid_commands" -eq 1 ] && [ "$invalid_commands" -eq 3 ]; then
        echo "    ✅ Edge case validation working correctly"
        return 0
    else
        echo "    ❌ Edge case validation failed"
        return 1
    fi
}

# Test that command-audit can identify and report all validation categories
test_validation_categories() {
    local audit_file="$ORIGINAL_DIR/system-configs/.claude/commands/command-audit.md"

    echo "  Checking validation categories coverage..."

    local expected_categories=(
        "Template Compliance"
        "Frontmatter"
        "Content Quality"
        "Agent Specification"
        "Parallel\|Parallelization"
        "Markdown Quality"
    )

    for category in "${expected_categories[@]}"; do
        if grep -q "$category" "$audit_file"; then
            echo "    ✅ Covers $category validation"
        else
            echo "    ❌ Missing $category validation"
            return 1
        fi
    done

    # Check for comprehensive audit reporting
    if grep -q "Status Matrix\|Executive Summary" "$audit_file"; then
        echo "    ✅ Includes comprehensive reporting"
    else
        echo "    ❌ Missing comprehensive reporting"
        return 1
    fi

    return 0
}

# Run all template compliance integration tests
echo "Testing command template compliance integration..."

test_existing_commands_template_compliance || exit 1
test_command_audit_implementation || exit 1
test_validation_edge_cases || exit 1
test_validation_categories || exit 1

echo "All command template compliance tests passed!"