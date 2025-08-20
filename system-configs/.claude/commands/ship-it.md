# /ship-it Command

## Description

Orchestrates development workflows by running multiple `/` commands in sequence.
Automates commit, push, PR creation, and quality gates with todo list tracking.

## Usage

```bash
/ship-it                    # Full workflow (default)
/ship-it --basic            # review --quick → commit → push
/ship-it --quick            # commit → push
```

## Workflows

```yaml
Full (Default): /review → /test → /commit → /push → /pr (if no PR exists)
Basic: /review --quick → /commit → /push
Quick: /commit → /push
```

## Execution Logic

```bash
ship_it() {
  local workflow="${1:-full}"

  case "$workflow" in
    "quick")
      execute_workflow "commit,push"
      ;;
    "basic")
      execute_workflow "review --quick,commit,push"
      ;;
    "full"|*)
      execute_workflow "review,test,commit,push,pr"
      ;;
  esac
}

execute_workflow() {
  local steps="$1"
  IFS=',' read -ra COMMANDS <<< "$steps"
  local total=${#COMMANDS[@]}

  # Track commands in local progress file
  mkdir -p .tmp/ship-it
  echo "# Ship-It Progress - $(date)" > .tmp/ship-it/progress.log
  for i in "${!COMMANDS[@]}"; do
    local cmd="${COMMANDS[$i]}"
    echo "[$((i+1))] PENDING: /$cmd command" >> .tmp/ship-it/progress.log
  done

  # Execute each command
  for i in "${!COMMANDS[@]}"; do
    local cmd="${COMMANDS[$i]}"
    local cmd_id=$((i+1))

    echo "🚀 Step $cmd_id/$total: /$cmd"
    sed -i "s/\[$cmd_id\] PENDING/\[$cmd_id\] IN_PROGRESS/" .tmp/ship-it/progress.log

    if execute_command "$cmd"; then
      echo "✅ /$cmd completed"
      sed -i "s/\[$cmd_id\] IN_PROGRESS/\[$cmd_id\] COMPLETED/" .tmp/ship-it/progress.log
    else
      echo "❌ /$cmd failed - stopping workflow"
      sed -i "s/\[$cmd_id\] IN_PROGRESS/\[$cmd_id\] FAILED/" .tmp/ship-it/progress.log
      return 1
    fi
  done

  echo "🎉 Ship-it workflow completed!"
}

execute_command() {
  local cmd="$1"

  case "$cmd" in
    "review"|"review --quick")
      run_review_command "$cmd"
      ;;
    "test")
      run_test_command
      ;;
    "commit")
      run_commit_command
      ;;
    "push")
      run_push_command
      ;;
    "pr")
      if ! pr_exists_for_branch; then
        run_pr_command
      else
        echo "ℹ️ PR exists - skipping"
        return 0
      fi
      ;;
    *)
      echo "Unknown command: $cmd"
      return 1
      ;;
  esac
}

pr_exists_for_branch() {
  local current_branch=$(git branch --show-current)
  local pr_count=$(gh pr list --head "$current_branch" --json number --jq 'length')
  [[ "$pr_count" -gt 0 ]]
}

update_progress_status() {
  local id="$1"
  local status="$2"
  # Progress tracked via .tmp/ship-it/progress.log file
}

# Command execution functions
run_review_command() {
  # Execute /review command logic with args: $1
}

run_test_command() {
  # Execute /test command logic
}

run_commit_command() {
  # Execute /commit command logic
}

run_push_command() {
  # Execute /push command logic
}

run_pr_command() {
  # Execute /pr command logic
}
```

## Error Handling

```yaml
Strategy: Stop on first failure (fail-fast)
/review fails: Stop, manual fix needed
/test fails: Stop, fix tests first
/commit fails: Stop, resolve issues
/push fails: Stop, check remote
/pr fails: Continue (user can create manually)
```

## Examples

```bash
User: /ship-it
Claude: 🚀 Step 1/5: /review
✅ /review completed
🚀 Step 2/5: /test
✅ /test completed
🚀 Step 3/5: /commit
✅ /commit completed
🚀 Step 4/5: /push
✅ /push completed
🚀 Step 5/5: /pr
ℹ️ PR exists - skipping
🎉 Ship-it workflow completed!

User: /ship-it --quick
Claude: 🚀 Step 1/2: /commit
✅ /commit completed
🚀 Step 2/2: /push
✅ /push completed
🎉 Ship-it workflow completed!
```

## Key Features

- **Command Orchestration**: Executes actual `/` commands in sequence
- **Todo Integration**: Each command becomes a tracked todo item
- **Smart PR Logic**: Only creates PR if none exists for branch
- **Fail-Fast**: Stops on first command failure
- **Three Workflows**: Full, basic, and quick options

## Notes

- Default is full workflow (review → test → commit → push → pr)
- Each `/` command executed with full functionality
- Todo list tracks progress and shows failures
- PR creation intelligently skipped if PR already exists
