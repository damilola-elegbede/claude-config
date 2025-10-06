---
description: CodeRabbit feedback resolver with intelligent evaluation
argument-hint: [<pr-number>] [--auto|--dry-run]
thinking-level: megathink
thinking-tokens: 10000
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

Intelligently evaluates unresolved CodeRabbit feedback using code-reviewer agent analysis, then presents
an interactive table for user approval before applying fixes. The code-reviewer agent evaluates each
suggestion against your codebase and coding standards to determine if it should be addressed.

### Thinking Level: MEGATHINK (10,000 tokens)

Required for coordinating code-reviewer analysis, processing multiple comment threads, generating
evaluation table, and orchestrating fix agent deployment.

## Workflow

### Step 1: Fetch Unresolved CodeRabbit Comments

Collect all unresolved comments from the PR:

```bash
# Get PR number (current branch or argument)
pr="${1:-$(gh pr view --json number -q .number)}"

# Fetch only unresolved CodeRabbit comments
gh pr view "$pr" --json comments --jq '
  .comments[] |
  select(.author.login == "coderabbitai[bot]") |
  select(.isResolved == false) |
  {
    id: .id,
    body: .body,
    path: .path,
    line: .line,
    createdAt: .createdAt
  }'
```

If no unresolved comments found, report success and exit.

### Step 2: Deploy Code-Reviewer Agent for Analysis

Deploy single code-reviewer agent with all unresolved comments and codebase context:

**Agent Prompt:**

```text
You are analyzing CodeRabbit feedback for a pull request. For each suggestion below, evaluate:

1. **Alignment**: Does this align with our coding standards and codebase conventions?
2. **Value**: Does this suggestion add real value or is it pedantic?
3. **Severity**: How important is this issue? (Critical/High/Medium/Low/Info)
4. **Recommendation**: Should we address it? (Yes/No/Maybe)
5. **Agent Assignment**: Which agent should fix this? (code-reviewer/tech-writer/test-engineer/manual)

Evaluation Criteria:
- **Critical**: Security vulnerabilities, breaking bugs, data loss risks
- **High**: Performance issues, incorrect logic, major code quality problems
- **Medium**: Code style consistency, maintainability improvements, minor bugs
- **Low**: Formatting preferences, optional optimizations, minor style tweaks
- **Info**: Educational comments, best practice suggestions, nice-to-haves

Assignment Guidelines:
- **code-reviewer**: Code fixes, refactoring, logic changes, formatting, imports
- **tech-writer**: Documentation, comments, docstrings, README updates
- **test-engineer**: Test additions, test fixes, coverage improvements
- **manual**: Architecture changes, complex refactors, design decisions

Codebase Context:
[Include relevant files, coding standards, architectural patterns]

Unresolved CodeRabbit Comments:
[All unresolved comments from Step 1]

Output a structured evaluation for each comment with:
- Issue summary (one line)
- File and line number
- Severity
- Recommendation (Yes/No/Maybe with brief reasoning)
- Assigned agent
```

### Step 3: Display Interactive Evaluation Table

Present code-reviewer's analysis as an interactive table:

```text
📊 CodeRabbit Feedback Evaluation (PR #119)

┌────┬─────────────────────────────────────────┬──────────┬────────────────┬────────────────┬──────────────┐
│ ID │ Issue                                   │ Severity │ Recommendation │ Assigned Agent │ Location     │
├────┼─────────────────────────────────────────┼──────────┼────────────────┼────────────────┼──────────────┤
│ 1  │ Missing error handling in auth()        │ High     │ Yes ✓          │ code-reviewer  │ auth.ts:45   │
│ 2  │ Add docstring for getUserData()         │ Medium   │ Yes ✓          │ tech-writer    │ api.ts:128   │
│ 3  │ Use const instead of let                │ Low      │ No ✗           │ N/A            │ utils.ts:12  │
│    │   Reason: Our style guide allows let    │          │                │                │              │
│ 4  │ Extract magic number to constant        │ Medium   │ Yes ✓          │ code-reviewer  │ calc.ts:67   │
│ 5  │ Add integration test for payment flow   │ High     │ Yes ✓          │ test-engineer  │ payment.ts:1 │
│ 6  │ Consider using async/await pattern      │ Info     │ Maybe ?        │ manual         │ db.ts:203    │
│    │   Reason: Requires architecture review  │          │                │                │              │
│ 7  │ Remove console.log debug statement      │ Low      │ Yes ✓          │ code-reviewer  │ debug.ts:89  │
└────┴─────────────────────────────────────────┴──────────┴────────────────┴────────────────┴──────────────┘

Summary:
  ✅ Recommended to address: 5 issues (1 High, 2 Medium, 2 Low)
  ❌ Recommended to skip: 1 issue
  ❓ Requires manual review: 1 issue

Automatic fixes available for: 4 issues
Manual intervention needed for: 1 issue
```

### Step 4: User Approval and Plan Modification

**Interactive Mode (default):**

```text
Options:
  [a] Approve all recommended fixes (5 issues)
  [s] Select specific issues to fix
  [m] Modify plan (change severity/assignment)
  [v] View detailed analysis for each issue
  [n] Skip all fixes, exit

Your choice:
```

**Selection Mode:**

```text
Select issues to fix (space-separated IDs, or 'all'):
> 1 2 4 5

Selected 4 issues:
  1. Missing error handling in auth() [High]
  2. Add docstring for getUserData() [Medium]
  4. Extract magic number to constant [Medium]
  5. Add integration test for payment flow [High]

Proceed with these fixes? [y/n]:
```

**Auto Mode (`--auto`):**
Skip approval, automatically fix all items with "Yes ✓" recommendation.

**Dry-Run Mode (`--dry-run`):**
Display table and exit without applying fixes.

### Step 5: Deploy Assigned Agents for Approved Fixes

For each approved issue, deploy the assigned agent with specific context:

```yaml
Deployment Strategy:
  - Group fixes by agent type
  - Deploy agents in parallel per type
  - code-reviewer: All code fixes simultaneously
  - tech-writer: All documentation updates simultaneously
  - test-engineer: All test additions simultaneously

Example Deployment:
  code-reviewer (3 instances):
    - instance_1: Fix auth error handling (issue #1)
    - instance_2: Extract magic number (issue #4)
    - instance_3: Remove debug statement (issue #7)

  tech-writer (1 instance):
    - instance_1: Add getUserData docstring (issue #2)

  test-engineer (1 instance):
    - instance_1: Add payment integration test (issue #5)

Execution:
  - All agents run in parallel
  - Each agent creates focused commit for its fix
  - Verify tests pass after all fixes applied
```

### Step 6: Verify and Push Changes

After all agents complete:

1. **Run test suite** to verify no regressions
2. **Review all changes** made by agents
3. **Create consolidated commit** or keep individual commits based on user preference
4. **Push changes** to remote branch

### Step 7: Post Resolution Comment

**MANDATORY** - Always post after pushing fixes:

```bash
gh pr comment "$pr" --body "@coderabbitai resolve"
```

This triggers CodeRabbit to update status of resolved comments.

## Expected Output

### Successful Interactive Workflow

```text
🔍 Fetching unresolved CodeRabbit comments for PR #119...
✅ Found 7 unresolved comments

🤖 Deploying code-reviewer agent for intelligent analysis...
⏳ Analyzing comments against codebase standards...
✅ Analysis complete

📊 CodeRabbit Feedback Evaluation (PR #119)
[Table displayed as shown above]

Options:
  [a] Approve all recommended fixes (5 issues)
  [s] Select specific issues to fix
  [m] Modify plan
  [v] View detailed analysis
  [n] Skip all fixes

Your choice: a

✅ Approved 5 fixes

🚀 Deploying specialized agents...
  🔧 code-reviewer (3 instances): Issues #1, #4, #7
  📝 tech-writer (1 instance): Issue #2
  🧪 test-engineer (1 instance): Issue #5

⚡ All agents running in parallel...
  ✅ code-reviewer-1 completed: Added error handling (2.1s)
  ✅ code-reviewer-2 completed: Extracted MAX_RETRIES constant (1.3s)
  ✅ code-reviewer-3 completed: Removed debug log (0.8s)
  ✅ tech-writer-1 completed: Added getUserData docstring (1.5s)
  ✅ test-engineer-1 completed: Added payment integration test (4.2s)

🧪 Running test suite to verify changes...
✅ All tests passing

📦 Creating consolidated commit...
✅ Commit created: fix: resolve CodeRabbit feedback (5 issues)

⬆️  Pushing changes to remote...
✅ Pushed successfully

📢 Posting resolution comment to CodeRabbit...
✅ Posted "@coderabbitai resolve" to PR #119

🎉 Resolution complete!
  - 5/7 issues addressed
  - 2 issues skipped based on analysis
  - 5 agents deployed
  - All tests passing
  - Total time: 8.2 seconds
```

### Auto Mode Workflow

```text
🔍 Fetching unresolved CodeRabbit comments for PR #119...
✅ Found 7 unresolved comments

🤖 Analyzing with code-reviewer agent...
✅ Analysis complete: 5 recommended, 1 skip, 1 manual review

⚡ Auto mode: Deploying fixes for 5 recommended issues...
[... agent deployment same as above ...]

🎉 Auto-resolution complete! 5/7 issues addressed
```

### Dry-Run Mode

```text
🔍 Fetching unresolved CodeRabbit comments for PR #119...
✅ Found 7 unresolved comments

🤖 Analyzing with code-reviewer agent...
✅ Analysis complete

📊 CodeRabbit Feedback Evaluation (PR #119)
[Table displayed]

🔍 Dry-run mode: No changes will be made

Would deploy:
  - 3 code-reviewer instances (issues #1, #4, #7)
  - 1 tech-writer instance (issue #2)
  - 1 test-engineer instance (issue #5)

Exiting without changes.
```

### No Unresolved Comments

```text
🔍 Fetching unresolved CodeRabbit comments for PR #119...
✅ No unresolved comments found

🎉 All CodeRabbit feedback has been addressed!
```

## Evaluation Criteria Details

The code-reviewer agent evaluates each suggestion using:

### Alignment Check

- Does this match our documented coding standards?
- Is this consistent with existing codebase patterns?
- Does this fit our architectural decisions?

### Value Assessment

- Does this improve code quality meaningfully?
- Is this a pedantic preference vs substantive improvement?
- What's the maintenance/readability impact?

### Severity Determination

```yaml
Critical:
  - Security vulnerabilities (SQL injection, XSS, auth bypass)
  - Data loss or corruption risks
  - Breaking production bugs

High:
  - Performance bottlenecks (N+1 queries, memory leaks)
  - Incorrect business logic
  - Major code quality issues (high complexity, duplicated logic)

Medium:
  - Code style inconsistencies across files
  - Maintainability improvements (better naming, clearer structure)
  - Minor bugs that don't affect critical paths

Low:
  - Formatting preferences (spacing, indentation)
  - Optional optimizations (micro-performance)
  - Minor style tweaks (const vs let when both acceptable)

Info:
  - Educational suggestions
  - Best practice recommendations
  - Nice-to-have improvements
```

### Recommendation Logic

```yaml
Yes (Address):
  - Aligns with our standards AND adds value
  - Fixes real bugs or security issues
  - Improves maintainability significantly

No (Skip):
  - Conflicts with our documented standards
  - Pedantic without real value
  - Already addressed in different way

Maybe (Manual Review):
  - Requires architectural decision
  - Trade-offs need discussion
  - Complex refactoring with unclear ROI
```

## Agent Assignment Strategy

### code-reviewer

**Best for:**

- Logic fixes and bug corrections
- Refactoring and code structure
- Import organization and cleanup
- Formatting and style consistency
- Error handling improvements
- Variable/function renaming

**Example fixes:**

- Add null checks and error handling
- Extract magic numbers to constants
- Remove unused imports
- Fix linting violations
- Simplify complex conditionals

### tech-writer

**Best for:**

- Function and class documentation
- Inline code comments
- README and markdown updates
- API documentation
- Code examples in docs

**Example fixes:**

- Add JSDoc/docstring to functions
- Update README with new features
- Add inline comments for complex logic
- Document API endpoints
- Add usage examples

### test-engineer

**Best for:**

- Unit test additions
- Integration test coverage
- Test fixes and updates
- Mock and fixture improvements
- Test data generation

**Example fixes:**

- Add missing test cases
- Fix failing tests
- Improve test coverage
- Add edge case tests
- Update test assertions

### manual

**Assigned when:**

- Architecture changes needed
- Complex refactoring required
- Business logic decisions
- Performance optimization trade-offs
- Breaking API changes

**Requires:**

- Human review and approval
- Discussion with team
- Design document updates
- Migration planning

## Success Criteria

- Code-reviewer provides intelligent evaluation based on codebase context
- Interactive table clearly shows recommendations with reasoning
- User has full control over which fixes to apply
- Assigned agents execute fixes accurately
- All changes validated by test suite
- Resolution comment posted to CodeRabbit
- No false positives (skipping inappropriate suggestions)

## Command Philosophy

Transform CodeRabbit feedback resolution from automatic pattern matching to intelligent, context-aware
evaluation. The code-reviewer agent acts as a senior developer reviewing each suggestion, ensuring only
valuable changes that align with your standards are applied. User maintains full control with clear
visibility into what will be changed and why.
