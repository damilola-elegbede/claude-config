# Claude Agent Ecosystem

## Overview
The Claude agent ecosystem consists of 41 specialized agents organized across 8 functional domains, providing comprehensive coverage of the software development lifecycle.

## Agent Categories

The agent ecosystem is organized into 8 primary categories. For detailed category definitions and color assignments, see [AGENT_CATEGORIES.md](./AGENT_CATEGORIES.md).

### 1. **Development** (blue) - 7 agents
Core programming and implementation agents
- backend-engineer
- data-engineer
- database-migration-specialist
- frontend-engineer
- integration-specialist
- ml-engineer
- mobile-engineer

### 2. **Infrastructure** (orange) - 4 agents
Systems, operations, and deployment agents
- cloud-architect
- database-admin
- devops
- network-engineer

### 3. **Architecture** (purple) - 2 agents
System design and technical planning agents
- api-architect
- principal-architect

### 4. **Design** (pink) - 3 agents
User experience and interface design agents
- mobile-ui
- ui-designer
- ux-researcher

### 5. **Quality** (green) - 5 agents
Testing, review, and validation agents
- accessibility-auditor
- api-contract-tester
- code-reviewer
- performance-engineer
- test-engineer

### 6. **Security** (red) - 3 agents
Security assessment and compliance agents
- agent-auditor
- security-auditor
- security-tester

### 7. **Analysis** (yellow) - 7 agents
Research, documentation, and analysis agents
- api-documenter
- business-analyst
- codebase-analyst
- data-scientist
- log-analyst
- researcher
- tech-writer

### 8. **Operations** (orange) - 11 agents
Support, coordination, efficiency, and strategic planning agents
- config-specialist
- debugger
- dependency-manager
- documentation-finder
- error-resolver
- file-navigator
- file-writer
- git-workflow
- incident-commander
- product-strategist
- search-coordinator

## Table of Contents
- [Agent Categories](#agent-categories)
- [Agent Directory](#agent-directory)
- [Quick Reference](#quick-reference)
- [Agent Selection Guide](#agent-selection-guide)
- [Coordination Patterns](#coordination-patterns)
- [Quality Gates](#quality-gates)
- [Best Practices](#best-practices)

## Agent Directory

### Development & Implementation Agents (7)
- **backend-engineer** - Server-side systems, APIs, microservices, databases, and distributed architectures
- **frontend-engineer** - React/Vue/Angular apps, state management, and frontend optimization
- **mobile-engineer** - iOS/Android native apps, React Native, and Flutter development
- **ml-engineer** - ML model deployment, MLOps pipelines, and production ML systems
- **data-engineer** - Data pipelines, ETL/ELT systems, data warehouses, and stream processing
- **database-migration-specialist** - Database schema migrations, data migrations, and zero-downtime deployments
- **integration-specialist** - Third-party API integrations, webhooks, OAuth, and external services

### Infrastructure & DevOps Agents (4)
- **devops** - CI/CD pipelines, containerization, IaC, deployment automation, and SRE practices
- **cloud-architect** - Cloud architecture design, migration planning, and cost optimization
- **network-engineer** - Cloud networking, API gateways, load balancing, CDN setup, and DNS
- **database-admin** - Database optimization, security hardening, backup strategies, and tuning

### Architecture & Design Agents (4)
- **principal-architect** - System-wide architecture design, technical roadmaps, and coordination
- **api-architect** - API design, OpenAPI specs, governance policies, and SDK generation
- **ui-designer** - UI/UX design, visual hierarchy, and design systems
- **mobile-ui** - iOS Human Interface Guidelines and Android Material Design implementation

### Quality & Testing Agents (5)
- **test-engineer** - Test strategy, test implementation, execution, and quality assurance
- **code-reviewer** - Quality review, security checks, and best practices validation
- **performance-engineer** - Performance profiling, load testing, and bottleneck analysis
- **accessibility-auditor** - WCAG compliance audits, screen reader testing, and remediation
- **api-contract-tester** - API validation, breaking change detection, and contract tests

### Security & Compliance Agents (3)
- **security-auditor** - Security audits, vulnerability assessment, and compliance reviews
- **security-tester** - Penetration testing, security scanning, and automated testing
- **agent-auditor** - Agent ecosystem validation, compliance checking, and gap analysis

### Analysis & Documentation Agents (7)
- **codebase-analyst** - Code architecture analysis, technical debt assessment, dependency mapping
- **business-analyst** - Requirements gathering, stakeholder analysis, and process mapping
- **data-scientist** - Statistical analysis, A/B testing, ML evaluation, and data insights
- **researcher** - Technology evaluation, market analysis, and competitive research
- **tech-writer** - Documentation, READMEs, API docs, and work summaries
- **api-documenter** - API documentation generation, OpenAPI specs, and SDK docs
- **log-analyst** - Log analysis, pattern detection, anomaly identification, and debugging insights

### Operations & Efficiency Agents (11)
- **incident-commander** - Production incidents, outages, and crisis management
- **debugger** - Complex bug investigation, race conditions, and root cause analysis
- **product-strategist** - Product vision, feature prioritization, and go-to-market strategy
- **file-navigator** - Intelligent file system exploration with context-aware patterns
- **config-specialist** - Efficient configuration file management across projects
- **dependency-manager** - Unified package management across all package managers
- **documentation-finder** - Intelligent documentation search across all sources
- **error-resolver** - Automated error context gathering and fix suggestions
- **git-workflow** - Streamlined git operations with intelligent automation
- **search-coordinator** - Complex multi-pattern search orchestration
- **file-writer** - Batch file writing and template-based generation

## Quick Reference

### Command Shortcuts
```bash
/test         → test-engineer
/review       → code-reviewer
/security     → security-auditor
/perf         → performance-engineer
/docs         → tech-writer
/debug        → debugger
/context      → codebase-analyst
/find         → file-navigator
/deps         → dependency-manager
/git          → git-workflow
/config       → config-specialist
/error        → error-resolver
/search       → search-coordinator
/find-docs    → documentation-finder
/agent-audit  → agent-auditor
```

### Core Rules
1. **Use the right agent for the right job**
2. **Use project-orchestrator for complex multi-agent projects**
3. **Focus on outcomes over process**

## Agent Selection Guide

### By Task Type

| Task | Primary Agent(s) | When to Use |
|------|-----------------|-------------|
| **Backend API Development** | backend-engineer | Server-side logic, databases, microservices |
| **Frontend Development** | frontend-engineer | Web UI, React/Vue/Angular, performance |
| **Mobile Development** | mobile-engineer | iOS/Android apps, React Native, Flutter |
| **System Architecture** | principal-architect | System design, technical roadmaps |
| **API Architecture** | api-architect | REST/GraphQL design, OpenAPI specs |
| **Bug Investigation** | debugger | Complex bugs, memory leaks, race conditions |
| **Code Quality Review** | code-reviewer | Pre-commit review, best practices |
| **Security Assessment** | security-auditor | Vulnerability assessment, OWASP compliance |
| **Performance Issues** | performance-engineer | Optimization, load testing, profiling |
| **Test Strategy** | test-engineer | Test planning, framework selection |
| **Documentation** | tech-writer | Technical docs, API docs, guides |
| **API Documentation** | api-documenter | OpenAPI/Swagger docs, endpoint reference |
| **Code Analysis** | codebase-analyst | Code search, dependency analysis |
| **Data Analysis** | data-scientist | Statistical analysis, A/B testing, ML evaluation |
| **Log Analysis** | log-analyst | Log patterns, debugging, anomaly detection |
| **Network Infrastructure** | network-engineer | Network design, routing, security, CDN |
| **Database Management** | database-admin | Query optimization, backups, performance |
| **File Navigation** | file-navigator | Intelligent file search and exploration |
| **Package Management** | dependency-manager | npm, pip, cargo, go mod operations |
| **Error Diagnosis** | error-resolver | Automated error fixing suggestions |
| **Agent Ecosystem Health** | agent-auditor | Compliance, gaps, and ecosystem validation |

### By Scale

| Scale | Required Agents |
|-------|----------------|
| **>100k users** | backend-engineer, frontend-engineer, principal-architect |
| **>10k requests/sec** | backend-engineer, performance-engineer, devops |
| **3+ microservices** | backend-engineer, api-architect, principal-architect |
| **2+ platforms** | mobile-engineer |
| **Complex debugging** | debugger, log-analyst, error-resolver |
| **Full audit** | agent-auditor |

## Coordination Patterns

### 1. Full Stack Feature Development
```
principal-architect → [backend-engineer + frontend-engineer + mobile-engineer] (parallel)
         ↓                      ↓                    ↓                 ↓
    System design         API services           Web UI          Mobile apps
```

### 2. API Development Flow
```
api-architect → backend-engineer → api-documenter → api-contract-tester
      ↓                ↓                  ↓                ↓
  API design    Implementation      Documentation    Validation
```

### 3. Quality Gate Cascade
```
[code-reviewer + test-engineer + security-auditor] (parallel) → production
        ↓               ↓                ↓
  Code quality    Test coverage    Security check
```

### 4. Bug Resolution Pipeline
```
log-analyst → debugger → developer → code-reviewer
     ↓            ↓          ↓           ↓
Log patterns  Root cause   Fix impl   Validate
```

### 5. Performance Investigation
```
performance-engineer ← → log-analyst ← → backend-engineer
         ↓                    ↓               ↓
    Profiling            Patterns       Optimization
```

### 6. Multi-Platform Development
```
project-orchestrator
         ├── backend-engineer (APIs)
         ├── frontend-engineer (Web)
         ├── mobile-engineer #1 (iOS)
         └── mobile-engineer #2 (Android)
```

### 7. Agent Ecosystem Audit
```
agent-auditor instances (parallel by category):
         ├── agent-auditor #1 (Development agents)
         ├── agent-auditor #2 (Infrastructure agents)
         ├── agent-auditor #3 (Architecture agents)
         ├── agent-auditor #4 (Design agents)
         ├── agent-auditor #5 (Quality agents)
         ├── agent-auditor #6 (Security agents)
         ├── agent-auditor #7 (Analysis agents)
         └── agent-auditor #8 (Operations agents)
```

### 8. Efficiency Pattern
```
User query → [file-navigator + documentation-finder + search-coordinator] (parallel)
                    ↓                    ↓                    ↓
              Find files          Find docs          Search patterns
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

### Stage 5: Accessibility (accessibility-auditor)
- WCAG compliance
- Screen reader support
- Keyboard navigation
- Color contrast

## Best Practices

### Task Execution
- **DO**: Focus on completing assigned tasks efficiently
- **DO**: Use specialized tools for domain-specific work
- **DON'T**: Exceed your domain boundaries

### Agent Selection
- **DO**: Use specialist agents for their domain (e.g., log-analyst for log analysis)
- **DO**: Use efficiency agents (file-navigator, error-resolver) for common tasks
- **DO**: Use agent-auditor for file quality validation
- **DON'T**: Use generic approaches when specialists exist

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
accessibility-auditor: Accessibility compliance
```

#### Cross-Platform Development
```bash
# Building for multiple platforms
backend-engineer: Shared API
frontend-engineer: Web app
mobile-engineer #1: iOS app
mobile-engineer #2: Android app
```

#### Efficiency Boost Pattern
```bash
# Fast file and documentation access
file-navigator: Find relevant files
documentation-finder: Locate docs
search-coordinator: Complex searches
error-resolver: Fix common errors
```

## Tool Permissions

Agents are granted minimal necessary permissions following the principle of least privilege:

| Permission Level | Example Agents | Allowed Tools |
|-----------------|----------------|---------------|
| **Full Access** | backend-engineer, frontend-engineer | All tools |
| **Read & Analysis** | code-reviewer, codebase-analyst, log-analyst | Read, Grep, Glob |
| **Documentation** | tech-writer, api-documenter | Read, Write, Edit |
| **Efficiency** | file-navigator, search-coordinator | Read, Grep, Glob, LS |
| **Strategic** | product-strategist | Read, TodoWrite |

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
general analysis for log parsing

# RIGHT
code-reviewer for code review
ui-designer for UI design
log-analyst for log parsing
```

### ❌ Skipping Orchestration
```bash
# WRONG (3+ agents without coordination)
Just launch all agents randomly

# RIGHT
project-orchestrator → coordinated execution plan
```

### ❌ Single Agent Auditor for Large Ecosystem
```bash
# WRONG
agent-auditor (trying to audit 40+ agents alone)

# RIGHT
agent-auditor (focused file analysis)
```

## Success Metrics
- **Coverage**: 100% of software development lifecycle
- **Total Agents**: 41 specialized agents
- **Categories**: 8 distinct functional domains
- **Clarity**: 100% clear agent naming and purpose
- **Coordination**: 15+ documented handoff patterns
- **Quality**: 5-stage quality gate process
- **Parallelism**: Default execution mode
- **Efficiency**: Dedicated efficiency agents for common tasks

## Additional Resources
- Individual agent documentation: See specific `.md` files
- Category definitions: [AGENT_CATEGORIES.md](./AGENT_CATEGORIES.md)
- Audit protocols: [AUDIT_VERIFICATION_PROTOCOL.md](./AUDIT_VERIFICATION_PROTOCOL.md)
- Configuration: `~/.claude/settings.json`
