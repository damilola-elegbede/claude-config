# Claude Agent Ecosystem Documentation

## Overview

The Claude agent ecosystem provides specialized AI agents for various technical tasks, from implementation to analysis, testing, and strategic planning. Each agent has specific expertise and tool access patterns optimized for their domain.

## Table of Contents
- [Quick Reference](#quick-reference)
- [Agent Categories](#agent-categories)
- [Individual Agent Specifications](#individual-agent-specifications)
- [Multi-Agent Orchestration](#multi-agent-orchestration)
- [Command Shortcuts](#command-shortcuts)
- [Best Practices](#best-practices)

## Quick Reference

### Command to Agent Mapping
| Command | Agent | Purpose |
|---------|-------|---------|
| `/test` | test-engineer | Automated test discovery and execution |
| `/review` | code-reviewer | Comprehensive code quality review |
| `/security` | security-auditor | Security vulnerability assessment |
| `/perf` | performance-engineer | Performance analysis and optimization |
| `/docs` | tech-writer | Documentation creation and maintenance |
| `/debug` | debugger | Complex bug investigation |
| `/orchestrate` | project-orchestrator | Multi-agent execution planning |
| `/context` | codebase-analyst (multiple) | Repository structure analysis |

### Agent Selection Matrix

#### By Task Type
| Task | Recommended Agent | When to Use |
|------|------------------|-------------|
| **New Feature** | fullstack-lead → backend-staff/frontend-staff | Start with lead, escalate to staff for complexity |
| **Bug Fix** | debugger → implementation agents | Debug first, then fix with appropriate dev agent |
| **Code Review** | code-reviewer + security-auditor + qa-tester | Run in parallel for comprehensive review |
| **Documentation** | tech-writer | Any documentation needs |
| **Performance** | performance-engineer | Optimization and benchmarking |
| **Architecture** | principal-architect | System design and technical decisions |

## Agent Categories

### 1. Implementation Agents
Agents that write and modify code directly.

#### Senior Level
- **fullstack-lead**: General implementation, single-service features
- **senior-dev**: Standard development tasks, established patterns

#### Staff Level  
- **backend-staff**: Complex backend systems, microservices, distributed systems
- **frontend-staff**: Complex UI, real-time features, performance optimization

#### Specialist
- **mobile-staff**: iOS/Android development
- **api-engineer**: API design, OpenAPI specs, contract testing

### 2. Analysis Agents
Agents focused on understanding and evaluating code.

- **codebase-analyst**: Internal code analysis, architecture assessment
- **researcher**: External research, technology evaluation
- **debugger**: Complex bug investigation, root cause analysis
- **performance-engineer**: Performance profiling, optimization

### 3. Quality Assurance Agents
Agents ensuring code quality and security.

- **code-reviewer**: Code style, best practices, PR readiness
- **security-auditor**: Vulnerability assessment, OWASP compliance
- **qa-tester**: Test strategy, coverage analysis
- **test-engineer**: Test implementation and automation

### 4. Strategic Planning Agents
Agents for high-level planning and coordination.

- **principal-architect**: System architecture, technical roadmaps
- **product-strategist**: Feature prioritization, user experience
- **project-orchestrator**: Multi-agent coordination, execution planning

### 5. Operations Agents
Agents for infrastructure and deployment.

- **devops-engineer**: CI/CD, deployment automation
- **platform-engineer**: Production reliability, monitoring
- **sre-specialist**: Site reliability, incident response

### 6. Design & Documentation Agents
Agents for UI/UX and technical writing.

- **ui-designer**: Web/desktop interfaces, design systems
- **mobile-ui**: Mobile-specific design patterns
- **tech-writer**: Technical documentation, API docs

## Individual Agent Specifications

### backend-staff
**Role**: Staff Backend Engineer  
**Expertise**: Complex distributed systems, microservices, high-performance backends  
**Tool Access**: Full implementation access  
**When to Use**:
- Multi-service coordination
- Performance requirements < 2.5s
- Distributed state management
- 100k+ requests/second

**Example Usage**:
```
I need a backend-staff agent to design and implement a distributed caching layer for our microservices that can handle 150k requests per second with sub-100ms latency.
```

### frontend-staff
**Role**: Staff Frontend Engineer  
**Expertise**: Complex UI, real-time features, performance optimization  
**Tool Access**: Full implementation access  
**When to Use**:
- Real-time data (WebSocket/SSE)
- Complex state management
- Core Web Vitals optimization
- Micro-frontend architecture

**Example Usage**:
```
I need a frontend-staff agent to implement a real-time collaborative editor with conflict resolution and offline support.
```

### fullstack-lead
**Role**: Senior Fullstack Engineer  
**Expertise**: End-to-end feature development, API integration  
**Tool Access**: Full implementation access  
**When to Use**:
- Single-service features
- Well-defined requirements
- Standard patterns
- Initial implementation before escalation

**Example Usage**:
```
I need a fullstack-lead agent to implement user authentication with JWT tokens and password reset functionality.
```

### principal-architect
**Role**: Principal Software Architect  
**Expertise**: System design, architecture decisions, technical strategy  
**Tool Access**: Full access + strategic planning tools  
**When to Use**:
- Architecture decisions
- Technology stack selection
- Cross-team coordination
- Technical roadmaps

**Example Usage**:
```
I need a principal-architect agent to design the migration strategy from our monolith to microservices architecture.
```

### codebase-analyst
**Role**: Code Analysis Specialist  
**Expertise**: Architecture assessment, technical debt analysis  
**Tool Access**: Read + analysis tools  
**When to Use**:
- Repository overview
- Technical debt assessment
- Architecture documentation
- Dependency analysis

**Example Usage**:
```
I need multiple codebase-analyst agents to analyze our backend, frontend, and mobile codebases in parallel.
```

### security-auditor
**Role**: Security Assessment Specialist  
**Expertise**: Vulnerability assessment, compliance checking  
**Tool Access**: Read + security analysis tools  
**When to Use**:
- Security review
- OWASP Top 10 compliance
- Penetration testing
- Compliance audits

**Example Usage**:
```
I need a security-auditor agent to perform a comprehensive security assessment before our SOC 2 audit.
```

### test-engineer
**Role**: Test Automation Engineer  
**Expertise**: Test framework setup, automated testing  
**Tool Access**: Full test implementation access  
**When to Use**:
- Test suite creation
- Test automation
- Coverage improvement
- Framework selection

**Example Usage**:
```
/test
```

### tech-writer
**Role**: Technical Documentation Specialist  
**Expertise**: API docs, technical guides, SPEC files  
**Tool Access**: Documentation read/write  
**When to Use**:
- API documentation
- README updates
- Architecture docs
- SPEC file creation

**Example Usage**:
```
/docs api --sync
```

### debugger
**Role**: Debug Specialist  
**Expertise**: Complex bug investigation, root cause analysis  
**Tool Access**: Full debugging access  
**When to Use**:
- Intermittent failures
- Performance degradation
- Memory leaks
- Race conditions

**Example Usage**:
```
/debug Users are reporting random 500 errors in production that we can't reproduce locally
```

### project-orchestrator
**Role**: Multi-Agent Coordination Specialist  
**Expertise**: Parallel execution planning, resource optimization  
**Tool Access**: Orchestration and coordination tools  
**When to Use**:
- 3+ agents needed
- Complex project planning
- Parallel execution optimization
- Resource allocation

**Example Usage**:
```
/orchestrate Implement a new payment system with Stripe integration
```

## Multi-Agent Orchestration

### Parallel Execution Patterns

#### Development Pattern
Run multiple implementation agents concurrently:
```
backend-staff (payment service) + 
backend-staff (notification service) + 
frontend-staff (checkout UI) +
mobile-staff (mobile checkout)
```

#### Quality Assurance Pattern
Comprehensive parallel review:
```
code-reviewer + security-auditor + qa-tester + performance-engineer
```

#### Analysis Pattern
Multi-perspective analysis:
```
codebase-analyst (backend) + 
codebase-analyst (frontend) + 
codebase-analyst (infrastructure) +
security-auditor
```

### Orchestration Best Practices

1. **Start with project-orchestrator** for 3+ agent projects
2. **Maximize parallelization** - identify independent tasks
3. **Use multiple instances** of the same agent type when appropriate
4. **Define clear interfaces** between agent outputs
5. **Synchronize at milestones** for integration points

### Example: E-commerce Platform Development

```
Phase 1 (Parallel):
- backend-staff: User service
- backend-staff: Product catalog service  
- backend-staff: Order service
- frontend-staff: Customer portal
- mobile-staff: Mobile app

Phase 2 (Parallel):
- api-engineer: API gateway design
- test-engineer: Integration tests
- security-auditor: Security assessment

Phase 3:
- principal-architect: Architecture review
- tech-writer: API documentation
```

## Command Shortcuts

### /test Command
Invokes test-engineer agent to:
- Discover existing tests
- Create test suites if missing
- Run appropriate test commands
- Generate starter tests

### /review Command  
Launches parallel review with:
- code-reviewer: Style and best practices
- security-auditor: Security vulnerabilities
- qa-tester: Test coverage gaps

### /security Command
Dedicated security-auditor invocation for:
- OWASP Top 10 assessment
- Authentication flow review
- Data exposure risks
- Compliance checking

### /perf Command
Performance-engineer analysis including:
- Bottleneck identification
- Load testing
- Resource optimization
- Benchmark comparisons

### /docs Command
tech-writer agent for:
- API documentation
- README files
- Architecture docs
- SPEC files
- Migration guides

### /debug Command
debugger agent for investigating:
- Intermittent failures
- Performance issues
- Memory leaks
- Race conditions

### /orchestrate Command
project-orchestrator for:
- Multi-agent planning
- Execution optimization
- Resource allocation
- Timeline estimation

### /context Command
Multiple codebase-analyst agents for:
- Repository overview
- Tech stack analysis
- Architecture understanding
- Quick onboarding

## Best Practices

### Agent Selection
1. **Start simple**: Use fullstack-lead before escalating to staff agents
2. **Match expertise**: Choose agents based on domain expertise
3. **Consider scope**: Single service vs multi-service vs system-wide
4. **Think parallel**: Identify opportunities for concurrent execution

### Multi-Instance Usage
Use multiple instances of the same agent when you have:
- Independent components (3 backend-staff for 3 microservices)
- Large analysis scope (4 codebase-analyst for different domains)
- Platform variations (2 mobile-staff for iOS and Android)
- Parallel features (multiple senior-dev for independent features)

### Coordination Patterns
1. **Sequential**: When tasks have dependencies
2. **Parallel**: For independent tasks
3. **Phased**: Parallel within phases, sequential between
4. **Pipeline**: Continuous handoff between specialists

### Quality Gates
Always include quality agents in your workflow:
- Pre-commit: code-reviewer
- Pre-deploy: security-auditor + qa-tester
- Post-deploy: performance-engineer

### Documentation
- Keep docs in sync with tech-writer
- Create SPEC files before implementation
- Update architecture docs with principal-architect
- Generate API docs automatically

## Tool Access Reference

| Agent Type | Read | Write | Execute | Analyze | Deploy |
|------------|------|-------|---------|---------|--------|
| Implementation | ✓ | ✓ | ✓ | ✓ | ✗ |
| Analysis | ✓ | ✗ | ✓ | ✓ | ✗ |
| QA/Security | ✓ | ✗ | ✓ | ✓ | ✗ |
| Strategic | ✓ | ✓ | ✓ | ✓ | ✗ |
| Operations | ✓ | ✓ | ✓ | ✓ | ✓ |
| Documentation | ✓ | ✓ | ✗ | ✓ | ✗ |

## Conclusion

The Claude agent ecosystem provides specialized expertise for every aspect of software development. By selecting the right agents and coordinating them effectively, you can achieve higher quality results with better efficiency than using general-purpose agents alone.

Remember: **Always use the right agent for the right job, and don't hesitate to use multiple agents in parallel when appropriate.**