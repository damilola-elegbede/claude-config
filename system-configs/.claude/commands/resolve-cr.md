---
description: Resolve CodeRabbit review comments
argument-hint: [pr-number] [--auto|--dry-run]
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

1. **Fetch**: Get comments from GitHub API
2. **Evaluate**: Analyze each comment with code-reviewer
3. **Approve**: Present findings for user approval
4. **Fix**: Apply approved fixes
5. **Notify**: Post `@coderabbitai resolve` to PR

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

Options: [a]pprove all, [s]elect, [n]o fixes

Your choice: a

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

## Notes

- Fetches fresh data each run (no caching)
- Can run multiple times safely (idempotent)
- Posts resolution comment to trigger CodeRabbit update
- Typical execution: 2-5 minutes
