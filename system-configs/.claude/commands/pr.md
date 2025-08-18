# /pr Command

## Description

Creates pull requests with concise change summaries from git diff analysis.
Focuses on what actually changed rather than hypothetical features.

## Usage

```bash
/pr [target_branch] [options]
```

## Arguments

- `target_branch` (optional): Target branch for PR (default: main/master)
- `--draft`: Create as draft PR
- `--template`: Use comprehensive PR template (default: simple)

## Behavior

When you invoke `/pr`, I will:

1. **Validate branch status** - Ensure changes are committed and pushed
2. **Generate diff summary** - Extract actual changes from git diff
3. **Include test results** - Add pass/fail status if /test was run
4. **Create pull request** - Submit via GitHub API
5. **Return PR URL** - Provide link for review

## PR Description Format

### Simple Format (Default)

```markdown
## Summary
[One paragraph describing what changed and why]

## Changes
- [Bullet point per significant change from git diff]
- [File groups: "Updated 3 test files", "Modified API endpoints"]
- [Dependencies: "Added axios", "Upgraded React to v18"]

## Test Results
✅ All tests passing (if /test was run)
❌ 2 tests failing: auth.test.js, user.test.js (if applicable)

## Related Issues
Closes #123 (if applicable)
```

### Template Format (--template flag)

Uses `.github/pull_request_template.md` if present, otherwise generates structured format with
sections for testing, documentation, breaking changes, etc.

## Examples

```bash
/pr
# Creates PR with simple format to main branch

/pr develop
# Creates PR targeting develop branch

/pr --draft
# Creates draft PR for work in progress

/pr --template
# Uses comprehensive template format
```

## Notes

- Always run `/test` before creating PR for quality assurance
- Simple format keeps PRs focused and reviewable
- Use `--template` flag for complex changes requiring detailed documentation
