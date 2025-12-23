---
description: AI-powered code review matching CodeRabbit quality
argument-hint: [--full|--fix|--report-only|--security|--quick|file-path]
thinking-level: megathink
thinking-tokens: 10000
---

# /review Command

## Usage

```bash
/review                          # Review changed files + interactive resolution (default)
/review --full                   # Review ENTIRE codebase (all files, not just changes)
/review --fix                    # Auto-fix recommended issues + commit (no approval)
/review --report-only            # Report only, no resolution phase
/review --quick                  # Linter-only mode (fast, no AI)
/review <file|directory>         # Review specific target
/review --security               # Security-focused analysis
/review --full --fix             # Full codebase audit with auto-fix
```

## Description

Comprehensive code review system designed to match or exceed CodeRabbit quality. Combines configuration integrity
validation, automated linting, and mandatory AI-powered deep analysis to catch issues BEFORE external review.

**Philosophy**: Catch everything locally so CodeRabbit reviews are mostly approvals.

### Thinking Level: MEGATHINK (10,000 tokens)

Required for multi-phase orchestration: evaluating issues across 9 phases, coordinating parallel agent deployment,
generating structured evaluation tables, and managing interactive approval workflows with complex branching logic.

## Review Modes

| Mode | Duration | Scope | Phases | Use Case |
|------|----------|-------|--------|----------|
| Default | 3-8 min | Changed files | All 9 phases | Review + interactive resolution |
| `--full` | 10-30 min | All files | All 9 phases | Comprehensive codebase audit |
| `--fix` | 2-5 min | Changed files | All 9 (auto) | Auto-fix + commit (no approval) |
| `--report-only` | 2-5 min | Changed files | Phases 0-6 | Report only, no resolution |
| `--quick` | 30-60s | Changed files | Linting only | Fast linter checks |
| `--security` | 3-5 min | Changed files | + security-auditor | Security focus |

**Flag combinations**: `--full --fix` reviews entire codebase and auto-fixes all recommended issues.

## Behavior

### Phase 0: Configuration Integrity Checks

Run validation scripts before code analysis:

```bash
python scripts/test-config-integrity.py    # Counts, orphans, YAML
python scripts/validate-agent-yaml.py       # Agent validation
python scripts/check-orphans.py             # Orphan references
./scripts/validate-markdown-quality.sh      # Markdown quality
```

### Phase 1: Detect Changed Files

```bash
git diff --name-only main...HEAD
```

### Phase 2: Path-Based Validation

| Path Pattern | Validations |
|--------------|-------------|
| `agents/*.md` | YAML fields, SYSTEM BOUNDARY, required sections |
| `commands/*.md` | YAML fields, Usage/Description sections |
| `docs/**/*.md` | Markdownlint, cross-references |
| `scripts/*.py` | Ruff/Pylint, UTF-8 encoding |
| `scripts/*.sh` | ShellCheck, pipefail |

### Phase 3: Run Automated Linters

Parallel execution by language: ESLint, Prettier, TypeScript, Ruff, Pylint, Bandit, golangci-lint, markdownlint,
ShellCheck, Semgrep. Skip unavailable tools gracefully.

### Phase 4: AI Deep Analysis (MANDATORY)

**Wave 1: Foundation Analysis (Always, Parallel)**

| Agent | Focus |
|-------|-------|
| code-reviewer | SOLID, DRY, error handling, naming, patterns |
| codebase-analyst | Cross-file impact, architectural drift, breaking changes |

**Wave 2: Specialized Analysis (Conditional)**

| Trigger | Agent | Checks |
|---------|-------|--------|
| Security/API files | security-auditor | Injection, auth flaws, OWASP |
| Backend code | performance-engineer | Race conditions, memory leaks, N+1 |
| SQL/migrations | database-admin | Query optimization, transactions |
| Components | frontend-engineer | State management, accessibility |
| Routes/API | api-architect | API design, breaking changes |

### Phase 5: CodeRabbit Checklist Verification

Verify items from `docs/quality/CODERABBIT_PRECOMMIT_CHECKLIST.md`:

- Documentation consistency (paths, counts, cross-refs)
- YAML quality (required fields, format, no deprecated)
- Agent compliance (31 agents, 21 commands, boundaries)
- Structural patterns (naming, templates)

### Phase 6: Report Generation

```markdown
## AI Deep Analysis Report

### Review Summary
- Files Analyzed: {count}
- Agents Deployed: {list}
- Issues: {critical} Critical, {high} High, {medium} Medium

### Issues by Severity
| ID | Issue | Location | Agent | Severity |
|----|-------|----------|-------|----------|

### Prompts for AI Agents
1. **Fix Critical: {issue}**
   {actionable prompt}

### Configuration Integrity Summary
- Agent count: {n}/31, Command count: {n}/21
- YAML validation: {status}, Orphans: {count}
```

### Phase 7: Issue Evaluation and Agent Assignment

For each issue from Phase 6, evaluate:

| Evaluation Criteria | Description |
|---------------------|-------------|
| **Actionability** | Can this be fixed automatically or requires human judgment? |
| **Severity** | Critical, High, Medium, Low, Info |
| **Recommendation** | Yes (safe to fix), No (skip), Maybe (needs review) |
| **Agent Assignment** | code-reviewer, tech-writer, test-engineer, security-auditor, or manual |

**Agent Assignment Matrix:**

| Issue Type | Assigned Agent | Examples |
|------------|----------------|----------|
| Code quality, SOLID, DRY | code-reviewer | Missing error handling, code duplication |
| Documentation | tech-writer | Missing docstrings, outdated README |
| Missing tests | test-engineer | Uncovered code paths |
| Security vulnerabilities | security-auditor | Injection risks, auth flaws |
| Performance issues | performance-engineer | N+1 queries, memory leaks |
| Architecture decisions | manual | Design patterns, breaking changes |

### Phase 8: Interactive Resolution (MANDATORY PAUSE)

Present evaluation table to user:

```text
📊 Review Issue Evaluation

┌────┬─────────────────────────────────────────┬──────────┬────────────────┬────────────────┬──────────────┐
│ ID │ Issue                                   │ Severity │ Recommendation │ Assigned Agent │ Location     │
├────┼─────────────────────────────────────────┼──────────┼────────────────┼────────────────┼──────────────┤
│ 1  │ Missing error handling in auth()        │ High     │ Yes ✓          │ code-reviewer  │ auth.ts:45   │
│ 2  │ Add docstring for getUserData()         │ Medium   │ Yes ✓          │ tech-writer    │ api.ts:128   │
│ 3  │ Extract magic number to constant        │ Medium   │ Yes ✓          │ code-reviewer  │ calc.ts:67   │
│ 4  │ Consider async/await refactoring        │ Info     │ Maybe ?        │ manual         │ db.ts:203    │
│ 5  │ Add unit tests for payment flow         │ High     │ Yes ✓          │ test-engineer  │ payment.ts   │
└────┴─────────────────────────────────────────┴──────────┴────────────────┴────────────────┴──────────────┘

Legend: ✓ = Safe to auto-fix, ? = Needs human review

Summary:
  ✅ Recommended: 4 issues (2 High, 2 Medium)
  ❓ Manual review: 1 issue (architecture decision)

Options:
  [a] Approve all recommended fixes (4 issues)
  [s] Select specific issues to fix
  [v] View detailed analysis
  [n] Skip all fixes
```

**MANDATORY**: Use `AskUserQuestion` tool to present options and wait for user selection.
NEVER proceed to Phase 9 without explicit user approval.

**Auto Mode (`--fix`):**

- Skip approval step
- Automatically fix all "Yes ✓" recommendations
- Useful for CI/CD integration and trusted reviews

**Report-Only Mode (`--report-only`):**

- Skip Phases 7-9 entirely
- End after Phase 6 report generation
- Useful for assessment without fixes

### Phase 9: Parallel Fix Deployment and Verification

Deploy specialized agents in parallel to implement approved fixes:

**Deployment Strategy:**

Group approved fixes by agent type and deploy simultaneously:

```yaml
Parallel Deployment Example:
  code-reviewer:
    - instance_1: Fix error handling (issue #1) - auth.ts:45
    - instance_2: Extract magic number (issue #3) - calc.ts:67

  tech-writer:
    - instance_1: Add getUserData docstring (issue #2) - api.ts:128

  test-engineer:
    - instance_1: Add payment unit tests (issue #5) - payment.ts
```

**Verification Process:**

1. Confirm all approved fixes are reflected in git diff
2. Run linters to verify no new issues introduced
3. Run test suite if applicable
4. Ensure no conflicts between parallel agent changes

**Commit Strategy (when fixes applied):**

```text
fix: resolve review issues (4 fixes)

- Fixed auth error handling (High)
- Added getUserData docstring (Medium)
- Extracted MAX_RETRIES constant (Medium)
- Added payment unit tests (High)

Skipped: 1 issue (architecture decision - manual review)

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>
```

## Expected Output

### Default Mode (Interactive Resolution)

```text
User: /review
Claude: Starting comprehensive review with resolution...

Phase 0: Configuration Integrity - Passed
Phase 1: Changed Files (3 files)
Phase 2: Path-Based Validation - Passed
Phase 3: Linters - 0 issues
Phase 4: AI Deep Analysis
  Wave 1: code-reviewer + codebase-analyst (45s)
Phase 5: CodeRabbit Checklist - 100% passed
Phase 6: Report Generated

Phase 7: Evaluating issues for resolution...
  4 issues suitable for auto-fix
  1 issue requires manual review

📊 Review Issue Evaluation

[Evaluation table displayed]

Options:
  [a] Approve all recommended fixes (4 issues)
  [s] Select specific issues to fix
  [v] View detailed analysis
  [n] Skip all fixes

Your choice: a

✅ Approved 4 fixes

Phase 8: Deploying fix agents...
  ✅ Fixed error handling in auth.ts (1.2s)
  ✅ Added docstring in api.ts (0.8s)
  ✅ Extracted constant in calc.ts (0.5s)
  ✅ Added payment tests (2.1s)

Phase 9: Verification
  ✅ Linters passing
  ✅ Tests passing
  ✅ No conflicts detected

📦 Committed: fix: resolve review issues (4 fixes)

🎉 Successfully resolved 4 of 5 issues
   1 issue deferred for manual review
```

### Auto-Fix Mode (`--fix`)

```text
User: /review --fix
Claude: Starting comprehensive review with auto-resolution...

[Phases 0-6 execute normally]

Phase 7: Evaluating issues for resolution...
  4 issues suitable for auto-fix

⚡ Auto-fix mode: Skipping approval

Phase 8: Deploying fix agents in parallel...
  ✅ Fixed error handling in auth.ts
  ✅ Added docstring in api.ts
  ✅ Extracted constant in calc.ts
  ✅ Added payment tests

Phase 9: Verification
  ✅ All checks passing

📦 Committed: fix: resolve review issues (4 fixes)

🎉 Auto-fixed 4 issues successfully
```

### Report-Only Mode (`--report-only`)

```text
User: /review --report-only
Claude: Starting comprehensive review (report only)...

Phase 0: Configuration Integrity - Passed
Phase 1: Changed Files (3 files)
Phase 2: Path-Based Validation - Passed
Phase 3: Linters - 0 issues
Phase 4: AI Deep Analysis
  Wave 1: code-reviewer + codebase-analyst (45s)
Phase 5: CodeRabbit Checklist - 100% passed
Phase 6: Report
  Issues: 0 Critical, 1 High, 2 Medium

  Prompts for AI Agents:
  1. Fix High: Add error handling in review.md:45

Review complete - 1 high priority issue to address
(Use /review to enter interactive resolution mode)
```

## Quality Standards

**What This Review Catches:**

- **Configuration**: Count mismatches, orphan refs, YAML errors, deprecated fields
- **Documentation**: Path errors, count inconsistencies, broken cross-refs
- **Code Quality**: SOLID/DRY violations, error handling gaps, complexity
- **Architecture**: Cross-file impact, breaking changes, technical debt
- **Security**: Injection, auth flaws, secrets exposure
- **Performance**: Race conditions, memory leaks, N+1 queries

## Implementation Notes

**For Claude:**

- In default mode: Use `AskUserQuestion` tool after displaying evaluation table in Phase 8
- In `--fix` mode: Skip user approval, auto-approve all "Yes ✓" recommendations
- In `--report-only` mode: Stop after Phase 6, do not enter resolution phases
- Deploy fix agents in parallel using Task tool (one Task call per agent instance)
- Store intermediate state in `.tmp/review-<timestamp>/` directory
- Execute phases sequentially with clear progress indicators

**Agent Deployment Rules:**

- Group fixes by agent type for efficient parallel deployment
- Each agent instance receives specific issue context and file location
- Maximum 5 concurrent agent instances to avoid resource contention
- Verify no conflicts between parallel agent changes before commit

**Error Handling:**

- If any fix agent fails: Report failure, continue with other agents
- If verification fails: Do not commit, report issues
- If all agents succeed: Create consolidated commit

**Interactive Mode Handling:**

- Option [a]: Approve all "Yes ✓" recommendations → proceed to Phase 9
- Option [s]: Present numbered list, parse user selection, validate IDs → proceed with subset
- Option [v]: Display full Phase 6 report → re-prompt for action
- Option [n]: Skip all fixes → end command with summary of unresolved issues
- Invalid input: Re-prompt with error message, max 3 attempts before defaulting to [n]

## Notes

- Default mode runs full 9-phase pipeline with interactive resolution
- Use `--report-only` for assessment without fixes (old default behavior)
- Use `--fix` for automated fix and commit (no approval)
- Use `--full` to review entire codebase, not just changes
- Use `--quick` for fast linter-only checks (30-60 sec)
- AI analysis is MANDATORY in default mode
- Target: >90% CodeRabbit approval rate
