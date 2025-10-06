---
description: Orchestrate development workflows with inline wave execution
argument-hint: [-f|--full|-l|--lite]
thinking-level: megathink
thinking-tokens: 10000
---

# /ship-it Command

## Usage

```bash
/ship-it                         # Basic workflow: docs → test → commit → push
/ship-it --full | -f             # Full workflow: docs → test → commit → push → pr
/ship-it --lite | -l             # Lite workflow: commit → push
# Note: -f/-l are maintained for backward compatibility; prefer long flags
```

## Description

Orchestrates development workflows with a focus on simplicity and efficiency (KISS principle).
Executes essential quality checks through minimal agent deployment.

### Thinking Level: MEGATHINK (10,000 tokens)

Required for coordinating workflow steps, managing agent deployments, and handling
commit message generation across the entire workflow.

## Workflow Types

Based on `$ARGUMENTS`:

- **Lite**: Commit → Push
- **Basic**: Docs → Test → Commit → Push
- **Full**: Docs → Test → Commit → Push → PR (only if PR doesn't exist)

## Step 1: Documentation Gaps (Basic/Full only)

Deploy single tech-writer agent:

```yaml
tech-writer:
  role: Identify documentation gaps
  focus: Missing docs, outdated content, coverage analysis
  exclusions: All CLAUDE.md files skipped
  output: Gap inventory for information only (no generation in audit mode)
```

## Step 2: Test Execution (Basic/Full)

Deploy 2 test-engineer agents in parallel:

```yaml
test-engineer (2 instances):
  - instance_1: Unit tests
  - instance_2: Integration tests

parallel_execution: Both test types simultaneously
timeout: 30 seconds per instance
```

### Test Failure Handling

If tests fail, Claude analyzes failures and determines next steps:

- Auto-fixable issues: Deploy fix agents
- Manual review needed: Report to user with details

## Step 3: Commit Creation (All workflows)

Claude generates commit message directly after docs and tests complete:

1. Analyze git status and changes
2. Review git log for commit message style
3. Generate concise commit message focusing on "why" over "what"
4. Create commit with standard format:

```text
<type>: <description>

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

**NEVER use --no-verify**. Quality gates must be respected.

## Step 4: Push Changes (All workflows)

Execute push with basic validation:

```bash
# Check branch tracking (ignore if upstream not yet set)
git rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1 || true

# Push to remote
git push -u origin <branch-name>

# Verify push success
git log --oneline -1
```

## Step 5: PR Creation (Full only)

Only execute if `--full` flag is used:

1. **Check for existing PR**:

   ```bash
   gh pr list --head <branch-name> --json number,url
   ```

2. **If no PR exists**, create one:
   - Analyze changes from `git diff main...HEAD`
   - Review commit messages
   - Generate conventional commit title
   - Create concise description
   - Submit with `gh pr create`

3. **If PR exists**, skip creation and report URL

## Expected Output

### Successful Full Workflow

```text
🚀 Starting ship-it workflow: full

📋 Step 1/5: Documentation Gaps
  🔍 Deploying tech-writer agent
  ✅ 3 documentation gaps identified

📋 Step 2/5: Test Execution
  🧪 Running unit and integration tests (2 agents parallel)
  ✅ All tests passing

📋 Step 3/5: Commit Creation
  📝 Generating commit message
  ✅ Commit created: feat: add user authentication

📋 Step 4/5: Push Changes
  ⬆️ Pushing to origin/enhancement/workflow-updates
  ✅ Push successful

📋 Step 5/5: PR Creation
  🔍 Checking for existing PR
  ✅ PR created: https://github.com/owner/repo/pull/123

🎉 Ship-it completed successfully!
  - 5/5 steps completed
  - 3 agents deployed
  - Total time: 3 minutes 12 seconds
```

### Successful Basic Workflow

```text
🚀 Starting ship-it workflow: basic

📋 Step 1/4: Documentation Gaps
  🔍 Deploying tech-writer agent
  ✅ 2 documentation gaps identified

📋 Step 2/4: Test Execution
  🧪 Running unit and integration tests
  ✅ All tests passing

📋 Step 3/4: Commit Creation
  📝 Generating commit message
  ✅ Commit created: fix: resolve authentication bug

📋 Step 4/4: Push Changes
  ⬆️ Pushing to origin/enhancement/workflow-updates
  ✅ Push successful

🎉 Ship-it completed successfully!
  - 4/4 steps completed
  - 3 agents deployed
  - Total time: 2 minutes 48 seconds
```

### Successful Lite Workflow

```text
🚀 Starting ship-it workflow: lite

📋 Step 1/2: Commit Creation
  📝 Generating commit message
  ✅ Commit created: chore: update dependencies

📋 Step 2/2: Push Changes
  ⬆️ Pushing to origin/enhancement/workflow-updates
  ✅ Push successful

🎉 Ship-it completed successfully!
  - 2/2 steps completed
  - Total time: 45 seconds
```

### With Test Failures

```text
🚀 Starting ship-it workflow: basic

📋 Step 1/4: Documentation Gaps
  🔍 Deploying tech-writer agent
  ✅ 1 documentation gap identified

📋 Step 2/4: Test Execution
  🧪 Running unit and integration tests
  ⚠️ 3 test failures detected
  🔧 Deploying fix agents
  ✅ Tests passing after fixes

📋 Step 3/4: Commit Creation
  📝 Generating commit message
  ✅ Commit created: fix: resolve user service tests

📋 Step 4/4: Push Changes
  ⬆️ Pushing to origin/enhancement/workflow-updates
  ✅ Push successful

🎉 Ship-it completed with auto-recovery!
  - 4/4 steps completed
  - 5 agents deployed (2 test + 3 fix)
  - All issues auto-resolved
```

## Performance Metrics

```yaml
Execution Times:
  Lite: ~1 minute (commit + push)
  Basic: 2-3 minutes (4 steps)
  Full: 3-4 minutes (5 steps)

Agent Deployment:
  Lite: 0 agents
  Basic: 3 agents (1 tech-writer + 2 test-engineer)
  Full: 3 agents (1 tech-writer + 2 test-engineer)

Parallelization:
  Tests: 2 agents simultaneously
  Auto-remediation: Deploy as needed for failures
```

## Quality Gates

```yaml
Non-Negotiable:
  - NEVER use --no-verify flags
  - NEVER bypass pre-commit hooks
  - Fix issues, don't bypass them
  - Respect existing PR (don't create duplicates)
```

## Success Criteria

- Essential quality checks passed (docs, tests)
- Commit created with proper message format
- Push successful
- PR created only in full mode and only if none exists
- Total execution under 5 minutes
- Minimal agent deployment (KISS principle)
