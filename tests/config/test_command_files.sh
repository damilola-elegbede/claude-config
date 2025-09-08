#!/bin/bash
# Test for command file validation

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test all command files exist
test_all_commands_exist() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"

    assert_dir_exists "$commands_dir" \
        "Commands directory should exist"

    # Check each command file
    local expected_commands=("plan" "commit" "push" "test" "prime" "sync")

    for cmd in "${expected_commands[@]}"; do
        assert_file_exists "$commands_dir/${cmd}.md" \
            "Command file ${cmd}.md should exist"
    done
}

# Test command YAML frontmatter structure (new template format)
test_command_yaml_frontmatter() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"

    echo "Testing YAML frontmatter in command files..."

    # Test each command file has proper YAML frontmatter
    for cmd_file in "$commands_dir"/*.md; do
        local cmd_name=$(basename "$cmd_file" .md)
        
        # Skip if this is the old format (no frontmatter expected)
        if ! grep -q "^---$" "$cmd_file"; then
            echo "⚠️  ${cmd_name}.md uses legacy format (no YAML frontmatter)"
            continue
        fi

        local temp_file
        temp_file=$(mktemp)

        # Extract YAML front-matter (between --- markers)
        sed -n '/^---$/,/^---$/p' "$cmd_file" | sed '1d;$d' > "$temp_file"

        # Check if we got any YAML content
        if [ ! -s "$temp_file" ]; then
            echo "❌ Empty YAML front-matter in ${cmd_name}.md"
            rm "$temp_file"
            return 1
        fi

        # Validate YAML syntax (basic check - ensure it's key: value format)
        if ! grep -q "^[a-zA-Z_][a-zA-Z0-9_-]*:" "$temp_file"; then
            echo "❌ Invalid YAML syntax in ${cmd_name}.md"
            rm "$temp_file"
            return 1
        fi

        # Check required fields
        local yaml_content=$(cat "$temp_file")
        
        # Required: description field
        if ! echo "$yaml_content" | grep -q "^description:"; then
            echo "❌ Missing required 'description' field in ${cmd_name}.md"
            rm "$temp_file"
            return 1
        fi

        # Validate description content (should not be empty and under 60 chars for good UX)
        local description=$(echo "$yaml_content" | grep "^description:" | sed 's/^description: *//' | tr -d '"')
        if [ -z "$description" ] || [ "$description" = "description:" ]; then
            echo "❌ Empty description field in ${cmd_name}.md"
            rm "$temp_file"
            return 1
        fi
        
        if [ ${#description} -gt 60 ]; then
            echo "⚠️  Description too long (${#description} chars) in ${cmd_name}.md - consider shortening for better UX"
        fi

        # Optional: argument-hint field validation
        if echo "$yaml_content" | grep -q "^argument-hint:"; then
            local arg_hint=$(echo "$yaml_content" | grep "^argument-hint:" | sed 's/^argument-hint: *//' | tr -d '"')
            # If present, should use proper format with square brackets for optional args
            if [[ -n "$arg_hint" && ! "$arg_hint" =~ ^\[.*\]$ ]]; then
                echo "⚠️  Argument hint should use square brackets format (e.g., [file-path]) in ${cmd_name}.md"
            fi
        fi

        echo "✅ Valid YAML frontmatter in ${cmd_name}.md"
        rm "$temp_file"
    done

    return 0
}

# Test command file structure (legacy format - keeping for compatibility)
test_command_structure() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"

    # Test each command file has proper structure
    for cmd_file in "$commands_dir"/*.md; do
        local cmd_name=$(basename "$cmd_file" .md)

        # Check for command header OR YAML frontmatter (new template format)
        if ! grep -q "# /${cmd_name} Command" "$cmd_file" && ! grep -q "^---$" "$cmd_file"; then
            echo "${cmd_name}: Should have command header or YAML frontmatter"
            return 1
        fi

        # For files with YAML frontmatter, check new template sections
        if grep -q "^---$" "$cmd_file"; then
            # Check required sections for new template format
            assert_file_contains "$cmd_file" "## Usage" \
                "${cmd_name}: Should have Usage section"
            assert_file_contains "$cmd_file" "## Description" \
                "${cmd_name}: Should have Description section"
            assert_file_contains "$cmd_file" "## Expected Output" \
                "${cmd_name}: Should have Expected Output section"
        else
            # For files with old format, check traditional sections
            if grep -q "## Description" "$cmd_file"; then
                assert_file_contains "$cmd_file" "## Usage" \
                    "${cmd_name}: Should have Usage section"
            fi
        fi

        # Check for usage example or code blocks
        assert_file_contains "$cmd_file" "\`\`\`" \
            "${cmd_name}: Should have code block for usage"
    done
}

# Test specific command requirements
test_command_specifics() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"

    # Test /test command has generation section
    assert_file_contains "$commands_dir/test.md" "## Test Generation" \
        "/test command should have generation section"

    # Test /sync command mentions settings.json
    assert_file_contains "$commands_dir/sync.md" "settings.json" \
        "/sync command should mention settings.json"

    # Test /plan command has approval workflow
    assert_file_contains "$commands_dir/plan.md" "## Approval Workflow" \
        "/plan command should have approval workflow"

    # Test /prime command has output format
    assert_file_contains "$commands_dir/prime.md" "Output Format:" \
        "/prime command should have output format"
}

# Test agent specification requirements
test_agent_specifications() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"
    
    # Commands that must specify agents
    local agent_required_commands=("implement" "docs" "debug" "ship-it" "review" 
                                  "test" "prime" "fix-ci" "deps" "plan" 
                                  "commit" "branch" "pr" "push" "sync")
    
    for cmd in "${agent_required_commands[@]}"; do
        local cmd_file="$commands_dir/${cmd}.md"
        if [ -f "$cmd_file" ]; then
            # Check for agent mentions (at least one of the common agents)
            if ! grep -qE "backend-engineer|frontend-architect|test-engineer|security-auditor|tech-writer|code-reviewer|codebase-analyst|devops|platform-engineer|project-orchestrator|debugger|performance-engineer" "$cmd_file"; then
                echo "Warning: ${cmd}.md should specify appropriate agents"
            fi
        fi
    done
    
    # Security-critical commands must have security-auditor
    local security_commands=("commit" "push" "sync" "deps")
    for cmd in "${security_commands[@]}"; do
        local cmd_file="$commands_dir/${cmd}.md"
        if [ -f "$cmd_file" ]; then
            if ! grep -q "security-auditor" "$cmd_file"; then
                echo "Warning: ${cmd}.md (security-critical) should include security-auditor"
            fi
        fi
    done
}

# Test parallelization patterns
test_parallelization_patterns() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"
    
    # Commands that should leverage parallelization
    local parallel_commands=("implement" "docs" "ship-it" "review" "prime" 
                            "agent-audit" "command-audit" "fix-ci" "test")
    
    for cmd in "${parallel_commands[@]}"; do
        local cmd_file="$commands_dir/${cmd}.md"
        if [ -f "$cmd_file" ]; then
            # Check for parallel execution patterns
            if ! grep -qiE "parallel|simultaneous|concurrent|Phase.*Parallel|Parallel Wave" "$cmd_file"; then
                echo "Warning: ${cmd}.md should leverage parallel execution patterns"
            fi
        fi
    done
    
    # Check for sequential anti-patterns in commands that should parallelize
    for cmd in "${parallel_commands[@]}"; do
        local cmd_file="$commands_dir/${cmd}.md"
        if [ -f "$cmd_file" ]; then
            if grep -qE "Sequential Phase|sequential execution|one at a time" "$cmd_file"; then
                # Check if it also has parallel patterns (mixed approach is OK)
                if ! grep -qiE "parallel|simultaneous|concurrent" "$cmd_file"; then
                    echo "Warning: ${cmd}.md uses sequential-only patterns, consider parallelization"
                fi
            fi
        fi
    done
}

# Test YAML frontmatter compliance (COMMAND_TEMPLATE.md format)
test_frontmatter_compliance() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"
    local template_file="$ORIGINAL_DIR/docs/commands/COMMAND_TEMPLATE.md"
    local failures=0

    echo "  Validating command frontmatter against template..."

    for cmd_file in "$commands_dir"/*.md; do
        local cmd_name=$(basename "$cmd_file" .md)

        # Check if file has YAML frontmatter
        if ! grep -q "^---$" "$cmd_file"; then
            echo "    Warning: ${cmd_name}.md missing YAML frontmatter"
            continue  # Allow files without frontmatter for now (legacy format)
        fi

        # Extract YAML frontmatter content
        local yaml_content=$(sed -n '/^---$/,/^---$/p' "$cmd_file" | sed '1d;$d')
        
        # Check for required 'description' field
        if ! echo "$yaml_content" | grep -q "^description:"; then
            echo "    Error: ${cmd_name}.md missing required 'description' field"
            failures=$((failures + 1))
        else
            # Check description length (should be under 60 chars for autocomplete)
            local desc_length=$(echo "$yaml_content" | grep "^description:" | cut -d':' -f2- | sed 's/^[ \t]*//' | wc -c)
            if [ "$desc_length" -gt 60 ]; then
                echo "    Warning: ${cmd_name}.md description too long (${desc_length} > 60 chars)"
            fi
        fi

        # Check argument-hint format if present (should use [brackets])
        if echo "$yaml_content" | grep -q "^argument-hint:"; then
            if ! echo "$yaml_content" | grep -q "argument-hint:.*\[.*\]"; then
                echo "    Error: ${cmd_name}.md invalid argument-hint format (should use [brackets])"
                failures=$((failures + 1))
            fi
        fi

        # Validate YAML syntax (basic check)
        if ! echo "$yaml_content" | grep -q "^[a-zA-Z-]*:"; then
            echo "    Error: ${cmd_name}.md invalid YAML syntax"
            failures=$((failures + 1))
        fi
    done

    if [ $failures -gt 0 ]; then
        echo "    Failed: $failures commands have frontmatter compliance issues"
        return 1
    fi

    return 0
}

# Test command template format compliance
test_template_format_compliance() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"
    local template_file="$ORIGINAL_DIR/docs/commands/COMMAND_TEMPLATE.md"
    local failures=0

    echo "  Validating command format against COMMAND_TEMPLATE.md..."

    # Ensure template exists
    if [ ! -f "$template_file" ]; then
        echo "    Error: COMMAND_TEMPLATE.md not found at $template_file"
        return 1
    fi

    for cmd_file in "$commands_dir"/*.md; do
        local cmd_name=$(basename "$cmd_file" .md)

        # For commands with frontmatter, verify template compliance
        if grep -q "^---$" "$cmd_file"; then
            # Check for main command purpose section after frontmatter
            if ! sed -n '/^---$/,/^---$/!p' "$cmd_file" | grep -q "^# "; then
                echo "    Warning: ${cmd_name}.md should have main heading after frontmatter"
            fi

            # Check for required sections in new template format
            if ! grep -q "## Usage" "$cmd_file"; then
                echo "    Error: ${cmd_name}.md missing required Usage section"
                failures=$((failures + 1))
            fi

            if ! grep -q "## Description" "$cmd_file"; then
                echo "    Error: ${cmd_name}.md missing required Description section"
                failures=$((failures + 1))
            fi

            if ! grep -q "## Expected Output" "$cmd_file"; then
                echo "    Error: ${cmd_name}.md missing required Expected Output section"
                failures=$((failures + 1))
            fi

            # Check for optional Behavior section
            if grep -q "## Behavior" "$cmd_file"; then
                echo "    Info: ${cmd_name}.md includes optional Behavior section"
            fi

            # Check for proper use of $ARGUMENTS placeholder if argument-hint exists
            if grep -q "argument-hint:" "$cmd_file" && ! grep -q "\$ARGUMENTS" "$cmd_file"; then
                echo "    Warning: ${cmd_name}.md has argument-hint but no \$ARGUMENTS placeholder"
            fi
        fi
    done

    return 0
}

# Test command-audit specific functionality
test_command_audit_requirements() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"
    local audit_file="$commands_dir/command-audit.md"

    echo "  Testing command-audit specific requirements..."

    # Ensure command-audit exists
    if [ ! -f "$audit_file" ]; then
        echo "    Error: command-audit.md not found"
        return 1
    fi

    # Check that command-audit references the template
    if ! grep -q "COMMAND_TEMPLATE.md" "$audit_file"; then
        echo "    Error: command-audit should reference COMMAND_TEMPLATE.md"
        return 1
    fi

    # Check for frontmatter validation logic
    if ! grep -q "frontmatter\|YAML" "$audit_file"; then
        echo "    Error: command-audit should include frontmatter validation"
        return 1
    fi

    # Check for template compliance validation
    if ! grep -q "Template Compliance\|template compliance" "$audit_file"; then
        echo "    Error: command-audit should validate template compliance"
        return 1
    fi

    # Check for description field validation
    if ! grep -q "description.*field\|required.*description" "$audit_file"; then
        echo "    Error: command-audit should validate required description field"
        return 1
    fi

    return 0
}

# Test no missing documentation
test_documentation_completeness() {
    local commands_dir="$ORIGINAL_DIR/system-configs/.claude/commands"

    for cmd_file in "$commands_dir"/*.md; do
        local cmd_name=$(basename "$cmd_file" .md)

        # Check file is not empty
        if [ ! -s "$cmd_file" ]; then
            echo "Command file ${cmd_name}.md is empty"
            return 1
        fi

        # Check for either new template format compliance or legacy content sections
        if grep -q "^---$" "$cmd_file"; then
            # New template format - check required sections
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
        else
            # Legacy format - check for any main content section
            if ! grep -q "## Behavior\|## Workflow\|## Discovery Algorithm\|## Analysis Modes\|## Two-Mode Operation\|## SCOPE Framework\|## Smart Branch Creation\|## Validation Framework\|## Investigation Framework\|## Failure Pattern Library\|## Agent Orchestration Strategy\|## Configuration File\|## Command Execution Flow\|## File Structure\|## Context\|# Command Purpose\|## Expected Output\|## Usage\|## Description" "$cmd_file"; then
                echo "${cmd_name}: Should have a main content section"
                return 1
            fi
        fi
    done
}

# Run all tests
echo "Testing command file validation..."

test_all_commands_exist || exit 1
test_command_structure || exit 1
test_frontmatter_compliance || exit 1
test_template_format_compliance || exit 1
test_command_audit_requirements || exit 1
test_command_specifics || exit 1
test_agent_specifications || exit 1
test_parallelization_patterns || exit 1
test_documentation_completeness || exit 1

echo "All command file validation tests passed!"
