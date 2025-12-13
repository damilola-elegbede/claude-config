---
description: AI-powered code review matching CodeRabbit quality
argument-hint: [--full|--fix|--security|--quick|file-path]
---

# /review Command

## Usage

```bash
/review                          # Full AI-powered review (default)
/review --quick                  # Linter-only mode (fast, no AI)
/review --full                   # Full repository review
/review <file|directory>         # Review specific target
/review --fix                    # Auto-fix safe issues + commit
/review --security               # Security-focused analysis
```

## Description

Comprehensive code review system designed to match or exceed CodeRabbit quality. Combines configuration integrity
validation, automated linting, and mandatory AI-powered deep analysis to catch issues BEFORE external review.

**Philosophy**: Catch everything locally so CodeRabbit reviews are mostly approvals.

## Review Modes

| Mode | Duration | Phases | Use Case |
|------|----------|--------|----------|
| Default | 2-5 min | All 6 phases | Full AI analysis |
| `--quick` | 30-60s | Linting only | Fast checks |
| `--full` | 5-10 min | All files | Audits, refactors |
| `--security` | 3-5 min | + security-auditor | Security focus |
| `--fix` | 1-2 min | Auto-fix + commit | Safe fixes |

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

## Expected Output

```text
User: /review
Claude: Starting comprehensive review...

Phase 0: Configuration Integrity
  test-config-integrity.py: Passed
  validate-agent-yaml.py: Passed

Phase 1: Changed Files (3 files)

Phase 2: Path-Based Validation - Passed

Phase 3: Linters
  markdownlint: 0 issues

Phase 4: AI Deep Analysis
  Wave 1: code-reviewer + codebase-analyst (45s)
  Wave 2: No additional agents needed

Phase 5: CodeRabbit Checklist - 100% passed

Phase 6: Report
  Issues: 0 Critical, 1 High, 2 Medium

  Prompts for AI Agents:
  1. Fix High: Add error handling in review.md:45

Review complete - 1 high priority issue to address
```

## Quality Standards

**What This Review Catches:**

- **Configuration**: Count mismatches, orphan refs, YAML errors, deprecated fields
- **Documentation**: Path errors, count inconsistencies, broken cross-refs
- **Code Quality**: SOLID/DRY violations, error handling gaps, complexity
- **Architecture**: Cross-file impact, breaking changes, technical debt
- **Security**: Injection, auth flaws, secrets exposure
- **Performance**: Race conditions, memory leaks, N+1 queries

## Notes

- Default mode runs full 6-phase pipeline (2-5 min)
- Use `--quick` for fast linter-only checks (30-60 sec)
- AI analysis is MANDATORY in default mode
- Output includes "Prompts for AI Agents" for easy fixing
- Target: >90% CodeRabbit approval rate
