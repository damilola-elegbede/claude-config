# YAML Front-Matter Requirements for Agent Files

## Overview

All agent configuration files are Markdown (.md) files that must include valid YAML
front-matter at the beginning of the file. This document specifies the requirements
and best practices for YAML front-matter in agent files.

**Important**: Per Anthropic's Claude Code documentation, agents are saved as
Markdown files with YAML frontmatter, not as pure YAML files.

## Structure Requirements

### 1. YAML Delimiters

- **Opening delimiter**: Files MUST start with `---` on the first line
- **Closing delimiter**: YAML block MUST end with `---` on its own line
- **No content before**: Nothing should appear before the opening delimiter

Example:

```yaml
---
name: agent-name
description: Agent description
---
```

### 2. Required Fields (Per AGENT_TEMPLATE.md)

Every agent file MUST include these fields:

- **name**: Unique identifier for the agent (lowercase, hyphenated)
  - Format: `[a-z]+(-[a-z]+)*`
  - Examples: `backend-engineer`, `test-engineer`, `principal-architect`

- **description**: Clear trigger-based description
  - Must include trigger phrase: "MUST BE USED", "Use PROACTIVELY", "Expert", or "Specializes"
  - Maximum length: 300 characters
  - Single line format (no multiline with `|`)

- **tools**: Comma-separated list of allowed tools
  - Examples: `Read, Write, Edit, Bash, Grep, Glob`
  - No Task tool (reserved for Claude only)

- **model**: AI model selection
  - Valid values: `opus` (complex reasoning), `sonnet` (standard), `haiku` (rapid)

- **category**: Agent category
  - Valid values: `development`, `infrastructure`, `architecture`, `quality`, `security`,
    `design`, `analysis`, `documentation`, `coordination`

- **color**: Visual identifier
  - Valid values: `blue`, `green`, `red`, `purple`, `yellow`, `orange`, `pink`, `cyan`

### 3. Prohibited Fields (Deprecated)

These fields must NOT be used (not in AGENT_TEMPLATE.md format):

- **specialization_level**: No longer use
- **domain_expertise**: Removed in favor of concise format
- **coordination_protocols**: Handled in markdown sections
- **knowledge_base**: Not part of template
- **escalation_path**: Covered in Coordination section
- **tools as object**: Use simple comma-separated string instead

### 4. Required Markdown Sections

After YAML front-matter, agents must have these sections (~46 lines total):

1. **## Identity**: 2-3 lines describing expertise
2. **## Core Capabilities**: 5 bullet points maximum
3. **## When to Engage**: Specific triggers
4. **## When NOT to Engage**: Clear boundaries
5. **## Coordination**: Parallel work and escalation
6. **## SYSTEM BOUNDARY**: Must include "Only Claude has orchestration authority"

## Best Practices

### 1. Description Format

- **DO**: Use single-line descriptions

  ```yaml
  description: Use this agent for backend development tasks requiring FAANG-level expertise
  ```

- **AVOID**: Multiline descriptions with pipe operator

  ```yaml
  description: |
    Use this agent for backend development...
    Multiple lines make parsing complex...
  ```

### 2. File Length Requirement

- **Target**: ~46 lines total
- **Range**: 40-60 lines acceptable
- **Format**: Concise, focused content

### 3. Field Ordering (Per AGENT_TEMPLATE.md)

Required order:

1. name
2. description
3. tools
4. model
5. category
6. color (required)

### 4. Validation

#### Using the Validation Script

```bash
# Validate all agent files
./scripts/validate_yaml.sh

# Validate specific file
./scripts/validate_yaml.sh agent-name.md
```

#### Running Unit Tests

```bash
./test_yaml_validation.sh
```

#### Pre-commit Hook Setup

To automatically validate YAML before commits:

```bash
# Copy pre-commit hook to git hooks directory
cp pre-commit-yaml-validation.sh .git/hooks/pre-commit

# Or symlink it
ln -s ../../.claude/agents/pre-commit-yaml-validation.sh .git/hooks/pre-commit
```

## Example Agent (AGENT_TEMPLATE.md Format)

```yaml
---
name: backend-engineer
description: MUST BE USED for server-side architecture, microservices, distributed systems, and database engineering. Use PROACTIVELY for high-performance optimization (>10k RPS).
tools: Read, Write, Edit, Bash, Grep, Glob
model: sonnet
category: development

color: blue
---

# Backend Engineer

## Identity

Expert backend engineer specializing in distributed systems, microservices architecture, and high-performance server implementations.
Combines strategic architectural thinking with production-grade implementation skills for 100k+ RPS systems.

## Core Capabilities

- Distributed systems design with consensus algorithms and CAP theorem application
- Microservices architecture with proper service boundaries
- Performance optimization for sub-100ms latency
- Database engineering including sharding and replication
- Event-driven architecture with message queues

## When to Engage

- Server-side code modifications or new API endpoints
- Database schema changes or query optimization
- Performance issues exceeding latency thresholds
- Microservices architecture design

## When NOT to Engage

- Pure frontend or UI-only changes
- Documentation updates without code changes

## Coordination

Works in parallel with frontend-engineer for full-stack features.
Escalates to principal-architect for system-wide architectural decisions.

## SYSTEM BOUNDARY

This agent cannot invoke other agents or create Task calls. Only Claude has orchestration authority.
```

## Common Issues and Solutions

### Issue 1: Very Long Descriptions

**Problem**: Descriptions over 300 characters are too long
**Solution**: Keep descriptions concise, move details to documentation section

### Issue 2: Complex Nested YAML

**Problem**: Deep nesting makes YAML hard to read and parse
**Solution**: Limit nesting to 2-3 levels maximum

### Issue 3: Special Characters in Strings

**Problem**: Quotes, colons, and special characters can break YAML
**Solution**: Use proper quoting for strings with special characters

## Template

Use `AGENT_TEMPLATE.md` as a starting point for new agent files:

```bash
cp AGENT_TEMPLATE.md new-agent.md
# Edit the file to customize for your agent
```

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Validate Agent YAML
on:
  pull_request:
    paths:
      - '.claude/agents/*.md'

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Validate YAML front-matter
        run: |
          ./scripts/validate_yaml.sh
```

## Maintenance

### Regular Validation

Run validation as part of your regular CI/CD pipeline to catch issues early.

### Updating Templates

When adding new required fields, update:

1. AGENT_TEMPLATE.md
2. scripts/validate_yaml.sh validation rules
3. This documentation

## Support

For questions or issues with YAML validation:

1. Check error messages from scripts/validate_yaml.sh
2. Refer to examples in existing agent files
