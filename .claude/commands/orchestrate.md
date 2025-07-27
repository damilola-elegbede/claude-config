# /orchestrate Command

## Description
Plans and optimizes multi-agent execution strategies using the project-orchestrator agent for complex projects requiring coordination of 3+ specialized agents, including multiple instances of the same agent type.

## Usage
```
/orchestrate <project-description>
```

## Arguments
- `project-description`: Description of the complex project requiring multi-agent coordination

## Behavior
When you use `/orchestrate`, I will:

1. **Analyze project complexity**:
   - Identify required agent types
   - Determine parallelization opportunities
   - Map dependencies between tasks
   - Estimate agent instance needs
   
2. **Launch project-orchestrator agent** to create:
   - Optimal execution strategy
   - Parallel execution plan
   - Agent coordination timeline
   - Integration checkpoints
   - Quality gates
   
3. **Design multi-instance strategies** for:
   - Multiple backend-staff on different services
   - Parallel codebase-analysts for large systems
   - Concurrent frontend-staff for multiple UIs
   - Distributed senior-dev for features
   
4. **Generate orchestration plan** with:
   - Agent selection and quantities
   - Execution timeline
   - Dependency management
   - Resource optimization
   - Progress tracking strategy

## Examples
```
/orchestrate "Build e-commerce platform with web, mobile, and API"
/orchestrate "Modernize legacy system with 10 microservices"
/orchestrate "Security audit and performance optimization for enterprise app"
/orchestrate "Create developer platform with docs, SDKs, and examples"
```

## Orchestration Patterns

### Parallel Execution Blocks
```
Phase 1: Analysis (Parallel)
├── codebase-analyst (Backend Services)
├── codebase-analyst (Frontend Apps)
├── codebase-analyst (Mobile Apps)
└── security-auditor (Full Scan)

Phase 2: Implementation (Parallel)
├── backend-staff (User Service)
├── backend-staff (Payment Service)
├── backend-staff (Inventory Service)
├── frontend-staff (Web App)
└── frontend-staff (Admin Panel)
```

### Multi-Instance Coordination
- **Same Type, Different Domains**: 3 backend-staff on different microservices
- **Same Type, Same Domain**: 2 frontend-staff on web + mobile web
- **Analysis Swarm**: 4 codebase-analysts for comprehensive analysis
- **Implementation Team**: Multiple senior-dev for parallel features

### Cross-Agent Dependencies
```
principal-architect → Creates master plan
    ↓
project-orchestrator → Optimizes execution
    ↓
[Multiple Agents Execute in Parallel]
    ↓
qa-tester + code-reviewer → Validate quality
    ↓
tech-writer → Documents everything
```

## Coordination Strategies

### Agent Selection
- Right agent for each task
- Multiple instances when beneficial
- Expertise matching
- Scale-appropriate choices

### Parallel Optimization
- Maximize concurrent execution
- Minimize blocking dependencies
- Efficient resource utilization
- Balanced workload distribution

### Integration Points
- Shared standards/patterns
- API contract coordination
- Data model consistency
- Style guide adherence

### Quality Gates
- Code review checkpoints
- Test coverage requirements
- Security validation
- Performance benchmarks

## Output Format
1. **Project Overview**: Scope and complexity assessment
2. **Agent Matrix**: Required agents and quantities
3. **Execution Timeline**: Phased approach with parallelism
4. **Dependency Graph**: Task relationships
5. **Integration Plan**: Coordination points
6. **Success Metrics**: Progress tracking KPIs

## Complexity Triggers
- **3+ Agent Types**: Mixed expertise required
- **5+ Total Agents**: Including multiple instances
- **Cross-Domain**: Frontend + backend + mobile
- **Enterprise Scale**: High availability, compliance
- **Time Constraints**: Aggressive deadlines

## Benefits
- **Optimal Parallelism**: Maximum concurrent work
- **Reduced Time**: Faster delivery
- **Better Coordination**: Clear handoffs
- **Risk Mitigation**: Identified dependencies
- **Progress Visibility**: Trackable milestones

## Integration
- Task management systems
- CI/CD pipelines
- Progress dashboards
- Resource planning
- Timeline tracking

## Prerequisites
- Clear project requirements
- Understanding of system scope
- Available agent pool
- Integration points defined

## Notes
- Optimizes for parallel execution
- Handles complex dependencies
- Scales from 3 to 20+ agents
- Supports multiple instances
- Provides execution oversight