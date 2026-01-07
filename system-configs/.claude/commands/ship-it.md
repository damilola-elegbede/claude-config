---
description: Orchestrate development workflows with composable flags
argument-hint: [-d] [-r] [-t] [-c] [-p] [-pr] [--dry-run]
---

# /ship-it Command

## Usage

```bash
/ship-it                    # Full: docs → review → test → commit → push → pr
/ship-it -c -p              # Quick: commit → push
/ship-it -t -c -p           # Test first: test → commit → push
/ship-it -r -t              # Quality check only: review → test
/ship-it -d -r -t -c -p     # Everything except PR
/ship-it -pr                # Just create PR
/ship-it --dry-run          # Preview full workflow
/ship-it -c -p --dry-run    # Preview what would run
```

## Description

Orchestrates development workflows by composing individual command flags. Each flag enables a step;
combine flags to build custom workflows. With no flags, runs the full workflow.

## Flags

| Flag | Step | Command |
|------|------|---------|
| `-d` | docs | `/docs` |
| `-r` | review | `/review` |
| `-t` | test | `/test` |
| `-c` | commit | `/commit` |
| `-p` | push | `/push` |
| `-pr` | pull request | `/pr` |
| `--dry-run` | preview | Shows steps without executing |

## Behavior

### Flag Parsing

1. Parse `$ARGUMENTS` for flags: `-d`, `-r`, `-t`, `-c`, `-p`, `-pr`, `--dry-run`
2. If no step flags provided, enable ALL steps (full workflow)
3. Execute enabled steps in fixed order: `d → r → t → c → p → pr`
4. Flag order in command doesn't matter: `-p -c` runs as `commit → push`

### Execution

- **Halt-on-failure**: Any step fails → workflow stops immediately
- **Smart skipping**: Commands skip gracefully (e.g., no changes to commit, PR exists)
- **Dry run**: With `--dry-run`, print steps that would execute without running them

## Expected Output

### Full Workflow (default)

```text
🚀 ship-it: docs → review → test → commit → push → pr

📋 Step 1/6: docs
  ✅ Documentation updated

📋 Step 2/6: review
  ✅ Code review passed

📋 Step 3/6: test
  ✅ All tests passed (45/45)

📋 Step 4/6: commit
  ✅ Commit created: a1b2c3d

📋 Step 5/6: push
  ✅ Pushed to origin/feature-branch

📋 Step 6/6: pr
  ✅ PR created: https://github.com/org/repo/pull/123

🎉 Complete (6/6 steps)
```

### Quick Commit (-c -p)

```text
🚀 ship-it: commit → push

📋 Step 1/2: commit
  ✅ Commit created: d4e5f6a

📋 Step 2/2: push
  ✅ Pushed to origin/main

🎉 Complete (2/2 steps)
```

### Dry Run (--dry-run)

```text
🚀 ship-it --dry-run

Would execute:
  1. /docs
  2. /review
  3. /test
  4. /commit
  5. /push
  6. /pr

No changes made.
```

## Notes

- Pure orchestrator: delegates to `/docs`, `/review`, `/test`, `/commit`, `/push`, `/pr`
- Never bypasses quality gates (no `--no-verify`)
- Step dependencies are your responsibility: `-p` alone fails if nothing committed
