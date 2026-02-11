---
name: codex
description: Delegate coding tasks to Codex CLI for cost-effective execution
argument-hint: "[task description] [--dry-run]"
category: workflow
context: fork
---

# /codex

## Usage

```bash
/codex "implement the UserProfile component per the spec"
/codex "write unit tests for the auth module"
/codex "refactor database queries to use parameterized statements"
/codex --dry-run "rename all snake_case vars to camelCase in src/utils"
```

## Description

Delegates coding execution to OpenAI Codex CLI. Claude plans and scopes the work,
Codex executes the implementation. Use when requirements are well-defined and the
task is primarily code generation, not reasoning.

The key insight: Codex is an execution engine for any well-defined coding task.
Claude (Opus) does the thinking — scoping, planning, reviewing.
Codex does the hands-on coding once requirements are clear.

## Execution Steps

### Step 1: Prerequisites Check

```text
RUN: command -v codex
IF: not found
  OUTPUT: "Codex CLI not installed. Install with: npm install -g @openai/codex"
  END

RUN: codex --version
OUTPUT: "Codex CLI v{version} detected"
```

### Step 2: Parse Arguments

```text
IF: --dry-run flag present
  DRY_RUN: true
  TASK: remaining arguments after --dry-run

IF: no arguments provided
  Analyze current context (git diff, recent files, branch name)
  Suggest what could be delegated to Codex
  OUTPUT: "No task specified. Based on current context, consider delegating:"
  OUTPUT: "  - {suggestion based on uncommitted changes}"
  OUTPUT: "  - {suggestion based on branch name}"
  END
```

### Step 3: Build Execution Prompt

```text
GATHER context:
  - Working directory and project structure
  - Relevant source files (read files mentioned in task or inferred from context)
  - Project coding patterns (from existing code)
  - Test patterns (from existing tests)

CONSTRUCT prompt:
  - Task description from user args
  - File list to modify
  - Coding standards observed in project
  - Any constraints or patterns to follow
```

### Step 4: Execute or Preview

```text
IF: DRY_RUN
  OUTPUT: "Dry Run - Would execute:"
  OUTPUT: "  Prompt: {constructed prompt}"
  OUTPUT: "  Files in scope: {file list}"
  OUTPUT: "  Estimated changes: {description}"
  END

RUN: codex exec "$PROMPT" --json
CAPTURE: output as JSON
```

### Step 5: Parse and Display Results

```text
PARSE: JSON output from Codex
EXTRACT: files changed, diffs applied

OUTPUT:
  "Codex Execution Complete"
  ""
  "Files changed:"
  "  - {file1}: {description of change}"
  "  - {file2}: {description of change}"
  ""
  "Diff summary:"
  {abbreviated diff output}
```

### Step 6: Run Tests

```text
DETECT: test runner (npm test, pytest, go test, etc.)

IF: test runner found
  RUN: tests
  IF: tests pass
    OUTPUT: "All tests passing after Codex changes"
  ELSE:
    OUTPUT: "Test failures detected — review Codex output"
    OUTPUT: {failure details}

IF: no test runner
  OUTPUT: "No test runner detected — manual verification recommended"
```

### Step 7: Report

```text
OUTPUT:
  "/codex Complete"
  ""
  "| Metric | Value |"
  "|--------|-------|"
  "| Files changed | {count} |"
  "| Lines added | {added} |"
  "| Lines removed | {removed} |"
  "| Tests | {pass/fail/none} |"
```

## Expected Output

```text
User: /codex "add input validation to the signup form"

Codex CLI v0.1.0 detected
Building execution context...

Reading: src/components/SignupForm.tsx
Reading: src/utils/validation.ts
Reading: tests/signup.test.ts

Executing via Codex CLI...

Codex Execution Complete

Files changed:
  - src/components/SignupForm.tsx: Added validation for email, password, name fields
  - src/utils/validation.ts: Added validateSignupInput function

Diff summary:
  src/components/SignupForm.tsx | 15 ++++++++++++---
  src/utils/validation.ts      |  8 ++++++++

Running tests...
All tests passing after Codex changes

/codex Complete

| Metric | Value |
|--------|-------|
| Files changed | 2 |
| Lines added | 23 |
| Lines removed | 3 |
| Tests | pass |
```

### Dry Run Output

```text
User: /codex --dry-run "rename all snake_case vars to camelCase in src/utils"

Codex CLI v0.1.0 detected

Dry Run - Would execute:
  Prompt: "Rename all snake_case variables to camelCase in the following files..."
  Files in scope: src/utils/helpers.ts, src/utils/format.ts, src/utils/api.ts
  Estimated changes: Variable renames across 3 files

Ready to execute? Run without --dry-run
```

## Notes

- Codex CLI must be installed and authenticated (`npm install -g @openai/codex`)
- Best for well-defined tasks where Claude has already done the thinking
- Not a replacement for Claude's reasoning — use for execution, not planning
- `--dry-run` shows what would happen without making changes
- Results should be reviewed by Claude or the user before considering complete
- Cost savings come from using Codex API for code generation instead of Claude
