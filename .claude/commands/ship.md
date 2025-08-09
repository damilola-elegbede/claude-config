# /ship Command

## Description

Streamlined workflow command that executes the complete code delivery pipeline: 
commits changes, pushes to remote, and creates a pull request - all in one command. 
Perfect for when your code is ready to ship.

## Prerequisites

Before using `/ship`, ensure you have:
- Git installed and configured
- GitHub CLI (`gh`) installed
- Current working directory is a Git repository
- Logged in to GitHub via `gh auth`
- Appropriate branch permissions
- Resolved any pending merge conflicts

## Usage

```bash
/ship [commit-message]
```

## Arguments

- `commit-message` (optional): Custom commit message. If not provided, 
  will auto-generate based on changes.

## Implementation Note

This command implements a hard-coded logic for delivering code, 
reading specific command documentation files to ensure comprehensive 
execution of commit, push, and PR creation steps.

## Behavior

The `/ship` command executes a comprehensive code delivery workflow:

1. **Commit Changes**:
   - Perform enhanced code review
   - Clean up temporary files
   - Stage appropriate changes
   - Create commit with proper message
   - Enforce quality gates

2. **Push to Remote**:
   - Run comprehensive tests
   - Perform additional code review
   - Push current branch to remote
   - Set upstream tracking if needed

3. **Create Pull Request**:
   - Check for existing PRs
   - Create new PR to main/master branch
   - Auto-generate PR title and description
   - Include commit history

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

### Typical Development Workflow

```bash
# Complete your feature development
/test                    # Run tests
/review                  # Code review
/ship                    # Ship it!
```

## Success Criteria

The command succeeds when:
- All changes are committed
- Branch is pushed to remote
- PR is created successfully
- PR URL is returned

## Troubleshooting

### Common Issues

1. **Commit Failures**
   - Check pre-commit hooks
   - Verify code review comments
   - Ensure no sensitive information is staged

2. **Push Failures**
   - Verify network connection
   - Check GitHub permissions
   - Confirm branch is not protected

3. **PR Creation Issues**
   - Ensure GitHub CLI is authenticated
   - Check branch naming conventions
   - Verify no existing open PRs

### Recovery Steps

- If `/ship` fails, run individual commands:
  1. `/commit` to stage changes
  2. `/push` to update remote
  3. `/pr` to create pull request

## Safety Features

### Commit Safety
- Automatic file cleanup
- Comprehensive code review
- Quality gate enforcement
- Change verification

### Push Safety
- Test suite execution
- Branch protection checks
- Force push prevention
- Upstream verification

### PR Safety
- Duplicate PR prevention
- Template usage
- Automatic reviewer assignment

## Smart Features

### Commit Message Generation
- Follows conventional commits format
- Groups related changes
- Includes identifiable scope
- References related issues

### PR Description Intelligence
- Summarizes changes
- Lists modified files
- Generates test plan
- Links related tickets

## Configuration

Respects repository settings:
- Default branch name
- PR templates
- Branch protection rules
- Required reviewers
- CI/CD integrations

## Notes

- Reads and implements command documentation
- Preserves all quality gates and safety checks
- Supports GitHub Flow and Git Flow
- Safe to run multiple times
- Provides real-time feedback
- Stops at first critical failure

## Integration with Other Commands

Recommended pre-`/ship` commands:
- `/test` - Ensure tests pass
- `/review` - Get code review
- `/resolve-rabbit` - Fix PR comments