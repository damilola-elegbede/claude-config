#!/bin/bash
# Environment Doctor - Check development environment setup
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

REPO_ROOT=$(git rev-parse --show-toplevel)

echo -e "${BLUE}🔍 Claude Config Environment Doctor${NC}"
echo "========================================"
echo

# Track overall health
ERRORS=0
WARNINGS=0
CHECKS_PASSED=0

check_pass() {
    echo -e "${GREEN}✅ $1${NC}"
    ((CHECKS_PASSED++))
}

check_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    ((WARNINGS++))
}

check_error() {
    echo -e "${RED}❌ $1${NC}"
    ((ERRORS++))
}

check_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check Git configuration
echo "🔧 Git Configuration"
echo "--------------------"

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    check_pass "Repository is a valid Git repository"
else
    check_error "Not inside a Git repository"
fi

# Check user configuration
if git config user.name >/dev/null 2>&1 && git config user.email >/dev/null 2>&1; then
    check_pass "Git user configuration: $(git config user.name) <$(git config user.email)>"
else
    check_warning "Git user not configured. Run: git config --global user.name 'Your Name' && git config --global user.email 'your@email.com'"
fi

# Check for Git hooks
echo
echo "🪝 Git Hooks"
echo "------------"

HOOKS_DIR="$REPO_ROOT/.git/hooks"
EXPECTED_HOOKS=("pre-commit" "commit-msg" "pre-push")

for hook in "${EXPECTED_HOOKS[@]}"; do
    if [[ -x "$HOOKS_DIR/$hook" ]]; then
        if [[ -L "$HOOKS_DIR/$hook" ]]; then
            check_pass "$hook hook installed (symlinked)"
        else
            check_pass "$hook hook installed"
        fi
    else
        check_warning "$hook hook not installed. Run: make install-hooks"
    fi
done

# Check system dependencies
echo
echo "📦 System Dependencies"
echo "---------------------"

REQUIRED_TOOLS=(
    "git:Git version control"
    "make:Build automation"
    "bash:Shell interpreter"
)

OPTIONAL_TOOLS=(
    "yq:YAML processor"
    "jq:JSON processor"
    "shellcheck:Shell script linter"
    "yamllint:YAML linter"
    "hadolint:Dockerfile linter"
    "python3:Python interpreter"
    "docker:Container runtime"
)

for tool_info in "${REQUIRED_TOOLS[@]}"; do
    IFS=':' read -r tool description <<< "$tool_info"
    if command -v "$tool" >/dev/null 2>&1; then
        local version=$(command "$tool" --version 2>/dev/null | head -1 || echo "unknown version")
        check_pass "$description available: $version"
    else
        check_error "$description not found. Required for basic functionality."
    fi
done

for tool_info in "${OPTIONAL_TOOLS[@]}"; do
    IFS=':' read -r tool description <<< "$tool_info"
    if command -v "$tool" >/dev/null 2>&1; then
        local version=$(command "$tool" --version 2>/dev/null | head -1 || echo "unknown version")
        check_pass "$description available: $version"
    else
        check_warning "$description not found. Some validations may be limited."
    fi
done

# Check Python dependencies
echo
echo "🐍 Python Dependencies"
echo "----------------------"

if command -v python3 >/dev/null 2>&1; then
    PYTHON_DEPS=("yaml" "json")

    for dep in "${PYTHON_DEPS[@]}"; do
        if python3 -c "import $dep" >/dev/null 2>&1; then
            check_pass "Python $dep module available"
        else
            check_warning "Python $dep module not found. Run: pip3 install pyyaml"
        fi
    done
else
    check_warning "Python3 not available. Some validation features will be limited."
fi

# Check repository structure
echo
echo "📁 Repository Structure"
echo "----------------------"

REQUIRED_DIRS=(
    ".claude/agents:Agent definitions directory"
    "scripts:Automation scripts directory"
    "docs:Documentation directory"
    "tests:Test scripts directory"
)

REQUIRED_FILES=(
    "Makefile:Build automation"
    "README.md:Project documentation"
    "CLAUDE.md:Project configuration"
)

for dir_info in "${REQUIRED_DIRS[@]}"; do
    IFS=':' read -r dir description <<< "$dir_info"
    if [[ -d "$REPO_ROOT/$dir" ]]; then
        local file_count=$(find "$REPO_ROOT/$dir" -type f | wc -l)
        check_pass "$description exists ($file_count files)"
    else
        check_error "$description missing"
    fi
done

for file_info in "${REQUIRED_FILES[@]}"; do
    IFS=':' read -r file description <<< "$file_info"
    if [[ -f "$REPO_ROOT/$file" ]]; then
        check_pass "$description exists"
    else
        check_error "$description missing"
    fi
done

# Check agent files
echo
echo "🤖 Agent Files"
echo "-------------"

if [[ -d "$REPO_ROOT/.claude/agents" ]]; then
    local agent_count=$(find "$REPO_ROOT/.claude/agents" -name "*.md" -type f | wc -l)
    check_info "Found $agent_count agent files"

    # Check for YAML front-matter
    local valid_agents=0
    local invalid_agents=0

    find "$REPO_ROOT/.claude/agents" -name "*.md" -type f | while read -r agent_file; do
        if head -1 "$agent_file" | grep -q "^---$"; then
            ((valid_agents++))
        else
            ((invalid_agents++))
            check_warning "Agent $(basename "$agent_file") missing YAML front-matter"
        fi
    done

    if [[ $invalid_agents -eq 0 ]]; then
        check_pass "All agent files have YAML front-matter"
    fi
else
    check_error "No agents directory found"
fi

# Check validation scripts
echo
echo "🔍 Validation Scripts"
echo "--------------------"

VALIDATION_SCRIPTS=(
    "scripts/validation/framework.sh:Validation framework"
    "scripts/install-hooks.sh:Hook installer"
    "tests/validate_yaml.sh:YAML validator"
)

for script_info in "${VALIDATION_SCRIPTS[@]}"; do
    IFS=':' read -r script description <<< "$script_info"
    if [[ -f "$REPO_ROOT/$script" ]]; then
        if [[ -x "$REPO_ROOT/$script" ]]; then
            check_pass "$description executable"
        else
            check_warning "$description exists but not executable"
        fi
    else
        check_warning "$description not found"
    fi
done

# Check CI/CD configuration
echo
echo "🚀 CI/CD Configuration"
echo "----------------------"

if [[ -d "$REPO_ROOT/.github/workflows" ]]; then
    local workflow_count=$(find "$REPO_ROOT/.github/workflows" -name "*.yml" -type f | wc -l)
    check_pass "GitHub Actions configured ($workflow_count workflows)"

    # Check specific workflows
    if [[ -f "$REPO_ROOT/.github/workflows/validate-agent-yaml.yml" ]]; then
        check_pass "YAML validation workflow configured"
    else
        check_warning "YAML validation workflow not found"
    fi
else
    check_warning "No GitHub Actions workflows found"
fi

# Check performance and caching
echo
echo "⚡ Performance & Caching"
echo "-----------------------"

if [[ -d "$REPO_ROOT/.validation-cache" ]]; then
    local cache_size=$(du -sh "$REPO_ROOT/.validation-cache" 2>/dev/null | cut -f1 || echo "unknown")
    check_pass "Validation cache directory exists ($cache_size)"
else
    check_info "Validation cache will be created on first run"
fi

if [[ -d "$REPO_ROOT/.validation-metrics" ]]; then
    local metrics_count=$(find "$REPO_ROOT/.validation-metrics" -name "*.jsonl" -type f | wc -l)
    check_pass "Metrics collection configured ($metrics_count files)"
else
    check_info "Metrics collection will be initialized on first run"
fi

# Run a quick validation test
echo
echo "🧪 Quick Validation Test"
echo "------------------------"

if [[ -f "$REPO_ROOT/scripts/validation/framework.sh" ]]; then
    if source "$REPO_ROOT/scripts/validation/framework.sh" 2>/dev/null; then
        check_pass "Validation framework loads successfully"

        # Test YAML validation on a sample file
        if [[ -f "$REPO_ROOT/.claude/agents/general-purpose.md" ]]; then
            if validate_yaml_frontmatter "$REPO_ROOT/.claude/agents/general-purpose.md" >/dev/null 2>&1; then
                check_pass "YAML validation working correctly"
            else
                check_warning "YAML validation test failed"
            fi
        fi
    else
        check_error "Validation framework failed to load"
    fi
else
    check_warning "Validation framework not found - run setup first"
fi

# Summary
echo
echo "📊 Health Summary"
echo "=================="

TOTAL_CHECKS=$((CHECKS_PASSED + WARNINGS + ERRORS))

echo -e "${GREEN}✅ Passed: $CHECKS_PASSED${NC}"
echo -e "${YELLOW}⚠️  Warnings: $WARNINGS${NC}"
echo -e "${RED}❌ Errors: $ERRORS${NC}"
echo "📈 Total checks: $TOTAL_CHECKS"

echo
if [[ $ERRORS -eq 0 ]]; then
    if [[ $WARNINGS -eq 0 ]]; then
        echo -e "${GREEN}🎉 Environment is perfectly configured!${NC}"
        exit 0
    else
        echo -e "${YELLOW}⚠️  Environment is mostly ready with some optional improvements available.${NC}"
        echo
        echo "🔧 Quick fixes:"
        echo "  make setup          # Install dependencies and hooks"
        echo "  pip3 install pyyaml # Install Python YAML support"
        exit 0
    fi
else
    echo -e "${RED}❌ Environment has critical issues that need attention.${NC}"
    echo
    echo "🛠️  Required actions:"
    if (( ERRORS > 0 )); then
        echo "  make setup                    # Install dependencies and hooks"
        echo "  git config user.name 'Name'  # Configure Git user"
        echo "  git config user.email 'email' # Configure Git email"
    fi
    exit 1
fi
