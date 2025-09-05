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
appropriate specialized agents to complete the implementation.

## Expected Output

### Basic Implementation

```text
User: /implement feature-spec.md
Claude: 📄 Reading specification: feature-spec.md
🔍 Analyzing requirements...
📋 Identified 8 tasks across 3 domains

🎯 Execution Plan:
Parallel Wave 1:
  - backend-engineer: Implement API endpoints
  - frontend-architect: Create UI components
  - test-engineer: Setup test framework

Sequential Phase:
  - api-architect: Design API contracts
  - Integration of components

Parallel Wave 2:
  - test-engineer: Integration testing
  - tech-writer: Documentation

🚀 Deploying 3 agents in parallel...
✅ Wave 1 complete (3/3 agents)
🔄 Running sequential tasks...
✅ Sequential phase complete
🚀 Deploying 2 agents in parallel...
✅ Wave 2 complete (2/2 agents)

✅ Implementation complete!
📊 Summary: 8 tasks completed, 5 agents deployed, 2 parallel waves
```

### Complex Multi-Agent Implementation

```text
User: /implement authentication-system.md
Claude: 📄 Reading specification: authentication-system.md
📚 Loading referenced files:
  - api-schema.yaml
  - database-design.sql
  - security-requirements.md

🔍 Analyzing comprehensive specification...
📋 Identified 15 tasks across 6 domains

🎯 Execution Plan:

Parallel Wave 1 (Foundation):
  - database-admin: Design and implement auth schema
  - api-architect: Define OAuth2 API contracts
  - security-auditor: Review security requirements

Parallel Wave 2 (Implementation):
  - backend-engineer: Implement auth endpoints
  - frontend-architect: Create login/registration UI
  - test-engineer: Write auth test suite

Sequential Integration:
  - Integration of auth components
  - Security validation

Parallel Wave 3 (Finalization):
  - performance-engineer: Optimize auth flow
  - tech-writer: API documentation
  - test-engineer: End-to-end testing

🚀 Executing implementation plan...
[Progress indicators for each wave]

✅ Authentication system implemented successfully!
📊 15 tasks completed in 3 parallel waves + integration
```

### Specification with Dependencies

```text
User: /implement data-pipeline.md
Claude: 📄 Analyzing dependencies in data-pipeline.md...

🎯 Optimized Execution Plan:

Phase 1 (Sequential):
  - database-admin: Design schema (Task 1)

Phase 2 (Parallel):
  - backend-engineer: Implement ETL (Task 2)
  - api-architect: Create API (Task 3)
  - test-engineer: Write tests (Task 5)
  - tech-writer: Documentation (Task 6)

Phase 3 (Sequential):
  - monitoring-specialist: Add monitoring (Task 4)

⚡ Optimized from 6 sequential to 3 phases with parallelization
```

### Dry Run Mode

```text
User: /implement spec.md --dry-run
Claude: 📄 Dry run analysis for spec.md

🎯 Proposed Execution Plan:
Wave 1: 3 agents (backend, frontend, test)
Sequential: 2 integration tasks
Wave 2: 2 agents (docs, monitoring)

Total estimated time: 45 minutes (vs 2 hours sequential)
Resource usage: Max 3 parallel agents

Ready to proceed? Use /implement spec.md to execute.
```

## Behavior

### Implementation Strategy

#### Phase 1: Document Parsing

- Read the entire markdown specification file
- Extract all file references and load them for context
- Identify code blocks, examples, and requirements
- Parse task lists, acceptance criteria, and dependencies

#### Phase 2: Task Extraction

- Identify explicit tasks (numbered lists, checkboxes)
- Infer implicit tasks from requirements
- Categorize tasks by domain (backend, frontend, testing, etc.)
- Determine task dependencies and ordering

#### Phase 3: Agent Mapping

- Map tasks to appropriate specialized agents
- Identify opportunities for parallel execution
- Create agent deployment strategy
- Plan integration points for agent outputs

### Parallel Execution Patterns

```yaml
Independent Tasks: Launch all these concurrently - multiple agents simultaneously
Sequential Tasks: Execute in parallel (not sequentially) where dependencies allow
Integration Points: Run simultaneously in a single response at convergence points
Verification: Validate implementation against specification
```

### Agent Selection Logic

```yaml
Backend Tasks: backend-engineer, database-admin, api-architect
Frontend Tasks: frontend-architect, mobile-ui, ui-designer
Testing Tasks: test-engineer, test-engineer, performance-engineer
Documentation: tech-writer, api-architect (for API docs)
Security: security-auditor, security-auditor
Infrastructure: devops, platform-engineer, cloud-architect
Analysis: codebase-analyst, debugger, performance-specialist
```

### Agent Orchestration

#### Parallel Deployment Strategies

**Maximum Parallelization:**

- **Launch all these concurrently:** Deploy all independent tasks simultaneously
- **Execute in parallel (not sequentially):** Use resource pooling for agent management
- **Run simultaneously in a single response:** Monitor progress across all parallel agents
- Coordinate outputs at convergence points

**Intelligent Batching:**

- Group related tasks for domain-specific agents
- Balance load across available agents
- Optimize for minimal total execution time
- Consider resource constraints

#### Coordination Mechanisms

**Progress Tracking:**

- Real-time status updates from each agent
- Dependency resolution monitoring
- Integration point synchronization
- Failure detection and recovery

**Output Integration:**

- Collect outputs from parallel agents
- Resolve conflicts when multiple agents modify same files
- Maintain consistency across implementation
- Validate against specification

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
  "verify-against-spec": true
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

### Performance

- **Analysis & Planning**: 15-45 seconds
- **Execution**: 40-60% faster with parallelization
- **Resource Usage**: 2-10 parallel agents, ~100MB each

### Best Practices

- Write clear, testable requirements with explicit dependencies
- Break down into modular, atomic tasks for parallel execution
- Define acceptance criteria and reference relevant code
- Use dry-run mode to review execution plan before starting

### Notes

- Reads entire specification before starting implementation
- Automatically identifies parallelization opportunities
- Intelligently selects and coordinates specialized agents
- Provides detailed progress tracking for long-running implementations
- Validates implementation against original specification
- Supports incremental implementation for complex projects
