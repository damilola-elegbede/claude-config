# Claude Code Command Template

This template defines the standard format for all Claude Code slash commands.
All commands in `system-configs/.claude/commands/` should follow this structure.

## Required Structure

```markdown
---
description: [Brief one-line description of what this command does]
argument-hint: [optional - hint for arguments, e.g., "[issue-number]", "[file-path]", or leave empty if no arguments]
---

# Command Purpose
[Main instruction or prompt that Claude will execute]

## Context
[Any context, rules, or guidelines Claude should follow]

## Expected Output
[What the command should produce or accomplish]
```

## Frontmatter Fields

### Required Fields
- **description**: A concise, clear description of the command's purpose (shown in autocomplete)

### Optional Fields
- **argument-hint**: Shows users what arguments to provide (e.g., `[branch-name]`, `[file-path]`)
- **allowed-tools**: Specify which tools can be used (e.g., `Bash(git add:*)`)
- **model**: Override the default model (e.g., `claude-3-5-haiku-20241022`)

## Best Practices

1. **Description**: Keep it under 60 characters for clean autocomplete display
2. **Argument Hints**: Use square brackets for optional args: `[file-path]`
3. **Content**: Start with a clear directive of what Claude should do
4. **Arguments**: Use `$ARGUMENTS` placeholder where user input should be inserted
5. **Context**: Include any project-specific conventions or rules

## Examples

### Simple Command (no arguments)
```markdown
---
description: Run all project tests and report results
---

Run all tests in the project and provide a summary of results.
```

### Command with Arguments
```markdown
---
description: Fix a specific GitHub issue
argument-hint: [issue-number]
---

Find and fix issue #$ARGUMENTS following our coding standards.
```

### Command with Tool Restrictions
```markdown
---
description: Create a comprehensive git commit
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*)
---

Review changes and create a meaningful commit message.
```