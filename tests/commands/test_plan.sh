#!/bin/bash
# Test for /plan skill (migrated from command)

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test plan skill file exists
test_plan_file_exists() {
    assert_file_exists "$ORIGINAL_DIR/system-configs/.claude/skills/plan/SKILL.md" \
        "Plan skill file should exist"
}

# Test plan skill structure
test_plan_structure() {
    local plan_file="$ORIGINAL_DIR/system-configs/.claude/skills/plan/SKILL.md"

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

# Test plan skill content
test_plan_content() {
    local plan_file="$ORIGINAL_DIR/system-configs/.claude/skills/plan/SKILL.md"

    # Check for key behavior descriptions
    assert_file_contains "$plan_file" "PRD" \
        "Should mention PRD"

    assert_file_contains "$plan_file" "architect" \
        "Should mention architect agent"

    assert_file_contains "$plan_file" "task" \
        "Should mention tasks"
}

# Run all tests
echo "Testing /plan skill..."

test_plan_file_exists || exit 1
test_plan_structure || exit 1
test_plan_content || exit 1

echo "All /plan skill tests passed!"
