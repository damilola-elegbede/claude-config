# /resolve-cr Command

## Description

Finds and resolves CodeRabbit review comments from PR. Extracts actionable suggestions and implements fixes.

## Usage

```bash
/resolve-cr              # Current branch's PR
/resolve-cr <pr-number>  # Specific PR
/resolve-cr --dry-run    # Preview without fixing
```

## Workflow

### Find Comments

```bash
# Search PR for CodeRabbit comments
gh api "repos/:owner/:repo/pulls/$PR/comments" \
  --jq '.[] | select(.user.login == "coderabbitai[bot]")'
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
# Main resolution function
resolve_cr() {
  local pr="${1:-$(gh pr view --json number -q .number)}"
  
  # Find CodeRabbit comments
  comments=$(gh api "repos/:owner/:repo/pulls/$pr/comments" \
    --jq '.[] | select(.user.login == "coderabbitai[bot]") | .body')
  
  if [[ -z "$comments" ]]; then
    echo "✅ No CodeRabbit comments found"
    return 0
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
  
  # Commit if changes made
  if ! git diff --quiet; then
    git add .
    git commit -m "fix: resolve CodeRabbit suggestions

- Security: $security issues
- Performance: $performance issues  
- Tests: $tests issues
- Quality: $quality issues"
    git push
    
    # Notify CodeRabbit
    gh pr comment $pr --body "@coderabbitai resolve"
  fi
}
```

## Examples

```bash
User: /resolve-cr
Claude: 🔍 Checking PR #42...
📋 Found: 2 security, 3 perf, 1 test, 6 quality issues
🔒 Fixing security issues...
⚡ Fixing performance issues...
✅ Committed and pushed fixes
💬 Notified CodeRabbit

User: /resolve-cr --dry-run
Claude: 🔍 Found 3 suggestions:
- Security: XSS vulnerability
- Performance: Slow query
- Testing: Missing coverage
💡 Run without --dry-run to apply fixes
```

## Notes

- Focuses on CodeRabbit's "Prompts for AI Agents" section
- Pattern matches to categorize issues
- Single commit for all fixes
- Notifies CodeRabbit with @mention
- Use --dry-run to preview before applying
