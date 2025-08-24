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

When invoked, there ARE CodeRabbit comments to resolve - no questions asked.
I will aggressively search for unresolved CodeRabbit comments, implement fixes,
push the changes, then post two comments: first "@coderabbitai resolve" to
trigger resolution, followed by a detailed summary of the fixes for CodeRabbit.

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

  # Strategy 1: PR review comments
  comments1=$(gh api "repos/:owner/:repo/pulls/$pr/comments" \
    --jq '.[] | select(.user.login == "coderabbitai[bot]") | .body' 2>/dev/null || echo "")

  # Strategy 2: Issue comments
  comments2=$(gh api "repos/:owner/:repo/issues/$pr/comments" \
    --jq '.[] | select(.user.login == "coderabbitai[bot]") | .body' 2>/dev/null || echo "")

  # Strategy 3: Review comments
  comments3=$(gh api "repos/:owner/:repo/pulls/$pr/reviews" \
    --jq '.[] | select(.user.login == "coderabbitai[bot]") | .body' 2>/dev/null || echo "")

  # Strategy 4: All comments via pr view
  comments4=$(gh pr view $pr --json comments,reviews 2>/dev/null | \
    jq -r '.comments[],.reviews[] | select(.author.login == "coderabbitai[bot]") | .body' 2>/dev/null || echo "")
  # Combine all comment sources
  comments=$(printf "%s\n%s\n%s\n%s\n" "$comments1" "$comments2" "$comments3" "$comments4" | grep -v '^$' | sort -u)

  # If still no comments, search more aggressively
  if [[ -z "$comments" ]]; then
    echo "🔎 Expanding search to all recent activity..."
    # Search last 50 comments regardless of user
    all_comments=$(gh api "repos/:owner/:repo/issues/$pr/comments?per_page=50" \
      --jq '.[] | select(.body | contains("coderabbitai") or contains("CodeRabbit") or contains("Prompts for AI Agents")) | .body' 2>/dev/null || echo "")
    comments="$all_comments"
  fi

  # Comments MUST be found - this is non-negotiable
  if [[ -z "$comments" ]]; then
    echo "❌ CRITICAL: No CodeRabbit comments found despite aggressive search!"
    echo "💡 Manually check PR #$pr for CodeRabbit activity"
    return 1
  fi

  # Extract suggestions from "Prompts for AI Agents"
  suggestions=$(echo "$comments" | \
    grep -A 10 "## Prompts for AI Agents" | \
    grep -E "^[-*]")

  # Count by category
  security=$(echo "$suggestions" | grep -ci "security\|XSS\|injection" || true)
  performance=$(echo "$suggestions" | grep -ci "performance\|slow\|N+1" || true)
  tests=$(echo "$suggestions" | grep -ci "test\|coverage" || true)
  quality=$(echo "$suggestions" | grep -ci "refactor\|complexity" || true)

  echo "📋 Found: $security security, $performance perf, $tests test, $quality quality issues"

  # Deploy appropriate agents to fix issues
  [[ $security -gt 0 ]] && echo "🔒 Fixing security issues..."
  [[ $performance -gt 0 ]] && echo "⚡ Fixing performance issues..."
  [[ $tests -gt 0 ]] && echo "🧪 Adding test coverage..."
  [[ $quality -gt 0 ]] && echo "🔧 Improving code quality..."

  # Commit fixes locally
  if ! git diff --quiet; then
    git add .
    git commit -m "fix: resolve CodeRabbit suggestions

- Security: $security issues
- Performance: $performance issues
- Tests: $tests issues
- Quality: $quality issues"
    echo "✅ Changes committed locally"
  fi

  # Push changes immediately
  echo "🚀 Pushing fixes to remote..."
  git push -u origin "$(git rev-parse --abbrev-ref HEAD)"
  echo "✅ Changes pushed successfully"

  # Post resolution trigger comment
  echo "💬 Posting @coderabbitai resolve to trigger resolution..."
  gh pr comment $pr --body "@coderabbitai resolve"
  echo "✅ Resolution trigger posted"

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

```bash
User: /resolve-cr
Claude: 🔍 Aggressively searching for CodeRabbit comments in PR #42...
📋 Found: 2 security, 3 perf, 1 test, 6 quality issues
🔒 Fixing security issues...
⚡ Fixing performance issues...
🧪 Adding test coverage...
🔧 Improving code quality...
✅ Changes committed locally
🚀 Pushing fixes to remote...
✅ Changes pushed successfully
💬 Posting @coderabbitai resolve to trigger resolution...
✅ Resolution trigger posted
📝 Posting detailed resolution summary...
✅ Detailed summary posted

User: /resolve-cr --dry-run
Claude: 🔍 Aggressively searching for CodeRabbit comments...
📋 Found 4 unresolved suggestions:
- Security: XSS vulnerability in user input
- Performance: N+1 query in user lookup
- Testing: Missing edge case coverage
- Quality: Complex function needs refactoring
💡 Run without --dry-run to apply fixes and notify CodeRabbit
```

## Notes

- **Aggressive Search**: Uses multiple strategies to find ALL CodeRabbit comments
- **Non-negotiable Finding**: MUST find comments - no "not found" excuses
- **Push-First Approach**: Pushes fixes before commenting to ensure CodeRabbit reviews actual changes
- **Pattern Matching**: Categorizes issues by security, performance, testing, quality
- **Single Commit**: All fixes in one commit with clear categorization
- **Split Comments**: Posts "@coderabbitai resolve" first, then detailed summary separately
- **Automatic Resolution**: CodeRabbit marks comments as resolved via @mention
- **No Wait Required**: Eliminates unreliable acknowledgment wait, proceeds immediately
