# /push Command

## Description

Safely pushes changes to remote repository with optional quality gates.
Supports both simple push mode and comprehensive quality-checked push.

## Usage

```bash
/push                        # Full quality gate push
/push --simple               # Quick push without quality checks
/push --force                # Force push (use carefully)
/push --dry-run             # Preview what would be pushed
```

## Behavior

When invoked, I will safely push changes to the remote repository. Simple mode
performs basic safety checks and pushes quickly. Full mode runs comprehensive
quality gates including tests, linting, code review, and security scanning
before pushing.

## Two-Mode Operation

### Simple Mode (--simple) - Quick Push

**What it does**: Basic safety checks then push

```yaml
Checks Performed:
  - Verify not on main/master branch
  - Ensure no uncommitted changes
  - Check branch has commits to push
  - Set upstream tracking if needed

Agent Usage: None
Duration: 10-15 seconds
```

### Full Mode (default) - Quality Gate Push

**What it does**: Comprehensive quality validation

```yaml
Quality Gates:
  - Run test suite (test-engineer if failures)
  - Comprehensive linting with auto-fix
  - Code review with automated remediation
  - Security scan for vulnerabilities
  - Generate quality reports

Agent Usage: Multiple specialists as needed
Duration: 2-5 minutes depending on issues found
```

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
```

### Phase 2: Quality Gates (Full Mode Only)

```bash
# Comprehensive quality validation
run_quality_gates() {
  local issues_found=0
  
  echo "🧪 Running test suite..."
  if ! run_tests; then
    echo "🤖 Deploying test-engineer to fix failing tests..."
    # Deploy agent to fix tests
    ((issues_found++))
  fi
  
  echo "🔍 Running linters with auto-fix..."
  if ! run_linters_with_autofix; then
    echo "🔧 Some linting issues require manual attention"
    ((issues_found++))
  fi
  
  echo "👁️ Performing code review..."
  if ! run_automated_review; then
    echo "🤖 Deploying specialists for automated remediation..."
    # Deploy code-reviewer + specialists
    ((issues_found++))
  fi
  
  return $issues_found
}
```

### Phase 3: Auto-Fix Integration

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
```

## Agent Coordination Strategy

### Simple Mode (No Agents)

```yaml
Operations:
  - Direct git commands only
  - Basic validation checks
  - No quality analysis
  
Benefits:
  - Fast execution (10-15 seconds)
  - No agent overhead
  - Perfect for hot fixes
```

### Full Mode (Multi-Agent)

```yaml
Quality Gate Agents:
  test-engineer:
    trigger: "Test failures detected"
    role: "Fix failing tests, add missing coverage"
    
  code-reviewer:
    trigger: "Always for full mode"
    role: "Identify code quality issues"
    
  backend-engineer:
    trigger: "Server-side code issues"
    role: "Fix backend linting and logic issues"
    
  frontend-architect:
    trigger: "Client-side code issues"
    role: "Fix frontend linting and performance"
    
  security-auditor:
    trigger: "Security vulnerabilities found"
    role: "Patch security issues before push"

Coordination Pattern:
  1. Run quality checks in parallel
  2. Deploy agents based on issues found
  3. Allow agents to auto-remediate
  4. Re-run checks after fixes
  5. Generate comprehensive report
```

## Concrete Quality Checks

### Test Execution

```bash
# Universal test runner
run_tests() {
  if [ -f "package.json" ] && npm run test 2>/dev/null; then
    echo "✅ npm tests passed"
  elif [ -f "requirements.txt" ] && python -m pytest 2>/dev/null; then
    echo "✅ Python tests passed"
  elif [ -f "go.mod" ] && go test ./... 2>/dev/null; then
    echo "✅ Go tests passed"
  elif [ -f "Cargo.toml" ] && cargo test 2>/dev/null; then
    echo "✅ Rust tests passed"
  else
    echo "⚠️ No test framework detected or tests failed"
    return 1
  fi
}
```

### Security Scanning

```bash
# Quick security checks
run_security_scan() {
  local security_issues=0
  
  # Dependency vulnerabilities
  if [ -f "package.json" ] && npm audit --audit-level high; then
    echo "⚠️ npm security vulnerabilities found"
    ((security_issues++))
  fi
  
  # Secrets detection
  if command -v git-secrets >/dev/null && ! git secrets --scan; then
    echo "⚠️ Potential secrets detected in code"
    ((security_issues++))
  fi
  
  # Basic pattern matching for common issues
  if grep -r "password\s*=" . --include="*.js" --include="*.py" --include="*.go"; then
    echo "⚠️ Hardcoded passwords detected"
    ((security_issues++))
  fi
  
  return $security_issues
}
```

## Quality Report Generation

### Comprehensive Report

```markdown
# Push Quality Report

## Summary
- **Branch**: feature/user-authentication
- **Commits**: 3 commits ready to push
- **Quality Gates**: 4/5 passed
- **Auto-fixes Applied**: 12 formatting issues

## Test Results ✅
- **Test Suite**: All 47 tests passed
- **Coverage**: 85.3% (target: 80%)
- **Duration**: 23.4 seconds

## Linting Results ✅
- **ESLint**: 8 issues auto-fixed
- **Prettier**: 4 formatting issues resolved
- **Markdown**: 2 line length violations fixed

## Code Review ⚠️
- **Issues Found**: 3 medium-priority suggestions
- **Auto-Fixed**: 2/3 issues resolved by agents
- **Remaining**: 1 issue requires manual review

## Security Scan ✅
- **Vulnerabilities**: None detected
- **Secrets**: No leaked credentials found
- **Dependencies**: All security patches applied

## Recommendation
✅ **Safe to push** - All critical issues resolved
```

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
```

### Quality Gate Push

```bash
User: /push
Claude: 🛡️ Running quality gates...
🧪 Testing... ✅ All 47 tests passed
🔍 Linting... 🔧 Auto-fixed 8 ESLint issues
👁️ Code review... 🤖 Deploying backend-engineer for 2 issues
✅ All quality gates passed
📝 Committed auto-fixes
🚀 Pushing 4 commits to origin/feature/auth-improvements
```

### Quality Issues Found

```bash
User: /push
Claude: 🛡️ Running quality gates...
❌ Tests failed: 3/47 failing
🤖 Deploying test-engineer to fix failing tests...
✅ Tests fixed and passing
⚠️ Security scan found 1 medium vulnerability
🤖 Deploying security-auditor for remediation...
✅ Vulnerability patched
📊 Generated quality report: .tmp/reports/push-quality-report.md
🚀 All issues resolved, safe to push
```

### Blocked Push

```bash
User: /push
Claude: 🛡️ Running quality gates...
❌ Critical security vulnerability found
❌ 12 test failures detected
🛑 Push blocked until critical issues are resolved
📋 Run /review for detailed analysis
💡 Suggestion: Fix security issue, then re-run /push
```

## Execution Verification

Deploy execution-evaluator to verify:

- ✅ **Quality gates executed** - All checks ran according to mode
- ✅ **Auto-fixes committed** - Changes properly staged and committed
- ✅ **Push successful** - Commits reached remote repository
- ✅ **Branch tracking set** - Upstream configured correctly
- ✅ **No regressions** - Push didn't break existing functionality
- ✅ **Reports generated** - Quality documentation created

## Notes

- Simple mode perfect for hot fixes and trusted branches
- Full mode ensures code quality and prevents issues reaching main
- Auto-fixes are committed automatically to include in push
- Quality reports provide audit trail for compliance
- Agents only deployed when issues are detected
- Push is blocked only for critical/security issues
- All fixes are verified before push proceeds
