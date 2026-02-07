---
name: review
description: Code review with dual-reviewer parallel analysis. Use when reviewing code changes.
argument-hint: "[--full]"
category: orchestration
context: fork
---

# /review

## Usage

```bash
/review           # Review current branch changes vs main
/review --full    # Review entire codebase
```

## Description

Comprehensive code review that runs two reviewers in parallel:

1. **CodeRabbit CLI** - External AI review via `coderabbit review`
2. **code-reviewer agent** - Internal AI analysis for security, performance, accessibility

Both reviewers are mandatory. Results are passed to `/resolve-comments` for interactive triage.

## Prerequisites

CodeRabbit CLI must be installed and authenticated:

```bash
# Install
curl -fsSL https://cli.coderabbit.ai/install.sh | sh

# Authenticate
coderabbit auth login

# Verify
coderabbit auth status
```

## Execution

### Step 1: Validate Environment

```text
CHECK: which coderabbit
IF: not found
  OUTPUT: "CodeRabbit CLI required. Install: curl -fsSL https://cli.coderabbit.ai/install.sh | sh"
  END with error

OUTPUT: "Starting dual-reviewer analysis..."
```

### Step 2: Determine Scope

```text
IF: --full flag
  SCOPE: all files in repository (use git ls-files)
  OUTPUT: "Mode: Full codebase review"
ELSE:
  SCOPE: git diff $(git merge-base main HEAD)..HEAD + uncommitted changes
  RUN: git diff --name-only $(git merge-base main HEAD)..HEAD
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
  run_in_background: true  # <-- Enables parallel execution
  prompt: |
    Run CodeRabbit CLI review and output results to .tmp/review-coderabbit.json

    1. Create .tmp/ directory if needed: mkdir -p .tmp

    2. Determine default branch (with sanitization):
       RAW_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
       # Sanitize: allow alphanumeric, forward slash, hyphen, underscore, dot (valid git branch chars)
       if echo "$RAW_BRANCH" | grep -qE '^[a-zA-Z0-9/_.-]+$'; then
         DEFAULT_BRANCH="$RAW_BRANCH"
       else
         DEFAULT_BRANCH="main"
       fi

    3. Run CodeRabbit CLI:
       coderabbit review --prompt-only --type all --base "$DEFAULT_BRANCH" --config .coderabbit.yaml

    Note: The --prompt-only flag produces AI-optimized text output, not JSON.
    Parse the text output by extracting structured sections (file paths, line numbers,
    issue descriptions) and transforming them into the JSON schema below.

    ERROR HANDLING for parsing:
    - Wrap parsing in error boundaries
    - If a line is malformed, log warning and continue to next line
    - If a section is missing, skip it and continue
    - If output is empty, write empty issues array
    - Track and report parsing failures at end: "Parsed N issues, M lines skipped due to errors"

    4. Parse the output and write to .tmp/review-coderabbit.json with this schema:
       {
         "schema_version": "1.0",
         "branch": "{current_branch}",
         "created_at": "{ISO timestamp}",
         "source": "coderabbit",
         "issues": [
           {
             "id": {sequential number},
             "file": "path/to/file",
             "line": {line number or null},
             "severity": "LOW|MEDIUM|HIGH|CRITICAL",
             "description": "Issue description",
             "suggestion": "Fix suggestion"
           }
         ]
       }

    4. Report: "CodeRabbit found {count} issues"

    If CodeRabbit returns no issues, write empty issues array.

# Task 2: AI Code Review (BACKGROUND)
# NOTE: Uses code-reviewer agent type which has access to Read, Grep, Bash tools
# The Task tool orchestration is valid as it's invoked by Claude, not by another agent
Task tool:
  subagent_type: "code-reviewer"
  description: "Run AI code review"
  run_in_background: true  # <-- Enables parallel execution
  prompt: |
    Review the following files and output results to .tmp/review-local.json

    Files to review:
    {file_list from Step 2}

    Review for:
    - Security vulnerabilities (injection, auth issues, data exposure)
    - Performance problems (N+1 queries, memory leaks, algorithm complexity)
    - Accessibility issues (WCAG compliance, keyboard navigation, screen readers)
    - Code quality (error handling, edge cases, maintainability)

    Write results to .tmp/review-local.json with this schema:
    {
      "schema_version": "1.0",
      "branch": "{current_branch}",
      "created_at": "{ISO timestamp}",
      "source": "code-reviewer",
      "issues": [
        {
          "id": {sequential number},
          "file": "path/to/file",
          "line": {line number or null},
          "severity": "LOW|MEDIUM|HIGH|CRITICAL",
          "type": "security|performance|accessibility|quality",
          "description": "Issue description",
          "suggestion": "Fix suggestion"
        }
      ]
    }

    Report: "AI reviewer found {count} issues"

    If no issues found, write empty issues array.
```

### Step 3.5: Collect Background Results

```text
# Both tasks are now running in parallel
# Use TaskOutput to wait for and collect results

TaskOutput: task_id=<coderabbit_task_id>, block=true
TaskOutput: task_id=<code_reviewer_task_id>, block=true

# Both reviewers complete in parallel, reducing total review time
```

### Step 4: Report Results

```text
WAIT: for both Task agents to complete

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

### Step 5: Hand Off to Triage

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
User: /review

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
[/resolve-comments --code-rabbit --local takes over]
```

## Notes

- Both reviewers run in parallel for speed
- CodeRabbit CLI is required (command fails without it)
- Results stored in `.tmp/` for `/resolve-comments` consumption
- No auto-fix - all changes require user approval via triage
- `--full` mode may take longer depending on codebase size
