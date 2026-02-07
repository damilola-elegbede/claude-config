#!/bin/bash
# Test for /test command

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test test command file exists
test_test_file_exists() {
    assert_file_exists "$ORIGINAL_DIR/system-configs/.claude/skills/test/SKILL.md" \
        "Test command file should exist"
}

# Test test command structure
test_test_structure() {
    local test_file="$ORIGINAL_DIR/system-configs/.claude/skills/test/SKILL.md"

    # Check for YAML frontmatter
    assert_file_contains "$test_file" "^---" \
        "Should have YAML frontmatter start"

    assert_file_contains "$test_file" "description:" \
        "Should have description in frontmatter"

    # Check required sections (new template format)
    assert_file_contains "$test_file" "## Usage" \
        "Should have Usage section"

    assert_file_contains "$test_file" "## Description" \
        "Should have Description section"

    assert_file_contains "$test_file" "## Expected Output" \
        "Should have Expected Output section"
}

# Test test command content
test_test_content() {
    local test_file="$ORIGINAL_DIR/system-configs/.claude/skills/test/SKILL.md"

    # Check for key behavior descriptions
    assert_file_contains "$test_file" "discovers and runs tests" \
        "Should mention test discovery"

    assert_file_contains "$test_file" "test.*creation\|creates.*test" \
        "Should mention test creation"

    assert_file_contains "$test_file" "README.md" \
        "Should mention README parsing"

    assert_file_contains "$test_file" "npm test" \
        "Should include npm test example"

    assert_file_contains "$test_file" "pytest" \
        "Should include pytest example"
}

# Run all tests
echo "Testing /test command..."

test_test_file_exists || exit 1
test_test_structure || exit 1
test_test_content || exit 1

echo "All /test command tests passed!"
