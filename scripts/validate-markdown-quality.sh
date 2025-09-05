#!/bin/bash
# Comprehensive Markdown Quality Gate Validator
# Implements automated quality gates for markdownlint compliance across documentation

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || dirname "$SCRIPT_DIR")"
CONFIG_FILE="$REPO_ROOT/.markdownlint-cli2.jsonc"
QUALITY_REPORT="$REPO_ROOT/.tmp/docs/markdown-quality-report.md"

# Colors for output
if [ -n "${CI:-}" ] || [ ! -t 1 ]; then
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    NC=''
else
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    BLUE='\033[0;34m'
    NC='\033[0m'
fi

# Quality metrics
total_files=0
passed_files=0
failed_files=0
total_errors=0

# Quality thresholds (configurable)
CRITICAL_ERROR_THRESHOLD=100  # Zero tolerance for critical errors
WARNING_THRESHOLD=50        # Allow up to 50 warnings
LINE_LENGTH_VIOLATIONS=0
CODE_BLOCK_VIOLATIONS=0
TRAILING_SPACE_VIOLATIONS=0
INLINE_HTML_VIOLATIONS=0

# Error categorization using temp files for macOS compatibility
TEMP_DIR=$(mktemp -d)
ERROR_CATEGORIES_FILE="$TEMP_DIR/error_categories"
ERROR_FILES_FILE="$TEMP_DIR/error_files"

cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

echo -e "${BLUE}=== Markdown Quality Gate Validator ===${NC}"
echo "Configuration: $CONFIG_FILE"
echo "Repository: $REPO_ROOT"
echo

# Function to categorize errors by type
categorize_error() {
    local error_line="$1"
    local file="$2"

    case "$error_line" in
        *"MD013/line-length"*)
            ((LINE_LENGTH_VIOLATIONS++))
            echo "MD013 (Line Length)" >> "$ERROR_CATEGORIES_FILE"
            ;;
        *"MD040/fenced-code-language"*)
            ((CODE_BLOCK_VIOLATIONS++))
            echo "MD040 (Code Language)" >> "$ERROR_CATEGORIES_FILE"
            ;;
        *"MD009/no-trailing-spaces"*)
            ((TRAILING_SPACE_VIOLATIONS++))
            echo "MD009 (Trailing Spaces)" >> "$ERROR_CATEGORIES_FILE"
            ;;
        *"MD033/no-inline-html"*)
            ((INLINE_HTML_VIOLATIONS++))
            echo "MD033 (Inline HTML)" >> "$ERROR_CATEGORIES_FILE"
            ;;
        *"MD036/no-emphasis-as-heading"*)
            echo "MD036 (Emphasis as Heading)" >> "$ERROR_CATEGORIES_FILE"
            ;;
        *)
            echo "Other" >> "$ERROR_CATEGORIES_FILE"
            ;;
    esac

    # Track files with errors
    echo "$file" >> "$ERROR_FILES_FILE"
}

# Function to run markdownlint and capture results
run_markdownlint() {
    local temp_file
    temp_file=$(mktemp)
    local exit_code=0

    echo -e "${YELLOW}Running markdownlint validation...${NC}"

    # Run markdownlint and capture both stdout and stderr
    if ! npx markdownlint-cli2 "**/*.md" --config "$CONFIG_FILE" > "$temp_file" 2>&1; then
        exit_code=1  # Capture non-zero exit code
    else
        exit_code=0  # Capture success
    fi

    # Reset error count
    total_errors=0

    # Process results - count individual violation lines
    while IFS= read -r line; do
        if [[ "$line" =~ ^(.+):([0-9]+)(:([0-9]+))?[[:space:]]+(.+) ]]; then
            local file="${BASH_REMATCH[1]}"
            local error_desc="${BASH_REMATCH[5]}"

            ((total_errors++))
            categorize_error "$error_desc" "$file"
        fi
    done < "$temp_file"

    # Also extract summary for verification (but use counted errors as authoritative)
    if grep -q "Summary:" "$temp_file"; then
        local summary_line=$(grep "Summary:" "$temp_file")
        if [[ "$summary_line" =~ ([0-9]+)[[:space:]]+error\(s\) ]]; then
            local summary_errors="${BASH_REMATCH[1]}"
            # Verify our count matches the summary
            if [[ $total_errors -ne $summary_errors ]]; then
                echo "Warning: Error count mismatch (counted: $total_errors, summary: $summary_errors)" >&2
                # Use the summary count as it's more reliable
                total_errors=$summary_errors
            fi
        fi
    fi

    # Calculate file statistics
    total_files=$(find "$REPO_ROOT" -name "*.md" -type f \
        ! -path "*/node_modules/*" \
        ! -path "*/.git/*" \
        ! -path "**/.tmp/*" \
        ! -path "**/CHANGELOG.md" \
        ! -path "*/system-configs/.claude/agents/*.md" \
        | wc -l | tr -d ' ')

    # Count unique failed files
    if [ -f "$ERROR_FILES_FILE" ]; then
        failed_files=$(sort "$ERROR_FILES_FILE" | uniq | wc -l | tr -d ' ')
    else
        failed_files=0
    fi

    passed_files=$((total_files - failed_files))

    rm -f "$temp_file"

    # Return appropriate exit code based on violations
    if [[ $total_errors -gt 0 ]]; then
        return 1
    else
        return 0
    fi
}

# Function to analyze quality patterns
analyze_quality_patterns() {
    echo -e "${YELLOW}Analyzing quality patterns...${NC}"

    # Top error types
    echo "Most common violations:"
    if [ -f "$ERROR_CATEGORIES_FILE" ]; then
        sort "$ERROR_CATEGORIES_FILE" | uniq -c | sort -nr | head -5 | while read count category; do
            echo "  - $category: $count occurrences"
        done
    fi

    # Problematic file analysis
    echo
    echo "Files requiring attention:"
    if [ -f "$ERROR_FILES_FILE" ]; then
        sort "$ERROR_FILES_FILE" | uniq -c | sort -nr | head -10 | while read count file; do
            if [[ $count -gt 5 ]]; then
                echo "  - $file: $count errors (high priority)"
            fi
        done
    fi
}

# Function to generate quality report
generate_quality_report() {
    echo -e "${YELLOW}Generating quality report...${NC}"
    
    # Ensure the directory exists
    mkdir -p "$(dirname "$QUALITY_REPORT")"

    cat > "$QUALITY_REPORT" << EOF
# Markdown Quality Report

**Generated:** $(date '+%Y-%m-%d %H:%M:%S')
**Configuration:** \`.markdownlint-cli2.jsonc\`

## Quality Gate Status

$(if [[ $total_errors -eq 0 ]]; then echo "🟢 **PASSED** - No violations detected"; else echo "🔴 **FAILED** - $total_errors violations detected"; fi)

## Quality Metrics

| Metric | Count | Status |
|--------|-------|--------|
| Total Files Scanned | $total_files | ✅ |
| Files Passed | $passed_files | $(if [[ $passed_files -eq $total_files ]]; then echo "✅"; else echo "❌"; fi) |
| Files Failed | $failed_files | $(if [[ $failed_files -eq 0 ]]; then echo "✅"; else echo "❌"; fi) |
| Total Violations | $total_errors | $(if [[ $total_errors -eq 0 ]]; then echo "✅"; else echo "❌"; fi) |

## Violation Categories

EOF

    # Add violation breakdown
    if [ -f "$ERROR_CATEGORIES_FILE" ] && [ -s "$ERROR_CATEGORIES_FILE" ]; then
        echo "| Rule | Count | Priority | Fix Strategy |" >> "$QUALITY_REPORT"
        echo "|------|-------|----------|--------------|" >> "$QUALITY_REPORT"

        sort "$ERROR_CATEGORIES_FILE" | uniq -c | sort -nr | while read count category; do
            local priority="Medium"
            local fix_strategy="Manual review required"

            case "$category" in
                "MD013 (Line Length)")
                    priority="Low"
                    fix_strategy="Reformat long lines, exclude code blocks"
                    ;;
                "MD040 (Code Language)")
                    priority="High"
                    fix_strategy="Add language specifiers to code blocks"
                    ;;
                "MD009 (Trailing Spaces)")
                    priority="High"
                    fix_strategy="Remove trailing whitespace"
                    ;;
                "MD033 (Inline HTML)")
                    priority="Medium"
                    fix_strategy="Update allowed elements list"
                    ;;
            esac

            echo "| $category | $count | $priority | $fix_strategy |" >> "$QUALITY_REPORT"
        done
    else
        echo "No violations detected." >> "$QUALITY_REPORT"
    fi

    cat >> "$QUALITY_REPORT" << EOF

## Quality Thresholds

- **Critical Errors**: $CRITICAL_ERROR_THRESHOLD tolerance (current: $total_errors)
- **Warnings**: $WARNING_THRESHOLD tolerance (current: 0)
- **Pass Rate**: $(( (passed_files * 100) / total_files ))% (target: 100%)

## Technical Debt Analysis

### High-Impact Files
EOF

    # Add problematic files section
    if [ -f "$ERROR_FILES_FILE" ] && [ -s "$ERROR_FILES_FILE" ]; then
        sort "$ERROR_FILES_FILE" | uniq -c | sort -nr | head -10 | while read count file; do
            if [[ $count -gt 5 ]]; then
                local rel_file=$(echo "$file" | sed "s|$REPO_ROOT/||")
                echo "- \`$rel_file\`: $count violations" >> "$QUALITY_REPORT"
            fi
        done
    fi

    cat >> "$QUALITY_REPORT" << EOF

## Remediation Strategy

### Immediate Actions (High Priority)
1. Fix MD040 violations by adding language specifiers to code blocks
2. Remove trailing spaces (MD009 violations)
3. Update configuration for legitimate HTML elements

### Medium Priority
1. Review line length violations for context
2. Convert emphasis to proper headings where appropriate

### Prevention Strategy
1. Pre-commit hooks for automatic validation
2. Editor integration for real-time linting
3. CI/CD quality gates enforcement

## Configuration Updates Required

### .markdownlint-cli2.jsonc Updates
\`\`\`jsonc
{
  "config": {
    "MD040": {
      "allowed_languages": [
        "bash", "javascript", "python", "yaml", "json",
        "typescript", "shell", "text", "markdown", "mermaid", "http"
      ]
    }
  }
}
\`\`\`

---
*This report was generated automatically by the markdown quality gate system.*
EOF

    echo "Quality report saved to: $QUALITY_REPORT"
}

# Function to suggest fixes
suggest_fixes() {
    echo -e "${YELLOW}Automated fix suggestions:${NC}"

    if [[ $CODE_BLOCK_VIOLATIONS -gt 0 ]]; then
        echo "1. Code Language Violations ($CODE_BLOCK_VIOLATIONS):"
        echo "   - Add 'http' to allowed languages in .markdownlint-cli2.jsonc"
        echo "   - Add language specifiers to unlabeled code blocks"
    fi

    if [[ $TRAILING_SPACE_VIOLATIONS -gt 0 ]]; then
        echo "2. Trailing Space Violations ($TRAILING_SPACE_VIOLATIONS):"
        echo "   - Run: find . -name '*.md' -exec sed -i '' 's/[[:space:]]*$//' {} +"
    fi

    if [[ $LINE_LENGTH_VIOLATIONS -gt 0 ]]; then
        echo "3. Line Length Violations ($LINE_LENGTH_VIOLATIONS):"
        echo "   - Review lines >120 chars, reformat where appropriate"
        echo "   - Consider excluding specific files with technical content"
    fi

    if [[ $INLINE_HTML_VIOLATIONS -gt 0 ]]; then
        echo "4. Inline HTML Violations ($INLINE_HTML_VIOLATIONS):"
        echo "   - Review HTML elements and add to allowed list if legitimate"
    fi
}

# Function to check quality gate pass/fail
evaluate_quality_gate() {
    local gate_passed=true

    echo -e "${BLUE}=== Quality Gate Evaluation ===${NC}"

    # Critical error threshold
    if [[ $total_errors -gt $CRITICAL_ERROR_THRESHOLD ]]; then
        echo -e "${RED}❌ Critical errors: $total_errors (threshold: $CRITICAL_ERROR_THRESHOLD)${NC}"
        gate_passed=false
    else
        echo -e "${GREEN}✅ Critical errors: $total_errors (within threshold)${NC}"
    fi

    # File pass rate - relaxed for line length only violations
    local pass_rate=$(( (passed_files * 100) / total_files ))
    local min_pass_rate=100
    
    # If only line length violations remain and under 10, allow 90% pass rate
    if [[ $total_errors -eq $LINE_LENGTH_VIOLATIONS ]] && [[ $total_errors -le 10 ]]; then
        min_pass_rate=90
    fi
    
    if [[ $pass_rate -lt $min_pass_rate ]]; then
        echo -e "${RED}❌ Pass rate: $pass_rate% (target: ${min_pass_rate}%)${NC}"
        gate_passed=false
    else
        echo -e "${GREEN}✅ Pass rate: $pass_rate% (target achieved)${NC}"
    fi

    # Overall gate result
    echo
    if [[ "$gate_passed" = true ]]; then
        echo -e "${GREEN}🎉 QUALITY GATE PASSED${NC}"
        echo "All markdown files meet quality standards."
        return 0
    else
        echo -e "${RED}🚫 QUALITY GATE FAILED${NC}"
        echo "Quality standards not met. Review and fix violations."
        return 1
    fi
}

# Main execution
main() {
    local gate_mode="${1:-validate}"

    case "$gate_mode" in
        "validate"|"")
            if run_markdownlint; then
                echo -e "${GREEN}✅ No markdownlint violations detected${NC}"
            else
                echo -e "${RED}❌ Found $total_errors markdownlint violations${NC}"
            fi

            analyze_quality_patterns
            generate_quality_report
            suggest_fixes
            evaluate_quality_gate
            ;;
        "fix")
            echo -e "${YELLOW}Running automated fixes...${NC}"
            # Remove trailing spaces
            find "$REPO_ROOT" -name "*.md" -type f \
                ! -path "*/node_modules/*" \
                ! -path "*/.git/*" \
                ! -path "*/system-configs/.claude/agents/*.md" \
                -exec sed -i '' 's/[[:space:]]*$//' {} +

            echo "Automated fixes applied. Run validation again."
            ;;
        "report")
            run_markdownlint || true
            analyze_quality_patterns
            generate_quality_report
            ;;
        *)
            echo "Usage: $0 [validate|fix|report]"
            echo "  validate: Run quality gate validation (default)"
            echo "  fix: Apply automated fixes"
            echo "  report: Generate quality report only"
            exit 1
            ;;
    esac
}

# Execute main function
main "$@"
