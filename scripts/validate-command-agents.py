#!/usr/bin/env python3
"""
Validate that commands specify appropriate agents and leverage parallelization.
Based on the workflow analysis findings.
"""

import os
import re
import sys
from pathlib import Path
from typing import Dict, List, Set, Tuple
import json

# Agent requirements per command category (aligned with command-audit.md)
CATEGORY_AGENT_REQUIREMENTS = {
    'git_workflow': {
        'commands': ['commit', 'branch', 'push', 'pr'],
        'required_agents': ['tech-writer', 'code-reviewer', 'security-auditor'],
        'parallelization': ['validation checks', 'multiple validators']
    },
    'repository_analysis': {
        'commands': ['context', 'test', 'debug'],
        'required_agents': ['codebase-analyst', 'test-engineer', 'debugger'],
        'parallelization': ['multiple analysts', 'parallel test suite']
    },
    'system_management': {
        'commands': ['sync', 'deps', 'fix-ci'],
        'required_agents': ['platform-engineer', 'devops', 'security-auditor'],
        'parallelization': ['parallel file validation', 'simultaneous scanning']
    },
    'quality_assurance': {
        'commands': ['review', 'agent-audit', 'command-audit'],
        'required_agents': ['code-reviewer', 'security-auditor', 'performance-engineer'],
        'parallelization': ['parallel tool execution', 'multiple reviewers']
    },
    'development_support': {
        'commands': ['plan', 'resolve-comments', 'prompt', 'implement', 'docs', 'ship-it', 'bug'],
        'required_agents': ['tech-writer', 'project-orchestrator'],
        'parallelization': ['parallel phases', 'multiple agents per phase']
    }
}

# Security-critical commands that must have security-auditor
SECURITY_CRITICAL_COMMANDS = ['commit', 'push', 'sync', 'deps', 'fix-ci']

# Commands that should leverage parallelization
PARALLEL_REQUIRED_COMMANDS = [
    'implement', 'docs', 'ship-it', 'review', 'context',
    'agent-audit', 'command-audit', 'fix-ci', 'test', 'deps'
]

# All available agents
ALL_AGENTS = [
    'backend-engineer', 'frontend-architect', 'frontend-engineer', 'fullstack-lead',
    'test-engineer', 'security-auditor', 'tech-writer', 'code-reviewer',
    'codebase-analyst', 'devops', 'platform-engineer', 'project-orchestrator',
    'debugger', 'performance-engineer', 'api-architect', 'principal-architect',
    'database-admin', 'ml-engineer', 'mobile-engineer', 'data-engineer',
    'business-analyst', 'product-strategist', 'researcher', 'ui-designer',
    'ux-researcher', 'mobile-ui', 'accessibility-auditor', 'cloud-architect'
]


def find_commands_dir() -> Path:
    """Find the commands directory."""
    current = Path.cwd()

    # Look for system-configs/.claude/commands
    for parent in [current] + list(current.parents):
        commands_dir = parent / 'system-configs' / '.claude' / 'commands'
        if commands_dir.exists():
            return commands_dir

    raise FileNotFoundError("Could not find system-configs/.claude/commands directory")


def read_command_file(file_path: Path) -> str:
    """Read a command file."""
    with open(file_path, 'r', encoding='utf-8') as f:
        return f.read()


def extract_agents(content: str) -> Set[str]:
    """Extract mentioned agents from command content."""
    agents = set()

    # Create pattern for all agents
    agent_pattern = '|'.join(re.escape(agent) for agent in ALL_AGENTS)

    # Find all agent mentions
    matches = re.findall(rf'\b({agent_pattern})\b', content, re.IGNORECASE)
    agents.update(match.lower().replace('_', '-') for match in matches)

    return agents


def check_parallelization(content: str) -> Dict[str, bool]:
    """Check for parallelization patterns."""
    patterns = {
        'parallel_keywords': bool(re.search(r'\b(parallel|simultaneous|concurrent)\b', content, re.IGNORECASE)),
        'parallel_phases': bool(re.search(r'Phase.*Parallel|Parallel Wave|Parallel Execution', content, re.IGNORECASE)),
        'multiple_agents': bool(re.search(r'multiple agents?|agents? in parallel|deploy.*agents?.*simultaneous', content, re.IGNORECASE)),
        'sequential_only': bool(re.search(r'Sequential Phase|sequential execution|one at a time', content)) and not bool(re.search(r'parallel', content, re.IGNORECASE))
    }

    patterns['has_parallelization'] = (
        patterns['parallel_keywords'] or
        patterns['parallel_phases'] or
        patterns['multiple_agents']
    ) and not patterns['sequential_only']

    return patterns


def get_command_category(command: str) -> str:
    """Get the category for a command."""
    for category, info in CATEGORY_AGENT_REQUIREMENTS.items():
        if command in info['commands']:
            return category
    return 'uncategorized'


def validate_command(file_path: Path) -> Dict:
    """Validate a single command file."""
    command_name = file_path.stem
    content = read_command_file(file_path)

    # Extract agents
    mentioned_agents = extract_agents(content)

    # Check parallelization
    parallel_patterns = check_parallelization(content)

    # Get category and requirements
    category = get_command_category(command_name)

    # Determine required agents
    required_agents = set()
    if category != 'uncategorized':
        cat_info = CATEGORY_AGENT_REQUIREMENTS[category]
        required_agents.update(cat_info['required_agents'])

    # Security-critical commands need security-auditor
    if command_name in SECURITY_CRITICAL_COMMANDS:
        required_agents.add('security-auditor')

    # Check for missing agents
    missing_agents = required_agents - mentioned_agents

    # Check parallelization requirement
    needs_parallelization = command_name in PARALLEL_REQUIRED_COMMANDS
    has_parallelization = parallel_patterns['has_parallelization']

    # Calculate scores
    agent_score = len(mentioned_agents & required_agents) / len(required_agents) if required_agents else 1.0
    parallel_score = 1.0 if (not needs_parallelization or has_parallelization) else 0.0

    return {
        'command': command_name,
        'category': category,
        'mentioned_agents': list(mentioned_agents),
        'required_agents': list(required_agents),
        'missing_agents': list(missing_agents),
        'has_agents': len(mentioned_agents) > 0,
        'agent_score': agent_score,
        'needs_parallelization': needs_parallelization,
        'has_parallelization': has_parallelization,
        'parallel_patterns': parallel_patterns,
        'parallel_score': parallel_score,
        'overall_score': (agent_score + parallel_score) / 2
    }


def print_validation_report(results: List[Dict]):
    """Print a formatted validation report."""
    print("\n" + "="*80)
    print("COMMAND AGENT & PARALLELIZATION VALIDATION REPORT")
    print("="*80)

    # Summary statistics
    total_commands = len(results)
    commands_with_agents = sum(1 for r in results if r['has_agents'])
    commands_with_parallel = sum(1 for r in results if r['has_parallelization'])
    commands_needing_parallel = sum(1 for r in results if r['needs_parallelization'])
    commands_missing_agents = sum(1 for r in results if r['missing_agents'])

    avg_agent_score = sum(r['agent_score'] for r in results) / total_commands
    avg_parallel_score = sum(r['parallel_score'] for r in results) / total_commands
    avg_overall_score = sum(r['overall_score'] for r in results) / total_commands

    print(f"\n📊 SUMMARY")
    print(f"   Total Commands: {total_commands}")
    print(f"   Commands with Agents: {commands_with_agents}/{total_commands} ({commands_with_agents/total_commands*100:.1f}%)")
    print(f"   Commands with Parallelization: {commands_with_parallel}/{commands_needing_parallel} ({commands_with_parallel/commands_needing_parallel*100:.1f}% of required)")
    print(f"   Commands Missing Required Agents: {commands_missing_agents}")
    print(f"\n   Average Scores:")
    print(f"   - Agent Specification: {avg_agent_score*100:.1f}%")
    print(f"   - Parallelization: {avg_parallel_score*100:.1f}%")
    print(f"   - Overall: {avg_overall_score*100:.1f}%")

    # Grade calculation
    if avg_overall_score >= 0.9:
        grade = "A"
    elif avg_overall_score >= 0.8:
        grade = "B"
    elif avg_overall_score >= 0.7:
        grade = "C"
    elif avg_overall_score >= 0.6:
        grade = "D"
    else:
        grade = "F"

    print(f"\n   📈 ECOSYSTEM GRADE: {grade} ({avg_overall_score*100:.1f}%)")

    # Detailed results by category
    print(f"\n📋 DETAILED RESULTS BY CATEGORY")
    print("-"*80)

    categories = {}
    for result in results:
        cat = result['category']
        if cat not in categories:
            categories[cat] = []
        categories[cat].append(result)

    for category in sorted(categories.keys()):
        cat_results = categories[category]
        print(f"\n{category.upper().replace('_', ' ')}")

        for result in sorted(cat_results, key=lambda x: x['command']):
            status_agents = "✅" if not result['missing_agents'] else "❌"
            status_parallel = "✅" if not result['needs_parallelization'] or result['has_parallelization'] else "❌"

            print(f"  /{result['command']:15} Agents: {status_agents}  Parallel: {status_parallel}  Score: {result['overall_score']*100:.0f}%")

            if result['missing_agents']:
                print(f"    Missing agents: {', '.join(result['missing_agents'])}")

            if result['needs_parallelization'] and not result['has_parallelization']:
                print(f"    Needs parallelization patterns")

    # Critical issues
    print(f"\n⚠️  CRITICAL ISSUES")
    print("-"*80)

    security_missing = [r for r in results if r['command'] in SECURITY_CRITICAL_COMMANDS and 'security-auditor' in r['missing_agents']]
    if security_missing:
        print(f"\nSecurity-Critical Commands Missing security-auditor:")
        for r in security_missing:
            print(f"  - /{r['command']}")

    no_agents = [r for r in results if not r['has_agents']]
    if no_agents:
        print(f"\nCommands with NO Agent Specifications:")
        for r in no_agents:
            print(f"  - /{r['command']}")

    # Recommendations
    print(f"\n💡 TOP RECOMMENDATIONS")
    print("-"*80)

    # Sort by overall score to find worst performers
    worst_commands = sorted(results, key=lambda x: x['overall_score'])[:5]

    print(f"\nPriority Commands to Fix (lowest scores):")
    for i, r in enumerate(worst_commands, 1):
        print(f"{i}. /{r['command']} (Score: {r['overall_score']*100:.0f}%)")
        if r['missing_agents']:
            print(f"   - Add agents: {', '.join(r['missing_agents'])}")
        if r['needs_parallelization'] and not r['has_parallelization']:
            print(f"   - Add parallelization patterns")

    print("\n" + "="*80)


def main():
    """Main validation function."""
    try:
        commands_dir = find_commands_dir()
        print(f"Found commands directory: {commands_dir}")

        # Validate all command files
        results = []
        for cmd_file in sorted(commands_dir.glob("*.md")):
            if cmd_file.stem not in ['README', 'TEMPLATE']:
                result = validate_command(cmd_file)
                results.append(result)

        # Print report
        print_validation_report(results)

        # Save detailed results to JSON
        output_file = Path.cwd() / '.tmp' / 'command_validation_results.json'
        output_file.parent.mkdir(exist_ok=True)

        with open(output_file, 'w') as f:
            json.dump(results, f, indent=2)

        print(f"\nDetailed results saved to: {output_file}")

        # Exit with error if score is too low
        if results:
            avg_score = sum(r['overall_score'] for r in results) / len(results)
            if avg_score < 0.6:
                sys.exit(1)
        else:
            print("No commands found to validate")

    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
