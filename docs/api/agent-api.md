# Agent System API Documentation

## Overview
The Claude Agent System provides a programmatic interface for invoking specialized AI agents, coordinating multi-agent workflows, and managing agent execution.

## Base Concepts

### Agent
An agent is a specialized AI entity with:
- Defined expertise domain
- Specific tool access permissions
- Clear interaction patterns
- Quality standards

### Task
A task is a unit of work assigned to an agent:
- Has clear objectives
- May have dependencies
- Can run in parallel or sequence
- Produces defined outputs

### Orchestration
Orchestration manages multi-agent execution:
- Plans optimal execution order
- Manages dependencies
- Enables parallel execution
- Handles result aggregation

## API Endpoints

### Agent Invocation

#### Direct Agent Call
```
POST /api/agents/invoke
```

**Request Body:**
```json
{
  "agent": "backend-engineer",
  "task": "Implement authentication service with JWT",
  "context": {
    "project": "e-commerce-platform",
    "requirements": ["OAuth2", "refresh tokens", "MFA"]
  },
  "options": {
    "timeout": 3600,
    "priority": "high"
  }
}
```

**Response:**
```json
{
  "execution_id": "exec_123456",
  "agent": "backend-engineer",
  "status": "in_progress",
  "started_at": "2024-01-15T10:00:00Z",
  "estimated_completion": "2024-01-15T11:00:00Z"
}
```

#### Command-Based Invocation
```
POST /api/commands/execute
```

**Request Body:**
```json
{
  "command": "/test",
  "args": ["--coverage", "--watch"],
  "working_directory": "/project/path"
}
```

**Response:**
```json
{
  "command": "test",
  "agent": "test-engineer",
  "execution_id": "exec_123457",
  "status": "completed",
  "results": {
    "tests_run": 156,
    "passed": 154,
    "failed": 2,
    "coverage": 82.5
  }
}
```

### Multi-Agent Orchestration

#### Create Orchestration Plan
```
POST /api/orchestration/plan
```

**Request Body:**
```json
{
  "project": "Build real-time chat application",
  "requirements": [
    "Web and mobile clients",
    "WebSocket support",
    "Message persistence",
    "User presence"
  ],
  "constraints": {
    "timeline": "2 weeks",
    "team_size": 5
  }
}
```

**Response:**
```json
{
  "plan_id": "plan_789",
  "phases": [
    {
      "phase": 1,
      "name": "Foundation",
      "agents": [
        {
          "agent": "backend-engineer",
          "task": "WebSocket server setup",
          "duration": "2 days"
        },
        {
          "agent": "frontend-engineer",
          "task": "Chat UI framework",
          "duration": "2 days"
        },
        {
          "agent": "mobile-staff",
          "task": "Mobile app skeleton",
          "duration": "2 days"
        }
      ],
      "execution_mode": "parallel"
    },
    {
      "phase": 2,
      "name": "Implementation",
      "agents": [
        {
          "agent": "backend-engineer",
          "task": "Message persistence",
          "duration": "3 days"
        },
        {
          "agent": "frontend-engineer",
          "task": "Chat features",
          "duration": "3 days"
        }
      ],
      "execution_mode": "parallel"
    }
  ],
  "total_duration": "10 days",
  "critical_path": ["WebSocket server", "Message persistence"]
}
```

#### Execute Orchestration Plan
```
POST /api/orchestration/execute
```

**Request Body:**
```json
{
  "plan_id": "plan_789",
  "options": {
    "parallel_limit": 4,
    "checkpoint_frequency": "daily",
    "failure_strategy": "pause"
  }
}
```

**Response:**
```json
{
  "orchestration_id": "orch_456",
  "status": "running",
  "current_phase": 1,
  "active_agents": [
    {
      "agent": "backend-engineer",
      "task": "WebSocket server setup",
      "progress": 45
    },
    {
      "agent": "frontend-engineer",
      "task": "Chat UI framework",
      "progress": 60
    }
  ],
  "estimated_completion": "2024-01-25T17:00:00Z"
}
```

### Agent Management

#### List Available Agents
```
GET /api/agents
```

**Response:**
```json
{
  "agents": [
    {
      "name": "backend-engineer",
      "category": "development",
      "expertise": ["distributed systems", "microservices"],
      "availability": "available"
    },
    {
      "name": "frontend-engineer",
      "category": "development",
      "expertise": ["real-time UI", "performance"],
      "availability": "busy"
    }
  ],
  "total": 25
}
```

#### Get Agent Details
```
GET /api/agents/{agent_name}
```

**Response:**
```json
{
  "name": "backend-engineer",
  "category": "development",
  "expertise": [
    "distributed systems",
    "microservices",
    "high-performance backends"
  ],
  "tool_access": {
    "read": true,
    "write": true,
    "execute": true,
    "deploy": false
  },
  "success_rate": 98.5,
  "average_task_duration": "2.5 hours",
  "current_load": 2,
  "max_parallel_tasks": 3
}
```

### Execution Monitoring

#### Get Execution Status
```
GET /api/executions/{execution_id}
```

**Response:**
```json
{
  "execution_id": "exec_123456",
  "agent": "backend-engineer",
  "task": "Implement authentication service",
  "status": "in_progress",
  "progress": 75,
  "logs": [
    {
      "timestamp": "2024-01-15T10:30:00Z",
      "message": "Database schema created"
    },
    {
      "timestamp": "2024-01-15T10:45:00Z",
      "message": "JWT implementation complete"
    }
  ],
  "artifacts": [
    "src/services/auth.js",
    "src/middleware/authenticate.js",
    "tests/auth.test.js"
  ]
}
```

#### Stream Execution Logs
```
GET /api/executions/{execution_id}/logs/stream
```

**Response:** Server-Sent Events stream
```
event: log
data: {"timestamp": "2024-01-15T10:46:00Z", "level": "info", "message": "Running tests..."}

event: progress
data: {"progress": 80, "phase": "testing"}

event: complete
data: {"status": "success", "duration": 3600, "test_results": {"passed": 25, "failed": 0}}
```

### Quality Assurance

#### Request Code Review
```
POST /api/qa/review
```

**Request Body:**
```json
{
  "scope": {
    "files": ["src/services/*.js"],
    "changes_since": "main"
  },
  "reviewers": ["code-reviewer", "security-auditor"],
  "options": {
    "parallel": true,
    "security_focus": ["authentication", "authorization"]
  }
}
```

**Response:**
```json
{
  "review_id": "review_987",
  "status": "in_progress",
  "reviewers": [
    {
      "agent": "code-reviewer",
      "status": "reviewing",
      "eta": "15 minutes"
    },
    {
      "agent": "security-auditor",
      "status": "reviewing",
      "eta": "20 minutes"
    }
  ]
}
```

## Webhooks

### Execution Complete
```
POST https://your-webhook-url.com/agent-complete
```

**Payload:**
```json
{
  "event": "execution.complete",
  "execution_id": "exec_123456",
  "agent": "backend-engineer",
  "status": "success",
  "duration": 3600,
  "artifacts": [
    "src/services/auth.js",
    "tests/auth.test.js"
  ],
  "metrics": {
    "lines_of_code": 450,
    "test_coverage": 95,
    "complexity": "moderate"
  }
}
```

### Orchestration Checkpoint
```
POST https://your-webhook-url.com/orchestration-checkpoint
```

**Payload:**
```json
{
  "event": "orchestration.checkpoint",
  "orchestration_id": "orch_456",
  "phase": 2,
  "status": "completed",
  "next_phase": 3,
  "overall_progress": 60,
  "agents_status": {
    "backend-engineer": "completed",
    "frontend-engineer": "completed",
    "test-engineer": "starting"
  }
}
```

## Error Handling

### Error Response Format
```json
{
  "error": {
    "code": "AGENT_UNAVAILABLE",
    "message": "The requested agent is currently at capacity",
    "details": {
      "agent": "backend-engineer",
      "current_load": 3,
      "max_capacity": 3,
      "retry_after": 300
    }
  }
}
```

### Error Codes

| Code | Description | Retry |
|------|-------------|-------|
| AGENT_NOT_FOUND | Requested agent doesn't exist | No |
| AGENT_UNAVAILABLE | Agent at capacity | Yes |
| TASK_TIMEOUT | Execution exceeded timeout | No |
| INVALID_PARAMETERS | Bad request parameters | No |
| DEPENDENCY_FAILED | Required task failed | No |
| ORCHESTRATION_ERROR | Multi-agent coordination failed | Yes |

## Rate Limits

### Default Limits
- **Agent Invocations**: 100 per hour
- **Orchestrations**: 10 per hour
- **Status Checks**: 1000 per hour
- **Log Streaming**: 50 concurrent connections

### Rate Limit Headers
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1705333200
```

## Authentication

### API Key Authentication
```
Authorization: Bearer sk_live_abcdef123456
```

### OAuth2 Flow
```
Authorization: Bearer oauth2_token_xyz789
```

## SDK Examples

### JavaScript/TypeScript
```typescript
import { ClaudeAgents } from '@anthropic/claude-agents';

const client = new ClaudeAgents({
  apiKey: process.env.CLAUDE_API_KEY
});

// Direct agent invocation
const result = await client.agents.invoke({
  agent: 'backend-engineer',
  task: 'Implement payment processing service',
  context: {
    gateway: 'stripe',
    requirements: ['subscriptions', 'one-time payments']
  }
});

// Multi-agent orchestration
const plan = await client.orchestration.plan({
  project: 'E-commerce platform',
  agents: ['backend-engineer', 'frontend-engineer', 'test-engineer']
});

const execution = await client.orchestration.execute(plan.id);
```

### Python
```python
from claude_agents import ClaudeAgents

client = ClaudeAgents(api_key=os.environ['CLAUDE_A_PI_KEY'])

# Command execution
result = client.commands.execute(
    command='/test',
    args=['--coverage'],
    working_directory='/project'
)

# Stream execution logs
for event in client.executions.stream_logs(execution_id):
    print(f"{event.timestamp}: {event.message}")
```

## Best Practices

### Agent Selection
1. Use the agent selector endpoint for recommendations
2. Consider task complexity when choosing agents
3. Prefer specialized agents over general-purpose

### Parallel Execution
1. Identify independent tasks
2. Set appropriate parallel limits
3. Handle partial failures gracefully

### Error Recovery Strategies
1. Implement exponential backoff for retries
2. Log all error responses
3. Have fallback strategies

### Performance
1. Use webhook notifications instead of polling
2. Cache agent availability
