#!/bin/bash
# Test for CLAUDE.md validation

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test CLAUDE.md exists - check system config version for orchestration rules
test_claude_md_exists() {
    assert_file_exists "$ORIGINAL_DIR/system-configs/CLAUDE.md" \
        "System CLAUDE.md should exist in system-configs directory"
}

# Test that CLAUDE.md is in paragraph form with no markdown headers
test_claude_md_paragraph_form() {
    local claude_file="$ORIGINAL_DIR/system-configs/CLAUDE.md"
    local has_markdown_headers=false
    local has_markdown_lists=false

    echo "Validating CLAUDE.md is in paragraph form..."

    # Check for markdown headers (##, ###, etc.)
    if grep -q "^##" "$claude_file"; then
        has_markdown_headers=true
        echo "❌ Found markdown headers (##) - file must be in paragraph form"
    fi

    if grep -q "^###" "$claude_file"; then
        has_markdown_headers=true
        echo "❌ Found markdown headers (###) - file must be in paragraph form"
    fi

    # Check for markdown bullet lists
    if grep -q "^- " "$claude_file" || grep -q "^\* " "$claude_file"; then
        has_markdown_lists=true
        echo "❌ Found markdown bullet lists - file must be in paragraph form"
    fi

    # Check for numbered lists
    if grep -q "^[0-9]\+\. " "$claude_file"; then
        has_markdown_lists=true
        echo "❌ Found numbered lists - file must be in paragraph form"
    fi

    if [ "$has_markdown_headers" = true ] || [ "$has_markdown_lists" = true ]; then
        echo "❌ CLAUDE.md contains markdown formatting - must be pure paragraph form"
        return 1
    fi

    echo "✅ CLAUDE.md is in correct paragraph form (no markdown headers or lists)"
    return 0
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

    # Must have delegation principle
    if ! grep -q -i "delegate everything" "$claude_file"; then
        score=$((score - 2))
        reasons+=("Missing delegation principle: Core orchestration logic absent")
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

    # Must have 1.5K token threshold
    if ! grep -q "1\.5K" "$claude_file"; then
        score=$((score - 1))
        reasons+=("Missing 1.5K token delegation threshold")
    fi

    # Must have wave-based orchestration
    if ! grep -q -i "wave" "$claude_file"; then
        score=$((score - 1))
        reasons+=("Missing wave-based orchestration pattern")
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
    test_claude_md_paragraph_form && \
    test_claude_md_effectiveness
}

# Execute if called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_claude_md_tests
fi
