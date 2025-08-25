# /pr Command

## Description

Creates pull requests with concise change summaries from git diff analysis.
Focuses on what actually changed rather than hypothetical features.

## Usage

```bash
/pr [target_branch] [options]
```bash

## Arguments

- `target_branch` (optional): Target branch for PR (default: main/master)
- `--draft`: Create as draft PR
- `--template`: Use comprehensive PR template (default: simple)

## Agent Orchestration

### Parallel Analysis Phase

Deploy specialized agents simultaneously for comprehensive PR creation:

```yaml
tech-writer:
  role: Generate clear PR descriptions and summaries
  input: Git diff, commit messages, branch context
  output: Well-structured PR description with proper formatting

code-reviewer:
  role: Analyze changes for PR review preparation
  input: Changed files, diff statistics
  output: Change categorization, impact assessment, review notes

security-auditor:
  role: Review changes for security implications
  input: Code diff, dependency changes, API modifications
  output: Security assessment, vulnerability check, sensitive data scan
```bash

### Parallel Execution Benefits

```yaml
Time Optimization:
  - All agents analyze simultaneously
  - PR description generated while tests analyzed
  - Total time: 3-5 seconds (vs 10-15 sequential)

Quality Enhancement:
  - tech-writer ensures clear communication
  - code-reviewer provides review guidance
  - test-engineer validates quality metrics
```

## Behavior

When you invoke `/pr`, I will:

1. **Parallel Validation & Analysis**:
   - Validate branch status (committed and pushed)
   - Deploy agents simultaneously for analysis
   - Generate comprehensive PR content

2. **Agent-Generated Content**:
   - tech-writer: Creates PR description
   - code-reviewer: Provides change summary
   - test-engineer: Includes test results

3. **Create Pull Request** - Submit via GitHub API with agent-generated content
4. **Return PR URL** - Provide link for review

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
```bash

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
```bash

## Execution Verification

Deploy execution-evaluator to verify:

- ✅ **Branch validated** - Current branch committed and pushed successfully
- ✅ **Changes analyzed** - Git diff and commit messages processed by agents
- ✅ **PR description generated** - Clear, comprehensive description created
- ✅ **Test results included** - Test status and coverage information added
- ✅ **Security review completed** - Code changes reviewed for security implications
- ✅ **PR created successfully** - Pull request submitted via GitHub API
- ✅ **URL returned** - Valid PR URL provided for review and tracking

## Notes

- Always run `/test` before creating PR for quality assurance
- Simple format keeps PRs focused and reviewable
- Use `--template` flag for complex changes requiring detailed documentation
