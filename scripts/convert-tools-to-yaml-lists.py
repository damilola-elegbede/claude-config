#!/usr/bin/env python3
"""Convert tools field from comma-separated string to YAML list in all agent files."""

import os
import re
from pathlib import Path

def convert_tools_to_yaml_list(content):
    """Convert tools field from string to YAML list format."""
    # Pattern to match the tools line in frontmatter
    pattern = r'^(tools:\s*)([^\n]+)$'
    
    def replacer(match):
        prefix = match.group(1)
        tools_string = match.group(2).strip()
        
        # Split by comma and clean up
        tools = [tool.strip() for tool in tools_string.split(',')]
        
        # Build YAML list
        yaml_list = "tools:\n"
        for tool in tools:
            yaml_list += f"  - {tool}\n"
        
        return yaml_list.rstrip()
    
    # Process line by line to handle frontmatter correctly
    lines = content.split('\n')
    in_frontmatter = False
    frontmatter_count = 0
    result_lines = []
    
    for i, line in enumerate(lines):
        if line.strip() == '---':
            frontmatter_count += 1
            in_frontmatter = frontmatter_count == 1
            result_lines.append(line)
        elif in_frontmatter and line.startswith('tools:') and ':' in line[6:]:
            # This is a tools line with inline value
            match = re.match(pattern, line)
            if match:
                # Get the tools and convert to list
                tools_string = match.group(2).strip()
                tools = [tool.strip() for tool in tools_string.split(',')]
                
                # Add YAML list
                result_lines.append("tools:")
                for tool in tools:
                    result_lines.append(f"  - {tool}")
            else:
                result_lines.append(line)
        else:
            result_lines.append(line)
    
    return '\n'.join(result_lines)

def process_agent_files():
    """Process all agent markdown files."""
    agents_dir = Path(__file__).parent.parent / '.claude' / 'agents'
    
    # Skip these files
    skip_files = {'AGENT_TEMPLATE.md', 'AGENT_CATEGORIES.md', 'README.md', 'AUDIT_VERIFICATION_PROTOCOL.md'}
    
    converted_files = []
    already_list_files = []
    
    for agent_file in agents_dir.glob('*.md'):
        if agent_file.name in skip_files:
            continue
            
        try:
            content = agent_file.read_text()
            
            # Check if already in list format
            if re.search(r'^tools:\s*\n\s+-', content, re.MULTILINE):
                already_list_files.append(agent_file.name)
                continue
            
            # Check if has inline tools
            if re.search(r'^tools:\s*[A-Za-z]', content, re.MULTILINE):
                new_content = convert_tools_to_yaml_list(content)
                agent_file.write_text(new_content)
                converted_files.append(agent_file.name)
                
        except Exception as e:
            print(f"Error processing {agent_file.name}: {e}")
    
    print(f"Converted {len(converted_files)} files to YAML list format")
    print(f"Already in list format: {len(already_list_files)} files")
    
    if converted_files:
        print("\nConverted files:")
        for f in sorted(converted_files):
            print(f"  - {f}")

if __name__ == "__main__":
    process_agent_files()