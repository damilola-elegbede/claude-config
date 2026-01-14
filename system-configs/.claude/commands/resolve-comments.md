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
  # Variables are extracted from gh CLI context (validated by GitHub)
  RUN: gh repo view --json owner,name -q '.owner.login + "/" + .name'
  PARSE: owner and repo from output (validated format: ^[a-zA-Z0-9._-]+$)
  VALIDATE: pr matches ^[0-9]+$

  INITIALIZE: all_issues = [], threads_cursor = null, has_more_threads = true
  INITIALIZE: threads_needing_pagination = []

  # Phase 1: Fetch all threads
  WHILE: has_more_threads
    RUN: gh api graphql -f query='
      query($owner: String!, $repo: String!, $pr: Int!, $after: String) {
        repository(owner: $owner, name: $repo) {
          pullRequest(number: $pr) {
            reviewThreads(first: 100, after: $after) {
              pageInfo { endCursor hasNextPage }
              nodes {
                id
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
        APPEND: thread.id to threads_needing_pagination
      APPEND: thread to all_threads

    SET: threads_cursor = reviewThreads.pageInfo.endCursor
    SET: has_more_threads = reviewThreads.pageInfo.hasNextPage

  # Phase 2: Batch fetch remaining comments for threads with >100 (parallel)
  IF: threads_needing_pagination not empty
    FOR_EACH: thread_id in threads_needing_pagination (parallel batch)
      PAGINATE: fetch remaining comments using thread-specific cursor
      MERGE: into corresponding thread.comments

  FILTER: isResolved == false AND author.login contains "coderabbit"
  APPEND: filtered issues to all_issues
  STORE: all_issues in memory
  OUTPUT: "Fetched {count} unresolved CodeRabbit comments from PR #{pr}"

STEP 3: Present triage table
  (See Common Triage Flow below)

STEP 4: Apply fixes
  (See Common Triage Flow below)

STEP 5: Finalize
  IF: skipped_issues not empty
    WRITE: .tmp/review-tickets.json (merge with existing tickets map)
    OUTPUT: "Saved {count} skipped issues for /pr acknowledgment"

  IF: fixes applied
    ASK_USER:
      question: "Commit, push, and post resolution to PR #{pr}? ({fix_count} fixes on {current_branch})"
      options:
        - "Yes - commit, push, and post @coderabbitai resolve"
        - "No - stop after local changes only"
    WAIT: for user response

    IF: user selected "Yes"
      VALIDATE: fix_count > 0 (skip commit if no actual fixes)
      RUN: git add -A
      RUN: git commit -m "fix: resolve CodeRabbit feedback ({fix_count} issues)"
      IF: commit fails
        OUTPUT: "⚠️ Commit failed - changes staged but not committed"
        END
      RUN: git push
      IF: push fails
        OUTPUT: "⚠️ Push failed - commit created locally but not pushed"
        END
      RUN: gh pr comment {pr} --body "@coderabbitai resolve"
      IF: comment fails
        OUTPUT: "⚠️ Failed to post comment (changes pushed successfully)"
      ELSE:
        OUTPUT: "Posted @coderabbitai resolve to PR #{pr}"
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
    VALIDATE: fix_count > 0 (skip commit if no actual fixes)
    RUN: git add -A
    RUN: git commit -m "fix: resolve review feedback ({fix_count} issues)"
    IF: commit fails
      OUTPUT: "⚠️ Commit failed - changes staged but not committed"
    ELSE:
      OUTPUT: "Committed {fix_count} fixes"

  IF: skipped_issues not empty
    WRITE: .tmp/review-tickets.json (merge with existing tickets map)
    OUTPUT: "Saved {count} skipped issues (will be posted to PR via /pr)"

  OUTPUT: "Fixed {fix_count} issues, skipped {skip_count}"
  END
```

## Common Triage Flow

Used by both PR mode and File mode.

### Sync Ticket Cache with GitHub

```text
STEP 0: Sync ticket cache (runs before triage)
  READ: .tmp/review-tickets.json (if exists)
  IF: tickets map has entries where resolved == false
    SET: unresolved_tickets = tickets where resolved == false
    SET: unresolved_count = count of unresolved_tickets
    OUTPUT: "Checking {unresolved_count} cached tickets against GitHub..."

    # Batch fetch issue states using GraphQL nodes query (single API call)
    SET: issue_numbers = [ticket.gh_issue_number for ticket in unresolved_tickets]
    RUN: gh api graphql -f query='
      query($owner: String!, $repo: String!, $numbers: [Int!]!) {
        repository(owner: $owner, name: $repo) {
          issues: nodes(ids: $numbers) {
            ... on Issue { number state }
          }
        }
      }' -F owner={owner} -F repo={repo} -F numbers={issue_numbers}

    FOR_EACH: issue in response.issues
      IF: issue.state == "CLOSED"
        SET: tickets[matching_key].resolved = true
        SET: tickets[matching_key].resolved_at = current ISO timestamp
        OUTPUT: "  #{issue.number} now resolved"

    WRITE: updated .tmp/review-tickets.json
    SET: newly_resolved = count of tickets marked resolved this run
    IF: newly_resolved > 0
      OUTPUT: "Synced: {newly_resolved} ticket(s) marked as resolved"
```

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

  IF: category == "will-fix-later"
    # Check ticket cache for existing issue
    READ: .tmp/review-tickets.json (if exists)
    # Generate deterministic key using SHA-256 hash
    NORMALIZE: input = lowercase(source) + "|" + lowercase(location) + "|" + normalize_whitespace(description)
    HASH: issue_key = SHA256(input).substring(0, 16)  # First 16 hex chars
    SET: should_create_ticket = true

    IF: issue_key exists in tickets map AND tickets[issue_key].resolved == false
      OUTPUT: "Issue already filed: #{tickets[issue_key].gh_issue_number}"
      SET: issue.gh_issue_number = cached value
      SET: issue.gh_issue_url = cached value
      SET: should_create_ticket = false
    ELSE IF: issue_key exists in tickets map AND tickets[issue_key].resolved == true
      OUTPUT: "Previous issue #{tickets[issue_key].gh_issue_number} was resolved - creating new ticket"

    IF: should_create_ticket
      ASK_USER:
        question: "Add context for the GitHub issue? (optional)"
      WAIT: for user response (allow empty)

      # Sanitize issue fields before creating GitHub issue
      SANITIZE: title = truncate(strip_markdown(issue.description), 60)
      SANITIZE: body = escape_markdown_injection(formatted_issue_body)

      RUN: gh issue create \
           --title "Review feedback: {sanitized_title}" \
           --body "{sanitized_body}" \
           --label "tech-debt,review-feedback"
      IF: gh command fails
        OUTPUT: "⚠️ Failed to create GitHub issue - continuing without tracking"
        SET: should_create_ticket = false
      ELSE:
        PARSE: issue number and URL from output

        STORE: in .tmp/review-tickets.json tickets map:
          tickets[issue_key] = {
            gh_issue_number, gh_issue_url, source, location,
            description, severity, created_at, branch,
            resolved: false, resolved_at: null
          }
        OUTPUT: "Filed GitHub issue #{number}: {url}"

        SET: issue.gh_issue_number = created number
        SET: issue.gh_issue_url = created url

  STORE: issue with category in skipped_issues
```

### GitHub Issue Body Format

```markdown
## Review Feedback: {issue.description}

**Source**: {source}
**Severity**: {severity}
**Location**: `{location}`

### Details
{issue.description}

{issue.suggestion if available}

### Context
- Branch: `{branch}`
- Deferred during review triage

---
*Auto-created by /resolve-comments*
```

## Review Tickets Schema

Output format (`.tmp/review-tickets.json`):

```json
{
  "schema_version": "1.0",
  "tickets": {
    "{issue_key_hash}": {
      "gh_issue_number": 123,
      "gh_issue_url": "https://github.com/owner/repo/issues/123",
      "source": "coderabbit",
      "location": "file.ts:45",
      "description": "Issue description",
      "severity": "MEDIUM",
      "created_at": "2025-01-13T10:00:00Z",
      "branch": "feature/my-feature",
      "resolved": false,
      "resolved_at": null
    }
  },
  "skipped_issues": [
    {
      "id": 1,
      "source": "coderabbit|code-reviewer",
      "location": "file.ts:45",
      "description": "Issue description",
      "severity": "LOW",
      "category": "nitpick|false-positive|intentional|out-of-scope|will-fix-later",
      "reason": "User explanation (optional)",
      "gh_issue_number": 123,
      "gh_issue_url": "https://github.com/owner/repo/issues/123"
    }
  ]
}
```

**Key design**:

- `tickets` map: Keyed by hash of (source + location + description), persists across triage runs to prevent duplicate issue creation
- `skipped_issues` array: Current PR's skipped items for acknowledgment, cleared after PR creation
- `resolved` field: Tracks whether GitHub issue has been closed; if resolved, a new ticket will be created if the same issue reappears

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
Posted @coderabbitai resolve to PR #42
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
- Skipped issues saved to `.tmp/review-tickets.json` for `/pr` acknowledgment
- "will-fix-later" items automatically file a GitHub issue with `tech-debt,review-feedback` labels
- Ticket cache prevents duplicate issue creation when running triage multiple times
- Cache syncs with GitHub at start of triage: closed issues are marked `resolved: true`
- Resolved tickets allow new issue creation if the same problem reappears
- `--auto` skips user interaction and applies all recommended fixes
- `--dry-run` shows analysis without making any changes
