# Claude Agent Ecosystem

## Overview

This directory contains specialized agent configurations with standardized YAML frontmatter for clear role definition, escalation paths, and collaboration protocols.

## Agent Hierarchy & Specialization Levels

### Staff Level (Strategic Leadership)
- **Principal Architect** - Final authority on technical architecture and strategy
- **Backend Staff** - Complex system design and performance optimization

### Senior Level (Domain Expertise)
- **Product Strategy Expert** - Business strategy and market analysis
- **Project Orchestrator** - Multi-team coordination and delivery management
- **Codebase Analyst** - Technical analysis and architecture assessment
- **Debugger** - Complex problem diagnosis and resolution
- **UI Designer** - User interface and experience design
- **Mobile UI** - Mobile-specific interface design

### Specialist Level (Focused Expertise)
- **Tech Writer** - Documentation and developer experience

## Escalation Matrix

```
┌─────────────────────┐
│ Principal Architect │ ← Final Authority
└─────────────────────┘
         ↑
    ┌─────────┴─────────┐
    │                   │
┌─────────────┐  ┌─────────────────────┐
│Backend Staff│  │Product Strategy     │
└─────────────┘  │Expert               │
    ↑            └─────────────────────┘
    │                      ↑
┌─────────────┐      ┌─────────────┐
│Debugger     │      │Project      │
│             │      │Orchestrator │
└─────────────┘      └─────────────┘
    ↑                      ↑
┌─────────────┐      ┌─────────────┐
│Codebase     │      │Tech Writer  │
│Analyst      │      │             │
└─────────────┘      └─────────────┘
```

## Parallel Collaboration Groups

### Technical Implementation
- **Backend Staff** + **Tech Writer** + **Debugger**
- Focus: Technical execution with documentation

### Analysis & Investigation  
- **Codebase Analyst** + **Debugger** + **Tech Writer**
- Focus: Problem investigation and knowledge capture

### Strategic Coordination
- **Product Strategy Expert** + **Project Orchestrator** + **Tech Writer**
- Focus: Business alignment and delivery management

### Design & User Experience
- **UI Designer** + **Mobile UI** + **Tech Writer**
- Focus: Cross-platform design consistency and design documentation

### Full-Stack Feature Development
- **Backend Staff** + **UI Designer** + **Mobile UI** + **Tech Writer**
- Focus: Complete feature implementation across all platforms

## Agent Responsibilities (Non-Overlapping)

### **Principal Architect**
- **Unique Role**: Final technical authority and cross-system architecture
- **Decisions**: Technology strategy, architectural standards, cross-team technical coordination
- **Scope**: Organization-wide technical direction

### **Backend Staff** 
- **Unique Role**: Complex system implementation and performance optimization
- **Decisions**: Service architecture, database design, scalability patterns
- **Scope**: System-level technical solutions

### **Product Strategy Expert**
- **Unique Role**: Business strategy and market positioning
- **Decisions**: Product roadmap, go-to-market strategy, business model design
- **Scope**: Strategic business direction

### **Project Orchestrator**
- **Unique Role**: Cross-functional coordination and delivery management
- **Decisions**: Resource allocation, timeline management, risk mitigation
- **Scope**: Project execution and stakeholder coordination

### **Codebase Analyst**
- **Unique Role**: Technical analysis and architecture assessment
- **Decisions**: Technical debt prioritization, refactoring strategies, code quality standards
- **Scope**: Codebase health and technical improvement recommendations

### **Debugger**
- **Unique Role**: Problem diagnosis and complex issue resolution
- **Decisions**: Root cause identification, debugging methodology, issue reproduction
- **Scope**: Technical problem solving and system troubleshooting

### **Tech Writer**
- **Unique Role**: Documentation strategy and developer experience
- **Decisions**: Documentation architecture, content strategy, accessibility standards
- **Scope**: Knowledge management and technical communication

### **UI Designer**
- **Unique Role**: User interface and experience design leadership
- **Decisions**: Design systems, user experience strategy, accessibility design
- **Scope**: Cross-platform design consistency and design standards

### **Mobile UI**
- **Unique Role**: Mobile-specific interface design and platform optimization
- **Decisions**: Platform-specific design patterns, mobile UX optimization, cross-platform mobile consistency
- **Scope**: iOS and Android interface design and mobile user experience

## Complexity Triggers

### Use **Principal Architect** for:
- Cross-system architecture decisions
- Technology strategy planning
- Organizational technical direction
- Platform standardization
- Architectural governance needs

### Use **Backend Staff** for:
- System architecture changes
- Performance bottlenecks
- Scalability requirements
- Complex integrations
- Security implementations

### Use **Product Strategy Expert** for:
- Strategic product decisions
- Market positioning challenges
- Competitive response planning
- Business model innovation
- Go-to-market initiatives

### Use **Project Orchestrator** for:
- Multi-team coordination requirements
- Complex timeline dependencies
- Resource allocation conflicts
- Cross-functional project delivery
- Risk mitigation planning

### Use **Codebase Analyst** for:
- Large codebase analysis
- Legacy system assessment
- Technical debt evaluation
- Architecture review requirements
- Migration planning needs

### Use **Debugger** for:
- Complex bugs spanning multiple systems
- Performance degradation issues
- Hard-to-reproduce bugs
- Production incidents
- Concurrency-related problems

### Use **Tech Writer** for:
- Comprehensive documentation overhauls
- Complex API documentation
- Multi-audience documentation needs
- Documentation strategy development
- Accessibility compliance requirements

### Use **UI Designer** for:
- Comprehensive design system creation
- Complex user experience flows
- Cross-platform design consistency
- Design tool integration and workflow optimization
- Large-scale interface redesigns

### Use **Mobile UI** for:
- Cross-platform mobile design systems
- Complex mobile interaction patterns
- Mobile accessibility compliance
- Performance-critical mobile interfaces
- Platform-specific design optimizations

## Integration Patterns

### Sequential Workflows
```
Codebase Analyst → Backend Staff → Tech Writer
(Analysis) → (Implementation) → (Documentation)
```

### Parallel Execution
```
Backend Staff + Tech Writer + Project Orchestrator
(Parallel technical work with coordination)
```

### Escalation Chains
```
Debugger → Backend Staff → Principal Architect
(Issue complexity escalation)

Tech Writer → Product Strategy Expert → Principal Architect  
(Strategic documentation decisions)
```

## Usage Guidelines

1. **Start with appropriate complexity level** - Don't use staff-level agents for simple tasks
2. **Follow escalation paths** - Use defined escalation routes for complex decisions
3. **Leverage parallel execution** - Use compatible agents simultaneously when possible
4. **Respect boundaries** - Each agent has distinct, non-overlapping responsibilities
5. **Document decisions** - All agents should contribute to knowledge capture and documentation

## Tool Access Specification System

Each agent configuration includes standardized tool access patterns to ensure appropriate capabilities while maintaining security and role boundaries.

### Tool Access Categories

#### **full_access**
- **Agents**: Backend Staff
- **Tools**: All tools available
- **Purpose**: Implementation agents need complete tool access for development tasks
- **Includes**: Bash, Read, Write, Edit, MultiEdit, Glob, Grep, LS, WebFetch, WebSearch, TodoWrite, NotebookRead, NotebookEdit

#### **orchestration_access**
- **Agents**: Principal Architect, Project Orchestrator
- **Tools**: All tools + specialized project management capabilities
- **Purpose**: Leadership roles need full access for strategic coordination
- **Includes**: All tools with emphasis on coordination and management

#### **read_only_plus_analysis**
- **Agents**: Codebase Analyst, Debugger, Product Strategy Expert
- **Tools**: Read tools + analysis tools + TodoWrite
- **Purpose**: Analysis-focused roles need comprehensive read access but limited write capabilities
- **Includes**: Bash, Read, Glob, Grep, LS, WebFetch, WebSearch, TodoWrite
- **Excludes**: Write, Edit, MultiEdit, NotebookEdit (varies by agent)

#### **documentation_access**
- **Agents**: Tech Writer
- **Tools**: Read/write tools optimized for documentation
- **Purpose**: Documentation creation and maintenance
- **Includes**: Bash, Read, Write, Edit, MultiEdit, Glob, Grep, LS, WebFetch, WebSearch, TodoWrite
- **Excludes**: NotebookEdit (typically not needed for documentation)

#### **design_access**
- **Agents**: UI Designer, Mobile UI
- **Tools**: Read/write tools for design documentation and specifications
- **Purpose**: Design specification creation and collaboration
- **Includes**: Bash, Read, Write, Edit, MultiEdit, Glob, Grep, LS, WebFetch, WebSearch, TodoWrite
- **Excludes**: NotebookRead, NotebookEdit (not typically used in design workflows)

### Tool Access Configuration Format

```yaml
tool_access: [category_name]
tool_restrictions:
  allowed: [specific tools list]
  forbidden: [tools not allowed] 
  rationale: "Brief explanation of why this access pattern fits the role"
```

### Security & Role Boundaries

- **Analysis agents** have read-only access to prevent accidental modifications during investigation
- **Implementation agents** have full access to execute technical solutions
- **Leadership agents** have orchestration access for strategic coordination
- **Specialized agents** have tailored access matching their domain expertise
- All agents can create todos for task tracking and coordination