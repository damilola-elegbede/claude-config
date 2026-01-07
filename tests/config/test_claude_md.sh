#!/bin/bash
# Test for CLAUDE.md validation (Boris Cherny style - identity/preferences focused)

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test CLAUDE.md exists
test_claude_md_exists() {
    assert_file_exists "$ORIGINAL_DIR/system-configs/CLAUDE.md" \
        "System CLAUDE.md should exist in system-configs directory"
}

# Test that CLAUDE.md has proper identity-focused structure
test_claude_md_structure() {
    local claude_file="$ORIGINAL_DIR/system-configs/CLAUDE.md"
    local has_main_header=false
    local has_communication=false
    local has_working_style=false
    local has_quality=false

    echo "Validating CLAUDE.md identity-focused structure..."

    # Check for main header (About Me or similar identity header)
    if grep -q "^# About Me" "$claude_file"; then
        has_main_header=true
    else
        echo "Warning: Missing '# About Me' header (optional but recommended)"
    fi

    # Check for Communication Preferences
    if grep -q "^## Communication Preferences" "$claude_file"; then
        has_communication=true
    else
        echo "Warning: Missing Communication Preferences section"
    fi

    # Check for Working Style
    if grep -q "^## Working Style" "$claude_file"; then
        has_working_style=true
    else
        echo "Warning: Missing Working Style section"
    fi

    # Check for Quality Standards
    if grep -q "^## Quality Standards" "$claude_file"; then
        has_quality=true
    else
        echo "Warning: Missing Quality Standards section"
    fi

    # Pass if at least 3 of 4 sections present
    local count=0
    [ "$has_main_header" = true ] && count=$((count + 1))
    [ "$has_communication" = true ] && count=$((count + 1))
    [ "$has_working_style" = true ] && count=$((count + 1))
    [ "$has_quality" = true ] && count=$((count + 1))

    if [ "$count" -ge 3 ]; then
        echo "CLAUDE.md has correct identity-focused structure ($count/4 sections)"
        return 0
    else
        echo "CLAUDE.md missing key identity sections ($count/4)"
        return 1
    fi
}

# Test CLAUDE.md effectiveness - Boris Cherny style is concise
test_claude_md_effectiveness() {
    local claude_file="$ORIGINAL_DIR/system-configs/CLAUDE.md"
    local line_count
    local word_count
    line_count=$(wc -l < "$claude_file")
    word_count=$(wc -w < "$claude_file")
    local score=10
    local reasons=()

    # Boris Cherny style: short and focused
    # Ideal: 50-100 lines (concise identity/preferences)
    if [ "$line_count" -gt 150 ]; then
        score=$((score - 2))
        reasons+=("Getting long ($line_count lines > 150): Boris style is concise")
    fi

    if [ "$line_count" -gt 200 ]; then
        score=$((score - 3))
        reasons+=("Too long ($line_count lines > 200): Will impact effectiveness")
    fi

    # Must have .tmp directory requirement
    if ! grep -q "\.tmp/" "$claude_file"; then
        score=$((score - 1))
        reasons+=("Missing .tmp directory operational standard")
    fi

    # Must have quality emphasis
    if ! grep -q -i "quality\|standards" "$claude_file"; then
        score=$((score - 1))
        reasons+=("Missing quality standards mention")
    fi

    # Must have git mention (no-verify policy)
    if ! grep -q -i "git\|--no-verify" "$claude_file"; then
        score=$((score - 1))
        reasons+=("Missing git policy")
    fi

    # Report results
    echo "CLAUDE.md Effectiveness Analysis:"
    echo "  Lines: $line_count"
    echo "  Words: $word_count"
    echo "  Score: $score/10"

    if [ ${#reasons[@]} -gt 0 ]; then
        echo "  Issues found:"
        for reason in "${reasons[@]}"; do
            echo "    - $reason"
        done
    fi

    # Require 7/10 or higher for effectiveness
    if [ "$score" -lt 7 ]; then
        echo "CLAUDE.md effectiveness score too low: $score/10 (requires 7/10)"
        return 1
    else
        echo "CLAUDE.md effectiveness score: $score/10"
        return 0
    fi
}

# Run all tests
run_claude_md_tests() {
    echo "Testing CLAUDE.md validation..."

    test_claude_md_exists && \
    test_claude_md_structure && \
    test_claude_md_effectiveness
}

# Execute if called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_claude_md_tests
fi
