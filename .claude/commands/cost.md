# /cost Command

## Description
Optimizes cloud costs and resource utilization through specialized cost-optimizer and finops-analyst agents to identify savings opportunities, implement cost controls, and establish financial governance for technical infrastructure.

## Usage
```
/cost [scope] [options]
```

## Arguments
- `scope` (optional): Cost analysis focus area
  - `compute`: Server and container optimization
  - `storage`: Data storage cost analysis
  - `network`: Bandwidth and transfer optimization
  - `services`: Managed service cost review
  - `full`: Comprehensive cost optimization (default)

## Options
- `--provider <platform>`: Cloud provider (aws, gcp, azure, multi-cloud)
- `--target <reduction>`: Cost reduction target (percentage or dollar amount)
- `--timeline <period>`: Optimization timeline (1m, 3m, 6m, 1y)
- `--preserve <sla>`: Maintain service levels (performance, availability)
- `--audit`: Generate cost allocation and usage audit
- `--implement`: Execute approved cost optimizations

## Behavior
When you use `/cost`, I will orchestrate comprehensive cost optimization:

### Phase 1 (Cost Analysis - 0-30 min)
1. **Launch cost-optimizer agent** for:
   - Resource utilization analysis
   - Cost allocation mapping
   - Waste identification
   - Right-sizing opportunities
   - Reserved capacity analysis

2. **Deploy finops-analyst agent** for:
   - Financial governance assessment
   - Budget tracking and forecasting
   - Cost trend analysis
   - ROI calculation
   - Chargeback/showback modeling

3. **Coordinate with cloud-architect** for:
   - Architecture cost impact analysis
   - Service selection optimization
   - Multi-cloud cost comparison
   - Serverless vs container cost analysis
   - Data transfer optimization

### Phase 2 (Optimization Strategy - 30-60 min)
4. **Cost reduction identification**:
   - Unused resource elimination
   - Right-sizing recommendations
   - Reserved instance optimization
   - Spot instance opportunities
   - Storage tier optimization

5. **Financial control implementation**:
   - Budget alerts and controls
   - Cost allocation strategies
   - Tagging standardization
   - Governance policy creation
   - Approval workflows

### Phase 3 (Implementation Planning - 60+ min)
6. **Optimization execution**:
   - Priority-based implementation
   - Risk assessment and mitigation
   - Testing and validation procedures
   - Rollback planning
   - Monitoring and tracking setup

## Examples
```
/cost                                           # Full cost optimization analysis
/cost compute --target 30% --timeline 3m       # 30% compute cost reduction in 3 months
/cost storage --provider aws --audit           # AWS storage cost audit
/cost --provider multi-cloud --preserve 99.9%  # Multi-cloud optimization maintaining SLA
/cost services --implement                      # Execute managed service optimizations
/cost network --target $10000 --timeline 6m    # $10K network cost reduction in 6 months
```

## Cost Optimization Categories

### Compute Optimization
- **Right-Sizing**: Match instance types to actual usage
- **Reserved Instances**: Long-term commitment discounts
- **Spot Instances**: Significant savings for fault-tolerant workloads
- **Auto-Scaling**: Dynamic capacity based on demand
- **Container Optimization**: Efficient resource packing

### Storage Optimization
- **Tier Management**: Hot, warm, cold, archive storage
- **Lifecycle Policies**: Automated data movement
- **Compression**: Reduce storage footprint
- **Deduplication**: Eliminate redundant data
- **Backup Optimization**: Efficient backup strategies

### Network Optimization
- **Data Transfer**: Minimize cross-region/internet transfers
- **CDN Usage**: Reduce origin server bandwidth
- **VPN vs Direct Connect**: Cost-effective connectivity
- **Bandwidth Right-Sizing**: Match capacity to usage
- **Compression**: Reduce data transfer volumes

## Multi-Agent Orchestration

### Comprehensive Cost Analysis
```
PHASE 1 (Parallel - 30 min):
├── cost-optimizer: Resource utilization and waste analysis
├── finops-analyst: Financial governance and trend analysis
└── cloud-architect: Architecture cost impact assessment

PHASE 2 (Sequential - 30 min):
├── cost-optimizer: Optimization strategy development
├── finops-analyst: Financial control implementation
└── cloud-architect: Technical implementation planning

PHASE 3 (Parallel - 20 min):
├── devops-sre: Implementation execution
├── cost-optimizer: Monitoring setup
└── finops-analyst: Governance documentation
```

### Provider-Specific Patterns
```
AWS Cost Optimization:
├── aws-specialist: AWS-specific cost tools and services
├── cost-optimizer: EC2, S3, RDS optimization
└── finops-analyst: Cost Explorer and budgets setup

Multi-Cloud Cost Management:
├── cloud-architect: Cross-provider cost comparison
├── finops-analyst: Unified cost reporting
└── cost-optimizer: Provider-specific optimizations
```

## Cost Analysis Framework

### Resource Utilization Metrics
- **Compute Utilization**: CPU, memory, disk usage patterns
- **Storage Efficiency**: Used vs allocated storage
- **Network Usage**: Bandwidth utilization and patterns
- **Service Consumption**: API calls, function executions
- **License Utilization**: Software license efficiency

### Cost Allocation Models
- **Business Unit**: Department-based cost allocation
- **Project-Based**: Per-project cost tracking
- **Environment**: Development, staging, production costs
- **Service-Based**: Microservice cost allocation
- **Feature-Based**: Feature development cost tracking

### Financial Governance
- **Budget Controls**: Spending limits and alerts
- **Approval Workflows**: Cost approval processes
- **Chargeback Models**: Internal cost recovery
- **Showback Reports**: Cost transparency without billing
- **Forecasting Models**: Predictive cost planning

## Advanced Features

### Intelligent Cost Optimization
- **Machine Learning**: Usage pattern analysis for optimization
- **Anomaly Detection**: Unusual spending pattern identification
- **Predictive Scaling**: Cost-optimized capacity planning
- **Automated Optimization**: Policy-driven cost controls
- **Continuous Optimization**: Ongoing cost improvement

### Multi-Cloud Cost Management
- **Unified Billing**: Consolidated cost reporting
- **Cross-Provider Comparison**: Service cost analysis
- **Workload Placement**: Optimal provider selection
- **Arbitrage Opportunities**: Cost differences exploitation
- **Migration Economics**: Cost-driven workload movement

### FinOps Best Practices
- **Cost Transparency**: Detailed cost visibility
- **Accountability**: Cost ownership assignment
- **Real-Time Monitoring**: Immediate cost feedback
- **Optimization Culture**: Cost-conscious development
- **Continuous Improvement**: Regular cost review cycles

## Platform-Specific Optimization

### AWS Cost Optimization
- **Compute**: EC2 right-sizing, Reserved Instances, Spot Instances
- **Storage**: S3 Intelligent Tiering, EBS optimization
- **Database**: RDS Reserved Instances, Aurora serverless
- **Tools**: Cost Explorer, Trusted Advisor, Compute Optimizer
- **Services**: Lambda cost optimization, ECS vs EKS costs

### Google Cloud Platform
- **Compute**: Committed Use Discounts, Preemptible VMs
- **Storage**: Nearline, Coldline, Archive storage classes
- **Database**: Cloud SQL optimization, BigQuery slot management
- **Tools**: Cloud Billing, Recommender, Cloud Asset Inventory
- **Services**: Cloud Functions optimization, GKE cost management

### Microsoft Azure
- **Compute**: Reserved VM Instances, Spot VMs, Azure Hybrid Benefit
- **Storage**: Blob storage tiers, Azure Files optimization
- **Database**: SQL Database reserved capacity, Cosmos DB optimization
- **Tools**: Cost Management + Billing, Advisor recommendations
- **Services**: Azure Functions consumption plan optimization

## Cost Monitoring and Alerting

### Real-Time Monitoring
- **Spending Dashboards**: Live cost visualization
- **Budget Alerts**: Threshold-based notifications
- **Anomaly Detection**: Unusual spending identification
- **Usage Tracking**: Resource consumption monitoring
- **Trend Analysis**: Cost trajectory analysis

### Reporting and Analytics
- **Executive Dashboards**: High-level cost overview
- **Departmental Reports**: Business unit cost allocation
- **Project Tracking**: Initiative-based cost reporting
- **Efficiency Metrics**: Cost per transaction, user, etc.
- **ROI Analysis**: Investment return calculations

## Output Deliverables

1. **Cost Optimization Report**: Comprehensive savings analysis
2. **Implementation Roadmap**: Priority-based optimization plan
3. **Financial Governance Framework**: Cost control policies
4. **Monitoring Dashboard**: Real-time cost visibility
5. **Budget Framework**: Spending controls and alerts
6. **ROI Analysis**: Optimization investment returns
7. **Best Practices Guide**: Ongoing cost management procedures

## Optimization Strategies

### Immediate Wins (0-30 days)
- **Unused Resource Cleanup**: Idle instance termination
- **Right-Sizing**: Oversized resource optimization
- **Storage Cleanup**: Orphaned volume/snapshot removal
- **Reserved Instance Coverage**: Commitment-based discounts
- **Spot Instance Adoption**: Fault-tolerant workload migration

### Medium-Term Optimization (1-6 months)
- **Architecture Refactor**: Cost-efficient design patterns
- **Service Migration**: Cost-effective service alternatives
- **Data Lifecycle Management**: Automated storage tiering
- **Workload Scheduling**: Time-based resource optimization
- **Multi-Cloud Strategy**: Provider arbitrage opportunities

### Long-Term Initiatives (6+ months)
- **FinOps Culture**: Organization-wide cost consciousness
- **Custom Tooling**: Automated cost optimization tools
- **Predictive Analytics**: AI-driven cost forecasting
- **Governance Maturity**: Advanced financial controls
- **Innovation Investment**: Cost-saving technology adoption

## Success Metrics

### Financial Metrics
- **Cost Reduction**: Absolute and percentage savings achieved
- **ROI**: Return on optimization investment
- **Budget Variance**: Actual vs budgeted spending
- **Cost per Unit**: Per-user, per-transaction cost trends
- **Forecast Accuracy**: Prediction vs actual spending

### Operational Metrics
- **Resource Utilization**: Efficiency improvement percentages
- **Waste Reduction**: Eliminated unused resources
- **Optimization Coverage**: Percentage of resources optimized
- **Time to Optimization**: Speed of implementing savings
- **Governance Compliance**: Policy adherence rates

## Integration Points

### Development Workflow
- **Cost-Aware Development**: Developer cost visibility
- **CI/CD Cost Gates**: Deployment cost validation
- **Infrastructure as Code**: Cost-optimized templates
- **Performance Testing**: Cost impact measurement
- **Feature Flags**: Cost-controlled feature rollouts

### Financial Systems
- **ERP Integration**: Enterprise resource planning sync
- **Procurement Systems**: Purchase approval workflows
- **Accounting Systems**: Cost allocation automation
- **Budgeting Tools**: Planning system integration
- **Billing Systems**: Chargeback automation

## Prerequisites
- **Cloud Account Access**: Billing and resource permissions
- **Historical Usage Data**: 3-6 months of usage patterns
- **Business Requirements**: Performance and availability needs
- **Organizational Structure**: Cost center and project mapping
- **Current Architecture**: System design and dependencies
- **Budget Information**: Spending limits and targets

## Notes
- Balances cost reduction with performance requirements
- Provides actionable optimization recommendations
- Supports multiple cloud providers and hybrid environments
- Emphasizes sustainable cost management practices
- Integrates with existing financial and operational processes
- Considers long-term architectural cost implications
- Promotes cost-conscious development culture