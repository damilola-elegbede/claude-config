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

## Behavior

When invoked, I automatically discovers and runs tests using a 3-phase
algorithm: README analysis, package manager detection, and framework conventions.
If no tests exist, I can generate comprehensive test suites appropriate for
the detected framework.

## Discovery Algorithm

### Phase 1: README Analysis (Highest Priority)

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

When no tests exist, I deploy **test-engineer** to create comprehensive test suites:

### JavaScript/TypeScript Projects

```javascript
// Generated: src/__tests__/example.test.js
import { add, multiply } from '../utils';

describe('Utils Functions', () => {
  test('add function', () => {
    expect(add(2, 3)).toBe(5);
    expect(add(-1, 1)).toBe(0);
  });

  test('multiply function', () => {
    expect(multiply(3, 4)).toBe(12);
    expect(multiply(0, 5)).toBe(0);
  });
});
```bash

Package.json script addition:

```json
{
  "scripts": {
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage"
  }
}
```bash

### Python Projects

```python
# Generated: tests/test_utils.py
import pytest
from src.utils import add, multiply

class TestUtils:
    def test_add(self):
        assert add(2, 3) == 5
        assert add(-1, 1) == 0

    def test_multiply(self):
        assert multiply(3, 4) == 12
        assert multiply(0, 5) == 0

    def test_add_edge_cases(self):
        with pytest.raises(TypeError):
            add("string", 5)
```bash

Configuration files:

```text
# Generated: pytest.ini
[tool:pytest]
testpaths = tests
python_files = test_*.py
python_functions = test_*
addopts = --verbose --tb=short
```bash

### Go Projects

```go
// Generated: utils_test.go
package main

import "testing"

func TestAdd(t *testing.T) {
    tests := []struct {
        name string
        a, b int
        want int
    }{
        {"positive numbers", 2, 3, 5},
        {"negative and positive", -1, 1, 0},
        {"zeros", 0, 0, 0},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            if got := Add(tt.a, tt.b); got != tt.want {
                t.Errorf("Add(%d, %d) = %d, want %d", tt.a, tt.b, got, tt.want)
            }
        })
    }
}
```bash

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

### Jest/Vitest (JavaScript)

```bash
# Standard execution:
npm test

# With coverage:
npm test -- --coverage

# Watch mode (if not CI):
npm test -- --watch

# CI optimizations:
npm test -- --ci --coverage --watchAll=false
```bash

### pytest (Python)

```bash
# Standard execution:
pytest -v

# With coverage:
pytest --cov=src --cov-report=html

# Parallel execution:
pytest -n auto  # if pytest-xdist installed

# XML output for CI:
pytest --junitxml=test-results.xml
```bash

### Go Testing

```bash
# Standard execution:
go test ./...

# With coverage:
go test -cover ./...

# Verbose output:
go test -v ./...

# Race condition detection:
go test -race ./...
```bash

## Error Handling & Recovery

### Common Failure Scenarios

```yaml
Missing Dependencies:
  Detection: "command not found", "module not found"
  Recovery: Install using detected package manager
  Example: npm install --save-dev jest

Test Database Issues:
  Detection: Database connection errors
  Recovery: Create test database, run migrations
  Example: createdb myapp_test && rails db:test:prepare

Configuration Errors:
  Detection: Config file parsing failures
  Recovery: Generate minimal working config
  Example: Create jest.config.js with defaults

Permission Issues:
  Detection: EACCES, permission denied errors
  Recovery: Suggest chmod fixes or container usage
  Example: chmod +x node_modules/.bin/jest
```bash

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

- **Discovery Rate**: >95% successful test command identification
- **Generation Quality**: Generated tests pass and provide meaningful coverage
- **Execution Speed**: Test discovery completes in <5 seconds
- **Error Recovery**: Clear guidance provided for 90% of common failures

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
