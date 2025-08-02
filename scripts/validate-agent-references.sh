#!/bin/bash

# Agent Reference Validation Script
# Ensures all agent references in commands and documentation are valid

set -e

echo "=== Agent Reference Validator ==="
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
    if [[ -f "$agent_file" ]] && [[ "$basename_file" != "README.md" ]] && [[ "$basename_file" != "AGENT_TEMPLATE.md" ]] && [[ "$basename_file" != "AGENT_CATEGORIES.md" ]] && [[ "$basename_file" != "AUDIT_VERIFICATION_PROTOCOL.md" ]]; then
        agent_name=$(basename "$agent_file" .md)
        agent_names+=("$agent_name")
    fi
done

echo "Found ${#agent_names[@]} agents in roster"
echo

# Function to check if a string is a valid agent
is_valid_agent() {
    local potential_agent="$1"
    for agent in "${agent_names[@]}"; do
        if [[ "$potential_agent" == "$agent" ]]; then
            return 0
        fi
    done
    return 1
}

# Function to check references in a file
check_file() {
    local file="$1"
    local errors=0
    
    # Skip non-existent files
    [[ ! -f "$file" ]] && return 0
    
    # Look for specific agent reference patterns
    # Pattern 1: "agent-name agent" or "agent-name agents"
    while IFS= read -r line; do
        # Extract agent name before "agent" or "agents"
        if [[ "$line" =~ ([a-z][a-z0-9-]*[a-z0-9])\ agents? ]]; then
            potential_agent="${BASH_REMATCH[1]}"
            # Skip common words that aren't agent names
            if [[ "$potential_agent" != "the" ]] && [[ "$potential_agent" != "all" ]] && \
               [[ "$potential_agent" != "other" ]] && [[ "$potential_agent" != "multiple" ]] && \
               [[ "$potential_agent" != "specialized" ]] && [[ "$potential_agent" != "existing" ]] && \
               [[ "$potential_agent" != "new" ]] && [[ "$potential_agent" != "missing" ]] && \
               [[ "$potential_agent" != "comprehensive" ]] && [[ "$potential_agent" != "entire" ]] && \
               [[ "$potential_agent" != "range" ]] && [[ "$potential_agent" != "for" ]] && \
               [[ "$potential_agent" != "affects" ]] && [[ "$potential_agent" != "which" ]] && \
               [[ "$potential_agent" != "similar" ]] && [[ "$potential_agent" != "specific" ]] && \
               [[ "${#potential_agent}" -gt 3 ]]; then
                if ! is_valid_agent "$potential_agent"; then
                    echo "❌ Invalid reference in $file: '$potential_agent agent'"
                    ((errors++))
                fi
            fi
        fi
    done < "$file"
    
    # Pattern 2: Look for explicit "uses X agent", "deploys X agent", etc.
    while IFS= read -r line; do
        if [[ -n "$line" ]]; then
            # Extract the agent name
            agent_ref=$(echo "$line" | sed -E 's/.*(uses|deploys|coordinates|launches|invokes) ([a-z][a-z0-9-]*[a-z0-9]) agent.*/\2/')
            if [[ "$agent_ref" != "$line" ]] && ! is_valid_agent "$agent_ref"; then
                echo "❌ Invalid reference in $file: '$agent_ref agent' (from: $line)"
                ((errors++))
            fi
        fi
    done < <(grep -E "(uses|deploys|coordinates|launches|invokes) [a-z][a-z0-9-]*[a-z0-9] agent" "$file" 2>/dev/null || true)
    
    return $errors
}

# Check all command files
echo "Checking command files..."
total_errors=0
cmd_errors=0
for cmd_file in "$COMMANDS_DIR"/*.md; do
    if [[ -f "$cmd_file" ]]; then
        check_file "$cmd_file"
        cmd_errors=$?
        ((total_errors+=cmd_errors))
    fi
done

# Check documentation files
echo
echo "Checking documentation files..."
doc_errors=0
while IFS= read -r -d '' doc_file; do
    check_file "$doc_file"
    doc_errors=$?
    ((total_errors+=doc_errors))
done < <(find "$DOCS_DIR" -name "*.md" -type f -print0)

# Check CLAUDE.md files
echo
echo "Checking CLAUDE.md files..."
for claude_file in CLAUDE.md ~/CLAUDE.md; do
    if [[ -f "$claude_file" ]]; then
        check_file "$claude_file"
        claude_errors=$?
        ((total_errors+=claude_errors))
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
    echo "To fix:"
    echo "1. Update references to use existing agents"
    echo "2. Create missing agents if needed"
    echo "3. Remove obsolete references"
    exit 1
fi