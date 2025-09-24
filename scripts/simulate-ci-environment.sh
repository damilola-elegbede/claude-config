#!/bin/bash
# CI Environment Simulation Script
# Simulates GitHub Actions Ubuntu environment for local testing

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  CI Environment Simulation${NC}"
echo -e "${BLUE}========================================${NC}"
echo

# Simulate CI environment variables
export CI=true
export RUNNER_OS="Linux"
export GITHUB_ACTIONS=true
export GITHUB_WORKSPACE=$(pwd)

# Reset temp directory to standard location
unset TMPDIR
export TMPDIR=/tmp

# Check Python availability
echo -e "${YELLOW}→${NC} Checking Python environment..."
if ! command -v python3 > /dev/null; then
    echo -e "${RED}✗${NC} Python3 not available. Please install Python 3."
    exit 1
fi

# Check PyYAML availability
if ! python3 -c "import yaml" 2>/dev/null; then
    echo -e "${YELLOW}⚠${NC} PyYAML not available. Installing..."
    if command -v pip3 > /dev/null; then
        pip3 install --user PyYAML
    else
        echo -e "${RED}✗${NC} pip3 not available. Please install PyYAML manually:"
        echo "  pip install PyYAML"
        exit 1
    fi
fi

echo -e "${GREEN}✓${NC} Python environment ready"

# Display environment info (matching CI output)
echo
echo "=== CI Environment Info ==="
echo "Runner OS: $RUNNER_OS"
echo "Home: $HOME"
echo "Temp: $TMPDIR"
echo "Python: $(python3 --version)"
echo "Bash: $(bash --version | head -1)"
echo "Working Directory: $(pwd)"
echo "=========================="
echo

# Ensure test script is executable
echo -e "${YELLOW}→${NC} Making test script executable..."
chmod +x tests/test.sh

# Run test suite
echo -e "${YELLOW}→${NC} Running test suite in CI simulation mode..."
echo

if ./tests/test.sh; then
    echo
    echo -e "${GREEN}✓${NC} CI simulation completed successfully!"
    echo -e "${BLUE}ℹ${NC} Your tests should pass in the actual CI environment."
else
    exit_code=$?
    echo
    echo -e "${RED}✗${NC} CI simulation failed with exit code $exit_code"
    echo -e "${YELLOW}⚠${NC} Check the output above for specific test failures."
    echo -e "${BLUE}ℹ${NC} Test artifacts may be in /tmp/verify-test-results-*"
    exit $exit_code
fi