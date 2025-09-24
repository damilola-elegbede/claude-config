#!/bin/bash
# Dependency Verification Script for CI/CD
# ========================================
#
# Comprehensive dependency verification with detailed reporting
# Used across all CI workflows to ensure consistent dependency resolution

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "=== Dependency Verification ==="

# Function to print status
print_status() {
    local status=$1
    local message=$2
    case $status in
        "pass")
            echo -e "${GREEN}✓${NC} $message"
            ;;
        "fail")
            echo -e "${RED}✗${NC} $message"
            ;;
        "info")
            echo -e "${YELLOW}→${NC} $message"
            ;;
    esac
}

# Verify Python environment
verify_python() {
    print_status "info" "Verifying Python environment..."

    if command -v python3 >/dev/null 2>&1; then
        print_status "pass" "Python3 available: $(python3 --version)"
    else
        print_status "fail" "Python3 not found"
        return 1
    fi

    # Check pip
    if python3 -m pip --version >/dev/null 2>&1; then
        print_status "pass" "pip available: $(python3 -m pip --version | head -1)"
    else
        print_status "fail" "pip not available"
        return 1
    fi

    # Check PyYAML
    if python3 -c "import yaml; print(f'PyYAML version: {yaml.__version__}')" 2>/dev/null; then
        print_status "pass" "PyYAML installed and working"
    else
        print_status "fail" "PyYAML not available or not working"
        return 1
    fi
}

# Verify Node.js environment
verify_nodejs() {
    print_status "info" "Verifying Node.js environment..."

    if command -v node >/dev/null 2>&1; then
        print_status "pass" "Node.js available: $(node --version)"
    else
        print_status "fail" "Node.js not found"
        return 1
    fi

    # Check npm
    if command -v npm >/dev/null 2>&1; then
        print_status "pass" "npm available: $(npm --version)"
    else
        print_status "fail" "npm not found"
        return 1
    fi

    # Check package.json exists
    if [ -f "package.json" ]; then
        print_status "pass" "package.json found"
    else
        print_status "fail" "package.json not found"
        return 1
    fi

    # Verify package-lock integrity
    if [ -f "package-lock.json" ]; then
        if npm list --depth=0 >/dev/null 2>&1; then
            print_status "pass" "Package dependencies resolved correctly"
        else
            print_status "info" "Some package warnings detected (may be non-critical)"
            # Show specific issues
            npm list --depth=0 2>&1 | grep -E "WARN|ERROR" | head -5 || true
        fi
    else
        print_status "fail" "package-lock.json not found"
        return 1
    fi
}

# Verify system resources
verify_system() {
    print_status "info" "Verifying system resources..."

    # Check temp directory
    if [ -d "${TMPDIR:-/tmp}" ] && [ -w "${TMPDIR:-/tmp}" ]; then
        print_status "pass" "Temp directory writable: ${TMPDIR:-/tmp}"
    else
        print_status "fail" "Temp directory not writable: ${TMPDIR:-/tmp}"
        return 1
    fi

    # Check available disk space (warn if less than 1GB)
    available_space=$(df "${TMPDIR:-/tmp}" | awk 'NR==2 {print $4}')
    if [ "$available_space" -gt 1048576 ]; then  # 1GB in KB
        print_status "pass" "Sufficient disk space available"
    else
        print_status "info" "Limited disk space: $(df -h "${TMPDIR:-/tmp}" | awk 'NR==2 {print $4}') available"
    fi

    # Show memory status
    if command -v free >/dev/null 2>&1; then
        memory_info=$(free -h | awk 'NR==2 {print $7}')
        print_status "info" "Available memory: $memory_info"
    fi
}

# Main verification
main() {
    local exit_code=0

    verify_python || exit_code=1
    echo
    verify_nodejs || exit_code=1
    echo
    verify_system || exit_code=1

    echo "=============================="

    if [ $exit_code -eq 0 ]; then
        print_status "pass" "All dependency verifications passed"
    else
        print_status "fail" "Some dependency verifications failed"
    fi

    return $exit_code
}

# Run main function
main "$@"