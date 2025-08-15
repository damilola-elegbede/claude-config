# ShellCheck Validation System

## Overview

This repository now includes comprehensive ShellCheck validation to prevent bash syntax errors and improve shell script quality. The system includes automated CI validation, local development tools, and pre-commit hooks.

## Components

### 1. CI/CD Workflows

#### Primary ShellCheck Workflow
- **File**: `.github/workflows/shellcheck.yml`
- **Triggers**: All pushes and PRs, specifically when shell scripts change
- **Features**:
  - Validates all shell scripts in the repository
  - Separate critical script validation with strict rules
  - Artifact upload for detailed results
  - Excludes temporary and node_modules directories

#### Integrated CI Validation
- **File**: `.github/workflows/ci.yml`
- **Integration**: Added shellcheck validation for critical scripts
- **Focus**: Essential scripts that must pass for CI/CD to work

### 2. Configuration Files

#### ShellCheck Configuration
- **File**: `.shellcheckrc`
- **Purpose**: Centralized configuration for shellcheck behavior
- **Features**:
  - Default shell set to bash
  - Warning-level severity
  - Excludes common false positives
  - Enables all optional checks

#### Pre-commit Configuration
- **File**: `.pre-commit-config.yaml`
- **Purpose**: Local validation before commits
- **Includes**:
  - ShellCheck validation
  - Basic file checks
  - YAML validation
  - Markdown linting

### 3. Development Tools

#### Setup Script
- **File**: `scripts/setup-shellcheck.sh`
- **Purpose**: One-command setup for developers
- **Features**:
  - Cross-platform ShellCheck installation
  - Pre-commit hooks setup
  - Repository validation
  - Test verification

#### Fix Script
- **File**: `scripts/fix-shellcheck-issues.sh`
- **Purpose**: Automated fixing of common issues
- **Features**:
  - Safe automatic fixes
  - Backup creation
  - Progress tracking
  - Manual fix suggestions

## Usage

### For Developers

#### Initial Setup
```bash
# Install ShellCheck and setup pre-commit hooks
./scripts/setup-shellcheck.sh
```

#### Local Validation
```bash
# Check individual script
shellcheck path/to/script.sh

# Check all repository scripts
./scripts/setup-shellcheck.sh

# Run pre-commit on all files
pre-commit run --all-files
```

#### Fixing Issues
```bash
# Automatic fixes for common issues
./scripts/fix-shellcheck-issues.sh

# Manual validation after fixes
shellcheck scripts/*.sh
```

### For CI/CD

#### Automatic Validation
- All shell scripts are automatically validated on push/PR
- Critical scripts must pass strict validation
- Results are uploaded as artifacts for review

#### Severity Levels
- **Critical Scripts**: Error-level severity (must pass)
- **General Scripts**: Warning-level severity (should pass)
- **Temporary Scripts**: Excluded from validation

## Script Categories

### Critical Scripts (Must Pass Strict Validation)
- `tests/test.sh` - Main test runner
- `scripts/validate-system.sh` - System validation
- `scripts/validate_yaml.sh` - YAML validation
- `scripts/setup-hooks.sh` - Git hooks setup
- `scripts/install-hooks.sh` - Hook installation

### Validated Scripts (Warning Level)
- All scripts in `scripts/` directory
- All test scripts in `tests/` directory
- Shell scripts without `.sh` extension (detected by shebang)

### Excluded from Validation
- `temp-scripts/` directory
- `node_modules/` directory
- Scripts in `.git/` directory

## Configuration Details

### ShellCheck Rules

#### Enabled Checks
- All standard ShellCheck rules
- All optional checks (`enable=all`)
- Bash-specific syntax validation

#### Excluded Rules
- **SC1091**: Not following sourced files (common in CI)
- **SC2034**: Variable appears unused (acceptable for exports)

#### Customizable Rules
Individual scripts can override global settings:
```bash
# shellcheck disable=SC2086
# This script intentionally uses word splitting
```

### Pre-commit Integration

#### Automatic Checks
- ShellCheck validation on all shell scripts
- Syntax validation
- Executable permission checks
- Trailing whitespace removal
- End-of-file fixing

#### Performance
- Only runs on changed files by default
- Can be run on all files with `--all-files` flag

## Troubleshooting

### Common Issues

#### ShellCheck Not Found
```bash
# Install ShellCheck
./scripts/setup-shellcheck.sh
```

#### Permission Denied
```bash
# Make scripts executable
chmod +x path/to/script.sh
```

#### False Positives
Add specific disables:
```bash
# shellcheck disable=SC2086  # Intentional word splitting
```

#### Pre-commit Failures
```bash
# Install hooks
pre-commit install

# Run on all files to fix issues
pre-commit run --all-files
```

### CI/CD Debugging

#### View ShellCheck Results
- Check CI artifacts for detailed ShellCheck output
- Download `shellcheck-results` artifact from failed builds

#### Local Reproduction
```bash
# Run the same checks as CI
shellcheck --format=gcc --severity=warning scripts/*.sh
```

## Best Practices

### Writing ShellCheck-Compliant Scripts

#### Required Elements
```bash
#!/bin/bash
# shellcheck disable=SC2086  # Document intentional rule exceptions

set -euo pipefail  # Fail fast on errors

# Quote variables
echo "Value: $variable"

# Use command -v instead of which
if command -v git >/dev/null 2>&1; then
    echo "Git is available"
fi

# Handle cd failures
cd /some/path || exit 1
```

#### Error Handling
```bash
# Check command success
if ! some_command; then
    echo "Command failed"
    exit 1
fi

# Use && and || carefully
command1 && command2  # OK: command2 only if command1 succeeds
command1 || exit 1    # OK: exit if command1 fails

# Avoid: command1 && command2 || command3  # This is not if-then-else!
```

#### Variable Handling
```bash
# Quote variables to prevent word splitting
echo "File: $filename"

# Use arrays for multiple values
files=("file1.sh" "file2.sh")
for file in "${files[@]}"; do
    echo "Processing: $file"
done

# Declare variables before use
local result
result=$(some_command)
```

### Code Review Guidelines

#### Automatic Checks
- ShellCheck validation must pass
- Syntax validation must pass
- Pre-commit hooks must pass

#### Manual Review Points
- Intentional rule exceptions are documented
- Error handling is appropriate
- Variables are properly quoted
- Scripts follow repository patterns

## Integration with Existing Workflows

### GitHub Actions
- ShellCheck runs in parallel with other checks
- Results are available as downloadable artifacts
- Critical scripts must pass for CI to succeed

### Development Workflow
1. Write/modify shell script
2. Pre-commit hooks run automatically
3. Fix any issues identified
4. Commit changes
5. CI validates on push/PR

### Release Process
- All shell scripts must pass validation
- No critical script failures allowed
- Warning-level issues documented but don't block

## Future Enhancements

### Planned Improvements
- Shell script unit testing framework
- Automated performance analysis
- Integration with code coverage tools
- Custom rule development for repository-specific patterns

### Monitoring
- Track ShellCheck rule violation trends
- Monitor false positive rates
- Measure script quality improvements over time

## Support

### Getting Help
- Run `./scripts/setup-shellcheck.sh` for guided setup
- Check CI artifacts for detailed error messages
- Review this documentation for common solutions

### Contributing
- All new shell scripts must pass ShellCheck validation
- Use the setup script to ensure your environment is correct
- Follow the coding standards outlined in this document

---

This validation system ensures high-quality, reliable shell scripts throughout the repository while providing developers with the tools they need to write compliant code efficiently.