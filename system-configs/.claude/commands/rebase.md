---
description: Rebase current branch on latest main (or specified branch)
argument-hint: [target_branch] [--continue|--abort]
---

# /rebase Command

## Usage

```bash
/rebase                  # Rebase current branch on main
/rebase develop          # Rebase on specific branch
/rebase --continue       # Continue after resolving conflicts
/rebase --abort          # Abort rebase operation
```

## Description

Safely rebases the current branch on the latest version of the target branch (default: main). Automatically stashes
uncommitted changes, updates the target branch, and rebases cleanly. Follows the same direct execution pattern as
/branch for speed and reliability.

## Expected Output

Direct execution workflow for efficient rebasing:

1. **Safety Check**: Verify repository state and stash uncommitted changes if needed
2. **Update Target**: Switch to target branch and pull latest changes with rebase
3. **Rebase Operation**: Switch back to feature branch and rebase on updated target
4. **Conflict Handling**: Provide clear guidance if conflicts occur

## Behavior

### Default Mode - Rebase on Main

Execute rebase with minimal overhead:

1. **Pre-Rebase Safety Checks**

   ```bash
   # Check current branch
   current_branch=$(git branch --show-current)

   # Verify not on main/master
   if [[ "$current_branch" == "main" || "$current_branch" == "master" ]]; then
     echo "❌ Cannot rebase main branch on itself"
     exit 1
   fi

   # Check for uncommitted changes
   if ! git diff --quiet || ! git diff --cached --quiet; then
     echo "💾 Stashing uncommitted changes..."
     git stash push -m "Auto-stash before rebase on $(date +%Y%m%d-%H%M%S)"
     stashed=true
   fi
   ```

2. **Update Target Branch**

   ```bash
   # Switch to target branch (default: main, fallback to master)
   target_branch="${1:-main}"
   echo "🔄 Updating $target_branch..."

   git checkout "$target_branch" 2>/dev/null || git checkout master

   # Pull latest changes with rebase to keep history clean
   git pull --rebase

   echo "✅ $target_branch updated to latest"
   ```

3. **Rebase Feature Branch**

   ```bash
   # Switch back to feature branch
   echo "🔄 Rebasing $current_branch on $target_branch..."
   git checkout "$current_branch"

   # Rebase on updated target
   if git rebase "$target_branch"; then
     echo "✅ Rebase successful!"

     # Restore stashed changes if any
     if [ "$stashed" = true ]; then
       echo "💾 Restoring stashed changes..."
       git stash pop
     fi

     echo ""
     echo "📊 Branch Status:"
     git log --oneline "$target_branch..$current_branch" | head -5
   else
     echo "⚠️ Rebase conflicts detected"
     handle_conflicts
   fi
   ```

4. **Confirmation**
   - Display rebase status
   - Show commits on feature branch
   - Provide next steps guidance

### Continue Mode (--continue)

Resume rebase after resolving conflicts:

```bash
/rebase --continue
```

**What it does:**

1. Verify conflicts are resolved
2. Stage resolved files
3. Continue rebase operation
4. Report status

### Abort Mode (--abort)

Cancel rebase and return to pre-rebase state:

```bash
/rebase --abort
```

**What it does:**

1. Abort rebase operation
2. Return to original branch state
3. Restore stashed changes if any
4. Confirm cancellation

## Conflict Handling

When conflicts occur during rebase:

```yaml
Conflict Detection:
  - Identify conflicting files
  - Show conflict markers
  - Provide resolution guidance

User Guidance:
  1. List conflicting files
  2. Suggest: "Resolve conflicts in these files"
  3. Provide commands:
     - git status (see conflicts)
     - git diff (view conflicts)
     - /rebase --continue (after resolving)
     - /rebase --abort (to cancel)

Example Output:
  ⚠️ Rebase conflicts in 3 files:
    • src/auth/login.ts
    • src/api/routes.ts
    • tests/integration.test.ts

  📝 Next steps:
    1. Open conflicting files and resolve conflicts
    2. Stage resolved files: git add <file>
    3. Continue rebase: /rebase --continue

  Or abort: /rebase --abort
```

## Error Handling

Handle common scenarios gracefully:

```yaml
Already on Main:
  - Detect if current branch is main/master
  - Error: "Cannot rebase main on itself"
  - Suggest creating feature branch first

Uncommitted Changes:
  - Auto-stash with descriptive message
  - Include timestamp in stash message
  - Auto-restore after successful rebase

Remote Divergence:
  - Detect if branch was force-pushed
  - Warn about rewriting history
  - Suggest force push with lease after rebase

Network Issues:
  - Report connection problems
  - Suggest retry or offline rebase
  - Provide manual git commands

Already Rebased:
  - Detect if branch is already up to date
  - Report: "Branch already based on latest main"
  - Show current status
```

## Success Criteria

Simple and effective rebasing:

- Current branch rebased on latest target branch
- Uncommitted changes preserved (stashed and restored)
- Clear conflict guidance if needed
- Fast execution (5-10 seconds for clean rebase)
- Minimal overhead and complexity

## Advanced Usage

### Rebase on Specific Branch

```bash
/rebase develop
# Rebases current branch on develop instead of main
```

### Interactive Workflow

```bash
# Start rebase
/rebase

# If conflicts occur
# ... resolve conflicts manually ...
git add <resolved-files>

# Continue rebase
/rebase --continue

# Or abort if needed
/rebase --abort
```

## Command Philosophy

Transform branch rebasing from a multi-step manual process into a single, safe command. Focus on direct execution
following the /branch pattern for speed and reliability.

```yaml
Direct Execution Benefits:
  - Fast rebasing (5-10 seconds)
  - Safe handling of uncommitted changes
  - Clear conflict resolution guidance
  - Minimal system overhead
  - Predictable behavior

Key Safety Features:
  - Auto-stash uncommitted changes
  - Verify not rebasing main on itself
  - Clean target branch update with rebase
  - Clear error messages and guidance
  - Easy abort mechanism
```

## Implementation Notes

### Git Operations Sequence

```bash
# Complete rebase workflow
current_branch=$(git branch --show-current)
target_branch="${1:-main}"

# Safety checks
[[ "$current_branch" == "main" || "$current_branch" == "master" ]] && exit 1
[[ -n "$(git status --porcelain)" ]] && git stash push -m "Auto-stash before rebase"

# Update target
git checkout "$target_branch"
git pull --rebase

# Rebase feature branch
git checkout "$current_branch"
git rebase "$target_branch"

# Restore stash if exists
[[ -n "$(git stash list | grep 'Auto-stash before rebase')" ]] && git stash pop
```

### Conflict Detection

```bash
# Check for conflicts
if ! git rebase "$target_branch"; then
  echo "⚠️ Conflicts detected:"
  git diff --name-only --diff-filter=U | while read file; do
    echo "  • $file"
  done
  exit 1
fi
```

## Related Commands

- `/branch` - Create new branch from updated main
- `/push` - Push rebased branch to remote
- `/pr` - Create pull request after rebasing

## Notes

- Follows direct execution pattern like /branch
- No agents needed (Level 1 task)
- Preserves uncommitted changes safely
- Clear guidance for conflict resolution
- Fast and predictable execution
- Safe defaults with force-with-lease for subsequent push
