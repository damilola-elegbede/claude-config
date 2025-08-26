#!/bin/bash

# ElevenLabs MCP Validation Script
# Validates ElevenLabs MCP server configuration and dependencies
# Ensures proper setup before attempting to use the MCP server
#
# This script implements validation requirements from:
# - REQ-MCP-001: MCP Server Integration and Configuration
# - REQ-ENV-001: Environment Variable Management
# - REQ-SEC-002: Secure API Key Handling
#
# Configuration location:
# - MCP servers are now configured in .mcp.json (repository root)
# - Settings.json contains only Claude-specific settings (hooks, theme, etc.)
#
# Usage:
#   ./scripts/validate-elevenlabs-mcp.sh
#   ./scripts/validate-elevenlabs-mcp.sh --help
#   ELEVENLABS_API_KEY=your_key ./scripts/validate-elevenlabs-mcp.sh

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG_FILE="$PROJECT_ROOT/.mcp.json"
SETTINGS_FILE="$PROJECT_ROOT/system-configs/.claude/settings.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
total_checks=0
failed_checks=0
warnings=0

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
    ((total_checks++)) || true
}

log_error() {
    echo -e "${RED}✗${NC} $1"
    ((total_checks++)) || true
    ((failed_checks++)) || true
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((warnings++)) || true
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Validate JSON syntax
validate_json() {
    local file="$1"
    local name="$2"
    
    if ! python3 -m json.tool "$file" >/dev/null 2>&1; then
        log_error "$name: Invalid JSON syntax"
        return 1
    fi
    
    log_success "$name: Valid JSON syntax"
    return 0
}

# Check configuration file structure
validate_config_structure() {
    local config="$1"
    
    # Check if mcpServers exists
    if ! python3 -c "import json; data=json.load(open('$config')); assert 'mcpServers' in data" 2>/dev/null; then
        log_error "Configuration: Missing 'mcpServers' key"
        return 1
    fi
    
    # Check if elevenlabs server config exists
    if ! python3 -c "import json; data=json.load(open('$config')); assert 'elevenlabs' in data['mcpServers']" 2>/dev/null; then
        log_error "Configuration: Missing 'elevenlabs' server configuration"
        return 1
    fi
    
    # Check required fields
    local required_fields=("command" "args" "env")
    for field in "${required_fields[@]}"; do
        if ! python3 -c "import json; data=json.load(open('$config')); assert '$field' in data['mcpServers']['elevenlabs']" 2>/dev/null; then
            log_error "Configuration: Missing required field '$field' in elevenlabs config"
            return 1
        fi
    done
    
    # Check command is npx or uvx
    local command=$(python3 -c "import json; data=json.load(open('$config')); print(data['mcpServers']['elevenlabs']['command'])" 2>/dev/null)
    if [[ "$command" != "npx" && "$command" != "uvx" ]]; then
        log_error "Configuration: Command should be 'npx' or 'uvx', found '$command'"
        return 1
    fi
    
    # Check args contains either elevenlabs-streaming-mcp-server or elevenlabs-mcp
    local args_check=$(python3 -c "
import json
data = json.load(open('$config'))
args = data['mcpServers']['elevenlabs']['args']
args_str = ' '.join(args) if isinstance(args, list) else str(args)
has_streaming = 'elevenlabs-streaming-mcp-server' in args_str
has_mcp = 'elevenlabs-mcp' in args_str
print('true' if has_streaming or has_mcp else 'false')
" 2>/dev/null)
    
    if [[ "$args_check" != "true" ]]; then
        log_error "Configuration: Args should contain either 'elevenlabs-streaming-mcp-server' or 'elevenlabs-mcp'"
        return 1
    fi
    
    # Check ELEVENLABS_API_KEY environment variable is configured
    if ! python3 -c "import json; data=json.load(open('$config')); assert 'ELEVENLABS_API_KEY' in data['mcpServers']['elevenlabs']['env']" 2>/dev/null; then
        log_error "Configuration: Missing ELEVENLABS_API_KEY in env section"
        return 1
    fi
    
    log_success "Configuration: All required fields present and valid"
    return 0
}

# Test MCP server startup (without API calls)
test_mcp_startup() {
    log_info "Testing MCP server startup (dry run)..."
    
    # Check which command is configured
    local configured_command=$(python3 -c "import json; data=json.load(open('$CONFIG_FILE')); print(data['mcpServers']['elevenlabs']['command'])" 2>/dev/null)
    
    # For npx packages, we just need to verify the configured command is available
    # The package will be downloaded automatically when Claude Desktop starts
    if command_exists "$configured_command"; then
        log_success "MCP server: $configured_command available, package will be downloaded on first use"
        
        if [[ "$configured_command" == "npx" ]]; then
            log_info "Note: ElevenLabs MCP package will be installed automatically by Claude Desktop"
        elif [[ "$configured_command" == "uvx" ]]; then
            log_info "Note: ElevenLabs MCP package will be managed by uvx (Python-based tool runner)"
        fi
        return 0
    else
        log_error "MCP server: $configured_command not available, required for running the server"
        if [[ "$configured_command" == "npx" ]]; then
            log_info "Install with: brew install node"
        elif [[ "$configured_command" == "uvx" ]]; then
            log_info "Install with: pip install uv"
        fi
        return 1
    fi
}

# Main validation function
main() {
    echo -e "${BLUE}=== ElevenLabs MCP Validation ===${NC}"
    echo
    
    # 1. Check Python availability
    log_info "Checking Python availability..."
    if command_exists python3; then
        local python_version=$(python3 --version 2>&1 | cut -d' ' -f2)
        log_success "Python available: $python_version"
    else
        log_error "Python 3 not found in PATH"
    fi
    
    # 2. Check package manager availability (npx/uvx)
    log_info "Checking package manager availability..."
    
    # Check npx
    if command_exists npx; then
        local npx_path=$(which npx)
        log_success "npx available at: $npx_path"
        
        # Check Node.js version
        local node_version=$(node --version 2>/dev/null || echo "unknown")
        log_success "Node.js version: $node_version"
    else
        log_warning "npx not found in PATH"
        log_info "Install with: brew install node"
    fi
    
    # Check uvx
    if command_exists uvx; then
        local uvx_path=$(which uvx)
        log_success "uvx available at: $uvx_path"
        
        # Check uv version
        local uv_version=$(uv --version 2>/dev/null || echo "unknown")
        log_success "uv version: $uv_version"
    else
        log_warning "uvx not found in PATH"
        log_info "Install with: pip install uv"
    fi
    
    # At least one package manager should be available
    if ! command_exists npx && ! command_exists uvx; then
        log_error "Neither npx nor uvx found - at least one is required"
    fi
    
    # 3. Check ELEVENLABS_API_KEY environment variable
    log_info "Checking ELEVENLABS_API_KEY environment variable..."
    if [[ -n "${ELEVENLABS_API_KEY:-}" ]]; then
        # Validate API key format (basic check)
        if [[ ${#ELEVENLABS_API_KEY} -ge 32 ]]; then
            log_success "ELEVENLABS_API_KEY: Present and appears valid (${#ELEVENLABS_API_KEY} characters)"
        else
            log_warning "ELEVENLABS_API_KEY: Present but may be too short (${#ELEVENLABS_API_KEY} characters)"
        fi
    else
        log_error "ELEVENLABS_API_KEY environment variable not set"
        log_info "Set with: export ELEVENLABS_API_KEY=your_api_key_here"
    fi
    
    # 4. Validate configuration files
    log_info "Validating configuration files..."
    
    if [[ -f "$CONFIG_FILE" ]]; then
        log_success "Configuration file exists: $CONFIG_FILE"
        
        # Validate JSON syntax
        validate_json "$CONFIG_FILE" "ElevenLabs MCP config"
        
        # Validate structure
        validate_config_structure "$CONFIG_FILE"
    else
        log_error "Configuration file not found: $CONFIG_FILE"
    fi
    
    # 5. Check settings.json integration
    if [[ -f "$SETTINGS_FILE" ]]; then
        log_success "Settings file exists: $SETTINGS_FILE"
        
        # Validate JSON syntax
        validate_json "$SETTINGS_FILE" "Settings file"
        
        # Check if MCP servers are configured
        if python3 -c "import json; data=json.load(open('$SETTINGS_FILE')); assert 'mcpServers' in data" 2>/dev/null; then
            log_success "Settings: MCP servers section found"
        else
            log_warning "Settings: No mcpServers section found (may be using external config)"
        fi
    else
        log_warning "Settings file not found: $SETTINGS_FILE"
    fi
    
    # 6. Test MCP server availability (if dependencies are met)
    if [[ $failed_checks -eq 0 ]]; then
        test_mcp_startup
    else
        log_warning "Skipping MCP server test due to previous failures"
    fi
    
    # 7. Summary
    echo
    echo -e "${BLUE}=== Validation Summary ===${NC}"
    echo "Total checks: $total_checks"
    echo "Failed checks: $failed_checks"
    echo "Warnings: $warnings"
    echo
    
    if [[ $failed_checks -eq 0 ]]; then
        echo -e "${GREEN}✓ ElevenLabs MCP validation passed!${NC}"
        if [[ $warnings -gt 0 ]]; then
            echo -e "${YELLOW}Note: $warnings warning(s) found - review above${NC}"
        fi
        exit 0
    else
        echo -e "${RED}✗ ElevenLabs MCP validation failed with $failed_checks error(s)${NC}"
        echo
        echo "Common fixes:"
        echo "1. Install package manager: brew install node (for npx) or pip install uv (for uvx)"
        echo "2. Set API key: export ELEVENLABS_API_KEY=your_api_key_here"
        echo "3. Verify configuration files are present and valid JSON"
        echo "4. Ensure command is 'npx' or 'uvx' and args contain ElevenLabs MCP package name"
        echo "5. Run script again after addressing issues"
        exit 1
    fi
}

# Help function
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "ElevenLabs MCP Validation Script"
    echo "Validates ElevenLabs MCP server configuration and dependencies"
    echo
    echo "Options:"
    echo "  -h, --help    Show this help message"
    echo "  -v, --verbose Enable verbose output"
    echo
    echo "Environment Variables:"
    echo "  ELEVENLABS_API_KEY  Your ElevenLabs API key (required)"
    echo
    echo "Exit Codes:"
    echo "  0  All validations passed"
    echo "  1  One or more validations failed"
    echo
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--verbose)
            set -x
            shift
            ;;
        *)
            echo "Unknown option: $1" >&2
            show_help >&2
            exit 1
            ;;
    esac
done

# Run main function
main "$@"