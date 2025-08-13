#!/bin/bash
# Test for command file validation

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test all command files exist
test_all_commands_exist() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"
    
    assert_dir_exists "$commands_dir" \
        "Commands directory should exist"
    
    # Check each command file
    local expected_commands=("plan" "commit" "push" "test" "context" "sync")
    
    for cmd in "${expected_commands[@]}"; do
        assert_file_exists "$commands_dir/${cmd}.md" \
            "Command file ${cmd}.md should exist"
    done
}

# Test command file structure
test_command_structure() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"
    
    # Test each command file has proper structure
    for cmd_file in "$commands_dir"/*.md; do
        local cmd_name=$(basename "$cmd_file" .md)
        
        # Check for command header
        assert_file_contains "$cmd_file" "# /${cmd_name} Command" \
            "${cmd_name}: Should have proper command header"
        
        # Check for required sections
        assert_file_contains "$cmd_file" "## Description" \
            "${cmd_name}: Should have Description section"
        
        assert_file_contains "$cmd_file" "## Usage" \
            "${cmd_name}: Should have Usage section"
        
        # Check for usage example
        assert_file_contains "$cmd_file" "\`\`\`" \
            "${cmd_name}: Should have code block for usage"
    done
}

# Test specific command requirements
test_command_specifics() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"
    
    # Test /test command has generation templates
    assert_file_contains "$commands_dir/test.md" "## Test Generation Templates" \
        "/test command should have generation templates"
    
    # Test /sync command mentions it's repo-specific
    assert_file_contains "$commands_dir/sync.md" "Repository-specific command" \
        "/sync command should mention it's repo-specific"
    
    # Test /plan command has approval workflow
    assert_file_contains "$commands_dir/plan.md" "## Approval Indicators" \
        "/plan command should have approval indicators"
    
    # Test /context command has output format
    assert_file_contains "$commands_dir/context.md" "## Output Format" \
        "/context command should have output format"
}

# Test no missing documentation
test_documentation_completeness() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"
    
    for cmd_file in "$commands_dir"/*.md; do
        local cmd_name=$(basename "$cmd_file" .md)
        
        # Check file is not empty
        if [ ! -s "$cmd_file" ]; then
            echo "Command file ${cmd_name}.md is empty"
            return 1
        fi
        
        # Check for behavior section
        assert_file_contains "$cmd_file" "## Behavior" \
            "${cmd_name}: Should have Behavior section"
    done
}

# Run all tests
echo "Testing command file validation..."

test_all_commands_exist || exit 1
test_command_structure || exit 1
test_command_specifics || exit 1
test_documentation_completeness || exit 1

echo "All command file validation tests passed!"