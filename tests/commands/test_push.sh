#!/bin/bash
# Test for /push command

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test push command file exists
test_push_file_exists() {
    assert_file_exists "$ORIGINAL_DIR/system-configs/.claude/skills/push/SKILL.md" \
        "Push command file should exist"
}

# Test push command structure
test_push_structure() {
    local push_file="$ORIGINAL_DIR/system-configs/.claude/skills/push/SKILL.md"

    # Check for YAML frontmatter
    assert_file_contains "$push_file" "^---" \
        "Should have YAML frontmatter start"

    assert_file_contains "$push_file" "description:" \
        "Should have description in frontmatter"

    # Check required sections (new template format)
    assert_file_contains "$push_file" "## Usage" \
        "Should have Usage section"

    assert_file_contains "$push_file" "## Description" \
        "Should have Description section"

    assert_file_contains "$push_file" "## Expected Output" \
        "Should have Expected Output section"
}

# Test push command content
test_push_content() {
    local push_file="$ORIGINAL_DIR/system-configs/.claude/skills/push/SKILL.md"

    # Check for key behavior descriptions
    assert_file_contains "$push_file" "git push" \
        "Should mention git push"

    assert_file_contains "$push_file" "branch" \
        "Should mention branch handling"

    assert_file_contains "$push_file" "Safely pushes" \
        "Should mention safe pushing"
}

# Run all tests
echo "Testing /push command..."

test_push_file_exists || exit 1
test_push_structure || exit 1
test_push_content || exit 1

echo "All /push command tests passed!"
