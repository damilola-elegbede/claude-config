# /plan Command

## Description

Generates Product Requirements Document (PRD) and PR-based task files with 
agent assignments. Never guesses unclear requirements - asks for clarification 
while staying in plan mode.

## Usage

```bash
/plan <task_description>             # Standard mode
/plan -s <task_description>          # Simple mode (single PR)
/plan --simple <task_description>    # Simple mode (single PR)
/plan -f <file_path>                 # Read from file
/plan --file <file_path>             # Read from file
```

## Command Execution Flow

1. Enter plan mode
2. Analyze requirements, ask clarification if needed
3. Generate PRD preview
4. Wait for approval (yes/no/modify)
5. Create files in `.tmp/<feature-name>/` only after approval

## Plan Preview Format

PRD preview shows:

- Executive Summary
- Implementation Phases with PR counts
- Key Requirements
- Approval prompt

## File Structure

### Generated Files

- `prd.md` - Product Requirements Document
- `phase_X_pr_Y_<description>.md` - PR implementation files
- `rollback.md` - Rollback procedures (if needed)

### PRD Contents

- Executive Summary
- Business Objectives & Scope
- Technical Requirements
- Implementation Phases
- Success Metrics & Risks
- Dependencies & Timeline

### Phase Organization

Phases are organized with clear dependencies:

- Phase 1: Foundation (infrastructure, contracts)
- Phase 2: Implementation (features, logic)
- Phase 3: Integration (connections, validation)

### Phase Files (Auto-Generated)

Each PR file contains tasks with:

- **Task ID**: `Task_X_Y_ZZ` format
- **Assignees**: Specialized agents
- **Execution**: Independent/Concurrent/Depends
- **Technical Details**: Implementation steps
- **Testing**: Acceptance criteria

## Clarification Protocol

**Never guess requirements.** When unclear:

- Present what's understood
- Ask specific questions
- Stay in plan mode awaiting answers
- Generate PRD only after clarity

Example ambiguities:

- "Make it faster" → Ask for specific metrics
- "Add search" → Ask scope, volume, features needed
- "Integrate API" → Ask which API, what operations

## Task Breakdown Logic

### Granularity Framework

Each PR contains **3-5 granular tasks** (1-8 hours each) following this hierarchy:

- **Phase 1**: Infrastructure (schema, APIs, configs)
- **Phase 2**: Implementation (logic, endpoints, components)  
- **Phase 3**: Integration (testing, docs, deployment)

### Breakdown Patterns

```yaml
Backend: Schema → Service → Controller → Validation → Tests
Frontend: Design → Component → State → Styling → Tests  
Infrastructure: Config → Build → Deploy → Monitor → Rollback
Database: Schema → Migration → Rollback → Validation → Performance
API: Contract → Implementation → Security → Testing → Docs
```

## Dependency Analysis Framework

### Dependency Types

- **Hard Dependencies**: Schema → Code, API → Frontend, Infrastructure → Deployment
- **Soft Dependencies**: Frontend/Backend (shared API), Testing/Implementation (parallel)
- **Independent**: Separate services, components, infrastructure, test suites

### Execution Rules

```yaml
Sequential: Foundation → Implementation → Integration
Parallel: Independent components, Frontend+Backend (post-API), Testing+Implementation
Coordination: API contracts, schema approval, integration checkpoints
```

## Agent Assignment Rules

### Assignment Matrix

```yaml
Infrastructure: database-admin, database-evolution-specialist, api-architect, 
  devops, monitoring-specialist, security-auditor
Implementation: backend-engineer, frontend-architect, mobile-platform-engineer, 
  ui-designer
Quality: code-reviewer, security-auditor, performance-specialist, test-engineer, 
  accessibility-auditor
Technology: React/Vue→frontend-architect, Node/Python→backend-engineer, 
  K8s→kubernetes-admin, Auth→security-auditor
```

### Priority Rules

1. **Security-First**: Auth/security → security-auditor (always)
2. **Specialist-Preferred**: Domain experts for specialized tech  
3. **Multi-Agent**: Complex tasks get primary + secondary + quality agents

## Execution Sequencing

### Task Types

- **Independent**: Start immediately, full parallel (separate services/components)
- **Concurrent**: Parallel with coordination (Frontend/Backend shared API)  
- **Depends**: Sequential execution (Migration before code, API before implementation)

### Sequencing Patterns

```yaml
Phase_1: Schema, API contracts, infrastructure (Independent within phase)
Phase_2: Backend/Frontend services (Concurrent), migrations (Depends on schema)
Phase_3: E2E testing (Depends on implementation), docs (Concurrent with testing)
```

## Agent Patterns

- **Features**: backend-engineer + frontend-architect + test-engineer
- **Bug fixes**: debugger → specialist → test-engineer
- **Performance**: performance-specialist + monitoring-specialist
- **Security**: security-auditor + code-reviewer

## Approval Workflow

Stay in plan mode until user responds:

- **Approve**: yes, approve, proceed, 👍 → Exit plan mode, write files
- **Modify**: modify, update, change → Stay in plan mode, adjust
- **Cancel**: no, cancel, abort, stop → Exit without writing

## Task Template Structure

### Phase File Format

```markdown
# Phase X PR Y: [Description]

## Overview
- **PRD Reference**: [prd.md](./prd.md) Section X.Y
- **Requirements**: REQ-XXX-001, REQ-YYY-002
- **Dependencies**: [None/Phase X completion/Task_X_Y_ZZ]
- **Duration**: X-Y days

## Tasks

### Task_X_Y_ZZ: [Task Name]
- **Assignee**: [agent-name]
- **Execution**: [Independent/Concurrent/Depends on Task_X_Y_ZZ]  
- **Duration**: X-Y hours
- **PRD Requirements**: REQ-XXX-001, REQ-YYY-002
- **Technical Details**: Implementation steps (reference requirements)
- **Acceptance Criteria**: Success measures (validate requirements)
- **Testing**: Test requirements
- **PRD Validation**: Verify against prd.md Section X.Y

## Success Criteria
- All PRD requirements satisfied per specifications
```

### Task ID Format: `Task_X_Y_ZZ` (Phase_PR_Task)

## Example

```bash
User: /plan implement authentication
Claude: 📋 Entering plan mode...

## PRD Preview: Authentication System

Executive Summary: JWT-based auth with registration/login
Phases: 3 phases, 9 PRs, 33 tasks
Key Requirements: Bcrypt, RS256, <500ms response

Ready to proceed? (yes/no/modify)

User: yes
Claude: ✅ Created in .tmp/authentication/:
- prd.md
- phase_1_pr_1_database.md (3 tasks)
- phase_1_pr_2_services.md (4 tasks)
[... 7 more PR files]
```

## PRD Integration Standards

### Requirement Format: `REQ-[CATEGORY]-[NUMBER]`

**Categories**: DB, API, SEC, PERF, SCALE, UI, DEPLOY, MONITOR, ROLLBACK, COMPLIANCE

### Task Requirements

Every task must include:

- **PRD Requirements**: Specific REQ-XXX-001 IDs addressed
- **PRD Reference**: Link to relevant prd.md section  
- **PRD Validation**: Verification step against specifications
- **Requirement Traceability**: Technical details reference requirements

### Multi-Phase Tracking

Complex requirements span phases:

- **REQ-AUTH-001**: Phase 1 (schema) → Phase 2 (logic) → Phase 3 (integration)
- **Cross-phase validation** ensures complete requirement coverage

## Notes

- PRD drives all phase file generation with explicit requirement traceability
- Tasks auto-assigned based on requirement type and technical domain
- Parallel execution optimized while maintaining requirement dependencies  
- PRD compliance validation required before phase completion
