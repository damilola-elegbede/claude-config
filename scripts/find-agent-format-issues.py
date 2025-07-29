#!/usr/bin/env python3
"""Find agents with format issues that need fixing."""

import os
import re
from pathlib import Path

agents_dir = Path('/Users/damilola/Documents/Projects/claude-config/.claude/agents')
skip_files = {'README.md', 'AGENT_CATEGORIES.md', 'AGENT_TEMPLATE.md', 'AUDIT_VERIFICATION_PROTOCOL.md'}

# Valid fields according to local template
valid_fields = {'name', 'description', 'color', 'tools'}

issues = {
    'list_format_tools': [],
    'extra_fields': {},
    'color_issues': {}
}

# Check AGENT_CATEGORIES.md for expected colors
category_colors = {}
with open(agents_dir / 'AGENT_CATEGORIES.md', 'r') as f:
    content = f.read()
    # Extract category colors
    for match in re.finditer(r'### \d+\. \*\*(\w+)\*\* \((\w+)\)', content):
        category = match.group(1)
        color = match.group(2)
        category_colors[category.lower()] = color

print("Expected category colors:", category_colors)
print("\n" + "="*60 + "\n")

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
    
    # Check if tools use list format
    if re.search(r'^tools:\s*\n\s*-', yaml_content, re.MULTILINE):
        issues['list_format_tools'].append(agent_name)
    
    # Check for extra fields
    extra_fields = []
    for line in yaml_content.split('\n'):
        if ':' in line:
            field = line.split(':')[0].strip()
            if field and field not in valid_fields:
                extra_fields.append(field)
    
    if extra_fields:
        issues['extra_fields'][agent_name] = extra_fields
    
    # Check color
    color_match = re.search(r'^color:\s*(\w+)', yaml_content, re.MULTILINE)
    if color_match:
        color = color_match.group(1)
        # Try to determine expected color based on agent name patterns
        # This is approximate since we don't have category field
        if agent_name in ['backend-engineer', 'frontend-engineer', 'database-admin', 
                          'database-migration-specialist', 'integration-specialist',
                          'ml-engineer', 'mobile-engineer', 'data-engineer']:
            expected = 'blue'  # Development
        elif agent_name in ['devops', 'cloud-architect', 'network-engineer']:
            expected = 'orange'  # Infrastructure
        elif agent_name in ['api-architect', 'principal-architect']:
            expected = 'purple'  # Architecture
        elif agent_name in ['ui-designer', 'mobile-ui']:
            expected = 'purple'  # Design
        elif agent_name in ['test-engineer', 'performance-engineer', 'code-reviewer', 
                            'accessibility-auditor', 'api-contract-tester']:
            expected = 'green'  # Quality
        elif agent_name in ['security-auditor', 'security-tester', 'agent-auditor']:
            expected = 'red'  # Security
        elif agent_name in ['data-scientist', 'business-analyst', 'codebase-analyst', 
                            'tech-writer', 'researcher']:
            expected = 'yellow'  # Analysis
        elif agent_name in ['incident-commander', 'debugger', 'product-strategist',
                            'file-navigator', 'dependency-manager', 'git-workflow',
                            'config-specialist', 'file-writer', 'documentation-finder',
                            'error-resolver', 'search-coordinator']:
            expected = 'orange'  # Operations
        else:
            expected = None
        
        if expected and color != expected:
            issues['color_issues'][agent_name] = {'current': color, 'expected': expected}

# Print results
print("AGENTS WITH LIST FORMAT TOOLS:")
for agent in sorted(issues['list_format_tools']):
    print(f"  - {agent}")

print(f"\nTotal: {len(issues['list_format_tools'])} agents need tool format updates")

print("\n" + "="*60 + "\n")

print("AGENTS WITH EXTRA FIELDS:")
for agent, fields in sorted(issues['extra_fields'].items()):
    print(f"  - {agent}: {', '.join(fields)}")

print(f"\nTotal: {len(issues['extra_fields'])} agents have extra fields")

print("\n" + "="*60 + "\n")

print("AGENTS WITH COLOR ISSUES:")
for agent, colors in sorted(issues['color_issues'].items()):
    print(f"  - {agent}: {colors['current']} → {colors['expected']}")

print(f"\nTotal: {len(issues['color_issues'])} agents need color fixes")