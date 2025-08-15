#!/bin/bash
# Setup script for shellcheck and pre-commit hooks
# This script helps developers set up shellcheck validation locally

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Setting up ShellCheck and Pre-commit Hooks${NC}"
echo "=================================================="

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install shellcheck on different platforms
install_shellcheck() {
    echo -e "${YELLOW}Installing ShellCheck...${NC}"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command_exists brew; then
            brew install shellcheck
        else
            echo -e "${RED}Homebrew not found. Please install Homebrew first or install ShellCheck manually.${NC}"
            echo "Visit: https://github.com/koalaman/shellcheck#installing"
            exit 1
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        if command_exists apt-get; then
            sudo apt-get update
            sudo apt-get install -y shellcheck
        elif command_exists yum; then
            sudo yum install -y ShellCheck
        elif command_exists dnf; then
            sudo dnf install -y ShellCheck
        elif command_exists pacman; then
            sudo pacman -S shellcheck
        else
            echo -e "${RED}Package manager not supported. Please install ShellCheck manually.${NC}"
            echo "Visit: https://github.com/koalaman/shellcheck#installing"
            exit 1
        fi
    else
        echo -e "${RED}OS not supported. Please install ShellCheck manually.${NC}"
        echo "Visit: https://github.com/koalaman/shellcheck#installing"
        exit 1
    fi

    echo -e "${GREEN}✓ ShellCheck installed successfully${NC}"
}

# Function to install pre-commit
install_precommit() {
    echo -e "${YELLOW}Installing pre-commit...${NC}"

    if command_exists pip3; then
        pip3 install pre-commit
    elif command_exists pip; then
        pip install pre-commit
    else
        echo -e "${RED}pip not found. Please install Python and pip first.${NC}"
        exit 1
    fi

    echo -e "${GREEN}✓ pre-commit installed successfully${NC}"
}

# Function to setup pre-commit hooks
setup_precommit_hooks() {
    echo -e "${YELLOW}Setting up pre-commit hooks...${NC}"

    # Install the hooks
    pre-commit install

    # Run hooks on all files to test
    echo -e "${YELLOW}Running pre-commit on all files to test setup...${NC}"
    if pre-commit run --all-files; then
        echo -e "${GREEN}✓ Pre-commit hooks setup successfully${NC}"
    else
        echo -e "${YELLOW}⚠️ Some hooks found issues. This is normal for the first run.${NC}"
        echo -e "${YELLOW}The hooks are installed and will check future commits.${NC}"
    fi
}

# Function to test shellcheck setup
test_shellcheck() {
    echo -e "${YELLOW}Testing ShellCheck setup...${NC}"

    # Create a temporary test script
    cat > /tmp/test_shellcheck.sh << 'EOF'
#!/bin/bash
# Test script for shellcheck
echo "Hello, World!"
cd /nonexistent/directory
rm -rf $HOME/*
EOF

    echo "Running ShellCheck on test script..."
    if shellcheck /tmp/test_shellcheck.sh; then
        echo -e "${RED}❌ ShellCheck should have found issues with the test script${NC}"
        rm -f /tmp/test_shellcheck.sh
        exit 1
    else
        echo -e "${GREEN}✓ ShellCheck is working correctly (found expected issues)${NC}"
        rm -f /tmp/test_shellcheck.sh
    fi
}

# Function to run shellcheck on repository scripts
check_repository_scripts() {
    echo -e "${YELLOW}Checking repository shell scripts...${NC}"

    # Find all shell scripts
    scripts=$(find . -name "*.sh" \
        -not -path "./node_modules/*" \
        -not -path "./.git/*" \
        -not -path "./temp-scripts/*")

    if [ -z "$scripts" ]; then
        echo -e "${YELLOW}No shell scripts found to check${NC}"
        return 0
    fi

    echo "Found scripts to check:"
    echo "$scripts"
    echo ""

    # Check each script
    all_passed=true
    for script in $scripts; do
        echo "Checking: $script"
        if shellcheck "$script"; then
            echo -e "${GREEN}✓ $script passed${NC}"
        else
            echo -e "${RED}❌ $script has issues${NC}"
            all_passed=false
        fi
        echo ""
    done

    if $all_passed; then
        echo -e "${GREEN}✓ All repository scripts passed ShellCheck${NC}"
    else
        echo -e "${YELLOW}⚠️ Some scripts have ShellCheck warnings/errors${NC}"
        echo "Please review and fix the issues above."
    fi
}

# Main setup process
main() {
    echo -e "${BLUE}Checking prerequisites...${NC}"

    # Check if shellcheck is installed
    if ! command_exists shellcheck; then
        install_shellcheck
    else
        echo -e "${GREEN}✓ ShellCheck already installed${NC}"
        shellcheck --version
    fi

    # Check if pre-commit is installed
    if ! command_exists pre-commit; then
        install_precommit
    else
        echo -e "${GREEN}✓ pre-commit already installed${NC}"
        pre-commit --version
    fi

    echo ""
    echo -e "${BLUE}Setting up tools...${NC}"

    # Test shellcheck
    test_shellcheck

    # Setup pre-commit hooks
    setup_precommit_hooks

    echo ""
    echo -e "${BLUE}Validating repository...${NC}"

    # Check repository scripts
    check_repository_scripts

    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}Setup completed successfully!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo "What's been set up:"
    echo "• ShellCheck for shell script analysis"
    echo "• Pre-commit hooks for automated validation"
    echo "• Configuration files (.shellcheckrc, .pre-commit-config.yaml)"
    echo ""
    echo "Usage:"
    echo "• Run 'shellcheck script.sh' to check individual scripts"
    echo "• Run 'pre-commit run --all-files' to check all files"
    echo "• Hooks will automatically run on git commit"
    echo ""
    echo "CI/CD will now validate all shell scripts automatically!"
}

# Run main function
main "$@"
