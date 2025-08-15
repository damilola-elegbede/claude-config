#!/usr/bin/env python3
"""
Scan all agents to build a comprehensive capability matrix for orchestration.
"""

import os
import re
from pathlib import Path
import json

def extract_agent_info(file_path):
    """Extract key information from an agent file."""
    with open(file_path, 'r') as f:
        content = f.read()

    agent_info = {
        'name': file_path.stem,
        'file': file_path.name,
        'capabilities': [],
        'tools': [],
        'coordination_patterns': [],
        'parallel_compatible': [],
        'handoff_patterns': [],
        'unique_expertise': [],
        'when_to_use': [],
        'orchestration_notes': []
    }

    # Extract YAML frontmatter
    yaml_match = re.search(r'^---\n(.*?)\n---', content, re.DOTALL)
    if yaml_match:
        yaml_content = yaml_match.group(1)

        # Extract name
        name_match = re.search(r'^name:\s*(.+)$', yaml_content, re.MULTILINE)
        if name_match:
            agent_info['name'] = name_match.group(1).strip()

        # Extract description
        desc_match = re.search(r'^description:\s*(.+)$', yaml_content, re.MULTILINE)
        if desc_match:
            agent_info['description'] = desc_match.group(1).strip()

        # Extract color
        color_match = re.search(r'^color:\s*(.+)$', yaml_content, re.MULTILINE)
        if color_match:
            agent_info['color'] = color_match.group(1).strip()

        # Extract tools
        tools_section = re.search(r'^tools:\s*\n((?:\s+-\s+.+\n)+)', yaml_content, re.MULTILINE)
        if tools_section:
            tools = re.findall(r'^\s+-\s+(.+)$', tools_section.group(1), re.MULTILINE)
            agent_info['tools'] = tools

    # Extract capabilities from various sections
    capability_patterns = [
        r'## (?:Core )?(?:Capabilities|Expertise|Skills|Responsibilities)(.*?)(?=##|\Z)',
        r'### (?:Technical )?(?:Capabilities|Expertise|Skills)(.*?)(?=###|##|\Z)',
        r'You (?:are|have|possess|excel at)(.*?)(?:\.|##)',
    ]

    for pattern in capability_patterns:
        matches = re.findall(pattern, content, re.DOTALL | re.IGNORECASE)
        for match in matches:
            # Extract bullet points
            bullets = re.findall(r'^\s*[-*]\s+(.+)$', match, re.MULTILINE)
            agent_info['capabilities'].extend(bullets)

    # Extract when to use patterns
    when_patterns = [
        r'(?:When to use|Ideal for|Perfect for|Use when)(.*?)(?=##|\Z)',
        r'## When to (?:Use|Engage)(.*?)(?=##|\Z)',
    ]

    for pattern in when_patterns:
        matches = re.findall(pattern, content, re.DOTALL | re.IGNORECASE)
        for match in matches:
            bullets = re.findall(r'^\s*[-*]\s+(.+)$', match, re.MULTILINE)
            agent_info['when_to_use'].extend(bullets)

    # Extract coordination patterns
    coord_patterns = [
        r'(?:Coordination|Collaboration|Works with|Handoff)(.*?)(?=##|\Z)',
        r'(?:Parallel|Sequential|Handoff) (?:execution|patterns?)(.*?)(?=##|\Z)',
    ]

    for pattern in coord_patterns:
        matches = re.findall(pattern, content, re.DOTALL | re.IGNORECASE)
        for match in matches:
            bullets = re.findall(r'^\s*[-*]\s+(.+)$', match, re.MULTILINE)
            agent_info['coordination_patterns'].extend(bullets)

    # Clean up extracted data
    agent_info['capabilities'] = [cap.strip() for cap in agent_info['capabilities'] if cap.strip()]
    agent_info['when_to_use'] = [use.strip() for use in agent_info['when_to_use'] if use.strip()]
    agent_info['coordination_patterns'] = [coord.strip() for coord in agent_info['coordination_patterns'] if coord.strip()]

    return agent_info

def categorize_capabilities(agents_data):
    """Categorize capabilities by type."""
    categories = {
        'Development': {
            'Backend': [],
            'Frontend': [],
            'Mobile': [],
            'Database': [],
            'API': [],
            'ML/AI': []
        },
        'Infrastructure': {
            'Cloud': [],
            'DevOps': [],
            'Networking': [],
            'Platform': [],
            'Monitoring': []
        },
        'Quality': {
            'Testing': [],
            'Security': [],
            'Performance': [],
            'Code Review': [],
            'Accessibility': []
        },
        'Architecture': {
            'System Design': [],
            'API Design': [],
            'Technical Planning': [],
            'Solution Architecture': []
        },
        'Analysis': {
            'Code Analysis': [],
            'Business Analysis': [],
            'Data Analysis': [],
            'Research': [],
            'Documentation': []
        },
        'Operations': {
            'Incident Response': [],
            'Debugging': [],
            'Coordination': [],
            'Strategy': []
        }
    }

    # Keywords for categorization
    keywords = {
        'Backend': ['backend', 'server', 'api', 'database', 'microservice'],
        'Frontend': ['frontend', 'ui', 'react', 'vue', 'angular', 'web'],
        'Mobile': ['mobile', 'ios', 'android', 'react native', 'flutter'],
        'Database': ['database', 'sql', 'nosql', 'query', 'schema'],
        'API': ['api', 'rest', 'graphql', 'endpoint', 'swagger'],
        'ML/AI': ['machine learning', 'ml', 'ai', 'model', 'data science'],
        'Cloud': ['cloud', 'aws', 'azure', 'gcp', 'infrastructure'],
        'DevOps': ['devops', 'ci/cd', 'pipeline', 'deployment', 'docker'],
        'Testing': ['test', 'qa', 'quality', 'coverage', 'automation'],
        'Security': ['security', 'vulnerability', 'audit', 'compliance'],
        'Performance': ['performance', 'optimization', 'load', 'speed'],
        'Documentation': ['documentation', 'docs', 'writing', 'readme']
    }

    return categories

def main():
    agents_dir = Path('/Users/damilola/Documents/Projects/claude-config/.claude/agents')

    # Skip these files
    skip_files = ['README.md', 'AGENT_CATEGORIES.md', 'AGENT_TEMPLATE.md', 'AUDIT_VERIFICATION_PROTOCOL.md']

    agents_data = []

    print("Scanning agent files...")
    print("=" * 60)

    for agent_file in sorted(agents_dir.glob('*.md')):
        if agent_file.name in skip_files:
            continue

        print(f"\nScanning {agent_file.name}...")
        agent_info = extract_agent_info(agent_file)
        agents_data.append(agent_info)

        # Print summary
        print(f"  Name: {agent_info['name']}")
        print(f"  Description: {agent_info.get('description', 'N/A')[:100]}...")
        print(f"  Tools: {len(agent_info['tools'])} tools")
        print(f"  Capabilities: {len(agent_info['capabilities'])} identified")
        print(f"  Coordination patterns: {len(agent_info['coordination_patterns'])}")

    # Save comprehensive data
    output_file = Path('/Users/damilola/Documents/Projects/claude-config/agent-capability-matrix.json')
    with open(output_file, 'w') as f:
        json.dump(agents_data, f, indent=2)

    print(f"\n✅ Scanned {len(agents_data)} agents")
    print(f"📊 Capability matrix saved to: {output_file}")

    # Generate summary report
    print("\n" + "=" * 60)
    print("CAPABILITY SUMMARY")
    print("=" * 60)

    # Group by color/category
    by_color = {}
    for agent in agents_data:
        color = agent.get('color', 'unknown')
        if color not in by_color:
            by_color[color] = []
        by_color[color].append(agent['name'])

    print("\nAgents by Category (Color):")
    for color, agents in sorted(by_color.items()):
        print(f"  {color}: {', '.join(agents)}")

    # Identify parallel execution opportunities
    print("\n\nParallel Execution Opportunities:")
    print("  - Multiple analysis agents for different aspects")
    print("  - Backend + Frontend + Mobile development")
    print("  - Testing + Security + Performance validation")
    print("  - Documentation across different formats")

    return agents_data

if __name__ == '__main__':
    main()
