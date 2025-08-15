#!/bin/bash
# Test for CLAUDE.md validation

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test CLAUDE.md exists - check system config version for orchestration rules
test_claude_md_exists() {
    assert_file_exists "$ORIGINAL_DIR/system-configs/CLAUDE.md" \
        "System CLAUDE.md should exist in system-configs directory"
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
    # Orchestration framework needs comprehensive guidance, adjusted thresholds
    if [ "$line_count" -gt 200 ]; then
        score=$((score - 1))
        reasons+=("Getting long ($line_count lines > 200): Monitor for attention impact")
    fi

    if [ "$line_count" -gt 300 ]; then
        score=$((score - 3))
        reasons+=("Too long ($line_count lines > 300): Will impact effectiveness")
    fi

    # Word density check (should be concise, not verbose)
    words_per_line=$((word_count / line_count))
    if [ "$words_per_line" -gt 25 ]; then
        score=$((score - 2))
        reasons+=("Too verbose ($words_per_line words/line > 25): Needs tighter editing")
    fi

    # Must have core philosophy section
    if ! grep -q "Core Philosophy" "$claude_file"; then
        score=$((score - 2))
        reasons+=("Missing Core Philosophy: Must define orchestration principles")
    fi

    # Must have decision framework
    if ! grep -q "Decision Framework" "$claude_file"; then
        score=$((score - 2))
        reasons+=("Missing Decision Framework: Core orchestration logic absent")
    fi

    # Must have parallel execution strategy
    if ! grep -q "Parallel Execution Strategy" "$claude_file"; then
        score=$((score - 2))
        reasons+=("Missing Parallel Execution Strategy: Key efficiency component missing")
    fi

    # Must have parallel execution guidance
    if ! grep -q -i "parallel\|simultaneous\|concurrent" "$claude_file"; then
        score=$((score - 2))
        reasons+=("Missing parallel execution: Must orchestrate agents in parallel")
    fi

    # Must have non-negotiable rules
    if ! grep -q "Non-Negotiable Rules" "$claude_file"; then
        score=$((score - 3))
        reasons+=("Missing Non-Negotiable Rules: Core enforcement rules absent")
    fi

    # Must have success metrics
    if ! grep -q "Success Metrics" "$claude_file"; then
        score=$((score - 1))
        reasons+=("Missing Success Metrics: Need clear behavior indicators")
    fi

    # Must have practical examples
    if ! grep -q "Practical Examples" "$claude_file"; then
        score=$((score - 1))
        reasons+=("Missing Practical Examples: Need concrete usage patterns")
    fi

    # Must have failure recovery strategies
    if ! grep -q "Failure Recovery" "$claude_file"; then
        score=$((score - 1))
        reasons+=("Missing Failure Recovery: Need error handling guidance")
    fi

    # Must be actionable (not just theory)
    if ! grep -q -E "→|Deploy|delegate|Handle Directly" "$claude_file"; then
        score=$((score - 1))
        reasons+=("Not actionable enough: Needs clear directives")
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

    # Require 8/10 or higher for orchestration framework (comprehensive requirements)
    if [ "$score" -lt 8 ]; then
        echo "❌ CLAUDE.md effectiveness score too low: $score/10 (requires ≥8/10)"
        echo "   Orchestration framework needs improvements to be effective"
        return 1
    else
        echo "✅ CLAUDE.md effectiveness score: $score/10"
        return 0
    fi
}

# Test orchestration framework structure
test_claude_md_structure() {
    local claude_file="$ORIGINAL_DIR/system-configs/CLAUDE.md"
    local missing_sections=()

    # Core framework sections that must exist in streamlined version
    local required_sections=(
        "Core Philosophy"
        "Decision Framework"
        "Parallel Execution Strategy"
        "Non-Negotiable Rules"
        "Failure Recovery"
        "Success Metrics"
        "Examples"
        "Continuous Improvement"
    )

    echo "Validating orchestration framework structure..."

    for section in "${required_sections[@]}"; do
        if ! grep -q "## $section" "$claude_file"; then
            missing_sections+=("$section")
        fi
    done

    if [ ${#missing_sections[@]} -gt 0 ]; then
        echo "❌ Missing required framework sections:"
        for section in "${missing_sections[@]}"; do
            echo "    - $section"
        done
        return 1
    fi

    # Check for key orchestration concepts
    if ! grep -q -i "agent" "$claude_file" || ! grep -q -i "specialist" "$claude_file"; then
        echo "❌ Missing agent/specialist terminology"
        return 1
    fi

    if ! grep -q -i "threshold\|complexity" "$claude_file"; then
        echo "❌ Missing complexity guidance"
        return 1
    fi

    echo "✅ Framework structure validation passed"
    return 0
}

# Test examples and anti-patterns
test_claude_md_examples() {
    local claude_file="$ORIGINAL_DIR/system-configs/CLAUDE.md"

    # Must have practical examples (can be in Examples section or throughout)
    if ! grep -q -E "Example|README typo|Authentication system|Bug report" "$claude_file"; then
        echo "❌ Missing practical examples"
        return 1
    fi

    # Must have anti-patterns
    if ! grep -q "❌.*Anti-patterns\|❌.*patterns" "$claude_file"; then
        echo "❌ Missing anti-patterns section"
        return 1
    fi

    # Must have success indicators
    if ! grep -q "✅.*Optimal\|✅.*behaviors" "$claude_file"; then
        echo "❌ Missing optimal behavior indicators"
        return 1
    fi

    echo "✅ Examples and patterns validation passed"
    return 0
}

# Run all tests
run_claude_md_tests() {
    echo "Testing CLAUDE.md validation..."

    test_claude_md_exists && \
    test_claude_md_effectiveness && \
    test_claude_md_structure && \
    test_claude_md_examples
}

# Execute if called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_claude_md_tests
fi
