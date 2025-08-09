#!/bin/bash
# Test for /plan command

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test plan command file exists
test_plan_file_exists() {
    assert_file_exists "$ORIGINAL_DIR/.claude/commands/plan.md" \
        "Plan command file should exist"
}

# Test plan command structure
test_plan_structure() {
    local plan_file="$ORIGINAL_DIR/.claude/commands/plan.md"
    
    # Check required sections
    assert_file_contains "$plan_file" "# /plan Command" \
        "Should have command header"
    
    assert_file_contains "$plan_file" "## Description" \
        "Should have Description section"
    
    assert_file_contains "$plan_file" "## Usage" \
        "Should have Usage section"
    
    assert_file_contains "$plan_file" "## Behavior" \
        "Should have Behavior section"
    
    assert_file_contains "$plan_file" "## Approval Indicators" \
        "Should have Approval Indicators section"
}

# Test plan command content
test_plan_content() {
    local plan_file="$ORIGINAL_DIR/.claude/commands/plan.md"
    
    # Check for key behavior descriptions
    assert_file_contains "$plan_file" "comprehensive implementation plan" \
        "Should mention comprehensive planning"
    
    assert_file_contains "$plan_file" "Wait for explicit approval" \
        "Should mention waiting for approval"
    
    assert_file_contains "$plan_file" "Executive Summary" \
        "Should include plan template sections"
}

# Run all tests
echo "Testing /plan command..."

test_plan_file_exists || exit 1
test_plan_structure || exit 1
test_plan_content || exit 1

echo "All /plan command tests passed!"