#!/usr/bin/env python3
"""Fix remaining documentation and code issues."""

import os
import re
from pathlib import Path

def fix_data_scientist_code():
    """Fix missing imports in data-scientist.md."""
    file_path = Path(__file__).parent.parent / '.claude/agents/data-scientist.md'
    content = file_path.read_text()
    
    # Fix datetime import
    if 'datetime.now()' in content and 'import datetime' not in content:
        # Find the code block and add import
        content = re.sub(
            r'(```python\n)(.*?datetime\.now\(\))',
            r'\1import datetime\n\n\2',
            content,
            flags=re.DOTALL
        )
    
    file_path.write_text(content)

def fix_design_system_colors():
    """Fix color token references in design-system.md."""
    file_path = Path(__file__).parent.parent / '.claude/agents/design-system.md'
    content = file_path.read_text()
    
    # Add color palette definitions
    color_palette = '''
      "red": {
        "500": "#ef4444"
      },
      "amber": {
        "500": "#f59e0b"
      },
      "green": {
        "500": "#10b981"
      },
      "blue": {
        "500": "#3b82f6"
      },'''
    
    # Insert palette after "color": { line
    content = re.sub(
        r'("color":\s*{\s*\n)',
        r'\1' + color_palette + '\n',
        content
    )
    
    file_path.write_text(content)

def fix_documentation_finder():
    """Fix documentation-finder categorization and field order."""
    file_path = Path(__file__).parent.parent / '.claude/agents/documentation-finder.md'
    content = file_path.read_text()
    
    # Read current frontmatter
    lines = content.split('\n')
    in_frontmatter = False
    frontmatter_lines = []
    content_lines = []
    
    for line in lines:
        if line == '---':
            if not in_frontmatter:
                in_frontmatter = True
            else:
                in_frontmatter = False
                continue
        elif in_frontmatter:
            frontmatter_lines.append(line)
        else:
            content_lines.append(line)
    
    # Rebuild with correct order and values
    new_content = '''---
name: documentation-finder
description: Intelligently searches across all documentation sources with minimal queries
tools:
  - Read
  - Grep
  - Glob
  - WebFetch
color: yellow
category: analysis
---

''' + '\n'.join(content_lines[1:])  # Skip the first empty line
    
    file_path.write_text(new_content)

def fix_file_navigator():
    """Remove Write tool from file-navigator."""
    file_path = Path(__file__).parent.parent / '.claude/agents/file-navigator.md'
    content = file_path.read_text()
    
    # Remove Write from tools list
    content = re.sub(r'  - Write\n', '', content)
    
    file_path.write_text(content)

def fix_openapi_spec():
    """Fix OpenAPI spec issues in agent-ecosystem-api.md."""
    file_path = Path(__file__).parent.parent / 'docs/api/agent-ecosystem-api.md'
    content = file_path.read_text()
    
    # Add components section before the Security Model section
    components_section = '''
## API Components

### Schemas

```yaml
components:
  schemas:
    AgentType:
      type: string
      description: Available agent types in the ecosystem
      enum:
        - general-purpose
        - file-writer
        - tech-writer
        - network-engineer
        - mobile-engineer
        - file-navigator
        - backend-engineer
        - data-engineer
        - devops
        - api-architect
        - config-specialist
        - log-analyst
        - integration-specialist
        - kubernetes-admin
        - ui-designer
        - frontend-engineer
        - incident-commander
        - design-system
        - monitoring-specialist
        - cloud-architect
        - api-contract-tester
        - security-auditor
        - product-strategist
        - business-analyst
        - dependency-manager
        - data-scientist
        - documentation-finder
        - researcher
        - ux-researcher
        - security-tester
        - agent-auditor
        - platform-engineer
        - database-admin
        - error-resolver
        - git-workflow
        - performance-analyst
        - debugger
        - database-migration-specialist
        - api-documenter
        - performance-engineer
        - search-coordinator
        - test-engineer
        - ml-engineer
        - accessibility-auditor
        - code-reviewer
        - codebase-analyst
        - principal-architect
        - mobile-ui
    
    AgentInfo:
      type: object
      required:
        - agent_type
        - description
        - tools
        - color
        - category
      properties:
        agent_type:
          type: string
        description:
          type: string
        tools:
          type: array
          items:
            type: string
        color:
          type: string
        category:
          type: string
    
    AgentInvocationRequest:
      type: object
      required:
        - description
        - prompt
        - subagent_type
      properties:
        description:
          type: string
          description: Short description of the task
        prompt:
          type: string
          description: Detailed task for the agent
        subagent_type:
          $ref: '#/components/schemas/AgentType'
    
    AgentInvocationResponse:
      type: object
      properties:
        status:
          type: string
        result:
          type: string
        agent_type:
          type: string
        execution_time:
          type: number
```

'''
    
    # Find where to insert (before "## System Boundary & Security Model")
    insert_pos = content.find('## System Boundary & Security Model')
    if insert_pos > 0:
        content = content[:insert_pos] + components_section + content[insert_pos:]
    
    # Replace inline enum with $ref
    content = re.sub(
        r'enum:\s*\[[^\]]+\]',
        "$ref: '#/components/schemas/AgentType'",
        content
    )
    
    file_path.write_text(content)

def fix_guide_colors():
    """Fix color assignments in agent-development-guide.md."""
    file_path = Path(__file__).parent.parent / 'docs/guides/agent-development-guide.md'
    content = file_path.read_text()
    
    # Update operations color from orange to teal
    content = re.sub(
        r'(\| operations\s+\|\s+)orange(\s+\|)',
        r'\1teal\2',
        content
    )
    
    file_path.write_text(content)

def main():
    """Run all fixes."""
    print("Fixing remaining issues...")
    
    try:
        print("1. Fixing data-scientist code examples...")
        fix_data_scientist_code()
        
        print("2. Fixing design-system color tokens...")
        fix_design_system_colors()
        
        print("3. Fixing documentation-finder categorization...")
        fix_documentation_finder()
        
        print("4. Fixing file-navigator Write tool...")
        fix_file_navigator()
        
        print("5. Fixing OpenAPI spec...")
        fix_openapi_spec()
        
        print("6. Fixing guide color assignments...")
        fix_guide_colors()
        
        print("\nAll fixes completed successfully!")
        
    except Exception as e:
        print(f"Error: {e}")
        return 1
    
    return 0

if __name__ == "__main__":
    exit(main())