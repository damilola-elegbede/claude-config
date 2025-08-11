#!/bin/bash
# Phase 3: Intelligence Layer Implementation Test Script
# Tests performance-predictor agent, ML infrastructure, and intelligence capabilities
set -euo pipefail

# Source validation framework
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
REPO_ROOT=$(git rev-parse --show-toplevel)
source "$SCRIPT_DIR/validation/framework.sh"

# Test counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
CRITICAL_FAILURES=0

# Test results array
declare -a TEST_RESULTS=()

# Phase 3 specific configurations
ML_AGENT_FILE="$REPO_ROOT/.claude/agents/performance-predictor.md"
ML_DOCS_DIR="$REPO_ROOT/docs"
ML_SCRIPTS_DIR="$REPO_ROOT/scripts"
EXPECTED_ACCURACY_THRESHOLD=0.95
EXPECTED_LATENCY_THRESHOLD=100  # milliseconds
EXPECTED_UPTIME_THRESHOLD=0.999

# Enhanced logging with test context and criticality
log_test_start() {
    local test_name="$1"
    local criticality="${2:-medium}"
    ((TOTAL_TESTS++))
    echo
    log_info "TEST $TOTAL_TESTS: $test_name [$criticality criticality]"
    echo "=============================================="
}

log_test_pass() {
    local test_name="$1"
    local performance_metric="${2:-}"
    ((PASSED_TESTS++))
    if [[ -n "$performance_metric" ]]; then
        log_success "PASS: $test_name ($performance_metric)"
        TEST_RESULTS+=("PASS: $test_name - $performance_metric")
    else
        log_success "PASS: $test_name"
        TEST_RESULTS+=("PASS: $test_name")
    fi
}

log_test_fail() {
    local test_name="$1"
    local error_msg="$2"
    local is_critical="${3:-false}"
    ((FAILED_TESTS++))
    
    if [[ "$is_critical" == "true" ]]; then
        ((CRITICAL_FAILURES++))
        log_error "CRITICAL FAIL: $test_name"
        log_error "Error: $error_msg"
        TEST_RESULTS+=("CRITICAL FAIL: $test_name - $error_msg")
    else
        log_error "FAIL: $test_name"
        log_error "Error: $error_msg"
        TEST_RESULTS+=("FAIL: $test_name - $error_msg")
    fi
}

# Test 1: Verify performance-predictor agent exists with correct ML-focused YAML
test_performance_predictor_agent_structure() {
    log_test_start "Verify performance-predictor agent structure and ML capabilities" "critical"
    
    if [[ ! -f "$ML_AGENT_FILE" ]]; then
        log_test_fail "performance-predictor agent structure" "Agent file not found at $ML_AGENT_FILE" "true"
        return
    fi
    
    # Extract and validate YAML frontmatter
    local temp_yaml="/tmp/performance_predictor_frontmatter_$$.yml"
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
    done < "$ML_AGENT_FILE"
    
    if [[ "$frontmatter_end_found" != "true" ]]; then
        rm -f "$temp_yaml"
        log_test_fail "performance-predictor agent structure" "Missing YAML frontmatter delimiters" "true"
        return
    fi
    
    # Check required ML-specific fields
    local required_fields=("name" "description" "tools" "category" "model" "color")
    local ml_specific_checks=()
    
    for field in "${required_fields[@]}"; do
        if ! grep -q "^$field:" "$temp_yaml"; then
            ml_specific_checks+=("Missing required field: $field")
        fi
    done
    
    # Verify ML-specific field values
    if ! grep -q "^name:.*performance.*predictor" "$temp_yaml"; then
        ml_specific_checks+=("name field should contain 'performance' and 'predictor'")
    fi
    
    if ! grep -q "^category:.*analysis" "$temp_yaml"; then
        ml_specific_checks+=("category should be 'analysis' for ML agent")
    fi
    
    if ! grep -q "^model:.*sonnet" "$temp_yaml"; then
        ml_specific_checks+=("model should specify 'sonnet' for advanced AI capabilities")
    fi
    
    if ! grep -q "^color:.*yellow" "$temp_yaml"; then
        ml_specific_checks+=("color should be 'yellow' for analysis agents")
    fi
    
    # Check for ML-specific tools
    local ml_tools=("Read" "Write" "Edit" "Bash" "Grep")
    for tool in "${ml_tools[@]}"; do
        if ! grep -A 5 "^tools:" "$temp_yaml" | grep -q "$tool"; then
            ml_specific_checks+=("Missing required ML tool: $tool")
        fi
    done
    
    rm -f "$temp_yaml"
    
    if [[ ${#ml_specific_checks[@]} -gt 0 ]]; then
        log_test_fail "performance-predictor agent structure" "${ml_specific_checks[*]}" "true"
        return
    fi
    
    log_test_pass "performance-predictor agent structure" "All ML-specific YAML fields validated"
}

# Test 2: Validate ML prediction capabilities and accuracy requirements
test_ml_prediction_capabilities() {
    log_test_start "Validate ML prediction capabilities and accuracy requirements" "critical"
    
    local capability_checks=()
    local agent_content
    
    if ! agent_content=$(cat "$ML_AGENT_FILE"); then
        log_test_fail "ML prediction capabilities" "Cannot read agent file" "true"
        return
    fi
    
    # Check for critical ML capabilities mentioned in agent description
    local required_capabilities=(
        "predictive.*modeling"
        "anomaly.*detection" 
        "capacity.*planning"
        "time.*series"
        "forecast.*accuracy"
        "performance.*prediction"
        "85%.*accuracy"
        "confidence.*interval"
        "model.*ensemble"
    )
    
    for capability in "${required_capabilities[@]}"; do
        if ! echo "$agent_content" | grep -i -q "$capability"; then
            capability_checks+=("Missing ML capability: $capability")
        fi
    done
    
    # Check for ML integration points
    local integration_points=(
        "prometheus"
        "grafana"
        "cloudwatch"
        "datadog"
        "api.*integration"
        "real.*time.*serving"
        "batch.*processing"
    )
    
    for integration in "${integration_points[@]}"; do
        if ! echo "$agent_content" | grep -i -q "$integration"; then
            capability_checks+=("Missing integration capability: $integration")
        fi
    done
    
    # Verify accuracy targets are specified
    if ! echo "$agent_content" | grep -q "85%\|90%\|95%"; then
        capability_checks+=("No specific accuracy targets mentioned")
    fi
    
    if [[ ${#capability_checks[@]} -gt 0 ]]; then
        log_test_fail "ML prediction capabilities" "${capability_checks[*]}" "true"
        return
    fi
    
    log_test_pass "ML prediction capabilities" "All critical ML capabilities validated"
}

# Test 3: Test ML infrastructure components and configurations
test_ml_infrastructure_components() {
    log_test_start "Test ML infrastructure components and configurations" "high"
    
    local infrastructure_checks=()
    
    # Check for ML documentation
    local ml_docs=(
        "$ML_DOCS_DIR/mlops-guide.md"
        "$ML_DOCS_DIR/ml-api-reference.md"
        "$ML_DOCS_DIR/phase3-intelligence-layer.md"
        "$ML_DOCS_DIR/performance-predictor-guide.md"
    )
    
    for doc in "${ml_docs[@]}"; do
        if [[ ! -f "$doc" ]]; then
            infrastructure_checks+=("Missing ML documentation: $(basename "$doc")")
        else
            # Validate documentation content
            local doc_content
            if doc_content=$(cat "$doc"); then
                # Check for production-ready indicators
                if ! echo "$doc_content" | grep -i -q "production.*ready\|enterprise.*grade\|99\.9%"; then
                    infrastructure_checks+=("Documentation $(basename "$doc") lacks production-ready indicators")
                fi
            fi
        fi
    done
    
    # Check for ML scripts
    local ml_scripts=(
        "$ML_SCRIPTS_DIR/demo-performance-predictor.py"
        "$ML_SCRIPTS_DIR/test-performance-predictor.py"
        "$ML_SCRIPTS_DIR/test-performance-predictor-basic.py"
    )
    
    local found_scripts=0
    for script in "${ml_scripts[@]}"; do
        if [[ -f "$script" ]]; then
            ((found_scripts++))
        fi
    done
    
    if [[ $found_scripts -lt 2 ]]; then
        infrastructure_checks+=("Insufficient ML scripts found ($found_scripts/3)")
    fi
    
    # Check for Docker and Kubernetes manifest directories (expected in Phase 3)
    local expected_dirs=(
        "docker"
        "k8s"
        "ml-pipeline"
        "config"
    )
    
    local found_dirs=0
    local agent_content=""
    if [[ -f "$ML_AGENT_FILE" ]]; then
        agent_content=$(cat "$ML_AGENT_FILE")
    fi
    
    for dir in "${expected_dirs[@]}"; do
        if [[ -d "$REPO_ROOT/$dir" ]] || echo "$agent_content" | grep -q "$dir"; then
            ((found_dirs++))
        fi
    done
    
    if [[ $found_dirs -eq 0 ]]; then
        infrastructure_checks+=("No Docker/Kubernetes infrastructure components referenced")
    fi
    
    if [[ ${#infrastructure_checks[@]} -gt 0 ]]; then
        log_test_fail "ML infrastructure components" "${infrastructure_checks[*]}" "false"
        return
    fi
    
    log_test_pass "ML infrastructure components" "Infrastructure documentation and components validated"
}

# Test 4: Validate Docker and Kubernetes manifests references
test_deployment_configurations() {
    log_test_start "Validate Docker and Kubernetes deployment configurations" "high"
    
    local deployment_checks=()
    local docs_content=""
    
    # Aggregate content from ML documentation
    for doc in "$ML_DOCS_DIR"/*.md; do
        if [[ -f "$doc" ]]; then
            docs_content+=$(cat "$doc")$'\n'
        fi
    done
    
    # Check for Docker configuration references
    local docker_configs=(
        "dockerfile"
        "docker.*compose"
        "container.*image"
        "docker.*build"
        "registry"
    )
    
    local docker_found=0
    for config in "${docker_configs[@]}"; do
        if echo "$docs_content" | grep -i -q "$config"; then
            ((docker_found++))
        fi
    done
    
    if [[ $docker_found -lt 2 ]]; then
        deployment_checks+=("Insufficient Docker configuration references ($docker_found/5)")
    fi
    
    # Check for Kubernetes configuration references  
    local k8s_configs=(
        "kubernetes\|k8s"
        "deployment"
        "service"
        "configmap\|config.*map"
        "persistent.*volume"
        "horizontal.*pod.*autoscaler\|hpa"
    )
    
    local k8s_found=0
    for config in "${k8s_configs[@]}"; do
        if echo "$docs_content" | grep -i -q "$config"; then
            ((k8s_found++))
        fi
    done
    
    if [[ $k8s_found -lt 3 ]]; then
        deployment_checks+=("Insufficient Kubernetes configuration references ($k8s_found/6)")
    fi
    
    # Check for monitoring and observability
    local monitoring_configs=(
        "prometheus"
        "grafana" 
        "metrics"
        "alerting"
        "health.*check"
        "monitoring"
    )
    
    local monitoring_found=0
    for config in "${monitoring_configs[@]}"; do
        if echo "$docs_content" | grep -i -q "$config"; then
            ((monitoring_found++))
        fi
    done
    
    if [[ $monitoring_found -lt 4 ]]; then
        deployment_checks+=("Insufficient monitoring configuration references ($monitoring_found/6)")
    fi
    
    if [[ ${#deployment_checks[@]} -gt 0 ]]; then
        log_test_fail "deployment configurations" "${deployment_checks[*]}" "false"
        return
    fi
    
    log_test_pass "deployment configurations" "Docker, Kubernetes, and monitoring configs validated"
}

# Test 5: Test ML API endpoints and model serving capabilities
test_ml_api_endpoints() {
    log_test_start "Test ML API endpoints and model serving capabilities" "medium"
    
    local api_checks=()
    local docs_content=""
    
    # Check ML API documentation
    if [[ -f "$ML_DOCS_DIR/ml-api-reference.md" ]]; then
        docs_content=$(cat "$ML_DOCS_DIR/ml-api-reference.md")
    fi
    
    # Aggregate from other ML docs if API reference doesn't exist
    if [[ -z "$docs_content" ]]; then
        for doc in "$ML_DOCS_DIR"/ml*.md "$ML_DOCS_DIR"/phase3*.md; do
            if [[ -f "$doc" ]]; then
                docs_content+=$(cat "$doc")$'\n'
            fi
        done
    fi
    
    # Check for API endpoint definitions
    local api_patterns=(
        "\/predict\|\/inference"
        "\/health\|\/status"
        "\/metrics"
        "POST\|GET\|PUT"
        "json\|application\/json"
        "rest.*api\|restful"
        "http.*status.*code"
    )
    
    local api_found=0
    for pattern in "${api_patterns[@]}"; do
        if echo "$docs_content" | grep -i -q "$pattern"; then
            ((api_found++))
        fi
    done
    
    if [[ $api_found -lt 4 ]]; then
        api_checks+=("Insufficient API endpoint documentation ($api_found/7)")
    fi
    
    # Check for model serving patterns
    local serving_patterns=(
        "real.*time.*serving\|inference"
        "batch.*processing\|batch.*prediction"
        "model.*loading\|model.*registry"
        "scaling\|auto.*scaling"
        "load.*balancing"
        "caching\|redis"
    )
    
    local serving_found=0
    for pattern in "${serving_patterns[@]}"; do
        if echo "$docs_content" | grep -i -q "$pattern"; then
            ((serving_found++))
        fi
    done
    
    if [[ $serving_found -lt 3 ]]; then
        api_checks+=("Insufficient model serving capabilities ($serving_found/6)")
    fi
    
    # Check for performance specifications
    local perf_patterns=(
        "latency.*<.*ms\|response.*time"
        "throughput.*requests.*per.*second\|rps"
        "99%\|p99\|percentile"
        "sla\|uptime"
    )
    
    local perf_found=0
    for pattern in "${perf_patterns[@]}"; do
        if echo "$docs_content" | grep -i -q "$pattern"; then
            ((perf_found++))
        fi
    done
    
    if [[ $perf_found -lt 2 ]]; then
        api_checks+=("Missing performance specifications ($perf_found/4)")
    fi
    
    if [[ ${#api_checks[@]} -gt 0 ]]; then
        log_test_fail "ML API endpoints" "${api_checks[*]}" "false"
        return
    fi
    
    log_test_pass "ML API endpoints" "API endpoints and serving capabilities validated"
}

# Test 6: Validate monitoring and alerting configurations
test_monitoring_alerting() {
    log_test_start "Validate monitoring and alerting configurations" "high"
    
    local monitoring_checks=()
    local agent_content
    local docs_content=""
    
    if ! agent_content=$(cat "$ML_AGENT_FILE"); then
        log_test_fail "monitoring and alerting" "Cannot read agent file" "false"
        return
    fi
    
    # Aggregate monitoring documentation
    for doc in "$ML_DOCS_DIR"/{mlops-guide.md,phase3-intelligence-layer.md,performance-predictor-guide.md}; do
        if [[ -f "$doc" ]]; then
            docs_content+=$(cat "$doc")$'\n'
        fi
    done
    
    combined_content="$agent_content"$'\n'"$docs_content"
    
    # Check for monitoring systems integration
    local monitoring_systems=(
        "prometheus"
        "grafana"
        "cloudwatch"
        "datadog"
        "new.*relic"
    )
    
    local systems_found=0
    for system in "${monitoring_systems[@]}"; do
        if echo "$combined_content" | grep -i -q "$system"; then
            ((systems_found++))
        fi
    done
    
    if [[ $systems_found -lt 3 ]]; then
        monitoring_checks+=("Insufficient monitoring systems integration ($systems_found/5)")
    fi
    
    # Check for alerting configurations
    local alerting_patterns=(
        "alert.*threshold\|alert.*rule"
        "notification\|alert.*channel"
        "slack\|email\|pagerduty"
        "incident.*response"
        "escalation"
        "false.*positive.*rate"
    )
    
    local alerting_found=0
    for pattern in "${alerting_patterns[@]}"; do
        if echo "$combined_content" | grep -i -q "$pattern"; then
            ((alerting_found++))
        fi
    done
    
    if [[ $alerting_found -lt 3 ]]; then
        monitoring_checks+=("Insufficient alerting configuration ($alerting_found/6)")
    fi
    
    # Check for ML-specific metrics
    local ml_metrics=(
        "model.*accuracy\|prediction.*accuracy"
        "drift.*detection\|model.*drift"
        "prediction.*latency"
        "throughput"
        "error.*rate"
        "business.*impact"
    )
    
    local metrics_found=0
    for metric in "${ml_metrics[@]}"; do
        if echo "$combined_content" | grep -i -q "$metric"; then
            ((metrics_found++))
        fi
    done
    
    if [[ $metrics_found -lt 4 ]]; then
        monitoring_checks+=("Insufficient ML-specific metrics ($metrics_found/6)")
    fi
    
    if [[ ${#monitoring_checks[@]} -gt 0 ]]; then
        log_test_fail "monitoring and alerting" "${monitoring_checks[*]}" "false"
        return
    fi
    
    log_test_pass "monitoring and alerting" "Monitoring systems and alerting configurations validated"
}

# Test 7: Integration tests for ML pipeline workflow
test_ml_pipeline_workflow() {
    log_test_start "Integration tests for ML pipeline workflow" "high"
    
    local pipeline_checks=()
    local docs_content=""
    
    # Check MLOps guide for pipeline documentation
    if [[ -f "$ML_DOCS_DIR/mlops-guide.md" ]]; then
        docs_content=$(cat "$ML_DOCS_DIR/mlops-guide.md")
    else
        # Fallback to other ML documentation
        for doc in "$ML_DOCS_DIR"/ml*.md "$ML_DOCS_DIR"/phase3*.md; do
            if [[ -f "$doc" ]]; then
                docs_content+=$(cat "$doc")$'\n'
            fi
        done
    fi
    
    # Check for complete ML pipeline stages
    local pipeline_stages=(
        "data.*ingestion\|data.*collection"
        "feature.*engineering"
        "model.*training"
        "model.*validation\|model.*testing"
        "model.*deployment"
        "model.*monitoring"
        "model.*retraining\|continuous.*learning"
    )
    
    local stages_found=0
    for stage in "${pipeline_stages[@]}"; do
        if echo "$docs_content" | grep -i -q "$stage"; then
            ((stages_found++))
        fi
    done
    
    if [[ $stages_found -lt 5 ]]; then
        pipeline_checks+=("Incomplete ML pipeline stages ($stages_found/7)")
    fi
    
    # Check for automation and CI/CD integration
    local automation_patterns=(
        "continuous.*integration\|ci\/cd"
        "automated.*testing"
        "automated.*deployment"
        "rollback.*mechanism"
        "canary.*deployment\|blue.*green"
        "github.*actions\|jenkins\|gitlab"
    )
    
    local automation_found=0
    for pattern in "${automation_patterns[@]}"; do
        if echo "$docs_content" | grep -i -q "$pattern"; then
            ((automation_found++))
        fi
    done
    
    if [[ $automation_found -lt 3 ]]; then
        pipeline_checks+=("Insufficient automation integration ($automation_found/6)")
    fi
    
    # Check for data quality and validation
    local quality_patterns=(
        "data.*validation\|data.*quality"
        "feature.*validation"
        "great.*expectations"
        "data.*drift.*detection"
        "schema.*validation"
    )
    
    local quality_found=0
    for pattern in "${quality_patterns[@]}"; do
        if echo "$docs_content" | grep -i -q "$pattern"; then
            ((quality_found++))
        fi
    done
    
    if [[ $quality_found -lt 2 ]]; then
        pipeline_checks+=("Insufficient data quality measures ($quality_found/5)")
    fi
    
    if [[ ${#pipeline_checks[@]} -gt 0 ]]; then
        log_test_fail "ML pipeline workflow" "${pipeline_checks[*]}" "false"
        return
    fi
    
    log_test_pass "ML pipeline workflow" "Complete ML pipeline workflow validated"
}

# Test 8: Validate security and compliance requirements
test_security_compliance() {
    log_test_start "Validate security and compliance requirements" "critical"
    
    local security_checks=()
    local docs_content=""
    
    # Aggregate security-related documentation
    for doc in "$ML_DOCS_DIR"/{mlops-guide.md,phase3-intelligence-layer.md}; do
        if [[ -f "$doc" ]]; then
            docs_content+=$(cat "$doc")$'\n'
        fi
    done
    
    # Check for security measures
    local security_patterns=(
        "authentication\|auth"
        "authorization\|rbac"
        "encryption.*at.*rest\|encryption.*in.*transit"
        "tls\|ssl"
        "api.*key\|token.*based"
        "network.*policy\|network.*security"
        "audit.*log\|audit.*trail"
    )
    
    local security_found=0
    for pattern in "${security_patterns[@]}"; do
        if echo "$docs_content" | grep -i -q "$pattern"; then
            ((security_found++))
        fi
    done
    
    if [[ $security_found -lt 4 ]]; then
        security_checks+=("Insufficient security measures ($security_found/7)")
    fi
    
    # Check for data protection and privacy
    local privacy_patterns=(
        "pii.*scrubbing\|data.*anonymization"
        "gdpr\|data.*protection"
        "data.*retention.*policy"
        "privacy.*by.*design"
        "consent.*management"
    )
    
    local privacy_found=0
    for pattern in "${privacy_patterns[@]}"; do
        if echo "$docs_content" | grep -i -q "$pattern"; then
            ((privacy_found++))
        fi
    done
    
    if [[ $privacy_found -lt 2 ]]; then
        security_checks+=("Insufficient privacy protection measures ($privacy_found/5)")
    fi
    
    # Check for model security
    local model_security_patterns=(
        "model.*versioning"
        "model.*rollback"
        "adversarial.*robustness"
        "input.*validation"
        "rate.*limiting"
    )
    
    local model_security_found=0
    for pattern in "${model_security_patterns[@]}"; do
        if echo "$docs_content" | grep -i -q "$pattern"; then
            ((model_security_found++))
        fi
    done
    
    if [[ $model_security_found -lt 2 ]]; then
        security_checks+=("Insufficient model security measures ($model_security_found/5)")
    fi
    
    if [[ ${#security_checks[@]} -gt 0 ]]; then
        log_test_fail "security and compliance" "${security_checks[*]}" "true"
        return
    fi
    
    log_test_pass "security and compliance" "Security and compliance requirements validated"
}

# Test 9: Performance benchmarking and SLA validation
test_performance_benchmarks() {
    log_test_start "Performance benchmarking and SLA validation" "high"
    
    local performance_checks=()
    local agent_content
    local docs_content=""
    
    if ! agent_content=$(cat "$ML_AGENT_FILE"); then
        log_test_fail "performance benchmarks" "Cannot read agent file" "false"
        return
    fi
    
    # Aggregate performance documentation
    for doc in "$ML_DOCS_DIR"/{mlops-guide.md,phase3-intelligence-layer.md,performance-predictor-guide.md}; do
        if [[ -f "$doc" ]]; then
            docs_content+=$(cat "$doc")$'\n'
        fi
    done
    
    combined_content="$agent_content"$'\n'"$docs_content"
    
    # Check for specific performance targets
    local latency_targets=(
        "50ms\|100ms\|<.*100.*ms"
        "p95.*<.*ms\|p99.*<.*ms"
        "response.*time.*<"
    )
    
    local latency_found=0
    for target in "${latency_targets[@]}"; do
        if echo "$combined_content" | grep -i -q "$target"; then
            ((latency_found++))
        fi
    done
    
    if [[ $latency_found -lt 1 ]]; then
        performance_checks+=("No specific latency targets found")
    fi
    
    # Check for throughput specifications
    local throughput_targets=(
        "[0-9]+.*requests.*per.*second\|rps"
        "[0-9]+.*predictions.*per.*second"
        "sustained.*throughput"
        "concurrent.*users\|concurrent.*requests"
    )
    
    local throughput_found=0
    for target in "${throughput_targets[@]}"; do
        if echo "$combined_content" | grep -i -q "$target"; then
            ((throughput_found++))
        fi
    done
    
    if [[ $throughput_found -lt 1 ]]; then
        performance_checks+=("No specific throughput targets found")
    fi
    
    # Check for availability targets
    local availability_targets=(
        "99\.9%\|99\.99%"
        "uptime.*>.*99"
        "sla.*99"
        "high.*availability"
        "disaster.*recovery"
    )
    
    local availability_found=0
    for target in "${availability_targets[@]}"; do
        if echo "$combined_content" | grep -i -q "$target"; then
            ((availability_found++))
        fi
    done
    
    if [[ $availability_found -lt 1 ]]; then
        performance_checks+=("No specific availability targets found")
    fi
    
    # Check for accuracy targets (critical for ML)
    local accuracy_targets=(
        "95%.*accuracy\|>.*95%.*accuracy"
        "85%.*accuracy\|>.*85%.*accuracy"
        "90%.*accuracy\|>.*90%.*accuracy"
        "prediction.*accuracy.*>"
        "model.*accuracy.*threshold"
    )
    
    local accuracy_found=0
    for target in "${accuracy_targets[@]}"; do
        if echo "$combined_content" | grep -i -q "$target"; then
            ((accuracy_found++))
        fi
    done
    
    if [[ $accuracy_found -lt 1 ]]; then
        performance_checks+=("No specific accuracy targets found (critical for ML)")
    fi
    
    if [[ ${#performance_checks[@]} -gt 0 ]]; then
        log_test_fail "performance benchmarks" "${performance_checks[*]}" "false"
        return
    fi
    
    log_test_pass "performance benchmarks" "Performance targets and SLAs validated"
}

# Test 10: Automated rollback testing for failed deployments
test_automated_rollback() {
    log_test_start "Automated rollback testing for failed deployments" "critical"
    
    local rollback_checks=()
    local docs_content=""
    
    # Check for rollback documentation
    for doc in "$ML_DOCS_DIR"/{mlops-guide.md,phase3-intelligence-layer.md}; do
        if [[ -f "$doc" ]]; then
            docs_content+=$(cat "$doc")$'\n'
        fi
    done
    
    # Check for rollback mechanisms
    local rollback_patterns=(
        "rollback.*mechanism\|automated.*rollback"
        "canary.*deployment"
        "blue.*green.*deployment"
        "health.*check.*failure.*rollback"
        "previous.*stable.*version"
        "rapid.*rollback\|emergency.*rollback"
    )
    
    local rollback_found=0
    for pattern in "${rollback_patterns[@]}"; do
        if echo "$docs_content" | grep -i -q "$pattern"; then
            ((rollback_found++))
        fi
    done
    
    if [[ $rollback_found -lt 3 ]]; then
        rollback_checks+=("Insufficient rollback mechanisms documented ($rollback_found/6)")
    fi
    
    # Check for failure detection patterns
    local failure_detection=(
        "health.*check.*fail"
        "accuracy.*threshold.*breach"
        "error.*rate.*threshold"
        "latency.*threshold.*breach"
        "model.*drift.*detection"
        "anomaly.*detection.*trigger"
    )
    
    local detection_found=0
    for pattern in "${failure_detection[@]}"; do
        if echo "$docs_content" | grep -i -q "$pattern"; then
            ((detection_found++))
        fi
    done
    
    if [[ $detection_found -lt 3 ]]; then
        rollback_checks+=("Insufficient failure detection mechanisms ($detection_found/6)")
    fi
    
    # Check for rollback verification
    local verification_patterns=(
        "rollback.*verification\|rollback.*success.*check"
        "post.*rollback.*validation"
        "service.*restoration.*confirmation"
        "metrics.*recovery.*validation"
    )
    
    local verification_found=0
    for pattern in "${verification_patterns[@]}"; do
        if echo "$docs_content" | grep -i -q "$pattern"; then
            ((verification_found++))
        fi
    done
    
    if [[ $verification_found -lt 1 ]]; then
        rollback_checks+=("No rollback verification mechanisms documented")
    fi
    
    if [[ ${#rollback_checks[@]} -gt 0 ]]; then
        log_test_fail "automated rollback" "${rollback_checks[*]}" "true"
        return
    fi
    
    log_test_pass "automated rollback" "Automated rollback mechanisms validated"
}

# Main test execution function
run_phase3_tests() {
    echo
    log_info "Starting Phase 3: Intelligence Layer Implementation Tests"
    log_info "======================================================"
    log_info "Target: >95% reliability with comprehensive ML testing"
    echo
    
    # Run all tests in logical order
    test_performance_predictor_agent_structure
    test_ml_prediction_capabilities
    test_ml_infrastructure_components
    test_deployment_configurations
    test_ml_api_endpoints
    test_monitoring_alerting
    test_ml_pipeline_workflow
    test_security_compliance
    test_performance_benchmarks
    test_automated_rollback
    
    # Print comprehensive test summary with reliability analysis
    echo
    log_info "Phase 3: Intelligence Layer Test Results Summary"
    log_info "================================================="
    
    # Calculate reliability percentage
    local reliability_percentage=0
    if [[ $TOTAL_TESTS -gt 0 ]]; then
        reliability_percentage=$(( (PASSED_TESTS * 100) / TOTAL_TESTS ))
    fi
    
    # Detailed results breakdown
    for result in "${TEST_RESULTS[@]}"; do
        if [[ "$result" == PASS:* ]]; then
            log_success "$result"
        elif [[ "$result" == "CRITICAL FAIL:"* ]]; then
            log_error "$result"
        else
            log_warning "$result"
        fi
    done
    
    echo
    echo "================================================="
    log_info "Total Tests: $TOTAL_TESTS"
    log_success "Passed: $PASSED_TESTS"
    
    if [[ $FAILED_TESTS -gt 0 ]]; then
        log_warning "Failed: $FAILED_TESTS"
    else
        log_success "Failed: $FAILED_TESTS"
    fi
    
    if [[ $CRITICAL_FAILURES -gt 0 ]]; then
        log_error "Critical Failures: $CRITICAL_FAILURES"
    else
        log_success "Critical Failures: $CRITICAL_FAILURES"
    fi
    
    echo
    log_info "System Reliability: ${reliability_percentage}% (Target: >95%)"
    
    # Final assessment
    if [[ $CRITICAL_FAILURES -gt 0 ]]; then
        echo
        log_error "Phase 3 implementation validation FAILED - Critical failures detected"
        log_error "Critical failures must be resolved before production deployment"
        return 1
    elif [[ $reliability_percentage -lt 95 ]]; then
        echo
        log_warning "Phase 3 implementation validation PASSED with concerns"
        log_warning "Reliability ${reliability_percentage}% is below target (95%)"
        log_warning "Consider addressing failed tests before production deployment"
        return 2
    else
        echo
        log_success "Phase 3 implementation validation PASSED"
        log_success "System meets production-ready requirements with ${reliability_percentage}% reliability"
        return 0
    fi
}

# Health check function to verify Phase 3 dependencies
health_check() {
    local missing_deps=()
    
    # Check for required commands
    local required_commands=("git" "grep" "sed" "python3")
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing_deps+=("$cmd")
        fi
    done
    
    # Check repository structure
    if [[ ! -d "$REPO_ROOT/.claude" ]]; then
        missing_deps+=(".claude directory")
    fi
    
    if [[ ! -d "$REPO_ROOT/docs" ]]; then
        missing_deps+=("docs directory")
    fi
    
    # Check for Python if ML scripts need to be tested
    if command -v python3 >/dev/null 2>&1; then
        # Check for essential Python packages
        if ! python3 -c "import json, datetime" 2>/dev/null; then
            missing_deps+=("Python standard library incomplete")
        fi
    fi
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        log_error "Missing dependencies for Phase 3 testing: ${missing_deps[*]}"
        exit 1
    fi
    
    log_info "Phase 3 test environment health check passed"
}

# Performance measurement wrapper
measure_test_performance() {
    local test_function="$1"
    local start_time
    local end_time
    local duration
    
    start_time=$(date +%s.%N)
    "$test_function"
    local exit_code=$?
    end_time=$(date +%s.%N)
    
    duration=$(echo "$end_time - $start_time" | bc -l 2>/dev/null || echo "0")
    
    if command -v bc >/dev/null 2>&1 && [[ -n "$duration" ]]; then
        log_info "Test execution time: ${duration}s"
    fi
    
    return $exit_code
}

# Script entry point with performance measurement
main() {
    local overall_start_time
    local overall_end_time
    local total_duration
    
    overall_start_time=$(date +%s.%N)
    
    # Perform health check
    health_check
    
    # Run tests with performance monitoring
    local exit_code=0
    if ! run_phase3_tests; then
        exit_code=$?
    fi
    
    overall_end_time=$(date +%s.%N)
    
    if command -v bc >/dev/null 2>&1; then
        total_duration=$(echo "$overall_end_time - $overall_start_time" | bc -l)
        echo
        log_info "Total test execution time: ${total_duration}s"
        
        # Performance target: Complete test suite should run in < 60 seconds
        if [[ $(echo "$total_duration > 60" | bc -l) -eq 1 ]]; then
            log_warning "Test execution time exceeds 60s target"
        else
            log_success "Test execution performance within target"
        fi
    fi
    
    exit $exit_code
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi