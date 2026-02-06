# Agent Inventory

Post-optimization inventory of 12 agents (consolidated from 31).

## Summary

| Category | Count | Model |
|----------|-------|-------|
| Development | 3 | Sonnet |
| Architecture | 1 | Opus |
| Quality | 4 | Sonnet |
| Infrastructure | 2 | Sonnet |
| Research | 1 | Sonnet |
| Documentation | 1 | Sonnet |
| **Total** | **12** | |

## All Agents (12)

| Agent | Category | Description | Key Triggers |
|-------|----------|-------------|--------------|
| accessibility-auditor | quality | WCAG compliance, screen reader testing | accessibility, a11y, wcag, aria |
| architect | architecture | System, API, cloud, frontend architecture | architecture, system design, api, cloud |
| backend-engineer | development | Server-side, microservices, distributed | backend, server, api, microservice |
| career-assistant | resume-toolkit | JD analysis, resume, career strategy | resume, ats, cover letter, career |
| code-reviewer | quality | Code review, security | review, check, audit |
| data-engineer | development | ETL pipelines, database admin | pipeline, etl, database, query |
| debugger | infrastructure | Bug investigation, performance | fix, broken, bug, error, slow |
| devops | infrastructure | CI/CD, Kubernetes, IaC, platform | deploy, ci/cd, pipeline, docker, k8s |
| frontend-engineer | development | UI components, design systems | frontend, ui, component, react, design |
| researcher | research | Tech research, codebase analysis | research, compare, analyze, evaluate |
| security-auditor | quality | Security audits, compliance | security, vulnerability, auth |
| tech-writer | documentation | READMEs, API docs, architecture | docs, readme, documentation |
| test-engineer | quality | Test strategy, automation | test, spec, coverage |

## Consolidation Details

| New Agent | Absorbed From |
|-----------|---------------|
| architect | principal-architect, api-architect, cloud-architect, frontend-architect |
| career-assistant | jd-analyzer, resume-optimizer, content-writer, career-strategist, company-researcher, application-tracker |
| code-reviewer | code-reviewer |
| data-engineer | data-engineer, database-admin |
| debugger | debugger, performance-engineer |
| devops | devops, platform-engineer |
| frontend-engineer | frontend-engineer, ui-designer |
| researcher | researcher, codebase-analyst, ux-researcher, business-analyst, product-strategist |

## Restored Agents

| Agent | Reason |
|-------|--------|
| accessibility-auditor | Specialized WCAG expertise warranted dedicated agent |

## Removed (18 agents)

Functionality covered by consolidated agents or Claude directly:

- principal-architect → architect
- api-architect → architect
- cloud-architect → architect
- frontend-architect → architect
- database-admin → data-engineer
- codebase-analyst → researcher
- ux-researcher → researcher
- business-analyst → researcher
- product-strategist → researcher
- performance-engineer → debugger
- platform-engineer → devops
- ui-designer → frontend-engineer
- jd-analyzer → career-assistant
- resume-optimizer → career-assistant
- fullstack-lead → (use backend + frontend)
- mobile-engineer → (removed, add if needed)
- ml-engineer → (removed, add if needed)
- project-orchestrator → (Claude orchestrates)
- result-arbitrator → (Claude arbitrates)
