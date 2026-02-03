#!/usr/bin/env python3
"""
Configuration Integrity Tests
=============================

Pytest-based validation tests for Claude Code configuration ecosystem.
Verifies agent/command counts, orphan references, YAML validity, and routing consistency.

Usage:
    python -m pytest scripts/test-config-integrity.py -v
    python scripts/test-config-integrity.py  # Direct execution
"""

import os
import re
import sys
from pathlib import Path

# Get project root
SCRIPT_DIR = Path(__file__).parent
PROJECT_ROOT = SCRIPT_DIR.parent
AGENTS_DIR = PROJECT_ROOT / "system-configs" / ".claude" / "agents"
COMMANDS_DIR = PROJECT_ROOT / "system-configs" / ".claude" / "commands"
SKILLS_DIR = PROJECT_ROOT / "system-configs" / ".claude" / "skills"

# Expected counts after optimization (consolidated from 31 agents, 21 commands)
# Updated: accessibility-auditor added as standalone complex agent
# Updated: debug, review, ship-it moved from commands to skills (21 - 3 = 18)
EXPECTED_AGENT_COUNT = 12
EXPECTED_COMMAND_COUNT = 18

# Non-agent/command documentation files to skip
NON_AGENT_FILES = [
    "README.md", "AGENT_CATEGORIES.md", "AGENT_TEMPLATE.md",
    "AUDIT_VERIFICATION_PROTOCOL.md", "AGENT_SELECTION_GUIDE.md",
    "ENHANCEMENT_SUMMARY.md"
]
NON_COMMAND_FILES = ["README.md", "COMMAND_TEMPLATE.md"]

# Built-in Claude Code Task tool agent types (not custom agents)
# These are part of the Task tool's available subagent_types
BUILTIN_AGENT_TYPES = {
    "general-purpose", "bash", "explore", "plan", "statusline-setup"
}


def count_agents() -> int:
    """Count agent files excluding documentation."""
    if not AGENTS_DIR.exists():
        return 0
    return len([f for f in AGENTS_DIR.glob("*.md") if f.name not in NON_AGENT_FILES])


def count_commands() -> int:
    """Count command files excluding documentation."""
    if not COMMANDS_DIR.exists():
        return 0
    return len([f for f in COMMANDS_DIR.glob("*.md") if f.name not in NON_COMMAND_FILES])


def get_all_agents() -> list[str]:
    """Get list of all agent names."""
    if not AGENTS_DIR.exists():
        return []
    return [f.stem for f in AGENTS_DIR.glob("*.md") if f.name not in NON_AGENT_FILES]


def extract_yaml_section(file_path: Path) -> str | None:
    """Extract YAML front-matter from file."""
    with open(file_path, "r") as f:
        content = f.read()
    match = re.match(r"^---\n(.*?)\n---", content, re.DOTALL)
    return match.group(1) if match else None


def find_orphan_references() -> list[tuple[str, str]]:
    """Find agent references in commands that don't exist."""
    orphans: list[tuple[str, str]] = []
    valid_agents = set(a.lower() for a in get_all_agents())

    if not COMMANDS_DIR.exists():
        return orphans

    # Only look for explicit agent references in specific contexts
    # This is more targeted to avoid false positives
    agent_patterns = [
        r"subagent_type[=:]\s*['\"]?(\w+-\w+)['\"]?",  # subagent_type="agent-name"
        r"Task tool.*?(\w+-\w+)",  # Task tool with agent-name
        r"use\s+the\s+(\w+-\w+)\s+agent",  # "use the agent-name agent"
    ]

    for cmd_file in COMMANDS_DIR.glob("*.md"):
        if cmd_file.name in NON_COMMAND_FILES:
            continue

        content = cmd_file.read_text()

        # Find potential agent references
        for pattern in agent_patterns:
            matches = re.findall(pattern, content, re.IGNORECASE)
            for match in matches:
                match_lower = match.lower()
                # Must look like an agent name (lowercase-letters-separated-by-hyphens)
                if re.match(r"^[a-z]+-[a-z]+(?:-[a-z]+)?$", match_lower):
                    # Skip built-in Task tool agent types
                    if match_lower in BUILTIN_AGENT_TYPES:
                        continue
                    if match_lower not in valid_agents:
                        orphans.append((cmd_file.name, match))

    return orphans


def get_all_routing_keywords() -> list[str]:
    """Extract routing keywords from CLAUDE.md."""
    claude_md = PROJECT_ROOT / "system-configs" / "CLAUDE.md"
    if not claude_md.exists():
        return []

    content = claude_md.read_text()
    keywords: list[str] = []

    # Extract keywords from routing table
    keyword_pattern = r"\|\s*([^|]+)\s*\|\s*([^|]+)\s*\|"
    for match in re.finditer(keyword_pattern, content):
        keyword_cell = match.group(1).strip()
        if keyword_cell and keyword_cell != "Keywords":
            # Split comma-separated keywords
            for kw in keyword_cell.split(","):
                kw = kw.strip().lower()
                if kw and kw not in ["keywords"]:
                    keywords.append(kw)

    return keywords


def parse_yaml(file_path: Path, file_type: str = "agent") -> bool:
    """Check if YAML front-matter is parseable."""
    yaml_text = extract_yaml_section(file_path)
    if not yaml_text:
        # Commands may have legacy format without YAML front-matter
        if file_type == "command":
            return True
        return False

    # Basic validation - check for required structure
    if file_type == "agent":
        required_patterns = [r"^name:", r"^description:"]
    else:
        # Commands only require description
        required_patterns = [r"^description:"]

    for pattern in required_patterns:
        if not re.search(pattern, yaml_text, re.MULTILINE):
            return False

    return True


# Test functions for pytest
def test_agent_count():
    """Verify expected agent count after consolidation."""
    actual = count_agents()
    assert actual == EXPECTED_AGENT_COUNT, (
        f"Expected {EXPECTED_AGENT_COUNT} agents, found {actual}. "
        f"Agents: {get_all_agents()}"
    )


def test_command_count():
    """Verify expected command count after consolidation."""
    actual = count_commands()
    assert actual == EXPECTED_COMMAND_COUNT, (
        f"Expected {EXPECTED_COMMAND_COUNT} commands, found {actual}"
    )


def test_no_orphan_references():
    """Ensure no commands reference deleted agents."""
    orphans = find_orphan_references()
    if orphans:
        orphan_list = [f"{cmd}: {ref}" for cmd, ref in orphans]
        raise AssertionError(f"Found orphaned agent references: {orphan_list}")


def test_yaml_valid():
    """All YAML front-matter parses correctly."""
    invalid = []

    if AGENTS_DIR.exists():
        for agent_file in AGENTS_DIR.glob("*.md"):
            if agent_file.name not in NON_AGENT_FILES:
                if not parse_yaml(agent_file, "agent"):
                    invalid.append(f"agents/{agent_file.name}")

    if COMMANDS_DIR.exists():
        for cmd_file in COMMANDS_DIR.glob("*.md"):
            if cmd_file.name not in NON_COMMAND_FILES:
                if not parse_yaml(cmd_file, "command"):
                    invalid.append(f"commands/{cmd_file.name}")

    assert not invalid, f"Invalid YAML in: {invalid}"


def test_routing_keywords_defined():
    """Ensure routing keywords are defined in CLAUDE.md."""
    keywords = get_all_routing_keywords()
    assert len(keywords) > 0, "No routing keywords found in CLAUDE.md"


def test_consolidated_agents_exist():
    """Verify consolidated agents were created correctly."""
    agents = get_all_agents()

    # Removed agents should not exist (including career-assistant which was removed with skills)
    removed_agents = [
        "ats-auditor", "resume-parser", "content-writer",
        "career-strategist", "application-tracker", "company-researcher",
        "mobile-ui", "career-assistant"
    ]
    for removed in removed_agents:
        assert removed not in agents, f"Deleted agent {removed} still exists"


def test_consolidated_commands_exist():
    """Verify consolidated commands were created correctly."""
    if not COMMANDS_DIR.exists():
        return

    commands = [f.stem for f in COMMANDS_DIR.glob("*.md") if f.name not in NON_COMMAND_FILES]

    # audit command should exist (consolidated from agent-audit + command-audit)
    assert "audit" in commands, "audit command missing"

    # Removed commands should not exist
    removed_commands = ["implementation-plan", "agent-audit", "command-audit"]
    for removed in removed_commands:
        assert removed not in commands, f"Deleted command {removed} still exists"


def main():
    """Run tests directly without pytest."""
    print("Running Configuration Integrity Tests...\n")

    tests = [
        ("Agent Count", test_agent_count),
        ("Command Count", test_command_count),
        ("No Orphan References", test_no_orphan_references),
        ("YAML Valid", test_yaml_valid),
        # Routing keywords test removed - Boris Cherny philosophy uses identity/preferences, not routing tables
        ("Consolidated Agents", test_consolidated_agents_exist),
        ("Consolidated Commands", test_consolidated_commands_exist),
    ]

    passed = 0
    failed = 0

    for name, test_func in tests:
        try:
            test_func()
            print(f"  PASS  {name}")
            passed += 1
        except AssertionError as e:
            print(f"  FAIL  {name}")
            print(f"        {str(e)[:100]}")
            failed += 1

    print(f"\n{'='*50}")
    print(f"Results: {passed} passed, {failed} failed")

    return 0 if failed == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
