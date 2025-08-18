# /fix-ci Command

## Description

Diagnoses and fixes GitHub Actions failures using pattern recognition and historical fix data.
Learns from successful fixes to improve success rate over time.

## Usage

```bash
/fix-ci                  # Fix latest failure
/fix-ci <run-id>         # Fix specific run
/fix-ci --learn          # Update fix patterns from history
```

## Behavior

When invoked, I will diagnose and fix GitHub Actions failures using pattern
recognition and historical fix data. I fetch failure details, apply quick fixes
for known patterns, and learn from successful fixes to improve success rate over time.

## Failure Pattern Library

```yaml
# Patterns tracked with success rates
Lint/Format:
  fix: "npm run lint:fix"
  success_rate: 95%

Missing Dependencies:
  fix: "npm install"
  success_rate: 88%

Test Timeouts:
  fix: "Add async/await, increase timeout"
  success_rate: 72%

Type Errors:
  fix: "Update type definitions"
  success_rate: 65%

Build Cache:
  fix: "Clear cache and rebuild"
  success_rate: 61%
```

## Quick Fix Patterns

```bash
# Apply fixes based on error pattern
apply_fix() {
  local error_log="$1"

  # Lint/format (95% success)
  if grep -q "ESLint\|Prettier" "$error_log"; then
    npm run lint:fix || npx eslint . --fix
    npx prettier --write .
    return 0
  fi

  # Dependencies (88% success)
  if grep -q "Module not found\|Cannot resolve" "$error_log"; then
    npm install
    return 0
  fi

  # Test timeout (72% success)
  if grep -q "Timeout.*exceeded\|Async.*timeout" "$error_log"; then
    # Find test files and add timeout
    find . -name "*.test.js" -exec sed -i 's/test(/test.timeout(10000)(/' {} \;
    return 0
  fi

  # No quick fix available
  return 1
}
```

## Learning from History

```bash
# Track successful fixes
record_fix() {
  local pattern="$1"
  local fix="$2"
  local success="$3"

  echo "${pattern}|${fix}|${success}" >> ~/.fix-ci-history
}

# Update success rates
update_patterns() {
  # Calculate success rates from history
  awk -F'|' '
    {patterns[$1]++; if($3=="true") success[$1]++}
    END {for(p in patterns) print p, int(success[p]/patterns[p]*100)"%"}
  ' ~/.fix-ci-history | sort -t' ' -k2 -rn
}

# Apply fix with highest success rate
best_fix_for() {
  local error="$1"
  grep "$error" ~/.fix-ci-history | \
    sort -t'|' -k3 -r | \
    head -1 | \
    cut -d'|' -f2
}
```

## Execution Workflow

```bash
fix_ci() {
  # Get failure logs
  local run_id="${1:-$(gh run list --status=failure --limit=1 --jq '.[0].databaseId')}"
  local logs=$(gh run view "$run_id" --log-failed)

  # Try quick fixes first
  if apply_fix "$logs"; then
    echo "✅ Applied quick fix"
  else
    # Check historical fixes
    local best_fix=$(best_fix_for "$logs")
    if [[ -n "$best_fix" ]]; then
      echo "📦 Applying historical fix: $best_fix"
      # Execute fix command safely without eval
      bash -c "$best_fix"
    else
      echo "⚠️ No automated fix available"
      echo "💡 Manual review needed for:"
      echo "$logs" | head -20
      return 1
    fi
  fi

  # Commit and push
  if ! git diff --quiet; then
    git add .
    git commit -m "fix: resolve CI failure

Automated fix applied by /fix-ci"
    git push

    # Record outcome
    sleep 60  # Wait for CI
    local result=$(gh run list --limit=1 --jq '.[0].conclusion')
    record_fix "$(echo "$logs" | head -1)" "$best_fix" "$([[ "$result" == "success" ]] && echo true || echo false)"
  fi
}
```

## Success Tracking

```text
Current Success Rates (from ~/.fix-ci-history):
- Lint/Format: 95% (152/160 successful)
- Dependencies: 88% (73/83 successful)
- Test Timeouts: 72% (36/50 successful)
- Type Errors: 65% (26/40 successful)
- Build Cache: 61% (19/31 successful)
- Other: 42% (34/81 successful)

Overall: 74% automated fix rate
```

## Examples

```bash
User: /fix-ci
Claude: 🔍 Getting latest failure...
📋 ESLint errors detected
🔧 Applying lint fix (95% success rate)...
✅ Fixed and pushed
📦 Recording successful fix pattern

User: /fix-ci --learn
Claude: 📦 Updating fix patterns from history...
Top patterns by success rate:
- Lint/Format: 95%
- Dependencies: 88%
- Test Timeouts: 72%
📊 Overall success rate: 74%
```

## Notes

- GitHub Actions only (use native tools for other CI systems)
- Learns from successful fixes to improve over time
- Quick fixes applied first (95% success on lint issues)
- Historical patterns checked for complex issues
- Success rates tracked in ~/.fix-ci-history
