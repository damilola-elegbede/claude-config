# Agent Selection Guide - Consolidated System

## Quick Reference Decision Matrix

### Implementation Tasks (Consolidated)

| Task Complexity | Domain | Agent Choice | Key Indicators | Consolidation Notes |
|---|---|---|---|---|
| **Staff Level** | Backend | `backend-engineer` | Multi-service architecture, complex state management, performance < 2.5s | Consolidated from backend-staff |
| **Staff Level** | Frontend | `frontend-architect` | Real-time features, complex UI, Core Web Vitals optimization | Consolidated from frontend-staff |
| **Senior Level** | General | `fullstack-lead` | Single-service features, well-defined APIs, standard patterns | Legacy fullstack capabilities |
| **Specialist** | Mobile Development | `mobile-platform-engineer` | Native/cross-platform apps, iOS/Android patterns | Unified mobile platform development |
| **Specialist** | Web Design | `ui-designer` | Design systems, visual hierarchy, web/desktop interfaces | Non-mobile interface design |

### Analysis & Review Tasks

| Task Type | Scope | Agent Choice | Key Indicators |
|---|---|---|---|
| **Internal Code Analysis** | Existing codebase | `codebase-analyst` | Architecture assessment, technical debt, executive summary |
| **Security Review** | Security-focused | `security-auditor` | OWASP compliance, vulnerability assessment |
| **Code Quality** | Pre-commit | `code-reviewer` | Style, best practices, PR readiness |
| **Testing Strategy** | Test coverage | `test-engineer` | Framework selection, test architecture, comprehensive QA |
| **Complex Debugging** | Mystery bugs | `debugger` | Intermittent failures, performance degradation |
| **Performance Analysis** | System performance | `performance-specialist` | Load testing, optimization, benchmarking |

### Strategic & Planning Tasks

| Planning Level | Scope | Agent Choice | Key Indicators |
|---|---|---|---|
| **System Architecture** | Multi-service | `principal-architect` | Technical roadmaps, architecture decisions |
| **Project Coordination** | Multi-agent | `project-orchestrator` | Progress tracking, parallel execution |
| **Documentation** | Knowledge transfer | `tech-writer` | API docs, technical writing, project summaries, doc updates |
| **API Design** | API governance | `api-architect` | OpenAPI specs, contract testing, API strategy, full lifecycle |

### Infrastructure & Operations Tasks

| Task Type | Focus Area | Agent Choice | Key Indicators |
|---|---|---|---|
| **Deployment Automation** | CI/CD pipelines | `devops` | Build pipelines, infrastructure provisioning |
| **Production Reliability** | SRE practices | `platform-engineer` | Monitoring, alerting, observability, site reliability |
| **Performance Optimization** | System performance | `performance-specialist` | Load testing, benchmarking, optimization |

## Escalation Decision Trees

### Implementation Escalation Path

```mermaid
Task Request → fullstack-lead → [complexity assessment] → staff agents → principal-architect
```

### Quality Assurance Workflow

```mermaid
Code Complete → code-reviewer → [parallel: security-auditor, test-engineer] → implementation agents
```

### Analysis Request Flow

```mermaid
Analysis Need → codebase-analyst → [domain-specific agents] → principal-architect
```

## Complexity Thresholds

### Staff Agent Triggers

- **Backend Engineer**: 100k+ requests/sec, microservices coordination, distributed state
- **Frontend Architect**: Real-time data (WebSocket/SSE), complex state management, performance optimization
- **Principal Architect**: Cross-team coordination, system design changes, technology stack decisions

### Senior Agent Boundaries

- **Fullstack Lead**: Single service, established patterns, clear requirements
- **Stays Autonomous**: Implementation details, coding patterns, testing strategies
- **Escalates When**: Architecture changes, new dependencies, breaking changes

### Specialist Agent Scope

- **Mobile Platform Engineer**: iOS/Android native apps, React Native, Flutter development
- **UI Designer**: Web/desktop only, design systems, visual hierarchy
- **Security Auditor**: OWASP Top 10, penetration testing, compliance
- **test-engineer**: Test strategy, framework setup, coverage analysis

## Parallel Execution Groups

### Development Workflow

- **Primary**: `frontend-architect` + `backend-engineer` + `fullstack-lead`
- **Quality**: `code-reviewer` + `security-auditor` + `test-engineer`
- **Design**: `ui-designer` (cross-platform consistency)

### Analysis Workflow

- **Technical**: `codebase-analyst` + `debugger` + `security-auditor` + `performance-specialist`
- **Strategic**: `principal-architect` + `project-orchestrator`
- **Infrastructure**: `devops` + `platform-engineer` (deployment + monitoring)
- **Documentation**: `tech-writer` + any domain expert

## Tool Access Categories

| Access Level | Agents | Capabilities |
|---|---|---|
| **Full Access** | backend-engineer, frontend-architect, fullstack-lead | All tools for implementation |
| **Read + Analysis** | codebase-analyst, security-auditor, debugger | Read tools + analysis + TodoWrite |
| **Orchestration** | principal-architect, project-orchestrator | Full access + project management |
| **Documentation** | tech-writer | Read/write + documentation tools |
| **Design** | ui-designer | Read/write for design specs |

## Common Anti-Patterns to Avoid

### ❌ Wrong Agent Selection

- Using `fullstack-lead` for architecture decisions → Use `principal-architect`
- Using `ui-designer` for mobile apps → Use `mobile-platform-engineer`
- Using `codebase-analyst` for implementation → Use implementation agents
- Using `debugger` for new feature bugs → Use `fullstack-lead` or staff agents
- Using `devops` for production monitoring → Use `platform-engineer`

### ❌ Missing Parallel Opportunities

- Sequential code review → Run `code-reviewer` + `security-auditor` + `test-engineer` in parallel
- Single-threaded analysis → Use multiple analysis agents concurrently
- Independent implementation → Parallel frontend/backend development

### ❌ Incorrect Escalation

- Staff agents for simple tasks → Start with `fullstack-lead`
- No escalation for complex decisions → Use proper escalation paths
- Skipping domain specialists → Leverage expert knowledge

## Quick Decision Prompts

**Before selecting an agent, ask:**

1. **Complexity**: Staff-level complexity or senior-level execution?
2. **Domain**: Technical implementation, analysis, strategy, or design?
3. **Scope**: Single service, multi-service, or system-wide?
4. **Parallelization**: Can this work run concurrently with other tasks?
5. **Specialization**: Does this need domain-specific expertise?
