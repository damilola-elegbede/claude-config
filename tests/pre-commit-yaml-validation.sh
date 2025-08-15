#!/bin/bash
# Pre-commit hook for YAML validation in agent files
# Copy this to .git/hooks/pre-commit or integrate with your pre-commit framework

# Get the repository root
REPO_ROOT=$(git rev-parse --show-toplevel)
AGENTS_DIR="$REPO_ROOT/system-configs/.claude/agents"
VALIDATION_SCRIPT="$REPO_ROOT/scripts/validate_yaml.sh"

# Check if validation script exists
if [ ! -f "$VALIDATION_SCRIPT" ]; then
    echo "Warning: YAML validation script not found at $VALIDATION_SCRIPT"
    echo "Skipping YAML validation..."
    exit 0
fi

# Get list of staged .md files in agents directory
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep "^system-configs/\.claude/agents/.*\.md$" || true)

if [ -z "$STAGED_FILES" ]; then
    # No agent files staged, nothing to validate
    exit 0
fi

echo "🔍 Running YAML validation on staged agent files..."

# Validate each staged file
ERRORS=0
for file in $STAGED_FILES; do
    if [ -f "$REPO_ROOT/$file" ]; then
        if ! bash "$VALIDATION_SCRIPT" "$REPO_ROOT/$file" > /dev/null 2>&1; then
            echo "❌ YAML validation failed for: $file"
            bash "$VALIDATION_SCRIPT" "$REPO_ROOT/$file"
            ((ERRORS++))
        fi
    fi
done

if [ $ERRORS -gt 0 ]; then
    echo ""
    echo "❌ Pre-commit hook failed: $ERRORS files have YAML validation errors"
    echo "Please fix the errors and try again."
    exit 1
fi

echo "✅ All staged agent files passed YAML validation"
exit 0
