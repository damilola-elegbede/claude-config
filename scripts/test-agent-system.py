#!/usr/bin/env python3
"""
Test the agent ecosystem for quality assurance.
Validates consolidation, naming, coordination, and completeness.
"""

import os
import re
from pathlib import Path
from collections import defaultdict

# Get repository root directory
REPO_ROOT = Path(__file__).resolve().parents[1]

# Expected final state - Updated based on actual agent ecosystem (AGENT_TEMPLATE.md format)
EXPECTED_AGENTS = 28  # Production agents following 46-line template
EXPECTED_CATEGORIES = {
    'blue': 7,    # Development (7 agents)
    'green': 4,   # Quality (4 agents)
    'red': 1,     # Security (1 agent)
    'purple': 3,  # Architecture (3 agents)
    'pink': 3,    # Design (3 agents)
    'yellow': 3,  # Analysis (3 agents)
    'orange': 4,  # Infrastructure (4 agents)
    'cyan': 3,    # Coordination (3 agents)
    'white': 0,   # Not used (poor visibility)
    'brown': 0,   # Not used
}

DEPRECATED_AGENTS = [
    'qa-tester', 'doc-updater', 'senior-dev',
    'fullstack-dev', 'db-admin', 'test-data-manager',
    'arch-reviewer', 'tech-lead'
]
# Note: reliability-engineer and agent-auditor are active agents

COMMAND_AGENT_MAP = {
    '/test': 'test-engineer',
    '/review': 'code-reviewer',
    '/security': 'security-auditor',
    '/perf': 'performance-engineer',
    '/docs': 'tech-writer',
    '/debug': 'debugger',
    '/orchestrate': 'project-orchestrator',
    '/prime': 'codebase-analyst',
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
    """Test that we have exactly 28 agents following AGENT_TEMPLATE.md format."""
    agents_dir = REPO_ROOT / "system-configs" / ".claude" / "agents"
    agent_files = [f for f in agents_dir.glob('*.md') 
                   if f.name not in ['README.md', 'AGENT_TEMPLATE.md', 'AGENT_CATEGORIES.md']]

    passed = len(agent_files) == EXPECTED_AGENTS
    print(f"{'✅' if passed else '❌'} Agent count: {len(agent_files)} (expected {EXPECTED_AGENTS})")

    return passed

def test_no_deprecated_agents():
    """Test that no deprecated agents exist."""
    agents_dir = REPO_ROOT / "system-configs" / ".claude" / "agents"
    existing_agents = [f.stem for f in agents_dir.glob('*.md') 
                      if f.name not in ['README.md', 'AGENT_TEMPLATE.md']]

    found_deprecated = [agent for agent in DEPRECATED_AGENTS if agent in existing_agents]

    passed = len(found_deprecated) == 0
    print(f"{'✅' if passed else '❌'} No deprecated agents: {passed}")
    if found_deprecated:
        print(f"   Found deprecated: {', '.join(found_deprecated)}")

    return passed

def test_agent_categories():
    """Test agent color distribution matches expected categories."""
    agents_dir = REPO_ROOT / "system-configs" / ".claude" / "agents"
    color_counts = defaultdict(int)

    for agent_file in agents_dir.glob('*.md'):
        if agent_file.name in ['README.md', 'AGENT_TEMPLATE.md']:
            continue

        with open(agent_file, 'r', encoding='utf-8') as f:
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

# Removed test_yaml_structure as it's replaced by test_agent_yaml_validity

def test_command_mappings():
    """Test command shortcuts map to correct agents."""
    commands_dir = REPO_ROOT / "system-configs" / ".claude" / "commands"

    all_good = True
    for command, expected_agent in COMMAND_AGENT_MAP.items():
        command_file = commands_dir / f"{command[1:]}.md"

        if command_file.exists():
            with open(command_file, 'r', encoding='utf-8') as f:
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

def test_agent_yaml_validity():
    """Test agents have valid YAML front-matter."""
    agents_dir = REPO_ROOT / "system-configs" / ".claude" / "agents"

    invalid_agents = []
    non_agent_files = ['README.md', 'AGENT_CATEGORIES.md', 'AGENT_TEMPLATE.md', 'AUDIT_VERIFICATION_PROTOCOL.md']

    for agent_file in agents_dir.glob('*.md'):
        if agent_file.name in non_agent_files:
            continue

        with open(agent_file, 'r', encoding='utf-8') as f:
            content = f.read()

        # Check for basic YAML structure
        if not content.startswith('---\n'):
            invalid_agents.append(agent_file.stem)
            continue

        # Check for required fields: name, description, color, tools
        yaml_match = re.search(r'^---\n(.*?)\n---', content, re.DOTALL)
        if yaml_match:
            yaml_content = yaml_match.group(1)
            required_fields = ['name:', 'description:', 'color:', 'tools:']
            for field in required_fields:
                if field not in yaml_content:
                    invalid_agents.append(agent_file.stem)
                    break

    passed = len(invalid_agents) == 0
    print(f"{'✅' if passed else '❌'} All agents have valid YAML: {passed}")
    if invalid_agents:
        print(f"   Invalid: {', '.join(invalid_agents[:5])}..." if len(invalid_agents) > 5 else f"   Invalid: {', '.join(invalid_agents)}")

    return passed

def test_deprecated_directory():
    """Test deprecated agents are properly archived."""
    deprecated_dir = REPO_ROOT / "system-configs" / ".claude" / "deprecated" / "agents"

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
        ("Agent YAML Validity", test_agent_yaml_validity),
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
