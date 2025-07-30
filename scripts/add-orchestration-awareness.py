#!/usr/bin/env python3
"""
Add orchestration awareness to agent system prompts.
"""

import re
from pathlib import Path

# Orchestration awareness text to add
ORCHESTRATION_HEADER = """
## Working with Claude Orchestration Engine

You are a specialized agent working under the coordination of Claude, the primary orchestration engine. Claude will:
- Assign you specific work based on your expertise
- Coordinate parallel execution with other specialists
- Aggregate outputs across multiple agents
- Handle dependencies and handoffs between specialists

Your role is to:
- Focus on your specialized domain
- Provide clear, structured outputs
- Indicate when work should be handed off to other specialists
- Work efficiently knowing other specialists may be working in parallel
"""

def add_orchestration_awareness(file_path):
    """Add orchestration awareness to an agent file."""
    with open(file_path, 'r') as f:
        content = f.read()
    
    # Skip if already has orchestration awareness
    if "Working with Claude Orchestration Engine" in content:
        return False
    
    # Find where to insert (after the first heading after frontmatter)
    lines = content.split('\n')
    yaml_end = -1
    
    # Find end of YAML frontmatter
    for i, line in enumerate(lines):
        if i > 0 and line.strip() == '---':
            yaml_end = i
            break
    
    if yaml_end == -1:
        return False
    
    # Find first major heading after frontmatter
    insert_position = yaml_end + 1
    for i in range(yaml_end + 1, len(lines)):
        if lines[i].startswith('#') and not lines[i].startswith('##'):
            # Found a main heading, insert after it
            insert_position = i + 1
            # Skip any immediate content
            while insert_position < len(lines) and lines[insert_position].strip():
                insert_position += 1
            break
    
    # Insert orchestration awareness
    lines.insert(insert_position, ORCHESTRATION_HEADER)
    
    # Write back
    with open(file_path, 'w') as f:
        f.write('\n'.join(lines))
    
    return True

def update_coordination_language(file_path):
    """Update coordination language to reference orchestration engine."""
    with open(file_path, 'r') as f:
        content = f.read()
    
    original_content = content
    
    # Replace patterns
    replacements = [
        # Replace references to general-purpose agent
        (r'general-purpose agent', 'Claude orchestration engine'),
        (r'specialist for general research and analysis work', 'Claude orchestration engine'),
        
        # Update coordination language
        (r'Coordinate with other agents', 'Work with Claude to coordinate with other specialists'),
        (r'Hand off to', 'Return to Claude for handoff to'),
        (r'Escalate to', 'Return to Claude for escalation to'),
        
        # Update delegation language
        (r'delegate to specialists', 'return to Claude for specialist delegation'),
        (r'When to delegate', 'When to return to Claude for delegation'),
    ]
    
    for old_pattern, new_pattern in replacements:
        content = re.sub(old_pattern, new_pattern, content, flags=re.IGNORECASE)
    
    if content != original_content:
        with open(file_path, 'w') as f:
            f.write(content)
        return True
    
    return False

def main():
    agents_dir = Path('/Users/damilola/Documents/Projects/claude-config/.claude/agents')
    
    # Skip these files
    skip_files = ['README.md', 'AGENT_CATEGORIES.md', 'AGENT_TEMPLATE.md', 'AUDIT_VERIFICATION_PROTOCOL.md']
    
    # Priority agents that coordinate work
    priority_agents = [
        'incident-commander.md',
        'principal-architect.md',
        'debugger.md',
        'tech-writer.md',
        'code-reviewer.md',
        'test-engineer.md'
    ]
    
    updated_count = 0
    
    print("Adding orchestration awareness to agents...")
    print("=" * 60)
    
    # Process priority agents first
    for agent_file in priority_agents:
        file_path = agents_dir / agent_file
        if file_path.exists():
            print(f"\nUpdating {agent_file}...")
            
            awareness_added = add_orchestration_awareness(file_path)
            language_updated = update_coordination_language(file_path)
            
            if awareness_added or language_updated:
                updated_count += 1
                print(f"  ✓ Updated with orchestration awareness")
                if awareness_added:
                    print(f"    - Added orchestration section")
                if language_updated:
                    print(f"    - Updated coordination language")
            else:
                print(f"  - Already has orchestration awareness")
    
    # Process remaining agents
    for agent_file in sorted(agents_dir.glob('*.md')):
        if agent_file.name in skip_files or agent_file.name in priority_agents:
            continue
        
        print(f"\nUpdating {agent_file.name}...")
        
        awareness_added = add_orchestration_awareness(agent_file)
        language_updated = update_coordination_language(agent_file)
        
        if awareness_added or language_updated:
            updated_count += 1
            print(f"  ✓ Updated with orchestration awareness")
            if awareness_added:
                print(f"    - Added orchestration section")
            if language_updated:
                print(f"    - Updated coordination language")
        else:
            print(f"  - No updates needed")
    
    print(f"\n✅ Updated {updated_count} agent files")

if __name__ == '__main__':
    main()