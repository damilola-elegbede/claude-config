# /test Command

## Description

Universal test runner that discovers and runs tests automatically for any repository,
and creates a base level test suite when none exist. Uses a 3-phase discovery algorithm: README analysis,
package manager detection, and framework conventions. Creates comprehensive
test suites when none exist.

## Usage

```bash
/test                    # Auto-discover and run tests
/test --create           # Generate test suite if missing
/test --framework <name> # Use specific framework (jest, pytest, etc.)
/test --coverage         # Run with coverage reporting
```

## Agent Orchestration - Multi-Instance Test Runners

### Parallel Test Execution with Instance Pools

Deploy multiple test-engineer instances for simultaneous test suite execution:

```yaml
# PARALLEL WAVE 1: Multi-Instance Test Discovery (5-10 seconds)
codebase-analyst (instance pool):
  deployment: 2-3 instances for rapid discovery
  distribution:
    - instance_1: Frontend test discovery (components, UI tests)
    - instance_2: Backend test discovery (API, service tests)
    - instance_3: Infrastructure test discovery (config, deployment)
  parallel_with: [test-engineer instances]
  role: Analyze codebase structure for test discovery
  output: Test locations and frameworks identified simultaneously

# PARALLEL WAVE 2: Multi-Instance Test Execution (20-30 seconds)
test-engineer (instance pool):
  deployment: 3-5 instances based on test suite types
  calculation: min(5, number_of_test_suites)
  distribution:
    - instance_1: Unit tests (fastest, highest volume)
    - instance_2: Integration tests (API, database)
    - instance_3: E2E tests (browser, user flows)
    - instance_4: Performance tests (load, stress)
    - instance_5: Security tests (vulnerability scans)
  parallel_execution: All test types run simultaneously
  role: Execute different test suites in parallel
  output: Parallel test results from all suites

performance-engineer (specialized instance):
  deployment: Dedicated instance for performance testing
  parallel_with: [test-engineer instances]
  role: Run performance and load tests independently
  output: Performance metrics without blocking other tests

security-auditor (specialized instance):
  deployment: Dedicated instance for security testing
  parallel_with: [test-engineer instances]
  role: Execute security test suites independently
  output: Security scan results in parallel

debugger:
  role: Aggregate and investigate failures from all instances
  input: Collected failures from all test instances
  output: Consolidated failure analysis, fix recommendations

# Performance Impact:
#   Sequential: 2-3 minutes for all test suites
#   Parallel with instances: 30-40 seconds (4-5x faster)
#   Test isolation: Each instance runs independently
```

### Multi-Instance Execution Strategy

```yaml
Test Suite Parallelization with Instance Pools:
  instance_distribution:
    - Automatic detection of test suite types
    - Deploy one instance per test type (unit, integration, e2e, etc.)
    - Each instance handles its test suite independently
    - Maximum 5 concurrent test instances

  execution_optimization:
    - Unit tests: Instance 1 with --parallel flag
    - Integration tests: Instance 2 with database isolation
    - E2E tests: Instance 3 with browser parallelization
    - Performance tests: Instance 4 with dedicated resources
    - Security tests: Instance 5 with vulnerability scanners

  result_aggregation:
    - Real-time streaming from all instances
    - Unified test report generation
    - Failure collection and prioritization
    - Coverage metrics merged from all suites

Time Optimization:
  - Sequential execution: 2-3 minutes typical
  - Multi-instance parallel: 30-40 seconds (4-5x faster)
  - Resource utilization: Full CPU core usage
  - Test isolation: No interference between suites
```

## Behavior

When invoked, I automatically discover and run tests using multi-instance parallel
agent deployment. I deploy 3-5 test-engineer instances to execute different test
suites simultaneously (unit, integration, e2e, performance, security), achieving
4-5x faster execution than sequential testing. Each instance handles a specific
test type independently for maximum efficiency and isolation.

## Discovery Algorithm

### Phase 1: Parallel Discovery & Analysis

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

### Phase 2: Package Manager Detection

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

### Phase 3: Framework Convention Detection

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

## Test Generation (--create)

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

## Test Execution Process

### Pre-Execution Validation

1. **Dependency Check**: Ensure test framework is installed
2. **Environment Setup**: Set NODE_ENV=test, activate virtual environments
3. **Database Preparation**: Run migrations, seed test data if configured

### Execution Strategy

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

### Output Enhancement

```text
# Real-time test output with enhanced formatting:
🧪 Running Tests: npm test

✅ PASS src/utils.test.js (1.2s)
  ✓ add function (5ms)
  ✓ multiply function (3ms)

✅ PASS src/auth.test.js (2.1s)
  ✓ validates email format (12ms)
  ✓ hashes passwords correctly (45ms)

📊 Test Results:
  Suites: 2 passed, 2 total
  Tests:  4 passed, 4 total
  Time:   3.3s
  Coverage: 85.2% (lines), 78.9% (branches)
```

## Framework-Specific Optimizations

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

## Error Handling & Recovery

### Common Failure Scenarios

- **Missing Dependencies**: Auto-install with package manager
- **Database Issues**: Create test DB and run migrations
- **Config Errors**: Generate minimal working config
- **Permission Issues**: Fix with chmod or container

### Graceful Degradation

If test discovery fails completely:

1. **Fallback to common patterns**: Try `npm test`, `pytest`, `go test`
2. **Manual guidance**: Provide setup commands for detected project type
3. **Test generation**: Offer to create basic test structure

## Integration with Specialized Agents

### test-engineer Multi-Instance Deployment

Multiple test-engineer instances are deployed for:

- **Parallel test execution**: 3-5 instances run different test suites simultaneously
- **Test suite generation**: Multiple instances create tests for different components
- **Complex test strategy**: Instances specialize by test type (unit, integration, e2e)
- **Test optimization**: Each instance optimizes its specific test domain
- **Failure investigation**: Debugger aggregates failures from all instances

**Instance Allocation Strategy**:

```yaml
Small project (<100 tests): 2 instances (unit + integration)
Medium project (100-500 tests): 3 instances (unit + integration + e2e)
Large project (500+ tests): 5 instances (all test types)
```

### execution-evaluator Verification

After test execution, validates:

- ✅ Test command executed successfully
- ✅ All tests passed or failure reasons are clear
- ✅ Coverage thresholds met (if configured)
- ✅ Test artifacts generated correctly
- ✅ CI integration working properly

## Success Metrics

- ✅ >95% test command discovery rate
- ✅ <5 seconds discovery time
- ✅ 90% error recovery rate

## Examples

### Node.js Project with Jest

```text
User: /test
Claude: 🔍 Discovering tests...
✅ Found in package.json: "test": "jest"
🧪 Running: npm test

✅ All tests passed (4/4)
📊 Coverage: 87.3% lines, 82.1% branches
```

### Python Project (No Tests)

```text
User: /test
Claude: 🔍 Discovering tests...
⚠️  No tests found. Deploying test-engineer to create test suite...
📝 Generated: tests/test_main.py, tests/test_utils.py
✅ Created pytest.ini configuration
🧪 Running: pytest -v

✅ All tests passed (6/6)
```

### Go Project with Custom Command

```text
User: /test
Claude: 🔍 Discovering tests...
✅ Found in README.md: "make test"
🧪 Running: make test

✅ All tests passed
📊 Coverage: 78.9% of statements
```

## Notes

- Automatically detects CI environments and adjusts flags accordingly
- Supports mono-repos by detecting multiple project types
- Preserves existing test configurations and conventions
- Generates tests follow language-specific best practices
- Real-time output with enhanced formatting and emojis
- Comprehensive error recovery with actionable suggestions
