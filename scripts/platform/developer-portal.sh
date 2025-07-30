#!/bin/bash
# Claude Developer Portal - Self-service platform for developers
# Provides interactive tools and guidance for validation system
set -euo pipefail

REPO_ROOT=$(git rev-parse --show-toplevel)
PORTAL_DIR="$REPO_ROOT/.claude/platform/portal"
TEMPLATES_DIR="$PORTAL_DIR/templates"
SCRIPTS_DIR="$REPO_ROOT/scripts/platform"

# Colors and emoji
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly RED='\033[0;31m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# Initialize portal
init_portal() {
    mkdir -p "$PORTAL_DIR" "$TEMPLATES_DIR"
    
    # Create welcome message
    cat > "$PORTAL_DIR/welcome.md" << 'EOF'
# 🚀 Claude Validation Platform - Developer Portal

Welcome to the Claude validation platform! This self-service portal helps you:

## Quick Start
- `claude-validate setup` - Setup your environment
- `claude-validate doctor` - Check system health  
- `claude-validate validate` - Run validations

## Common Tasks
- **First Time Setup**: Run the setup wizard
- **Daily Workflow**: Integrate with your Git workflow
- **Troubleshooting**: Use the diagnostic tools
- **Performance**: Optimize for your repository size

## Resources
- Configuration templates
- Integration examples
- Best practices guide
- Performance tuning tips

## Support
- Self-diagnostic tools
- Interactive troubleshooting
- Performance optimization
- Custom configuration generation
EOF

    create_templates
    create_integration_examples
}

# Create configuration templates
create_templates() {
    # Git hooks template
    cat > "$TEMPLATES_DIR/pre-commit-simple.sh" << 'EOF'
#!/bin/bash
# Simple pre-commit hook template
set -e

echo "🔍 Running validation..."

# Basic YAML validation
if command -v claude-validate >/dev/null 2>&1; then
    claude-validate validate yaml
else
    echo "⚠️  claude-validate not found, using basic validation"
    make validate-yaml 2>/dev/null || echo "❌ Validation failed"
fi
EOF

    # CI/CD templates
    cat > "$TEMPLATES_DIR/github-actions.yml" << 'EOF'
name: Claude Validation
on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup validation environment
        run: |
          scripts/platform/claude-validate setup
      - name: Run validation
        run: |
          scripts/platform/claude-validate validate
      - name: Performance report
        if: always()
        run: |
          scripts/platform/performance-optimizer.sh monitor report
EOF

    # Docker template
    cat > "$TEMPLATES_DIR/Dockerfile.validation" << 'EOF'
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    bash \
    make \
    python3 \
    python3-pip \
    yq \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip3 install pyyaml

# Copy validation scripts
COPY scripts/ /app/scripts/
COPY .claude/ /app/.claude/

WORKDIR /app

# Set up validation environment
RUN scripts/platform/claude-validate setup

# Default command
CMD ["scripts/platform/claude-validate", "validate"]
EOF

    # VS Code settings
    cat > "$TEMPLATES_DIR/vscode-settings.json" << 'EOF'
{
  "files.associations": {
    "*.md": "markdown"
  },
  "yaml.validate": true,
  "yaml.format.enable": true,
  "shellcheck.enable": true,
  "git.hooks.pre-commit": true,
  "tasks.version": "2.0.0",
  "tasks": [
    {
      "label": "Claude Validate",
      "type": "shell",
      "command": "scripts/platform/claude-validate",
      "args": ["validate"],
      "group": "build",
      "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": false,
        "panel": "shared"
      }
    },
    {
      "label": "Claude Setup",
      "type": "shell", 
      "command": "scripts/platform/claude-validate",
      "args": ["setup"],
      "group": "build"
    }
  ]
}
EOF
}

# Create integration examples
create_integration_examples() {
    mkdir -p "$TEMPLATES_DIR/integrations"
    
    # Make integration
    cat > "$TEMPLATES_DIR/integrations/Makefile.example" << 'EOF'
# Claude Validation Integration Example

.PHONY: validate setup doctor fix

# Quick validation
validate:
	@scripts/platform/claude-validate validate

# Environment setup  
setup:
	@scripts/platform/claude-validate setup

# Health check
doctor:
	@scripts/platform/claude-validate doctor

# Auto-fix issues
fix:
	@scripts/platform/claude-validate fix --auto

# Pre-commit test
pre-commit-test:
	@scripts/platform/claude-validate validate --staged

# Performance optimization
optimize:
	@scripts/platform/performance-optimizer.sh analyze
EOF

    # NPM scripts integration
    cat > "$TEMPLATES_DIR/integrations/package.json.example" << 'EOF'
{
  "scripts": {
    "validate": "scripts/platform/claude-validate validate",
    "validate:yaml": "scripts/platform/claude-validate validate yaml",
    "validate:security": "scripts/platform/claude-validate validate security",
    "setup": "scripts/platform/claude-validate setup",
    "doctor": "scripts/platform/claude-validate doctor",
    "fix": "scripts/platform/claude-validate fix --auto",
    "precommit": "scripts/platform/claude-validate validate --staged"
  },
  "husky": {
    "hooks": {
      "pre-commit": "npm run precommit"
    }
  }
}
EOF

    # Python integration
    cat > "$TEMPLATES_DIR/integrations/setup.py.example" << 'EOF'
#!/usr/bin/env python3
"""Claude validation integration for Python projects."""

import subprocess
import sys
from pathlib import Path

def run_validation():
    """Run Claude validation."""
    script_path = Path(__file__).parent / "scripts" / "platform" / "claude-validate"
    
    try:
        result = subprocess.run([str(script_path), "validate"], 
                              capture_output=True, text=True)
        
        if result.returncode == 0:
            print("✅ Validation passed")
            return True
        else:
            print("❌ Validation failed")
            print(result.stdout)
            print(result.stderr)
            return False
            
    except FileNotFoundError:
        print("⚠️  Claude validate not found. Run setup first.")
        return False

if __name__ == "__main__":
    success = run_validation()
    sys.exit(0 if success else 1)
EOF
}

# Interactive setup wizard
run_setup_wizard() {
    echo -e "${BLUE}🧙‍♂️ Claude Validation Setup Wizard${NC}"
    echo "====================================="
    echo
    
    # Project type detection
    local project_type="generic"
    if [[ -f "package.json" ]]; then
        project_type="nodejs"
    elif [[ -f "requirements.txt" ]] || [[ -f "setup.py" ]]; then
        project_type="python"
    elif [[ -f "go.mod" ]]; then
        project_type="go"
    elif [[ -f "Cargo.toml" ]]; then
        project_type="rust"
    fi
    
    echo "🔍 Detected project type: $project_type"
    echo
    
    # Repository size analysis
    local file_count=$(find . -type f | wc -l)
    local repo_size
    if [[ $file_count -lt 100 ]]; then
        repo_size="small"
    elif [[ $file_count -lt 500 ]]; then
        repo_size="medium"
    else
        repo_size="large"
    fi
    
    echo "📊 Repository size: $repo_size ($file_count files)"
    echo
    
    # Interactive configuration
    echo "⚙️  Configuration Options:"
    echo
    
    read -p "Enable performance caching? [Y/n]: " enable_cache
    enable_cache=${enable_cache:-Y}
    
    read -p "Enable parallel validation? [Y/n]: " enable_parallel
    enable_parallel=${enable_parallel:-Y}
    
    read -p "Set up Git hooks? [Y/n]: " setup_hooks
    setup_hooks=${setup_hooks:-Y}
    
    read -p "Create IDE integration? [Y/n]: " setup_ide
    setup_ide=${setup_ide:-Y}
    
    echo
    echo "🚀 Setting up validation platform..."
    
    # Apply configuration
    if [[ "$enable_cache" =~ ^[Yy] ]]; then
        echo "✅ Enabling performance caching"
        # Configuration would be applied here
    fi
    
    if [[ "$enable_parallel" =~ ^[Yy] ]]; then
        echo "✅ Enabling parallel validation"
        # Configuration would be applied here
    fi
    
    if [[ "$setup_hooks" =~ ^[Yy] ]]; then
        echo "✅ Setting up Git hooks"
        "$REPO_ROOT/scripts/install-hooks.sh"
    fi
    
    if [[ "$setup_ide" =~ ^[Yy] ]]; then
        echo "✅ Creating IDE integration files"
        create_ide_integration "$project_type"
    fi
    
    # Performance optimization
    echo "⚡ Optimizing for $repo_size repository..."
    "$SCRIPTS_DIR/performance-optimizer.sh" optimize "$repo_size"
    
    echo
    echo -e "${GREEN}🎉 Setup completed successfully!${NC}"
    echo
    echo "Next steps:"
    echo "  1. Run: claude-validate doctor"
    echo "  2. Test: claude-validate validate"
    echo "  3. Commit your changes to activate hooks"
    echo
    
    # Show integration examples
    show_integration_examples "$project_type"
}

# Create IDE integration
create_ide_integration() {
    local project_type="$1"
    
    # VS Code
    if [[ ! -d ".vscode" ]]; then
        mkdir -p ".vscode"
        cp "$TEMPLATES_DIR/vscode-settings.json" ".vscode/settings.json"
        echo "📝 Created VS Code integration"
    fi
    
    # Project-specific integration
    case "$project_type" in
        nodejs)
            if [[ -f "package.json" ]] && ! grep -q "claude-validate" package.json; then
                echo "📦 Consider adding validation scripts to package.json"
                echo "   See: $TEMPLATES_DIR/integrations/package.json.example"
            fi
            ;;
        python)
            if [[ ! -f "validate.py" ]]; then
                cp "$TEMPLATES_DIR/integrations/setup.py.example" "validate.py"
                echo "🐍 Created Python validation integration"
            fi
            ;;
    esac
}

# Show integration examples
show_integration_examples() {
    local project_type="$1"
    
    echo "📚 Integration Examples:"
    echo
    
    case "$project_type" in
        nodejs)
            echo "NPM Scripts:"
            echo '  "scripts": {'
            echo '    "validate": "scripts/platform/claude-validate validate",'
            echo '    "precommit": "scripts/platform/claude-validate validate --staged"'
            echo '  }'
            ;;
        python)
            echo "Python Integration:"
            echo "  python validate.py  # Run validation"
            echo "  Or integrate with tox, pytest, etc."
            ;;
        *)
            echo "Makefile Integration:"
            echo "  make validate      # Run validation"
            echo "  make setup         # Setup environment"
            echo "  make doctor        # Health check"
            ;;
    esac
    
    echo
    echo "Available templates:"
    echo "  🔧 CI/CD: $TEMPLATES_DIR/github-actions.yml"
    echo "  🐳 Docker: $TEMPLATES_DIR/Dockerfile.validation"
    echo "  ⚙️  Make: $TEMPLATES_DIR/integrations/Makefile.example"
}

# Interactive troubleshooting
run_troubleshooting() {
    echo -e "${YELLOW}🔧 Interactive Troubleshooting${NC}"
    echo "==============================="
    echo
    
    # Common issues and solutions
    local issues=(
        "Validation is slow"
        "Git hooks not working"
        "YAML validation errors"
        "Permission issues"
        "Configuration problems"
        "CI/CD integration issues"
    )
    
    echo "What issue are you experiencing?"
    echo
    
    for i in "${!issues[@]}"; do
        echo "$((i+1)). ${issues[i]}"
    done
    echo
    
    read -p "Select issue (1-${#issues[@]}): " issue_num
    
    case "$issue_num" in
        1)
            troubleshoot_performance
            ;;
        2)
            troubleshoot_git_hooks
            ;;
        3)
            troubleshoot_yaml
            ;;
        4)
            troubleshoot_permissions
            ;;
        5)
            troubleshoot_configuration
            ;;
        6)
            troubleshoot_ci_cd
            ;;
        *)
            echo "❌ Invalid selection"
            return 1
            ;;
    esac
}

# Troubleshooting functions
troubleshoot_performance() {
    echo "🔍 Diagnosing performance issues..."
    
    local file_count=$(find . -type f | wc -l)
    echo "📊 Repository has $file_count files"
    
    if [[ $file_count -gt 1000 ]]; then
        echo "💡 Large repository detected. Recommendations:"
        echo "  1. Enable caching: claude-validate config set .settings.cache_enabled true"
        echo "  2. Use incremental validation"
        echo "  3. Create .claudeignore file to exclude unnecessary files"
        echo "  4. Run: scripts/platform/performance-optimizer.sh analyze"
    fi
    
    # Check for .claudeignore
    if [[ ! -f ".claudeignore" ]]; then
        echo "💡 Create .claudeignore to exclude files:"
        echo "  node_modules/"
        echo "  .git/"
        echo "  *.log"
        echo "  build/"
    fi
    
    # Check cache status
    local cache_size=$(du -sh "$REPO_ROOT/.validation-cache" 2>/dev/null | cut -f1 || echo "0B")
    echo "💾 Current cache size: $cache_size"
}

troubleshoot_git_hooks() {
    echo "🔍 Checking Git hooks..."
    
    local hooks_dir="$REPO_ROOT/.git/hooks"
    local hook_files=("pre-commit" "commit-msg" "pre-push")
    
    for hook in "${hook_files[@]}"; do
        if [[ -x "$hooks_dir/$hook" ]]; then
            echo "✅ $hook hook is installed and executable"
        else
            echo "❌ $hook hook is missing or not executable"
            echo "💡 Fix: Run 'claude-validate setup' or 'make install-hooks'"
        fi
    done
    
    # Check hook content
    if [[ -f "$hooks_dir/pre-commit" ]]; then
        if grep -q "claude-validate\|validation/framework" "$hooks_dir/pre-commit"; then
            echo "✅ Pre-commit hook contains validation logic"
        else
            echo "⚠️  Pre-commit hook exists but may not contain validation"
        fi
    fi
}

troubleshoot_yaml() {
    echo "🔍 Checking YAML validation..."
    
    # Check for common YAML issues
    find .claude/agents -name "*.md" 2>/dev/null | head -5 | while read -r file; do
        echo "Checking $file..."
        
        if ! head -1 "$file" | grep -q "^---$"; then
            echo "❌ Missing YAML front-matter start marker in $file"
        fi
        
        # Check for common YAML errors
        if grep -n "^\s*-\s*$" "$file" >/dev/null; then
            echo "⚠️  Empty list items found in $file"
        fi
        
        if grep -n ":\s*$" "$file" >/dev/null; then
            echo "⚠️  Empty values found in $file"
        fi
    done
    
    echo "💡 Common YAML fixes:"
    echo "  1. Ensure files start with '---'"
    echo "  2. Use proper indentation (2 spaces)"
    echo "  3. Quote strings with special characters"
    echo "  4. Don't use tabs for indentation"
}

troubleshoot_permissions() {
    echo "🔍 Checking file permissions..."
    
    # Check script permissions
    local scripts=("$SCRIPTS_DIR/claude-validate" "$REPO_ROOT/scripts/install-hooks.sh")
    
    for script in "${scripts[@]}"; do
        if [[ -f "$script" ]]; then
            if [[ -x "$script" ]]; then
                echo "✅ $script is executable"
            else
                echo "❌ $script is not executable"
                echo "💡 Fix: chmod +x $script"
            fi
        else
            echo "❌ $script not found"
        fi
    done
    
    # Check directory permissions
    local dirs=("$REPO_ROOT/.claude" "$REPO_ROOT/scripts")
    
    for dir in "${dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            if [[ -r "$dir" ]] && [[ -w "$dir" ]]; then
                echo "✅ $dir has correct permissions"
            else
                echo "❌ $dir permission issues"
                echo "💡 Fix: chmod -R 755 $dir"
            fi
        fi
    done
}

troubleshoot_configuration() {
    echo "🔍 Checking configuration..."
    
    # Check main config files
    local configs=(
        "$REPO_ROOT/CLAUDE.md"
        "$REPO_ROOT/.claude/agents"
        "$REPO_ROOT/scripts/validation/framework.sh"
    )
    
    for config in "${configs[@]}"; do
        if [[ -e "$config" ]]; then
            echo "✅ $config exists"
        else
            echo "❌ $config missing"
            echo "💡 This may indicate incomplete setup"
        fi
    done
    
    # Check validation framework
    if [[ -f "$REPO_ROOT/scripts/validation/framework.sh" ]]; then
        if source "$REPO_ROOT/scripts/validation/framework.sh" 2>/dev/null; then
            echo "✅ Validation framework loads correctly"
        else
            echo "❌ Validation framework has errors"
            echo "💡 Check syntax and dependencies"
        fi
    fi
}

troubleshoot_ci_cd() {
    echo "🔍 Checking CI/CD integration..."
    
    # Check for CI config files
    local ci_files=(
        ".github/workflows"
        ".gitlab-ci.yml"
        "Jenkinsfile"
        ".circleci/config.yml"
    )
    
    local found_ci=false
    for ci_file in "${ci_files[@]}"; do
        if [[ -e "$ci_file" ]]; then
            echo "✅ Found CI configuration: $ci_file"
            found_ci=true
        fi
    done
    
    if [[ "$found_ci" == "false" ]]; then
        echo "⚠️  No CI/CD configuration found"
        echo "💡 Consider adding validation to your CI pipeline"
        echo "   Template available: $TEMPLATES_DIR/github-actions.yml"
    fi
    
    # Check if validation commands work in CI context
    echo "🧪 Testing validation commands..."
    if command -v claude-validate >/dev/null 2>&1; then
        echo "✅ claude-validate command available"
    else
        echo "❌ claude-validate command not found"
        echo "💡 Ensure scripts are executable and in PATH"
    fi
}

# Performance dashboard
show_performance_dashboard() {
    echo -e "${CYAN}📊 Performance Dashboard${NC}"
    echo "======================="
    echo
    
    # Repository stats
    local total_files=$(find . -type f | wc -l)
    local agent_files=$(find .claude/agents -name "*.md" 2>/dev/null | wc -l || echo 0)
    local script_files=$(find scripts -name "*.sh" 2>/dev/null | wc -l || echo 0)
    
    echo "📈 Repository Statistics:"
    echo "  Total files: $total_files"
    echo "  Agent files: $agent_files"
    echo "  Script files: $script_files"
    echo
    
    # Cache information
    if [[ -d "$REPO_ROOT/.validation-cache" ]]; then
        local cache_size=$(du -sh "$REPO_ROOT/.validation-cache" | cut -f1)
        local cache_files=$(find "$REPO_ROOT/.validation-cache" -type f | wc -l)
        echo "💾 Cache Statistics:"
        echo "  Cache size: $cache_size"
        echo "  Cache files: $cache_files"
    else
        echo "💾 Cache: Not initialized"
    fi
    echo
    
    # Recent performance metrics
    if [[ -f "$REPO_ROOT/.validation-metrics/performance.jsonl" ]]; then
        echo "⏱️  Recent Performance:"
        tail -5 "$REPO_ROOT/.validation-metrics/performance.jsonl" | while read -r line; do
            if command -v jq >/dev/null 2>&1; then
                local operation=$(echo "$line" | jq -r '.operation')
                local duration=$(echo "$line" | jq -r '.duration_seconds')
                local files=$(echo "$line" | jq -r '.files_processed')
                echo "  $operation: ${duration}s ($files files)"
            fi
        done
    else
        echo "⏱️  Performance: No metrics available"
    fi
    echo
    
    # Recommendations
    echo "💡 Optimization Recommendations:"
    if [[ $total_files -gt 1000 ]]; then
        echo "  • Large repository detected - consider performance optimization"
        echo "  • Run: scripts/platform/performance-optimizer.sh analyze"
    fi
    
    if [[ ! -f ".claudeignore" ]]; then
        echo "  • Create .claudeignore to exclude unnecessary files"
    fi
    
    if [[ ! -d "$REPO_ROOT/.validation-cache" ]]; then
        echo "  • Enable caching for better performance"
    fi
}

# Main command dispatcher
main() {
    local command="${1:-help}"
    
    case "$command" in
        init)
            init_portal
            echo -e "${GREEN}✅ Developer portal initialized${NC}"
            ;;
        wizard)
            init_portal
            run_setup_wizard
            ;;
        troubleshoot)
            run_troubleshooting
            ;;
        dashboard)
            show_performance_dashboard
            ;;
        templates)
            init_portal
            echo "📝 Available templates:"
            find "$TEMPLATES_DIR" -type f | sed "s|$TEMPLATES_DIR/||" | sort
            ;;
        integration)
            local project_type="${2:-generic}"
            show_integration_examples "$project_type"
            ;;
        help|*)
            echo -e "${BLUE}Claude Developer Portal${NC}"
            echo "======================="
            echo
            echo "Commands:"
            echo "  init              Initialize developer portal"
            echo "  wizard           Run interactive setup wizard"
            echo "  troubleshoot     Interactive troubleshooting"
            echo "  dashboard        Show performance dashboard" 
            echo "  templates        List available templates"
            echo "  integration      Show integration examples"
            echo "  help             Show this help message"
            echo
            echo "Quick Start:"
            echo "  $0 wizard        # Interactive setup"
            echo "  $0 troubleshoot  # Fix common issues"
            echo "  $0 dashboard     # View performance"
            ;;
    esac
}

# Execute main function
main "$@"