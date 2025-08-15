#!/bin/bash
# Git Hooks Installer - Universal hook installation with cross-platform support
set -euo pipefail

REPO_ROOT=$(git rev-parse --show-toplevel)
HOOKS_DIR="$REPO_ROOT/.git/hooks"
SCRIPTS_DIR="$REPO_ROOT/scripts/hooks"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

echo -e "${BLUE}🔧 Installing Git Hooks${NC}"
echo "======================="

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    log_error "Not inside a Git repository"
    exit 1
fi

# Create hooks directory if it doesn't exist
mkdir -p "$HOOKS_DIR"
mkdir -p "$SCRIPTS_DIR"

# Backup existing hooks
backup_existing_hooks() {
    local hooks_to_install=("pre-commit" "commit-msg" "pre-push" "prepare-commit-msg" "post-commit")

    for hook in "${hooks_to_install[@]}"; do
        if [[ -f "$HOOKS_DIR/$hook" ]] && [[ ! -L "$HOOKS_DIR/$hook" ]]; then
            local backup_name="$hook.backup.$(date +%Y%m%d_%H%M%S)"
            mv "$HOOKS_DIR/$hook" "$HOOKS_DIR/$backup_name"
            log_warning "Backed up existing $hook to $backup_name"
        fi
    done
}

# Create hook scripts if they don't exist
create_hook_scripts() {

    # Pre-commit hook
    if [[ ! -f "$SCRIPTS_DIR/pre-commit.sh" ]]; then
        cat > "$SCRIPTS_DIR/pre-commit.sh" << 'EOF'
#!/bin/bash
# Pre-commit hook with comprehensive validation
set -euo pipefail

REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT"

# Load validation framework
if [[ -f "scripts/validation/framework.sh" ]]; then
    source "scripts/validation/framework.sh"
else
    echo "❌ Validation framework not found"
    exit 1
fi

echo "🔍 Running pre-commit validation..."

# Execute validation pipeline
VALIDATION_RESULTS=()
EXIT_CODE=0

# 1. YAML Validation
if ! run_validation "yaml" "YAML Front-matter validation"; then
    EXIT_CODE=1
fi

# 2. File Format Validation
if ! run_validation "format" "File format validation"; then
    EXIT_CODE=1
fi

# 3. Security Checks
if ! run_validation "security" "Security validation"; then
    EXIT_CODE=1
fi

# 4. Documentation Consistency
if ! run_validation "docs" "Documentation consistency"; then
    EXIT_CODE=1
fi

# Report results
if [[ ${#VALIDATION_RESULTS[@]} -gt 0 ]]; then
    print_validation_summary "${VALIDATION_RESULTS[@]}"
fi

if [[ $EXIT_CODE -ne 0 ]]; then
    echo ""
    echo "❌ Pre-commit validation failed."
    echo "💡 Quick fixes:"
    echo "  make fix-all        # Auto-fix common issues"
    echo "  make validate-yaml  # Check specific validation"
    echo "  git commit --no-verify  # Skip validation (emergency only)"
fi

exit $EXIT_CODE
EOF
        chmod +x "$SCRIPTS_DIR/pre-commit.sh"
        log_success "Created pre-commit hook script"
    fi

    # Commit message hook
    if [[ ! -f "$SCRIPTS_DIR/commit-msg.sh" ]]; then
        cat > "$SCRIPTS_DIR/commit-msg.sh" << 'EOF'
#!/bin/bash
# Commit message validation hook
set -euo pipefail

COMMIT_MSG_FILE="$1"
REPO_ROOT=$(git rev-parse --show-toplevel)

# Read commit message
COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

# Skip validation for merge commits
if echo "$COMMIT_MSG" | grep -q "^Merge "; then
    exit 0
fi

# Skip validation for revert commits
if echo "$COMMIT_MSG" | grep -q "^Revert "; then
    exit 0
fi

# Basic commit message validation
if [[ ${#COMMIT_MSG} -lt 10 ]]; then
    echo "❌ Commit message too short (minimum 10 characters)"
    exit 1
fi

if [[ ${#COMMIT_MSG} -gt 72 ]]; then
    echo "⚠️  Commit message is quite long (>72 characters)"
    echo "Consider using a shorter subject line with a detailed body"
fi

# Check for conventional commit format (optional)
if [[ "$COMMIT_MSG" =~ ^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: ]]; then
    echo "✅ Conventional commit format detected"
fi

exit 0
EOF
        chmod +x "$SCRIPTS_DIR/commit-msg.sh"
        log_success "Created commit-msg hook script"
    fi

    # Pre-push hook
    if [[ ! -f "$SCRIPTS_DIR/pre-push.sh" ]]; then
        cat > "$SCRIPTS_DIR/pre-push.sh" << 'EOF'
#!/bin/bash
# Pre-push hook for final validation
set -euo pipefail

REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT"

remote="$1"
url="$2"

echo "🚀 Running pre-push validation for $remote ($url)..."

# Load validation framework
if [[ -f "scripts/validation/framework.sh" ]]; then
    source "scripts/validation/framework.sh"
else
    echo "❌ Validation framework not found"
    exit 1
fi

# Run comprehensive validation before push
VALIDATION_RESULTS=()
EXIT_CODE=0

# Quick validation of all files
if ! run_validation "yaml" "Final YAML validation"; then
    EXIT_CODE=1
fi

if ! run_validation "security" "Final security check"; then
    EXIT_CODE=1
fi

# Check for any unstaged changes
if ! git diff-index --quiet HEAD --; then
    echo "⚠️  Warning: You have unstaged changes"
    echo "Consider committing or stashing them before pushing"
fi

if [[ $EXIT_CODE -ne 0 ]]; then
    echo "❌ Pre-push validation failed"
    echo "Push aborted for safety"
    exit 1
fi

echo "✅ Pre-push validation passed"
exit 0
EOF
        chmod +x "$SCRIPTS_DIR/pre-push.sh"
        log_success "Created pre-push hook script"
    fi

    # Prepare commit message hook
    if [[ ! -f "$SCRIPTS_DIR/prepare-commit-msg.sh" ]]; then
        cat > "$SCRIPTS_DIR/prepare-commit-msg.sh" << 'EOF'
#!/bin/bash
# Prepare commit message hook
set -euo pipefail

COMMIT_MSG_FILE="$1"
COMMIT_SOURCE="$2"
SHA1="$3"

# Only modify the message for regular commits (not merges, squashes, etc.)
if [[ -z "$COMMIT_SOURCE" ]]; then
    # Get current branch name
    BRANCH_NAME=$(git symbolic-ref --short HEAD 2>/dev/null || echo "detached")

    # Extract ticket number from branch name (e.g., feature/ABC-123-description -> ABC-123)
    if [[ "$BRANCH_NAME" =~ ([A-Z]+-[0-9]+) ]]; then
        TICKET="${BASH_REMATCH[1]}"

        # Check if commit message already contains the ticket
        if ! grep -q "$TICKET" "$COMMIT_MSG_FILE"; then
            # Prepend ticket to commit message
            sed -i.bak "1s/^/$TICKET: /" "$COMMIT_MSG_FILE"
            rm -f "$COMMIT_MSG_FILE.bak"
        fi
    fi
fi

exit 0
EOF
        chmod +x "$SCRIPTS_DIR/prepare-commit-msg.sh"
        log_success "Created prepare-commit-msg hook script"
    fi

    # Post-commit hook
    if [[ ! -f "$SCRIPTS_DIR/post-commit.sh" ]]; then
        cat > "$SCRIPTS_DIR/post-commit.sh" << 'EOF'
#!/bin/bash
# Post-commit hook for notifications and cleanup
set -euo pipefail

REPO_ROOT=$(git rev-parse --show-toplevel)
COMMIT_HASH=$(git rev-parse HEAD)
COMMIT_MSG=$(git log -1 --pretty=%B)

# Record commit metrics
if [[ -f "scripts/monitoring/collect-metrics.sh" ]]; then
    source "scripts/monitoring/collect-metrics.sh"
    collect_commit_metrics
fi

# Success notification
echo "✅ Commit successful: ${COMMIT_HASH:0:8}"

# Optional: Play success sound (macOS)
if [[ "$(uname -s)" == "Darwin" ]] && command -v afplay >/dev/null 2>&1; then
    afplay /System/Library/Sounds/Glass.aiff 2>/dev/null &
fi

exit 0
EOF
        chmod +x "$SCRIPTS_DIR/post-commit.sh"
        log_success "Created post-commit hook script"
    fi
}

# Install hooks by creating symlinks
install_hooks() {
    local hooks=("pre-commit" "commit-msg" "pre-push" "prepare-commit-msg" "post-commit")

    for hook in "${hooks[@]}"; do
        local hook_script="$SCRIPTS_DIR/$hook.sh"
        local hook_link="$HOOKS_DIR/$hook"

        if [[ -f "$hook_script" ]]; then
            # Create relative symlink
            local relative_path=$(python3 -c "
import os.path
print(os.path.relpath('$hook_script', '$HOOKS_DIR'))
" 2>/dev/null || echo "../../scripts/hooks/$hook.sh")

            ln -sf "$relative_path" "$hook_link"
            chmod +x "$hook_link"
            log_success "Installed $hook hook"
        else
            log_warning "$hook script not found at $hook_script"
        fi
    done
}

# Detect and integrate with existing hook managers
detect_hook_managers() {
    # Check for pre-commit framework
    if [[ -f "$REPO_ROOT/.pre-commit-config.yaml" ]]; then
        log_info "Pre-commit framework detected"
        if command -v pre-commit >/dev/null 2>&1; then
            log_info "Installing pre-commit framework hooks..."
            pre-commit install --install-hooks
            log_success "Pre-commit framework hooks installed"
        else
            log_warning "Pre-commit framework config found but pre-commit not installed"
            echo "Install with: pip install pre-commit"
        fi
    fi

    # Check for Husky (Node.js)
    if [[ -f "$REPO_ROOT/package.json" ]] && grep -q "husky" "$REPO_ROOT/package.json"; then
        log_info "Husky detected in package.json"
        if command -v npx >/dev/null 2>&1; then
            log_info "Installing Husky hooks..."
            cd "$REPO_ROOT"
            npx husky install
            log_success "Husky hooks installed"
        else
            log_warning "Husky detected but npm/npx not available"
        fi
    fi
}

# Test hooks installation
test_hooks() {
    log_info "Testing hook installation..."

    # Test pre-commit hook
    if [[ -x "$HOOKS_DIR/pre-commit" ]]; then
        # Create a temporary test change
        echo "# Test comment" >> "$REPO_ROOT/test-hook-validation.tmp"
        git add "$REPO_ROOT/test-hook-validation.tmp"

        if "$HOOKS_DIR/pre-commit"; then
            log_success "Pre-commit hook test passed"
        else
            log_warning "Pre-commit hook test failed (this might be expected)"
        fi

        # Clean up
        git reset HEAD "$REPO_ROOT/test-hook-validation.tmp" >/dev/null 2>&1 || true
        rm -f "$REPO_ROOT/test-hook-validation.tmp"
    fi
}

# Main installation process
main() {
    log_info "Starting hook installation process..."

    # Step 1: Backup existing hooks
    backup_existing_hooks

    # Step 2: Create hook scripts
    create_hook_scripts

    # Step 3: Install hooks
    install_hooks

    # Step 4: Detect and integrate with hook managers
    detect_hook_managers

    # Step 5: Test installation
    test_hooks

    echo
    log_success "Git hooks installation complete!"
    echo
    echo "📝 Installed hooks:"
    echo "  • pre-commit: Validates YAML, format, security, and docs"
    echo "  • commit-msg: Validates commit message format"
    echo "  • pre-push: Final validation before push"
    echo "  • prepare-commit-msg: Auto-formats commit messages"
    echo "  • post-commit: Success notifications and metrics"
    echo
    echo "🔧 Hook management:"
    echo "  make install-hooks  # Reinstall hooks"
    echo "  git config core.hooksPath \"\"  # Disable hooks"
    echo "  git commit --no-verify  # Skip pre-commit (emergency only)"
    echo
    echo "🧪 Test your setup:"
    echo "  make doctor  # Check environment health"
    echo "  make validate-all  # Test validation manually"
}

# Error handling
trap 'log_error "Hook installation failed"; exit 1' ERR

# Run main installation
main "$@"
