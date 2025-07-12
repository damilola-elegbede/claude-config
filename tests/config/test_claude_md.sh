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
    
    # Check main sections
    assert_file_contains "$claude_file" "# Claude Configuration" \
        "Should have main header"
    
    assert_file_contains "$claude_file" "## CLI Command Shortcuts" \
        "Should have CLI Command Shortcuts section"
    
    assert_file_contains "$claude_file" "## Trusted Folders" \
        "Should have Trusted Folders section"
    
    assert_file_contains "$claude_file" "## Code Quality Standards" \
        "Should have Code Quality Standards section"
    
    assert_file_contains "$claude_file" "## Development Workflow" \
        "Should have Development Workflow section"
}

# Test command documentation in CLAUDE.md
test_claude_md_commands() {
    local claude_file="$ORIGINAL_DIR/CLAUDE.md"
    
    # Check all commands are documented
    assert_file_contains "$claude_file" "### /test Command" \
        "Should document /test command"
    
    assert_file_contains "$claude_file" "### /context Command" \
        "Should document /context command"
    
    # Check command descriptions
    assert_file_contains "$claude_file" "Automatically discovers and runs tests" \
        "Should describe test command functionality"
    
    assert_file_contains "$claude_file" "Creates base level test suite if no tests exist" \
        "Should mention test creation feature"
}

# Test critical sections exist
test_claude_md_critical_sections() {
    local claude_file="$ORIGINAL_DIR/CLAUDE.md"
    
    # Check for plan approval workflow
    assert_file_contains "$claude_file" "Plan Approval Workflow" \
        "Should have plan approval workflow"
    
    # Check for language-specific guidelines
    assert_file_contains "$claude_file" "Language-Specific Guidelines" \
        "Should have language guidelines"
    
    # Check for platform guidelines
    assert_file_contains "$claude_file" "Platform-Specific Guidelines" \
        "Should have platform guidelines"
}

# Run all tests
echo "Testing CLAUDE.md validation..."

test_claude_md_exists || exit 1
test_claude_md_structure || exit 1
test_claude_md_commands || exit 1
test_claude_md_critical_sections || exit 1

echo "All CLAUDE.md validation tests passed!"