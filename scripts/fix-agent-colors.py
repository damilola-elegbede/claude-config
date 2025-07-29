#!/usr/bin/env python3
"""Fix agent color compliance issues based on expected categories."""

import re
from pathlib import Path

agents_dir = Path('/Users/damilola/Documents/Projects/claude-config/.claude/agents')

# Color fixes based on the analysis
color_fixes = {
    'api-architect': 'purple',  # Architecture
    'business-analyst': 'yellow',  # Analysis
    'cloud-architect': 'orange',  # Infrastructure
    'codebase-analyst': 'yellow',  # Analysis
    'debugger': 'orange',  # Operations
    'devops': 'orange',  # Infrastructure
    'documentation-finder': 'orange',  # Operations
    'error-resolver': 'orange',  # Operations
    'principal-architect': 'purple',  # Architecture
    'researcher': 'yellow',  # Analysis
    'search-coordinator': 'orange',  # Operations
    'security-auditor': 'red',  # Security
    'security-tester': 'red',  # Security
    'tech-writer': 'yellow',  # Analysis
    'ui-designer': 'purple',  # Design
}

fixed_count = 0

for agent_name, new_color in color_fixes.items():
    agent_file = agents_dir / f"{agent_name}.md"
    
    if not agent_file.exists():
        print(f"Warning: {agent_name}.md not found")
        continue
    
    with open(agent_file, 'r') as f:
        content = f.read()
    
    # Find current color
    color_match = re.search(r'^(color:\s*)(\w+)', content, re.MULTILINE)
    if color_match:
        current_color = color_match.group(2)
        if current_color != new_color:
            # Replace color
            new_content = re.sub(
                r'^(color:\s*)\w+',
                f'\\1{new_color}',
                content,
                flags=re.MULTILINE
            )
            
            with open(agent_file, 'w') as f:
                f.write(new_content)
            
            print(f"Fixed {agent_name}: {current_color} → {new_color}")
            fixed_count += 1
        else:
            print(f"Skipped {agent_name}: already has correct color {new_color}")
    else:
        print(f"Warning: No color field found in {agent_name}.md")

print(f"\nTotal: Fixed colors in {fixed_count} agents")