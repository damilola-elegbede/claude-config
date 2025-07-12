#!/bin/bash
# Test for /context command

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test context command file exists
test_context_file_exists() {
    assert_file_exists "$ORIGINAL_DIR/.claude/commands/context.md" \
        "Context command file should exist"
}

# Test context command structure
test_context_structure() {
    local context_file="$ORIGINAL_DIR/.claude/commands/context.md"
    
    # Check required sections
    assert_file_contains "$context_file" "# /context Command" \
        "Should have command header"
    
    assert_file_contains "$context_file" "## Description" \
        "Should have Description section"
    
    assert_file_contains "$context_file" "## Usage" \
        "Should have Usage section"
    
    assert_file_contains "$context_file" "## Behavior" \
        "Should have Behavior section"
    
    assert_file_contains "$context_file" "## Output Format" \
        "Should have Output Format section"
}

# Test context command content
test_context_content() {
    local context_file="$ORIGINAL_DIR/.claude/commands/context.md"
    
    # Check for key behavior descriptions
    assert_file_contains "$context_file" "analyzes and understands any repository" \
        "Should mention repository analysis"
    
    assert_file_contains "$context_file" "technology stack" \
        "Should mention tech stack detection"
    
    assert_file_contains "$context_file" "Auto-execution" \
        "Should mention auto-execution feature"
    
    assert_file_contains "$context_file" "package.json" \
        "Should include config file examples"
}

# Run all tests
echo "Testing /context command..."

test_context_file_exists || exit 1
test_context_structure || exit 1
test_context_content || exit 1

echo "All /context command tests passed!"