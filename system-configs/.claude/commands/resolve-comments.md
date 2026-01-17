---
description: Resolve review comments from any source
argument-hint: "[pr-number] [--code-rabbit] [--local] [--auto] [--dry-run]"
---

# /resolve-comments Command

## Usage

```bash
/resolve-comments                     # Fetch and resolve PR comments (default)
/resolve-comments <pr-number>         # Specific PR
/resolve-comments --code-rabbit       # Triage CodeRabbit issues from .tmp/
/resolve-comments --local             # Triage AI reviewer issues from .tmp/
/resolve-comments --code-rabbit --local  # Triage both (used by /review)
/resolve-comments --auto              # Auto-apply all recommended fixes
/resolve-comments --dry-run           # Analysis only, no changes
```

**Note:** The `--local` and `--from-file <path>` flags are mutually exclusive. Do not use them together.

## Description

Resolves review comments from multiple sources with interactive triage.

**Modes:**

- **PR mode** (default): Fetch unresolved CodeRabbit comments from GitHub PR
- **File mode** (`--code-rabbit` and/or `--local`): Triage issues from `/review` output files

## Mode: PR (Default)

When no `--code-rabbit` or `--local` flags are provided.

### Execution

```text
STEP 1: Determine PR number
  IF: pr-number argument provided
    USE: provided number
  ELSE:
    RUN: gh pr view --json number -q '.number'
    IF: fails
      OUTPUT: "No PR found for current branch. Create one with: gh pr create"
      END

STEP 2: Fetch unresolved CodeRabbit comments (with pagination)
  INITIALIZE: all_issues = [], threads_cursor = null, has_more_threads = true

  WHILE: has_more_threads
    RUN: gh api graphql -f query='
      query($owner: String!, $repo: String!, $pr: Int!, $after: String) {
        repository(owner: $owner, name: $repo) {
          pullRequest(number: $pr) {
            reviewThreads(first: 100, after: $after) {
              pageInfo { endCursor hasNextPage }
              nodes {
                isResolved
                comments(first: 100) {
                  pageInfo { endCursor hasNextPage }
                  nodes {
                    id
                    path
                    line
                    body
                    author { login }
                  }
                }
              }
            }
          }
        }
      }' -F owner={owner} -F repo={repo} -F pr={pr} -F after={threads_cursor}

    FOR_EACH: thread in reviewThreads.nodes
      IF: thread has >100 comments (thread.comments.pageInfo.hasNextPage)
        PAGINATE: fetch remaining comments for this thread using comments cursor
      APPEND: all comments to thread.comments.nodes

    FILTER: isResolved == false AND author.login contains "coderabbit"
    APPEND: filtered issues to all_issues
    SET: threads_cursor = reviewThreads.pageInfo.endCursor
    SET: has_more_threads = reviewThreads.pageInfo.hasNextPage

  STORE: all_issues in memory
  OUTPUT: "Fetched {count} unresolved CodeRabbit comments from PR #{pr}"

STEP 3: Present triage table
  (See Common Triage Flow below)

STEP 4: Apply fixes
  (See Common Triage Flow below)

STEP 5: Finalize
  IF: skipped_issues not empty
    WRITE: .tmp/coderabbit-ignored.json
    OUTPUT: "Saved {count} skipped issues for /ship-it acknowledgment"

  IF: fixes applied
    ASK_USER:
      question: "Commit, push, and post resolution to PR #{pr}? ({fix_count} fixes on {current_branch})"
      options:
        - "Yes - commit, push, and post @coderabbitai resolve"
        - "No - stop after local changes only"
    WAIT: for user response

    IF: user selected "Yes"
      RUN: git add -A && git commit -m "fix: resolve CodeRabbit feedback ({fix_count} issues)"
      RUN: git push

      GENERATE: summary of changes
        DATA_SOURCE: fixed_issues list from triage (issues marked for fix with applied changes)
        CATEGORIZATION:
          - Map issue.type to categories: security→Security, error→Error Handling, performance→Performance,
            docs→Documentation, test→Testing, quality/other→Code Quality
          - Issues without type or unknown type: group under "Code Quality"
          - If issue spans multiple categories: use primary category based on severity
        FORMAT: markdown with:
          - Heading: "## Addressed CodeRabbit Feedback"
          - Total count: "**Resolved {fix_count} review comments**"
          - Category breakdown (omit categories with zero issues)
          - File-by-file changes with brief descriptions (max 100 chars per description)
        EDGE_CASES:
          - Empty categories: omit from output
          - Issues without file association: group under "General" section
          - Duplicate file paths: consolidate actions into single bullet
          - Summary exceeds 2000 chars: truncate file details, keep category counts
        VALIDATION:
          - Verify summary is non-empty
          - Verify markdown is well-formed
          - IF generation fails (empty fixed_issues, markdown validation error, or file write error):
            use fallback "@coderabbitai resolve" without summary
        WRITE: summary to .tmp/pr-comment.md

      RUN: gh pr comment {pr} --body-file .tmp/pr-comment.md
      OUTPUT: "Posted @coderabbitai resolve with change summary to PR #{pr}"
    ELSE:
      OUTPUT: "Skipped commit/push/comment. Local changes preserved."

  OUTPUT: "Resolved {fix_count} of {total} comments"
  END
```

## Mode: File (--code-rabbit and/or --local)

When `--code-rabbit` and/or `--local` flags are provided.

### Execution

```text
STEP 1: Load issues from files
  issues = []

  IF: --code-rabbit flag
    READ: .tmp/review-coderabbit.json
    IF: file not found
      OUTPUT: "No CodeRabbit issues file. Run /review first."
      END
    APPEND: issues from file with source="coderabbit"
    OUTPUT: "Loaded {count} CodeRabbit issues"

  IF: --local flag
    READ: .tmp/review-local.json
    IF: file not found
      OUTPUT: "No AI reviewer issues file. Run /review first."
      END
    APPEND: issues from file with source="code-reviewer"
    OUTPUT: "Loaded {count} AI reviewer issues"

  IF: issues empty
    OUTPUT: "No issues to triage"
    END

STEP 2: Present triage table
  (See Common Triage Flow below)

STEP 3: Apply fixes
  (See Common Triage Flow below)

STEP 4: Finalize
  IF: fixes applied
    RUN: git add -A && git commit -m "fix: resolve review feedback ({fix_count} issues)"
    OUTPUT: "Committed {fix_count} fixes"

  IF: skipped_issues not empty
    WRITE: .tmp/coderabbit-ignored.json
    OUTPUT: "Saved {count} skipped issues (will be posted to PR via /ship-it)"

  OUTPUT: "Fixed {fix_count} issues, skipped {skip_count}"
  END
```

## Common Triage Flow

Used by both PR mode and File mode.

### Evaluate Issues

```text
FOR_EACH: issue in issues
  ANALYZE: severity, type, fix complexity
  ASSIGN: recommendation = "Fix" if severity >= MEDIUM or security/accessibility issue
  ASSIGN: recommendation = "Skip" if severity == LOW and type == "nitpick"
```

### Present Triage Table

```text
DISPLAY:
  Review Issues:

  | # | Source | Severity | Location | Issue | Rec |
  |---|--------|----------|----------|-------|-----|
  | 1 | coderabbit | HIGH | auth.ts:45 | Missing error handling | Fix |
  | 2 | code-reviewer | MEDIUM | api.ts:12 | Input validation needed | Fix |
  | 3 | coderabbit | LOW | utils.ts:8 | Use const vs let | Skip |

  Summary: {fix_count} recommended fixes, {skip_count} recommended skips

IF: --dry-run flag
  OUTPUT: "Dry run complete. No changes made."
  END

IF: --auto flag
  PROCEED: with all recommended fixes
ELSE:
  ASK_USER:
    question: "How would you like to proceed?"
    options:
      - "Approve all recommended ({fix_count} fixes)"
      - "Select specific issues"
      - "View detailed analysis"
      - "Skip all"
  WAIT: for user response
```

### Apply Fixes

```text
FOR_EACH: approved issue
  IF: issue.suggestion or issue.recommendation exists
    APPLY: fix using provided guidance
  ELSE:
    DELEGATE: to appropriate agent based on issue.type
  OUTPUT: "Fixed: {issue.description}"

FOR_EACH: skipped issue
  ASK_USER:
    question: "Reason for skipping '{issue.description}'?"
    options:
      - "nitpick" - Style preference, not worth changing
      - "false-positive" - Incorrectly identified as issue
      - "intentional" - Code is correct as-is by design
      - "out-of-scope" - Valid but not part of this PR
      - "will-fix-later" - Acknowledged, will address separately
  WAIT: for user response
  STORE: issue with category in skipped_issues
```

## Ignored Issues Schema

Output format (`.tmp/coderabbit-ignored.json`):

```json
{
  "schema_version": "1.0",
  "branch": "feature/my-feature",
  "created_at": "2025-01-10T12:00:00Z",
  "ignored_issues": [
    {
      "id": 1,
      "source": "coderabbit|code-reviewer",
      "location": "file.ts:45",
      "description": "Issue description",
      "severity": "LOW",
      "category": "nitpick|false-positive|intentional|out-of-scope|will-fix-later",
      "reason": "User explanation (optional)"
    }
  ]
}
```

## Expected Output

### PR Mode

```text
User: /resolve-comments

Fetched 3 unresolved CodeRabbit comments from PR #42

Review Issues:

| # | Source | Severity | Location | Issue | Rec |
|---|--------|----------|----------|-------|-----|
| 1 | coderabbit | HIGH | auth.ts:45 | Missing error handling | Fix |
| 2 | coderabbit | MEDIUM | api.ts:12 | Add input validation | Fix |
| 3 | coderabbit | LOW | utils.ts:8 | Use const vs let | Skip |

Summary: 2 recommended fixes, 1 recommended skip

[User selects "Approve all recommended"]

Fixed: Missing error handling
Fixed: Add input validation

[User categorizes skip as "nitpick"]

Committed: fix: resolve CodeRabbit feedback (2 issues)
Pushed to origin
Posted @coderabbitai resolve with change summary to PR #42
Saved 1 skipped issue for /ship-it acknowledgment

Resolved 2 of 3 comments
```

### File Mode

```text
User: /resolve-comments --code-rabbit --local

Loaded 3 CodeRabbit issues
Loaded 2 AI reviewer issues

Review Issues:

| # | Source | Severity | Location | Issue | Rec |
|---|--------|----------|----------|-------|-----|
| 1 | coderabbit | HIGH | auth.ts:45 | Missing error handling | Fix |
| 2 | coderabbit | MEDIUM | api.ts:12 | Add input validation | Fix |
| 3 | code-reviewer | HIGH | db.ts:78 | SQL injection risk | Fix |
| 4 | code-reviewer | MEDIUM | perf.ts:23 | N+1 query detected | Fix |
| 5 | coderabbit | LOW | utils.ts:8 | Use const vs let | Skip |

Summary: 4 recommended fixes, 1 recommended skip

[Interactive triage continues...]
```

## Notes

- **CRITICAL**: Present triage options to user and WAIT for response. Never auto-apply without consent (unless --auto flag).
- PR mode posts `@coderabbitai resolve` to acknowledge resolution
- File mode commits but does not push or post to PR (no PR exists yet)
- Skipped issues always saved to `.tmp/coderabbit-ignored.json` for `/ship-it`
- `--auto` skips user interaction and applies all recommended fixes
- `--dry-run` shows analysis without making any changes
