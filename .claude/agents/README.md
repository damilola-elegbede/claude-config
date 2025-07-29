# Claude Agent Ecosystem

## Overview
The Claude agent ecosystem consists of 40 specialized agents organized across 8 functional domains, providing comprehensive coverage of the software development lifecycle with sophisticated coordination patterns and parallel execution capabilities.

## Agent Categories

The agent ecosystem is organized into 8 primary categories. For detailed category definitions and color assignments, see [AGENT_CATEGORIES.md](./AGENT_CATEGORIES.md).

1. **Development** (blue) - Core programming and implementation
   - backend-engineer, frontend-engineer, mobile-engineer, ml-engineer, data-engineer, database-admin, database-migration-specialist, integration-specialist

2. **Infrastructure** (orange) - Systems, operations, and deployment
   - devops, cloud-architect, network-engineer

3. **Architecture** (purple) - System design and technical planning
   - api-architect, principal-architect

4. **Design** (purple) - User experience and interface design
   - ui-designer, mobile-ui

5. **Quality** (green) - Testing, review, and validation
   - test-engineer, performance-engineer, code-reviewer, accessibility-auditor

6. **Security** (red) - Security assessment and compliance
   - security-auditor, security-tester, agent-auditor

7. **Analysis** (yellow) - Research, documentation, and analysis
   - data-engineer, business-analyst, codebase-analyst, tech-writer, researcher

8. **Operations** (orange) - Support, coordination, and strategic planning
   - incident-commander, debugger, project-orchestrator, product-strategist, general-purpose

## Table of Contents
- [Agent Categories](#agent-categories)
- [Agent Directory](#agent-directory)
- [Quick Reference](#quick-reference)
- [Agent Selection Guide](#agent-selection-guide)
- [Coordination Patterns](#coordination-patterns)
- [Quality Gates](#quality-gates)
- [Best Practices](#best-practices)

## Agent Directory

### Development & Implementation Agents
- **backend-engineer** - Staff-level backend development (APIs, databases, microservices)
- **frontend-engineer** - Staff-level frontend development (React, Vue, Angular)
- **mobile-engineer** - iOS/Android native and cross-platform development
- **tech-lead** - Full-stack development with technical leadership
- **ml-engineer** - Machine learning models and AI/ML pipelines

### Quality & Testing Agents
- **test-engineer** - Test strategy, framework selection, coverage analysis
- **test-data-manager** - Test data generation, fixtures, privacy compliance
- **code-reviewer** - Pre-commit quality review, best practices validation
- **debugger** - Complex bug investigation, root cause analysis
- **security-auditor** - Security vulnerability assessment, compliance review
- **api-contract-tester** - API contract testing, OpenAPI/GraphQL schema validation

### Architecture & Design Agents
- **principal-architect** - System architecture, technical roadmaps, implementation plans
- **api-architect** - Comprehensive API architecture, design governance, and implementation
- **ui-designer** - Design systems, user experience, web/desktop interfaces
- **mobile-ui** - Mobile UI patterns, React Native, iOS/Android design
- **cloud-architect** - Cloud infrastructure design, scalability, cost optimization

### Operations & Infrastructure Agents
- **devops** - CI/CD pipelines, deployment automation, build systems
- **db-admin** - Database design, optimization, backup/recovery
- **network-engineer** - Network architecture, security, optimization, troubleshooting

### Analysis & Research Agents
- **codebase-analyst** - Code analysis, technical debt assessment
- **researcher** - External research, technology evaluation, best practices
- **business-analyst** - Requirements analysis, business logic, process mapping
- **data-engineer** - Data pipelines, ETL/ELT, data warehouse architecture
- **data-scientist** - Statistical analysis, ML model evaluation, experiment design

### Documentation & Support Agents
- **tech-writer** - Documentation, API docs, user guides, completion summaries
- **api-documenter** - Automated API documentation, OpenAPI/Swagger generation

### Coordination & Strategy Agents
- **project-orchestrator** - Multi-agent coordination for 2+ agent projects
- **product-strategist** - Product vision, roadmaps, feature prioritization
- **agent-auditor** - Agent ecosystem health, coverage gap analysis (auto-spawns multiple instances for >5 agents, max 5 agents per instance)

### Specialized Domain Agents
- **accessibility-auditor** - WCAG compliance, accessibility standards
- **arch-reviewer** - Architecture review process and decisions
- **fullstack-dev** - Full-stack coordination with quality gates
- **performance-engineer** - Performance optimization, load testing

## Quick Reference

### Command Shortcuts
```bash
/test         → test-engineer
/review       → code-reviewer
/security     → security-auditor
/perf         → performance-engineer
/docs         → tech-writer
/debug        → debugger
/orchestrate  → project-orchestrator
/context      → multiple codebase-analyst agents
```

### Core Rules
1. **Parallel by Default** - Always prioritize parallel execution
2. **Use project-orchestrator for 2+ agent projects**
3. **Multiple instances of same agent type are encouraged**
4. **Always use the right agent for the right job**

## Agent Selection Guide

### By Task Type

| Task | Primary Agent(s) | When to Use |
|------|-----------------|-------------|
| **Backend API Development** | backend-engineer | Server-side logic, databases, microservices |
| **Frontend Development** | frontend-engineer | Web UI, React/Vue/Angular, performance |
| **Mobile Development** | mobile-engineer | iOS/Android apps, React Native, Flutter |
| **System Architecture** | principal-architect | System design, technical roadmaps |
| **API Architecture** | api-architect | REST/GraphQL design, OpenAPI specs, implementation |
| **Bug Investigation** | debugger | Complex bugs, memory leaks, race conditions |
| **Code Quality Review** | code-reviewer | Pre-commit review, best practices |
| **Security Assessment** | security-auditor | Vulnerability assessment, OWASP compliance |
| **Performance Issues** | performance-engineer | Optimization, load testing, profiling |
| **Test Strategy** | test-engineer | Test planning, framework selection |
| **Documentation** | tech-writer | Technical docs, API docs, guides |
| **API Documentation** | api-documenter | OpenAPI/Swagger docs, endpoint reference |
| **Code Analysis** | codebase-analyst | Code search, dependency analysis |
| **Data Analysis** | data-scientist | Statistical analysis, A/B testing, ML evaluation |
| **Network Infrastructure** | network-engineer | Network design, routing, security, CDN |
| **API Contract Testing** | api-contract-tester | Schema validation, breaking change detection |
| **Multi-Agent Projects** | project-orchestrator | Coordinate 2+ agents |

### By Scale

| Scale | Required Agents |
|-------|----------------|
| **>100k users** | backend-engineer, frontend-engineer, principal-architect |
| **>10k requests/sec** | backend-engineer, performance-engineer, devops |
| **3+ microservices** | backend-engineer, api-architect, principal-architect |
| **2+ platforms** | Multiple mobile-engineer instances |
| **2+ agents needed** | project-orchestrator (mandatory) |

## Coordination Patterns

### 1. API Development Flow
```
api-architect → [backend-engineer + frontend-engineer] (parallel)
     ↓                    ↓                    ↓
API Implementation  Backend Services    Frontend Integration
```

### 2. Feature Development
```
principal-architect → project-orchestrator → [multiple specialists]
        ↓                      ↓                       ↓
  System design          Execution plan          Parallel work
```

### 3. Quality Gate Cascade
```
code-reviewer → test-engineer → security-auditor → production
      ↓               ↓                ↓
Code quality    Test coverage    Security check
```

### 4. Bug Resolution
```
test-engineer → debugger → developer → code-reviewer
      ↓            ↓           ↓            ↓
Find issue    Root cause    Fix impl    Validate
```

### 5. Performance Investigation
```
performance-engineer ←→ debugger ←→ backend-engineer
         ↓                  ↓              ↓
    Profiling          Analysis      Optimization
```

### 6. Multi-Platform Development
```
project-orchestrator
         ├── backend-engineer (APIs)
         ├── frontend-engineer (Web)
         ├── mobile-engineer #1 (iOS)
         └── mobile-engineer #2 (Android)
```

## Quality Gates

### Stage 1: Code Quality (code-reviewer)
- Style compliance
- Best practices
- Documentation
- Maintainability

### Stage 2: Test Coverage (test-engineer)
- Unit tests ≥ 80%
- Integration tests
- Edge cases
- Performance tests

### Stage 3: Security (security-auditor)
- OWASP Top 10
- Auth patterns
- Data handling
- Dependencies

### Stage 4: Performance (performance-engineer)
- Response times
- Resource usage
- Scalability
- Regression check

## Best Practices

### Parallel Execution
- **DO**: Launch multiple agents simultaneously when tasks are independent
- **DO**: Use multiple instances of the same agent for different components
- **DON'T**: Wait for one agent to finish before starting another unnecessarily

### Agent Selection
- **DO**: Use specialist agents for their domain (e.g., security-auditor for security)
- **DO**: Consult project-orchestrator for 2+ agent projects
- **DON'T**: Use generic agents when specialists exist

### Handoff Management
- **DO**: Provide clear context and artifacts between agents
- **DO**: Define explicit success criteria for each handoff
- **DON'T**: Assume agents will infer missing information

### Quality Integration
- **DO**: Run quality agents in parallel when possible
- **DO**: Establish clear pass/fail criteria
- **DON'T**: Skip quality gates for "simple" changes

### Common Patterns

#### Multiple Instances Pattern
```bash
# Analyzing large codebase
codebase-analyst #1: Backend analysis
codebase-analyst #2: Frontend analysis
codebase-analyst #3: Mobile analysis
codebase-analyst #4: Integration patterns
```

#### Parallel Quality Check
```bash
# Comprehensive review
code-reviewer: Code quality
security-auditor: Security issues
test-engineer: Test coverage
performance-engineer: Performance impact
```

#### Cross-Platform Development
```bash
# Building for multiple platforms
backend-engineer: Shared API
frontend-engineer: Web app
mobile-engineer #1: iOS app
mobile-engineer #2: Android app
```

#### Agent Ecosystem Audit
```bash
# Agent-auditor automatically scales based on total agents
# Rule: Maximum 5 agents per instance for focused analysis

Total agents: 26
Required instances: 6 (ceiling of 26/5)

agent-auditor #1: Agents 1-5
agent-auditor #2: Agents 6-10
agent-auditor #3: Agents 11-15
agent-auditor #4: Agents 16-20
agent-auditor #5: Agents 21-25
agent-auditor #6: Agents 26

# This pattern automatically scales:
# - 10 agents = 2 instances
# - 25 agents = 5 instances  
# - 50 agents = 10 instances
```

## Tool Permissions

| Permission Level | Agents | Allowed Tools |
|-----------------|--------|---------------|
| **full_access** | backend-engineer, frontend-engineer, tech-lead | All tools |
| **read_analysis** | code-reviewer, codebase-analyst | Read, Grep, Glob |
| **design_only** | principal-architect, ui-designer | Read, Write (specs) |
| **strategic** | project-orchestrator | Read, TodoWrite |

## Anti-Patterns to Avoid

### ❌ Sequential When Parallel is Possible
```bash
# WRONG
codebase-analyst → wait → codebase-analyst → wait

# RIGHT
codebase-analyst #1 + codebase-analyst #2 (parallel)
```

### ❌ Wrong Agent for the Job
```bash
# WRONG
devops for code review
backend-engineer for UI design

# RIGHT
code-reviewer for code review
ui-designer for UI design
```

### ❌ Skipping Orchestration
```bash
# WRONG (3+ agents without coordination)
Just launch all agents randomly

# RIGHT
project-orchestrator → coordinated execution plan
```

## Success Metrics
- **Coverage**: 95%+ of software development lifecycle
- **Clarity**: 100% clear agent naming and purpose
- **Coordination**: 10+ documented handoff patterns
- **Quality**: 4-stage quality gate process
- **Parallelism**: Default execution mode

## Additional Resources
- Individual agent documentation: See specific `.md` files
- Configuration: `~/.claude/settings.json`
- Project settings: `CLAUDE.md` in project root