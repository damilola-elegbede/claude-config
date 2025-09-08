#!/bin/bash

# Setup script for Git hooks
# This script installs pre-commit and pre-push hooks for the Claude Configuration repository

set -e

echo "🔧 Setting up Git hooks for Claude Configuration..."

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if we're in the right repository - support system-configs layout
if [ ! -f "system-configs/CLAUDE.md" ] && [ ! -f "CLAUDE.md" ]; then
    echo -e "${RED}❌ This doesn't appear to be the claude-config repository${NC}"
    echo "Please run this script from the repository root"
    exit 1
fi

# Create hooks directory if it doesn't exist
mkdir -p .git/hooks

# Install pre-commit hook
if [ -f ".git/hooks/pre-commit" ]; then
    echo -e "${YELLOW}⚠️  Pre-commit hook already exists. Backing up to pre-commit.backup${NC}"
    mv .git/hooks/pre-commit .git/hooks/pre-commit.backup
fi

# Copy pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash

# Pre-commit hook for Claude Configuration Repository
# Runs fast checks that should pass before any commit
# These checks are designed to be quick (<5 seconds)

set -e

echo "🔍 Running pre-commit checks..."

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if we're in the right directory - support system-configs layout
if [ ! -f "system-configs/CLAUDE.md" ] && [ ! -f "CLAUDE.md" ]; then
    echo -e "${RED}❌ Not in claude-config repository root${NC}"
    exit 1
fi

# 1. Check for required files (fast check) - using system-configs paths
echo "📋 Checking required files..."
required_files=(
    "README.md"
    "system-configs/CLAUDE.md"
    "LICENSE"
    "tests/test.sh"
    "system-configs/.claude/commands/plan.md"
    "system-configs/.claude/commands/commit.md"
    "system-configs/.claude/commands/push.md"
    "system-configs/.claude/commands/test.md"
    "system-configs/.claude/commands/prime.md"
    "system-configs/.claude/commands/sync.md"
)

for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}❌ Missing required file: $file${NC}"
        exit 1
    fi
done
echo -e "${GREEN}✓ All required files present${NC}"

# 2. Check for large files (>1MB)
echo "📦 Checking file sizes..."
large_files=$(find . -type f -size +1M -not -path "./.git/*" -not -path "./node_modules/*" 2>/dev/null)
if [ ! -z "$large_files" ]; then
    echo -e "${YELLOW}⚠️  Warning: Large files detected (>1MB):${NC}"
    echo "$large_files"
    echo -e "${YELLOW}Consider using Git LFS for large files${NC}"
fi

# 3. Check for common mistakes
echo "🚨 Checking for common issues..."

# Check for merge conflict markers
if git diff --cached --name-only | xargs grep -l "^<<<<<<< \|^======= \|^>>>>>>> " 2>/dev/null; then
    echo -e "${RED}❌ Merge conflict markers found in staged files${NC}"
    exit 1
fi

# Check for console.log statements in JavaScript files
if git diff --cached --name-only --diff-filter=ACM | grep -E '\.(js|ts)$' | xargs grep -l "console\.log" 2>/dev/null; then
    echo -e "${YELLOW}⚠️  Warning: console.log statements found in JavaScript files${NC}"
fi

# Check for TODO comments in staged files
todo_count=$(git diff --cached --name-only | xargs grep -c "TODO\|FIXME\|HACK" 2>/dev/null | grep -v ":0" | wc -l)
if [ "$todo_count" -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Warning: Found TODO/FIXME/HACK comments in $todo_count file(s)${NC}"
fi

# 4. Check for sensitive information
echo "🔐 Checking for sensitive information..."

# Check for potential secrets
patterns=(
    "password.*=.*['\"].*['\"]"
    "api[_-]?key.*=.*['\"].*['\"]"
    "secret.*=.*['\"].*['\"]"
    "token.*=.*['\"].*['\"]"
    "private[_-]?key"
)
# Note: These are regex patterns for detecting secrets, not actual secrets

for pattern in "${patterns[@]}"; do
    if git diff --cached --name-only | xargs grep -iE "$pattern" 2>/dev/null | grep -v "example\|sample\|test\|fake\|dummy" > /dev/null; then
        echo -e "${RED}❌ Potential secrets detected in staged files${NC}"
        echo "Please review your changes for sensitive information"
        exit 1
    fi
done
echo -e "${GREEN}✓ No obvious secrets detected${NC}"

# 5. Validate file permissions
echo "🔧 Checking file permissions..."
if [ ! -x "tests/test.sh" ]; then
    echo -e "${YELLOW}⚠️  Warning: tests/test.sh is not executable${NC}"
    echo "Run: chmod +x tests/test.sh"
fi

# 6. Quick markdown syntax check (basic)
echo "📝 Running basic markdown validation..."
markdown_files=$(git diff --cached --name-only --diff-filter=ACM | grep '\.md$' || true)
if [ ! -z "$markdown_files" ]; then
    for file in $markdown_files; do
        # Check for broken markdown links
        if grep -E '\[.*\]\(\s*\)' "$file" > /dev/null 2>&1; then
            echo -e "${YELLOW}⚠️  Warning: Empty markdown links found in $file${NC}"
        fi

        # Check for unmatched code blocks
        open_blocks=$(grep -c '^```' "$file" || echo 0)
        if [ $((open_blocks % 2)) -ne 0 ]; then
            echo -e "${YELLOW}⚠️  Warning: Unmatched code blocks in $file${NC}"
        fi
    done
fi

echo -e "${GREEN}✅ Pre-commit checks passed!${NC}"
echo "Run 'git push' to trigger comprehensive CI/CD checks"
EOF

chmod +x .git/hooks/pre-commit
echo -e "${GREEN}✓ Pre-commit hook installed${NC}"

# Install pre-push hook
if [ -f ".git/hooks/pre-push" ]; then
    echo -e "${YELLOW}⚠️  Pre-push hook already exists. Backing up to pre-push.backup${NC}"
    mv .git/hooks/pre-push .git/hooks/pre-push.backup
fi

# Copy pre-push hook
cat > .git/hooks/pre-push << 'EOF'
#!/bin/bash

# Pre-push hook for Claude Configuration Repository
# Runs comprehensive checks before pushing to remote
# These are more thorough than pre-commit but may take longer

set -e

echo "🚀 Running pre-push checks..."

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if we're in the right directory - support system-configs layout
if [ ! -f "system-configs/CLAUDE.md" ] && [ ! -f "CLAUDE.md" ]; then
    echo -e "${RED}❌ Not in claude-config repository root${NC}"
    exit 1
fi

# Get the remote and branch being pushed to
remote="$1"
url="$2"

echo -e "${BLUE}📍 Pushing to: $remote ($url)${NC}"

# 1. Run the full test suite
echo -e "${BLUE}🧪 Running test suite...${NC}"
if [ -f "tests/test.sh" ]; then
    if [ ! -x "tests/test.sh" ]; then
        chmod +x tests/test.sh
        echo "Made tests/test.sh executable"
    fi

    # Run tests and capture output
    if ./tests/test.sh > test-output.log 2>&1; then
        echo -e "${GREEN}✓ All tests passed${NC}"
        rm -f test-output.log
    else
        echo -e "${RED}❌ Tests failed${NC}"
        echo "Test output:"
        tail -20 test-output.log
        rm -f test-output.log
        exit 1
    fi
else
    echo -e "${YELLOW}⚠️  No test suite found${NC}"
fi

# 2. Validate YAML files in agents directory - using system-configs path
echo -e "${BLUE}📄 Validating agent YAML frontmatter...${NC}"
if [ -f "scripts/validate_yaml.sh" ]; then
    chmod +x scripts/validate_yaml.sh 2>/dev/null || true
    if ./scripts/validate_yaml.sh > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Agent YAML validation passed${NC}"
    else
        echo -e "${YELLOW}⚠️  Some agent files have invalid YAML${NC}"
    fi
else
    # Basic YAML validation fallback - using system-configs path
    agent_files=$(find system-configs/.claude/agents -name "*.md" 2>/dev/null || true)
    if [ ! -z "$agent_files" ]; then
        invalid_count=0
        for file in $agent_files; do
            # Check if file has YAML frontmatter
            if head -1 "$file" | grep -q "^---$"; then
                # Extract YAML frontmatter and do basic validation
                yaml_end=$(grep -n "^---$" "$file" | head -2 | tail -1 | cut -d: -f1)
                if [ -z "$yaml_end" ]; then
                    echo -e "${YELLOW}⚠️  Invalid YAML frontmatter in $file${NC}"
                    ((invalid_count++))
                fi
            fi
        done
        if [ $invalid_count -eq 0 ]; then
            echo -e "${GREEN}✓ Basic YAML validation passed${NC}"
        fi
    fi
fi

# 3. Check markdown files with markdownlint
echo -e "${BLUE}📝 Linting markdown files...${NC}"
if command -v npx &> /dev/null; then
    # Check if markdownlint-cli2 is available
    if npx markdownlint-cli2 --version > /dev/null 2>&1; then
        if [ -f ".markdownlint-cli2.jsonc" ]; then
            # Capture lint output
            lint_output=$(npx markdownlint-cli2 "**/*.md" 2>&1)
            lint_status=$?

            if [ $lint_status -eq 0 ]; then
                echo -e "${GREEN}✓ Markdown linting passed${NC}"
            else
                echo -e "${RED}❌ Markdown linting failed${NC}"
                echo "Linting errors:"
                echo "$lint_output" | head -20
                echo ""
                echo "Fix markdown linting errors before pushing."
                echo "Run 'npx markdownlint-cli2 \"**/*.md\"' to see all issues."
                exit 1
            fi
        else
            echo -e "${YELLOW}⚠️  No markdownlint config found, skipping${NC}"
        fi
    else
        echo "Installing markdownlint-cli2 locally..."
        if npm install --no-save markdownlint-cli2 > /dev/null 2>&1; then
            # Try running after install
            if npx markdownlint-cli2 "**/*.md" > /dev/null 2>&1; then
                echo -e "${GREEN}✓ Markdown linting passed${NC}"
            else
                echo -e "${RED}❌ Markdown linting failed${NC}"
                echo "Run 'npx markdownlint-cli2 \"**/*.md\"' to see issues."
                exit 1
            fi
        else
            echo -e "${YELLOW}⚠️  Could not install markdownlint, skipping${NC}"
        fi
    fi
else
    echo -e "${YELLOW}⚠️  npx not available, skipping markdown linting${NC}"
fi

# 4. Check branch protection (for main/master)
current_branch=$(git rev-parse --abbrev-ref HEAD)
echo -e "${BLUE}🌿 Current branch: $current_branch${NC}"

if [[ "$current_branch" == "main" ]] || [[ "$current_branch" == "master" ]]; then
    echo -e "${YELLOW}⚠️  Warning: Pushing directly to $current_branch${NC}"
    echo "Consider creating a feature branch and pull request instead"

    # Give user a chance to cancel
    echo -n "Continue pushing to $current_branch? (y/N): "
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo -e "${RED}Push cancelled${NC}"
        exit 1
    fi
fi

# 5. Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo -e "${YELLOW}⚠️  Warning: You have uncommitted changes${NC}"
    git status --short
fi

# 6. Validate command files structure - using system-configs path
echo -e "${BLUE}📂 Validating command files...${NC}"
command_files=$(find system-configs/.claude/commands -name "*.md" -not -name "README.md" 2>/dev/null || true)
if [ ! -z "$command_files" ]; then
    invalid_commands=0
    for cmd in $command_files; do
        # Check if file has YAML frontmatter (new template format)
        if grep -q "^---$" "$cmd"; then
            # New template format - check required sections
            if ! grep -q "^## Usage" "$cmd"; then
                echo -e "${YELLOW}⚠️  Missing Usage section in $cmd${NC}"
                ((invalid_commands++))
            fi
            if ! grep -q "^## Description" "$cmd"; then
                echo -e "${YELLOW}⚠️  Missing Description section in $cmd${NC}"
                ((invalid_commands++))
            fi
            if ! grep -q "^## Expected Output" "$cmd"; then
                echo -e "${YELLOW}⚠️  Missing Expected Output section in $cmd${NC}"
                ((invalid_commands++))
            fi
        else
            # Legacy format - check traditional sections
            if ! grep -q "^## Description" "$cmd"; then
                echo -e "${YELLOW}⚠️  Missing Description section in $cmd${NC}"
                ((invalid_commands++))
            fi
            if ! grep -q "^## Usage" "$cmd"; then
                echo -e "${YELLOW}⚠️  Missing Usage section in $cmd${NC}"
                ((invalid_commands++))
            fi
        fi
    done
    if [ $invalid_commands -eq 0 ]; then
        echo -e "${GREEN}✓ All command files have required sections${NC}"
    fi
fi

# 7. Check file sizes before push
echo -e "${BLUE}📦 Checking for large files...${NC}"
large_files=$(find . -type f -size +5M -not -path "./.git/*" -not -path "./node_modules/*" 2>/dev/null || true)
if [ ! -z "$large_files" ]; then
    echo -e "${RED}❌ Large files detected (>5MB):${NC}"
    echo "$large_files"
    echo -e "${RED}Use Git LFS for large files or exclude them${NC}"
    exit 1
fi

# 8. Final summary
echo ""
echo -e "${GREEN}╔══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║    ✅ All pre-push checks passed!    ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════╝${NC}"
echo ""
echo "Proceeding with push to $remote..."
EOF

chmod +x .git/hooks/pre-push
echo -e "${GREEN}✓ Pre-push hook installed${NC}"

echo ""
echo -e "${GREEN}╔══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║    ✅ Git hooks setup complete!      ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════╝${NC}"
echo ""
echo "Hooks installed:"
echo "  • pre-commit: Fast checks before each commit"
echo "  • pre-push: Comprehensive tests before pushing"
echo ""
echo -e "${YELLOW}Note: Team policy prohibits using --no-verify flags${NC}"
echo "Always fix quality gate failures rather than bypassing them"