---
description: Generate PRD and task files with wave orchestration
argument-hint: "[task_description]"
---

# /plan Command

## Usage

```bash
/plan <task_description>             # Standard mode
/plan -s <task_description>          # Simple mode (single PR)
/plan --simple <task_description>    # Simple mode (single PR)
/plan -f <file_path>                 # Read from file
/plan --file <file_path>             # Read from file
```

## Description

Generates Product Requirements Document (PRD) and PR-based task files with agent assignments using an iterative
wave-based orchestration approach. Never guesses unclear requirements - asks for clarification while staying in plan
mode. Planning is iterative and continues until the plan is comprehensive and actionable.

## Expected Output

### Standard Planning Mode

```text
User: /plan implement authentication
Claude: 📋 Entering plan mode with iterative wave-based orchestration...

## Wave 1: Initial Analysis (Parallel Execution)
Launching: product-strategist, business-analyst, tech-writer

## PRD Preview: Authentication System

Executive Summary: JWT-based auth with registration/login
Phases: 3 phases, 9 PRs, 33 tasks
Key Requirements: Bcrypt, RS256, <500ms response

Ready to proceed to Wave 2? (yes/no/modify)

User: yes
Claude: ## Wave 2: Detailed Planning (Parallel Execution)
Launching: project-orchestrator, principal-architect, database-admin, api-architect

[Claude presents refined technical design]

Ready to proceed to Wave 3? (yes/no/modify)

User: yes
Claude: ## Wave 3: Implementation Strategy
Analysis reveals gaps in security protocols. Launching Wave 4...

## Wave 4: Security Refinement (Parallel Execution)
Launching: security-auditor, compliance-auditor

[Additional security planning]

Ready to proceed to Wave 5? (yes/no/modify)

User: yes
Claude: ## Wave 5: Final Implementation Strategy
✅ Comprehensive plan approved! Creating implementation files in .tmp/authentication/:
- prd.md
- phase_1_pr_1_database.md (3 tasks)
- phase_1_pr_2_services.md (4 tasks)
[... 7 more PR files]
```

### File-Based Planning

```text
User: /plan -f requirements.txt
Claude: 📋 Entering plan mode with iterative wave-based orchestration...
Reading requirements from file...

## Wave 1: Initial Analysis (Parallel Execution)
[Generated wave 1 analysis]

Ready to proceed to Wave 2? (yes/no/modify)

User: modify
Claude: What would you like me to adjust in the Wave 1 analysis?
[Stays in plan mode awaiting modifications]
```

### Simple Mode Planning

```text
User: /plan -s add user profile page
Claude: 📋 Entering plan mode (simple) with iterative wave-based orchestration...

## Wave 1: Initial Analysis (Parallel Execution)
Executive Summary: Single-page user profile with edit functionality
Phases: 1 phase, 1 PR, 5 tasks

Ready to proceed to implementation? (yes/no/modify)

User: yes
Claude: ✅ Approved! Creating implementation files in .tmp/user-profile/:
- prd.md
- phase_1_pr_1_user_profile.md (5 tasks)
```

## Behavior

### Iterative Wave-Based Orchestration Flow

#### Core Principle: Progressive Planning Refinement

Planning is **iterative and continues until comprehensive**. Each wave builds on previous discoveries, and additional waves are triggered when:

- **Gap Discovery**: Wave analysis reveals missing requirements or technical concerns
- **Complexity Emergence**: Initial estimates prove insufficient for project scope
- **Stakeholder Feedback**: User modifications require deeper analysis
- **Risk Identification**: Security, performance, or compliance issues surface

#### Wave Progression Examples

**Simple Projects**: 3 waves (Analysis → Planning → Strategy)
**Complex Projects**: 4-5 waves with progressive refinement
**Enterprise Projects**: 5+ waves including compliance, security, and integration reviews

#### Wave 1: Initial Analysis

**Launch all these concurrently in a single response:**

```yaml
product-strategist:
  role: High-level planning and feature prioritization
  input: Task description, business context, constraints
  output: Strategic direction, feature priorities, success metrics
  focus: Business value, market alignment, stakeholder needs

business-analyst:
  role: Requirements gathering and business logic definition
  input: User needs, business processes, constraints
  output: Functional requirements, user stories, acceptance criteria
  focus: What needs to be built and why

tech-writer:
  role: Initial documentation and requirement structuring
  input: Raw requirements, business context
  output: Structured requirements document, initial PRD outline
  focus: Clear communication and documentation standards
```

**Claude Analysis Phase:**

- Synthesize Wave 1 outputs
- Identify gaps, complexity indicators, or conflicts
- Ask clarifying questions if needed
- Present unified understanding
- **Gap Assessment**: Determine if Wave 2 can proceed or additional analysis needed
- Prompt: "Ready to proceed to Wave 2? (yes/no/modify)"

#### Wave 2: Detailed Planning

**Launch all these concurrently in a single response:**

```yaml
project-orchestrator:
  role: Task breakdown and execution coordination
  input: Requirements, business objectives, constraints
  output: Detailed task breakdown, dependency mapping, timeline
  focus: How work should be organized and sequenced

principal-architect:
  role: Technical design and architecture planning
  input: Technical requirements, scalability needs, constraints
  output: System architecture, technology stack, design patterns
  focus: Technical foundation and scalability

database-admin:
  role: Data architecture and storage planning
  input: Data requirements, performance needs, compliance
  output: Database schema, data flow, storage strategy
  focus: Data persistence and performance

api-architect:
  role: API design and integration planning
  input: System interactions, external dependencies, protocols
  output: API contracts, integration patterns, service boundaries
  focus: System interfaces and communication
```

**Claude Validation Phase:**

- Check for gaps and dependencies
- Validate technical feasibility
- Ensure alignment between business and technical plans
- Resolve conflicts between Wave 2 outputs
- **Complexity Assessment**: Determine if additional waves needed
- Prompt: "Ready to proceed to Wave 3? (yes/no/modify)"

#### Wave 3: Implementation Strategy

**Comprehensive execution planning:**

- Assign specific agents to tasks based on previous wave outputs
- Create detailed execution timeline with dependencies
- **Gap Analysis**: Assess if plan is comprehensive or needs refinement
- **Trigger Additional Waves** if gaps identified (security, performance, compliance)
- Generate planning documents if plan is complete, otherwise continue refinement
- Prompt: "Ready to create implementation files? (yes/no/modify)" OR "Analysis reveals gaps requiring Wave 4..."

#### Wave N: Continue Refinement Until Plan is Comprehensive

**Additional waves may include:**

```yaml
Wave_4_Security_Review:
  - security-auditor: Authentication flows, data protection
  - compliance-auditor: Regulatory requirements, audit trails
  - Triggered by: Auth systems, payment processing, data handling

Wave_5_Performance_Planning:
  - performance-engineer: Load testing, optimization strategies
  - cloud-architect: Scalability planning, resource allocation
  - Triggered by: High-traffic systems, real-time requirements

Wave_6_Integration_Strategy:
  - api-architect: Third-party integrations, data synchronization
  - devops: CI/CD pipeline, deployment strategies
  - Triggered by: External API dependencies, complex deployments

Wave_7_Compliance_Validation:
  - compliance-auditor: Legal requirements, industry standards
  - security-auditor: Vulnerability assessments, threat modeling
  - Triggered by: Healthcare, finance, or regulated industry projects
```

### Iterative Refinement Protocol

**Between each wave:**

1. **Synthesis**: Claude consolidates all agent outputs
2. **Gap Analysis**: Identify missing information, emerging complexity, or conflicts
3. **Wave Assessment**: Determine if additional waves needed for comprehensive planning
4. **Clarification**: Ask specific questions if needed
5. **Validation**: Present unified understanding with refinement recommendations
6. **Progressive Approval**: Continue waves until plan is complete and actionable

**User Response Options:**

- **yes/approve/proceed** → Continue to next wave or finalize if complete
- **no/cancel/stop** → Exit without creating files
- **modify/adjust/change** → Stay in current wave, refine based on feedback

**Wave Continuation Triggers:**

- **Automatic**: Claude identifies gaps requiring additional analysis
- **User-Driven**: Feedback reveals new requirements or concerns
- **Complexity-Based**: Project scope exceeds initial wave capacity
- **Risk-Mitigation**: Security, compliance, or performance concerns surface

### Agent Orchestration Enhancements

#### Iterative Wave Benefits

```yaml
Progressive_Refinement:
  - Each wave incorporates feedback and discoveries from previous waves
  - Complex projects receive appropriate depth of analysis
  - Risk identification improves with each refinement cycle
  - Plan quality increases through iterative validation

Adaptive_Planning:
  - Wave count adjusts to project complexity automatically
  - Specialized expertise deployed when specific concerns identified
  - Comprehensive coverage through progressive domain analysis
  - Quality gates prevent premature implementation planning

Feedback_Integration:
  - User modifications trigger appropriate refinement waves
  - Discovered gaps addressed through targeted agent deployment
  - Iterative approval ensures stakeholder alignment throughout process
  - Progressive detail refinement based on project requirements
```

#### Parallel Execution Rules

```yaml
Wave_1: All agents launch simultaneously - no dependencies
Wave_2: All agents launch simultaneously - use Wave 1 outputs as input
Wave_N: Each wave uses all previous wave outputs, continues until comprehensive
Final_Wave: Sequential synthesis and file generation based on all previous waves
```

### Clarification Protocol

**Never guess requirements.** At any wave:

- Present current understanding clearly
- Ask specific, targeted questions
- Stay in current wave awaiting answers
- Only proceed to next wave after clarity
- Continue refinement until plan is comprehensive
- Generate final files only after plan completion

Example wave-specific clarifications:

**Wave 1 Clarifications:**

- "Make it faster" → Ask for specific performance metrics and user experience goals
- "Add search" → Ask for scope, data volume, and required features
- "Integrate API" → Ask which API, what operations, and data requirements

**Wave 2 Clarifications:**

- Technical stack preferences and constraints
- Scalability requirements and expected load
- Security and compliance requirements
- Integration complexity and external dependencies

**Wave N Clarifications:**

- Domain-specific requirements based on identified gaps
- Risk mitigation strategies for complex scenarios
- Compliance requirements for regulated environments
- Performance optimization needs for high-scale systems

### Task Breakdown Logic

#### Granularity Framework

Each PR contains **3-5 granular tasks** (1-8 hours each) following this hierarchy:

- **Phase 1**: Infrastructure (schema, APIs, configs)
- **Phase 2**: Implementation (logic, endpoints, components)
- **Phase 3**: Integration (testing, docs, deployment)

#### Breakdown Patterns

```yaml
Backend: Schema → Service → Controller → Validation → Tests
Frontend: Design → Component → State → Styling → Tests
Infrastructure: Config → Build → Deploy → Monitor → Rollback
Database: Schema → Migration → Rollback → Validation → Performance
API: Contract → Implementation → Security → Testing → Docs
```

### Dependency Analysis Framework

#### Dependency Types

- **Hard Dependencies**: Schema → Code, API → Frontend, Infrastructure → Deployment
- **Soft Dependencies**: Frontend/Backend (shared API), Testing/Implementation (parallel)
- **Independent**: Separate services, components, infrastructure, test suites

#### Execution Rules

```yaml
Sequential: Foundation → Implementation → Integration
Parallel: Independent components, Frontend+Backend (post-API), Testing+Implementation
Coordination: API contracts, schema approval, integration checkpoints
```

### Agent Assignment Rules

#### Assignment Matrix

```yaml
Infrastructure: database-admin, api-architect, devops, performance-engineer, security-auditor
Implementation: backend-engineer, frontend-architect, mobile-engineer, ui-designer
Quality: code-reviewer, security-auditor, performance-engineer, test-engineer, accessibility-auditor
Technology: React/Vue→frontend-architect, Node/Python→backend-engineer, K8s→cloud-architect, Auth→security-auditor
```

#### Priority Rules

1. **Security-First**: Auth/security → security-auditor (always)
2. **Specialist-Preferred**: Domain experts for specialized tech
3. **Multi-Agent**: Complex tasks get primary + secondary + quality agents

### Approval Workflow

**MANDATORY FOR ALL MODES**: Stay in plan mode until user explicitly responds at each wave. Never assume approval based on input method or command flags.

#### Wave Progression Requirements

- Each wave requires explicit user approval
- Default mode, -s mode, and -f mode ALL follow same iterative wave-based approval process
- No auto-proceeding regardless of how requirements were provided
- Clear wave completion and next step prompts
- **Continue refinement until plan is comprehensive and actionable**
- Progressive wave generation based on complexity and feedback

### File Structure

#### Generated Files

- `prd.md` - Product Requirements Document
- `phase_X_pr_Y_<description>.md` - PR implementation files
- `rollback.md` - Rollback procedures (if needed)
- `wave_analysis.md` - Summary of iterative wave-based planning process
- `refinement_log.md` - Documentation of progressive wave refinements

#### PRD Contents

- Executive Summary
- Business Objectives & Scope
- Technical Requirements
- Implementation Phases
- Success Metrics & Risks
- Dependencies & Timeline
- Iterative Wave-Based Planning Summary
- Progressive Refinement History

### Phase Organization

Phases are organized with clear dependencies:

- Phase 1: Foundation (infrastructure, contracts)
- Phase 2: Implementation (features, logic)
- Phase 3: Integration (connections, validation)

### Task Template Structure

#### Phase File Format

```markdown
# Phase X PR Y: [Description]

## Overview
- **PRD Reference**: [prd.md](./prd.md) Section X.Y
- **Requirements**: REQ-XXX-001, REQ-YYY-002
- **Dependencies**: [None/Phase X completion/Task_X_Y_ZZ]
- **Duration**: X-Y days
- **Wave Analysis**: Based on iterative Waves 1-N insights
- **Refinement History**: Key decisions from progressive wave analysis

## Tasks

### Task_X_Y_ZZ: [Task Name]
- **Assignee**: [agent-name] (selected via final wave comprehensive analysis)
- **Execution**: [Independent/Concurrent/Depends on Task_X_Y_ZZ]
- **Duration**: X-Y hours
- **PRD Requirements**: REQ-XXX-001, REQ-YYY-002
- **Technical Details**: Implementation steps (reference requirements)
- **Acceptance Criteria**: Success measures (validate requirements)
- **Testing**: Test requirements
- **PRD Validation**: Verify against prd.md Section X.Y
- **Wave Insights**: Relevant considerations from iterative wave-based analysis
- **Refinement Context**: How progressive planning influenced task design

## Success Criteria
- All PRD requirements satisfied per specifications
- Iterative wave-based planning insights incorporated
- Progressive refinement considerations addressed
```

#### Task ID Format: `Task_X_Y_ZZ` (Phase_PR_Task)

### PRD Integration Standards

#### Requirement Format: `REQ-[CATEGORY]-[NUMBER]`

**Categories**: AUTH, DB, API, SEC, PERF, SCALE, UI, DEPLOY, MONITOR, ROLLBACK, COMPLIANCE

#### Task Requirements

Every task must include:

- **PRD Requirements**: Specific REQ-XXX-001 IDs addressed
- **PRD Reference**: Link to relevant prd.md section
- **PRD Validation**: Verification step against specifications
- **Requirement Traceability**: Technical details reference requirements
- **Wave Context**: Insights from iterative wave-based analysis
- **Refinement History**: How progressive planning influenced design

#### Multi-Phase Tracking

Complex requirements span phases:

- **REQ-AUTH-001**: Phase 1 (schema) → Phase 2 (logic) → Phase 3 (integration)
- **Cross-phase validation** ensures complete requirement coverage
- **Iterative refinement tracking** across all planning waves

### Execution Sequencing

#### Task Types

- **Independent**: Start immediately, full parallel (separate services/components)
- **Concurrent**: Parallel with coordination (Frontend/Backend shared API)
- **Depends**: Sequential execution (Migration before code, API before implementation)

#### Sequencing Patterns

```yaml
Phase_1: Schema, API contracts, infrastructure (Independent within phase)
Phase_2: Backend/Frontend services (Concurrent), migrations (Depends on schema)
Phase_3: E2E testing (Depends on implementation), docs (Concurrent with testing)
```

### Agent Patterns

- **Features**: backend-engineer + frontend-architect + test-engineer
- **Bug fixes**: debugger → backend-engineer → test-engineer
- **Performance**: performance-engineer + performance-engineer
- **Security**: security-auditor + code-reviewer

### Execution Verification

Deploy execution-evaluator to verify:

- ✅ **Progressive Wave Analysis** - Iterative refinement through multiple waves as needed
- ✅ **Wave 1 completed** - Business analysis, requirements gathering, documentation
- ✅ **Wave 2 completed** - Technical planning, architecture, task breakdown
- ✅ **Wave N completed** - Additional refinement waves based on complexity and gaps
- ✅ **Final Wave completed** - Comprehensive implementation strategy and file generation
- ✅ **Requirements analyzed** - All ambiguities clarified through progressive wave refinement
- ✅ **Comprehensive Planning** - Plan is complete and actionable before file generation
- ✅ **PRD generated** - Complete Product Requirements Document created
- ✅ **Tasks broken down** - Granular tasks with proper agent assignments
- ✅ **Dependencies mapped** - Clear task sequencing and coordination
- ✅ **Files created** - All phase files generated in .tmp/`feature-name`/
- ✅ **Agent assignments** - Specialized agents properly matched via comprehensive wave analysis
- ✅ **PRD compliance** - All requirements traceable through task breakdown
- ✅ **Phase organization** - Clear dependencies and parallel execution plans
- ✅ **Iterative Insights** - Progressive planning process insights incorporated into implementation
- ✅ **Refinement Documentation** - Wave-based refinement history captured

### Notes

- **Iterative wave-based orchestration** ensures comprehensive analysis through progressive refinement
- **Each wave builds on previous insights** with additional waves triggered by complexity or gaps
- **Planning continues until comprehensive** - Wave 3 may reveal gaps requiring Wave 4-N refinement
- **Complex projects require 4-5+ waves** of progressive planning detail incorporating feedback and discoveries
- **Each wave incorporates feedback** and discoveries from previous waves until plan is actionable
- PRD drives all phase file generation with explicit requirement traceability
- Tasks auto-assigned based on comprehensive final wave analysis
- Parallel execution optimized while maintaining requirement dependencies
- PRD compliance validation required before phase completion
- **Progressive refinement ensures quality** through iterative validation and gap identification
- **Wave count adapts to project complexity** automatically for optimal planning depth
