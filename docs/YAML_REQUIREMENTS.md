# YAML Front-Matter Requirements for Agent Files

## Overview
All agent configuration files must include valid YAML front-matter at the beginning of the file. This document specifies the requirements and best practices for YAML front-matter in agent files.

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

### 2. Required Fields
Every agent file MUST include these fields:

- **name**: Unique identifier for the agent (lowercase, hyphenated)
  - Format: `[a-z]+(-[a-z]+)*`
  - Examples: `backend-staff`, `qa-tester`, `principal-architect`

- **description**: Clear, concise description of the agent's purpose
  - Should be a single line (not multiline with `|`)
  - Maximum recommended length: 500 characters
  - Should clearly state what the agent does and when to use it

### 3. Recommended Fields
These fields should be included for complete agent configuration:

- **color**: Visual identifier for the agent
  - Valid values: red, orange, yellow, green, blue, purple, cyan, etc.

- **specialization_level**: Agent's expertise level
  - Valid values: `junior`, `specialist`, `senior`, `principal`

- **domain_expertise**: Array of expertise areas
  ```yaml
  domain_expertise:
    - primary_skill
    - secondary_skill
    - tertiary_skill
  ```

- **tools**: Tool access configuration
  ```yaml
  tools:
    allowed: [Read, Write, Grep]
    forbidden: [Delete]
    rationale: "Explanation of tool permissions"
  ```

### 4. Optional Fields
These fields can be included as needed:

- **parallel_compatible**: List of agents that can work in parallel
- **escalation_to**: Agents to escalate complex issues to
- **escalation_from**: Agents that escalate to this agent
- **coordination_protocols**: Detailed coordination patterns
- **knowledge_base**: Additional reference information

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

### 2. Examples in Description
- **AVOID**: Embedding examples in the description field
- **CONSIDER**: Creating a separate examples section after the front-matter

### 3. Field Ordering
Recommended order for consistency:
1. name
2. description  
3. color
4. specialization_level
5. domain_expertise
6. tools
7. coordination fields
8. other optional fields

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

## Common Issues and Solutions

### Issue 1: Very Long Descriptions
**Problem**: Descriptions over 500 characters are hard to maintain
**Solution**: Keep descriptions concise, move details to documentation section

### Issue 2: Complex Nested YAML
**Problem**: Deep nesting makes YAML hard to read and parse
**Solution**: Limit nesting to 2-3 levels maximum

### Issue 3: Special Characters in Strings
**Problem**: Quotes, colons, and special characters can break YAML
**Solution**: Use proper quoting for strings with special characters

## Template
Use `AGENT_TEMPLATE.yaml` as a starting point for new agent files:

```bash
cp AGENT_TEMPLATE.yaml new-agent.md
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
1. AGENT_TEMPLATE.yaml
2. scripts/validate_yaml.sh validation rules
3. This documentation

## Support
For questions or issues with YAML validation:
1. Check error messages from scripts/validate_yaml.sh
2. Refer to examples in existing agent files
3. Run unit tests to verify validation logic