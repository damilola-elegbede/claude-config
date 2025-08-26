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
```text

## Behavior

When invoked, I enter plan mode and systematically analyze requirements,
asking for clarification on any ambiguities. I generate a Product Requirements
Document (PRD) preview showing phases, PRs, and task breakdown.

**CRITICAL**: ALL modes (default, -s, -f) MUST wait for explicit user approval
before creating any implementation files. No mode should assume approval or
auto-proceed to file creation. Only after receiving explicit "yes", "approve",
"proceed", or 👍 do I create implementation files in `.tmp/<feature-name>/` with
detailed agent assignments and technical specifications.

## Agent Orchestration

### Parallel Planning Phase

**Launch all these concurrently:** Specialized agents for comprehensive planning:

```yaml
product-strategist:
  role: Feature prioritization and roadmap planning
  input: Requirements, constraints, goals
  output: Feature priorities, release strategy

tech-writer:
  role: Document requirements and implementation plans
  input: Technical specifications, user stories
  output: PRD documentation, task descriptions

project-orchestrator:
  role: Coordinate implementation phases and agent assignments
  input: Task breakdown, dependencies, resources
  output: Execution strategy, parallel task organization
```bash

### Parallel Planning Benefits

```yaml
Execute in parallel (not sequentially):
  - Business and technical planning simultaneously
  - Requirements refined while architecture designed
  - Run simultaneously in a single response: 40% faster PRD generation
```

## Command Execution Flow

1. Enter plan mode
2. Analyze requirements, ask clarification if needed
3. Generate PRD preview with "Ready to proceed? (yes/no/modify)" prompt
4. **MANDATORY**: Wait for explicit user approval - NEVER assume or skip this step
5. Create files in `.tmp/<feature-name>/` ONLY after receiving approval
6. If user says "modify" - stay in plan mode and adjust the plan
7. If user says "no/cancel" - exit without creating files

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

Each PR contains **3-5 granular tasks** (1-8 hours each) following this
hierarchy:

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
```bash

## Dependency Analysis Framework

### Dependency Types

- **Hard Dependencies**: Schema → Code, API → Frontend,
  Infrastructure → Deployment
- **Soft Dependencies**: Frontend/Backend (shared API),
  Testing/Implementation (parallel)
- **Independent**: Separate services, components, infrastructure, test suites

### Execution Rules

```yaml
Sequential: Foundation → Implementation → Integration
Parallel: Independent components, Frontend+Backend (post-API), Testing+Implementation
Coordination: API contracts, schema approval, integration checkpoints
```bash

## Agent Assignment Rules

### Assignment Matrix

```yaml
Infrastructure: database-admin, database-evolution-specialist, api-architect,
  devops, monitoring-specialist, security-auditor
Implementation: backend-engineer, frontend-architect, mobile-platform-engineer,
  ui-designer
Quality: code-reviewer, security-auditor, performance-specialist,
  test-engineer, accessibility-auditor
Technology: React/Vue→frontend-architect, Node/Python→backend-engineer,
  K8s→kubernetes-admin, Auth→security-auditor
```bash

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
```bash

## Agent Patterns

- **Features**: backend-engineer + frontend-architect + test-engineer
- **Bug fixes**: debugger → specialist → test-engineer
- **Performance**: performance-specialist + monitoring-specialist
- **Security**: security-auditor + code-reviewer

## Approval Workflow

**MANDATORY FOR ALL MODES**: Stay in plan mode until user explicitly responds.
Never assume approval based on input method or command flags.

### User Response Options:

- **Approve**: yes, approve, proceed, 👍, ok, go → Exit plan mode, write files
- **Modify**: modify, update, change, adjust → Stay in plan mode, adjust plan
- **Cancel**: no, cancel, abort, stop, exit → Exit without writing any files

### Implementation Requirements:

- Display clear approval prompt: "Ready to proceed? (yes/no/modify)"
- Wait for user input before any file operations
- Default mode, -s mode, and -f mode ALL follow same approval process
- No auto-proceeding regardless of how requirements were provided

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
```bash

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
Claude: ✅ Approved! Creating implementation files in .tmp/authentication/:
- prd.md
- phase_1_pr_1_database.md (3 tasks)
- phase_1_pr_2_services.md (4 tasks)
[... 7 more PR files]

User: /plan -f requirements.txt
Claude: 📋 Entering plan mode...
Reading requirements from file...

## PRD Preview: [Feature from File]

[Generated plan preview]

Ready to proceed? (yes/no/modify)

User: modify
Claude: What would you like me to adjust in the plan?
[Stays in plan mode awaiting modifications]
```bash

## PRD Integration Standards

### Requirement Format: `REQ-[CATEGORY]-[NUMBER]`

**Categories**: AUTH, DB, API, SEC, PERF, SCALE, UI, DEPLOY, MONITOR, ROLLBACK, COMPLIANCE

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

## Execution Verification

Deploy execution-evaluator to verify:

- ✅ **Requirements analyzed** - All ambiguities clarified before planning
- ✅ **PRD generated** - Complete Product Requirements Document created
- ✅ **Tasks broken down** - Granular tasks with proper agent assignments
- ✅ **Dependencies mapped** - Clear task sequencing and coordination
- ✅ **Files created** - All phase files generated in .tmp/<feature-name>/
- ✅ **Agent assignments** - Specialized agents properly matched to tasks
- ✅ **PRD compliance** - All requirements traceable through task breakdown
- ✅ **Phase organization** - Clear dependencies and parallel execution plans

## Notes

- PRD drives all phase file generation with explicit requirement traceability
- Tasks auto-assigned based on requirement type and technical domain
- Parallel execution optimized while maintaining requirement dependencies
- PRD compliance validation required before phase completion
