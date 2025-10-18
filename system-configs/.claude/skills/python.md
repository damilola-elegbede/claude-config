---
name: python
description: Expertise in Python best practices, validation scripts, and testing patterns
category: language
---

# Python Expertise

## Domain Focus

Expert knowledge in Python idioms, best practices, and patterns for validation scripts and automation tools.

## Core Capabilities

- Python 3.8+ modern syntax and features
- Script validation and error handling
- File I/O and path manipulation
- Testing with pytest and unittest
- CLI argument parsing with argparse

## When to Use This Skill

Invoke this skill when:

- Writing or reviewing Python validation scripts
- Implementing automation tools
- Debugging Python code errors
- Setting up Python project structure

## Common Patterns

### Script Template with Argparse

```python
#!/usr/bin/env python3
"""Module docstring describing purpose."""

import argparse
import sys
from pathlib import Path


def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(description="Script description")
    parser.add_argument("--flag", action="store_true", help="Flag description")
    args = parser.parse_args()

    # Implementation here
    return 0


if __name__ == "__main__":
    sys.exit(main())
```

### Path Handling with Pathlib

```python
from pathlib import Path

# Modern path handling
config_dir = Path.home() / ".claude"
for file_path in config_dir.glob("agents/*.md"):
    content = file_path.read_text()
    # Process content
```

### Error Handling

```python
try:
    result = process_file(file_path)
except FileNotFoundError:
    print(f"Error: File not found: {file_path}", file=sys.stderr)
    return 1
except ValueError as e:
    print(f"Error: Invalid data - {e}", file=sys.stderr)
    return 1
```

## Best Practices

- Use pathlib.Path for file operations (not os.path)
- Include type hints for function signatures
- Write docstrings for modules, classes, and functions
- Use f-strings for string formatting
- Handle errors with specific exceptions
- Return proper exit codes (0=success, 1+=error)

## Quick Reference

| Task | Pattern | Example |
|------|---------|---------|
| Read file | `Path.read_text()` | `content = Path("file.md").read_text()` |
| Write file | `Path.write_text()` | `Path("out.txt").write_text(data)` |
| Glob files | `Path.glob()` | `files = Path(".").glob("**/*.py")` |
| Exit codes | `sys.exit(code)` | `sys.exit(0)` for success |

## Common Validation Patterns

### YAML Frontmatter Validation

```python
import yaml

def validate_frontmatter(content: str) -> dict:
    """Extract and validate YAML frontmatter."""
    if not content.startswith("---"):
        raise ValueError("Missing frontmatter")

    parts = content.split("---", 2)
    if len(parts) < 3:
        raise ValueError("Invalid frontmatter format")

    return yaml.safe_load(parts[1])
```

## Integration Notes

- Works alongside: validation scripts in scripts/
- Escalate to: backend-engineer for complex Python applications
- Complements: /test command for running pytest
- Testing: pytest framework used in tests/
