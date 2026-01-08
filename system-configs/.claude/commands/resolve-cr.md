---
description: Resolve CodeRabbit review comments
argument-hint: "[pr-number] [--local|--auto|--dry-run]"
thinking-level: megathink
thinking-tokens: 10000
---

# /resolve-cr Command

## Usage

```bash
/resolve-cr                # Interactive mode - fetch from PR (default)
/resolve-cr <pr-number>    # Specific PR
/resolve-cr --local        # Local mode - run CodeRabbit CLI on local changes
/resolve-cr --auto         # Auto-fix all recommended
/resolve-cr --dry-run      # Analysis only
```

## Description

Handles CodeRabbit feedback from two sources:

- **PR mode** (default): Fetches comments from existing GitHub PR
- **Local mode** (`--local`): Runs CodeRabbit CLI on local changes before PR exists

Both modes use the same interactive triage flow for fix/skip decisions.

## Behavior

### PR Mode (default)

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

### Local Mode (`--local`)

1. **Run**: Execute CodeRabbit CLI with local config

   ```bash
   coderabbit review --prompt-only --type all --config .coderabbit.yaml --base <default-branch>
   ```

   - `--type all`: Reviews both uncommitted and committed changes
   - `--config .coderabbit.yaml`: Uses repository-specific settings
   - `--base <default-branch>`: Analyzes full branch diff from default branch (use `main`, `master`, or your repo's default)

2. **Evaluate**: Same as PR mode - analyze against project standards

3. **Approve**: Same interactive table with additional option
   - `[a]` Approve all recommended fixes
   - `[s]` Select specific issues to fix
   - `[v]` View detailed analysis
   - `[n]` Skip all - document as ignored (creates `.tmp/coderabbit-ignored.json` for PR acknowledgment)
   - `[c]` Continue without action - dismiss issues without tracking (use when re-running after prior review or when you explicitly don't want PR acknowledgment)

4. **Track Ignored Issues**: For skipped issues, prompt for reason:
   - `nitpick` - Style preference, not a real issue
   - `false-positive` - CodeRabbit misunderstood the code
   - `intentional` - Deliberate design choice
   - `out-of-scope` - Valid but not for this PR
   - `will-fix-later` - Acknowledged, tracked elsewhere

   Store in `.tmp/coderabbit-ignored.json` for PR acknowledgment

5. **Fix**: Apply approved fixes (same as PR mode, no PR posting)

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

### Local Mode

```text
User: /resolve-cr --local

🔍 Running CodeRabbit local analysis...
  coderabbit review --prompt-only --type all --config .coderabbit.yaml --base main

📊 Found 5 issues

Evaluating against project standards...

📊 CodeRabbit Issue Evaluation:

| ID | Issue | Severity | Location | Recommendation |
|----|-------|----------|----------|----------------|
| 1 | Missing error handling | High | auth.ts:45 | Fix ✓ |
| 2 | Add input validation | Medium | api.ts:12 | Fix ✓ |
| 3 | Use const vs let | Low | utils.ts:8 | Skip ✗ |
| 4 | Replace informal phrasing | Low | SKILL.md:90 | Skip ✗ |
| 5 | Extract magic number | Medium | config.ts:3 | Fix ✓ |

Summary: 3 recommended fixes, 2 skips

Options:
  [a] Approve all recommended fixes (3 issues)
  [s] Select specific issues to fix
  [v] View detailed analysis
  [n] Skip all - document as ignored for PR
  [c] Continue without action

Your choice: s
Select issues to fix (comma-separated): 1,2,5

📝 Documenting skipped issues...

Issue 3: utils.ts:8 - Use const vs let

Reason for ignoring:
  [1] nitpick    [2] false-positive    [3] intentional
  [4] out-of-scope    [5] will-fix-later

Your choice: 2
Explanation (optional): Variable is reassigned on line 25
✅ Documented: false-positive

Issue 4: SKILL.md:90 - Replace informal phrasing

Reason for ignoring:
  [1] nitpick    [2] false-positive    [3] intentional
  [4] out-of-scope    [5] will-fix-later

Your choice: 3
Explanation (optional): Matches project voice guidelines
✅ Documented: intentional

Applying fixes...
  ✅ Fixed error handling in auth.ts
  ✅ Added validation to api.ts
  ✅ Extracted magic number in config.ts

🧪 Tests passing

📄 Saved 2 ignored issues to .tmp/coderabbit-ignored.json
   (Will be posted as acknowledgment when PR is created)

🎉 Fixed 3 issues, documented 2 for PR acknowledgment
```

### Ignored Issues File Format

**Location**: `.tmp/coderabbit-ignored.json`

```json
{
  "schema_version": "1.0",
  "branch": "feature/my-feature",
  "created_at": "2025-01-08T15:30:00Z",
  "ignored_issues": [
    {
      "id": 3,
      "location": "utils.ts:8",
      "description": "Use const vs let",
      "severity": "LOW",
      "category": "false-positive",
      "reason": "Variable is reassigned on line 25"
    }
  ]
}
```

**Field Validation**:

- **`schema_version`**: Format version (current: "1.0") for backward compatibility
- **`severity`**: Must be one of: `LOW`, `MEDIUM`, `HIGH`, `CRITICAL`
- **`category`**: Must be one of: `nitpick`, `false-positive`, `intentional`, `out-of-scope`, `will-fix-later`

**Field Semantics**:

- **`branch`**: Git branch name - used by `/ship-it` to validate the file matches current branch (prevents posting stale acknowledgments from old branches)
- **`created_at`**: RFC3339 timestamp - audit trail and staleness detection (files older than 7 days trigger warnings)

## Implementation Notes

**CRITICAL**: In default mode (no `--auto`), you MUST use the `AskUserQuestion` tool after
displaying the evaluation table. Present the options and WAIT for user response before
applying any fixes. Never proceed without explicit approval.

**Multi-Source Fetching**: Query all 3 GitHub API endpoints to ensure comprehensive
coverage. Filter for CodeRabbit-authored comments. Merge and deduplicate by comment ID.

## Notes

### PR Mode

- Fetches fresh data each run (no caching)
- Can run multiple times safely (idempotent)
- Posts resolution comment to trigger CodeRabbit update
- Typical execution: 2-5 minutes

### Local Mode

- Runs CodeRabbit CLI locally (requires `coderabbit` installed and authenticated)
- Uses `.coderabbit.yaml` for path instructions and tool configuration
- Uses `--base <default-branch>` to analyze full branch diff, matching what PR review sees (substitute your repo's default: `main`, `master`, etc.)
- Stores ignored issues in `.tmp/coderabbit-ignored.json`
- Ignored issues file is consumed by `/ship-it` when creating PR
- Does NOT post to GitHub (no PR exists yet)
- Typical execution: 1-3 minutes

### File Lifecycle

- `.tmp/` directory is gitignored and ephemeral
- Each `/resolve-cr --local` run **overwrites** the ignored issues file (not appending)
- `/ship-it` validates `branch` field matches current branch before posting
- Cross-branch isolation: switching branches won't accidentally post old acknowledgments
- File is deleted after `/ship-it` posts acknowledgment to PR
