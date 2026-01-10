---
description: Create pull requests with smart title and description generation
argument-hint: "[target_branch] [--draft] [--force]"
---

# /pr Command

## Usage

```bash
/pr                     # Creates PR to main branch
/pr develop             # Creates PR targeting develop branch
/pr --draft             # Creates draft PR for work in progress
/pr main --draft        # Combined: targets main branch as draft
/pr --force             # Create PR even if one already exists
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

📢 Posted acknowledgment for 2 skipped review issues
```

### PR Already Exists

```text
ℹ️ PR already exists: https://github.com/owner/repo/pull/123
💡 Use --force to create another PR
```

## Behavior

### Execution Flow

1. **Check for Existing PR**: Query GitHub for existing PR from current branch
   - If PR exists and `--force` not set: Output PR URL and exit (success)
   - If PR exists and `--force` set: Continue to create new PR
   - If no PR exists: Continue
2. **Analyze Changes**: Get diff between current branch and target branch
3. **Generate Content**: Create title and description based on commits and changes
4. **Create PR**: Submit to GitHub with generated content
5. **Post Review Acknowledgments**: If `.tmp/coderabbit-ignored.json` exists, post skipped issues as PR comment

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

```text
STEP 1: Check for existing PR
  RUN: gh pr view --json url 2>/dev/null
  IF: success AND NOT --force flag
    PARSE: url from output
    OUTPUT: "ℹ️ PR already exists: {url}"
    OUTPUT: "💡 Use --force to create another PR"
    END (success)

STEP 2: Analyze and create PR
  RUN: git diff main...HEAD
  RUN: git log main..HEAD
  GENERATE: title using conventional commit pattern
  GENERATE: description summarizing changes
  RUN: gh pr create --title "..." --body "..."
  SET: pr_url = created PR URL

STEP 3: Post review acknowledgments
  READ: .tmp/coderabbit-ignored.json
  IF: file exists AND has ignored_issues
    RUN: git branch --show-current
    VALIDATE: branch field matches current branch
    IF: matches
      BUILD: comment from ignored_issues grouped by category:
        ## Review Issue Acknowledgments

        The following issues were reviewed locally and intentionally not addressed:

        ### {category}
        | Location | Issue | Reason |
        |----------|-------|--------|
        | {foreach issue in category} |

        ---
        @coderabbitai These issues were reviewed during local development. No action needed.

      RUN: gh pr comment {pr_url} --body "{comment}"
      DELETE: .tmp/coderabbit-ignored.json
      OUTPUT: "📢 Posted acknowledgment for {count} skipped issues"

STEP 4: Report success
  OUTPUT: "✅ Pull request created: {pr_url}"
  END
```

## Arguments

- `target_branch` (optional): Target branch for PR (default: main/master)
- `--draft`: Create as draft PR
- `--force`: Create PR even if one already exists for this branch

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

- Checks for existing PR before creation (skips gracefully unless --force)
- Posts skipped review issues from `/review` as PR comment
- Generates clear, conventional commit style titles
- Creates concise, informative descriptions
- Cleans up `.tmp/coderabbit-ignored.json` after posting acknowledgments
