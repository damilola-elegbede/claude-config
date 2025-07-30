# Agent Ecosystem API Documentation

## Overview

The Claude Agent Ecosystem provides a sophisticated multi-agent orchestration system where specialized AI agents can be invoked to handle specific tasks. This document provides comprehensive API documentation for interacting with the agent ecosystem.

## Table of Contents

1. [Agent Invocation API](#agent-invocation-api)
2. [Agent Capability API](#agent-capability-api)
3. [Agent YAML Specification](#agent-yaml-specification)
4. [System Boundary & Security Model](#system-boundary--security-model)
5. [Tool Access Patterns](#tool-access-patterns)
6. [API Examples](#api-examples)
7. [Error Handling](#error-handling)
8. [Multi-Agent Workflows](#multi-agent-workflows)

## Agent Invocation API

### Task Tool Interface

The primary method for invoking agents is through the `Task` tool. This tool serves as the orchestration interface for launching specialized agents.

```typescript
interface TaskInvocation {
  description: string;    // 3-5 word task description
  prompt: string;        // Detailed task instructions
  subagent_type: string; // Agent identifier (e.g., "backend-engineer")
}
```

### OpenAPI Specification

```yaml
openapi: 3.0.0
info:
  title: Agent Invocation API
  version: 1.0.0
paths:
  /agent/invoke:
    post:
      summary: Invoke a specialized agent
      operationId: invokeAgent
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required:
                - description
                - prompt
                - subagent_type
              properties:
                description:
                  type: string
                  minLength: 3
                  maxLength: 50
                  description: Brief task description (3-5 words)
                prompt:
                  type: string
                  description: Detailed task instructions for the agent
                subagent_type:
                  $ref: '#/components/schemas/AgentType'
      responses:
        200:
          description: Agent execution successful
          content:
            application/json:
              schema:
                type: object
                properties:
                  status:
                    $ref: '#/components/schemas/ExecutionStatus'
                  result:
                    type: string
                    description: Agent's response and findings
                  metadata:
                    type: object
                    properties:
                      agent_type:
                        type: string
                      execution_time:
                        type: number
                      tools_used:
                        type: array
                        items:
                          type: string
```

## Agent Capability API

### List Available Agents

```yaml
/agents/list:
  get:
    summary: List all available agents with capabilities
    operationId: listAgents
    responses:
      200:
        description: List of available agents
        content:
          application/json:
            schema:
              type: array
              items:
                $ref: '#/components/schemas/AgentInfo'
```

### Agent Suggestion API

```yaml
/agents/suggest:
  post:
    summary: Get agent recommendations for a task
    operationId: suggestAgents
    requestBody:
      required: true
      content:
        application/json:
          schema:
            type: object
            properties:
              task:
                type: string
                description: Task description
    responses:
      200:
        description: Suggested agents for the task
        content:
          application/json:
            schema:
              type: array
              items:
                type: object
                properties:
                  agent_type:
                    type: string
                  relevance_score:
                    type: number
                    minimum: 0
                    maximum: 1
                  reasoning:
                    type: string
```

## Agent YAML Specification

### Example Agent YAML

```yaml
---
name: backend-engineer
description: Use for building server-side systems, APIs, microservices, databases, and distributed architectures
tools: Read, Write, Edit, MultiEdit, Grep, Glob, LS, Bash, TodoWrite
color: blue
category: development
---
```

## System Boundary & Security Model

### Security Model

1. **Hierarchical Control**: Only Claude (main orchestrator) can invoke agents
2. **No Lateral Movement**: Agents cannot invoke other agents
3. **Tool Sandboxing**: Each agent has specific tool access
4. **Automatic Termination**: Boundary violations cause immediate termination
5. **Audit Trail**: All agent invocations are logged

## Tool Access Patterns

### By Category

```yaml
ToolAccessPatterns:
  development:
    common_tools: [Read, Write, Edit, MultiEdit, Grep, Glob, LS, Bash, TodoWrite]
    description: Full development capabilities including file manipulation
    
  infrastructure:
    common_tools: [Read, Write, Edit, MultiEdit, Grep, Glob, LS, Bash, TodoWrite, WebFetch]
    description: Infrastructure management with web access for cloud APIs
    
  architecture:
    common_tools: [Read, Write, Edit, Grep, Glob, LS, TodoWrite]
    description: Design and documentation focused tools
    
  design:
    common_tools: [Read, Write, Edit, Grep, Glob, LS, TodoWrite]
    description: UI/UX design and documentation tools
    
  quality:
    common_tools: [Read, Grep, Glob, LS, Bash, TodoWrite]
    description: Analysis and testing tools, limited write access
    
  security:
    common_tools: [Read, Grep, Glob, LS, TodoWrite]
    description: Read-only analysis tools for security auditing
    
  analysis:
    common_tools: [Read, Grep, Glob, LS, TodoWrite, WebFetch]
    description: Research and analysis tools with web access
    
  operations:
    common_tools: [Read, Write, Grep, Glob, Bash]
    description: Operational tools for automation and management
```

## API Examples

### Example 1: Backend Service Implementation

```json
{
  "description": "Build user service",
  "prompt": "Create a RESTful user service with authentication, including:\n- User registration and login endpoints\n- JWT token generation\n- PostgreSQL database integration\n- Input validation and error handling\n- Unit and integration tests",
  "subagent_type": "backend-engineer"
}
```

### Example 2: Security Audit

```json
{
  "description": "Security audit API",
  "prompt": "Perform comprehensive security audit of the authentication system:\n- Check for OWASP Top 10 vulnerabilities\n- Review JWT implementation\n- Analyze password storage\n- Check for SQL injection risks\n- Provide remediation recommendations",
  "subagent_type": "security-auditor"
}
```

### Example 3: Multi-Agent Parallel Execution

```javascript
// Parallel agent invocation pattern
const agents = [
  {
    description: "Backend API dev",
    prompt: "Implement user management API",
    subagent_type: "backend-engineer"
  },
  {
    description: "Frontend UI build",
    prompt: "Create React user dashboard",
    subagent_type: "frontend-engineer"
  },
  {
    description: "API documentation",
    prompt: "Generate OpenAPI spec for user API",
    subagent_type: "api-documenter"
  }
];

// Execute in parallel (orchestrated by Claude)
```

## Error Handling

### Common Error Scenarios

1. **Agent Not Found**
   ```json
   {
     "error": {
       "code": "AGENT_NOT_FOUND",
       "message": "Agent type 'invalid-agent' does not exist",
       "details": {
         "agent_type": "invalid-agent",
         "timestamp": "2024-01-30T10:00:00Z"
       }
     }
   }
   ```

2. **Boundary Violation**
   ```json
   {
     "error": {
       "code": "BOUNDARY_VIOLATION",
       "message": "Agent attempted to use restricted Task tool",
       "details": {
         "agent_type": "backend-engineer",
         "attempted_action": "Task invocation",
         "timestamp": "2024-01-30T10:00:00Z"
       }
     }
   }
   ```

## Multi-Agent Workflows

### Orchestration Patterns

#### Pattern 1: Parallel Development
```yaml
workflow:
  name: full-stack-feature
  phases:
    - name: parallel-implementation
      agents:
        - type: backend-engineer
          task: API development
        - type: frontend-engineer
          task: UI implementation
        - type: test-engineer
          task: Test suite creation
    - name: integration
      agents:
        - type: integration-specialist
          task: Connect frontend to backend
    - name: validation
      agents:
        - type: code-reviewer
          task: Review implementation
        - type: security-auditor
          task: Security validation
```

#### Pattern 2: Analysis Pipeline
```yaml
workflow:
  name: codebase-analysis
  phases:
    - name: discovery
      agents:
        - type: codebase-analyst
          task: Architecture analysis
        - type: security-auditor
          task: Security assessment
        - type: performance-analyst
          task: Performance review
    - name: reporting
      agents:
        - type: tech-writer
          task: Consolidate findings
```

### Integration Best Practices

1. **Phase Dependencies**: Define clear dependencies between workflow phases
2. **Data Handoff**: Use structured formats for agent communication
3. **Error Propagation**: Handle failures gracefully with fallback strategies
4. **Result Aggregation**: Combine outputs from parallel agents effectively
5. **Progress Tracking**: Monitor workflow execution status

### Advanced Integration Example

```json
{
  "workflow": {
    "id": "microservice-deployment",
    "phases": [
      {
        "phase": 1,
        "parallel": true,
        "agents": [
          {
            "type": "backend-engineer",
            "instances": 3,
            "tasks": [
              "User service implementation",
              "Payment service implementation",
              "Notification service implementation"
            ]
          }
        ]
      },
      {
        "phase": 2,
        "parallel": true,
        "dependencies": ["phase-1"],
        "agents": [
          {
            "type": "test-engineer",
            "task": "Integration testing"
          },
          {
            "type": "api-documenter",
            "task": "API documentation"
          },
          {
            "type": "devops",
            "task": "Container setup"
          }
        ]
      },
      {
        "phase": 3,
        "dependencies": ["phase-2"],
        "agents": [
          {
            "type": "cloud-architect",
            "task": "Deploy to Kubernetes"
          }
        ]
      }
    ]
  }
}
```

## Summary

The Agent Ecosystem API provides a powerful, secure, and flexible system for orchestrating specialized AI agents. Key features include:

- **Hierarchical Control**: Centralized orchestration through Claude
- **Parallel Execution**: Efficient multi-agent workflows
- **Strong Security**: Boundary enforcement and sandboxing
- **Tool Specialization**: Category-specific tool access
- **Comprehensive Error Handling**: Detailed error responses
- **Flexible Integration**: Support for complex workflows

---

## Components

```yaml
components:
  schemas:
    AgentType:
      type: string
      description: Available agent types in the ecosystem
      enum:
        - general-purpose
        - file-writer
        - tech-writer
        - network-engineer
        - mobile-engineer
        - file-navigator
        - backend-engineer
        - data-engineer
        - devops
        - api-architect
        - config-specialist
        - log-analyst
        - integration-specialist
        - kubernetes-admin
        - ui-designer
        - frontend-engineer
        - incident-commander
        - design-system
        - monitoring-specialist
        - cloud-architect
        - api-contract-tester
        - security-auditor
        - product-strategist
        - business-analyst
        - dependency-manager
        - data-scientist
        - documentation-finder
        - researcher
        - ux-researcher
        - security-tester
        - agent-auditor
        - platform-engineer
        - database-admin
        - error-resolver
        - git-workflow
        - performance-analyst
        - debugger
        - database-migration-specialist
        - api-documenter
        - performance-engineer
        - search-coordinator
        - test-engineer
        - ml-engineer
        - accessibility-auditor
        - code-reviewer
        - codebase-analyst
        - principal-architect
        - mobile-ui

    ExecutionStatus:
      type: string
      description: Agent execution status
      enum:
        - pending
        - running
        - completed
        - failed
        - timeout

    AgentColor:
      type: string
      description: Agent visual identifier colors
      enum:
        - blue
        - red
        - yellow
        - purple
        - teal
        - orange
        - white
        - brown
        - cyan
        - pink
        - green

    AgentCategory:
      type: string
      description: Agent category classifications
      enum:
        - development
        - infrastructure
        - architecture
        - design
        - quality
        - security
        - analysis
        - operations

    ErrorCode:
      type: string
      description: Error code identifiers
      enum:
        - AGENT_NOT_FOUND
        - AGENT_UNAVAILABLE
        - TASK_TIMEOUT
        - INVALID_PARAMETERS
        - DEPENDENCY_FAILED
        - ORCHESTRATION_ERROR
        - BOUNDARY_VIOLATION
        - SYSTEM_ERROR
    
    AgentInfo:
      type: object
      required:
        - agent_type
        - description
        - tools
        - color
        - category
      properties:
        agent_type:
          type: string
        description:
          type: string
        tools:
          type: array
          items:
            type: string
        color:
          type: string
        category:
          type: string
    
    AgentInvocationRequest:
      type: object
      required:
        - description
        - prompt
        - subagent_type
      properties:
        description:
          type: string
          description: Short description of the task
        prompt:
          type: string
          description: Detailed task for the agent
        subagent_type:
          $ref: '#/components/schemas/AgentType'
    
    AgentInvocationResponse:
      type: object
      properties:
        status:
          type: string
        result:
          type: string
        agent_type:
          type: string
        execution_time:
          type: number

    AgentSpecification:
      type: object
      required:
        - name
        - description
        - tools
        - color
        - category
      properties:
        name:
          type: string
          pattern: '^[a-z]+(-[a-z]+)*$'
          description: Unique identifier (lowercase, hyphenated)
        description:
          type: string
          description: Natural language purpose of the agent
        tools:
          type: string
          description: Comma-separated list of tools
          example: "Read, Write, Edit, Grep, Glob, LS, Bash"
        color:
          $ref: '#/components/schemas/AgentColor'
          description: Visual identifier color
        category:
          $ref: '#/components/schemas/AgentCategory'
          description: Agent category classification

    SecurityBoundary:
      type: object
      properties:
        task_tool_restriction:
          type: string
          enum: ["RESERVED_FOR_CLAUDE_ONLY"]
          description: Task tool is exclusively reserved for the main Claude orchestrator
        agent_limitations:
          type: array
          items:
            type: string
          example:
            - "Cannot invoke other agents"
            - "Cannot use Task tool"
            - "Cannot orchestrate workflows"
            - "Must operate within assigned tools"
        termination_triggers:
          type: array
          items:
            type: string
          example:
            - "Attempting to use Task tool"
            - "Attempting recursive agent calls"
            - "Violating tool access boundaries"

    ErrorResponse:
      type: object
      properties:
        error:
          type: object
          properties:
            code:
              $ref: '#/components/schemas/ErrorCode'
            message:
              type: string
            details:
              type: object
              properties:
                agent_type:
                  type: string
                attempted_action:
                  type: string
                timestamp:
                  type: string
                  format: date-time
```