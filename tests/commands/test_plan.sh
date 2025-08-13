#!/bin/bash
# Test for /plan command

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test plan command file exists
test_plan_file_exists() {
    assert_file_exists "$ORIGINAL_DIR/system-configs/.claude/commands/plan.md" \
        "Plan command file should exist"
}

# Test plan command structure
test_plan_structure() {
    local plan_file="$ORIGINAL_DIR/system-configs/.claude/commands/plan.md"
    
    # Check required sections
    assert_file_contains "$plan_file" "# /plan Command" \
        "Should have command header"
    
    assert_file_contains "$plan_file" "## Description" \
        "Should have Description section"
    
    assert_file_contains "$plan_file" "## Usage" \
        "Should have Usage section"
    
    assert_file_contains "$plan_file" "## Command Execution Flow" \
        "Should have Command Execution Flow section"
    
    assert_file_contains "$plan_file" "## Strategic Plan Format" \
        "Should have Strategic Plan Format section"
}

# Test plan command content
test_plan_content() {
    local plan_file="$ORIGINAL_DIR/system-configs/.claude/commands/plan.md"
    
    # Check for key behavior descriptions
    assert_file_contains "$plan_file" "TDD methodology" \
        "Should mention TDD methodology"
    
    assert_file_contains "$plan_file" "phased implementation" \
        "Should mention phased implementation"
    
    assert_file_contains "$plan_file" "Executive Summary" \
        "Should include plan template sections"
}

# Run all tests
echo "Testing /plan command..."

test_plan_file_exists || exit 1
test_plan_structure || exit 1
test_plan_content || exit 1

echo "All /plan command tests passed!"