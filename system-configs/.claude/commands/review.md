---
description: Code review with linting and security scanning
argument-hint: [--full|--fix|--quick|--coderabbit|--no-coderabbit|file-path]
---

# /review Command

## Usage

```bash
/review                    # Review changed files (default)
/review --full             # Review entire codebase
/review --fix              # Auto-fix issues and commit
/review --quick            # Linter-only mode (fast)
/review --coderabbit       # CodeRabbit only (skip internal agent)
/review --no-coderabbit    # Internal agent only (skip CodeRabbit)
/review <file|directory>   # Review specific target
```

## Description

Comprehensive code review combining CodeRabbit CLI, automated linting, and AI analysis. Catches issues before external review.

## Behavior

### Flag Semantics

| Flag | Phase 0 (CodeRabbit) | Phases 1-3 (Lint/Analyze/Report) |
|------|----------------------|----------------------------------|
| (default) | Runs if CLI available | All run |
| `--coderabbit` | Runs | Skipped (CodeRabbit-only) |
| `--no-coderabbit` | Skipped | All run (internal agent only) |

### Phases

0. **CodeRabbit Analysis** (when CLI available and not --no-coderabbit):
   - Delegate to `/resolve-cr --local` for interactive triage
   - Uses interactive approval flow (never auto-commits without consent)
   - Ignored issues stored in `.tmp/coderabbit-ignored.json` for PR acknowledgment via `/ship-it`

1. **Lint**: Run automated linters (ESLint, Prettier, ruff, etc.)
2. **Analyze**: Deploy code-reviewer agent for deep analysis (skipped if `--coderabbit` flag used)
3. **Report**: Present combined findings with actionable recommendations
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

Phase 0: CodeRabbit Analysis
  Delegating to /resolve-cr --local...
  [Interactive triage - see /resolve-cr for details]
  ✅ Fixed 2 issues, documented 1 for PR acknowledgment
     (Saved to .tmp/coderabbit-ignored.json → posted by /ship-it)

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

- **CodeRabbit**: Runs first when CLI is installed (`coderabbit auth login` to set up)
- Uses code-reviewer agent for deeper AI analysis after CodeRabbit
- Includes accessibility checks (WCAG compliance)
- Default mode requires approval before fixes
- `--fix` auto-applies safe recommendations
- Typical execution: 2-5 minutes (longer with CodeRabbit)

### CodeRabbit Setup

```bash
# Install CLI
curl -fsSL https://cli.coderabbit.ai/install.sh | sh

# Authenticate
coderabbit auth login

# Verify
coderabbit auth status
```

Free tier: 1 review/hour. Pro tier: 5 reviews/hour with enhanced analysis.
