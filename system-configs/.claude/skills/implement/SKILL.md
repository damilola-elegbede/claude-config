---
name: implement
description: Implement features from markdown specs. Use when building features from a specification.
argument-hint: "[spec-file.md] [--backend|--frontend|--full-stack]"
category: workflow
context: fork
---

# /implement

## Usage

```bash
/implement $ARGUMENTS           # Implement from spec
/implement spec.md --dry-run        # Show plan without executing
/implement spec.md --incremental    # Only incomplete tasks
```

## Description

Reads a markdown specification and implements the described features. Deploys appropriate
engineers based on the spec requirements. Uses TeamCreate for multi-domain specs (2+ domains),
or a single Task call for single-domain specs.

## Execution Steps

### Step 1: Parse Specification

```text
TaskCreate: "Parse specification" (no blockers)
TaskCreate: "Classify tasks by domain" (blockedBy: parse)
TaskCreate: "Deploy implementation" (blockedBy: classify)
TaskCreate: "Verify implementation" (blockedBy: deploy)
```

```text
TaskUpdate: "Parse specification" → in_progress
```

Read the specification file and extract:

- Task list (from checkboxes, numbered lists, or headings)
- Dependencies between tasks (from "depends on" annotations)
- Acceptance criteria

If `--incremental`: filter to only unchecked/incomplete tasks.

If `--dry-run`: skip to Dry-Run Output after classification (Step 2).

```text
TaskUpdate: "Parse specification" → completed
```

### Step 2: Classify Tasks by Domain

```text
TaskUpdate: "Classify tasks by domain" → in_progress
```

Assign each task to a domain based on content:

| Domain | Indicators | Prompt Specialization |
|--------|------------|----------------------|
| backend | API, endpoint, server, middleware, auth | Server architecture, API patterns, data modeling |
| frontend | component, UI, page, style, layout | React/Vue patterns, CSS, client-side state |
| test | test, spec, coverage, mock, fixture | Test strategies, mocking patterns, assertions |
| data | database, migration, query, schema | SQL patterns, migration strategies, data integrity |
| devops | CI, deploy, docker, pipeline, config | Infrastructure patterns, deployment strategies |

Identify shared files (types, configs, utilities) that span domains. Assign each shared
file to exactly one domain to prevent conflicts.

```text
TaskUpdate: "Classify tasks by domain" → completed
```

### Step 3: Deploy Implementation

```text
TaskUpdate: "Deploy implementation" → in_progress
```

**Decision: Team vs Single Agent**

```text
IF: 2+ domains identified
  → TeamCreate path (parallel teammates)
ELSE:
  → Single Task path (no team overhead)
```

#### Path A: Multi-Domain (TeamCreate)

```text
# Create the team
TeamCreate:
  team_name: "impl-{current-branch}"
  description: "Implementation from {spec-file}"

# Create a task for each domain's work
TaskCreate: "Implement {domain-1} tasks" (team task)
TaskCreate: "Implement {domain-2} tasks" (team task)
...
```

Spawn one teammate per domain **in a SINGLE message with multiple Task tool calls**:

```text
Task tool call:
  subagent_type: "general-purpose"
  name: "{domain}-engineer"
  team_name: "impl-{current-branch}"
  model: "sonnet"
  prompt: |
    You are a {domain} specialist implementing features from a specification.

    ## Your Tasks
    {list of tasks assigned to this domain}

    ## File Ownership
    You own these files — only modify files in this list:
    {list of files assigned to this domain}

    Do NOT modify files outside your ownership list. If you need changes
    to a file you don't own, document the needed change and mark your task
    as completed with a note.

    ## Dependencies
    {any task dependency information}

    ## Acceptance Criteria
    {relevant acceptance criteria from spec}

    Implement each task, then mark your assigned tasks as completed.
```

Wait for all teammates to complete their tasks.

```text
# Cleanup team
SendMessage shutdown_request to all teammates
TeamDelete
```

#### Path B: Single Domain (Task)

```text
Task tool:
  subagent_type: "general-purpose"
  model: "sonnet"
  prompt: |
    Implement the following tasks from specification:
    {all tasks}

    Files to modify: {file list}
    Acceptance criteria: {criteria}
```

```text
IF: agent completed successfully
  TaskUpdate: "Deploy implementation" → completed
ELSE:
  OUTPUT: "Implementation agent failed — review output for errors"
  TaskUpdate: "Deploy implementation" → completed (with note: "agent failed, manual review needed")
```

### Step 4: Verify Implementation

```text
TaskUpdate: "Verify implementation" → in_progress
```

```bash
# Run project tests
# Auto-detect test runner (npm test, pytest, go test, etc.)
```

Report results:

```text
IF: tests pass
  OUTPUT: "All tests passing"
  TaskUpdate: "Verify implementation" → completed
ELSE:
  OUTPUT: "Test failures detected — review output"
  TaskUpdate: "Verify implementation" → completed (with note about failures)
```

```text
TaskList: show final status of all phases
```

## Expected Output

```text
User: /implement feature-spec.md

📄 Reading specification: feature-spec.md
🔍 Identified 5 tasks across 2 domains

📋 Execution Plan:
  - backend (3 tasks): API endpoints, validation, auth middleware
  - frontend (2 tasks): UserProfile component, form integration

🏗️ Creating team: impl-feature-user-profile
   Spawning 2 teammates...
   [tmux panes show backend-engineer, frontend-engineer]

   backend-engineer owns: src/api/, src/middleware/, src/models/
   frontend-engineer owns: src/components/, src/pages/

   ✓ backend-engineer: 3/3 tasks completed
   ✓ frontend-engineer: 2/2 tasks completed

🧹 Shutting down team impl-feature-user-profile...

🧪 Running tests...
✅ All tests passing

🎉 Implementation complete (5 tasks across 2 domains)
```

### Single-Domain Output

```text
User: /implement api-spec.md

📄 Reading specification: api-spec.md
🔍 Identified 3 tasks in 1 domain (backend)

Deploying single backend agent...

✅ Task 1/3: Created user API endpoint
✅ Task 2/3: Added input validation
✅ Task 3/3: Added rate limiting middleware

🧪 Running tests...
✅ All tests passing

🎉 Implementation complete (3 tasks)
```

### Dry-Run Mode

```text
User: /implement spec.md --dry-run

📄 Dry run analysis for spec.md

📋 Would execute:
  - backend: 3 tasks (API endpoints, validation, auth)
  - frontend: 2 tasks (UserProfile, form integration)

  Deployment: TeamCreate (2 domains → parallel teammates)
  File ownership:
    backend-engineer: src/api/, src/middleware/
    frontend-engineer: src/components/, src/pages/
    Shared (assigned to backend): src/types/user.ts

Ready to proceed? Run without --dry-run
```

## Specification Format

```markdown
# Feature Name

## Tasks

1. [ ] Create API endpoint for users
2. [ ] Add validation middleware
3. [ ] Build UserList component (depends on: 1)

## Acceptance Criteria

- [ ] Users can be listed and filtered
- [ ] Validation errors shown clearly
```

## Notes

- Uses TeamCreate for 2+ domains, single Task for 1 domain (avoids team overhead)
- All teammates spawned with `model: "sonnet"` to match custom agent cost/behavior
- File ownership prevents conflicts between teammates working in parallel
- Shared files (types, configs) assigned to exactly one domain
- Cleanup (shutdown + TeamDelete) always runs after multi-domain deployment
- Manual cleanup if needed: `rm -rf ~/.claude/teams/impl-* ~/.claude/tasks/impl-*`
- When [#24316](https://github.com/anthropics/claude-code/issues/24316) lands, replace `subagent_type: "general-purpose"` with custom agent types
- Respects task dependencies within and across domains
- Use `--incremental` to resume partial implementations
