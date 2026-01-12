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

STEP 3: Execute enabled steps
  SET: step_number = 1
  SET: total_steps = count(enabled_steps)

  FOR_EACH: step in enabled_steps
    OUTPUT: "📋 Step {step_number}/{total_steps}: {step}"

    Skill tool: skill="{step}"
    WAIT: for Skill tool completion

    IF: skill returned failure
      OUTPUT: "❌ Step '{step}' failed. Halting."
      END

    OUTPUT: "✅ {step} complete"
    INCREMENT: step_number

STEP 4: Summary
  OUTPUT: "🎉 Complete ({total_steps}/{total_steps} steps)"
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
