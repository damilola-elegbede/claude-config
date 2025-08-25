# /test Command

## Description

Universal test runner that automatically discovers, runs, and generates tests
for any repository and creates a base level test suite when none exist. Uses a 3-phase discovery algorithm: README analysis,
package manager detection, and framework conventions. Creates comprehensive
test suites when none exist.

## Usage

```bash
/test                    # Auto-discover and run tests
/test --create           # Generate test suite if missing
/test --framework <name> # Use specific framework (jest, pytest, etc.)
/test --coverage         # Run with coverage reporting
```bash

## Agent Orchestration

### Parallel Test Execution

Deploy specialized agents for comprehensive test management:

```yaml
codebase-analyst:
  role: Analyze codebase structure for test discovery
  input: Project structure, dependencies, code patterns
  output: Test framework recommendations, coverage analysis

debugger:
  role: Investigate test failures and framework issues
  input: Test failures, environment problems, setup issues
  output: Failure analysis, configuration fixes, debugging strategies

test-engineer:
  role: Manage test execution and generation
  input: Test framework detection, existing tests
  output: Test results, coverage reports, new test generation

performance-engineer:
  role: Run performance and load tests in parallel
  input: Performance test suites, benchmarks
  output: Performance metrics, bottleneck analysis

security-auditor:
  role: Execute security test suites simultaneously
  input: Security test configurations, vulnerability scanners
  output: Security test results, vulnerability reports
```bash

### Parallel Execution Strategy

```yaml
Test Suite Parallelization:
  - Unit tests, integration tests, and e2e tests run simultaneously
  - Performance tests run in parallel with functional tests
  - Security tests execute alongside other suites
  - Results aggregate for comprehensive report

Time Optimization:
  - Parallel execution: 30-60% faster
  - Independent test suites run concurrently
  - Multi-core utilization for test runners
```

## Behavior

When invoked, I automatically discover and run tests using parallel agent
deployment and a 3-phase algorithm: README analysis, package manager detection,
and framework conventions. Multiple test suites execute simultaneously for
maximum efficiency.

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
```bash

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
```bash

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
```bash

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
```bash

### Output Enhancement

```bash
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
```bash

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

### test-engineer Deployment

The test-engineer agent is deployed for:

- **Test suite generation** when `--create` is used
- **Complex test strategy** for large codebases
- **Test optimization** when coverage is below thresholds
- **Test debugging** when tests fail with unclear errors

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

```bash
User: /test
Claude: 🔍 Discovering tests...
✅ Found in package.json: "test": "jest"
🧪 Running: npm test

✅ All tests passed (4/4)
📊 Coverage: 87.3% lines, 82.1% branches
```bash

### Python Project (No Tests)

```bash
User: /test
Claude: 🔍 Discovering tests...
⚠️  No tests found. Deploying test-engineer to create test suite...
📝 Generated: tests/test_main.py, tests/test_utils.py
✅ Created pytest.ini configuration
🧪 Running: pytest -v

✅ All tests passed (6/6)
```bash

### Go Project with Custom Command

```bash
User: /test
Claude: 🔍 Discovering tests...
✅ Found in README.md: "make test"
🧪 Running: make test

✅ All tests passed
📊 Coverage: 78.9% of statements
```bash

## Notes

- Automatically detects CI environments and adjusts flags accordingly
- Supports mono-repos by detecting multiple project types
- Preserves existing test configurations and conventions
- Generates tests follow language-specific best practices
- Real-time output with enhanced formatting and emojis
- Comprehensive error recovery with actionable suggestions
