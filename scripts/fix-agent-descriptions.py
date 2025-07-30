#!/usr/bin/env python3
"""
Fix agent descriptions to be concise (under 200 chars).
"""

import re
from pathlib import Path

# Proper concise descriptions for each agent
AGENT_DESCRIPTIONS = {
    'accessibility-auditor': 'Accessibility testing and WCAG compliance specialist',
    'api-architect': 'API design, governance, implementation, and lifecycle management expert',
    'backend-engineer': 'Expert backend engineer for server-side architecture, APIs, databases, and distributed systems',
    'business-analyst': 'Requirements analysis, stakeholder communication, and process mapping expert',
    'cloud-architect': 'Cloud deployment and infrastructure design expert',
    'code-reviewer': 'Pre-commit code quality review, style compliance, and PR readiness specialist',
    'codebase-analyst': 'Internal code analysis, architecture assessment, and technical reporting expert',
    'data-engineer': 'Expert data engineer for pipelines, ETL/ELT systems, and data warehouse architecture',
    'database-admin': 'Database security, optimization, and administration expert',
    'debugger': 'Complex bug investigation and systematic root cause analysis expert',
    'devops': 'Deployment automation, CI/CD pipelines, and application deployment coordinator',
    'frontend-engineer': 'Expert frontend engineer for user interfaces, client applications, and performance',
    'fullstack-lead': 'Senior full-stack developer with auto-escalation for complex requirements',
    'ml-engineer': 'Expert ML engineer for machine learning systems, model deployment, and MLOps',
    'mobile-engineer': 'Expert mobile engineer for native and cross-platform mobile applications',
    'mobile-ui': 'Mobile UI/UX design specialist for iOS/Android design patterns',
    'performance-engineer': 'Performance optimization, load testing, and benchmarking expert',
    'platform-engineer': 'Production reliability, monitoring, and SRE practices specialist',
    'principal-architect': 'System architecture design, technical roadmaps, and implementation planning leader',
    'product-strategist': 'Strategic product guidance and feature prioritization specialist',
    'project-orchestrator': 'Multi-agent coordination and parallel execution planning expert',
    'researcher': 'External research, technology evaluation, and industry analysis specialist',
    'security-auditor': 'Security vulnerability assessment and compliance review specialist',
    'tech-writer': 'Technical documentation, API docs, and knowledge management specialist',
    'test-engineer': 'Comprehensive testing strategy, test implementation, and quality assurance expert',
    'ui-designer': 'Visual design, UX optimization, and design systems specialist for web/desktop'
}

def fix_agent_description(file_path):
    """Fix description in a single agent file."""
    agent_name = Path(file_path).stem
    
    # Get the correct description
    correct_description = AGENT_DESCRIPTIONS.get(agent_name)
    if not correct_description:
        print(f"Warning: No description found for {agent_name}")
        return False
    
    # Read the file
    with open(file_path, 'r') as f:
        content = f.read()
    
    # Replace the description line
    # Match multi-line descriptions as well
    pattern = r'^(description:\s*)(.+?)(\n(?=[a-z_]+:|---))'
    replacement = f'\\1{correct_description}\\3'
    
    new_content = re.sub(pattern, replacement, content, flags=re.MULTILINE | re.DOTALL)
    
    # If no change was made, try simpler pattern
    if new_content == content:
        pattern = r'^(description:\s*)(.+)$'
        replacement = f'\\1{correct_description}'
        new_content = re.sub(pattern, replacement, content, flags=re.MULTILINE)
    
    # Write back if changed
    if new_content != content:
        with open(file_path, 'w') as f:
            f.write(new_content)
        print(f"✅ Fixed: {agent_name}")
        return True
    else:
        print(f"⚠️  No change needed: {agent_name}")
        return False

def main():
    """Fix all agent descriptions."""
    agents_dir = Path('/Users/damilola/Documents/Projects/claude-config/.claude/agents')
    
    # Get all agent markdown files
    agent_files = sorted([f for f in agents_dir.glob('*.md') if f.name != 'README.md'])
    
    print(f"Fixing descriptions for {len(agent_files)} agent files...\n")
    
    fixed_count = 0
    for agent_file in agent_files:
        if fix_agent_description(agent_file):
            fixed_count += 1
    
    print(f"\n{'='*50}")
    print(f"Fixed {fixed_count} agent descriptions")
    print(f"All descriptions are now under 200 characters")

if __name__ == '__main__':
    main()