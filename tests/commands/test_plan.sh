#!/bin/bash
# Test for /plan command (Altoid style - simplified)

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

    # Check required sections (new template format)
    assert_file_contains "$plan_file" "## Usage" \
        "Should have Usage section"

    assert_file_contains "$plan_file" "## Description" \
        "Should have Description section"

    assert_file_contains "$plan_file" "## Expected Output" \
        "Should have Expected Output section"
}

# Test plan command content
test_plan_content() {
    local plan_file="$ORIGINAL_DIR/system-configs/.claude/commands/plan.md"

    # Check for key behavior descriptions (Altoid style)
    assert_file_contains "$plan_file" "PRD" \
        "Should mention PRD"

    assert_file_contains "$plan_file" "architect" \
        "Should mention architect agent"

    assert_file_contains "$plan_file" "task" \
        "Should mention tasks"
}

# Run all tests
echo "Testing /plan command..."

test_plan_file_exists || exit 1
test_plan_structure || exit 1
test_plan_content || exit 1

echo "All /plan command tests passed!"
