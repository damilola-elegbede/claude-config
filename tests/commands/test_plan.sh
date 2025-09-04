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

    # Check for YAML frontmatter
    assert_file_contains "$plan_file" "^---" \
        "Should have YAML frontmatter start"

    assert_file_contains "$plan_file" "description:" \
        "Should have description in frontmatter"

    # Check required sections (new format)
    assert_file_contains "$plan_file" "# Command Purpose" \
        "Should have Command Purpose header"

    assert_file_contains "$plan_file" "## Context" \
        "Should have Context section"

    assert_file_contains "$plan_file" "### Agent Orchestration" \
        "Should have Agent Orchestration subsection"
}

# Test plan command content
test_plan_content() {
    local plan_file="$ORIGINAL_DIR/system-configs/.claude/commands/plan.md"

    # Check for key behavior descriptions
    assert_file_contains "$plan_file" "phases" \
        "Should mention phases"

    assert_file_contains "$plan_file" "Phase Organization" \
        "Should have Phase Organization section"

    assert_file_contains "$plan_file" "dependencies" \
        "Should mention dependencies"
}

# Run all tests
echo "Testing /plan command..."

test_plan_file_exists || exit 1
test_plan_structure || exit 1
test_plan_content || exit 1

echo "All /plan command tests passed!"
