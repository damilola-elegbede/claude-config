# /ship-it Command

## Description

Instructs Claude to execute a development workflow by running multiple Claude commands in sequence.
Leverages Claude's full intelligence and agent orchestration for each step.

## Usage

```bash
/ship-it                    # Full workflow (default)
/ship-it --basic            # Basic workflow
/ship-it --quick            # Quick workflow
```

## Workflows

```text
Full (Default): /commit → /review → /test → /push --simple → /pr (if no PR exists)
Basic: /commit → /review --quick → /push --simple
Quick: /commit → /push --simple
```

## Behavior

When invoked, I will execute a sequence of Claude commands with full agent orchestration.
Each command runs with complete context awareness, specialized agents, and quality gates.
The workflow continues sequentially with **automatic issue resolution** - when commands report
problems, I deploy appropriate agents to fix them and retry until success.

## Execution Logic

```bash
ship_it() {
  local workflow="${1:-full}"

  echo "🚀 Starting ship-it workflow: $workflow"
  echo ""

  case "$workflow" in
    "quick")
      echo "I will now execute the Quick workflow:"
      echo "1. /commit - Stage changes and create commit (no review)"
      echo "2. /push --simple - Safe repository operations with basic validation"
      ;;
    "basic")
      echo "I will now execute the Basic workflow:"
      echo "1. /commit - Stage changes and create commit with semantic messaging"
      echo "2. /review --quick - Quick code review with essential checks on staged commit"
      echo "3. /push --simple - Safe repository operations (review already done)"
      ;;
    "full"|*)
      echo "I will now execute the Full workflow:"
      echo "1. /commit - Stage changes and create commit with semantic messaging"
      echo "2. /review - Multi-agent code analysis with comprehensive quality gates on staged commit"
      echo "3. /test - Intelligent test discovery and execution with framework detection"
      echo "4. /push --simple - Safe repository operations (review already done)"
      echo "5. /pr - Intelligent PR creation with context-aware descriptions (if no PR exists)"
      ;;
  esac
  echo ""
  echo "Each command will use Claude's full intelligence with:"
  echo "• Agent orchestration and specialized expertise"
  echo "• Context awareness and quality gates"
  echo "• Automatic issue resolution (deploy agents to fix problems)"
  echo "• Retry failed steps until success (except /pr which is non-fatal)"
  echo ""
  echo "Ready to begin the workflow."
}
```

## Automatic Issue Resolution

When commands report problems, I automatically deploy appropriate agents to resolve them:

### /commit Issues
```text
Staging conflicts: Use git-workflow-specialist to resolve merge issues
Temp file cleanup: Execute cleanup and retry commit
Pre-commit hooks fail: Apply fixes from hooks and retry commit
Large files detected: Use .gitignore rules and retry
```

### /review Issues
```text
Security vulnerabilities: Deploy security-auditor → fix issues → retry
Performance problems: Deploy performance-specialist → optimize → retry
Code quality issues: Deploy code-reviewer + specialists → remediate → retry
Test coverage gaps: Deploy test-engineer → add tests → retry
Documentation missing: Deploy tech-writer → generate docs → retry
```

### /test Issues
```text
Test failures: Deploy test-engineer → fix failing tests → retry
Coverage too low: Deploy test-engineer → add missing tests → retry
Test env issues: Deploy devops → fix environment → retry
Dependencies missing: Install requirements → retry
```

### /push Issues
```text
Pre-push hooks fail: Apply hook fixes → commit fixes → retry push
Linting failures: Auto-fix with formatters → commit → retry push
Merge conflicts: Deploy git-workflow-specialist → resolve → retry
Branch protection: Create PR instead of direct push
Network failures: Retry with exponential backoff
```

### /pr Issues
```text
Template missing: Generate PR template → retry
Description incomplete: Deploy tech-writer → enhance description → retry
Branch conflicts: Deploy git-workflow-specialist → resolve → retry
CI checks failing: Wait for checks → deploy specialists if needed
```

## Resolution Strategies

### Progressive Problem Solving
1. **Identify Issue**: Parse command output for specific error patterns
2. **Deploy Specialist**: Route to appropriate agent based on error type
3. **Apply Fixes**: Let agent implement solutions automatically
4. **Verify Resolution**: Re-run original command to confirm success
5. **Continue Workflow**: Move to next step once resolved

### Agent Routing Logic
```text
Security Issues → security-auditor (always, non-negotiable)
Performance Issues → performance-specialist + monitoring-specialist
Code Quality → code-reviewer + backend-engineer/frontend-architect
Testing Issues → test-engineer + execution-evaluator
Git Issues → git-workflow-specialist + execution-evaluator
Infrastructure → devops + platform-engineer
Documentation → tech-writer
Dependencies → dependency-analyst + package managers
```

### Retry Patterns
```text
Transient Failures: Retry up to 3 times with backoff
Fix-and-Retry: Apply fixes, commit if needed, then retry original command
Agent-Mediated: Deploy specialist → verify fix → retry original
Escalation: If 3 attempts fail, surface to user with analysis
```

## Examples

### Full Workflow

```bash
User: /ship-it
Claude: 🚀 Starting ship-it workflow: full

I will now execute the Full workflow:
1. /commit - Stage changes and create commit with semantic messaging
2. /review - Multi-agent code analysis with comprehensive quality gates on staged commit
3. /test - Intelligent test discovery and execution with framework detection
4. /push --simple - Safe repository operations (review already done)
5. /pr - Intelligent PR creation with context-aware descriptions (if no PR exists)

Each command will use Claude's full intelligence with:
• Agent orchestration and specialized expertise
• Context awareness and quality gates
• Automatic issue resolution (deploy agents to fix problems)
• Retry failed steps until success (except /pr which is non-fatal)

Ready to begin the workflow.

[Claude executes /commit successfully]
[Claude executes /review - finds 3 security issues]
🤖 Deploying security-auditor to fix vulnerabilities...
✅ Security issues resolved, committing fixes
[Claude retries /review - all checks pass]
[Claude executes /test - 2 tests failing]
🤖 Deploying test-engineer to fix failing tests...
✅ Tests fixed and passing
[Claude executes /push --simple successfully]
[Claude executes /pr successfully]
```

### Basic Workflow

```bash
User: /ship-it --basic
Claude: 🚀 Starting ship-it workflow: basic

I will now execute the Basic workflow:
1. /commit - Stage changes and create commit with semantic messaging
2. /review --quick - Quick code review with essential checks on staged commit
3. /push --simple - Safe repository operations (review already done)

Each command will use Claude's full intelligence with:
• Agent orchestration and specialized expertise
• Context awareness and quality gates
• Automatic issue resolution (deploy agents to fix problems)
• Retry failed steps until success (except /pr which is non-fatal)

Ready to begin the workflow.
```

### Quick Workflow

```bash
User: /ship-it --quick
Claude: 🚀 Starting ship-it workflow: quick

I will now execute the Quick workflow:
1. /commit - Stage changes and create commit (no review)
2. /push --simple - Safe repository operations with basic validation

Each command will use Claude's full intelligence with:
• Agent orchestration and specialized expertise
• Context awareness and quality gates
• Automatic issue resolution (deploy agents to fix problems)
• Retry failed steps until success (except /pr which is non-fatal)

Ready to begin the workflow.
```

### Problem Resolution Example

```bash
User: /ship-it
Claude: 🚀 Starting ship-it workflow: full

[Claude executes /commit successfully]
[Claude executes /review - finds linting issues]
🤖 Deploying code-reviewer + frontend-architect for auto-remediation...
✅ Linting issues fixed, committing remediation
[Claude retries /review - all checks pass]
[Claude executes /test successfully]
[Claude executes /push --simple - pre-push hooks fail]
⚠️ Pre-push hooks failed: ESLint errors detected
🤖 Applying ESLint auto-fixes...
📝 Committing hook fixes
[Claude retries /push --simple successfully]
[Claude executes /pr successfully]

🎉 Full workflow completed with automatic issue resolution
```

## Key Features

- **Meta-Command**: Instructs Claude to execute command sequences with full intelligence
- **Agent Orchestration**: Each command uses specialized agents and quality gates
- **Three Workflows**: Full (5 commands), basic (3 commands), quick (2 commands)
- **Context Awareness**: Commands run with complete repository and change context
- **Auto-Remediation**: Automatically deploys agents to fix issues and retries until success
- **Resilient Execution**: Handles pre-push hooks, test failures, security issues, and linting errors
- **Progressive Problem Solving**: Identifies → Deploy Specialists → Apply Fixes → Retry → Continue

## Notes

- Commands are executed by Claude with full agent orchestration, not bash functions
- Each command leverages Claude's specialized agents and intelligence
- **Auto-remediation**: Commands don't fail - they deploy agents to fix issues and retry
- **Resilient workflow**: Handles pre-push hooks, test failures, review comments automatically
- /pr command is non-fatal and will continue workflow even if it fails
- Default workflow is "full" if no flags specified
- Up to 3 retry attempts per command with specialized agent intervention
