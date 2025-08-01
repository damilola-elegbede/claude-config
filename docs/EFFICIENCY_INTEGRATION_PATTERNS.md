# Agent Integration Patterns

This guide demonstrates how specialized agents work together to create powerful, optimized workflows.

## Core Integration Principles

1. **Analysis First**: Use analysis agents for discovery and understanding
2. **Specialist Implementation**: Delegate complex logic to domain specialists
3. **Parallel When Possible**: Run independent agents concurrently
4. **Handoff Optimization**: Minimize data transfer between agents

## Common Integration Patterns

### Pattern 1: Discovery → Analysis → Implementation

```yaml
workflow: analyze-and-refactor
  agents:
    - codebase-analyst: Find and analyze database access patterns
    - backend-engineer: Implement repository pattern
    - test-engineer: Verify refactoring didn't break tests
```

**Example Execution:**
```python
# Step 1: Discovery and analysis
Task: "Use codebase-analyst to find and analyze database access patterns"

# Step 2: Implementation
Task: "Use backend-engineer to refactor using repository pattern based on analysis"

# Step 3: Validation
Task: "Use test-engineer to run affected tests"
```

### Pattern 2: Parallel Setup → Concurrent Development

```yaml
workflow: full-stack-feature
  parallel_block_1:
    - devops-engineer: Setup project dependencies
    - system-architect: Design feature architecture
  parallel_block_2:
    - frontend-architect: Implement UI components
    - backend-engineer: Create API endpoints
    - test-engineer: Write integration tests
```

**Example Execution:**
```python
# Parallel Block 1: Setup (all run simultaneously)
Task: "Use devops-engineer to setup project dependencies and branch"
Task: "Use system-architect to design feature architecture"

# Parallel Block 2: Development (all run simultaneously)
Task: "Use frontend-architect to build dashboard components"
Task: "Use backend-engineer to create dashboard API endpoints"
Task: "Use test-engineer to write integration tests"
```

### Pattern 3: Error Resolution → Root Cause → Prevention

```yaml
workflow: production-incident
  agents:
    - production-reliability-engineer: Quick diagnosis and mitigation
    - debugger: Deep root cause analysis
    - platform-engineer: Implement prevention measures
    - tech-writer: Document incident and resolution
```

**Example Execution:**
```python
# Step 1: Immediate response
Task: "Use production-reliability-engineer to diagnose and provide quick fix for memory leak"

# Step 2: Deep investigation
Task: "Use debugger to find root cause of memory leak"

# Step 3: Long-term fix
Task: "Use platform-engineer to implement monitoring and prevention"

# Step 4: Knowledge capture
Task: "Use tech-writer to document incident, resolution, and prevention"
```

### Pattern 4: Scaffold → Customize → Optimize

```yaml
workflow: microservice-creation
  agents:
    - system-architect: Design service structure
    - backend-engineer: Implement business logic
    - performance-specialist: Optimize critical paths
    - devops-engineer: Setup CI/CD
```

**Example Execution:**
```python
# Step 1: Design and scaffolding
Task: "Use system-architect to design microservice structure and patterns"

# Step 2: Implementation
Task: "Use backend-engineer to implement order processing logic"

# Step 3: Optimization
Task: "Use performance-specialist to optimize database queries and caching"

# Step 4: Deployment
Task: "Use devops-engineer to setup CI/CD pipeline"
```

## Advanced Integration Strategies

### Multi-Instance Coordination

When working with large codebases, use multiple instances of efficiency agents:

```yaml
workflow: large-scale-refactoring
  parallel_analysis:
    - codebase-analyst[frontend]: Analyze React components
    - codebase-analyst[backend]: Analyze API controllers
    - codebase-analyst[shared]: Analyze utility functions
  implementation:
    - frontend-architect: Update frontend patterns
    - backend-engineer: Update backend patterns
```

### Efficiency Agent Chains

Chain efficiency agents for complex multi-step operations:

```yaml
workflow: dependency-migration
  chain:
    - ux-researcher: Find migration guides
    - devops-engineer: Update packages
    - codebase-analyst: Find usage patterns
    - backend-engineer: Update code for new API
    - test-engineer: Verify migration success
```

### Hybrid Workflows

Combine efficiency and specialist agents based on task complexity:

```yaml
workflow: api-redesign
  analysis_phase:
    - codebase-analyst: Locate and analyze API endpoints
    - ux-researcher: Gather current API documentation
  specialist_phase:
    - api-architect: Design new API structure
    - backend-engineer: Implement new endpoints
    - test-engineer: Create comprehensive tests
  finalization_phase:
    - tech-writer: Create migration guide
    - devops-engineer: Deploy and version new API
```

## Integration Best Practices

### 1. Handoff Optimization

**Efficient Handoff:**
```python
# codebase-analyst provides specific analysis
analysis_result = "Found patterns: src/api/users.js, src/api/orders.js - using outdated ORM patterns"

# Next agent receives precise targets
Task: f"Use backend-engineer to refactor {analysis_result}"
```

**Inefficient Handoff:**
```python
# Vague results require re-analysis
Task: "Use backend-engineer to refactor API files"  # Agent must analyze again
```

### 2. Parallel Execution Rules

**Good Parallelization:**
- Independent file operations
- Different service deployments
- Separate test suites
- Non-overlapping configurations

**Avoid Parallel When:**
- Agents modify same files
- Sequential dependencies exist
- Shared resource conflicts possible
- Order of operations matters

### 3. Context Preservation

Maintain context between agent handoffs:

```python
# Context-rich workflow
context = {
    "modified_files": ["src/api/users.js", "src/models/User.js"],
    "test_files": ["tests/api/users.test.js"],
    "dependencies": ["express", "mongoose"]
}

Task: f"Use test-engineer to test the modified files: {context['test_files']}"
```

### 4. Error Handling Strategies

Build resilient workflows with fallbacks:

```yaml
workflow: safe-deployment
  try:
    - test-engineer: Run all tests
    - devops-engineer: Deploy to staging
  catch:
    - production-reliability-engineer: Diagnose failures
    - devops-engineer: Revert problematic commits
  finally:
    - tech-writer: Document outcome
```

## Performance Optimization Tips

### 1. Batch Similar Operations

**Instead of:**
```python
Task: "Use codebase-analyst to find user components"
Task: "Use codebase-analyst to find auth components"  
Task: "Use codebase-analyst to find admin components"
```

**Do:**
```python
Task: "Use codebase-analyst to find all components grouped by feature (user, auth, admin)"
```

### 2. Preload Common Data

**Instead of:**
```python
# Each agent rediscovers project structure
Task: "Use frontend-architect to update components"
Task: "Use test-engineer to write tests"
```

**Do:**
```python
# Share discovered structure
structure = Task: "Use codebase-analyst to map project structure"
Task: f"Use frontend-architect to update components in {structure}"
Task: f"Use test-engineer to write tests for {structure}"
```

### 3. Smart Agent Selection

Choose the right efficiency agent for the task:

| Task Type | Best Agent | Alternative |
|-----------|------------|-------------|
| Find files by pattern | codebase-analyst | ux-researcher |
| Update multiple configs | devops | backend-engineer |
| Fix common errors | production-reliability-engineer | debugger |
| Run affected tests | test-engineer | test-engineer |
| Bulk implementation | backend-engineer/frontend-architect | backend-engineer/frontend-architect |

## Monitoring and Optimization

### Workflow Metrics

Track efficiency gains:

```yaml
metrics:
  total_operations: 45
  traditional_tool_calls: 167
  efficiency_agent_calls: 12
  specialist_agent_calls: 8
  parallel_operations: 15
  time_saved: "~6 minutes"
  efficiency_gain: "73%"
```

### Optimization Opportunities

Look for patterns that indicate optimization potential:

1. **Repeated Operations** → Use specialized agents
2. **Sequential Same-Type Tasks** → Batch into single delegation  
3. **Independent Agent Calls** → Run in parallel
4. **Complex File Operations** → Use multiple agents in parallel
5. **Multi-Step Git Workflows** → Use individual Git commands

## Example: Complete Feature Implementation

Here's a full example showing optimal integration:

```python
# Phase 1: Parallel Setup (2 agents, 5 seconds)
parallel_tasks = [
    "Use devops-engineer to create branch and install Stripe SDK",
    "Use codebase-analyst to map current payment code structure"
]

# Phase 2: Implementation (2 agents, parallel where possible)
Task: "Use backend-engineer to implement Stripe payment service"
Task: "Use frontend-architect to create payment form component"

# Phase 3: Quality Assurance (3 agents in parallel, 10 seconds)
parallel_qa = [
    "Use test-engineer to run payment-related tests",
    "Use security-auditor to review payment implementation",
    "Use code-reviewer to check code quality"
]

# Phase 4: Finalization (2 agents, sequential)
Task: "Use tech-writer to document payment integration"
Task: "Use devops-engineer to create PR with deployment"

# Total time: ~45 seconds
# Traditional approach: ~5-10 minutes
```

## Summary

Specialized agents dramatically improve development velocity when properly coordinated. By following these patterns and best practices, you can achieve:

- 70-90% reduction in tool calls
- 50-80% time savings on common workflows
- Better error handling and consistency
- Improved developer experience
- Maintained code quality and standards
