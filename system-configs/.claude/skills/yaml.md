---
name: yaml
description: Expertise in YAML syntax, validation, and frontmatter patterns for agents and commands
category: format
---

# YAML Expertise

## Domain Focus

Expert knowledge in YAML syntax, validation, and frontmatter configuration for Claude Code agents and commands.

## Core Capabilities

- YAML syntax validation and formatting
- Frontmatter schema compliance for agents and commands
- Common YAML patterns and anti-patterns
- Error diagnosis and resolution

## When to Use This Skill

Invoke this skill when:

- Creating or editing agent definitions (*.md files with YAML frontmatter)
- Creating or editing command definitions
- Validating YAML syntax in configuration files
- Troubleshooting YAML parsing errors

## Common Patterns

### Agent Frontmatter

```yaml
---
name: agent-name  # lowercase-hyphenated
description: MUST BE USED for [trigger]. Specializes in [capability].
tools: Read, Write, Edit, Grep, Glob, Bash
model: sonnet  # opus/sonnet/haiku
thinking-level: megathink  # OPTIONAL
thinking-tokens: 10000  # OPTIONAL
category: development  # See AGENT_CATEGORIES.md
color: blue  # Must match category color
---
```

### Command Frontmatter

```yaml
---
description: Brief description under 60 chars
argument-hint: [options]
thinking-level: megathink  # OPTIONAL
thinking-tokens: 10000  # OPTIONAL
---
```

## Best Practices

- Always use lowercase-hyphenated names (e.g., backend-engineer, not Backend_Engineer)
- Match agent color to category (see docs/agents/AGENT_CATEGORIES.md)
- Include thinking-tokens only if thinking-level is specified
- Keep descriptions concise and actionable
- Use proper YAML indentation (2 spaces, no tabs)

## Quick Reference

| Task | Pattern | Example |
|------|---------|---------|
| Agent name | lowercase-hyphenated | `name: backend-engineer` |
| Description | Action-oriented | `MUST BE USED for [trigger]` |
| Tools | Comma-separated | `tools: Read, Write, Edit` |
| Thinking levels | Token count match | `megathink` = 10000 tokens |

## Validation Checklist

- [ ] Valid YAML syntax (no tabs, proper indentation)
- [ ] Required fields present (name/description)
- [ ] Thinking-tokens matches thinking-level
- [ ] Category and color alignment (agents only)
- [ ] Tools list contains only valid tools
- [ ] Description under 150 characters (commands)

## Integration Notes

- Works alongside: validate-agent-yaml.py script
- Escalate to: code-reviewer for complex configuration issues
- Complements: /agent-audit and /command-audit commands
