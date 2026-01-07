---
description: Diagnoses and fixes GitHub Actions CI failures
argument-hint: [run-id|--learn]
---

# /fix-ci Command

## Usage

```bash
/fix-ci              # Fix latest failure
/fix-ci 12345678     # Fix specific run
/fix-ci --learn      # Show historical fix patterns
```

## Description

Diagnose and fix GitHub Actions failures. Fetches failure data from GitHub API, deploys devops agent to fix, then verifies CI passes.

## Behavior

1. **Fetch**: Get failure details from GitHub Actions API
2. **Analyze**: Deploy devops agent to diagnose issues
3. **Fix**: Apply fixes based on analysis
4. **Verify**: Push and monitor CI until green

### Iterative Resolution

If CI still fails after fix, the process repeats with new failure data until all checks pass.

## Expected Output

```text
User: /fix-ci

🔍 Fetching CI failures from run #987654...
📊 Found 3 failures: lint, test:unit, build

Deploying devops agent...

🔧 Fixes Applied:
  - Fixed ESLint violations in auth.ts
  - Updated test mock for new API response
  - Added missing dependency to package.json

💾 Committed and pushed...

📊 Monitoring CI run #987655...
⏳ Running... (2 min)

✅ All CI checks passed!
🎉 CI fixed in 1 iteration
```

### Multiple Iterations

```text
📊 CI run #987655 still failing (1 remaining)
🔄 Iteration 2: Fetching new failures...

🔧 Additional Fix:
  - Fixed race condition in async test

📊 Monitoring CI run #987656...
✅ All CI checks passed!
🎉 CI fixed in 2 iterations
```

### Learn Mode

```text
User: /fix-ci --learn

📊 Historical Fix Patterns:
  Lint/Format: 98% success (47/48)
  Dependencies: 92% success (23/25)
  Test Failures: 85% success (17/20)
```

## Notes

- Uses devops agent for CI/CD expertise
- Monitors real CI runs, not just local tests
- Continues until GitHub shows green
- Typical execution: 3-10 minutes
