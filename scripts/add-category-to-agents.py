#!/usr/bin/env python3
"""Add category field to all agents based on their color and purpose."""

import re
from pathlib import Path

agents_dir = Path('/Users/damilola/Documents/Projects/claude-config/.claude/agents')
skip_files = {'README.md', 'AGENT_CATEGORIES.md', 'AGENT_TEMPLATE.md', 'AUDIT_VERIFICATION_PROTOCOL.md'}

# Map colors to categories (some colors map to multiple categories)
color_to_categories = {
    'blue': 'development',
    'orange': ['infrastructure', 'operations'],  # Need to check agent purpose
    'purple': ['architecture', 'design'],  # Need to check agent purpose
    'green': 'quality',
    'red': 'security',
    'yellow': 'analysis'
}

# Specific agent categorizations based on name/purpose
agent_categories = {
    # Development
    'backend-engineer': 'development',
    'frontend-engineer': 'development',
    'database-admin': 'development',
    'database-migration-specialist': 'development',
    'integration-specialist': 'development',
    'ml-engineer': 'development',
    'mobile-engineer': 'development',
    'data-engineer': 'development',
    
    # Infrastructure
    'devops': 'infrastructure',
    'cloud-architect': 'infrastructure',
    'network-engineer': 'infrastructure',
    
    # Architecture
    'api-architect': 'architecture',
    'principal-architect': 'architecture',
    
    # Design
    'ui-designer': 'design',
    'mobile-ui': 'design',
    
    # Quality
    'test-engineer': 'quality',
    'performance-engineer': 'quality',
    'code-reviewer': 'quality',
    'accessibility-auditor': 'quality',
    'api-contract-tester': 'quality',
    
    # Security
    'security-auditor': 'security',
    'security-tester': 'security',
    'agent-auditor': 'security',
    
    # Analysis
    'data-scientist': 'analysis',
    'business-analyst': 'analysis',
    'codebase-analyst': 'analysis',
    'tech-writer': 'analysis',
    'researcher': 'analysis',
    'api-documenter': 'analysis',  # Moving to same category as tech-writer
    
    # Operations
    'incident-commander': 'operations',
    'debugger': 'operations',
    'product-strategist': 'operations',
    'file-navigator': 'operations',
    'dependency-manager': 'operations',
    'git-workflow': 'operations',
    'config-specialist': 'operations',
    'file-writer': 'operations',
    'documentation-finder': 'operations',
    'error-resolver': 'operations',
    'search-coordinator': 'operations',
}

updated_count = 0
already_has_category = 0

for agent_file in agents_dir.glob('*.md'):
    if agent_file.name in skip_files:
        continue
    
    with open(agent_file, 'r') as f:
        content = f.read()
    
    agent_name = agent_file.stem
    
    # Check if category already exists
    if re.search(r'^category:', content, re.MULTILINE):
        already_has_category += 1
        print(f"Skipping {agent_name}: already has category field")
        continue
    
    # Determine category
    if agent_name in agent_categories:
        category = agent_categories[agent_name]
    else:
        # Fall back to color-based categorization
        color_match = re.search(r'^color:\s*(\w+)', content, re.MULTILINE)
        if color_match:
            color = color_match.group(1)
            category_mapping = color_to_categories.get(color)
            if isinstance(category_mapping, list):
                # For colors that map to multiple categories, we need more info
                print(f"Warning: {agent_name} with color {color} could be multiple categories")
                continue
            else:
                category = category_mapping
        else:
            print(f"Warning: No color found for {agent_name}")
            continue
    
    # Add category field after color field
    new_content = re.sub(
        r'^(color:\s*\w+)$',
        r'\1\ncategory: ' + category,
        content,
        flags=re.MULTILINE
    )
    
    if new_content != content:
        with open(agent_file, 'w') as f:
            f.write(new_content)
        print(f"Updated {agent_name}: added category '{category}'")
        updated_count += 1
    else:
        print(f"Failed to update {agent_name}")

# Also update api-documenter to have yellow color for Analysis category
api_doc_file = agents_dir / 'api-documenter.md'
if api_doc_file.exists():
    with open(api_doc_file, 'r') as f:
        content = f.read()
    
    # Change color from blue to yellow
    new_content = re.sub(r'^color:\s*blue', 'color: yellow', content, flags=re.MULTILINE)
    
    if new_content != content:
        with open(api_doc_file, 'w') as f:
            f.write(new_content)
        print(f"Updated api-documenter: changed color blue → yellow")

print(f"\nSummary:")
print(f"- Updated {updated_count} agents with category field")
print(f"- {already_has_category} agents already had category field")