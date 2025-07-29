# Efficiency Agent Integration Patterns

This guide demonstrates how efficiency agents work seamlessly with specialist agents to create powerful, optimized workflows.

## Core Integration Principles

1. **Efficiency First**: Use efficiency agents for setup and discovery
2. **Specialist Deep Dive**: Delegate complex logic to specialists
3. **Parallel When Possible**: Run independent agents concurrently
4. **Handoff Optimization**: Minimize data transfer between agents

## Common Integration Patterns

### Pattern 1: Discovery → Analysis → Implementation

```yaml
workflow: analyze-and-refactor
  agents:
    - file-navigator: Find all database access code
    - codebase-analyst: Analyze patterns and anti-patterns
    - backend-engineer: Implement repository pattern
    - test-runner: Verify refactoring didn't break tests
```

**Example Execution:**
```python
# Step 1: Rapid discovery
Task: "Use file-navigator to find all files containing database queries"

# Step 2: Deep analysis  
Task: "Use codebase-analyst to analyze the database access patterns found"

# Step 3: Implementation
Task: "Use backend-engineer to refactor using repository pattern based on analysis"

# Step 4: Validation
Task: "Use test-runner to run affected tests"
```

### Pattern 2: Parallel Setup → Concurrent Development

```yaml
workflow: full-stack-feature
  parallel_block_1:
    - dependency-manager: Install frontend deps
    - dependency-manager: Install backend deps
    - git-workflow: Create feature branch
  parallel_block_2:
    - frontend-engineer: Implement UI components
    - backend-engineer: Create API endpoints
    - test-engineer: Write integration tests
```

**Example Execution:**
```python
# Parallel Block 1: Setup (all run simultaneously)
Task: "Use dependency-manager to install React Query and related deps for frontend"
Task: "Use dependency-manager to install Express middleware for backend"  
Task: "Use git-workflow to create feature/user-dashboard branch"

# Parallel Block 2: Development (all run simultaneously)
Task: "Use frontend-engineer to build dashboard components"
Task: "Use backend-engineer to create dashboard API endpoints"
Task: "Use test-engineer to write integration tests"
```

### Pattern 3: Error Resolution → Root Cause → Prevention

```yaml
workflow: production-incident
  agents:
    - error-resolver: Quick diagnosis and mitigation
    - debugger: Deep root cause analysis
    - reliability-engineer: Implement prevention measures
    - tech-writer: Document incident and resolution
```

**Example Execution:**
```python
# Step 1: Immediate response
Task: "Use error-resolver to diagnose and provide quick fix for memory leak"

# Step 2: Deep investigation
Task: "Use debugger to find root cause of memory leak"

# Step 3: Long-term fix
Task: "Use reliability-engineer to implement monitoring and prevention"

# Step 4: Knowledge capture
Task: "Use tech-writer to document incident, resolution, and prevention"
```

### Pattern 4: Scaffold → Customize → Optimize

```yaml
workflow: microservice-creation
  agents:
    - file-writer: Scaffold service structure
    - config-specialist: Setup configurations
    - backend-engineer: Implement business logic
    - performance-engineer: Optimize critical paths
    - devops: Setup CI/CD
```

**Example Execution:**
```python
# Step 1: Rapid scaffolding
Task: "Use file-writer to create microservice boilerplate with standard structure"

# Step 2: Configuration
Task: "Use config-specialist to setup multi-environment configurations"

# Step 3: Implementation
Task: "Use backend-engineer to implement order processing logic"

# Step 4: Optimization
Task: "Use performance-engineer to optimize database queries and caching"

# Step 5: Deployment
Task: "Use devops to setup CI/CD pipeline"
```

## Advanced Integration Strategies

### Multi-Instance Coordination

When working with large codebases, use multiple instances of efficiency agents:

```yaml
workflow: large-scale-refactoring
  parallel_discovery:
    - file-navigator[frontend]: Find React components
    - file-navigator[backend]: Find API controllers
    - file-navigator[shared]: Find utility functions
  parallel_analysis:
    - search-coordinator[imports]: Analyze import patterns
    - search-coordinator[exports]: Analyze export patterns
  implementation:
    - file-writer: Update import/export statements
```

### Efficiency Agent Chains

Chain efficiency agents for complex multi-step operations:

```yaml
workflow: dependency-migration
  chain:
    - documentation-finder: Find migration guides
    - dependency-manager: Update packages
    - search-coordinator: Find usage patterns
    - file-writer: Update code for new API
    - test-runner: Verify migration success
    - git-workflow: Commit with detailed message
```

### Hybrid Workflows

Combine efficiency and specialist agents based on task complexity:

```yaml
workflow: api-redesign
  efficiency_phase:
    - file-navigator: Locate all API endpoints
    - documentation-finder: Gather current API docs
    - search-coordinator: Find API usage patterns
  specialist_phase:
    - api-architect: Design new API structure
    - backend-engineer: Implement new endpoints
    - test-engineer: Create comprehensive tests
  finalization_phase:
    - file-writer: Generate API client SDKs
    - tech-writer: Create migration guide
    - git-workflow: Create PR with changes
```

## Integration Best Practices

### 1. Handoff Optimization

**Efficient Handoff:**
```python
# file-navigator provides specific file paths
navigator_result = "Found: src/api/users.js, src/api/orders.js"

# Next agent receives precise targets
Task: f"Use backend-engineer to refactor {navigator_result}"
```

**Inefficient Handoff:**
```python
# Vague results require re-discovery
Task: "Use backend-engineer to refactor API files"  # Agent must search again
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

Task: f"Use test-runner to test the modified files: {context['test_files']}"
```

### 4. Error Handling Strategies

Build resilient workflows with fallbacks:

```yaml
workflow: safe-deployment
  try:
    - test-runner: Run all tests
    - devops: Deploy to staging
  catch:
    - error-resolver: Diagnose failures
    - git-workflow: Revert problematic commits
  finally:
    - tech-writer: Document outcome
```

## Performance Optimization Tips

### 1. Batch Similar Operations

**Instead of:**
```python
Task: "Use file-navigator to find user components"
Task: "Use file-navigator to find auth components"  
Task: "Use file-navigator to find admin components"
```

**Do:**
```python
Task: "Use file-navigator to find all components grouped by feature (user, auth, admin)"
```

### 2. Preload Common Data

**Instead of:**
```python
# Each agent rediscovers project structure
Task: "Use frontend-engineer to update components"
Task: "Use test-engineer to write tests"
```

**Do:**
```python
# Share discovered structure
structure = Task: "Use file-navigator to map project structure"
Task: f"Use frontend-engineer to update components in {structure}"
Task: f"Use test-engineer to write tests for {structure}"
```

### 3. Smart Agent Selection

Choose the right efficiency agent for the task:

| Task Type | Best Efficiency Agent | Fallback Specialist |
|-----------|---------------------|-------------------|
| Find files by pattern | file-navigator | codebase-analyst |
| Update multiple configs | config-specialist | backend-engineer |
| Fix common errors | error-resolver | debugger |
| Run affected tests | test-runner | test-engineer |
| Bulk file creation | file-writer | frontend/backend-engineer |

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

1. **Repeated Operations** → Use efficiency agents
2. **Sequential Same-Type Tasks** → Batch into single delegation  
3. **Independent Agent Calls** → Run in parallel
4. **Complex File Operations** → Use file-writer
5. **Multi-Step Git Workflows** → Use git-workflow

## Example: Complete Feature Implementation

Here's a full example showing optimal integration:

```python
# Phase 1: Parallel Setup (3 agents, 5 seconds)
parallel_tasks = [
    "Use git-workflow to create feature/payment-integration branch",
    "Use dependency-manager to install Stripe SDK and types",
    "Use file-navigator to map current payment code structure"
]

# Phase 2: Implementation (2 agents, parallel where possible)
Task: "Use backend-engineer to implement Stripe payment service"
Task: "Use frontend-engineer to create payment form component"

# Phase 3: Quality Assurance (3 agents in parallel, 10 seconds)
parallel_qa = [
    "Use test-runner to run payment-related tests",
    "Use security-auditor to review payment implementation",
    "Use code-reviewer to check code quality"
]

# Phase 4: Finalization (2 agents, sequential)
Task: "Use tech-writer to document payment integration"
Task: "Use git-workflow to create PR with conventional commit"

# Total time: ~45 seconds
# Traditional approach: ~5-10 minutes
```

## Summary

Efficiency agents dramatically improve development velocity when properly integrated with specialist agents. By following these patterns and best practices, you can achieve:

- 70-90% reduction in tool calls
- 50-80% time savings on common workflows
- Better error handling and consistency
- Improved developer experience
- Maintained code quality and standards

Remember: Efficiency agents handle the "how" quickly, while specialist agents ensure the "what" is correct. Use them together for maximum impact.