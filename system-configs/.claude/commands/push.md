# /push Command

## Description

Safely pushes changes to remote repository using git push with optional quality gates.
Supports both simple push mode and comprehensive quality-checked push.

## Usage

```bash
/push                        # Full quality gate push
/push --simple               # Quick push without quality checks
/push --force                # Force push (use carefully)
/push --dry-run             # Preview what would be pushed
```bash

## Agent Orchestration

### Parallel Validation Phase

Deploy multiple agents simultaneously for comprehensive pre-push validation:

```yaml
tech-writer:
  role: Generate push summary and documentation updates
  input: Commit messages, changed files, push context
  output: Push summary, documentation needs, changelog updates

code-reviewer:
  role: Validate code quality and standards
  input: Changed files, commit diffs
  output: Quality issues, auto-fixable problems

security-auditor:
  role: Final security check before remote push
  input: All commits to be pushed, changed files
  output: Security vulnerabilities, sensitive data exposure
```bash

### Parallel Execution Strategy

```yaml
Pre-Push Validation:
  - All three agents run simultaneously
  - Any agent can block the push
  - Auto-fix issues in parallel where possible
  - Re-validate after fixes

Time Optimization:
  - Parallel agent execution: 5-10 seconds
  - Sequential would take: 15-30 seconds
  - 60-70% time reduction
```

## Behavior

When invoked, I will safely push changes to the remote repository with parallel
agent validation. Simple mode performs basic checks. Full mode deploys all agents
simultaneously for comprehensive validation with auto-fixing.

## Two-Mode Operation

### Simple Mode (--simple) - Quick Push

**What it does**: Basic safety checks then push

```yaml
Checks Performed:
  - Verify not on main/master branch
  - Ensure no uncommitted changes
  - Check branch has commits to push
  - Set upstream tracking if needed

Agent Usage: None (skip for speed)
Duration: 10-15 seconds
```bash

### Full Mode (default) - Parallel Agent Validation

**What it does**: Comprehensive parallel validation before push

```yaml
Parallel Validation:
  - code-reviewer: Quality and style checks
  - test-engineer: Test verification
  - security-auditor: Security scanning

All agents run simultaneously:
  - Total duration: 5-10 seconds
  - Auto-fix issues in parallel
  - Re-validate after fixes

Agent Usage: code-reviewer + test-engineer + security-auditor (parallel)
Duration: 10-20 seconds (with parallel execution)
```bash

## Push Workflow

### Phase 1: Pre-Push Validation

```bash
# Basic safety checks
validate_push_safety() {
  # Check current branch
  current_branch=$(git branch --show-current)
  if [[ "$current_branch" =~ ^(main|master)$ ]]; then
    echo "❌ Cannot push directly to $current_branch"
    return 1
  fi

  # Check for uncommitted changes
  if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "❌ Uncommitted changes detected. Commit first."
    return 1
  fi

  # Check if there's anything to push
  ahead_count=$(git rev-list --count HEAD ^origin/$current_branch 2>/dev/null || echo "0")
  if [ "$ahead_count" -eq 0 ]; then
    echo "✅ Already up to date with remote"
    return 1
  fi

  echo "📊 Ready to push $ahead_count commits"
}
```bash

### Phase 2: Basic Auto-Fixes (Full Mode Only)

```bash
# Basic linting with automatic fixes only
run_basic_fixes() {
  echo "🔍 Running basic linters with auto-fix..."

  if ! run_linters_with_autofix; then
    echo "⚠️ Some linting issues require manual attention"
    echo "💡 Run /review for comprehensive quality analysis"
    return 1
  fi

  return 0
}
```bash

### Phase 3: Linting Auto-Fix Implementation

```bash
# Linting with automatic fixes
run_linters_with_autofix() {
  local fixes_applied=0

  # JavaScript/TypeScript
  if [ -f "package.json" ]; then
    if npm run lint:fix 2>/dev/null || npx eslint . --fix; then
      echo "✅ JavaScript linting auto-fixed"
      ((fixes_applied++))
    fi

    if npx prettier --write . 2>/dev/null; then
      echo "✅ Code formatting applied"
      ((fixes_applied++))
    fi
  fi

  # Python
  if find . -name "*.py" -not -path "./venv/*" | head -1 | grep -q ".py"; then
    if command -v black >/dev/null && black . --check --diff; then
      black .
      echo "✅ Python formatting applied"
      ((fixes_applied++))
    fi

    if command -v isort >/dev/null; then
      isort .
      echo "✅ Import sorting applied"
      ((fixes_applied++))
    fi
  fi

  # Go
  if [ -f "go.mod" ]; then
    gofmt -w .
    goimports -w . 2>/dev/null
    echo "✅ Go formatting applied"
    ((fixes_applied++))
  fi

  # Markdown
  if command -v markdownlint-cli2 >/dev/null; then
    if npx markdownlint-cli2 "**/*.md" --fix; then
      echo "✅ Markdown formatting applied"
      ((fixes_applied++))
    fi
  fi

  # Commit fixes if any were applied
  if [ $fixes_applied -gt 0 ]; then
    git add .
    git commit -m "fix: apply automated formatting and linting fixes

Applied fixes:
- Code formatting and style corrections
- Import organization
- Markdown formatting compliance

Auto-generated before push to maintain quality standards."
    echo "📝 Committed $fixes_applied auto-fixes"
  fi

  return 0
}
```bash

## Push Strategy

### Simple Mode (No Processing)

```yaml
Operations:
  - Direct git commands only
  - Basic validation checks
  - No linting or processing

Benefits:
  - Fast execution (10-15 seconds)
  - No overhead
  - Perfect for hot fixes and reviewed code
```bash

### Full Mode (Basic Auto-Fix)

```yaml
Operations:
  - Basic validation checks
  - Automatic linting fixes
  - No agent deployment
  - No comprehensive quality gates

Benefits:
  - Quick formatting fixes
  - Safe push with basic validation
  - Relies on separate /review for quality
```bash

## Basic Push Report

When auto-fixes are applied, a simple report is generated:

```markdown
# Push Auto-Fix Report

## Summary
- **Branch**: feature/user-authentication
- **Commits**: 3 commits ready to push
- **Auto-fixes Applied**: 8 formatting issues

## Linting Results ✅
- **ESLint**: 5 issues auto-fixed
- **Prettier**: 2 formatting issues resolved
- **Markdown**: 1 line length violation fixed

## Recommendation
✅ **Ready to push** - Basic formatting applied
💡 **Note**: Run /review for comprehensive quality analysis
```bash

## Examples

### Simple Push

```bash
User: /push --simple
Claude: 🚀 Simple push mode...
✅ Not on main branch (feature/auth-improvements)
✅ No uncommitted changes
📊 3 commits ready to push
🔗 Setting upstream tracking...
✅ Pushed to origin/feature/auth-improvements
```bash

### Standard Push

```bash
User: /push
Claude: 🚀 Standard push with basic validation...
✅ Not on main branch (feature/auth-improvements)
✅ No uncommitted changes
📊 3 commits ready to push
🔍 Auto-fixing linting issues... 🔧 Fixed 5 ESLint issues
📝 Committed auto-fixes
🚀 Pushing 4 commits to origin/feature/auth-improvements
💡 Tip: Run /review for comprehensive quality analysis
```bash

### Push with Manual Review Needed

```bash
User: /push
Claude: 🚀 Standard push with basic validation...
✅ Basic checks passed
🔍 Auto-fixing... ⚠️ Some linting issues require manual attention
💡 Run /review for comprehensive quality analysis
🚀 Pushing 3 commits to origin/feature/auth-improvements
```bash

## Execution Verification

Deploy execution-evaluator to verify:

- ✅ **Basic validation executed** - Safety checks ran according to mode
- ✅ **Auto-fixes committed** - Linting changes properly staged and committed
- ✅ **Push successful** - Commits reached remote repository
- ✅ **Branch tracking set** - Upstream configured correctly

## Notes

- Simple mode perfect for hot fixes and already-reviewed code
- Full mode provides basic linting with auto-fix capability
- Auto-fixes are committed automatically to include in push
- Comprehensive quality gates handled by separate /review command
- Focus on safe pushing rather than comprehensive validation
- Use ship-it workflow for proper review → push sequence
