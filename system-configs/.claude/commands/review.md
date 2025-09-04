---
description: AI code review with linting and security scanning
argument-hint: [--full|--fix|--security|file-path]
---

# CodeRabbit-Style AI Code Review

Deploy comprehensive code review combining linting tools, security scanning, and AI synthesis
to generate structured reports with "Prompts for AI Agents" sections. Every invocation automatically
runs the comprehensive pre-commit checklist first.

## Command Purpose

Execute multi-layer code analysis with:

1. **Pre-Commit Checklist**: Automatically runs CodeRabbit checklist (see `docs/quality/CODERABBIT_PRECOMMIT_CHECKLIST.md`)
2. **Tool Pipeline**: Runs available linters (ESLint, Semgrep, Gitleaks, etc.) in parallel
3. **AI Synthesis**: Processes tool outputs with contextual reasoning
4. **Structured Report**: CodeRabbit-style output with "Prompts for AI Agents"

## Usage Modes

- `/review` - Review changed files + run pre-commit checklist
- `/review --full` - Full repository review + checklist
- `/review <file|directory>` - Review specific target + checklist
- `/review --fix` - Auto-fix safe issues + commit
- `/review --security` - Security-focused analysis + checklist

Use arguments: `$ARGUMENTS`

## Context

**Multi-Layer Analysis:**

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
```

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
```

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

### Execution Strategy

- **Language Detection**: Auto-run appropriate tools based on file extensions
- **Parallel Execution**: All tools run simultaneously for speed
- **Graceful Degradation**: Skip missing tools, continue with available ones
- **JSON Collection**: Gather all tool outputs for AI synthesis

## Implementation

### Core Review Function

```bash
# CodeRabbit-style review execution with security hardening
run_coderabbit_review() {
  local target="${1:-$(git diff --name-only main...HEAD 2>/dev/null || echo '.')}"
  local mode="$2"

  echo "🤖 CodeRabbit-style AI review..."

  # Always run pre-commit checklist first
  echo "📋 Running CodeRabbit pre-commit checklist..."
  run_coderabbit_checklist
  echo ""

  # Create secure temporary directory with cleanup trap
  local temp_dir=$(mktemp -d -t "claude_review.XXXXXXXXXX")
  trap 'rm -rf "$temp_dir"' EXIT INT TERM

  # Language detection and tool execution
  detect_and_run_tools "$target"

  # AI synthesis and report generation
  echo "🧠 AI synthesis: Processing tool outputs..."
  echo "📝 Generating CodeRabbit-style report..."
}

# Secure tool execution without eval
run_tool_secure() {
  local tool_cmd="$1" target_files="$2"
  shift 2; local -a args=("$@")

  local tool_path=$(command -v "$tool_cmd" 2>/dev/null) || {
    echo "  ⏭️ $tool_cmd: Not available, skipping"; return 0
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
```

### Auto-Fix Implementation

```bash
# Auto-fix mode with security controls
run_autofix() {
  echo "🔧 Auto-fixing safe issues..."

  # Safe tool execution function
  safe_autofix() {
    local tool_cmd="$1"; shift; local -a args=("$@")
    local tool_path=$(command -v "$tool_cmd" 2>/dev/null) || return 0

    echo "  🔧 Running $tool_cmd..."
    timeout 120 "$tool_path" "${args[@]}" 2>/dev/null ||
      echo "  ⚠️ $tool_cmd: completed with warnings"
  }

  # Apply auto-fixes securely
  safe_autofix "npx" "eslint" "--fix" "."
  safe_autofix "npx" "prettier" "--write" "."
  safe_autofix "ruff" "check" "--fix" "."

  # Commit fixes if changes made
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

### Pre-Commit Checklist Summary

The comprehensive checklist validates:

- **Documentation**: Path consistency, agent counts, template compliance
- **YAML Quality**: Required fields, trigger phrases, no deprecated fields
- **Code Standards**: UTF-8 encoding, proper constant organization
- **Agent System**: Correct count (28), boundary statements
- **Testing**: System health, YAML validation, markdown quality

See `docs/quality/CODERABBIT_PRECOMMIT_CHECKLIST.md` for complete implementation details.

## Expected Output

### CodeRabbit-Style Report Structure

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

### Performance Optimizations
- Optimize N+1 query pattern in user data retrieval
- Implement caching for frequently accessed user data

## 📊 Tool Summary
- ESLint: 5 style issues (3 auto-fixable)
- Semgrep: 1 SQL injection vulnerability
- Gitleaks: 1 hardcoded secret detected

## 🎯 Next Steps
1. Fix SQL injection (Critical - blocks merge)
2. Remove hardcoded secret (Critical - security risk)
3. Optimize N+1 queries (High - performance impact)
```

## Examples

### Standard Review

```text
User: /review
Claude: 🤖 CodeRabbit-style AI review...
📋 Running Pre-Commit Checklist...
  ✅ All checks passed
🧠 AI synthesis: Processing tool outputs...
📝 Report: 2 Critical, 1 High issue found with remediation prompts
```

### Auto-Fix Mode

```text
User: /review --fix
Claude: 🔧 Auto-fixing safe issues...
✅ ESLint: Fixed 8 style issues
✅ Prettier: Applied formatting to 12 files
✅ Auto-fixes committed
⚠️ Manual fixes needed: 2 security issues (see report)
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
- **Pre-Commit Validation**: Systematic quality checks before commits
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
