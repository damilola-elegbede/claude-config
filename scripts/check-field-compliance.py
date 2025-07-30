#!/usr/bin/env python3
"""Check for field compliance issues in agent files."""

import re
from pathlib import Path

agents_dir = Path('/Users/damilola/Documents/Projects/claude-config/.claude/agents')
skip_files = {'README.md', 'AGENT_CATEGORIES.md', 'AGENT_TEMPLATE.md', 'AUDIT_VERIFICATION_PROTOCOL.md'}

# Valid fields according to local template
valid_fields = {'name', 'description', 'color', 'tools'}

issues = {}

for agent_file in agents_dir.glob('*.md'):
    if agent_file.name in skip_files:
        continue
    
    with open(agent_file, 'r') as f:
        content = f.read()
    
    # Extract YAML frontmatter
    yaml_match = re.search(r'^---\n(.*?)\n---', content, re.DOTALL)
    if not yaml_match:
        continue
    
    yaml_content = yaml_match.group(1)
    agent_name = agent_file.stem
    
    # Find all fields in the YAML
    extra_fields = []
    for line in yaml_content.split('\n'):
        if ':' in line and not line.strip().startswith('#'):
            field = line.split(':', 1)[0].strip()
            if field and field not in valid_fields:
                extra_fields.append(field)
    
    if extra_fields:
        issues[agent_name] = extra_fields

if issues:
    print("Field compliance issues found:")
    print("="*60)
    for agent, fields in sorted(issues.items()):
        print(f"{agent}: Extra fields - {', '.join(fields)}")
    print(f"\nTotal agents with issues: {len(issues)}")
else:
    print("No field compliance issues found! All agents have only valid fields.")