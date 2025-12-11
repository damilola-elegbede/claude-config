---
description: Validate agent and command ecosystem integrity
argument-hint: [--scope agents|commands|all] [--fix]
---

# /audit Command

## Usage

```bash
# Audit all agents and commands
/audit
/audit --scope all

# Audit only agents
/audit --scope agents
/audit --scope agents --fix

# Audit only commands
/audit --scope commands
/audit --scope commands --fix

# Apply automatic fixes
/audit --fix
```

## Description

Unified validation command for the Claude Code configuration ecosystem. Performs comprehensive
validation of agents, commands, or both against template standards, YAML compliance, and
system integrity. Replaces the separate `/agent-audit` and `/command-audit` commands.

## Expected Output

### Executive Summary

```text
AUDIT REPORT - Configuration Ecosystem Validation
──────────────────────────────────────────────────
Scope: [agents|commands|all]
Agents: XX total | XX compliant | XX issues
Commands: XX total | XX compliant | XX issues
Overall Compliance: XX%
```

### Agent Validation Results

| Agent | YAML Valid | Template | Tools | Category | Status |
|-------|------------|----------|-------|----------|--------|
| debugger | Pass | Pass | Pass | quality | Pass |
| backend-engineer | Pass | Pass | Pass | development | Pass |

### Command Validation Results

| Command | Frontmatter | Description | Args | Thinking | Status |
|---------|-------------|-------------|------|----------|--------|
| /commit | Pass | Pass | Pass | N/A | Pass |
| /plan | Pass | Pass | Pass | ultrathink | Pass |

### Issues Detected

```text
CRITICAL:
- [agent-name]: YAML parsing error on line X

HIGH:
- [command-name]: Description exceeds 60 char limit

MEDIUM:
- [agent-name]: Missing category field
```

## Behavior

### Scope Selection

```yaml
--scope agents:
  - Validate all agents in system-configs/.claude/agents/
  - Check YAML frontmatter parsing
  - Verify template compliance (AGENT_TEMPLATE.md)
  - Validate required fields: name, description, tools, model, category, color
  - Check thinking-level/thinking-tokens consistency
  - Verify SYSTEM BOUNDARY statement present
  - Validate no Task tool access

--scope commands:
  - Validate all commands in system-configs/.claude/commands/
  - Check YAML frontmatter syntax
  - Verify description < 60 chars for autocomplete
  - Validate argument-hint format
  - Check thinking-level/thinking-tokens when present
  - Verify agent references exist

--scope all (default):
  - Run both agent and command validation
  - Cross-reference agent usage in commands
  - Check for orphaned references
```

### Wave-Based Orchestration

#### Wave 1: Structural Validation (Parallel)

```yaml
code-reviewer (per scope):
  agents: YAML parsing, template structure, required fields
  commands: Frontmatter syntax, description length, argument format

security-auditor:
  agents: Task tool violations, system boundary enforcement
  commands: Agent reference validation, permission checks
```

#### Wave 2: Deep Analysis (Conditional)

```yaml
debugger:
  trigger: YAML parsing failures detected
  role: Root cause analysis of syntax errors
  output: Specific fix recommendations

performance-engineer:
  trigger: Resource optimization opportunities
  role: Model assignment analysis
  output: Cost optimization recommendations
```

#### Wave 3: Remediation (With --fix)

```yaml
Auto-Fix Capabilities:
  yaml_fixes:
    - Multi-line description block scalar formatting
    - Tools field comma-separated string conversion
    - Trailing whitespace removal
    - Newline normalization

  template_compliance:
    - Missing field insertion with defaults
    - Category/color alignment
    - System boundary statement addition

  command_fixes:
    - Description truncation with ellipsis
    - Argument-hint format standardization
```

### Validation Rules

#### Agent Validation

```yaml
Required Fields:
  - name: Must match filename (without .md)
  - description: Single line, meaningful summary
  - tools: Comma-separated list (NOT YAML array)
  - model: sonnet|opus|haiku
  - category: Valid category from AGENT_CATEGORIES.md
  - color: Matching category color

Optional Fields:
  - thinking-level: ultrathink|megathink|think harder|think
  - thinking-tokens: 31999|10000|8000|4000 (must match level)

Anti-Pattern Checks:
  - No Task tool in tools list
  - SYSTEM BOUNDARY statement present
  - No agent self-references
  - No orchestration language
```

#### Command Validation

```yaml
Required Fields:
  - description: < 60 chars for autocomplete compatibility

Optional Fields:
  - argument-hint: [bracket] notation format
  - thinking-level: Valid thinking level
  - thinking-tokens: Matching token count

Agent Reference Checks:
  - All referenced agents must exist
  - Agent names match current ecosystem (30 agents)
```

### Output Modes

```yaml
Default (Report Only):
  - Generates comprehensive report
  - Lists all issues with severity
  - Provides fix recommendations
  - No file modifications

--fix (Auto-Remediation):
  - Applies safe automatic fixes
  - Reports all changes made
  - Flags issues requiring manual intervention
  - Creates backup before modifications
```

## Success Criteria

```yaml
Agent Validation:
  - YAML parseability: 100%
  - Template adherence: All agents follow structure
  - Required fields: All present and valid
  - Anti-patterns: None detected

Command Validation:
  - Frontmatter valid: 100%
  - Description compliance: All < 60 chars
  - Agent references: All valid
  - Thinking consistency: Levels match tokens

Cross-Validation:
  - No orphaned agent references
  - No circular dependencies
  - Ecosystem integrity maintained
```

## Examples

```text
User: /audit

Audit Report - Configuration Ecosystem
──────────────────────────────────────
Scope: all
Agents: 30 total | 30 compliant | 0 issues
Commands: 20 total | 20 compliant | 0 issues
Overall Compliance: 100%

All validation checks passed.
```

```text
User: /audit --scope agents --fix

Audit Report - Agent Validation
───────────────────────────────
Agents: 30 total | 28 compliant | 2 issues

Issues Fixed:
- resume-optimizer.md: Fixed trailing whitespace
- ui-designer.md: Fixed multi-line description format

Issues Requiring Manual Fix:
- None

Post-fix Compliance: 100%
```

## Notes

- Unified command replaces `/agent-audit` and `/command-audit`
- Default scope is `all` for comprehensive validation
- Use `--fix` only after reviewing issues in report mode
- Pre-commit hooks should run `/audit --scope all` automatically
- Agent count should be 30 after optimization (down from 37)
- Command count should be 20 after optimization (down from 23)
