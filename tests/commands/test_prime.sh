#!/bin/bash
# Test for /prime command

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test prime command file exists
test_prime_file_exists() {
    assert_file_exists "$ORIGINAL_DIR/system-configs/.claude/commands/prime.md" \
        "Prime command file should exist"
}

# Test prime command structure
test_prime_structure() {
    local prime_file="$ORIGINAL_DIR/system-configs/.claude/commands/prime.md"

    # Check for YAML frontmatter
    assert_file_contains "$prime_file" "^---" \
        "Should have YAML frontmatter start"

    assert_file_contains "$prime_file" "description:" \
        "Should have description in frontmatter"

    # Check required sections (new template format)
    assert_file_contains "$prime_file" "## Usage" \
        "Should have Usage section"

    assert_file_contains "$prime_file" "## Description" \
        "Should have Description section"

    assert_file_contains "$prime_file" "## Expected Output" \
        "Should have Expected Output section"
}

# Test prime command content
test_prime_content() {
    local prime_file="$ORIGINAL_DIR/system-configs/.claude/commands/prime.md"

    # Check for key behavior descriptions
    assert_file_contains "$prime_file" "Analyze repository structure" \
        "Should mention repository analysis"

    assert_file_contains "$prime_file" "technology stack" \
        "Should mention tech stack detection"

    assert_file_contains "$prime_file" "Lite Mode" \
        "Should mention lite mode"

    assert_file_contains "$prime_file" "package.json" \
        "Should include config file examples"
}

# Run all tests
echo "Testing /prime command..."

test_prime_file_exists || exit 1
test_prime_structure || exit 1
test_prime_content || exit 1

echo "All /prime command tests passed!"
