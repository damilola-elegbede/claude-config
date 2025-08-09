#!/bin/bash
# Test for CLAUDE.md validation

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test CLAUDE.md exists
test_claude_md_exists() {
    assert_file_exists "$ORIGINAL_DIR/CLAUDE.md" \
        "CLAUDE.md should exist in repository root"
}

# Test CLAUDE.md structure
test_claude_md_structure() {
    local claude_file="$ORIGINAL_DIR/CLAUDE.md"
    
    # Check main sections - only check for essential global settings sections
    assert_file_contains "$claude_file" "# Claude Configuration" \
        "Should have main header"
    
    # These sections are core to the chief of staff identity
    assert_file_contains "$claude_file" "Identity & Mission" \
        "Should have Identity & Mission section"
    
    assert_file_contains "$claude_file" "Operating Principles" \
        "Should have Operating Principles section"
}

# Test command documentation in CLAUDE.md - REMOVED
# Commands are documented in individual command files, not in global CLAUDE.md
test_claude_md_commands() {
    # This test is no longer needed - commands are in .claude/commands/*.md
    # Global CLAUDE.md doesn't need to duplicate command documentation
    return 0
}

# Test critical sections exist - Updated for global settings
test_claude_md_critical_sections() {
    local claude_file="$ORIGINAL_DIR/CLAUDE.md"
    
    # Check for core chief of staff sections
    assert_file_contains "$claude_file" "Delegation Matrix" \
        "Should have delegation matrix"
    
    # Check for execution patterns
    assert_file_contains "$claude_file" "Execution Patterns" \
        "Should have execution patterns"
    
    # Check for Git best practices (critical for global settings)
    assert_file_contains "$claude_file" "Git Best Practices" \
        "Should have Git best practices"
}

# Run all tests
echo "Testing CLAUDE.md validation..."

test_claude_md_exists || exit 1
test_claude_md_structure || exit 1
test_claude_md_commands || exit 1
test_claude_md_critical_sections || exit 1

echo "All CLAUDE.md validation tests passed!"