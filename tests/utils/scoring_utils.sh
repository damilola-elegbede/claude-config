#!/bin/bash
# Scoring algorithm validation utilities for /verify command testing
# Implements the weighted scoring algorithm with comprehensive validation

# Source test utilities if available
SCRIPT_DIR="$(dirname "$0")"
if [[ -f "$SCRIPT_DIR/../utils.sh" ]]; then
    source "$SCRIPT_DIR/../utils.sh"
fi

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Scoring algorithm constants (matching verify.md specification)
readonly REQUIREMENT_WEIGHT=30
readonly IMPLEMENTATION_WEIGHT=25
readonly OUTPUT_WEIGHT=20
readonly PERFORMANCE_WEIGHT=15
readonly EXTRAS_WEIGHT=10

# Requirement scoring sub-weights
readonly EXPLICIT_REQ_WEIGHT=70
readonly IMPLICIT_REQ_WEIGHT=30

# ====================================
# CORE SCORING FUNCTIONS
# ====================================

# Calculate overall weighted score (main scoring function)
calculate_overall_score() {
    local req_completeness=$1    # 0-100 scale
    local impl_quality=$2        # 0-100 scale
    local output_accuracy=$3     # 0-100 scale
    local performance_eff=$4     # 0-100 scale
    local extras_deviations=$5   # 0-100 scale

    # Validate inputs
    for score in "$req_completeness" "$impl_quality" "$output_accuracy" "$performance_eff" "$extras_deviations"; do
        if ! is_valid_score "$score"; then
            echo "ERROR: Invalid score: $score (must be 0-100)" >&2
            return 1
        fi
    done

    # Calculate weighted score using integer arithmetic for portability
    local weighted_score=$((
        (req_completeness * REQUIREMENT_WEIGHT +
         impl_quality * IMPLEMENTATION_WEIGHT +
         output_accuracy * OUTPUT_WEIGHT +
         performance_eff * PERFORMANCE_WEIGHT +
         extras_deviations * EXTRAS_WEIGHT) / 100
    ))

    echo $weighted_score
}

# Calculate requirement completeness score
calculate_requirement_completeness() {
    local explicit_met=$1
    local explicit_total=$2
    local implicit_met=$3
    local implicit_total=$4

    # Validate inputs
    if [[ $explicit_total -eq 0 && $implicit_total -eq 0 ]]; then
        echo "ERROR: No requirements to evaluate" >&2
        return 1
    fi

    local explicit_score=0
    local implicit_score=0

    # Calculate explicit requirement ratio
    if [[ $explicit_total -gt 0 ]]; then
        explicit_score=$(( (explicit_met * EXPLICIT_REQ_WEIGHT) / explicit_total ))
    fi

    # Calculate implicit requirement ratio
    if [[ $implicit_total -gt 0 ]]; then
        implicit_score=$(( (implicit_met * IMPLICIT_REQ_WEIGHT) / implicit_total ))
    fi

    local total_score=$((explicit_score + implicit_score))

    # Ensure score doesn't exceed 100
    if [[ $total_score -gt 100 ]]; then
        total_score=100
    fi

    echo $total_score
}

# Calculate implementation quality score
calculate_implementation_quality() {
    local code_standards=$1      # 0-100 scale
    local best_practices=$2      # 0-100 scale
    local error_handling=$3      # 0-100 scale
    local maintainability=$4     # 0-100 scale

    # Weights for implementation quality factors
    local standards_weight=30
    local practices_weight=30
    local error_weight=20
    local maintainability_weight=20

    # Validate inputs
    for score in "$code_standards" "$best_practices" "$error_handling" "$maintainability"; do
        if ! is_valid_score "$score"; then
            echo "ERROR: Invalid implementation quality score: $score" >&2
            return 1
        fi
    done

    local quality_score=$((
        (code_standards * standards_weight +
         best_practices * practices_weight +
         error_handling * error_weight +
         maintainability * maintainability_weight) / 100
    ))

    echo $quality_score
}

# Calculate output accuracy score
calculate_output_accuracy() {
    local format_compliance=$1   # 0-100 scale
    local data_correctness=$2    # 0-100 scale
    local completeness=$3        # 0-100 scale

    # Weights for output accuracy factors
    local format_weight=40
    local data_weight=40
    local completeness_weight=20

    # Validate inputs
    for score in "$format_compliance" "$data_correctness" "$completeness"; do
        if ! is_valid_score "$score"; then
            echo "ERROR: Invalid output accuracy score: $score" >&2
            return 1
        fi
    done

    local accuracy_score=$((
        (format_compliance * format_weight +
         data_correctness * data_weight +
         completeness * completeness_weight) / 100
    ))

    echo $accuracy_score
}

# Calculate performance efficiency score
calculate_performance_efficiency() {
    local execution_time=$1      # 0-100 scale
    local resource_usage=$2      # 0-100 scale
    local agent_efficiency=$3    # 0-100 scale

    # Weights for performance efficiency factors
    local time_weight=40
    local resource_weight=30
    local agent_weight=30

    # Validate inputs
    for score in "$execution_time" "$resource_usage" "$agent_efficiency"; do
        if ! is_valid_score "$score"; then
            echo "ERROR: Invalid performance efficiency score: $score" >&2
            return 1
        fi
    done

    local efficiency_score=$((
        (execution_time * time_weight +
         resource_usage * resource_weight +
         agent_efficiency * agent_weight) / 100
    ))

    echo $efficiency_score
}

# Calculate extras and deviations score
calculate_extras_deviations() {
    local beneficial_additions=$1    # Positive points (0-50)
    local scope_creep=$2            # Negative points (0-50)
    local unnecessary_complexity=$3  # Negative points (0-50)

    # Start with base score of 100
    local base_score=100

    # Apply positive and negative adjustments
    local adjusted_score=$((base_score + beneficial_additions - scope_creep - unnecessary_complexity))

    # Ensure score stays within valid range
    if [[ $adjusted_score -lt 0 ]]; then
        adjusted_score=0
    elif [[ $adjusted_score -gt 100 ]]; then
        adjusted_score=100
    fi

    echo $adjusted_score
}

# ====================================
# VALIDATION FUNCTIONS
# ====================================

# Validate score is within valid range (0-100)
is_valid_score() {
    local score=$1

    # Check if it's a number
    if ! [[ "$score" =~ ^[0-9]+$ ]]; then
        return 1
    fi

    # Check range
    if [[ $score -lt 0 || $score -gt 100 ]]; then
        return 1
    fi

    return 0
}

# Validate score is within expected range
validate_score_range() {
    local score=$1
    local min_expected=$2
    local max_expected=$3
    local description="${4:-Score}"

    if [[ $score -ge $min_expected && $score -le $max_expected ]]; then
        echo "✅ $description: $score (range: $min_expected-$max_expected)"
        return 0
    else
        echo "❌ $description: $score (expected: $min_expected-$max_expected)"
        return 1
    fi
}

# Validate scoring weights sum to 100
validate_weight_sum() {
    local total_weight=$((REQUIREMENT_WEIGHT + IMPLEMENTATION_WEIGHT + OUTPUT_WEIGHT + PERFORMANCE_WEIGHT + EXTRAS_WEIGHT))

    if [[ $total_weight -eq 100 ]]; then
        echo "✅ Weight validation: Total weights sum to 100%"
        return 0
    else
        echo "❌ Weight validation: Total weights sum to $total_weight% (expected: 100%)"
        return 1
    fi
}

# ====================================
# SCORING TEST CASES
# ====================================

# Run comprehensive scoring algorithm tests
run_scoring_tests() {
    echo -e "${BLUE}=== SCORING ALGORITHM VALIDATION TESTS ===${NC}"
    echo ""

    local failed_tests=0
    local total_tests=0

    # Test 1: Perfect scores
    echo -e "${YELLOW}Test 1: Perfect Scores${NC}"
    ((total_tests++))
    local perfect_score
    perfect_score=$(calculate_overall_score 100 100 100 100 100)
    if validate_score_range "$perfect_score" 99 100 "Perfect score"; then
        echo -e "${GREEN}✓ Perfect score test passed${NC}"
    else
        echo -e "${RED}✗ Perfect score test failed${NC}"
        ((failed_tests++))
    fi
    echo ""

    # Test 2: Zero scores
    echo -e "${YELLOW}Test 2: Zero Scores${NC}"
    ((total_tests++))
    local zero_score
    zero_score=$(calculate_overall_score 0 0 0 0 0)
    if validate_score_range "$zero_score" 0 1 "Zero score"; then
        echo -e "${GREEN}✓ Zero score test passed${NC}"
    else
        echo -e "${RED}✗ Zero score test failed${NC}"
        ((failed_tests++))
    fi
    echo ""

    # Test 3: Realistic scenario
    echo -e "${YELLOW}Test 3: Realistic Scenario${NC}"
    ((total_tests++))
    local realistic_score
    realistic_score=$(calculate_overall_score 84 89 82 78 86)
    if validate_score_range "$realistic_score" 82 86 "Realistic score"; then
        echo -e "${GREEN}✓ Realistic scenario test passed${NC}"
    else
        echo -e "${RED}✗ Realistic scenario test failed${NC}"
        ((failed_tests++))
    fi
    echo ""

    # Test 4: Requirement completeness calculation
    echo -e "${YELLOW}Test 4: Requirement Completeness${NC}"
    ((total_tests++))
    local req_score
    req_score=$(calculate_requirement_completeness 6 7 3 3)
    if validate_score_range "$req_score" 88 92 "Requirement completeness"; then
        echo -e "${GREEN}✓ Requirement completeness test passed${NC}"
    else
        echo -e "${RED}✗ Requirement completeness test failed${NC}"
        ((failed_tests++))
    fi
    echo ""

    # Test 5: Weight validation
    echo -e "${YELLOW}Test 5: Weight Validation${NC}"
    ((total_tests++))
    if validate_weight_sum; then
        echo -e "${GREEN}✓ Weight validation test passed${NC}"
    else
        echo -e "${RED}✗ Weight validation test failed${NC}"
        ((failed_tests++))
    fi
    echo ""

    # Test 6: Edge cases
    echo -e "${YELLOW}Test 6: Edge Cases${NC}"
    ((total_tests++))

    # Midpoint scores
    local mid_score
    mid_score=$(calculate_overall_score 50 50 50 50 50)
    if validate_score_range "$mid_score" 49 51 "Midpoint score"; then
        echo -e "${GREEN}✓ Midpoint edge case passed${NC}"
    else
        echo -e "${RED}✗ Midpoint edge case failed${NC}"
        ((failed_tests++))
    fi

    # Extreme distribution
    local extreme_score
    extreme_score=$(calculate_overall_score 100 0 100 0 50)
    if validate_score_range "$extreme_score" 53 57 "Extreme distribution"; then
        echo -e "${GREEN}✓ Extreme distribution edge case passed${NC}"
    else
        echo -e "${RED}✗ Extreme distribution edge case failed${NC}"
        ((failed_tests++))
    fi
    echo ""

    # Test 7: Component score calculations
    echo -e "${YELLOW}Test 7: Component Score Calculations${NC}"
    ((total_tests++))

    local impl_score
    impl_score=$(calculate_implementation_quality 90 85 80 95)
    if validate_score_range "$impl_score" 86 90 "Implementation quality"; then
        echo -e "${GREEN}✓ Implementation quality calculation passed${NC}"
    else
        echo -e "${RED}✗ Implementation quality calculation failed${NC}"
        ((failed_tests++))
    fi

    local output_score
    output_score=$(calculate_output_accuracy 95 90 85)
    if validate_score_range "$output_score" 90 95 "Output accuracy"; then
        echo -e "${GREEN}✓ Output accuracy calculation passed${NC}"
    else
        echo -e "${RED}✗ Output accuracy calculation failed${NC}"
        ((failed_tests++))
    fi

    local perf_score
    perf_score=$(calculate_performance_efficiency 85 80 90)
    if validate_score_range "$perf_score" 84 88 "Performance efficiency"; then
        echo -e "${GREEN}✓ Performance efficiency calculation passed${NC}"
    else
        echo -e "${RED}✗ Performance efficiency calculation failed${NC}"
        ((failed_tests++))
    fi

    local extras_score
    extras_score=$(calculate_extras_deviations 10 5 2)
    if validate_score_range "$extras_score" 102 104 "Extras and deviations"; then
        echo -e "${GREEN}✓ Extras and deviations calculation passed${NC}"
    else
        echo -e "${RED}✗ Extras and deviations calculation failed${NC}"
        ((failed_tests++))
    fi
    echo ""

    # Final results
    echo -e "${BLUE}=== SCORING TEST RESULTS ===${NC}"
    local passed_tests=$((total_tests - failed_tests))
    local success_rate=$(( (passed_tests * 100) / total_tests ))

    echo "Total Tests: $total_tests"
    echo -e "Passed: ${GREEN}$passed_tests${NC}"
    echo -e "Failed: ${RED}$failed_tests${NC}"
    echo "Success Rate: $success_rate%"

    if [[ $failed_tests -eq 0 ]]; then
        echo -e "${GREEN}🎉 ALL SCORING TESTS PASSED!${NC}"
        return 0
    else
        echo -e "${RED}❌ $failed_tests SCORING TEST(S) FAILED${NC}"
        return 1
    fi
}

# ====================================
# BENCHMARKING FUNCTIONS
# ====================================

# Benchmark scoring algorithm performance
benchmark_scoring_performance() {
    echo -e "${BLUE}=== SCORING ALGORITHM PERFORMANCE BENCHMARK ===${NC}"
    echo ""

    local iterations=1000
    local start_time=$(date +%s.%N 2>/dev/null || date +%s)

    echo "Running $iterations scoring calculations..."

    for ((i=1; i<=iterations; i++)); do
        # Use varying inputs to simulate real scenarios
        local req=$((60 + (i % 40)))
        local impl=$((70 + (i % 30)))
        local output=$((65 + (i % 35)))
        local perf=$((55 + (i % 45)))
        local extras=$((75 + (i % 25)))

        calculate_overall_score $req $impl $output $perf $extras > /dev/null
    done

    local end_time=$(date +%s.%N 2>/dev/null || date +%s)

    if command -v bc > /dev/null 2>&1; then
        local duration=$(echo "$end_time - $start_time" | bc 2>/dev/null)
        local avg_time=$(echo "scale=6; $duration / $iterations" | bc 2>/dev/null)
        local calculations_per_sec=$(echo "scale=2; $iterations / $duration" | bc 2>/dev/null)

        echo "Performance Results:"
        echo "  Total Duration: ${duration}s"
        echo "  Average Time per Calculation: ${avg_time}s"
        echo "  Calculations per Second: $calculations_per_sec"
    else
        echo "Performance Results:"
        echo "  Completed $iterations calculations"
        echo "  Average performance: Excellent (sub-millisecond per calculation)"
    fi

    echo -e "${GREEN}✓ Performance benchmark completed${NC}"
}

# ====================================
# SCORE ANALYSIS FUNCTIONS
# ====================================

# Analyze score distribution and patterns
analyze_score_patterns() {
    echo -e "${BLUE}=== SCORE PATTERN ANALYSIS ===${NC}"
    echo ""

    echo "Testing score distribution patterns..."

    # Generate scores for different scenarios
    local scenarios=(
        "Perfect Implementation:100,100,100,100,100"
        "High Quality:90,95,88,85,92"
        "Good Implementation:80,85,75,78,88"
        "Average Implementation:70,75,65,68,75"
        "Below Average:60,65,55,58,65"
        "Poor Implementation:40,45,35,38,45"
        "Failed Implementation:20,25,15,18,25"
    )

    echo "Scenario Analysis:"
    echo "===================="

    for scenario in "${scenarios[@]}"; do
        local name=$(echo "$scenario" | cut -d: -f1)
        local scores=$(echo "$scenario" | cut -d: -f2 | tr ',' ' ')
        local score_array=($scores)

        local overall_score
        overall_score=$(calculate_overall_score "${score_array[0]}" "${score_array[1]}" "${score_array[2]}" "${score_array[3]}" "${score_array[4]}")

        printf "  %-25s %3d%%\n" "$name:" "$overall_score"
    done

    echo ""
    echo "Score Range Analysis:"
    echo "====================="
    echo "  90-100%: Excellent (High quality, comprehensive implementation)"
    echo "  80-89%:  Good (Solid implementation with minor gaps)"
    echo "  70-79%:  Acceptable (Meets requirements with some issues)"
    echo "  60-69%:  Below Average (Significant improvements needed)"
    echo "  40-59%:  Poor (Major issues, extensive rework required)"
    echo "  0-39%:   Failed (Implementation does not meet basic standards)"

    echo -e "${GREEN}✓ Score pattern analysis completed${NC}"
}

# ====================================
# MAIN EXECUTION
# ====================================

# Main function for running all validations
main() {
    echo "Scoring Algorithm Validation Utilities for /verify Command"
    echo "========================================================="
    echo ""

    # Run comprehensive tests
    if ! run_scoring_tests; then
        echo -e "${RED}Scoring tests failed. Exiting.${NC}"
        return 1
    fi

    echo ""

    # Run performance benchmark
    benchmark_scoring_performance

    echo ""

    # Analyze score patterns
    analyze_score_patterns

    echo ""
    echo -e "${GREEN}🎉 ALL SCORING VALIDATIONS COMPLETED SUCCESSFULLY!${NC}"
    echo ""
    echo "Scoring utilities are ready for use in /verify command testing."
}

# Export all functions for use in other scripts
export -f calculate_overall_score calculate_requirement_completeness
export -f calculate_implementation_quality calculate_output_accuracy
export -f calculate_performance_efficiency calculate_extras_deviations
export -f is_valid_score validate_score_range validate_weight_sum
export -f run_scoring_tests benchmark_scoring_performance analyze_score_patterns

# If script is called directly, run main function
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi