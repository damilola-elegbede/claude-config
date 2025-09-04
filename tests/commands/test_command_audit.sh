#!/bin/bash
# Test for command-audit functionality and template compliance validation

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test command-audit exists and has proper structure
test_command_audit_exists() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"
    local audit_file="$commands_dir/command-audit.md"

    assert_file_exists "$audit_file" \
        "command-audit.md should exist"

    # Check it has YAML frontmatter
    assert_file_contains "$audit_file" "^---$" \
        "command-audit should have YAML frontmatter"

    # Check for required description field
    assert_file_contains "$audit_file" "^description:" \
        "command-audit should have description field"

    return 0
}

# Test command-audit validates COMMAND_TEMPLATE.md format
test_command_audit_template_validation() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"
    local audit_file="$commands_dir/command-audit.md"

    # Check that it references the template file
    assert_file_contains "$audit_file" "COMMAND_TEMPLATE.md" \
        "command-audit should reference COMMAND_TEMPLATE.md"

    # Check that it validates frontmatter structure
    assert_file_contains "$audit_file" "Frontmatter Structure" \
        "command-audit should validate frontmatter structure"

    # Check that it validates required description field
    assert_file_contains "$audit_file" "required.*description.*field\|description.*field.*required" \
        "command-audit should validate required description field"

    # Check that it validates argument-hint format
    assert_file_contains "$audit_file" "argument-hint" \
        "command-audit should validate argument-hint format"

    return 0
}

# Test command-audit validates YAML syntax
test_command_audit_yaml_validation() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"
    local audit_file="$commands_dir/command-audit.md"

    # Check for YAML validation logic
    assert_file_contains "$audit_file" "YAML.*frontmatter\|frontmatter.*YAML" \
        "command-audit should validate YAML frontmatter"

    # Check for proper YAML syntax validation
    assert_file_contains "$audit_file" "YAML.*syntax\|syntax.*YAML" \
        "command-audit should validate YAML syntax"

    # Check for delimiter validation
    assert_file_contains "$audit_file" "delimiter" \
        "command-audit should validate YAML delimiters"

    return 0
}

# Test command-audit checks description field requirements
test_command_audit_description_validation() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"
    local audit_file="$commands_dir/command-audit.md"

    # Check for description length validation (60 char limit)
    assert_file_contains "$audit_file" "60.*char\|character.*60" \
        "command-audit should validate description length limit"

    # Check for autocomplete compatibility mention
    assert_file_contains "$audit_file" "autocomplete" \
        "command-audit should mention autocomplete compatibility"

    return 0
}

# Test command-audit validates argument-hint format
test_command_audit_argument_hint_validation() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"
    local audit_file="$commands_dir/command-audit.md"

    # Check for bracket format validation
    assert_file_contains "$audit_file" "\[.*\]" \
        "command-audit should validate bracket format for argument-hint"

    # Check for $ARGUMENTS placeholder validation (may not be present in this command)
    if grep -q "argument-hint" "$audit_file" && ! grep -q "\$ARGUMENTS" "$audit_file"; then
        echo "    Info: command-audit mentions argument-hint but doesn't use \$ARGUMENTS placeholder"
    fi

    return 0
}

# Test command-audit provides comprehensive validation framework
test_command_audit_validation_framework() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"
    local audit_file="$commands_dir/command-audit.md"

    # Check for validation categories
    assert_file_contains "$audit_file" "Template Compliance\|Frontmatter.*Valid\|Content Quality" \
        "command-audit should define validation categories"

    # Check for success criteria
    assert_file_contains "$audit_file" "Success Criteria\|✅.*Template Compliance" \
        "command-audit should define success criteria"

    # Check for validation process
    assert_file_contains "$audit_file" "Validation.*Process\|Process.*Validation" \
        "command-audit should define validation process"

    return 0
}

# Test command-audit includes agent specification validation
test_command_audit_agent_validation() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"
    local audit_file="$commands_dir/command-audit.md"

    # Check for agent validation
    assert_file_contains "$audit_file" "Agent.*Specification\|Specification.*Agent" \
        "command-audit should validate agent specifications"

    # Check for 28 production agents reference
    assert_file_contains "$audit_file" "28.*agent\|agent.*28" \
        "command-audit should reference 28 production agents"

    # Check for security-auditor validation for critical operations
    assert_file_contains "$audit_file" "security-auditor" \
        "command-audit should validate security-auditor usage"

    return 0
}

# Test template file exists
test_template_file_exists() {
    local template_file="$ORIGINAL_DIR/docs/commands/COMMAND_TEMPLATE.md"

    assert_file_exists "$template_file" \
        "COMMAND_TEMPLATE.md should exist"

    # Check template has required structure documentation
    assert_file_contains "$template_file" "Required.*Fields\|Frontmatter.*Fields" \
        "template should document required fields"

    # Check template shows description field requirement
    assert_file_contains "$template_file" "Required.*Fields" \
        "template should specify required fields section"
    
    assert_file_contains "$template_file" "description.*:" \
        "template should document description field"

    # Check template shows argument-hint as optional
    assert_file_contains "$template_file" "argument-hint.*optional\|optional.*argument-hint" \
        "template should specify argument-hint as optional"

    return 0
}

# Create mock command files for testing validation logic
test_validation_with_mock_files() {
    setup_test_env
    
    local test_commands_dir="$TEST_DIR/commands"
    mkdir -p "$test_commands_dir"

    # Create valid command with proper frontmatter
    cat > "$test_commands_dir/valid-command.md" << 'EOF'
---
description: A valid command with proper frontmatter
argument-hint: [optional-arg]
---

# Valid Command Purpose
This is a properly formatted command.

## Context
Clear context provided.

## Expected Output
Well-defined output expectations.
EOF

    # Create invalid command missing description
    cat > "$test_commands_dir/invalid-command.md" << 'EOF'
---
argument-hint: [arg]
---

# Invalid Command
Missing required description field.
EOF

    # Create command with invalid argument-hint format
    cat > "$test_commands_dir/bad-hint-command.md" << 'EOF'
---
description: Command with bad argument hint
argument-hint: arg-without-brackets
---

# Bad Hint Command
Uses invalid argument-hint format.
EOF

    # Test validation logic manually (simulating what command-audit should do)
    local valid_count=0
    local invalid_count=0

    for cmd_file in "$test_commands_dir"/*.md; do
        local cmd_name=$(basename "$cmd_file" .md)
        
        if grep -q "^---$" "$cmd_file"; then
            local yaml_content=$(sed -n '/^---$/,/^---$/p' "$cmd_file" | sed '1d;$d')
            
            # Check for required description field
            if echo "$yaml_content" | grep -q "^description:"; then
                # Check argument-hint format if present
                if echo "$yaml_content" | grep -q "^argument-hint:"; then
                    if echo "$yaml_content" | grep -q "argument-hint:.*\[.*\]"; then
                        valid_count=$((valid_count + 1))
                    else
                        echo "Invalid argument-hint format in $cmd_name"
                        invalid_count=$((invalid_count + 1))
                    fi
                else
                    valid_count=$((valid_count + 1))
                fi
            else
                echo "Missing required description field in $cmd_name"
                invalid_count=$((invalid_count + 1))
            fi
        fi
    done

    # Verify our test logic works correctly
    assert_equals 1 "$valid_count" "Should find 1 valid command"
    assert_equals 2 "$invalid_count" "Should find 2 invalid commands"

    cleanup_test_env
    return 0
}

# Run all command-audit specific tests
echo "Testing command-audit functionality..."

test_command_audit_exists || exit 1
test_command_audit_template_validation || exit 1
test_command_audit_yaml_validation || exit 1
test_command_audit_description_validation || exit 1
test_command_audit_argument_hint_validation || exit 1
test_command_audit_validation_framework || exit 1
test_command_audit_agent_validation || exit 1
test_template_file_exists || exit 1
test_validation_with_mock_files || exit 1

echo "All command-audit tests passed!"