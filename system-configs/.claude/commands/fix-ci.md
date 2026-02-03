---
description: Diagnoses and fixes GitHub Actions CI failures
argument-hint: [run-id|--learn]
---

# /fix-ci Command

## Usage

```bash
/fix-ci              # Fix latest failure
/fix-ci 12345678     # Fix specific run
/fix-ci --learn      # Show historical fix patterns
```

## Description

Two-phase CI failure resolution: diagnose with debugger agents, then fix with domain-specialized agents.

## Architecture

### Phase 1: Diagnosis (Parallel Debuggers)

Deploy debugger agents in parallel to investigate each failure. Each debugger returns:

- **Root cause**: What actually failed and why
- **Domain**: Classification for agent routing (see matrix below)
- **Files**: Specific files that need changes
- **Fix approach**: Recommended solution

### Phase 2: Fix (Specialized Agents)

Route fixes to domain experts based on diagnosis:

| Domain | Fix Agent | Examples |
|--------|-----------|----------|
| test | test-engineer | Test failures, missing mocks, assertion errors |
| security | security-auditor | Auth issues, credential problems, vulnerability fixes |
| frontend | frontend-engineer | React/Vue errors, CSS issues, client-side bugs |
| backend | backend-engineer | API errors, server logic, microservice issues |
| data | data-engineer | Database errors, migration issues, query problems |
| pipeline | devops | Workflow syntax, CI config, deployment issues |
| architecture | architect | Design issues, unclear domains, cross-cutting concerns |

## Workflow

```text
┌─────────────────────────────────────────────────────────────────┐
│ 1. FETCH                                                        │
│    gh run view <run-id> --json jobs                            │
│    → Get failure details from GitHub Actions API                │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ 2. DIAGNOSE (Parallel)                                          │
│    Deploy N debugger agents (one per failure)                   │
│    Each returns: { root_cause, domain, files, fix_approach }    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ 3. CLASSIFY                                                     │
│    Group fixes by domain                                        │
│    Map to specialized agents                                    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ 4. FIX (Parallel)                                               │
│    Deploy specialized agents based on classification            │
│    Each agent fixes issues in their domain                      │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ 5. VERIFY                                                       │
│    Commit fixes, push to remote                                 │
│    Monitor CI run until complete                                │
│    If still failing → iterate from step 1                       │
└─────────────────────────────────────────────────────────────────┘
```

## Execution Steps

### Step 1: Create Task Plan

```text
TaskCreate: "Fetch CI failure details" (no blockers)
TaskCreate: "Diagnose failures" (blockedBy: fetch)
TaskCreate: "Classify and route fixes" (blockedBy: diagnose)
TaskCreate: "Apply fixes" (blockedBy: classify)
TaskCreate: "Verify CI passes" (blockedBy: fixes)
```

### Step 2: Fetch CI Failures

```text
TaskUpdate: "Fetch CI failure details" → in_progress
```

```bash
# Get latest failed run (or use provided run-id)
gh run list --status failure --limit 1 --json databaseId,conclusion,event
gh run view <run-id> --json jobs,conclusion
```

Extract: job names, failure messages, log URLs

```text
TaskUpdate: "Fetch CI failure details" → completed
```

### Step 3: Deploy Diagnosis Agents (Parallel)

```text
TaskUpdate: "Diagnose failures" → in_progress
```

For each failed job, deploy a debugger agent **in parallel using run_in_background: true**:

```text
# Launch ALL debugger agents in a SINGLE message with multiple Task tool calls
# Each Task tool call should have run_in_background: true

Task 1 (background):
  subagent_type: "debugger"
  run_in_background: true
  prompt: "Investigate CI failure in job '<job-1-name>':..."

Task 2 (background):
  subagent_type: "debugger"
  run_in_background: true
  prompt: "Investigate CI failure in job '<job-2-name>':..."

# Wait for all to complete using TaskOutput
```

Each debugger returns JSON diagnosis:

```json
{
  "root_cause": "Brief description of what failed",
  "domain": "test|security|frontend|backend|data|pipeline|architecture",
  "files": ["list", "of", "files", "to", "fix"],
  "fix_approach": "How to fix this issue"
}
```

```text
TaskUpdate: "Diagnose failures" → completed
```

### Step 4: Route to Specialized Agents (Parallel)

```text
TaskUpdate: "Classify and route fixes" → in_progress
```

Based on diagnosis domains, deploy fix agents **in parallel using run_in_background: true**:

| Diagnosis Domain | Deploy Agent |
|------------------|--------------|
| test | test-engineer |
| security | security-auditor |
| frontend | frontend-engineer |
| backend | backend-engineer |
| data | data-engineer |
| pipeline | devops |
| architecture | architect |

```text
# Launch ALL fix agents in a SINGLE message with multiple Task tool calls
# Each Task tool call should have run_in_background: true

Task 1 (background):
  subagent_type: "<domain-specific-agent>"
  run_in_background: true
  prompt: "Fix the following CI failure:
    - Root cause: <from diagnosis>
    - Files to modify: <from diagnosis>
    - Approach: <from diagnosis>
    Implement the fix. Do not make unrelated changes."

# Wait for all to complete using TaskOutput
```

```text
TaskUpdate: "Classify and route fixes" → completed
TaskUpdate: "Apply fixes" → completed
```

### Step 5: Commit and Verify

```text
TaskUpdate: "Verify CI passes" → in_progress
```

```bash
# Stage and commit fixes
git add -A
git commit -m "fix(ci): <summary of fixes>"

# Push and monitor
git push
gh run watch
```

```text
TaskUpdate: "Verify CI passes" → completed
```

### Step 6: Iterate if Needed

If CI still fails after fix:

1. Fetch new failure data
2. Re-diagnose (may be different issues)
3. Deploy appropriate fix agents
4. Continue until green

```text
TaskList: show final status of all phases
```

## Expected Output

```text
User: /fix-ci

🔍 Fetching CI failures from run #987654...
📊 Found 3 failures: lint, test:unit, build

🔬 Phase 1: Diagnosis
   Deploying 3 debugger agents in parallel...

   Job: lint
   └─ Domain: frontend
   └─ Cause: ESLint error in auth.ts - unused variable
   └─ Files: src/auth.ts

   Job: test:unit
   └─ Domain: test
   └─ Cause: Mock outdated for new API response shape
   └─ Files: tests/api.test.ts

   Job: build
   └─ Domain: pipeline
   └─ Cause: Missing dependency declaration
   └─ Files: package.json

🔧 Phase 2: Fix
   Deploying 3 specialized agents:
   └─ frontend-engineer → src/auth.ts
   └─ test-engineer → tests/api.test.ts
   └─ devops → package.json

   ✓ frontend-engineer: Removed unused variable
   ✓ test-engineer: Updated mock to match new API shape
   ✓ devops: Added missing dependency

💾 Committed and pushed...

📊 Monitoring CI run #987655...
⏳ Running... (2 min)

✅ All CI checks passed!
🎉 CI fixed in 1 iteration
```

### Learn Mode

```text
User: /fix-ci --learn

📊 Historical Fix Patterns (last 30 days):

By Domain:
  test        │ ████████████████ │ 42% (21 fixes)
  frontend    │ ████████         │ 22% (11 fixes)
  pipeline    │ ██████           │ 16% (8 fixes)
  backend     │ ████             │ 10% (5 fixes)
  security    │ ██               │  6% (3 fixes)
  data        │ ██               │  4% (2 fixes)

Success Rate by Agent:
  test-engineer      │ 95% (20/21)
  frontend-engineer  │ 91% (10/11)
  devops             │ 88% (7/8)
  backend-engineer   │ 80% (4/5)

Common Root Causes:
  1. Outdated test mocks (18 occurrences)
  2. Lint violations (12 occurrences)
  3. Missing dependencies (6 occurrences)
```

## Notes

- Two-phase architecture separates diagnosis from fixing
- Debuggers identify root cause; specialists apply fixes
- Parallel execution for both phases when possible
- Domain classification ensures expert handling
- Iterates until GitHub shows all checks green
