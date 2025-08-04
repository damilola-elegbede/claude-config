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

4. **Run comprehensive tests** using test-engineer agent:
   - Discover and execute all test suites
   - Check test coverage requirements
   - Ensure 100% test pass rate
   - Block push if any tests fail

5. **Run code review** using code-reviewer agent:
   - Review all changes to be pushed
   - Check for critical issues or regressions
   - Ensure production readiness
   - Generate quality report

6. **Quality gate enforcement**:
   - All tests must pass (100% success rate)
   - No critical code review issues
   - If warnings exist, require confirmation
   - Display quality summary before push

7. **Push to remote**:
   - Use `-u` flag if branch needs upstream tracking
   - Push to appropriate remote (usually origin)
   - Always specify current branch explicitly: `git push origin <current-branch>`

8. **Confirm success**:
   - Verify push completed
   - Show updated status
   - Display pushed commit summary

## Safety Features
- Prevents accidental pushes to main/master
- Warns about uncommitted changes
- Sets up branch tracking automatically
- Shows what will be pushed before pushing
- Requires all tests to pass (100% success rate)
- Blocks push if critical code issues detected
- Enforces code review before any push
- Provides quality gate summary before push confirmation

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

## Quality Gates
Before push is allowed:
1. **Test Suite**: 100% of tests must pass
2. **Code Review**: No critical issues identified
3. **Working Directory**: Must be clean (no uncommitted changes)
4. **Branch Protection**: Respects repository branch rules

## Prerequisites
- Git repository with remote configured
- Commits to push
- Clean working directory (or explicit override)
- All tests passing (100% success rate)
- Code review approval (no critical issues)

## Notes
- Force pushes require explicit confirmation
- Protected branches follow repository rules
- Test failures will block push with detailed error report
- Code review issues must be resolved before retry
- Quality gates cannot be bypassed
