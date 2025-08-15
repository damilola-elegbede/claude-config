# ML API Reference - Phase 3 Intelligence Layer

<metadata>
  <api-version>v1.0</api-version>
  <specification-standard>OpenAPI 3.0</specification-standard>
  <authentication>JWT + API Key</authentication>
  <base-url>https://ml-api.claude.local/v1</base-url>
</metadata>

<executive-summary>
Comprehensive API reference for the Phase 3 Intelligence Layer ML services, providing predictive analytics,
performance optimization, and intelligent system insights. Designed for high-throughput production workloads
with enterprise-grade security and reliability.
</executive-summary>

## API Overview

<api-architecture>
  <service-endpoints>
    <category name="prediction-services">

```text
- `/predict/bottleneck` - Performance bottleneck prediction
- `/predict/resource-optimization` - Resource allocation optimization
- `/predict/failure-prevention` - System failure prevention
- `/predict/workload-forecast` - Agent workload forecasting
```

    </category>

    <category name="model-management">

```text
- `/models` - Model registry operations
- `/models/{id}/deploy` - Model deployment management
- `/models/{id}/metrics` - Model performance metrics
- `/models/{id}/drift` - Model drift analysis
```

    </category>

    <category name="system-analytics">

```text
- `/analytics/performance` - System performance analytics
- `/analytics/trends` - Historical trend analysis
- `/analytics/insights` - AI-generated insights
- `/analytics/recommendations` - Optimization recommendations
```

    </category>

    <category name="monitoring-observability">

```text
- `/health` - Service health checks
- `/metrics` - Prometheus metrics endpoint
- `/status` - System status and uptime
- `/alerts` - Alert management
```

    </category>
  </service-endpoints>
</api-architecture>

### Authentication and Security

<authentication-setup>
  <auth-methods>
    <method name="jwt-bearer" security-level="high">

```text
- JWT tokens with 1-hour expiration
- RSA256 signing with rotation every 24 hours
- Role-based access control (RBAC) integration
- Automatic refresh token mechanism
```

    </method>

    <method name="service-credentials" security-level="medium">

```text
- Service credentials for service-to-service communication
- Scoped permissions per service credential
- Rate limiting by service credential
- Audit logging for all service credential usage
```

    </method>
  </auth-methods>

  <rate-limiting>
    <tier name="basic" requests-per-minute="100">

```text
- Standard prediction endpoints
- Basic analytics queries
- Model status checks
```

    </tier>

    <tier name="premium" requests-per-minute="1000">

```text
- High-frequency prediction requests
- Bulk analytics operations
- Real-time streaming endpoints
```

    </tier>

    <tier name="enterprise" requests-per-minute="10000">

```text
- Unlimited prediction requests
- Priority queue processing
- Dedicated infrastructure resources
```

    </tier>
  </rate-limiting>
</authentication-setup>

## Prediction Services API

### Bottleneck Prediction

<api-endpoint name="POST /predict/bottleneck" category="prediction">
  <description>Predict system performance bottlenecks before they occur</description>

  <request-specification>
    <headers>

```http
Authorization: Bearer {jwt_token}
Content-Type: application/json
X-Request-ID: {unique_request_id}
```

    </headers>

    <request-body>

```json
{
  "system_id": "prod-cluster-01",
  "prediction_horizon": 30,
  "confidence_level": 0.95,
  "features": {
    "cpu_utilization": [65.2, 72.1, 68.5],
    "memory_usage": [78.9, 82.3, 80.1],
    "disk_io": [1200, 1350, 1275],
    "network_io": [850, 920, 890],
    "agent_queue_depth": 15,
    "active_tasks": 8
  },
  "context": {
    "time_of_day": "business_hours",
    "day_of_week": "wednesday",
    "deployment_version": "v2.1.3"
  }
}
```

    </request-body>
  </request-specification>

  <response-specification>
    <success-response code="200">

```json
{
  "request_id": "req_12345abcdef",
  "prediction": {
    "bottleneck_probability": 0.847,
    "time_to_bottleneck": 23,
    "predicted_resource": "memory",
    "severity_score": 7.2,
    "confidence_interval": {
      "lower": 0.798,
      "upper": 0.896
    }
  },
  "recommendations": [
    {
      "action": "scale_memory",
      "description": "Increase memory allocation by 25%",
      "expected_impact": 0.65,
      "implementation_effort": "low"
    },
    {
      "action": "optimize_agent_allocation",
      "description": "Redistribute agents to balance load",
      "expected_impact": 0.45,
      "implementation_effort": "medium"
    }
  ],
  "metadata": {
    "model_version": "bottleneck_predictor_v1.2.0",
    "feature_importance": {
      "memory_usage": 0.34,
      "cpu_utilization": 0.28,
      "agent_queue_depth": 0.21,
      "disk_io": 0.17
    },
    "processing_time_ms": 45,
    "cached": false
  }
}
```

    </success-response>

    <error-responses>
      <error code="400" type="validation_error">

```json
{
  "error": "validation_error",
  "message": "Invalid feature values provided",
  "details": {
    "cpu_utilization": "Values must be between 0 and 100",
    "prediction_horizon": "Must be between 1 and 240 minutes"
  },
  "request_id": "req_12345abcdef"
}
```

      </error>

      <error code="429" type="rate_limit_exceeded">

```json
{
  "error": "rate_limit_exceeded",
  "message": "Request rate limit exceeded",
  "retry_after": 60,
  "limit": 100,
  "remaining": 0,
  "reset_time": "2024-01-15T15:30:00Z"
}
```

      </error>
    </error-responses>
  </response-specification>
</api-endpoint>

### Resource Optimization

<api-endpoint name="POST /predict/resource-optimization" category="prediction">
  <description>Get intelligent resource allocation recommendations</description>

  <request-specification>
    <request-body>

```json
{
  "system_id": "prod-cluster-01",
  "current_allocation": {
    "cpu_cores": 64,
    "memory_gb": 256,
    "gpu_count": 4,
    "storage_gb": 1000
  },
  "workload_forecast": {
    "predicted_load": [0.65, 0.78, 0.82, 0.69],
    "peak_hours": ["09:00", "14:00", "19:00"],
    "agent_distribution": {
      "backend-staff": 0.4,
      "frontend-architect": 0.3,
      "ml-engineer": 0.2,
      "other": 0.1
    }
  },
  "objectives": {
    "minimize_cost": 0.3,
    "maximize_performance": 0.4,
    "maintain_reliability": 0.3
  },
  "constraints": {
    "max_cost_increase": 0.15,
    "min_performance_level": 0.95,
    "availability_requirement": 0.999
  }
}
```

    </request-body>
  </request-specification>

  <response-specification>
    <success-response code="200">

```json
{
  "request_id": "req_opt_67890",
  "optimization": {
    "recommended_allocation": {
      "cpu_cores": 72,
      "memory_gb": 288,
      "gpu_count": 4,
      "storage_gb": 1200
    },
    "scaling_strategy": "horizontal",
    "implementation_plan": [
      {
        "step": 1,
        "action": "increase_memory",
        "details": "Add 32GB RAM during maintenance window",
        "expected_downtime": "5 minutes",
        "cost_impact": 120.50
      },
      {
        "step": 2,
        "action": "add_cpu_cores",
        "details": "Scale to 72 cores with new instances",
        "expected_downtime": "0 minutes",
        "cost_impact": 89.30
      }
    ],
    "expected_outcomes": {
      "cost_change": 0.08,
      "performance_improvement": 0.23,
      "reliability_impact": 0.02
    },
    "confidence_score": 0.91
  },
  "alternatives": [
    {
      "name": "cost_optimized",
      "allocation": {
        "cpu_cores": 68,
        "memory_gb": 272,
        "gpu_count": 3,
        "storage_gb": 1000
      },
      "cost_change": -0.05,
      "performance_impact": -0.08,
      "trade_offs": "Reduced GPU capacity during peak ML workloads"
    }
  ]
}
```

    </success-response>
  </response-specification>
</api-endpoint>

### Failure Prevention

<api-endpoint name="POST /predict/failure-prevention" category="prediction">
  <description>Predict and prevent system failures before they impact operations</description>

  <request-specification>
    <request-body>

```json
{
  "system_id": "prod-cluster-01",
  "monitoring_data": {
    "error_rates": [0.001, 0.002, 0.003, 0.002],
    "response_times": [45, 52, 68, 71],
    "resource_exhaustion_indicators": {
      "disk_space_remaining": 0.15,
      "connection_pool_utilization": 0.89,
      "thread_pool_utilization": 0.92
    },
    "anomaly_scores": [0.1, 0.2, 0.4, 0.6]
  },
  "time_horizons": [15, 60, 240, 1440],
  "severity_threshold": 0.7
}
```

    </request-body>
  </request-specification>

  <response-specification>
    <success-response code="200">

```json
{
  "request_id": "req_fail_prev_789",
  "failure_predictions": [
    {
      "time_horizon": 60,
      "failure_probability": 0.82,
      "predicted_failure_type": "disk_space_exhaustion",
      "severity": "critical",
      "root_cause_analysis": {
        "primary_cause": "log_file_accumulation",
        "contributing_factors": [
          "insufficient_log_rotation",
          "increased_verbosity_in_ml_pipeline"
        ],
        "confidence": 0.94
      },
      "mitigation_strategies": [
        {
          "strategy": "emergency_log_cleanup",
          "effectiveness": 0.95,
          "implementation_time": "2 minutes",
          "automation_available": true
        },
        {
          "strategy": "increase_disk_capacity",
          "effectiveness": 0.99,
          "implementation_time": "15 minutes",
          "automation_available": false
        }
      ]
    }
  ],
  "early_warning_alerts": [
    {
      "alert_level": "warning",
      "message": "Disk space critically low, failure predicted in 60 minutes",
      "recommended_actions": [
        "Execute emergency log cleanup script",
        "Alert operations team for capacity increase"
      ],
      "auto_remediation_available": true
    }
  ],
  "system_health_score": 0.67,
  "trend_analysis": {
    "overall_trend": "degrading",
    "key_indicators": {
      "resource_pressure": "increasing",
      "error_patterns": "stable",
      "performance": "degrading"
    }
  }
}
```

    </success-response>
  </response-specification>
</api-endpoint>

### Workload Forecasting

<api-endpoint name="POST /predict/workload-forecast" category="prediction">
  <description>Forecast agent workload and resource demands</description>

  <request-specification>
    <request-body>

```json
{
  "forecast_horizon": 24,
  "granularity": "hourly",
  "agent_types": [
    "backend-staff",
    "frontend-architect",
    "ml-engineer",
    "performance-specialist"
  ],
  "historical_context": {
    "seasonal_patterns": true,
    "business_events": [
      {
        "event": "product_launch",
        "date": "2024-01-20",
        "expected_impact": 1.5
      }
    ]
  },
  "external_factors": {
    "business_hours": "09:00-17:00",
    "timezone": "UTC",
    "weekend_factor": 0.3
  }
}
```
    </request-body>
  </request-specification>

  <response-specification>
    <success-response code="200">

```json
{
  "request_id": "req_forecast_456",
  "forecast": {
    "time_series": [
      {
        "timestamp": "2024-01-15T10:00:00Z",
        "predicted_load": 0.78,
        "confidence_interval": [0.71, 0.85],
        "agent_demand": {
          "backend-staff": 12,
          "frontend-architect": 8,
          "ml-engineer": 6,
          "performance-specialist": 3
        }
      },
      {
        "timestamp": "2024-01-15T11:00:00Z",
        "predicted_load": 0.85,
        "confidence_interval": [0.79, 0.91],
        "agent_demand": {
          "backend-staff": 14,
          "frontend-architect": 9,
          "ml-engineer": 7,
          "performance-specialist": 4
        }
      }
    ],
    "peak_periods": [
      {
        "start": "2024-01-15T09:00:00Z",
        "end": "2024-01-15T11:00:00Z",
        "peak_load": 0.92,
        "primary_drivers": ["daily_standup_completion", "deployment_activities"]
      }
    ],
    "resource_recommendations": {
      "scale_up_triggers": [
        {
          "time": "2024-01-15T08:45:00Z",
          "action": "pre_scale_backend_agents",
          "target_capacity": 16
        }
      ],
      "scale_down_opportunities": [
        {
          "time": "2024-01-15T18:00:00Z",
          "action": "reduce_agent_pool",
          "target_capacity": 8
        }
      ]
    }
  },
  "model_metadata": {
    "model_version": "workload_forecaster_v2.1.0",
    "training_date": "2024-01-10",
    "accuracy_metrics": {
      "mae": 0.08,
      "mape": 12.3,
      "r2_score": 0.89
    }
  }
}
```
    </success-response>
  </response-specification>
</api-endpoint>

## Model Management API

### Model Registry Operations

<api-endpoint name="GET /models" category="model-management">
  <description>List all registered models with metadata and status</description>

  <request-specification>
    <query-parameters>

```http
?status=active&type=prediction&limit=50&offset=0
```

    </query-parameters>
  </request-specification>

  <response-specification>
    <success-response code="200">

```json
{
  "models": [
    {
      "id": "bottleneck_predictor_v1.2.0",
      "name": "Performance Bottleneck Predictor",
      "version": "1.2.0",
      "type": "classification",
      "status": "active",
      "deployment_status": "deployed",
      "accuracy": 0.963,
      "last_trained": "2024-01-10T15:30:00Z",
      "training_samples": 1000000,
      "feature_count": 42,
      "model_size_mb": 15.6,
      "inference_latency_p99": 78,
      "tags": ["production", "performance", "prediction"],
      "metadata": {
        "framework": "xgboost",
        "training_duration": "2.5 hours",
        "hyperparameters": {
          "n_estimators": 500,
          "max_depth": 8,
          "learning_rate": 0.1
        }
      }
    }
  ],
  "pagination": {
    "total": 25,
    "limit": 50,
    "offset": 0,
    "has_next": false
  }
}
```
    </success-response>
  </response-specification>
</api-endpoint>

### Model Deployment

<api-endpoint name="POST /models/{id}/deploy" category="model-management">
  <description>Deploy a model version to production with deployment strategy</description>

  <request-specification>
    <path-parameters>

```http
{id}: bottleneck_predictor_v1.2.0
```

    </path-parameters>

    <request-body>

```json
{
  "deployment_strategy": "blue_green",
  "environment": "production",
  "traffic_split": {
    "canary_percentage": 10,
    "monitoring_duration": 300
  },
  "rollback_policy": {
    "auto_rollback": true,
    "error_threshold": 0.05,
    "latency_threshold": 200
  },
  "resource_allocation": {
    "replicas": 3,
    "cpu_request": "1000m",
    "memory_request": "2Gi",
    "gpu_request": 0
  }
}
```
    </request-body>
  </request-specification>

  <response-specification>
    <success-response code="202">

```json
{
  "deployment_id": "deploy_789xyz",
  "status": "in_progress",
  "deployment_strategy": "blue_green",
  "estimated_completion": "2024-01-15T11:15:00Z",
  "progress": {
    "current_step": "deploying_canary",
    "steps_completed": 2,
    "total_steps": 6,
    "next_step": "monitoring_canary_health"
  },
  "monitoring": {
    "health_check_url": "/deployments/deploy_789xyz/health",
    "metrics_dashboard": "https://grafana.claude.local/d/model-deployment/deploy_789xyz"
  }
}
```
    </success-response>
  </response-specification>
</api-endpoint>

### Model Performance Metrics

<api-endpoint name="GET /models/{id}/metrics" category="model-management">
  <description>Retrieve detailed performance metrics for a deployed model</description>

  <request-specification>
    <query-parameters>

```http
      ?start_time=2024-01-14T00:00:00Z&end_time=2024-01-15T00:00:00Z&granularity=hourly
```

    </query-parameters>
  </request-specification>

  <response-specification>
    <success-response code="200">

      ```json
      {
        "model_id": "bottleneck_predictor_v1.2.0",
        "time_period": {
          "start": "2024-01-14T00:00:00Z",
          "end": "2024-01-15T00:00:00Z",
          "granularity": "hourly"
        },
        "performance_metrics": {
          "accuracy": {
            "current": 0.961,
            "trend": "stable",
            "time_series": [
              {"timestamp": "2024-01-14T00:00:00Z", "value": 0.958},
              {"timestamp": "2024-01-14T01:00:00Z", "value": 0.962}
            ]
          },
          "latency": {
            "p50": 32,
            "p95": 67,
            "p99": 89,
            "time_series": [
              {"timestamp": "2024-01-14T00:00:00Z", "p99": 85},
              {"timestamp": "2024-01-14T01:00:00Z", "p99": 92}
            ]
          },
          "throughput": {
            "requests_per_second": 145,
            "peak_rps": 387,
            "time_series": [
              {"timestamp": "2024-01-14T00:00:00Z", "rps": 92},
              {"timestamp": "2024-01-14T01:00:00Z", "rps": 156}
            ]
          },
          "error_rates": {
            "total_error_rate": 0.003,
            "prediction_errors": 0.001,
            "system_errors": 0.002
          }
        },
        "business_metrics": {
          "predictions_made": 523847,
          "bottlenecks_prevented": 23,
          "cost_savings_usd": 12450.67,
          "false_positive_rate": 0.024,
          "false_negative_rate": 0.008
        }
      }
      ```
    </success-response>
  </response-specification>
</api-endpoint>

## System Analytics API

### Performance Analytics

<api-endpoint name="GET /analytics/performance" category="analytics">
  <description>Get comprehensive system performance analytics and insights</description>

  <request-specification>
    <query-parameters>

```http
      ?system_id=prod-cluster-01&time_range=7d&metrics=cpu,memory,throughput&include_predictions=true
```

    </query-parameters>
  </request-specification>

  <response-specification>
    <success-response code="200">

      ```json
      {
        "system_id": "prod-cluster-01",
        "analysis_period": {
          "start": "2024-01-08T00:00:00Z",
          "end": "2024-01-15T00:00:00Z",
          "duration_days": 7
        },
        "performance_summary": {
          "overall_health_score": 0.87,
          "availability": 0.9994,
          "average_response_time": 52,
          "peak_concurrent_agents": 28,
          "total_tasks_completed": 15672
        },
        "resource_utilization": {
          "cpu": {
            "average": 0.64,
            "peak": 0.91,
            "efficiency_score": 0.78,
            "bottlenecks_detected": 3
          },
          "memory": {
            "average": 0.71,
            "peak": 0.88,
            "efficiency_score": 0.82,
            "memory_leaks_detected": 0
          },
          "network": {
            "average_bandwidth_mbps": 245,
            "peak_bandwidth_mbps": 892,
            "packet_loss_rate": 0.0001
          }
        },
        "agent_performance": {
          "top_performers": [
            {
              "agent_type": "backend-staff",
              "efficiency_score": 0.94,
              "avg_task_time": 187,
              "success_rate": 0.989
            }
          ],
          "performance_issues": [
            {
              "agent_type": "ml-engineer",
              "issue": "increased_memory_usage",
              "impact": "moderate",
              "recommendation": "review_model_loading_strategy"
            }
          ]
        },
        "predictions": {
          "next_24h_load": [0.67, 0.82, 0.78, 0.45],
          "expected_bottlenecks": [
            {
              "resource": "memory",
              "probability": 0.23,
              "estimated_time": "2024-01-16T14:30:00Z"
            }
          ],
          "optimization_opportunities": [
            {
              "type": "resource_reallocation",
              "potential_savings": "15% CPU reduction",
              "implementation_effort": "low"
            }
          ]
        }
      }
      ```
    </success-response>
  </response-specification>
</api-endpoint>

### AI-Generated Insights

<api-endpoint name="GET /analytics/insights" category="analytics">
  <description>Get AI-generated insights and recommendations for system optimization</description>

  <response-specification>
    <success-response code="200">

      ```json
      {
        "insights": [
          {
            "id": "insight_001",
            "type": "performance_optimization",
            "priority": "high",
            "confidence": 0.92,
            "title": "Memory Allocation Pattern Optimization Opportunity",
            "description": "Analysis reveals that ml-engineer agents are allocating 40% more memory than necessary during model inference, " +
                           "leading to resource waste and OOM conditions.",
            "impact": {
              "performance_improvement": "18%",
              "cost_reduction": "$1,200/month",
              "reliability_increase": "12%"
            },
            "recommendations": [
              {
                "action": "implement_memory_pooling",
                "description": "Implement shared memory pools for model inference",
                "effort": "medium",
                "timeline": "2 weeks"
              },
              {
                "action": "optimize_model_loading",
                "description": "Use lazy loading for infrequently used models",
                "effort": "low",
                "timeline": "3 days"
              }
            ],
            "supporting_data": {
              "affected_agents": 12,
              "memory_waste_gb": 48,
              "peak_hours_impact": "09:00-17:00 UTC"
            }
          },
          {
            "id": "insight_002",
            "type": "capacity_planning",
            "priority": "medium",
            "confidence": 0.87,
            "title": "Predictive Scaling Opportunity",
            "description": "Historical patterns show 23% of scaling events could be predicted 15 minutes in advance, " +
                           "enabling proactive allocation.",
            "recommendations": [
              {
                "action": "enable_predictive_autoscaling",
                "description": "Configure Kubernetes HPA with prediction-based triggers",
                "effort": "high",
                "timeline": "4 weeks"
              }
            ]
          }
        ],
        "trend_analysis": {
          "emerging_patterns": [
            {
              "pattern": "increased_ml_workload_complexity",
              "description": "ML inference tasks showing 15% increase in computational requirements",
              "trend_strength": 0.76,
              "projected_impact": "Resource requirements will increase by 25% over next 3 months"
            }
          ],
          "anomalies_detected": [
            {
              "anomaly": "unusual_network_traffic_pattern",
              "severity": "low",
              "description": "10% increase in inter-service communication during off-peak hours",
              "investigation_required": true
            }
          ]
        }
      }
      ```
    </success-response>
  </response-specification>
</api-endpoint>

## SDK and Client Libraries

### Python SDK

<client-library language="python">
  <installation>

```bash
pip install claude-ml-client
```

  </installation>

  <usage-examples>
    <example name="basic-prediction">
      ```python
      from claude_ml import MLClient
      import os

      # Initialize client with environment variable
      # Set ML_SERVICE_KEY in your environment
      auth_key = os.getenv("ML_SERVICE_KEY")
      client = MLClient(
          auth_key=auth_key,
          base_url="https://ml-api.claude.local/v1"
      )

      # Performance bottleneck prediction
      prediction = await client.predict_bottleneck(
          system_id="prod-cluster-01",
          features={
              "cpu_utilization": [65.2, 72.1, 68.5],
              "memory_usage": [78.9, 82.3, 80.1],
              "disk_io": [1200, 1350, 1275]
          },
          horizon_minutes=30
      )

      print(f"Bottleneck probability: {prediction.probability}")
      print(f"Time to bottleneck: {prediction.time_to_bottleneck} minutes")

      # Resource optimization
      optimization = await client.optimize_resources(
          system_id="prod-cluster-01",
          current_allocation={
              "cpu_cores": 64,
              "memory_gb": 256
          },
          objectives={
              "minimize_cost": 0.3,
              "maximize_performance": 0.7
          }
      )

      for recommendation in optimization.recommendations:
          print(f"Action: {recommendation.action}")
          print(f"Expected impact: {recommendation.expected_impact}")
      ```
    </example>

    <example name="streaming-predictions">
      ```python
      # Real-time streaming predictions
      async def stream_predictions():
          async for prediction in client.stream_predictions(
              system_id="prod-cluster-01",
              prediction_types=["bottleneck", "failure_prevention"],
              update_interval=30
          ):
              if prediction.type == "bottleneck" and prediction.probability > 0.8:
                  await handle_bottleneck_alert(prediction)
              elif prediction.type == "failure_prevention" and prediction.severity == "critical":
                  await handle_failure_alert(prediction)

      # Run streaming predictions
      asyncio.run(stream_predictions())
      ```
    </example>

    <example name="batch-operations">
      ```python
      # Batch prediction operations
      batch_requests = [
          {
              "system_id": f"cluster-{i:02d}",
              "features": generate_features(f"cluster-{i:02d}")
          }
          for i in range(1, 11)
      ]

      # Process batch predictions
      batch_results = await client.batch_predict_bottlenecks(batch_requests)

      for result in batch_results:
          if result.prediction.probability > 0.7:
              print(f"Alert: {result.system_id} - {result.prediction.probability:.2f}")
      ```
    </example>
  </usage-examples>

  <error-handling>

```python
from claude_ml.exceptions import (
    MLClientError,
    RateLimitError,
    AuthenticationError,
    ValidationError
)

try:
    prediction = await client.predict_bottleneck(
        system_id="prod-cluster-01",
        features=invalid_features
    )
except ValidationError as e:
    print(f"Validation error: {e.details}")
except RateLimitError as e:
    print(f"Rate limited. Retry after: {e.retry_after} seconds")
except AuthenticationError as e:
    print(f"Authentication failed: {e.message}")
except MLClientError as e:
    print(f"General client error: {e}")
```

  </error-handling>
</client-library>

### JavaScript/Node.js SDK

<client-library language="javascript">
  <installation>

```bash
npm install claude-ml-client
```

  </installation>

  <usage-examples>
    <example name="basic-usage">
      ```javascript
      const { MLClient } = require('claude-ml-client');

      const client = new MLClient({
          apiKey: process.env.ML_API_KEY,
          baseUrl: 'https://ml-api.claude.local/v1'
      });

      // Performance prediction
      async function checkSystemHealth() {
          try {
              const prediction = await client.predictBottleneck({
                  systemId: 'prod-cluster-01',
                  features: {
                      cpuUtilization: [65.2, 72.1, 68.5],
                      memoryUsage: [78.9, 82.3, 80.1],
                      diskIo: [1200, 1350, 1275]
                  },
                  horizonMinutes: 30
              });

              if (prediction.probability > 0.8) {
                  console.log('High bottleneck probability detected!');
                  console.log(`Recommendations: ${prediction.recommendations}`);
              }

          } catch (error) {
              if (error.name === 'RateLimitError') {
                  console.log(`Rate limited. Retry after: ${error.retryAfter}s`);
              } else {
                  console.error('Prediction failed:', error.message);
              }
          }
      }

      checkSystemHealth();
      ```
    </example>

    <example name="websocket-streaming">
      ```javascript
      // Real-time WebSocket streaming
      const stream = client.createPredictionStream({
          systemId: 'prod-cluster-01',
          predictionTypes: ['bottleneck', 'failure_prevention'],
          updateInterval: 30
      });

      stream.on('prediction', (prediction) => {
          console.log(`New prediction: ${prediction.type}`);

          if (prediction.type === 'bottleneck' && prediction.probability > 0.8) {
              handleBottleneckAlert(prediction);
          }
      });

      stream.on('error', (error) => {
          console.error('Stream error:', error);
      });

      stream.connect();
      ```
    </example>
  </usage-examples>
</client-library>

## Monitoring and Health Checks

### Service Health

<api-endpoint name="GET /health" category="monitoring">
  <description>Service health check endpoint for load balancers and monitoring</description>

  <response-specification>
    <success-response code="200">
      ```json
      {
        "status": "healthy",
        "timestamp": "2024-01-15T10:30:00Z",
        "version": "1.0.0",
        "uptime": 259200,
        "services": {
          "prediction_service": {
            "status": "healthy",
            "response_time_ms": 45,
            "last_check": "2024-01-15T10:29:55Z"
          },
          "model_registry": {
            "status": "healthy",
            "response_time_ms": 12,
            "models_loaded": 8
          },
          "feature_store": {
            "status": "healthy",
            "connection_pool_size": 20,
            "cache_hit_rate": 0.89
          },
          "database": {
            "status": "healthy",
            "connection_count": 15,
            "query_latency_p95": 23
          }
        },
        "resource_usage": {
          "cpu_percent": 34.5,
          "memory_percent": 67.2,
          "disk_usage_percent": 45.1
        }
      }
      ```
    </success-response>

    <degraded-response code="200">
      ```json
      {
        "status": "degraded",
        "timestamp": "2024-01-15T10:30:00Z",
        "version": "1.0.0",
        "issues": [
          {
            "service": "feature_store",
            "issue": "high_latency",
            "details": "Cache response time exceeding 100ms threshold",
            "impact": "minor"
          }
        ]
      }
      ```
    </degraded-response>
  </response-specification>
</api-endpoint>

### Prometheus Metrics

<api-endpoint name="GET /metrics" category="monitoring">
  <description>Prometheus metrics endpoint for monitoring and alerting</description>

  <response-specification>
    <metrics-format>

```text
      # HELP ml_predictions_total Total number of predictions made
      # TYPE ml_predictions_total counter
      ml_predictions_total{model="bottleneck_predictor",version="v1.2.0"} 15234

      # HELP ml_prediction_duration_seconds Time spent on predictions
      # TYPE ml_prediction_duration_seconds histogram
      ml_prediction_duration_seconds_bucket{model="bottleneck_predictor",le="0.01"} 1234
      ml_prediction_duration_seconds_bucket{model="bottleneck_predictor",le="0.05"} 8901
      ml_prediction_duration_seconds_bucket{model="bottleneck_predictor",le="0.1"} 12456
      ml_prediction_duration_seconds_sum{model="bottleneck_predictor"} 756.78
      ml_prediction_duration_seconds_count{model="bottleneck_predictor"} 15234

      # HELP ml_model_accuracy Current model accuracy
      # TYPE ml_model_accuracy gauge
      ml_model_accuracy{model="bottleneck_predictor",metric="overall"} 0.963

      # HELP ml_api_requests_total Total API requests
      # TYPE ml_api_requests_total counter
      ml_api_requests_total{endpoint="/predict/bottleneck",status="200"} 14890
      ml_api_requests_total{endpoint="/predict/bottleneck",status="400"} 23
      ml_api_requests_total{endpoint="/predict/bottleneck",status="429"} 45

      # HELP ml_cache_hit_rate Cache hit rate for predictions
      # TYPE ml_cache_hit_rate gauge
      ml_cache_hit_rate 0.847
      ```
    </metrics-format>
  </response-specification>
</api-endpoint>

---

<implementation-notes>
  <deployment-requirements>
    - Kubernetes cluster with ingress controller
    - TLS certificates for HTTPS endpoints
    - Redis cluster for caching and rate limiting
    - PostgreSQL for metadata storage
    - Prometheus for metrics collection
    - Load balancer with health check support
  </deployment-requirements>

  <performance-characteristics>
    - API response time: p99 < 100ms
    - Throughput: 10K+ requests/second
    - Availability: 99.9% uptime SLA
    - Cache hit rate: >85% for repeated requests
    - Model serving latency: p95 < 50ms
  </performance-characteristics>

  <security-features>
    - JWT authentication with automatic rotation
    - API key management with scoped permissions
    - Rate limiting per client and endpoint
    - Request/response encryption (TLS 1.3)
    - Audit logging for all API operations
    - Input validation and sanitization
  </security-features>
</implementation-notes>

## ML API Reference v1.0 - Production Ready Enterprise API
