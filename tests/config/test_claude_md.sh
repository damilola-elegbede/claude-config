#!/bin/bash
# Test for CLAUDE.md validation

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test CLAUDE.md exists
test_claude_md_exists() {
    assert_file_exists "$ORIGINAL_DIR/CLAUDE.md" \
        "CLAUDE.md should exist in repository root"
}

# Test CLAUDE.md structure - Updated for new pragmatic format
test_claude_md_structure() {
    local claude_file="$ORIGINAL_DIR/CLAUDE.md"
    
    # Check main header
    assert_file_contains "$claude_file" "# Claude Configuration" \
        "Should have main header"
    
    # Check for core principle (chief of staff role)
    assert_file_contains "$claude_file" "Core Principle" \
        "Should have Core Principle section"
    
    assert_file_contains "$claude_file" "chief of staff" \
        "Should define chief of staff role"
    
    # Check for decision framework
    assert_file_contains "$claude_file" "Decision Framework" \
        "Should have Decision Framework section"
}

# Test critical sections exist - Updated for pragmatic structure
test_claude_md_critical_sections() {
    local claude_file="$ORIGINAL_DIR/CLAUDE.md"
    
    # Check for Quick Start section
    assert_file_contains "$claude_file" "Quick Start" \
        "Should have Quick Start section with common patterns"
    
    # Check for Task Complexity Guide
    assert_file_contains "$claude_file" "Task Complexity Guide" \
        "Should have Task Complexity Guide"
    
    # Check for Essential Agents section
    assert_file_contains "$claude_file" "Essential Agents" \
        "Should have Essential Agents section"
    
    # Check for Real-World Examples
    assert_file_contains "$claude_file" "Real-World Examples" \
        "Should have Real-World Examples section"
    
    # Check for Anti-Patterns
    assert_file_contains "$claude_file" "Anti-Patterns" \
        "Should have Anti-Patterns to Avoid section"
    
    # Check for execution patterns
    assert_file_contains "$claude_file" "Execution Patterns" \
        "Should have Execution Patterns section"
    
    # Check for brutal honesty principle
    assert_file_contains "$claude_file" "brutal honesty" \
        "Should mention brutal honesty principle"
}

# Test pragmatic philosophy
test_claude_md_philosophy() {
    local claude_file="$ORIGINAL_DIR/CLAUDE.md"
    
    # Check for pragmatic approach
    assert_file_contains "$claude_file" "When to Delegate" \
        "Should have When to Delegate section"
    
    assert_file_contains "$claude_file" "When NOT to Delegate" \
        "Should have When NOT to Delegate section"
    
    # Check for the closing philosophy
    assert_file_contains "$claude_file" "bias toward action" \
        "Should emphasize bias toward action"
    
    # Check for Mental Model
    assert_file_contains "$claude_file" "Mental Model" \
        "Should have Mental Model section"
}

# Run all tests
echo "Testing CLAUDE.md validation..."

test_claude_md_exists || exit 1
test_claude_md_structure || exit 1
test_claude_md_critical_sections || exit 1
test_claude_md_philosophy || exit 1

echo "All CLAUDE.md validation tests passed!"