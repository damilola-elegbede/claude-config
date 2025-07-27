#!/usr/bin/env python3
"""
YAML Front-Matter Validation Script for Agent Files.

This module validates YAML front-matter in agent markdown files to ensure they
conform to the required structure. It checks for proper YAML delimiters, validates
YAML syntax, and reports any issues found.

Usage:
    python check_yaml.py [agents_directory]
    
If no directory is specified, defaults to '.claude/agents' relative to the current directory.
"""

import os
import yaml
import sys
import argparse
from pathlib import Path
from typing import List

def check_yaml_frontmatter(filepath: str) -> List[str]:
    """
    Check if a file has valid YAML front-matter.
    
    Args:
        filepath: Path to the markdown file to check.
        
    Returns:
        List of issue descriptions found in the file. Empty list if no issues.
    """
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

def main() -> None:
    """
    Main function to validate YAML front-matter in all agent files.
    
    Parses command-line arguments and validates all markdown files in the
    specified agents directory.
    """
    parser = argparse.ArgumentParser(
        description="Validate YAML front-matter in agent markdown files"
    )
    parser.add_argument(
        "agents_dir",
        nargs="?",
        default=".claude/agents",
        help="Path to the agents directory (default: .claude/agents)"
    )
    args = parser.parse_args()
    
    agents_dir = Path(args.agents_dir)
    
    if not agents_dir.exists():
        raise FileNotFoundError(f"Agents directory not found: {agents_dir}")
        
    print("Checking YAML front-matter in agent files...\n")
    
    issue_files: List[tuple[str, List[str]]] = []
    clean_files: List[str] = []
    
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