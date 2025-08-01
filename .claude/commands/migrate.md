# /migrate Command

## Description
Coordinates complex database migrations, framework upgrades, and platform transitions using specialized agents for zero-downtime deployments. Handles everything from simple schema changes to complete platform migrations with comprehensive rollback strategies.

## Usage
```
/migrate <migration_type> [options]
```

## Arguments
- `migration_type`: Type of migration (database, framework, platform, api)
- `options`: Additional flags like --zero-downtime, --dry-run, --rollback

## Behavior
When you use `/migrate`, I will:

1. **Analyze migration complexity**:
   - **database-evolution-specialist**: Assess data changes
   - **backend-engineer**: Review application impact
   - **devops**: Evaluate deployment strategy
   - **test-engineer**: Identify test requirements

2. **Create migration strategy**:
   - Zero-downtime approach
   - Rollback procedures
   - Data validation plans
   - Performance benchmarks

3. **Execute migration phases**:
   - Pre-migration validation
   - Incremental data migration
   - Application compatibility
   - Post-migration verification

4. **Monitor and validate**:
   - Real-time monitoring
   - Data integrity checks
   - Performance comparison
   - Automated rollback triggers

## Migration Types

### Database Migrations
```bash
# Schema changes
/migrate database add-column users.preferences

# Database engine migration
/migrate database postgres-to-mysql --zero-downtime

# Sharding implementation
/migrate database implement-sharding --tables=users,orders
```

**Strategies**:
- **Blue-Green**: Parallel database with sync
- **Expand-Contract**: Gradual schema evolution
- **Shadow Writes**: Dual writes for validation
- **Batch Processing**: Large dataset migrations

### Framework Migrations
```bash
# Version upgrades
/migrate framework react-17-to-18

# Architecture changes
/migrate framework monolith-to-microservices

# Language migrations
/migrate framework javascript-to-typescript
```

**Approaches**:
- **Incremental**: Module-by-module
- **Parallel Run**: Old/new side-by-side
- **Feature Flags**: Gradual rollout
- **Compatibility Layer**: Temporary adapters

### Platform Migrations
```bash
# Cloud migrations
/migrate platform on-premise-to-aws

# Container orchestration
/migrate platform docker-swarm-to-kubernetes

# Service mesh adoption
/migrate platform add-istio-service-mesh
```

**Methodologies**:
- **Lift and Shift**: Quick migration
- **Re-architecture**: Optimize for cloud
- **Hybrid**: Gradual transition
- **Multi-cloud**: Vendor diversification

### API Migrations
```bash
# Version upgrades
/migrate api v1-to-v2 --deprecation-period=90d

# Protocol changes
/migrate api rest-to-graphql

# Breaking changes
/migrate api rename-endpoints --compatibility-mode
```

## Multi-Agent Orchestration

### Phase 1: Assessment (Parallel)
```
├── database-evolution-specialist → Data impact analysis
├── backend-engineer → Application changes
├── frontend-architect → Client compatibility
├── devops → Infrastructure requirements
└── security-auditor → Security implications
```

### Phase 2: Planning
```
principal-architect → Migration architecture
├── Create detailed timeline
├── Define rollback points
├── Establish success metrics
└── Risk mitigation strategies
```

### Phase 3: Execution (Sequential with Parallel Tasks)
```
Stage 1: Preparation
├── backend-engineer → Compatibility layer
├── database-admin → Backup procedures
└── monitoring-specialist → Observability setup

Stage 2: Migration
├── database-evolution-specialist → Data migration
├── devops → Infrastructure updates
└── test-engineer → Continuous validation

Stage 3: Cutover
├── incident-commander → Coordination
├── All agents → Monitoring and support
└── performance-specialist → Benchmarking
```

## Zero-Downtime Strategies

### Database
- **Dual Writes**: Write to old and new
- **Read Replicas**: Gradual traffic shift
- **Online Schema Changes**: gh-ost, pt-online-schema-change
- **Versioned Schemas**: Multiple compatible versions

### Application
- **Feature Toggles**: Gradual enablement
- **Canary Deployments**: Percentage rollout
- **Blue-Green Deployments**: Instant switch
- **Rolling Updates**: Node-by-node

### Data
- **CDC (Change Data Capture)**: Real-time sync
- **ETL Pipelines**: Batch migration
- **Event Sourcing**: Replay events
- **Dual Running**: Parallel systems

## Validation & Testing

### Pre-Migration
- Data consistency checks
- Performance baselines
- Compatibility testing
- Load testing

### During Migration
- Real-time monitoring
- Data integrity validation
- Performance tracking
- Error rate monitoring

### Post-Migration
- Full regression testing
- Performance comparison
- Data reconciliation
- User acceptance testing

## Rollback Procedures

### Automatic Triggers
- Error rate > threshold
- Performance degradation
- Data corruption detected
- Health check failures

### Manual Procedures
```bash
/migrate rollback --to=checkpoint-3
/migrate rollback --full
```

### Rollback Safety
- Point-in-time snapshots
- Transaction logs
- Reverse migrations
- Data backup restoration

## Common Scenarios

### Multi-Terabyte Database Migration
```bash
/migrate database large-dataset --parallel=10 --batch-size=10000
# - Parallel processing
# - Progress tracking
# - Automatic retry
# - Zero data loss
```

### Microservices Extraction
```bash
/migrate framework extract-service --service=payments
# - API contract definition
# - Data boundary identification
# - Gradual traffic routing
# - Monitoring setup
```

### Cloud-Native Transformation
```bash
/migrate platform kubernetes-native --services=all
# - Containerization
# - Service mesh integration
# - Observability stack
# - GitOps setup
```

## Success Metrics
- **Downtime**: < 5 minutes (or zero)
- **Data Loss**: Zero tolerance
- **Performance**: No degradation
- **Rollback Time**: < 15 minutes
- **Error Rate**: < 0.01%

## Integration Tools
- **Flyway/Liquibase**: Database versioning
- **Kubernetes**: Container orchestration
- **Terraform**: Infrastructure as code
- **GitHub Actions**: CI/CD automation
- **Datadog/Prometheus**: Monitoring

## Notes
- Always test migrations in staging
- Maintain detailed runbooks
- Implement comprehensive monitoring
- Document lessons learned
- Keep rollback procedures updated