#!/bin/bash
# Integration test for skill template compliance validation
# Tests that skills validate against template requirements (migrated from command template compliance)

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test that user-invocable skills are validated against template requirements
# Reference/domain skills (user-invocable: false, imported skills) are excluded
test_existing_skills_template_compliance() {
    local skills_dir="$ORIGINAL_DIR/system-configs/.claude/skills"
    local compliance_issues=0

    echo "  Checking all skills for template compliance..."

    # Check each skill directory
    for skill_dir in "$skills_dir"/*/; do
        [ -d "$skill_dir" ] || continue
        local skill_file="$skill_dir/SKILL.md"
        [ -f "$skill_file" ] || continue

        local skill_name=$(basename "$skill_dir")

        echo "    Validating: $skill_name/SKILL.md"

        # Check if skill follows template format (has YAML frontmatter)
        if grep -q "^---$" "$skill_file"; then
            # New template format validation
            local yaml_content=$(sed -n '/^---$/,/^---$/p' "$skill_file" | sed '1d;$d')

            # Required: description field
            if ! echo "$yaml_content" | grep -q "^description:"; then
                echo "      ❌ Missing required 'description' field"
                compliance_issues=$((compliance_issues + 1))
            else
                local desc=$(echo "$yaml_content" | grep "^description:" | cut -d':' -f2- | sed 's/^[ \t]*//' | sed 's/[ \t]*$//')
                echo "      ✅ Valid description: $desc"
            fi

            # Skip section checks for non-user-invocable or imported reference skills
            if echo "$yaml_content" | grep -q "^user-invocable: false"; then
                echo "      ℹ️  Reference skill (user-invocable: false) - skipping section checks"
                echo
                continue
            fi

            # Skip section checks for imported skills with license field
            if echo "$yaml_content" | grep -q "^license:"; then
                echo "      ℹ️  Imported skill (has license) - skipping section checks"
                echo
                continue
            fi

            # Skip section checks for skills that use phase-based or alternative structure
            # (feature-lifecycle uses Phase 0/1/2/etc. instead of Usage/Description/Expected Output)
            if grep -q "^## Phase " "$skill_file"; then
                echo "      ℹ️  Phase-based skill - uses alternative structure, skipping section checks"
                echo
                continue
            fi

            # Content structure validation for user-invocable skills
            if grep -q "## Usage" "$skill_file"; then
                echo "      ✅ Has Usage section"
            else
                echo "      ❌ Missing required Usage section"
                compliance_issues=$((compliance_issues + 1))
            fi

            if grep -q "## Description" "$skill_file"; then
                echo "      ✅ Has Description section"
            else
                echo "      ❌ Missing required Description section"
                compliance_issues=$((compliance_issues + 1))
            fi

            if grep -q "## Expected Output" "$skill_file"; then
                echo "      ✅ Has Expected Output section"
            else
                echo "      ❌ Missing required Expected Output section"
                compliance_issues=$((compliance_issues + 1))
            fi
        else
            echo "      ℹ️  Using legacy format (no YAML frontmatter)"
        fi

        # Universal validation
        # Check file size (should be reasonable)
        local line_count=$(wc -l < "$skill_file")
        if [ "$line_count" -gt 600 ]; then
            echo "      ⚠️  Large skill file ($line_count lines > 600)"
        fi

        echo
    done

    if [ $compliance_issues -eq 0 ]; then
        echo "  ✅ All skills pass template compliance checks"
        return 0
    else
        echo "  ❌ Found $compliance_issues template compliance issues"
        return 1
    fi
}

# Test that unified audit skill is properly implemented
test_audit_skill_implementation() {
    local audit_file="$ORIGINAL_DIR/system-configs/.claude/skills/audit/SKILL.md"

    echo "  Validating unified audit implementation..."

    # Ensure audit SKILL.md exists
    if [ ! -f "$audit_file" ]; then
        echo "    ❌ audit/SKILL.md not found"
        return 1
    fi

    # Audit should follow template requirements
    if grep -q "^---$" "$audit_file"; then
        local yaml_content=$(sed -n '/^---$/,/^---$/p' "$audit_file" | sed '1d;$d')

        if ! echo "$yaml_content" | grep -q "^description:"; then
            echo "    ❌ audit missing required description field"
            return 1
        fi

        echo "    ✅ audit follows template format"
    else
        echo "    ⚠️  audit uses legacy format"
    fi

    # Verify audit contains key validation capabilities
    local required_validations=(
        "scope"
        "agents"
        "YAML"
    )

    for validation in "${required_validations[@]}"; do
        if grep -q -- "$validation" "$audit_file"; then
            echo "    ✅ Includes $validation support"
        else
            echo "    ❌ Missing $validation support"
            return 1
        fi
    done

    return 0
}

# Test that the validation logic handles edge cases correctly
test_validation_edge_cases() {
    setup_test_env

    local test_skills_dir="$TEST_DIR/skills"
    mkdir -p "$test_skills_dir"

    echo "  Testing validation edge cases..."

    # Edge case 1: Empty frontmatter
    cat > "$test_skills_dir/empty-frontmatter.md" << 'EOF'
---
---

# Skill with empty frontmatter
Should fail validation.
EOF

    # Edge case 2: Malformed YAML
    cat > "$test_skills_dir/malformed-yaml.md" << 'EOF'
---
description: Valid description
this is not valid yaml syntax
---

# Malformed YAML Skill
Has syntax error in YAML.
EOF

    # Edge case 3: Very long description
    cat > "$test_skills_dir/long-description.md" << 'EOF'
---
description: This is a very long description that exceeds the sixty character limit for autocomplete compatibility
---

# Long Description Skill
Tests length validation.
EOF

    # Edge case 4: Perfect template compliance
    cat > "$test_skills_dir/perfect-skill.md" << 'EOF'
---
description: Perfect template compliant skill
argument-hint: [file-path]
---

# Perfect Skill Purpose
This skill follows the template exactly.

## Usage

```bash
/perfect-skill [file-path]
```

## Description

This skill demonstrates perfect template compliance with all required sections.

## Expected Output

```text
Skill executed successfully with [file-path]
Processing complete
```

## Behavior

Optional detailed behavior description.
EOF

    # Simulate validation logic
    local valid_skills=0
    local invalid_skills=0

    for skill_file in "$test_skills_dir"/*.md; do
        local skill_name=$(basename "$skill_file" .md)
        local is_valid=true

        if grep -q "^---$" "$skill_file"; then
            local yaml_content=$(sed -n '/^---$/,/^---$/p' "$skill_file" | sed '1d;$d')

            # Check for empty frontmatter
            if [ -z "$(echo "$yaml_content" | tr -d '[:space:]')" ]; then
                echo "    ❌ $skill_name: Empty frontmatter"
                is_valid=false
            fi

            # Check required description
            if ! echo "$yaml_content" | grep -q "^description:"; then
                echo "    ❌ $skill_name: Missing description field"
                is_valid=false
            fi

            # Check YAML syntax
            if echo "$yaml_content" | grep -v '^$' | grep -v ':' | grep -q '.'; then
                echo "    ❌ $skill_name: Invalid YAML syntax"
                is_valid=false
            fi
        fi

        if [ "$is_valid" = true ]; then
            valid_skills=$((valid_skills + 1))
            echo "    ✅ $skill_name: Valid"
        else
            invalid_skills=$((invalid_skills + 1))
        fi
    done

    echo "    Results: $valid_skills valid, $invalid_skills invalid skills"

    cleanup_test_env

    # Should find exactly 2 valid skills (perfect-skill and long-description)
    # and 2 invalid skills (empty-frontmatter and malformed-yaml)
    if [ "$valid_skills" -eq 2 ] && [ "$invalid_skills" -eq 2 ]; then
        echo "    ✅ Edge case validation working correctly"
        return 0
    else
        echo "    ❌ Edge case validation failed"
        return 1
    fi
}

# Run all template compliance integration tests
echo "Testing skill template compliance integration..."

test_existing_skills_template_compliance || exit 1
test_audit_skill_implementation || exit 1
test_validation_edge_cases || exit 1

echo "All skill template compliance tests passed!"
