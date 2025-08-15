#!/bin/bash

# Agent Reference Validation Script V2
# More precise pattern matching for agent references

set -e

echo "=== Agent Reference Validator V2 ==="
echo

# Get list of all agents
AGENTS_DIR=".claude/agents"
COMMANDS_DIR=".claude/commands"
DOCS_DIR="docs"

# Extract agent names from files
echo "Loading agent roster..."
agent_names=()
for agent_file in "$AGENTS_DIR"/*.md; do
    basename_file=$(basename "$agent_file")
    # Skip non-agent files
    if [[ -f "$agent_file" ]] && [[ "$basename_file" != "README.md" ]] && \
       [[ "$basename_file" != "AGENT_TEMPLATE.md" ]] && \
       [[ "$basename_file" != "AGENT_CATEGORIES.md" ]] && \
       [[ "$basename_file" != "AUDIT_VERIFICATION_PROTOCOL.md" ]]; then
        agent_name=$(basename "$agent_file" .md)
        agent_names+=("$agent_name")
    fi
done

echo "Found ${#agent_names[@]} agents in roster"
echo

# Create a regex pattern of all valid agents
valid_agents_pattern=""
for agent in "${agent_names[@]}"; do
    if [[ -n "$valid_agents_pattern" ]]; then
        valid_agents_pattern+="|"
    fi
    # Escape special regex characters in agent names
    escaped_agent=$(echo "$agent" | sed 's/[[\.*+?{}()|^$]/\\&/g')
    valid_agents_pattern+="$escaped_agent"
done

# Function to check references in a file
check_file() {
    local file="$1"
    local errors=0

    # Skip non-existent files
    [[ ! -f "$file" ]] && return 0

    # Look for specific patterns that indicate agent usage
    # Pattern: "uses/deploys/coordinates/launches {agent-name} agent"
    while IFS= read -r match; do
        # Extract agent name using grep with Perl-compatible regex
        agent_ref=$(echo "$match" | grep -oP '(?<=\b(uses|deploys|coordinates|launches|invokes) )\S+(?= agent\b)' | head -1)

        # Skip if we couldn't extract an agent name
        [[ -z "$agent_ref" ]] && continue

        # Check if it's a valid agent
        if ! echo "$agent_ref" | grep -qE "^($valid_agents_pattern)$"; then
            echo "❌ Invalid agent reference in $file: '$agent_ref' (context: $match)"
            ((errors++))
        fi
    done < <(grep -E "(uses|deploys|coordinates|launches|invokes) [a-z][a-z0-9-]+ agent" "$file" 2>/dev/null || true)

    # Pattern: "{agent-name} agent:" or "- {agent-name}:" in lists
    while IFS= read -r match; do
        # Skip lines with "(now:" which indicate historical references
        if echo "$match" | grep -q "(now:"; then
            continue
        fi

        agent_ref=$(echo "$match" | sed -E 's/^[[:space:]]*[-*]?[[:space:]]*([a-z][a-z0-9-]+):.*/\1/')

        # Only check if it looks like an agent reference (ends with common agent suffixes)
        if echo "$agent_ref" | grep -qE "(auditor|engineer|architect|designer|specialist|admin|commander|writer|tester|analyst|researcher)$"; then
            if ! echo "$agent_ref" | grep -qE "^($valid_agents_pattern)$"; then
                echo "❌ Invalid agent reference in $file: '$agent_ref' (context: $match)"
                ((errors++))
            fi
        fi
    done < <(grep -E "^[[:space:]]*[-*]?[[:space:]]*[a-z][a-z0-9-]+:" "$file" 2>/dev/null || true)

    return $errors
}

# Check all command files
echo "Checking command files..."
total_errors=0
for cmd_file in "$COMMANDS_DIR"/*.md; do
    if [[ -f "$cmd_file" ]]; then
        check_file "$cmd_file"
        errors=$?
        ((total_errors+=errors))
    fi
done

# Check documentation files
echo
echo "Checking documentation files..."
while IFS= read -r -d '' doc_file; do
    check_file "$doc_file"
    errors=$?
    ((total_errors+=errors))
done < <(find "$DOCS_DIR" -name "*.md" -type f -print0 2>/dev/null || true)

# Check CLAUDE.md files
echo
echo "Checking CLAUDE.md files..."
for claude_file in CLAUDE.md ~/CLAUDE.md; do
    if [[ -f "$claude_file" ]]; then
        check_file "$claude_file"
        errors=$?
        ((total_errors+=errors))
    fi
done

# Summary
echo
echo "=== Validation Summary ==="
if [[ $total_errors -eq 0 ]]; then
    echo "✅ All agent references are valid!"
    exit 0
else
    echo "❌ Found $total_errors invalid agent references"
    echo
    echo "Common issues to check:"
    echo "1. Renamed agents (e.g., performance-engineer → performance-specialist)"
    echo "2. Removed agents that are still referenced"
    echo "3. Typos in agent names"
    exit $total_errors
fi
