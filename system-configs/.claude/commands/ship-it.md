---
description: Orchestrate development workflows with composable flags
argument-hint: "[-d] [-r] [-t] [-c] [-p] [-pr] [--dry-run]"
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

Pure orchestrator that composes workflow steps. Each flag enables a step; combine flags to build custom workflows.
With no flags, runs the full workflow.

## Flags

| Flag | Command to Invoke |
|------|-------------------|
| `-d` | `/docs` |
| `-t` | `/test` |
| `-c` | `/commit` |
| `-r` | `/review` |
| `-p` | `/push` |
| `-pr` | `/pr` |
| `--dry-run` | Preview only (no execution) |

## Execution Rules

**CRITICAL**: This command is a pure orchestrator. You MUST use the Skill tool to invoke each command.
Never implement command logic directly - always delegate via the Skill tool.

### Mandatory Skill Tool Invocation

For each enabled step, use the Skill tool to invoke the corresponding command:

| Flag | Action |
|------|--------|
| `-d` | `Skill tool: skill="docs"` |
| `-t` | `Skill tool: skill="test"` |
| `-c` | `Skill tool: skill="commit"` |
| `-r` | `Skill tool: skill="review"` |
| `-p` | `Skill tool: skill="push"` |
| `-pr` | `Skill tool: skill="pr"` |

### Execution Order

Steps always execute in this fixed order regardless of flag order in command:

```text
docs → test → commit → review → push → pr
```

Example: `/ship-it -p -c` executes as `commit → push`

### Flag Parsing

1. Parse `$ARGUMENTS` for flags: `-d`, `-r`, `-t`, `-c`, `-p`, `-pr`, `--dry-run`
2. If no step flags provided → enable ALL steps (full workflow)
3. If `--dry-run` → print steps that would execute, then stop

### Halt on Failure

If any Skill tool invocation fails → stop immediately. Do not continue to subsequent steps.

## Pre-Execution Validation

Before invoking any commands:

1. **Branch check** (when `-p` or `-pr` enabled):
   - If on `main` or `master` → halt with error, suggest creating feature branch

2. **Remote tracking** (when `-p` enabled):
   - If no upstream → the `/push` command will handle setting it

3. **PR exists** (when `-pr` enabled):
   - Check via `gh pr view --json url`
   - If PR exists → skip `/pr` invocation, display existing URL

## Post-PR Actions

After `/pr` completes (or PR already exists):

1. Check if `.tmp/coderabbit-ignored.json` exists
2. If missing or empty → skip silently
3. If present → post acknowledgment comment to PR via `gh pr comment`
4. Delete tracking file after successful posting

**Comment format:**

```markdown
## CodeRabbit Issue Acknowledgments

The following issues were reviewed locally and intentionally not addressed:

### [Category Name]

| Location | Issue | Reason |
|----------|-------|--------|
| `file:line` | Issue description | Reason provided |

---
@coderabbitai These issues were reviewed during local development. No action needed.
```

## Expected Output

```text
🚀 ship-it: docs → test → commit → review → push → pr

📋 Step 1/6: docs
  [Skill tool invokes /docs]
  ✅ Documentation updated

📋 Step 2/6: test
  [Skill tool invokes /test]
  ✅ All tests passed

📋 Step 3/6: commit
  [Skill tool invokes /commit]
  ✅ Commit created: a1b2c3d

📋 Step 4/6: review
  [Skill tool invokes /review]
  ✅ Code review passed

📋 Step 5/6: push
  [Skill tool invokes /push]
  ✅ Pushed to origin/feature-branch

📋 Step 6/6: pr
  [Skill tool invokes /pr]
  ✅ PR created: https://github.com/org/repo/pull/123

🎉 Complete (6/6 steps)
```

## Notes

- Pure orchestrator: MUST use Skill tool to invoke `/docs`, `/test`, `/commit`, `/review`, `/push`, `/pr`
- Never bypass quality gates (no `--no-verify`)
- Review (`-r`) runs AFTER commit to analyze full branch diff before push
