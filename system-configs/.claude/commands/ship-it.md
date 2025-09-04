---
description: Orchestrate development workflows with auto-resolution
argument-hint: [--full | --lite]
---

# /ship-it Command

## Usage

```bash
/ship-it                         # Basic workflow: docs audit → review → commit → push
/ship-it --full                  # Full workflow: docs → review → test → commit → push → pr
/ship-it --lite                  # Lite workflow: commit → push
```

Use `$ARGUMENTS` to determine workflow type (empty for basic, `--full` or `-f` for full, `--lite` or `-l` for lite).

## Description

Orchestrate development workflows by running multiple `/` commands in sequence with **automatic issue resolution**.
When commands report problems, deploy specialized agents to fix them and retry until success. Never stop on failures -
always find a way forward.

Execute one of three workflow types:

- **Basic (default)**: `/docs --audit` → `/docs readme` → `/review --quick` → `/commit` → `/push`
- **Full (--full/-f)**: `/docs --audit` → `/docs` → `/review` → `/test` → `/docs --clean` → `/commit` → `/push` → `/pr`
- **Lite (--lite/-l)**: `/commit` → `/push`

## Expected Output

### Execution Flow Example

```text
🚀 Starting ship-it workflow: [basic|full|lite]

Step X/Y: [command]
[Command execution and results]

🔧 Auto-remediation triggered:
🤖 Deploying [agent] for [issue type]...
✅ [Fix description]
📝 Committing auto-fixes...

⏳ Retrying [command]...
✅ [Success confirmation]

🎉 Ship-it workflow completed with auto-remediation!
```

## Behavior

### Core Principles

- **Auto-Remediation**: Commands don't fail - they deploy agents to fix issues
- **Progressive Problem Solving**: Identify → Deploy Specialists → Apply Fixes → Retry → Continue
- **Resilient Execution**: Handle all failure modes through agent deployment
- **Smart PR Detection**: Create PR only if none exists for current branch
- **Never Give Up**: Retry with fixes until success (except /pr which is optional)

### Auto-Remediation Workflow

When commands report problems:

1. **Identify Issue**: Parse command output for specific error patterns
2. **Deploy Specialist**: Route to appropriate agent based on error type
3. **Apply Fixes**: Let agent implement solutions automatically
4. **Verify Resolution**: Re-run original command to confirm success
5. **Continue Workflow**: Move to next step once resolved

### Agent Routing Logic

```yaml
Security Issues: security-auditor (always, non-negotiable)
Performance Issues: performance-specialist + performance-engineer
Code Quality: code-reviewer + backend-engineer/frontend-architect
Testing Issues: test-engineer + execution-evaluator
Git Issues: devops + execution-evaluator
Infrastructure: devops + platform-engineer
Documentation: tech-writer + accessibility-auditor
Dependencies: security-auditor + security-auditor
Linting: code-reviewer + auto-remediation
Markdown: tech-writer + code-reviewer
```

### Parallel Workflow Orchestration

Deploy project-orchestrator for workflow optimization:

```yaml
project-orchestrator:
  role: Identify parallelization opportunities
  input: Workflow dependencies, command requirements
  output: Parallel execution plan

project-orchestrator:
  role: Handle critical failures and recovery
  input: Failure patterns, system state
  output: Recovery strategy, remediation steps

Parallel Execution:
  - Independent commands run simultaneously
  - docs + review can run in parallel
  - Multiple fix agents deploy concurrently
```

### Issue Resolution by Command

#### /docs Issues → Auto-Fix and Retry

- Documentation gaps: Deploy tech-writer → generate missing docs → retry /docs
- Outdated content: Deploy tech-writer → update documentation → retry /docs
- API docs missing: Deploy api-architect → generate API docs → retry /docs
- Broken examples: Deploy codebase-analyst → fix code samples → retry /docs
- Organization issues: Execute cleanup → organize files → retry /docs --clean

#### /review Issues → Auto-Fix and Retry

- Security vulnerabilities: Deploy security-auditor → fix issues → retry /review
- Performance problems: Deploy performance-specialist → optimize → retry /review
- Code quality issues: Deploy code-reviewer + specialists → remediate → retry /review
- Test coverage gaps: Deploy test-engineer → add tests → retry /review
- Documentation missing: Deploy tech-writer → generate docs → retry /review
- Linting failures: Deploy code-reviewer → auto-fix → commit fixes → retry /review
- Markdown violations: Deploy tech-writer → fix formatting → retry /review
- Structure issues: Deploy code-reviewer → fix structure → retry /review

#### /test Issues → Auto-Fix and Retry

- Test failures: Deploy test-engineer → fix failing tests → retry /test
- Coverage too low: Deploy test-engineer → add missing tests → retry /test
- Test env issues: Deploy devops → fix environment → retry /test
- Dependencies missing: Deploy security-auditor → install deps → retry /test
- Framework issues: Deploy test-engineer → configure framework → retry /test

#### /commit Issues → Auto-Fix and Retry

- Staging conflicts: Deploy devops → resolve conflicts → retry /commit
- Pre-commit hooks fail: Apply hook fixes → commit remediation → retry /commit
- Large files detected: Use .gitignore rules → stage properly → retry /commit
- Temp file cleanup: Execute cleanup → retry /commit
- No changes to commit: Skip gracefully, continue workflow

#### /push Issues → Auto-Fix and Retry

- Pre-push hooks fail: Deploy specialists → fix issues → commit → retry /push
- Linting failures: Deploy code-reviewer → auto-fix → commit → retry /push
- Merge conflicts: Deploy devops → resolve → retry /push
- Branch protection: Create PR instead of direct push
- Network failures: Retry with exponential backoff (up to 3 attempts)
- Authentication: Guide user through auth setup → retry /push

#### /pr Issues → Auto-Fix and Retry (Optional)

- Template missing: Deploy tech-writer → generate template → retry /pr
- Description incomplete: Deploy tech-writer → enhance description → retry /pr
- Branch conflicts: Deploy devops → resolve → retry /pr
- CI checks failing: Wait for checks → deploy specialists if needed
- No PR needed: Skip gracefully if PR already exists

### Retry Patterns

#### Automatic Retry Strategy

```yaml
Immediate Retry: For transient failures (network, temporary locks)
Fix-and-Retry: Deploy agent → apply fixes → commit if needed → retry command
Agent-Mediated: Route to specialist → verify comprehensive fix → retry original
Escalation: After 3 fix attempts, surface to user with detailed analysis
```

#### Retry Limits

```yaml
Network/Transient Issues: Up to 3 retries with exponential backoff
Agent-Mediated Fixes: Up to 2 fix-and-retry cycles per command
Total Command Attempts: Maximum 5 attempts per command before escalation
Workflow Timeout: 30 minutes maximum for complete ship-it workflow
```

### Workflow State Management

```yaml
Progress Tracking: .tmp/ship-it/progress.log with detailed issue resolution
Command Status: PENDING → EXECUTING → ISSUES_FOUND → REMEDIATING → RESOLVED → COMPLETED
Issue Classification: Security, Performance, Quality, Testing, Infrastructure
Fix History: Track all auto-remediation actions for audit trail
Success Metrics: Commands fixed, agents deployed, retry attempts, total time
```
