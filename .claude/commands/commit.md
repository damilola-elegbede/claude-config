# /commit Command

## Description
Creates a git commit following Claude's standards with proper formatting and co-authorship attribution.

## Usage
```
/commit
```

## Behavior
When you use `/commit`, I will:

1. **Check repository status** by running:
   - `git status` to see untracked files
   - `git diff` to see staged and unstaged changes
   - `git log` to match repository's commit style

2. **Run STRICT MODE code review** using code-reviewer agent:
   - Execute ALL applicable linters (ESLint, Prettier, etc.) on staged files only
   - Analyze only staged changes (files in `git diff --cached --name-only`)
   - Enforce zero-tolerance quality standards for staged files
   - Block commit for ANY violations in staged files (no warnings)
   - Generate strict review report with required fixes for staged changes

3. **Strict review gate enforcement**:
   - ANY linter errors: Block commit (zero tolerance)
   - ANY code quality issues: Block commit 
   - No warnings mode: ALL issues are blocking
   - Display full review report with required fixes
   - Commit only proceeds with 100% compliance

4. **Analyze changes** to:
   - Summarize the nature of changes
   - Check for sensitive information
   - Draft a concise commit message

5. **Stage appropriate files**:
   - Add relevant untracked files
   - Exclude files that shouldn't be committed

6. **Create commit** with:
   - Descriptive message following conventional format
   - Claude co-authorship attribution:
     ```
     🤖 Generated with [Claude Code](https://claude.ai/code)
     
     Co-Authored-By: Claude <noreply@anthropic.com>
     ```

7. **Verify success** by checking git status after commit

## Commit Message Format
Follows conventional commit format:
- `type(scope): subject`
- Types: feat, fix, docs, style, refactor, test, chore
- Subject: imperative mood, lowercase, no period

## Examples
- `feat(settings): add dark mode toggle`
- `fix(auth): resolve login timeout issue`
- `docs(readme): update installation instructions`

## Strict Mode Code Review Requirements
The STRICT MODE review enforces:
- **Linter Compliance**: 0 errors, 0 warnings from ALL linters
- **Security**: Zero vulnerabilities tolerated
- **Code Quality**: No complexity, duplication, or maintainability issues
- **Style Compliance**: 100% adherence to style guides
- **Test Coverage**: Minimum 80% coverage required (coverage < 80% = ERROR, not warning)
- **Documentation**: All public APIs must be documented
- **Performance**: No inefficient algorithms allowed
- **Error Handling**: EVERY function must handle errors

### Strict Mode Outcomes
1. **100% Compliance**: Commit proceeds automatically
2. **ANY Violation**: Commit BLOCKED - must fix ALL issues
3. **No Warnings**: Everything is either PASS or BLOCK

## Prerequisites
- Git must be initialized in the repository
- Changes must exist (staged or unstaged)
- Code must pass review checks (no critical issues)

## Notes
- If pre-commit hooks modify files, the commit will be retried once
- Empty commits are not created
- Code review is mandatory and cannot be skipped
- Review results are displayed before commit confirmation
