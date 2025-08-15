# /test Command

## Description

Automatically discovers and runs tests configured in any repository by analyzing the README.md and common test
patterns. If no tests exist, it creates a base level test suite appropriate for the project type. This universal
test runner eliminates the need to remember project-specific test commands or manually set up initial tests.
Claude coordinates with the test-engineer specialist for comprehensive test strategy when needed.

## Usage

```bash
/test
```

## Behavior

When you use `/test`, I will:

1. **Check for existing tests** by looking for:
   - Test directories (test/, tests/, **tests**, spec/)
   - Test files (*test.*, *.test.*, *_test.*, *.spec.*)
   - Test configuration files (jest.config.*, pytest.ini, etc.)

2. **If no tests exist**, I will:
   - Detect the project type and main files
   - Create appropriate test directory structure
   - Generate base test files with:
     - Basic import/setup tests
     - Simple unit tests for main functions/classes
     - Test configuration if needed
   - Add test script to package.json or equivalent

3. **Analyze README.md** to find test commands by looking for:
   - Sections with headers containing "test", "testing", "run tests"
   - Code blocks following test-related sections
   - Common test command patterns

4. **Detect project type** if README parsing fails:
   - Node.js: Look for `package.json` and check scripts.test
   - Python: Look for `pytest.ini`, `tox.ini`, or test directories
   - Go: Look for `*_test.go` files
   - Rust: Look for `Cargo.toml`
   - Other frameworks based on configuration files

5. **Execute tests** with proper setup:
   - Ensure dependencies are installed
   - Run the identified test command
   - Display results with pass/fail status
   - Show coverage information if available

6. **Deploy execution-evaluator** to verify:
   - Test command executed correctly
   - Coverage thresholds were met
   - Test reports were generated
   - CI/CD integration successful

## Test Detection Priority

1. README.md documented commands (highest priority)
2. Package manager test scripts (npm, yarn, pnpm)
3. Framework-specific conventions
4. Common test tool detection (pytest, jest, mocha, etc.)

## Test Generation Templates

When creating new tests, I'll generate appropriate starter tests:

### JavaScript/TypeScript

- Jest test with describe/it blocks
- Basic module import tests
- Simple function tests with assertions
- Mock setup examples

### Python

- pytest-style test functions
- Basic import tests
- Simple unit tests with assertions
- Fixture examples

### Go

- Standard testing package tests
- Table-driven test examples
- Basic function tests

### Other Languages

- Framework-appropriate test structure
- Basic assertions and test cases
- Import/compilation tests

## Supported Test Frameworks

- **JavaScript/TypeScript**: Jest, Mocha, Vitest, Jasmine, Karma
- **Python**: pytest, unittest, nose, tox
- **Go**: go test
- **Rust**: cargo test
- **Ruby**: RSpec, Minitest
- **Java**: JUnit, TestNG
- **C#**: NUnit, xUnit
- **.NET**: dotnet test

## Examples

```bash
# In a Node.js project
/test
# Finds and runs: npm test

# In a Python project
/test
# Finds and runs: pytest

# In a Go project
/test
# Finds and runs: go test ./...
```

## Notes

- If no tests exist, I'll create a basic test suite before running
- Generated tests follow best practices for the detected framework
- If multiple test commands are found, I'll ask which one to run
- For CI/CD environments, I'll use appropriate flags (--ci, --no-watch, etc.)
- Test output is displayed in real-time
- Failed tests will show detailed error information
