# Tool Access Justification Guide

## Overview

This guide explains the rationale behind tool access restrictions for each agent type, ensuring appropriate capabilities while maintaining security and role boundaries.

## Tool Access Categories

### Full Access Agents
**Tools**: All tools including Bash, Read, Write, Edit, MultiEdit, Glob, Grep, LS, WebFetch, WebSearch, TodoWrite, NotebookRead, NotebookEdit

#### Implementation Agents
- **backend-engineer**: Needs full access for complex server-side implementation, database modifications, and system configuration
- **frontend-engineer**: Requires all tools for UI implementation, build system configuration, and performance optimization
- **fullstack-lead**: Standard implementation agent needing complete toolset for feature development and bug fixes
- **devops**: Essential for infrastructure automation, CI/CD configuration, and deployment scripts
- **platform-engineer**: Needs full access for monitoring setup, infrastructure management, and SRE automation

**Justification**: Implementation agents must modify code, configure systems, and manage infrastructure to deliver working solutions.

### Read + Analysis Access
**Tools**: Glob, Grep, LS, Read, NotebookRead, WebFetch, WebSearch, Bash(read-only), TodoWrite
**Forbidden**: Edit, MultiEdit, Write, NotebookEdit(modification)

#### Analysis Agents
- **codebase-analyst**: Focuses on understanding and reporting, not modification. Read-only access prevents accidental changes while allowing comprehensive analysis
- **security-auditor**: Analyzes for vulnerabilities without modifying code. Separation of analysis and implementation ensures objective security assessment
- **debugger**: Investigates issues without changing code during analysis phase. Modifications happen after investigation is complete
- **researcher**: Gathers external information and analyzes patterns. No need to modify code as this agent provides research insights
- **performance-engineer**: Analyzes performance characteristics before recommending changes. Separation ensures objective measurement

**Justification**: Analysis agents must remain objective and focused on assessment rather than implementation. Read-only access ensures thorough analysis without bias toward immediate fixes.

### Orchestration Access
**Tools**: Full access + project management capabilities

#### Coordination Agents
- **principal-architect**: Needs full access for architectural decisions, system design, and technical leadership across all domains
- **project-orchestrator**: Requires complete toolset to coordinate multiple agents and manage complex project workflows

**Justification**: Leadership roles require full capabilities to support and coordinate other agents effectively.

### Documentation Access
**Tools**: Bash, Read, Write, Edit, MultiEdit, Glob, Grep, LS, WebFetch, WebSearch, TodoWrite
**Forbidden**: NotebookRead, NotebookEdit

#### Documentation Agents
- **tech-writer**: Focuses on technical documentation and knowledge transfer. Notebook tools not needed for standard documentation workflows
- **api-engineer**: Creates API specifications and documentation. Primary focus on OpenAPI specs and contract documentation

**Justification**: Documentation agents need to read existing code and write specifications but don't typically work with data analysis notebooks.

### Design Access
**Tools**: Read, Write, Edit, MultiEdit, Glob, Grep, LS, WebFetch, WebSearch, TodoWrite
**Forbidden**: Bash, NotebookRead, NotebookEdit

#### Design Agents
- **ui-designer**: Creates design specifications and visual guidelines. No need for system execution or data analysis
- **mobile-ui**: Develops platform-specific design patterns. Limited to design specification creation

**Justification**: Design agents create specifications that implementation agents execute. Direct system access could blur the design/implementation boundary.

### Quality Assurance Access
**Tools**: Varies by agent role and responsibilities

#### QA Agents
- **test-engineer**: Full access needed for test implementation, framework configuration, and quality automation
- **code-reviewer**: Read + analysis access for objective code quality assessment without implementation bias

**Justification**: Testing requires implementation capabilities while code review benefits from objective, read-only analysis.

## Security Principles

### Principle of Least Privilege
Each agent receives minimum access required for their core responsibilities:
- Analysis agents can't accidentally modify code during investigation
- Design agents focus on specifications rather than implementation
- Implementation agents have full access only when building solutions

### Role Separation
Clear boundaries between analysis and implementation:
- **Analysis Phase**: Read-only agents investigate and report
- **Implementation Phase**: Full-access agents build solutions
- **Quality Phase**: Appropriate access level for validation

### Audit Trail
Tool restrictions enable clear audit trails:
- Read-only agents produce analysis reports
- Write-access agents create implementation artifacts
- Clear responsibility attribution for all changes

## Tool-Specific Justifications

### Bash Access
- **Full Access**: Implementation and orchestration agents need system execution
- **Read-Only**: Analysis agents can run non-destructive commands for investigation
- **Forbidden**: Design agents don't need system access for specification creation

### File Modification Tools (Edit, Write, MultiEdit)
- **Allowed**: Implementation, orchestration, and documentation agents
- **Forbidden**: Analysis and design agents to maintain objectivity and role separation

### WebFetch/WebSearch Access
- **Universal**: All agents can access external information for research and context
- **Justification**: External information gathering doesn't pose security risks and enhances agent capabilities

### Notebook Tools
- **Limited Use**: Only data-focused implementation agents need notebook capabilities
- **Justification**: Most agents work with code and documentation rather than data analysis notebooks

## Access Control Benefits

### Enhanced Security
- Reduced risk of accidental modifications during analysis
- Clear audit trail of who can make what changes
- Separation of concerns between analysis and implementation

### Improved Quality
- Objective analysis without implementation bias
- Clear handoff protocols between analysis and implementation
- Focused agent capabilities aligned with responsibilities

### Better Coordination
- Clear understanding of what each agent can and cannot do
- Appropriate escalation paths when agents need capabilities they don't have
- Streamlined workflows based on access patterns

## Escalation Patterns

### When Analysis Agents Need Modifications
1. Complete analysis and provide recommendations
2. Hand off to appropriate implementation agent
3. Implementation agent executes changes
4. Return to analysis agent for validation if needed

### When Design Agents Need Implementation
1. Create comprehensive design specifications
2. Hand off to frontend-engineer or fullstack-lead
3. Implementation agent builds according to specs
4. Design agent reviews for fidelity

### When Implementation Agents Need Analysis
1. Pause implementation work
2. Engage appropriate analysis agent
3. Receive analysis results and recommendations
4. Resume implementation with new insights
