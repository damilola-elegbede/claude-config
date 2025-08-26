#!/bin/bash

# YAML validation script for agent front-matter

set -e

echo "🔍 Validating YAML front-matter in agent files..."

# Function to validate YAML front-matter
validate_yaml_frontmatter() {
    local file="$1"
    local temp_file
    temp_file=$(mktemp)

    # Extract YAML front-matter (between --- markers)
    sed -n '/^---$/,/^---$/p' "$file" | sed '1d;$d' > "$temp_file"

    # Check if we got any YAML content
    if [ ! -s "$temp_file" ]; then
        echo "❌ No YAML front-matter found in $file"
        rm "$temp_file"
        return 1
    fi

    # Validate YAML syntax (basic check - ensure it's key: value format)
    if ! grep -q "^[a-zA-Z_][a-zA-Z0-9_]*:" "$temp_file"; then
        echo "❌ Invalid YAML syntax in $file"
        rm "$temp_file"
        return 1
    fi

    # Check required fields
    local yaml_content=$(cat "$temp_file")
    if ! echo "$yaml_content" | grep -q "^name:"; then
        echo "❌ Missing 'name' field in $file"
        rm "$temp_file"
        return 1
    fi

    if ! echo "$yaml_content" | grep -q "^description:"; then
        echo "❌ Missing 'description' field in $file"
        rm "$temp_file"
        return 1
    fi

    if ! echo "$yaml_content" | grep -q "^color:"; then
        echo "❌ Missing 'color' field in $file"
        rm "$temp_file"
        return 1
    fi

    if ! echo "$yaml_content" | grep -q "^category:"; then
        echo "❌ Missing 'category' field in $file"
        rm "$temp_file"
        return 1
    fi

    if ! echo "$yaml_content" | grep -q "^tools:"; then
        echo "❌ Missing 'tools' field in $file"
        rm "$temp_file"
        return 1
    fi

    echo "✅ Valid YAML front-matter in $file"
    rm "$temp_file"
    return 0
}

# Counter for validation results
valid_count=0
invalid_count=0

# Find and validate all agent markdown files (exclude .tmp and documentation files)
while IFS= read -r -d '' file; do
    if validate_yaml_frontmatter "$file"; then
        ((valid_count++))
    else
        ((invalid_count++))
    fi
done < <(find system-configs/.claude/agents -name "*.md" -not -name "README.md" -not -name "AGENT_*.md" -not -path "*/.tmp/*" -not -name "AUDIT_*.md" -print0 2>/dev/null)

# Summary
echo ""
echo "📊 YAML Validation Summary:"
echo "✅ Valid files: $valid_count"
echo "❌ Invalid files: $invalid_count"

if [ $invalid_count -eq 0 ]; then
    echo "🎉 All YAML front-matter is valid!"
    exit 0
else
    echo "💥 Found $invalid_count files with invalid YAML front-matter"
    exit 1
fi
