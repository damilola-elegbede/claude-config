---
name: markdown
description: Expertise in Markdown formatting, linting rules, and documentation standards
category: format
---

# Markdown Expertise

## Domain Focus

Expert knowledge in Markdown syntax, linting compliance, and documentation best practices for technical content.

## Core Capabilities

- Markdown syntax and GitHub-flavored extensions
- Markdownlint rule compliance (MD001-MD058)
- Documentation structure and organization
- Code block formatting and language tags

## When to Use This Skill

Invoke this skill when:

- Creating or editing documentation files
- Fixing markdownlint violations
- Structuring README or guide content
- Formatting code examples and tables

## Common Patterns

### Heading Hierarchy

```markdown
# Document Title (H1 - only one per file)

## Main Section (H2)

### Subsection (H3)

#### Detail Section (H4)
```

### Code Blocks with Language Tags

```markdown
​```python
def example():
    return "Always specify language"
​```

​```bash
npm install  # Shell commands
​```
```

### Tables with Proper Spacing

```markdown
| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Data 1   | Data 2   | Data 3   |
| Value A  | Value B  | Value C  |
```

## Best Practices

- One H1 heading per file (MD025)
- Surround headings with blank lines (MD022, MD031, MD032)
- Specify language for all code blocks (MD040)
- Keep lines under 150 characters (MD013)
- End files with single newline (MD047)
- Use consistent list markers (MD004)

## Quick Reference

| Rule | Issue | Fix |
|------|-------|-----|
| MD001 | Heading skip | Use sequential levels (H1→H2→H3) |
| MD022 | No blank lines | Add blank line before/after headings |
| MD040 | No language tag | Add language to ```blocks |
| MD047 | No final newline | End file with single newline |

## Common Linting Fixes

### Fix Missing Blank Lines

```markdown
## Bad
Some text
### Next Heading

## Good
Some text

### Next Heading
```

### Fix Code Block Language

```markdown
## Bad
​```
code here
​```

## Good
​```python
code here
​```
```

## Integration Notes

- Works alongside: markdownlint-cli2 tool
- Escalate to: tech-writer for complex documentation structure
- Complements: /docs command for documentation generation
- Validation: .markdownlint-cli2.jsonc config in repo root
