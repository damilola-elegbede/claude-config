#!/usr/bin/env python3
"""
Skills YAML Validation
======================

Validates skill YAML front-matter for skills in system-configs/.claude/skills/
Supports both formats:
- Directory-based: skills/<name>/SKILL.md (Claude Code native format)
- Flat file: skills/<name>.md (legacy format)

Validates frontmatter fields and skill structure.
"""

import os
import re
import sys
from pathlib import Path

# Valid frontmatter fields for skills (based on Claude Code skills system)
VALID_FIELDS = {
    # Core fields
    'name',
    'description',
    'category',
    # Claude Code skill features
    'context',           # 'fork' for isolated context
    'agent',             # Agent type to route to
    'user-invocable',    # Whether user can invoke directly (default: true)
    'disable-model-invocation',  # Prevent model from invoking
    'allowed-tools',     # Restrict available tools
}

# Valid categories for skills
VALID_CATEGORIES = [
    'language',       # Programming languages (python, typescript, go, etc.)
    'format',         # File formats (yaml, markdown, json, etc.)
    'framework',      # Frameworks (react, fastapi, django, etc.)
    'infrastructure', # DevOps tools (docker, k8s, terraform, etc.)
    'workflow',       # Workflows and processes (git-workflows, cicd, etc.)
    'orchestration',  # Complex multi-step workflows (ship-it, review, etc.)
]

# Valid agent types (maps to Claude Code built-in subagent_types)
VALID_AGENTS = [
    'general-purpose',
    'Explore',
    'Plan',
    'debugger',
    'architect',
    'code-reviewer',
    'test-engineer',
    'security-auditor',
    'researcher',
    'frontend-engineer',
    'backend-engineer',
    'devops',
    'data-engineer',
    'tech-writer',
]

# Valid context values
VALID_CONTEXTS = ['fork']

# Non-skill documentation files to skip
NON_SKILL_FILES = [
    'README.md', 'SKILL_TEMPLATE.md'
]


def extract_yaml_section(file_path):
    """Extract YAML front-matter from file."""
    with open(file_path, 'r') as f:
        content = f.read()

    match = re.match(r'^---\n(.*?)\n---', content, re.DOTALL)
    if match:
        return match.group(1)
    return None


def parse_yaml_structure(yaml_text, skill_name=None):
    """Parse YAML structure to check for required fields."""
    issues = []
    fields_found = {}

    lines = yaml_text.split('\n')

    for line in lines:
        line = line.rstrip()

        # Skip empty lines and comments
        if not line or line.startswith('#'):
            continue

        # Check for top-level fields
        if not line.startswith(' '):
            if ':' in line:
                field = line.split(':')[0].strip()
                value = line.split(':', 1)[1].strip() if ':' in line else ''
                fields_found[field] = value

    # Validate category if present
    if 'category' in fields_found:
        value = fields_found['category']
        if value and value not in VALID_CATEGORIES:
            issues.append(
                f"Invalid category '{value}'. "
                f"Must be one of: {', '.join(VALID_CATEGORIES)}"
            )

    # Validate name if present
    if 'name' in fields_found:
        value = fields_found['name']
        if value and not re.match(r'^[a-z][a-z0-9-]*$', value):
            issues.append(
                f"Invalid name '{value}'. "
                "Must be lowercase-hyphenated (e.g., 'yaml', 'git-workflows')"
            )
        # Check name matches directory name for directory-based skills
        if skill_name and value and value != skill_name:
            issues.append(
                f"Name '{value}' doesn't match directory name '{skill_name}'"
            )

    # Validate context if present
    if 'context' in fields_found:
        value = fields_found['context']
        if value and value not in VALID_CONTEXTS:
            issues.append(
                f"Invalid context '{value}'. "
                f"Must be one of: {', '.join(VALID_CONTEXTS)}"
            )

    # Validate agent if present
    if 'agent' in fields_found:
        value = fields_found['agent']
        if value and value not in VALID_AGENTS:
            issues.append(
                f"Invalid agent '{value}'. "
                f"Must be one of: {', '.join(VALID_AGENTS)}"
            )

    # Validate user-invocable if present
    if 'user-invocable' in fields_found:
        value = fields_found['user-invocable'].lower()
        if value not in ['true', 'false']:
            issues.append(
                f"Invalid user-invocable '{value}'. "
                "Must be 'true' or 'false'"
            )

    # Validate disable-model-invocation if present
    if 'disable-model-invocation' in fields_found:
        value = fields_found['disable-model-invocation'].lower()
        if value not in ['true', 'false']:
            issues.append(
                f"Invalid disable-model-invocation '{value}'. "
                "Must be 'true' or 'false'"
            )

    # Warn about unknown fields
    unknown_fields = set(fields_found.keys()) - VALID_FIELDS
    for field in unknown_fields:
        issues.append(f"Unknown field: '{field}' (may be ignored)")

    # Check for description (recommended but not strictly required)
    if 'description' not in fields_found:
        issues.append("Missing recommended field: description")

    return issues, fields_found


def validate_skill_directory(skill_dir):
    """Validate a skill in directory format (skills/<name>/SKILL.md)."""
    issues = []
    skill_name = skill_dir.name
    skill_file = skill_dir / "SKILL.md"

    if not skill_file.exists():
        issues.append(f"Missing SKILL.md file in {skill_name}/")
        return issues

    # Extract and validate YAML
    yaml_text = extract_yaml_section(skill_file)
    if not yaml_text:
        issues.append("Missing YAML front-matter (must start with ---)")
        return issues

    yaml_issues, _ = parse_yaml_structure(yaml_text, skill_name)
    issues.extend(yaml_issues)

    return issues


def validate_skill_file(file_path):
    """Validate a skill in flat file format (skills/<name>.md)."""
    issues = []

    yaml_text = extract_yaml_section(file_path)
    if not yaml_text:
        issues.append("Missing YAML front-matter (must start with ---)")
        return issues

    yaml_issues, _ = parse_yaml_structure(yaml_text)
    issues.extend(yaml_issues)

    return issues


def main():
    """Main validation function."""
    script_dir = Path(__file__).parent
    repo_dir = script_dir.parent
    skills_dir = repo_dir / "system-configs" / ".claude" / "skills"

    if not skills_dir.exists():
        print(f"Skills directory not found at {skills_dir}")
        print("   This is expected if skills haven't been created yet.")
        return 0

    # Find all skills (both directory-based and flat files)
    skills_to_validate = []

    # Check for directory-based skills (skills/<name>/SKILL.md)
    for item in skills_dir.iterdir():
        if item.is_dir() and not item.name.startswith('.'):
            skills_to_validate.append(('directory', item))

    # Check for flat file skills (skills/<name>.md) - legacy support
    for file_path in skills_dir.glob("*.md"):
        if file_path.name not in NON_SKILL_FILES:
            skills_to_validate.append(('file', file_path))

    if not skills_to_validate:
        print("No skill files found to validate")
        return 0

    print(f"Validating {len(skills_to_validate)} skills...\n")

    errors_found = False
    warnings_found = False

    for skill_type, skill_path in sorted(skills_to_validate, key=lambda x: str(x[1])):
        if skill_type == 'directory':
            issues = validate_skill_directory(skill_path)
            display_name = f"{skill_path.name}/"
        else:
            issues = validate_skill_file(skill_path)
            display_name = skill_path.name

        # Separate errors from warnings
        errors = [i for i in issues if not i.startswith("Unknown field") and "recommended" not in i.lower()]
        warnings = [i for i in issues if i.startswith("Unknown field") or "recommended" in i.lower()]

        if errors:
            errors_found = True
            print(f"  {display_name}:")
            for error in errors:
                print(f"   - {error}")
            for warning in warnings:
                print(f"   - [WARN] {warning}")
            print()
        elif warnings:
            warnings_found = True
            print(f"  {display_name}:")
            for warning in warnings:
                print(f"   - [WARN] {warning}")
            print()
        else:
            print(f"  {display_name}")

    print()
    if errors_found:
        print("Validation failed - fix errors above")
        return 1
    elif warnings_found:
        print(f"All {len(skills_to_validate)} skills valid (with warnings)")
        return 0
    else:
        print(f"All {len(skills_to_validate)} skills are valid")
        return 0


if __name__ == "__main__":
    sys.exit(main())
