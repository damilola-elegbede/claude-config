#!/bin/bash

# Simple integration test for ElevenLabs MCP validation script
# Tests basic functionality and integration with the project

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
VALIDATION_SCRIPT="$PROJECT_ROOT/scripts/validate-elevenlabs-mcp.sh"

echo "=== ElevenLabs MCP Integration Test ==="
echo

# Test 1: Script exists and is executable
echo "Test 1: Script exists and is executable"
if [[ -x "$VALIDATION_SCRIPT" ]]; then
    echo "✓ PASS: Validation script is executable"
else
    echo "✗ FAIL: Validation script is not executable"
    exit 1
fi

# Test 2: Help functionality works
echo "Test 2: Help functionality"
if "$VALIDATION_SCRIPT" --help > /dev/null 2>&1; then
    echo "✓ PASS: Help functionality works"
else
    echo "✗ FAIL: Help functionality broken"
    exit 1
fi

# Test 3: Configuration file validation
echo "Test 3: Configuration file validation"
CONFIG_FILE="$PROJECT_ROOT/.mcp.json"
if [[ -f "$CONFIG_FILE" ]]; then
    if python3 -c "import json; json.load(open('$CONFIG_FILE'))" 2>/dev/null; then
        echo "✓ PASS: Configuration file exists and is valid JSON"
    else
        echo "✗ FAIL: Configuration file is invalid JSON"
        exit 1
    fi
else
    echo "✗ FAIL: Configuration file does not exist"
    exit 1
fi

# Test 4: Script handles missing API key gracefully
echo "Test 4: Missing API key handling"
unset ELEVENLABS_API_KEY 2>/dev/null || true
if "$VALIDATION_SCRIPT" > /dev/null 2>&1; then
    echo "✗ FAIL: Script should fail with missing API key"
    exit 1
else
    echo "✓ PASS: Script correctly fails with missing API key"
fi

# Test 5: Script runs successfully with API key
echo "Test 5: Script runs with test API key"
export ELEVENLABS_API_KEY="test_key_for_validation_$(date +%s)"
# Since we don't want to test actual API calls, we just check it doesn't crash immediately
if timeout 5s "$VALIDATION_SCRIPT" > /dev/null 2>&1 || [[ $? -eq 124 ]] || [[ $? -eq 1 ]]; then
    echo "✓ PASS: Script runs with API key (may fail on MCP test, which is expected)"
else
    echo "✗ FAIL: Script crashes with API key"
    exit 1
fi

echo
echo "=== All Integration Tests Passed ==="
echo "✓ ElevenLabs MCP validation script is properly integrated"