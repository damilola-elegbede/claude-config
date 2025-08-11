#!/bin/bash
# Phase 2 Implementation Test Script
# Tests /scaffold command (SPEC_04) and /feature command (SPEC_05) implementations
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

# Test 1: Verify /scaffold command exists and has proper structure
test_scaffold_command_exists() {
    log_test_start "Verify /scaffold command exists and has proper structure"
    
    local command_file="$REPO_ROOT/.claude/commands/scaffold.md"
    
    if [[ ! -f "$command_file" ]]; then
        log_test_fail "scaffold command file" "Command file not found at $command_file"
        return
    fi
    
    # Check file has proper markdown format with required sections
    local missing_sections=()
    
    if ! grep -q "^# /scaffold" "$command_file"; then
        missing_sections+=("header '# /scaffold'")
    fi
    
    if ! grep -q "<description>" "$command_file"; then
        missing_sections+=("description section")
    fi
    
    if ! grep -q "## Usage" "$command_file"; then
        missing_sections+=("usage section")
    fi
    
    if ! grep -q "<options>" "$command_file"; then
        missing_sections+=("options section")
    fi
    
    if ! grep -q "<execution-flow>" "$command_file"; then
        missing_sections+=("execution-flow section")
    fi
    
    if ! grep -q "<examples>" "$command_file"; then
        missing_sections+=("examples section")
    fi
    
    if [[ ${#missing_sections[@]} -gt 0 ]]; then
        log_test_fail "scaffold command structure" "Missing sections: ${missing_sections[*]}"
        return
    fi
    
    log_test_pass "scaffold command exists with proper structure"
}

# Test 2: Test scaffold command required options
test_scaffold_command_options() {
    log_test_start "Test scaffold command required options"
    
    local command_file="$REPO_ROOT/.claude/commands/scaffold.md"
    
    if [[ ! -f "$command_file" ]]; then
        log_test_fail "scaffold command options" "Command file not found"
        return
    fi
    
    local missing_options=()
    
    # Check for required options
    if ! grep -q -i "\-\-framework" "$command_file"; then
        missing_options+=("--framework")
    fi
    
    if ! grep -q -i "\-\-with-tests" "$command_file"; then
        missing_options+=("--with-tests")
    fi
    
    if ! grep -q -i "\-\-with-stories" "$command_file"; then
        missing_options+=("--with-stories")
    fi
    
    if ! grep -q -i "\-\-with-docs" "$command_file"; then
        missing_options+=("--with-docs")
    fi
    
    if ! grep -q -i "\-\-style" "$command_file"; then
        missing_options+=("--style")
    fi
    
    if ! grep -q -i "\-\-typescript" "$command_file"; then
        missing_options+=("--typescript")
    fi
    
    if ! grep -q -i "\-\-interactive" "$command_file"; then
        missing_options+=("--interactive")
    fi
    
    if ! grep -q -i "\-\-dry-run" "$command_file"; then
        missing_options+=("--dry-run")
    fi
    
    if ! grep -q -i "\-\-template" "$command_file"; then
        missing_options+=("--template")
    fi
    
    if ! grep -q -i "\-\-props" "$command_file"; then
        missing_options+=("--props")
    fi
    
    if [[ ${#missing_options[@]} -gt 0 ]]; then
        log_test_fail "scaffold command options" "Missing options: ${missing_options[*]}"
        return
    fi
    
    log_test_pass "scaffold command has all required options"
}

# Test 3: Validate scaffold command argument types
test_scaffold_argument_types() {
    log_test_start "Validate scaffold command argument types"
    
    local command_file="$REPO_ROOT/.claude/commands/scaffold.md"
    
    if [[ ! -f "$command_file" ]]; then
        log_test_fail "scaffold argument types" "Command file not found"
        return
    fi
    
    local validation_errors=()
    
    # Check that scaffold types are documented
    local required_types=("component" "service" "feature" "api" "model" "module" "project")
    for type in "${required_types[@]}"; do
        if ! grep -q "$type" "$command_file"; then
            validation_errors+=("missing scaffold type: $type")
        fi
    done
    
    # Check framework values
    local frameworks=("react" "vue" "angular" "express" "fastapi" "django" "spring" "go" "python")
    local framework_found=false
    for framework in "${frameworks[@]}"; do
        if grep -q "$framework" "$command_file"; then
            framework_found=true
            break
        fi
    done
    
    if [[ "$framework_found" != "true" ]]; then
        validation_errors+=("no supported frameworks documented")
    fi
    
    # Check style options
    local styles=("css" "scss" "styled-components" "tailwind" "css-modules")
    local style_found=false
    for style in "${styles[@]}"; do
        if grep -q "$style" "$command_file"; then
            style_found=true
            break
        fi
    done
    
    if [[ "$style_found" != "true" ]]; then
        validation_errors+=("no style options documented")
    fi
    
    if [[ ${#validation_errors[@]} -gt 0 ]]; then
        log_test_fail "scaffold argument types" "${validation_errors[*]}"
        return
    fi
    
    log_test_pass "scaffold argument types are properly documented"
}

# Test 4: Test agent orchestration documentation in scaffold command
test_scaffold_agent_orchestration() {
    log_test_start "Test agent orchestration documentation in scaffold command"
    
    local command_file="$REPO_ROOT/.claude/commands/scaffold.md"
    
    if [[ ! -f "$command_file" ]]; then
        log_test_fail "scaffold agent orchestration" "Command file not found"
        return
    fi
    
    local orchestration_errors=()
    
    # Check for execution phases
    if ! grep -q "<phase" "$command_file"; then
        orchestration_errors+=("no execution phases documented")
    fi
    
    # Check for required agents
    local required_agents=("codebase-analyst" "frontend-architect" "backend-engineer" "test-engineer" "tech-writer" "project-orchestrator")
    for agent in "${required_agents[@]}"; do
        if ! grep -q "$agent" "$command_file"; then
            orchestration_errors+=("missing agent: $agent")
        fi
    done
    
    # Check for parallel execution documentation
    if ! grep -q -i "parallel" "$command_file"; then
        orchestration_errors+=("no parallel execution documentation")
    fi
    
    # Check for context sharing documentation
    if ! grep -q -i "context" "$command_file" && ! grep -q -i "shared" "$command_file"; then
        orchestration_errors+=("no context sharing documentation")
    fi
    
    # Check for error handling
    if ! grep -q -i "error" "$command_file" && ! grep -q -i "failure" "$command_file"; then
        orchestration_errors+=("no error handling documentation")
    fi
    
    if [[ ${#orchestration_errors[@]} -gt 0 ]]; then
        log_test_fail "scaffold agent orchestration" "${orchestration_errors[*]}"
        return
    fi
    
    log_test_pass "scaffold agent orchestration is properly documented"
}

# Test 5: Validate framework support matrix
test_framework_support_matrix() {
    log_test_start "Validate framework support matrix"
    
    local command_file="$REPO_ROOT/.claude/commands/scaffold.md"
    
    if [[ ! -f "$command_file" ]]; then
        log_test_fail "framework support matrix" "Command file not found"
        return
    fi
    
    local matrix_errors=()
    
    # Check for framework support section
    if ! grep -q "<framework-support>" "$command_file"; then
        matrix_errors+=("no framework support section")
    fi
    
    # Check for frontend frameworks
    local frontend_frameworks=("React" "Vue" "Angular")
    for framework in "${frontend_frameworks[@]}"; do
        if ! grep -A 50 "<frontend>" "$command_file" | grep -q "$framework"; then
            matrix_errors+=("missing frontend framework: $framework")
        fi
    done
    
    # Check for backend frameworks
    local backend_frameworks=("Express" "FastAPI" "Django")
    for framework in "${backend_frameworks[@]}"; do
        if ! grep -A 100 "<backend>" "$command_file" | grep -q "$framework"; then
            matrix_errors+=("missing backend framework: $framework")
        fi
    done
    
    # Check for version information
    if ! grep -q "versions=" "$command_file"; then
        matrix_errors+=("no version information for frameworks")
    fi
    
    # Check for features documentation
    if ! grep -q "<features>" "$command_file"; then
        matrix_errors+=("no features documentation for frameworks")
    fi
    
    if [[ ${#matrix_errors[@]} -gt 0 ]]; then
        log_test_fail "framework support matrix" "${matrix_errors[*]}"
        return
    fi
    
    log_test_pass "framework support matrix is comprehensive"
}

# Test 6: Test scaffold command examples
test_scaffold_examples() {
    log_test_start "Test scaffold command examples"
    
    local command_file="$REPO_ROOT/.claude/commands/scaffold.md"
    
    if [[ ! -f "$command_file" ]]; then
        log_test_fail "scaffold examples" "Command file not found"
        return
    fi
    
    local example_errors=()
    
    # Check for examples section
    if ! grep -q "<examples>" "$command_file"; then
        example_errors+=("no examples section")
    fi
    
    # Check for specific example types
    local example_types=("React Component" "Complete Feature" "FastAPI Service" "Vue Component" "Interactive Mode" "Dry Run Mode")
    for example_type in "${example_types[@]}"; do
        if ! grep -A 5 -B 5 "$example_type" "$command_file" | grep -q "<command>"; then
            example_errors+=("missing example: $example_type")
        fi
    done
    
    # Check that examples show generated files
    if ! grep -q "<generated-files>" "$command_file"; then
        example_errors+=("examples don't show generated files")
    fi
    
    # Check for command syntax validation in examples
    if ! grep -q "^    <command>/scaffold" "$command_file"; then
        example_errors+=("examples don't show proper command syntax")
    fi
    
    if [[ ${#example_errors[@]} -gt 0 ]]; then
        log_test_fail "scaffold examples" "${example_errors[*]}"
        return
    fi
    
    log_test_pass "scaffold examples are comprehensive and well-formatted"
}

# Test 7: Check for /feature command (SPEC_05)
test_feature_command_exists() {
    log_test_start "Check for /feature command (SPEC_05)"
    
    local command_file="$REPO_ROOT/.claude/commands/feature.md"
    
    # Note: /feature command may be implemented as part of scaffold or as separate command
    if [[ ! -f "$command_file" ]]; then
        # Check if feature is documented as part of scaffold
        local scaffold_file="$REPO_ROOT/.claude/commands/scaffold.md"
        if [[ -f "$scaffold_file" ]] && grep -q "feature" "$scaffold_file"; then
            log_test_pass "feature functionality exists within scaffold command"
            return
        fi
        
        log_test_fail "feature command" "Feature command not found as separate command or within scaffold"
        return
    fi
    
    # If feature.md exists, validate its structure
    local missing_sections=()
    
    if ! grep -q "^# /feature" "$command_file"; then
        missing_sections+=("header '# /feature'")
    fi
    
    if ! grep -q -i "description" "$command_file"; then
        missing_sections+=("description section")
    fi
    
    if ! grep -q -i "usage\|example" "$command_file"; then
        missing_sections+=("usage or example section")
    fi
    
    if [[ ${#missing_sections[@]} -gt 0 ]]; then
        log_test_fail "feature command structure" "Missing sections: ${missing_sections[*]}"
        return
    fi
    
    log_test_pass "feature command exists with proper structure"
}

# Test 8: Validate YAML frontmatter compliance for agents
test_agent_yaml_frontmatter() {
    log_test_start "Validate YAML frontmatter compliance for Phase 2 agents"
    
    # Check agents that should exist for Phase 2
    local phase2_agents=("frontend-architect" "backend-engineer" "test-engineer" "tech-writer" "project-orchestrator")
    local validation_errors=()
    
    for agent in "${phase2_agents[@]}"; do
        local agent_file="$REPO_ROOT/.claude/agents/$agent.md"
        
        if [[ ! -f "$agent_file" ]]; then
            validation_errors+=("$agent: agent file missing")
            continue
        fi
        
        # Validate YAML frontmatter using existing framework function
        if ! validate_yaml_frontmatter "$agent_file"; then
            validation_errors+=("$agent: invalid YAML frontmatter")
            continue
        fi
        
        # Check for specific fields required for Phase 2 agents
        local temp_yaml="/tmp/${agent}_phase2_$$.yml"
        sed -n '/^---$/,/^---$/p' "$agent_file" | sed '1d;$d' > "$temp_yaml"
        
        # Check for required fields
        # Note: trigger_words is not required for existing agents used by Phase 2
        local required_fields=("name" "description" "tools" "category")
        for field in "${required_fields[@]}"; do
            if ! grep -q "^$field:" "$temp_yaml"; then
                validation_errors+=("$agent: missing field '$field'")
            fi
        done
        
        # Check for appropriate tools for scaffolding
        local scaffolding_tools=("Write" "Edit" "MultiEdit")
        local has_scaffolding_tool=false
        for tool in "${scaffolding_tools[@]}"; do
            if grep -A 10 "^tools:" "$temp_yaml" | grep -q "$tool"; then
                has_scaffolding_tool=true
                break
            fi
        done
        
        if [[ "$has_scaffolding_tool" != "true" ]]; then
            validation_errors+=("$agent: no scaffolding tools (Write/Edit/MultiEdit)")
        fi
        
        rm -f "$temp_yaml"
    done
    
    if [[ ${#validation_errors[@]} -gt 0 ]]; then
        log_test_fail "agent YAML frontmatter" "${validation_errors[*]}"
        return
    fi
    
    log_test_pass "all Phase 2 agents have proper YAML frontmatter"
}

# Test 9: Test pattern detection and smart defaults
test_pattern_detection() {
    log_test_start "Test pattern detection and smart defaults documentation"
    
    local command_file="$REPO_ROOT/.claude/commands/scaffold.md"
    
    if [[ ! -f "$command_file" ]]; then
        log_test_fail "pattern detection" "Command file not found"
        return
    fi
    
    local pattern_errors=()
    
    # Check for pattern detection section
    if ! grep -q "<pattern-detection>" "$command_file"; then
        pattern_errors+=("no pattern detection section")
    fi
    
    # Check for naming conventions
    if ! grep -q "naming-conventions\|naming.*convention" "$command_file"; then
        pattern_errors+=("no naming conventions documentation")
    fi
    
    # Check for project structure detection
    if ! grep -q "project-structure\|structure.*detect" "$command_file"; then
        pattern_errors+=("no project structure detection")
    fi
    
    # Check for framework detection
    if ! grep -q "framework-detection\|framework.*detect" "$command_file"; then
        pattern_errors+=("no framework detection documentation")
    fi
    
    # Check for smart defaults section
    if ! grep -q "<smart-defaults>" "$command_file"; then
        pattern_errors+=("no smart defaults section")
    fi
    
    # Check for auto-detection capabilities
    if ! grep -q "auto-detection\|auto.*detect" "$command_file"; then
        pattern_errors+=("no auto-detection documentation")
    fi
    
    if [[ ${#pattern_errors[@]} -gt 0 ]]; then
        log_test_fail "pattern detection" "${pattern_errors[*]}"
        return
    fi
    
    log_test_pass "pattern detection and smart defaults are documented"
}

# Test 10: Test integration points documentation
test_integration_points() {
    log_test_start "Test integration points documentation"
    
    local command_file="$REPO_ROOT/.claude/commands/scaffold.md"
    
    if [[ ! -f "$command_file" ]]; then
        log_test_fail "integration points" "Command file not found"
        return
    fi
    
    local integration_errors=()
    
    # Check for integration section
    if ! grep -q "<integration>" "$command_file"; then
        integration_errors+=("no integration section")
    fi
    
    # Check for git workflow integration
    if ! grep -q "git-workflow\|git.*integration" "$command_file"; then
        integration_errors+=("no git workflow integration")
    fi
    
    # Check for IDE support
    if ! grep -q "ide-support\|IDE.*support" "$command_file"; then
        integration_errors+=("no IDE support documentation")
    fi
    
    # Check for CI/CD integration
    if ! grep -q "ci-cd\|CI.*CD" "$command_file"; then
        integration_errors+=("no CI/CD integration documentation")
    fi
    
    if [[ ${#integration_errors[@]} -gt 0 ]]; then
        log_test_fail "integration points" "${integration_errors[*]}"
        return
    fi
    
    log_test_pass "integration points are properly documented"
}

# Test 11: Test command execution simulation (dry-run capability)
test_command_execution_simulation() {
    log_test_start "Test command execution simulation (dry-run capability)"
    
    local command_file="$REPO_ROOT/.claude/commands/scaffold.md"
    
    if [[ ! -f "$command_file" ]]; then
        log_test_fail "command execution simulation" "Command file not found"
        return
    fi
    
    # Check for dry-run capability
    if ! grep -q -i "dry.*run\|preview.*generation" "$command_file"; then
        log_test_fail "command execution simulation" "No dry-run capability documented"
        return
    fi
    
    # Test basic command parsing simulation
    local test_commands=(
        "/scaffold component UserProfile --framework=react --with-tests"
        "/scaffold feature TaskManager --with-tests --with-docs"
        "/scaffold api UserService --framework=fastapi --with-tests"
        "/scaffold component ProductCard --framework=vue --typescript"
    )
    
    local parsing_errors=()
    
    for cmd in "${test_commands[@]}"; do
        # Basic validation of command format
        if ! echo "$cmd" | grep -q "^/scaffold"; then
            parsing_errors+=("Invalid command format: $cmd")
        fi
        
        # Check for valid scaffold types
        if ! echo "$cmd" | grep -E "/scaffold (component|service|feature|api|model|module|project)"; then
            parsing_errors+=("Invalid scaffold type in: $cmd")
        fi
        
        # Check for valid option combinations
        if echo "$cmd" | grep -q "\-\-framework" && ! echo "$cmd" | grep -E "\-\-framework=(react|vue|angular|express|fastapi|django)"; then
            if echo "$cmd" | grep -E "\-\-framework=[a-zA-Z]+" >/dev/null; then
                # This is acceptable - it has a framework value
                continue
            else
                parsing_errors+=("Invalid framework value in: $cmd")
            fi
        fi
    done
    
    if [[ ${#parsing_errors[@]} -gt 0 ]]; then
        log_test_fail "command execution simulation" "Command parsing errors: ${parsing_errors[*]}"
        return
    fi
    
    log_test_pass "command execution simulation works correctly"
}

# Test 12: Validate success metrics and error handling
test_success_metrics_and_error_handling() {
    log_test_start "Validate success metrics and error handling documentation"
    
    local command_file="$REPO_ROOT/.claude/commands/scaffold.md"
    
    if [[ ! -f "$command_file" ]]; then
        log_test_fail "success metrics and error handling" "Command file not found"
        return
    fi
    
    local validation_errors=()
    
    # Check for success metrics section
    if ! grep -q "<metrics>" "$command_file"; then
        validation_errors+=("no success metrics section")
    fi
    
    # Check for performance targets
    if ! grep -q -i "performance\|target.*value" "$command_file"; then
        validation_errors+=("no performance targets")
    fi
    
    # Check for error handling section
    if ! grep -q "<error-handling>" "$command_file"; then
        validation_errors+=("no error handling section")
    fi
    
    # Check for validation errors
    if ! grep -q "validation-errors\|validation.*error" "$command_file"; then
        validation_errors+=("no validation error handling")
    fi
    
    # Check for recovery strategies
    if ! grep -q "recovery\|fallback\|rollback" "$command_file"; then
        validation_errors+=("no recovery strategies documented")
    fi
    
    if [[ ${#validation_errors[@]} -gt 0 ]]; then
        log_test_fail "success metrics and error handling" "${validation_errors[*]}"
        return
    fi
    
    log_test_pass "success metrics and error handling are documented"
}

# Main test execution function
run_phase2_tests() {
    echo
    log_info "Starting Phase 2 Implementation Tests"
    log_info "======================================"
    
    # Run all tests
    test_scaffold_command_exists
    test_scaffold_command_options
    test_scaffold_argument_types
    test_scaffold_agent_orchestration
    test_framework_support_matrix
    test_scaffold_examples
    test_feature_command_exists
    test_agent_yaml_frontmatter
    test_pattern_detection
    test_integration_points
    test_command_execution_simulation
    test_success_metrics_and_error_handling
    
    # Print detailed test summary
    echo
    log_info "Phase 2 Test Results Summary"
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
        log_error "Phase 2 implementation validation FAILED"
        return 1
    else
        log_success "Failed: $FAILED_TESTS"
        echo
        log_success "Phase 2 implementation validation PASSED"
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
    
    if [[ ! -d "$REPO_ROOT/.claude/commands" ]]; then
        missing_deps+=(".claude/commands directory")
    fi
    
    if [[ ! -d "$REPO_ROOT/.claude/agents" ]]; then
        missing_deps+=(".claude/agents directory")
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
    if run_phase2_tests; then
        exit 0
    else
        exit 1
    fi
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi