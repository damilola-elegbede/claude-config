#!/bin/bash

# YAML validation script for skill front-matter (migrated from command validation)

set -e

echo "Validating YAML front-matter in skill files..."

# Function to validate YAML front-matter for skills
validate_skill_yaml_frontmatter() {
    local file="$1"
    local temp_file
    temp_file=$(mktemp)

    # Extract YAML front-matter (between --- markers)
    sed -n '/^---$/,/^---$/p' "$file" | sed '1d;$d' > "$temp_file"

    # Check if we got any YAML content
    if [ ! -s "$temp_file" ]; then
        echo "Warning: No YAML front-matter found in $file (legacy format)"
        rm "$temp_file"
        return 0  # Not an error for legacy format
    fi

    # Validate YAML syntax (basic check - ensure it's key: value format)
    if ! grep -q "^[a-zA-Z_][a-zA-Z0-9_-]*:" "$temp_file"; then
        echo "Invalid YAML syntax in $file"
        rm "$temp_file"
        return 1
    fi

    # Check required fields
    local yaml_content=$(cat "$temp_file")

    # Required: description field
    if ! echo "$yaml_content" | grep -q "^description:"; then
        echo "Missing required 'description' field in $file"
        rm "$temp_file"
        return 1
    fi

    # Validate description content
    local description=$(echo "$yaml_content" | grep "^description:" | sed 's/^description: *//' | tr -d '"')
    if [ -z "$description" ] || [ "$description" = "description:" ]; then
        echo "Empty description field in $file"
        rm "$temp_file"
        return 1
    fi

    # Warn if description is too long for good UX
    if [ ${#description} -gt 100 ]; then
        echo "Warning: Description length (${#description} chars) exceeds recommended 100 chars in $file"
    fi

    # Optional: argument-hint field validation
    if echo "$yaml_content" | grep -q "^argument-hint:"; then
        local arg_hint=$(echo "$yaml_content" | grep "^argument-hint:" | sed 's/^argument-hint: *//' | tr -d '"')
        if [[ -n "$arg_hint" && "$arg_hint" != "" && ! "$arg_hint" =~ ^\[.*\]$ ]]; then
            echo "Warning: Argument hint should use square brackets format (e.g., [file-path]) in $file"
        fi
    fi

    echo "Valid YAML front-matter in $file"
    rm "$temp_file"
    return 0
}

# Counter for validation results
valid_count=0
legacy_count=0
invalid_count=0

# Find and validate all skill SKILL.md files
while IFS= read -r -d '' file; do
    if validate_skill_yaml_frontmatter "$file"; then
        if grep -q "^---$" "$file"; then
            ((valid_count++))
        else
            ((legacy_count++))
        fi
    else
        ((invalid_count++))
    fi
done < <(find system-configs/.claude/skills -name "SKILL.md" -not -path "*/.tmp/*" -print0 2>/dev/null)

# Summary
echo ""
echo "Skill YAML Validation Summary:"
echo "Valid YAML files: $valid_count"
echo "Legacy format files: $legacy_count"
echo "Invalid files: $invalid_count"

if [ $invalid_count -eq 0 ]; then
    echo "All skill files are valid!"
    if [ $legacy_count -gt 0 ]; then
        echo "Consider migrating $legacy_count legacy format files to use YAML frontmatter"
    fi
    exit 0
else
    echo "Found $invalid_count files with invalid YAML front-matter"
    exit 1
fi
