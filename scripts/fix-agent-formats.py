#!/usr/bin/env python3
"""Fix agent format issues: convert tools to comma-separated and remove extra fields."""

import os
import re
from pathlib import Path

agents_dir = Path('/Users/damilola/Documents/Projects/claude-config/.claude/agents')
skip_files = {'README.md', 'AGENT_CATEGORIES.md', 'AGENT_TEMPLATE.md', 'AUDIT_VERIFICATION_PROTOCOL.md'}

# Valid fields according to local template
valid_fields = {'name', 'description', 'color', 'tools'}

fixed_count = 0
field_removal_count = 0

for agent_file in agents_dir.glob('*.md'):
    if agent_file.name in skip_files:
        continue
    
    with open(agent_file, 'r') as f:
        content = f.read()
    
    # Extract YAML frontmatter and content after
    yaml_match = re.search(r'^(---\n)(.*?)\n(---\n)(.*)', content, re.DOTALL)
    if not yaml_match:
        continue
    
    yaml_start = yaml_match.group(1)
    yaml_content = yaml_match.group(2)
    yaml_end = yaml_match.group(3)
    rest_content = yaml_match.group(4)
    
    original_yaml = yaml_content
    agent_name = agent_file.stem
    modified = False
    
    # Parse YAML fields
    fields = {}
    current_field = None
    field_lines = []
    
    for line in yaml_content.split('\n'):
        if line and not line.startswith(' '):
            # Save previous field if exists
            if current_field:
                fields[current_field] = '\n'.join(field_lines)
            # Start new field
            if ':' in line:
                current_field = line.split(':', 1)[0].strip()
                field_value = line.split(':', 1)[1].strip()
                if field_value:
                    field_lines = [field_value]
                else:
                    field_lines = []
            else:
                current_field = None
                field_lines = []
        elif current_field:
            field_lines.append(line)
    
    # Save last field
    if current_field:
        fields[current_field] = '\n'.join(field_lines)
    
    # Process tools field if it uses list format
    if 'tools' in fields:
        tools_content = fields['tools']
        if '\n  -' in tools_content or tools_content.startswith('\n  -'):
            # Extract tool names from list format
            tool_names = []
            for line in tools_content.split('\n'):
                line = line.strip()
                if line.startswith('- '):
                    tool_names.append(line[2:].strip())
            
            if tool_names:
                # Convert to comma-separated format
                fields['tools'] = ', '.join(tool_names)
                modified = True
                print(f"Converting tools for {agent_name}: {len(tool_names)} tools")
    
    # Remove extra fields
    removed_fields = []
    for field in list(fields.keys()):
        if field not in valid_fields:
            removed_fields.append(field)
            del fields[field]
            modified = True
    
    if removed_fields:
        field_removal_count += 1
        print(f"Removing fields from {agent_name}: {', '.join(removed_fields)}")
    
    # Rebuild YAML if modified
    if modified:
        # Rebuild in correct order
        new_yaml_lines = []
        field_order = ['name', 'description', 'color', 'tools']
        
        for field in field_order:
            if field in fields:
                value = fields[field]
                if value and '\n' not in value:
                    new_yaml_lines.append(f"{field}: {value}")
                elif field == 'tools' and not value:
                    # Skip empty tools
                    pass
                else:
                    # Multi-line value (shouldn't happen with our fields)
                    new_yaml_lines.append(f"{field}:")
                    new_yaml_lines.append(value)
        
        new_yaml = '\n'.join(new_yaml_lines)
        
        # Write back
        new_content = yaml_start + new_yaml + '\n' + yaml_end + rest_content
        
        with open(agent_file, 'w') as f:
            f.write(new_content)
        
        fixed_count += 1

print(f"\nSummary:")
print(f"- Fixed tool format in {fixed_count} agents")
print(f"- Removed extra fields from {field_removal_count} agents")