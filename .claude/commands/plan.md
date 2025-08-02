# /plan Command

## Description
Creates comprehensive implementation plans and multi-agent orchestration strategies for projects of any complexity. For simple tasks, provides detailed implementation plans. For complex projects (3+ agents), automatically engages project-orchestrator agent to optimize parallel execution strategies.

## Usage
```
/plan <task or project description>
```

## Examples
```
# Simple feature planning
/plan Add dark mode toggle to settings page

# Complex multi-agent orchestration
/plan Build e-commerce platform with web, mobile, and API
/plan Modernize legacy system with 10 microservices
/plan Security audit and performance optimization for enterprise app
```

## Behavior

### For Simple Tasks (1-2 agents)
When you use `/plan` for straightforward features, I will:

1. **Create detailed implementation plan** including:
   - Executive Summary
   - Problem Statement & Business Impact
   - Proposed Solution Architecture
   - Technical Implementation Details
   - Risk Assessment & Mitigation
   - Success Metrics & KPIs
   - Timeline & Milestones
   - Dependencies & Prerequisites
   - Claude's Assessment

2. **Wait for explicit approval** before proceeding
3. **Execute with todo tracking** only after approval

### For Complex Projects (3+ agents)
When complexity warrants orchestration, I will:

1. **Analyze project complexity** to identify:
   - Required agent types and quantities
   - Parallelization opportunities
   - Task dependencies
   - Integration points

2. **Launch project-orchestrator agent** to create:
   - Optimal execution strategy
   - Parallel execution plan
   - Agent coordination timeline
   - Multi-instance strategies
   - Quality gates

3. **Design execution phases** like:
   ```
   Phase 1: Analysis (Parallel)
   ├── codebase-analyst (Backend)
   ├── codebase-analyst (Frontend)
   ├── codebase-analyst (Mobile)
   └── security-auditor (Full Scan)
   
   Phase 2: Implementation (Parallel)
   ├── backend-engineer (User Service)
   ├── backend-engineer (Payment Service)
   ├── frontend-architect (Web App)
   └── mobile-platform-engineer (iOS/Android)
   ```

## Multi-Agent Orchestration Patterns

### Multi-Instance Coordination
- **Same Type, Different Domains**: 3 backend-engineer agents on different microservices
- **Same Type, Same Domain**: 2 frontend-architect agents on web + admin panel
- **Analysis Swarm**: 4 codebase-analyst agents for comprehensive analysis
- **Implementation Team**: Multiple agents for parallel feature development

### Cross-Agent Dependencies
```
principal-architect → Creates master plan
    ↓
project-orchestrator → Optimizes execution
    ↓
[Multiple Agents Execute in Parallel]
    ↓
test-engineer + code-reviewer → Validate quality
    ↓
tech-writer → Documents everything
```

## Approval Workflow

### Approval Indicators
Clear approval intent includes:
- Direct approval: "approved", "approve", "go ahead"
- Affirmative commands: "execute", "implement", "proceed"
- Positive confirmations: "lgtm", "ship it", "let's do it"
- Action directives: "start implementation", "begin coding"

### Non-Approval Responses
These require re-confirmation:
- Questions about the plan
- Suggestions without clear approval
- Vague responses like "sounds good"
- Any response lacking permission to execute

## Output Format

### Simple Task Plan
1. **Executive Summary**: High-level approach
2. **Technical Details**: Implementation specifics
3. **Timeline**: Estimated duration and milestones
4. **Risks**: Potential issues and mitigations

### Complex Project Plan
1. **Project Overview**: Scope and complexity assessment
2. **Agent Matrix**: Required agents and quantities
3. **Execution Timeline**: Phased approach with parallelism
4. **Dependency Graph**: Task relationships
5. **Integration Plan**: Coordination points
6. **Success Metrics**: Progress tracking KPIs

## Complexity Triggers
Automatic orchestration engages for:
- **3+ Agent Types**: Mixed expertise required
- **5+ Total Agents**: Including multiple instances
- **Cross-Domain**: Frontend + backend + mobile
- **Enterprise Scale**: High availability, compliance
- **Time Constraints**: Aggressive deadlines

## Benefits
- **Optimal Parallelism**: Maximum concurrent work
- **Reduced Time**: Faster delivery through parallelization
- **Better Coordination**: Clear handoffs and integration
- **Risk Mitigation**: Identified dependencies upfront
- **Progress Visibility**: Trackable milestones

## Notes
- Automatically scales from simple plans to complex orchestration
- Supports multiple instances of same agent type
- Optimizes for parallel execution when possible
- Enforces approval workflow for all plans
