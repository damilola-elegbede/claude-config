#!/usr/bin/env python3
"""
Validate agent YAML front-matter compliance.
This script checks all agent files for proper YAML structure and required fields.
"""

import os
import re
import sys
from pathlib import Path

# Required fields in YAML front-matter based on actual agent schema
REQUIRED_FIELDS = [
    'name',
    'description',
    'color',
    'tools'
]

# Valid values for specific fields
VALID_COLORS = ['blue', 'green', 'red', 'purple', 'yellow', 'orange', 'white', 'brown', 'cyan']

# Non-agent documentation files to skip
NON_AGENT_FILES = [
    'README.md', 'AGENT_CATEGORIES.md', 'AGENT_TEMPLATE.md', 
    'AUDIT_VERIFICATION_PROTOCOL.md', 'AGENT_SELECTION_GUIDE.md',
    'ENHANCEMENT_SUMMARY.md', 'PARALLEL_EXECUTION_GUIDE.md',
    'SECURITY_ACCESS_PATTERNS.md', 'TOOL_ACCESS_GUIDE.md',
    'TOOL_ACCESS_STANDARDIZATION_SUMMARY.md'
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
    current_section = None
    
    for line in lines:
        line = line.rstrip()
        
        # Skip empty lines
        if not line:
            continue
        
        # Check for top-level fields
        if not line.startswith(' '):
            if ':' in line:
                field = line.split(':')[0].strip()
                fields_found.add(field)
                current_section = field
                
                # Validate specific field values
                if field == 'color':
                    value = line.split(':', 1)[1].strip()
                    if value and value not in VALID_COLORS:
                        issues.append(f"Invalid color '{value}'. Must be one of: {', '.join(VALID_COLORS)}")
                
                # Remove specialization_level check as it's not required
        
        # Tools can be a simple list or have subfields - both are valid
    
    # Check for missing required fields
    for field in REQUIRED_FIELDS:
        if field not in fields_found:
            issues.append(f"Missing required field: {field}")
    
    return fields_found, issues

def validate_agent_file(file_path):
    """Validate a single agent file."""
    agent_name = Path(file_path).stem
    issues = []
    
    # Skip non-agent files
    if Path(file_path).name in NON_AGENT_FILES:
        return agent_name, []
    
    # Extract YAML section
    yaml_section = extract_yaml_section(file_path)
    if not yaml_section:
        issues.append("No YAML front-matter found (missing --- delimiters)")
        return agent_name, issues
    
    # Parse and validate YAML structure
    fields_found, yaml_issues = parse_yaml_structure(yaml_section)
    issues.extend(yaml_issues)
    
    # Check name field matches filename
    name_match = re.search(r'^name:\s*(.+)$', yaml_section, re.MULTILINE)
    if name_match:
        yaml_name = name_match.group(1).strip()
        if yaml_name != agent_name:
            issues.append(f"Name mismatch: YAML says '{yaml_name}' but filename is '{agent_name}.md'")
    
    # Check description length - increased limit to 250 for complex agents
    desc_match = re.search(r'^description:\s*(.+)$', yaml_section, re.MULTILINE)
    if desc_match:
        description = desc_match.group(1).strip()
        if len(description) > 250:
            issues.append(f"Description too long ({len(description)} chars). Should be under 250.")
    
    # Check for empty lists
    if re.search(r'domain_expertise:\s*$', yaml_section, re.MULTILINE):
        if not re.search(r'domain_expertise:.*?\n\s+-', yaml_section, re.DOTALL):
            issues.append("domain_expertise list is empty")
    
    return agent_name, issues

def main():
    """Validate all agent files."""
    agents_dir = Path('/Users/damilola/Documents/Projects/claude-config/.claude/agents')
    
    if not agents_dir.exists():
        print(f"Error: Agents directory not found at {agents_dir}")
        sys.exit(1)
    
    # Get all agent markdown files, excluding non-agent documentation
    agent_files = sorted([f for f in agents_dir.glob('*.md') if f.name not in NON_AGENT_FILES])
    
    print(f"Validating {len(agent_files)} agent files...\n")
    
    all_valid = True
    validation_results = []
    
    for agent_file in agent_files:
        agent_name, issues = validate_agent_file(agent_file)
        validation_results.append((agent_name, issues))
        
        if issues:
            all_valid = False
            print(f"❌ {agent_name}")
            for issue in issues:
                print(f"   - {issue}")
        else:
            print(f"✅ {agent_name}")
    
    # Generate summary
    print(f"\n{'='*50}")
    print("VALIDATION SUMMARY")
    print(f"{'='*50}")
    
    valid_count = sum(1 for _, issues in validation_results if not issues)
    invalid_count = len(validation_results) - valid_count
    
    print(f"Total agents: {len(validation_results)}")
    print(f"Valid: {valid_count}")
    print(f"Invalid: {invalid_count}")
    
    if all_valid:
        print("\n✅ All agents have valid YAML front-matter!")
        sys.exit(0)
    else:
        print(f"\n❌ {invalid_count} agents have validation issues")
        
        # Save detailed report
        report_path = Path('/Users/damilola/Documents/Projects/claude-config/docs/yaml-validation-report.md')
        with open(report_path, 'w') as f:
            f.write("# Agent YAML Validation Report\n\n")
            f.write(f"Total agents validated: {len(validation_results)}\n\n")
            
            f.write("## Validation Issues\n\n")
            for agent_name, issues in validation_results:
                if issues:
                    f.write(f"### {agent_name}\n")
                    for issue in issues:
                        f.write(f"- {issue}\n")
                    f.write("\n")
            
            f.write("## Valid Agents\n\n")
            for agent_name, issues in validation_results:
                if not issues:
                    f.write(f"- ✅ {agent_name}\n")
        
        print(f"\nDetailed report saved to: {report_path}")
        sys.exit(1)

if __name__ == '__main__':
    main()