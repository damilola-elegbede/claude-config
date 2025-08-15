#!/usr/bin/env python3
"""Find actual naked code blocks (opening ``` without language)"""

import os
import re

def check_file(filepath):
    """Check a file for naked code blocks"""
    issues = []
    
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            lines = f.readlines()
    except (UnicodeDecodeError, IOError):
        return issues
    
    in_code_block = False
    code_block_lang = None
    
    for line_num, line in enumerate(lines, 1):
        stripped = line.strip()
        
        # Check for code block markers
        if stripped.startswith('```'):
            if not in_code_block:
                # Starting a code block
                lang = stripped[3:].strip()
                if not lang:
                    # This is a naked code block!
                    issues.append({
                        'line': line_num,
                        'content': line.rstrip(),
                        'type': 'naked_opening'
                    })
                in_code_block = True
                code_block_lang = lang
            else:
                # Ending a code block
                in_code_block = False
                code_block_lang = None
    
    return issues

def main():
    # Find markdown files (excluding agents as per config)
    ignore_patterns = [
        'node_modules/',
        '.git/',
        '.tmp/',
        'CHANGELOG.md',
        'system-configs/.claude/agents/'
    ]
    
    for root, dirs, files in os.walk('.'):
        # Skip ignored directories
        dirs[:] = [d for d in dirs if not any(pattern.rstrip('/') in os.path.join(root, d) for pattern in ignore_patterns)]
        
        for file in files:
            if file.endswith('.md'):
                filepath = os.path.join(root, file)
                
                # Skip ignored files
                if any(pattern in filepath for pattern in ignore_patterns):
                    continue
                
                issues = check_file(filepath)
                if issues:
                    print(f"\n🔴 {filepath}:")
                    for issue in issues:
                        print(f"  Line {issue['line']}: {issue['content']}")

if __name__ == '__main__':
    main()