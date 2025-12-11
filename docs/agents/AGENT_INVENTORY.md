# Agent Inventory

Post-optimization inventory of 31 agents (reduced from 37).

## Summary

| Category | Count | Model |
|----------|-------|-------|
| Development | 7 | Sonnet |
| Architecture | 4 | Sonnet/Opus |
| Quality | 4 | Sonnet |
| Infrastructure | 4 | Sonnet |
| Design | 2 | Sonnet |
| Analysis | 4 | Sonnet/Opus |
| Resume/Career | 3 | Sonnet |
| Coordination | 2 | Opus |
| Documentation | 1 | Sonnet |
| **Total** | **31** | |

## Development Agents (7)

| Agent | Description | Triggers |
|-------|-------------|----------|
| backend-engineer | Server-side architecture, microservices | backend, server, api, microservice |
| frontend-engineer | UI components, React/Vue | frontend, ui, component, react, vue |
| fullstack-lead | End-to-end features | fullstack, full stack, end to end |
| mobile-engineer | iOS/Android development | mobile, ios, android, app |
| data-engineer | ETL pipelines, data warehousing | pipeline, etl, data processing |
| ml-engineer | ML models, MLOps | ml, machine learning, model |
| test-engineer | Testing strategy, automation | test, spec, coverage |

## Architecture Agents (4)

| Agent | Description | Triggers | Model |
|-------|-------------|----------|-------|
| principal-architect | Strategic system design | architecture, system design | Opus |
| api-architect | REST/GraphQL design | api, endpoint, graphql, rest | Sonnet |
| cloud-architect | Multi-cloud, IaC | aws, azure, gcp, cloud | Sonnet |
| frontend-architect | Micro-frontends, state mgmt | frontend architecture | Sonnet |

## Quality Agents (4)

| Agent | Description | Triggers |
|-------|-------------|----------|
| code-reviewer | Pre-commit reviews, security | review, check, audit |
| accessibility-auditor | WCAG compliance | accessibility, a11y, wcag |
| performance-engineer | Optimization | slow, performance, optimize |
| debugger | Root cause analysis | fix, broken, bug, error |

## Infrastructure Agents (4)

| Agent | Description | Triggers |
|-------|-------------|----------|
| devops | CI/CD, Kubernetes | deploy, ci, pipeline, docker, k8s |
| platform-engineer | Internal tooling, DX | platform, internal tools, dx |
| database-admin | DB performance, migrations | database, query, migration, sql |
| security-auditor | Vulnerability assessment | security, vulnerability, auth |

## Design Agents (2)

| Agent | Description | Triggers |
|-------|-------------|----------|
| ui-designer | UI/UX design, mobile | design, ux, ui, mobile ui |
| ux-researcher | User research | user research, usability |

## Analysis Agents (4)

| Agent | Description | Triggers | Model |
|-------|-------------|----------|-------|
| codebase-analyst | Architecture assessment | how does this work, analyze | Sonnet |
| researcher | Technology evaluation | research, compare, options | Sonnet |
| business-analyst | Requirements gathering | requirements, business needs | Sonnet |
| result-arbitrator | Conflict resolution | conflicting, synthesize | Opus |

## Resume/Career Agents (3)

| Agent | Description | Triggers |
|-------|-------------|----------|
| resume-optimizer | ATS optimization, PDF parsing | resume, ats, optimize |
| jd-analyzer | Job description parsing | job description, jd |
| career-assistant | Career support, cover letters | cover letter, career, interview |

## Coordination Agents (2)

| Agent | Description | Triggers | Model |
|-------|-------------|----------|-------|
| project-orchestrator | Timeline planning | timeline, planning, schedule | Opus |
| product-strategist | Product vision | product, prioritize, roadmap | Sonnet |

## Documentation Agent (1)

| Agent | Description | Triggers |
|-------|-------------|----------|
| tech-writer | Documentation, READMEs | docs, documentation, readme |

## Removed Agents (7)

The following agents were consolidated:

| Removed | Merged Into |
|---------|-------------|
| ats-auditor | resume-optimizer |
| resume-parser | resume-optimizer |
| content-writer | career-assistant |
| career-strategist | career-assistant |
| application-tracker | career-assistant |
| company-researcher | career-assistant |
| mobile-ui | ui-designer |

## Routing Keywords

Complete routing table in `system-configs/CLAUDE.md`.
