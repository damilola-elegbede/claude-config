#!/usr/bin/env python3
"""
Update all agent YAML front-matter to standardized format without external dependencies.
"""

import os
import re
from pathlib import Path

# Color mapping for agent categories
COLOR_MAP = {
    'backend-engineer': 'blue',
    'frontend-engineer': 'blue', 
    'fullstack-dev': 'blue',
    'mobile-engineer': 'blue',
    'data-engineer': 'blue',
    'ml-engineer': 'blue',
    'test-engineer': 'green',
    'code-reviewer': 'green',
    'debugger': 'green',
    'security-auditor': 'green',
    'performance-engineer': 'green',
    'principal-architect': 'red',
    'api-architect': 'red',
    'ui-designer': 'red',
    'mobile-ui': 'red',
    'codebase-analyst': 'purple',
    'researcher': 'purple',
    'business-analyst': 'purple',
    'devops': 'yellow',
    'platform-engineer': 'yellow',
    'cloud-architect': 'yellow',
    'tech-writer': 'orange',
    'project-orchestrator': 'orange',
    'product-strategist': 'orange',
    'accessibility-auditor': 'white',
    'database-admin': 'white',
    'db-admin': 'white',
    'agent-architect': 'brown',
    'agent-auditor': 'brown',
    'arch-reviewer': 'brown',
    'tech-lead': 'brown',
    'senior-dev': 'blue',
    'qa-tester': 'green',
    'reliability-engineer': 'yellow',
    'test-data-manager': 'brown'
}

def extract_yaml_section(content):
    """Extract YAML front-matter section from content."""
    match = re.match(r'^---\n(.*?)\n---\n(.*)', content, re.DOTALL)
    if match:
        return match.group(1), match.group(2)
    return None, content

def parse_simple_yaml(yaml_text):
    """Parse simple YAML into a dictionary."""
    data = {}
    current_key = None
    current_list = []
    indent_stack = []
    
    lines = yaml_text.strip().split('\n')
    
    for line in lines:
        # Skip empty lines
        if not line.strip():
            continue
            
        # Calculate indentation
        indent = len(line) - len(line.lstrip())
        
        # Handle list items
        if line.strip().startswith('-'):
            item = line.strip()[1:].strip()
            if current_key and current_list is not None:
                current_list.append(item)
            continue
            
        # Handle key-value pairs
        if ':' in line:
            parts = line.split(':', 1)
            key = parts[0].strip()
            value = parts[1].strip() if len(parts) > 1 else ''
            
            # Simple key-value
            if value:
                data[key] = value
                current_key = key
                current_list = None
            else:
                # Start of a list or nested structure
                data[key] = []
                current_key = key
                current_list = data[key]
    
    return data

def create_standardized_yaml(agent_name, existing_data):
    """Create standardized YAML content."""
    # Extract basic info from existing data
    name = existing_data.get('name', agent_name)
    description = existing_data.get('description', f'Expert {agent_name} agent')
    color = existing_data.get('color', COLOR_MAP.get(agent_name, 'white'))
    level = existing_data.get('specialization_level', 'specialist')
    
    yaml_content = f"""---
name: {name}
description: {description}
color: {color}
specialization_level: {level}

domain_expertise:"""
    
    # Add domain expertise if exists
    if 'domain_expertise' in existing_data:
        for item in existing_data.get('domain_expertise', []):
            if isinstance(item, str) and item.strip():
                yaml_content += f"\n  - {item}"
    else:
        yaml_content += f"\n  - {agent_name.replace('-', '_')}_expertise"
    
    # Add tools section
    yaml_content += "\n\ntools:"
    yaml_content += "\n  allowed:"
    
    # Process allowed tools
    if 'tools' in existing_data:
        # Read current allowed tools from the file content
        yaml_content += "\n    read: \"Analyzing existing code and documentation\""
        yaml_content += "\n    write: \"Implementing features and fixes\""
        yaml_content += "\n    bash: \"Running commands and scripts\""
    
    yaml_content += "\n  forbidden:"
    yaml_content += "\n    deploy: \"Production deployment restricted to DevOps agents\""
    
    # Add coordination protocols
    yaml_content += "\n\ncoordination_protocols:"
    yaml_content += "\n  handoff_to:"
    yaml_content += "\n    test-engineer: \"Test implementation and validation\""
    yaml_content += "\n  parallel_compatible:"
    
    # Add parallel compatible agents
    if 'parallel_compatible' in existing_data:
        for agent in existing_data.get('parallel_compatible', []):
            if isinstance(agent, str) and agent.strip():
                yaml_content += f"\n    - {agent}"
    else:
        yaml_content += "\n    - test-engineer"
        yaml_content += "\n    - code-reviewer"
    
    yaml_content += "\n  escalation_path:"
    
    # Add escalation path
    if 'escalation_to' in existing_data:
        for agent in existing_data.get('escalation_to', []):
            if isinstance(agent, str) and agent.strip():
                yaml_content += f"\n    {agent}: \"Requirements exceed current capabilities\""
    else:
        yaml_content += "\n    principal-architect: \"System-wide architectural decisions\""
    
    # Add knowledge base and examples (empty for now)
    yaml_content += "\n\nknowledge_base:"
    yaml_content += "\n  - Domain knowledge will be added here"
    yaml_content += "\n\nexamples:"
    yaml_content += "\n  - scenario: \"Example scenario\""
    yaml_content += "\n    approach: \"How this agent handles it\""
    
    yaml_content += "\n---"
    
    return yaml_content

def update_agent_file(file_path):
    """Update a single agent file."""
    agent_name = Path(file_path).stem
    
    # Read the file
    with open(file_path, 'r') as f:
        content = f.read()
    
    # Extract YAML and markdown sections
    yaml_section, markdown_content = extract_yaml_section(content)
    
    # Parse existing YAML
    existing_data = {}
    if yaml_section:
        existing_data = parse_simple_yaml(yaml_section)
    
    # Create new standardized YAML
    new_yaml = create_standardized_yaml(agent_name, existing_data)
    
    # Write back the updated content
    with open(file_path, 'w') as f:
        f.write(new_yaml)
        f.write('\n')
        f.write(markdown_content)
    
    print(f"Updated: {agent_name}")

def main():
    """Process all agent files."""
    agents_dir = '/Users/damilola/Documents/Projects/claude-config/.claude/agents'
    
    # Get all agent markdown files
    agent_files = sorted([f for f in Path(agents_dir).glob('*.md') if f.name != 'README.md'])
    
    print(f"Found {len(agent_files)} agent files to update\n")
    
    for agent_file in agent_files:
        try:
            update_agent_file(agent_file)
        except Exception as e:
            print(f"Error updating {agent_file.stem}: {e}")
    
    print(f"\nCompleted YAML front-matter standardization")

if __name__ == '__main__':
    main()