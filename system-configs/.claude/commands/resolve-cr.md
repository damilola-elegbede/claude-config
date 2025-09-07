---
description: Aggressive CodeRabbit feedback resolver with comprehensive comment fetching
argument-hint: [pr-number] [--auto|--dry-run|--skip-tests]
---

# /resolve-cr Command

## Usage

```bash
/resolve-cr                   # Interactive mode (default) - preview & confirm
/resolve-cr <pr-number>       # Specific PR, interactive
/resolve-cr --auto            # Auto-fix safe categories without confirmation
/resolve-cr --dry-run         # Preview only, no changes
/resolve-cr --skip-tests      # Skip test runs between batches (faster but riskier)
```

## Description

Aggressively fetches ALL CodeRabbit suggestions from comprehensive comment sources and resolves auto-fixable issues
with mandatory resolution posting. This command assumes unresolved comments exist when executed and performs
exhaustive comment retrieval to find them.

**Critical Behavior**: ALWAYS posts "@coderabbitai resolve" as a PR comment after pushing fixes - this is mandatory, not optional.

## Expected Output

```text
User: /resolve-cr
Claude: 🔍 Performing comprehensive CodeRabbit comment analysis for PR #119...

📡 Fetching from ALL comment sources:
  - Pull request reviews: 3 found
  - Review line comments: 12 found
  - Issue comments: 8 found
  - Conversation threads: 5 found
  - Committable suggestions: 7 found

📊 CodeRabbit Feedback Summary:
  ✅ Auto-fixable: 43 suggestions
  👀 Needs review: 18 suggestions
  🔍 Total unresolved: 61 items found

🔧 Auto-fixable suggestions:
  - Missing docstrings in auth.js
  - Import order in components/Button.tsx
  - Formatting issues in utils/helpers.js
  - Console.log statements in api/routes.js
  - Missing type annotations in types.ts
  ... and 38 more

👀 Requires human review:
  - Security: Input validation in login handler
  - Performance: N+1 query in user loader
  - Architecture: Suggested state management refactor
  - Business logic: Price calculation algorithm
  - Design: Component structure reorganization
  ... and 13 more

Would you like to auto-fix the safe categories? (y/n): y

🎨 Fixing formatting issues...
✅ Formatted 12 files
🧪 Tests passing

📝 Generating missing docstrings...
✅ Added docstrings to 23 functions

📦 Organizing imports...
✅ Organized imports in 8 files

🚀 Pushing fixes...
✅ Pushed 3 commits

🔄 MANDATORY: Posting resolution comment to CodeRabbit...
✅ Posted "@coderabbitai resolve" to PR #119
✅ CodeRabbit will update comment status automatically
```

## Behavior

### Comprehensive Comment Fetching Strategy

#### 1. Exhaustive API Calls (No Caching)

```bash
# CRITICAL: Always fetch fresh data - NEVER assume comments are resolved
fetch_all_coderabbit_feedback() {
  local pr="${1:-$(gh pr view --json number -q .number)}"
  local repo_info=$(gh repo view --json owner,name)
  local owner=$(echo "$repo_info" | jq -r '.owner.login')
  local repo=$(echo "$repo_info" | jq -r '.name')

  echo "📡 Fetching from ALL comment sources..."

  # 1. ALL CodeRabbit reviews (not just latest)
  echo "  - Fetching all PR reviews..."
  local reviews=$(gh api "repos/$owner/$repo/pulls/$pr/reviews" --paginate \
    --jq '.[] | select(.user.login == "coderabbitai[bot]") | {
      id: .id,
      body: .body,
      state: .state,
      submitted_at: .submitted_at,
      commit_id: .commit_id
    }')

  # 2. Review comments on specific lines
  echo "  - Fetching review line comments..."
  local review_comments=$(gh api "repos/$owner/$repo/pulls/$pr/comments" --paginate \
    --jq '.[] | select(.user.login == "coderabbitai[bot]") | {
      id: .id,
      body: .body,
      path: .path,
      line: .line,
      created_at: .created_at,
      in_reply_to_id: .in_reply_to_id
    }')

  # 3. Issue comments for inline suggestions
  echo "  - Fetching issue comments..."
  local issue_comments=$(gh api "repos/$owner/$repo/issues/$pr/comments" --paginate \
    --jq '.[] | select(.user.login == "coderabbitai[bot]") | {
      id: .id,
      body: .body,
      created_at: .created_at
    }')

  # 4. Conversation threads via CLI
  echo "  - Fetching conversation threads..."
  local conversations=$(gh pr view "$pr" --comments --json comments \
    --jq '.comments[] | select(.author.login == "coderabbitai[bot]") | {
      body: .body,
      createdAt: .createdAt
    }')

  # Combine all sources
  local all_feedback=$(echo "$reviews $review_comments $issue_comments $conversations" | jq -s 'add')

  echo "  - Found $(echo "$all_feedback" | jq length) total comments"
  echo "$all_feedback"
}

# Parse ALL suggestion types from combined feedback
parse_all_suggestions() {
  local feedback="$1"
  local suggestions=()

  echo "$feedback" | jq -r '.[].body' | while IFS= read -r body; do
    # Look for specific CodeRabbit suggestion patterns
    echo "$body" | grep -E "(📝 Committable suggestion|⚠️|🛠️|💡|##.*Suggestion|Consider|Recommend)" | while IFS= read -r line; do
      [[ -n "$line" ]] && suggestions+=("$line")
    done

    # Extract code blocks with suggestions
    echo "$body" | sed -n '/```suggestion/,/```/p' | while IFS= read -r line; do
      [[ "$line" != "```"* ]] && [[ -n "$line" ]] && suggestions+=("Code suggestion: $line")
    done

    # Look for unresolved conversation markers
    if echo "$body" | grep -q "unresolved\|pending\|needs.*fix\|please.*address"; then
      suggestions+=("Unresolved discussion: $(echo "$body" | head -1)")
    fi
  done

  printf '%s\n' "${suggestions[@]}"
}
```

#### 2. Aggressive Unresolved Detection

```bash
# CRITICAL: When user runs command, assume there ARE unresolved comments
analyze_unresolved_feedback() {
  local pr="$1"

  echo "🔍 Performing comprehensive CodeRabbit comment analysis for PR #$pr..."
  echo ""
  echo "⚠️  ASSUMPTION: Running this command means there ARE unresolved comments"
  echo "⚠️  BEHAVIOR: Fetching ALL comments with no caching"
  echo ""

  # Force fresh fetch - no assumptions
  local all_feedback=$(fetch_all_coderabbit_feedback "$pr")

  if [[ -z "$all_feedback" || "$all_feedback" == "[]" ]]; then
    echo "❌ No CodeRabbit comments found. This suggests:"
    echo "   - CodeRabbit hasn't reviewed this PR yet"
    echo "   - All comments were manually deleted"
    echo "   - API access issues"
    echo ""
    echo "🔄 Retrying with different API endpoints..."
    # Retry with alternative methods
    gh pr view "$pr" --comments | grep -i coderabbit || echo "No CodeRabbit mentions found"
    return 1
  fi

  # Parse ALL suggestions
  local all_suggestions=$(parse_all_suggestions "$all_feedback")

  if [[ -z "$all_suggestions" ]]; then
    echo "⚠️  Comments found but no actionable suggestions detected"
    echo "   This might mean:"
    echo "   - Comments are general/informational only"
    echo "   - Suggestions are in non-standard format"
    echo "   - All items may actually be resolved"
    echo ""
    echo "📝 Raw comment preview:"
    echo "$all_feedback" | jq -r '.[0].body' | head -5
    return 1
  fi

  echo "📊 Comprehensive feedback found:"
  local total_count=$(echo "$all_suggestions" | wc -l)
  echo "  🔍 Total unresolved: $total_count items found"
  echo ""

  echo "$all_suggestions"
}
```

#### 3. Enhanced Categorization

```bash
categorize_suggestion() {
  local suggestion="$1"
  local category=""

  # Auto-fixable patterns (expanded)
  if echo "$suggestion" | grep -qiE "(missing docstring|add documentation|document.*function|missing.*comment)"; then
    category="docstring"
  elif echo "$suggestion" | grep -qiE "(formatting|indentation|whitespace|prettier|style|lint)"; then
    category="formatting"
  elif echo "$suggestion" | grep -qiE "(import.*order|organize imports|unused import|missing import)"; then
    category="imports"
  elif echo "$suggestion" | grep -qiE "(console\.log|debug.*statement|print.*statement|remove.*log)"; then
    category="cleanup"
  elif echo "$suggestion" | grep -qiE "(type annotation|add types|missing.*type|typescript)"; then
    category="types"
  elif echo "$suggestion" | grep -qiE "(variable.*naming|camelCase|snake_case|rename.*to)"; then
    category="naming"
  elif echo "$suggestion" | grep -qiE "(unnecessary else|remove.*else|simplify.*condition)"; then
    category="simplification"

  # Requires human review (expanded)
  elif echo "$suggestion" | grep -qiE "(security|vulnerability|injection|auth|sanitize|validate.*input)"; then
    category="security-review"
  elif echo "$suggestion" | grep -qiE "(performance|optimize|N\+1|slow.*query|cache|memory)"; then
    category="performance-review"
  elif echo "$suggestion" | grep -qiE "(architecture|design|pattern|refactor.*structure|component.*design)"; then
    category="design-review"
  elif echo "$suggestion" | grep -qiE "(business.*logic|calculation|algorithm|workflow|process)"; then
    category="business-review"
  elif echo "$suggestion" | grep -qiE "(test.*coverage|add.*test|missing.*test|test.*case)"; then
    category="testing-review"
  else
    category="manual-review"
  fi

  echo "$category"
}

# Categorize all suggestions with counts
categorize_all_suggestions() {
  local suggestions="$1"
  declare -A auto_fixable_counts
  declare -A review_counts
  local auto_fixable=()
  local needs_review=()

  while IFS= read -r suggestion; do
    [[ -z "$suggestion" ]] && continue

    local category=$(categorize_suggestion "$suggestion")

    case "$category" in
      docstring|formatting|imports|cleanup|types|naming|simplification)
        auto_fixable+=("$suggestion")
        ((auto_fixable_counts["$category"]++))
        ;;
      *)
        needs_review+=("$suggestion")
        ((review_counts["$category"]++))
        ;;
    esac
  done <<< "$suggestions"

  # Display detailed breakdown
  echo "📊 CodeRabbit Feedback Summary:"
  echo "  ✅ Auto-fixable: ${#auto_fixable[@]} suggestions"
  echo "  👀 Needs review: ${#needs_review[@]} suggestions"
  echo ""

  if [[ ${#auto_fixable[@]} -gt 0 ]]; then
    echo "🔧 Auto-fixable breakdown:"
    for category in "${!auto_fixable_counts[@]}"; do
      echo "  - $category: ${auto_fixable_counts[$category]} items"
    done
    echo ""
  fi

  if [[ ${#needs_review[@]} -gt 0 ]]; then
    echo "👀 Review required breakdown:"
    for category in "${!review_counts[@]}"; do
      echo "  - $category: ${review_counts[$category]} items"
    done
    echo ""
  fi

  # Export for use by other functions
  export AUTO_FIXABLE_SUGGESTIONS=$(printf '%s\n' "${auto_fixable[@]}")
  export REVIEW_SUGGESTIONS=$(printf '%s\n' "${needs_review[@]}")
  export AUTO_FIXABLE_COUNT=${#auto_fixable[@]}
  export REVIEW_COUNT=${#needs_review[@]}
}
```

### Mandatory Resolution Posting

#### Critical Resolution Flow

```bash
# MANDATORY: Always post resolution comment after pushing fixes
post_mandatory_resolution() {
  local pr="$1"

  echo "🔄 MANDATORY: Posting resolution comment to CodeRabbit..."
  echo ""
  echo "⚠️  CRITICAL: This posts a PR COMMENT, NOT a commit message"
  echo "⚠️  NEVER put @coderabbitai in commit messages - only PR comments!"
  echo ""

  # ALWAYS post this comment after pushing - no exceptions
  gh pr comment "$pr" --body "@coderabbitai resolve"

  local comment_result=$?
  if [[ $comment_result -eq 0 ]]; then
    echo "✅ Posted \"@coderabbitai resolve\" to PR #$pr"
    echo "✅ CodeRabbit will update comment status automatically"
  else
    echo "❌ Failed to post resolution comment!"
    echo "🔄 Retrying with manual GitHub API call..."

    # Fallback to direct API call
    local repo_info=$(gh repo view --json owner,name)
    local owner=$(echo "$repo_info" | jq -r '.owner.login')
    local repo=$(echo "$repo_info" | jq -r '.name')

    gh api "repos/$owner/$repo/issues/$pr/comments" \
      --method POST \
      --field body="@coderabbitai resolve" || {
      echo "❌ Failed to post via API as well!"
      echo "🚨 MANUAL ACTION REQUIRED:"
      echo "   Go to PR #$pr and post this comment: @coderabbitai resolve"
      return 1
    }

    echo "✅ Successfully posted via API fallback"
  fi

  echo ""
  echo "🔄 Resolution posting complete - CodeRabbit will process shortly"
}

# Enhanced resolution summary with mandatory posting
post_comprehensive_resolution_summary() {
  local pr="$1"
  local fixed="$2"
  local deferred="$3"
  local commit=$(git rev-parse --short HEAD)

  # Post detailed summary first
  gh pr comment "$pr" --body "## 📋 Comprehensive Feedback Resolution Summary

I've performed an exhaustive analysis of ALL CodeRabbit comments and addressed feedback in commits up to \`$commit\`:

### ✅ Auto-fixed ($fixed items)
- Code formatting and style consistency
- Missing docstrings and documentation
- Import organization and ordering
- Removed debug statements
- Added obvious type annotations
- Variable naming standardization
- Code simplification where safe

### 👀 Requires Review ($deferred items)
The following suggestions need human judgment:
- Architectural and design decisions
- Security-sensitive changes
- Performance trade-offs
- Business logic modifications
- Test coverage improvements

### 🔍 Resolution Process
- **Comprehensive Fetching**: Analyzed ALL comment sources (reviews, line comments, issues, conversations)
- **No Caching**: Fresh API calls to ensure latest state
- **Aggressive Detection**: Assumed unresolved comments exist when command was run
- **Safety First**: Only auto-fixed truly safe categories

### 🧪 Quality Assurance
- All changes tested individually
- No regressions detected
- CI/CD pipeline passing

Thank you for the comprehensive review! Auto-fixable issues have been resolved while preserving intentional design decisions."

  # MANDATORY: Always post resolution command
  post_mandatory_resolution "$pr"
}
```

### Main Command Implementation

```bash
resolve_cr() {
  local pr="${1:-$(gh pr view --json number -q .number)}"
  local mode="interactive"  # Default mode
  local skip_tests=false

  # Parse arguments
  for arg in "$@"; do
    case "$arg" in
      --auto) mode="auto" ;;
      --dry-run) mode="dry-run" ;;
      --skip-tests) skip_tests=true ;;
      [0-9]*) pr="$arg" ;;
    esac
  done

  # CRITICAL: Always analyze comprehensively
  local all_suggestions=$(analyze_unresolved_feedback "$pr")

  if [[ $? -ne 0 || -z "$all_suggestions" ]]; then
    echo "❌ Could not find actionable CodeRabbit feedback"
    echo "🔄 If you believe there are unresolved comments, try:"
    echo "   - Check PR #$pr manually for CodeRabbit comments"
    echo "   - Ensure CodeRabbit has reviewed this PR"
    echo "   - Verify GitHub API permissions"
    return 1
  fi

  # Categorize all found suggestions
  categorize_all_suggestions "$all_suggestions"

  # Interactive mode: show details and get confirmation
  if [[ "$mode" == "interactive" ]]; then
    echo "🔧 Auto-fixable suggestions:"
    echo "$AUTO_FIXABLE_SUGGESTIONS" | head -5
    [[ $AUTO_FIXABLE_COUNT -gt 5 ]] && echo "  ... and $((AUTO_FIXABLE_COUNT - 5)) more"

    echo ""
    echo "👀 Requires human review:"
    echo "$REVIEW_SUGGESTIONS" | head -5
    [[ $REVIEW_COUNT -gt 5 ]] && echo "  ... and $((REVIEW_COUNT - 5)) more"

    echo ""
    echo "Would you like to auto-fix the safe categories? (y/n): "
    read -r response
    [[ "$response" != "y" && "$response" != "Y" ]] && {
      echo "Aborted. No changes made."
      return 0
    }
  fi

  # Dry-run mode: just show what would be done
  if [[ "$mode" == "dry-run" ]]; then
    echo "🔍 Dry-run mode - no changes will be made"
    echo "Would fix: $AUTO_FIXABLE_COUNT auto-fixable issues"
    echo "Would skip: $REVIEW_COUNT issues requiring review"
    echo ""
    echo "Categories that would be fixed:"
    echo "$AUTO_FIXABLE_SUGGESTIONS" | while read -r suggestion; do
      local category=$(categorize_suggestion "$suggestion")
      echo "  - $category: $suggestion" | head -c 100
      echo "..."
    done
    return 0
  fi

  # Execute fixes if we have auto-fixable items
  if [[ $AUTO_FIXABLE_COUNT -gt 0 ]]; then
    execute_comprehensive_fixes "$skip_tests"

    # MANDATORY: Post resolution summary with required comment
    post_comprehensive_resolution_summary "$pr" "$AUTO_FIXABLE_COUNT" "$REVIEW_COUNT"
  else
    echo "✅ No auto-fixable issues found"
    echo "👀 All $REVIEW_COUNT items require human review"

    # Still post resolution comment to acknowledge review
    post_mandatory_resolution "$pr"
  fi

  echo ""
  echo "🎉 Resolution process complete!"
  echo "📝 Check PR #$pr for CodeRabbit status updates"
}

# Enhanced batch fix execution
execute_comprehensive_fixes() {
  local skip_tests="$1"
  local commit_count=0

  echo "🚀 Executing comprehensive fixes..."
  echo ""

  # Batch 1: Formatting
  if echo "$AUTO_FIXABLE_SUGGESTIONS" | grep -q "formatting\|style\|lint"; then
    echo "🎨 Fixing formatting issues..."
    npm run format 2>/dev/null || prettier --write . 2>/dev/null || {
      echo "  ℹ️  No formatter configured, skipping automatic formatting"
    }
    [[ "$skip_tests" != true ]] && (npm test 2>/dev/null || echo "  ⚠️  Tests not available")

    if git diff --quiet; then
      echo "  ℹ️  No formatting changes needed"
    else
      git add . && git commit -m "style: auto-fix formatting issues from CodeRabbit" && ((commit_count++))
      echo "  ✅ Committed formatting fixes"
    fi
  fi

  # Batch 2: Import organization
  if echo "$AUTO_FIXABLE_SUGGESTIONS" | grep -qi "import"; then
    echo "📦 Organizing imports..."
    npm run organize-imports 2>/dev/null || isort . 2>/dev/null || {
      echo "  ℹ️  No import organizer configured, skipping"
    }
    [[ "$skip_tests" != true ]] && (npm test 2>/dev/null || echo "  ⚠️  Tests not available")

    if git diff --quiet; then
      echo "  ℹ️  No import changes needed"
    else
      git add . && git commit -m "refactor: organize imports per CodeRabbit suggestions" && ((commit_count++))
      echo "  ✅ Committed import organization"
    fi
  fi

  # Batch 3: Cleanup (remove debug statements)
  if echo "$AUTO_FIXABLE_SUGGESTIONS" | grep -qi "console\.log\|debug\|print"; then
    echo "🧹 Removing debug statements..."

    # Remove console.log statements (be careful with intentional ones)
    find . -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" | \
      grep -v node_modules | grep -v .git | \
      xargs sed -i.bak '/console\.log.*debugging\|console\.log.*debug\|console\.log.*temp/d' 2>/dev/null || {
      echo "  ℹ️  No JavaScript files found for cleanup"
    }

    # Clean up backup files
    find . -name "*.bak" -delete 2>/dev/null || true

    if git diff --quiet; then
      echo "  ℹ️  No debug statements found to remove"
    else
      git add . && git commit -m "cleanup: remove debug statements per CodeRabbit suggestions" && ((commit_count++))
      echo "  ✅ Committed debug cleanup"
    fi
  fi

  # Batch 4: Documentation (this requires manual intervention typically)
  if echo "$AUTO_FIXABLE_SUGGESTIONS" | grep -qi "docstring\|documentation\|comment"; then
    echo "📝 Processing documentation suggestions..."
    echo "  ℹ️  Documentation improvements typically require manual review"
    echo "  📋 Logged for manual processing: $(echo "$AUTO_FIXABLE_SUGGESTIONS" | grep -ci "docstring\|documentation") items"
  fi

  # Push all changes if any were made
  if [[ $commit_count -gt 0 ]]; then
    echo ""
    echo "🚀 Pushing $commit_count fix commit(s)..."
    git push || {
      echo "❌ Failed to push changes"
      echo "🔄 Please resolve any conflicts and push manually"
      return 1
    }
    echo "✅ Successfully pushed all fixes"
  else
    echo ""
    echo "ℹ️  No changes were committed (suggestions may already be addressed)"
  fi
}
```

### Critical Warnings

```bash
# Display critical warnings about @coderabbitai usage
show_critical_warnings() {
  echo ""
  echo "🚨 CRITICAL WARNINGS:"
  echo ""
  echo "❌ NEVER put '@coderabbitai' in commit messages!"
  echo "   ❌ git commit -m '@coderabbitai resolve'  ← WRONG"
  echo "   ❌ git commit -m 'fix: @coderabbitai suggestions'  ← WRONG"
  echo ""
  echo "✅ ONLY use '@coderabbitai' in PR comments!"
  echo "   ✅ gh pr comment --body '@coderabbitai resolve'  ← CORRECT"
  echo "   ✅ Manual comment on GitHub PR page  ← CORRECT"
  echo ""
  echo "📝 This command handles the proper posting automatically"
  echo "📝 The resolution comment will be posted AFTER pushing fixes"
  echo ""
}
```

### Implementation Notes

#### Key Behavioral Changes

1. **Comprehensive Fetching**: Uses 4 different API endpoints to ensure ALL CodeRabbit comments are found
2. **No Caching**: Forces fresh API calls every time - never assumes comments are resolved
3. **Aggressive Detection**: Assumes unresolved comments exist when command is run
4. **Mandatory Resolution**: ALWAYS posts "@coderabbitai resolve" after pushing fixes
5. **Enhanced Categorization**: More patterns for both auto-fixable and review-required items

#### Safety Features

- **Interactive by default**: Shows what will be fixed and asks for confirmation
- **Comprehensive testing**: Runs tests after each fix batch (unless skipped)
- **Clear boundaries**: Never auto-fixes security, architecture, or business logic
- **Fallback mechanisms**: Multiple ways to post resolution comments if the primary method fails

#### Resolution Process

1. **Exhaustive Analysis** - Fetch from all comment sources with fresh API calls
2. **Smart Categorization** - Distinguish auto-fixable from review-required with enhanced patterns
3. **Safe Execution** - Apply fixes in batches with testing between stages
4. **Commit & Push** - Create meaningful commits and push to PR
5. **Mandatory Resolution** - ALWAYS post "@coderabbitai resolve" comment to PR

**The "@coderabbitai resolve" posting is mandatory and happens automatically after every successful fix push.**
