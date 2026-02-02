#!/usr/bin/env python3
"""
Circular Dependency Detection
=============================

Detects circular dependencies in commands and skills that invoke other commands.

Checks for:
- Direct cycles (A → B → A)
- Indirect cycles (A → B → C → A)
- Self-references (A → A)
- Orphaned commands (referenced but don't exist)

Add to pre-commit and CI for validation.
"""

import os
import re
import sys
from pathlib import Path
from collections import defaultdict


def _read_text(path: Path) -> str:
    """Read file with explicit UTF-8 encoding and error handling."""
    try:
        return path.read_text(encoding="utf-8")
    except OSError as exc:
        raise RuntimeError(f"Failed to read {path}: {exc}") from exc


def extract_command_references(content: str) -> list[str]:
    """Extract command references from file content.

    Looks for patterns like:
    - /command-name
    - `/command-name`
    - Run `/command-name`
    - Execute /command-name
    """
    references = []

    # Pattern for command invocations (excluding markdown headers and code comments)
    # Matches /word or /word-word patterns
    patterns = [
        r'(?:Run|Execute|Use|Invoke|Call)\s+[`"]?(/[a-z][a-z0-9-]*)',  # Explicit invocations
        r':\s*[`"]?(/[a-z][a-z0-9-]*)[`"]?\s*(?:command|skill)?',  # Label: /command
        r'(?:then|after|before)\s+[`"]?(/[a-z][a-z0-9-]*)',  # Workflow sequences
    ]

    for pattern in patterns:
        matches = re.findall(pattern, content, re.IGNORECASE)
        references.extend(matches)

    # Deduplicate and normalize
    normalized = list(set(ref.lower().strip('`"') for ref in references))
    return normalized


def build_dependency_graph(commands_dir: Path, skills_dir: Path) -> tuple[dict, set]:
    """Build a dependency graph from commands and skills.

    Returns:
        Tuple of (adjacency_list, all_commands)
    """
    graph = defaultdict(set)
    all_commands = set()

    # Process commands
    if commands_dir.exists():
        for file_path in commands_dir.glob("*.md"):
            if file_path.name in ["README.md", "TEMPLATE.md"]:
                continue

            command_name = "/" + file_path.stem
            all_commands.add(command_name)

            content = _read_text(file_path)
            references = extract_command_references(content)

            for ref in references:
                if ref != command_name:  # Exclude self-references (documentation mentions)
                    graph[command_name].add(ref)

    # Process skills (directory-based)
    if skills_dir.exists():
        for skill_dir in skills_dir.iterdir():
            if skill_dir.is_dir() and not skill_dir.name.startswith('.'):
                skill_file = skill_dir / "SKILL.md"
                if skill_file.exists():
                    skill_name = "/" + skill_dir.name
                    all_commands.add(skill_name)

                    content = _read_text(skill_file)
                    references = extract_command_references(content)

                    for ref in references:
                        if ref != skill_name:  # Exclude self-references (documentation mentions)
                            graph[skill_name].add(ref)

        # Process legacy flat-file skills (skills/<name>.md)
        non_skill_files = {"README.md", "TEMPLATE.md"}
        for skill_file in skills_dir.glob("*.md"):
            if skill_file.name in non_skill_files:
                continue
            skill_name = "/" + skill_file.stem
            all_commands.add(skill_name)

            content = _read_text(skill_file)
            references = extract_command_references(content)

            for ref in references:
                if ref != skill_name:  # Exclude self-references (documentation mentions)
                    graph[skill_name].add(ref)

    return dict(graph), all_commands


def normalize_cycle(cycle: list[str]) -> tuple[str, ...]:
    """Normalize a cycle for deduplication.

    Rotates the cycle so the lexicographically smallest element is first,
    then returns as a tuple (without the duplicate end element).
    """
    # Remove the duplicate end element (A -> B -> A becomes [A, B])
    if len(cycle) > 1 and cycle[0] == cycle[-1]:
        cycle = cycle[:-1]

    if not cycle:
        return tuple()

    # Find the index of the lexicographically smallest element
    min_idx = cycle.index(min(cycle))

    # Rotate so smallest is first
    rotated = cycle[min_idx:] + cycle[:min_idx]
    return tuple(rotated)


def find_cycles(graph: dict) -> list[list[str]]:
    """Find all cycles in the dependency graph using DFS.

    Returns deduplicated cycles (same cycle with different starting nodes
    is only reported once).
    """
    cycles = []
    seen_cycles: set[tuple[str, ...]] = set()
    visited = set()
    rec_stack = set()
    path = []

    def dfs(node: str) -> bool:
        visited.add(node)
        rec_stack.add(node)
        path.append(node)

        for neighbor in graph.get(node, []):
            if neighbor not in visited:
                if dfs(neighbor):
                    return True
            elif neighbor in rec_stack:
                # Found a cycle
                cycle_start = path.index(neighbor)
                cycle = path[cycle_start:] + [neighbor]

                # Deduplicate by normalizing
                normalized = normalize_cycle(cycle)
                if normalized not in seen_cycles:
                    seen_cycles.add(normalized)
                    cycles.append(cycle)

        path.pop()
        rec_stack.remove(node)
        return False

    for node in graph:
        if node not in visited:
            dfs(node)

    return cycles


def find_self_references(graph: dict) -> list[str]:
    """Find commands that reference themselves."""
    self_refs = []
    for command, deps in graph.items():
        if command in deps:
            self_refs.append(command)
    return self_refs


def find_orphaned_references(graph: dict, all_commands: set) -> dict[str, list[str]]:
    """Find references to commands that don't exist."""
    orphans = defaultdict(list)

    for command, deps in graph.items():
        for dep in deps:
            if dep not in all_commands:
                orphans[command].append(dep)

    return dict(orphans)


def main():
    """Main validation function."""
    script_dir = Path(__file__).parent
    repo_dir = script_dir.parent
    commands_dir = repo_dir / "system-configs" / ".claude" / "commands"
    skills_dir = repo_dir / "system-configs" / ".claude" / "skills"

    print("🔍 Checking for circular dependencies...")

    # Build dependency graph
    try:
        graph, all_commands = build_dependency_graph(commands_dir, skills_dir)
    except RuntimeError as exc:
        print(f"\n❌ {exc}", file=sys.stderr)
        return 1

    if not graph:
        print("   No command dependencies found to check")
        return 0

    print(f"   Analyzing {len(all_commands)} commands/skills...")

    errors_found = False

    # Check for self-references
    self_refs = find_self_references(graph)
    if self_refs:
        errors_found = True
        print("\n❌ Self-references detected:")
        for ref in self_refs:
            print(f"   • {ref} references itself")

    # Check for cycles
    cycles = find_cycles(graph)
    if cycles:
        errors_found = True
        print("\n❌ Circular dependencies detected:")
        for cycle in cycles:
            cycle_str = " → ".join(cycle)
            print(f"   • {cycle_str}")

    # Check for orphaned references
    orphans = find_orphaned_references(graph, all_commands)
    if orphans:
        # Orphans are warnings, not errors (the referenced command might be built-in)
        print("\n⚠️  References to undefined commands (may be built-in):")
        for command, refs in orphans.items():
            for ref in refs:
                print(f"   • {command} references {ref}")

    if errors_found:
        print("\n❌ Circular dependency check failed")
        return 1
    else:
        print("\n✅ No circular dependencies found")
        return 0


if __name__ == "__main__":
    sys.exit(main())
