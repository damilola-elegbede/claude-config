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

| Flag | Command to Execute |
|------|-------------------|
| `-d` | `/docs` |
| `-t` | `/test` |
| `-c` | `/commit` |
| `-r` | `/review` |
| `-p` | `/push` |
| `-pr` | `/pr` |
| `--dry-run` | Preview only (no execution) |

## Execution Rules

**CRITICAL**: This command is a pure orchestrator. You MUST use the Task tool with `general-purpose` agent
to execute each command in complete isolation. Never implement command logic directly.

### Why Task Tool (Not Skill Tool)

- **Skill tool** only loads markdown instructions into your session - no isolation
- **Task tool** spawns an isolated agent subprocess with separate context window
- The agent uses Skill tool internally to load command instructions
- Task agents run until they complete or hit iteration limits (safeguards against infinite loops)

**Note**: Task tool provides isolation and bounded execution, but completion depends on the agent
following instructions correctly. Verify Skill tool availability in the agent context.

### Mandatory Task Tool Delegation

For each enabled step:

1. Spawn a `general-purpose` agent via Task tool
2. Agent uses Skill tool to load the command instructions
3. Agent executes the command completely - all steps, no skipping
4. Wait for agent completion before proceeding to next step

| Flag | Task Tool Invocation |
|------|---------------------|
| `-d` | `Task: subagent_type="general-purpose", description="Execute /docs", prompt="Execute /docs completely. Use Skill tool: skill='docs'. Follow ALL instructions."` |
| `-t` | `Task: subagent_type="general-purpose", description="Execute /test", prompt="Execute /test completely. Use Skill tool: skill='test'. Follow ALL instructions."` |
| `-c` | `Task: subagent_type="general-purpose", description="Execute /commit", prompt="Execute /commit completely. Use Skill tool: skill='commit'. Follow ALL instructions."` |
| `-r` | `Task: subagent_type="general-purpose", description="Execute /review", prompt="Execute /review completely. Use Skill tool: skill='review'. Follow ALL instructions."` |
| `-p` | `Task: subagent_type="general-purpose", description="Execute /push", prompt="Execute /push completely. Use Skill tool: skill='push'. Follow ALL instructions."` |
| `-pr` | `Task: subagent_type="general-purpose", description="Execute /pr", prompt="Execute /pr completely. Use Skill tool: skill='pr'. Follow ALL instructions."` |

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

If any Task agent returns failure → stop immediately. Do not continue to subsequent steps.

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
  [Task agent executing /docs...]
  ✅ Documentation updated

📋 Step 2/6: test
  [Task agent executing /test...]
  ✅ All tests passed

📋 Step 3/6: commit
  [Task agent executing /commit...]
  ✅ Commit created: a1b2c3d

📋 Step 4/6: review
  [Task agent executing /review...]
  ✅ Code review passed

📋 Step 5/6: push
  [Task agent executing /push...]
  ✅ Pushed to origin/feature-branch

📋 Step 6/6: pr
  [Task agent executing /pr...]
  ✅ PR created: https://github.com/org/repo/pull/123

🎉 Complete (6/6 steps)
```

## Notes

- Pure orchestrator: MUST use Task tool with `general-purpose` agent for each command
- Agent uses Skill tool internally to load command instructions
- Each command runs in isolated subprocess with bounded execution (iteration limits apply)
- Never bypass quality gates (no `--no-verify`)
- Review (`-r`) runs AFTER commit to analyze full branch diff before push
