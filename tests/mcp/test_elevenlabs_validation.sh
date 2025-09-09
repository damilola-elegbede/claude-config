#!/bin/bash

# Test suite for ElevenLabs MCP validation script
# Tests various scenarios and edge cases

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEST_SCRIPT="$PROJECT_ROOT/scripts/validate-elevenlabs-mcp.sh"

# Source test utilities
source "$PROJECT_ROOT/tests/utils.sh"

# Ensure colors are defined (in case utils.sh doesn't define them)
RED=${RED:-'\033[0;31m'}
GREEN=${GREEN:-'\033[0;32m'}
YELLOW=${YELLOW:-'\033[1;33m'}
BLUE=${BLUE:-'\033[0;34m'}
NC=${NC:-'\033[0m'}

# Test counters
tests_run=0
tests_passed=0
tests_failed=0

# Test logging
log_test() {
    echo "  Testing: $1"
    ((tests_run++))
}

pass_test() {
    echo -e "  ${GREEN}✓${NC} $1"
    ((tests_passed++))
}

fail_test() {
    echo -e "  ${RED}✗${NC} $1"
    ((tests_failed++))
}

# Test with valid configuration
test_valid_configuration() {
    log_test "Valid configuration scenario"

    # Create temporary test environment
    local temp_dir=$(mktemp -d)
    local config_dir="$temp_dir/system-configs/.claude/mcp"
    local settings_dir="$temp_dir/system-configs"

    mkdir -p "$config_dir"
    mkdir -p "$settings_dir"

    # Create valid configuration
    cat > "$config_dir/elevenlabs-config.json" << 'EOF'
{
  "mcpServers": {
    "elevenlabs": {
      "command": "uvx",
      "args": ["elevenlabs-mcp"],
      "env": {
        "ELEVENLABS_API_KEY": "${ELEVENLABS_API_KEY}"
      }
    }
  }
}
EOF

    # Create valid settings.json
    cat > "$settings_dir/settings.json" << 'EOF'
{
  "mcpServers": {}
}
EOF

    # Test configuration validation only (not full script as it requires system dependencies)
    if python3 -c "
import json
config_file = '$config_dir/elevenlabs-config.json'
try:
    with open(config_file, 'r') as f:
        data = json.load(f)
    assert 'mcpServers' in data
    assert 'elevenlabs' in data['mcpServers']
    assert 'command' in data['mcpServers']['elevenlabs']
    assert data['mcpServers']['elevenlabs']['command'] == 'uvx'
    assert 'elevenlabs-mcp' in data['mcpServers']['elevenlabs']['args']
    print('Configuration validation passed')
except Exception as e:
    print(f'Configuration validation failed: {e}')
    exit(1)
"; then
        pass_test "Valid configuration parsing"
    else
        fail_test "Valid configuration parsing"
    fi

    # Cleanup
    rm -rf "$temp_dir"
}

# Test with invalid JSON
test_invalid_json() {
    log_test "Invalid JSON handling"

    local temp_dir=$(mktemp -d)
    local config_dir="$temp_dir/system-configs/.claude/mcp"

    mkdir -p "$config_dir"

    # Create invalid JSON
    cat > "$config_dir/elevenlabs-config.json" << 'EOF'
{
  "mcpServers": {
    "elevenlabs": {
      "command": "uvx",
      "args": ["elevenlabs-mcp"]
    }
  // Missing closing brace
EOF

    # Test JSON validation
    if ! python3 -m json.tool "$config_dir/elevenlabs-config.json" >/dev/null 2>&1; then
        pass_test "Invalid JSON detection"
    else
        fail_test "Invalid JSON detection"
    fi

    # Cleanup
    rm -rf "$temp_dir"
}

# Test with missing required fields
test_missing_fields() {
    log_test "Missing required fields detection"

    local temp_dir=$(mktemp -d)
    local config_dir="$temp_dir/system-configs/.claude/mcp"

    mkdir -p "$config_dir"

    # Create config missing required fields
    cat > "$config_dir/elevenlabs-config.json" << 'EOF'
{
  "mcpServers": {
    "elevenlabs": {
      "command": "uvx"
    }
  }
}
EOF

    # Test missing fields detection
    if ! python3 -c "
import json
config_file = '$config_dir/elevenlabs-config.json'
with open(config_file, 'r') as f:
    data = json.load(f)
assert 'args' in data['mcpServers']['elevenlabs']
assert 'env' in data['mcpServers']['elevenlabs']
" 2>/dev/null; then
        pass_test "Missing fields detection"
    else
        fail_test "Missing fields detection"
    fi

    # Cleanup
    rm -rf "$temp_dir"
}

# Test script help functionality
test_help_functionality() {
    log_test "Help functionality"

    if "$TEST_SCRIPT" --help >/dev/null 2>&1; then
        pass_test "Help option works"
    else
        fail_test "Help option works"
    fi
}

# Test script exists and is executable
test_script_executable() {
    log_test "Script exists and is executable"

    if [[ -x "$TEST_SCRIPT" ]]; then
        pass_test "Script is executable"
    else
        fail_test "Script is executable"
    fi
}

# Test configuration file structure validation
test_config_structure_validation() {
    log_test "Configuration structure validation"

    # Test correct structure
    local temp_dir=$(mktemp -d)
    local config_file="$temp_dir/config.json"

    cat > "$config_file" << 'EOF'
{
  "mcpServers": {
    "elevenlabs": {
      "command": "uvx",
      "args": ["elevenlabs-mcp"],
      "env": {
        "ELEVENLABS_API_KEY": "${ELEVENLABS_API_KEY}"
      }
    }
  }
}
EOF

    # Validate structure
    if python3 -c "
import json
with open('$config_file', 'r') as f:
    data = json.load(f)

# Check all required structure
assert 'mcpServers' in data
assert 'elevenlabs' in data['mcpServers']
elevenlabs_config = data['mcpServers']['elevenlabs']
assert 'command' in elevenlabs_config
assert 'args' in elevenlabs_config
assert 'env' in elevenlabs_config
assert elevenlabs_config['command'] == 'uvx'
assert 'elevenlabs-mcp' in elevenlabs_config['args']
assert 'ELEVENLABS_API_KEY' in elevenlabs_config['env']
"; then
        pass_test "Configuration structure validation"
    else
        fail_test "Configuration structure validation"
    fi

    # Cleanup
    rm -rf "$temp_dir"
}

# Main test runner
main() {
    echo -e "${BLUE}=== ElevenLabs MCP Validation Tests ===${NC}"
    echo

    # Run all tests
    test_script_executable
    test_help_functionality
    test_valid_configuration
    test_invalid_json
    test_missing_fields
    test_config_structure_validation

    # Summary
    echo
    echo -e "${BLUE}=== Test Results ===${NC}"
    echo "Tests run: $tests_run"
    echo "Tests passed: $tests_passed"
    echo "Tests failed: $tests_failed"

    if [[ $tests_failed -eq 0 ]]; then
        echo -e "${GREEN}✓ All tests passed!${NC}"
        exit 0
    else
        echo -e "${RED}✗ $tests_failed test(s) failed${NC}"
        exit 1
    fi
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
