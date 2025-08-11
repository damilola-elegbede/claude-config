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
    
    # Check for core principles section (accepts either old or new format)
    if ! grep -q "Operating Principles" "$claude_file" && ! grep -q "Principle 0: Radical Candor" "$claude_file"; then
        fail "Should have core principles section (either 'Operating Principles' or 'Principle 0: Radical Candor')"
        return 1
    fi
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
    
    # Check for delegation-related sections (flexible matching for refactored structure)
    if ! grep -qi "Delegation Matrix" "$claude_file" && ! grep -qi "Delegation.*Rules\|Task.*Delegation" "$claude_file"; then
        fail "Should have delegation section (either 'Delegation Matrix' or delegation rules)"
        return 1
    fi
    
    # Check for execution patterns (flexible matching)
    if ! grep -qi "Execution.*Patterns\|Parallel.*Execution" "$claude_file"; then
        fail "Should have execution patterns section"
        return 1
    fi
    
    # Check for Git best practices (optional in refactored structure)  
    # This section may not exist in simplified configurations
    if grep -q "Git" "$claude_file"; then
        echo "Git practices section found"
    else
        echo "Note: Git practices section not required in simplified config"
    fi
}

# Run all tests
echo "Testing CLAUDE.md validation..."

test_claude_md_exists || exit 1
test_claude_md_structure || exit 1
test_claude_md_commands || exit 1
test_claude_md_critical_sections || exit 1

echo "All CLAUDE.md validation tests passed!"