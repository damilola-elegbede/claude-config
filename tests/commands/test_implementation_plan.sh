#!/bin/bash
# Test for /implementation-plan command

# Source test utilities
source "$(dirname "$0")/../utils.sh"

# Test implementation-plan command file exists
test_implementation_plan_file_exists() {
    assert_file_exists "$ORIGINAL_DIR/system-configs/.claude/commands/implementation-plan.md" \
        "Implementation-plan command file should exist"
}

# Test implementation-plan command structure
test_implementation_plan_structure() {
    local plan_file="$ORIGINAL_DIR/system-configs/.claude/commands/implementation-plan.md"

    # Check for YAML frontmatter
    assert_file_contains "$plan_file" "^---" \
        "Should have YAML frontmatter start"

    assert_file_contains "$plan_file" "description:" \
        "Should have description in frontmatter"

    # Check required sections (new template format)
    assert_file_contains "$plan_file" "## Usage" \
        "Should have Usage section"

    assert_file_contains "$plan_file" "## Description" \
        "Should have Description section"

    assert_file_contains "$plan_file" "## Expected Output" \
        "Should have Expected Output section"
}

# Test implementation-plan command content
test_implementation_plan_content() {
    local plan_file="$ORIGINAL_DIR/system-configs/.claude/commands/implementation-plan.md"

    # Check for key behavior descriptions
    assert_file_contains "$plan_file" "Analysis Phase" \
        "Should have Analysis Phase section"

    assert_file_contains "$plan_file" "Plan Structure" \
        "Should have Plan Structure section"

    assert_file_contains "$plan_file" "without execution" \
        "Should emphasize planning without execution"

    # Check for flag documentation
    assert_file_contains "$plan_file" "no-execute" \
        "Should document no-execute flag"

    assert_file_contains "$plan_file" "verbose" \
        "Should document verbose flag"

    assert_file_contains "$plan_file" "minimal" \
        "Should document minimal flag"
}

# Test implementation-plan command functionality descriptions
test_implementation_plan_functionality() {
    local plan_file="$ORIGINAL_DIR/system-configs/.claude/commands/implementation-plan.md"

    # Check for comprehensive planning features
    assert_file_contains "$plan_file" "File Modification List" \
        "Should include file modification tracking"

    assert_file_contains "$plan_file" "Task Grouping" \
        "Should include task organization"

    assert_file_contains "$plan_file" "Execution Order" \
        "Should include execution sequencing"

    assert_file_contains "$plan_file" "Edge Cases" \
        "Should include edge case consideration"

    assert_file_contains "$plan_file" "Verification Plan" \
        "Should include verification steps"

    # Check for planning methodology
    assert_file_contains "$plan_file" "Code Analysis" \
        "Should include code analysis methodology"

    assert_file_contains "$plan_file" "Pattern Recognition" \
        "Should include pattern recognition"

    assert_file_contains "$plan_file" "Risk Assessment" \
        "Should include risk assessment"
}

# Test implementation-plan command output format
test_implementation_plan_output_format() {
    local plan_file="$ORIGINAL_DIR/system-configs/.claude/commands/implementation-plan.md"

    # Check for structured output format
    assert_file_contains "$plan_file" "Overview" \
        "Should include overview section in output"

    assert_file_contains "$plan_file" "File Modifications" \
        "Should include file modifications section"

    assert_file_contains "$plan_file" "Task Groups" \
        "Should include task groups section"

    assert_file_contains "$plan_file" "Execution Order" \
        "Should include execution order section"

    assert_file_contains "$plan_file" "Verification Steps" \
        "Should include verification steps section"

    # Check for markdown formatting examples
    assert_file_contains "$plan_file" "\`\`\`markdown" \
        "Should include markdown format examples"
}

# Test implementation-plan use cases
test_implementation_plan_use_cases() {
    local plan_file="$ORIGINAL_DIR/system-configs/.claude/commands/implementation-plan.md"

    # Check for documented use cases
    assert_file_contains "$plan_file" "Bug Fix Planning" \
        "Should include bug fix planning use case"

    assert_file_contains "$plan_file" "Feature Implementation" \
        "Should include feature implementation use case"

    assert_file_contains "$plan_file" "Refactoring Strategy" \
        "Should include refactoring use case"

    assert_file_contains "$plan_file" "Performance Optimization" \
        "Should include performance optimization use case"

    # Check for example usage
    assert_file_contains "$plan_file" "/implementation-plan" \
        "Should include command usage examples"
}

# Run all tests
echo "Testing /implementation-plan command..."

test_implementation_plan_file_exists || exit 1
test_implementation_plan_structure || exit 1
test_implementation_plan_content || exit 1
test_implementation_plan_functionality || exit 1
test_implementation_plan_output_format || exit 1
test_implementation_plan_use_cases || exit 1

echo "All /implementation-plan command tests passed!"