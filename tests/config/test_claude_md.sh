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

    # Must have parallel execution strategy
    if ! grep -q -i "parallel execution" "$claude_file"; then
        score=$((score - 2))
        reasons+=("Missing Parallel Execution Strategy: Key efficiency component missing")
    fi

    # Must have parallel execution guidance
    if ! grep -q -i "parallel\|simultaneous\|concurrent" "$claude_file"; then
        score=$((score - 2))
        reasons+=("Missing parallel execution: Must orchestrate agents in parallel")
    fi

    # Must have authentication/API design patterns mentioned
    if ! grep -q -i "authentication\|api design" "$claude_file"; then
        score=$((score - 3))
        reasons+=("Missing specific patterns: Core enforcement examples absent")
    fi

    # Must have success measurement criteria
    if ! grep -q -i "measures success\|optimal execution" "$claude_file"; then
        score=$((score - 1))
        reasons+=("Missing success criteria: Need clear behavior indicators")
    fi

    # Must have practical examples (20 files = 20 agents, etc)
    if ! grep -q -E "20 files.*20.*agents|example" "$claude_file"; then
        score=$((score - 1))
        reasons+=("Missing practical examples: Need concrete usage patterns")
    fi

    # Must have failure recovery strategies (not required in parallelization-focused framework)
    # Removing this check as it's not part of the parallelization framework

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
    local missing_elements=()

    # Core framework elements that must exist in paragraph format
    local required_elements=(
        "chief of staff"
        "delegate everything"
        "parallel execution"
        "MCP servers"
        "git.*quality standards"
        "measures success"
    )

    echo "Validating orchestration framework structure..."

    for element in "${required_elements[@]}"; do
        if ! grep -i -q "$element" "$claude_file"; then
            missing_elements+=("$element")
        fi
    done

    if [ ${#missing_elements[@]} -gt 0 ]; then
        echo "❌ Missing required framework elements:"
        for element in "${missing_elements[@]}"; do
            echo "    - $element"
        done
        return 1
    fi

    # Check for key orchestration concepts
    if ! grep -q -i "agent" "$claude_file" || ! grep -q -i "specialist" "$claude_file"; then
        echo "❌ Missing agent/specialist terminology"
        return 1
    fi

    if ! grep -q -i "threshold\|complex" "$claude_file"; then
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
    if ! grep -q -i -E "example|20 files|authentication|api design" "$claude_file"; then
        echo "❌ Missing practical examples"
        return 1
    fi

    # Must have anti-patterns mentioned
    if ! grep -q -i "anti-pattern" "$claude_file"; then
        echo "❌ Missing anti-patterns section"
        return 1
    fi

    # Must have success/optimal mentioned
    if ! grep -q -i "optimal\|success" "$claude_file"; then
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
