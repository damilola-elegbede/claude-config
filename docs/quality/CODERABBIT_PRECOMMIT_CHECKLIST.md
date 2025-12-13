# CodeRabbit Pre-Commit Self-Review Checklist

This checklist catches 80-90% of issues typically flagged in code reviews.
The `/review` command **programmatically implements** this entire checklist through its 6-phase review pipeline.

## How `/review` Implements This Checklist

The `/review` command runs this checklist automatically through:

| Phase | Checklist Coverage |
|-------|-------------------|
| Phase 0: Configuration Integrity | Agent/command counts, YAML validation, orphan detection |
| Phase 2: Path-Based Validation | File-specific rules, template compliance |
| Phase 4: AI Deep Analysis | Documentation sync, pattern violations, architectural issues |
| Phase 5: Checklist Verification | Explicit pass/fail for each item below |

## Documentation & Consistency

- [ ] **Path Updates**: All paths updated when files are moved (README, CONTRIBUTING, etc.)
- [ ] **Version/Count Consistency**: Version numbers and counts (31 agents, 21 commands) consistent across all references
- [ ] **Agent References**: Use correct names (avoid mobile-ui vs mobile-engineer mix-ups)
- [ ] **New Files**: Have appropriate front-matter and follow template structure
- [ ] **Cross-References**: Between docs are accurate and working

**Automated by**: Phase 0 (`test-config-integrity.py`), Phase 4 (code-reviewer agent)

## YAML/Configuration Quality

- [ ] **Required Fields**: `name`, `description`, `tools`, `model`, `category`, `color` present
- [ ] **Description Format**:
  - Contains trigger phrases: "MUST BE USED", "Use PROACTIVELY", "Expert", "Specializes"
  - Length <= 300 characters
  - Single line (no `|` or `>`)
- [ ] **Color Compliance**: Matches category requirements per `AGENT_CATEGORIES.md`
- [ ] **No Deprecated Fields**: No `specialization_level`, `domain_expertise`, `coordination_protocols`
- [ ] **Valid Categories**: From set: `development`, `infrastructure`, `architecture`,
  `quality`, `security`, `design`, `analysis`, `documentation`, `coordination`

**Automated by**: Phase 0 (`validate-agent-yaml.py`), Phase 2 (path-based validation)

## Code Quality Standards

- [ ] **Constants**: Moved to class-level when used across methods
- [ ] **Encoding**: UTF-8 specified for file operations
- [ ] **Input Validation**: Clear error messages for validation failures
- [ ] **No Hardcoded Values**: Constants/enums used instead of magic numbers
- [ ] **Error Handling**: Proper error handling and graceful failures

**Automated by**: Phase 3 (linters), Phase 4 (code-reviewer agent)

## Agent System Compliance

- [ ] **Agent Count**: Accurate (currently 31 agents across 8 categories)
- [ ] **Command Count**: Accurate (currently 21 commands)
- [ ] **System Boundary**: Statements include "NO Task tool access allowed"
- [ ] **Required Sections**: Identity, Core Capabilities, When to Engage, When NOT to Engage, Coordination, SYSTEM BOUNDARY
- [ ] **File Length**: Approximately 40-80 lines per agent
- [ ] **Tools Field**: Comma-separated string format (not YAML list)

**Automated by**: Phase 0 (`test-config-integrity.py`), Phase 2 (path-based validation)

## Testing & Verification

- [ ] **Validation Scripts**: Run before committing
  - `python scripts/test-config-integrity.py`
  - `python scripts/validate-agent-yaml.py`
  - `python scripts/check-orphans.py`
- [ ] **Markdown Quality**: No violations
  - `./scripts/validate-markdown-quality.sh validate`
- [ ] **Pre-commit Hooks**: Successful

**Automated by**: Phase 0 (all validation scripts run automatically)

## Structural Patterns

- [ ] **Command/Agent Patterns**: New commands/agents follow established patterns
- [ ] **File Organization**: Matches directory structure conventions
- [ ] **Naming Conventions**: Consistent (lowercase-hyphenated for agents)
- [ ] **No Circular Dependencies**: Or conflicting configurations
- [ ] **Template Compliance**: All agents follow `AGENT_TEMPLATE.md` structure

**Automated by**: Phase 0 (`check-orphans.py`), Phase 4 (codebase-analyst agent)

## Quick Validation Commands

These are run automatically by `/review`, but can be run manually:

```bash
# Full comprehensive review (recommended)
/review

# Or run individual scripts manually:

# Configuration integrity (counts, orphans, YAML)
python scripts/test-config-integrity.py

# Agent YAML validation
python scripts/validate-agent-yaml.py

# Orphan reference detection
python scripts/check-orphans.py

# Validate markdown quality
./scripts/validate-markdown-quality.sh validate

# Count agents (should be 31)
find system-configs/.claude/agents/ -name "*.md" -type f | wc -l

# Count commands (should be 21)
find system-configs/.claude/commands/ -name "*.md" -type f | wc -l

# Check for deprecated fields
grep -r "specialization_level\|domain_expertise\|coordination_protocols" system-configs/.claude/agents/

# Verify system boundaries
grep -L "NO Task tool access\|Only Claude has orchestration" system-configs/.claude/agents/*.md
```

## Integration with `/review` Command

The `/review` command provides multiple modes for this checklist:

```bash
/review              # Full 6-phase review with AI analysis (2-5 min)
/review --quick      # Linter-only, no AI (30-60 sec)
/review --full       # Repository-wide analysis
/review --security   # Security-focused with security-auditor agent
/review --fix        # Auto-fix safe issues + commit
```

### What Each Mode Validates

| Mode | Phases Run | Checklist Coverage |
|------|------------|-------------------|
| Default | All 6 phases | 100% of checklist |
| --quick | Phase 3 only | Linting only (~30%) |
| --full | All 6 phases, all files | 100% + repo-wide |
| --security | All 6 + security-auditor | 100% + deep security |

## Checklist Pass Criteria

All checks must pass before code is considered ready for commit:

- **Documentation**: 100% consistency across all references
- **YAML Quality**: All agents valid with required fields
- **Code Standards**: No hardcoded values, proper error handling
- **Agent Compliance**: 31 agents, 21 commands, all with boundary protection
- **Testing**: All validation scripts pass
- **Structure**: Follows established patterns and conventions

## Success Metrics

When `/review` passes with no critical or high issues:

- **CodeRabbit Approval Rate**: Target >90% (up from ~60%)
- **Average Comments per PR**: Target <2 (down from 5+)
- **Configuration Issues**: Zero reach CodeRabbit
- **Review Cycle Time**: Reduced by catching issues locally

## Report Output

The `/review` command generates a structured report including:

- Severity-based issue tables (Critical, High, Medium, Low)
- Detailed findings with file:line references
- **"Prompts for AI Agents"** section for easy fixing
- Configuration integrity summary
- Linter summary
- Checklist pass/fail status

---

*This checklist is programmatically implemented by the `/review` command. Run `/review` to validate
all items automatically with AI-powered deep analysis.*
