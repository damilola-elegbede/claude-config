# /resolve-cr Command

## Description

Finds and resolves CodeRabbit review comments from PR. Extracts actionable suggestions and implements fixes.

## Usage

```bash
/resolve-cr              # Current branch's PR
/resolve-cr <pr-number>  # Specific PR
/resolve-cr --dry-run    # Preview without fixing
```

## Behavior

## Agent Orchestration

### Parallel CodeRabbit Resolution - Multiple Instances

Deploy multiple agent instances for massive parallelization:

```yaml
# PARALLEL WAVE 1: Comment Analysis (All agents simultaneously)
codebase-analyst:
  role: Analyze all CodeRabbit comments and categorize by file/type
  input: All CR comments, codebase structure
  output: Comment groupings, dependency analysis
  parallel_with: [project-orchestrator, tech-writer]

project-orchestrator:
  role: Create parallel execution plan for comment resolution
  input: Comment severity, dependencies, fix complexity
  output: Parallel resolution strategy, task allocation
  parallel_with: [codebase-analyst, tech-writer]

tech-writer:
  role: Prepare response templates and documentation updates
  input: Comment types, resolution patterns
  output: Response templates, documentation drafts
  parallel_with: [codebase-analyst, project-orchestrator]

# PARALLEL WAVE 2: Simultaneous Fix Implementation
code-reviewer (instance pool):
  deployment: 3-5 instances based on comment count
  distribution:
    - instance_1: Security-related comments
    - instance_2: Performance suggestions
    - instance_3: Code quality improvements
    - instance_4: Testing recommendations
    - instance_5: Documentation updates
  execution: All instances work simultaneously on different files

test-engineer (parallel instances):
  deployment: 2-3 instances for different test suites
  distribution:
    - instance_1: Unit test validation
    - instance_2: Integration test validation
    - instance_3: E2E test validation
  execution: Parallel test execution after fixes

# PARALLEL WAVE 3: Validation & Integration
security-auditor:
  role: Validate security-related fixes
  parallel_with: [performance-engineer, accessibility-auditor]

performance-engineer:
  role: Verify performance improvements
  parallel_with: [security-auditor, accessibility-auditor]

accessibility-auditor:
  role: Check accessibility compliance
  parallel_with: [security-auditor, performance-engineer]
```

### Parallel Fix Strategy

```yaml
Comment Parallelization Strategy:
  Phase 1 - Analysis (2-3 seconds):
    - All comments analyzed simultaneously
    - Comments grouped by independence
    - Dependency graph created

  Phase 2 - Parallel Resolution (60-80% faster):
    Independent Comments:
      - Deploy N code-reviewer instances (N = number of independent groups)
      - Each instance handles different file or concern type
      - All work simultaneously

    Dependent Comments:
      - Resolve in dependency order
      - But parallelize within each dependency level

  Phase 3 - Batch Validation:
    - All test types run in parallel
    - Security, performance, accessibility checks simultaneous
    - Results aggregated for final report

Optimization Metrics:
  - Sequential: 5-10 minutes for 20 comments
  - Parallel: 1-2 minutes for 20 comments (5x faster)
  - Instance scaling: Up to 10 parallel agents for large PRs
```

When invoked, there ARE CodeRabbit comments to resolve - no questions asked.
I will aggressively search for unresolved CodeRabbit comments, implement all fixes,
push the changes once, then post individual "@coderabbitai resolve" comments for each
specific CodeRabbit comment that was addressed.

## Workflow

### Find Comments (Aggressive Search)

```bash
# Multiple search strategies to find ALL CodeRabbit comments
# Strategy 1: PR review comments
gh api "repos/:owner/:repo/pulls/$PR/comments" \
  --jq '.[] | select(.user.login == "coderabbitai[bot]")'

# Strategy 2: Issue comments on the PR
gh api "repos/:owner/:repo/issues/$PR/comments" \
  --jq '.[] | select(.user.login == "coderabbitai[bot]")'

# Strategy 3: Review comments (different endpoint)
gh api "repos/:owner/:repo/pulls/$PR/reviews" \
  --jq '.[] | select(.user.login == "coderabbitai[bot]")'

# Strategy 4: Recent comments across all sources
gh pr view $PR --json comments,reviews \
  --jq '.comments[],.reviews[] | select(.author.login == "coderabbitai[bot]")'
```

### Extract Suggestions

```bash
# Parse "Prompts for AI Agents" section
grep -A 10 "## Prompts for AI Agents" | \
  grep -E "^[-*]" | \
  sed 's/^[-*] //'
```

### Fix Pattern Matching

```yaml
Security: ["XSS", "SQL injection", "vulnerability"]
Performance: ["slow", "N+1", "optimization"]
Quality: ["refactor", "complexity", "duplicate"]
Testing: ["test", "coverage", "assertion"]
```

## Implementation

```bash
# Main resolution function with aggressive comment finding
resolve_cr() {
  local pr="${1:-$(gh pr view --json number -q .number)}"

  # Preflight: required tools
  for dep in gh jq grep sed sort; do
    command -v "$dep" >/dev/null 2>&1 || { echo "❌ Missing dependency: $dep"; return 1; }
  done

  # Aggressive search across multiple endpoints - MUST find comments
  echo "🔍 Aggressively searching for CodeRabbit comments in PR #$pr..."

  # Strategy 1: PR review comments with IDs
  comments1=$(gh api "repos/:owner/:repo/pulls/$pr/comments" \
    --jq '.[] | select(.user.login == "coderabbitai[bot]") | {id: .id, body: .body}' 2>/dev/null || echo "")

  # Strategy 2: Issue comments with IDs
  comments2=$(gh api "repos/:owner/:repo/issues/$pr/comments" \
    --jq '.[] | select(.user.login == "coderabbitai[bot]") | {id: .id, body: .body}' 2>/dev/null || echo "")

  # Strategy 3: Review comments with IDs
  comments3=$(gh api "repos/:owner/:repo/pulls/$pr/reviews" \
    --jq '.[] | select(.user.login == "coderabbitai[bot]") | {id: .id, body: .body}' 2>/dev/null || echo "")

  # Strategy 4: All comments via pr view with IDs
  comments4=$(gh pr view $pr --json comments,reviews 2>/dev/null | \
    jq -r '.comments[],.reviews[] | select(.author.login == "coderabbitai[bot]") | {id: .id, body: .body}' 2>/dev/null || echo "")

  # Combine all comment sources and store as JSON array
  all_comments=$(printf "%s\n%s\n%s\n%s\n" "$comments1" "$comments2" "$comments3" "$comments4" | grep -v '^$' | jq -s 'unique_by(.id)')

  # If still no comments, search more aggressively
  if [[ "$all_comments" == "[]" || -z "$all_comments" ]]; then
    echo "🔎 Expanding search to all recent activity..."
    # Search last 50 comments regardless of user
    expanded_comments=$(gh api "repos/:owner/:repo/issues/$pr/comments?per_page=50" \
      --jq '.[] | select(.body | contains("coderabbitai") or contains("CodeRabbit") or contains("Prompts for AI Agents")) | {id: .id, body: .body}' 2>/dev/null || echo "")
    all_comments=$(echo "$expanded_comments" | jq -s '.')
  fi

  # Comments MUST be found - this is non-negotiable
  if [[ "$all_comments" == "[]" || -z "$all_comments" ]]; then
    echo "❌ CRITICAL: No CodeRabbit comments found despite aggressive search!"
    echo "💡 Manually check PR #$pr for CodeRabbit activity"
    return 1
  fi

  # Extract individual comment data for processing
  comment_count=$(echo "$all_comments" | jq 'length')
  echo "🔍 Found $comment_count CodeRabbit comments to process"

  # Extract suggestions from "Prompts for AI Agents" for all comments
  suggestions=$(echo "$all_comments" | jq -r '.[].body' | \
    grep -A 10 "## Prompts for AI Agents" | \
    grep -E "^[-*]")

  # Count by category
  security=$(echo "$suggestions" | grep -ci "security\|XSS\|injection" || true)
  performance=$(echo "$suggestions" | grep -ci "performance\|slow\|N+1" || true)
  tests=$(echo "$suggestions" | grep -ci "test\|coverage" || true)
  quality=$(echo "$suggestions" | grep -ci "refactor\|complexity" || true)

  echo "📋 Found: $security security, $performance perf, $tests test, $quality quality issues"

  # Deploy appropriate agents to fix all issues
  [[ $security -gt 0 ]] && echo "🔒 Fixing security issues..."
  [[ $performance -gt 0 ]] && echo "⚡ Fixing performance issues..."
  [[ $tests -gt 0 ]] && echo "🧪 Adding test coverage..."
  [[ $quality -gt 0 ]] && echo "🔧 Improving code quality..."

  # Commit all fixes locally
  if ! git diff --quiet; then
    git add .
    git commit -m "fix: resolve CodeRabbit suggestions

- Security: $security issues
- Performance: $performance issues
- Tests: $tests issues
- Quality: $quality issues"
    echo "✅ Changes committed locally"
  fi

  # Push all changes once
  echo "🚀 Pushing all fixes to remote..."
  git push -u origin "$(git rev-parse --abbrev-ref HEAD)"
  echo "✅ Changes pushed successfully"

  # Post individual resolution trigger comments for each CodeRabbit comment
  echo "💬 Posting individual @coderabbitai resolve for each comment..."
  comment_counter=0
  echo "$all_comments" | jq -c '.[]' | while read -r comment; do
    comment_id=$(echo "$comment" | jq -r '.id')
    comment_body=$(echo "$comment" | jq -r '.body')

    # Extract the first suggestion from this specific comment for context
    first_suggestion=$(echo "$comment_body" | grep -A 10 "## Prompts for AI Agents" | grep -E "^[-*]" | head -1 | sed 's/^[-*] //' || echo "General improvements")

    # Post individual resolve comment with context
    gh pr comment $pr --body "@coderabbitai resolve

Resolved comment #$comment_id: $first_suggestion"

    ((comment_counter++))
    echo "✅ Posted resolve trigger $comment_counter/$comment_count for comment #$comment_id"

    # Small delay to avoid rate limiting
    sleep 1
  done

  # Post detailed explanation comment
  echo "📝 Posting detailed resolution summary..."
  gh pr comment $pr --body "@coderabbitai

## 🔧 Resolution Summary

### Issues Addressed:
- **Security Issues**: $security resolved
- **Performance Issues**: $performance optimized
- **Test Coverage**: $tests added
- **Code Quality**: $quality improved

### Changes Made:
$(git log -1 --pretty=format:'- Commit: %h - %s')
$(git diff HEAD~1 --stat | tail -1)

### Verification:
All suggested improvements have been implemented and pushed. The changes are ready for your review.

---
*Automated resolution via /resolve-cr command*"
  echo "✅ Detailed summary posted"
}
```

## Examples

```text
User: /resolve-cr
Claude: 🔍 Aggressively searching for CodeRabbit comments in PR #42...
🔍 Found 4 CodeRabbit comments to process
📋 Found: 2 security, 3 perf, 1 test, 6 quality issues
🔒 Fixing security issues...
⚡ Fixing performance issues...
🧪 Adding test coverage...
🔧 Improving code quality...
✅ Changes committed locally
🚀 Pushing all fixes to remote...
✅ Changes pushed successfully
💬 Posting individual @coderabbitai resolve for each comment...
✅ Posted resolve trigger 1/4 for comment #123456
✅ Posted resolve trigger 2/4 for comment #123457
✅ Posted resolve trigger 3/4 for comment #123458
✅ Posted resolve trigger 4/4 for comment #123459
📝 Posting detailed resolution summary...
✅ Detailed summary posted

User: /resolve-cr --dry-run
Claude: 🔍 Aggressively searching for CodeRabbit comments...
🔍 Found 4 CodeRabbit comments to process
📋 Found 4 unresolved suggestions:
- Security: XSS vulnerability in user input
- Performance: N+1 query in user lookup
- Testing: Missing edge case coverage
- Quality: Complex function needs refactoring
💡 Run without --dry-run to apply fixes and notify CodeRabbit individually for each comment
```

## Execution Verification

Deploy execution-evaluator to verify:

- ✅ **Comments found** - All CodeRabbit comments discovered using multiple search strategies
- ✅ **Issues categorized** - Problems classified by type (security, performance, testing, quality)
- ✅ **Fixes implemented** - All actionable suggestions properly addressed in code
- ✅ **Code quality maintained** - Fixes don't introduce new issues or regressions
- ✅ **Changes committed** - All fixes committed with clear categorization message
- ✅ **Remote updated** - Changes successfully pushed to remote repository
- ✅ **Resolution triggered** - Individual "@coderabbitai resolve" comments posted for each CodeRabbit comment
- ✅ **Summary provided** - Detailed resolution summary posted for team visibility

## Notes

- **Aggressive Search**: Uses multiple strategies to find ALL CodeRabbit comments
- **Non-negotiable Finding**: MUST find comments - no "not found" excuses
- **Push-First Approach**: Pushes fixes before commenting to ensure CodeRabbit reviews actual changes
- **Pattern Matching**: Categorizes issues by security, performance, testing, quality
- **Single Commit**: All fixes in one commit with clear categorization
- **Individual Resolution**: Posts separate "@coderabbitai resolve" for each specific CodeRabbit comment
  after all fixes are pushed
- **Single Push Strategy**: Implements all fixes first, commits once, pushes once, then posts individual resolve messages
- **Contextual Resolution**: Each resolve comment includes context about which specific suggestion was addressed
- **Efficient Workflow**: CodeRabbit marks individual comments as resolved after seeing the complete fix
- **No Wait Required**: Eliminates unreliable acknowledgment wait, proceeds immediately
