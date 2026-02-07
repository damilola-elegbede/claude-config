---
name: audit
description: Validate agent and command ecosystem integrity. Use when checking configuration compliance or ecosystem health.
argument-hint: "[--scope agents|commands|all] [--fix]"
category: workflow
---

# /audit

## Usage

```bash
/audit                     # Audit all agents and commands
/audit --scope agents      # Agents only
/audit --scope commands    # Commands only
/audit --fix               # Auto-fix issues
```

## Description

Validate Claude Code configuration ecosystem. Checks agents and commands for YAML compliance, template adherence, and integrity.

## Behavior

1. **Validate**: Run validation scripts
2. **Report**: Present findings with severity
3. **Fix** (with --fix): Apply safe automatic fixes

### Validation Checks

**Agents:**

- YAML frontmatter parsing
- Required fields: name, description, tools, model, category, color
- Template compliance (AGENT_TEMPLATE.md)
- SYSTEM BOUNDARY statement present
- No Task tool access

**Commands:**

- Frontmatter syntax
- Description < 60 chars (autocomplete)
- Argument-hint format
- Agent references exist

## Expected Output

```text
User: /audit

AUDIT REPORT - Configuration Ecosystem
──────────────────────────────────────
Scope: all
Agents: 12 total | 12 compliant | 0 issues
Commands: 20 total | 20 compliant | 0 issues
Overall Compliance: 100%

✅ All validation checks passed
```

### With Issues

```text
User: /audit --scope agents

AUDIT REPORT - Agent Validation
──────────────────────────────
Agents: 12 total | 10 compliant | 2 issues

Issues Detected:

HIGH:
  - debugger.md: Missing SYSTEM BOUNDARY statement

MEDIUM:
  - researcher.md: Description exceeds recommended length

Run `/audit --fix` to auto-apply safe fixes
```

### Fix Mode

```text
User: /audit --fix

[Validation runs...]

Issues Fixed:
  ✅ debugger.md: Added SYSTEM BOUNDARY statement
  ✅ researcher.md: Truncated description

Post-fix Compliance: 100%
```

## Notes

- Runs validation scripts directly
- Safe fixes applied with --fix
- Pre-commit hooks should run this automatically
- Typical execution: 30-60 seconds
