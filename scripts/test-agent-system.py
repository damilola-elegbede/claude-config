#!/usr/bin/env python3
"""
Test the agent ecosystem for quality assurance.
Validates consolidation, naming, coordination, and completeness.
"""

import os
import re
from pathlib import Path
from collections import defaultdict

# Expected final state
EXPECTED_AGENTS = 26
EXPECTED_CATEGORIES = {
    'blue': 6,    # Development & Implementation
    'green': 5,   # Quality & Testing
    'red': 4,     # Architecture & Design
    'purple': 3,  # Analysis & Research
    'yellow': 3,  # Infrastructure & Operations
    'orange': 3,  # Documentation & Support
    'white': 2,   # Specialized Support
}

DEPRECATED_AGENTS = [
    'qa-tester', 'doc-updater', 'reliability-engineer', 'senior-dev',
    'fullstack-dev', 'db-admin', 'test-data-manager', 'agent-architect',
    'agent-auditor', 'arch-reviewer', 'tech-lead'
]

COMMAND_AGENT_MAP = {
    '/test': 'test-engineer',
    '/review': 'code-reviewer',
    '/security': 'security-auditor',
    '/perf': 'performance-engineer',
    '/docs': 'tech-writer',
    '/debug': 'debugger',
    '/orchestrate': 'project-orchestrator',
    '/context': 'codebase-analyst',
    '/backend': 'backend-engineer',
    '/frontend': 'frontend-engineer',
    '/data': 'data-engineer',
    '/ml': 'ml-engineer',
    '/api': 'api-architect',
    '/mobile': 'mobile-engineer',
    '/architect': 'principal-architect',
    '/analyze': 'codebase-analyst'
}

def test_agent_count():
    """Test that we have exactly 26 agents."""
    agents_dir = Path('/Users/damilola/Documents/Projects/claude-config/.claude/agents')
    agent_files = [f for f in agents_dir.glob('*.md') if f.name != 'README.md']
    
    passed = len(agent_files) == EXPECTED_AGENTS
    print(f"{'✅' if passed else '❌'} Agent count: {len(agent_files)} (expected {EXPECTED_AGENTS})")
    
    return passed

def test_no_deprecated_agents():
    """Test that no deprecated agents exist."""
    agents_dir = Path('/Users/damilola/Documents/Projects/claude-config/.claude/agents')
    existing_agents = [f.stem for f in agents_dir.glob('*.md') if f.name != 'README.md']
    
    found_deprecated = [agent for agent in DEPRECATED_AGENTS if agent in existing_agents]
    
    passed = len(found_deprecated) == 0
    print(f"{'✅' if passed else '❌'} No deprecated agents: {passed}")
    if found_deprecated:
        print(f"   Found deprecated: {', '.join(found_deprecated)}")
    
    return passed

def test_agent_categories():
    """Test agent color distribution matches expected categories."""
    agents_dir = Path('/Users/damilola/Documents/Projects/claude-config/.claude/agents')
    color_counts = defaultdict(int)
    
    for agent_file in agents_dir.glob('*.md'):
        if agent_file.name == 'README.md':
            continue
            
        with open(agent_file, 'r') as f:
            content = f.read()
            
        color_match = re.search(r'^color:\s*(\w+)$', content, re.MULTILINE)
        if color_match:
            color = color_match.group(1)
            color_counts[color] += 1
    
    all_match = True
    for color, expected in EXPECTED_CATEGORIES.items():
        actual = color_counts.get(color, 0)
        match = actual == expected
        all_match &= match
        print(f"{'✅' if match else '❌'} {color.title()} agents: {actual} (expected {expected})")
    
    return all_match

def test_yaml_structure():
    """Test all agents have valid YAML structure."""
    from scripts.validate_agent_yaml import validate_agent_file
    
    agents_dir = Path('/Users/damilola/Documents/Projects/claude-config/.claude/agents')
    agent_files = [f for f in agents_dir.glob('*.md') if f.name != 'README.md']
    
    all_valid = True
    for agent_file in agent_files:
        _, issues = validate_agent_file(agent_file)
        if issues:
            all_valid = False
            print(f"❌ {agent_file.stem}: {len(issues)} issues")
        else:
            print(f"✅ {agent_file.stem}: Valid YAML")
    
    return all_valid

def test_command_mappings():
    """Test command shortcuts map to correct agents."""
    commands_dir = Path('/Users/damilola/Documents/Projects/claude-config/.claude/commands')
    
    all_good = True
    for command, expected_agent in COMMAND_AGENT_MAP.items():
        command_file = commands_dir / f"{command[1:]}.md"
        
        if command_file.exists():
            with open(command_file, 'r') as f:
                content = f.read()
            
            # Check if the command mentions the correct agent
            if expected_agent in content:
                print(f"✅ {command} → {expected_agent}")
            else:
                print(f"❌ {command} → missing reference to {expected_agent}")
                all_good = False
        else:
            print(f"❌ {command} → command file missing")
            all_good = False
    
    return all_good

def test_coordination_protocols():
    """Test agents have proper coordination protocols."""
    agents_dir = Path('/Users/damilola/Documents/Projects/claude-config/.claude/agents')
    
    missing_protocols = []
    for agent_file in agents_dir.glob('*.md'):
        if agent_file.name == 'README.md':
            continue
            
        with open(agent_file, 'r') as f:
            content = f.read()
        
        # Check for coordination_protocols section
        if 'coordination_protocols:' not in content:
            missing_protocols.append(agent_file.stem)
    
    passed = len(missing_protocols) == 0
    print(f"{'✅' if passed else '❌'} All agents have coordination protocols: {passed}")
    if missing_protocols:
        print(f"   Missing: {', '.join(missing_protocols)}")
    
    return passed

def test_deprecated_directory():
    """Test deprecated agents are properly archived."""
    deprecated_dir = Path('/Users/damilola/Documents/Projects/claude-config/.claude/deprecated/agents')
    
    if deprecated_dir.exists():
        deprecated_files = list(deprecated_dir.glob('*.md'))
        print(f"✅ Deprecated directory exists with {len(deprecated_files)} archived agents")
        
        # Check some expected deprecated agents are there
        expected_deprecated = ['qa-tester.md', 'reliability-engineer.md', 'senior-dev.md']
        found = [f.name for f in deprecated_files if f.name in expected_deprecated]
        
        if found:
            print(f"   Found archived: {', '.join(found)}")
        
        return True
    else:
        print("❌ Deprecated directory missing")
        return False

def main():
    """Run all tests."""
    print("=" * 60)
    print("AGENT ECOSYSTEM QUALITY ASSURANCE TEST")
    print("=" * 60)
    
    tests = [
        ("Agent Count", test_agent_count),
        ("No Deprecated Agents", test_no_deprecated_agents),
        ("Agent Categories", test_agent_categories),
        ("Command Mappings", test_command_mappings),
        ("Coordination Protocols", test_coordination_protocols),
        ("Deprecated Archive", test_deprecated_directory),
    ]
    
    results = []
    for test_name, test_func in tests:
        print(f"\n## Testing: {test_name}")
        try:
            passed = test_func()
            results.append((test_name, passed))
        except Exception as e:
            print(f"❌ Test failed with error: {e}")
            results.append((test_name, False))
    
    # Summary
    print("\n" + "=" * 60)
    print("TEST SUMMARY")
    print("=" * 60)
    
    passed_count = sum(1 for _, passed in results if passed)
    total_count = len(results)
    
    for test_name, passed in results:
        print(f"{'✅' if passed else '❌'} {test_name}")
    
    print(f"\nTotal: {passed_count}/{total_count} tests passed")
    
    if passed_count == total_count:
        print("\n🎉 All tests passed! Agent ecosystem is properly configured.")
        return 0
    else:
        print(f"\n❌ {total_count - passed_count} tests failed. Review the issues above.")
        return 1

if __name__ == '__main__':
    exit(main())