# System Administration API Documentation

## Overview

The Claude Code CLI System Administration API provides comprehensive management capabilities for the entire Claude ecosystem. This API enables system configuration, user management, monitoring, maintenance, and administrative operations across all components including agents, commands, MCP servers, and infrastructure.

## Table of Contents

1. [System Configuration](#system-configuration)
2. [User Management](#user-management)
3. [System Monitoring](#system-monitoring)
4. [Maintenance Operations](#maintenance-operations)
5. [Audit & Compliance](#audit--compliance)
6. [Backup & Recovery](#backup--recovery)
7. [Security Administration](#security-administration)
8. [Resource Management](#resource-management)

## System Configuration

### Get System Configuration

```http
GET /admin/system/config
```

**Response:**

```json
{
  "system": {
    "version": "2.1.3",
    "environment": "production",
    "cluster_id": "claude-prod-cluster-1",
    "region": "us-west-2",
    "deployed_at": "2024-01-01T00:00:00Z",
    "uptime_seconds": 1296000,
    "configuration": {
      "authentication": {
        "jwt_expiry_hours": 24,
        "refresh_token_expiry_days": 30,
        "mfa_required": true,
        "session_timeout_minutes": 120,
        "max_concurrent_sessions": 5
      },
      "agents": {
        "total_agents": 28,
        "default_timeout_minutes": 60,
        "max_concurrent_tasks_per_agent": 3,
        "auto_scaling_enabled": true,
        "health_check_interval_seconds": 30,
        "instance_limits": {
          "min_total_instances": 28,
          "max_total_instances": 140,
          "max_instances_per_agent": 8
        }
      },
      "commands": {
        "total_commands": 20,
        "execution_timeout_minutes": 30,
        "parallel_execution_limit": 10,
        "audit_all_executions": true
      },
      "mcp_servers": {
        "total_servers": 6,
        "routing_strategy": "performance_first",
        "health_check_interval_seconds": 15,
        "connection_timeout_seconds": 10,
        "max_connections_per_server": 100
      },
      "performance": {
        "cache_enabled": true,
        "cache_ttl_seconds": 300,
        "compression_enabled": true,
        "request_rate_limit": 1000,
        "burst_limit": 50
      },
      "monitoring": {
        "metrics_retention_days": 90,
        "log_retention_days": 30,
        "audit_log_retention_days": 365,
        "real_time_monitoring": true,
        "alerting_enabled": true
      }
    }
  },
  "components": {
    "api_gateway": {
      "status": "healthy",
      "version": "1.5.2",
      "instances": 3,
      "health_score": 0.98
    },
    "authentication_service": {
      "status": "healthy",
      "version": "2.1.1",
      "instances": 2,
      "health_score": 0.99
    },
    "agent_orchestrator": {
      "status": "healthy",
      "version": "2.1.3",
      "instances": 5,
      "health_score": 0.97
    },
    "mcp_router": {
      "status": "healthy",
      "version": "1.3.4",
      "instances": 2,
      "health_score": 0.98
    },
    "monitoring_service": {
      "status": "healthy",
      "version": "1.2.1",
      "instances": 2,
      "health_score": 0.96
    }
  }
}
```

### Update System Configuration

```http
PUT /admin/system/config
```

**Request Body:**

```json
{
  "authentication": {
    "jwt_expiry_hours": 12,
    "session_timeout_minutes": 90,
    "mfa_required": true
  },
  "agents": {
    "default_timeout_minutes": 90,
    "max_concurrent_tasks_per_agent": 4,
    "auto_scaling_enabled": true,
    "instance_limits": {
      "max_instances_per_agent": 10
    }
  },
  "performance": {
    "request_rate_limit": 1500,
    "burst_limit": 75
  },
  "monitoring": {
    "metrics_retention_days": 120,
    "real_time_monitoring": true
  }
}
```

**Response:**

```json
{
  "configuration_updated": true,
  "updated_at": "2024-01-15T10:00:00Z",
  "updated_by": "admin_456",
  "changes": [
    {
      "section": "authentication",
      "field": "jwt_expiry_hours",
      "old_value": 24,
      "new_value": 12,
      "requires_restart": false
    },
    {
      "section": "agents",
      "field": "default_timeout_minutes",
      "old_value": 60,
      "new_value": 90,
      "requires_restart": false
    },
    {
      "section": "performance",
      "field": "request_rate_limit",
      "old_value": 1000,
      "new_value": 1500,
      "requires_restart": false
    }
  ],
  "restart_required": false,
  "rollback_available": true,
  "rollback_token": "rollback_token_abc123"
}
```

### System Health Check

```http
GET /admin/system/health
```

**Response:**

```json
{
  "overall_status": "healthy",
  "health_score": 0.97,
  "last_check": "2024-01-15T10:00:00Z",
  "components": {
    "api_gateway": {
      "status": "healthy",
      "health_score": 0.98,
      "response_time_ms": 12,
      "uptime_percentage": 99.95,
      "instances": {
        "total": 3,
        "healthy": 3,
        "unhealthy": 0
      }
    },
    "authentication_service": {
      "status": "healthy",
      "health_score": 0.99,
      "response_time_ms": 8,
      "uptime_percentage": 99.98,
      "instances": {
        "total": 2,
        "healthy": 2,
        "unhealthy": 0
      }
    },
    "agent_orchestrator": {
      "status": "healthy",
      "health_score": 0.97,
      "response_time_ms": 15,
      "uptime_percentage": 99.92,
      "instances": {
        "total": 5,
        "healthy": 5,
        "unhealthy": 0
      },
      "agent_stats": {
        "total_agents": 28,
        "active_agents": 28,
        "total_instances": 84,
        "healthy_instances": 82,
        "degraded_instances": 2
      }
    },
    "mcp_router": {
      "status": "healthy",
      "health_score": 0.98,
      "response_time_ms": 5,
      "routing_decisions_per_second": 247,
      "success_rate": 99.8,
      "servers": {
        "total": 6,
        "connected": 6,
        "disconnected": 0
      }
    },
    "database": {
      "status": "healthy",
      "health_score": 0.96,
      "connection_pool_usage": 45,
      "query_performance": "optimal",
      "storage_usage_percentage": 67
    },
    "monitoring_service": {
      "status": "healthy",
      "health_score": 0.96,
      "metrics_ingestion_rate": 12500,
      "log_ingestion_rate": 8900,
      "alert_processing_time": 2.3
    }
  },
  "alerts": [
    {
      "severity": "warning",
      "component": "agent_orchestrator",
      "message": "2 agent instances showing degraded performance",
      "timestamp": "2024-01-15T09:55:00Z"
    }
  ]
}
```

## User Management

### List Users

```http
GET /admin/users
```

**Query Parameters:**

- `status` (optional): Filter by user status (active, inactive, locked)
- `role` (optional): Filter by user role
- `limit` (optional): Number of users to return
- `search` (optional): Search by username or email

**Response:**

```json
{
  "users": [
    {
      "user_id": "user_123",
      "username": "john.doe",
      "email": "john.doe@example.com",
      "role": "admin",
      "status": "active",
      "created_at": "2024-01-01T00:00:00Z",
      "last_login": "2024-01-15T09:30:00Z",
      "login_count": 247,
      "mfa_enabled": true,
      "permissions": [
        "system:admin",
        "agent:invoke:*",
        "command:execute:*"
      ],
      "session_count": 2,
      "last_activity": "2024-01-15T09:45:00Z"
    },
    {
      "user_id": "user_124",
      "username": "jane.smith",
      "email": "jane.smith@example.com",
      "role": "developer",
      "status": "active",
      "created_at": "2024-01-02T00:00:00Z",
      "last_login": "2024-01-15T08:15:00Z",
      "login_count": 89,
      "mfa_enabled": true,
      "permissions": [
        "agent:invoke:development",
        "command:execute"
      ],
      "session_count": 1,
      "last_activity": "2024-01-15T08:30:00Z"
    }
  ],
  "total": 47,
  "pagination": {
    "limit": 25,
    "offset": 0,
    "total_pages": 2
  },
  "summary": {
    "by_role": {
      "admin": 3,
      "developer": 28,
      "analyst": 12,
      "viewer": 4
    },
    "by_status": {
      "active": 44,
      "inactive": 2,
      "locked": 1
    },
    "mfa_enabled": 41,
    "active_sessions": 67
  }
}
```

### Create User

```http
POST /admin/users
```

**Request Body:**

```json
{
  "username": "new.user",
  "email": "new.user@example.com",
  "role": "developer",
  "permissions": [
    "agent:invoke:development",
    "command:execute",
    "system:read"
  ],
  "temporary_password": true,
  "require_mfa": true,
  "notification_preferences": {
    "email_notifications": true,
    "security_alerts": true
  }
}
```

**Response:**

```json
{
  "user": {
    "user_id": "user_125",
    "username": "new.user",
    "email": "new.user@example.com",
    "role": "developer",
    "status": "active",
    "created_at": "2024-01-15T10:00:00Z",
    "created_by": "admin_456",
    "permissions": [
      "agent:invoke:development",
      "command:execute",
      "system:read"
    ],
    "mfa_enabled": false,
    "mfa_required": true
  },
  "temporary_password": "TempPass123!",
  "password_expires_at": "2024-01-22T10:00:00Z",
  "setup_instructions": {
    "steps": [
      "User must change password on first login",
      "User must setup MFA during first session",
      "Welcome email sent to user@example.com"
    ]
  }
}
```

### Update User

```http
PUT /admin/users/{user_id}
```

**Request Body:**

```json
{
  "role": "senior_developer",
  "permissions": [
    "agent:invoke:*",
    "command:execute:*",
    "system:read"
  ],
  "status": "active",
  "notification_preferences": {
    "email_notifications": true,
    "security_alerts": true,
    "maintenance_notifications": true
  }
}
```

**Response:**

```json
{
  "user_id": "user_124",
  "updated": true,
  "updated_at": "2024-01-15T10:00:00Z",
  "updated_by": "admin_456",
  "changes": [
    {
      "field": "role",
      "old_value": "developer",
      "new_value": "senior_developer"
    },
    {
      "field": "permissions",
      "added": ["agent:invoke:security", "agent:invoke:operations"],
      "removed": []
    }
  ],
  "notification_sent": true
}
```

### Lock/Unlock User

```http
POST /admin/users/{user_id}/lock
```

**Request Body:**

```json
{
  "reason": "Suspicious activity detected",
  "duration_hours": 24,
  "notify_user": true,
  "admin_comment": "Account locked pending security investigation"
}
```

**Response:**

```json
{
  "user_id": "user_124",
  "locked": true,
  "locked_at": "2024-01-15T10:00:00Z",
  "locked_by": "admin_456",
  "reason": "Suspicious activity detected",
  "unlock_at": "2024-01-16T10:00:00Z",
  "active_sessions_terminated": 2,
  "notification_sent": true
}
```

## System Monitoring

### Get System Metrics

```http
GET /admin/system/metrics
```

**Query Parameters:**

- `time_range` (optional): Time range for metrics (1h, 24h, 7d, 30d)
- `granularity` (optional): Data granularity (1m, 5m, 1h)
- `components` (optional): Specific components to include

**Response:**

```json
{
  "system_overview": {
    "timestamp": "2024-01-15T10:00:00Z",
    "time_range": "24h",
    "granularity": "5m",
    "health_score": 0.97,
    "total_requests": 247891,
    "successful_requests": 244567,
    "failed_requests": 3324,
    "success_rate": 98.66,
    "average_response_time": 245,
    "p95_response_time": 480,
    "p99_response_time": 850
  },
  "agent_metrics": {
    "total_invocations": 12456,
    "successful_invocations": 12298,
    "failed_invocations": 158,
    "success_rate": 98.73,
    "average_execution_time": 2400,
    "total_active_instances": 84,
    "total_processing_time": 29587200,
    "categories": {
      "development": {
        "invocations": 4823,
        "success_rate": 98.9,
        "avg_execution_time": 2100
      },
      "infrastructure": {
        "invocations": 2156,
        "success_rate": 99.2,
        "avg_execution_time": 1800
      },
      "security": {
        "invocations": 1789,
        "success_rate": 97.8,
        "avg_execution_time": 3200
      }
    }
  },
  "command_metrics": {
    "total_executions": 8934,
    "successful_executions": 8756,
    "failed_executions": 178,
    "success_rate": 98.01,
    "average_execution_time": 1500,
    "most_used_commands": [
      {
        "command": "/test",
        "executions": 2341,
        "success_rate": 98.5
      },
      {
        "command": "/commit",
        "executions": 1567,
        "success_rate": 99.1
      },
      {
        "command": "/review",
        "executions": 1234,
        "success_rate": 97.8
      }
    ]
  },
  "mcp_metrics": {
    "total_routing_decisions": 156789,
    "routing_success_rate": 99.8,
    "average_routing_time": 45,
    "cache_hit_rate": 87.3,
    "server_performance": [
      {
        "server": "filesystem",
        "requests": 67890,
        "success_rate": 99.9,
        "avg_response_time": 15
      },
      {
        "server": "github",
        "requests": 34567,
        "success_rate": 99.5,
        "avg_response_time": 120
      }
    ]
  },
  "resource_usage": {
    "cpu": {
      "average_usage": 45.7,
      "peak_usage": 78.3,
      "current_usage": 42.1
    },
    "memory": {
      "total_gb": 256,
      "used_gb": 156.8,
      "usage_percentage": 61.3,
      "available_gb": 99.2
    },
    "storage": {
      "total_tb": 10,
      "used_tb": 3.7,
      "usage_percentage": 37.0,
      "available_tb": 6.3
    },
    "network": {
      "inbound_mbps": 125.7,
      "outbound_mbps": 89.3,
      "total_connections": 2456
    }
  }
}
```

### Get System Logs

```http
GET /admin/system/logs
```

**Query Parameters:**

- `level` (optional): Log level filter (DEBUG, INFO, WARN, ERROR)
- `component` (optional): Filter by component
- `start_time` (optional): Start time for log filtering
- `end_time` (optional): End time for log filtering
- `limit` (optional): Number of log entries to return
- `search` (optional): Search term in log messages

**Response:**

```json
{
  "logs": [
    {
      "timestamp": "2024-01-15T10:00:00Z",
      "level": "INFO",
      "component": "agent_orchestrator",
      "message": "Agent backend-engineer instance started successfully",
      "request_id": "req_123abc",
      "context": {
        "agent_id": "agent_123456",
        "instance_id": "instance_001",
        "startup_time_ms": 2300
      }
    },
    {
      "timestamp": "2024-01-15T09:59:45Z",
      "level": "WARN",
      "component": "mcp_router",
      "message": "High latency detected for github server",
      "context": {
        "server": "github",
        "latency_ms": 580,
        "threshold_ms": 500,
        "consecutive_slow_requests": 3
      }
    },
    {
      "timestamp": "2024-01-15T09:59:30Z",
      "level": "ERROR",
      "component": "authentication_service",
      "message": "Failed login attempt detected",
      "context": {
        "username": "suspicious.user",
        "ip_address": "192.168.1.999",
        "reason": "invalid_credentials",
        "attempt_count": 5
      }
    }
  ],
  "total_entries": 15678,
  "pagination": {
    "limit": 100,
    "offset": 0,
    "has_more": true
  },
  "filters_applied": {
    "time_range": "1h",
    "level": "INFO",
    "component": null
  },
  "summary": {
    "by_level": {
      "DEBUG": 2345,
      "INFO": 11234,
      "WARN": 1567,
      "ERROR": 532
    },
    "by_component": {
      "agent_orchestrator": 4567,
      "api_gateway": 3456,
      "authentication_service": 2345,
      "mcp_router": 2234
    }
  }
}
```

### Get Alerts

```http
GET /admin/system/alerts
```

**Query Parameters:**

- `severity` (optional): Filter by alert severity
- `status` (optional): Filter by alert status (active, resolved, acknowledged)
- `component` (optional): Filter by component

**Response:**

```json
{
  "alerts": [
    {
      "alert_id": "alert_123",
      "severity": "critical",
      "status": "active",
      "component": "database",
      "title": "High database connection usage",
      "message": "Database connection pool usage at 95% capacity",
      "created_at": "2024-01-15T09:45:00Z",
      "updated_at": "2024-01-15T09:45:00Z",
      "threshold": {
        "metric": "connection_pool_usage",
        "threshold_value": 90,
        "current_value": 95,
        "unit": "percentage"
      },
      "actions_taken": [
        "Auto-scaling database connections initiated",
        "Operations team notified"
      ],
      "escalation_level": 2,
      "acknowledgments": []
    },
    {
      "alert_id": "alert_124",
      "severity": "warning",
      "status": "acknowledged",
      "component": "agent_orchestrator",
      "title": "Agent instance performance degradation",
      "message": "2 backend-engineer instances showing elevated response times",
      "created_at": "2024-01-15T09:30:00Z",
      "updated_at": "2024-01-15T09:35:00Z",
      "acknowledged_at": "2024-01-15T09:35:00Z",
      "acknowledged_by": "admin_456",
      "threshold": {
        "metric": "average_response_time",
        "threshold_value": 3000,
        "current_value": 4200,
        "unit": "milliseconds"
      },
      "actions_taken": [
        "Instance health checks increased",
        "Performance monitoring enabled"
      ],
      "escalation_level": 1
    }
  ],
  "summary": {
    "total_alerts": 23,
    "by_severity": {
      "critical": 2,
      "high": 5,
      "warning": 12,
      "info": 4
    },
    "by_status": {
      "active": 16,
      "acknowledged": 5,
      "resolved": 2
    },
    "by_component": {
      "agent_orchestrator": 8,
      "api_gateway": 4,
      "database": 3,
      "mcp_router": 3,
      "authentication_service": 2
    }
  }
}
```

## Maintenance Operations

### Schedule Maintenance

```http
POST /admin/maintenance/schedule
```

**Request Body:**

```json
{
  "title": "System upgrade to v2.2.0",
  "description": "Upgrading all components to version 2.2.0 with enhanced performance and security features",
  "type": "system_upgrade",
  "scheduled_start": "2024-01-20T02:00:00Z",
  "estimated_duration_minutes": 120,
  "affected_components": [
    "agent_orchestrator",
    "api_gateway",
    "authentication_service"
  ],
  "maintenance_steps": [
    {
      "step": 1,
      "description": "Drain traffic from API gateway",
      "estimated_duration_minutes": 10
    },
    {
      "step": 2,
      "description": "Stop all agent instances gracefully",
      "estimated_duration_minutes": 15
    },
    {
      "step": 3,
      "description": "Upgrade system components",
      "estimated_duration_minutes": 60
    },
    {
      "step": 4,
      "description": "Restart services and validate",
      "estimated_duration_minutes": 20
    },
    {
      "step": 5,
      "description": "Restore traffic and monitor",
      "estimated_duration_minutes": 15
    }
  ],
  "rollback_plan": {
    "enabled": true,
    "auto_rollback_conditions": [
      "critical_errors_detected",
      "performance_degradation_50_percent"
    ],
    "manual_rollback_time_minutes": 30
  },
  "notifications": {
    "advance_notice_hours": 48,
    "reminder_hours": [24, 2],
    "stakeholders": [
      "engineering-team",
      "operations-team",
      "management"
    ]
  }
}
```

**Response:**

```json
{
  "maintenance": {
    "maintenance_id": "maint_789",
    "title": "System upgrade to v2.2.0",
    "type": "system_upgrade",
    "status": "scheduled",
    "scheduled_start": "2024-01-20T02:00:00Z",
    "estimated_end": "2024-01-20T04:00:00Z",
    "estimated_duration_minutes": 120,
    "created_at": "2024-01-15T10:00:00Z",
    "created_by": "admin_456",
    "affected_components": [
      "agent_orchestrator",
      "api_gateway",
      "authentication_service"
    ],
    "approval_required": true,
    "approval_status": "pending",
    "notifications_scheduled": true
  },
  "next_steps": [
    "Maintenance window requires approval from 2 additional administrators",
    "Advance notifications will be sent 48 hours before start time",
    "Automated pre-maintenance checks will run 1 hour before start"
  ]
}
```

### Get Maintenance History

```http
GET /admin/maintenance/history
```

**Query Parameters:**

- `type` (optional): Filter by maintenance type
- `status` (optional): Filter by status
- `start_date` (optional): Start date for filtering
- `end_date` (optional): End date for filtering

**Response:**

```json
{
  "maintenance_history": [
    {
      "maintenance_id": "maint_788",
      "title": "Security patch deployment",
      "type": "security_update",
      "status": "completed",
      "scheduled_start": "2024-01-10T03:00:00Z",
      "actual_start": "2024-01-10T03:02:00Z",
      "scheduled_end": "2024-01-10T04:00:00Z",
      "actual_end": "2024-01-10T03:45:00Z",
      "duration_minutes": 43,
      "success": true,
      "affected_components": [
        "authentication_service",
        "api_gateway"
      ],
      "performed_by": "admin_456",
      "impact": {
        "service_downtime_minutes": 0,
        "performance_impact": "none",
        "user_impact": "minimal"
      }
    },
    {
      "maintenance_id": "maint_787",
      "title": "Database optimization",
      "type": "performance_optimization",
      "status": "completed",
      "scheduled_start": "2024-01-05T01:00:00Z",
      "actual_start": "2024-01-05T01:05:00Z",
      "scheduled_end": "2024-01-05T03:00:00Z",
      "actual_end": "2024-01-05T02:30:00Z",
      "duration_minutes": 85,
      "success": true,
      "performed_by": "admin_789",
      "impact": {
        "service_downtime_minutes": 15,
        "performance_impact": "improved_25_percent",
        "user_impact": "brief_interruption"
      }
    }
  ],
  "summary": {
    "total_maintenance_events": 24,
    "by_type": {
      "system_upgrade": 6,
      "security_update": 8,
      "performance_optimization": 5,
      "bug_fix": 3,
      "capacity_expansion": 2
    },
    "by_status": {
      "completed": 22,
      "failed": 1,
      "cancelled": 1
    },
    "average_duration_minutes": 67,
    "total_downtime_minutes": 145,
    "success_rate": 95.8
  }
}
```

## Backup & Recovery

### Create Backup

```http
POST /admin/backup/create
```

**Request Body:**

```json
{
  "backup_type": "full",
  "description": "Pre-upgrade full system backup",
  "components": [
    "system_configuration",
    "user_data",
    "agent_configurations",
    "audit_logs",
    "metrics_data"
  ],
  "compression": true,
  "encryption": true,
  "retention_days": 90,
  "storage_location": "s3://claude-backups/production",
  "notification_on_completion": true
}
```

**Response:**

```json
{
  "backup": {
    "backup_id": "backup_456",
    "backup_type": "full",
    "status": "in_progress",
    "started_at": "2024-01-15T10:00:00Z",
    "estimated_completion": "2024-01-15T10:45:00Z",
    "estimated_size_gb": 12.5,
    "components": [
      "system_configuration",
      "user_data",
      "agent_configurations",
      "audit_logs",
      "metrics_data"
    ],
    "progress": {
      "percentage": 25,
      "current_component": "user_data",
      "processed_size_gb": 3.1
    },
    "compression": true,
    "encryption": true,
    "storage_location": "s3://claude-backups/production/backup_456",
    "retention_until": "2024-04-15T10:00:00Z"
  }
}
```

### List Backups

```http
GET /admin/backup/list
```

**Query Parameters:**

- `backup_type` (optional): Filter by backup type (full, incremental, differential)
- `status` (optional): Filter by status
- `start_date` (optional): Start date for filtering
- `limit` (optional): Number of backups to return

**Response:**

```json
{
  "backups": [
    {
      "backup_id": "backup_456",
      "backup_type": "full",
      "status": "completed",
      "created_at": "2024-01-15T10:00:00Z",
      "completed_at": "2024-01-15T10:42:00Z",
      "duration_minutes": 42,
      "size_gb": 11.8,
      "compressed_size_gb": 4.2,
      "encryption": true,
      "description": "Pre-upgrade full system backup",
      "storage_location": "s3://claude-backups/production/backup_456",
      "retention_until": "2024-04-15T10:00:00Z",
      "components": [
        "system_configuration",
        "user_data",
        "agent_configurations",
        "audit_logs",
        "metrics_data"
      ],
      "verification": {
        "verified": true,
        "verification_date": "2024-01-15T11:00:00Z",
        "integrity_check": "passed"
      }
    },
    {
      "backup_id": "backup_455",
      "backup_type": "incremental",
      "status": "completed",
      "created_at": "2024-01-14T10:00:00Z",
      "completed_at": "2024-01-14T10:15:00Z",
      "duration_minutes": 15,
      "size_gb": 2.3,
      "compressed_size_gb": 0.8,
      "encryption": true,
      "description": "Daily incremental backup",
      "storage_location": "s3://claude-backups/production/backup_455",
      "retention_until": "2024-02-14T10:00:00Z",
      "verification": {
        "verified": true,
        "verification_date": "2024-01-14T10:30:00Z",
        "integrity_check": "passed"
      }
    }
  ],
  "summary": {
    "total_backups": 87,
    "by_type": {
      "full": 12,
      "incremental": 62,
      "differential": 13
    },
    "total_storage_gb": 245.7,
    "compressed_storage_gb": 89.3,
    "oldest_backup": "2024-01-01T00:00:00Z",
    "newest_backup": "2024-01-15T10:00:00Z"
  }
}
```

### Restore from Backup

```http
POST /admin/backup/restore
```

**Request Body:**

```json
{
  "backup_id": "backup_456",
  "restore_type": "selective",
  "components": [
    "system_configuration",
    "agent_configurations"
  ],
  "target_environment": "staging",
  "confirmation_required": true,
  "pre_restore_backup": true,
  "notification_on_completion": true,
  "rollback_on_failure": true
}
```

**Response:**

```json
{
  "restore_operation": {
    "restore_id": "restore_789",
    "backup_id": "backup_456",
    "restore_type": "selective",
    "status": "pending_confirmation",
    "components": [
      "system_configuration",
      "agent_configurations"
    ],
    "target_environment": "staging",
    "estimated_duration_minutes": 25,
    "impact_analysis": {
      "service_interruption": "minimal",
      "affected_users": 0,
      "data_loss_risk": "none",
      "rollback_time_minutes": 10
    },
    "pre_checks": [
      {
        "check": "backup_integrity",
        "status": "passed"
      },
      {
        "check": "target_environment_accessible",
        "status": "passed"
      },
      {
        "check": "sufficient_storage_space",
        "status": "passed"
      }
    ],
    "confirmation_token": "confirm_restore_abc123",
    "expires_at": "2024-01-15T10:15:00Z"
  }
}
```

## OpenAPI Specification

```yaml
openapi: 3.0.0
info:
  title: Claude System Administration API
  version: 1.0.0
  description: Comprehensive system administration API for Claude Code CLI

security:
  - bearerAuth: []
  - apiKeyAuth: []

paths:
  /admin/system/config:
    get:
      summary: Get system configuration
      tags: [System Configuration]
      security:
        - bearerAuth: []
      responses:
        200:
          description: System configuration
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/SystemConfiguration'
        403:
          description: Insufficient permissions
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

    put:
      summary: Update system configuration
      tags: [System Configuration]
      security:
        - bearerAuth: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/UpdateSystemConfigRequest'
      responses:
        200:
          description: Configuration updated
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ConfigurationUpdateResponse'

  /admin/system/health:
    get:
      summary: Get system health status
      tags: [System Monitoring]
      security:
        - bearerAuth: []
      responses:
        200:
          description: System health status
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/SystemHealthResponse'

  /admin/users:
    get:
      summary: List users
      tags: [User Management]
      security:
        - bearerAuth: []
      parameters:
        - name: status
          in: query
          schema:
            type: string
            enum: [active, inactive, locked]
        - name: role
          in: query
          schema:
            type: string
        - name: limit
          in: query
          schema:
            type: integer
            minimum: 1
            maximum: 100
            default: 25
      responses:
        200:
          description: List of users
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UserListResponse'

    post:
      summary: Create new user
      tags: [User Management]
      security:
        - bearerAuth: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateUserRequest'
      responses:
        201:
          description: User created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UserCreationResponse'

  /admin/users/{userId}:
    put:
      summary: Update user
      tags: [User Management]
      security:
        - bearerAuth: []
      parameters:
        - name: userId
          in: path
          required: true
          schema:
            type: string
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/UpdateUserRequest'
      responses:
        200:
          description: User updated successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UserUpdateResponse'

components:
  schemas:
    SystemConfiguration:
      type: object
      properties:
        system:
          type: object
          properties:
            version:
              type: string
            environment:
              type: string
              enum: [development, staging, production]
            cluster_id:
              type: string
            region:
              type: string
            uptime_seconds:
              type: integer
        configuration:
          type: object
          properties:
            authentication:
              $ref: '#/components/schemas/AuthenticationConfig'
            agents:
              $ref: '#/components/schemas/AgentConfig'
            performance:
              $ref: '#/components/schemas/PerformanceConfig'

    AuthenticationConfig:
      type: object
      properties:
        jwt_expiry_hours:
          type: integer
          minimum: 1
          maximum: 168
        session_timeout_minutes:
          type: integer
          minimum: 5
          maximum: 480
        mfa_required:
          type: boolean
        max_concurrent_sessions:
          type: integer
          minimum: 1
          maximum: 20

    AgentConfig:
      type: object
      properties:
        total_agents:
          type: integer
        default_timeout_minutes:
          type: integer
          minimum: 5
          maximum: 180
        max_concurrent_tasks_per_agent:
          type: integer
          minimum: 1
          maximum: 10
        auto_scaling_enabled:
          type: boolean

    PerformanceConfig:
      type: object
      properties:
        cache_enabled:
          type: boolean
        cache_ttl_seconds:
          type: integer
          minimum: 60
          maximum: 3600
        request_rate_limit:
          type: integer
          minimum: 100
          maximum: 10000
        burst_limit:
          type: integer
          minimum: 10
          maximum: 1000

    SystemHealthResponse:
      type: object
      properties:
        overall_status:
          type: string
          enum: [healthy, degraded, unhealthy]
        health_score:
          type: number
          minimum: 0
          maximum: 1
        last_check:
          type: string
          format: date-time
        components:
          type: object
          additionalProperties:
            $ref: '#/components/schemas/ComponentHealth'

    ComponentHealth:
      type: object
      properties:
        status:
          type: string
          enum: [healthy, degraded, unhealthy]
        health_score:
          type: number
          minimum: 0
          maximum: 1
        response_time_ms:
          type: number
        uptime_percentage:
          type: number
        instances:
          type: object
          properties:
            total:
              type: integer
            healthy:
              type: integer
            unhealthy:
              type: integer

    CreateUserRequest:
      type: object
      required:
        - username
        - email
        - role
      properties:
        username:
          type: string
          pattern: '^[a-zA-Z0-9._-]+$'
        email:
          type: string
          format: email
        role:
          type: string
          enum: [admin, developer, analyst, viewer]
        permissions:
          type: array
          items:
            type: string
        temporary_password:
          type: boolean
          default: true
        require_mfa:
          type: boolean
          default: true

    UserCreationResponse:
      type: object
      properties:
        user:
          $ref: '#/components/schemas/User'
        temporary_password:
          type: string
        password_expires_at:
          type: string
          format: date-time
        setup_instructions:
          type: object
          properties:
            steps:
              type: array
              items:
                type: string

    User:
      type: object
      properties:
        user_id:
          type: string
        username:
          type: string
        email:
          type: string
          format: email
        role:
          type: string
        status:
          type: string
          enum: [active, inactive, locked]
        created_at:
          type: string
          format: date-time
        last_login:
          type: string
          format: date-time
        mfa_enabled:
          type: boolean
        permissions:
          type: array
          items:
            type: string

    ErrorResponse:
      type: object
      properties:
        error:
          type: object
          properties:
            code:
              type: string
            message:
              type: string
            details:
              type: object
            timestamp:
              type: string
              format: date-time

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

### System Administration

1. **Configuration Management**
   - Use version control for configuration changes
   - Test configuration changes in staging first
   - Implement rollback procedures

2. **User Management**
   - Enforce principle of least privilege
   - Regular access reviews and cleanup
   - Strong password and MFA policies

3. **Monitoring & Alerting**
   - Comprehensive monitoring across all components
   - Proactive alerting with appropriate escalation
   - Regular review of alert thresholds

4. **Maintenance & Backup**
   - Regular automated backups with verification
   - Well-planned maintenance windows
   - Comprehensive rollback procedures

5. **Security Administration**
   - Regular security audits and compliance checks
   - Incident response procedures
   - Continuous security monitoring

---

The System Administration API provides enterprise-grade management capabilities for the Claude Code CLI ecosystem, ensuring reliable, secure, and efficient operations across all system components.