#!/bin/bash
# Test for CLAUDE.md validation

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test CLAUDE.md exists - check system config version for orchestration rules
test_claude_md_exists() {
    assert_file_exists "$ORIGINAL_DIR/system-configs/CLAUDE.md" \
        "System CLAUDE.md should exist in system-configs directory"
}

# Test CLAUDE.md effectiveness criteria - check system config for orchestration
test_claude_md_effectiveness() {
    local claude_file="$ORIGINAL_DIR/system-configs/CLAUDE.md"
    local line_count=$(wc -l < "$claude_file")
    local word_count=$(wc -w < "$claude_file")
    local score=10
    local reasons=()
    
    # CRITICAL: Size limits for attention/effectiveness
    # Executive framework requires more detail, adjusted thresholds
    if [ "$line_count" -gt 150 ]; then
        score=$((score - 2))
        reasons+=("Getting long ($line_count lines > 150): May affect attention")
    fi
    
    if [ "$line_count" -gt 250 ]; then
        score=$((score - 4))
        reasons+=("Too long ($line_count lines > 250): Will impact effectiveness")
    fi
    
    # Word density check (should be concise, not verbose)
    words_per_line=$((word_count / line_count))
    if [ "$words_per_line" -gt 20 ]; then
        score=$((score - 2))
        reasons+=("Too verbose ($words_per_line words/line > 20): Needs tighter editing")
    fi
    
    # Must have executive role definition (Fortune 500 CTO)
    if ! grep -q -i "CTO\|chief\|executive" "$claude_file"; then
        score=$((score - 2))
        reasons+=("Missing executive role: Must define Fortune 500 CTO role")
    fi
    
    # Must have mandatory delegations (core requirement)
    if ! grep -q "MANDATORY" "$claude_file"; then
        score=$((score - 3))
        reasons+=("Missing MANDATORY section: Core orchestration rules absent")
    fi
    
    # Must have executive mental models section
    if ! grep -q "Executive Mental Models\|ROI Thinking" "$claude_file"; then
        score=$((score - 1))
        reasons+=("Missing mental models: Executive decision frameworks required")
    fi
    
    # Must have parallel execution guidance
    if ! grep -q -i "parallel\|simultaneous\|concurrent" "$claude_file"; then
        score=$((score - 2))
        reasons+=("Missing parallel execution: CTO must orchestrate teams in parallel")
    fi
    
    # Must have success metrics
    if ! grep -q "Success Metrics\|Successful CTO" "$claude_file"; then
        score=$((score - 1))
        reasons+=("Missing success metrics: Need clear behavior indicators")
    fi
    
    # Must have executive escalation authority
    if ! grep -q -i "escalat\|override\|authority" "$claude_file"; then
        score=$((score - 1))
        reasons+=("No escalation authority: Executive needs override powers")
    fi
    
    # Must have consequences/enforcement
    if ! grep -q -i "fail\|violat\|consequenc" "$claude_file"; then
        score=$((score - 2))
        reasons+=("No enforcement: Rules without consequences are ignored")
    fi
    
    # Must be actionable (not just theory)
    if ! grep -q -E "→|Deploy|strategic|delegate" "$claude_file"; then
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
    
    # Require 8/10 or higher for executive framework (more complex requirements)
    if [ "$score" -lt 8 ]; then
        echo "❌ CLAUDE.md effectiveness score too low: $score/10 (requires ≥8/10)"
        echo "   Executive framework needs improvements to be effective"
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