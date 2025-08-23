#!/bin/bash
# Test utilities for Claude configuration tests

# Test directory setup
TEST_DIR="/tmp/claude-config-test-$$"
ORIGINAL_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

# Colors (if not already defined)
RED=${RED:-'\033[0;31m'}
GREEN=${GREEN:-'\033[0;32m'}
YELLOW=${YELLOW:-'\033[1;33m'}
NC=${NC:-'\033[0m'}

# Create test environment
setup_test_env() {
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"
}

# Clean up test environment
cleanup_test_env() {
    cd "$ORIGINAL_DIR"
    rm -rf "$TEST_DIR"
}

# Assert functions
assert_equals() {
    local expected=$1
    local actual=$2
    local message=${3:-""}

    if [ "$expected" = "$actual" ]; then
        return 0
    else
        echo -e "${RED}Assertion failed${NC}: $message"
        echo "  Expected: $expected"
        echo "  Actual: $actual"
        return 1
    fi
}

assert_file_exists() {
    local file=$1
    local message=${2:-"File should exist: $file"}

    if [ -f "$file" ]; then
        return 0
    else
        echo -e "${RED}Assertion failed${NC}: $message"
        return 1
    fi
}

assert_directory_exists() {
    local dir=$1
    local message=${2:-"Directory should exist: $dir"}

    if [ -d "$dir" ]; then
        return 0
    else
        echo -e "${RED}Assertion failed${NC}: $message"
        return 1
    fi
}

assert_dir_exists() {
    local dir=$1
    local message=${2:-"Directory should exist: $dir"}

    if [ -d "$dir" ]; then
        return 0
    else
        echo -e "${RED}Assertion failed${NC}: $message"
        return 1
    fi
}

assert_file_contains() {
    local file=$1
    local pattern=$2
    local message=${3:-"File should contain pattern"}

    if grep -q "$pattern" "$file" 2>/dev/null; then
        return 0
    else
        echo -e "${RED}Assertion failed${NC}: $message"
        echo "  File: $file"
        echo "  Pattern: $pattern"
        return 1
    fi
}

assert_command_success() {
    local command=$1
    local message=${2:-"Command should succeed: $command"}

    if eval "$command" > /dev/null 2>&1; then
        return 0
    else
        echo -e "${RED}Assertion failed${NC}: $message"
        return 1
    fi
}

assert_command_fails() {
    local command=$1
    local message=${2:-"Command should fail: $command"}

    if eval "$command" > /dev/null 2>&1; then
        echo -e "${RED}Assertion failed${NC}: $message"
        return 1
    else
        return 0
    fi
}

# Mock functions for testing commands
mock_git_status() {
    echo "On branch main"
    echo "Your branch is up to date with 'origin/main'."
    echo ""
    echo "nothing to commit, working tree clean"
}

mock_git_diff() {
    if [ "$1" = "--cached" ]; then
        echo "No staged changes"
    else
        echo "No changes"
    fi
}

# Create a mock command file for testing
create_mock_command() {
    local name=$1
    local content=$2

    mkdir -p system-configs/.claude/commands
    cat > "system-configs/.claude/commands/${name}.md" << EOF
# /${name} Command

## Description
Test command for ${name}

## Usage
\`\`\`
/${name}
\`\`\`

## Behavior
${content}
EOF
}

# Create a mock CLAUDE.md for testing
create_mock_claude_md() {
    cat > CLAUDE.md << 'EOF'
# Claude Configuration

## CLI Command Shortcuts

### /test Command
- Test command description

## Trusted Folders
- /test/path - Test path

## Code Quality Standards

### Comments and Documentation
- Test documentation standard
EOF
}

# Run a test with setup and cleanup
run_isolated_test() {
    local test_name=$1
    local test_function=$2

    echo "  Running: $test_name"

    # Setup
    setup_test_env

    # Run test
    if $test_function; then
        echo -e "  ${GREEN}✓${NC} $test_name"
        cleanup_test_env
        return 0
    else
        echo -e "  ${RED}✗${NC} $test_name"
        cleanup_test_env
        return 1
    fi
}

# Verify markdown file structure
verify_markdown_structure() {
    local file=$1

    # Check for main heading
    if ! grep -q "^# " "$file"; then
        echo "Missing main heading (#)"
        return 1
    fi

    # Check for Description section
    if ! grep -q "^## Description" "$file"; then
        echo "Missing Description section"
        return 1
    fi

    return 0
}

# Export all functions
export -f setup_test_env cleanup_test_env
export -f assert_equals assert_file_exists assert_dir_exists
export -f assert_file_contains assert_command_success assert_command_fails
export -f mock_git_status mock_git_diff
export -f create_mock_command create_mock_claude_md
export -f run_isolated_test verify_markdown_structure
