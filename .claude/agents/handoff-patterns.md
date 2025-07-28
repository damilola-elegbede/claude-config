# Cross-Agent Handoff Patterns

## Overview
This document defines standard handoff patterns between agents, ensuring smooth coordination and clear responsibility transitions across the agent ecosystem.

## Core Handoff Principles

1. **Clear Trigger Points**: Each handoff has explicit conditions
2. **Context Preservation**: Critical information passes between agents
3. **No Responsibility Gaps**: Every scenario has a clear owner
4. **Parallel Opportunities**: Independent handoffs can run concurrently
5. **Feedback Loops**: Results flow back when needed

## Common Handoff Patterns

### 1. API Design → Implementation
```mermaid
api-engineer → backend-dev → frontend-engineer
```
**Trigger**: API specification complete
**Context Passed**: OpenAPI spec, performance requirements, security constraints
**Example**:
```yaml
handoff:
  from: api-engineer
  to: [backend-dev, frontend-engineer]
  artifacts:
    - openapi-spec.yaml
    - performance-requirements.md
    - security-guidelines.md
  parallel: true
```

### 2. Analysis → Implementation
```mermaid
codebase-analyst → [backend-dev | frontend-engineer | mobile-ui]
```
**Trigger**: Analysis reveals improvement opportunities
**Context Passed**: Current state analysis, recommendations, impact assessment
**Example**:
```yaml
handoff:
  from: codebase-analyst
  to: backend-dev
  artifacts:
    - performance-bottlenecks.md
    - refactoring-recommendations.md
    - dependency-analysis.json
```

### 3. Design → Development
```mermaid
ui-designer → frontend-engineer → qa-tester
```
**Trigger**: Design specifications approved
**Context Passed**: Figma links, design tokens, interaction specifications
**Example**:
```yaml
handoff:
  from: ui-designer
  to: frontend-engineer
  artifacts:
    - design-system-tokens.json
    - component-specifications.md
    - interaction-patterns.md
  subsequent: qa-tester
```

### 4. Quality Gate Cascade
```mermaid
code-reviewer → qa-tester → security-auditor → deployment
```
**Trigger**: Code ready for review
**Context Passed**: Review results cascade forward
**Example**:
```yaml
handoff:
  sequence:
    - agent: code-reviewer
      output: review-report.md
    - agent: qa-tester
      input: review-report.md
      output: test-results.json
    - agent: security-auditor
      input: [review-report.md, test-results.json]
      output: security-clearance.md
```

### 5. Performance Investigation
```mermaid
performance-engineer ←→ debugger ←→ backend-dev
```
**Trigger**: Performance anomaly detected
**Context Passed**: Metrics, profiling data, reproduction steps
**Example**:
```yaml
handoff:
  from: performance-engineer
  to: debugger
  bidirectional: true
  artifacts:
    - performance-metrics.json
    - profiling-results.flame
    - reproduction-steps.md
```

### 6. Security Incident Response
```mermaid
security-auditor → [backend-dev + frontend-engineer + devops]
```
**Trigger**: Security vulnerability discovered
**Context Passed**: Vulnerability details, remediation plan, priority
**Example**:
```yaml
handoff:
  from: security-auditor
  to: [backend-dev, frontend-engineer, devops]
  priority: critical
  parallel: true
  artifacts:
    - vulnerability-report.md
    - remediation-plan.md
    - test-cases.yaml
```

### 7. Architecture Planning
```mermaid
principal-architect → project-orchestrator → [multiple agents]
```
**Trigger**: Architecture plan approved
**Context Passed**: Architecture decisions, implementation plan, agent assignments
**Example**:
```yaml
handoff:
  from: principal-architect
  to: project-orchestrator
  artifacts:
    - architecture-design.md
    - implementation-roadmap.md
    - agent-assignments.yaml
```

### 8. Documentation Flow
```mermaid
[any agent] → tech-writer → code-reviewer
```
**Trigger**: Feature complete, needs documentation
**Context Passed**: Technical details, API changes, user impact
**Example**:
```yaml
handoff:
  from: backend-dev
  to: tech-writer
  artifacts:
    - api-changes.md
    - technical-details.md
    - usage-examples.md
```

### 9. Mobile Platform Coordination
```mermaid
mobile-ui → [backend-dev + platform-engineer]
```
**Trigger**: Mobile-specific backend needs identified
**Context Passed**: Mobile constraints, API requirements, performance needs
**Example**:
```yaml
handoff:
  from: mobile-ui
  to: [backend-dev, platform-engineer]
  artifacts:
    - mobile-constraints.md
    - api-requirements.md
    - offline-sync-needs.md
```

### 10. Data Pipeline Integration
```mermaid
data-engineer ←→ ml-engineer ←→ backend-dev
```
**Trigger**: ML model needs data pipeline or serving infrastructure
**Context Passed**: Data schemas, feature requirements, serving needs
**Example**:
```yaml
handoff:
  from: ml-engineer
  to: data-engineer
  bidirectional: true
  artifacts:
    - feature-requirements.md
    - data-schemas.json
    - training-pipeline-spec.yaml
```

## Handoff Implementation

### Standard Handoff Format
```typescript
interface Handoff {
  from: AgentType;
  to: AgentType | AgentType[];
  trigger: string;
  priority: 'low' | 'medium' | 'high' | 'critical';
  artifacts: string[];
  context: {
    summary: string;
    requirements: string[];
    constraints: string[];
    deadline?: Date;
  };
  parallel?: boolean;
  bidirectional?: boolean;
}
```

### Handoff Checklist
- [ ] Clear trigger condition defined
- [ ] All necessary artifacts identified
- [ ] Context requirements documented
- [ ] Priority level assigned
- [ ] Parallel execution possibility evaluated
- [ ] Feedback mechanism established

## Anti-Patterns to Avoid

### 1. Circular Dependencies
❌ **Bad**: A → B → C → A
✅ **Good**: A → B → C (with feedback to A)

### 2. Missing Context
❌ **Bad**: "Just implement this"
✅ **Good**: Detailed specifications with requirements

### 3. Unclear Ownership
❌ **Bad**: "Someone should handle this"
✅ **Good**: Explicit agent assignment with rationale

### 4. Sequential When Parallel Possible
❌ **Bad**: A → B → C → D (all independent)
✅ **Good**: A → [B, C, D] (parallel execution)

## Monitoring and Optimization

### Handoff Metrics
- Average handoff time
- Context loss frequency
- Rework due to poor handoffs
- Parallel execution utilization

### Continuous Improvement
- Regular handoff pattern reviews
- Feedback from agent interactions
- Optimization of artifact formats
- Automation of common handoffs