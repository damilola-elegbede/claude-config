---
description: Code review with linting and security scanning
argument-hint: [--full|--fix|--quick|file-path]
---

# /review Command

## Usage

```bash
/review                    # Review changed files (default)
/review --full             # Review entire codebase
/review --fix              # Auto-fix issues and commit
/review --quick            # Linter-only mode (fast)
/review <file|directory>   # Review specific target
```

## Description

Comprehensive code review combining automated linting and AI analysis. Catches issues before external review.

## Behavior

1. **Lint**: Run automated linters (ESLint, Prettier, ruff, etc.)
2. **Analyze**: Deploy code-reviewer agent for deep analysis
3. **Report**: Present findings with actionable recommendations
4. **Fix** (with --fix): Auto-apply safe fixes and commit

### Review Modes

| Mode | Duration | Scope |
|------|----------|-------|
| Default | 2-5 min | Changed files |
| `--full` | 5-15 min | All files |
| `--fix` | 2-5 min | Auto-fix + commit |
| `--quick` | 30-60s | Linting only |

## Expected Output

```text
User: /review

🔍 Reviewing changed files...

Phase 1: Automated Linting
  ✅ ESLint: 0 issues
  ✅ Prettier: formatted
  ⚠️ TypeScript: 2 warnings

Phase 2: AI Analysis (code-reviewer)
  Analyzing 3 files...

📊 Review Results:

| Issue | Severity | Location | Recommendation |
|-------|----------|----------|----------------|
| Missing error handling | High | auth.ts:45 | Yes ✓ |
| Unused import | Low | utils.ts:3 | Yes ✓ |

Summary: 2 issues found (1 High, 1 Low)

💡 Run `/review --fix` to auto-apply recommended fixes
```

### Auto-Fix Mode

```text
User: /review --fix

[Review runs...]

✅ Applied 2 fixes:
  - Added error handling in auth.ts
  - Removed unused import in utils.ts

📦 Committed: fix: resolve review issues (2 fixes)
```

## Notes

- Uses code-reviewer agent for AI analysis
- Includes accessibility checks (WCAG compliance)
- Default mode requires approval before fixes
- `--fix` auto-applies safe recommendations
- Typical execution: 2-5 minutes
