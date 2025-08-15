# /deps Command

## Description

Manages dependencies intelligently across all package managers with security scanning, safe updates, and supply
chain protection. Identifies vulnerabilities, reduces technical debt, and maintains optimal dependency health for
polyglot codebases.

## Usage

```bash
/deps <action> [options]
```yaml

## Actions

- `audit` - Deep vulnerability scan with risk assessment
- `update` - Safe, staged dependency updates with rollback capability
- `clean` - Remove unused dependencies to reduce attack surface
- `analyze` - Comprehensive dependency health and risk scoring
- `predict` - Forecast potential future vulnerabilities
- `compare` - Compare dependencies across environments

## Behavior

When you invoke `/deps`, I will:

1. **Detect all package managers** in the codebase
2. **Deploy dependency-manager agent** as the primary coordinator
3. **Analyze the requested action** and deploy appropriate specialists
4. **Execute the action** across all detected ecosystems
5. **Provide consolidated results** with actionable recommendations
6. **Deploy execution-evaluator** to verify:
   - All package managers detected correctly
   - Requested action completed successfully
   - No dependencies broken
   - Security scan results accurate
   - Lock files updated appropriately

## Package Manager Detection

I automatically detect and work with:

- **JavaScript/Node**: npm, yarn, pnpm
- **Python**: pip, pipenv, poetry, conda
- **Go**: go modules
- **Rust**: cargo
- **Java**: maven, gradle
- **Ruby**: bundler
- **PHP**: composer
- **.NET**: nuget
- **Swift**: swift package manager
- **Elixir**: mix

## Action Details

### /deps audit

I perform comprehensive security analysis:

#### Vulnerability Scanning

- Check against CVE databases
- Identify known security issues
- Assess severity levels (Critical, High, Medium, Low)
- Check for available patches

#### Supply Chain Analysis

- Verify package authenticity
- Check maintainer reputation
- Identify typosquatting risks
- Detect suspicious package behaviors
- Analyze download statistics anomalies

#### License Compliance

- Identify license types
- Check for incompatible licenses
- Flag copyleft requirements
- Verify commercial usage rights

#### Output Format

```text
## Dependency Audit Report

### Critical Issues (Immediate Action Required)
- Package: version → vulnerability → fix available

### High Risk (Address Within 48 Hours)
- Package: version → issue → recommendation

### Supply Chain Risks
- Suspicious packages detected
- Unmaintained dependencies
- Single maintainer risks

### License Issues
- Incompatible licenses found
- Commercial usage restrictions
```yaml

### /deps update

I perform safe, intelligent updates:

#### Update Strategy

1. **Analyze update impact** - breaking changes, compatibility
2. **Create update plan** - staged approach for safety
3. **Test each stage** - run tests after each update group
4. **Automatic rollback** - revert on test failures
5. **Generate report** - document all changes

#### Update Priorities

- **Security patches**: Immediate, even if breaking
- **Minor updates**: Grouped by compatibility
- **Major updates**: Individual attention with migration notes
- **Dev dependencies**: Updated more aggressively

#### Safety Measures

- Lock file backups before changes
- Incremental updates (patch → minor → major)
- Compatibility verification between packages
- Test suite validation after each change
- Rollback capability at each stage
- Dry-run diff preview for all changes (show lockfile and manifest diffs)
- Require ExitPlanMode approval for major/breaking updates before write operations

### /deps clean

I remove unnecessary dependencies:

#### Detection Methods

- **Static analysis** - find unused imports/requires
- **Dynamic analysis** - runtime usage tracking
- **Test coverage** - dependencies only used in dead code
- **Build analysis** - unnecessary build dependencies
- **Transitive analysis** - duplicated sub-dependencies
- **Peer/optional dependency awareness** - avoid false positives in removal

#### Cleanup Process

1. Identify unused packages
2. Check for hidden usages
3. Verify removal safety
4. Remove packages incrementally
5. Run full test suite
6. Update lock files
7. Create a reversible PR per removal batch with rollback plan

### /deps analyze

I provide comprehensive dependency health metrics:

#### Health Indicators

- **Freshness**: How up-to-date are dependencies
- **Security**: Known vulnerabilities count
- **Maintenance**: Last update, open issues, responsiveness
- **Popularity**: Downloads, stars, community size
- **Complexity**: Dependency tree depth and breadth
- **Technical Debt**: Update effort required

#### Risk Assessment

```text
## Dependency Health Score: B+ (78/100)

### Breakdown
- Security: A (95/100) - 1 low severity issue
- Freshness: B (75/100) - 12 updates available
- Maintenance: B+ (82/100) - Well maintained
- Complexity: C (65/100) - Deep dependency tree
- License: A (100/100) - All compatible

### Recommendations
1. Update these security-critical packages
2. Consider replacing these unmaintained packages
3. Reduce dependency on these heavy packages
```yaml

### /deps predict

I forecast future dependency risks:

#### Prediction Factors

- **Historical vulnerability patterns** of the package
- **Maintenance activity trends** and responsiveness
- **Dependency chain risks** from sub-dependencies
- **Community health indicators** and adoption trends
- **Code complexity metrics** suggesting bug likelihood

#### Prediction Output

```text
## 30-Day Risk Forecast

### High Risk Packages (>70% probability)
- package-a: Likely security disclosure based on patterns
- package-b: Maintenance stopping, seek alternatives

### Medium Risk (40-70% probability)
- package-c: Increasing issue reports, monitor closely
- package-d: Major version coming, breaking changes expected

### Recommendations
- Prepare migration plan for high-risk packages
- Set up monitoring alerts for medium-risk packages
```yaml

### /deps compare

I analyze dependency differences:

#### Comparison Scenarios

- **Environment comparison**: dev vs prod vs staging
- **Branch comparison**: main vs feature branches
- **Time comparison**: current vs last month
- **Team comparison**: different projects/services

#### Comparison Output

```text
## Dependency Comparison: main vs feature/new-ui

### Added (5 packages)
- react-charts@2.1.0 (visualization)
- lodash@4.17.21 (utilities)

### Removed (2 packages)
- old-chart-lib@1.0.0
- jquery@3.6.0

### Version Changes (8 packages)
- react: 17.0.2 → 18.2.0 (major update)
- typescript: 4.5.0 → 4.9.5 (minor update)

### Security Impact
- Resolved 3 vulnerabilities
- Introduced 1 new low-severity issue
```yaml

## Agent Coordination

### Primary Coordinator

- **dependency-manager**: Orchestrates the analysis and updates

### Specialist Support

- **security-auditor**: For vulnerability assessment
- **supply-chain-security-engineer**: For supply chain risks
- **code-archaeologist**: For usage analysis in legacy code
- **test-engineer**: For validating updates
- **migration-specialist**: For major version upgrades

## Configuration Support

I respect and use configuration files:

- `.dependabot.yml` - GitHub dependency updates
- `.npmrc` / `.yarnrc` - Node.js configurations
- `pip.conf` - Python package settings
- `renovate.json` - Renovate bot configuration
- `.snyk` - Snyk security policies

## Success Metrics

Operation success is measured by:

- **No new vulnerabilities** introduced
- **All tests passing** after updates
- **Reduced attack surface** through cleanup
- **Improved health scores** over time
- **Faster build times** from optimization
- **License compliance** maintained

## Notes

- Always backup lock files before updates
- Security updates take priority over features
- Consider maintenance burden when adding dependencies
- Prefer well-maintained packages over features
- Regular audits prevent security debt accumulation
- Document why each dependency is needed
