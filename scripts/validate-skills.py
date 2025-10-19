#!/usr/bin/env python3
"""
Skills YAML Validation
======================

Validates skill YAML front-matter for skills in system-configs/.claude/skills/
Ensures skills follow SKILL_TEMPLATE.md structure and conventions.
"""

import os
import re
import sys
from pathlib import Path

# Required fields in YAML front-matter based on SKILL_TEMPLATE.md
REQUIRED_FIELDS = [
    'name',
    'description',
    'category'
]

# Valid categories for skills
VALID_CATEGORIES = [
    'language',      # Programming languages (python, typescript, go, etc.)
    'format',        # File formats (yaml, markdown, json, etc.)
    'framework',     # Frameworks (react, fastapi, django, etc.)
    'infrastructure',# DevOps tools (docker, k8s, terraform, etc.)
    'workflow'       # Workflows and processes (git-workflows, cicd, etc.)
]

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


def parse_yaml_structure(yaml_text):
    """Parse YAML structure to check for required fields."""
    issues = []
    fields_found = set()

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
                fields_found.add(field)

                # Validate specific field values
                if field == 'category':
                    value = line.split(':', 1)[1].strip()
                    if value and value not in VALID_CATEGORIES:
                        issues.append(
                            f"Invalid category '{value}'. "
                            f"Must be one of: {', '.join(VALID_CATEGORIES)}"
                        )

                if field == 'name':
                    value = line.split(':', 1)[1].strip()
                    if value and not re.match(r'^[a-z][a-z0-9-]*$', value):
                        issues.append(
                            f"Invalid name '{value}'. "
                            "Must be lowercase-hyphenated (e.g., 'yaml', 'git-workflows')"
                        )

    # Check for missing required fields
    for required in REQUIRED_FIELDS:
        if required not in fields_found:
            issues.append(f"Missing required field: {required}")

    return issues


def validate_skill(file_path):
    """Validate a single skill file."""
    issues = []

    # Extract YAML front-matter
    yaml_text = extract_yaml_section(file_path)
    if not yaml_text:
        issues.append("Missing YAML front-matter (must start with ---)")
        return issues

    # Validate YAML structure
    yaml_issues = parse_yaml_structure(yaml_text)
    issues.extend(yaml_issues)

    return issues


def main():
    """Main validation function."""
    # Find skills directory
    script_dir = Path(__file__).parent
    repo_dir = script_dir.parent
    skills_dir = repo_dir / "system-configs" / ".claude" / "skills"

    if not skills_dir.exists():
        print(f"✅ Skills directory not found at {skills_dir}")
        print("   This is expected if skills haven't been created yet.")
        return 0

    # Find all skill files
    skill_files = []
    for file_path in skills_dir.glob("*.md"):
        if file_path.name not in NON_SKILL_FILES:
            skill_files.append(file_path)

    if not skill_files:
        print("✅ No skill files found to validate")
        return 0

    print(f"🔍 Validating {len(skill_files)} skill files...\n")

    errors_found = False
    for file_path in sorted(skill_files):
        issues = validate_skill(file_path)

        if issues:
            errors_found = True
            print(f"❌ {file_path.name}:")
            for issue in issues:
                print(f"   - {issue}")
            print()
        else:
            print(f"✅ {file_path.name}")

    print()
    if errors_found:
        print("❌ Validation failed - fix issues above")
        return 1
    else:
        print(f"✅ All {len(skill_files)} skill files are valid")
        return 0


if __name__ == "__main__":
    sys.exit(main())
