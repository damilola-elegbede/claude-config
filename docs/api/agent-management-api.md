# Agent Management API Documentation

## Overview

The Claude Agent Management API provides comprehensive lifecycle management for the 28 specialized agents in the ecosystem. This API enables agent deployment, configuration, monitoring, scaling, and administration across all categories including Development, Infrastructure, Architecture, Design, Quality, Security, Analysis, and Operations.

## Table of Contents

1. [Agent Lifecycle Management](#agent-lifecycle-management)
2. [Agent Configuration](#agent-configuration)
3. [Agent Deployment](#agent-deployment)
4. [Agent Monitoring](#agent-monitoring)
5. [Agent Scaling](#agent-scaling)
6. [Agent Health & Diagnostics](#agent-health--diagnostics)
7. [Agent Performance Analytics](#agent-performance-analytics)
8. [Agent Version Control](#agent-version-control)

## Agent Lifecycle Management

### Create Agent

```http
POST /agents/manage/create
```

##### Request Body:

```json
{
  "name": "custom-backend-engineer",
  "description": "Specialized backend engineer for microservices architecture",
  "category": "development",
  "tools": ["Read", "Write", "Edit", "Bash", "Grep", "Glob"],
  "model": "sonnet",
  "color": "blue",
  "specializations": [
    "microservices",
    "event-driven-architecture",
    "high-performance-apis"
  ],
  "configuration": {
    "max_concurrent_tasks": 3,
    "timeout_minutes": 60,
    "retry_policy": {
      "max_retries": 3,
      "backoff_multiplier": 2
    }
  },
  "deployment": {
    "environment": "production",
    "resource_limits": {
      "memory_mb": 2048,
      "cpu_cores": 2
    }
  }
}
```

##### Response:

```json
{
  "agent": {
    "agent_id": "agent_123456",
    "name": "custom-backend-engineer",
    "description": "Specialized backend engineer for microservices architecture",
    "category": "development",
    "version": "1.0.0",
    "status": "deploying",
    "created_at": "2024-01-15T10:00:00Z",
    "created_by": "user_789",
    "tools": ["Read", "Write", "Edit", "Bash", "Grep", "Glob"],
    "model": "sonnet",
    "color": "blue",
    "specializations": [
      "microservices",
      "event-driven-architecture",
      "high-performance-apis"
    ],
    "configuration": {
      "max_concurrent_tasks": 3,
      "timeout_minutes": 60,
      "retry_policy": {
        "max_retries": 3,
        "backoff_multiplier": 2
      }
    },
    "deployment": {
      "environment": "production",
      "deployment_id": "deploy_abc123",
      "resource_limits": {
        "memory_mb": 2048,
        "cpu_cores": 2
      },
      "instances": 1,
      "health_check_url": "/agents/custom-backend-engineer/health"
    }
  },
  "deployment_status": {
    "phase": "initializing",
    "progress_percentage": 25,
    "estimated_completion": "2024-01-15T10:05:00Z"
  }
}
```

### List Agents

```http
GET /agents/manage/list
```

##### Query Parameters:

- `category` (optional): Filter by agent category
- `status` (optional): Filter by agent status
- `environment` (optional): Filter by deployment environment
- `limit` (optional): Number of agents to return
- `offset` (optional): Pagination offset

##### Response:

```json
{
  "agents": [
    {
      "agent_id": "agent_123456",
      "name": "backend-engineer",
      "description": "Server-side architecture and microservices specialist",
      "category": "development",
      "version": "2.1.3",
      "status": "active",
      "instances": 3,
      "current_load": 2,
      "success_rate": 98.5,
      "average_response_time": 2.3,
      "last_activity": "2024-01-15T09:58:00Z",
      "health_status": "healthy",
      "deployment": {
        "environment": "production",
        "deployed_at": "2024-01-10T08:00:00Z",
        "uptime_hours": 120.5
      }
    },
    {
      "agent_id": "agent_123457",
      "name": "security-auditor",
      "description": "Security vulnerability and compliance specialist",
      "category": "security",
      "version": "1.8.2",
      "status": "active",
      "instances": 2,
      "current_load": 1,
      "success_rate": 99.2,
      "average_response_time": 4.7,
      "last_activity": "2024-01-15T09:55:00Z",
      "health_status": "healthy",
      "deployment": {
        "environment": "production",
        "deployed_at": "2024-01-08T14:30:00Z",
        "uptime_hours": 164.5
      }
    }
  ],
  "total": 28,
  "pagination": {
    "limit": 10,
    "offset": 0,
    "total_pages": 3
  },
  "summary": {
    "by_category": {
      "development": 8,
      "infrastructure": 7,
      "architecture": 5,
      "security": 3,
      "quality": 5
    },
    "by_status": {
      "active": 26,
      "maintenance": 1,
      "error": 1
    },
    "total_instances": 84,
    "average_load": 2.1
  }
}
```

### Get Agent Details

```http
GET /agents/manage/{agent_id}
```

##### Response:

```json
{
  "agent": {
    "agent_id": "agent_123456",
    "name": "backend-engineer",
    "description": "Server-side architecture and microservices specialist",
    "category": "development",
    "version": "2.1.3",
    "status": "active",
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-10T08:00:00Z",
    "created_by": "system",
    "tools": ["Read", "Write", "Edit", "Bash", "Grep", "Glob"],
    "model": "sonnet",
    "color": "blue",
    "specializations": [
      "distributed-systems",
      "microservices",
      "high-performance-apis",
      "database-optimization"
    ],
    "configuration": {
      "max_concurrent_tasks": 3,
      "timeout_minutes": 60,
      "retry_policy": {
        "max_retries": 3,
        "backoff_multiplier": 2,
        "retry_on_codes": ["TIMEOUT", "SYSTEM_ERROR"]
      },
      "resource_allocation": {
        "cpu_weight": 1.0,
        "memory_weight": 1.0,
        "priority": "normal"
      }
    },
    "deployment": {
      "environment": "production",
      "deployment_id": "deploy_abc123",
      "deployed_at": "2024-01-10T08:00:00Z",
      "deployed_by": "admin_456",
      "instances": 3,
      "resource_limits": {
        "memory_mb": 2048,
        "cpu_cores": 2,
        "disk_mb": 1024
      },
      "health_check": {
        "url": "/agents/backend-engineer/health",
        "interval_seconds": 30,
        "timeout_seconds": 10,
        "failure_threshold": 3
      },
      "scaling": {
        "min_instances": 1,
        "max_instances": 5,
        "target_cpu_utilization": 70,
        "scale_up_cooldown": 300,
        "scale_down_cooldown": 600
      }
    },
    "metrics": {
      "total_invocations": 2547,
      "successful_invocations": 2509,
      "failed_invocations": 38,
      "success_rate": 98.5,
      "average_response_time": 2.3,
      "p95_response_time": 4.8,
      "current_load": 2,
      "peak_load": 3,
      "uptime_percentage": 99.8,
      "last_failure": "2024-01-14T16:30:00Z"
    },
    "health": {
      "status": "healthy",
      "last_health_check": "2024-01-15T10:00:00Z",
      "consecutive_failures": 0,
      "resource_usage": {
        "cpu_percentage": 45,
        "memory_percentage": 62,
        "disk_percentage": 23
      }
    }
  }
}
```

### Update Agent

```http
PUT /agents/manage/{agent_id}
```

##### Request Body:

```json
{
  "description": "Enhanced backend engineer with cloud-native capabilities",
  "specializations": [
    "distributed-systems",
    "microservices",
    "cloud-native-architecture",
    "serverless-computing"
  ],
  "configuration": {
    "max_concurrent_tasks": 4,
    "timeout_minutes": 90,
    "retry_policy": {
      "max_retries": 5,
      "backoff_multiplier": 1.5
    }
  },
  "deployment": {
    "resource_limits": {
      "memory_mb": 3072,
      "cpu_cores": 3
    },
    "scaling": {
      "max_instances": 8,
      "target_cpu_utilization": 60
    }
  }
}
```

##### Response:

```json
{
  "agent": {
    "agent_id": "agent_123456",
    "name": "backend-engineer",
    "version": "2.2.0",
    "status": "updating",
    "updated_at": "2024-01-15T10:00:00Z",
    "updated_by": "admin_456"
  },
  "update_status": {
    "phase": "applying_configuration",
    "progress_percentage": 30,
    "estimated_completion": "2024-01-15T10:10:00Z",
    "requires_restart": true
  },
  "changes": [
    {
      "field": "description",
      "old_value": "Server-side architecture and microservices specialist",
      "new_value": "Enhanced backend engineer with cloud-native capabilities"
    },
    {
      "field": "configuration.max_concurrent_tasks",
      "old_value": 3,
      "new_value": 4
    },
    {
      "field": "deployment.resource_limits.memory_mb",
      "old_value": 2048,
      "new_value": 3072
    }
  ]
}
```

### Delete Agent

```http
DELETE /agents/manage/{agent_id}
```

##### Query Parameters:

- `force` (optional): Force deletion even if agent has active tasks
- `backup` (optional): Create backup before deletion

##### Response:

```json
{
  "agent_id": "agent_123456",
  "name": "custom-backend-engineer",
  "deletion_status": "in_progress",
  "phase": "draining_tasks",
  "progress_percentage": 25,
  "estimated_completion": "2024-01-15T10:15:00Z",
  "active_tasks": 2,
  "backup_created": true,
  "backup_id": "backup_789xyz",
  "deleted_by": "admin_456",
  "deletion_initiated_at": "2024-01-15T10:00:00Z"
}
```

## Agent Configuration

### Get Agent Configuration

```http
GET /agents/manage/{agent_id}/configuration
```

##### Response:

```json
{
  "agent_id": "agent_123456",
  "configuration": {
    "runtime": {
      "max_concurrent_tasks": 3,
      "timeout_minutes": 60,
      "idle_timeout_minutes": 15,
      "memory_limit_mb": 2048,
      "cpu_limit_cores": 2
    },
    "retry_policy": {
      "max_retries": 3,
      "backoff_multiplier": 2,
      "initial_delay_ms": 1000,
      "max_delay_ms": 30000,
      "retry_on_codes": ["TIMEOUT", "SYSTEM_ERROR", "NETWORK_ERROR"]
    },
    "logging": {
      "level": "INFO",
      "structured": true,
      "include_request_id": true,
      "include_performance_metrics": true
    },
    "security": {
      "tool_restrictions": {
        "allowed_tools": ["Read", "Write", "Edit", "Bash", "Grep", "Glob"],
        "denied_tools": ["Task"],
        "file_access_patterns": ["src/**", "tests/**", "docs/**"],
        "denied_file_patterns": ["/etc/**", "/sys/**", "/proc/**"]
      },
      "network_access": {
        "enabled": false,
        "allowed_domains": [],
        "blocked_domains": ["*"]
      }
    },
    "performance": {
      "enable_caching": true,
      "cache_ttl_seconds": 300,
      "enable_compression": true,
      "max_response_size_mb": 10
    },
    "monitoring": {
      "enable_metrics": true,
      "enable_tracing": true,
      "health_check_interval": 30,
      "performance_sampling_rate": 0.1
    }
  },
  "version": "2.1.3",
  "last_updated": "2024-01-10T08:00:00Z",
  "updated_by": "admin_456"
}
```

### Update Agent Configuration

```http
PUT /agents/manage/{agent_id}/configuration
```

##### Request Body:

```json
{
  "runtime": {
    "max_concurrent_tasks": 4,
    "timeout_minutes": 90
  },
  "retry_policy": {
    "max_retries": 5,
    "backoff_multiplier": 1.5
  },
  "security": {
    "tool_restrictions": {
      "allowed_tools": ["Read", "Write", "Edit", "Bash", "Grep", "Glob", "WebFetch"]
    },
    "network_access": {
      "enabled": true,
      "allowed_domains": ["api.github.com", "api.slack.com"]
    }
  }
}
```

##### Response:

```json
{
  "agent_id": "agent_123456",
  "configuration_updated": true,
  "version": "2.2.0",
  "updated_at": "2024-01-15T10:00:00Z",
  "updated_by": "admin_456",
  "restart_required": true,
  "restart_scheduled": "2024-01-15T10:05:00Z",
  "changes": [
    {
      "section": "runtime",
      "field": "max_concurrent_tasks",
      "old_value": 3,
      "new_value": 4
    },
    {
      "section": "security.network_access",
      "field": "enabled",
      "old_value": false,
      "new_value": true
    }
  ]
}
```

## Agent Deployment

### Deploy Agent

```http
POST /agents/manage/{agent_id}/deploy
```

##### Request Body:

```json
{
  "environment": "production",
  "version": "2.2.0",
  "deployment_strategy": "rolling",
  "configuration": {
    "instances": 3,
    "resource_limits": {
      "memory_mb": 3072,
      "cpu_cores": 3
    },
    "health_check": {
      "enabled": true,
      "url": "/health",
      "interval_seconds": 30,
      "timeout_seconds": 10,
      "failure_threshold": 3
    }
  },
  "rollback_on_failure": true,
  "notification_webhooks": [
    "https://hooks.slack.com/services/deployment-notifications"
  ]
}
```

##### Response:

```json
{
  "deployment": {
    "deployment_id": "deploy_xyz789",
    "agent_id": "agent_123456",
    "environment": "production",
    "version": "2.2.0",
    "strategy": "rolling",
    "status": "in_progress",
    "phase": "health_checks",
    "progress_percentage": 60,
    "started_at": "2024-01-15T10:00:00Z",
    "estimated_completion": "2024-01-15T10:15:00Z",
    "deployed_by": "admin_456",
    "instances": {
      "total": 3,
      "healthy": 2,
      "unhealthy": 0,
      "pending": 1
    },
    "phases": [
      {
        "name": "pre_deployment_checks",
        "status": "completed",
        "duration_seconds": 30
      },
      {
        "name": "instance_deployment",
        "status": "completed",
        "duration_seconds": 180
      },
      {
        "name": "health_checks",
        "status": "in_progress",
        "duration_seconds": 90
      },
      {
        "name": "traffic_routing",
        "status": "pending",
        "estimated_duration_seconds": 60
      }
    ]
  },
  "monitoring": {
    "logs_url": "/agents/deploy_xyz789/logs",
    "metrics_url": "/agents/deploy_xyz789/metrics",
    "webhook_notifications": true
  }
}
```

### Get Deployment Status

```http
GET /agents/manage/deployments/{deployment_id}
```

##### Response:

```json
{
  "deployment": {
    "deployment_id": "deploy_xyz789",
    "agent_id": "agent_123456",
    "agent_name": "backend-engineer",
    "environment": "production",
    "version": "2.2.0",
    "strategy": "rolling",
    "status": "completed",
    "phase": "completed",
    "progress_percentage": 100,
    "started_at": "2024-01-15T10:00:00Z",
    "completed_at": "2024-01-15T10:12:30Z",
    "duration_seconds": 750,
    "deployed_by": "admin_456",
    "instances": {
      "total": 3,
      "healthy": 3,
      "unhealthy": 0,
      "pending": 0
    },
    "phases": [
      {
        "name": "pre_deployment_checks",
        "status": "completed",
        "started_at": "2024-01-15T10:00:00Z",
        "completed_at": "2024-01-15T10:00:30Z",
        "duration_seconds": 30,
        "checks": [
          {
            "name": "configuration_validation",
            "status": "passed"
          },
          {
            "name": "resource_availability",
            "status": "passed"
          }
        ]
      },
      {
        "name": "instance_deployment",
        "status": "completed",
        "started_at": "2024-01-15T10:00:30Z",
        "completed_at": "2024-01-15T10:03:30Z",
        "duration_seconds": 180,
        "instances_deployed": 3
      },
      {
        "name": "health_checks",
        "status": "completed",
        "started_at": "2024-01-15T10:03:30Z",
        "completed_at": "2024-01-15T10:05:00Z",
        "duration_seconds": 90,
        "health_checks_passed": 3
      },
      {
        "name": "traffic_routing",
        "status": "completed",
        "started_at": "2024-01-15T10:05:00Z",
        "completed_at": "2024-01-15T10:06:00Z",
        "duration_seconds": 60,
        "traffic_switched": true
      }
    ],
    "resource_usage": {
      "cpu_cores_allocated": 9,
      "memory_mb_allocated": 9216,
      "disk_mb_allocated": 3072
    },
    "success_criteria": {
      "all_instances_healthy": true,
      "performance_baseline_met": true,
      "error_rate_within_threshold": true
    }
  }
}
```

### Rollback Deployment

```http
POST /agents/manage/deployments/{deployment_id}/rollback
```

##### Request Body:

```json
{
  "reason": "Performance degradation detected",
  "target_version": "2.1.3",
  "immediate": false,
  "notification_webhooks": [
    "https://hooks.slack.com/services/rollback-notifications"
  ]
}
```

##### Response:

```json
{
  "rollback": {
    "rollback_id": "rollback_abc123",
    "deployment_id": "deploy_xyz789",
    "agent_id": "agent_123456",
    "reason": "Performance degradation detected",
    "from_version": "2.2.0",
    "to_version": "2.1.3",
    "status": "in_progress",
    "phase": "draining_traffic",
    "progress_percentage": 25,
    "started_at": "2024-01-15T10:20:00Z",
    "estimated_completion": "2024-01-15T10:30:00Z",
    "initiated_by": "admin_456",
    "immediate": false,
    "phases": [
      {
        "name": "traffic_draining",
        "status": "in_progress",
        "estimated_duration_seconds": 120
      },
      {
        "name": "instance_replacement",
        "status": "pending",
        "estimated_duration_seconds": 180
      },
      {
        "name": "health_verification",
        "status": "pending",
        "estimated_duration_seconds": 90
      }
    ]
  }
}
```

## Agent Monitoring

### Get Agent Metrics

```http
GET /agents/manage/{agent_id}/metrics
```

##### Query Parameters:

- `time_range` (optional): Time range for metrics (1h, 24h, 7d, 30d)
- `granularity` (optional): Data granularity (1m, 5m, 1h)
- `metrics` (optional): Specific metrics to retrieve

##### Response:

```json
{
  "agent_id": "agent_123456",
  "agent_name": "backend-engineer",
  "time_range": "24h",
  "granularity": "5m",
  "metrics": {
    "performance": {
      "invocations": {
        "total": 2547,
        "successful": 2509,
        "failed": 38,
        "success_rate": 98.5
      },
      "response_times": {
        "average_ms": 2300,
        "p50_ms": 1800,
        "p95_ms": 4800,
        "p99_ms": 8500,
        "max_ms": 15000
      },
      "throughput": {
        "requests_per_second": 0.7,
        "peak_rps": 2.3,
        "average_concurrent_tasks": 2.1
      }
    },
    "resource_usage": {
      "cpu": {
        "average_percentage": 45,
        "peak_percentage": 78,
        "current_percentage": 42
      },
      "memory": {
        "average_mb": 1280,
        "peak_mb": 1856,
        "current_mb": 1245,
        "limit_mb": 2048
      },
      "network": {
        "bytes_in": 15680234,
        "bytes_out": 8945612,
        "connections_active": 12
      }
    },
    "health": {
      "uptime_percentage": 99.8,
      "health_check_failures": 2,
      "last_failure": "2024-01-14T16:30:00Z",
      "consecutive_successes": 2880
    },
    "scaling": {
      "scale_up_events": 3,
      "scale_down_events": 1,
      "current_instances": 3,
      "instance_utilization": 70
    }
  },
  "time_series": [
    {
      "timestamp": "2024-01-15T09:00:00Z",
      "invocations": 12,
      "success_rate": 100,
      "average_response_time": 2100,
      "cpu_percentage": 38,
      "memory_mb": 1180
    },
    {
      "timestamp": "2024-01-15T09:05:00Z",
      "invocations": 15,
      "success_rate": 96.7,
      "average_response_time": 2400,
      "cpu_percentage": 52,
      "memory_mb": 1320
    }
  ]
}
```

### Get Agent Logs

```http
GET /agents/manage/{agent_id}/logs
```

##### Query Parameters:

- `start_time` (optional): Start time for log filtering
- `end_time` (optional): End time for log filtering
- `level` (optional): Log level filter (DEBUG, INFO, WARN, ERROR)
- `limit` (optional): Number of log entries to return
- `stream` (optional): Enable real-time log streaming

##### Response:

```json
{
  "agent_id": "agent_123456",
  "agent_name": "backend-engineer",
  "logs": [
    {
      "timestamp": "2024-01-15T10:00:00Z",
      "level": "INFO",
      "message": "Task execution started",
      "request_id": "req_123abc",
      "task_id": "task_456def",
      "context": {
        "task_type": "api_implementation",
        "user_id": "user_789",
        "execution_time_ms": null
      }
    },
    {
      "timestamp": "2024-01-15T10:00:02Z",
      "level": "DEBUG",
      "message": "Processing file: src/services/auth.js",
      "request_id": "req_123abc",
      "task_id": "task_456def",
      "context": {
        "file_path": "src/services/auth.js",
        "operation": "read"
      }
    },
    {
      "timestamp": "2024-01-15T10:00:15Z",
      "level": "INFO",
      "message": "Task execution completed successfully",
      "request_id": "req_123abc",
      "task_id": "task_456def",
      "context": {
        "execution_time_ms": 15000,
        "files_modified": 3,
        "lines_added": 245,
        "status": "success"
      }
    }
  ],
  "total_entries": 1547,
  "pagination": {
    "limit": 100,
    "offset": 0,
    "has_more": true
  },
  "filters_applied": {
    "time_range": "1h",
    "level": "INFO"
  }
}
```

### Agent Health Check

```http
GET /agents/manage/{agent_id}/health
```

##### Response:

```json
{
  "agent_id": "agent_123456",
  "agent_name": "backend-engineer",
  "health": {
    "status": "healthy",
    "last_check": "2024-01-15T10:00:00Z",
    "next_check": "2024-01-15T10:00:30Z",
    "consecutive_failures": 0,
    "uptime_seconds": 432000
  },
  "instances": [
    {
      "instance_id": "instance_001",
      "status": "healthy",
      "health_score": 0.98,
      "last_check": "2024-01-15T10:00:00Z",
      "response_time_ms": 45,
      "resource_usage": {
        "cpu_percentage": 42,
        "memory_percentage": 61,
        "disk_percentage": 23
      },
      "active_tasks": 2,
      "last_activity": "2024-01-15T09:58:00Z"
    },
    {
      "instance_id": "instance_002",
      "status": "healthy",
      "health_score": 0.95,
      "last_check": "2024-01-15T10:00:00Z",
      "response_time_ms": 52,
      "resource_usage": {
        "cpu_percentage": 38,
        "memory_percentage": 58,
        "disk_percentage": 25
      },
      "active_tasks": 1,
      "last_activity": "2024-01-15T09:57:30Z"
    },
    {
      "instance_id": "instance_003",
      "status": "healthy",
      "health_score": 0.99,
      "last_check": "2024-01-15T10:00:00Z",
      "response_time_ms": 38,
      "resource_usage": {
        "cpu_percentage": 35,
        "memory_percentage": 55,
        "disk_percentage": 20
      },
      "active_tasks": 3,
      "last_activity": "2024-01-15T09:59:45Z"
    }
  ],
  "checks": [
    {
      "name": "api_responsiveness",
      "status": "pass",
      "response_time_ms": 45,
      "last_check": "2024-01-15T10:00:00Z"
    },
    {
      "name": "resource_utilization",
      "status": "pass",
      "cpu_ok": true,
      "memory_ok": true,
      "disk_ok": true
    },
    {
      "name": "task_processing",
      "status": "pass",
      "active_tasks": 6,
      "queue_depth": 0,
      "processing_rate": "normal"
    }
  ]
}
```

## Agent Scaling

### Scale Agent

```http
POST /agents/manage/{agent_id}/scale
```

##### Request Body:

```json
{
  "target_instances": 5,
  "scaling_strategy": "gradual",
  "reason": "Increased load detected",
  "max_scaling_time_minutes": 10,
  "resource_requirements": {
    "memory_mb_per_instance": 2048,
    "cpu_cores_per_instance": 2
  },
  "health_check_grace_period": 60
}
```

##### Response:

```json
{
  "scaling_operation": {
    "operation_id": "scale_op_123",
    "agent_id": "agent_123456",
    "scaling_type": "scale_up",
    "from_instances": 3,
    "to_instances": 5,
    "status": "in_progress",
    "phase": "provisioning",
    "progress_percentage": 40,
    "started_at": "2024-01-15T10:00:00Z",
    "estimated_completion": "2024-01-15T10:08:00Z",
    "initiated_by": "auto_scaler",
    "reason": "Increased load detected",
    "strategy": "gradual",
    "phases": [
      {
        "name": "resource_validation",
        "status": "completed",
        "duration_seconds": 30
      },
      {
        "name": "instance_provisioning",
        "status": "in_progress",
        "target_instances": 2,
        "provisioned_instances": 1
      },
      {
        "name": "health_verification",
        "status": "pending"
      },
      {
        "name": "load_balancing",
        "status": "pending"
      }
    ]
  },
  "current_state": {
    "total_instances": 4,
    "healthy_instances": 3,
    "provisioning_instances": 1,
    "current_load": 2.8,
    "target_load": 2.0
  }
}
```

### Get Scaling History

```http
GET /agents/manage/{agent_id}/scaling/history
```

##### Response:

```json
{
  "agent_id": "agent_123456",
  "scaling_events": [
    {
      "operation_id": "scale_op_123",
      "scaling_type": "scale_up",
      "from_instances": 3,
      "to_instances": 5,
      "triggered_by": "auto_scaler",
      "trigger_reason": "CPU utilization > 80%",
      "started_at": "2024-01-15T10:00:00Z",
      "completed_at": "2024-01-15T10:07:45Z",
      "duration_seconds": 465,
      "status": "completed",
      "success": true
    },
    {
      "operation_id": "scale_op_122",
      "scaling_type": "scale_down",
      "from_instances": 4,
      "to_instances": 3,
      "triggered_by": "scheduler",
      "trigger_reason": "Low utilization during off-peak hours",
      "started_at": "2024-01-14T22:00:00Z",
      "completed_at": "2024-01-14T22:05:30Z",
      "duration_seconds": 330,
      "status": "completed",
      "success": true
    }
  ],
  "summary": {
    "total_scaling_events": 47,
    "scale_up_events": 28,
    "scale_down_events": 19,
    "successful_events": 46,
    "failed_events": 1,
    "average_scaling_time": 285,
    "last_scaling_event": "2024-01-15T10:00:00Z"
  }
}
```

### Configure Auto-scaling

```http
PUT /agents/manage/{agent_id}/scaling/config
```

##### Request Body:

```json
{
  "auto_scaling": {
    "enabled": true,
    "min_instances": 2,
    "max_instances": 8,
    "target_cpu_utilization": 70,
    "target_memory_utilization": 80,
    "scale_up_threshold": 80,
    "scale_down_threshold": 30,
    "scale_up_cooldown_minutes": 5,
    "scale_down_cooldown_minutes": 15,
    "scaling_policy": "aggressive"
  },
  "triggers": [
    {
      "metric": "cpu_utilization",
      "threshold": 80,
      "duration_seconds": 300,
      "action": "scale_up"
    },
    {
      "metric": "memory_utilization",
      "threshold": 85,
      "duration_seconds": 180,
      "action": "scale_up"
    },
    {
      "metric": "queue_depth",
      "threshold": 10,
      "duration_seconds": 120,
      "action": "scale_up"
    },
    {
      "metric": "cpu_utilization",
      "threshold": 30,
      "duration_seconds": 900,
      "action": "scale_down"
    }
  ],
  "notifications": {
    "enabled": true,
    "webhooks": [
      "https://hooks.slack.com/services/scaling-notifications"
    ],
    "email_alerts": ["admin@example.com"]
  }
}
```

##### Response:

```json
{
  "agent_id": "agent_123456",
  "auto_scaling_updated": true,
  "configuration": {
    "enabled": true,
    "min_instances": 2,
    "max_instances": 8,
    "target_cpu_utilization": 70,
    "target_memory_utilization": 80,
    "scaling_policy": "aggressive"
  },
  "triggers_configured": 4,
  "notifications_enabled": true,
  "updated_at": "2024-01-15T10:00:00Z",
  "updated_by": "admin_456",
  "next_evaluation": "2024-01-15T10:01:00Z"
}
```

## Agent Performance Analytics

### Get Performance Report

```http
GET /agents/manage/{agent_id}/analytics/performance
```

##### Query Parameters:

- `time_range`: Analysis time range (24h, 7d, 30d, 90d)
- `include_comparisons`: Include period-over-period comparisons
- `breakdown_by`: Breakdown dimension (hour, day, task_type)

##### Response:

```json
{
  "agent_id": "agent_123456",
  "agent_name": "backend-engineer",
  "report_period": {
    "start_date": "2024-01-08T00:00:00Z",
    "end_date": "2024-01-15T00:00:00Z",
    "duration_days": 7
  },
  "performance_summary": {
    "total_invocations": 1847,
    "successful_invocations": 1823,
    "failed_invocations": 24,
    "success_rate": 98.7,
    "average_response_time": 2.4,
    "p95_response_time": 5.2,
    "throughput_per_hour": 11.0,
    "peak_throughput": 32.0,
    "total_processing_time": 4434,
    "average_concurrent_tasks": 2.3
  },
  "trends": {
    "success_rate": {
      "current_period": 98.7,
      "previous_period": 97.9,
      "change_percentage": 0.8,
      "trend": "improving"
    },
    "response_time": {
      "current_period": 2.4,
      "previous_period": 2.8,
      "change_percentage": -14.3,
      "trend": "improving"
    },
    "throughput": {
      "current_period": 11.0,
      "previous_period": 9.5,
      "change_percentage": 15.8,
      "trend": "improving"
    }
  },
  "breakdown_by_task_type": [
    {
      "task_type": "api_implementation",
      "invocations": 724,
      "success_rate": 99.2,
      "average_response_time": 3.1,
      "percentage_of_total": 39.2
    },
    {
      "task_type": "database_optimization",
      "invocations": 412,
      "success_rate": 97.8,
      "average_response_time": 1.9,
      "percentage_of_total": 22.3
    },
    {
      "task_type": "microservice_design",
      "invocations": 387,
      "success_rate": 98.5,
      "average_response_time": 2.7,
      "percentage_of_total": 21.0
    }
  ],
  "performance_anomalies": [
    {
      "date": "2024-01-12",
      "anomaly_type": "response_time_spike",
      "description": "Response time increased by 40% between 14:00-16:00",
      "impact": "moderate",
      "resolution": "Auto-scaling triggered, resolved automatically"
    }
  ],
  "recommendations": [
    {
      "priority": "high",
      "category": "performance",
      "title": "Optimize database query patterns",
      "description": "Database optimization tasks show 15% faster completion when connection pooling is optimized",
      "estimated_impact": "10-15% response time improvement"
    },
    {
      "priority": "medium",
      "category": "scaling",
      "title": "Adjust auto-scaling thresholds",
      "description": "Current scaling triggers could be more responsive during peak hours",
      "estimated_impact": "Reduced queue wait times"
    }
  ]
}
```

## OpenAPI Specification

```yaml
openapi: 3.0.0
info:
  title: Claude Agent Management API
  version: 1.0.0
  description: Comprehensive agent lifecycle management API

security:
  - bearerAuth: []
  - apiKeyAuth: []

paths:
  /agents/manage/create:
    post:
      summary: Create new agent
      tags: [Agent Lifecycle]
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateAgentRequest'
      responses:
        201:
          description: Agent created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/AgentCreationResponse'

  /agents/manage/list:
    get:
      summary: List all agents
      tags: [Agent Lifecycle]
      parameters:
        - name: category
          in: query
          schema:
            type: string
            enum: [development, infrastructure, architecture, design, quality, security, analysis, operations]
        - name: status
          in: query
          schema:
            type: string
            enum: [active, inactive, maintenance, error]
        - name: limit
          in: query
          schema:
            type: integer
            minimum: 1
            maximum: 100
            default: 20
      responses:
        200:
          description: List of agents
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/AgentListResponse'

  /agents/manage/{agentId}:
    get:
      summary: Get agent details
      tags: [Agent Lifecycle]
      parameters:
        - name: agentId
          in: path
          required: true
          schema:
            type: string
      responses:
        200:
          description: Agent details
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/AgentDetailsResponse'

    put:
      summary: Update agent
      tags: [Agent Lifecycle]
      parameters:
        - name: agentId
          in: path
          required: true
          schema:
            type: string
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/UpdateAgentRequest'
      responses:
        200:
          description: Agent updated successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/AgentUpdateResponse'

    delete:
      summary: Delete agent
      tags: [Agent Lifecycle]
      parameters:
        - name: agentId
          in: path
          required: true
          schema:
            type: string
        - name: force
          in: query
          schema:
            type: boolean
            default: false
      responses:
        200:
          description: Agent deletion initiated
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/AgentDeletionResponse'

  /agents/manage/{agentId}/metrics:
    get:
      summary: Get agent metrics
      tags: [Agent Monitoring]
      parameters:
        - name: agentId
          in: path
          required: true
          schema:
            type: string
        - name: time_range
          in: query
          schema:
            type: string
            enum: [1h, 24h, 7d, 30d]
            default: 24h
      responses:
        200:
          description: Agent metrics
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/AgentMetricsResponse'

components:
  schemas:
    CreateAgentRequest:
      type: object
      required:
        - name
        - description
        - category
        - tools
      properties:
        name:
          type: string
          pattern: '^[a-z]+(-[a-z]+)*$'
        description:
          type: string
        category:
          type: string
          enum: [development, infrastructure, architecture, design, quality, security, analysis, operations]
        tools:
          type: array
          items:
            type: string
        model:
          type: string
          enum: [sonnet, haiku, opus]
          default: sonnet
        color:
          type: string
          enum: [blue, red, yellow, purple, teal, orange, white, brown, cyan, pink, green]
        specializations:
          type: array
          items:
            type: string
        configuration:
          $ref: '#/components/schemas/AgentConfiguration'

    AgentConfiguration:
      type: object
      properties:
        max_concurrent_tasks:
          type: integer
          minimum: 1
          maximum: 10
          default: 3
        timeout_minutes:
          type: integer
          minimum: 5
          maximum: 180
          default: 60
        retry_policy:
          type: object
          properties:
            max_retries:
              type: integer
              minimum: 0
              maximum: 10
              default: 3
            backoff_multiplier:
              type: number
              minimum: 1.0
              maximum: 5.0
              default: 2.0

    AgentCreationResponse:
      type: object
      properties:
        agent:
          $ref: '#/components/schemas/Agent'
        deployment_status:
          type: object
          properties:
            phase:
              type: string
            progress_percentage:
              type: integer
            estimated_completion:
              type: string
              format: date-time

    Agent:
      type: object
      properties:
        agent_id:
          type: string
        name:
          type: string
        description:
          type: string
        category:
          type: string
        version:
          type: string
        status:
          type: string
          enum: [active, inactive, maintenance, error, deploying, updating]
        created_at:
          type: string
          format: date-time
        updated_at:
          type: string
          format: date-time
        instances:
          type: integer
        current_load:
          type: integer
        success_rate:
          type: number
        average_response_time:
          type: number
        health_status:
          type: string
          enum: [healthy, degraded, unhealthy]

    AgentListResponse:
      type: object
      properties:
        agents:
          type: array
          items:
            $ref: '#/components/schemas/Agent'
        total:
          type: integer
        pagination:
          type: object
          properties:
            limit:
              type: integer
            offset:
              type: integer
            total_pages:
              type: integer
        summary:
          type: object
          properties:
            by_category:
              type: object
              additionalProperties:
                type: integer
            by_status:
              type: object
              additionalProperties:
                type: integer

  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
    apiKeyAuth:
      type: apiKey
      in: header
      name: X-API-Key
```

## Best Practices

### Agent Lifecycle Management

1. **Planning**
   - Define clear agent specifications before creation
   - Consider resource requirements and scaling needs
   - Plan for monitoring and observability

2. **Deployment**
   - Use staged deployments for production environments
   - Implement comprehensive health checks
   - Plan rollback strategies

3. **Monitoring**
   - Monitor key performance metrics continuously
   - Set up alerting for anomalies
   - Regular performance analysis and optimization

4. **Scaling**
   - Configure auto-scaling based on usage patterns
   - Monitor resource utilization trends
   - Plan for peak load scenarios

5. **Maintenance**
   - Regular agent updates and security patches
   - Performance tuning based on analytics
   - Capacity planning for growth

---

The Agent Management API provides enterprise-grade lifecycle management for the Claude agent ecosystem, enabling scalable, reliable, and high-performance agent operations across all categories and use cases.
