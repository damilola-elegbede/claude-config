#!/bin/bash
# Test for CLAUDE.md validation

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test CLAUDE.md exists - check system config version for orchestration rules
test_claude_md_exists() {
    assert_file_exists "$ORIGINAL_DIR/system-configs/CLAUDE.md" \
        "System CLAUDE.md should exist in system-configs directory"
}

# Test that CLAUDE.md has proper structured markdown format
test_claude_md_structure() {
    local claude_file="$ORIGINAL_DIR/system-configs/CLAUDE.md"
    local has_main_header=false
    local has_core_principle=false
    local has_excellence_principles=false
    local has_task_classification=false

    echo "Validating CLAUDE.md structured markdown format..."

    # Check for main header
    if grep -q "^# Claude - Chief of Staff Configuration" "$claude_file"; then
        has_main_header=true
    else
        echo "❌ Missing main header: '# Claude - Chief of Staff Configuration'"
    fi

    # Check for Core Operating Principle section
    if grep -q "^## Core Operating Principle" "$claude_file"; then
        has_core_principle=true
    else
        echo "❌ Missing Core Operating Principle section"
    fi

    # Check for Operational Excellence Principles section
    if grep -q "^## Operational Excellence Principles" "$claude_file"; then
        has_excellence_principles=true
    else
        echo "❌ Missing Operational Excellence Principles section"
    fi

    # Check for Task Classification section (Three-Tier or Binary)
    if grep -q "^## Three-Tier Task Classification" "$claude_file" || grep -q "^## Binary Task Classification" "$claude_file"; then
        has_task_classification=true
    else
        echo "❌ Missing Task Classification section"
    fi

    if [ "$has_main_header" = true ] && [ "$has_core_principle" = true ] && [ "$has_excellence_principles" = true ] && [ "$has_task_classification" = true ]; then
        echo "✅ CLAUDE.md has correct structured markdown format"
        return 0
    else
        echo "❌ CLAUDE.md missing required structural elements"
        return 1
    fi
}

# Test CLAUDE.md effectiveness criteria - check system config for orchestration framework
test_claude_md_effectiveness() {
    local claude_file="$ORIGINAL_DIR/system-configs/CLAUDE.md"
    local line_count
    local word_count
    line_count=$(wc -l < "$claude_file")
    word_count=$(wc -w < "$claude_file")
    local score=10
    local reasons=()

    # CRITICAL: Size limits for attention/effectiveness
    if [ "$line_count" -gt 100 ]; then
        score=$((score - 1))
        reasons+=("Getting long ($line_count lines > 100): Monitor for attention impact")
    fi

    if [ "$line_count" -gt 150 ]; then
        score=$((score - 3))
        reasons+=("Too long ($line_count lines > 150): Will impact effectiveness")
    fi

    # Word density check (should be concise, not verbose)
    words_per_line=$((word_count / line_count))
    if [ "$words_per_line" -gt 25 ]; then
        score=$((score - 2))
        reasons+=("Too verbose ($words_per_line words/line > 25): Needs tighter editing")
    fi

    # Must have chief of staff positioning
    if ! grep -q "chief of staff" "$claude_file"; then
        score=$((score - 2))
        reasons+=("Missing chief of staff positioning: Must define coordination role")
    fi

    # Must have delegation framework (three-tier or binary)
    if ! grep -q -i "three-tier delegation framework\|binary delegation framework" "$claude_file"; then
        score=$((score - 2))
        reasons+=("Missing delegation framework: Core orchestration logic absent")
    fi

    # Must have Task tool execution requirement
    if ! grep -q -i "Task tool" "$claude_file"; then
        score=$((score - 2))
        reasons+=("Missing Task tool execution requirements")
    fi

    # Must have parallel execution strategy
    if ! grep -q -i "parallel execution" "$claude_file"; then
        score=$((score - 2))
        reasons+=("Missing parallel execution strategy")
    fi

    # Must have Level 1/Level 2/Level 3 classification
    if ! grep -q "Level 1" "$claude_file" && ! grep -q "Level 2" "$claude_file"; then
        score=$((score - 1))
        reasons+=("Missing Level 1/Level 2/Level 3 task classification")
    fi

    # Must have operational excellence principles
    if ! grep -q -i "Operational Excellence Principles" "$claude_file"; then
        score=$((score - 1))
        reasons+=("Missing Operational Excellence Principles section")
    fi

    # Must have git quality standards
    if ! grep -q -i "git.*quality\|quality.*git\|--no-verify" "$claude_file"; then
        score=$((score - 1))
        reasons+=("Missing git quality standards")
    fi

    # Must have success measurement criteria
    if ! grep -q -i "measures success\|success.*metric" "$claude_file"; then
        score=$((score - 1))
        reasons+=("Missing success measurement criteria")
    fi

    # Must have .tmp directory requirement
    if ! grep -q "\.tmp/" "$claude_file"; then
        score=$((score - 1))
        reasons+=("Missing .tmp directory operational standard")
    fi

    # Report results
    echo "CLAUDE.md Effectiveness Analysis:"
    echo "  Lines: $line_count"
    echo "  Words: $word_count"
    echo "  Words/line: $words_per_line"
    echo "  Score: $score/10"

    if [ ${#reasons[@]} -gt 0 ]; then
        echo "  Issues found:"
        for reason in "${reasons[@]}"; do
            echo "    - $reason"
        done
    fi

    # Require 7/10 or higher for effectiveness
    if [ "$score" -lt 7 ]; then
        echo "❌ CLAUDE.md effectiveness score too low: $score/10 (requires ≥7/10)"
        return 1
    else
        echo "✅ CLAUDE.md effectiveness score: $score/10"
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
