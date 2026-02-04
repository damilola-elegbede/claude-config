---
description: Orchestrate development workflows with composable flags
argument-hint: "[-d] [-t] [-c] [-r] [-p] [-pr] [--dry-run]"
---

# /ship-it Command

## Usage

```bash
/ship-it                    # Full: docs → test → commit → review → push → pr
/ship-it -c -p              # Quick: commit → push
/ship-it -t -c -p           # Test first: test → commit → push
/ship-it -r -c -p           # Review gate: commit → review → push
/ship-it -d -t -c -r -p     # Everything except PR
/ship-it -pr                # Just create PR
/ship-it --dry-run          # Preview full workflow
```

## Description

Pure orchestrator that composes workflow steps. Each flag enables a step.
With no flags, runs the full workflow.

## Flags

| Flag | Command |
|------|---------|
| `-d` | `/docs` |
| `-t` | `/test` |
| `-c` | `/commit` |
| `-r` | `/review` |
| `-p` | `/push` |
| `-pr` | `/pr` |
| `--dry-run` | Preview only |

## Execution Script

```text
STEP 1: Parse flags
  PARSE: $ARGUMENTS for flags: -d, -t, -c, -r, -p, -pr, --dry-run

  IF: no step flags provided
    SET: enabled_steps = [docs, test, commit, review, push, pr]
  ELSE:
    SET: enabled_steps = [flags that were provided]

  SORT: enabled_steps by fixed order: docs → test → commit → review → push → pr
  OUTPUT: "🚀 ship-it: {enabled_steps joined by ' → '}"

STEP 2: Dry-run check
  IF: --dry-run flag set
    OUTPUT: "Steps that would execute:\n{foreach step: '  📋 /{step}'}"
    END

STEP 3: Create task plan with dependencies
  USE: TaskCreate for each enabled step with proper dependencies

  Example task creation (for full workflow):
    TaskCreate: "Generate documentation" (no blockers)
    TaskCreate: "Run test suite" (no blockers - can run parallel with docs)
    TaskCreate: "Create semantic commit" (blockedBy: docs, test)
    TaskCreate: "Execute code review" (blockedBy: commit)
    TaskCreate: "Push to remote" (blockedBy: review)
    TaskCreate: "Create pull request" (blockedBy: push)

  USE: TaskUpdate to set dependencies between tasks:
    - commit blocked by: docs, test (both must complete first)
    - review blocked by: commit
    - push blocked by: review
    - pr blocked by: push

STEP 4: Execute with progress tracking
  FOR_EACH: unblocked task in task list (use TaskList to find next)
    TaskUpdate: task → in_progress
    OUTPUT: "📋 {task.activeForm}..."

    Command: "/{step}"
    WAIT: for command completion

    IF: command returned failure
      OUTPUT: "❌ Step '{step}' failed. Halting."
      TaskList: show current progress
      END

    TaskUpdate: task → completed
    OUTPUT: "✅ {step} complete"

STEP 5: Summary
  TaskList: show final status
  OUTPUT: "🎉 Complete ({completed_count}/{total_steps} steps)"
  END
```

## Expected Output

```text
🚀 ship-it: docs → test → commit → review → push → pr

📋 Step 1/6: docs
  ✅ docs complete

📋 Step 2/6: test
  ✅ test complete

📋 Step 3/6: commit
  ✅ commit complete

📋 Step 4/6: review
  ✅ review complete

📋 Step 5/6: push
  ✅ push complete

📋 Step 6/6: pr
  ✅ pr complete

🎉 Complete (6/6 steps)
PR: https://github.com/org/repo/pull/123
```

## Notes

- Pure orchestrator: invokes commands and halts on failure
- Steps always execute in fixed order: docs → test → commit → review → push → pr
- Each command handles its own validation (main/master checks, existing PR, etc.)
- Halts immediately on any step failure
