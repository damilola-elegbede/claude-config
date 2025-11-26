# Agent Selection Guide

Detailed decision trees and routing patterns for complex multi-agent scenarios.

## Quick Selection by Domain

### Development Agents

| Agent | Use When | Natural Language Triggers |
|-------|----------|---------------------------|
| backend-engineer | Server-side work, APIs, databases | "backend", "server", "api", "database" |
| frontend-engineer | UI work, React/Vue/Angular | "frontend", "ui", "component", "css" |
| frontend-architect | Complex frontend systems, micro-frontends | "frontend architecture", "state management" |
| fullstack-lead | End-to-end features spanning frontend/backend | "full feature", "end to end" |
| mobile-engineer | iOS, Android, React Native, Flutter | "mobile", "ios", "android", "app" |
| data-engineer | Data pipelines, ETL, analytics infrastructure | "pipeline", "etl", "data processing" |
| ml-engineer | ML models, training, MLOps | "model", "ml", "training", "inference" |

### Quality Agents

| Agent | Use When | Natural Language Triggers |
|-------|----------|---------------------------|
| code-reviewer | Any code changes need review | "review", "check", "look at" |
| test-engineer | Writing or improving tests | "test", "coverage", "spec" |
| security-auditor | Security concerns, vulnerabilities | "security", "vulnerability", "auth" |
| accessibility-auditor | WCAG compliance, a11y issues | "accessibility", "wcag", "screen reader" |
| performance-engineer | Slowness, optimization | "slow", "performance", "optimize" |

### Architecture Agents

| Agent | Use When | Natural Language Triggers |
|-------|----------|---------------------------|
| principal-architect | System-wide design, roadmaps | "architecture", "system design", "roadmap" |
| api-architect | API design, OpenAPI specs | "api design", "graphql schema", "rest api" |
| cloud-architect | AWS/GCP/Azure, multi-cloud | "cloud", "aws", "infrastructure" |
| database-admin | Query optimization, migrations | "database", "query", "migration" |

### Infrastructure Agents

| Agent | Use When | Natural Language Triggers |
|-------|----------|---------------------------|
| devops | CI/CD, Kubernetes, deployments | "deploy", "ci", "pipeline", "docker" |
| platform-engineer | Developer experience, internal tools | "platform", "developer tools", "internal" |

### Analysis Agents

| Agent | Use When | Natural Language Triggers |
|-------|----------|---------------------------|
| debugger | Something broken, crashes, bugs | "broken", "crash", "bug", "not working" |
| codebase-analyst | Understanding large codebases | "understand", "analyze", "how does this work" |
| researcher | Technology evaluation, best practices | "research", "compare", "what's best" |
| result-arbitrator | Conflicting findings from multiple agents | (internal use when agents disagree) |

### Design Agents

| Agent | Use When | Natural Language Triggers |
|-------|----------|---------------------------|
| ui-designer | UI/UX optimization, design systems | "design", "ux", "user interface" |
| mobile-ui | Mobile-specific UI patterns | "mobile ui", "ios design", "android design" |
| ux-researcher | User research, usability testing | "user research", "usability", "user feedback" |

### Documentation Agent

| Agent | Use When | Natural Language Triggers |
|-------|----------|---------------------------|
| tech-writer | Documentation, READMEs, API docs | "docs", "readme", "documentation" |

### Strategic Agents

| Agent | Use When | Natural Language Triggers |
|-------|----------|---------------------------|
| business-analyst | Requirements gathering | "requirements", "business needs" |
| product-strategist | Product direction, prioritization | "product", "prioritize", "roadmap" |
| project-orchestrator | Timeline, resource planning | "timeline", "planning", "coordination" |

## File Pattern Routing

| File Patterns | Primary Agent | Supporting Agents |
|---------------|---------------|-------------------|
| `*.test.*`, `*.spec.*`, `__tests__/` | test-engineer | code-reviewer |
| `Dockerfile`, `docker-compose.*` | devops | cloud-architect |
| `*.yaml` (k8s manifests) | devops | platform-engineer |
| `.github/workflows/*` | devops | - |
| `*.sql`, `migrations/` | database-admin | backend-engineer |
| `package.json`, `requirements.txt` | devops | security-auditor |
| `src/api/*`, `routes/*` | api-architect | backend-engineer |
| `src/components/*`, `*.tsx`, `*.vue` | frontend-engineer | ui-designer |
| `*.md` (documentation) | tech-writer | - |
| `.env*`, `*secret*`, `*auth*` | security-auditor | code-reviewer |
| `terraform/*`, `*.tf` | cloud-architect | devops |
| `*.py` (ML related) | ml-engineer | data-engineer |

## Multi-Agent Coordination Patterns

### Bug Fix Pattern

```text
User: "This is broken" / "There's a bug"

Deploy in parallel:
1. debugger - Investigate root cause
2. test-engineer - Create regression test
3. codebase-analyst - Understand affected areas

After fixes:
4. code-reviewer - Review the fix
```

### New Feature Pattern

```text
User: "Add a new feature" / "Implement X"

Deploy in sequence:
1. principal-architect - Design approach (if complex)
2. [relevant engineers] - Implementation
3. test-engineer - Write tests
4. code-reviewer + security-auditor - Review
5. tech-writer - Update docs (if needed)
```

### Performance Issue Pattern

```text
User: "This is slow" / "Optimize X"

Deploy in parallel:
1. performance-engineer - Profile and identify bottlenecks
2. backend-engineer OR frontend-engineer - Implement fixes
3. codebase-analyst - Understand system impact

After optimization:
4. test-engineer - Add performance tests
```

### Security Review Pattern

```text
User: "Check for security issues" / "Is this secure?"

Deploy in parallel:
1. security-auditor - Vulnerability scan
2. code-reviewer - Code quality check

If issues found:
3. backend-engineer OR frontend-engineer - Fix vulnerabilities
4. test-engineer - Add security tests
```

### Code Review Pattern

```text
User: "Review this" / "Check my code"

Deploy in parallel:
1. code-reviewer - Quality, patterns, best practices
2. security-auditor - Security vulnerabilities
3. test-engineer - Test coverage assessment
```

## Decision Tree: Complex Scenarios

### Multiple Domains Affected

When a task spans multiple domains, deploy agents for each:

```text
Task: "Add user authentication"

Domains: Backend + Frontend + Security + Database

Deploy:
- backend-engineer (API endpoints)
- frontend-engineer (login UI)
- security-auditor (auth security)
- database-admin (user schema)
- test-engineer (auth tests)
```

### Conflicting Agent Recommendations

When agents disagree:

1. Deploy `result-arbitrator` to synthesize findings
2. Present trade-offs to user if fundamental disagreement
3. Prioritize security > correctness > performance > style

### Unknown Task Type

If task doesn't match any pattern:

1. Deploy `codebase-analyst` to explore
2. Based on findings, route to appropriate specialists
3. Include `code-reviewer` for quality assurance

## Agent Capability Matrix

| Capability | Agents |
|------------|--------|
| Can write code | backend-engineer, frontend-engineer, fullstack-lead, mobile-engineer, data-engineer, ml-engineer, devops |
| Can review code | code-reviewer, security-auditor, performance-engineer |
| Can write tests | test-engineer, code-reviewer |
| Can design architecture | principal-architect, api-architect, cloud-architect, frontend-architect |
| Can write docs | tech-writer |
| Can debug | debugger, codebase-analyst |
| Can analyze | codebase-analyst, researcher, ux-researcher |

## Anti-Patterns to Avoid

| Anti-Pattern | Instead Do |
|--------------|------------|
| Single agent for complex task | Deploy 2+ agents in parallel |
| Only implementation, no review | Always include quality agent |
| Security as afterthought | Include security-auditor for sensitive code |
| No tests with new code | Always pair with test-engineer |
| Guess which agent | Use routing table in CLAUDE.md |
