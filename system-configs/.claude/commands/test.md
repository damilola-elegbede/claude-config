---
description: Universal test runner with auto-discovery and execution
argument-hint: [--create|--framework <name>|--coverage]
---

# /test Command

## Usage

```bash
/test                           # Auto-discover and run tests
/test --create                  # Generate test suite if missing
/test --framework <name>        # Use specific framework (jest, pytest, etc.)
/test --coverage                # Run with coverage reporting
```

## Description

Universal test runner that discovers and runs tests automatically for any repository, and creates a base level test
suite when none exist. Uses a 3-phase discovery algorithm: README analysis, package manager detection, and framework
conventions. Creates comprehensive test suites when none exist.

## Expected Output

### Wave-Based Execution with Auto-Remediation Example

```text
🌊 WAVE 1: Initial Test Execution (20-30s)
🔍 Discovering tests... Found 3 test suites
🚀 Deploying 3 test-engineer instances + 2 specialized agents in parallel

✅ Unit Tests (Instance 1): 45/45 passed (8.2s)
✅ Integration Tests (Instance 2): 12/12 passed (15.1s)
❌ E2E Tests (Instance 3): 2/8 failed (22.3s)
✅ Performance Tests: All benchmarks within thresholds (18.7s)
✅ Security Tests: No vulnerabilities detected (14.2s)

🧠 CLAUDE ANALYSIS: Categorizing 2 E2E failures (3s)
  - UI selector failures (auto-fixable)
  - Timing synchronization issues (auto-fixable)

🌊 WAVE 2: Auto-Remediation Deployment (15-25s)
🔧 Deploying 1 e2e_fix_instance for targeted remediation

✅ Fixed: Updated CSS selectors for DOM changes
✅ Fixed: Added explicit waits for async operations
📝 Changes: 2 test files modified, 0 regressions detected

🌊 WAVE 3: Final Validation (10-15s)
🔍 Re-running E2E tests with fixes...

✅ E2E Tests (Validation): 8/8 passed (12.1s)
✅ Regression Check: No new failures introduced
✅ Coverage maintained: 87.3% lines, 82.1% branches

📊 FINAL REPORT:
  Total Execution Time: 62 seconds
  Original Failures: 2
  Auto-Fixed: 2 (100% success rate)
  Manual Review Required: 0
  Final Status: ALL TESTS PASSING ✅
```

### Complex Project with Multiple Failures Example

```text
🌊 WAVE 1: Initial Test Execution (25-35s)
🔍 Discovering tests... Found 5 test suites
🚀 Deploying 5 test-engineer instances + 2 specialized agents in parallel

✅ Unit Tests (Instance 1): 156/156 passed (12.3s)
❌ Integration Tests (Instance 2): 8/15 failed (28.1s)
❌ E2E Tests (Instance 3): 3/12 failed (32.4s)
❌ Performance Tests: 2 benchmarks failed (25.7s)
✅ Security Tests: No vulnerabilities detected (18.9s)

🧠 CLAUDE ANALYSIS: Categorizing 13 failures (8s)
  - Database connection issues (auto-fixable)
  - API endpoint changes (auto-fixable)
  - UI timing issues (auto-fixable)
  - Performance threshold violations (requires investigation)

🌊 WAVE 2: Auto-Remediation Deployment (20-30s)
🔧 Deploying 3 fix instances + 1 performance specialist

✅ Integration Fix: Updated database connection strings
✅ Integration Fix: Corrected API endpoint URLs
✅ E2E Fix: Added explicit waits and updated selectors
🔍 Performance Analysis: Identified memory leak in test setup

🌊 WAVE 3: Final Validation (15-20s)
🔍 Re-running affected test suites...

✅ Integration Tests: 15/15 passed (18.2s)
✅ E2E Tests: 12/12 passed (16.7s)
⚠️  Performance Tests: 1 test still failing (requires manual review)

📊 FINAL REPORT:
  Total Execution Time: 89 seconds
  Original Failures: 13
  Auto-Fixed: 11 (85% success rate)
  Manual Review Required: 2 performance optimizations
  Auto-Fix Categories: DB config, API endpoints, UI timing
  Status: 91% tests passing, performance review needed
```

### Python Project (No Tests) with Generation Example

```text
🔍 Discovering tests... No test suites found
🚀 Deploying test-engineer to generate comprehensive test suite

📝 Generated test structure:
  ├── tests/test_main.py (unit tests)
  ├── tests/test_utils.py (utility functions)
  ├── tests/test_integration.py (API tests)
  └── pytest.ini (configuration)

🌊 WAVE 1: Initial Test Execution (15-20s)
🧪 Running generated tests: pytest -v

✅ All generated tests passed (18/18)
📊 Initial coverage: 76.4% lines, 68.2% branches
💡 Recommendations: Add E2E tests for user workflows
```

## Behavior

When invoked, I execute a sophisticated wave-based orchestration pattern for comprehensive test execution and
auto-remediation. This approach maximizes parallel execution while enabling intelligent failure resolution through
automated self-healing test suites.

### Wave-Based Test Orchestration with Auto-Remediation

#### Wave 1: Initial Test Execution (20-30 seconds)

Deploy 3-5 test-engineer instances for comprehensive parallel test execution:

```yaml
# WAVE 1: Parallel Test Suite Execution
test-engineer (instance pool):
  deployment: 3-5 instances based on test suite types
  calculation: min(5, discovered_test_suites)
  distribution:
    - instance_1: Unit tests (fastest execution, high volume)
    - instance_2: Integration tests (API endpoints, database operations)
    - instance_3: E2E tests (browser automation, user workflows)
    - instance_4: Performance tests (load testing, benchmarks)
    - instance_5: Security tests (vulnerability scanning, auth flows)
  parallel_execution: All test types run simultaneously
  role: Execute different test suites independently
  output: Parallel test results with failure categorization
  timeout: 30 seconds per instance

performance-engineer (specialized instance):
  deployment: Dedicated instance for performance validation
  parallel_with: [test-engineer instances]
  role: Execute performance benchmarks independently
  output: Performance metrics and threshold violations

security-auditor (specialized instance):
  deployment: Dedicated instance for security validation
  parallel_with: [test-engineer instances]
  role: Run security test suites and vulnerability scans
  output: Security findings and compliance violations

# Wave 1 Success Criteria:
#   - All test suites execute without critical failures
#   - Performance benchmarks meet thresholds
#   - Security scans pass vulnerability checks
#   - Test coverage meets minimum requirements
```

#### Claude Analysis Phase: Intelligent Failure Categorization (5-10 seconds)

Between Wave 1 and Wave 2, Claude analyzes all failures and categorizes them for targeted remediation:

```yaml
Failure Pattern Recognition:
  unit_test_failures:
    - Logic errors in functions
    - Assertion mismatches
    - Mock configuration issues

  integration_test_failures:
    - Database connection issues
    - API endpoint failures
    - Service communication errors

  e2e_test_failures:
    - UI element selection failures
    - Timing/synchronization issues
    - Browser compatibility problems

  performance_test_failures:
    - Response time threshold violations
    - Memory leak detection
    - Resource utilization spikes

  security_test_failures:
    - Authentication bypass attempts
    - Input validation vulnerabilities
    - Authorization control weaknesses

Auto-Remediation Eligibility Assessment:
  - Simple assertion fixes: AUTO-FIX
  - Mock/stub configuration: AUTO-FIX
  - Test data issues: AUTO-FIX
  - Environment setup: AUTO-FIX
  - Complex logic errors: MANUAL REVIEW
  - Architecture changes needed: MANUAL REVIEW
```

#### Wave 2: Auto-Fix Deployment (15-25 seconds)

Based on Claude's analysis, deploy targeted remediation agents in parallel:

```yaml
# WAVE 2: Parallel Auto-Remediation Based on Failure Types
test-engineer (failure-specific instances):
  deployment: 1 instance per failure category
  distribution:
    - unit_fix_instance: Fix unit test assertion errors
    - integration_fix_instance: Resolve API/database issues
    - e2e_fix_instance: Fix UI selectors and timing
    - mock_fix_instance: Repair mock configurations
  role: Apply automated fixes to categorized test failures
  output: Fixed test files with change documentation

debugger (complex failure instance):
  deployment: Dedicated instance for complex failures
  role: Investigate failures requiring logic analysis
  input: Complex failures from Claude categorization
  output: Detailed failure analysis and fix recommendations

performance-engineer (performance fix instance):
  deployment: Conditional on performance test failures
  role: Fix performance threshold violations
  output: Optimized code or adjusted performance expectations

security-auditor (security fix instance):
  deployment: Conditional on security test failures
  role: Fix security vulnerabilities in test scenarios
  output: Hardened test security configurations

# Auto-Fix Patterns Applied:
#   - Update outdated assertions
#   - Fix mock return values
#   - Repair test data setup
#   - Resolve environment variables
#   - Update UI selectors
#   - Fix async/await timing
```

#### Claude Verification: Non-Regression Validation (5 seconds)

Claude analyzes fixes to ensure they don't break other tests:

```yaml
Fix Impact Analysis:
  changed_files: List of files modified by auto-fix agents
  potential_conflicts: Cross-test dependencies analysis
  regression_risk: Assessment of fix side effects

Verification Strategy:
  - Check fixes don't modify shared utilities incorrectly
  - Ensure mock changes don't affect other tests
  - Validate test data changes maintain referential integrity
  - Confirm environment changes are test-scoped
```

#### Wave 3: Final Validation & Reporting (10-15 seconds)

Re-run affected test suites and generate comprehensive reports:

```yaml
# WAVE 3: Targeted Re-execution and Validation
test-engineer (validation instances):
  deployment: 1 instance per previously failed test suite
  scope: Only re-run tests that were fixed
  role: Validate fixes resolve original failures
  output: Final test status for each fixed suite

codebase-analyst (regression instance):
  deployment: Single instance for regression detection
  scope: Run broader test suite to detect regressions
  role: Ensure fixes don't break existing functionality
  output: Regression analysis report

# Final Report Generation:
comprehensive_test_report:
  original_failures: Count and types of initial failures
  auto_fixed: Successfully resolved issues
  manual_review: Issues requiring developer attention
  regression_status: No new failures introduced
  coverage_impact: Test coverage before/after fixes
  execution_time: Total time from start to completion

Success Metrics:
  - Auto-fix rate: >80% of simple failures resolved
  - Zero regressions introduced
  - All critical test suites passing
  - Performance within acceptable thresholds
```

#### Auto-Remediation Patterns & Intelligence

```yaml
Intelligent Auto-Fix Categories:
  simple_fixes:
    - Outdated assertion values (expected vs actual mismatches)
    - Mock return value corrections
    - Test data setup and teardown issues
    - Environment variable configuration
    - Import/dependency resolution
    - Async/await timing adjustments
    success_rate: 85-95%

  moderate_fixes:
    - UI selector updates (DOM changes)
    - API endpoint URL corrections
    - Database schema alignment
    - Configuration file updates
    - Test runner option adjustments
    success_rate: 70-85%

  complex_issues:
    - Business logic errors
    - Architecture mismatches
    - Performance optimization needs
    - Security vulnerability fixes
    - Cross-cutting concerns
    requires: Manual review and developer intervention

Wave-Based Execution Timeline:
  total_execution_time: 60-90 seconds (vs 3-5 minutes sequential)
  wave_1_parallel: 20-30 seconds (initial test execution)
  claude_analysis: 5-10 seconds (failure categorization)
  wave_2_auto_fix: 15-25 seconds (parallel remediation)
  claude_verification: 5 seconds (regression analysis)
  wave_3_validation: 10-15 seconds (final verification)

Performance Benefits:
  - 3-4x faster than sequential testing
  - Auto-remediation reduces manual intervention by 80%
  - Continuous improvement through failure pattern learning
  - Zero-downtime test suite maintenance
```

### Discovery Algorithm

#### Phase 1: Parallel Discovery & Analysis

I scan README.md for test commands using these patterns:

```bash
# Searches for these section headers (case-insensitive):
grep -i "test\|testing\|run.*test" README.md

# Extracts commands from code blocks after test sections:
- npm test
- npm run test:unit
- yarn test
- pytest
- go test ./...
- cargo test
```

#### Phase 2: Package Manager Detection

Language-specific package manager inspection:

```yaml
Node.js:
  files: [package.json]
  scripts: [test, test:unit, test:integration, test:e2e]
  command: npm run {script}

Python:
  files: [pyproject.toml, setup.py, pytest.ini, tox.ini]
  command: pytest || python -m pytest || tox

Go:
  files: [go.mod, go.sum]
  command: go test ./...

Rust:
  files: [Cargo.toml]
  command: cargo test

Ruby:
  files: [Gemfile, .rspec]
  command: bundle exec rspec || rake test

Java:
  files: [pom.xml, build.gradle, build.gradle.kts]
  command: mvn test || gradle test || ./gradlew test

.NET:
  files: [*.csproj, *.sln]
  command: dotnet test
```

#### Phase 3: Framework Convention Detection

File pattern analysis for common test structures:

```bash
# Test file patterns (case-insensitive):
find . -name "*test*" -o -name "*spec*" | head -10

# Common patterns:
- **/*.test.js     # Jest/Vitest
- **/*_test.py     # pytest
- **/*_test.go     # Go testing
- **/test_*.py     # pytest
- **/*.spec.js     # Jasmine/Mocha
- **/tests/**      # General test directory
```

### Test Generation (--create)

When no tests exist, **test-engineer** agent creates comprehensive test suites:

```javascript
// JavaScript: src/__tests__/example.test.js
describe('Utils Functions', () => {
  test('add function', () => {
    expect(add(2, 3)).toBe(5);
  });
});
```

```python
# Python: tests/test_utils.py
import pytest
class TestUtils:
    def test_add(self):
        assert add(2, 3) == 5
```

```go
// Go: utils_test.go
func TestAdd(t *testing.T) {
    if got := Add(2, 3); got != 5 {
        t.Errorf("Add(2, 3) = %d, want 5", got)
    }
}
```

Automatically adds test scripts to package.json/pyproject.toml and creates config files

### Test Execution Process

#### Pre-Execution Validation

1. **Dependency Check**: Ensure test framework is installed
2. **Environment Setup**: Set NODE_ENV=test, activate virtual environments
3. **Database Preparation**: Run migrations, seed test data if configured

#### Execution Strategy

```yaml
Discovery Result Processing:
  Single Command Found:
    - Execute immediately with appropriate environment
    - Display real-time output with syntax highlighting

  Multiple Commands Found:
    - Present interactive selection menu
    - Show estimated execution time for each
    - Allow parallel execution of compatible tests

  No Commands Found:
    - Trigger test generation workflow
    - Create basic test suite using test-engineer
    - Run generated tests to verify setup
```

### Framework-Specific Optimizations

```bash
# JavaScript (Jest/Vitest)
npm test                         # Standard
npm test -- --coverage           # With coverage
npm test -- --ci --watchAll=false  # CI mode

# Python (pytest)
pytest -v                        # Standard
pytest --cov=src                 # With coverage
pytest -n auto                   # Parallel execution

# Go
go test ./...                    # Standard
go test -cover -race ./...       # Coverage + race detection
```

### Error Handling & Recovery

#### Common Failure Scenarios

- **Missing Dependencies**: Auto-install with package manager
- **Database Issues**: Create test DB and run migrations
- **Config Errors**: Generate minimal working config
- **Permission Issues**: Fix with chmod or container

#### Graceful Degradation

If test discovery fails completely:

1. **Fallback to common patterns**: Try `npm test`, `pytest`, `go test`
2. **Manual guidance**: Provide setup commands for detected project type
3. **Test generation**: Offer to create basic test structure

### Integration with Specialized Agents

#### Wave-Based Agent Coordination

The test command orchestrates multiple waves of specialized agents for maximum efficiency and auto-remediation:

**Wave 1 - Initial Execution Agents**:

- **test-engineer instances**: 3-5 parallel instances by test type
- **performance-engineer**: Dedicated performance validation
- **security-auditor**: Independent security testing
- **Execution time**: 20-30 seconds parallel

**Wave 2 - Auto-Remediation Agents**:

- **test-engineer fix instances**: Targeted failure remediation
- **debugger**: Complex failure investigation
- **performance-engineer**: Performance issue resolution
- **security-auditor**: Security vulnerability fixes
- **Deployment strategy**: Conditional based on Wave 1 failures

**Wave 3 - Validation Agents**:

- **test-engineer validation**: Re-run fixed test suites
- **codebase-analyst**: Regression detection
- **execution-evaluator**: Final success verification

**Instance Allocation Strategy**:

```yaml
Auto-Scaling Based on Codebase Size:
  Small project (<100 tests):
    wave_1: 2 instances (unit + integration)
    wave_2: 1-2 fix instances (conditional)
    wave_3: 1 validation instance

  Medium project (100-500 tests):
    wave_1: 3 instances (unit + integration + e2e)
    wave_2: 2-3 fix instances (conditional)
    wave_3: 2 validation instances

  Large project (500+ tests):
    wave_1: 5 instances (all test types)
    wave_2: 3-5 fix instances (conditional)
    wave_3: 3 validation instances

  Enterprise project (1000+ tests):
    wave_1: 5 instances with load balancing
    wave_2: Up to 5 specialized fix instances
    wave_3: Comprehensive validation and reporting
```

#### execution-evaluator Final Verification

After all waves complete, validates:

- ✅ Initial test execution successful (Wave 1)
- ✅ Auto-remediation completed without regressions (Wave 2)
- ✅ Final validation confirms all fixes (Wave 3)
- ✅ Coverage thresholds maintained or improved
- ✅ Performance benchmarks within acceptable ranges
- ✅ Security tests pass vulnerability checks
- ✅ Test artifacts and reports generated correctly
- ✅ Auto-fix rate >80% for eligible issues
- ✅ Zero new test failures introduced by fixes
