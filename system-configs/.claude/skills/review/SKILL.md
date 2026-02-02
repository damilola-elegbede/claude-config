---
name: review
description: Code review with dual-reviewer parallel analysis
category: orchestration
context: fork
user-invocable: true
---

# /review Skill

Code review skill that runs two reviewers in parallel for comprehensive analysis.

## Usage

```bash
/review           # Review current branch changes vs main
/review --full    # Review entire codebase
```

## Architecture

This skill uses `context: fork` to run in an isolated context, preventing review
findings from polluting the main conversation. It orchestrates parallel background
tasks rather than routing to a specific agent.

### Dual Reviewer System

1. **CodeRabbit CLI** - External AI review via `coderabbit review`
2. **code-reviewer agent** - Internal AI analysis for security, performance, accessibility

Both reviewers run in parallel using `run_in_background: true` for efficiency.

## Prerequisites

CodeRabbit CLI must be installed and authenticated:

```bash
curl -fsSL https://cli.coderabbit.ai/install.sh | sh
coderabbit auth login
```

## Execution

### Step 1: Validate Environment

```text
CHECK: which coderabbit
IF: not found
  OUTPUT: "CodeRabbit CLI required. Install: curl -fsSL https://cli.coderabbit.ai/install.sh | sh"
  END with error

CHECK: coderabbit auth status (verify authenticated)
IF: not authenticated
  OUTPUT: "CodeRabbit CLI not authenticated. Run: coderabbit auth login"
  END with error

CHECK: .coderabbit.yaml exists in repo root
IF: not found
  OUTPUT: "Warning: .coderabbit.yaml not found. Using default configuration."

OUTPUT: "Starting dual-reviewer analysis..."
```

### Step 2: Determine Scope

```text
IF: --full flag
  SCOPE: all files in repository (use git ls-files)
  OUTPUT: "Mode: Full codebase review"
ELSE:
  SET: DEFAULT_BRANCH from origin/HEAD (git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
  FALLBACK: if command fails, use "main"
  SCOPE: git diff $(git merge-base "$DEFAULT_BRANCH" HEAD)..HEAD + uncommitted changes
  RUN: git diff --name-only $(git merge-base "$DEFAULT_BRANCH" HEAD)..HEAD
  RUN: git diff --name-only (uncommitted)
  MERGE: both file lists (deduplicated)
  OUTPUT: "Mode: Branch delta review ({count} files)"

IF: no files to review
  OUTPUT: "No changes to review"
  END
```

### Step 3: Launch Parallel Reviewers (Background Tasks)

**CRITICAL**: Launch BOTH reviewers in a SINGLE message with TWO Task tool calls using `run_in_background: true`.

```yaml
# Task 1: CodeRabbit CLI Review (BACKGROUND)
Task tool:
  subagent_type: "general-purpose"
  description: "Run CodeRabbit CLI review"
  run_in_background: true
  prompt: |
    Run CodeRabbit CLI review and output results to .tmp/review-coderabbit.json

    1. Create .tmp/ directory if needed: mkdir -p .tmp

    2. Determine default branch (with sanitization):
       RAW_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
       if echo "$RAW_BRANCH" | grep -qE '^[a-zA-Z0-9/_.-]+$'; then
         DEFAULT_BRANCH="$RAW_BRANCH"
       else
         DEFAULT_BRANCH="main"
       fi

    3. Run CodeRabbit CLI:
       coderabbit review --prompt-only --type all --base "$DEFAULT_BRANCH" --config .coderabbit.yaml

    4. Parse output and write to .tmp/review-coderabbit.json with schema:
       {
         "schema_version": "1.0",
         "branch": "{current_branch}",
         "created_at": "{ISO timestamp}",
         "source": "coderabbit",
         "issues": [...]
       }

# Task 2: AI Code Review (BACKGROUND)
Task tool:
  subagent_type: "code-reviewer"
  description: "Run AI code review"
  run_in_background: true
  prompt: |
    Review files and output results to .tmp/review-local.json

    Review for:
    - Security vulnerabilities
    - Performance problems
    - Accessibility issues
    - Code quality

    Write results to .tmp/review-local.json with schema:
    {
      "schema_version": "1.0",
      "branch": "{current_branch}",
      "created_at": "{ISO timestamp}",
      "source": "code-reviewer",
      "issues": [...]
    }
```

### Step 4: Collect Background Results

```text
TaskOutput: task_id=<coderabbit_task_id>, block=true
IF: task failed OR output file missing
  OUTPUT: "Warning: CodeRabbit review failed. Continuing with AI reviewer only."
  SET: coderabbit_failed = true

TaskOutput: task_id=<code_reviewer_task_id>, block=true
IF: task failed OR output file missing
  OUTPUT: "Warning: AI code review failed. Continuing with CodeRabbit only."
  SET: local_failed = true

IF: both failed
  OUTPUT: "Error: Both reviewers failed. Check prerequisites and try again."
  END with error
```

### Step 5: Report Results

```text
READ: .tmp/review-coderabbit.json
READ: .tmp/review-local.json

OUTPUT:
  Dual-Review Complete

  | Reviewer | Issues Found |
  |----------|--------------|
  | CodeRabbit | {coderabbit_count} |
  | AI Reviewer | {local_count} |

  Total: {total} issues
```

### Step 6: Hand Off to Triage

```text
IF: total issues > 0
  OUTPUT: "Launching interactive triage..."
  Skill tool: skill="resolve-comments", args="--code-rabbit --local"
ELSE:
  OUTPUT: "No issues found. Code looks good!"
  END
```

## Expected Output

```text
Starting dual-reviewer analysis...
Mode: Branch delta review (5 files)

[Launching parallel reviewers...]

Dual-Review Complete

| Reviewer | Issues Found |
|----------|--------------|
| CodeRabbit | 3 |
| AI Reviewer | 2 |

Total: 5 issues

Launching interactive triage...
```

## Notes

- Both reviewers run in parallel for speed
- Results stored in `.tmp/` for `/resolve-comments` consumption
- No auto-fix - all changes require user approval via triage
- `context: fork` ensures review context is isolated
