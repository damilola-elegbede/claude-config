#!/bin/bash
# Test for /sync command

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test sync command file exists
test_sync_file_exists() {
    assert_file_exists "$ORIGINAL_DIR/system-configs/.claude/commands/sync.md" \
        "Sync command file should exist"
}

# Test sync command structure
test_sync_structure() {
    local sync_file="$ORIGINAL_DIR/system-configs/.claude/commands/sync.md"

    # Check required sections
    assert_file_contains "$sync_file" "# /sync Command" \
        "Should have command header"

    assert_file_contains "$sync_file" "## Description" \
        "Should have Description section"

    assert_file_contains "$sync_file" "## Usage" \
        "Should have Usage section"

    assert_file_contains "$sync_file" "## Configuration File" \
        "Should have Configuration File section"

    assert_file_contains "$sync_file" "## Notes" \
        "Should have Notes section"
}

# Test sync command content
test_sync_content() {
    local sync_file="$ORIGINAL_DIR/system-configs/.claude/commands/sync.md"

    # Check for key behavior descriptions
    assert_file_contains "$sync_file" ".syncconfig" \
        "Should mention .syncconfig file"

    assert_file_contains "$sync_file" "Synchronizes configuration" \
        "Should mention synchronization"

    assert_file_contains "$sync_file" "rsync" \
        "Should mention rsync"

    assert_file_contains "$sync_file" "Bidirectional" \
        "Should mention bidirectional sync"

    assert_file_contains "$sync_file" "\\-\\-pull" \
        "Should mention pull mode"

    assert_file_contains "$sync_file" "\\-\\-push" \
        "Should mention push mode"
}

# Run all tests
echo "Testing /sync command..."

test_sync_file_exists || exit 1
test_sync_structure || exit 1
test_sync_content || exit 1

echo "All /sync command tests passed!"
