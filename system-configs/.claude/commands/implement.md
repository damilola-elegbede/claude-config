# /implement Command

## Description

Reads a markdown specification file and automatically implements the described features using intelligent
multi-agent orchestration. Analyzes the specification for tasks, dependencies, and parallelization opportunities,
then deploys appropriate specialized agents to complete the implementation.

## Usage

```bash
/implement <spec-file.md> [options]
```bash

## Behavior

When invoked, I will:

1. **Read the specification file** completely, including all referenced files for context
2. **Analyze the specification** to identify tasks, requirements, and dependencies
3. **Create an execution plan** with parallel and sequential task ordering
4. **Launch all these concurrently:** Specialized agents when tasks are independent
5. **Coordinate agent outputs** and integrate results into cohesive implementation
6. **Verify completion** against the original specification requirements

## Implementation Strategy

### Specification Analysis

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
Testing Tasks: test-engineer, qa-tester, performance-engineer
Documentation: tech-writer, api-architect (for API docs)
Security: security-auditor, regulatory-compliance-specialist
Infrastructure: devops, platform-engineer, cloud-architect
Analysis: codebase-analyst, debugger, performance-specialist
```bash

## Examples

### Basic Implementation

```bash
/implement feature-spec.md

# Expected output:
# 📄 Reading specification: feature-spec.md
# 🔍 Analyzing requirements...
# 📋 Identified 8 tasks across 3 domains
#
# 🎯 Execution Plan:
# Parallel Wave 1:
#   - backend-engineer: Implement API endpoints
#   - frontend-architect: Create UI components
#   - test-engineer: Setup test framework
#
# Sequential Phase:
#   - api-architect: Design API contracts
#   - Integration of components
#
# Parallel Wave 2:
#   - qa-tester: Integration testing
#   - tech-writer: Documentation
#
# 🚀 Deploying 3 agents in parallel...
# ✅ Wave 1 complete (3/3 agents)
# 🔄 Running sequential tasks...
# ✅ Sequential phase complete
# 🚀 Deploying 2 agents in parallel...
# ✅ Wave 2 complete (2/2 agents)
#
# ✅ Implementation complete!
# 📊 Summary: 8 tasks completed, 5 agents deployed, 2 parallel waves
```

### Complex Multi-Agent Implementation

```bash
/implement authentication-system.md

# Specification contains:
# - OAuth2 implementation requirements
# - Database schema design
# - API endpoint definitions
# - Security requirements
# - Testing requirements
# - Documentation needs

# Expected execution:
# 📄 Reading specification: authentication-system.md
# 📚 Loading referenced files:
#   - api-schema.yaml
#   - database-design.sql
#   - security-requirements.md
#
# 🔍 Analyzing comprehensive specification...
# 📋 Identified 15 tasks across 6 domains
#
# 🎯 Execution Plan:
#
# Parallel Wave 1 (Foundation):
#   - database-admin: Design and implement auth schema
#   - api-architect: Define OAuth2 API contracts
#   - security-auditor: Review security requirements
#
# Parallel Wave 2 (Implementation):
#   - backend-engineer: Implement auth endpoints
#   - frontend-architect: Create login/registration UI
#   - test-engineer: Write auth test suite
#
# Sequential Integration:
#   - Integration of auth components
#   - Security validation
#
# Parallel Wave 3 (Finalization):
#   - performance-engineer: Optimize auth flow
#   - tech-writer: API documentation
#   - qa-tester: End-to-end testing
#
# 🚀 Executing implementation plan...
# [Progress indicators for each wave]
#
# ✅ Authentication system implemented successfully!
# 📊 15 tasks completed in 3 parallel waves + integration
```bash

### Specification with Dependencies

```bash
/implement data-pipeline.md

# Specification defines:
# Task 1: Design schema (prerequisite for 2,3)
# Task 2: Implement ETL (depends on 1)
# Task 3: Create API (depends on 1)
# Task 4: Add monitoring (depends on 2,3)
# Task 5: Write tests (can run parallel)
# Task 6: Documentation (can run parallel)

# Intelligent execution:
# 📄 Analyzing dependencies in data-pipeline.md...
#
# 🎯 Optimized Execution Plan:
#
# Phase 1 (Sequential):
#   - database-admin: Design schema (Task 1)
#
# Phase 2 (Parallel):
#   - backend-engineer: Implement ETL (Task 2)
#   - api-architect: Create API (Task 3)
#   - test-engineer: Write tests (Task 5)
#   - tech-writer: Documentation (Task 6)
#
# Phase 3 (Sequential):
#   - monitoring-specialist: Add monitoring (Task 4)
#
# ⚡ Optimized from 6 sequential to 3 phases with parallelization
```

## Specification Format Guidelines

### Effective Specification Structure

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
```bash

### Task Dependency Notation

```markdown
## Tasks
1. [ ] Independent task
2. [ ] Another independent task
3. [ ] Dependent task (depends on: 1, 2)
4. [ ] Parallel task (parallel with: 3)
5. [ ] Sequential task (after: 4)
```

## Agent Orchestration

### Parallel Deployment Strategies

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

### Coordination Mechanisms

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

## Advanced Features

### Incremental Implementation

```bash
/implement feature.md --incremental

# Only implements tasks not marked as complete
# Useful for resuming partial implementations
```bash

### Dry Run Mode

```bash
/implement spec.md --dry-run

# Shows execution plan without running
# Useful for validating agent selection and parallelization
```

### Specific Agent Assignment

```bash
/implement spec.md --prefer-agents "backend-engineer,test-engineer"

# Prefers specified agents when multiple options available
```bash

### Maximum Parallelization

```bash
/implement spec.md --max-parallel 5

# Limits simultaneous agent deployment
# Useful for resource-constrained environments
```

## Error Handling

### Specification Issues

```bash
❌ Invalid specification format
💡 Ensure markdown follows specification guidelines
💡 Check for proper task formatting and dependencies
```bash

### Agent Failures

```bash
⚠️ backend-engineer failed on task 3
🔄 Retrying with alternative approach...
✅ Retry successful with modified strategy
```

### Dependency Conflicts

```bash
❌ Circular dependency detected: Task 2 → Task 3 → Task 2
💡 Review task dependencies and remove cycles
```bash

## Integration Points

### With Development Workflow

- **Feature Development**: Implement complete features from specifications
- **Bug Fixes**: Implement fixes described in bug reports
- **Refactoring**: Execute refactoring plans from technical specs
- **Migration**: Implement migration plans from documentation

### With Other Commands

- **`/plan`**: Generate specifications for /implement
- **`/review`**: Review implementation against specification
- **`/test`**: Validate implementation with tests
- **`/docs`**: Generate documentation from implementation

## Best Practices

- Write clear, testable requirements with explicit dependencies
- Break down into modular, atomic tasks for parallel execution
- Define acceptance criteria and reference relevant code
- Use dry-run mode to review execution plan before starting

## Performance

- **Analysis & Planning**: 15-45 seconds
- **Execution**: 40-60% faster with parallelization
- **Resource Usage**: 2-10 parallel agents, ~100MB each

## Configuration

```json
{
  "max-parallel-agents": 5,
  "auto-retry-failures": true,
  "verify-against-spec": true
}
```

## Execution Verification

Deploy execution-evaluator to verify:

- ✅ **Specification analyzed** - Implementation specification fully understood and parsed
- ✅ **Agent deployment** - Appropriate specialists selected and deployed in parallel
- ✅ **Task completion** - All specified tasks marked complete with acceptance criteria met
- ✅ **Code quality** - Implementation passes code review and quality standards
- ✅ **Test coverage** - Comprehensive testing completed and passing
- ✅ **Security validation** - Security audits completed without critical issues
- ✅ **Integration success** - All components integrated and functioning together
- ✅ **Specification compliance** - Final implementation matches original requirements

## Notes

- Reads entire specification before starting implementation
- Automatically identifies parallelization opportunities
- Intelligently selects and coordinates specialized agents
- Provides detailed progress tracking for long-running implementations
- Validates implementation against original specification
- Supports incremental implementation for complex projects
