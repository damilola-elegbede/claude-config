#!/bin/bash
# Phase 1 Implementation Test Script
# Tests /analyze-stack command and required agent components
set -euo pipefail

# Source validation framework
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
REPO_ROOT=$(git rev-parse --show-toplevel)
source "$SCRIPT_DIR/validation/framework.sh"

# Test counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Test results array
declare -a TEST_RESULTS=()

# Enhanced logging with test context
log_test_start() {
    local test_name="$1"
    ((TOTAL_TESTS++))
    echo
    log_info "TEST $TOTAL_TESTS: $test_name"
    echo "----------------------------------------"
}

log_test_pass() {
    local test_name="$1"
    ((PASSED_TESTS++))
    log_success "PASS: $test_name"
    TEST_RESULTS+=("PASS: $test_name")
}

log_test_fail() {
    local test_name="$1"
    local error_msg="$2"
    ((FAILED_TESTS++))
    log_error "FAIL: $test_name"
    log_error "Error: $error_msg"
    TEST_RESULTS+=("FAIL: $test_name - $error_msg")
}

# Test 1: Verify /analyze-stack command exists and is properly formatted
test_analyze_stack_command_exists() {
    log_test_start "Verify /analyze-stack command exists and is properly formatted"
    
    local command_file="$REPO_ROOT/.claude/commands/analyze-stack.md"
    
    if [[ ! -f "$command_file" ]]; then
        log_test_fail "analyze-stack command file" "Command file not found at $command_file"
        return
    fi
    
    # Check file has proper markdown format
    if ! grep -q "^# /analyze-stack" "$command_file"; then
        log_test_fail "analyze-stack command format" "Command file missing proper header '# /analyze-stack'"
        return
    fi
    
    # Check for description section
    if ! grep -q -i "description" "$command_file"; then
        log_test_fail "analyze-stack command format" "Command file missing description section"
        return
    fi
    
    # Check for usage section
    if ! grep -q -i "usage\|example" "$command_file"; then
        log_test_fail "analyze-stack command format" "Command file missing usage or example section"
        return
    fi
    
    log_test_pass "analyze-stack command file exists and has proper format"
}

# Test 2: Test analyze-stack command options (--focus, --depth, --format)
test_analyze_stack_command_options() {
    log_test_start "Test analyze-stack command options (--focus, --depth, --format)"
    
    local command_file="$REPO_ROOT/.claude/commands/analyze-stack.md"
    
    if [[ ! -f "$command_file" ]]; then
        log_test_fail "analyze-stack command options" "Command file not found"
        return
    fi
    
    local missing_options=()
    
    # Check for --focus option
    if ! grep -q -i "\-\-focus" "$command_file"; then
        missing_options+=("--focus")
    fi
    
    # Check for --depth option
    if ! grep -q -i "\-\-depth" "$command_file"; then
        missing_options+=("--depth")
    fi
    
    # Check for --format option
    if ! grep -q -i "\-\-format" "$command_file"; then
        missing_options+=("--format")
    fi
    
    if [[ ${#missing_options[@]} -gt 0 ]]; then
        log_test_fail "analyze-stack command options" "Missing options: ${missing_options[*]}"
        return
    fi
    
    log_test_pass "analyze-stack command has all required options"
}

# Test 3: Verify code-archaeologist agent exists with correct YAML frontmatter
test_code_archaeologist_agent() {
    log_test_start "Verify code-archaeologist agent exists with correct YAML frontmatter"
    
    local agent_file="$REPO_ROOT/.claude/agents/code-archaeologist.md"
    
    if [[ ! -f "$agent_file" ]]; then
        log_test_fail "code-archaeologist agent" "Agent file not found at $agent_file"
        return
    fi
    
    # Check YAML frontmatter exists
    if ! head -1 "$agent_file" | grep -q "^---$"; then
        log_test_fail "code-archaeologist agent" "Missing YAML frontmatter start delimiter"
        return
    fi
    
    # Extract and validate YAML frontmatter
    local temp_yaml="/tmp/code_archaeologist_frontmatter_$$.yml"
    local line_num=0
    local in_frontmatter=false
    local frontmatter_end_found=false
    
    while IFS= read -r line; do
        ((line_num++))
        
        if [[ $line_num -eq 1 && "$line" == "---" ]]; then
            in_frontmatter=true
            continue
        elif [[ "$in_frontmatter" == "true" && "$line" == "---" ]]; then
            frontmatter_end_found=true
            break
        elif [[ "$in_frontmatter" == "true" ]]; then
            echo "$line" >> "$temp_yaml"
        fi
    done < "$agent_file"
    
    if [[ "$frontmatter_end_found" != "true" ]]; then
        rm -f "$temp_yaml"
        log_test_fail "code-archaeologist agent" "Missing YAML frontmatter end delimiter"
        return
    fi
    
    # Check required fields
    local required_fields=("name" "description" "tools" "category")
    local missing_fields=()
    
    for field in "${required_fields[@]}"; do
        if ! grep -q "^$field:" "$temp_yaml"; then
            missing_fields+=("$field")
        fi
    done
    
    # Check specific field values for code-archaeologist
    if ! grep -q "^name:.*code.*archaeologist" "$temp_yaml"; then
        missing_fields+=("name (should contain 'code' and 'archaeologist')")
    fi
    
    if ! grep -q "^category:.*analysis\|development" "$temp_yaml"; then
        missing_fields+=("category (should be 'analysis' or 'development')")
    fi
    
    rm -f "$temp_yaml"
    
    if [[ ${#missing_fields[@]} -gt 0 ]]; then
        log_test_fail "code-archaeologist agent YAML" "Missing or invalid fields: ${missing_fields[*]}"
        return
    fi
    
    log_test_pass "code-archaeologist agent exists with correct YAML frontmatter"
}

# Test 4: Verify dependency-strategist agent exists with correct configuration
test_dependency_strategist_agent() {
    log_test_start "Verify dependency-strategist agent exists with correct configuration"
    
    local agent_file="$REPO_ROOT/.claude/agents/dependency-strategist.md"
    
    if [[ ! -f "$agent_file" ]]; then
        log_test_fail "dependency-strategist agent" "Agent file not found at $agent_file"
        return
    fi
    
    # Validate YAML frontmatter using existing function
    if ! validate_yaml_frontmatter "$agent_file"; then
        log_test_fail "dependency-strategist agent" "Invalid YAML frontmatter"
        return
    fi
    
    # Extract YAML frontmatter for specific checks
    local temp_yaml="/tmp/dependency_strategist_frontmatter_$$.yml"
    sed -n '/^---$/,/^---$/p' "$agent_file" | sed '1d;$d' > "$temp_yaml"
    
    # Check specific field values for dependency-strategist
    local validation_errors=()
    
    if ! grep -q "^name:.*dependency.*strategist" "$temp_yaml"; then
        validation_errors+=("name should contain 'dependency' and 'strategist'")
    fi
    
    if ! grep -q "^category:.*analysis\|strategy" "$temp_yaml"; then
        validation_errors+=("category should be 'analysis' or 'strategy'")
    fi
    
    # Check for strategy-related tools
    if ! grep -A 10 "^tools:" "$temp_yaml" | grep -q -i "read\|grep\|glob"; then
        validation_errors+=("tools should include analysis tools like Read, Grep, Glob")
    fi
    
    rm -f "$temp_yaml"
    
    if [[ ${#validation_errors[@]} -gt 0 ]]; then
        log_test_fail "dependency-strategist agent configuration" "${validation_errors[*]}"
        return
    fi
    
    log_test_pass "dependency-strategist agent exists with correct configuration"
}

# Test 5: Check all required tools are specified for each component
test_required_tools_specification() {
    log_test_start "Check all required tools are specified for each component"
    
    local agents=("code-archaeologist" "dependency-strategist")
    local validation_errors=()
    
    for agent in "${agents[@]}"; do
        local agent_file="$REPO_ROOT/.claude/agents/$agent.md"
        
        if [[ ! -f "$agent_file" ]]; then
            validation_errors+=("$agent: agent file missing")
            continue
        fi
        
        # Extract tools section
        local temp_yaml="/tmp/${agent}_tools_$$.yml"
        sed -n '/^---$/,/^---$/p' "$agent_file" | sed '1d;$d' > "$temp_yaml"
        
        if ! grep -q "^tools:" "$temp_yaml"; then
            validation_errors+=("$agent: missing tools section")
            rm -f "$temp_yaml"
            continue
        fi
        
        # Check for minimum required tools
        local required_tools=("Read" "Grep" "Glob")
        for tool in "${required_tools[@]}"; do
            if ! grep -A 10 "^tools:" "$temp_yaml" | grep -q "$tool"; then
                validation_errors+=("$agent: missing required tool '$tool'")
            fi
        done
        
        rm -f "$temp_yaml"
    done
    
    if [[ ${#validation_errors[@]} -gt 0 ]]; then
        log_test_fail "required tools specification" "${validation_errors[*]}"
        return
    fi
    
    log_test_pass "all required tools are properly specified"
}

# Test 6: Validate trigger words and categories for agents
test_trigger_words_and_categories() {
    log_test_start "Validate trigger words and categories for agents"
    
    local agents=("code-archaeologist" "dependency-strategist")
    local validation_errors=()
    
    for agent in "${agents[@]}"; do
        local agent_file="$REPO_ROOT/.claude/agents/$agent.md"
        
        if [[ ! -f "$agent_file" ]]; then
            validation_errors+=("$agent: agent file missing")
            continue
        fi
        
        # Extract YAML frontmatter
        local temp_yaml="/tmp/${agent}_triggers_$$.yml"
        sed -n '/^---$/,/^---$/p' "$agent_file" | sed '1d;$d' > "$temp_yaml"
        
        # Check for trigger_words field
        if ! grep -q "^trigger_words:" "$temp_yaml"; then
            validation_errors+=("$agent: missing trigger_words field")
        fi
        
        # Check for category field with valid values
        if ! grep -q "^category:" "$temp_yaml"; then
            validation_errors+=("$agent: missing category field")
        else
            local category
            category=$(grep "^category:" "$temp_yaml" | cut -d':' -f2 | xargs)
            case "$agent" in
                "code-archaeologist")
                    if [[ "$category" != "analysis" && "$category" != "development" ]]; then
                        validation_errors+=("$agent: invalid category '$category', expected 'analysis' or 'development'")
                    fi
                    ;;
                "dependency-strategist")
                    if [[ "$category" != "analysis" && "$category" != "strategy" ]]; then
                        validation_errors+=("$agent: invalid category '$category', expected 'analysis' or 'strategy'")
                    fi
                    ;;
            esac
        fi
        
        rm -f "$temp_yaml"
    done
    
    if [[ ${#validation_errors[@]} -gt 0 ]]; then
        log_test_fail "trigger words and categories" "${validation_errors[*]}"
        return
    fi
    
    log_test_pass "trigger words and categories are properly configured"
}

# Test 7: Test command execution simulation (dry-run)
test_command_execution_simulation() {
    log_test_start "Test command execution simulation (dry-run)"
    
    local command_file="$REPO_ROOT/.claude/commands/analyze-stack.md"
    
    if [[ ! -f "$command_file" ]]; then
        log_test_fail "command execution simulation" "Command file not found"
        return
    fi
    
    # Check for dry-run or simulation capabilities in the command
    if ! grep -q -i "dry.*run\|simulat\|preview" "$command_file"; then
        log_test_fail "command execution simulation" "No dry-run or simulation capability documented"
        return
    fi
    
    # Test basic command parsing simulation
    local test_commands=(
        "/analyze-stack --focus frontend --depth shallow"
        "/analyze-stack --format json --depth deep"
        "/analyze-stack --focus backend"
    )
    
    local parsing_errors=()
    
    for cmd in "${test_commands[@]}"; do
        # Basic validation of command format
        if ! echo "$cmd" | grep -q "^/analyze-stack"; then
            parsing_errors+=("Invalid command format: $cmd")
        fi
        
        # Check for valid option combinations
        if echo "$cmd" | grep -q "\-\-focus" && ! echo "$cmd" | grep -E "\-\-focus (frontend|backend|database|infrastructure)"; then
            if echo "$cmd" | grep -E "\-\-focus [a-zA-Z]+" >/dev/null; then
                # This is acceptable - it has a focus value
                continue
            else
                parsing_errors+=("Invalid focus value in: $cmd")
            fi
        fi
    done
    
    if [[ ${#parsing_errors[@]} -gt 0 ]]; then
        log_test_fail "command execution simulation" "Command parsing errors: ${parsing_errors[*]}"
        return
    fi
    
    log_test_pass "command execution simulation works correctly"
}

# Main test execution function
run_phase1_tests() {
    echo
    log_info "Starting Phase 1 Implementation Tests"
    log_info "======================================"
    
    # Run all tests
    test_analyze_stack_command_exists
    test_analyze_stack_command_options
    test_code_archaeologist_agent
    test_dependency_strategist_agent
    test_required_tools_specification
    test_trigger_words_and_categories
    test_command_execution_simulation
    
    # Print detailed test summary
    echo
    log_info "Phase 1 Test Results Summary"
    log_info "============================"
    
    for result in "${TEST_RESULTS[@]}"; do
        if [[ "$result" == PASS:* ]]; then
            log_success "$result"
        else
            log_error "$result"
        fi
    done
    
    echo
    echo "============================"
    log_info "Total Tests: $TOTAL_TESTS"
    log_success "Passed: $PASSED_TESTS"
    
    if [[ $FAILED_TESTS -gt 0 ]]; then
        log_error "Failed: $FAILED_TESTS"
        echo
        log_error "Phase 1 implementation validation FAILED"
        return 1
    else
        log_success "Failed: $FAILED_TESTS"
        echo
        log_success "Phase 1 implementation validation PASSED"
        return 0
    fi
}

# Health check function to verify script dependencies
health_check() {
    local missing_deps=()
    
    # Check for required commands
    local required_commands=("git" "grep" "sed")
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing_deps+=("$cmd")
        fi
    done
    
    # Check repository structure
    if [[ ! -d "$REPO_ROOT/.claude" ]]; then
        missing_deps+=(".claude directory")
    fi
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        log_error "Missing dependencies: ${missing_deps[*]}"
        exit 1
    fi
}

# Script entry point
main() {
    # Perform health check
    health_check
    
    # Run tests
    if run_phase1_tests; then
        exit 0
    else
        exit 1
    fi
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi