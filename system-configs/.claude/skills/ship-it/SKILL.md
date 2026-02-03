---
name: ship-it
description: Orchestrate development workflows with composable flags
category: orchestration
context: fork
user-invocable: true
allowed-tools: Skill, Task, TaskCreate, TaskUpdate, TaskList, TaskOutput
---

# /ship-it Skill

Pure orchestrator that composes workflow steps with task tracking. Each flag enables
a step. With no flags, runs the full workflow.

## Usage

```bash
/ship-it                    # Full: docs -> test -> commit -> review -> push -> pr
/ship-it -c -p              # Quick: commit -> push
/ship-it -t -c -p           # Test first: test -> commit -> push
/ship-it -r -c -p           # Review gate: commit -> review -> push
/ship-it -d -t -c -r -p     # Everything except PR
/ship-it -pr                # Just create PR
/ship-it --dry-run          # Preview full workflow
```

## Architecture

This skill uses:

- `context: fork` - Isolates workflow execution from main conversation
- Task system - Tracks progress through each phase with dependencies
- Skill tool - Invokes individual commands (/docs, /test, /commit, etc.)

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

## Execution

### Step 1: Parse Flags

```text
PARSE: $ARGUMENTS for flags: -d, -t, -c, -r, -p, -pr, --dry-run

IF: no step flags provided
  SET: enabled_steps = [docs, test, commit, review, push, pr]
ELSE:
  SET: enabled_steps = [flags that were provided]

SORT: enabled_steps by fixed order: docs -> test -> commit -> review -> push -> pr
OUTPUT: "ship-it: {enabled_steps joined by ' -> '}"
```

### Step 2: Dry-run Check

```text
IF: --dry-run flag set
  OUTPUT: "Steps that would execute:\n{foreach step: '  /{step}'}"
  END
```

### Step 3: Create Task Plan with Dependencies

```text
USE: TaskCreate for each enabled step with proper dependencies

Example task creation (for full workflow):
  TaskCreate: "Generate documentation" (no blockers)
    activeForm: "Generating documentation"
  TaskCreate: "Run test suite" (no blockers - can run parallel with docs)
    activeForm: "Running tests"
  TaskCreate: "Create semantic commit" (blockedBy: docs, test)
    activeForm: "Creating commit"
  TaskCreate: "Execute code review" (blockedBy: commit)
    activeForm: "Running code review"
  TaskCreate: "Push to remote" (blockedBy: review)
    activeForm: "Pushing to remote"
  TaskCreate: "Create pull request" (blockedBy: push)
    activeForm: "Creating pull request"

Dependencies are automatically enforced via blockedBy parameter in TaskCreate:
  - commit blocked by: docs, test (both must complete first)
  - review blocked by: commit
  - push blocked by: review
  - pr blocked by: push
```

### Step 4: Execute with Progress Tracking

```text
FOR_EACH: unblocked task in task list (use TaskList to find next)
  TaskUpdate: task -> in_progress
  OUTPUT: "{task.activeForm}..."

  Skill tool: skill="{step}"
  WAIT: for Skill tool completion

  IF: skill returned failure
    OUTPUT: "Step '{step}' failed. Halting."
    TaskList: show current progress
    END

  TaskUpdate: task -> completed
  OUTPUT: "{step} complete"
```

### Step 5: Summary

```text
TaskList: show final status
OUTPUT: "Complete ({completed_count}/{total_steps} steps)"
```

## Expected Output

```text
ship-it: docs -> test -> commit -> review -> push -> pr

Step 1/6: docs
  docs complete

Step 2/6: test
  test complete

Step 3/6: commit
  commit complete

Step 4/6: review
  review complete

Step 5/6: push
  push complete

Step 6/6: pr
  pr complete

Complete (6/6 steps)
PR: https://github.com/org/repo/pull/123
```

## Task Dependencies Visualization

```text
     docs ----+
              |---> commit ---> review ---> push ---> pr
     test ----+
```

- `docs` and `test` can run in parallel (no dependencies)
- `commit` waits for both `docs` and `test`
- `review` waits for `commit`
- `push` waits for `review`
- `pr` waits for `push`

## Notes

- Pure orchestrator: invokes commands and halts on failure
- Steps always execute in fixed order
- Each command handles its own validation
- Task system provides progress visibility and error recovery
- `context: fork` isolates workflow execution
