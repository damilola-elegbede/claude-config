#!/bin/bash
# Validation Framework - Core validation functions
set -euo pipefail

REPO_ROOT=$(git rev-parse --show-toplevel)
VALIDATION_CACHE_DIR="$REPO_ROOT/.validation-cache"
METRICS_DIR="$REPO_ROOT/.validation-metrics"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Ensure directories exist
mkdir -p "$VALIDATION_CACHE_DIR" "$METRICS_DIR"

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Validation runner function
run_validation() {
    local validation_type="$1"
    local description="$2"
    local start_time=$(date +%s)
    local exit_code=0
    local files_processed=0
    
    log_info "Running $description..."
    
    case "$validation_type" in
        "yaml")
            files_processed=$(run_yaml_validation) || exit_code=$?
            ;;
        "format")
            files_processed=$(run_format_validation) || exit_code=$?
            ;;
        "security")
            files_processed=$(run_security_validation) || exit_code=$?
            ;;
        "docs")
            files_processed=$(run_docs_validation) || exit_code=$?
            ;;
        *)
            log_error "Unknown validation type: $validation_type"
            exit_code=1
            ;;
    esac
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    # Record metrics
    if command -v python3 >/dev/null 2>&1; then
        python3 -c "
import json
import sys
from datetime import datetime

metrics = {
    'timestamp': datetime.utcnow().isoformat() + 'Z',
    'validation_type': '$validation_type',
    'duration_seconds': $duration,
    'exit_code': $exit_code,
    'files_processed': $files_processed,
    'success': $exit_code == 0
}

with open('$METRICS_DIR/validation-metrics.jsonl', 'a') as f:
    f.write(json.dumps(metrics) + '\n')
"
    fi
    
    if [[ $exit_code -eq 0 ]]; then
        log_success "$description completed ($files_processed files, ${duration}s)"
        VALIDATION_RESULTS+=("$validation_type:SUCCESS:$duration")
    else
        log_error "$description failed ($files_processed files, ${duration}s)"
        VALIDATION_RESULTS+=("$validation_type:FAILED:$duration")
    fi
    
    return $exit_code
}

# YAML validation implementation
run_yaml_validation() {
    local files_processed=0
    local validation_failed=false
    
    # Get staged files or all agent files if not in git hook context
    local files_to_check
    if git diff --cached --name-only >/dev/null 2>&1; then
        files_to_check=$(git diff --cached --name-only --diff-filter=ACM | grep "^\.claude/agents/.*\.md$" || true)
    else
        files_to_check=$(find .claude/agents -name "*.md" -type f || true)
    fi
    
    if [[ -z "$files_to_check" ]]; then
        echo "0"
        return 0
    fi
    
    while IFS= read -r file; do
        if [[ -f "$file" ]]; then
            if ! validate_yaml_frontmatter "$file"; then
                validation_failed=true
            fi
            ((files_processed++))
        fi
    done <<< "$files_to_check"
    
    echo "$files_processed"
    [[ "$validation_failed" == "false" ]] || return 1
}

# YAML front-matter validation
validate_yaml_frontmatter() {
    local file="$1"
    local temp_yaml="/tmp/frontmatter_$$.yml"
    local line_num=0
    local in_frontmatter=false
    local frontmatter_start=false
    
    # Extract YAML front-matter
    while IFS= read -r line; do
        ((line_num++))
        
        if [[ $line_num -eq 1 && "$line" == "---" ]]; then
            frontmatter_start=true
            in_frontmatter=true
            continue
        elif [[ "$in_frontmatter" == "true" && "$line" == "---" ]]; then
            break
        elif [[ "$in_frontmatter" == "true" ]]; then
            echo "$line" >> "$temp_yaml"
        fi
    done < "$file"
    
    if [[ "$frontmatter_start" != "true" ]]; then
        log_error "No YAML front-matter found in $file"
        return 1
    fi
    
    # Validate YAML syntax
    if command -v yq >/dev/null 2>&1; then
        if ! yq eval '.' "$temp_yaml" >/dev/null 2>&1; then
            log_error "Invalid YAML syntax in $file"
            yq eval '.' "$temp_yaml" 2>&1 | head -5
            rm -f "$temp_yaml"
            return 1
        fi
    elif command -v python3 >/dev/null 2>&1; then
        if ! python3 -c "
import yaml
import sys
try:
    with open('$temp_yaml') as f:
        yaml.safe_load(f)
except yaml.YAMLError as e:
    print(f'YAML Error: {e}')
    sys.exit(1)
" >/dev/null 2>&1; then
            log_error "Invalid YAML syntax in $file"
            rm -f "$temp_yaml"
            return 1
        fi
    else
        log_warning "No YAML validator found (yq or python3+pyyaml)"
    fi
    
    # Validate required fields
    local required_fields=("name" "description" "tools" "category")
    for field in "${required_fields[@]}"; do
        if command -v yq >/dev/null 2>&1; then
            if ! yq eval "has(\"$field\")" "$temp_yaml" | grep -q "true"; then
                log_error "Missing required field '$field' in $file"
                rm -f "$temp_yaml"
                return 1
            fi
        fi
    done
    
    rm -f "$temp_yaml"
    return 0
}

# Format validation implementation
run_format_validation() {
    local files_processed=0
    local validation_failed=false
    
    # Check shell scripts
    find scripts -name "*.sh" -type f | while read -r script; do
        if command -v shellcheck >/dev/null 2>&1; then
            if ! shellcheck "$script" >/dev/null 2>&1; then
                log_error "ShellCheck failed for $script"
                validation_failed=true
            fi
        fi
        ((files_processed++))
    done
    
    # Check Dockerfile syntax
    if [[ -f "Dockerfile.validation" ]] && command -v hadolint >/dev/null 2>&1; then
        if ! hadolint Dockerfile.validation >/dev/null 2>&1; then
            log_error "Hadolint failed for Dockerfile.validation"
            validation_failed=true
        fi
        ((files_processed++))
    fi
    
    echo "$files_processed"
    [[ "$validation_failed" == "false" ]] || return 1
}

# Security validation implementation
run_security_validation() {
    local files_processed=0
    local validation_failed=false
    
    # Check for sensitive information in staged files
    local staged_files
    if git diff --cached --name-only >/dev/null 2>&1; then
        staged_files=$(git diff --cached --name-only --diff-filter=ACM || true)
    else
        staged_files=$(find . -type f -name "*.md" -o -name "*.sh" -o -name "*.yml" || true)
    fi
    
    if [[ -n "$staged_files" ]]; then
        while IFS= read -r file; do
            if [[ -f "$file" ]]; then
                # Check for common secrets patterns
                local secrets_found=false
                
                # API keys, tokens, passwords (exclude validation patterns and examples)
                if grep -i -E "(ap_i[_-]?k_ey|tok_en|pass_word|sec_ret)" "$file" | grep -E "[:=]\s*['\"][^'\"]{20,}" >/dev/null 2>&1; then
                    log_warning "Potential secret found in $file"
                    secrets_found=true
                fi
                
                # AWS keys
                if grep -E "AKIA[0-9A-Z]{16}" "$file" >/dev/null 2>&1; then
                    log_error "AWS Access Key found in $file"
                    validation_failed=true
                fi
                
                # Private keys
                if grep -E "-----BEGIN [A-Z]+ PRIVATE KEY-----" "$file" >/dev/null 2>&1; then
                    log_error "Private key found in $file"
                    validation_failed=true
                fi
                
                ((files_processed++))
            fi
        done <<< "$staged_files"
    fi
    
    echo "$files_processed"
    [[ "$validation_failed" == "false" ]] || return 1
}

# Documentation validation implementation
run_docs_validation() {
    local files_processed=0
    local validation_failed=false
    
    # Check for broken internal links
    find docs -name "*.md" -type f | while read -r doc; do
        # Extract markdown links
        grep -o '\[.*\](\..*\.md)' "$doc" 2>/dev/null | while read -r link; do
            local file_path=$(echo "$link" | sed 's/.*](\(.*\))/\1/')
            local full_path="$(dirname "$doc")/$file_path"
            
            if [[ ! -f "$full_path" ]]; then
                log_error "Broken link in $doc: $file_path"
                validation_failed=true
            fi
        done
        ((files_processed++))
    done
    
    echo "$files_processed"
    [[ "$validation_failed" == "false" ]] || return 1
}

# Print validation summary
print_validation_summary() {
    local results=("$@")
    local total_validations=${#results[@]}
    local successful_validations=0
    local total_duration=0
    
    echo
    log_info "Validation Summary:"
    echo "===================="
    
    for result in "${results[@]}"; do
        IFS=':' read -r validation_type status duration <<< "$result"
        total_duration=$((total_duration + duration))
        
        if [[ "$status" == "SUCCESS" ]]; then
            log_success "$validation_type: passed (${duration}s)"
            ((successful_validations++))
        else
            log_error "$validation_type: failed (${duration}s)"
        fi
    done
    
    echo "===================="
    
    if [[ $successful_validations -eq $total_validations ]]; then
        log_success "All $total_validations validations passed in ${total_duration}s"
    else
        local failed_validations=$((total_validations - successful_validations))
        log_error "$failed_validations of $total_validations validations failed in ${total_duration}s"
    fi
}

# Cache management
clear_validation_cache() {
    rm -rf "$VALIDATION_CACHE_DIR"
    mkdir -p "$VALIDATION_CACHE_DIR"
    log_info "Validation cache cleared"
}

# Performance optimization: skip validation if files haven't changed
should_skip_validation() {
    local validation_type="$1"
    local cache_file="$VALIDATION_CACHE_DIR/${validation_type}_cache"
    
    if [[ ! -f "$cache_file" ]]; then
        return 1  # Don't skip, no cache exists
    fi
    
    # Check if any relevant files are newer than cache
    local relevant_files
    case "$validation_type" in
        "yaml")
            relevant_files=$(find .claude/agents -name "*.md" -newer "$cache_file" 2>/dev/null || true)
            ;;
        "format")
            relevant_files=$(find scripts -name "*.sh" -newer "$cache_file" 2>/dev/null || true)
            ;;
        *)
            return 1  # Don't skip unknown validation types
            ;;
    esac
    
    [[ -z "$relevant_files" ]]  # Skip if no files are newer
}

# Update validation cache
update_validation_cache() {
    local validation_type="$1"
    local cache_file="$VALIDATION_CACHE_DIR/${validation_type}_cache"
    touch "$cache_file"
}

# Export all functions for use in other scripts
export -f log_info log_success log_warning log_error
export -f run_validation validate_yaml_frontmatter
export -f run_yaml_validation run_format_validation run_security_validation run_docs_validation
export -f print_validation_summary clear_validation_cache should_skip_validation update_validation_cache