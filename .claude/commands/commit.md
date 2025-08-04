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

2. **Run code review** using code-reviewer agent:
   - Analyze all staged and unstaged changes
   - Check for code quality issues
   - Identify critical problems that must be fixed
   - Generate review report with actionable feedback

3. **Review gate enforcement**:
   - If critical issues found: Block commit and require fixes
   - If only warnings/suggestions: Proceed with commit after confirmation
   - Display review summary before proceeding

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

## Code Review Requirements
The code review will check for:
- **Critical Issues**: Security vulnerabilities, breaking changes, data loss risks
- **Code Quality**: Maintainability, readability, proper error handling
- **Style Compliance**: Formatting, naming conventions, project standards
- **Test Coverage**: Adequate tests for new/modified functionality

### Review Outcomes
1. **No Issues**: Commit proceeds automatically
2. **Warnings Only**: Asks for confirmation before committing
3. **Critical Issues**: Blocks commit until issues are resolved

## Prerequisites
- Git must be initialized in the repository
- Changes must exist (staged or unstaged)
- Code must pass review checks (no critical issues)

## Notes
- If pre-commit hooks modify files, the commit will be retried once
- Empty commits are not created
- Code review is mandatory and cannot be skipped
- Review results are displayed before commit confirmation
