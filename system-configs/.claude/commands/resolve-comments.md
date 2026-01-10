---
description: Resolve review comments from any source
argument-hint: "[pr-number] [--local|--from-file <path>|--auto|--dry-run]"
---

# /resolve-comments Command

## Usage

```bash
/resolve-comments                      # Interactive - fetch from PR (default)
/resolve-comments <pr-number>          # Specific PR
/resolve-comments --local              # Run CodeRabbit CLI on local changes
/resolve-comments --from-file <path>   # Triage issues from unified review file
/resolve-comments --auto               # Auto-fix all recommended
/resolve-comments --dry-run            # Analysis only
```

## Description

Handles review feedback from multiple sources:

- **PR mode** (default): Fetches UNRESOLVED comments from existing GitHub PR via GraphQL
- **Local mode** (`--local`): Runs CodeRabbit CLI on local changes
- **From-file mode** (`--from-file`): Triages pre-collected issues from `/review`

All modes use the same interactive triage flow.

## Execution Script

### Mode: PR (default)

```text
STEP 1: Fetch UNRESOLVED PR comments via GraphQL
  RUN: gh api graphql -f query='
    query($owner: String!, $repo: String!, $pr: Int!) {
      repository(owner: $owner, name: $repo) {
        pullRequest(number: $pr) {
          reviewThreads(first: 100) {
            nodes {
              isResolved
              comments(first: 10) {
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
    }' -f owner={owner} -f repo={repo} -F pr={pr}
  PARSE: filter for isResolved == false
  PARSE: filter for CodeRabbit-authored comments (author.login contains "coderabbit")
  STORE: issues in memory
  OUTPUT: "🔍 Fetching unresolved comments on PR #{pr}...\n📊 Found {count} unresolved threads"

STEP 2: Evaluate issues
  FOR_EACH: issue in issues
    ANALYZE: against project standards
    ASSIGN: recommendation (fix|skip) based on severity and type
  OUTPUT: "Evaluating against project standards..."

STEP 3: Present triage table
  DISPLAY:
    📊 Review Comments:

    | ID | Source | Issue | Severity | Location | Rec |
    |----|--------|-------|----------|----------|-----|
    | {foreach issue} |

    Summary: {fix_count} recommended fixes, {skip_count} skips

  ASK_USER:
    question: "How would you like to proceed?"
    options:
      - "Approve all recommended ({fix_count} issues)"
      - "Select specific issues"
      - "View detailed analysis"
      - "Skip all"
  WAIT: for user response

STEP 4: Apply fixes
  IF: user selected "Approve all" or specific issues
    FOR_EACH: approved issue
      IF: issue.ai_prompt exists
        APPLY: fix using ai_prompt as guidance
      ELSE:
        DELEGATE: to appropriate agent based on issue.type
      OUTPUT: "✅ Fixed: {issue.description}"

  FOR_EACH: skipped issue
    ASK_USER:
      question: "Reason for skipping '{issue.description}'?"
      options:
        - "nitpick"
        - "false-positive"
        - "intentional"
        - "out-of-scope"
        - "will-fix-later"
    WAIT: for user response
    STORE: in skipped_issues with reason

STEP 5: Save and notify
  IF: skipped_issues not empty
    WRITE: .tmp/coderabbit-ignored.json with schema:
      {
        "schema_version": "1.0",
        "branch": "{current_branch}",
        "created_at": "{timestamp}",
        "ignored_issues": [{skipped_issues with reasons}]
      }
    OUTPUT: "📄 Saved {count} skipped issues to .tmp/coderabbit-ignored.json"

  IF: fixes applied
    RUN: git add -A && git commit -m "fix: resolve review comments ({fix_count} issues)"
    RUN: git push
    RUN: gh pr comment {pr} --body "@coderabbitai resolve"
    OUTPUT: "📢 Posted resolution to PR #{pr}"

  OUTPUT: "🎉 Resolved {fix_count} of {total} issues"
  END
```

### Mode: --local

```text
STEP 1: Run CodeRabbit CLI
  IF: which coderabbit fails
    OUTPUT: "❌ CodeRabbit CLI not installed. Run: curl -fsSL https://cli.coderabbit.ai/install.sh | sh"
    END

  RUN: coderabbit review --prompt-only --type all --config .coderabbit.yaml --base main
  PARSE: output to unified issue format, source="coderabbit"
  STORE: issues in memory
  OUTPUT: "🔍 Running CodeRabbit local analysis...\n📊 Found {count} issues"

STEP 2-4: (Same as PR mode - Evaluate, Present, Apply)

STEP 5: Save skipped issues (no PR posting)
  IF: skipped_issues not empty
    WRITE: .tmp/coderabbit-ignored.json
    OUTPUT: "📄 Saved skipped issues (will be posted when PR created via /ship-it)"

  IF: fixes applied
    RUN: git add -A && git commit -m "fix: resolve CodeRabbit feedback ({fix_count} issues)"
    OUTPUT: "📦 Committed fixes"

  OUTPUT: "🎉 Fixed {fix_count} issues, documented {skip_count} for PR acknowledgment"
  END
```

### Mode: --from-file <path>

```text
STEP 1: Load issues from file
  READ: {path}
  VALIDATE: schema_version, branch matches current
  STORE: issues in memory
  OUTPUT: "🔍 Loading issues from {path}...\n📊 Found {count} issues from {unique_sources}"

STEP 2-4: (Same as PR mode - Evaluate, Present, Apply)

STEP 5: Save skipped issues
  IF: skipped_issues not empty
    WRITE: .tmp/coderabbit-ignored.json
    OUTPUT: "📄 Saved skipped issues"

  OUTPUT: "🎉 Fixed {fix_count} issues, skipped {skip_count}"
  RETURN: { fix_count, skip_count } to caller
  END
```

## Expected Output

```text
🔍 Fetching unresolved comments on PR #123...
📊 Found 3 unresolved threads

Evaluating against project standards...

📊 Review Comments:

| ID | Source | Issue | Severity | Location | Rec |
|----|--------|-------|----------|----------|-----|
| 1 | coderabbit | Missing error handling | HIGH | auth.ts:45 | Fix |
| 2 | coderabbit | Add input validation | MEDIUM | api.ts:12 | Fix |
| 3 | coderabbit | Use const vs let | LOW | utils.ts:8 | Skip |

Summary: 2 recommended fixes, 1 skip

[User selects option via AskUserQuestion]

✅ Fixed: Missing error handling
✅ Fixed: Add input validation

📄 Saved 1 skipped issue to .tmp/coderabbit-ignored.json
📦 Committed: fix: resolve review comments (2 issues)
📢 Posted resolution to PR #123

🎉 Resolved 2 of 3 issues
```

## Unified Issue Schema

Input format for `--from-file` mode (`.tmp/review-issues.json`):

```json
{
  "schema_version": "1.0",
  "branch": "feature/my-feature",
  "created_at": "2025-01-10T12:00:00Z",
  "issues": [
    {
      "id": 1,
      "source": "coderabbit|code-reviewer|eslint|markdownlint|ruff",
      "file": "path/to/file.ts",
      "line": 45,
      "type": "nitpick|potential_issue|error|security|contract_violation",
      "severity": "LOW|MEDIUM|HIGH|CRITICAL",
      "description": "Issue description",
      "ai_prompt": "Fix instructions (optional)",
      "rule": "Linter rule ID (optional)"
    }
  ]
}
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
      "source": "coderabbit",
      "location": "file.ts:45",
      "description": "Issue description",
      "severity": "LOW",
      "category": "nitpick|false-positive|intentional|out-of-scope|will-fix-later",
      "reason": "User explanation (optional)"
    }
  ]
}
```

## Notes

- **CRITICAL**: Use `AskUserQuestion` tool for triage. WAIT for response. Never auto-apply without consent.
- All modes use identical triage flow (Steps 2-4)
- `--from-file` mode returns `{fix_count, skip_count}` for caller integration
- Skipped issues are always saved to `.tmp/coderabbit-ignored.json`
- PR mode uses GraphQL to fetch only UNRESOLVED threads (REST API lacks this field)
- Local mode requires `coderabbit` CLI installed and authenticated
