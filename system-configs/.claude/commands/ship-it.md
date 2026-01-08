---
description: Orchestrate development workflows with composable flags
argument-hint: [-d] [-r] [-t] [-c] [-p] [-pr] [--dry-run]
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
3. Execute enabled steps in fixed order: `d → t → c → r → p → pr`
4. Flag order in command doesn't matter: `-p -c` runs as `commit → push`
5. Review (`-r`) runs AFTER commit to analyze full branch diff before push

### Execution

- **Halt-on-failure**: Any step fails → workflow stops immediately
- **Smart skipping**: Commands skip gracefully (e.g., no changes to commit, PR exists)
- **Dry run**: With `--dry-run`, print steps that would execute without running them
- **Review gate**: When `-r` runs after commit, it analyzes the full branch diff (all changes from main).
  If issues are found and fixed, create an additional commit before push

### Validation

Before executing steps, perform these checks:

1. **Branch validation** (for `-p` and `-pr`):
   - Warn and halt if current branch is `main` or `master`
   - Suggest creating a feature branch first

2. **Remote tracking** (for `-p`):
   - If branch has no upstream, run `git push -u origin <branch>` to set it
   - If push fails due to no remote, halt with clear error

3. **PR exists check** (for `-pr`):
   - Check if PR already exists for current branch: `gh pr view --json url`
   - If PR exists → skip creation, display existing PR URL
   - Only create new PR if none exists

### Post-PR Actions

After PR creation (or if PR already exists), perform these actions:

1. **CodeRabbit Acknowledgments** (automatic):
   - Check if `.tmp/coderabbit-ignored.json` exists
   - **Skip silently** if file doesn't exist (no ignored issues to acknowledge)
   - **Validate branch** matches current branch - abort with warning if mismatch
   - **Validate structure** - skip posting with error log if file is malformed
   - Generate acknowledgment comment, grouped by `category` field
   - Post to PR via `gh pr comment <pr-number> --body "..."`
   - Delete tracking file after successful posting

   **Edge Cases**:

   | Condition | Action |
   |-----------|--------|
   | File doesn't exist | Skip silently (no issues to acknowledge) |
   | File exists, 0 issues | Skip silently (empty array) |
   | Branch mismatch | Abort with warning, don't delete file |
   | Malformed JSON | Log error, skip posting, don't delete file |

   **Comment format** (grouped by category):

   ```markdown
   ## CodeRabbit Issue Acknowledgments

   The following issues were reviewed locally and intentionally not addressed:

   ### False Positives

   | Location | Issue | Reason |
   |----------|-------|--------|
   | `utils.ts:8` | Use const vs let | Variable is reassigned |

   ### Intentional Design Decisions

   | Location | Issue | Reason |
   |----------|-------|--------|
   | `SKILL.md:90` | Informal phrasing | Matches project voice |

   ---
   @coderabbitai These issues were reviewed during local development. No action needed.
   ```

## Expected Output

### Full Workflow (default)

```text
🚀 ship-it: docs → test → commit → review → push → pr

📋 Step 1/6: docs
  ✅ Documentation updated

📋 Step 2/6: test
  ✅ All tests passed (45/45)

📋 Step 3/6: commit
  ✅ Commit created: a1b2c3d

📋 Step 4/6: review
  ✅ Code review passed (2 issues fixed)
  📦 Fix commit: b2c3d4e

📋 Step 5/6: push
  ✅ Pushed to origin/feature-branch

📋 Step 6/6: pr
  ✅ PR created: https://github.com/org/repo/pull/123

📋 Post-PR: acknowledgments
  📄 Found 1 ignored CodeRabbit issue
  📝 Posted acknowledgment comment to PR
  🧹 Cleaned up tracking file

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
  2. /test
  3. /commit
  4. /review (+ fix commit if issues found)
  5. /push
  6. /pr

No changes made.
```

## Notes

- Pure orchestrator: delegates to `/docs`, `/review`, `/test`, `/commit`, `/push`, `/pr`
- Never bypasses quality gates (no `--no-verify`)
- Step dependencies are your responsibility: `-p` alone fails if nothing committed
- **Review gate timing**: Review runs AFTER commit but BEFORE push to analyze full branch diff.
  This ensures local review catches the same issues as PR review
- **CodeRabbit integration**: After PR creation, automatically posts acknowledgment comment for any ignored issues tracked during `/review`
