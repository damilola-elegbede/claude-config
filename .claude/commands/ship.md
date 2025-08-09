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
When you use `/ship`, I will execute three user commands in sequence:

1. **Execute `/commit` command**:
   - Runs comprehensive code review with automated remediation
   - Performs file cleanup (removes temp files, build artifacts)
   - Stages appropriate changes
   - Creates commit with proper message format
   - Includes all quality gates and safety checks from /commit
   - Auto-generates message if not provided

2. **Execute `/push` command**:
   - Runs comprehensive tests using test-engineer agent
   - Performs enhanced code review with automated remediation
   - Enforces quality gates (blocks critical issues)
   - Pushes current branch to remote with all safety checks
   - Sets upstream tracking if needed
   - Includes all validation logic from /push

3. **Execute `/pr` command**:
   - **Checks for existing PR** for current branch first
   - If PR exists: Shows existing PR URL and skips creation
   - If no PR exists: Creates new PR to main/master branch
   - Auto-generates PR title and description
   - Includes commit history in PR body
   - Returns PR URL for review

## Execution Flow

### Step 1: Execute `/commit` Command
- **Invokes actual `/commit` user command** (not raw git commands)
- Inherits ALL `/commit` functionality:
  - Enhanced code review with automated remediation
  - File cleanup (temp files, build artifacts, system files)
  - Quality gate enforcement (blocks critical issues)
  - Specialist agent deployment for fixes
  - Proper commit message formatting
  - Co-author attribution
- If `/commit` fails: `/ship` stops execution
- Pass through commit message parameter if provided

### Step 2: Execute `/push` Command  
- **Invokes actual `/push` user command** (not raw git commands)
- Inherits ALL `/push` functionality:
  - Comprehensive test execution via test-engineer agent
  - Enhanced code review with automated remediation
  - Quality gate enforcement (blocks for critical issues)
  - Branch safety checks
  - Upstream tracking setup
  - Force push protection
- If `/push` fails: `/ship` stops execution

### Step 3: Execute `/pr` Command
- **Invokes actual `/pr` user command** (not raw git commands)  
- Inherits ALL `/pr` functionality:
  - Existing PR detection and duplicate prevention
  - PR template usage if configured
  - Auto-generated titles and descriptions
  - Commit history inclusion
  - Label and reviewer assignment
- If PR creation fails: Reports error but doesn't fail `/ship`
- Returns final PR URL or existing PR info

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

### Multiple runs on same branch
```bash
# First run - creates PR
/ship "feat: initial implementation"
# ✅ PR created: https://github.com/org/repo/pull/123

# Make more changes, then run again
/ship "feat: add error handling" 
# ✅ Commits and pushes changes
# ℹ️  PR already exists - no new PR created
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

### Command Execution Sequence
Instead of running raw git commands, `/ship` executes:
```bash
/commit [message]  # Full /commit command with all checks
/push              # Full /push command with all validations  
/pr                # Full /pr command with duplicate prevention
```

This ensures ALL command-specific logic is preserved:
- `/commit`: Code review, file cleanup, quality gates
- `/push`: Test execution, code review, safety checks  
- `/pr`: Duplicate prevention, template usage, auto-assignment

## Safety Features

**Inherits ALL safety features from constituent commands:**

### From `/commit` command:
- **File cleanup**: Automatic removal of temp files, build artifacts
- **Code review**: Comprehensive review with automated remediation
- **Quality gates**: Blocks commits with critical issues
- **Change verification**: Shows diff before committing

### From `/push` command:
- **Test execution**: Comprehensive test suite via test-engineer agent
- **Code review**: Enhanced review with quality gate enforcement
- **Branch protection**: Won't push from main/master
- **Force push protection**: Requires explicit confirmation
- **Upstream verification**: Ensures remote branch exists

### From `/pr` command:
- **PR duplicate prevention**: Checks for existing PR before creation
- **Template usage**: Uses PR templates if configured
- **Review assignment**: Auto-assigns reviewers if configured

### Additional `/ship` safety:
- **Command failure handling**: Stops execution if any step fails
- **Clean state guarantee**: Each step completes fully before next step
- **Full traceability**: All command outputs preserved and displayed

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

# First time returns:
✅ Committed: feat: new feature
✅ Pushed to origin/feature-branch  
✅ PR created: https://github.com/org/repo/pull/123

# Second time on same branch returns:
✅ Committed: additional changes
✅ Pushed to origin/feature-branch  
ℹ️  PR already exists: https://github.com/org/repo/pull/123 (Open)
```

## Notes

- **Executes actual user commands**: Calls `/commit`, `/push`, `/pr` (not raw git)
- **Inherits full functionality**: All quality gates, safety checks, and automation
- **Perfect for rapid deployment**: Reduces workflow to single command
- **Maintains best practices**: Leverages all built-in command logic
- **Complete traceability**: Full output from all three commands preserved
- **Ideal for feature branches**: Supports GitHub Flow and Git Flow
- **Safe to run multiple times**: Won't create duplicate PRs
- **Failure handling**: Stops at first command failure for safety
- **Can be interrupted**: Ctrl+C stops execution cleanly
- **Real-time feedback**: All command outputs displayed as they execute
- **Parameter passing**: Commit message passed through to `/commit`