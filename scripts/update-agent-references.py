#!/usr/bin/env python3
"""
Update agent files to replace direct agent references with work type descriptions.
"""

import re
from pathlib import Path

# Mapping of agent names to work type descriptions
AGENT_TO_WORK_TYPE = {
    'backend-engineer': 'backend development work',
    'backend-staff': 'backend development work',
    'frontend-engineer': 'frontend development work', 
    'frontend-staff': 'frontend development work',
    'mobile-engineer': 'mobile development work',
    'mobile-ui': 'mobile UI/UX design work',
    'ml-engineer': 'machine learning engineering work',
    'data-engineer': 'data engineering work',
    'devops': 'DevOps and infrastructure work',
    'devops-engineer': 'DevOps and infrastructure work',
    'cloud-architect': 'cloud architecture work',
    'platform-engineer': 'platform engineering work',
    'reliability-engineer': 'reliability engineering work',
    'database-admin': 'database administration work',
    'api-architect': 'API design and architecture work',
    'principal-architect': 'system architecture work',
    'agent-architect': 'agent design and creation work',
    'ui-designer': 'UI/UX design work',
    'test-engineer': 'testing and QA work',
    'qa-tester': 'testing and QA work',
    'performance-engineer': 'performance engineering work',
    'code-reviewer': 'code review work',
    'accessibility-auditor': 'accessibility audit work',
    'security-auditor': 'security audit work',
    'security-tester': 'security testing work',
    'agent-auditor': 'agent audit and compliance work',
    'data-scientist': 'data science and analysis work',
    'business-analyst': 'business analysis work',
    'codebase-analyst': 'codebase analysis work',
    'tech-writer': 'technical writing and documentation work',
    'researcher': 'research and analysis work',
    'incident-commander': 'incident response coordination work',
    'debugger': 'debugging and troubleshooting work',
    'product-strategist': 'product strategy work',
    'senior-dev': 'general development work',
    'general-purpose': 'general research and analysis work',
    'project-orchestrator': 'project coordination and orchestration work'
}

def update_agent_references(content):
    """Update agent references in the content."""
    updated_content = content
    
    # Replace specific agent references in various contexts
    for agent_name, work_type in AGENT_TO_WORK_TYPE.items():
        # Pattern 1: Agent: `agent-name`
        pattern1 = rf'Agent:\s*`{re.escape(agent_name)}`'
        replacement1 = f'Work Type: {work_type}'
        updated_content = re.sub(pattern1, replacement1, updated_content)
        
        # Pattern 2: agent-name agent
        pattern2 = rf'\b{re.escape(agent_name)}\s+agent\b'
        replacement2 = f'specialist for {work_type}'
        updated_content = re.sub(pattern2, replacement2, updated_content, flags=re.IGNORECASE)
        
        # Pattern 3: the agent-name
        pattern3 = rf'\bthe\s+{re.escape(agent_name)}\b'
        replacement3 = f'the specialist for {work_type}'
        updated_content = re.sub(pattern3, replacement3, updated_content, flags=re.IGNORECASE)
        
        # Pattern 4: coordinate with agent-name
        pattern4 = rf'coordinate\s+with\s+{re.escape(agent_name)}\b'
        replacement4 = f'coordinate with specialists for {work_type}'
        updated_content = re.sub(pattern4, replacement4, updated_content, flags=re.IGNORECASE)
        
        # Pattern 5: work with agent-name
        pattern5 = rf'work\s+with\s+{re.escape(agent_name)}\b'
        replacement5 = f'work with specialists for {work_type}'
        updated_content = re.sub(pattern5, replacement5, updated_content, flags=re.IGNORECASE)
        
        # Pattern 6: use agent-name
        pattern6 = rf'use\s+{re.escape(agent_name)}\b'
        replacement6 = f'delegate {work_type}'
        updated_content = re.sub(pattern6, replacement6, updated_content, flags=re.IGNORECASE)
        
        # Pattern 7: Escalate to agent-name
        pattern7 = rf'Escalate\s+to\s+{re.escape(agent_name)}\b'
        replacement7 = f'Escalate to specialists for {work_type}'
        updated_content = re.sub(pattern7, replacement7, updated_content, flags=re.IGNORECASE)
        
        # Pattern 8: (use agent-name)
        pattern8 = rf'\(use\s+{re.escape(agent_name)}\)'
        replacement8 = f'(delegate {work_type})'
        updated_content = re.sub(pattern8, replacement8, updated_content, flags=re.IGNORECASE)
        
        # Pattern 9: `agent-name`:
        pattern9 = rf'`{re.escape(agent_name)}`:'
        replacement9 = f'**{work_type.title()}**:'
        updated_content = re.sub(pattern9, replacement9, updated_content)
        
        # Pattern 10: → agent-name
        pattern10 = rf'→\s*{re.escape(agent_name)}\b'
        replacement10 = f'→ {work_type}'
        updated_content = re.sub(pattern10, replacement10, updated_content)
    
    # Fix typos
    typo_fixes = {
        r'2qa-tester': '200',
        r'5qa-tester': '50',
        r'1qa-tester': '10',
        r'3qa-tester': '30',
        r'qa-tester': '0',
        r'1qa-testerx': '10x',
        r'<5qa-tester%': '<50%',
        r'2qa-testerqa-tester': '200',
        r'$5qa-testerK': '$50K',
        r'1qa-testerk\+': '10k+',
        r'senior engineers': 'experienced engineers',
        r'Senior engineers': 'Experienced engineers'
    }
    
    for typo, fix in typo_fixes.items():
        updated_content = re.sub(typo, fix, updated_content)
    
    return updated_content

def should_process_file(file_path):
    """Check if file should be processed."""
    skip_files = ['README.md', 'AGENT_CATEGORIES.md', 'AGENT_TEMPLATE.md', 'AUDIT_VERIFICATION_PROTOCOL.md']
    return file_path.name not in skip_files and file_path.suffix == '.md'

def main():
    agents_dir = Path('/Users/damilola/Documents/Projects/claude-config/.claude/agents')
    
    if not agents_dir.exists():
        print(f"Error: Agents directory not found at {agents_dir}")
        return
    
    files_updated = 0
    
    for agent_file in sorted(agents_dir.glob('*.md')):
        if not should_process_file(agent_file):
            continue
            
        print(f"Processing {agent_file.name}...")
        
        with open(agent_file, 'r') as f:
            content = f.read()
        
        # Skip if it's the file's own agent definition
        agent_name = agent_file.stem
        if f'name: {agent_name}' in content:
            # Process but preserve self-references in name/description
            lines = content.split('\n')
            yaml_end = -1
            for i, line in enumerate(lines):
                if i > 0 and line.strip() == '---':
                    yaml_end = i
                    break
            
            if yaml_end > 0:
                yaml_section = '\n'.join(lines[:yaml_end+1])
                body_section = '\n'.join(lines[yaml_end+1:])
                
                # Update only the body section
                updated_body = update_agent_references(body_section)
                
                if body_section != updated_body:
                    updated_content = yaml_section + '\n' + updated_body
                    with open(agent_file, 'w') as f:
                        f.write(updated_content)
                    files_updated += 1
                    print(f"  ✓ Updated {agent_file.name}")
                else:
                    print(f"  - No changes needed for {agent_file.name}")
        else:
            # Process entire file
            updated_content = update_agent_references(content)
            
            if content != updated_content:
                with open(agent_file, 'w') as f:
                    f.write(updated_content)
                files_updated += 1
                print(f"  ✓ Updated {agent_file.name}")
            else:
                print(f"  - No changes needed for {agent_file.name}")
    
    print(f"\n✅ Updated {files_updated} files")

if __name__ == '__main__':
    main()