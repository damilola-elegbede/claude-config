#!/bin/bash
# Agent mocking framework for /verify command testing
# Provides realistic mock agent responses for wave-based testing

# Source test utilities
SCRIPT_DIR="$(dirname "$0")"
if [[ -f "$SCRIPT_DIR/../utils.sh" ]]; then
    source "$SCRIPT_DIR/../utils.sh"
fi

# Mock response generation functions

# Generate codebase-analyst mock response
generate_codebase_analyst_mock() {
    local command="$1"
    local complexity="${2:-75}"
    local requirements_count="${3:-5}"

    cat << EOF
{
  "agent": "codebase-analyst",
  "wave": 1,
  "execution_time": 2.1,
  "command_analyzed": "$command",
  "requirements": {
    "explicit": [
      "Create comprehensive test infrastructure",
      "Implement scoring algorithm validation",
      "Add performance benchmarking tests",
      "Create agent mocking framework",
      "Implement integration tests"
    ],
    "implicit": [
      "Follow existing test patterns",
      "Maintain test isolation",
      "Use portable shell scripting",
      "Ensure cross-platform compatibility"
    ],
    "total_count": $requirements_count,
    "complexity_score": $complexity,
    "confidence": 0.94
  },
  "intent_analysis": {
    "primary_goal": "Establish robust testing infrastructure for verify command",
    "secondary_objectives": [
      "Validate scoring accuracy",
      "Test wave coordination",
      "Benchmark performance"
    ],
    "architectural_impact": "medium",
    "business_impact": "high"
  },
  "context_extraction": {
    "conversation_depth": 15,
    "code_context_lines": 450,
    "git_commits_analyzed": 8,
    "files_analyzed": 12
  },
  "timestamp": "$(date -u '+%Y-%m-%d %H:%M:%S') UTC"
}
EOF
}

# Generate code-reviewer mock response
generate_code_reviewer_mock() {
    local files_changed="${1:-4}"
    local quality_score="${2:-88}"

    cat << EOF
{
  "agent": "code-reviewer",
  "wave": 1,
  "execution_time": 2.3,
  "implementation_analysis": {
    "files_changed": $files_changed,
    "lines_added": 1250,
    "lines_modified": 180,
    "quality_metrics": {
      "overall_quality": $(echo "scale=2; $quality_score / 100" | bc -l),
      "best_practices_compliance": 0.92,
      "error_handling_score": 0.85,
      "maintainability_score": 0.90,
      "documentation_score": 0.87
    },
    "code_patterns": [
      "Comprehensive error handling implemented",
      "Modular function structure maintained",
      "Clear separation of concerns",
      "Proper test organization"
    ],
    "potential_issues": [
      "Some functions could benefit from additional comments",
      "Consider extracting common test patterns"
    ]
  },
  "git_analysis": {
    "commits_reviewed": 3,
    "merge_conflicts": 0,
    "branch_health": "clean",
    "commit_message_quality": "excellent"
  },
  "confidence": 0.91,
  "timestamp": "$(date -u '+%Y-%m-%d %H:%M:%S') UTC"
}
EOF
}

# Generate test-engineer mock response
generate_test_engineer_mock() {
    local output_accuracy="${1:-80}"
    local missing_count="${2:-1}"

    cat << EOF
{
  "agent": "test-engineer",
  "wave": 1,
  "execution_time": 2.0,
  "output_validation": {
    "expected_outputs": [
      "Basic command structure tests",
      "Agent mocking framework",
      "Scoring algorithm validation",
      "Integration tests",
      "Performance benchmarks"
    ],
    "delivered_outputs": [
      "Basic command structure tests",
      "Agent mocking framework",
      "Scoring algorithm validation",
      "Integration tests"
    ],
    "accuracy_score": $(echo "scale=2; $output_accuracy / 100" | bc -l),
    "format_compliance": 0.95,
    "completeness_score": 0.82,
    "test_coverage": 0.89
  },
  "missing_elements": [
    "Performance benchmark implementation"
  ],
  "test_quality_assessment": {
    "assertion_coverage": 0.94,
    "edge_case_coverage": 0.87,
    "integration_depth": 0.91,
    "mock_framework_quality": 0.93
  },
  "recommendations": [
    "Implement remaining performance benchmarks",
    "Add more edge case scenarios",
    "Consider parameterized test cases"
  ],
  "confidence": 0.87,
  "timestamp": "$(date -u '+%Y-%m-%d %H:%M:%S') UTC"
}
EOF
}

# Generate performance-engineer mock response
generate_performance_engineer_mock() {
    local efficiency_score="${1:-78}"
    local resource_usage="${2:-82}"

    cat << EOF
{
  "agent": "performance-engineer",
  "wave": 1,
  "execution_time": 2.4,
  "performance_metrics": {
    "execution_efficiency": $(echo "scale=2; $efficiency_score / 100" | bc -l),
    "resource_utilization": $(echo "scale=2; $resource_usage / 100" | bc -l),
    "memory_usage": {
      "peak_mb": 145,
      "average_mb": 98,
      "efficiency": 0.85
    },
    "cpu_utilization": {
      "peak_percentage": 45,
      "average_percentage": 28,
      "efficiency": 0.82
    },
    "io_metrics": {
      "disk_reads": 234,
      "disk_writes": 89,
      "network_calls": 0
    },
    "scalability_score": 0.85,
    "optimization_opportunities": [
      "Consider caching parsed JSON responses",
      "Parallelize independent validations",
      "Optimize shell script execution patterns"
    ]
  },
  "benchmarking": {
    "baseline_execution_time": 4.2,
    "current_execution_time": 3.8,
    "improvement_percentage": 9.5,
    "target_execution_time": 3.2
  },
  "confidence": 0.89,
  "timestamp": "$(date -u '+%Y-%m-%d %H:%M:%S') UTC"
}
EOF
}

# Generate security-auditor mock response
generate_security_auditor_mock() {
    local compliance_score="${1:-96}"
    local vulnerability_count="${2:-0}"

    cat << EOF
{
  "agent": "security-auditor",
  "wave": 1,
  "execution_time": 1.8,
  "security_assessment": {
    "vulnerability_scan": {
      "critical": 0,
      "high": 0,
      "medium": 0,
      "low": $vulnerability_count,
      "total": $vulnerability_count
    },
    "compliance_score": $(echo "scale=2; $compliance_score / 100" | bc -l),
    "security_best_practices": {
      "input_validation": 0.95,
      "output_sanitization": 0.93,
      "file_permissions": 0.98,
      "execution_safety": 0.91
    },
    "risk_assessment": {
      "overall_risk": "low",
      "data_exposure": "none",
      "privilege_escalation": "none",
      "injection_risks": "minimal"
    },
    "security_patterns": [
      "Proper shell script quoting implemented",
      "File path validation in place",
      "No hardcoded sensitive data found",
      "Safe temporary file handling"
    ]
  },
  "recommendations": [
    "Continue following secure coding practices",
    "Consider adding input size limits for very large commands",
    "Document security assumptions in README"
  ],
  "confidence": 0.95,
  "timestamp": "$(date -u '+%Y-%m-%d %H:%M:%S') UTC"
}
EOF
}

# Generate business-analyst mock response (Wave 2)
generate_business_analyst_mock() {
    local satisfaction_score="${1:-82}"
    local gaps_count="${2:-2}"

    cat << EOF
{
  "agent": "business-analyst",
  "wave": 2,
  "execution_time": 1.1,
  "business_alignment": {
    "requirement_satisfaction": $(echo "scale=2; $satisfaction_score / 100" | bc -l),
    "business_value_score": 0.88,
    "stakeholder_needs": {
      "development_team": 0.92,
      "qa_team": 0.89,
      "operations_team": 0.78,
      "end_users": 0.85
    },
    "roi_analysis": {
      "development_time_saved": "15-20%",
      "bug_detection_improvement": "35%",
      "maintenance_cost_reduction": "25%"
    }
  },
  "gaps_identified": [
    "User acceptance criteria not fully defined",
    "Performance SLAs need specification"
  ],
  "business_impact": {
    "immediate": "Improved test coverage and reliability",
    "short_term": "Faster development cycles",
    "long_term": "Reduced maintenance overhead"
  },
  "stakeholder_feedback": {
    "positive_aspects": [
      "Comprehensive testing approach",
      "Good integration with existing patterns",
      "Clear documentation structure"
    ],
    "concerns": [
      "Execution time for comprehensive tests",
      "Learning curve for new test patterns"
    ]
  },
  "confidence": 0.83,
  "timestamp": "$(date -u '+%Y-%m-%d %H:%M:%S') UTC"
}
EOF
}

# Generate debugger mock response (Wave 2)
generate_debugger_mock() {
    local instance_id="${1:-1}"
    local gap_type="${2:-missing_requirements}"
    local severity="${3:-medium}"

    cat << EOF
{
  "agent": "debugger_$instance_id",
  "wave": 2,
  "execution_time": 1.3,
  "investigation_focus": "$gap_type",
  "gap_analysis": {
    "root_cause": "Performance benchmarks deprioritized due to time constraints",
    "severity": "$severity",
    "impact_assessment": {
      "functionality": "minimal",
      "user_experience": "low",
      "maintenance": "medium",
      "scalability": "medium"
    },
    "fix_complexity": "low",
    "estimated_effort": "2-3 hours",
    "dependencies": [
      "Shell performance measurement utilities",
      "Baseline performance data collection"
    ]
  },
  "investigation_methods": [
    "Code analysis of missing components",
    "Review of similar implementations",
    "Effort estimation based on existing patterns",
    "Dependency mapping"
  ],
  "fix_recommendations": [
    {
      "priority": "high",
      "description": "Implement basic performance timing tests",
      "effort": "1-2 hours",
      "risk": "low"
    },
    {
      "priority": "medium",
      "description": "Add resource utilization monitoring",
      "effort": "2-3 hours",
      "risk": "medium"
    }
  ],
  "confidence": 0.91,
  "timestamp": "$(date -u '+%Y-%m-%d %H:%M:%S') UTC"
}
EOF
}

# Generate project-orchestrator mock response (Wave 3)
generate_project_orchestrator_mock() {
    local req_score="${1:-84}"
    local impl_score="${2:-89}"
    local output_score="${3:-82}"
    local perf_score="${4:-78}"
    local extra_score="${5:-86}"

    # Calculate overall score using weighted algorithm
    local overall_score=$(( (req_score * 30 + impl_score * 25 + output_score * 20 + perf_score * 15 + extra_score * 10) / 100 ))

    cat << EOF
{
  "agent": "project-orchestrator",
  "wave": 3,
  "execution_time": 0.6,
  "scoring_calculation": {
    "algorithm_version": "1.0",
    "calculation_method": "weighted_average",
    "category_scores": {
      "requirement_completeness": {
        "score": $(echo "scale=2; $req_score / 100" | bc -l),
        "weight": 0.30,
        "weighted_value": $(echo "scale=2; $req_score * 30 / 10000" | bc -l)
      },
      "implementation_quality": {
        "score": $(echo "scale=2; $impl_score / 100" | bc -l),
        "weight": 0.25,
        "weighted_value": $(echo "scale=2; $impl_score * 25 / 10000" | bc -l)
      },
      "output_accuracy": {
        "score": $(echo "scale=2; $output_score / 100" | bc -l),
        "weight": 0.20,
        "weighted_value": $(echo "scale=2; $output_score * 20 / 10000" | bc -l)
      },
      "performance_efficiency": {
        "score": $(echo "scale=2; $perf_score / 100" | bc -l),
        "weight": 0.15,
        "weighted_value": $(echo "scale=2; $perf_score * 15 / 10000" | bc -l)
      },
      "extras_deviations": {
        "score": $(echo "scale=2; $extra_score / 100" | bc -l),
        "weight": 0.10,
        "weighted_value": $(echo "scale=2; $extra_score * 10 / 10000" | bc -l)
      }
    },
    "overall_score": $(echo "scale=2; $overall_score / 100" | bc -l),
    "confidence": 0.92
  },
  "score_analysis": {
    "strengths": [
      "Strong implementation quality",
      "Good requirement coverage",
      "Solid extras and enhancements"
    ],
    "improvement_areas": [
      "Performance optimization opportunities",
      "Output format consistency"
    ],
    "score_trends": {
      "compared_to_baseline": "+12%",
      "category_balance": "well_balanced",
      "consistency": "high"
    }
  },
  "validation": {
    "score_range_check": "passed",
    "weight_sum_validation": "passed",
    "category_correlation": "normal"
  },
  "timestamp": "$(date -u '+%Y-%m-%d %H:%M:%S') UTC"
}
EOF
}

# Wave coordination simulation
simulate_wave_execution() {
    local depth_level="${1:-standard}"
    local command="${2:-/test --create comprehensive-test-suite}"

    echo "=== WAVE EXECUTION SIMULATION ==="
    echo "Depth Level: $depth_level"
    echo "Command: $command"
    echo "Timestamp: $(date -u '+%Y-%m-%d %H:%M:%S') UTC"
    echo ""

    # Wave 1: Always executed
    echo "🌊 WAVE 1: Initial Analysis (Parallel Execution)"
    local wave1_start=$(date +%s)

    local agents=("codebase-analyst" "code-reviewer" "test-engineer" "performance-engineer" "security-auditor")
    for agent in "${agents[@]}"; do
        echo "  📊 $agent: ANALYZING..."
        sleep 0.02  # Simulate processing time
        echo "  ✅ $agent: COMPLETED"
    done

    local wave1_end=$(date +%s)
    local wave1_duration=$((wave1_end - wave1_start))
    echo "  ⏱️  Wave 1 Duration: ${wave1_duration}s (simulated: 60-120s)"
    echo ""

    # Wave 2: Conditional based on depth and findings
    if [[ "$depth_level" == "standard" || "$depth_level" == "comprehensive" ]]; then
        echo "🌊 WAVE 2: Conditional Deep Analysis"
        local wave2_start=$(date +%s)

        # Simulate conditional deployment
        local gaps_found=2
        local business_changes=1

        if [[ $gaps_found -gt 0 ]]; then
            echo "  📊 business-analyst: ANALYZING ($business_changes business logic changes detected)..."
            sleep 0.01
            echo "  ✅ business-analyst: COMPLETED"
        fi

        if [[ $gaps_found -gt 0 ]]; then
            echo "  📊 debugger_1: INVESTIGATING ($gaps_found gaps identified)..."
            sleep 0.01
            echo "  ✅ debugger_1: COMPLETED"
        fi

        local wave2_end=$(date +%s)
        local wave2_duration=$((wave2_end - wave2_start))
        echo "  ⏱️  Wave 2 Duration: ${wave2_duration}s (simulated: 90-150s)"
        echo ""
    fi

    # Wave 3: Synthesis (for standard and comprehensive)
    if [[ "$depth_level" == "standard" || "$depth_level" == "comprehensive" ]]; then
        echo "🌊 WAVE 3: Final Synthesis & Scoring"
        local wave3_start=$(date +%s)

        local synthesis_agents=("tech-writer" "project-orchestrator" "code-reviewer")
        for agent in "${synthesis_agents[@]}"; do
            echo "  📊 $agent: SYNTHESIZING..."
            sleep 0.01
            echo "  ✅ $agent: COMPLETED"
        done

        local wave3_end=$(date +%s)
        local wave3_duration=$((wave3_end - wave3_start))
        echo "  ⏱️  Wave 3 Duration: ${wave3_duration}s (simulated: 30-60s)"
        echo ""
    fi

    # Final results
    echo "📊 EXECUTION SUMMARY:"
    case "$depth_level" in
        "basic")
            echo "  Agents Deployed: 5 (Wave 1 only)"
            echo "  Total Duration: ~60s"
            ;;
        "standard")
            echo "  Agents Deployed: 8-10 (Waves 1-2, Wave 3 synthesis)"
            echo "  Total Duration: ~180-330s"
            ;;
        "comprehensive")
            echo "  Agents Deployed: 12-14 (All waves, maximum analysis)"
            echo "  Total Duration: ~240-360s"
            ;;
    esac

    echo "  Overall Score: 84.2%"
    echo "  Status: ✅ COMPLETED SUCCESSFULLY"
    echo ""
}

# Generate complete mock response set
generate_full_mock_set() {
    local output_dir="${1:-/tmp/verify-mocks-$$}"
    local command="${2:-/test --create comprehensive-test-suite}"

    mkdir -p "$output_dir"

    echo "Generating complete mock response set in: $output_dir"

    # Wave 1 responses
    generate_codebase_analyst_mock "$command" > "$output_dir/codebase-analyst.json"
    generate_code_reviewer_mock > "$output_dir/code-reviewer.json"
    generate_test_engineer_mock > "$output_dir/test-engineer.json"
    generate_performance_engineer_mock > "$output_dir/performance-engineer.json"
    generate_security_auditor_mock > "$output_dir/security-auditor.json"

    # Wave 2 responses
    generate_business_analyst_mock > "$output_dir/business-analyst.json"
    generate_debugger_mock 1 "missing_requirements" > "$output_dir/debugger_1.json"
    generate_debugger_mock 2 "performance_issues" > "$output_dir/debugger_2.json"

    # Wave 3 responses
    generate_project_orchestrator_mock > "$output_dir/project-orchestrator.json"

    echo "Mock response set generated with $(ls -1 "$output_dir" | wc -l) files"
    echo "Files created:"
    ls -la "$output_dir/"
}

# Validate mock response JSON
validate_mock_responses() {
    local mock_dir="$1"

    if [[ ! -d "$mock_dir" ]]; then
        echo "Mock directory not found: $mock_dir"
        return 1
    fi

    echo "Validating mock responses in: $mock_dir"

    local failed_validations=0
    local total_files=0

    for json_file in "$mock_dir"/*.json; do
        if [[ -f "$json_file" ]]; then
            ((total_files++))
            echo -n "  Validating $(basename "$json_file"): "

            if command -v python3 > /dev/null 2>&1; then
                if python3 -c "import json; json.load(open('$json_file'))" 2>/dev/null; then
                    echo "✅ Valid"
                else
                    echo "❌ Invalid JSON"
                    ((failed_validations++))
                fi
            else
                # Basic JSON validation without python
                if grep -q '^\s*{' "$json_file" && grep -q '^\s*}' "$json_file"; then
                    echo "✅ Basic structure valid"
                else
                    echo "❌ Invalid basic structure"
                    ((failed_validations++))
                fi
            fi
        fi
    done

    echo ""
    echo "Validation Summary:"
    echo "  Total files: $total_files"
    echo "  Valid: $((total_files - failed_validations))"
    echo "  Failed: $failed_validations"

    return $failed_validations
}

# Export all functions for use in other scripts
export -f generate_codebase_analyst_mock generate_code_reviewer_mock
export -f generate_test_engineer_mock generate_performance_engineer_mock
export -f generate_security_auditor_mock generate_business_analyst_mock
export -f generate_debugger_mock generate_project_orchestrator_mock
export -f simulate_wave_execution generate_full_mock_set validate_mock_responses

# If script is called directly, run demonstration
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Agent Mocking Framework for /verify Command Testing"
    echo "===================================================="
    echo ""

    # Generate sample mock set
    DEMO_DIR="/tmp/verify-mock-demo-$$"
    generate_full_mock_set "$DEMO_DIR" "/test --create comprehensive-test-suite"

    echo ""
    validate_mock_responses "$DEMO_DIR"

    echo ""
    simulate_wave_execution "comprehensive" "/test --create comprehensive-test-suite"

    # Cleanup demo
    rm -rf "$DEMO_DIR"

    echo "Demo completed. Agent mocking framework ready for use."
fi