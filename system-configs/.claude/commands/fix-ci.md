---
description: Diagnoses and fixes GitHub Actions CI failures automatically
argument-hint: [run-id|--learn]
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

### Agent Orchestration - Multi-Instance Parallel Deployment

#### Parallel Fix Strategy

```yaml
# PARALLEL WAVE 1: Simultaneous Failure Analysis
devops (instance pool):
  deployment: 2-3 instances based on number of failed jobs
  distribution:
    - instance_1: Pipeline/workflow configuration issues
    - instance_2: Infrastructure and environment problems
    - instance_3: Deployment and integration failures
  parallel_with: [test-engineer instances, platform-engineer instances]
  output: Pipeline fixes, configuration corrections

test-engineer (instance pool):
  deployment: 3-4 instances for different test types
  distribution:
    - instance_1: Unit test failures
    - instance_2: Integration test failures
    - instance_3: E2E test failures
    - instance_4: Flaky test identification
  parallel_with: [devops instances, platform-engineer instances]
  output: Test fixes, stability improvements

platform-engineer (instance pool):
  deployment: 2-3 instances for different aspects
  distribution:
    - instance_1: Dependency resolution issues
    - instance_2: Build environment problems
    - instance_3: Resource constraints and timeouts
  parallel_with: [devops instances, test-engineer instances]
  output: Environment fixes, dependency resolutions

code-reviewer:
  role: Analyze code changes that triggered CI failures
  parallel_with: [all other agents]
  output: Code quality issues, syntax problems

security-auditor:
  role: Check for security-related CI failures
  parallel_with: [all other agents]
  output: Security violations, compliance issues
```

#### CI Job Parallelization Strategy

```yaml
Phase 1 - Parallel Diagnosis (10-15 seconds):
  - All failed CI jobs analyzed simultaneously
  - Deploy N agents where N = number of failure types
  - Each agent instance handles specific failure domain
  - Cross-reference findings for related issues

Phase 2 - Parallel Fix Implementation:
  Lint/Format Failures:
    - Multiple code-reviewer instances fix different files
    - Parallel execution: npm run lint:fix on file groups

  Test Failures:
    - test-engineer instance 1: Fix unit tests
    - test-engineer instance 2: Fix integration tests
    - test-engineer instance 3: Fix E2E tests
    - All work simultaneously

  Build Failures:
    - platform-engineer instance 1: Fix dependencies
    - platform-engineer instance 2: Fix environment config
    - devops: Fix pipeline configuration
    - Parallel resolution of independent issues

Phase 3 - Parallel Validation:
  - Run all CI checks locally in parallel
  - Different test suites on different threads
  - Aggregate results for confidence scoring
  - Only push when ALL parallel checks pass

Performance Metrics:
  - Sequential analysis: 3-5 minutes
  - Parallel analysis: 30-60 seconds (5x faster)
  - Fix confidence: Higher with parallel validation
  - Success rate: 95%+ with comprehensive parallel checking
```

### Fix Pattern Recognition

#### Pattern Matching with Confidence Scoring

```yaml
Lint/Format: {confidence: 98%, test: "npm run lint", fix: "npm run lint:fix"}
Dependencies: {confidence: 92%, test: "npm test", fix: "npm install"}
Test Failures: {confidence: 85%, test: "npm test", fix: "update tests"}
Type Errors: {confidence: 78%, test: "npm run typecheck", fix: "fix types"}
Build Issues: {confidence: 70%, test: "npm run build", fix: "rebuild"}
```

#### Safe Command Validation

```bash
# Whitelist of safe commands
SAFE_COMMANDS=(
  "npm run lint:fix"
  "npm run lint"
  "npx eslint . --fix"
  "npm install"
  "npm test"
  "npm run typecheck"
  "npm run build"
)

validate_fix_command() {
  local cmd="$1"
  for safe_cmd in "${SAFE_COMMANDS[@]}"; do
    [[ "$cmd" == "$safe_cmd" ]] && return 0
  done
  echo "❌ Unsafe command: $cmd"
  return 1
}
```

#### Pattern Application Logic

```bash
apply_fix() {
  local error_log="$1"
  local confidence=0
  local fix_cmd=""
  local test_cmd=""
  local pattern=""

  if grep -q "ESLint\|Prettier\|lint" "$error_log"; then
    pattern="Lint/Format"; confidence=98
    fix_cmd="npm run lint:fix"
    test_cmd="npm run lint"
  elif grep -q "Module not found\|Cannot resolve" "$error_log"; then
    pattern="Dependencies"; confidence=92; fix_cmd="npm install"; test_cmd="npm test"
  elif grep -q "Test.*failed\|expect.*received" "$error_log"; then
    pattern="Test Failures"; confidence=85; fix_cmd="MANUAL"; test_cmd="npm test"
  elif grep -q "Type.*error\|TS[0-9]" "$error_log"; then
    pattern="Type Errors"; confidence=78; fix_cmd="MANUAL"; test_cmd="npm run typecheck"
  else
    return 1
  fi

  # If manual fix is required, return sentinel without validation
  if [[ "$fix_cmd" == "MANUAL" ]]; then
    echo "$pattern,$confidence,$fix_cmd,$test_cmd"
    return 0
  fi

  # Validate fix command is safe
  if ! validate_fix_command "$fix_cmd"; then
    return 1
  fi

  echo "$pattern,$confidence,$fix_cmd,$test_cmd"
}
```

### Historical Learning System

#### History Tracking

```bash
# Initialize history directory
init_history() {
  mkdir -p .tmp/fix-ci
}

# Record fix outcomes with 100% CI success requirement
record_outcome() {
  local pattern="$1"
  local confidence="$2"
  local all_ci_passed="$3"  # true only if 100% CI issues resolved

  echo "$(date),$pattern,$confidence,$all_ci_passed" >> .tmp/fix-ci/history.log
}

# Calculate confidence from historical success
get_confidence() {
  local pattern="$1"
  if [[ ! -f .tmp/fix-ci/history.log ]]; then
    echo "50"
    return 0
  fi
  awk -F',' -v p="$pattern" '
    $2 == p { total++; if($4=="true") success++ }
    END { if(total==0) print 50; else print int(success/total*100) }
  ' .tmp/fix-ci/history.log
}
```

### Main Execution Flow

#### Complete Fix Process

```bash
fix_ci() {
  init_history
  command -v gh >/dev/null 2>&1 || { echo "❌ GitHub CLI (gh) not found"; return 1; }
  if ! gh auth status >/dev/null 2>&1; then
    echo "❌ gh is not authenticated. Run: gh auth login"
    return 1
  fi

  local run_id="${1:-$(gh run list --status=failure --limit=1 --jq '.[0].databaseId')}"
  if [[ -z "$run_id" || "$run_id" == "null" ]]; then
    echo "ℹ️ No failed GitHub Actions runs found."
    return 1
  fi

  local logs
  logs=$(gh run view "$run_id" --log-failed)

  # Get fix details
  local fix_data
  fix_data=$(apply_fix "$logs")
  [[ -z "$fix_data" ]] && { echo "❌ No fix pattern matched"; return 1; }

  IFS=',' read -r pattern confidence fix_cmd test_cmd <<< "$fix_data"
  local historical_confidence
  historical_confidence=$(get_confidence "$pattern")
  local final_confidence=$(( (confidence + historical_confidence) / 2 ))

  echo "🔍 Pattern confidence: ${final_confidence}%"

  if [[ "$fix_cmd" == "MANUAL" ]]; then
    echo "📝 Pattern matched but requires manual remediation. Recommended test: $test_cmd"
    return 1
  fi

  # Only proceed if 95%+ confident
  if [[ $final_confidence -lt 95 ]]; then
    echo "⚠️ Confidence too low (${final_confidence}% < 95%)"
    echo "💡 Manual review recommended"
    return 1
  fi

  # Apply fix safely
  echo "🔧 Applying fix (${final_confidence}% confidence)..."
  if ! validate_fix_command "$fix_cmd"; then
    echo "❌ Fix command failed validation"
    return 1
  fi
  bash -c "$fix_cmd"

  # Test locally (account for CI environment differences)
  echo "🧪 Testing fix locally..."
  if ! validate_fix_command "$test_cmd"; then
    echo "❌ Test command failed validation"
    return 1
  fi
  if ! bash -c "$test_cmd"; then
    echo "❌ Local test failed - not pushing"
    record_outcome "$pattern" "$final_confidence" "false"
    return 1
  fi

  # Commit and push only if confident and tests pass
  if ! git diff --quiet; then
    git add .
    git commit -m "fix: resolve CI failure (${final_confidence}% confidence)

Automated fix applied by /fix-ci"
    git push

    # Record outcome after CI completes
    sleep 90
    local all_passed
    all_passed=$(gh run list --limit=1 --jq '.[0].conclusion == "success"')
    record_outcome "$pattern" "$final_confidence" "$all_passed"
    echo "📊 Recorded outcome: CI passed = $all_passed"
  fi
}
```

### Execution Verification

Deploy execution-evaluator to verify:

- ✅ **CI issues identified** - All CI failures correctly analyzed and categorized
- ✅ **Pattern confidence** - Confidence score calculated from historical success data
- ✅ **Local testing passed** - All fixes validated locally before pushing
- ✅ **Fixes applied** - Appropriate fixes implemented based on failure patterns
- ✅ **CI success achieved** - All CI checks pass after fix implementation
- ✅ **Historical learning** - Outcomes recorded for future confidence scoring
- ✅ **Threshold compliance** - Only proceeded when confidence >= 95%

### Key Features

- **95% confidence threshold** - Only pushes when highly confident
- **Local testing first** - Validates fixes before pushing
- **100% CI success requirement** - Success only when all CI issues resolved
- **Historical learning** - Improves confidence scoring from .tmp/fix-ci/ data
- **Safe execution** - Tests locally accounting for CI environment differences
- **Parallel agent deployment** - Multiple specialized agents work simultaneously

### Notes

- History stored in `.tmp/fix-ci/` not home directory
- Success only counted when 100% of CI issues are resolved
- Local testing accounts for CI environment differences
- Won't push unless 95%+ confident in fix success
- Deploys multiple agent instances for comprehensive parallel analysis
