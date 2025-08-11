# /analyze-stack Command

## Description
Performs comprehensive technology stack analysis by orchestrating 4 specialized agents in parallel to assess architecture, security vulnerabilities, performance characteristics, and supply chain risks. Provides unified executive summary with prioritized action items for production readiness.

## Usage
```
/analyze-stack [options]
```

## Options
- `--focus <areas>`: Focus analysis on specific areas (security,performance,architecture,dependencies)
- `--depth <level>`: Analysis depth - `basic` or `comprehensive` (default: comprehensive)
- `--format <type>`: Output format - `summary`, `detailed`, or `action-plan` (default: summary)
- `--dry-run`: Simulate analysis execution without actually running agents (preview mode)
- `--preview`: Generate analysis plan and show which agents would be deployed

## Behavior
When you use `/analyze-stack`, I will:

1. **Deploy 4 specialized agents in parallel**:
   - **codebase-analyst**: Architecture assessment, technical debt, design patterns
   - **security-auditor**: Vulnerability scanning, threat modeling, compliance checks
   - **performance-specialist**: Performance profiling, bottleneck analysis, optimization opportunities
   - **supply-chain-security-engineer**: Dependency audit, license compliance, supply chain risks

2. **Execute comprehensive analysis**:
   - Architecture: Service boundaries, coupling, scalability patterns
   - Security: OWASP Top 10, authentication flows, data protection
   - Performance: Latency analysis, resource utilization, caching strategies
   - Dependencies: CVE scanning, license auditing, update recommendations

3. **Aggregate results into unified report** with:
   - Executive Summary
   - Security Posture Assessment
   - Performance Analysis
   - Architecture Assessment  
   - Dependency Audit
   - Prioritized Action Items

## Analysis Depth

### Basic Analysis (`--depth basic`)
- Quick assessment focusing on critical issues
- Surface-level vulnerability scanning
- High-level architecture overview
- Major dependency risks only
- Completes in ~15 seconds

### Comprehensive Analysis (`--depth comprehensive`) [Default]
- Deep technical debt analysis
- Thorough security vulnerability assessment
- Detailed performance profiling with benchmarks
- Complete supply chain audit with risk scoring
- Completes in ~30 seconds

## Simulation Modes

### Preview Mode (`--preview`)
- Shows analysis plan without execution
- Lists which agents would be deployed
- Estimates execution time and resource requirements
- Displays expected analysis scope per focus area
- Useful for planning and resource allocation

### Dry-Run Mode (`--dry-run`)
- Simulates full analysis execution
- Validates agent deployment configuration
- Tests command parsing and option handling
- Returns mock analysis structure
- Perfect for CI/CD pipeline testing

## Focus Areas
Use `--focus` to target specific areas:

```bash
/analyze-stack --focus security           # Security-only analysis
/analyze-stack --focus performance        # Performance-only analysis  
/analyze-stack --focus architecture       # Architecture-only analysis
/analyze-stack --focus dependencies       # Dependencies-only analysis
/analyze-stack --focus security,performance  # Multiple areas
```

## Output Formats

### Summary Format (`--format summary`) [Default]
Concise executive-level overview with key findings and top 5 action items.

### Detailed Format (`--format detailed`)
Comprehensive technical report with full findings, code examples, and detailed recommendations.

### Action Plan Format (`--format action-plan`)
Prioritized task list with effort estimates, impact scores, and implementation guidance.

## Examples

```bash
# Full comprehensive stack analysis
/analyze-stack

# Quick security-focused assessment
/analyze-stack --focus security --depth basic

# Detailed performance analysis with action plan
/analyze-stack --focus performance --format action-plan

# Multi-area analysis with detailed output
/analyze-stack --focus security,architecture --format detailed

# Complete analysis for production readiness
/analyze-stack --depth comprehensive --format detailed

# Preview what analysis would be performed (dry-run)
/analyze-stack --preview --focus security

# Simulate comprehensive analysis without execution
/analyze-stack --dry-run --depth comprehensive
```

## Agent Deployment Strategy

### Parallel Execution
All 4 agents execute simultaneously with specialized prompts:

- **codebase-analyst**: "Perform comprehensive architecture assessment focusing on scalability, maintainability, and technical debt. Identify service boundaries, coupling issues, and design pattern usage."

- **security-auditor**: "Execute full security vulnerability scan including OWASP Top 10, authentication mechanisms, data protection, and compliance requirements. Provide threat model assessment."

- **performance-specialist**: "Analyze system performance including latency bottlenecks, resource utilization patterns, caching strategies, and scalability constraints. Include benchmark recommendations."

- **supply-chain-security-engineer**: "Audit all dependencies for CVE vulnerabilities, license compliance, supply chain risks, and update recommendations. Assess third-party integration security."

### Result Aggregation
Results are merged using weighted scoring:
- Security: 30% weight (critical for production)
- Performance: 25% weight (user experience impact)
- Architecture: 25% weight (maintainability and scalability)
- Dependencies: 20% weight (risk and compliance)

## Output Structure

### Executive Summary
- Overall stack health score (1-100)
- Risk level assessment (Low/Medium/High/Critical)
- Production readiness evaluation
- Top 3 critical findings

### Security Posture
- Vulnerability count by severity
- Authentication/authorization assessment
- Data protection evaluation
- Compliance status (GDPR, SOX, etc.)

### Performance Analysis
- Latency analysis (p50, p95, p99)
- Resource utilization patterns
- Bottleneck identification
- Scalability assessment

### Architecture Assessment
- Technical debt score
- Coupling and cohesion analysis
- Design pattern usage
- Refactoring opportunities

### Dependency Audit
- CVE vulnerability summary
- License compliance status
- Supply chain risk assessment
- Update recommendations

### Prioritized Action Items
1. **Critical** (Fix immediately)
2. **High** (Fix within sprint)
3. **Medium** (Fix within month)
4. **Low** (Technical debt)

Each item includes:
- Impact score (1-10)
- Effort estimate (hours/days)
- Implementation guidance
- Risk if not addressed

## Performance Targets
- **Basic Analysis**: Completes in <15 seconds
- **Comprehensive Analysis**: Completes in <30 seconds
- **Parallel Agent Execution**: 4 agents run simultaneously
- **Result Aggregation**: <5 seconds processing time

## Integration Points
- Works with existing CI/CD pipelines
- Integrates with security scanning tools
- Supports multiple repository formats
- Compatible with monorepo and microservice architectures

## Prerequisites
- Git repository with committed code
- Package/dependency files (package.json, requirements.txt, etc.)
- Access to codebase for static analysis
- Optional: Running services for performance profiling

## Notes
- Results cached for 24 hours to improve performance
- Supports incremental analysis for large codebases
- Automatically detects technology stack and adjusts analysis
- Provides actionable recommendations, not just problem identification
- Integrates with existing development workflow and tools

## Sample Output

```
## Technology Stack Analysis: my-app

### Executive Summary
Overall Health: 78/100 | Risk Level: Medium | Production Ready: ⚠️  With Improvements

Critical Findings:
1. 3 high-severity CVE vulnerabilities in dependencies
2. Authentication bypass vulnerability in API gateway
3. Database query performance bottleneck (2.3s avg response)

### Security Posture: 72/100
- 🔴 3 Critical, 7 High, 12 Medium vulnerabilities
- ✅ Strong authentication implementation
- ⚠️  Missing input validation on 4 endpoints
- 🔴 Exposed sensitive configuration in logs

### Performance: 65/100
- p95 Latency: 2.3s (target: <200ms)
- 🔴 Database bottleneck: inefficient N+1 queries
- ⚠️  Missing caching layer
- ✅ Good horizontal scaling patterns

### Architecture: 82/100
- ✅ Well-defined service boundaries
- ✅ Strong separation of concerns
- ⚠️  Technical debt: 15% code duplication
- 🔴 Circular dependency between user/auth services

### Dependencies: 74/100
- 🔴 3 high-severity CVEs require immediate updates
- ⚠️  12 packages outdated by >6 months
- ✅ All licenses compatible with commercial use
- ⚠️  2 dependencies with known supply chain risks

### Prioritized Action Items
1. **CRITICAL** Update lodash to 4.17.21 (CVE-2021-23337) - 2 hours
2. **CRITICAL** Fix authentication bypass in /api/admin routes - 4 hours  
3. **HIGH** Optimize user query with database indexing - 1 day
4. **HIGH** Break circular dependency between services - 2 days
5. **MEDIUM** Implement Redis caching layer - 3 days
```