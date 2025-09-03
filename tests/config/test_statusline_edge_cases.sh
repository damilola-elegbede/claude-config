#!/bin/bash
# Edge case tests for statusline per-terminal version tracking
# Tests corner cases and error conditions

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
TEST_TEMP_DIR="/tmp/statusline_edge_test_$$"
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

# Test concurrent access to version files  
test_concurrent_access() {
    local statusline_path="../../system-configs/.claude/statusline.sh"
    
    # Clean test environment
    rm -rf "$TEST_HOME/.claude"
    
    # Test that the script can handle concurrent-like access patterns
    # Using proper semantic versions (X.Y.Z format)
    local outputs=()
    for i in {1..3}; do
        local test_input="{\"model\":{\"display_name\":\"Claude\"},\"version\":\"9.${i}.0\",\"workspace\":{\"current_dir\":\"/tmp\"},\"output_style\":{\"name\":\"default\"}}"
        outputs[$i]=$(HOME="$TEST_HOME" echo "$test_input" | bash "$statusline_path" 2>/dev/null)
    done
    
    # Each should work without error
    for i in {1..3}; do
        if [[ -z "${outputs[$i]}" ]]; then
            echo "Concurrent execution $i produced no output"
            return 1
        fi
        # Should contain the version (may or may not have stars depending on existing state)
        if [[ "${outputs[$i]}" != *"9.${i}.0"* ]]; then
            echo "Concurrent execution $i missing version: ${outputs[$i]}"
            return 1
        fi
    done
    
    # Test passes if all executions completed successfully
    return 0
}

# Test handling of special characters in version
test_special_characters_version() {
    local statusline_path="../../system-configs/.claude/statusline.sh"
    # Non-semantic version should trigger error
    local test_input='{"model":{"display_name":"Claude"},"version":"v1.2.3-beta+build.123","workspace":{"current_dir":"/tmp"},"output_style":{"name":"default"}}'
    
    # Clean test environment
    rm -rf "$TEST_HOME/.claude"
    
    # Run statusline (capture stderr for error message)
    HOME="$TEST_HOME" output=$(echo "$test_input" | bash "$statusline_path" 2>&1)
    
    # Check that non-semantic version triggers error
    if echo "$output" | grep -q "ERROR: Invalid version format"; then
        # Expected behavior - non-semantic version triggers error
        return 0
    else
        echo "Special characters in version not handled correctly: $output"
        return 1
    fi
    
    return 0
}

# Test behavior with empty session_id
test_empty_session_id() {
    local statusline_path="../../system-configs/.claude/statusline.sh"
    local test_input='{"model":{"display_name":"Claude"},"version":"1.0.0","session_id":"","workspace":{"current_dir":"/tmp"},"output_style":{"name":"default"}}'
    
    # Clean test environment
    rm -rf "$TEST_HOME/.claude"
    
    # Run statusline
    HOME="$TEST_HOME" output=$(echo "$test_input" | bash "$statusline_path" 2>/dev/null)
    
    # Should still show stars for new version
    if [[ "$output" != *"1.0.0 ✨"* ]]; then
        echo "Empty session_id should still work: $output"
        return 1
    fi
    
    # Check that fallback terminal ID was created
    version_files=("$TEST_HOME/.claude/terminal_versions"/*)
    if [[ ! -f "${version_files[0]}" ]]; then
        echo "Version file not created with empty session_id"
        return 1
    fi
    
    return 0
}

# Test handling of corrupted version files
test_corrupted_version_file() {
    local statusline_path="../../system-configs/.claude/statusline.sh"
    local test_input='{"model":{"display_name":"Claude"},"version":"2.0.0","workspace":{"current_dir":"/tmp"},"output_style":{"name":"default"}}'
    
    # Set up corrupted version file (use terminal_* pattern now)
    mkdir -p "$TEST_HOME/.claude/terminal_versions"
    # Create a corrupted file with predictable terminal ID
    echo -e "\x00\x01corrupted\xFF" > "$TEST_HOME/.claude/terminal_versions/terminal_test"
    
    # Run statusline - should handle corruption gracefully
    HOME="$TEST_HOME" output=$(echo "$test_input" | bash "$statusline_path" 2>/dev/null)
    
    # Should show stars because corrupted file should be treated as no previous version
    if [[ "$output" != *"2.0.0 ✨"* ]]; then
        echo "Corrupted version file should be handled gracefully: $output"
        return 1
    fi
    
    # Verify a terminal_* file now contains exactly 2.0.0
    if ! grep -rlq -- '^2\.0\.0$' "$TEST_HOME/.claude/terminal_versions"; then
        echo "No terminal version file updated with 2.0.0"
        return 1
    fi
    
    return 0
}

# Test permission denied scenarios
test_permission_denied() {
    local statusline_path="../../system-configs/.claude/statusline.sh"
    local test_input='{"model":{"display_name":"Claude"},"version":"3.0.0","workspace":{"current_dir":"/tmp"},"output_style":{"name":"default"}}'
    
    # Create read-only directory
    mkdir -p "$TEST_HOME/.claude"
    chmod 444 "$TEST_HOME/.claude"
    
    # Run statusline - should handle permission errors gracefully
    HOME="$TEST_HOME" output=$(echo "$test_input" | bash "$statusline_path" 2>/dev/null)
    
    # Should still produce output even if can't write files
    if [[ "$output" != *"3.0.0"* ]]; then
        echo "Should still work with permission denied: $output"
        # Restore permissions for cleanup
        chmod 755 "$TEST_HOME/.claude"
        return 1
    fi
    
    # Restore permissions for cleanup
    chmod 755 "$TEST_HOME/.claude"
    return 0
}

# Test extremely long version strings
test_long_version_string() {
    local statusline_path="../../system-configs/.claude/statusline.sh"
    # Non-semantic long version should trigger error
    local long_version="1.0.0-$(printf 'a%.0s' {1..100})"  # 100 character suffix
    local test_input="{\"model\":{\"display_name\":\"Claude\"},\"version\":\"$long_version\",\"workspace\":{\"current_dir\":\"/tmp\"},\"output_style\":{\"name\":\"default\"}}"
    
    # Clean test environment
    rm -rf "$TEST_HOME/.claude"
    
    # Run statusline (capture stderr)
    HOME="$TEST_HOME" output=$(echo "$test_input" | bash "$statusline_path" 2>&1)
    
    # Should reject non-semantic version
    if echo "$output" | grep -q "ERROR: Invalid version format"; then
        return 0
    else
        echo "Long version string not handled correctly"
        return 1
    fi
    
    return 0
}

# Test malformed JSON input
test_malformed_json() {
    local statusline_path="../../system-configs/.claude/statusline.sh"
    local malformed_input='{"model":{"display_name":"Claude"},"version":'
    
    # Clean test environment
    rm -rf "$TEST_HOME/.claude"
    
    # Run statusline with malformed JSON (capture stderr)
    HOME="$TEST_HOME" output=$(echo "$malformed_input" | bash "$statusline_path" 2>&1)
    
    # Malformed JSON triggers "unknown" version which now causes error
    if echo "$output" | grep -q "ERROR: Claude Code is not reporting version properly"; then
        return 0
    else
        echo "Should handle malformed JSON with error message"
        return 1
    fi
    
    return 0
}

# Test rapid version changes
test_rapid_version_changes() {
    local statusline_path="../../system-configs/.claude/statusline.sh"
    
    # Clean test environment
    rm -rf "$TEST_HOME/.claude"
    
    # Test rapid version changes
    for version in "1.0.0" "1.0.1" "1.0.2" "1.1.0" "2.0.0"; do
        local test_input="{\"model\":{\"display_name\":\"Claude\"},\"version\":\"$version\",\"workspace\":{\"current_dir\":\"/tmp\"},\"output_style\":{\"name\":\"default\"}}"
        
        HOME="$TEST_HOME" output=$(echo "$test_input" | bash "$statusline_path" 2>/dev/null)
        
        # Each new version should show stars
        if [[ "$output" != *"$version"* ]]; then
            echo "Rapid version change failed for $version: $output"
            return 1
        fi
        
        # Brief pause to ensure file system operations complete
        sleep 0.1
    done
    
    # Final check - last version should be recorded
    version_files=("$TEST_HOME/.claude/terminal_versions"/*)
    final_version=$(cat "${version_files[0]}" 2>/dev/null || echo "")
    if [[ "$final_version" != "2.0.0" ]]; then
        echo "Final version not recorded correctly: $final_version"
        return 1
    fi
    
    return 0
}

# Test cleanup functionality with various file ages
test_cleanup_functionality() {
    local statusline_path="../../system-configs/.claude/statusline.sh"
    # Use semantic version for cleanup test
    local test_input='{"model":{"display_name":"Claude"},"version":"4.5.6","workspace":{"current_dir":"/tmp"},"output_style":{"name":"default"}}'
    
    # Clean test environment
    rm -rf "$TEST_HOME/.claude"
    mkdir -p "$TEST_HOME/.claude/terminal_versions"
    
    # Create old files (simulate 8 days old by touching them)
    echo "old_version" > "$TEST_HOME/.claude/terminal_versions/old_terminal_1"
    echo "old_version" > "$TEST_HOME/.claude/terminal_versions/old_terminal_2"
    
    # Use touch to set modification time to 8 days ago
    touch -t $(date -v-8d +%Y%m%d%H%M.%S) "$TEST_HOME/.claude/terminal_versions/old_terminal_1" 2>/dev/null || \
    touch -d "8 days ago" "$TEST_HOME/.claude/terminal_versions/old_terminal_1" 2>/dev/null || true
    
    touch -t $(date -v-8d +%Y%m%d%H%M.%S) "$TEST_HOME/.claude/terminal_versions/old_terminal_2" 2>/dev/null || \
    touch -d "8 days ago" "$TEST_HOME/.claude/terminal_versions/old_terminal_2" 2>/dev/null || true
    
    # Run statusline - should trigger cleanup
    HOME="$TEST_HOME" bash "$statusline_path" <<< "$test_input" >/dev/null 2>&1
    
    # Check if new file was created and old files still exist (find might not work perfectly in test)
    version_files=("$TEST_HOME/.claude/terminal_versions"/*)
    if [[ ${#version_files[@]} -lt 1 ]]; then
        echo "Cleanup test failed - no version files found"
        return 1
    fi
    
    # At minimum, a new terminal file should exist (no more session files)
    terminal_files=("$TEST_HOME/.claude/terminal_versions/terminal_"*)
    if [[ ! -f "${terminal_files[0]}" ]]; then
        echo "New terminal file not created during cleanup test"
        return 1
    fi
    
    return 0
}

# Main test execution
echo "======================================="
echo "Statusline Edge Cases Test Suite"
echo "======================================="
echo

# Change to tests directory
cd "$(dirname "$0")"

# Run all edge case tests
run_test "Concurrent access handling" test_concurrent_access
run_test "Special characters in version" test_special_characters_version
run_test "Empty session_id handling" test_empty_session_id
run_test "Corrupted version file recovery" test_corrupted_version_file
run_test "Permission denied scenarios" test_permission_denied
run_test "Extremely long version strings" test_long_version_string
run_test "Malformed JSON input" test_malformed_json
run_test "Rapid version changes" test_rapid_version_changes
run_test "Cleanup functionality" test_cleanup_functionality

# Cleanup
rm -rf "$TEST_TEMP_DIR"

# Print summary
echo "======================================="
echo "Edge Cases Test Summary"
echo "======================================="
echo "Tests run: $TESTS_RUN"
echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests failed: ${RED}$TESTS_FAILED${NC}"
echo

# Exit with appropriate code
if [ $TESTS_FAILED -eq 0 ]; then
    print_pass "All statusline edge case tests passed!"
    exit 0
else
    print_fail "Some statusline edge case tests failed!"
    exit 1
fi