#!/bin/bash
# Test suite for statusline.sh functionality
# Tests the per-terminal version tracking feature

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Temp directory for test files
TEST_TEMP_DIR="/tmp/statusline_test_$$"
mkdir -p "$TEST_TEMP_DIR"

# Mock HOME directory for testing
TEST_HOME="$TEST_TEMP_DIR/home"
mkdir -p "$TEST_HOME"

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
    local test_name="$1"
    shift
    local test_func="$1"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    print_info "Testing: $test_name"
    
    if "$test_func"; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        print_pass "$test_name"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        print_fail "$test_name"
    fi
    echo
}

# Test statusline script exists and is executable
test_statusline_exists() {
    local statusline_path="../../system-configs/.claude/statusline.sh"
    
    if [[ ! -f "$statusline_path" ]]; then
        echo "Statusline script not found at $statusline_path"
        return 1
    fi
    
    if [[ ! -x "$statusline_path" ]]; then
        echo "Statusline script is not executable"
        return 1
    fi
    
    return 0
}

# Test basic statusline output format
test_basic_output_format() {
    local statusline_path="../../system-configs/.claude/statusline.sh"
    local test_input='{"model":{"display_name":"Claude 3.5 Sonnet"},"version":"1.2.3","session_id":"test123","workspace":{"current_dir":"/Users/test/project"},"output_style":{"name":"default"}}'
    
    # Set test environment
    HOME="$TEST_HOME" output=$(echo "$test_input" | bash "$statusline_path" 2>/dev/null)
    
    # Check if output contains expected elements
    if [[ "$output" != *"Claude 3.5 Sonnet"* ]]; then
        echo "Output missing model name: $output"
        return 1
    fi
    
    if [[ "$output" != *"project"* ]]; then
        echo "Output missing directory: $output"
        return 1
    fi
    
    if [[ "$output" != *"1.2.3"* ]]; then
        echo "Output missing version: $output"
        return 1
    fi
    
    return 0
}

# Test version tracking for new version
test_new_version_tracking() {
    local statusline_path="../../system-configs/.claude/statusline.sh"
    local test_input='{"model":{"display_name":"Claude"},"version":"2.0.0","session_id":"test456","workspace":{"current_dir":"/tmp"},"output_style":{"name":"default"}}'
    
    # Clean test environment
    rm -rf "$TEST_HOME/.claude"
    
    # First run should show stars for new version
    HOME="$TEST_HOME" output=$(echo "$test_input" | bash "$statusline_path" 2>/dev/null)
    
    if [[ "$output" != *"2.0.0 ✨"* ]]; then
        echo "New version should show stars, got: $output"
        return 1
    fi
    
    # Second run should not show stars
    HOME="$TEST_HOME" output=$(echo "$test_input" | bash "$statusline_path" 2>/dev/null)
    
    if [[ "$output" == *"2.0.0 ✨"* ]]; then
        echo "Same version should not show stars on second run, got: $output"
        return 1
    fi
    
    if [[ "$output" != *"2.0.0"* ]]; then
        echo "Output missing version on second run: $output"
        return 1
    fi
    
    return 0
}

# Test per-terminal tracking isolation
test_terminal_isolation() {
    local statusline_path="../../system-configs/.claude/statusline.sh"
    local input1='{"model":{"display_name":"Claude"},"version":"3.0.0","session_id":"terminal1","workspace":{"current_dir":"/tmp"},"output_style":{"name":"default"}}'
    local input2='{"model":{"display_name":"Claude"},"version":"3.0.0","session_id":"terminal2","workspace":{"current_dir":"/tmp"},"output_style":{"name":"default"}}'
    
    # Clean test environment
    rm -rf "$TEST_HOME/.claude"
    
    # Terminal 1 sees version first time
    HOME="$TEST_HOME" output1=$(echo "$input1" | bash "$statusline_path" 2>/dev/null)
    
    if [[ "$output1" != *"3.0.0 ✨"* ]]; then
        echo "Terminal 1 should show stars for new version: $output1"
        return 1
    fi
    
    # Terminal 2 should also see stars (different session)
    HOME="$TEST_HOME" output2=$(echo "$input2" | bash "$statusline_path" 2>/dev/null)
    
    if [[ "$output2" != *"3.0.0 ✨"* ]]; then
        echo "Terminal 2 should show stars for new version: $output2"
        return 1
    fi
    
    # Terminal 1 second time should not show stars
    HOME="$TEST_HOME" output1_2nd=$(echo "$input1" | bash "$statusline_path" 2>/dev/null)
    
    if [[ "$output1_2nd" == *"3.0.0 ✨"* ]]; then
        echo "Terminal 1 second run should not show stars: $output1_2nd"
        return 1
    fi
    
    return 0
}

# Test version file creation and cleanup
test_version_file_management() {
    local statusline_path="../../system-configs/.claude/statusline.sh"
    local test_input='{"model":{"display_name":"Claude"},"version":"4.0.0","session_id":"cleanup_test","workspace":{"current_dir":"/tmp"},"output_style":{"name":"default"}}'
    
    # Clean test environment
    rm -rf "$TEST_HOME/.claude"
    
    # Run statusline to create version tracking
    HOME="$TEST_HOME" bash "$statusline_path" <<< "$test_input" >/dev/null 2>&1
    
    # Check if terminal versions directory exists
    if [[ ! -d "$TEST_HOME/.claude/terminal_versions" ]]; then
        echo "Terminal versions directory not created"
        return 1
    fi
    
    # Check if terminal version file exists
    terminal_files=("$TEST_HOME/.claude/terminal_versions"/*)
    if [[ ${#terminal_files[@]} -eq 0 || ! -f "${terminal_files[0]}" ]]; then
        echo "Terminal version file not created"
        return 1
    fi
    
    # Check file content
    version_content=$(cat "${terminal_files[0]}")
    if [[ "$version_content" != "4.0.0" ]]; then
        echo "Version file content incorrect: $version_content"
        return 1
    fi
    
    return 0
}

# Test handling of unknown version
test_unknown_version_handling() {
    local statusline_path="../../system-configs/.claude/statusline.sh"
    local test_input='{"model":{"display_name":"Claude"},"version":"unknown","session_id":"unknown_test","workspace":{"current_dir":"/tmp"},"output_style":{"name":"default"}}'
    
    # Clean test environment
    rm -rf "$TEST_HOME/.claude"
    
    # Run with unknown version
    HOME="$TEST_HOME" output=$(echo "$test_input" | bash "$statusline_path" 2>/dev/null)
    
    # Should not show stars for unknown version
    if [[ "$output" == *"unknown ✨"* ]]; then
        echo "Unknown version should not show stars: $output"
        return 1
    fi
    
    if [[ "$output" != *"unknown"* ]]; then
        echo "Output should still show unknown version: $output"
        return 1
    fi
    
    return 0
}

# Test legacy cleanup functionality
test_legacy_cleanup() {
    local statusline_path="../../system-configs/.claude/statusline.sh"
    local test_input='{"model":{"display_name":"Claude"},"version":"5.0.0","session_id":"legacy_test","workspace":{"current_dir":"/tmp"},"output_style":{"name":"default"}}'
    
    # Set up legacy files
    mkdir -p "$TEST_HOME/.claude"
    echo "1.0.0" > "$TEST_HOME/.claude/acknowledged_version"
    echo "old_session" > "$TEST_HOME/.claude/notified_session"
    echo "2.0.0" > "$TEST_HOME/.claude/session_version_old"
    
    # Run statusline
    HOME="$TEST_HOME" bash "$statusline_path" <<< "$test_input" >/dev/null 2>&1
    
    # Check that legacy files are cleaned up
    if [[ -f "$TEST_HOME/.claude/acknowledged_version" ]]; then
        echo "Legacy acknowledged_version file not cleaned up"
        return 1
    fi
    
    if [[ -f "$TEST_HOME/.claude/notified_session" ]]; then
        echo "Legacy notified_session file not cleaned up"
        return 1
    fi
    
    if [[ -f "$TEST_HOME/.claude/session_version_old" ]]; then
        echo "Legacy session_version file not cleaned up"
        return 1
    fi
    
    return 0
}

# Test jq dependency
test_jq_dependency() {
    if ! command -v jq >/dev/null 2>&1; then
        echo "jq is required for statusline.sh but not installed"
        return 1
    fi
    return 0
}

# Test git command handling
test_git_handling() {
    local statusline_path=$(realpath "../../system-configs/.claude/statusline.sh")
    local test_input='{"model":{"display_name":"Claude"},"version":"6.0.0","session_id":"git_test","workspace":{"current_dir":"/tmp"},"output_style":{"name":"default"}}'
    
    # Test in non-git directory using subshell to avoid changing current directory
    output=$(cd /tmp && HOME="$TEST_HOME" echo "$test_input" | bash "$statusline_path" 2>/dev/null)
    
    # Strip ANSI color codes for testing
    output_clean=$(echo "$output" | sed 's/\x1b\[[0-9;]*m//g')
    
    if [[ "$output_clean" != *"no-git"* ]]; then
        echo "Should show 'no-git' when not in git repository: $output_clean"
        return 1
    fi
    
    return 0
}

# Main test execution
echo "======================================="
echo "Statusline Functionality Test Suite"
echo "======================================="
echo

# Change to tests directory
cd "$(dirname "$0")"

# Run all tests
run_test "Statusline script exists and is executable" test_statusline_exists
run_test "Basic output format" test_basic_output_format
run_test "New version tracking with stars" test_new_version_tracking
run_test "Per-terminal isolation" test_terminal_isolation
run_test "Version file management" test_version_file_management
run_test "Unknown version handling" test_unknown_version_handling
run_test "Legacy cleanup functionality" test_legacy_cleanup
run_test "jq dependency check" test_jq_dependency
run_test "Git command handling" test_git_handling

# Cleanup
rm -rf "$TEST_TEMP_DIR"

# Print summary
echo "======================================="
echo "Statusline Test Summary"
echo "======================================="
echo "Tests run: $TESTS_RUN"
echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests failed: ${RED}$TESTS_FAILED${NC}"
echo

# Exit with appropriate code
if [ $TESTS_FAILED -eq 0 ]; then
    print_pass "All statusline tests passed!"
    exit 0
else
    print_fail "Some statusline tests failed!"
    exit 1
fi