#!/bin/bash
# Behavioral test suite for /resolve-cr command
# Tests happy path, error path, and timeout scenarios

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test directory setup
TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FIXTURES_DIR="${TEST_DIR}/fixtures"
MOCK_BIN="${TEST_DIR}/mock-bin"

# Create mock directories
mkdir -p "${FIXTURES_DIR}" "${MOCK_BIN}"

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test helper functions
run_test() {
    local test_name="$1"
    local test_function="$2"
    
    echo -e "${YELLOW}Running test:${NC} $test_name"
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if $test_function; then
        echo -e "${GREEN}✓ PASSED${NC}: $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗ FAILED${NC}: $test_name"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

# Create mock gh command
create_mock_gh() {
    local scenario="$1"
    
    cat > "${MOCK_BIN}/gh" << 'EOF'
#!/bin/bash
# Mock gh command for testing

case "$*" in
    "pr view --json number -q .number")
        echo "62"
        ;;
    *"repos/:owner/:repo/pulls/"*"/comments"*)
        if [[ "$MOCK_SCENARIO" == "happy" ]]; then
            cat "${FIXTURES_DIR}/coderabbit-comment.json"
        else
            echo "[]"
        fi
        ;;
    *"repos/:owner/:repo/issues/"*"/comments?per_page=20"*)
        if [[ "$MOCK_SCENARIO" == "acknowledged" ]]; then
            cat "${FIXTURES_DIR}/coderabbit-ack.json"
        else
            echo "[]"
        fi
        ;;
    *"repos/:owner/:repo/issues/"*"/comments"*)
        if [[ "$MOCK_SCENARIO" == "happy" ]]; then
            cat "${FIXTURES_DIR}/coderabbit-issue-comment.json"
        else
            echo "[]"
        fi
        ;;
    *"repos/:owner/:repo/pulls/"*"/reviews"*)
        echo "[]"
        ;;
    "pr comment"*)
        echo "https://github.com/test/repo/pull/62#issuecomment-test"
        ;;
    *)
        echo "Mock gh: unhandled command: $*" >&2
        exit 1
        ;;
esac
EOF
    chmod +x "${MOCK_BIN}/gh"
}

# Create mock jq command
create_mock_jq() {
    cat > "${MOCK_BIN}/jq" << 'EOF'
#!/bin/bash
# Mock jq command - pass through for testing
exec /usr/bin/jq "$@"
EOF
    chmod +x "${MOCK_BIN}/jq"
}

# Create fixture files
create_fixtures() {
    # CodeRabbit comment with suggestions
    cat > "${FIXTURES_DIR}/coderabbit-comment.json" << 'EOF'
[{
  "user": {"login": "coderabbitai[bot]"},
  "body": "## Refactor Suggestion\n\nImprove acknowledgment detection\n\n## Prompts for AI Agents\n- Fix performance issue with acknowledgment detection\n- Add security checks for input validation\n- Improve test coverage for edge cases"
}]
EOF

    # CodeRabbit issue comment
    cat > "${FIXTURES_DIR}/coderabbit-issue-comment.json" << 'EOF'
[{
  "user": {"login": "coderabbitai[bot]"},
  "body": "Review in progress"
}]
EOF

    # CodeRabbit acknowledgment
    cat > "${FIXTURES_DIR}/coderabbit-ack.json" << 'EOF'
[{
  "user": {"login": "coderabbitai[bot]"},
  "body": "Thank you for resolving the suggestions! Great work on the improvements."
}]
EOF
}

# Test 1: Happy path - finds comments and pushes fixes
test_happy_path() {
    export MOCK_SCENARIO="happy"
    export PATH="${MOCK_BIN}:$PATH"
    
    # Source the resolve-cr implementation (simplified for testing)
    output=$(bash -c '
        source "${TEST_DIR}/../../system-configs/.claude/commands/resolve-cr-testable.sh"
        # Mock git commands
        git() {
            case "$*" in
                "diff --quiet") return 1 ;;  # simulate pending changes
                "diff HEAD~1 --stat") echo " 1 file changed, 3 insertions(+)" ; return 0 ;;
                add*) return 0 ;;
                commit*) echo "Mock commit"; return 0 ;;
                push*) echo "Mock push"; return 0 ;;
                "rev-parse --abbrev-ref HEAD") echo "test-branch" ;;
                "log -1 --pretty=format:- Commit: %h - %s") echo "- Commit: abc1234 - fix: resolve CodeRabbit suggestions" ;;
                "rev-list --count HEAD") echo "5" ;;
                *) echo "Mock git: $*"; return 0 ;;
            esac
        }
        export -f git
        resolve_cr 62 2>&1 | head -25
    ' 2>&1)
    
    # Check for expected output patterns in order
    if echo "$output" | grep -q "Aggressively searching for CodeRabbit comments"; then
        if echo "$output" | grep -q "Found:.*security.*perf.*test.*quality"; then
            if echo "$output" | grep -q "Changes pushed successfully"; then
                if echo "$output" | grep -q "Resolution trigger posted"; then
                    if echo "$output" | grep -q "Detailed summary posted"; then
                        return 0
                    fi
                fi
            fi
        fi
    fi
    
    echo "Output: $output"
    return 1
}

# Test 2: Error path - no comments found
test_no_comments() {
    export MOCK_SCENARIO="empty"
    export PATH="${MOCK_BIN}:$PATH"
    
    output=$(bash -c '
        source "${TEST_DIR}/../../system-configs/.claude/commands/resolve-cr-testable.sh"
        resolve_cr 62 2>&1
    ' 2>&1)
    
    # Check for expected error message
    if echo "$output" | grep -q "CRITICAL: No CodeRabbit comments found"; then
        return 0
    fi
    
    echo "Output: $output"
    return 1
}

# Test 3: Push and comment workflow
test_push_and_comment() {
    export MOCK_SCENARIO="happy"
    export PATH="${MOCK_BIN}:$PATH"
    
    output=$(bash -c '
        source "${TEST_DIR}/../../system-configs/.claude/commands/resolve-cr-testable.sh"
        # Mock git commands
        git() {
            case "$1" in
                "diff --quiet") return 1 ;;  # Has changes
                "add .") echo "Added files"; return 0 ;;
                commit*) echo "Committed changes"; return 0 ;;
                push*) echo "Pushed to remote"; return 0 ;;
                "rev-parse --abbrev-ref HEAD") echo "test-branch" ;;
                "log -1 --pretty=format:- Commit: %h - %s") echo "- Commit: abc1234 - fix: resolve CodeRabbit suggestions" ;;
                "diff HEAD~1 --stat") echo " 2 files changed, 10 insertions(+)" ;;
                "rev-list --count HEAD") echo "5" ;;
                *) echo "Mock git: $*"; return 0 ;;
            esac
        }
        export -f git
        resolve_cr 62 2>&1
    ' 2>&1)
    
    # Check that push happens before comments
    push_line=$(echo "$output" | grep -n "Changes pushed successfully" | cut -d: -f1)
    resolve_line=$(echo "$output" | grep -n "Resolution trigger posted" | cut -d: -f1)
    
    if [[ ! -z "$push_line" ]] && [[ ! -z "$resolve_line" ]]; then
        if [[ $push_line -lt $resolve_line ]]; then
            return 0
        fi
    fi
    
    echo "Output: $output"
    echo "Push line: $push_line, Resolve line: $resolve_line"
    return 1
}

# Test 4: Split comment posting
test_split_comments() {
    export MOCK_SCENARIO="happy"
    export PATH="${MOCK_BIN}:$PATH"
    
    # Track gh pr comment calls
    comment_count=0
    
    output=$(bash -c '
        source "${TEST_DIR}/../../system-configs/.claude/commands/resolve-cr-testable.sh"
        # Mock git commands
        git() {
            case "$1" in
                "diff --quiet") return 1 ;;  # Has changes
                "add .") return 0 ;;
                commit*) echo "Mock commit"; return 0 ;;
                push*) echo "Mock push"; return 0 ;;
                "rev-parse --abbrev-ref HEAD") echo "test-branch" ;;
                "log -1 --pretty=format:- Commit: %h - %s") echo "- Commit: abc1234 - fix: resolve CodeRabbit suggestions" ;;
                "diff HEAD~1 --stat") echo " 2 files changed, 10 insertions(+)" ;;
                "rev-list --count HEAD") echo "5" ;;
                *) echo "Mock git: $*"; return 0 ;;
            esac
        }
        export -f git
        resolve_cr 62 2>&1
    ' 2>&1)
    
    # Check for two separate comment posts via status lines
    resolve_count=$(echo "$output" | grep -c "Resolution trigger posted")
    summary_count=$(echo "$output" | grep -c "Detailed summary posted")
    
    if [[ $resolve_count -ge 1 ]] && [[ $summary_count -ge 1 ]]; then
        return 0
    fi
    
    echo "Output: $output"
    echo "Resolve comments: $resolve_count, Summary comments: $summary_count"
    return 1
}

# Create testable version of resolve-cr (without full implementation)
create_testable_resolve_cr() {
    # Extract just the function from the markdown file
    sed -n '/^resolve_cr() {/,/^}/p' \
        "${TEST_DIR}/../../system-configs/.claude/commands/resolve-cr.md" \
        > "${TEST_DIR}/../../system-configs/.claude/commands/resolve-cr-testable.sh"
}

# Main test execution
main() {
    echo "=== /resolve-cr Behavioral Test Suite ==="
    echo
    
    # Setup
    create_fixtures
    create_mock_gh
    create_mock_jq
    create_testable_resolve_cr
    
    # Run tests
    run_test "Happy path - finds comments and pushes fixes" test_happy_path
    run_test "Error path - no comments found" test_no_comments
    run_test "Push and comment workflow - push before comments" test_push_and_comment
    run_test "Split comments - resolve trigger and detailed summary" test_split_comments
    
    # Summary
    echo
    echo "=== Test Summary ==="
    echo -e "Tests run: ${TESTS_RUN}"
    echo -e "Tests passed: ${GREEN}${TESTS_PASSED}${NC}"
    echo -e "Tests failed: ${RED}${TESTS_FAILED}${NC}"
    
    # Cleanup
    rm -rf "${MOCK_BIN}" "${FIXTURES_DIR}"
    rm -f "${TEST_DIR}/../../system-configs/.claude/commands/resolve-cr-testable.sh"
    
    # Exit with appropriate code
    if [[ ${TESTS_FAILED} -gt 0 ]]; then
        exit 1
    fi
    
    exit 0
}

# Run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi