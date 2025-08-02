# /monitor Command

## Description
Establishes comprehensive production monitoring and observability stack using specialized devops-sre and monitoring-specialist agents to ensure system health, performance visibility, and proactive incident prevention.

## Usage
```
/monitor [scope] [options]
```

## Arguments
- `scope` (optional): Monitoring area to focus on
  - `infra`: Infrastructure and resource monitoring
  - `app`: Application performance monitoring (APM)
  - `logs`: Log aggregation and analysis
  - `alerts`: Alert configuration and optimization
  - `full`: Complete observability stack (default)

## Options
- `--stack <platform>`: Target platform (aws, gcp, azure, kubernetes, docker)
- `--tier <level>`: Monitoring tier (basic, standard, enterprise)
- `--metrics <type>`: Metric types (business, technical, security, all)
- `--dashboard`: Generate monitoring dashboards
- `--sla <target>`: Set SLA targets (99.9%, 99.95%, 99.99%)

## Behavior
When you use `/monitor`, I will coordinate in multiple phases:

### Phase 1 (Parallel Analysis)
1. **Launch devops-sre agent** to assess:
   - Current monitoring gaps
   - Infrastructure topology
   - Service dependencies
   - Deployment patterns
   - Scaling requirements

2. **Deploy monitoring-specialist agent** to design:
   - Metric collection strategy
   - Alerting thresholds
   - Dashboard layouts
   - SLI/SLO definitions
   - Observability patterns

3. **Coordinate with performance-specialist** for:
   - Performance baseline establishment
   - Critical path identification
   - Resource utilization patterns
   - Capacity planning metrics

### Phase 2 (Implementation)
1. **Monitoring stack configuration**:
   - Metrics collection (Prometheus, DataDog, New Relic)
   - Log aggregation (ELK, Splunk, Fluentd)
   - Distributed tracing (Jaeger, Zipkin)
   - Error tracking (Sentry, Rollbar)
   - Uptime monitoring (Pingdom, StatusPage)

2. **Dashboard and alerting setup**:
   - Executive dashboards
   - Engineering dashboards
   - Service-specific views
   - Alert routing rules
   - Escalation policies

## Examples
```
/monitor                                    # Full observability setup
/monitor infra --stack kubernetes          # K8s infrastructure monitoring
/monitor app --tier enterprise             # Enterprise APM setup
/monitor logs --dashboard                   # Log analysis with dashboards
/monitor alerts --sla 99.95%              # Alert tuning for 99.95% SLA
/monitor --stack aws --metrics business    # AWS business metrics focus
```

## Monitoring Categories

### Infrastructure Monitoring
- **Compute**: CPU, memory, disk, network utilization
- **Storage**: Disk I/O, capacity, IOPS, latency
- **Network**: Bandwidth, packet loss, connection counts
- **Container**: Pod health, resource limits, restarts
- **Database**: Query performance, connection pools, locks

### Application Performance Monitoring
- **Response Times**: P50, P95, P99 latencies
- **Throughput**: Requests per second, concurrent users
- **Error Rates**: HTTP 4xx/5xx, exception rates
- **Business Metrics**: Conversion rates, user actions
- **Dependencies**: External API performance

### Observability Stack Components
- **Metrics**: Time-series data collection
- **Logs**: Structured logging and analysis
- **Traces**: Distributed request tracing
- **Events**: System and business events
- **Synthetic**: Proactive health checks

## Multi-Agent Orchestration

### Agent Coordination Pattern
```
PHASE 1 (Parallel - 15 min):
├── devops-sre: Infrastructure assessment
├── monitoring-specialist: Metrics design
└── performance-specialist: Baseline establishment

PHASE 2 (Sequential - 30 min):
├── devops-sre: Stack deployment
├── monitoring-specialist: Dashboard creation
└── quality-assurance: Validation testing

PHASE 3 (Parallel - 10 min):
├── monitoring-specialist: Alert tuning
└── devops-sre: Documentation creation
```

## Advanced Features

### Intelligent Alerting
- **Anomaly Detection**: ML-based threshold adjustment
- **Alert Correlation**: Reduce noise through grouping
- **Escalation Policies**: Tiered response procedures
- **Maintenance Windows**: Suppression during deployments
- **Context Enrichment**: Runbook and dashboard links

### Custom Dashboards
- **Executive Summary**: High-level business metrics
- **Service Health**: Per-service operational view
- **Incident Response**: Real-time troubleshooting
- **Capacity Planning**: Resource trending and forecasting
- **Security Operations**: Security event monitoring

### Compliance Monitoring
- **SOC2**: Security and availability controls
- **PCI-DSS**: Payment processing compliance
- **GDPR**: Data processing and retention
- **HIPAA**: Healthcare data protection
- **Custom**: Industry-specific requirements

## Platform Integrations

### Cloud Platforms
- **AWS**: CloudWatch, X-Ray, Systems Manager
- **GCP**: Cloud Monitoring, Cloud Trace, Cloud Logging
- **Azure**: Monitor, Application Insights, Log Analytics

### Container Orchestration
- **Kubernetes**: Prometheus Operator, Grafana
- **Docker Swarm**: Built-in metrics and logging
- **ECS/Fargate**: CloudWatch Container Insights

### Communication Tools
- **Slack**: Alert notifications and ChatOps
- **PagerDuty**: Incident management integration
- **Teams**: Microsoft ecosystem integration
- **Discord**: Development team notifications

## Output Deliverables

1. **Monitoring Architecture**: Complete observability design
2. **Dashboard Collection**: Role-based monitoring views
3. **Alerting Rules**: Comprehensive alert definitions
4. **Runbook Templates**: Incident response procedures
5. **SLA/SLO Definitions**: Service level objectives
6. **Capacity Plan**: Resource scaling recommendations

## Monitoring Metrics Framework

### Golden Signals
- **Latency**: Request response times
- **Traffic**: Request volume and patterns
- **Errors**: Error rate and types
- **Saturation**: Resource utilization levels

### Business Metrics
- **User Experience**: Page load times, conversion rates
- **Revenue Impact**: Transaction volumes, payment success
- **Operational Efficiency**: Deployment frequency, MTTR
- **Security Posture**: Failed logins, suspicious activity

## Best Practices Implementation

### Monitoring Strategy
- **Proactive vs Reactive**: Prevention over response
- **Signal vs Noise**: Meaningful alerts only
- **Context Over Data**: Actionable information
- **Automation**: Self-healing where possible

### Performance Optimization
- **Efficient Collection**: Minimal overhead monitoring
- **Smart Aggregation**: Reduce data volume
- **Retention Policies**: Cost-effective storage
- **Query Optimization**: Fast dashboard loading

## Integration Points
- **CI/CD Pipelines**: Deployment monitoring
- **Incident Management**: Automated ticket creation
- **Capacity Planning**: Auto-scaling triggers
- **Security Systems**: SIEM integration
- **Cost Management**: Resource optimization alerts

## Prerequisites
- **Infrastructure Access**: Cloud/server credentials
- **Application Knowledge**: Service architecture
- **SLA Requirements**: Business objectives
- **Team Structure**: On-call responsibilities
- **Tool Preferences**: Existing monitoring investments

## Success Metrics
- **MTTR Reduction**: Faster incident resolution
- **Alert Accuracy**: Reduced false positives
- **Visibility Coverage**: Complete system observability
- **Team Productivity**: Efficient troubleshooting
- **SLA Achievement**: Service level objective compliance

## Notes
- Emphasizes proactive monitoring over reactive
- Balances comprehensive coverage with signal clarity
- Provides cost-effective observability solutions
- Integrates with existing operational workflows
- Supports compliance and audit requirements