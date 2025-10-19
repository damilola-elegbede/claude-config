---
name: bash
description: Expertise in shell scripting, git hooks, and automation workflows
category: workflow
---

# Bash Expertise

## Domain Focus

Expert knowledge in Bash shell scripting for git hooks, automation, and validation workflows.

## Core Capabilities

- Shell scripting best practices and safety
- Git hooks (pre-commit, pre-push, exit hooks)
- Error handling and exit codes
- File operations and command chaining
- Script portability (macOS/Linux)

## When to Use This Skill

Invoke this skill when:

- Writing or reviewing shell scripts
- Creating git hooks
- Building automation workflows
- Debugging script execution errors

## Common Patterns

### Safe Script Header

```bash
#!/usr/bin/env bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures
IFS=$'\n\t'        # Safe word splitting

# Script implementation
```

### Git Hook Template

```bash
#!/usr/bin/env bash
# pre-commit hook

set -e

echo "Running pre-commit validation..."

# Run validations
if ! ./scripts/validate-agent-yaml.py; then
    echo "❌ Agent validation failed"
    exit 1
fi

echo "✅ All validations passed"
exit 0
```

### Conditional Execution

```bash
# Run command, check status
if git diff --cached --name-only | grep -q '\.md$'; then
    echo "Markdown files changed, running linter..."
    npm run lint:md
fi

# Command chaining with AND (&&)
git add . && git commit -m "message" && git push

# Command chaining with OR (||)
command || echo "Command failed but continuing"
```

## Best Practices

- Always use `set -e` to exit on errors
- Quote variables: `"$var"` not `$var`
- Use `[[ ]]` for conditionals (not `[ ]`)
- Check command existence with `command -v`
- Use meaningful exit codes (0=success)
- Provide clear error messages to stderr

## Quick Reference

| Task | Pattern | Example |
|------|---------|---------|
| Exit on error | `set -e` | Place at script start |
| Quote variables | `"$var"` | Always quote expansions |
| Check command | `command -v cmd` | `if command -v python3; then` |
| Error message | `>&2 echo` | `echo "Error" >&2` |
| Exit code | `exit N` | `exit 1` for errors |

## Common Patterns for This Repo

### Running Validation Scripts

```bash
#!/usr/bin/env bash
set -e

# Validate agents
./scripts/validate-agent-yaml.py || exit 1

# Run tests
./tests/test.sh || exit 1

# Lint markdown
npm run lint:md || exit 1

echo "✅ All checks passed"
```

### File Existence Checks

```bash
if [[ ! -f "system-configs/.claude/agents/backend-engineer.md" ]]; then
    echo "Error: Agent file not found" >&2
    exit 1
fi
```

## Integration Notes

- Works alongside: Git hooks in .git/hooks/
- Escalate to: devops for complex CI/CD scripts
- Complements: /sync, /commit, /push commands
- Hooks: .pre-commit-config.yaml defines quality gates
