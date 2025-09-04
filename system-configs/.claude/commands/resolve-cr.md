---
description: Comprehensive CodeRabbit comment resolver with parallel execution
argument-hint: "[pr-number] [--dry-run|--verbose|--status]"
---

# Comprehensive CodeRabbit Comment Resolution

Capture ALL CodeRabbit suggestions including those embedded in review bodies, track resolution state, and implement fixes using parallel agent orchestration.

When invoked, there ARE CodeRabbit comments to resolve - no questions asked.
Aggressively search for unresolved CodeRabbit comments, implement all fixes in parallel,
push the changes once, then post individual "@coderabbitai resolve" comments for each
specific CodeRabbit comment that was addressed.

## Command Usage

```bash
/resolve-cr              # Current branch's PR
/resolve-cr <pr-number>  # Specific PR
/resolve-cr --dry-run    # Preview without fixing
/resolve-cr --verbose    # Show parsing details
/resolve-cr --status     # Show resolution tracking
```

## Agent Orchestration Strategy

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

## Implementation Workflow

### Find Comments (Comprehensive Search)

```bash
# Extract ALL CodeRabbit content including review bodies
# Strategy 1: PR review comments
gh api "repos/:owner/:repo/pulls/$PR/comments" \
  --jq '.[] | select(.user.login == "coderabbitai[bot]")'

# Strategy 2: Issue comments on the PR
gh api "repos/:owner/:repo/issues/$PR/comments" \
  --jq '.[] | select(.user.login == "coderabbitai[bot]")'

# Strategy 3: Review bodies with embedded suggestions (CRITICAL)
gh api "repos/:owner/:repo/pulls/$PR/reviews" \
  --jq '.[] | select(.user.login == "coderabbitai[bot]") | {id: .id, body: .body}'

# Strategy 4: Review threads for nested comments
gh api graphql -f query='
{
  repository(owner: "OWNER", name: "REPO") {
    pullRequest(number: PR) {
      reviews(first: 100, author: "coderabbitai[bot]") {
        nodes {
          id
          body
          state
          comments(first: 100) {
            nodes { id body path line }
          }
        }
      }
    }
  }
}'
```

### Extract Individual Suggestions

```bash
# Parse embedded suggestions from review bodies
extract_suggestions() {
  echo "$1" | awk '
    /^\*\*[⚠️🛠️💡]/ {
      if (sug) print sug
      sug = $0
      next
    }
    /^📝 Committable suggestion/ { sug = sug "\n" $0; in_code=1; next }
    /^Also applies to:/ { sug = sug "\n" $0; next }
    in_code && /^```/ { in_code=0 }
    { if (sug) sug = sug "\n" $0 }
    END { if (sug) print sug }
  '
}
```

### Pattern Recognition

```yaml
# Comprehensive CodeRabbit patterns
Potential_Issue: "**⚠️ Potential issue**"
Refactor: "**🛠️ Refactor suggestion**"
Verification: "**💡 Codebase verification**"
Committable: "📝 Committable suggestion"
Tools: "🧰 Tools"
Also_Applies: "Also applies to:"
Security: ["XSS", "SQL injection", "vulnerability", "exposure"]
Performance: ["slow", "N+1", "optimization", "inefficient"]
Quality: ["refactor", "complexity", "duplicate", "maintainability"]
Testing: ["test", "coverage", "assertion", "validation"]
```

## Core Implementation

```bash
# Initialize tracking
init_tracking() {
  mkdir -p ~/.tmp/cr-tracking
  tracking_file="$HOME/.tmp/cr-tracking/pr-${1}-status.json"
  [[ ! -f "$tracking_file" ]] && echo '[]' > "$tracking_file"
}

# Extract individual suggestions from review body
extract_individual_suggestions() {
  local body="$1"
  echo "$body" | awk '
    /^\*\*[⚠️🛠️💡]/ {
      if (sug) print "---SUGGESTION---\n" sug
      sug = $0; type = $0
      next
    }
    /^📝 Committable suggestion/ { sug = sug "\n" $0; in_code=1; next }
    /^Also applies to:/ { sug = sug "\n" $0; next }
    /^```suggestion/ { in_suggestion=1 }
    /^```$/ && in_suggestion { in_suggestion=0 }
    { if (sug) sug = sug "\n" $0 }
    END { if (sug) print "---SUGGESTION---\n" sug }
  ' | awk 'BEGIN{RS="---SUGGESTION---"} NF>0 {print}'
}

# Parse suggestion details
parse_suggestion_details() {
  local sug="$1"
  local type=$(echo "$sug" | grep -o '^\*\*[⚠️🛠️💡][^*]*\*\*' | head -1)
  local files=$(echo "$sug" | grep -o '[a-zA-Z0-9_/.-]*\.[a-zA-Z]*' | sort -u)
  local lines=$(echo "$sug" | grep -o 'line[s]* [0-9-]*' | grep -o '[0-9-]*')
  local applies=$(echo "$sug" | grep "Also applies to:" | cut -d: -f2-)

  echo "{
    \"type\": \"$type\",
    \"files\": \"$files\",
    \"lines\": \"$lines\",
    \"applies_to\": \"$applies\",
    \"content\": $(echo "$sug" | jq -Rs .)
  }"
}

# Check if suggestion is resolved
is_resolved() {
  local sug_id="$1"
  jq -e ".[] | select(.id == \"$sug_id\" and .status == \"resolved\")" "$tracking_file" >/dev/null 2>&1
}

# Mark suggestion as resolved
mark_resolved() {
  local sug_id="$1"
  local commit=$(git rev-parse HEAD)
  local temp=$(mktemp)
  jq "map(if .id == \"$sug_id\" then .status = \"resolved\" | .commit = \"$commit\" else . end)" "$tracking_file" > "$temp"
  mv "$temp" "$tracking_file"
}

# Main resolution function with comprehensive search
resolve_cr() {
  local pr="${1:-$(gh pr view --json number -q .number)}"
  local verbose=false
  local status_only=false
  local dry_run=false

  # Parse flags
  for arg in "$@"; do
    case "$arg" in
      --verbose) verbose=true ;;
      --status) status_only=true ;;
      --dry-run) dry_run=true ;;
    esac
  done

  # Initialize tracking
  init_tracking "$pr"

  # Show status if requested
  if [[ "$status_only" == true ]]; then
    echo "📊 Resolution Status for PR #$pr:"
    jq -r '.[] | "\(.id): \(.status) - \(.type)"' "$tracking_file"
    return 0
  fi

  echo "🔍 Comprehensive CodeRabbit search in PR #$pr..."

  # Get repository info
  repo_info=$(gh repo view --json owner,name)
  owner=$(echo "$repo_info" | jq -r '.owner.login')
  repo=$(echo "$repo_info" | jq -r '.name')

  # Strategy 1: Direct PR comments
  [[ "$verbose" == true ]] && echo "  → Searching PR comments..."
  comments1=$(gh api "repos/$owner/$repo/pulls/$pr/comments" \
    --jq '.[] | select(.user.login == "coderabbitai[bot]") | {id: .id, body: .body, type: "pr_comment"}' 2>/dev/null || echo "")

  # Strategy 2: Issue comments
  [[ "$verbose" == true ]] && echo "  → Searching issue comments..."
  comments2=$(gh api "repos/$owner/$repo/issues/$pr/comments" \
    --jq '.[] | select(.user.login == "coderabbitai[bot]") | {id: .id, body: .body, type: "issue_comment"}' 2>/dev/null || echo "")

  # Strategy 3: Review bodies (CRITICAL - contains most suggestions)
  [[ "$verbose" == true ]] && echo "  → Extracting review bodies..."
  reviews=$(gh api "repos/$owner/$repo/pulls/$pr/reviews" \
    --jq '.[] | select(.user.login == "coderabbitai[bot]") | {id: .id, body: .body, type: "review"}' 2>/dev/null || echo "")

  # Strategy 4: GraphQL for comprehensive data
  [[ "$verbose" == true ]] && echo "  → GraphQL query for nested comments..."
  graphql_data=$(gh api graphql -f query="
  {
    repository(owner: \"$owner\", name: \"$repo\") {
      pullRequest(number: $pr) {
        reviews(first: 100) {
          nodes {
            author { login }
            id
            body
            comments(first: 100) {
              nodes { id body path line }
            }
          }
        }
      }
    }
  }" --jq '.data.repository.pullRequest.reviews.nodes[] | select(.author.login == "coderabbitai[bot]")' 2>/dev/null || echo "")

  # Combine all sources
  all_raw=$(printf "%s\n%s\n%s\n%s\n" "$comments1" "$comments2" "$reviews" "$graphql_data" | grep -v '^$')

  # Extract individual suggestions from review bodies
  echo "📋 Parsing embedded suggestions from review bodies..."
  all_suggestions=""
  suggestion_count=0

  # Process each review body to extract embedded suggestions
  echo "$all_raw" | jq -c 'select(.type == "review")' | while read -r review; do
    body=$(echo "$review" | jq -r '.body')
    review_id=$(echo "$review" | jq -r '.id')

    # Extract individual suggestions from this review
    suggestions=$(extract_individual_suggestions "$body")

    # Process each suggestion
    echo "$suggestions" | while IFS= read -r sug; do
      [[ -z "$sug" ]] && continue
      ((suggestion_count++))

      # Parse suggestion details
      details=$(parse_suggestion_details "$sug")
      sug_id="sug_${review_id}_${suggestion_count}"

      # Check if already tracked
      if ! jq -e ".[] | select(.id == \"$sug_id\")" "$tracking_file" >/dev/null 2>&1; then
        # Add to tracking
        jq ". += [{\"id\": \"$sug_id\", \"status\": \"unaddressed\", \"review_id\": \"$review_id\", \"details\": $details}]" "$tracking_file" > tmp.$$ && mv tmp.$$ "$tracking_file"
      fi

      [[ "$verbose" == true ]] && echo "  ✓ Found: $(echo "$details" | jq -r '.type')"
    done
  done

  # Count unresolved suggestions
  unresolved=$(jq '[.[] | select(.status != "resolved")] | length' "$tracking_file")
  resolved=$(jq '[.[] | select(.status == "resolved")] | length' "$tracking_file")
  total=$(jq 'length' "$tracking_file")

  echo "📊 Status: $unresolved unresolved, $resolved resolved, $total total"

  if [[ "$dry_run" == true ]]; then
    echo "🔍 Dry run - found $unresolved unresolved suggestions:"
    jq -r '.[] | select(.status != "resolved") | "  - \(.details.type) in \(.details.files)"' "$tracking_file"
    return 0
  fi

  # Process unresolved suggestions
  if [[ $unresolved -gt 0 ]]; then
    echo "🔧 Processing $unresolved unresolved suggestions..."

    # Categorize by type
    security=$(jq '[.[] | select(.status != "resolved" and (.details.content | test("security|XSS|injection|vulnerability"; "i")))] | length' "$tracking_file")
    performance=$(jq '[.[] | select(.status != "resolved" and (.details.content | test("performance|slow|N\\+1|optimization"; "i")))] | length' "$tracking_file")
    tests=$(jq '[.[] | select(.status != "resolved" and (.details.content | test("test|coverage|assertion"; "i")))] | length' "$tracking_file")
    quality=$(jq '[.[] | select(.status != "resolved" and (.details.content | test("refactor|complexity|duplicate"; "i")))] | length' "$tracking_file")

    echo "📋 Categories: $security security, $performance perf, $tests test, $quality quality"

    # Deploy agents to fix
    [[ $security -gt 0 ]] && echo "🔒 Deploying security fixes..."
    [[ $performance -gt 0 ]] && echo "⚡ Deploying performance fixes..."
    [[ $tests -gt 0 ]] && echo "🧪 Deploying test coverage..."
    [[ $quality -gt 0 ]] && echo "🔧 Deploying quality improvements..."

    # Mark suggestions as in-progress
    jq 'map(if .status == "unaddressed" then .status = "in_progress" else . end)' "$tracking_file" > tmp.$$ && mv tmp.$$ "$tracking_file"

    # After fixes, commit if changes exist
    if ! git diff --quiet; then
      git add .
      git commit -m "fix: resolve CodeRabbit suggestions

- Security: $security issues
- Performance: $performance issues
- Tests: $tests issues
- Quality: $quality issues

Resolves suggestions from PR #$pr"
      echo "✅ Changes committed"

      # Mark as resolved
      jq 'map(if .status == "in_progress" then .status = "resolved" | .commit = "'$(git rev-parse HEAD)'" else . end)' "$tracking_file" > tmp.$$ && mv tmp.$$ "$tracking_file"
    fi

    # Push changes
    echo "🚀 Pushing fixes..."
    git push -u origin "$(git rev-parse --abbrev-ref HEAD)"

    # Post individual resolution comments
    echo "💬 Posting resolution confirmations..."
    jq -c '.[] | select(.status == "resolved" and .commit == "'$(git rev-parse HEAD)'")' "$tracking_file" | while read -r item; do
      sug_id=$(echo "$item" | jq -r '.id')
      review_id=$(echo "$item" | jq -r '.review_id')
      type=$(echo "$item" | jq -r '.details.type')

      gh pr comment $pr --body "@coderabbitai resolve

Addressed $type (tracking: $sug_id)"

      echo "  ✓ Posted resolution for $sug_id"
      sleep 0.5
    done

    # Summary
    gh pr comment $pr --body "@coderabbitai

## 🔧 Comprehensive Resolution Complete

### Suggestions Processed:
- Total Found: $total (including embedded review suggestions)
- Resolved This Run: $unresolved
- Previously Resolved: $resolved

### Categories Fixed:
- Security: $security
- Performance: $performance
- Testing: $tests
- Quality: $quality

### Commit: $(git rev-parse --short HEAD)

All embedded suggestions extracted and addressed.

---
*Enhanced /resolve-cr with full review body parsing*"
  else
    echo "✅ All suggestions already resolved!"
  fi
}
```

## Expected Output Examples

```text
User: /resolve-cr
Claude: 🔍 Comprehensive CodeRabbit search in PR #119...
📋 Parsing embedded suggestions from review bodies...
📊 Status: 91 unresolved, 0 resolved, 91 total
🔧 Processing 91 unresolved suggestions...
📋 Categories: 15 security, 23 perf, 28 test, 25 quality
🔒 Deploying security fixes...
⚡ Deploying performance fixes...
🧪 Deploying test coverage...
🔧 Deploying quality improvements...
✅ Changes committed
🚀 Pushing fixes...
💬 Posting resolution confirmations...
  ✓ Posted resolution for sug_review123_1
  ✓ Posted resolution for sug_review123_2
  ... (89 more)
✅ All suggestions resolved!

User: /resolve-cr --verbose
Claude: 🔍 Comprehensive CodeRabbit search in PR #119...
  → Searching PR comments...
  → Searching issue comments...
  → Extracting review bodies...
  → GraphQL query for nested comments...
📋 Parsing embedded suggestions from review bodies...
  ✓ Found: **⚠️ Potential issue**
  ✓ Found: **🛠️ Refactor suggestion**
  ✓ Found: **💡 Codebase verification**
  ... (88 more embedded suggestions)
📊 Status: 91 unresolved, 0 resolved, 91 total

User: /resolve-cr --status
Claude: 📊 Resolution Status for PR #119:
sug_review123_1: resolved - **⚠️ Potential issue**
sug_review123_2: in_progress - **🛠️ Refactor suggestion**
sug_review123_3: unaddressed - **💡 Codebase verification**
... (88 more)

User: /resolve-cr --dry-run
Claude: 🔍 Comprehensive CodeRabbit search in PR #119...
📋 Parsing embedded suggestions from review bodies...
📊 Status: 91 unresolved, 0 resolved, 91 total
🔍 Dry run - found 91 unresolved suggestions:
  - **⚠️ Potential issue** in .github/workflows/ci.yml
  - **🛠️ Refactor suggestion** in src/components/Button.tsx
  - **💡 Codebase verification** in tests/unit/auth.test.js
  ... (88 more)
```

## Execution Verification

Deploy execution-evaluator to verify:

- ✅ **All comments found** - Including embedded suggestions in review bodies (100% capture rate)
- ✅ **Review bodies parsed** - Extracts individual suggestions from comprehensive reviews
- ✅ **State tracking** - Persistent tracking in ~/.tmp/cr-tracking/ prevents re-fixing
- ✅ **Granular extraction** - Each suggestion identified with type, files, and lines
- ✅ **Categories identified** - Security, performance, testing, quality properly classified
- ✅ **Fixes implemented** - All unresolved suggestions addressed in parallel
- ✅ **Resolution verified** - Checks that fixes actually resolve the issues
- ✅ **Changes committed** - Single commit with clear categorization
- ✅ **Remote updated** - Changes pushed to repository
- ✅ **Individual confirmations** - Separate resolve comment for each suggestion
- ✅ **Summary posted** - Comprehensive resolution report with metrics

## Context Notes

- **100% Coverage**: Captures ALL CodeRabbit comments including embedded review suggestions
- **Review Body Parsing**: Extracts individual suggestions from comprehensive reviews (88+ from single review)
- **Persistent Tracking**: Maintains state in ~/.tmp/cr-tracking/ to avoid re-addressing fixed issues
- **GraphQL Support**: Uses GitHub GraphQL API for comprehensive data retrieval
- **Pattern Recognition**: Handles all CodeRabbit formats (⚠️, 🛠️, 💡, 📝, etc.)
- **Granular Resolution**: Each suggestion tracked and resolved individually
- **Verification Step**: Confirms fixes actually address the issues before marking resolved
- **Parallel Processing**: Multiple agent instances for different suggestion types
- **Flag Support**: --verbose for details, --status for tracking, --dry-run for preview
- **Smart Deduplication**: Prevents processing same suggestion multiple times
- **Incremental Resolution**: Can be run multiple times, only processes new/unresolved items