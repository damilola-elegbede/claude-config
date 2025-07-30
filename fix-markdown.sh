#!/bin/bash

# Quick fix script for common markdown linting issues

echo "🔧 Fixing markdown linting issues..."

# Fix multiple consecutive blank lines (MD012)
echo "Fixing multiple consecutive blank lines..."
find . -name "*.md" -not -path "./node_modules/*" -not -path "./.git/*" | while read -r file; do
    # Replace multiple consecutive blank lines with single blank line
    perl -i -pe 's/\n\n\n+/\n\n/g' "$file"
done

# Fix bare URLs in CLAUDE.md (MD034)
echo "Fixing bare URLs in CLAUDE.md..."
sed -i.bak 's|https://docs.anthropic.com/en/docs/claude-code/cli-reference|[CLI Reference](https://docs.anthropic.com/en/docs/claude-code/cli-reference)|g' CLAUDE.md
sed -i.bak 's|https://docs.anthropic.com/en/docs/claude-code/sub-agents|[Sub-agents Guide](https://docs.anthropic.com/en/docs/claude-code/sub-agents)|g' CLAUDE.md  
sed -i.bak 's|https://docs.anthropic.com/en/docs/claude-code/settings#tools-available-to-claude|[Available Tools](https://docs.anthropic.com/en/docs/claude-code/settings#tools-available-to-claude)|g' CLAUDE.md

# Fix spaces in emphasis markers in file-navigator.md (MD037)
echo "Fixing spaces in emphasis markers..."
sed -i.bak 's/, \*\*/, **/g' .claude/agents/file-navigator.md
sed -i.bak 's/, \*/, */g' .claude/agents/file-navigator.md

# Add blank lines around tables (MD058)
echo "Adding blank lines around tables..."
find . -name "*.md" -not -path "./node_modules/*" -not -path "./.git/*" | while read -r file; do
    # Add blank line before tables that start with |
    perl -i -pe 's/^(\|[^|]*\|)/\n$1/ if $. > 1 && $prev !~ /^\s*$/' "$file"
    
    # Store previous line for next iteration
    perl -i -pe 'BEGIN{$prev=""} $current=$_; $_=$prev; $prev=$current; END{print $prev}' "$file"
done

# Fix table column counts in AGENT_SELECTION_GUIDE.md
echo "Fixing table column counts..."
if [ -f "docs/AGENT_SELECTION_GUIDE.md" ]; then
    # Fix the table header and content to have consistent columns
    sed -i.bak 's/| Task Type | Recommended Agent | Alternative | When to Use Alternative | Example |/| Task Type | Recommended Agent | Alternative | When to Use Alternative |/g' docs/AGENT_SELECTION_GUIDE.md
    # Remove extra columns from rows
    sed -i.bak 's/| Complex bug investigation | debugger | log-analyst | For log-focused debugging | Race conditions, memory leaks |/| Complex bug investigation | debugger | log-analyst | For log-focused debugging |/g' docs/AGENT_SELECTION_GUIDE.md
fi

# Fix hard tabs to spaces in pre-commit-implementation-plan.md
echo "Converting hard tabs to spaces..."
if [ -f "docs/devops/pre-commit-implementation-plan.md" ]; then
    expand -t 4 docs/devops/pre-commit-implementation-plan.md > docs/devops/pre-commit-implementation-plan.md.tmp
    mv docs/devops/pre-commit-implementation-plan.md.tmp docs/devops/pre-commit-implementation-plan.md
fi

# Clean up backup files
find . -name "*.bak" -delete

echo "✅ Markdown linting fixes applied!"
echo "Run 'npx markdownlint-cli2 \"**/*.md\"' to verify fixes"