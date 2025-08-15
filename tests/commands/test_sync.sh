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

    assert_file_contains "$sync_file" "## Behavior" \
        "Should have Behavior section"

    assert_file_contains "$sync_file" "## Important Notes" \
        "Should have Important Notes section"
}

# Test sync command content
test_sync_content() {
    local sync_file="$ORIGINAL_DIR/system-configs/.claude/commands/sync.md"

    # Check for key behavior descriptions
    assert_file_contains "$sync_file" "Repository-specific command" \
        "Should mention it's repo-specific"

    assert_file_contains "$sync_file" "synchronizes Claude configuration" \
        "Should mention synchronization"

    assert_file_contains "$sync_file" "Backup existing files" \
        "Should mention backups"

    assert_file_contains "$sync_file" "~/CLAUDE.md" \
        "Should mention user home directory"

    assert_file_contains "$sync_file" "will NOT be copied" \
        "Should mention sync exclusion"

    assert_file_contains "$sync_file" "agents/" \
        "Should mention agents directory"

    assert_file_contains "$sync_file" "~/.claude/agents/" \
        "Should mention target agents directory"
}

# Run all tests
echo "Testing /sync command..."

test_sync_file_exists || exit 1
test_sync_structure || exit 1
test_sync_content || exit 1

echo "All /sync command tests passed!"
