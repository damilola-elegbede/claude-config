#!/usr/bin/env python3
"""
Comprehensive Markdown Quality Fix Script
Automatically fixes common markdownlint violations
"""

import os
import re
import sys
from pathlib import Path

class MarkdownFixer:
    def __init__(self):
        self.files_processed = 0
        self.files_modified = 0
        self.fixes_applied = {
            'code_language': 0,
            'trailing_spaces': 0,
            'indented_code': 0,
            'blank_lines': 0
        }
        
    def is_ignored_file(self, filepath):
        """Check if file should be ignored per markdownlint config"""
        ignore_patterns = [
            'node_modules/',
            '.git/',
            '.tmp/',
            'CHANGELOG.md',
            'system-configs/.claude/agents/'
        ]
        
        for pattern in ignore_patterns:
            if pattern in filepath:
                return True
        return False
    
    def detect_code_language(self, content_lines, start_index):
        """Detect appropriate language for a code block"""
        # Look at the next few lines to determine language
        sample_lines = []
        for i in range(start_index + 1, min(start_index + 6, len(content_lines))):
            line = content_lines[i].strip()
            if line and not line.startswith('```'):
                sample_lines.append(line)
        
        if not sample_lines:
            return 'text'
            
        content = '\n'.join(sample_lines).lower()
        
        # HTTP/API patterns
        if re.search(r'(get|post|put|delete|patch)\s+/', content) or 'http' in content or 'content-type:' in content:
            return 'http'
        
        # Command line patterns
        if re.search(r'^\s*[#$]', content) or any(cmd in content for cmd in ['npm', 'git', 'cd', 'ls', 'mkdir', 'docker', 'kubectl']):
            return 'bash'
        
        # JavaScript/TypeScript patterns
        if any(js in content for js in ['function', 'const', 'let', 'var', 'console.log', '=>', 'import', 'export']):
            return 'javascript'
        
        # TypeScript specific
        if any(ts in content for ts in ['interface', 'type', 'extends', 'implements', ': string', ': number']):
            return 'typescript'
        
        # Python patterns
        if any(py in content for py in ['def ', 'import ', 'from ', 'class ', 'print(']):
            return 'python'
        
        # YAML patterns
        if re.search(r'^\s*\w+:\s*$', content) or re.search(r'^\s*-\s+\w+:', content):
            return 'yaml'
        
        # JSON patterns
        if content.strip().startswith('{') or content.strip().startswith('['):
            return 'json'
        
        # XML patterns
        if '<' in content and '>' in content:
            return 'xml'
        
        # File structure patterns (directory listings)
        if any(char in content for char in ['├──', '└──', '│']) or content.count('/') > 2:
            return 'text'
        
        # Configuration patterns
        if any(conf in content for conf in ['config', 'settings', '=', 'true', 'false']):
            return 'text'
        
        # Default to text for lists and other content
        return 'text'
    
    def fix_code_blocks(self, content):
        """Fix code blocks without language specifiers"""
        lines = content.split('\n')
        modified = False
        
        i = 0
        while i < len(lines):
            line = lines[i].strip()
            
            # Check for naked code block opening
            if line == '```':
                # Detect language based on content
                language = self.detect_code_language(lines, i)
                lines[i] = f'```{language}'
                modified = True
                self.fixes_applied['code_language'] += 1
                
            i += 1
        
        return '\n'.join(lines), modified
    
    def fix_trailing_spaces(self, content):
        """Remove trailing spaces"""
        original_lines = content.split('\n')
        fixed_lines = [line.rstrip() for line in original_lines]
        
        if original_lines != fixed_lines:
            self.fixes_applied['trailing_spaces'] += 1
            return '\n'.join(fixed_lines), True
        
        return content, False
    
    def fix_indented_code_blocks(self, content):
        """Convert indented code blocks to fenced blocks"""
        lines = content.split('\n')
        modified = False
        result_lines = []
        
        i = 0
        while i < len(lines):
            line = lines[i]
            
            # Check for indented code (4+ spaces, followed by code-like content)
            if (re.match(r'^    [a-zA-Z0-9#$\{\[]', line) and 
                (i == 0 or not lines[i-1].strip().endswith('```'))):
                
                # Found start of indented block
                indented_lines = []
                while (i < len(lines) and 
                       (lines[i].startswith('    ') or lines[i].strip() == '')):
                    if lines[i].startswith('    '):
                        indented_lines.append(lines[i][4:])  # Remove 4 spaces
                    else:
                        indented_lines.append(lines[i])
                    i += 1
                
                # Add fenced code block
                if indented_lines:
                    # Detect language
                    language = self.detect_code_language([''] + indented_lines, 0)
                    result_lines.append(f'```{language}')
                    result_lines.extend(indented_lines)
                    result_lines.append('```')
                    modified = True
                    self.fixes_applied['indented_code'] += 1
                continue
            
            result_lines.append(line)
            i += 1
        
        return '\n'.join(result_lines), modified
    
    def fix_file(self, filepath):
        """Fix a single markdown file"""
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
        except (UnicodeDecodeError, IOError) as e:
            print(f"Error reading {filepath}: {e}")
            return False
        
        original_content = content
        file_modified = False
        
        # Apply fixes
        content, modified = self.fix_trailing_spaces(content)
        file_modified = file_modified or modified
        
        content, modified = self.fix_indented_code_blocks(content)
        file_modified = file_modified or modified
        
        content, modified = self.fix_code_blocks(content)
        file_modified = file_modified or modified
        
        # Write back if modified
        if file_modified:
            try:
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(content)
                print(f"✅ Fixed: {filepath}")
                self.files_modified += 1
                return True
            except IOError as e:
                print(f"Error writing {filepath}: {e}")
                return False
        
        return False
    
    def process_directory(self, directory='.'):
        """Process all markdown files in directory"""
        print("🔧 Starting comprehensive markdown fixes...")
        print(f"Directory: {os.path.abspath(directory)}")
        print()
        
        for root, dirs, files in os.walk(directory):
            # Skip ignored directories
            dirs[:] = [d for d in dirs if not any(
                ignore.rstrip('/') in os.path.join(root, d) 
                for ignore in ['node_modules', '.git', '.tmp']
            )]
            
            for file in files:
                if file.endswith('.md'):
                    filepath = os.path.join(root, file)
                    
                    if self.is_ignored_file(filepath):
                        continue
                    
                    self.files_processed += 1
                    self.fix_file(filepath)
        
        self.print_summary()
    
    def print_summary(self):
        """Print summary of fixes applied"""
        print()
        print("=" * 50)
        print("📊 Markdown Fix Summary")
        print("=" * 50)
        print(f"Files processed: {self.files_processed}")
        print(f"Files modified: {self.files_modified}")
        print()
        print("Fixes applied:")
        for fix_type, count in self.fixes_applied.items():
            if count > 0:
                fix_name = fix_type.replace('_', ' ').title()
                print(f"  {fix_name}: {count}")
        print()
        
        if self.files_modified > 0:
            print("✅ Fixes completed successfully!")
            print("Run markdownlint to verify remaining issues.")
        else:
            print("ℹ️  No fixes were needed.")

def main():
    fixer = MarkdownFixer()
    fixer.process_directory()

if __name__ == '__main__':
    main()