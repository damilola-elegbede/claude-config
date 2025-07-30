#!/usr/bin/env python3
"""Fix deprecated agent names across all documentation."""

import os
import re
from pathlib import Path

# Mapping of deprecated names to new names
AGENT_NAME_MAPPING = {
    'backend-dev': 'backend-engineer',
    'backend-staff': 'backend-engineer',
    'frontend-staff': 'frontend-engineer',
    'qa-tester': 'test-engineer',
    # Note: both performance-engineer and performance-analyst exist, keep as is
    # Note: product-strategist exists, keep as is
}

def update_agent_names(content):
    """Update deprecated agent names in content."""
    updated_content = content
    
    for old_name, new_name in AGENT_NAME_MAPPING.items():
        if old_name == new_name:
            continue
            
        # Replace exact matches (word boundaries)
        updated_content = re.sub(rf'\b{re.escape(old_name)}\b', new_name, updated_content)
    
    return updated_content

def process_files():
    """Process all documentation files."""
    docs_dir = Path(__file__).parent.parent / 'docs'
    
    # Include subdirectories
    patterns = ['*.md', '**/*.md']
    
    updated_files = []
    
    for pattern in patterns:
        for doc_file in docs_dir.glob(pattern):
            try:
                content = doc_file.read_text()
                updated_content = update_agent_names(content)
                
                if content != updated_content:
                    doc_file.write_text(updated_content)
                    updated_files.append(str(doc_file.relative_to(docs_dir)))
                    
            except Exception as e:
                print(f"Error processing {doc_file}: {e}")
    
    print(f"Updated {len(updated_files)} files with correct agent names")
    if updated_files:
        print("\nUpdated files:")
        for f in sorted(updated_files):
            print(f"  - {f}")

if __name__ == "__main__":
    process_files()