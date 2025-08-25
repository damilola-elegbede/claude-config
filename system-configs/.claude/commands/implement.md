# /implement Command

## Description

Reads a markdown specification file and automatically implements the described features using intelligent
multi-agent orchestration. Analyzes the specification for tasks, dependencies, and parallelization opportunities,
then deploys appropriate specialized agents to complete the implementation.

## Usage

```bash
/implement <spec-file.md> [options]
```

## Behavior

When invoked, I will:

1. **Read the specification file** completely, including all referenced files for context
2. **Analyze the specification** to identify tasks, requirements, and dependencies
3. **Create an execution plan** with parallel and sequential task ordering
4. **Deploy specialized agents** simultaneously when tasks are independent
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
Independent Tasks: Deploy multiple agents simultaneously
Sequential Tasks: Execute in dependency order
Integration Points: Coordinate agent outputs at convergence points
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
```

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
```

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

## Overview
Brief description of what needs to be implemented

## Requirements
- Functional requirements
- Non-functional requirements
- Constraints and considerations

## Tasks
1. [ ] Task one description
2. [ ] Task two description (depends on: task 1)
3. [ ] Task three description (parallel with: task 2)

## Acceptance Criteria
- [ ] Criteria one
- [ ] Criteria two

## Referenced Files
- `src/config.js` - Current configuration
- `docs/api.md` - API documentation to update

## Examples
```code
Example code or usage
```​

## Technical Details
Specific implementation notes
```

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

- Deploy all independent tasks simultaneously
- Use resource pooling for agent management
- Monitor progress across all parallel agents
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
```

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
```

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
```

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
```

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

### Specification Writing

- **Clear Requirements**: Unambiguous, testable requirements
- **Explicit Dependencies**: Clearly mark task dependencies
- **Modular Tasks**: Break down into independent, atomic tasks
- **Acceptance Criteria**: Define success conditions
- **Context Files**: Reference relevant existing code

### Implementation Strategy

- **Start with Analysis**: Let the command analyze before executing
- **Review Plan**: Check execution plan in dry-run mode first
- **Monitor Progress**: Watch parallel execution progress
- **Verify Results**: Validate against acceptance criteria

## Performance Characteristics

### Execution Times

- **Specification Analysis**: 5-15 seconds
- **Plan Generation**: 10-30 seconds
- **Per-Agent Task**: 30 seconds - 5 minutes
- **Total Time**: Reduced 40-60% through parallelization

### Resource Usage

- **Parallel Agents**: 2-10 simultaneous (configurable)
- **Memory**: ~100MB per active agent
- **CPU**: Scales with parallel execution
- **I/O**: Managed to prevent conflicts

## Configuration

### Settings

```json
{
  "implement": {
    "max-parallel-agents": 5,
    "auto-retry-failures": true,
    "verify-against-spec": true,
    "integration-strategy": "conservative",
    "progress-reporting": "detailed"
  }
}
```

## Verification

### Completion Validation

- **Task Completion**: All tasks marked complete
- **Acceptance Criteria**: All criteria satisfied
- **Integration Tests**: Automated testing passes
- **Specification Compliance**: Implementation matches spec

### Quality Assurance

- **Code Review**: Automatic review of implementation
- **Test Coverage**: Ensure adequate test coverage
- **Documentation**: Verify documentation completeness
- **Security**: Run security audits on implementation

## Notes

- Reads entire specification before starting implementation
- Automatically identifies parallelization opportunities
- Intelligently selects and coordinates specialized agents
- Provides detailed progress tracking for long-running implementations
- Validates implementation against original specification
- Supports incremental implementation for complex projects
