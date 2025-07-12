#!/bin/bash
# Test for /commit command

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test commit command file exists
test_commit_file_exists() {
    assert_file_exists "$ORIGINAL_DIR/.claude/commands/commit.md" \
        "Commit command file should exist"
}

# Test commit command structure
test_commit_structure() {
    local commit_file="$ORIGINAL_DIR/.claude/commands/commit.md"
    
    # Check required sections
    assert_file_contains "$commit_file" "# /commit Command" \
        "Should have command header"
    
    assert_file_contains "$commit_file" "## Description" \
        "Should have Description section"
    
    assert_file_contains "$commit_file" "## Usage" \
        "Should have Usage section"
    
    assert_file_contains "$commit_file" "## Behavior" \
        "Should have Behavior section"
}

# Test commit command content
test_commit_content() {
    local commit_file="$ORIGINAL_DIR/.claude/commands/commit.md"
    
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