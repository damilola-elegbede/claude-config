#!/usr/bin/env python3
"""Quick YAML front-matter checker for agent files."""

import os
import yaml
import sys
from pathlib import Path

def check_yaml_frontmatter(filepath):
    """Check if a file has valid YAML front-matter."""
    issues = []
    
    try:
        with open(filepath, 'r') as f:
            content = f.read()
            
        # Check if file starts with ---
        if not content.startswith('---\n'):
            issues.append("Missing opening YAML delimiter '---'")
            return issues
            
        # Find the closing ---
        lines = content.split('\n')
        closing_index = -1
        
        for i in range(1, len(lines)):
            if lines[i] == '---':
                closing_index = i
                break
                
        if closing_index == -1:
            issues.append("Missing closing YAML delimiter '---'")
            
        # Try to parse the YAML
        if closing_index > 0:
            yaml_content = '\n'.join(lines[1:closing_index])
            try:
                data = yaml.safe_load(yaml_content)
                if not isinstance(data, dict):
                    issues.append("YAML content is not a dictionary")
            except yaml.YAMLError as e:
                issues.append(f"YAML parsing error: {str(e)}")
        
    except Exception as e:
        issues.append(f"File reading error: {str(e)}")
        
    return issues

def main():
    agents_dir = Path("/Users/damilola/Documents/Projects/claude-config/.claude/agents")
    
    if not agents_dir.exists():
        print("Agents directory not found!")
        sys.exit(1)
        
    print("Checking YAML front-matter in agent files...\n")
    
    issue_files = []
    clean_files = []
    
    for md_file in sorted(agents_dir.glob("*.md")):
        issues = check_yaml_frontmatter(md_file)
        
        if issues:
            issue_files.append((md_file.name, issues))
            print(f"❌ {md_file.name}")
            for issue in issues:
                print(f"   - {issue}")
        else:
            clean_files.append(md_file.name)
            
    print(f"\n\nSummary:")
    print(f"- Files with issues: {len(issue_files)}")
    print(f"- Clean files: {len(clean_files)}")
    
    if clean_files:
        print(f"\n✅ Clean files: {', '.join(clean_files)}")

if __name__ == "__main__":
    main()