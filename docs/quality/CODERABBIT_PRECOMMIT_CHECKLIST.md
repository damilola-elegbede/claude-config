# CodeRabbit Pre-Commit Self-Review Checklist

This checklist catches 80-90% of issues typically flagged in code reviews.
The `/review` command automatically runs through this checklist to ensure code quality before commits.

## 📚 Documentation & Consistency

- [ ] **Path Updates**: All paths updated when files are moved (README, CONTRIBUTING, etc.)
- [ ] **Version/Count Consistency**: Version numbers and counts (e.g., 28 agents) consistent across all references
- [ ] **Agent References**: Use correct names (avoid mobile-ui vs mobile-engineer mix-ups)
- [ ] **New Files**: Have appropriate front-matter and follow template structure
- [ ] **Cross-References**: Between docs are accurate and working

## ⚙️ YAML/Configuration Quality

- [ ] **Required Fields**: `name`, `description`, `tools`, `model`, `category`, `color` present
- [ ] **Description Format**:
  - Contains trigger phrases: "MUST BE USED", "Use PROACTIVELY", "Expert", "Specializes"
  - Length ≤ 300 characters
  - Single line (no `|` or `>`)
- [ ] **Color Compliance**: Matches category requirements per `AGENT_CATEGORIES.md`
- [ ] **No Deprecated Fields**: No `specialization_level`, `domain_expertise`, `coordination_protocols`
- [ ] **Valid Categories**: From set: `development`, `infrastructure`, `architecture`,
  `quality`, `security`, `design`, `analysis`, `documentation`, `coordination`

## 🔧 Code Quality Standards

- [ ] **Constants**: Moved to class-level when used across methods
- [ ] **Encoding**: UTF-8 specified for file operations
- [ ] **Input Validation**: Clear error messages for validation failures
- [ ] **No Hardcoded Values**: Constants/enums used instead of magic numbers
- [ ] **Error Handling**: Proper error handling and graceful failures

## 🤖 Agent System Compliance

- [ ] **Agent Count**: Accurate (currently 28 agents across 8 categories)
- [ ] **System Boundary**: Statements include "NO Task tool access allowed"
- [ ] **Required Sections**: Identity, Core Capabilities, When to Engage, When NOT to Engage, Coordination, SYSTEM BOUNDARY
- [ ] **File Length**: Approximately 40-60 lines per agent
- [ ] **Tools Field**: Comma-separated string format (not YAML list)

## 🧪 Testing & Verification

- [ ] **Validation Scripts**: Run before committing
  - `python scripts/validate-agent-yaml.py`
  - `python scripts/standardize-agents.py`
- [ ] **System Tests**: All pass
  - `./tests/comprehensive/test_system_health.sh`
- [ ] **Pre-commit Hooks**: Successful
- [ ] **Markdown Quality**: No violations
  - `./scripts/validate-markdown-quality.sh validate`

## 🏗️ Structural Patterns

- [ ] **Command/Agent Patterns**: New commands/agents follow established patterns
- [ ] **File Organization**: Matches directory structure conventions
- [ ] **Naming Conventions**: Consistent (lowercase-hyphenated for agents)
- [ ] **No Circular Dependencies**: Or conflicting configurations
- [ ] **Template Compliance**: All agents follow `AGENT_TEMPLATE.md` structure

## 🔍 Quick Validation Commands

Run these before pushing:

```bash
# Comprehensive system health check
./tests/comprehensive/test_system_health.sh

# Agent YAML validation
python scripts/validate-agent-yaml.py

# Agent standardization
python scripts/standardize-agents.py

# Check for required trigger phrases
grep -r "MUST BE USED\|Use PROACTIVELY\|Expert\|Specializes" system-configs/.claude/agents/

# Validate markdown quality
./scripts/validate-markdown-quality.sh validate

# Count agents (should be 28)
find system-configs/.claude/agents/ -name "*.md" -type f | wc -l

# Check for deprecated fields
grep -r "specialization_level\|domain_expertise\|coordination_protocols" system-configs/.claude/agents/

# Verify system boundaries
grep -L "NO Task tool access\|Only Claude has orchestration" system-configs/.claude/agents/*.md
```

## 🎯 Integration with `/review` Command

The `/review` command automatically runs through this checklist with every invocation:

```bash
/review              # Runs checklist + tool-based review
/review --full       # Runs checklist + comprehensive repository review
/review --security   # Runs checklist + security-focused analysis
```

## ✅ Checklist Pass Criteria

All checks must pass before code is considered ready for commit:

- **Documentation**: 100% consistency across all references
- **YAML Quality**: All agents valid with required fields
- **Code Standards**: No hardcoded values, proper error handling
- **Agent Compliance**: 28 agents, all with boundary protection
- **Testing**: All validation scripts and tests pass
- **Structure**: Follows established patterns and conventions

## 📈 Success Metrics

When all checks pass:

- **Reduced Review Time**: 80-90% fewer issues in PR reviews
- **Consistent Quality**: All code meets established standards
- **Fast Feedback**: Issues caught before commit, not after push
- **Team Efficiency**: Less back-and-forth in review cycles

---

*This checklist is inspired by CodeRabbit's review patterns and integrated into the Claude configuration
system for proactive quality assurance.*
