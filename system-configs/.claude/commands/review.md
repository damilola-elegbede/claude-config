---
description: AI code review with linting and security scanning
argument-hint: [--full|--fix|--security|file-path]
thinking-level: think harder
thinking-tokens: 8000
---

# /review Command

## Usage

```bash
/review                          # Review changed files + run pre-commit checklist
/review --full                   # Full repository review + checklist
/review <file|directory>         # Review specific target + checklist
/review --fix                    # Auto-fix safe issues + commit
/review --security               # Security-focused analysis + checklist
```

Use arguments: `$ARGUMENTS`

## Description

Deploy comprehensive code review combining linting tools, security scanning, and AI synthesis to generate structured
reports with "Prompts for AI Agents" sections. Every invocation automatically runs the comprehensive pre-commit
checklist first.

### Thinking Level: THINK HARDER (8,000 tokens)

This command requires enhanced thinking depth due to:

- **Multi-dimensional code analysis**: Quality, security, performance, and maintainability
- **Pattern recognition complexity**: Identifying subtle issues and code smells
- **Synthesis of multiple tools**: Combining linter, security scanner, and AI insights
- **Prioritization logic**: Ranking issues by severity and impact
- **Fix recommendation quality**: Providing actionable and safe auto-fix suggestions

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

## Behavior

### Multi-Layer Analysis

Every invocation of `/review` automatically runs the comprehensive pre-commit checklist first, covering:

- Documentation consistency and cross-references
- YAML/configuration quality and compliance
- Code quality standards and best practices
- Agent system compliance (28 agents, boundaries)
- Testing verification and validation
- Structural patterns and conventions

**Default**: Reviews changed files only for fast feedback

**--full**: Comprehensive repository analysis with all tools

### Tool Integration

#### Core Tools (Auto-detected)

```text
JavaScript/TypeScript: ESLint, Prettier
Python: Ruff, Pylint, Bandit
Go: golangci-lint, gosec
Security: Semgrep, Gitleaks, OSV-Scanner
Infrastructure: Hadolint, Checkov
Documentation: markdownlint, ShellCheck
```

#### Iterative Wave-Based Agent Orchestration

Deploy agents in strategic waves with Claude decision points for intelligent escalation. This is an **adaptive,
iterative process** that continues until all critical and high-priority issues are resolved. Wave cycles extend
beyond Wave 3 as needed.

```yaml
WAVE 1: INITIAL ANALYSIS (5 Core Agents - Parallel Execution)
═══════════════════════════════════════════════════════════════

  code-reviewer:
    role: Basic quality scan across all domains
    input: Changed files, linter outputs
    output: Code quality assessment, style violations, architectural concerns
    execution: PARALLEL with all Wave 1 agents

  security-auditor:
    role: Initial security vulnerability scan
    input: Code changes, dependencies, API endpoints
    output: Security risk assessment, vulnerability classifications
    execution: PARALLEL with all Wave 1 agents

  performance-engineer:
    role: Basic performance scan and bottleneck detection
    input: Code changes, algorithm patterns
    output: Performance risk assessment, optimization opportunities
    execution: PARALLEL with all Wave 1 agents

  accessibility-auditor:
    role: Accessibility compliance baseline check
    input: UI components, markup changes
    output: WCAG compliance assessment, accessibility barriers
    execution: PARALLEL with all Wave 1 agents

  test-engineer:
    role: Test coverage and quality validation
    input: Test files, coverage reports
    output: Test adequacy assessment, coverage gaps
    execution: PARALLEL with all Wave 1 agents

WAVE BOUNDARY: CLAUDE ANALYSIS DECISION POINT 1
════════════════════════════════════════════════

  analysis_input: All Wave 1 agent outputs (5 reports)
  processing_tasks:
    - Categorize findings by severity: Critical, High, Medium, Low
    - Map issues to specialized domains for deep dive analysis
    - Calculate deployment priority based on issue density per domain
    - Determine multi-instance needs for high-volume issue areas
    - Assess cross-cutting concerns requiring coordinated specialists

  conditional_deployment_triggers:
    security_issues_found: Deploy security specialist team (2-3 instances)
    performance_bottlenecks_detected: Deploy performance specialist team
    code_quality_problems_identified: Deploy quality review team (2-4 instances)
    accessibility_violations_found: Deploy accessibility + design team
    test_coverage_gaps_detected: Deploy testing specialist team (2-3 instances)
    infrastructure_concerns_identified: Deploy devops + monitoring team

  deployment_strategy:
    - Calculate optimal instance count per specialist domain
    - Assign specific focus areas to prevent overlap
    - Establish inter-agent coordination for cross-cutting issues
    - Set conditional thresholds for Wave 3 remediation trigger

WAVE 2: SPECIALIZED DEEP DIVE (Conditional Deployment - 0-15 Agents)
════════════════════════════════════════════════════════════════════

  conditional_security_team:
    deployment_trigger: Security issues detected in Wave 1
    agent_instances:
      security-auditor-auth: Authentication/authorization vulnerabilities
      security-auditor-injection: Data validation and injection attacks
      security-auditor-deps: Dependency vulnerabilities and secrets detection
    specialized_input: Specific vulnerability types and contexts from Wave 1
    deep_analysis_output: Detailed remediation strategies per vulnerability class

  conditional_performance_team:
    deployment_trigger: Performance problems detected in Wave 1
    agent_instances:
      performance-engineer-algorithms: Algorithm complexity and optimization
      performance-engineer-database: Database query optimization and indexing
      performance-engineer: Performance monitoring and alerting setup
    specialized_input: Performance bottleneck locations and patterns from Wave 1
    deep_analysis_output: Optimization roadmap with measurable improvements

  conditional_quality_team:
    deployment_trigger: Code quality issues detected in Wave 1
    agent_instances:
      code-reviewer-frontend: Frontend architecture and component patterns
      code-reviewer-backend: Backend patterns, API design, data flow
      code-reviewer-integration: Cross-system integration and contracts
      code-reviewer-architecture: System design and scalability patterns
    specialized_input: Quality concerns categorized by architectural layer
    deep_analysis_output: Refactoring roadmap with architectural improvements

  conditional_accessibility_team:
    deployment_trigger: Accessibility violations detected in Wave 1
    agent_instances:
      accessibility-auditor: Detailed WCAG compliance analysis
      ui-designer: Accessible design patterns and alternatives
    specialized_input: Accessibility barriers by component and interaction type
    deep_analysis_output: Comprehensive accessibility remediation plan

  conditional_test_team:
    deployment_trigger: Test coverage gaps detected in Wave 1
    agent_instances:
      test-engineer-unit: Unit test coverage analysis and improvement
      test-engineer-integration: Integration test strategy and implementation
      test-engineer-e2e: End-to-end test coverage and critical path validation
    specialized_input: Coverage gaps mapped to risk areas from Wave 1
    deep_analysis_output: Comprehensive test improvement strategy with priorities

WAVE BOUNDARY: CLAUDE CONSOLIDATION DECISION POINT 2
═════════════════════════════════════════════════════

  analysis_input: All Wave 2 specialized analysis outputs (variable count)
  consolidation_tasks:
    - Merge findings across all specialized teams without duplication
    - Cross-reference issues between domains for systemic problems
    - Identify remaining critical/high priority issues requiring immediate fixes
    - Prioritize issues for current sprint vs. future technical debt
    - Calculate overall risk assessment and remediation timeline

  remediation_decision_criteria:
    critical_security_vulnerabilities: MANDATORY Wave 3 deployment
    high_priority_performance_blockers: MANDATORY Wave 3 deployment
    blocking_accessibility_violations: MANDATORY Wave 3 deployment
    critical_test_failures: MANDATORY Wave 3 deployment
    architectural_debt_accumulation: CONDITIONAL Wave 3 deployment

  final_decision:
    deploy_wave_3: Critical/High issues require immediate remediation
    skip_to_report: All issues documented and categorized for future work

WAVE 3: REMEDIATION (Conditional - Only for Critical/High Issues)
═════════════════════════════════════════════════════════════════

  conditional_remediation_deployment:
    deployment_trigger: Critical or High priority issues remain unresolved
    remediation_strategy:
      - Deploy targeted fix agents matching unresolved issue types
      - Deploy validation agents to verify fixes don't introduce regressions
      - Deploy integration testing agents for end-to-end change verification
      - Coordinate cross-domain fixes to prevent conflict

  remediation_agent_types:
    security_fix_agents: Apply security patches and configuration changes
    performance_fix_agents: Implement performance optimizations
    quality_fix_agents: Apply code refactoring and architectural improvements
    accessibility_fix_agents: Implement accessibility compliance changes
    test_fix_agents: Add missing test coverage and fix failing tests

  validation_protocol:
    pre_fix_validation: Snapshot current state and test baseline
    fix_application: Apply changes with rollback capability
    post_fix_validation: Verify fixes resolve issues without side effects
    integration_testing: Run full test suite to ensure system stability

ITERATIVE CONTINUATION: WAVE 4, 5, 6... N (As Needed)
═══════════════════════════════════════════════════════

  adaptive_remediation_cycles:
    description: Wave-based orchestration continues iteratively until all critical and high-priority issues are resolved
    continuation_triggers:
      - Wave 3 remediation discovers new issues requiring additional analysis
      - Applied fixes introduce regressions detected during validation
      - Cross-domain fixes reveal systemic problems requiring deeper investigation
      - Integration testing identifies previously unknown dependencies

  wave_n_examples:
    Wave 4: "Additional security analysis after fixes reveal broader attack surface"
    Wave 5: "Performance regression investigation triggered by security patches"
    Wave 6: "Architecture review required after discovering coupling issues"
    Wave N: "Continue remediation cycles until all critical/high issues resolved"

  adaptive_decision_points:
    each_wave_boundary:
      - Reassess remaining issue severity and impact
      - Determine if additional specialized analysis is required
      - Plan next wave deployment or conclude process
      - Update timeline and resource allocation

  termination_criteria:
    process_completion:
      - All critical issues resolved and validated
      - All high-priority issues addressed or explicitly deferred
      - System integration tests pass without regressions
      - Quality gates meet established thresholds
      - No new critical/high issues discovered in final validation

FINAL BOUNDARY: COMPREHENSIVE REPORT GENERATION
════════════════════════════════════════════════

  consolidation_input:
    - All wave outputs (Wave 1: 5 reports, Wave 2: 0-15 reports, Wave 3+: 0-N reports)
    - Applied fixes documentation with before/after analysis
    - Validation results for all applied changes
    - Remaining issues categorized by priority and domain

  report_synthesis:
    - Executive summary with quantified metrics and risk assessment
    - Critical/High/Medium/Low issue breakdown with context
    - Applied fixes documentation with verification status
    - Remaining technical debt prioritized by impact and effort
    - "Prompts for AI Agents" sections for future remediation
    - Next steps roadmap with timeline and resource requirements
```

### Wave-Based Review Strategy

```yaml
Execution Optimization:
  Phase 1 - Tool Execution (Parallel):
    - All linters run simultaneously
    - Security scanners execute in parallel
    - Performance profilers run concurrently
    - Results collected in real-time

  Phase 2 - Iterative Wave-Based Agent Analysis (Adaptive Escalation):
    Wave 1 - Foundation Scan (5 agents parallel):
      Duration: 30-45 seconds
      Agents: code-reviewer, security-auditor, performance-engineer, accessibility-auditor, test-engineer
      Output: Initial findings categorized by severity and domain

    Claude Decision Point (5-10 seconds):
      - Analyze Wave 1 findings
      - Determine specialized focus areas
      - Plan Wave 2 conditional deployment
      - Optimize agent instance allocation

    Wave 2 - Specialized Deep Dive (Conditional 3-15 agents):
      Duration: 45-90 seconds
      Conditional Teams:
        - Security Team: 3 security-auditor instances (if vulnerabilities found)
        - Performance Team: 2 performance-engineer + performance-engineer (if bottlenecks found)
        - Quality Team: 3 code-reviewer instances (if architectural issues found)
        - Accessibility Team: accessibility-auditor + ui-designer (if violations found)
        - Test Team: 3 test-engineer instances (if coverage gaps found)
      Total: 3-15 agents based on Wave 1 findings

    Claude Consolidation (10-15 seconds):
      - Merge specialized analysis outputs
      - Identify remaining critical issues
      - Decide on remediation need

    Wave 3+ - Iterative Remediation (Conditional, Continues Until Complete):
      Duration: 60-120 seconds per wave (only if critical/high issues remain)
      Agents: Targeted fix agents + validation agents per wave
      Output: Applied fixes with verification, continuation assessment
      Termination: When all critical/high issues resolved or explicitly deferred

  Phase 3 - Final Report Generation:
    - All wave outputs synthesized intelligently
    - Duplicate findings deduplicated across waves
    - Issues prioritized by severity and impact
    - CodeRabbit-style comprehensive report generated

Performance Metrics:
  - Iterative wave-based review: 2-8+ minutes total (adaptive based on complexity)
  - Agent efficiency: 5-50+ agents deployed (scales with issue discovery)
  - Coverage: 100% of code analyzed with targeted deep dives
  - Quality: Adaptive analysis depth based on actual findings
  - Resource optimization: Deploy only necessary agents per wave
```

### Execution Strategy

- **Language Detection**: Auto-run appropriate tools based on file extensions
- **Parallel Execution**: All tools run simultaneously for speed
- **Graceful Degradation**: Skip missing tools, continue with available ones
- **JSON Collection**: Gather all tool outputs for AI synthesis

### Implementation Examples

#### Core Review Function

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
```

#### Auto-Fix Implementation

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

#### Standard Review Example

```text
User: /review
Claude: 🤖 CodeRabbit-style AI review...
📋 Running Pre-Commit Checklist...
  ✅ All checks passed
🧠 AI synthesis: Processing tool outputs...
📝 Report: 2 Critical, 1 High issue found with remediation prompts
```

#### Auto-Fix Mode Example

```text
User: /review --fix
Claude: 🔧 Auto-fixing safe issues...
✅ ESLint: Fixed 8 style issues
✅ Prettier: Applied formatting to 12 files
✅ Auto-fixes committed
⚠️ Manual fixes needed: 2 security issues (see report)
```
