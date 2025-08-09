# /ship Command

## Description
Streamlined workflow command that executes the complete code delivery pipeline: commits changes, pushes to remote, and creates a pull request - all in one command. Perfect for when your code is ready to ship.

## Usage
```
/ship [commit-message]
```

## Arguments
- `commit-message` (optional): Custom commit message. If not provided, will auto-generate based on changes.

## Behavior
When you use `/ship`, I will execute three commands in sequence:

1. **Commit** (`/commit`):
   - Stages all changes
   - Creates commit with message
   - Runs pre-commit hooks if configured
   - Auto-generates message if not provided

2. **Push** (`/push`):
   - Pushes current branch to remote
   - Sets upstream if needed
   - Handles force push if necessary (with confirmation)

3. **Pull Request** (`/pr`):
   - Creates PR to main/master branch
   - Auto-generates PR title and description
   - Includes commit history in PR body
   - Returns PR URL for review

## Workflow Steps

### Phase 1: Pre-flight Checks
- Verify git repository status
- Check for uncommitted changes
- Ensure branch is not main/master
- Verify remote connectivity

### Phase 2: Commit
- Stage all modified files
- Generate or use provided commit message
- Create commit with proper formatting
- Add co-author attribution

### Phase 3: Push
- Push to remote repository
- Set upstream tracking if new branch
- Handle any push conflicts

### Phase 4: Pull Request
- Create PR with comprehensive description
- Include test plan
- Add relevant labels if available
- Return PR URL

## Examples

### Basic usage (auto-generated message)
```bash
/ship
# Analyzes changes, creates commit, pushes, and opens PR
```

### With custom commit message
```bash
/ship "feat: add user authentication system"
# Uses provided message for commit, then pushes and creates PR
```

### After feature completion
```bash
# Complete your feature development
/test                    # Run tests
/review                  # Code review
/ship                    # Ship it!
```

## Success Criteria

The command succeeds when:
- ✅ All changes are committed
- ✅ Branch is pushed to remote
- ✅ PR is created successfully
- ✅ PR URL is returned

## Failure Handling

If any step fails:
- Stops execution at failed step
- Reports specific error
- Provides recovery instructions
- Does not proceed to next step

Common failure scenarios:
- **Commit fails**: Pre-commit hooks or validation errors
- **Push fails**: Network issues or permissions
- **PR fails**: PR already exists or API issues

## Integration with Other Commands

### Prerequisites
These commands are often used before `/ship`:
- `/test` - Ensure tests pass
- `/review` - Get code review
- `/resolve-rabbit` - Fix PR comments

### Equivalent to
```bash
/commit
/push  
/pr
```

## Safety Features

- **Branch protection**: Won't ship from main/master
- **Change verification**: Shows diff before committing
- **PR duplicate check**: Won't create duplicate PRs
- **Upstream verification**: Ensures remote branch exists
- **Clean working tree**: Ensures no uncommitted changes remain

## Configuration

Respects repository settings for:
- Default branch name (main/master)
- PR templates if they exist
- Branch protection rules
- Required PR reviewers
- CI/CD integration

## Smart Features

### Auto-generated PR Description
Includes:
- Summary of changes
- List of modified files
- Test plan checklist
- Related issues/tickets (if mentioned)

### Commit Message Intelligence
When auto-generating:
- Follows conventional commits format
- Groups related changes
- Includes scope when identifiable
- References issues if found

### PR Title Generation
Creates descriptive titles:
- Uses commit message for single commits
- Summarizes for multiple commits
- Includes ticket numbers if found
- Follows team conventions

## Typical Workflow

```bash
# Development complete
/test                    # Ensure tests pass
/review                  # Optional: pre-review
/ship "feat: new feature" # Ship it!

# Returns something like:
✅ Committed: feat: new feature
✅ Pushed to origin/feature-branch  
✅ PR created: https://github.com/org/repo/pull/123
```

## Notes

- Perfect for rapid deployment workflows
- Reduces multiple commands to one
- Maintains git best practices
- Provides complete traceability
- Ideal for feature branches
- Supports GitHub Flow and Git Flow
- All sub-commands use their standard behavior
- Can be interrupted with Ctrl+C if needed
- Each step's output is displayed in real-time