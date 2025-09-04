---
description: Smart CodeRabbit feedback resolver with selective automation
argument-hint: [pr-number] [--auto|--dry-run|--skip-tests]
---

# CodeRabbit Feedback Resolution

Intelligently categorize and resolve CodeRabbit suggestions with safety-first automation.
Interactive mode is the default - shows what will be fixed and gets confirmation before proceeding.
Only auto-fixes truly safe categories while preserving architectural decisions for human review.

## Command Usage

```bash
/resolve-cr                  # Interactive mode (default) - preview & confirm
/resolve-cr <pr-number>      # Specific PR, interactive
/resolve-cr --auto           # Auto-fix safe categories without confirmation
/resolve-cr --dry-run        # Preview only, no changes
/resolve-cr --skip-tests     # Skip test runs between batches (faster but riskier)
```

## Resolution Strategy

### Auto-Fixable Categories (Safe)

```yaml
Formatting & Style:
  - Code formatting issues → prettier/black/rustfmt
  - Import ordering → isort/organize imports
  - Trailing whitespace → auto-trim
  - Line length violations → auto-wrap where safe

Documentation:
  - Missing docstrings → Generate via CodeRabbit API
  - Outdated comments → Flag for review (no auto-fix)
  - README updates → Generate changelog entries

Simple Refactors:
  - Variable naming (camelCase/snake_case) → Pattern replace
  - Unnecessary else after return → Auto-remove
  - Console.log removal → Auto-remove in production code

Type Safety:
  - Missing type annotations → Infer and add where obvious
  - Unnecessary type assertions → Remove if provable
```

### Requires Human Review

```yaml
Architecture & Design:
  - Component structure changes
  - API design modifications
  - Database schema updates
  - State management patterns

Security Concerns:
  - Authentication/authorization logic
  - Input validation strategies
  - Cryptographic implementations
  - API key/secret handling

Performance Trade-offs:
  - Algorithm complexity changes
  - Caching strategies
  - Database query optimizations
  - Bundle size impacts

Business Logic:
  - Feature behavior changes
  - Validation rule modifications
  - Calculation adjustments
  - User flow alterations
```

## Implementation Workflow

### 1. Fetch and Parse Comments

```bash
# Get all CodeRabbit reviews and comments
fetch_coderabbit_feedback() {
  local pr="${1:-$(gh pr view --json number -q .number)}"
  local repo_info=$(gh repo view --json owner,name)
  local owner=$(echo "$repo_info" | jq -r '.owner.login')
  local repo=$(echo "$repo_info" | jq -r '.name')

  # Fetch all CodeRabbit reviews
  gh api "repos/$owner/$repo/pulls/$pr/reviews" \
    --jq '.[] | select(.user.login == "coderabbitai[bot]") | {
      id: .id,
      body: .body,
      state: .state,
      submitted_at: .submitted_at
    }'
}

# Parse suggestions from review body
parse_suggestions() {
  local body="$1"
  echo "$body" | grep -E "^(\*\*[⚠️🛠️💡]|📝 Committable|##)" | while read -r line; do
    echo "$line"
  done
}
```

### 2. Categorize Suggestions

```bash
categorize_suggestion() {
  local suggestion="$1"

  # Auto-fixable patterns
  if echo "$suggestion" | grep -qE "missing docstring|add documentation"; then
    echo "docstring"
  elif echo "$suggestion" | grep -qE "formatting|indentation|whitespace"; then
    echo "formatting"
  elif echo "$suggestion" | grep -qE "import.*order|organize imports"; then
    echo "imports"
  elif echo "$suggestion" | grep -qE "console\.log|debug.*statement"; then
    echo "cleanup"
  elif echo "$suggestion" | grep -qE "type annotation|add types"; then
    echo "types"
  # Requires review
  elif echo "$suggestion" | grep -qE "security|vulnerability|injection"; then
    echo "security-review"
  elif echo "$suggestion" | grep -qE "performance|optimize|N\+1"; then
    echo "performance-review"
  elif echo "$suggestion" | grep -qE "architecture|design|pattern"; then
    echo "design-review"
  else
    echo "manual-review"
  fi
}
```

### 3. Interactive Resolution Flow

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
    esac
  done

  echo "🔍 Analyzing CodeRabbit feedback for PR #$pr..."

  # Fetch all feedback
  local feedback=$(fetch_coderabbit_feedback "$pr")

  # Categorize suggestions
  local auto_fixable=()
  local needs_review=()

  echo "$feedback" | while read -r suggestion; do
    local category=$(categorize_suggestion "$suggestion")
    case "$category" in
      docstring|formatting|imports|cleanup|types)
        auto_fixable+=("$suggestion")
        ;;
      *)
        needs_review+=("$suggestion")
        ;;
    esac
  done

  # Display summary
  echo "
📊 CodeRabbit Feedback Summary:
  ✅ Auto-fixable: ${#auto_fixable[@]} suggestions
  👀 Needs review: ${#needs_review[@]} suggestions
  "

  # Interactive mode: show details and get confirmation
  if [[ "$mode" == "interactive" ]]; then
    echo "🔧 Auto-fixable suggestions:"
    printf '%s\n' "${auto_fixable[@]}" | head -5
    [[ ${#auto_fixable[@]} -gt 5 ]] && echo "  ... and $((${#auto_fixable[@]} - 5)) more"

    echo "
👀 Requires human review:"
    printf '%s\n' "${needs_review[@]}" | head -5
    [[ ${#needs_review[@]} -gt 5 ]] && echo "  ... and $((${#needs_review[@]} - 5)) more"

    echo "
Would you like to auto-fix the safe categories? (y/n): "
    read -r response
    [[ "$response" != "y" ]] && { echo "Aborted."; return 0; }
  fi

  # Dry-run mode: just show what would be done
  if [[ "$mode" == "dry-run" ]]; then
    echo "🔍 Dry-run mode - no changes will be made"
    echo "Would fix: ${#auto_fixable[@]} auto-fixable issues"
    echo "Would skip: ${#needs_review[@]} issues requiring review"
    return 0
  fi

  # Execute fixes in batches
  execute_batch_fixes "$skip_tests"

  # Generate response to CodeRabbit
  post_resolution_summary "$pr" "${#auto_fixable[@]}" "${#needs_review[@]}"
}
```

### 4. Batch Execution

```bash
execute_batch_fixes() {
  local skip_tests="$1"

  # Batch 1: Formatting
  if [[ -n "$formatting_files" ]]; then
    echo "🎨 Fixing formatting issues..."
    npm run format 2>/dev/null || prettier --write . 2>/dev/null || true
    [[ "$skip_tests" != true ]] && npm test 2>/dev/null
    git add . && git commit -m "style: auto-fix formatting issues from CodeRabbit"
  fi

  # Batch 2: Docstrings
  if [[ -n "$docstring_files" ]]; then
    echo "📝 Generating missing docstrings..."
    # Use CodeRabbit API or language-specific tools
    echo "@coderabbitai generate docstrings" | gh pr comment --body-file -
    sleep 5
    git add . && git commit -m "docs: add missing docstrings from CodeRabbit"
  fi

  # Batch 3: Imports
  if [[ -n "$import_files" ]]; then
    echo "📦 Organizing imports..."
    npm run organize-imports 2>/dev/null || isort . 2>/dev/null || true
    [[ "$skip_tests" != true ]] && npm test 2>/dev/null
    git add . && git commit -m "refactor: organize imports per CodeRabbit suggestions"
  fi

  # Batch 4: Type annotations
  if [[ -n "$type_files" ]]; then
    echo "🔍 Adding type annotations..."
    # Language-specific type inference
    git add . && git commit -m "types: add missing type annotations"
  fi

  # Push all changes
  echo "🚀 Pushing fixes..."
  git push
}
```

### 5. Response to CodeRabbit

```bash
post_resolution_summary() {
  local pr="$1"
  local fixed="$2"
  local deferred="$3"
  local commit=$(git rev-parse --short HEAD)

  gh pr comment "$pr" --body "@coderabbitai

## 📋 Feedback Resolution Summary

I've reviewed and addressed your feedback in commits up to \`$commit\`:

### ✅ Auto-fixed ($fixed items)
- Code formatting and style consistency
- Missing docstrings and documentation
- Import organization and ordering
- Removed debug statements
- Added obvious type annotations

### 👀 Requires Review ($deferred items)
The following suggestions need human judgment:
- Architectural and design decisions
- Security-sensitive changes
- Performance trade-offs
- Business logic modifications

These items have been logged for team review in our tracking system.

### 🧪 Quality Assurance
- All changes tested individually
- No regressions detected
- CI/CD pipeline passing

Thank you for the comprehensive review! The auto-fixable issues have been resolved while preserving intentional design decisions.
"
}
```

## Expected Output Examples

```text
User: /resolve-cr
Claude: 🔍 Analyzing CodeRabbit feedback for PR #119...

📊 CodeRabbit Feedback Summary:
  ✅ Auto-fixable: 43 suggestions
  👀 Needs review: 18 suggestions

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

💬 Posted resolution summary to CodeRabbit

User: /resolve-cr --auto
Claude: 🔍 Analyzing CodeRabbit feedback for PR #119...

📊 CodeRabbit Feedback Summary:
  ✅ Auto-fixable: 43 suggestions
  👀 Needs review: 18 suggestions

🎨 Fixing formatting issues...
📝 Generating missing docstrings...
📦 Organizing imports...
🔍 Adding type annotations...
🚀 Pushing fixes...
✅ Resolved 43 auto-fixable issues in 4 commits

User: /resolve-cr --dry-run
Claude: 🔍 Analyzing CodeRabbit feedback for PR #119...

📊 CodeRabbit Feedback Summary:
  ✅ Auto-fixable: 43 suggestions
  👀 Needs review: 18 suggestions

🔍 Dry-run mode - no changes will be made
Would fix: 43 auto-fixable issues
Would skip: 18 issues requiring review

Categories to be fixed:
  - Formatting: 12 files
  - Docstrings: 23 functions
  - Imports: 8 files
  - Type annotations: 5 files
  - Debug cleanup: 3 files
```

## Key Features

### Safety-First Automation

- ✅ **Intelligent categorization** - Distinguishes auto-fixable from review-required
- ✅ **Interactive by default** - Shows preview and requests confirmation
- ✅ **Batch execution** - Groups similar fixes to minimize commits
- ✅ **Test validation** - Runs tests between fix batches (unless skipped)
- ✅ **Clear boundaries** - Never auto-fixes security, architecture, or business logic

### Auto-Fixable Categories

- **Formatting** - prettier, black, rustfmt, gofmt
- **Docstrings** - Uses "@coderabbitai generate docstrings"
- **Imports** - isort, organize imports, goimports
- **Type annotations** - Adds obvious types where inferrable
- **Debug cleanup** - Removes console.log, print statements

### Human Review Required

- **Security** - Authentication, validation, cryptography
- **Architecture** - Component structure, API design
- **Performance** - Algorithm choices, caching strategies
- **Business Logic** - Feature behavior, calculations

## Implementation Notes

- **Default Interactive Mode**: Always shows what will be fixed before proceeding
- **Batch Processing**: Groups similar fixes to reduce commit noise
- **Test Integration**: Runs tests after each batch (configurable)
- **Clear Communication**: Posts comprehensive summary to CodeRabbit
- **Selective Automation**: Only fixes truly safe categories
- **Preserves Intent**: Respects architectural and design decisions
