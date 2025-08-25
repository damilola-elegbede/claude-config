# Usage Examples

Comprehensive examples of using the Claude Smart Agent Orchestration Framework in real-world development scenarios.

## Quick Start Examples

### Initial Setup
```bash
# Clone and setup the configuration repository
git clone https://github.com/damilola/claude-config.git
cd claude-config

# Sync configurations to your system
/sync

# Verify everything works
/test
```

### Basic Configuration Management
```bash
# Check current system status
./scripts/validate-system.sh

# Backup existing configurations
./scripts/backup-configs.sh

# Sync latest configurations
/sync --backup
```

## Agent Usage Examples

### Development Workflows

#### Full-Stack Feature Development
```bash
# Multi-agent parallel development
# Context: Building a user authentication system

# 1. Architecture planning
/plan "Add JWT-based user authentication with role-based access control"
# Deploys: principal-architect for system design

# 2. Parallel implementation
# Backend API development (runs concurrently)
backend-engineer: "Implement JWT authentication middleware and user roles API"

# Frontend integration (runs concurrently)  
frontend-architect: "Build authentication forms and protected route components"

# Security validation (runs concurrently)
security-auditor: "Review authentication implementation for OWASP compliance"

# Test coverage (runs concurrently)
test-engineer: "Create comprehensive test suite for authentication flows"
```

#### Code Quality Workflow
```bash
# Multi-dimensional code review
/review src/auth/

# This automatically deploys in parallel:
# - code-reviewer: Code quality and best practices
# - security-auditor: Security vulnerability assessment  
# - test-engineer: Test coverage analysis
# - accessibility-auditor: WCAG compliance (if UI changes)

# Results are consolidated into actionable recommendations
```

### Infrastructure Management

#### Kubernetes Deployment
```bash
# Infrastructure orchestration workflow
# Context: Deploying microservices to K8s cluster

# 1. Platform architecture
platform-engineer: "Design developer experience for microservices deployment"

# 2. Parallel infrastructure setup
kubernetes-admin: "Set up K8s cluster with auto-scaling and networking"
devops: "Create CI/CD pipelines for containerized deployments"  
monitoring-specialist: "Configure observability stack with Prometheus and Grafana"

# 3. Security validation
security-auditor: "Review cluster security configuration and network policies"

# 4. Verification
execution-evaluator: "Validate all deployment commands and infrastructure health"
```

#### Database Migration
```bash
# Large-scale database evolution
# Context: Migrating from MySQL to PostgreSQL with zero downtime

# 1. Migration planning
database-migration-specialist: "Plan zero-downtime migration strategy with rollback capabilities"

# 2. Parallel preparation
database-admin: "Optimize current database performance and create backups"
backend-engineer: "Update application code for database abstraction layer"

# 3. Migration execution
database-migration-specialist: "Execute migration with data validation and integrity checks"

# 4. Post-migration validation
performance-specialist: "Benchmark new database performance against baselines"
test-engineer: "Run comprehensive integration tests on migrated data"
```

### Analysis and Debugging

#### Production Issue Investigation
```bash
# Multi-agent debugging workflow
# Context: Intermittent API timeouts in production

# 1. Initial triage
debugger: "Investigate intermittent API timeout issues in production environment"

# 2. Parallel analysis
log-analyst: "Analyze production logs for timeout patterns and correlation"
performance-specialist: "Profile API performance and identify bottlenecks"
monitoring-specialist: "Review system metrics and alerting data"

# 3. Root cause analysis
codebase-analyst: "Review code paths for potential race conditions or deadlocks"

# 4. Solution implementation
backend-engineer: "Implement fixes based on analysis findings"
test-engineer: "Create regression tests to prevent future occurrences"
```

#### Codebase Architecture Review
```bash
# Comprehensive technical assessment
# Context: Planning major refactoring or system modernization

# 1. Multi-dimensional analysis (all run in parallel)
codebase-analyst: "Assess overall architecture, technical debt, and modernization opportunities"
performance-specialist: "Identify performance bottlenecks and optimization opportunities"  
security-auditor: "Conduct security assessment and compliance review"
test-engineer: "Evaluate test coverage and quality assurance practices"

# 2. Strategic planning
principal-architect: "Synthesize findings into modernization roadmap and migration strategy"

# 3. Documentation
tech-writer: "Create comprehensive architecture documentation and migration guide"
```

## Command Workflow Examples

### `/ship-it` - Complete Release Workflow
```bash
# Comprehensive release orchestration with auto-remediation
/ship-it --full

# This executes in sequence with automatic issue resolution:
# 1. /docs --audit (documentation gap analysis)
# 2. /docs (comprehensive documentation updates) 
# 3. /review (multi-agent quality assessment)
# 4. /test (complete test suite execution)
# 5. /docs --clean (organize temporary files)
# 6. /commit (semantic commit creation)
# 7. /push (safe push with validation)
# 8. /pr (pull request creation if needed)

# Each step automatically resolves issues before proceeding
```

### `/context` - Repository Analysis
```bash
# Intelligent repository understanding
/context

# Parallel execution of multiple analysis agents:
# - codebase-analyst: Architecture and technology stack assessment
# - performance-specialist: Performance characteristics analysis  
# - security-auditor: Security posture evaluation
# - test-engineer: Test coverage and framework assessment

# Results synthesized into comprehensive repository overview
```

### `/agent-audit` - Framework Health Check
```bash
# Comprehensive ecosystem validation
/agent-audit

# Deploys 8 parallel agent-auditor instances:
# - Development agents validation (8 specialists)
# - Infrastructure agents validation (7 specialists)  
# - Architecture agents validation (5 specialists)
# - Quality agents validation (7 specialists)
# - Security agents validation (3 specialists)
# - Analysis agents validation (8 specialists)
# - Operations agents validation (4 specialists)

# Provides comprehensive health report with recommendations
```

## Advanced Orchestration Patterns

### Cross-Platform Mobile Development
```bash
# Coordinated multi-platform development
# Context: Building iOS and Android apps with shared backend

# 1. Architecture coordination  
principal-architect: "Design cross-platform architecture with shared business logic"

# 2. Parallel platform development
mobile-platform-engineer instance 1: "Develop iOS native components and platform integrations"
mobile-platform-engineer instance 2: "Develop Android native components and platform integrations"  
backend-engineer: "Build unified API layer for mobile clients"

# 3. Design consistency
mobile-ui: "Ensure platform-appropriate design patterns while maintaining brand consistency"

# 4. Quality assurance
test-engineer: "Create automated testing strategy for both platforms"
performance-specialist: "Optimize app performance for mobile constraints"
```

### Microservices Development
```bash
# Large-scale distributed system development  
# Context: Building 6-service microservices architecture

# 1. System design
principal-architect: "Design microservices architecture with service boundaries and communication patterns"

# 2. Parallel service development (multiple instances)
backend-engineer instance 1: "User service - authentication and profile management"
backend-engineer instance 2: "Payment service - transaction processing and billing"  
backend-engineer instance 3: "Notification service - email, SMS, and push notifications"
backend-engineer instance 4: "Analytics service - event tracking and reporting"

# 3. Supporting development
devops: "Containerization and orchestration setup for all services"
monitoring-specialist: "Distributed tracing and observability implementation"

# 4. Integration validation
integration-specialist: "Service integration testing and contract validation"
api-architect: "API gateway configuration and service mesh setup"
```

### Security-First Development
```bash
# Security-centric development workflow
# Context: Building financial services application

# 1. Security architecture (mandatory first step)
security-auditor: "Design security architecture with threat modeling for financial data"

# 2. Secure development (all include security validation)
backend-engineer + security-auditor: "API development with security-first approach"
frontend-architect + security-auditor: "Frontend development with XSS and CSRF protection"

# 3. Compliance validation
security-auditor: "PCI-DSS compliance verification and audit preparation"
regulatory-compliance-specialist: "Financial regulation compliance and documentation"

# 4. Security testing
security-tester: "Penetration testing and vulnerability assessment"
test-engineer: "Security test automation and continuous testing"
```

## Error Resolution Examples

### Automatic Issue Resolution
```bash
# /ship-it workflow with automatic remediation
User: /ship-it --full

# Step 3: /review finds issues
L Found security vulnerabilities + performance issues + test gaps

=' Auto-remediation triggered:
> security-auditor: "Fixed 2 SQL injection vulnerabilities in user authentication"
> performance-specialist: "Optimized database queries reducing response time by 85%"
> test-engineer: "Added comprehensive integration tests for payment processing"
=Ý Committing fixes: "security: fix SQL injection vulnerabilities and optimize performance"

ó Retrying /review...
 All security, performance, and test issues resolved!
```

### Command Failure Recovery
```bash
# /test command with intelligent failure handling  
/test

L Test failures detected: 
- 5 unit tests failing due to API changes
- Integration tests failing due to database schema mismatch
- TypeScript compilation errors

=' Auto-remediation:
> test-engineer: "Updated unit tests to match new API contract"
> database-migration-specialist: "Applied pending schema migrations" 
> backend-engineer: "Fixed TypeScript type definitions"

ó Retrying /test...
 All tests passing (94% coverage)
```

## Performance Optimization Examples

### Parallel Execution Efficiency
```bash
# Before: Sequential execution (slow)
Time: 0s    -> codebase-analyst (60s)
Time: 60s   -> security-auditor (45s)  
Time: 105s  -> test-engineer (30s)
Total: 135 seconds

# After: Parallel orchestration (fast)
Time: 0s    -> All agents deploy simultaneously
Time: 60s   -> All agents complete (max duration)
Total: 60 seconds (55% improvement)
```

### Multi-Instance Scaling
```bash
# Large codebase analysis with multiple instances
# Context: Analyzing 500k+ LOC enterprise application

# Deploy 4 parallel codebase-analyst instances:
codebase-analyst instance 1: "Analyze backend services (125k LOC)"
codebase-analyst instance 2: "Analyze frontend applications (125k LOC)"  
codebase-analyst instance 3: "Analyze mobile clients (125k LOC)"
codebase-analyst instance 4: "Analyze shared libraries (125k LOC)"

# Coordination:
project-orchestrator: "Synthesize analysis results and identify cross-cutting concerns"

# Result: 75% faster analysis through intelligent parallelization
```

## Troubleshooting Examples

### Agent Selection Issues
```bash
# Problem: Using wrong agent for task
L Wrong: mobile-platform-engineer for web application
 Right: frontend-architect for complex web application

# Problem: Missing parallel opportunities  
L Wrong: Sequential code-reviewer -> security-auditor -> test-engineer
 Right: Parallel deployment of all three agents

# Problem: Over-engineering simple tasks
L Wrong: principal-architect for simple bug fix
 Right: debugger for investigation, backend-engineer for fix
```

### Common Resolution Patterns
```bash
# SYSTEM BOUNDARY violations
Error: "Agent attempted to invoke another agent"
Solution: Let Claude handle all agent coordination - never have agents call other agents

# Configuration sync issues
Error: "Agent not found or configuration invalid"  
Solution: 
1. /sync to refresh configurations
2. ./scripts/validate-agent-yaml.py to check YAML
3. /agent-audit to validate ecosystem

# Performance issues
Error: "Agent response timeout or slow performance"
Solution:
1. Check agent workload and complexity
2. Consider parallel execution for independent tasks
3. Use multiple instances for large-scale work
```

## Best Practices Summary

### Agent Selection
- **Match expertise to task complexity**: Use specialists for their domain
- **Prefer parallel execution**: Deploy multiple agents simultaneously when possible  
- **Escalate appropriately**: Simple -> Senior -> Staff -> Principal as complexity increases
- **Leverage multi-instance**: Scale identical tasks across multiple agent instances

### Quality Assurance
- **Always include security-auditor** for authentication/authorization code
- **Parallel quality gates**: code-reviewer + security-auditor + test-engineer
- **Performance validation**: Include performance-specialist for optimization tasks
- **Execution verification**: Use execution-evaluator after critical operations

### Workflow Optimization
- **Start with /context** for repository understanding
- **Use /ship-it** for complete release workflows with auto-remediation
- **Deploy /agent-audit** regularly for framework health monitoring
- **Implement proper error handling** with automatic retry and fix patterns

---

**Key Takeaway**: The Smart Agent Orchestration Framework excels when you combine specialist expertise with parallel execution and intelligent error handling. Focus on matching the right agents to the right tasks while maximizing concurrent operations.