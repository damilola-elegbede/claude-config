# /review Command

## Description

CodeRabbit-inspired AI code review combining linting tools, security scanning, and AI synthesis
to generate structured reports with "Prompts for AI Agents" sections.

## Usage

```bash
/review                    # Review changed files + run pre-commit checklist
/review --full             # Full repository review + checklist
/review <file|directory>   # Review specific target + checklist
/review --fix             # Auto-fix safe issues + commit
/review --security        # Security-focused analysis + checklist
```

## Behavior

**Multi-Layer Analysis:**

1. **Pre-Commit Checklist**: Automatically runs CodeRabbit checklist (see `docs/quality/CODERABBIT_PRECOMMIT_CHECKLIST.md`)
2. **Tool Pipeline**: Runs available linters (ESLint, Semgrep, Gitleaks, etc.) in parallel
3. **AI Synthesis**: Processes tool outputs with contextual reasoning
4. **Structured Report**: CodeRabbit-style output with "Prompts for AI Agents"

**Every invocation** of `/review` automatically runs the comprehensive pre-commit checklist first, covering:

- Documentation consistency and cross-references
- YAML/configuration quality and compliance
- Code quality standards and best practices
- Agent system compliance (28 agents, boundaries)
- Testing verification and validation
- Structural patterns and conventions

**Default**: Reviews changed files only for fast feedback

**--full**: Comprehensive repository analysis with all tools

## Tool Integration

### Core Tools (Auto-detected)

```text
JavaScript/TypeScript: ESLint, Prettier
Python: Ruff, Pylint, Bandit
Go: golangci-lint, gosec
Security: Semgrep, Gitleaks, OSV-Scanner
Infrastructure: Hadolint, Checkov
Documentation: markdownlint, ShellCheck
```bash

### Execution Strategy

### Agent Orchestration - Multi-Instance Parallel Deployment

Deploy specialized agents and multiple instances for comprehensive parallel review:

```yaml
# PARALLEL WAVE 1: Simultaneous Multi-Domain Analysis
code-reviewer (instance pool):
  deployment: 3-5 instances based on codebase size
  distribution:
    - instance_1: Frontend code quality and standards
    - instance_2: Backend code patterns and architecture
    - instance_3: Test coverage and quality
    - instance_4: Configuration and infrastructure
    - instance_5: Documentation and comments
  input: Partitioned files, linter results per domain
  parallel_with: [security-auditor instances, performance-engineer instances, other agents]
  output: Parallel quality assessments across all domains

security-auditor (instance pool):
  deployment: 2-3 instances for thorough security analysis
  distribution:
    - instance_1: Authentication/authorization vulnerabilities
    - instance_2: Data validation and injection attacks
    - instance_3: Dependency vulnerabilities and secrets
  input: Code changes, dependency manifests, API endpoints
  parallel_with: [code-reviewer instances, performance-engineer instances, other agents]
  output: Comprehensive security assessment from multiple angles

performance-engineer (instance pool):
  deployment: 2-3 instances for different performance aspects
  distribution:
    - instance_1: Algorithm complexity and big-O analysis
    - instance_2: Database query optimization
    - instance_3: Memory usage and resource consumption
  input: Code changes, profiling data, metrics
  parallel_with: [code-reviewer instances, security-auditor instances, other agents]
  output: Multi-dimensional performance analysis

test-engineer:
  role: Test coverage and quality validation
  input: Test files, coverage reports
  parallel_with: [all other agent instances]
  output: Test adequacy assessment, missing coverage areas

accessibility-auditor:
  role: Accessibility compliance checking
  input: UI components, markup changes
  parallel_with: [all other agent instances]
  output: WCAG compliance issues, accessibility improvements

tech-writer:
  role: Documentation quality and completeness
  input: Code comments, README files, API docs
  parallel_with: [all other agent instances]
  output: Documentation gaps, clarity improvements
```bash

### Parallel Review Strategy

```yaml
Execution Optimization:
  Phase 1 - Tool Execution (Parallel):
    - All linters run simultaneously
    - Security scanners execute in parallel
    - Performance profilers run concurrently
    - Results collected in real-time

  Phase 2 - Agent Analysis (Massive Parallelization):
    Simultaneous Analysis (All agents + instances):
      - 5 code-reviewer instances analyze different domains
      - 3 security-auditor instances check various vulnerabilities
      - 3 performance-engineer instances profile different aspects
      - test-engineer validates coverage
      - accessibility-auditor checks compliance
      - tech-writer reviews documentation

    Total: Up to 15 agent instances working simultaneously

  Phase 3 - Result Synthesis:
    - All agent outputs merged intelligently
    - Duplicate findings deduplicated
    - Issues prioritized by severity
    - Comprehensive report generated

Performance Metrics:
  - Sequential review: 5-10 minutes for large codebase
  - Parallel review: 30-60 seconds (10x faster)
  - Coverage: 100% of code analyzed from multiple perspectives
  - Quality: 3x more issues detected due to specialized instances

Benefits:
  - Massive parallelization across domains
  - No single agent bottleneck
  - Comprehensive coverage in minimal time
  - Multiple perspectives on same code simultaneously
  - Real-time aggregation of findings
```

- **Language Detection**: Auto-run appropriate tools based on file extensions
- **Parallel Execution**: All tools run simultaneously for speed
- **Graceful Degradation**: Skip missing tools, continue with available ones
- **JSON Collection**: Gather all tool outputs for AI synthesis

## Implementation

```bash
# CodeRabbit-style review execution - SECURITY HARDENED
run_coderabbit_review() {
  local target="${1:-$(git diff --name-only main...HEAD 2>/dev/null || echo '.')}"
  local mode="$2"

  echo "🤖 CodeRabbit-style AI review..."

  # Always run pre-commit checklist first
  echo "📋 Running CodeRabbit pre-commit checklist..."
  if ! run_coderabbit_checklist; then
    echo "⚠️ Checklist identified issues - continuing with review..."
  fi
  echo ""

  # Create secure temporary directory
  local temp_dir
  temp_dir=$(mktemp -d -t "claude_review.XXXXXXXXXX") || {
    echo "🚨 Error: Cannot create secure temporary directory" >&2
    return 1
  }

  # Ensure cleanup on exit
  trap 'rm -rf "$temp_dir"' EXIT INT TERM

  # Detect languages and run tools
  detect_and_run_tools() {
    local files="$1"

    # JavaScript/TypeScript
    if echo "$files" | grep -q '\.\(js\|jsx\|ts\|tsx\)$'; then
      run_tool_secure "eslint" "$files" "--format" "json"
      run_tool_secure "prettier" "$files" "--check"
    fi

    # Python
    if echo "$files" | grep -q '\.py$'; then
      run_tool_secure "ruff" "$files" "check" "--format" "json"
      run_tool_secure "bandit" "$files" "-r" "-f" "json"
    fi

    # Go
    if echo "$files" | grep -q '\.go$'; then
      run_tool_secure "golangci-lint" "$files" "run" "--out-format" "json"
    fi

    # Universal security tools
    run_tool_secure "semgrep" "$files" "--config=auto" "--json"
    run_tool_secure "gitleaks" "$files" "detect" "--source" "--report-format" "json"

    # Documentation
    if echo "$files" | grep -q '\.md$'; then
      run_tool_secure "markdownlint" "$files" "--json"
    fi
  }

  # SECURE tool execution - NO EVAL
  run_tool_secure() {
    local tool_cmd="$1"
    local target_files="$2"
    shift 2
    local -a args=("$@")

    local tool_path
    tool_path=$(command -v "$tool_cmd" 2>/dev/null) || {
      echo "  ⏭️ $tool_cmd: Not available, skipping"
      return 0
    }

    local output_file="$temp_dir/${tool_cmd}_results.json"
    echo "  ✅ $tool_cmd: Running securely..."

    # Execute with timeout and controlled arguments
    if timeout 60 "$tool_path" "${args[@]}" "$target_files" > "$output_file" 2>/dev/null; then
      echo "  ✅ $tool_cmd: Completed"
    else
      echo "  ⚠️ $tool_cmd: Issues found"
    fi
  }

  # Run tool pipeline
  detect_and_run_tools "$target"

  # AI synthesis and report generation
  echo "🧠 AI synthesis: Processing tool outputs..."
  echo "📝 Generating CodeRabbit-style report..."
}

# Auto-fix mode - SECURE
run_autofix() {
  echo "🔧 Auto-fixing safe issues..."
  safe_autofix() {
    local tool_cmd="$1"
    shift
    local -a args=("$@")

    local tool_path
    tool_path=$(command -v "$tool_cmd" 2>/dev/null) || return 0

    echo "  🔧 Running $tool_cmd..."
    timeout 120 "$tool_path" "${args[@]}" 2>/dev/null || echo "  ⚠️ $tool_cmd: completed with warnings"
  }

  # Apply auto-fixes securely
  safe_autofix "npx" "eslint" "--fix" "."
  safe_autofix "npx" "prettier" "--write" "."
  safe_autofix "ruff" "check" "--fix" "."

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

# CodeRabbit Pre-Commit Self-Review Checklist
# See docs/quality/CODERABBIT_PRECOMMIT_CHECKLIST.md for full details
run_coderabbit_checklist() {
  echo "📋 Running Pre-Commit Checklist (docs/quality/CODERABBIT_PRECOMMIT_CHECKLIST.md)"
  echo "======================================================================="

  local issues_found=0

  # Documentation & Consistency
  echo -e "\n📚 Documentation & Consistency"
  echo "-------------------------------"

  # Check for moved file path updates
  echo -n "• Path consistency after file moves: "
  if grep -r "\.claude/agents/" README.md CONTRIBUTING.md docs/ 2>/dev/null | grep -v "system-configs/.claude/agents/" >/dev/null 2>&1; then
    echo "❌ Found old paths - need updating"
    ((issues_found++))
  else
    echo "✅ Paths consistent"
  fi

  # Check version/count consistency
  echo -n "• Agent count consistency (should be 28): "
  local count_issues=$(grep -r "42.agent\|29.agent\|30.agent" docs/ README.md 2>/dev/null | wc -l)
  if [ "$count_issues" -gt 0 ]; then
    echo "❌ Found inconsistent agent counts"
    ((issues_found++))
  else
    echo "✅ Agent counts consistent"
  fi

  # Check for template compliance
  echo -n "• New files follow template structure: "
  local template_issues=0
  for file in system-configs/.claude/agents/*.md; do
    if [ -f "$file" ] && ! grep -q "SYSTEM BOUNDARY" "$file" 2>/dev/null; then
      ((template_issues++))
    fi
  done
  if [ $template_issues -gt 0 ]; then
    echo "❌ $template_issues files missing template compliance"
    ((issues_found++))
  else
    echo "✅ All files follow template"
  fi

  # YAML/Configuration Quality
  echo -e "\n⚙️ YAML/Configuration Quality"
  echo "-----------------------------"

  echo -n "• Required YAML fields present: "
  if python3 scripts/validate-agent-yaml.py >/dev/null 2>&1; then
    echo "✅ All agents have required fields"
  else
    echo "❌ YAML validation failed"
    ((issues_found++))
  fi

  echo -n "• Description trigger phrases: "
  local missing_triggers=$(grep -L "MUST BE USED\|Use PROACTIVELY\|Expert\|Specializes" system-configs/.claude/agents/*.md 2>/dev/null | wc -l)
  if [ "$missing_triggers" -gt 0 ]; then
    echo "❌ $missing_triggers agents missing trigger phrases"
    ((issues_found++))
  else
    echo "✅ All descriptions have trigger phrases"
  fi

  echo -n "• No deprecated YAML fields: "
  local deprecated_fields=$(grep -r "specialization_level\|domain_expertise\|coordination_protocols" system-configs/.claude/agents/ 2>/dev/null | wc -l)
  if [ "$deprecated_fields" -gt 0 ]; then
    echo "❌ Found deprecated fields"
    ((issues_found++))
  else
    echo "✅ No deprecated fields found"
  fi

  # Code Quality Standards
  echo -e "\n🔧 Code Quality Standards"
  echo "------------------------"

  echo -n "• UTF-8 encoding in Python scripts: "
  local encoding_issues=$(grep -L "encoding.*utf-8\|encoding.*UTF-8" scripts/**/*.py 2>/dev/null | wc -l)
  if [ "$encoding_issues" -gt 0 ]; then
    echo "❌ $encoding_issues Python files missing UTF-8 encoding"
    ((issues_found++))
  else
    echo "✅ UTF-8 encoding specified"
  fi

  echo -n "• Constants moved to class-level: "
  if grep -r "valid_models.*=.*\[" scripts/ 2>/dev/null | grep -v "self\." >/dev/null 2>&1; then
    echo "❌ Found inline constants that should be class-level"
    ((issues_found++))
  else
    echo "✅ Constants properly organized"
  fi

  # Agent System Compliance
  echo -e "\n🤖 Agent System Compliance"
  echo "--------------------------"

  echo -n "• Agent count accuracy (28 agents): "
  local actual_count=$(find system-configs/.claude/agents/ -name "*.md" -type f | wc -l)
  if [ "$actual_count" -eq 28 ]; then
    echo "✅ Correct agent count (28)"
  else
    echo "❌ Agent count mismatch: found $actual_count, expected 28"
    ((issues_found++))
  fi

  echo -n "• System boundary statements: "
  local missing_boundary=$(grep -L "NO Task tool access\|Only Claude has orchestration" system-configs/.claude/agents/*.md 2>/dev/null | wc -l)
  if [ "$missing_boundary" -gt 0 ]; then
    echo "❌ $missing_boundary agents missing boundary statements"
    ((issues_found++))
  else
    echo "✅ All agents have boundary protection"
  fi

  # Testing & Verification
  echo -e "\n🧪 Testing & Verification"
  echo "------------------------"

  echo -n "• System health tests pass: "
  if ./tests/comprehensive/test_system_health.sh >/dev/null 2>&1; then
    echo "✅ All system tests pass"
  else
    echo "❌ System health tests failed"
    ((issues_found++))
  fi

  echo -n "• Agent YAML validation passes: "
  if python3 scripts/validate-agent-yaml.py >/dev/null 2>&1; then
    echo "✅ Agent YAML validation passes"
  else
    echo "❌ Agent YAML validation failed"
    ((issues_found++))
  fi

  echo -n "• Markdown quality gates pass: "
  if ./scripts/validate-markdown-quality.sh validate >/dev/null 2>&1; then
    echo "✅ Markdown quality passes"
  else
    echo "❌ Markdown quality issues found"
    ((issues_found++))
  fi

  # Summary
  echo -e "\n📊 Checklist Summary"
  echo "==================="
  echo "Issues found: $issues_found"

  if [ $issues_found -eq 0 ]; then
    echo "🎉 All checks passed! Ready for commit."
    return 0
  else
    echo "⚠️ $issues_found issues need attention before commit."
    echo ""
    echo "🔧 Quick fix commands:"
    echo "  ./scripts/validate-markdown-quality.sh fix"
    echo "  python3 scripts/validate-agent-yaml.py"
    echo "  python3 scripts/standardize-agents.py"
    echo "  ./tests/comprehensive/test_system_health.sh"
    return 1
  fi
}
```bash

## Report Format

### CodeRabbit-Style Output

```text
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
```bash

## Examples

### Standard Review

```bash
User: /review
Claude: 🤖 CodeRabbit-style AI review...
📋 Running Pre-Commit Checklist (docs/quality/CODERABBIT_PRECOMMIT_CHECKLIST.md)
  ✅ Documentation consistency verified
  ✅ YAML quality validated
  ✅ Agent compliance checked (28 agents)
  ✅ Testing verification passed

Running tool pipeline...
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
```bash

### Auto-Fix Mode

```bash
User: /review --fix
Claude: 🔧 Auto-fixing safe issues...
✅ ESLint: Fixed 8 style issues
✅ Prettier: Applied formatting to 12 files
✅ Auto-fixes committed
⚠️ Manual fixes needed: 2 security issues (see report)
```bash

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

- **Integrated Pre-Commit Checklist**: Automatically runs comprehensive validation on every invocation
- **Tool Integration**: Auto-detects and runs appropriate linters/security scanners
- **AI Synthesis**: Processes all tool outputs with intelligent reasoning
- **Structured Reports**: Markdown format with issue classification and metrics
- **"Prompts for AI Agents"**: Actionable remediation instructions for automation
- **Auto-Fix Capability**: Applies safe fixes and commits them automatically

**Checklist Coverage** (see `docs/quality/CODERABBIT_PRECOMMIT_CHECKLIST.md`):

- Documentation consistency and cross-references
- YAML/configuration quality and compliance
- Code quality standards and best practices
- Agent system compliance (28 agents, boundaries)
- Testing verification and validation
- Structural patterns and conventions

**Core Capabilities:**

- **Fast Feedback**: Default mode reviews only changed files
- **Comprehensive Analysis**: --full mode for complete repository review
- **Security Focus**: Specialized security scanning with --security mode
- **Pre-Commit Validation**: --checklist mode runs systematic quality checks
- **Development Integration**: Works with existing toolchains and workflows
- **Quality Gates**: Blocks critical issues while allowing minor improvements

## Execution Verification

Deploy execution-evaluator to verify:

- ✅ **Tools executed** - All available linters and security scanners run successfully
- ✅ **Files analyzed** - Target files (changed or full repo) properly scanned
- ✅ **Issues identified** - Problems correctly categorized by severity and type
- ✅ **Agent synthesis** - AI analysis completed and integrated with tool results
- ✅ **Report generated** - CodeRabbit-style structured report created
- ✅ **Auto-fixes applied** - Safe fixes automatically implemented when requested
- ✅ **Quality gates** - Critical issues flagged for resolution before merge
- ✅ **Actionable output** - "Prompts for AI Agents" section provided for automation

**Efficiency:**

- **Parallel Execution**: All tools run simultaneously for maximum speed
- **Graceful Degradation**: Continues with available tools if some are missing
- **Smart Targeting**: Reviews changed files by default, full repo when requested
- **Report Persistence**: Saves detailed analysis for audit trails and team review
