# /deps Command

## Description

Manages dependencies across all package managers with security scanning and
safe updates. Provides quick audit, update, and cleanup operations for
polyglot codebases.

## Usage

```bash
/deps                        # Quick audit of all dependencies
/deps audit                  # Detailed security scan
/deps update                 # Safe dependency updates
/deps clean                  # Remove unused dependencies
/deps --quick               # Fast check without deep analysis
```

## Behavior

When invoked, I will manage dependencies across all detected package managers,
performing security scanning and safe updates. Quick mode provides essential
health checks in 30 seconds, while audit mode performs comprehensive analysis
with supply chain assessment.

## Two-Mode Operation

### Quick Mode (default) - 30 Second Analysis

**What it does**: Essential dependency health check

```yaml
Analysis Scope:
  - Detect package managers automatically
  - Check for known critical vulnerabilities
  - Identify outdated packages
  - Flag unused dependencies

Agent Usage: None (direct tooling)

Output: Summary with actionable items only
```

### Deep Mode (audit) - 2 Minute Analysis

**What it does**: Comprehensive dependency analysis

```yaml
Analysis Scope:
  - Full CVE vulnerability scanning
  - Supply chain risk assessment
  - License compliance checking
  - Dependency tree analysis

Agent Usage: dependency-manager + supply-chain-security-engineer

Output: Detailed report with risk scoring
```

## Package Manager Support

### Auto-Detection

```bash
# Detection patterns
detect_package_managers() {
  managers=()

  [ -f "package.json" ] && managers+=("npm")
  [ -f "yarn.lock" ] && managers+=("yarn")
  [ -f "requirements.txt" ] && managers+=("pip")
  [ -f "pyproject.toml" ] && managers+=("poetry")
  [ -f "go.mod" ] && managers+=("go")
  [ -f "Cargo.toml" ] && managers+=("cargo")
  [ -f "pom.xml" ] && managers+=("maven")
  [ -f "build.gradle" ] && managers+=("gradle")
  [ -f "Gemfile" ] && managers+=("bundler")
  [ -f "composer.json" ] && managers+=("composer")

  echo "Detected: ${managers[*]}"
}
```

### Quick Vulnerability Checks

```bash
# Fast security scanning per ecosystem
quick_scan() {
  if [ -f "package.json" ]; then
    npm audit --audit-level high --parseable
  fi

  if [ -f "requirements.txt" ]; then
    pip-audit --format=json
  fi

  if [ -f "go.mod" ]; then
    go list -json -m all | nancy sleuth
  fi

  if [ -f "Cargo.toml" ]; then
    cargo audit --json
  fi
}
```

## Core Operations

### /deps (Quick Mode)

```text
🔍 Scanning dependencies...
📦 Detected: npm, pip (2 package managers)

⚠️ Issues Found:
🔴 Critical: lodash@4.17.15 (prototype pollution CVE-2020-8203)
🟡 Medium: axios@0.21.0 (SSRF vulnerability)
📊 Outdated: 12 packages have newer versions
🗑️ Unused: 3 packages not imported

💡 Quick Fixes:
npm audit fix
pip install --upgrade-strategy eager

⏱️ Completed in 28 seconds
```

### /deps audit (Deep Mode)

```text
## Comprehensive Dependency Audit

### Security Analysis
🔴 **Critical Vulnerabilities**: 2 found
- lodash@4.17.15: Prototype pollution (CVE-2020-8203)
  Fix: npm install lodash@4.17.21
- pillow@8.2.0: Buffer overflow (CVE-2021-34552)
  Fix: pip install pillow>=8.3.2

🟡 **Medium Risk**: 3 vulnerabilities
🟢 **Low Risk**: 7 vulnerabilities

### Supply Chain Assessment
✅ **Package Authenticity**: All packages verified
⚠️ **Maintainer Risk**: 2 packages have single maintainer
🔍 **Suspicious Activity**: None detected

### License Compliance
✅ **Compatible Licenses**: 94% (47/50 packages)
⚠️ **GPL Dependencies**: 2 packages require review
❌ **License Conflicts**: 1 incompatible license found

### Recommendations
1. Update critical vulnerabilities immediately
2. Consider alternatives for single-maintainer packages
3. Review GPL license requirements for commercial use
4. Remove 3 unused dependencies to reduce attack surface

⏱️ Completed in 1m 47s
```

### /deps update (Safe Updates)

```bash
# Staged update process
safe_update() {
  echo "🔄 Performing safe dependency updates..."

  # Backup current state
  cp package-lock.json package-lock.json.backup 2>/dev/null
  cp requirements.txt requirements.txt.backup 2>/dev/null

  # Update in stages
  echo "Stage 1: Security patches only"
  npm audit fix --force

  echo "Stage 2: Minor version updates"
  npm update --save

  echo "Stage 3: Test compatibility"
  npm test || {
    echo "❌ Tests failed, rolling back..."
    restore_backup
    return 1
  }

  echo "✅ Updates completed successfully"
}
```

### /deps clean (Unused Removal)

```bash
# Remove unused dependencies
cleanup_dependencies() {
  echo "🗑️ Removing unused dependencies..."

  # Node.js unused packages
  if command -v depcheck >/dev/null; then
    depcheck --json | jq -r '.dependencies[]' | xargs npm uninstall
  fi

  # Python unused packages
  if command -v unimport >/dev/null; then
    unimport --check --diff requirements.txt
  fi

  # Go module cleanup
  if [ -f "go.mod" ]; then
    go mod tidy
  fi

  echo "✅ Cleanup completed"
}
```

## Language-Specific Patterns

### Node.js/npm

```bash
# Complete npm audit and fix workflow
npm_workflow() {
  # Quick vulnerability check
  npm audit --audit-level high

  # Automated fixes for non-breaking changes
  npm audit fix

  # Manual review for breaking changes
  npm audit fix --force --dry-run

  # Update outdated packages
  npm outdated
  npm update
}
```

### Python/pip

```bash
# Python dependency management
python_workflow() {
  # Security scanning
  pip-audit --desc --format=json

  # Check for outdated packages
  pip list --outdated --format=json

  # Safe updates (patch versions only)
  pip install --upgrade --upgrade-strategy only-if-needed

  # Requirements file update
  pip freeze > requirements.txt
}
```

### Go Modules

```bash
# Go dependency management
go_workflow() {
  # Vulnerability scanning
  go list -json -m all | nancy sleuth

  # Update all dependencies
  go get -u ./...

  # Clean unused dependencies
  go mod tidy

  # Verify dependencies
  go mod verify
}
```

## Agent Coordination

### Quick Mode (No Agents)

```yaml
Direct Tooling:
  - npm audit, pip-audit, cargo audit
  - Built-in package manager commands
  - Simple vulnerability databases

Speed: 30 seconds average
Accuracy: High for known CVEs
Coverage: Basic security + outdated packages
```

### Deep Mode (Multi-Agent)

```yaml
Agent Deployment:
  dependency-manager:
    role: "Coordinate dependency analysis across ecosystems"
    tools: "All package manager integrations"

  supply-chain-security-engineer:
    role: "Advanced threat detection and supply chain analysis"
    tools: "CVE databases, package reputation analysis"

Coordination:
  - dependency-manager handles basic scanning
  - supply-chain-security-engineer provides threat intelligence
  - Results merged for comprehensive assessment
```

## Risk Assessment Matrix

### Vulnerability Severity

```yaml
Critical (CVSS 9.0-10.0):
  - Remote code execution
  - Privilege escalation
  - Data exfiltration
  Action: Immediate update required

High (CVSS 7.0-8.9):
  - Authentication bypass
  - SQL injection
  - XSS vulnerabilities
  Action: Update within 48 hours

Medium (CVSS 4.0-6.9):
  - Information disclosure
  - DoS potential
  - Input validation issues
  Action: Schedule update within 1 week

Low (CVSS 0.1-3.9):
  - Minor information leaks
  - Edge case vulnerabilities
  Action: Update during next maintenance
```

### Supply Chain Risk Factors

```yaml
High Risk Indicators:
  - Single maintainer packages
  - Recent maintainer changes
  - Unusual download patterns
  - Missing or incomplete metadata
  - Packages with embedded malware history

Medium Risk Indicators:
  - Infrequent updates (>1 year)
  - Small user base (<1000 downloads/week)
  - Typosquatting potential
  - Complex dependency chains

Low Risk Indicators:
  - Well-established packages
  - Active maintenance
  - Large user base
  - Corporate sponsorship
```

## Execution Verification

Deploy execution-evaluator to verify:

- ✅ **Package managers detected** - All present ecosystems identified
- ✅ **Vulnerabilities scanned** - Security databases queried successfully
- ✅ **Updates applied safely** - No breaking changes introduced
- ✅ **Dependencies functional** - Applications still work after changes
- ✅ **Lock files updated** - Dependency versions properly recorded
- ✅ **Tests passing** - Quality gates maintained during updates

## Examples

### Quick Dependency Check

```bash
User: /deps
Claude: 🔍 Scanning dependencies across 3 package managers...
⚠️ Found 2 critical vulnerabilities in npm packages
📊 12 packages have updates available
🗑️ 3 unused dependencies detected
💡 Run 'npm audit fix' for immediate security fixes
⏱️ Scan completed in 31 seconds
```

### Security-Focused Audit

```bash
User: /deps audit
Claude: 🔒 Deploying dependency-manager + supply-chain-security-engineer...
📊 Deep scanning 247 dependencies across npm, pip, go modules...
🔴 Critical: 1 RCE vulnerability in express@4.16.1
🟡 Medium: 5 other security issues found
⚠️ Supply chain: 2 packages flagged for single-maintainer risk
📋 Generating comprehensive security report...
```

### Safe Update Process

```bash
User: /deps update
Claude: 🔄 Starting safe dependency update process...
💾 Backing up current dependency state...
🔒 Stage 1: Applying security patches (3 updates)...
📦 Stage 2: Minor version updates (12 packages)...
🧪 Stage 3: Running tests to verify compatibility...
✅ All updates successful, tests passing
```

## Notes

- Quick mode for daily workflow, deep mode for security reviews
- Automatically detects all package managers in polyglot repos
- Prioritizes security fixes over feature updates
- Always backs up state before making changes
- Integrates with CI/CD pipelines for automated scanning
- Supports both individual and batch dependency operations
