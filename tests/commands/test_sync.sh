#!/bin/bash
# Test for /sync command
# Note: sync is a project-local command (.claude/commands/), not in system-configs

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test sync command file exists (project-local location)
test_sync_file_exists() {
    assert_file_exists "$ORIGINAL_DIR/.claude/commands/sync.md" \
        "Sync command file should exist in project-local .claude/commands/"
}

# Test sync command structure
test_sync_structure() {
    local sync_file="$ORIGINAL_DIR/.claude/commands/sync.md"

    # Check for YAML frontmatter
    assert_file_contains "$sync_file" "^---" \
        "Should have YAML frontmatter start"

    assert_file_contains "$sync_file" "description:" \
        "Should have description in frontmatter"

    # Check required sections (new template format)
    assert_file_contains "$sync_file" "## Usage" \
        "Should have Usage section"

    assert_file_contains "$sync_file" "## Description" \
        "Should have Description section"

    assert_file_contains "$sync_file" "## Expected Output" \
        "Should have Expected Output section"
}

# Test sync command content
test_sync_content() {
    local sync_file="$ORIGINAL_DIR/.claude/commands/sync.md"

    # Check for key behavior descriptions
    assert_file_contains "$sync_file" "system-configs/.claude/" \
        "Should mention source directory"

    assert_file_contains "$sync_file" "Synchronize all Claude configuration files" \
        "Should mention Claude configuration synchronization"

    assert_file_contains "$sync_file" "rsync" \
        "Should mention rsync"

    assert_file_contains "$sync_file" "statusline.sh" \
        "Should mention statusline.sh"

    assert_file_contains "$sync_file" "\\-\\-dry-run" \
        "Should mention dry-run mode"

    assert_file_contains "$sync_file" "\\-\\-backup" \
        "Should mention backup mode"
}

# Run all tests
echo "Testing /sync command..."

test_sync_file_exists || exit 1
test_sync_structure || exit 1
test_sync_content || exit 1

echo "All /sync command tests passed!"
