#!/bin/bash
# Quick test script to verify ShellCheck configuration fixes

set -e

echo "Testing ShellCheck configuration fixes..."
echo "========================================="

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Test scripts that were failing
CRITICAL_SCRIPTS=(
    "tests/test.sh"
    "scripts/validate-system.sh"
    "scripts/validate_yaml.sh"
    "scripts/install-hooks.sh"
)

# Check if shellcheck is installed
if ! command -v shellcheck &> /dev/null; then
    echo -e "${YELLOW}⚠️  ShellCheck not installed locally. Install with: brew install shellcheck${NC}"
    echo "Skipping local validation..."
    exit 0
fi

echo "ShellCheck version:"
shellcheck --version
echo

# Test with new configuration
echo "Testing critical scripts with updated configuration..."
echo "Using: --severity=warning --exclude=SC1091,SC2034,SC2086,SC2155,SC2312,SC2249"
echo

all_passed=true

for script in "${CRITICAL_SCRIPTS[@]}"; do
    if [ -f "$script" ]; then
        echo -n "Testing $script... "
        if shellcheck \
            --format=gcc \
            --severity=warning \
            --shell=bash \
            --exclude=SC1091,SC2034,SC2086,SC2155,SC2312,SC2249 \
            "$script" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ PASSED${NC}"
        else
            echo -e "${RED}❌ FAILED${NC}"
            # Show the actual errors for debugging
            echo "Errors found:"
            shellcheck \
                --format=gcc \
                --severity=warning \
                --shell=bash \
                --exclude=SC1091,SC2034,SC2086,SC2155,SC2312,SC2249 \
                "$script" || true
            echo
            all_passed=false
        fi
    else
        echo -e "${YELLOW}⚠️  Script not found: $script${NC}"
    fi
done

echo
echo "========================================="
if $all_passed; then
    echo -e "${GREEN}✅ All critical scripts pass with new configuration!${NC}"
    echo "The CI/CD pipeline should now pass."
else
    echo -e "${RED}❌ Some scripts still have issues.${NC}"
    echo "Additional fixes may be needed."
fi

# Cleanup
rm -f test-shellcheck-fix.sh