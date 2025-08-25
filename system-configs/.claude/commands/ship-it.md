# /ship-it Command

## Description

Orchestrates development workflows by running multiple `/` commands in sequence
with **automatic issue resolution**. When commands report problems, deploys
specialized agents to fix them and retries until success. Never stops on
failures - always finds a way forward.

## Usage

```bash
/ship-it                    # Basic workflow (default)
/ship-it -f, --full        # Full workflow
/ship-it -l, --lite        # Lite/quick workflow
```bash

## Workflows

```yaml
Basic (Default): /docs --audit → /docs readme → /review --quick → /commit → /push
Full (-f, --full): /docs --audit → /docs → /review → /test → /docs --clean → /commit → /push → /pr (if no PR exists)
Lite (-l, --lite): /commit → /push
```

## Behavior

When invoked, I execute a sequence of Claude commands with full agent
orchestration. Each command runs with complete context awareness, specialized
agents, and quality gates. The workflow continues sequentially with **automatic
issue resolution** - when commands report problems, I deploy appropriate agents
to fix them and retry until success.

**Core Principles:**

- **Auto-Remediation**: Commands don't fail - they deploy agents to fix issues
- **Progressive Problem Solving**: Identify → Deploy Specialists → Apply Fixes → Retry → Continue
- **Resilient Execution**: Handles all failure modes through agent deployment
- **Smart PR Detection**: Creates PR only if none exists for current branch
- **Never Give Up**: Retries with fixes until success (except /pr which is optional)

## Auto-Remediation Workflow

### When Commands Report Problems

```yaml
Step 1 - Identify Issue: Parse command output for specific error patterns
Step 2 - Deploy Specialist: Route to appropriate agent based on error type
Step 3 - Apply Fixes: Let agent implement solutions automatically
Step 4 - Verify Resolution: Re-run original command to confirm success
Step 5 - Continue Workflow: Move to next step once resolved
```bash

### Agent Routing Logic

### Parallel Workflow Orchestration

Deploy project-orchestrator for workflow optimization:

```yaml
project-orchestrator:
  role: Identify parallelization opportunities
  input: Workflow dependencies, command requirements
  output: Parallel execution plan

incident-commander:
  role: Handle critical failures and recovery
  input: Failure patterns, system state
  output: Recovery strategy, remediation steps

Parallel Execution:
  - Independent commands run simultaneously
  - docs + review can run in parallel
  - Multiple fix agents deploy concurrently
```


```yaml
Security Issues: security-auditor (always, non-negotiable)
Performance Issues: performance-specialist + monitoring-specialist
Code Quality: code-reviewer + backend-engineer/frontend-architect
Testing Issues: test-engineer + execution-evaluator
Git Issues: git-workflow-specialist + execution-evaluator
Infrastructure: devops + platform-engineer
Documentation: tech-writer + accessibility-auditor
Dependencies: dependency-analyst + supply-chain-security-engineer
Linting: code-reviewer + auto-remediation
Markdown: tech-writer + code-reviewer
```bash

## Issue Resolution by Command

### /docs Issues → Auto-Fix and Retry

```text
Documentation gaps: Deploy tech-writer → generate missing docs → retry /docs
Outdated content: Deploy tech-writer → update documentation → retry /docs
API docs missing: Deploy api-architect → generate API docs → retry /docs
Broken examples: Deploy codebase-analyst → fix code samples → retry /docs
Organization issues: Execute cleanup → organize files → retry /docs --clean
```

### /review Issues → Auto-Fix and Retry

```text
Security vulnerabilities: Deploy security-auditor → fix issues → retry /review
Performance problems: Deploy performance-specialist → optimize → retry /review
Code quality issues: Deploy code-reviewer + specialists → remediate → retry /review
Test coverage gaps: Deploy test-engineer → add tests → retry /review
Documentation missing: Deploy tech-writer → generate docs → retry /review
Linting failures: Deploy code-reviewer → auto-fix → commit fixes → retry /review
Markdown violations: Deploy tech-writer → fix formatting → retry /review
Structure issues: Deploy code-reviewer → fix structure → retry /review
```bash

### /test Issues → Auto-Fix and Retry

```text
Test failures: Deploy test-engineer → fix failing tests → retry /test
Coverage too low: Deploy test-engineer → add missing tests → retry /test
Test env issues: Deploy devops → fix environment → retry /test
Dependencies missing: Deploy dependency-analyst → install deps → retry /test
Framework issues: Deploy test-engineer → configure framework → retry /test
```

### /commit Issues → Auto-Fix and Retry

```text
Staging conflicts: Deploy git-workflow-specialist → resolve conflicts → retry /commit
Pre-commit hooks fail: Apply hook fixes → commit remediation → retry /commit
Large files detected: Use .gitignore rules → stage properly → retry /commit
Temp file cleanup: Execute cleanup → retry /commit
No changes to commit: Skip gracefully, continue workflow
```bash

### /push Issues → Auto-Fix and Retry

```text
Pre-push hooks fail: Deploy specialists → fix issues → commit → retry /push
Linting failures: Deploy code-reviewer → auto-fix → commit → retry /push
Merge conflicts: Deploy git-workflow-specialist → resolve → retry /push
Branch protection: Create PR instead of direct push
Network failures: Retry with exponential backoff (up to 3 attempts)
Authentication: Guide user through auth setup → retry /push
```

### /pr Issues → Auto-Fix and Retry (Optional)

```text
Template missing: Deploy tech-writer → generate template → retry /pr
Description incomplete: Deploy tech-writer → enhance description → retry /pr
Branch conflicts: Deploy git-workflow-specialist → resolve → retry /pr
CI checks failing: Wait for checks → deploy specialists if needed
No PR needed: Skip gracefully if PR already exists
```bash

## Retry Patterns

### Automatic Retry Strategy

```yaml
Immediate Retry: For transient failures (network, temporary locks)
Fix-and-Retry: Deploy agent → apply fixes → commit if needed → retry command
Agent-Mediated: Route to specialist → verify comprehensive fix → retry original
Escalation: After 3 fix attempts, surface to user with detailed analysis
```

### Retry Limits

```yaml
Network/Transient Issues: Up to 3 retries with exponential backoff
Agent-Mediated Fixes: Up to 2 fix-and-retry cycles per command
Total Command Attempts: Maximum 5 attempts per command before escalation
Workflow Timeout: 30 minutes maximum for complete ship-it workflow
```bash

## Examples

### Full Workflow with Auto-Remediation

```bash
User: /ship-it --full
Claude: 🚀 Starting ship-it workflow: full

Step 1/8: /docs --audit
🔍 Running documentation gap analysis...
📋 Found: 5 missing API endpoints, outdated README

Step 2/8: /docs
📚 Updating all documentation...
🤖 Deploying: tech-writer, api-architect, codebase-analyst
✅ Documentation suite updated

Step 3/8: /review
📚 Reading code and documentation...
🤖 Deploying: code-reviewer, security-auditor
❌ Found 7 blocking issues: 6 line length, 1 missing section

🔧 Auto-remediation triggered:
🤖 Deploying code-reviewer for line length fixes...
✅ Fixed 6 line length violations
🤖 Deploying tech-writer for missing execution verification...
✅ Added execution verification section to plan.md
📝 Committing auto-fixes...

⏳ Retrying /review...
🤖 Re-deploying: code-reviewer, security-auditor
✅ All issues resolved - review passed!

Step 4/8: /test
🔍 Auto-discovering test framework...
✅ Tests passed (85% coverage)

Step 5/8: /docs --clean
🧹 Organizing temporary documentation files...
✅ Moved 8 files to .tmp/

Step 6/8: /commit
📝 Creating semantic commit...
✅ Commit created successfully

Step 7/8: /push
🚀 Pushing to remote...
✅ Push completed successfully

Step 8/8: /pr
🔍 Checking if PR exists...
ℹ️ PR already exists - skipping

🎉 Ship-it workflow completed with auto-remediation!
```

### Basic Workflow with Issue Resolution (Default)

```bash
User: /ship-it
Claude: 🚀 Starting ship-it workflow: basic

Step 1/5: /docs --audit
🔍 Running documentation gap analysis...
📋 Found: README setup instructions outdated

Step 2/5: /docs readme
📚 Updating README.md...
🤖 Deploying: tech-writer
✅ README.md refreshed with current setup instructions

Step 3/5: /review --quick
🤖 Deploying: code-reviewer, security-auditor (quick mode)
❌ Found linting issues in 3 files

🔧 Auto-remediation triggered:
🤖 Deploying code-reviewer for auto-fixes...
✅ Applied ESLint fixes to 3 files
📝 Committing linting fixes...

⏳ Retrying /review --quick...
✅ Quick review passed!

Step 4/5: /commit
✅ Changes already committed during auto-remediation

Step 5/5: /push
✅ Push completed successfully

🎉 Basic workflow completed with auto-remediation!
```bash

### Advanced Problem Resolution

```bash
User: /ship-it --full
Claude: 🚀 Starting ship-it workflow: full

Step 1/5: /review
❌ Found security vulnerabilities + performance issues + test gaps

🔧 Multi-agent auto-remediation:
🤖 Deploying security-auditor for 2 SQL injection fixes...
✅ Fixed authentication vulnerabilities
🤖 Deploying performance-specialist for N+1 query optimization...
✅ Optimized database queries (8s → 120ms response time)
🤖 Deploying test-engineer for missing critical tests...
✅ Added comprehensive payment processing tests
📝 Committing comprehensive fixes...

⏳ Retrying /review...
✅ All security, performance, and test issues resolved!

Step 2/5: /test
❌ 3 new tests failing due to recent fixes

🔧 Auto-remediation triggered:
🤖 Deploying test-engineer for test fixes...
✅ Updated tests to work with security changes
✅ Fixed mock data for performance optimizations

⏳ Retrying /test...
✅ All tests passing (92% coverage)

[Continues through /commit, /push, /pr successfully]

🎉 Ship-it completed - automatically resolved 15+ issues across 3 domains!
```

## Command Execution Flow

### Progressive Enhancement Pattern

```yaml
Execute Command:
  Try: Run command with full agent orchestration
  Catch: Parse errors and classify by domain
  Fix: Deploy appropriate specialists for remediation
  Retry: Re-run command with fixes applied
  Verify: Confirm issue resolution with execution-evaluator
  Continue: Move to next workflow step

Domain Routing:
  Security → security-auditor (mandatory)
  Performance → performance-specialist + monitoring-specialist
  Quality → code-reviewer + domain specialists
  Testing → test-engineer + execution-evaluator
  Infrastructure → devops + platform-engineer
  Documentation → tech-writer + accessibility-auditor
```bash

### Workflow State Management

```yaml
Progress Tracking: .tmp/ship-it/progress.log with detailed issue resolution
Command Status: PENDING → EXECUTING → ISSUES_FOUND → REMEDIATING → RESOLVED → COMPLETED
Issue Classification: Security, Performance, Quality, Testing, Infrastructure
Fix History: Track all auto-remediation actions for audit trail
Success Metrics: Commands fixed, agents deployed, retry attempts, total time
```

## Execution Verification

Deploy execution-evaluator to verify:

- ✅ **Workflow completed** - All steps executed successfully with issue resolution
- ✅ **Auto-remediation functional** - Issues automatically fixed when detected
- ✅ **Agent deployment correct** - Appropriate specialists used for each issue type
- ✅ **Retry logic working** - Failed commands retried after fixes applied
- ✅ **Progressive enhancement** - Each step builds on previous with quality gates
- ✅ **Issue classification** - Problems correctly routed to domain experts
- ✅ **State management** - Progress tracked with detailed resolution history
- ✅ **Success criteria** - All original objectives achieved despite initial failures

## Key Features

- **Meta-Command**: Orchestrates Claude to execute command sequences intelligently
- **Auto-Remediation**: Never stops - deploys agents to fix issues and retries
- **Progressive Problem Solving**: Systematic approach to issue resolution
- **Multi-Domain Expertise**: Routes issues to appropriate specialist agents
- **Resilient Execution**: Handles all common failure modes automatically
- **Three Workflows**: Basic (default, essential), Full (comprehensive with -f/--full), Lite (minimal with -l/--lite)
- **Context Awareness**: Commands run with complete repository understanding
- **Quality Gates**: Each step includes comprehensive validation
- **Audit Trail**: Complete history of issues found and fixes applied

## Success Philosophy

The `/ship-it` command embodies the principle that **development workflows should
never fail due to solvable problems**. By combining Claude's intelligence with
specialized agent deployment, it automatically resolves issues that would
traditionally require manual intervention, ensuring that code always ships
when technically feasible.

**"Fix Forward, Never Fail Back"** - The ship-it mindset.

## Notes

- Commands are executed by Claude with full agent orchestration
- **Auto-remediation is mandatory** - workflows don't stop for solvable issues
- Each command leverages Claude's specialized agents and intelligence
- /pr command is optional and won't block workflow if it fails
- Maximum 3 fix-and-retry cycles per command before escalation
- All auto-fixes are committed with detailed commit messages
- Progress tracked in `.tmp/ship-it/` for audit and debugging
