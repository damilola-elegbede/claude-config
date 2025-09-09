---
description: Implement features from markdown specs with multi-agents
argument-hint: "[spec-file.md] [options]"
---

# /implement Command

## Usage

```bash
/implement <spec-file.md>              # Basic implementation
/implement feature.md --incremental    # Only incomplete tasks
/implement spec.md --dry-run           # Show execution plan only
/implement spec.md --max-parallel 5    # Limit parallel agents
/implement spec.md --prefer-agents "backend-engineer,test-engineer"
```

## Description

Reads a markdown specification file and automatically implements the described features using intelligent multi-agent
orchestration. Analyzes the specification for tasks, dependencies, and parallelization opportunities, then deploys
appropriate specialized agents to complete the implementation through iterative waves until the feature is fully
implemented and integrated.

## Expected Output

### Basic Implementation

```text
User: /implement feature-spec.md
Claude: 📄 Reading specification: feature-spec.md
🔍 Analyzing requirements...
📋 Identified 8 tasks across 3 domains

🎯 Wave-Based Execution Plan:

🌊 Wave 1: Requirements Analysis & Design
  - codebase-analyst: Analyze current system architecture
  - api-architect: Design API contracts
  - business-analyst: Validate feature requirements

🚀 Deploying Wave 1 agents in parallel...
✅ Wave 1 complete (3/3 agents)
📊 Claude Analysis: Requirements validated, dependencies identified

🌊 Wave 2: Core Implementation
  - backend-engineer: Implement API endpoints
  - frontend-architect: Create UI components
  - database-admin: Execute schema changes

🚀 Deploying Wave 2 agents in parallel...
✅ Wave 2 complete (3/3 agents)
🔗 Claude Integration Check: Components integrated successfully

🌊 Wave 3: Quality & Integration
  - test-engineer: Integration testing
  - performance-engineer: Performance validation

🚀 Deploying Wave 3 agents in parallel...
✅ Wave 3 complete (2/2 agents)

✅ Implementation complete!
📊 Summary: 8 tasks completed across 3 waves, 8 agents deployed in parallel
```

### Complex Multi-Wave Implementation

```text
User: /implement authentication-system.md
Claude: 📄 Reading specification: authentication-system.md
📚 Loading referenced files:
  - api-schema.yaml
  - database-design.sql
  - security-requirements.md

🔍 Analyzing comprehensive specification...
📋 Identified 15 tasks across 6 domains

🎯 Wave-Based Execution Plan:

🌊 Wave 1: Requirements Analysis & Design
  - codebase-analyst: Analyze current auth infrastructure
  - api-architect: Define OAuth2 API contracts
  - database-admin: Design auth schema architecture
  - business-analyst: Validate security requirements

🚀 Deploying Wave 1 agents in parallel...
✅ Wave 1 complete (4/4 agents)
📊 Claude Analysis: Auth requirements validated, security model confirmed

🌊 Wave 2: Core Implementation
  - backend-engineer (instance 1): Implement OAuth2 endpoints
  - backend-engineer (instance 2): Implement session management
  - frontend-architect: Create login/registration UI components
  - database-admin: Execute schema migrations
  - mobile-engineer: Mobile auth considerations

🚀 Deploying Wave 2 agents in parallel...
✅ Wave 2 complete (5/5 agents)
🔗 Claude Integration Check: Auth components integrated, flow validated

🌊 Wave 3: Quality & Integration
  - test-engineer: Auth integration testing
  - security-auditor: Security vulnerability assessment
  - performance-engineer: Auth flow optimization
  - accessibility-auditor: Login UI accessibility compliance

🚀 Deploying Wave 3 agents in parallel...
⚠️ Wave 3 feedback: Security vulnerabilities identified, integration issues detected
📊 Claude Analysis: Additional implementation required based on quality findings

🌊 Wave 4: Security & Integration Fixes
  - backend-engineer: Fix authentication vulnerabilities
  - test-engineer: Expand security test coverage
  - frontend-architect: Update UI for security compliance

🚀 Deploying Wave 4 agents in parallel...
✅ Wave 4 complete (3/3 agents)
🔗 Claude Integration Check: Security issues resolved, testing expanded

🌊 Wave 5: Final Validation & Documentation
  - security-auditor: Final security assessment
  - performance-engineer: Performance validation
  - tech-writer: Implementation documentation

🚀 Deploying Wave 5 agents in parallel...
✅ Wave 5 complete (3/3 agents)

✅ Authentication system implemented successfully!
📊 15 tasks completed across 5 waves, 18 total agent deployments
⚡ Complex feature required additional waves for complete integration
```

### Specification with Dependencies

```text
User: /implement data-pipeline.md
Claude: 📄 Analyzing dependencies in data-pipeline.md...

🎯 Wave-Based Execution Plan with Dependencies:

🌊 Wave 1: Requirements Analysis & Design
  - codebase-analyst: Analyze current data architecture
  - database-admin: Design pipeline schema and data model
  - api-architect: Design data ingestion APIs
  - business-analyst: Validate pipeline requirements

🚀 Deploying Wave 1 agents in parallel...
✅ Wave 1 complete (4/4 agents)
📊 Claude Analysis: Data flow designed, dependencies mapped

🌊 Wave 2: Core Implementation (Dependency-Aware)
  - backend-engineer (instance 1): Implement ETL processes
  - backend-engineer (instance 2): Implement data validation
  - database-admin: Execute schema migrations (prerequisite)
  - mobile-engineer: Mobile data access patterns

🚀 Deploying Wave 2 agents with dependency sequencing...
✅ Wave 2 complete (4/4 agents)
🔗 Claude Integration Check: Pipeline components validated

🌊 Wave 3: Quality & Integration
  - test-engineer: Data pipeline integration testing
  - performance-engineer: Pipeline performance optimization
  - security-auditor: Data security and privacy validation
  - accessibility-auditor: Data dashboard accessibility

🚀 Deploying Wave 3 agents in parallel...
✅ Wave 3 complete (4/4 agents)

✅ Data pipeline implemented successfully!
📊 12 tasks completed across 3 waves with dependency management, 12 agents deployed
⚡ Optimized from 6 sequential steps to 3 parallel waves
```

### Dry Run Mode

```text
User: /implement spec.md --dry-run
Claude: 📄 Dry run analysis for spec.md

🎯 Proposed Wave-Based Execution Plan:

🌊 Wave 1: Requirements Analysis & Design
  - codebase-analyst, api-architect, business-analyst
  - Estimated: 8-12 minutes, 3 parallel agents

📊 Claude Analysis Phase: 2-3 minutes

🌊 Wave 2: Core Implementation
  - backend-engineer, frontend-architect, database-admin
  - Estimated: 20-25 minutes, 3 parallel agents

🔗 Claude Integration Check: 3-5 minutes

🌊 Wave 3: Quality & Integration
  - test-engineer, security-auditor
  - Estimated: 10-15 minutes, 2 parallel agents

⚠️ Complex Feature Warning:
Based on specification complexity, additional waves (Wave 4-6) may be required
for complete implementation and integration. Each wave addresses discoveries
from the previous wave until feature completion.

📊 Implementation Summary:
Initial estimated time: 45-60 minutes (3 waves)
Complex scenarios: 75-120 minutes (4-6 waves)
Peak resource usage: 3 parallel agents per wave
Efficiency gain: 75% time reduction through wave-based parallelization

Ready to proceed? Use /implement spec.md to execute.
```

## Behavior

### Implementation Strategy

#### Phase 1: Specification Analysis

- Read the entire markdown specification file and referenced documents
- Extract requirements, constraints, and acceptance criteria
- Identify system context and architectural considerations
- Parse dependencies and integration requirements

#### Phase 2: Wave Planning

- **Wave 1 Planning**: Identify analysis and design requirements
- **Wave 2 Planning**: Map implementation tasks to specialized agents
- **Wave 3 Planning**: Define quality assurance and validation needs
- **Wave N Planning**: Continue planning additional waves as needed for complex features
- **Dependency Mapping**: Identify cross-wave dependencies and feedback loops

#### Phase 3: Wave-Based Execution

- **Wave 1 Execution**: Deploy analysis and design agents in parallel
- **Claude Analysis**: Consolidate Wave 1 outputs and validate understanding
- **Wave 2 Execution**: Deploy implementation agents based on Wave 1 insights
- **Claude Integration**: Verify component integration and resolve conflicts
- **Wave 3 Execution**: Deploy quality assurance agents in parallel
- **Wave N Execution**: Continue implementation/integration cycles until feature complete
- **Refinement Cycles**: Execute iterative improvements based on feedback

### Multi-Wave Implementation Patterns

#### Standard Three-Wave Pattern

For straightforward features with clear requirements and minimal complexity:

```yaml
Wave 1 - Analysis & Design: (5-15 minutes)
  Pattern: Full parallelization within wave
  Agents: codebase-analyst, api-architect, database-admin, business-analyst
  Integration: Claude consolidates analysis before Wave 2

Wave 2 - Core Implementation: (15-30 minutes)
  Pattern: Parallel execution with dependency awareness
  Agents: Multiple backend-engineer instances, frontend-architect, database-admin
  Integration: Claude validates component integration

Wave 3 - Quality & Integration: (10-20 minutes)
  Pattern: Parallel quality assurance with completion validation
  Agents: test-engineer, security-auditor, performance-engineer
  Integration: Final validation and feature completion
```

#### Extended Multi-Wave Pattern

For complex features requiring iterative refinement and additional integration:

```yaml
Wave 1 - Analysis & Design: (5-15 minutes)
  Same as standard pattern

Wave 2 - Core Implementation: (15-30 minutes)
  Same as standard pattern

Wave 3 - Quality & Integration: (10-20 minutes)
  Discovery: Issues identified requiring additional implementation

Wave 4 - Issue Resolution: (15-25 minutes)
  Pattern: Targeted fixes based on Wave 3 discoveries
  Agents: Specialized agents addressing specific issues
  Integration: Resolve integration conflicts and security issues

Wave 5 - Extended Testing: (10-15 minutes)
  Pattern: Comprehensive validation of fixes
  Agents: Full quality assurance suite re-execution
  Integration: Final system validation

Wave N - Continue Until Complete:
  Pattern: Iterative cycles addressing remaining issues
  Duration: Variable based on complexity
  Completion: When all acceptance criteria met
```

#### Wave Continuation Logic

**Wave 3 Integration Assessment:**

- If integration reveals issues → Deploy Wave 4 fixes
- If security vulnerabilities found → Deploy security-focused Wave 4
- If performance problems detected → Deploy optimization-focused Wave 4
- If accessibility issues identified → Deploy accessibility-focused Wave 4

**Example Multi-Wave Scenarios:**

```yaml
Complex Authentication System: 5-6 waves
  Wave 4: Security vulnerability fixes
  Wave 5: Performance optimization
  Wave 6: Final integration and documentation

Large-Scale Refactoring: 4-5 waves
  Wave 4: Address breaking changes discovered
  Wave 5: Performance and compatibility validation

Multi-Platform Feature: 4-6 waves
  Wave 4: Platform-specific integration issues
  Wave 5: Cross-platform compatibility fixes
  Wave 6: Final testing and deployment validation
```

### Wave-Based Agent Selection Logic

```yaml
Wave 1 - Analysis & Design Agents:
  Requirements: codebase-analyst, business-analyst
  Architecture: api-architect, database-admin
  Security: security-auditor (for security requirements)
  Performance: performance-engineer (for performance requirements)

Wave 2 - Implementation Agents:
  Backend: backend-engineer (multiple instances), database-admin
  Frontend: frontend-architect, ui-designer, mobile-engineer
  Integration: api-architect (for contract validation)
  Mobile: mobile-engineer (for cross-platform considerations)

Wave 3 - Quality & Integration Agents:
  Testing: test-engineer, performance-engineer
  Security: security-auditor (vulnerability assessment)
  Accessibility: accessibility-auditor
  Documentation: tech-writer (implementation docs)

Wave 4+ - Extended Implementation Agents:
  Issue-Specific: Agents selected based on Wave 3 findings
  Security Focus: security-auditor, backend-engineer for vulnerabilities
  Performance Focus: performance-engineer, backend-engineer for optimization
  Integration Focus: Multiple specialists for complex integration issues
  Testing Focus: test-engineer for expanded test coverage

Cross-Wave Support Agents:
  Infrastructure: devops, platform-engineer (deployment considerations)
  Debugging: debugger (issue resolution across waves)
  Monitoring: monitoring-specialist (observability)
```

### Agent Orchestration

#### Wave-Based Implementation Strategy

### Wave 1: Requirements Analysis & Design

Deploy parallel analysis and design agents:

- **codebase-analyst**: Understand current system state and architecture
- **api-architect**: Design API contracts and interface specifications
- **database-admin**: Plan schema changes and data modeling
- **business-analyst**: Validate requirements and acceptance criteria

**Claude Analysis Phase**: Consolidate Wave 1 outputs to confirm requirements are fully understood and identify implementation dependencies

### Wave 2: Core Implementation (Parallel)

Deploy parallel implementation agents based on Wave 1 analysis:

- **backend-engineer instances**: API implementation and business logic
- **frontend-architect**: UI components and user interface implementation
- **database-admin**: Execute planned schema changes and migrations
- **mobile-engineer**: Mobile app considerations and responsive design

**Claude Integration Check**: Verify components work together and resolve any integration conflicts

### Wave 3: Quality & Integration

Deploy parallel quality assurance agents:

- **test-engineer**: Integration testing and test automation
- **security-auditor**: Security validation and vulnerability assessment
- **performance-engineer**: Performance testing and optimization
- **accessibility-auditor**: Accessibility compliance and WCAG validation

### Wave 4+: Extended Implementation (As Needed)

Deploy additional waves based on Wave 3 discoveries:

- **Issue Resolution**: Target specific problems identified in quality assessment
- **Security Hardening**: Address vulnerabilities discovered during testing
- **Performance Optimization**: Resolve performance bottlenecks
- **Integration Fixes**: Resolve complex system integration issues
- **Extended Testing**: Comprehensive validation of fixes and improvements

#### Feedback Loops & Iterative Refinement

**Inter-Wave Feedback Mechanisms:**

- **Wave 1 → Wave 2**: Design decisions inform implementation approach
- **Wave 2 → Wave 3**: Implementation artifacts guide testing and validation strategy
- **Wave 3 → Wave 4+**: Quality findings trigger targeted implementation cycles
- **Wave N → Wave N+1**: Each wave's discoveries inform the next wave's focus
- **Continuous Integration**: Each wave can trigger selective re-execution of previous waves

**Multi-Wave Refinement Process:**

1. **Collect Wave Outputs**: Aggregate results from parallel agent execution
2. **Analyze Integration Status**: Identify incomplete implementation areas
3. **Assess Quality Findings**: Evaluate security, performance, and accessibility issues
4. **Plan Next Wave**: Deploy targeted agents to address specific discoveries
5. **Execute Additional Wave**: Implement fixes and improvements in parallel
6. **Validate Progress**: Confirm issues resolved and feature requirements met
7. **Repeat Until Complete**: Continue waves until all acceptance criteria satisfied

#### Coordination Mechanisms

**Progress Tracking:**

- Real-time status updates from each wave and agent
- Cross-wave dependency monitoring
- Integration point synchronization
- Failure detection with automated recovery strategies
- Multi-wave completion tracking

**Output Integration:**

- Structured collection of wave outputs with metadata
- Conflict resolution through agent negotiation
- Consistency validation across all implementation artifacts
- Comprehensive specification compliance verification
- Multi-wave integration validation

### Specification Format Guidelines

#### Effective Specification Structure

```markdown
# Feature Name

## Tasks
1. [ ] Task description (independent)
2. [ ] Task description (depends on: 1)
3. [ ] Task description (parallel with: 2)

## Acceptance Criteria
- [ ] Specific, testable criteria

## Referenced Files
- Relevant files with context
```

#### Task Dependency Notation

```markdown
## Tasks
1. [ ] Independent task
2. [ ] Another independent task
3. [ ] Dependent task (depends on: 1, 2)
4. [ ] Parallel task (parallel with: 3)
5. [ ] Sequential task (after: 4)
```

### Advanced Features

#### Incremental Implementation

Only implements tasks not marked as complete. Useful for resuming partial implementations.

#### Agent Assignment

Prefers specified agents when multiple options available for better consistency and expertise matching.

#### Resource Management

Limits simultaneous agent deployment for resource-constrained environments while maintaining optimal parallelization.

### Error Handling

#### Specification Issues

```text
❌ Invalid specification format
💡 Ensure markdown follows specification guidelines
💡 Check for proper task formatting and dependencies
```

#### Agent Failures

```text
⚠️ backend-engineer failed on task 3
🔄 Retrying with alternative approach...
✅ Retry successful with modified strategy
```

#### Dependency Conflicts

```text
❌ Circular dependency detected: Task 2 → Task 3 → Task 2
💡 Review task dependencies and remove cycles
```

### Integration Points

#### With Development Workflow

- **Feature Development**: Implement complete features from specifications
- **Bug Fixes**: Implement fixes described in bug reports
- **Refactoring**: Execute refactoring plans from technical specs
- **Migration**: Implement migration plans from documentation

#### With Other Commands

- **`/plan`**: Generate specifications for /implement
- **`/review`**: Review implementation against specification
- **`/test`**: Validate implementation with tests
- **`/docs`**: Generate documentation from implementation

### Configuration

```json
{
  "max-parallel-agents": 5,
  "auto-retry-failures": true,
  "verify-against-spec": true,
  "max-waves": 6,
  "wave-timeout-minutes": 30
}
```

### Execution Verification

Deploy execution-evaluator to verify:

- ✅ **Specification analyzed** - Implementation specification fully understood and parsed
- ✅ **Agent deployment** - Appropriate specialists selected and deployed in parallel
- ✅ **Task completion** - All specified tasks marked complete with acceptance criteria met
- ✅ **Code quality** - Implementation passes code review and quality standards
- ✅ **Test coverage** - Comprehensive testing completed and passing
- ✅ **Security validation** - Security audits completed without critical issues
- ✅ **Integration success** - All components integrated and functioning together
- ✅ **Specification compliance** - Final implementation matches original requirements
- ✅ **Multi-wave completion** - All necessary waves executed until feature complete

### Performance

- **Analysis & Planning**: 15-45 seconds
- **Standard Implementation (3 waves)**: 40-60% faster with parallelization
- **Complex Implementation (4-6 waves)**: Maintains efficiency through parallel execution
- **Resource Usage**: 2-10 parallel agents per wave, ~100MB each
- **Wave Duration**: 10-30 minutes per wave depending on complexity

### Best Practices

- Write clear, testable requirements with explicit dependencies
- Break down into modular, atomic tasks for parallel execution
- Define acceptance criteria and reference relevant code
- Use dry-run mode to review execution plan before starting
- **Expect multiple waves for complex features** - this is normal and ensures quality
- **Plan for 4-6 waves on complex implementations** - comprehensive features require iterative refinement

### Notes

- Reads entire specification before starting implementation
- Automatically identifies parallelization opportunities
- Intelligently selects and coordinates specialized agents
- Provides detailed progress tracking for long-running implementations
- Validates implementation against original specification
- Supports incremental implementation for complex projects
- **Continues wave execution until feature fully complete** - Wave 3 integration may reveal issues requiring Wave 4+ fixes
- **Complex features commonly require 4-6 waves** for complete implementation and integration
- **Each wave addresses discoveries from previous waves** ensuring comprehensive feature completion
