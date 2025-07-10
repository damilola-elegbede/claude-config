# /push Command

## Description
Safely pushes changes to the remote repository with proper checks and branch tracking.

## Usage
```
/push
```

## Behavior
When you use `/push`, I will:

1. **Verify branch status**:
   - Check current branch name
   - Verify it's not main/master (unless explicitly allowed)
   - Check if branch has upstream tracking

2. **Check for unpushed commits**:
   - Run `git status` to see if ahead of remote
   - Show commit count to be pushed

3. **Ensure clean working directory**:
   - Verify no uncommitted changes
   - Suggest committing if changes exist

4. **Push to remote**:
   - Use `-u` flag if branch needs upstream tracking
   - Push to appropriate remote (usually origin)
   - Always specify current branch explicitly: `git push origin <current-branch>`

5. **Confirm success**:
   - Verify push completed
   - Show updated status

## Safety Features
- Prevents accidental pushes to main/master
- Warns about uncommitted changes
- Sets up branch tracking automatically
- Shows what will be pushed before pushing

## Common Scenarios

### First push of new branch
```bash
git push -u origin feature/new-feature
```

### Regular push to tracked branch
```bash
git push origin $(git branch --show-current)
```

### Force push (requires confirmation)
```bash
git push --force-with-lease
```

## Prerequisites
- Git repository with remote configured
- Commits to push
- Clean working directory (or explicit override)

## Notes
- Force pushes require explicit confirmation
- Protected branches follow repository rules
- Suggests creating PR after successful push to feature branch