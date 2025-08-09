#!/bin/bash
# Integration tests for Claude configuration

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test sync command simulation
test_sync_simulation() {
    # Setup test environment
    setup_test_env
    
    # Create mock source structure
    mkdir -p .claude/commands
    create_mock_claude_md
    create_mock_command "test" "Test command content"
    create_mock_command "plan" "Plan command content"
    
    # Create mock destination
    mkdir -p mock_home/.claude/commands
    
    # Simulate sync operation
    cp CLAUDE.md mock_home/CLAUDE.md
    cp .claude/commands/*.md mock_home/.claude/commands/
    
    # Verify sync results
    assert_file_exists "mock_home/CLAUDE.md" \
        "CLAUDE.md should be synced"
    
    assert_file_exists "mock_home/.claude/commands/test.md" \
        "Command files should be synced"
    
    cleanup_test_env
}

# Test command consistency
test_command_consistency() {
    local commands_in_readme
    local commands_in_dir
    
    commands_in_readme=$(grep -c "^\s*- \`/[a-z]*\`" "$ORIGINAL_DIR/README.md" 2>/dev/null || echo 0)
    commands_in_dir=$(ls "$ORIGINAL_DIR/.claude/commands/"*.md 2>/dev/null | wc -l | tr -d ' ')
    
    # Ensure numeric values
    commands_in_readme=${commands_in_readme:-0}
    commands_in_dir=${commands_in_dir:-0}
    
    # All commands should be documented in README
    if [ "$commands_in_readme" -lt "$commands_in_dir" ] 2>/dev/null; then
        echo "Not all commands are documented in README.md"
        echo "Commands in directory: $commands_in_dir"
        echo "Commands in README: $commands_in_readme"
        return 1
    fi
    
    return 0
}

# Test CLAUDE.md consistency - Updated to not require command docs
test_claude_md_consistency() {
    local repo_claude="$ORIGINAL_DIR/CLAUDE.md"
    
    # Commands are documented in .claude/commands/*.md files
    # Global CLAUDE.md focuses on chief of staff identity and principles
    # Just verify the file exists and has core content
    assert_file_exists "$repo_claude" \
        "CLAUDE.md should exist"
    
    # Check for core identity
    assert_file_contains "$repo_claude" "chief of staff" \
        "CLAUDE.md should define chief of staff role"
    
    return 0
}

# Test repository structure integrity
test_repo_structure() {
    # Check all expected directories exist
    assert_dir_exists "$ORIGINAL_DIR/.claude" \
        ".claude directory should exist"
    
    assert_dir_exists "$ORIGINAL_DIR/.claude/commands" \
        "commands directory should exist"
    
    assert_dir_exists "$ORIGINAL_DIR/tests" \
        "tests directory should exist"
    
    # Check all expected files exist
    assert_file_exists "$ORIGINAL_DIR/README.md" \
        "README.md should exist"
    
    assert_file_exists "$ORIGINAL_DIR/CLAUDE.md" \
        "CLAUDE.md should exist"
    
    assert_file_exists "$ORIGINAL_DIR/tests/test.sh" \
        "tests/test.sh should exist"
}

# Test that sync command is excluded from global commands
test_sync_exclusion() {
    local sync_file="$ORIGINAL_DIR/.claude/commands/sync.md"
    
    # Verify sync.md exists
    assert_file_exists "$sync_file" \
        "sync.md should exist in repo"
    
    # Verify it mentions exclusion
    assert_file_contains "$sync_file" "will NOT be copied" \
        "sync.md should mention it won't be copied"
    
    assert_file_contains "$sync_file" "repo-specific" \
        "sync.md should be marked as repo-specific"
}

# Run all tests
echo "Running integration tests..."

test_sync_simulation || exit 1
test_command_consistency || exit 1
test_claude_md_consistency || exit 1
test_repo_structure || exit 1
test_sync_exclusion || exit 1

echo "All integration tests passed!"