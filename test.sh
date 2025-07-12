#!/bin/bash
# Claude Configuration Test Suite
# Runs all tests for Claude commands and configurations

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test results array
declare -a FAILED_TESTS

# Function to print colored output
print_pass() {
    echo -e "${GREEN}✓${NC} $1"
}

print_fail() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}→${NC} $1"
}

# Function to run a test
run_test() {
    local test_name=$1
    local test_file=$2
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [ -f "$test_file" ]; then
        print_info "Running $test_name..."
        if bash "$test_file"; then
            TESTS_PASSED=$((TESTS_PASSED + 1))
            print_pass "$test_name passed"
        else
            TESTS_FAILED=$((TESTS_FAILED + 1))
            FAILED_TESTS+=("$test_name")
            print_fail "$test_name failed"
        fi
    else
        print_fail "Test file not found: $test_file"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        FAILED_TESTS+=("$test_name (file not found)")
    fi
    echo
}

# Main test execution
echo "==================================="
echo "Claude Configuration Test Suite"
echo "==================================="
echo

# Change to tests directory
cd "$(dirname "$0")"
BASE_DIR=$(pwd)

# Source test utilities if available
if [ -f "tests/utils.sh" ]; then
    source "tests/utils.sh"
fi

# Run command tests
echo "Running Command Tests..."
echo "------------------------"
run_test "Plan Command" "tests/commands/test_plan.sh"
run_test "Commit Command" "tests/commands/test_commit.sh"
run_test "Push Command" "tests/commands/test_push.sh"
run_test "Test Command" "tests/commands/test_test.sh"
run_test "Context Command" "tests/commands/test_context.sh"
run_test "Sync Command" "tests/commands/test_sync.sh"

# Run configuration tests
echo "Running Configuration Tests..."
echo "------------------------------"
run_test "CLAUDE.md Validation" "tests/config/test_claude_md.sh"
run_test "Command Files Validation" "tests/config/test_command_files.sh"

# Run integration tests
echo "Running Integration Tests..."
echo "----------------------------"
run_test "Command Integration" "tests/integration/test_integration.sh"

# Print summary
echo "==================================="
echo "Test Summary"
echo "==================================="
echo "Tests run: $TESTS_RUN"
echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests failed: ${RED}$TESTS_FAILED${NC}"

if [ ${#FAILED_TESTS[@]} -gt 0 ]; then
    echo
    echo "Failed tests:"
    for test in "${FAILED_TESTS[@]}"; do
        echo "  - $test"
    done
fi

echo

# Exit with appropriate code
if [ $TESTS_FAILED -eq 0 ]; then
    print_pass "All tests passed!"
    exit 0
else
    print_fail "Some tests failed!"
    exit 1
fi