#!/usr/bin/env python3
"""Check for any remaining color compliance issues."""

import re
from pathlib import Path

agents_dir = Path('/Users/damilola/Documents/Projects/claude-config/.claude/agents')
skip_files = {'README.md', 'AGENT_CATEGORIES.md', 'AGENT_TEMPLATE.md', 'AUDIT_VERIFICATION_PROTOCOL.md'}

# Expected colors based on agent patterns
expected_colors = {
    # Development (blue)
    'backend-engineer': 'blue',
    'frontend-engineer': 'blue',
    'database-admin': 'blue',
    'database-migration-specialist': 'blue',
    'integration-specialist': 'blue',
    'ml-engineer': 'blue',
    'mobile-engineer': 'blue',
    'data-engineer': 'blue',
    'api-documenter': 'blue',
    
    # Infrastructure (orange)
    'devops': 'orange',
    'cloud-architect': 'orange',
    'network-engineer': 'orange',
    
    # Architecture (purple)
    'api-architect': 'purple',
    'principal-architect': 'purple',
    
    # Design (purple)
    'ui-designer': 'purple',
    'mobile-ui': 'purple',
    
    # Quality (green)
    'test-engineer': 'green',
    'performance-engineer': 'green',
    'code-reviewer': 'green',
    'accessibility-auditor': 'green',
    'api-contract-tester': 'green',
    
    # Security (red)
    'security-auditor': 'red',
    'security-tester': 'red',
    'agent-auditor': 'red',
    
    # Analysis (yellow)
    'data-scientist': 'yellow',
    'business-analyst': 'yellow',
    'codebase-analyst': 'yellow',
    'tech-writer': 'yellow',
    'researcher': 'yellow',
    
    # Operations (orange)
    'incident-commander': 'orange',
    'debugger': 'orange',
    'product-strategist': 'orange',
    'file-navigator': 'orange',
    'dependency-manager': 'orange',
    'git-workflow': 'orange',
    'config-specialist': 'orange',
    'file-writer': 'orange',
    'documentation-finder': 'orange',
    'error-resolver': 'orange',
    'search-coordinator': 'orange',
}

issues = []

for agent_file in agents_dir.glob('*.md'):
    if agent_file.name in skip_files:
        continue
    
    with open(agent_file, 'r') as f:
        content = f.read()
    
    agent_name = agent_file.stem
    
    # Extract color from YAML
    color_match = re.search(r'^color:\s*(\w+)', content, re.MULTILINE)
    if color_match:
        current_color = color_match.group(1)
        
        if agent_name in expected_colors:
            expected = expected_colors[agent_name]
            if current_color != expected:
                issues.append({
                    'agent': agent_name,
                    'current': current_color,
                    'expected': expected
                })
        else:
            print(f"Unknown agent category for: {agent_name} (has color: {current_color})")

if issues:
    print("Color compliance issues found:")
    print("="*60)
    for issue in issues:
        print(f"{issue['agent']}: {issue['current']} → {issue['expected']}")
else:
    print("No color compliance issues found!")

print(f"\nTotal issues: {len(issues)}")