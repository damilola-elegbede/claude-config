#!/bin/bash
# Test for /context command

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test context command file exists
test_context_file_exists() {
    assert_file_exists "$ORIGINAL_DIR/system-configs/.claude/commands/context.md" \
        "Context command file should exist"
}

# Test context command structure
test_context_structure() {
    local context_file="$ORIGINAL_DIR/system-configs/.claude/commands/context.md"

    # Check for YAML frontmatter
    assert_file_contains "$context_file" "^---" \
        "Should have YAML frontmatter start"

    assert_file_contains "$context_file" "description:" \
        "Should have description in frontmatter"

    # Check required sections (new format)
    assert_file_contains "$context_file" "# Command Purpose" \
        "Should have Command Purpose header"

    assert_file_contains "$context_file" "## Context" \
        "Should have Context section"

    assert_file_contains "$context_file" "### Analysis Modes" \
        "Should have Analysis Modes subsection"
}

# Test context command content
test_context_content() {
    local context_file="$ORIGINAL_DIR/system-configs/.claude/commands/context.md"

    # Check for key behavior descriptions
    assert_file_contains "$context_file" "Analyze repository structure" \
        "Should mention repository analysis"

    assert_file_contains "$context_file" "technology stack" \
        "Should mention tech stack detection"

    assert_file_contains "$context_file" "Lite Mode" \
        "Should mention lite mode"

    assert_file_contains "$context_file" "package.json" \
        "Should include config file examples"
}

# Run all tests
echo "Testing /context command..."

test_context_file_exists || exit 1
test_context_structure || exit 1
test_context_content || exit 1

echo "All /context command tests passed!"
