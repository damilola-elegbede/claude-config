---
description: Create pull requests with smart title and description generation
argument-hint: "[target_branch] [--draft]"
---

# /pr Command

## Usage

```bash
/pr                     # Creates PR to main branch
/pr develop             # Creates PR targeting develop branch
/pr --draft             # Creates draft PR for work in progress
/pr main --draft        # Combined: targets main branch as draft
```

## Description

Creates pull requests by analyzing commit changes and generating a clear title and thorough description.
Focuses on core PR creation functionality with minimal overhead.

## Expected Output

### Successful PR Creation

```text
🔍 Analyzing changes from main...
  Files changed: 5
  Commits: 3

📝 Generating PR content...
  Title: feat(auth): add OAuth2 integration

✅ Pull request created:
  https://github.com/owner/repo/pull/123
```

## Behavior

### Simple Execution Flow

1. **Analyze Changes**: Get diff between current branch and target branch
2. **Generate Content**: Create title and description based on commits and changes
3. **Create PR**: Submit to GitHub with generated content

### Agent Usage (Minimal)

```yaml
Optional_Agents:
  code-reviewer:
    role: Quick analysis of change type and scope
    usage: Only if changes are complex (>10 files)

  tech-writer:
    role: Generate clear PR title and description
    usage: Only if commit messages are unclear
```

### Title Generation

Analyze commit messages and changes to generate conventional commit style titles:

```yaml
Pattern_Detection:
  - Multiple feat commits → "feat: consolidated feature description"
  - Bug fixes → "fix: clear description of what was fixed"
  - Refactoring → "refactor: what was refactored"
  - Documentation → "docs: what documentation was updated"
  - Mixed changes → Use primary change type
```

### Description Generation

Create a clear, concise description covering:

1. **What changed** - Brief summary of modifications
2. **Why it changed** - Context from commit messages
3. **Testing** - Mention if tests were added/modified
4. **Breaking changes** - Flag if applicable

## PR Description Format

### Standard Format

```markdown
## Summary
[1-2 sentence overview of the changes]

## Changes
- [Key change 1]
- [Key change 2]
- [Key change 3]

## Context
[Why these changes were made, referencing commits]

## Testing
[What testing was done or tests added]

## Related Issues
Closes #123 (if applicable)
```

### Example Output

```markdown
## Summary
Add OAuth2 authentication integration for third-party login support.

## Changes
- Implement OAuth2 flow in auth service
- Add Google and GitHub provider configurations
- Update login UI with social login buttons
- Add integration tests for OAuth flow

## Context
Based on user feedback requesting social login options. This implementation follows RFC 6749 OAuth 2.0 specification and integrates with our existing JWT authentication system.

## Testing
Added unit tests for OAuth service and integration tests for the complete authentication flow. All existing auth tests still pass.

## Related Issues
Closes #456
```

## Usage Examples

```bash
/pr
# Creates PR to main branch

/pr develop
# Creates PR targeting develop branch

/pr --draft
# Creates draft PR for work in progress
```

## Implementation

### Direct Execution

When `/pr` is invoked:

1. **Check for existing PR**: `gh pr list --head $(git branch --show-current)`
2. **Get changes**: `git diff main...HEAD` and `git log main..HEAD`
3. **Generate title**: Analyze commits for conventional commit pattern
4. **Generate description**: Summarize changes clearly
5. **Create PR**: `gh pr create --title "..." --body "..."`

## Arguments

- `target_branch` (optional): Target branch for PR (default: main/master)
- `--draft`: Create as draft PR

## Performance

### Execution Time

- **Change analysis**: 1-2 seconds
- **Content generation**: 1-2 seconds
- **PR creation**: 1 second
- **Total**: 3-5 seconds

### Benefits of Streamlined Approach

- **Faster execution**: 3-5 seconds vs 6-8 seconds
- **Focused functionality**: Core PR creation without overhead
- **Clear output**: Simple, readable PR descriptions
- **Minimal agents**: Only use agents when truly needed

## Notes

- Focuses on essential PR creation functionality
- Generates clear, conventional commit style titles
- Creates concise, informative descriptions
- Avoids unnecessary complexity and analysis
