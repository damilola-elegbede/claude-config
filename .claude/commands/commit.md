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

2. **Analyze changes** to:
   - Summarize the nature of changes
   - Check for sensitive information
   - Draft a concise commit message

3. **Stage appropriate files**:
   - Add relevant untracked files
   - Exclude files that shouldn't be committed

4. **Create commit** with:
   - Descriptive message following conventional format
   - Claude co-authorship attribution:
     ```
     🤖 Generated with [Claude Code](https://claude.ai/code)
     
     Co-Authored-By: Claude <noreply@anthropic.com>
     ```

5. **Verify success** by checking git status after commit

## Commit Message Format
Follows conventional commit format:
- `type(scope): subject`
- Types: feat, fix, docs, style, refactor, test, chore
- Subject: imperative mood, lowercase, no period

## Examples
- `feat(settings): add dark mode toggle`
- `fix(auth): resolve login timeout issue`
- `docs(readme): update installation instructions`

## Prerequisites
- Git must be initialized in the repository
- Changes must exist (staged or unstaged)

## Notes
- If pre-commit hooks modify files, the commit will be retried once
- Empty commits are not created
- Sensitive information is flagged before committing