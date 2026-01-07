---
description: Resolve CodeRabbit review comments
argument-hint: [pr-number] [--auto|--dry-run]
thinking-level: megathink
thinking-tokens: 10000
---

# /resolve-cr Command

## Usage

```bash
/resolve-cr                # Interactive mode (default)
/resolve-cr <pr-number>    # Specific PR
/resolve-cr --auto         # Auto-fix all recommended
/resolve-cr --dry-run      # Analysis only
```

## Description

Fetches CodeRabbit review comments from GitHub, evaluates each against project standards, and applies approved fixes.

## Behavior

1. **Fetch**: Multi-source discovery from 3 GitHub API endpoints
   - Inline review comments: `gh api repos/{owner}/{repo}/pulls/{pr}/comments`
   - Review submissions: `gh pr view --json reviews`
   - PR discussion comments: `gh pr view --json comments`
   - Merge results and deduplicate by comment ID

2. **Evaluate**: Analyze each comment against project standards

3. **Approve**: Present evaluation table with options (MANDATORY in default mode)
   - `[a]` Approve all recommended fixes
   - `[s]` Select specific issues to fix
   - `[v]` View detailed analysis for a comment
   - `[n]` Skip all fixes

4. **Fix**: Apply approved fixes (delegate as needed)

5. **Notify**: Post `@coderabbitai resolve` to PR, push changes

## Expected Output

```text
User: /resolve-cr

🔍 Fetching CodeRabbit feedback on PR #228...
📊 Found 5 unresolved comments

Evaluating against project standards...

📊 CodeRabbit Feedback Evaluation:

| ID | Issue | Severity | Recommendation |
|----|-------|----------|----------------|
| 1 | Missing error handling | High | Yes ✓ |
| 2 | Add docstring | Medium | Yes ✓ |
| 3 | Use const vs let | Low | No ✗ |
| 4 | Extract constant | Medium | Yes ✓ |
| 5 | Add integration test | High | Yes ✓ |

Summary: 4 recommended, 1 skip (style preference)

Options:
  [a] Approve all recommended fixes (4 issues)
  [s] Select specific issues to fix
  [v] View detailed analysis
  [n] Skip all fixes

Your choice:

Applying fixes...
  ✅ Fixed error handling in auth.ts
  ✅ Added docstring to api.ts
  ✅ Extracted MAX_RETRIES constant
  ✅ Added payment integration test

🧪 Tests passing
📦 Committed: fix: resolve CodeRabbit feedback (4 issues)
⬆️ Pushed to remote
📢 Posted '@coderabbitai resolve' to PR #228

🎉 Resolved 4 of 5 issues
```

### Auto Mode

```text
User: /resolve-cr --auto

[Fetches and evaluates...]

⚡ Auto-fix mode: Applying 4 recommended fixes...

[Fixes applied...]

🎉 Auto-resolved 4 issues
```

## Implementation Notes

**CRITICAL**: In default mode (no `--auto`), you MUST use the `AskUserQuestion` tool after
displaying the evaluation table. Present the options and WAIT for user response before
applying any fixes. Never proceed without explicit approval.

**Multi-Source Fetching**: Query all 3 GitHub API endpoints to ensure comprehensive
coverage. Filter for CodeRabbit-authored comments. Merge and deduplicate by comment ID.

## Notes

- Fetches fresh data each run (no caching)
- Can run multiple times safely (idempotent)
- Posts resolution comment to trigger CodeRabbit update
- Typical execution: 2-5 minutes
