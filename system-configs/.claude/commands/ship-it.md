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

STEP 3: Pre-execution validation
  RUN: git branch --show-current
  SET: current_branch = output

  IF: -p or -pr in enabled_steps
    IF: current_branch == "main" OR current_branch == "master"
      OUTPUT: "❌ Cannot push/PR from {current_branch}. Create a feature branch first."
      END

  IF: -pr in enabled_steps
    RUN: gh pr view --json url 2>/dev/null
    IF: success
      PARSE: url from output
      SET: existing_pr = url
      OUTPUT: "ℹ️ PR already exists: {existing_pr}"
      REMOVE: pr from enabled_steps

STEP 4: Execute enabled steps
  SET: step_number = 1
  SET: total_steps = count(enabled_steps)

  FOR_EACH: step in enabled_steps
    OUTPUT: "📋 Step {step_number}/{total_steps}: {step}"

    INVOKE_SKILL: {step}
    WAIT: Skill execution completes

    IF: skill returned failure
      OUTPUT: "❌ Step '{step}' failed. Halting."
      END

    OUTPUT: "✅ {step} complete"
    INCREMENT: step_number

STEP 5: Post-PR actions
  IF: pr was in original enabled_steps (before existing PR check)
    READ: .tmp/coderabbit-ignored.json

    IF: file exists and has ignored_issues
      VALIDATE: branch field matches current_branch

      IF: branch matches
        BUILD: comment from ignored_issues grouped by category:
          ## Review Issue Acknowledgments

          The following issues were reviewed locally and intentionally not addressed:

          ### {category}
          | Location | Issue | Reason |
          |----------|-------|--------|
          | {foreach issue in category} |

          ---
          @coderabbitai These issues were reviewed during local development. No action needed.

        IF: existing_pr
          RUN: gh pr comment --body "{comment}"
        ELSE:
          RUN: gh pr view --json url
          PARSE: pr_url
          RUN: gh pr comment --body "{comment}"

        DELETE: .tmp/coderabbit-ignored.json
        OUTPUT: "📢 Posted acknowledgment for {count} skipped issues"

STEP 6: Summary
  OUTPUT: "🎉 Complete ({total_steps}/{total_steps} steps)"

  IF: existing_pr
    OUTPUT: "PR: {existing_pr}"
  ELSE IF: pr was executed
    RUN: gh pr view --json url
    OUTPUT: "PR: {url}"

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

- Steps always execute in fixed order: docs → test → commit → review → push → pr
- Uses INVOKE_SKILL for each step (interactive, same context)
- Halts immediately on any step failure
- Never bypass quality gates (no `--no-verify`)
- Skipped review issues from `/review` are posted to PR as acknowledgment
