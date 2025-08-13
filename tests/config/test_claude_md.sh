#!/bin/bash
# Test for CLAUDE.md validation

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test CLAUDE.md exists
test_claude_md_exists() {
    assert_file_exists "$ORIGINAL_DIR/CLAUDE.md" \
        "CLAUDE.md should exist in repository root"
}

# Test CLAUDE.md effectiveness criteria
test_claude_md_effectiveness() {
    local claude_file="$ORIGINAL_DIR/CLAUDE.md"
    local line_count=$(wc -l < "$claude_file")
    local word_count=$(wc -w < "$claude_file")
    local score=10
    local reasons=()
    
    # CRITICAL: Size limits for attention/effectiveness
    # Based on analysis: >100 lines = attention drops, >200 lines = ignored
    if [ "$line_count" -gt 100 ]; then
        score=$((score - 3))
        reasons+=("Too long ($line_count lines > 100): Claude will lose attention")
    fi
    
    if [ "$line_count" -gt 200 ]; then
        score=$((score - 5))
        reasons+=("Massively too long ($line_count lines > 200): Will be ignored")
    fi
    
    # Word density check (should be concise, not verbose)
    words_per_line=$((word_count / line_count))
    if [ "$words_per_line" -gt 20 ]; then
        score=$((score - 2))
        reasons+=("Too verbose ($words_per_line words/line > 20): Needs tighter editing")
    fi
    
    # Must have role definition
    if ! grep -q -i "orchestrat\|coordinat\|CTO\|chief\|manage" "$claude_file"; then
        score=$((score - 2))
        reasons+=("Missing role definition: Must clearly define Claude's role")
    fi
    
    # Must have mandatory delegations (core requirement)
    if ! grep -q "MANDATORY" "$claude_file"; then
        score=$((score - 3))
        reasons+=("Missing MANDATORY section: Core orchestration rules absent")
    fi
    
    # Must have consequences/enforcement
    if ! grep -q -i "fail\|violat\|consequenc" "$claude_file"; then
        score=$((score - 2))
        reasons+=("No enforcement: Rules without consequences are ignored")
    fi
    
    # Must be actionable (not just theory)
    if ! grep -q -E "→|USE|STOP|Deploy" "$claude_file"; then
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
    
    # Require 9/10 or higher (brutal standard)
    if [ "$score" -lt 9 ]; then
        echo "❌ CLAUDE.md effectiveness score too low: $score/10 (requires ≥9/10)"
        echo "   This file will not be effective at changing Claude's behavior"
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
    test_claude_md_effectiveness
}

# Execute if called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_claude_md_tests
fi