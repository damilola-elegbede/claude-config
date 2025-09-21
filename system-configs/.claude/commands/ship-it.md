---
description: Orchestrate development workflows with auto-resolution
argument-hint: [-f|--full|-l|--lite]
---

# /ship-it Command

## Usage

```bash
/ship-it                         # Basic workflow: docs audit → review → commit → push
/ship-it --full                  # Full workflow: docs → review → test → commit → push → pr
/ship-it --lite                  # Lite workflow: commit → push
```

Use `$ARGUMENTS` to determine workflow type (empty for basic, `--full` or `-f` for full, `--lite` or `-l` for lite).

## Description

Orchestrate development workflows by running multiple `/` commands in sequence with automatic issue resolution.
When commands report problems, attempt reasonable fixes but prioritize completing the workflow.

## Expected Output

```text
🚀 Starting ship-it workflow: lite

Step 1/2: /commit
✅ Commit created successfully

Step 2/2: /push
✅ Pushed to remote

🎉 Ship-it workflow completed!
  - 2/2 commands succeeded
  - Total time: 45 seconds
```

## Behavior

### Workflow Types

Based on `$ARGUMENTS`, execute one of three workflows:

- **Lite (`--lite` or `-l`)**: `/commit` → `/push`
- **Basic (default/empty)**: `/docs --audit` → `/review` → `/commit` → `/push`
- **Full (`--full` or `-f`)**: `/docs` → `/review` → `/test` → `/commit` → `/push` → `/pr`

### Direct Command Execution

Execute each command in sequence using the standard Claude Code command system:

1. **Parse Arguments**: Determine workflow type from `$ARGUMENTS`
2. **Sequential Execution**: Run each command in the defined order
3. **Error Handling**: If a command fails, attempt one retry with basic fixes
4. **Continue on Failure**: Log failures but continue to next step
5. **Final Report**: Summarize what succeeded/failed

### Automatic Issue Resolution

For each failed command, attempt one basic fix:

- **commit failures**: Remove problematic files, retry with `--no-verify` if needed
- **push failures**: Handle merge conflicts, retry with `--no-verify` if needed
- **review failures**: Auto-fix obvious linting issues
- **test failures**: Skip if critical, log for manual review
- **docs failures**: Skip if non-critical, continue workflow

### Implementation

```bash
# Parse workflow type
case "$ARGUMENTS" in
  "--lite"|"-l") WORKFLOW="lite" ;;
  "--full"|"-f") WORKFLOW="full" ;;
  *) WORKFLOW="basic" ;;
esac

# Execute workflow commands
if [ "$WORKFLOW" = "lite" ]; then
  run_command "/commit"
  run_command "/push"
elif [ "$WORKFLOW" = "basic" ]; then
  run_command "/docs --audit"
  run_command "/review"
  run_command "/commit"
  run_command "/push"
elif [ "$WORKFLOW" = "full" ]; then
  run_command "/docs"
  run_command "/review"
  run_command "/test"
  run_command "/commit"
  run_command "/push"
  run_command "/pr"
fi
```

### Performance Targets

- **Lite workflow**: 1-2 minutes
- **Basic workflow**: 3-5 minutes
- **Full workflow**: 5-8 minutes (including PR creation)

### Success Criteria

- At least 80% of commands succeed
- Critical path completed (commit + push minimum)
- PR created successfully in full mode
- Clear status report provided