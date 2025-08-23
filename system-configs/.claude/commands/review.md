# /review Command

## Description

CodeRabbit-inspired AI code review combining linting tools, security scanning, and AI synthesis
to generate structured reports with "Prompts for AI Agents" sections.

## Usage

```bash
/review                    # Review changed files with tool integration
/review --full             # Full repository review  
/review <file|directory>   # Review specific target
/review --fix             # Auto-fix safe issues + commit
/review --security        # Security-focused analysis
```

## Behavior

**Multi-Layer Analysis:**
1. **Tool Pipeline**: Runs available linters (ESLint, Semgrep, Gitleaks, etc.) in parallel
2. **AI Synthesis**: Processes tool outputs with contextual reasoning
3. **Structured Report**: CodeRabbit-style output with "Prompts for AI Agents"

**Default**: Reviews changed files only for fast feedback
**--full**: Comprehensive repository analysis with all tools

## Tool Integration

### Core Tools (Auto-detected)
```yaml
JavaScript/TypeScript: ESLint, Prettier
Python: Ruff, Pylint, Bandit
Go: golangci-lint, gosec  
Security: Semgrep, Gitleaks, OSV-Scanner
Infrastructure: Hadolint, Checkov
Documentation: markdownlint, ShellCheck
```

### Execution Strategy
- **Language Detection**: Auto-run appropriate tools based on file extensions
- **Parallel Execution**: All tools run simultaneously for speed
- **Graceful Degradation**: Skip missing tools, continue with available ones
- **JSON Collection**: Gather all tool outputs for AI synthesis

## Implementation

```bash
# CodeRabbit-style review execution
run_coderabbit_review() {
  local target="${1:-$(git diff --name-only main...HEAD || echo '.')}"
  local mode="$2"

  echo "🤖 CodeRabbit-style AI review..."
  
  # Detect languages and run tools
  detect_and_run_tools() {
    local files="$1"
    
    # JavaScript/TypeScript
    if echo "$files" | grep -q '\.\(js\|jsx\|ts\|tsx\)$'; then
      run_tool "npx eslint $files --format json" "ESLint"
      run_tool "npx prettier --check $files" "Prettier"  
    fi
    
    # Python
    if echo "$files" | grep -q '\.py$'; then
      run_tool "ruff check $files --format json" "Ruff"
      run_tool "bandit -r $files -f json" "Bandit"
    fi
    
    # Go
    if echo "$files" | grep -q '\.go$'; then
      run_tool "golangci-lint run $files --out-format json" "golangci-lint"
      run_tool "gosec -fmt json $files" "gosec"
    fi
    
    # Universal security tools
    run_tool "semgrep --config=auto $files --json" "Semgrep"
    run_tool "gitleaks detect --source $files --report-format json" "Gitleaks"
    
    # Documentation
    if echo "$files" | grep -q '\.md$'; then
      run_tool "markdownlint $files --json" "markdownlint"
    fi
  }
  
  run_tool() {
    local cmd="$1"
    local tool="$2"
    
    if command -v $(echo "$cmd" | cut -d' ' -f1) >/dev/null; then
      echo "  ✅ $tool: Running..."
      eval "$cmd" > "/tmp/${tool,,}_results.json" 2>/dev/null || echo "  ⚠️ $tool: Issues found"
    else
      echo "  ⏭️ $tool: Not available, skipping"
    fi
  }
  
  # Run tool pipeline
  detect_and_run_tools "$target"
  
  # AI synthesis and report generation
  echo "🧠 AI synthesis: Processing tool outputs..."
  echo "📝 Generating CodeRabbit-style report..."
}

# Auto-fix mode
run_autofix() {
  echo "🔧 Auto-fixing safe issues..."
  
  # Apply auto-fixes
  command -v eslint >/dev/null && npx eslint --fix . 2>/dev/null
  command -v prettier >/dev/null && npx prettier --write . 2>/dev/null  
  command -v ruff >/dev/null && ruff check --fix . 2>/dev/null
  
  # Commit fixes if any changes made
  if ! git diff --quiet; then
    git add .
    git commit -m "fix: apply automated linting fixes

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"
    echo "✅ Auto-fixes committed"
  else
    echo "ℹ️ No auto-fixable issues found"
  fi
}
```

## Report Format

### CodeRabbit-Style Output
```markdown
# 🤖 AI Code Review Report

## Summary
**Target**: 3 files | **Tools**: 8 executed | **Issues**: 2 Critical, 1 High  
**Status**: ⚠️ Needs Attention | **Estimated Fix Time**: 15 minutes

## 🔴 Critical Issues (2)
1. **SQL Injection** - `auth/login.js:45` (Semgrep)
   - Use parameterized queries: `db.query('SELECT * FROM users WHERE id = ?', [id])`

2. **Hardcoded Secret** - `config/api.js:12` (Gitleaks)  
   - Move to environment: `const API_KEY = process.env.API_KEY`

## 🟠 High Priority (1)
1. **N+1 Query** - `api/users.js:67` (Custom Analysis)
   - Use JOIN or prefetch to optimize database queries

## Prompts for AI Agents
### Security Fixes
- Fix SQL injection in login endpoint using parameterized queries
- Replace hardcoded API key with environment variable configuration
- Add input validation for all authentication endpoints

### Performance Optimizations  
- Optimize N+1 query pattern in user data retrieval
- Implement caching for frequently accessed user data

### Testing Improvements
- Add test coverage for payment processing logic
- Create integration tests for authentication flow

## 📊 Tool Summary
- ESLint: 5 style issues (3 auto-fixable)  
- Semgrep: 1 SQL injection vulnerability
- Gitleaks: 1 hardcoded secret detected
- Custom Analysis: 1 performance issue

## 🎯 Next Steps
1. Fix SQL injection (Critical - blocks merge)
2. Remove hardcoded secret (Critical - security risk)  
3. Optimize N+1 queries (High - performance impact)
```

## Examples

### Standard Review
```bash
User: /review
Claude: 🤖 CodeRabbit-style AI review...
  ✅ ESLint: Running...
  ⚠️ ESLint: Issues found
  ✅ Semgrep: Running...  
  ⚠️ Semgrep: Issues found
  ⏭️ Ruff: Not available, skipping
🧠 AI synthesis: Processing tool outputs...
📝 Generating CodeRabbit-style report...

# 🤖 AI Code Review Report
## Summary: 2 Critical, 1 High issue found
## Prompts for AI Agents ready for automated remediation
```

### Auto-Fix Mode
```bash  
User: /review --fix
Claude: 🔧 Auto-fixing safe issues...
✅ ESLint: Fixed 8 style issues
✅ Prettier: Applied formatting to 12 files
✅ Auto-fixes committed
⚠️ Manual fixes needed: 2 security issues (see report)
```

### Security Focus
```bash
User: /review --security  
Claude: 🔒 Security-focused analysis...
  ✅ Semgrep: Running security rules...
  ✅ Gitleaks: Scanning for secrets...
  ✅ Bandit: Python security analysis...
🚨 Found: 1 SQL injection, 1 hardcoded secret
📝 Security report with remediation prompts generated
```

## Notes

**CodeRabbit-Inspired Features:**
- **Tool Integration**: Auto-detects and runs appropriate linters/security scanners
- **AI Synthesis**: Processes all tool outputs with intelligent reasoning  
- **Structured Reports**: Markdown format with issue classification and metrics
- **"Prompts for AI Agents"**: Actionable remediation instructions for automation
- **Auto-Fix Capability**: Applies safe fixes and commits them automatically

**Core Capabilities:**
- **Fast Feedback**: Default mode reviews only changed files
- **Comprehensive Analysis**: --full mode for complete repository review
- **Security Focus**: Specialized security scanning with --security mode  
- **Development Integration**: Works with existing toolchains and workflows
- **Quality Gates**: Blocks critical issues while allowing minor improvements

**Efficiency:**
- **Parallel Execution**: All tools run simultaneously for maximum speed
- **Graceful Degradation**: Continues with available tools if some are missing
- **Smart Targeting**: Reviews changed files by default, full repo when requested
- **Report Persistence**: Saves detailed analysis for audit trails and team review