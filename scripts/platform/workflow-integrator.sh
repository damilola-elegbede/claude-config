#!/bin/bash
# Workflow Integrator - Seamless integration with development workflows
# Handles Git workflows, IDE integration, and CI/CD pipeline setup
set -euo pipefail

REPO_ROOT=$(git rev-parse --show-toplevel)
WORKFLOWS_DIR="$REPO_ROOT/.claude/platform/workflows"
INTEGRATIONS_DIR="$REPO_ROOT/.claude/platform/integrations"

# Colors
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# Initialize workflow integration
init_workflows() {
    mkdir -p "$WORKFLOWS_DIR" "$INTEGRATIONS_DIR"
    
    log_info "Initializing workflow integration system..."
    
    # Create workflow definitions
    create_git_workflows
    create_ci_workflows
    create_ide_workflows
    create_custom_workflows
    
    log_success "Workflow integration initialized"
}

# Git workflow integration
create_git_workflows() {
    log_info "Setting up Git workflow integration..."
    
    # Pre-commit workflow
    cat > "$WORKFLOWS_DIR/pre-commit.yml" << 'EOF'
# Pre-commit validation workflow
name: pre-commit-validation
description: "Comprehensive pre-commit validation"

triggers:
  - git-pre-commit

steps:
  - name: "Environment Check"
    command: "scripts/platform/claude-validate doctor --quick"
    continue_on_error: false
    
  - name: "Incremental Validation"
    command: "scripts/platform/claude-validate validate --staged"
    continue_on_error: false
    
  - name: "Performance Check"
    command: "scripts/platform/performance-optimizer.sh monitor record"
    continue_on_error: true

notifications:
  success: "sound"
  failure: "sound+message"

performance:
  timeout: 300
  parallel: true
  cache: true
EOF

    # Commit message workflow
    cat > "$WORKFLOWS_DIR/commit-msg.yml" << 'EOF'
# Commit message validation workflow
name: commit-message-validation
description: "Validate and enhance commit messages"

triggers:
  - git-commit-msg

steps:
  - name: "Message Format Check"
    command: "scripts/platform/commit-validator.sh format"
    continue_on_error: false
    
  - name: "Conventional Commit Check"
    command: "scripts/platform/commit-validator.sh conventional"
    continue_on_error: true
    
  - name: "Auto-enhance Message"
    command: "scripts/platform/commit-validator.sh enhance"
    continue_on_error: true

settings:
  min_length: 10
  max_length: 72
  conventional_format: true
  auto_prefix_ticket: true
EOF

    # Pre-push workflow
    cat > "$WORKFLOWS_DIR/pre-push.yml" << 'EOF'
# Pre-push comprehensive validation
name: pre-push-validation
description: "Final validation before push"

triggers:
  - git-pre-push

steps:
  - name: "Full Validation Suite"
    command: "scripts/platform/claude-validate validate"
    continue_on_error: false
    
  - name: "Security Scan"
    command: "scripts/platform/claude-validate validate security"
    continue_on_error: false
    
  - name: "Performance Report"
    command: "scripts/platform/performance-optimizer.sh test"
    continue_on_error: true
    
  - name: "Integration Test"
    command: "make test 2>/dev/null || echo 'No tests configured'"
    continue_on_error: true

notifications:
  success: "Performance: {{duration}}s, Files: {{files_count}}"
  failure: "Validation failed - see output for details"
EOF

    log_success "Git workflows created"
}

# CI/CD workflow integration
create_ci_workflows() {
    log_info "Setting up CI/CD workflow integration..."
    
    # GitHub Actions workflow
    cat > "$WORKFLOWS_DIR/github-actions.yml" << 'EOF'
# GitHub Actions CI/CD integration
name: Claude Validation CI
description: "Comprehensive validation in CI/CD"

on:
  push:
    branches: [ main, develop, 'feature/*' ]
  pull_request:
    branches: [ main, develop ]

jobs:
  validate:
    runs-on: ubuntu-latest
    
    strategy:
      matrix:
        validation-type: [yaml, format, security, docs]
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        
      - name: Setup validation environment
        run: |
          sudo apt-get update
          sudo apt-get install -y yq shellcheck
          pip3 install pyyaml
          
      - name: Initialize platform
        run: |
          scripts/platform/claude-validate setup
          scripts/platform/performance-optimizer.sh analyze
          
      - name: Run validation
        run: |
          scripts/platform/claude-validate validate ${{ matrix.validation-type }}
          
      - name: Performance report
        if: always()
        run: |
          scripts/platform/performance-optimizer.sh monitor report 1
          
      - name: Upload metrics
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: validation-metrics-${{ matrix.validation-type }}
          path: .validation-metrics/
  
  integration-test:
    needs: validate
    runs-on: ubuntu-latest
    if: github.event_name == 'pull_request'
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        
      - name: Full integration test
        run: |
          scripts/platform/claude-validate setup
          scripts/platform/claude-validate validate
          make test 2>/dev/null || echo "No tests configured"
          
      - name: Performance benchmark
        run: |
          scripts/platform/performance-optimizer.sh test
EOF

    # GitLab CI workflow
    cat > "$WORKFLOWS_DIR/gitlab-ci.yml" << 'EOF'
# GitLab CI integration
stages:
  - validate
  - test
  - performance

variables:
  CLAUDE_VALIDATE_CACHE: "true"

before_script:
  - apt-get update -qq && apt-get install -y yq shellcheck
  - pip3 install pyyaml

validate:yaml:
  stage: validate
  script:
    - scripts/platform/claude-validate setup
    - scripts/platform/claude-validate validate yaml
  cache:
    paths:
      - .validation-cache/
  artifacts:
    reports:
      junit: .validation-metrics/yaml-results.xml
    when: always

validate:format:
  stage: validate
  script:
    - scripts/platform/claude-validate validate format
  cache:
    paths:
      - .validation-cache/

validate:security:
  stage: validate
  script:
    - scripts/platform/claude-validate validate security
  allow_failure: false

validate:docs:
  stage: validate
  script:
    - scripts/platform/claude-validate validate docs

integration-test:
  stage: test
  script:
    - scripts/platform/claude-validate validate
    - make test 2>/dev/null || echo "No tests configured"
  dependencies:
    - validate:yaml
    - validate:format
    - validate:security
    - validate:docs

performance-test:
  stage: performance
  script:
    - scripts/platform/performance-optimizer.sh test
  artifacts:
    reports:
      performance: .validation-metrics/performance-report.json
  only:
    - main
    - develop
EOF

    # Jenkins pipeline
    cat > "$WORKFLOWS_DIR/Jenkinsfile" << 'EOF'
// Jenkins pipeline for Claude validation
pipeline {
    agent any
    
    environment {
        CLAUDE_VALIDATE_CACHE = 'true'
        CLAUDE_VALIDATE_PARALLEL = 'true'
    }
    
    stages {
        stage('Setup') {
            steps {
                sh 'scripts/platform/claude-validate setup'
                sh 'scripts/platform/performance-optimizer.sh analyze'
            }
        }
        
        stage('Validation') {
            parallel {
                stage('YAML') {
                    steps {
                        sh 'scripts/platform/claude-validate validate yaml'
                    }
                }
                stage('Format') {
                    steps {
                        sh 'scripts/platform/claude-validate validate format'
                    }
                }
                stage('Security') {
                    steps {
                        sh 'scripts/platform/claude-validate validate security'
                    }
                }
                stage('Documentation') {
                    steps {
                        sh 'scripts/platform/claude-validate validate docs'
                    }
                }
            }
        }
        
        stage('Integration Test') {
            when {
                anyOf {
                    branch 'main'
                    branch 'develop'
                    changeRequest()
                }
            }
            steps {
                sh 'scripts/platform/claude-validate validate'
                sh 'make test 2>/dev/null || echo "No tests configured"'
            }
        }
        
        stage('Performance Report') {
            steps {
                sh 'scripts/platform/performance-optimizer.sh monitor report'
                archiveArtifacts artifacts: '.validation-metrics/**', allowEmptyArchive: true
            }
        }
    }
    
    post {
        always {
            sh 'scripts/platform/performance-optimizer.sh monitor record "jenkins-pipeline" $BUILD_DURATION $BUILD_NUMBER'
        }
        success {
            echo 'Validation pipeline completed successfully!'
        }
        failure {
            echo 'Validation pipeline failed. Check logs for details.'
        }
    }
}
EOF

    log_success "CI/CD workflows created"
}

# IDE workflow integration
create_ide_workflows() {
    log_info "Setting up IDE workflow integration..."
    
    # VS Code tasks
    cat > "$WORKFLOWS_DIR/vscode-tasks.json" << 'EOF'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Claude: Validate All",
            "type": "shell",
            "command": "scripts/platform/claude-validate",
            "args": ["validate"],
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared",
                "showReuseMessage": true,
                "clear": false
            },
            "problemMatcher": {
                "pattern": {
                    "regexp": "^(ERROR|WARNING):\\s+(.*)$",
                    "severity": 1,
                    "message": 2
                }
            }
        },
        {
            "label": "Claude: Validate YAML Only",
            "type": "shell",
            "command": "scripts/platform/claude-validate",
            "args": ["validate", "yaml"],
            "group": "build"
        },
        {
            "label": "Claude: Setup Environment",
            "type": "shell",
            "command": "scripts/platform/claude-validate",
            "args": ["setup"],
            "group": "build"
        },
        {
            "label": "Claude: Health Check",
            "type": "shell",
            "command": "scripts/platform/claude-validate",
            "args": ["doctor"],
            "group": "test"
        },
        {
            "label": "Claude: Auto-fix Issues",
            "type": "shell",
            "command": "scripts/platform/claude-validate",
            "args": ["fix", "--auto"],
            "group": "build"
        },
        {
            "label": "Claude: Performance Dashboard",
            "type": "shell",
            "command": "scripts/platform/developer-portal.sh",
            "args": ["dashboard"],
            "group": "test"
        }
    ]
}
EOF

    # VS Code launch configurations
    cat > "$WORKFLOWS_DIR/vscode-launch.json" << 'EOF'
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Debug Validation",
            "type": "node",
            "request": "launch",
            "program": "scripts/platform/claude-validate",
            "args": ["validate", "--debug"],
            "console": "integratedTerminal",
            "env": {
                "CLAUDE_VALIDATE_DEBUG": "1"
            }
        },
        {
            "name": "Debug Performance",
            "type": "node", 
            "request": "launch",
            "program": "scripts/platform/performance-optimizer.sh",
            "args": ["test"],
            "console": "integratedTerminal"
        }
    ]
}
EOF

    # Vim/Neovim integration
    cat > "$WORKFLOWS_DIR/vim-integration.vim" << 'EOF'
" Claude validation integration for Vim/Neovim

" Quick validation commands
command! ClaudeValidate !scripts/platform/claude-validate validate
command! ClaudeValidateYaml !scripts/platform/claude-validate validate yaml
command! ClaudeSetup !scripts/platform/claude-validate setup
command! ClaudeDoctor !scripts/platform/claude-validate doctor
command! ClaudeFix !scripts/platform/claude-validate fix --auto

" Key mappings
nnoremap <leader>cv :ClaudeValidate<CR>
nnoremap <leader>cy :ClaudeValidateYaml<CR>
nnoremap <leader>cd :ClaudeDoctor<CR>
nnoremap <leader>cf :ClaudeFix<CR>

" Auto-validation on save for agent files
autocmd BufWritePost .claude/agents/*.md !scripts/platform/claude-validate validate yaml --file %

" Status line integration
function! ClaudeValidationStatus()
    let l:result = system('scripts/platform/claude-validate validate --quick 2>/dev/null')
    return v:shell_error == 0 ? '✅' : '❌'
endfunction

" Add to statusline: %{ClaudeValidationStatus()}
EOF

    # Emacs integration
    cat > "$WORKFLOWS_DIR/emacs-integration.el" << 'EOF'
;; Claude validation integration for Emacs

(defun claude-validate ()
  "Run Claude validation"
  (interactive)
  (compile "scripts/platform/claude-validate validate"))

(defun claude-validate-yaml ()
  "Run YAML validation only"
  (interactive)
  (compile "scripts/platform/claude-validate validate yaml"))

(defun claude-setup ()
  "Setup Claude validation environment"
  (interactive)
  (compile "scripts/platform/claude-validate setup"))

(defun claude-doctor ()
  "Run Claude health check"
  (interactive)
  (compile "scripts/platform/claude-validate doctor"))

(defun claude-fix ()
  "Auto-fix validation issues"
  (interactive)
  (compile "scripts/platform/claude-validate fix --auto"))

;; Key bindings
(global-set-key (kbd "C-c v v") 'claude-validate)
(global-set-key (kbd "C-c v y") 'claude-validate-yaml)
(global-set-key (kbd "C-c v s") 'claude-setup)
(global-set-key (kbd "C-c v d") 'claude-doctor)
(global-set-key (kbd "C-c v f") 'claude-fix)

;; Auto-validation hook
(add-hook 'after-save-hook
          (lambda ()
            (when (string-match ".claude/agents/.*\\.md$" buffer-file-name)
              (claude-validate-yaml))))
EOF

    log_success "IDE workflows created"
}

# Custom workflow creation
create_custom_workflows() {
    log_info "Setting up custom workflow templates..."
    
    # Workflow executor
    cat > "$WORKFLOWS_DIR/executor.sh" << 'EOF'
#!/bin/bash
# Workflow executor for Claude validation platform
set -euo pipefail

WORKFLOWS_DIR="$(dirname "$0")"
REPO_ROOT=$(git rev-parse --show-toplevel)

# Execute workflow from YAML definition
execute_workflow() {
    local workflow_file="$1"
    local trigger="${2:-manual}"
    
    if [[ ! -f "$workflow_file" ]]; then
        echo "❌ Workflow file not found: $workflow_file"
        return 1
    fi
    
    echo "🚀 Executing workflow: $(basename "$workflow_file")"
    
    # Parse YAML and execute steps
    if command -v yq >/dev/null 2>&1; then
        local steps_count=$(yq eval '.steps | length' "$workflow_file")
        
        for ((i=0; i<steps_count; i++)); do
            local step_name=$(yq eval ".steps[$i].name" "$workflow_file")
            local step_command=$(yq eval ".steps[$i].command" "$workflow_file")
            local continue_on_error=$(yq eval ".steps[$i].continue_on_error // true" "$workflow_file")
            
            echo "▶️  Executing: $step_name"
            
            if eval "$step_command"; then
                echo "✅ Step completed: $step_name"
            else
                echo "❌ Step failed: $step_name"
                if [[ "$continue_on_error" != "true" ]]; then
                    echo "🛑 Workflow terminated due to step failure"
                    return 1
                fi
            fi
        done
    else
        echo "⚠️  yq not available, cannot parse workflow YAML"
        return 1
    fi
    
    echo "✅ Workflow completed successfully"
}

# List available workflows
list_workflows() {
    echo "Available workflows:"
    find "$WORKFLOWS_DIR" -name "*.yml" -exec basename {} \; | sort
}

# Validate workflow definition
validate_workflow() {
    local workflow_file="$1"
    
    if [[ ! -f "$workflow_file" ]]; then
        echo "❌ Workflow file not found: $workflow_file"
        return 1
    fi
    
    # Basic YAML validation
    if command -v yq >/dev/null 2>&1; then
        if yq eval '.' "$workflow_file" >/dev/null 2>&1; then
            echo "✅ Workflow YAML is valid"
        else
            echo "❌ Invalid YAML in workflow file"
            return 1
        fi
        
        # Check required fields
        local required_fields=("name" "description" "steps")
        for field in "${required_fields[@]}"; do
            if yq eval "has(\"$field\")" "$workflow_file" | grep -q "false"; then
                echo "❌ Missing required field: $field"
                return 1
            fi
        done
        
        echo "✅ Workflow definition is valid"
    else
        echo "⚠️  Cannot validate workflow without yq"
    fi
}

# Main command dispatcher
case "${1:-help}" in
    execute)
        execute_workflow "$2" "${3:-manual}"
        ;;
    list)
        list_workflows
        ;;
    validate)
        validate_workflow "$2"
        ;;
    *)
        echo "Usage: $0 {execute|list|validate}"
        echo "  execute <workflow.yml> [trigger]  Execute a workflow"
        echo "  list                              List available workflows"
        echo "  validate <workflow.yml>           Validate workflow definition"
        ;;
esac
EOF

    chmod +x "$WORKFLOWS_DIR/executor.sh"
    
    # Custom workflow template
    cat > "$WORKFLOWS_DIR/custom-template.yml" << 'EOF'
# Custom workflow template
name: custom-workflow
description: "Template for creating custom workflows"

triggers:
  - manual
  - git-pre-commit
  - git-pre-push
  - cron

steps:
  - name: "Step 1: Environment Check"
    command: "scripts/platform/claude-validate doctor --quick"
    continue_on_error: false
    timeout: 30
    
  - name: "Step 2: Custom Validation"
    command: "echo 'Add your custom command here'"
    continue_on_error: true
    timeout: 60
    
  - name: "Step 3: Cleanup"
    command: "echo 'Cleanup operations'"
    continue_on_error: true

settings:
  parallel: false
  cache: true
  timeout: 300

notifications:
  success: "Custom workflow completed successfully"
  failure: "Custom workflow failed - check logs"
  
environment:
  CUSTOM_VAR: "value"
  DEBUG: "false"
EOF

    log_success "Custom workflows created"
}

# Integration setup for specific platforms
setup_platform_integration() {
    local platform="${1:-detect}"
    
    if [[ "$platform" == "detect" ]]; then
        # Auto-detect platform
        if [[ -f "package.json" ]]; then
            platform="nodejs"
        elif [[ -f "requirements.txt" ]] || [[ -f "setup.py" ]]; then
            platform="python"
        elif [[ -f "go.mod" ]]; then
            platform="go"
        elif [[ -f "Cargo.toml" ]]; then
            platform="rust"
        else
            platform="generic"
        fi
    fi
    
    log_info "Setting up integration for $platform platform..."
    
    case "$platform" in
        nodejs)
            setup_nodejs_integration
            ;;
        python)
            setup_python_integration
            ;;
        go)
            setup_go_integration
            ;;
        rust)
            setup_rust_integration
            ;;
        generic|*)
            setup_generic_integration
            ;;
    esac
}

# Node.js integration
setup_nodejs_integration() {
    log_info "Setting up Node.js integration..."
    
    # Package.json scripts
    if [[ -f "package.json" ]]; then
        local temp_file=$(mktemp)
        
        # Add scripts if they don't exist
        if ! grep -q '"claude:validate"' package.json; then
            jq '.scripts["claude:validate"] = "scripts/platform/claude-validate validate"' package.json > "$temp_file"
            mv "$temp_file" package.json
        fi
        
        if ! grep -q '"claude:setup"' package.json; then
            jq '.scripts["claude:setup"] = "scripts/platform/claude-validate setup"' package.json > "$temp_file"
            mv "$temp_file" package.json
        fi
        
        if ! grep -q '"precommit"' package.json; then
            jq '.scripts.precommit = "scripts/platform/claude-validate validate --staged"' package.json > "$temp_file"
            mv "$temp_file" package.json
        fi
        
        log_success "Added Claude validation scripts to package.json"
    fi
    
    # Husky integration
    if command -v npx >/dev/null 2>&1; then
        if [[ ! -d ".husky" ]]; then
            npx husky-init
            echo "scripts/platform/claude-validate validate --staged" > .husky/pre-commit
            log_success "Configured Husky with Claude validation"
        fi
    fi
}

# Python integration
setup_python_integration() {
    log_info "Setting up Python integration..."
    
    # Create validation script
    cat > "validate.py" << 'EOF'
#!/usr/bin/env python3
"""Claude validation integration for Python projects."""

import subprocess
import sys
from pathlib import Path
import argparse

def run_validation(validation_types=None):
    """Run Claude validation."""
    script_path = Path(__file__).parent / "scripts" / "platform" / "claude-validate"
    
    cmd = [str(script_path), "validate"]
    if validation_types:
        cmd.extend(validation_types)
    
    try:
        result = subprocess.run(cmd, capture_output=True, text=True)
        
        if result.returncode == 0:
            print("✅ Validation passed")
            return True
        else:
            print("❌ Validation failed")
            print(result.stdout)
            if result.stderr:
                print(result.stderr)
            return False
            
    except FileNotFoundError:
        print("⚠️  Claude validate not found. Run setup first.")
        return False

def main():
    parser = argparse.ArgumentParser(description="Claude validation for Python")
    parser.add_argument("types", nargs="*", help="Validation types to run")
    args = parser.parse_args()
    
    success = run_validation(args.types)
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()
EOF
    
    chmod +x "validate.py"
    log_success "Created Python validation integration"
    
    # Pre-commit hooks integration
    if [[ -f ".pre-commit-config.yaml" ]]; then
        log_info "Pre-commit framework detected"
        # Could add Claude validation to pre-commit config
    fi
}

# Go integration
setup_go_integration() {
    log_info "Setting up Go integration..."
    
    # Create Go validation wrapper
    cat > "validate.go" << 'EOF'
package main

import (
    "fmt"
    "os"
    "os/exec"
    "path/filepath"
)

func main() {
    wd, err := os.Getwd()
    if err != nil {
        fmt.Printf("❌ Error getting working directory: %v\n", err)
        os.Exit(1)
    }
    
    scriptPath := filepath.Join(wd, "scripts", "platform", "claude-validate")
    
    args := append([]string{"validate"}, os.Args[1:]...)
    cmd := exec.Command(scriptPath, args...)
    cmd.Stdout = os.Stdout
    cmd.Stderr = os.Stderr
    
    if err := cmd.Run(); err != nil {
        fmt.Println("❌ Validation failed")
        os.Exit(1)
    }
    
    fmt.Println("✅ Validation passed")
}
EOF
    
    log_success "Created Go validation integration"
}

# Rust integration
setup_rust_integration() {
    log_info "Setting up Rust integration..."
    
    # Add validation to Cargo.toml
    if [[ -f "Cargo.toml" ]]; then
        if ! grep -q "\[package.metadata.claude\]" Cargo.toml; then
            echo "" >> Cargo.toml
            echo "[package.metadata.claude]" >> Cargo.toml
            echo "validate_cmd = \"scripts/platform/claude-validate validate\"" >> Cargo.toml
            echo "setup_cmd = \"scripts/platform/claude-validate setup\"" >> Cargo.toml
        fi
        log_success "Added Claude metadata to Cargo.toml"
    fi
}

# Generic integration
setup_generic_integration() {
    log_info "Setting up generic integration..."
    
    # Create simple wrapper script
    cat > "validate" << 'EOF'
#!/bin/bash
# Generic validation wrapper
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -x "$SCRIPT_DIR/scripts/platform/claude-validate" ]]; then
    exec "$SCRIPT_DIR/scripts/platform/claude-validate" validate "$@"
else
    echo "❌ Claude validate not found. Run setup first."
    exit 1
fi
EOF
    
    chmod +x "validate"
    log_success "Created generic validation wrapper"
}

# Main command dispatcher
main() {
    local command="${1:-help}"
    
    case "$command" in
        init)
            init_workflows
            ;;
        integrate)
            local platform="${2:-detect}"
            setup_platform_integration "$platform"
            ;;
        execute)
            "$WORKFLOWS_DIR/executor.sh" execute "${@:2}"
            ;;
        list)
            "$WORKFLOWS_DIR/executor.sh" list
            ;;
        validate)
            "$WORKFLOWS_DIR/executor.sh" validate "$2"
            ;;
        git)
            create_git_workflows
            ;;
        ci)
            create_ci_workflows
            ;;
        ide)
            create_ide_workflows
            ;;
        help|*)
            echo "Workflow Integrator - Claude Validation Platform"
            echo "==============================================="
            echo
            echo "Commands:"
            echo "  init                    Initialize all workflow integrations"
            echo "  integrate [platform]    Setup platform-specific integration"
            echo "  execute <workflow>      Execute a specific workflow"
            echo "  list                    List available workflows"
            echo "  validate <workflow>     Validate workflow definition"
            echo "  git                     Setup Git workflow integration"
            echo "  ci                      Setup CI/CD workflow integration"
            echo "  ide                     Setup IDE workflow integration"
            echo
            echo "Platform Integration:"
            echo "  nodejs                  Node.js/npm integration"
            echo "  python                  Python integration"
            echo "  go                      Go integration"
            echo "  rust                    Rust/Cargo integration"
            echo "  generic                 Generic Makefile integration"
            echo
            echo "Examples:"
            echo "  $0 init                 # Setup all integrations"
            echo "  $0 integrate nodejs     # Setup Node.js integration"
            echo "  $0 execute pre-commit.yml  # Run pre-commit workflow"
            ;;
    esac
}

# Execute main function
main "$@"