#!/bin/bash
# Test for /commit command

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test commit command file exists
test_commit_file_exists() {
    assert_file_exists "$ORIGINAL_DIR/system-configs/.claude/skills/commit/SKILL.md" \
        "Commit command file should exist"
}

# Test commit command structure
test_commit_structure() {
    local commit_file="$ORIGINAL_DIR/system-configs/.claude/skills/commit/SKILL.md"

    # Check for YAML frontmatter
    assert_file_contains "$commit_file" "^---" \
        "Should have YAML frontmatter start"

    assert_file_contains "$commit_file" "description:" \
        "Should have description in frontmatter"

    # Check required sections (new template format)
    assert_file_contains "$commit_file" "## Usage" \
        "Should have Usage section"

    assert_file_contains "$commit_file" "## Description" \
        "Should have Description section"

    assert_file_contains "$commit_file" "## Expected Output" \
        "Should have Expected Output section"
}

# Test commit command content
test_commit_content() {
    local commit_file="$ORIGINAL_DIR/system-configs/.claude/skills/commit/SKILL.md"

    # Check for key behavior descriptions
    assert_file_contains "$commit_file" "git commit" \
        "Should mention git commit"

    assert_file_contains "$commit_file" "Co-Authored-By: Claude" \
        "Should include co-authorship"

    assert_file_contains "$commit_file" "conventional commit format" \
        "Should mention conventional commits"
}

# Run all tests
echo "Testing /commit command..."

test_commit_file_exists || exit 1
test_commit_structure || exit 1
test_commit_content || exit 1

echo "All /commit command tests passed!"
