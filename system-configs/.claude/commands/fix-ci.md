---
description: Diagnoses and fixes GitHub Actions CI failures automatically
argument-hint: [run-id|--learn]
thinking-level: megathink
thinking-tokens: 10000
---

# /fix-ci Command

## Usage

```bash
/fix-ci                  # Fix latest failure
/fix-ci 12345678         # Fix specific run
/fix-ci --learn          # Update fix patterns from history
```

## Description

Diagnose and fix GitHub Actions failures using pattern recognition, historical fix data, and **real-time CI monitoring**.
Fetches actual failure data from GitHub Actions API, deploys specialized agents to fix issues, then **monitors CI runs
to verify fixes actually work**. Only completes when GitHub Actions shows all checks passing.

**Critical Improvement**: Now uses GitHub Actions API to verify fixes work in real CI runs, not just local tests.
After each fix wave, the command monitors the actual CI run and fetches new failures if any remain. Process continues
iteratively until GitHub Actions shows all green checkmarks.

**Important**: Complex CI issues often cascade, requiring multiple remediation waves. The process continues iteratively
until all CI checks pass, with each wave addressing newly discovered failures from actual CI runs.

### Thinking Level: MEGATHINK (10,000 tokens)

This command requires substantial thinking depth due to:

- **Complex CI/CD debugging**: Analyzing multiple failure modes across parallel workflows
- **Pattern recognition complexity**: Matching failures against historical fix database
- **Cascading failure analysis**: Understanding interdependent test and build failures
- **Pipeline repair orchestration**: Coordinating fixes across multiple configuration files
- **Confidence calculation logic**: Statistical analysis of fix likelihood and risk assessment

## Expected Output

### Successful CI Fix with Confidence

```text
🔍 Pattern confidence: 96%
🔧 Applying fix (96% confidence)...
🧪 Testing fix locally...
✅ Local tests passed
💾 Committed and pushed fix
📊 Recorded outcome: CI passed = true
```

### Multi-Wave Remediation with Real CI Verification

```text
🆔 Execution: fix-ci-1738886234-12345
🔍 Initial run ID: #987654

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Wave 1: Starting remediation cycle
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔍 Wave 1: Fetching failures from GitHub Actions API...
📊 CI Failure Discovery Results:
  • Job failures: 3
  • Check failures: 2
  • Total unique: 5 failures
📊 Wave 1: Found 5 failures in run #987654

🤖 Wave 1: Deploying analysis agents...
🔍 Wave 1: Enhanced pattern confidence: 96% (complexity: 3)
🔧 Wave 1: Deploying parallel fix agents (96% confidence)...
🧪 Wave 1: Enhanced local testing with parallel validation...
✅ Local tests passed

💾 Wave 1: Committing and pushing fixes...
📊 Wave 1: Monitoring real CI run on GitHub Actions...
📊 Wave 1: Waiting for CI run to start...
✅ New CI run detected: #987655
📊 Wave 1: Monitoring CI run #987655...
[Real-time CI output from gh run watch]

📊 Wave 1: CI Results:
  Run ID: #987655
  Status: completed
  Conclusion: failure

⚠️ Wave 1: CI still has failures
🔍 Fetching new failure data for next wave...
🔄 Next wave will analyze run #987655

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Wave 2: Starting remediation cycle
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔍 Wave 2: Fetching failures from GitHub Actions API...
📊 Wave 2: Found 2 failures in run #987655 (down from 5)

🤖 Wave 2: Deploying analysis agents...
🔧 Wave 2: Deploying parallel fix agents (92% confidence)...
🧪 Wave 2: Enhanced local testing...
✅ Local tests passed

💾 Wave 2: Committing and pushing fixes...
📊 Wave 2: Monitoring real CI run on GitHub Actions...
✅ New CI run detected: #987656
📊 Wave 2: Monitoring CI run #987656...

📊 Wave 2: CI Results:
  Run ID: #987656
  Status: completed
  Conclusion: success

✅✅✅ Wave 2: ALL CI CHECKS PASSED! ✅✅✅
🎉 GitHub Actions showing all green checkmarks

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 FINAL RESULTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Success: 2 waves required for full CI remediation
🆔 Execution ID: fix-ci-1738886234-12345
📊 Final run: #987656
✅ All GitHub Actions checks: PASSING
```

### Low Confidence Scenario

```text
User: /fix-ci
Claude: 🔍 Pattern confidence: 70%
⚠️ Confidence too low (70% < 95%)
💡 Manual review recommended
```

### Learning Mode

```text
User: /fix-ci --learn
Claude: 📊 Historical Fix Analysis:
Lint/Format: 98% success rate (47/48 attempts)
Dependencies: 92% success rate (23/25 attempts)
Test Failures: 85% success rate (17/20 attempts)
Type Errors: 78% success rate (14/18 attempts)
```

## GitHub Actions API Integration

### Aggressive Multi-Source CI Failure Fetching

Following the `/resolve-cr` pattern of comprehensive data collection, `/fix-ci` now fetches CI failures from multiple
GitHub Actions API endpoints:

```bash
# Generate unique execution ID (like /resolve-cr)
execution_id="fix-ci-$(date +%s)-$$"
echo "🆔 Execution: $execution_id"

# Get run ID
run_id="${1:-$(gh run list --status=failure --limit=1 --jq '.[0].databaseId')}"

echo "🔍 Fetching CI failures from GitHub Actions API..."

# SOURCE 1: Job-level failures (main source)
job_failures=$(gh run view "$run_id" --json jobs --jq '
  .jobs[] |
  select(.conclusion == "failure") |
  {
    id: .id,
    name: .name,
    conclusion: .conclusion,
    steps: [.steps[] | select(.conclusion == "failure") | {name: .name, conclusion: .conclusion}]
  }
')

# SOURCE 2: Full run logs (detailed error messages)
run_logs=$(gh run view "$run_id" --log 2>&1)

# SOURCE 3: Check-level failures (additional validation)
check_failures=$(gh api "repos/{owner}/{repo}/commits/$(git rev-parse HEAD)/check-runs" --jq '
  .check_runs[] |
  select(.conclusion == "failure") |
  {
    id: .id,
    name: .name,
    conclusion: .conclusion,
    output: .output.summary
  }
')

# Merge and deduplicate failures
all_failures=$(echo "$job_failures"; echo "$check_failures" | jq -s 'flatten | unique_by(.id)')
total_failures=$(echo "$all_failures" | jq length)

echo "📊 CI Failure Discovery Results:"
echo "  • Job failures: $(echo "$job_failures" | jq length)"
echo "  • Check failures: $(echo "$check_failures" | jq length)"
echo "  • Total unique: $total_failures failures"
```

### CATASTROPHIC FAILURE: No Failures Found

Like `/resolve-cr`, if no failures are found in Wave 1, this is a FAILURE, not success:

```bash
if [ "$total_failures" -eq 0 ] && [ "$wave" -eq 1 ]; then
  echo ""
  echo "❌ CATASTROPHIC FAILURE: No CI failures found"
  echo ""
  echo "🔍 Diagnostic Information:"
  echo "  Execution ID: $execution_id"
  echo "  Run ID: $run_id"
  echo "  Searched 3 different API sources"
  echo "  All sources returned 0 failures"
  echo ""
  echo "⚠️  Possible Issues:"
  echo "  1. CI run hasn't completed yet"
  echo "  2. All failures already fixed (check CI status)"
  echo "  3. API permissions issue preventing access"
  echo "  4. Wrong run ID provided"
  echo ""
  echo "🔧 Troubleshooting:"
  echo "  1. Check CI status: gh run view $run_id"
  echo "  2. List recent runs: gh run list --limit 5"
  echo "  3. Verify GitHub CLI auth: gh auth status"
  echo ""
  exit 1
fi
```

### Real-Time CI Monitoring Loop

After pushing fixes, monitor the actual CI run to verify success:

```bash
monitor_ci_after_push() {
  local wave=$1
  local branch=$(git branch --show-current)

  echo "📊 Wave $wave: Waiting for CI run to start..."

  # Wait for new CI run (timeout after 60 seconds)
  local timeout=60
  local elapsed=0
  local new_run_id=""

  while [ $elapsed -lt $timeout ]; do
    new_run_id=$(gh run list --branch "$branch" --limit 1 --json databaseId,status,createdAt \
      --jq 'select(.[0].status == "in_progress" or .[0].status == "queued") | .[0].databaseId')

    if [ -n "$new_run_id" ]; then
      echo "✅ New CI run detected: #$new_run_id"
      break
    fi

    sleep 2
    elapsed=$((elapsed + 2))
  done

  if [ -z "$new_run_id" ]; then
    echo "⚠️ No CI run detected after $timeout seconds"
    echo "💡 CI may be disabled or delayed. Check manually: gh run list"
    return 1
  fi

  # Monitor CI run in real-time
  echo "📊 Wave $wave: Monitoring CI run #$new_run_id..."
  gh run watch "$new_run_id" --exit-status

  # Fetch final status
  local ci_conclusion=$(gh run view "$new_run_id" --json conclusion --jq '.conclusion')
  local ci_status=$(gh run view "$new_run_id" --json status --jq '.status')

  echo ""
  echo "📊 Wave $wave: CI Results:"
  echo "  Run ID: #$new_run_id"
  echo "  Status: $ci_status"
  echo "  Conclusion: $ci_conclusion"
  echo ""

  if [ "$ci_conclusion" == "success" ]; then
    echo "✅ Wave $wave: All CI checks PASSED!"
    return 0
  else
    echo "⚠️ Wave $wave: CI still has failures"
    echo "🔍 Fetching new failure data for next wave..."

    # Fetch NEW failures for next iteration
    fetch_all_ci_failures "$new_run_id"
    return 1
  fi
}
```

### Execution State Tracking

Track execution state across waves (like /resolve-cr):

```bash
# State tracking file
state_file=".tmp/fix-ci/execution-$execution_id.json"
mkdir -p .tmp/fix-ci

# Initialize state
init_execution_state() {
  cat > "$state_file" <<EOF
{
  "execution_id": "$execution_id",
  "started_at": "$(date -Iseconds)",
  "waves": [],
  "original_run_id": "$run_id",
  "original_failure_count": $total_failures
}
EOF
}

# Record wave results
record_wave_result() {
  local wave=$1
  local run_id=$2
  local conclusion=$3
  local new_failures=$4

  jq ".waves += [{
    \"wave\": $wave,
    \"run_id\": \"$run_id\",
    \"conclusion\": \"$conclusion\",
    \"failures_remaining\": $new_failures,
    \"timestamp\": \"$(date -Iseconds)\"
  }]" "$state_file" > "${state_file}.tmp" && mv "${state_file}.tmp" "$state_file"
}
```

## Behavior

### Agent Orchestration - Enhanced Multi-Wave Parallel Deployment

#### WAVE 1: Enhanced Parallel Failure Analysis (10-15 agents deployed simultaneously)

```yaml
# ENHANCED PARALLEL WAVE 1: Maximum Simultaneous Analysis
devops (expanded instance pool):
  deployment: 3-4 instances (was 2-3) - based on pipeline complexity
  distribution:
    - instance_1: Pipeline/workflow configuration issues
    - instance_2: Infrastructure and environment problems
    - instance_3: Deployment and integration failures
    - instance_4: Resource constraints and timeout analysis
  parallel_with: [test-engineer instances, platform-engineer instances, debugger instances]
  output: Pipeline fixes, configuration corrections, resource optimization

test-engineer (expanded instance pool):
  deployment: 4-5 instances (was 3-4) - for comprehensive test coverage
  distribution:
    - instance_1: Unit test failures and mocking issues
    - instance_2: Integration test failures and service connections
    - instance_3: E2E test failures and browser automation
    - instance_4: Flaky test identification and stabilization
    - instance_5: Performance test failures and load issues
  parallel_with: [devops instances, platform-engineer instances, debugger instances]
  output: Test fixes, stability improvements, performance optimizations

platform-engineer (expanded instance pool):
  deployment: 3-4 instances (was 2-3) - for deeper environment analysis
  distribution:
    - instance_1: Dependency resolution and version conflicts
    - instance_2: Build environment and toolchain problems
    - instance_3: Container/Docker configuration issues
    - instance_4: Runtime environment and system resource analysis
  parallel_with: [devops instances, test-engineer instances, debugger instances]
  output: Environment fixes, dependency resolutions, container optimizations

debugger (NEW - specialized debugging instances):
  deployment: 2-3 instances - for complex failure analysis
  distribution:
    - instance_1: Stack trace analysis and error correlation
    - instance_2: Memory/performance issue investigation
    - instance_3: Timing and race condition detection
  parallel_with: [all other Wave 1 agents]
  output: Root cause analysis, complex failure patterns

code-reviewer (enhanced):
  deployment: 2 instances - for comprehensive code analysis
  distribution:
    - instance_1: Syntax, style, and structural issues
    - instance_2: Logic errors and integration problems
  parallel_with: [all other Wave 1 agents]
  output: Code quality issues, architectural problems

security-auditor:
  deployment: 1-2 instances - security-focused analysis
  distribution:
    - instance_1: Security policy violations and compliance
    - instance_2: Vulnerability scanning and dependency security
  parallel_with: [all other Wave 1 agents]
  output: Security violations, compliance issues

execution-evaluator:
  deployment: 1 instance - coordination and confidence aggregation
  role: Synthesize findings from all Wave 1 agents
  parallel_with: [all other Wave 1 agents]
  output: Consolidated analysis, confidence scoring recommendations
```

#### WAVE 2: Conditional Fix Application (Only if 95%+ confident)

```yaml
# Enhanced Claude Confidence Calculation with Pattern Learning
confidence_calculation:
  base_patterns: Historical success rates from .tmp/fix-ci/
  failure_complexity: Number of different failure types detected
  agent_consensus: Agreement level between Wave 1 agent findings
  historical_similarity: Match strength to previous successful fixes
  environmental_factors: CI vs local environment differences

# Deploy fix agents only when confident
fix_deployment (conditional):
  trigger: confidence >= 95%
  strategy: Multiple parallel fix agents by failure type

  lint_fixes:
    - code-reviewer instance 1: ESLint rule violations
    - code-reviewer instance 2: Prettier formatting issues
    - code-reviewer instance 3: Custom linting rule failures

  test_fixes:
    - test-engineer instance 1: Unit test assertion fixes
    - test-engineer instance 2: Mock and stub corrections
    - test-engineer instance 3: Test environment setup issues

  build_fixes:
    - platform-engineer instance 1: Dependency version resolution
    - platform-engineer instance 2: Build configuration updates
    - devops instance 1: CI pipeline configuration fixes

  deployment_fixes:
    - devops instance 2: Container and orchestration fixes
    - platform-engineer instance 3: Environment variable corrections
    - security-auditor: Security configuration adjustments

local_validation:
  parallel_testing: Run all test suites simultaneously
  lint_validation: Multiple linting tools in parallel
  build_verification: Parallel build across different configurations
  security_scanning: Parallel security checks
```

#### WAVE 3: Enhanced Verification & Monitoring

```yaml
# Verification and continuous monitoring agents
monitoring_deployment:
  ci_monitor:
    deployment: 1 instance
    role: Real-time CI pipeline status monitoring
    duration: Until all checks pass or timeout

  performance_monitor:
    deployment: 1 instance
    role: Track build performance improvements/degradations
    metrics: Build time, test execution speed, resource usage

  pattern_learner:
    deployment: 1 instance
    role: Update pattern database with outcomes
    learning: Record success/failure patterns for future confidence scoring

  regression_detector:
    deployment: 1 instance
    role: Monitor for new issues introduced by fixes
    alert: Flag any new test failures or build issues

success_verification:
  criteria:
    - All CI checks pass (100% success requirement)
    - No new failures introduced
    - Performance metrics maintained or improved
    - Security scans pass
  recording: Update .tmp/fix-ci/history.log with comprehensive outcome data
```

#### WAVE N: Iterative Remediation Cycles

**Critical**: Wave 3 verification may reveal additional failures requiring Wave 4 fixes. Complex CI issues often
cascade, with each remediation wave uncovering new problems that must be addressed.

```yaml
# Iterative remediation pattern for cascading failures
wave_continuation:
  trigger: "CI verification reveals new failures after previous wave fixes"
  process: "Each wave addresses failures discovered in CI runs from previous wave"
  examples:
    - "Wave 4: Address integration test failures revealed after Wave 3 lint fixes"
    - "Wave 5: Resolve environment conflicts exposed by Wave 4 dependency updates"
    - "Wave 6: Fix security violations uncovered by Wave 5 configuration changes"

  escalation_pattern:
    wave_4_plus:
      diagnostic_agents: "Deploy additional specialized agents for complex cascading issues"
      confidence_adjustment: "Lower confidence threshold to 90% for iterative fixes"
      monitoring_intensity: "Increase monitoring frequency and failure detection granularity"

  termination_conditions:
    success: "All CI checks pass with no new failures detected"
    max_waves: "Limit to 8 waves to prevent infinite remediation cycles"
    confidence_floor: "Stop if confidence drops below 75% for safety"
```

**Remediation Wave Examples**:

- **Wave 3**: Initial fixes pass, but CI reveals test environment issues
- **Wave 4**: Environment fixes applied, CI discovers dependency version conflicts
- **Wave 5**: Dependencies resolved, CI exposes security policy violations
- **Wave 6**: Security fixes applied, CI shows performance regression
- **Wave 7**: Performance optimizations completed, all CI checks finally pass

### Enhanced Pattern Recognition with Multi-Agent Confidence

#### Advanced Pattern Matching with Agent Consensus

```yaml
# Enhanced confidence scoring with agent input weighting
pattern_confidence_matrix:
  Lint/Format:
    base_confidence: 98%
    agent_weights:
      code-reviewer: 0.4
      devops: 0.3
      execution-evaluator: 0.3
    consensus_multiplier: 1.0-1.2 (higher when agents agree)

  Dependencies:
    base_confidence: 92%
    agent_weights:
      platform-engineer: 0.5
      devops: 0.3
      debugger: 0.2
    consensus_multiplier: 1.0-1.15

  Test Failures:
    base_confidence: 85%
    agent_weights:
      test-engineer: 0.6
      debugger: 0.25
      code-reviewer: 0.15
    consensus_multiplier: 1.0-1.1

  Complex Issues:
    base_confidence: 60%
    agent_weights:
      debugger: 0.4
      execution-evaluator: 0.3
      platform-engineer: 0.2
      devops: 0.1
    consensus_multiplier: 1.0-1.3 (critical for complex issues)
```

#### Multi-Agent Learning Integration

```bash
# Enhanced learning system with agent-specific patterns
record_enhanced_outcome() {
  local pattern="$1"
  local confidence="$2"
  local all_ci_passed="$3"
  local agent_consensus="$4"
  local failure_complexity="$5"
  local fix_duration="$6"
  local wave_count="$7"

  echo "$(date),$pattern,$confidence,$all_ci_passed,$agent_consensus,$failure_complexity,$fix_duration,$wave_count" >> .tmp/fix-ci/enhanced-history.log
}

# Calculate confidence with multi-factor analysis
get_enhanced_confidence() {
  local pattern="$1"
  local agent_findings="$2"
  local complexity_score="$3"
  local wave_number="$4"

  # Base historical confidence
  local base_confidence
  base_confidence=$(get_confidence "$pattern")

  # Agent consensus factor (0.8-1.2 multiplier)
  local consensus_factor
  consensus_factor=$(calculate_agent_consensus "$agent_findings")

  # Complexity adjustment (-10 to +5 points based on issue complexity)
  local complexity_adjustment
  complexity_adjustment=$(calculate_complexity_adjustment "$complexity_score")

  # Wave iteration penalty (-5 points per wave beyond 3)
  local wave_penalty=0
  if [[ $wave_number -gt 3 ]]; then
    wave_penalty=$(( (wave_number - 3) * 5 ))
  fi

  # Final confidence calculation
  local final_confidence
  final_confidence=$(echo "$base_confidence * $consensus_factor + $complexity_adjustment - $wave_penalty" | bc -l)

  echo "${final_confidence%.*}" # Return integer confidence
}
```

### Enhanced Main Execution Flow with Real CI Verification

#### Multi-Wave Orchestration Process with GitHub Actions API

```bash
fix_ci_enhanced() {
  # Generate unique execution ID (like /resolve-cr)
  local execution_id="fix-ci-$(date +%s)-$$"
  echo "🆔 Execution: $execution_id"

  init_enhanced_history
  init_execution_state
  validate_prerequisites || return 1

  local run_id="${1:-$(gh run list --status=failure --limit=1 --jq '.[0].databaseId')}"
  [[ -z "$run_id" || "$run_id" == "null" ]] && { echo "ℹ️ No failed runs found."; return 1; }

  echo "🔍 Initial run ID: #$run_id"

  local wave_count=1
  local max_waves=8
  local all_ci_passed=false
  local current_run_id="$run_id"

  # Continue iterative remediation until CI passes or max waves reached
  while [[ $all_ci_passed == false && $wave_count -le $max_waves ]]; do
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🚀 Wave $wave_count: Starting remediation cycle"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # FETCH REAL FAILURES from GitHub Actions API
    echo "🔍 Wave $wave_count: Fetching failures from GitHub Actions API..."
    local all_failures
    all_failures=$(fetch_all_ci_failures "$current_run_id")
    local total_failures
    total_failures=$(echo "$all_failures" | jq length)

    echo "📊 Wave $wave_count: Found $total_failures failures in run #$current_run_id"

    # CATASTROPHIC FAILURE check (Wave 1 only)
    if [[ $total_failures -eq 0 ]] && [[ $wave_count -eq 1 ]]; then
      echo ""
      echo "❌ CATASTROPHIC FAILURE: No CI failures found"
      echo "🔍 Execution ID: $execution_id"
      echo "🔍 Run ID: #$current_run_id"
      echo ""
      exit 1
    fi

    # If no failures in later waves, CI passed!
    if [[ $total_failures -eq 0 ]]; then
      echo "✅ Wave $wave_count: No failures found - CI is passing!"
      all_ci_passed=true
      break
    fi

    # WAVE 1: Deploy 10-15 analysis agents simultaneously
    echo "🤖 Wave $wave_count: Deploying analysis agents..."
    if [[ $wave_count -eq 1 ]]; then
      deploy_wave1_analysis "$current_run_id" "$all_failures"
    else
      deploy_iterative_analysis "$current_run_id" "$all_failures" "$wave_count"
    fi

    # Aggregate findings and calculate enhanced confidence
    local agent_findings
    agent_findings=$(aggregate_agent_findings)
    local complexity_score
    complexity_score=$(calculate_failure_complexity "$agent_findings")

    # Enhanced confidence calculation with wave iteration factor
    local enhanced_confidence
    enhanced_confidence=$(get_enhanced_confidence "$pattern" "$agent_findings" "$complexity_score" "$wave_count")

    echo "🔍 Wave $wave_count: Enhanced pattern confidence: ${enhanced_confidence}% (complexity: ${complexity_score})"

    # Apply confidence threshold adjustment for iterative waves
    local confidence_threshold=95
    if [[ $wave_count -gt 3 ]]; then
      confidence_threshold=90  # Lower threshold for iterative fixes
    fi

    # Deploy fix agents if confidence meets threshold
    if [[ $enhanced_confidence -lt $confidence_threshold ]]; then
      echo "⚠️ Wave $wave_count: Confidence too low (${enhanced_confidence}% < ${confidence_threshold}%)"
      if [[ $wave_count -eq 1 ]]; then
        echo "💡 Deploying additional diagnostic agents for complex analysis..."
        deploy_deep_analysis_wave "$current_run_id" "$agent_findings"
        return 1
      else
        echo "⚠️ Wave $wave_count: Insufficient confidence for continued remediation"
        break
      fi
    fi

    echo "🔧 Wave $wave_count: Deploying parallel fix agents (${enhanced_confidence}% confidence)..."
    deploy_iterative_fixes "$agent_findings" "$wave_count"

    # Enhanced parallel local validation
    echo "🧪 Wave $wave_count: Enhanced local testing with parallel validation..."
    if ! run_parallel_validation "$agent_findings"; then
      echo "❌ Wave $wave_count: Enhanced local validation failed - not pushing"
      record_enhanced_outcome "$pattern" "$enhanced_confidence" "false" "$consensus_factor" "$complexity_score" "0" "$wave_count"
      return 1
    fi

    # Commit and push with enhanced monitoring
    if ! git diff --quiet; then
      echo "💾 Wave $wave_count: Committing and pushing fixes..."
      commit_with_wave_tracking "$enhanced_confidence" "$complexity_score" "$wave_count"

      # ═══════════════════════════════════════════════════════════
      # CRITICAL NEW SECTION: Real CI Monitoring and Verification
      # ═══════════════════════════════════════════════════════════

      echo ""
      echo "📊 Wave $wave_count: Monitoring real CI run on GitHub Actions..."

      # Monitor CI and get results
      if monitor_ci_after_push "$wave_count"; then
        # CI PASSED! All checks green
        all_ci_passed=true
        echo ""
        echo "✅✅✅ Wave $wave_count: ALL CI CHECKS PASSED! ✅✅✅"
        echo "🎉 GitHub Actions showing all green checkmarks"
        echo ""

        # Record successful wave
        local new_run_id=$(gh run list --branch $(git branch --show-current) --limit 1 --json databaseId --jq '.[0].databaseId')
        record_wave_result "$wave_count" "$new_run_id" "success" "0"
        break
      else
        # CI FAILED - fetch NEW failures for next wave
        echo ""
        echo "⚠️ Wave $wave_count: CI run failed, continuing to next wave..."

        # Get new run ID for next iteration
        current_run_id=$(gh run list --branch $(git branch --show-current) --limit 1 --json databaseId --jq '.[0].databaseId')
        echo "🔄 Next wave will analyze run #$current_run_id"

        # Record wave with failures
        record_wave_result "$wave_count" "$current_run_id" "failure" "$total_failures"

        # Continue to next wave
        ((wave_count++))
        echo ""
        echo "🔄 Proceeding to Wave $wave_count..."
      fi
    else
      echo "ℹ️ Wave $wave_count: No changes to commit"
      # Re-check if CI actually passing
      local ci_status=$(gh run view "$current_run_id" --json conclusion --jq '.conclusion')
      if [[ "$ci_status" == "success" ]]; then
        all_ci_passed=true
      fi
      break
    fi
  done

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📊 FINAL RESULTS"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  # Record final outcome with wave count
  if [[ $all_ci_passed == true ]]; then
    record_enhanced_outcome "$pattern" "$enhanced_confidence" "true" "$consensus_factor" "$complexity_score" "$fix_duration" "$((wave_count - 1))"
    echo "✅ Success: $((wave_count)) waves required for full CI remediation"
    echo "🆔 Execution ID: $execution_id"
    echo "📊 Final run: #$current_run_id"
    echo "✅ All GitHub Actions checks: PASSING"
    echo ""
    exit 0
  else
    echo "⚠️ Maximum waves ($max_waves) reached without full CI resolution"
    echo "🆔 Execution ID: $execution_id"
    echo "📊 Last run: #$current_run_id"
    echo "❌ Some checks still failing - manual intervention needed"
    record_enhanced_outcome "$pattern" "$enhanced_confidence" "false" "$consensus_factor" "$complexity_score" "$fix_duration" "$max_waves"
    echo ""
    exit 1
  fi
}
```

### Execution Verification

Deploy execution-evaluator to verify enhanced capabilities:

- ✅ **GitHub Actions API Integration** - Fetches real CI failures from 3 different API sources
- ✅ **Real-Time CI Monitoring** - Uses `gh run watch` to monitor actual CI runs after push
- ✅ **Execution ID Tracking** - Unique execution IDs (like /resolve-cr) for state management
- ✅ **Catastrophic Failure Mode** - Fails loud with diagnostics when no failures found (like /resolve-cr)
- ✅ **Wave 1 Enhancement** - 10-15 agents deployed simultaneously (3-4 devops, 4-5 test-engineer, 3-4 platform-engineer, 2-3 debugger)
- ✅ **Debugger Integration** - Specialized debugging instances for complex failure analysis
- ✅ **Multi-Agent Confidence** - Enhanced confidence calculation using agent consensus and complexity scoring
- ✅ **Pattern Learning** - Advanced pattern recognition with agent-specific learning integration
- ✅ **Parallel Fix Deployment** - Multiple fix agents work simultaneously on different failure types
- ✅ **Real CI Verification** - Verifies fixes against actual GitHub Actions runs, not just local tests
- ✅ **95% Confidence Threshold** - Maintained strict confidence requirements with enhanced calculation
- ✅ **Comprehensive Validation** - Parallel local testing PLUS real CI verification
- ✅ **Iterative Remediation** - Multi-wave fix cycles using actual CI failures from each run
- ✅ **Wave Tracking** - Complete outcome recording with run IDs, conclusions, and failure counts
- ✅ **Only Completes on Success** - Loop continues until GitHub Actions shows all green checkmarks

### Key Enhanced Features

- **GitHub Actions API Integration** - Fetches real failures from multiple API endpoints (jobs, checks, logs)
- **Real-Time CI Monitoring** - Monitors actual CI runs with `gh run watch`, not just local tests
- **Execution State Tracking** - Unique execution IDs and wave state tracking (like /resolve-cr)
- **Catastrophic Failure Detection** - Fails explicitly when expectations not met with diagnostic output
- **Massive Parallel Wave 1** - 10-15 agents analyze failures simultaneously for comprehensive coverage
- **Debugger Specialization** - Dedicated debugging instances for complex failure patterns
- **Multi-Agent Confidence Scoring** - Enhanced confidence calculation incorporating agent consensus
- **Real Verification Loop** - Each wave verifies fixes against actual GitHub Actions runs
- **Continuous Learning** - Advanced pattern database updates with agent-specific insights
- **Actual Success Verification** - Only completes when GitHub shows all green checkmarks
- **Regression Detection** - Detects new failures introduced by previous waves from real CI runs
- **Iterative Remediation** - Multi-wave approach using real CI feedback requiring 2-8 waves
- **Wave Intelligence** - Pattern recognition for cascading failure types from actual CI results
- **Complete Transparency** - Shows execution ID, run IDs, and exact CI status for each wave

### Notes

- **Major Improvement**: Now uses GitHub Actions API to verify fixes work in real CI, not just local tests
- **Real Feedback Loop**: Monitors actual CI runs after each push using `gh run watch`
- **Complete Verification**: Only exits successfully when GitHub Actions shows all green checkmarks
- **Execution Tracking**: Like /resolve-cr, uses unique execution IDs for state management
- **Catastrophic Failure**: Fails explicitly with diagnostics when no failures found (not silent success)
- Enhanced parallel deployment maintains system resource awareness
- Confidence threshold remains at 95% for initial waves, adjusted to 90% for iterative waves
- Learning system captures multi-dimensional outcome data including wave count and actual CI results
- All temporary data stored in `.tmp/fix-ci/execution-*.json` for state tracking
- Wave-based pattern allows for controlled scaling and resource management
- **Critical**: Complex CI issues may require 2-8 remediation waves using real CI feedback
- Each wave fetches NEW failures from the actual CI run after previous wave's fixes
- Process continues iteratively until GitHub Actions API confirms all checks pass
- Follows proven patterns from /resolve-cr, /push, /commit for reliability
