---
description: Manage dependencies with security scanning and safe updates
argument-hint: [audit|update|clean|--quick]
---

# Dependency Management Command

Manages dependencies across all package managers with security scanning and safe updates.
Provides quick audit, update, and cleanup operations for polyglot codebases.

## Context

When invoked, deploy multiple security-auditor instances (one per package manager) to scan all ecosystems
simultaneously. Quick mode provides essential health checks in 10-15 seconds using parallel scanning, while
audit mode deploys additional security-auditor instances for comprehensive analysis in 20-30 seconds
(4-6x faster than sequential).

### Command Usage

```bash
/deps                        # Quick audit of all dependencies
/deps audit                  # Detailed security scan
/deps update                 # Safe dependency updates
/deps clean                  # Remove unused dependencies
/deps --quick               # Fast check without deep analysis
```

### Agent Orchestration - Multi-Instance Package Manager Scanning

Deploy multiple instances for simultaneous package manager scanning:

```yaml
# PARALLEL WAVE: Multi-Instance Dependency Scanning (20-30 seconds)
security-auditor (instance pool):
  deployment: One instance per package manager detected
  calculation: min(5, number_of_package_managers)
  distribution:
    - instance_1: npm/yarn dependencies (package.json, lock files)
    - instance_2: Python pip dependencies (requirements.txt, pyproject.toml)
    - instance_3: Go modules (go.mod, go.sum)
    - instance_4: Rust cargo dependencies (Cargo.toml, Cargo.lock)
    - instance_5: Java/Maven dependencies (pom.xml, build.gradle)
  parallel_execution: All package managers scanned simultaneously
  role: Analyze dependencies per ecosystem
  output: Per-ecosystem dependency reports in parallel

security-auditor (instance pool):
  deployment: 2-3 instances for comprehensive security scanning
  distribution:
    - instance_1: Frontend dependencies supply chain risks
    - instance_2: Backend dependencies vulnerability assessment
    - instance_3: Infrastructure/DevOps dependency security
  parallel_with: [security-auditor instances]
  role: Deep supply chain vulnerability assessment
  output: Multi-angle security analysis

security-auditor:
  role: CVE scanning coordination and aggregation
  input: Results from all security-auditor instances
  output: Consolidated CVE report, security recommendations

devops:
  role: Infrastructure dependency validation
  parallel_with: [all other agents]
  output: Deployment compatibility assessment

platform-engineer:
  role: Platform-level dependency management
  parallel_with: [all other agents]
  output: System compatibility recommendations

# Performance Impact:
#   Sequential: 2 minutes for all package managers
#   Multi-instance parallel: 20-30 seconds (4-6x faster)
#   Ecosystem isolation: No interference between scanners
```

### Multi-Instance Scanning Strategy

```yaml
Multi-Package Manager Support:
  instance_deployment:
    - Auto-detect all package managers in repository
    - Deploy one security-auditor instance per ecosystem
    - Each instance runs ecosystem-specific tools
    - Maximum 5 concurrent instances

  parallel_tools_per_instance:
    - npm: npm audit, npm outdated, depcheck
    - pip: pip-audit, pip list --outdated, pipdeptree
    - go: nancy sleuth, go list -u, go mod graph
    - cargo: cargo audit, cargo outdated, cargo tree
    - maven: dependency:analyze, versions:display

  result_aggregation:
    - Real-time streaming from all instances
    - Unified vulnerability report
    - Cross-ecosystem dependency analysis
    - Consolidated risk assessment

Time Optimization:
  - Sequential: 2+ minutes
  - Multi-instance parallel: 20-30 seconds (4-6x faster)
  - Full CPU utilization: Each instance on separate core
```

## Expected Output

### Two-Mode Operation

#### Quick Mode (default) - 30 Second Analysis

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

#### Deep Mode (audit) - Multi-Instance Analysis (20-30 seconds)

**What it does**: Comprehensive parallel dependency analysis

```yaml
Analysis Scope:
  - Full CVE vulnerability scanning (all ecosystems simultaneously)
  - Supply chain risk assessment (multiple security instances)
  - License compliance checking (per-ecosystem parallel)
  - Dependency tree analysis (concurrent for all package managers)

Agent Usage:
  - security-auditor instances (one per package manager)
  - security-auditor instances (2-3 for security)
  - Parallel aggregation and reporting

Output: Detailed report with risk scoring from all instances

Performance:
  - Sequential: 2+ minutes
  - Multi-instance: 20-30 seconds (4-6x faster)
```

### Package Manager Support

Auto-detects: npm, pip, go, cargo, maven, gradle, bundler, composer
Based on presence of manifest files (package.json, requirements.txt, etc.)
Uses ecosystem-specific tools: npm audit, pip-audit, cargo audit, nancy (Go)

### Core Operations

#### /deps (Quick Mode)

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

#### /deps audit (Deep Mode)

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

#### /deps update (Safe Updates)

Staged process: backup → security patches → minor updates → test → rollback if needed

#### /deps clean (Unused Removal)

Uses depcheck (npm), pip-check (python), cargo machete (rust)
Safely removes unused dependencies after verification

### Language-Specific Patterns

#### Node.js/npm Workflow

```bash
npm_workflow() {
  # Quick vulnerability check and automated fixes
  npm audit --audit-level high
  npm audit fix

  # Manual review for breaking changes
  npm audit fix --force --dry-run

  # Update outdated packages
  npm outdated && npm update
}
```

#### Other Ecosystems

- Python: pip-audit, pip upgrade, pip-autoremove
- Go: nancy sleuth, go get -u, go mod tidy
- Rust: cargo audit, cargo update

### Agent Coordination

#### Quick Mode (No Agents)

```yaml
Direct Tooling:
  - npm audit, pip-audit, cargo audit
  - Built-in package manager commands
  - Simple vulnerability databases

Speed: 30 seconds average
Accuracy: High for known CVEs
Coverage: Basic security + outdated packages
```

#### Deep Mode (Multi-Instance Deployment)

```yaml
Multi-Instance Agent Deployment:
  security-auditor (instance pool):
    instances: "One per package manager (npm, pip, go, cargo, maven)"
    role: "Parallel ecosystem-specific dependency analysis"
    tools: "Ecosystem-specific scanners and audit tools"

  security-auditor (instance pool):
    instances: "2-3 for comprehensive coverage"
    distribution:
      - instance_1: "Frontend supply chain risks"
      - instance_2: "Backend vulnerability assessment"
      - instance_3: "Infrastructure dependency security"
    tools: "CVE databases, package reputation analysis"

Parallel Coordination:
  - All security-auditor instances scan simultaneously
  - Security instances provide multi-angle threat assessment
  - Results stream in real-time from all instances
  - Aggregated report generated from parallel outputs

Instance Scaling:
  - Small project (1-2 ecosystems): 2-3 total instances
  - Medium project (3-4 ecosystems): 4-5 total instances
  - Large polyglot (5+ ecosystems): 6-8 total instances
```

### Risk Assessment Matrix

#### Vulnerability Severity

```yaml
Critical (CVSS 9.0-10.0):
  - Remote code execution, privilege escalation, data exfiltration
  Action: Immediate update required

High (CVSS 7.0-8.9):
  - Authentication bypass, SQL injection, XSS vulnerabilities
  Action: Update within 48 hours

Medium (CVSS 4.0-6.9):
  - Information disclosure, DoS potential, input validation issues
  Action: Schedule update within 1 week

Low (CVSS 0.1-3.9):
  - Minor information leaks, edge case vulnerabilities
  Action: Update during next maintenance
```

#### Supply Chain Risk Factors

```yaml
High Risk Indicators:
  - Single maintainer packages, recent maintainer changes
  - Unusual download patterns, missing metadata
  - Packages with embedded malware history

Medium Risk Indicators:
  - Infrequent updates (>1 year), small user base (<1000 downloads/week)
  - Typosquatting potential, complex dependency chains

Low Risk Indicators:
  - Well-established packages, active maintenance
  - Large user base, corporate sponsorship
```

### Execution Verification

Deploy execution-evaluator to verify:

- ✅ **Package managers detected** - All present ecosystems identified
- ✅ **Vulnerabilities scanned** - Security databases queried successfully
- ✅ **Updates applied safely** - No breaking changes introduced
- ✅ **Dependencies functional** - Applications still work after changes
- ✅ **Lock files updated** - Dependency versions properly recorded
- ✅ **Tests passing** - Quality gates maintained during updates

### Examples

#### Quick Dependency Check

```text
User: /deps
Claude: 🔍 Scanning dependencies across 3 package managers...
⚠️ Found 2 critical vulnerabilities in npm packages
📊 12 packages have updates available
🗑️ 3 unused dependencies detected
💡 Run 'npm audit fix' for immediate security fixes
⏱️ Scan completed in 31 seconds
```

#### Security-Focused Audit with Multi-Instance

```text
User: /deps audit
Claude: 🔒 Deploying multi-instance dependency scanners...
📊 Instance Pool Status:
  - security-auditor[1]: Scanning npm (127 packages)...
  - security-auditor[2]: Scanning pip (85 packages)...
  - security-auditor[3]: Scanning go modules (35 packages)...
  - supply-chain[1]: Analyzing frontend supply chain...
  - supply-chain[2]: Assessing backend vulnerabilities...

⚡ Parallel Scanning Results (23 seconds):
🔴 Critical: 1 RCE vulnerability in express@4.16.1
🟡 Medium: 5 security issues across ecosystems
⚠️ Supply chain: 2 packages with maintainer risks
📋 Aggregating reports from all instances...
✅ Complete audit finished 4.5x faster than sequential
```

#### Safe Update Process

```text
User: /deps update
Claude: 🔄 Starting safe dependency update process...
💾 Backing up current dependency state...
🔒 Stage 1: Applying security patches (3 updates)...
📦 Stage 2: Minor version updates (12 packages)...
🧪 Stage 3: Running tests to verify compatibility...
✅ All updates successful, tests passing
```

## Notes

- **Multi-Instance Scanning**: Deploy one instance per package manager for parallel analysis
- **Dynamic Scaling**: Instance count adjusts to number of ecosystems detected
- **Performance Target**: 20-30 seconds for full audit (was 2+ minutes)
- Quick mode for daily workflow (10-15 seconds), deep mode for security reviews (20-30 seconds)
- Automatically detects all package managers in polyglot repos
- Prioritizes security fixes over feature updates
- Always backs up state before making changes
