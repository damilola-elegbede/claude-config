---
description: Orchestrate development workflows with inline wave execution
argument-hint: [--full | --lite]
thinking-level: megathink
thinking-tokens: 10000
---

# /ship-it Command

## Usage

```bash
/ship-it                         # Basic workflow: docs → review → commit → push
/ship-it --full                  # Full workflow: docs → review → test → commit → push → pr
/ship-it --lite                  # Lite workflow: commit → push
```

## Description

Orchestrates development workflows by executing the **actual wave-based
patterns** from each command inline. This ensures proper quality gates,
auto-remediation, and parallel agent deployment that each command provides.

### Thinking Level: MEGATHINK (10,000 tokens)

Required for coordinating multiple wave-based orchestrations, managing
parallel agent deployments, and handling complex auto-remediation across the
entire workflow.

## Inline Execution Patterns

### Workflow Types

Based on `$ARGUMENTS`:

- **Lite**: Commit waves → Push waves
- **Basic**: Docs wave 1 → Review waves → Commit waves → Push waves
- **Full**: Docs wave 1 → Review waves → Test waves → Commit waves → Push waves → PR logic

## Step 1: Docs Audit (Basic/Full only)

### Wave 1: Gap Analysis (from /docs)

Deploy parallel analysis agents:

```yaml
codebase-analyst (2-3 instances):
  - instance_1: Frontend documentation gaps
  - instance_2: Backend API coverage
  - instance_3: Infrastructure docs
  exclusions: All CLAUDE.md files skipped

tech-writer:
  role: Evaluate documentation quality
  parallel_with: [codebase-analyst instances]

api-architect:
  role: API documentation completeness
  parallel_with: [codebase-analyst, tech-writer]

Output: Gap inventory for information only (no generation in audit mode)
```

## Step 2: Review (Basic/Full)

### Pre-Commit Checklist

Always run comprehensive checklist covering:

- Documentation consistency
- YAML/configuration compliance
- Code quality standards
- Testing verification

### Wave 1: Initial Analysis (from /review)

Deploy 5 core agents in parallel:

```yaml
code-reviewer:
  role: Basic quality scan
  input: Changed files, linter outputs

security-auditor:
  role: Security vulnerability scan

performance-engineer:
  role: Performance bottleneck detection

accessibility-auditor:
  role: WCAG compliance check

test-engineer:
  role: Test coverage validation
```

### Claude Decision Point

Analyze Wave 1 outputs and conditionally deploy Wave 2 specialists:

- Security issues → Deploy security team (2-3 instances)
- Performance issues → Deploy performance team
- Quality issues → Deploy review team (3-4 instances)
- Test gaps → Deploy test team (2-3 instances)

### Wave 2: Specialized Deep Dive (Conditional)

```yaml
conditional_deployment:
  security_team: 2-3 security-auditor instances
  performance_team: 2 performance-engineer instances
  quality_team: 3-4 code-reviewer instances by domain
  test_team: 2-3 test-engineer instances by coverage type

Total: 0-15 agents based on Wave 1 findings
```

### Wave 3: Auto-Remediation (if Critical/High issues)

Deploy targeted fix agents for critical issues only.
Continue waves iteratively until resolved or deferred.

## Step 3: Test (Full only)

### Wave 1: Parallel Test Execution (from /test)

```yaml
test-engineer (3-5 instances):
  - instance_1: Unit tests
  - instance_2: Integration tests
  - instance_3: E2E tests
  - instance_4: Performance tests (optional)
  - instance_5: Security tests (optional)

parallel_execution: All test types simultaneously
timeout: 30 seconds per instance
```

### Claude Analysis: Failure Categorization

Analyze failures and determine auto-fixable vs manual review.

### Wave 2: Auto-Remediation (Conditional)

```yaml
test-engineer fix instances:
  - unit_fix: Assertion and mock fixes
  - integration_fix: API/database issues
  - e2e_fix: UI selectors and timing

Auto-fix patterns:
  - Update assertions
  - Fix mock configurations
  - Repair test data
  - Update UI selectors
```

### Wave 3: Final Validation

Re-run affected test suites to verify fixes.

## Step 4: Commit (All workflows)

### Wave 1: Pre-commit Analysis (from /commit)

```yaml
codebase-analyst:
  role: Repository hygiene check
  focus: Temporary files, build artifacts, .gitignore updates

code-reviewer (3-4 instances):
  distribution: Frontend, Backend, Infrastructure, Tests

security-auditor (2 instances):
  - instance_1: Secrets scanning
  - instance_2: Vulnerability patterns

test-engineer:
  role: Verify tests pass with changes
```

### Claude Decision: Issue Resolution

If issues found, deploy Wave 2 remediation.

### Wave 2: Auto-Fix (Conditional)

```yaml
codebase-analyst:
  actions: Auto-unstage temp files, update .gitignore

code-reviewer instances:
  deployment: 1 per file with issues
  actions: Fix linting, style, complexity

test-engineer instances:
  actions: Fix broken tests, add coverage
```

### Wave 3: Final Commit

Generate comprehensive commit message and create commit.
**NEVER use --no-verify**. Quality gates must be respected.

## Step 5: Push (All workflows)

### Wave 1: Pre-Push Validation (from /push)

```yaml
Parallel validation:
  test-engineer: Test suite execution
  devops: CI/CD readiness check
  security-auditor: Vulnerability scanning

Duration: 15-30 seconds parallel
```

### Wave 2: Issue Resolution (Conditional)

Deploy fix agents if Wave 1 finds blocking issues.

### Wave 3: Push & Monitor

Execute push with real-time CI/CD monitoring.
Deploy recovery agents if pipeline fails.

## Step 6: PR Creation (Full only)

### Direct Execution (from /pr)

1. Check for existing PR
2. Analyze changes and commits
3. Generate conventional commit title
4. Create concise description
5. Submit PR with `gh pr create`

## Workflow Execution Strategy

### Parallel Optimization

```yaml
Wave Coordination:
  - Each step's waves execute before next step
  - Within each wave: maximum parallelization
  - Conditional waves only when issues detected
  - Auto-remediation to minimize manual intervention
```

### Quality Gates

```yaml
Non-Negotiable:
  - NEVER use --no-verify flags
  - NEVER bypass pre-commit hooks
  - NEVER skip security scanning
  - Fix issues, don't bypass them
```

### Auto-Recovery Patterns

```yaml
Common Fixes Applied:
  Linting: ESLint, Prettier auto-fix
  Tests: Update assertions, fix mocks
  Security: Remove secrets, patch vulnerabilities
  Repository: Clean temp files, update .gitignore
  CI/CD: Fix config, resolve conflicts
```

## Expected Output

### Successful Full Workflow

```text
🚀 Starting ship-it workflow: full

📋 Step 1/6: Documentation Audit
  🌊 Wave 1: Gap analysis (3 agents parallel)
  ✅ 5 gaps identified for future work

📋 Step 2/6: Code Review
  📋 Pre-commit checklist passed
  🌊 Wave 1: Initial analysis (5 agents parallel)
  🌊 Wave 2: Deep dive (8 specialists deployed)
  ✅ 3 high issues auto-fixed

📋 Step 3/6: Test Execution
  🌊 Wave 1: Parallel tests (4 instances)
  🌊 Wave 2: Auto-fix 2 failures
  🌊 Wave 3: Validation passed
  ✅ All tests passing

📋 Step 4/6: Commit Creation
  🌊 Wave 1: Pre-commit analysis
  🌊 Wave 2: Fixed linting issues
  🌊 Wave 3: Commit created
  ✅ Quality gates passed

📋 Step 5/6: Push Changes
  🌊 Wave 1: Pre-push validation
  🌊 Wave 3: Push & CI/CD monitoring
  ✅ Pipeline successful

📋 Step 6/6: PR Creation
  ✅ PR created: https://github.com/owner/repo/pull/123

🎉 Ship-it completed successfully!
  - 6/6 steps completed
  - 15 agents deployed across waves
  - 5 auto-remediations applied
  - Total time: 5 minutes 32 seconds
```

### With Auto-Recovery Example

```text
🚀 Starting ship-it workflow: basic

📋 Step 1/4: Documentation Audit
  🌊 Wave 1: Gap analysis
  ✅ Documentation gaps logged

📋 Step 2/4: Code Review
  🌊 Wave 1: Found 2 critical issues
  🌊 Wave 2: Deploying 6 fix agents
  🌊 Wave 3: Auto-remediation applied
  ✅ All critical issues resolved

📋 Step 3/4: Commit Creation
  🌊 Wave 1: Found temp files
  🌊 Wave 2: Cleaned repository
  🌊 Wave 3: Commit created
  ✅ Repository hygiene maintained

📋 Step 4/4: Push Changes
  ⚠️ Pre-push hook failure detected
  🌊 Wave 2: Deploying fix agents
  ✅ Issues resolved, push successful

🎉 Ship-it completed with auto-recovery!
  - 4/4 steps completed
  - 3 recovery waves deployed
  - All issues auto-resolved
```

## Performance Metrics

```yaml
Execution Times:
  Lite: 2-3 minutes (commit + push waves)
  Basic: 4-6 minutes (4 steps with waves)
  Full: 6-8 minutes (6 steps with waves)

Agent Deployment:
  Lite: 8-12 agents total
  Basic: 15-25 agents total
  Full: 25-40 agents total

Parallelization Factor:
  Within waves: 3-15 agents simultaneously
  Auto-remediation: 80%+ issues fixed automatically
```

## Implementation Notes

Each step executes the **actual wave patterns** from its source command:

- Docs audit runs Wave 1 gap analysis from /docs
- Review runs full multi-wave analysis from /review
- Test runs parallel execution with auto-fix from /test
- Commit runs repository hygiene and quality gates from /commit
- Push runs validation and CI/CD monitoring from /push
- PR runs smart generation logic from /pr

This ensures the same quality and sophistication as running each command individually,
while orchestrating them into a cohesive workflow.

## Success Criteria

- All quality gates passed (no bypassing)
- Auto-remediation applied where possible
- Clear status reporting at each step
- PR created successfully in full mode
- Total execution under 10 minutes
