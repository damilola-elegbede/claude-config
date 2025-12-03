---
description: Resolve ALL unresolved CodeRabbit comments (always fetches fresh)
argument-hint: [<pr-number>] [--auto|--dry-run]
thinking-level: megathink
thinking-tokens: 10000
execution-mode: always-fresh
---

# /resolve-cr Command

## Usage

```bash
/resolve-cr                   # Interactive mode with approval (default)
/resolve-cr <pr-number>       # Specific PR, interactive
/resolve-cr --auto            # Skip approval, auto-fix all recommended items
/resolve-cr --dry-run         # Analysis only, no changes
```

## Description

Intelligently resolves CodeRabbit review feedback by fetching all unresolved comments from multiple GitHub API sources,
analyzing each suggestion against project standards, and deploying specialized agents to implement approved fixes.

**Core Principles:**

- **Always Fetch Fresh** - Never use cached data, each execution is independent
- **Comprehensive Discovery** - Query 4 different GitHub API sources and merge results
- **Complete Analysis** - Pass ALL comments to agent for thorough evaluation
- **Idempotent Execution** - Can be called repeatedly without conflicts
- **Parallel Resolution** - Multiple agents work simultaneously on approved fixes

### Thinking Level: MEGATHINK (10,000 tokens)

Required for processing multiple comment sources, coordinating code-reviewer analysis, generating evaluation table,
and orchestrating parallel agent deployment.

## Expected Output

### Successful Resolution

```text
🔍 Analyzing CodeRabbit feedback on PR #228...
📊 Found 7 unresolved comments

Evaluating recommendations against project standards...

📊 CodeRabbit Feedback Evaluation (PR #228)

┌────┬─────────────────────────────────────────┬──────────┬────────────────┬────────────────┬──────────────┐
│ ID │ Issue                                   │ Severity │ Recommendation │ Assigned Agent │ Location     │
├────┼─────────────────────────────────────────┼──────────┼────────────────┼────────────────┼──────────────┤
│ 1  │ Missing error handling in auth()        │ High     │ Yes ✓          │ code-reviewer  │ auth.ts:45   │
│ 2  │ Add docstring for getUserData()         │ Medium   │ Yes ✓          │ tech-writer    │ api.ts:128   │
│ 3  │ Use const instead of let                │ Low      │ No ✗           │ N/A            │ utils.ts:12  │
│ 4  │ Extract magic number to constant        │ Medium   │ Yes ✓          │ code-reviewer  │ calc.ts:67   │
│ 5  │ Add integration test for payment flow   │ High     │ Yes ✓          │ test-engineer  │ payment.ts:1 │
│ 6  │ Consider using async/await pattern      │ Info     │ Maybe ?        │ manual         │ db.ts:203    │
│ 7  │ Remove console.log debug statement      │ Low      │ Yes ✓          │ code-reviewer  │ debug.ts:89  │
└────┴─────────────────────────────────────────┴──────────┴────────────────┴────────────────┴──────────────┘

Summary:
  ✅ Recommended: 5 issues (2 High, 2 Medium, 1 Low)
  ❌ Skip: 1 issue (conflicts with style guide)
  ❓ Manual review: 1 issue (architecture decision)

Options:
  [a] Approve all recommended fixes (5 issues)
  [s] Select specific issues to fix
  [v] View detailed analysis
  [n] Skip all fixes

Your choice: a

✅ Approved 5 fixes

Applying approved fixes...
  ✅ Fixed error handling in auth.ts (1.2s)
  ✅ Added getUserData docstring (0.8s)
  ✅ Extracted MAX_RETRIES constant (0.5s)
  ✅ Removed debug log statement (0.3s)
  ✅ Added payment integration test (2.1s)

🧪 All tests passing
📦 Committed: fix: resolve CodeRabbit feedback (5 issues)
⬆️  Pushed to remote
📢 Posted '@coderabbitai resolve' to PR #228
   CodeRabbit will re-scan and update comment resolution status

🎉 Successfully resolved 5 of 7 issues in 8.3 seconds
```

### No Comments Found

```text
🔍 Analyzing CodeRabbit feedback on PR #228...
ℹ️  No unresolved comments found

Possible reasons:
  • All comments resolved in previous runs
  • CodeRabbit hasn't reviewed this PR yet
  • PR may not have CodeRabbit integration enabled

Next steps:
  • Check PR reviews tab in GitHub UI
  • Trigger new review: Comment "@coderabbitai review" on PR
  • Verify CodeRabbit bot has repository access
```

### Dry-Run Mode

```text
🔍 Analyzing CodeRabbit feedback on PR #228...
📊 Found 7 unresolved comments

[Evaluation table displayed]

🔍 DRY-RUN MODE: Analysis complete, no changes applied
```

## Workflow

### Phase 1: Comment Discovery

Fetch all unresolved CodeRabbit comments from multiple GitHub API sources:

**Discovery Process:**

- Identify target PR (from argument or current branch)
- Query 3 different GitHub API endpoints:
  - **Inline Review Comments** (via REST API): Line-by-line code review feedback
  - **Review Submissions** (via gh pr view): Top-level review comments and approvals
  - **PR Discussion Comments** (via gh pr view): General PR feedback and discussions
- Merge results and deduplicate by comment ID
- Filter for CodeRabbit-authored content
- Note: GitHub API doesn't expose resolution status directly; comments are treated as active unless explicitly dismissed

**Implementation Reference:**

```bash
# Multi-source comment fetching
fetch_coderabbit_comments() {
  local pr="$1"
  local owner="$2"
  local repo="$3"

  # SOURCE 1: Inline review comments (via GitHub REST API)
  gh api "repos/${owner}/${repo}/pulls/${pr}/comments" --paginate --jq '
    .[] |
    select(.user.login == "coderabbitai" or .user.login == "coderabbitai[bot]") |
    {id, body, path, line, source: "review_comments"}
  '

  # SOURCE 2: Review submissions (top-level review comments)
  gh pr view "$pr" --json reviews --jq '
    .reviews[] |
    select(.author.login == "coderabbitai" or .author.login == "coderabbitai[bot]") |
    {id, body, source: "review_submission"}
  '

  # SOURCE 3: PR discussion comments
  gh pr view "$pr" --json comments --jq '
    .comments[] |
    select(.author.login == "coderabbitai" or .author.login == "coderabbitai[bot]") |
    {id, body, source: "issue_comments"}
  '

  # Merge and deduplicate by ID with --paginate for complete history
}
```

### Phase 2: Comprehensive Analysis

Deploy code-reviewer agent to evaluate all comments against project standards:

**Analysis Objectives:**

For each comment, evaluate:

- **Alignment**: Does it match our coding standards and conventions?
- **Value**: Does it add real value or is it pedantic preference?
- **Severity**: How important is this fix? (Critical/High/Medium/Low/Info)
- **Actionability**: Is this actionable feedback or informational observation?
- **Recommendation**: Should we address it? (Yes/No/Maybe)
- **Agent Assignment**: Which agent should fix this? (code-reviewer/tech-writer/test-engineer/manual)

**Agent Prompt Structure:**

```text
Analyze ALL {count} CodeRabbit comments below.

For EACH comment, evaluate:
1. Alignment with codebase conventions
2. Value vs. pedantry balance
3. Severity level (Critical to Info)
4. Actionability (can this be fixed automatically?)
5. Implementation recommendation
6. Agent assignment for fixes

Provide structured evaluation for each comment with reasoning.
```

### Phase 3: Interactive Evaluation (MANDATORY PAUSE)

Present analysis as interactive table:

- Show all comments with severity, recommendation, and assignment
- Display summary: recommended vs. skip vs. manual review
- Provide options: approve all, select specific, view details, skip

**MANDATORY**: Use the `AskUserQuestion` tool to present options and wait for user selection.
NEVER proceed to Phase 4 without explicit user approval. Do not assume approval.

**Auto Mode (`--auto`):**

- Skip approval step
- Automatically fix all "Yes ✓" recommendations
- Useful for trusted CodeRabbit feedback

**Dry-Run Mode (`--dry-run`):**

- Display evaluation table
- Exit without applying changes
- Useful for reviewing recommendations

### Phase 4: Parallel Fix Deployment

Deploy specialized agents in parallel to implement approved fixes:

**Deployment Strategy:**

Group approved fixes by agent type:

- **code-reviewer instances**: Code fixes, refactoring, logic changes
- **tech-writer instances**: Documentation, comments, docstrings
- **test-engineer instances**: Test additions, coverage improvements

**Execution:**

- All agents run simultaneously for maximum speed
- Each agent receives specific comment context and file location
- Each agent creates focused fix for assigned issue
- Verify no conflicts between agent changes

**Implementation Note:**

```yaml
Parallel Deployment Example:
  code-reviewer:
    - instance_1: Fix auth error handling (issue #1) - auth.ts:45
    - instance_2: Extract magic number (issue #4) - calc.ts:67
    - instance_3: Remove debug statement (issue #7) - debug.ts:89

  tech-writer:
    - instance_1: Add getUserData docstring (issue #2) - api.ts:128

  test-engineer:
    - instance_1: Add payment integration test (issue #5) - payment.ts:1
```

### Phase 5: Verification and Commit

Verify all fixes were applied successfully:

**Verification Process:**

- Confirm all approved fixes are reflected in git diff
- Run test suite to verify no regressions
- Ensure no conflicts between parallel agent changes

**Commit Strategy:**

Create consolidated commit with conventional message:

```text
fix: resolve CodeRabbit feedback (5 issues)

Resolved 5 of 7 unresolved comments:
- Fixed auth error handling (High)
- Added getUserData docstring (Medium)
- Extracted MAX_RETRIES constant (Medium)
- Removed debug log statement (Low)
- Added payment integration test (High)

Skipped: 1 issue (style preference)
Manual review: 1 issue (architecture decision)
```

**Push Changes:**

```bash
# Push changes to remote branch
git push origin "$(git branch --show-current)"

echo "✅ Changes pushed to remote"
```

**Post Resolution Comment (MANDATORY):**

After pushing changes, you MUST post a comment to trigger CodeRabbit's resolution update:

```bash
# Get PR number from current branch or command argument
PR_NUMBER="$pr"  # Use the PR number identified earlier in the workflow

# Post resolution comment to CodeRabbit
gh pr comment "$PR_NUMBER" --body "@coderabbitai resolve"

echo "✅ Posted '@coderabbitai resolve' to PR #$PR_NUMBER"
echo "   CodeRabbit will re-scan and update comment resolution status"
```

**Why This Step is Critical:**

- CodeRabbit needs to be explicitly notified to re-scan the PR
- Without this comment, resolved issues may still appear as unresolved
- This triggers CodeRabbit to update its review status automatically

## Behavior

### Multi-Source Comment Fetching

The command queries 3 different GitHub API endpoints to ensure comprehensive coverage:

**Source Priority:**

1. **Inline Review Comments** (via REST API): Line-by-line code review feedback with file/line context
2. **Review Submissions** (via gh pr view): Top-level review comments and approval status
3. **PR Discussion Comments** (via gh pr view): General PR feedback and discussions

**Resolution Status Tracking:**

- GitHub API does not expose comment resolution status directly
- All fetched comments are treated as active feedback to address
- Comments can be dismissed/resolved manually in GitHub UI if not applicable
- Agent evaluates each comment for relevance and actionability regardless of API status

**Pagination Support:**

- All API queries use `--paginate` flag
- Fetches complete comment history without 30-item limits
- Ensures no comments are missed

### Agent Orchestration

**Code-Reviewer Agent:**

- Receives ALL comments in single prompt (not split)
- Evaluates each against codebase standards
- Assigns severity and recommendation
- Determines which specialized agent should fix each issue

**Specialized Fix Agents:**

Deploy in parallel after approval:

- **code-reviewer**: Code changes, refactoring, formatting
- **tech-writer**: Documentation, comments, docstrings
- **test-engineer**: Test additions, coverage improvements
- **manual**: Complex changes requiring human judgment

### Idempotent Execution

Can be called repeatedly without conflicts:

- Each execution fetches fresh data from GitHub API
- No caching or state persistence between runs
- Second run will find fewer comments if first run resolved some
- Never shows "already processed" errors

### Error Handling

**No Comments Found (Wave 1):**

When no unresolved comments are discovered, provide diagnostic guidance instead of silent success.

```text
ℹ️  No unresolved comments found

Possible reasons:
  1. All comments already resolved
  2. CodeRabbit hasn't reviewed this PR yet
  3. PR may not have CodeRabbit integration enabled

Next steps:
  • Check PR reviews tab in GitHub UI
  • Trigger review: @coderabbitai review
  • Verify CodeRabbit bot access
```

**Incomplete Analysis:**

If agent fails to evaluate all comments:

- Validate analyzed count matches total count
- Re-deploy agent with explicit instruction to cover all comments
- Never proceed with partial analysis

**Test Failures:**

If test suite fails after fixes:

- Report failure immediately
- Do not commit or push changes
- Provide rollback guidance

## Success Criteria

Effective CodeRabbit feedback resolution:

- ✅ Fetches comments from 3 different GitHub API sources
- ✅ Finds ALL CodeRabbit comments, not just some
- ✅ Provides clear diagnostics when no comments found
- ✅ Each execution is independent with fresh data
- ✅ Single code-reviewer agent analyzes ALL comments
- ✅ Verification ensures 100% comment coverage
- ✅ Can be called repeatedly without conflicts
- ✅ Parallel agent deployment for approved fixes
- ✅ All changes tested and verified before commit
- ✅ Posts resolution comment to trigger CodeRabbit update

## Implementation Notes

**For Claude:**

- Use GitHub CLI (`gh`) for all API interactions
- Handle JSON parsing errors gracefully with retry logic
- Store intermediate state in `.tmp/resolve-cr-<timestamp>/` directory
- Execute phases sequentially with clear progress indicators
- **CRITICAL**: After pushing changes, you MUST post `@coderabbitai resolve` comment using `gh pr comment`
- **CRITICAL**: In default mode (no --auto or --dry-run), you MUST use `AskUserQuestion` tool after
  displaying the evaluation table. Present options and WAIT for user response before fix deployment.
- Hide tool orchestration details (Bash calls, retries, agent deployment)
- Show only user-facing progress and outcomes
- Never display execution IDs in normal operation
- Simplify diagnostic output to essential information only

**Execution Tracking:**

Generate unique execution ID for internal tracking:

```bash
# Internal tracking (not displayed to user)
execution_id="resolve-cr-$(date +%s)-$$"

# State stored in .tmp for debugging
mkdir -p ".tmp/resolve-cr-${execution_id}"
```

**Comment Deduplication:**

```bash
# Merge sources and remove duplicates by comment ID
jq -s 'flatten | unique_by(.id)' \
  <(echo "$source1") \
  <(echo "$source2") \
  <(echo "$source3") \
  <(echo "$source4")
```

## Related Commands

- `/fix-ci` - Similar multi-wave pattern for CI failures
- `/commit` - Commit changes after manual fixes
- `/push` - Push resolved changes to remote

## Notes

- Comprehensive discovery from 3 different API endpoints
- Always fetches fresh data (never cached)
- Fails explicitly with diagnostics when expectations not met
- Idempotent - can run multiple times safely
- Complete resolution - passes ALL comments to agent
- Verification ensures 100% comment coverage
- Fast execution through parallel agent deployment
- Safe defaults with interactive approval
- Pagination support for complete comment history
- Treats all fetched comments as actionable unless agent determines otherwise
- Clean, user-friendly output with no verbose implementation details
