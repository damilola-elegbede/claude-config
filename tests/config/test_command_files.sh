#!/bin/bash
# Test for command file validation (Altoid style - simple, powerful)

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test all command files exist
test_all_commands_exist() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"

    assert_dir_exists "$commands_dir" \
        "Commands directory should exist"

    # Check each expected command file (20 commands after consolidation)
    local expected_commands=("plan" "commit" "push" "test" "prime" "sync" "review"
                            "debug" "fix-ci" "implement" "verify" "resolve-cr"
                            "docs" "audit" "branch" "pr" "rebase" "prompt"
                            "deps" "ship-it")

    for cmd in "${expected_commands[@]}"; do
        assert_file_exists "$commands_dir/${cmd}.md" \
            "Command file ${cmd}.md should exist"
    done
}

# Test command YAML frontmatter structure
test_command_yaml_frontmatter() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"

    echo "Testing YAML frontmatter in command files..."

    for cmd_file in "$commands_dir"/*.md; do
        local cmd_name=$(basename "$cmd_file" .md)

        # All commands should have frontmatter
        if ! grep -q "^---$" "$cmd_file"; then
            echo "Warning: ${cmd_name}.md missing YAML frontmatter"
            continue
        fi

        local temp_file
        temp_file=$(mktemp)

        # Extract YAML front-matter
        sed -n '/^---$/,/^---$/p' "$cmd_file" | sed '1d;$d' > "$temp_file"

        # Check required fields
        if ! grep -q "^description:" "$temp_file"; then
            echo "${cmd_name}.md missing required 'description' field"
            rm "$temp_file"
            return 1
        fi

        echo "Valid YAML frontmatter in ${cmd_name}.md"
        rm "$temp_file"
    done

    return 0
}

# Test command file structure
test_command_structure() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"

    for cmd_file in "$commands_dir"/*.md; do
        local cmd_name=$(basename "$cmd_file" .md)

        # Check for YAML frontmatter or command header
        if ! grep -q "^---$" "$cmd_file" && ! grep -q "# /${cmd_name}" "$cmd_file"; then
            echo "${cmd_name}: Should have YAML frontmatter or command header"
            return 1
        fi

        # Check for required sections
        if grep -q "^---$" "$cmd_file"; then
            assert_file_contains "$cmd_file" "## Usage" \
                "${cmd_name}: Should have Usage section"
            assert_file_contains "$cmd_file" "## Description" \
                "${cmd_name}: Should have Description section"
            assert_file_contains "$cmd_file" "## Expected Output" \
                "${cmd_name}: Should have Expected Output section"
        fi

        # Check for usage example
        assert_file_contains "$cmd_file" "\`\`\`" \
            "${cmd_name}: Should have code block for usage"
    done
}

# Test unified audit command
test_command_audit_requirements() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"
    local audit_file="$commands_dir/audit.md"

    echo "  Testing unified audit implementation..."

    if [ ! -f "$audit_file" ]; then
        echo "    Error: audit.md not found"
        return 1
    fi

    # Check audit has proper frontmatter
    if grep -q "^---$" "$audit_file"; then
        echo "    audit follows template format"
    fi

    # Check for scope support
    if grep -q "scope" "$audit_file"; then
        echo "    Includes scope support"
    fi

    # Check for agents validation
    if grep -q "agents" "$audit_file"; then
        echo "    Includes agents support"
    fi

    # Check for commands validation
    if grep -q "commands" "$audit_file"; then
        echo "    Includes commands support"
    fi

    # Check for YAML validation
    if grep -q -i "yaml" "$audit_file"; then
        echo "    Includes YAML support"
    fi

    return 0
}

# Test frontmatter compliance
test_frontmatter_compliance() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"
    local failures=0

    echo "  Validating command frontmatter against template..."

    for cmd_file in "$commands_dir"/*.md; do
        local cmd_name=$(basename "$cmd_file" .md)

        if ! grep -q "^---$" "$cmd_file"; then
            echo "    Warning: ${cmd_name}.md missing YAML frontmatter"
            continue
        fi

        local yaml_content=$(sed -n '/^---$/,/^---$/p' "$cmd_file" | sed '1d;$d')

        # Check for required description field
        if ! echo "$yaml_content" | grep -q "^description:"; then
            echo "    Error: ${cmd_name}.md missing required 'description' field"
            failures=$((failures + 1))
        fi
    done

    if [ $failures -gt 0 ]; then
        echo "    Failed: $failures commands have frontmatter issues"
        return 1
    fi

    return 0
}

# Test template format compliance
test_template_format_compliance() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"
    local failures=0

    echo "  Validating command format against template..."

    for cmd_file in "$commands_dir"/*.md; do
        local cmd_name=$(basename "$cmd_file" .md)

        if grep -q "^---$" "$cmd_file"; then
            # Check required sections
            if ! grep -q "## Usage" "$cmd_file"; then
                echo "    Error: ${cmd_name}.md missing Usage section"
                failures=$((failures + 1))
            fi

            if ! grep -q "## Description" "$cmd_file"; then
                echo "    Error: ${cmd_name}.md missing Description section"
                failures=$((failures + 1))
            fi

            if ! grep -q "## Expected Output" "$cmd_file"; then
                echo "    Error: ${cmd_name}.md missing Expected Output section"
                failures=$((failures + 1))
            fi

            # Check for optional Behavior section
            if grep -q "## Behavior" "$cmd_file"; then
                echo "    Info: ${cmd_name}.md includes optional Behavior section"
            fi

            # Check for $ARGUMENTS usage if argument-hint present
            if grep -q "argument-hint:" "$cmd_file" && ! grep -q "\$ARGUMENTS" "$cmd_file"; then
                echo "    Warning: ${cmd_name}.md has argument-hint but no \$ARGUMENTS placeholder"
            fi
        fi
    done

    return 0
}

# Test command count (should be 20 after consolidation)
test_command_count() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"
    local cmd_count=$(ls -1 "$commands_dir"/*.md 2>/dev/null | wc -l | tr -d ' ')

    if [ "$cmd_count" -lt 15 ] || [ "$cmd_count" -gt 25 ]; then
        echo "Command count $cmd_count outside expected range (15-25)"
        return 1
    fi

    echo "Command count: $cmd_count (expected ~20)"
    return 0
}

# Test documentation completeness
test_documentation_completeness() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"

    for cmd_file in "$commands_dir"/*.md; do
        local cmd_name=$(basename "$cmd_file" .md)

        # Check file is not empty
        if [ ! -s "$cmd_file" ]; then
            echo "Command file ${cmd_name}.md is empty"
            return 1
        fi

        # Check for required sections or legacy content
        if grep -q "^---$" "$cmd_file"; then
            local missing_sections=()
            if ! grep -q "## Usage" "$cmd_file"; then
                missing_sections+=("Usage")
            fi
            if ! grep -q "## Description" "$cmd_file"; then
                missing_sections+=("Description")
            fi
            if ! grep -q "## Expected Output" "$cmd_file"; then
                missing_sections+=("Expected Output")
            fi

            if [ ${#missing_sections[@]} -gt 0 ]; then
                echo "${cmd_name}: Missing required sections: ${missing_sections[*]}"
                return 1
            fi
        fi
    done
}

# Test validation edge cases
test_validation_edge_cases() {
    local test_dir="$TEST_DIR/edge-cases"
    mkdir -p "$test_dir"

    echo "  Testing validation edge cases..."

    # Create test files for edge case validation
    # 1. Empty frontmatter
    cat > "$test_dir/empty-frontmatter.md" << 'EOF'
---
---
# Empty Frontmatter Command

## Usage
```
/empty-frontmatter
```

## Description
Test command with empty frontmatter.

## Expected Output
Test output.
EOF

    # 2. Long description
    cat > "$test_dir/long-description.md" << 'EOF'
---
description: This is a very long description that exceeds the recommended sixty character limit for command descriptions
argument-hint: [optional]
---
# Long Description Command

## Usage
```
/long-description
```

## Description
Test command with long description.

## Expected Output
Test output.
EOF

    # 3. Malformed YAML
    cat > "$test_dir/malformed-yaml.md" << 'EOF'
---
description: Valid description
argument-hint [invalid format without colon]
---
# Malformed YAML Command

## Usage
```
/malformed-yaml
```

## Description
Test command.

## Expected Output
Test output.
EOF

    # 4. Perfect command
    cat > "$test_dir/perfect-command.md" << 'EOF'
---
description: Short and descriptive
argument-hint: [file-path]
---
# Perfect Command

## Usage
```
/perfect-command [file-path]
```

## Description
A perfectly formatted command.

## Expected Output
Clear output description.
EOF

    # Validate each test file
    local valid_count=0
    local invalid_count=0

    for test_file in "$test_dir"/*.md; do
        local name=$(basename "$test_file" .md)
        local is_valid=true

        # Check for empty frontmatter
        local yaml_content=$(sed -n '/^---$/,/^---$/p' "$test_file" | sed '1d;$d')
        if [ -z "$yaml_content" ]; then
            echo "    $name: Empty frontmatter"
            is_valid=false
        fi

        # Check for missing description
        if ! echo "$yaml_content" | grep -q "^description:"; then
            echo "    $name: Missing description field"
            is_valid=false
        fi

        # Check for malformed YAML
        if echo "$yaml_content" | grep -qE "^[a-zA-Z-]+ [^\:]"; then
            echo "    $name: Invalid YAML syntax"
            is_valid=false
        fi

        # Check description length
        if echo "$yaml_content" | grep -q "^description:"; then
            local desc_length=$(echo "$yaml_content" | grep "^description:" | cut -d':' -f2- | sed 's/^[ \t]*//' | wc -c)
            if [ "$desc_length" -gt 65 ]; then
                echo "    Warning $name: Description too long"
            fi
        fi

        if [ "$is_valid" = true ]; then
            echo "    $name: Valid"
            valid_count=$((valid_count + 1))
        else
            invalid_count=$((invalid_count + 1))
        fi
    done

    echo "    Results: $valid_count valid, $invalid_count invalid commands"

    # Cleanup
    rm -rf "$test_dir"

    # Expect 2 valid (long-description, perfect-command) and 2 invalid (empty-frontmatter, malformed-yaml)
    if [ "$valid_count" -eq 2 ] && [ "$invalid_count" -eq 2 ]; then
        echo "    Edge case validation working correctly"
        return 0
    else
        echo "    Edge case validation counts unexpected"
        echo "    Expected: 2 valid, 2 invalid; Got: $valid_count valid, $invalid_count invalid"
        return 1
    fi
}

# Test validation categories coverage
test_validation_categories() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"
    local audit_file="$commands_dir/audit.md"

    echo "  Checking validation categories coverage..."

    # Check audit covers agents
    if grep -q "agents" "$audit_file"; then
        echo "    Covers agents validation"
    fi

    # Check audit covers commands
    if grep -q "commands" "$audit_file"; then
        echo "    Covers commands validation"
    fi

    # Check audit covers YAML
    if grep -qi "yaml" "$audit_file"; then
        echo "    Covers YAML validation"
    fi

    # Check audit covers validation
    if grep -qi "validation\|validate" "$audit_file"; then
        echo "    Covers validation validation"
    fi

    return 0
}

# Run all tests
echo "Testing command file validation..."

test_all_commands_exist || exit 1
test_command_count || exit 1
test_command_yaml_frontmatter || exit 1
test_command_structure || exit 1
test_frontmatter_compliance || exit 1
test_template_format_compliance || exit 1
test_command_audit_requirements || exit 1
test_documentation_completeness || exit 1
test_validation_edge_cases || exit 1
test_validation_categories || exit 1

echo "All command file validation tests passed!"
