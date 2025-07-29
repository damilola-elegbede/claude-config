# Agent Selection Guide - Consolidated System

## Quick Reference Decision Matrix

### Implementation Tasks (Consolidated)

| Task Complexity | Domain | Agent Choice | Key Indicators | Consolidation Notes |
|---|---|---|---|---|
| **Staff Level** | Backend | `backend-engineer` | Multi-service architecture, complex state management, performance < 2.5s | Renamed from backend-staff |
| **Staff Level** | Frontend | `frontend-engineer` | Real-time features, complex UI, Core Web Vitals optimization | Renamed from frontend-staff |
| **Senior Level** | General | `fullstack-lead` | Single-service features, well-defined APIs, standard patterns | Unchanged |
| **Specialist** | Mobile Development | `mobile-engineer` | Native/cross-platform apps, platform-specific features | Renamed from mobile-dev |
| **Specialist** | Mobile UI/UX | `mobile-ui` | iOS/Android design, platform-specific patterns | Renamed from mobile-designer |
| **Specialist** | Web Design | `ui-designer` | Design systems, visual hierarchy, web/desktop interfaces | Unchanged |

### Analysis & Review Tasks

| Task Type | Scope | Agent Choice | Key Indicators |
|---|---|---|---|
| **Internal Code Analysis** | Existing codebase | `codebase-analyst` | Architecture assessment, technical debt, executive summary |
| **External Research** | Industry/technology | `researcher` | Technology comparison, standards, competitive analysis | Absorbed tech-researcher |
| **Security Review** | Security-focused | `security-auditor` | OWASP compliance, vulnerability assessment |
| **Code Quality** | Pre-commit | `code-reviewer` | Style, best practices, PR readiness |
| **Testing Strategy** | Test coverage | `test-engineer` | Framework selection, test architecture, comprehensive QA | Absorbed qa-engineer capabilities |
| **Complex Debugging** | Mystery bugs | `debugger` | Intermittent failures, performance degradation |
| **Performance Analysis** | System performance | `performance-engineer` | Load testing, optimization, benchmarking |

### Strategic & Planning Tasks

| Planning Level | Scope | Agent Choice | Key Indicators |
|---|---|---|---|
| **System Architecture** | Multi-service | `principal-architect` | Technical roadmaps, architecture decisions |
| **Product Strategy** | Business features | `product-strategist` | Feature prioritization, user experience |
| **Project Coordination** | Multi-agent | `project-orchestrator` | Progress tracking, parallel execution |
| **Documentation** | Knowledge transfer | `tech-writer` | API docs, technical writing, project summaries, doc updates | Absorbed doc-updater + completion-agent |
| **API Design** | API governance | `api-architect` | OpenAPI specs, contract testing, API strategy, full lifecycle | Consolidated from api-designer + api-engineer |

### Infrastructure & Operations Tasks

| Task Type | Focus Area | Agent Choice | Key Indicators |
|---|---|---|---|
| **Deployment Automation** | CI/CD pipelines | `devops` | Build pipelines, infrastructure provisioning |
| **Production Reliability** | SRE practices | `platform-engineer` | Monitoring, alerting, observability, site reliability | Consolidated from sre-engineer + reliability-engineer |
| **Performance Optimization** | System performance | `performance-engineer` | Load testing, benchmarking, optimization |

## Escalation Decision Trees

### Implementation Escalation Path
```
Task Request → fullstack-lead → [complexity assessment] → staff agents → principal-architect
```

### Quality Assurance Workflow
```
Code Complete → code-reviewer → [parallel: security-auditor, qa-tester] → implementation agents
```

### Analysis Request Flow
```
Analysis Need → codebase-analyst → [domain-specific agents] → principal-architect
```

## Complexity Thresholds

### Staff Agent Triggers
- **Backend Engineer**: 100k+ requests/sec, microservices coordination, distributed state
- **Frontend Engineer**: Real-time data (WebSocket/SSE), complex state management, performance optimization
- **Principal Architect**: Cross-team coordination, system design changes, technology stack decisions

### Senior Agent Boundaries
- **Fullstack Lead**: Single service, established patterns, clear requirements
- **Stays Autonomous**: Implementation details, coding patterns, testing strategies
- **Escalates When**: Architecture changes, new dependencies, breaking changes

### Specialist Agent Scope
- **Mobile UI**: iOS HIG compliance, Android Material Design, touch interfaces
- **UI Designer**: Web/desktop only, design systems, visual hierarchy
- **Security Auditor**: OWASP Top 10, penetration testing, compliance
- **QA Engineer**: Test strategy, framework setup, coverage analysis

## Parallel Execution Groups

### Development Workflow
- **Primary**: `frontend-engineer` + `backend-dev` + `fullstack-lead`
- **Quality**: `code-reviewer` + `security-auditor` + `qa-tester`
- **Design**: `ui-designer` + `mobile-ui` (cross-platform consistency)

### Analysis Workflow  
- **Technical**: `codebase-analyst` + `debugger` + `security-auditor` + `performance-engineer`
- **Research**: `researcher` + `codebase-analyst` (external context + internal analysis)
- **Strategic**: `principal-architect` + `product-strategist` + `project-orchestrator`
- **Infrastructure**: `devops` + `platform-engineer` (deployment + monitoring)
- **Documentation**: `tech-writer` + any domain expert

## Tool Access Categories

| Access Level | Agents | Capabilities |
|---|---|---|
| **Full Access** | backend-dev, frontend-engineer, fullstack-lead | All tools for implementation |
| **Read + Analysis** | codebase-analyst, security-auditor, debugger | Read tools + analysis + TodoWrite |
| **Orchestration** | principal-architect, project-orchestrator | Full access + project management |
| **Documentation** | tech-writer | Read/write + documentation tools |
| **Design** | ui-designer, mobile-ui | Read/write for design specs |

## Common Anti-Patterns to Avoid

### ❌ Wrong Agent Selection
- Using `fullstack-lead` for architecture decisions → Use `principal-architect`
- Using `ui-designer` for mobile apps → Use `mobile-ui`
- Using `codebase-analyst` for implementation → Use implementation agents
- Using `debugger` for new feature bugs → Use `fullstack-lead` or staff agents
- Using `researcher` for internal code analysis → Use `codebase-analyst`
- Using `devops` for production monitoring → Use `platform-engineer`
- Using `general-purpose` for API design → Use `api-engineer`

### ❌ Missing Parallel Opportunities
- Sequential code review → Run `code-reviewer` + `security-auditor` + `qa-tester` in parallel
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

**Use this guide to ensure optimal agent selection for maximum efficiency and quality.**