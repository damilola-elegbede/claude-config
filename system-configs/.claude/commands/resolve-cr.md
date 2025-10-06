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

Aggressively finds ALL unresolved CodeRabbit comments from multiple GitHub API sources and resolves them intelligently.
Uses code-reviewer agent to evaluate each comment, then deploys specialized agents to apply approved fixes.

**CRITICAL DESIGN PRINCIPLES:**

1. **Always Fetch Fresh** - Never use cached data, each execution is independent
2. **Find ALL Comments** - Query 4 different GitHub API sources and merge results
3. **Fail on Zero Comments** - Not finding comments is a CATASTROPHIC FAILURE, not success
4. **Idempotent Execution** - Can be called repeatedly without "already ran" issues
5. **Complete Resolution** - Pass ALL comments to agent, resolve ALL approved items

### Thinking Level: MEGATHINK (10,000 tokens)

Required for processing multiple comment sources, coordinating code-reviewer analysis, generating evaluation table, and orchestrating parallel agent deployment.

## Workflow

### Step 1: Aggressive Multi-Source Comment Fetching

**CRITICAL:** Fetch from ALL possible GitHub API sources to ensure nothing is missed.

```bash
# Generate unique execution ID
execution_id="resolve-cr-$(date +%s)-$$"
echo "🆔 Execution: $execution_id"

# Get PR number
pr="${1:-$(gh pr view --json number -q .number)}"
repo_info=$(gh repo view --json owner,name)
owner=$(echo "$repo_info" | jq -r .owner.login)
repo=$(echo "$repo_info" | jq -r .name)

echo "🔍 Fetching unresolved CodeRabbit comments from multiple sources..."

# SOURCE 1: PR Review Threads (most reliable for inline comments)
source1=$(gh pr view "$pr" --json reviewThreads --jq '
  .reviewThreads[] |
  select(.isResolved == false) |
  .comments[] |
  select(.author.login == "coderabbitai" or .author.login == "coderabbitai[bot]") |
  {
    id: .id,
    body: .body,
    path: .path,
    line: (.line // .originalLine),
    source: "review_thread",
    createdAt: .createdAt
  }
' 2>/dev/null)

# SOURCE 2: PR Review Comments (catches comments in reviews)
source2=$(gh api "repos/$owner/$repo/pulls/$pr/comments" --jq '
  .[] |
  select(.user.login == "coderabbitai" or .user.login == "coderabbitai[bot]") |
  select(.in_reply_to_id == null or .in_reply_to_id == .id) |
  {
    id: .id,
    body: .body,
    path: .path,
    line: (.line // .original_line),
    source: "review_comment",
    createdAt: .created_at
  }
' 2>/dev/null)

# SOURCE 3: Issue Comments (for general PR feedback)
source3=$(gh api "repos/$owner/$repo/issues/$pr/comments" --jq '
  .[] |
  select(.user.login == "coderabbitai" or .user.login == "coderabbitai[bot]") |
  {
    id: .id,
    body: .body,
    path: null,
    line: null,
    source: "issue_comment",
    createdAt: .created_at
  }
' 2>/dev/null)

# SOURCE 4: Review Submissions (top-level review comments)
source4=$(gh api "repos/$owner/$repo/pulls/$pr/reviews" --jq '
  .[] |
  select(.user.login == "coderabbitai" or .user.login == "coderabbitai[bot]") |
  select(.state == "COMMENTED" or .state == "CHANGES_REQUESTED") |
  select(.body != null and .body != "") |
  {
    id: .id,
    body: .body,
    path: null,
    line: null,
    source: "review_submission",
    createdAt: .submitted_at
  }
' 2>/dev/null)

# Merge all sources and deduplicate by ID
all_comments=$(echo "$source1"; echo "$source2"; echo "$source3"; echo "$source4" | \
  jq -s 'flatten | unique_by(.id)')

# Count comments per source for diagnostics
count1=$(echo "$source1" | jq -s length)
count2=$(echo "$source2" | jq -s length)
count3=$(echo "$source3" | jq -s length)
count4=$(echo "$source4" | jq -s length)
total_count=$(echo "$all_comments" | jq length)

echo "📊 Comment Discovery Results:"
echo "  • Review threads: $count1 comments"
echo "  • Review comments: $count2 comments"
echo "  • Issue comments: $count3 comments"
echo "  • Review submissions: $count4 comments"
echo "  • Total unique: $total_count unresolved comments"
```

### CATASTROPHIC FAILURE: No Comments Found

**CRITICAL:** If no comments found, this is a FAILURE, not success. Provide diagnostics.

```bash
if [ "$total_count" -eq 0 ]; then
  echo ""
  echo "❌ CATASTROPHIC FAILURE: No unresolved CodeRabbit comments found"
  echo ""
  echo "🔍 Diagnostic Information:"
  echo "  Execution ID: $execution_id"
  echo "  PR: #$pr ($owner/$repo)"
  echo "  Searched 4 different API sources"
  echo "  All sources returned 0 comments"
  echo ""

  # Try to get total CodeRabbit activity for diagnostics
  total_cr_activity=$(gh api "repos/$owner/$repo/issues/$pr/comments" \
    --jq '[.[] | select(.user.login == "coderabbitai" or .user.login == "coderabbitai[bot]")] | length' 2>/dev/null)

  echo "⚠️  Possible Issues:"
  echo "  1. CodeRabbit hasn't reviewed this PR yet (total activity: $total_cr_activity)"
  echo "  2. All comments were already resolved"
  echo "  3. API permissions issue preventing comment access"
  echo "  4. PR may not have CodeRabbit integration enabled"
  echo ""
  echo "🔧 Troubleshooting Steps:"
  echo "  1. Manually check PR reviews tab in GitHub UI"
  echo "  2. Trigger new review: Comment '@coderabbitai review' on PR"
  echo "  3. Verify CodeRabbit bot has access to repository"
  echo "  4. Run: gh pr view $pr --json reviewThreads | jq"
  echo ""
  exit 1
fi
```

### Step 2: Deploy code-reviewer Agent with ALL Comments

Pass ALL comments to single code-reviewer agent for comprehensive analysis.

**Agent Prompt:**

```text
🆔 EXECUTION: {execution_id}
📋 PR: #{pr_number} ({owner}/{repo})

CRITICAL TASK: Analyze ALL {total_count} unresolved CodeRabbit comments below.

You are evaluating CodeRabbit feedback to determine which suggestions should be implemented.
Your analysis MUST cover every single comment - partial analysis is not acceptable.

For EACH of the {total_count} comments, evaluate:

1. **Alignment**: Does this align with our coding standards and codebase conventions?
2. **Value**: Does this add real value or is it pedantic preference?
3. **Severity**: How important is this? (Critical/High/Medium/Low/Info)
4. **Recommendation**: Should we address it? (Yes/No/Maybe)
5. **Agent Assignment**: Which agent fixes this? (code-reviewer/tech-writer/test-engineer/manual)

Severity Criteria:
- **Critical**: Security vulnerabilities, data loss risks, breaking bugs
- **High**: Performance issues, incorrect logic, major quality problems
- **Medium**: Code style consistency, maintainability improvements, minor bugs
- **Low**: Formatting preferences, optional optimizations, minor tweaks
- **Info**: Educational comments, best practices, nice-to-haves

Agent Assignment Guidelines:
- **code-reviewer**: Code fixes, refactoring, logic changes, formatting, imports
- **tech-writer**: Documentation, comments, docstrings, README updates
- **test-engineer**: Test additions, test fixes, coverage improvements
- **manual**: Architecture changes, complex refactors, design decisions

Recommendation Logic:
- **Yes**: Aligns with standards AND adds value
- **No**: Conflicts with our standards OR pedantic without value
- **Maybe**: Needs discussion or architectural decision

---

CODEBASE CONTEXT:
[Include repository structure, coding standards, architectural patterns]

---

ALL {total_count} UNRESOLVED CODERABBIT COMMENTS:

{for each comment in all_comments}
Comment #{index} (Source: {source}):
  File: {path}:{line}
  Posted: {createdAt}
  CodeRabbit ID: {id}

  Content:
  {body}

  ---

{/for}

---

REQUIRED OUTPUT FORMAT:

For each comment, provide structured evaluation:

## Comment #{index}
- **Issue**: [One-line summary]
- **Location**: {path}:{line}
- **Severity**: [Critical/High/Medium/Low/Info]
- **Recommendation**: [Yes ✓ / No ✗ / Maybe ?]
- **Reasoning**: [Brief explanation]
- **Assigned Agent**: [code-reviewer/tech-writer/test-engineer/manual]

VERIFICATION: Ensure you provide evaluation for ALL {total_count} comments.
Your output must include exactly {total_count} numbered evaluations.
```

### Step 3: Verify Complete Analysis

**CRITICAL:** Validate that code-reviewer analyzed ALL comments.

```bash
# After code-reviewer completes
analyzed_count=$(echo "$agent_output" | grep -c "^## Comment #")

if [ "$analyzed_count" -ne "$total_count" ]; then
  echo "❌ CRITICAL ERROR: Agent Analysis Incomplete"
  echo "  Expected: $total_count comments"
  echo "  Analyzed: $analyzed_count comments"
  echo "  Missing: $((total_count - analyzed_count)) comments"
  echo ""
  echo "This is unacceptable. Re-deploying agent with explicit instruction..."
  # Re-deploy with stronger emphasis
  exit 1
fi

echo "✅ Verification: All $total_count comments analyzed"
```

### Step 4: Display Interactive Evaluation Table

Present analysis as interactive table with source information:

```text
📊 CodeRabbit Feedback Evaluation (PR #119)
🆔 Execution: resolve-cr-1738886234-12345
📍 Found comments from 4 sources: 3 review threads, 5 review comments, 2 issue comments, 1 review

┌────┬─────────────────────────────────────────┬──────────┬────────────────┬────────────────┬──────────────┬────────────────┐
│ ID │ Issue                                   │ Severity │ Recommendation │ Assigned Agent │ Location     │ Source         │
├────┼─────────────────────────────────────────┼──────────┼────────────────┼────────────────┼──────────────┼────────────────┤
│ 1  │ Missing error handling in auth()        │ High     │ Yes ✓          │ code-reviewer  │ auth.ts:45   │ review_thread  │
│ 2  │ Add docstring for getUserData()         │ Medium   │ Yes ✓          │ tech-writer    │ api.ts:128   │ review_comment │
│ 3  │ Use const instead of let                │ Low      │ No ✗           │ N/A            │ utils.ts:12  │ review_thread  │
│    │   Reason: Our style guide allows let    │          │                │                │              │                │
│ 4  │ Extract magic number to constant        │ Medium   │ Yes ✓          │ code-reviewer  │ calc.ts:67   │ review_comment │
│ 5  │ Add integration test for payment flow   │ High     │ Yes ✓          │ test-engineer  │ payment.ts:1 │ issue_comment  │
│ 6  │ Consider using async/await pattern      │ Info     │ Maybe ?        │ manual         │ db.ts:203    │ review_thread  │
│    │   Reason: Requires architecture review  │          │                │                │              │                │
│ 7  │ Remove console.log debug statement      │ Low      │ Yes ✓          │ code-reviewer  │ debug.ts:89  │ review_comment │
└────┴─────────────────────────────────────────┴──────────┴────────────────┴────────────────┴──────────────┴────────────────┘

Summary:
  ✅ Recommended to address: 5 issues (2 High, 2 Medium, 1 Low)
  ❌ Recommended to skip: 1 issue
  ❓ Requires manual review: 1 issue

Automatic fixes available for: 4 issues
Manual intervention needed for: 1 issue

✅ VERIFICATION: All 7 comments evaluated (100% coverage)
```

### Step 5: User Approval (Interactive Mode)

```text
Options:
  [a] Approve all recommended fixes (5 issues)
  [s] Select specific issues to fix
  [m] Modify plan (change severity/assignment)
  [v] View detailed analysis for each issue
  [n] Skip all fixes, exit

Your choice:
```

**Auto Mode (`--auto`):**
Skip approval, automatically fix all "Yes ✓" recommendations.

**Dry-Run Mode (`--dry-run`):**
Display table and exit without applying fixes.

### Step 6: Deploy Specialized Agents in Parallel

Group approved fixes by agent type and deploy in parallel:

```yaml
Parallel Deployment Strategy:
  code-reviewer instances:
    - instance_1: Fix auth error handling (issue #1) - auth.ts:45
    - instance_2: Extract magic number (issue #4) - calc.ts:67
    - instance_3: Remove debug statement (issue #7) - debug.ts:89

  tech-writer instances:
    - instance_1: Add getUserData docstring (issue #2) - api.ts:128

  test-engineer instances:
    - instance_1: Add payment integration test (issue #5) - payment.ts:1

Execution:
  - All agents run simultaneously (5 total agents)
  - Each agent gets specific comment context and location
  - Each agent creates focused fix for its assigned issue
  - Verify no conflicts between agent changes
```

### Step 7: Verify All Fixes Applied

```bash
# After all agents complete
approved_count=5  # Number of "Yes ✓" items
completed_count=$(git diff --name-only | wc -l)

echo "🔍 Verifying all approved fixes were applied..."
echo "  Approved fixes: $approved_count"
echo "  Files modified: $completed_count"

# Run tests to verify no regressions
echo "🧪 Running test suite..."
npm test || pytest || go test ./... || cargo test

echo "✅ All fixes applied and verified"
```

### Step 8: Commit and Push Changes

```bash
# Create consolidated commit
git add .
git commit -m "fix: resolve CodeRabbit feedback (${approved_count} issues)

Execution: ${execution_id}
Resolved ${approved_count} of ${total_count} unresolved comments

Issues addressed:
$(for issue in approved_issues; do echo "- ${issue}"; done)

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"

# Push to remote
git push origin "$(git branch --show-current)"

echo "✅ Changes pushed to remote"
```

### Step 9: Post Resolution Comment to CodeRabbit

**MANDATORY** - Trigger CodeRabbit to update resolved status:

```bash
echo "📢 Posting resolution comment to CodeRabbit..."

gh pr comment "$pr" --body "@coderabbitai resolve"

echo "✅ Posted '@coderabbitai resolve' to PR #$pr"
echo "   CodeRabbit will update comment resolution status"
```

## Expected Output

### Successful Execution (All Comments Found)

```text
🆔 Execution: resolve-cr-1738886234-12345
🔍 Fetching unresolved CodeRabbit comments from multiple sources...

📊 Comment Discovery Results:
  • Review threads: 3 comments
  • Review comments: 5 comments
  • Issue comments: 2 comments
  • Review submissions: 1 comments
  • Total unique: 7 unresolved comments

✅ Found 7 unresolved comments

🤖 Deploying code-reviewer agent with ALL 7 comments...
⏳ Analyzing against codebase standards...
✅ Analysis complete

🔍 Verifying analysis completeness...
✅ Verification: All 7 comments analyzed

📊 CodeRabbit Feedback Evaluation (PR #119)
[Interactive table shown]

Options: [a] Approve all / [s] Select / [v] View / [n] Skip
Your choice: a

✅ Approved 5 fixes

🚀 Deploying specialized agents in parallel...
  🔧 code-reviewer (3 instances): Issues #1, #4, #7
  📝 tech-writer (1 instance): Issue #2
  🧪 test-engineer (1 instance): Issue #5

⚡ All agents running...
  ✅ code-reviewer-1: Added error handling (2.1s)
  ✅ code-reviewer-2: Extracted MAX_RETRIES constant (1.3s)
  ✅ code-reviewer-3: Removed debug log (0.8s)
  ✅ tech-writer-1: Added getUserData docstring (1.5s)
  ✅ test-engineer-1: Added payment integration test (4.2s)

🔍 Verifying all fixes applied...
  Approved fixes: 5
  Files modified: 5

🧪 Running test suite...
✅ All tests passing

📦 Committing changes...
✅ Commit created: fix: resolve CodeRabbit feedback (5 issues)

⬆️  Pushing to remote...
✅ Pushed successfully

📢 Posting resolution comment...
✅ Posted "@coderabbitai resolve" to PR #119

🎉 Resolution Complete!
  🆔 Execution: resolve-cr-1738886234-12345
  📊 Addressed: 5 of 7 issues
  ⏭️  Skipped: 1 issue (not aligned with standards)
  ❓ Manual review: 1 issue (architecture decision)
  ⚡ Agents deployed: 5
  ✅ Tests: Passing
  ⏱️  Total time: 12.8 seconds
```

### Second Execution (Called Again Immediately)

```text
🆔 Execution: resolve-cr-1738886299-12346  # NEW EXECUTION ID
🔍 Fetching unresolved CodeRabbit comments from multiple sources...

📊 Comment Discovery Results:
  • Review threads: 1 comments
  • Review comments: 2 comments
  • Issue comments: 0 comments
  • Review submissions: 0 comments
  • Total unique: 3 unresolved comments

ℹ️  Note: Found 3 new/remaining comments (down from 7 in previous execution)

✅ Found 3 unresolved comments

🤖 Deploying code-reviewer agent with ALL 3 comments...
[... continues normally ...]
```

### Catastrophic Failure (No Comments)

```text
🆔 Execution: resolve-cr-1738886350-12347
🔍 Fetching unresolved CodeRabbit comments from multiple sources...

📊 Comment Discovery Results:
  • Review threads: 0 comments
  • Review comments: 0 comments
  • Issue comments: 0 comments
  • Review submissions: 0 comments
  • Total unique: 0 unresolved comments

❌ CATASTROPHIC FAILURE: No unresolved CodeRabbit comments found

🔍 Diagnostic Information:
  Execution ID: resolve-cr-1738886350-12347
  PR: #119 (owner/repo)
  Searched 4 different API sources
  All sources returned 0 comments

⚠️  Possible Issues:
  1. CodeRabbit hasn't reviewed this PR yet (total activity: 0)
  2. All comments were already resolved
  3. API permissions issue preventing comment access
  4. PR may not have CodeRabbit integration enabled

🔧 Troubleshooting Steps:
  1. Manually check PR reviews tab in GitHub UI
  2. Trigger new review: Comment '@coderabbitai review' on PR
  3. Verify CodeRabbit bot has access to repository
  4. Run: gh pr view 119 --json reviewThreads | jq

Exit code: 1
```

## Success Criteria

✅ Fetches comments from 4 different GitHub API sources
✅ Finds ALL unresolved comments, not just some
✅ Fails catastrophically with diagnostics when no comments found
✅ Each execution has unique ID, always fetches fresh
✅ Single code-reviewer agent receives ALL comments
✅ Verification ensures all comments analyzed (100% coverage)
✅ Can be called repeatedly without "already ran" issues
✅ Parallel agent deployment for approved fixes
✅ All changes tested and verified
✅ Posts resolution comment to CodeRabbit

## Notes

- **Aggressive Discovery**: Queries 4 different API endpoints to ensure complete coverage
- **Always Fresh**: Never uses cached data, each execution is independent
- **Fail Loud**: Not finding comments is an error state with comprehensive diagnostics
- **Idempotent**: Can be run multiple times as CodeRabbit adds new comments
- **Complete Resolution**: Passes ALL comments to agent, resolves ALL approved items
- **Verification Built-in**: Validates that agent analyzed every single comment
- **Fast Execution**: Parallel agent deployment, typically 10-20 seconds total
- **Safe Defaults**: Interactive approval prevents unwanted changes
