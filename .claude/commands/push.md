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
   - If tests fail: Deploy test-engineer to fix or add missing tests
   - Re-run tests after fixes

5. **Run ENHANCED code review** with automated remediation:
   - **Phase 1**: code-reviewer identifies all issues
   - **Phase 2**: Deploy specialist agents in parallel:
     - backend-engineer for server-side fixes
     - frontend-architect for client-side improvements
     - security-auditor for vulnerability patches
     - performance-specialist for optimizations
     - test-engineer for coverage gaps
   - **Phase 3**: Re-review after remediation
   - **Phase 4**: Document rationales for unfixed issues

6. **Smart quality gate enforcement**:
   - After remediation attempts, evaluate remaining issues:
     - **Critical/Security**: Must be fixed (no push until resolved)
     - **With Rationale**: Log warning but allow push
     - **Without Rationale**: Block push until justified
   - Generate comprehensive report:
     - Issues fixed by agents
     - Remaining issues with rationales
     - Test results and coverage
   - User confirmation required if issues remain

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

## Enhanced Quality Gates with Remediation

### Automated Fix Process
Before push, agents automatically attempt to fix issues:
1. **Test Failures**: test-engineer debugs and fixes failing tests
2. **Linter Issues**: Auto-fix with appropriate formatters
3. **Code Quality**: Refactor using backend/frontend engineers
4. **Security**: security-auditor patches vulnerabilities
5. **Documentation**: tech-writer generates missing docs
6. **Performance**: performance-specialist optimizes bottlenecks

### Quality Gate Levels
1. **Critical (Blocking)**:
   - Security vulnerabilities
   - Breaking test failures
   - Data corruption risks
   - Must be fixed before push

2. **Important (Fix or Justify)**:
   - Code quality issues
   - Missing documentation
   - Performance degradation
   - Fix automatically or provide rationale

3. **Advisory (Document)**:
   - Style preferences
   - Optional optimizations
   - Future improvements
   - Document for technical debt tracking

### Push Decision Matrix
- **All Fixed**: Push proceeds automatically
- **Critical Issues**: Push blocked until resolved
- **Non-critical + Rationale**: Push with warnings and documentation
- **Non-critical No Rationale**: Request justification or fix

## Prerequisites
- Git repository with remote configured
- Commits to push
- Clean working directory (or explicit override)
- All tests passing (100% success rate)
- Code review approval (no critical issues)

## Notes
- Force pushes require explicit confirmation
- Protected branches follow repository rules
- Critical issues (security, breaking tests) always block push
- Non-critical issues are auto-fixed when possible
- Unfixed issues require documented rationale
- User can override non-critical blocks with justification
- All remediation attempts are logged for audit trail
