#!/usr/bin/env python3
"""
Update all agent YAML front-matter to standardized format.
This script processes all agent markdown files and ensures they have proper YAML structure.
"""

import os
import re
import yaml
from pathlib import Path

# Define the standard YAML template structure
YAML_TEMPLATE = {
    'name': '',
    'description': '',
    'color': '',
    'specialization_level': '',
    'domain_expertise': [],
    'tools': {
        'allowed': [],
        'forbidden': []
    },
    'coordination_protocols': {
        'handoff_to': [],
        'parallel_compatible': [],
        'escalation_path': []
    },
    'knowledge_base': [],
    'examples': []
}

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

def extract_yaml_and_content(file_content):
    """Extract YAML front-matter and markdown content from file."""
    yaml_match = re.match(r'^---\n(.*?)\n---\n(.*)', file_content, re.DOTALL)
    if yaml_match:
        yaml_str = yaml_match.group(1)
        content = yaml_match.group(2)
        try:
            yaml_data = yaml.safe_load(yaml_str)
        except:
            yaml_data = {}
        return yaml_data, content
    return {}, file_content

def standardize_yaml(yaml_data, agent_name):
    """Standardize YAML data to match our template."""
    standardized = {}
    
    # Basic fields
    standardized['name'] = yaml_data.get('name', agent_name)
    standardized['description'] = yaml_data.get('description', f'Expert {agent_name} agent')
    standardized['color'] = yaml_data.get('color', COLOR_MAP.get(agent_name, 'white'))
    standardized['specialization_level'] = yaml_data.get('specialization_level', 'specialist')
    
    # Domain expertise
    standardized['domain_expertise'] = yaml_data.get('domain_expertise', [])
    
    # Tools section
    tools = yaml_data.get('tools', {})
    if isinstance(tools, dict):
        allowed_tools = tools.get('allowed', [])
        forbidden_tools = tools.get('forbidden', [])
        rationale = tools.get('rationale', '')
        
        # Convert tool names to structured format with rationales
        standardized['tools'] = {
            'allowed': {},
            'forbidden': {}
        }
        
        for tool in allowed_tools:
            if isinstance(tool, str):
                standardized['tools']['allowed'][tool.lower()] = f"Required for {agent_name} operations"
        
        for tool in forbidden_tools:
            if isinstance(tool, str):
                standardized['tools']['forbidden'][tool.lower()] = f"Out of scope for {agent_name}"
    else:
        standardized['tools'] = {'allowed': {}, 'forbidden': {}}
    
    # Coordination protocols
    standardized['coordination_protocols'] = {
        'handoff_to': {},
        'parallel_compatible': [],
        'escalation_path': {}
    }
    
    # Handle old format fields
    if 'parallel_compatible' in yaml_data:
        standardized['coordination_protocols']['parallel_compatible'] = yaml_data['parallel_compatible']
    
    if 'escalation_to' in yaml_data:
        escalation = yaml_data['escalation_to']
        if isinstance(escalation, list) and escalation:
            standardized['coordination_protocols']['escalation_path'][escalation[0]] = "Complex requirements exceed capabilities"
    
    # Knowledge base (empty for now, will be populated from content analysis)
    standardized['knowledge_base'] = []
    
    # Examples (empty for now, will be populated from content analysis)
    standardized['examples'] = []
    
    return standardized

def update_agent_file(file_path):
    """Update a single agent file with standardized YAML."""
    agent_name = Path(file_path).stem
    
    # Read file
    with open(file_path, 'r') as f:
        content = f.read()
    
    # Extract YAML and content
    yaml_data, markdown_content = extract_yaml_and_content(content)
    
    # Standardize YAML
    standardized_yaml = standardize_yaml(yaml_data, agent_name)
    
    # Write back
    with open(file_path, 'w') as f:
        f.write('---\n')
        yaml.dump(standardized_yaml, f, default_flow_style=False, sort_keys=False, allow_unicode=True)
        f.write('---\n')
        f.write(markdown_content)
    
    print(f"Updated: {agent_name}")
    return standardized_yaml

def main():
    """Process all agent files."""
    agents_dir = '/Users/damilola/Documents/Projects/claude-config/.claude/agents'
    
    # Get all agent markdown files
    agent_files = [f for f in Path(agents_dir).glob('*.md') if f.name != 'README.md']
    
    print(f"Found {len(agent_files)} agent files to update")
    
    updated_agents = {}
    for agent_file in agent_files:
        try:
            yaml_data = update_agent_file(agent_file)
            updated_agents[agent_file.stem] = yaml_data
        except Exception as e:
            print(f"Error updating {agent_file.stem}: {e}")
    
    print(f"\nSuccessfully updated {len(updated_agents)} agents")
    
    # Generate summary report
    with open('/Users/damilola/Documents/Projects/claude-config/docs/yaml-update-report.md', 'w') as f:
        f.write("# YAML Front-Matter Update Report\n\n")
        f.write(f"Updated {len(updated_agents)} agents with standardized YAML structure.\n\n")
        
        f.write("## Agent Summary\n\n")
        for name, data in sorted(updated_agents.items()):
            f.write(f"### {name}\n")
            f.write(f"- **Color**: {data['color']}\n")
            f.write(f"- **Level**: {data['specialization_level']}\n")
            f.write(f"- **Tools**: {len(data['tools']['allowed'])} allowed, {len(data['tools']['forbidden'])} forbidden\n")
            f.write(f"- **Parallel Compatible**: {len(data['coordination_protocols']['parallel_compatible'])} agents\n\n")

if __name__ == '__main__':
    main()