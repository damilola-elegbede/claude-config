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

Diagnose and fix GitHub Actions failures using pattern recognition and historical fix data. Only pushes when 95%
confident all CI issues are resolved. Tests locally before pushing fixes.

**Important**: Complex CI issues often cascade, requiring multiple remediation waves. The process continues iteratively
until all CI checks pass, with each wave addressing newly discovered failures.

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

### Multi-Wave Remediation Example

```text
🔍 Wave 1: Pattern confidence: 96%
🔧 Wave 1: Applying lint fixes (96% confidence)...
📊 Wave 1: CI verification reveals additional test failures
🔧 Wave 2: Deploying test fix agents...
📊 Wave 2: CI verification reveals dependency conflicts
🔧 Wave 3: Resolving dependency version conflicts...
📊 Wave 3: CI verification reveals environment issues
🔧 Wave 4: Fixing environment configuration...
✅ Wave 4: All CI checks now passing
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

### Enhanced Main Execution Flow

#### Multi-Wave Orchestration Process

```bash
fix_ci_enhanced() {
  init_enhanced_history
  validate_prerequisites || return 1

  local run_id="${1:-$(gh run list --status=failure --limit=1 --jq '.[0].databaseId')}"
  [[ -z "$run_id" || "$run_id" == "null" ]] && { echo "ℹ️ No failed runs found."; return 1; }

  local wave_count=1
  local max_waves=8
  local all_ci_passed=false

  # Continue iterative remediation until CI passes or max waves reached
  while [[ $all_ci_passed == false && $wave_count -le $max_waves ]]; do
    echo "🚀 Wave $wave_count: Deploying analysis agents..."

    # WAVE 1: Deploy 10-15 analysis agents simultaneously
    if [[ $wave_count -eq 1 ]]; then
      deploy_wave1_analysis "$run_id"
    else
      deploy_iterative_analysis "$run_id" "$wave_count"
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
        deploy_deep_analysis_wave "$run_id" "$agent_findings"
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
      commit_with_wave_tracking "$enhanced_confidence" "$complexity_score" "$wave_count"

      # Deploy monitoring and verification agents
      echo "📊 Wave $wave_count: Deploying verification and monitoring agents..."
      deploy_wave_monitoring "$run_id" "$wave_count"

      # Wait for CI verification results
      local verification_results
      verification_results=$(wait_for_wave_verification_results "$wave_count")

      if [[ "$verification_results" == "all_passed" ]]; then
        all_ci_passed=true
        echo "✅ Wave $wave_count: All CI checks passed - remediation complete!"
      else
        echo "📊 Wave $wave_count: CI verification reveals additional issues - continuing to Wave $((wave_count + 1))"
        # Update pattern recognition with cascading failure data
        update_cascading_failure_patterns "$verification_results" "$wave_count"
      fi
    else
      echo "ℹ️ Wave $wave_count: No changes to commit"
      all_ci_passed=true
    fi

    ((wave_count++))
  done

  # Record final outcome with wave count
  if [[ $all_ci_passed == true ]]; then
    record_enhanced_outcome "$pattern" "$enhanced_confidence" "true" "$consensus_factor" "$complexity_score" "$fix_duration" "$((wave_count - 1))"
    echo "📊 Enhanced outcome recorded: $((wave_count - 1)) waves required for full CI remediation"
  else
    echo "⚠️ Maximum waves ($max_waves) reached without full CI resolution"
    record_enhanced_outcome "$pattern" "$enhanced_confidence" "false" "$consensus_factor" "$complexity_score" "$fix_duration" "$max_waves"
  fi
}
```

### Execution Verification

Deploy execution-evaluator to verify enhanced capabilities:

- ✅ **Wave 1 Enhancement** - 10-15 agents deployed simultaneously (3-4 devops, 4-5 test-engineer, 3-4 platform-engineer, 2-3 debugger)
- ✅ **Debugger Integration** - Specialized debugging instances for complex failure analysis
- ✅ **Multi-Agent Confidence** - Enhanced confidence calculation using agent consensus and complexity scoring
- ✅ **Pattern Learning** - Advanced pattern recognition with agent-specific learning integration
- ✅ **Parallel Fix Deployment** - Multiple fix agents work simultaneously on different failure types
- ✅ **Enhanced Monitoring** - Wave 3 verification with continuous monitoring and regression detection
- ✅ **95% Confidence Threshold** - Maintained strict confidence requirements with enhanced calculation
- ✅ **Comprehensive Validation** - Parallel local testing with multiple validation streams
- ✅ **Iterative Remediation** - Multi-wave fix cycles for cascading CI failures (Wave 4, 5, 6+)
- ✅ **Wave Tracking** - Complete outcome recording with wave count and cascading failure patterns

### Key Enhanced Features

- **Massive Parallel Wave 1** - 10-15 agents analyze failures simultaneously for comprehensive coverage
- **Debugger Specialization** - Dedicated debugging instances for complex failure patterns
- **Multi-Agent Confidence Scoring** - Enhanced confidence calculation incorporating agent consensus
- **Complex Issue Handling** - Specialized workflows for multi-factor and intricate CI failures
- **Continuous Learning** - Advanced pattern database updates with agent-specific insights
- **Performance Monitoring** - Real-time tracking of fix effectiveness and performance impact
- **Regression Prevention** - Automated detection of new issues introduced by fixes
- **Iterative Remediation** - Multi-wave approach handling cascading CI failures requiring 4-8 waves
- **Wave Intelligence** - Pattern recognition for cascading failure types and remediation sequences
- **Escalation Management** - Confidence threshold adjustments and termination conditions for complex cases

### Notes

- Enhanced parallel deployment maintains system resource awareness
- Confidence threshold remains at 95% for initial waves, adjusted to 90% for iterative waves
- Learning system captures multi-dimensional outcome data including wave count for better future predictions
- All temporary data stored in `.tmp/fix-ci/enhanced-*` for improved organization
- Wave-based pattern allows for controlled scaling and resource management
- **Critical**: Complex CI issues may require 4-8 remediation waves to fully resolve all cascading failures
- Each wave addresses new failures discovered by CI verification of previous wave's fixes
- Process continues iteratively until all CI checks pass or maximum wave limit reached
