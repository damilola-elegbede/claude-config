# /incident Command

## Description
Coordinates comprehensive incident response through specialized incident-commander and crisis-management agents to manage production outages, security breaches, and critical system failures with structured command and control procedures.

## Usage
```
/incident <type> <severity> [options]
```

## Arguments
- `type`: Incident category
  - `outage`: Service availability incident
  - `performance`: Degraded system performance
  - `security`: Security breach or vulnerability
  - `data`: Data corruption or loss
  - `compliance`: Regulatory compliance issue
  
- `severity`: Impact level
  - `sev1`: Critical - Complete service outage
  - `sev2`: High - Major functionality impacted
  - `sev3`: Medium - Partial functionality affected  
  - `sev4`: Low - Minor issues or degradation

## Options
- `--scope <area>`: Affected system scope (api, database, frontend, payments)
- `--impact <level>`: Business impact (revenue, users, reputation, compliance)
- `--timeline <duration>`: Expected resolution time
- `--stakeholders <list>`: Notification recipients
- `--war-room`: Establish incident command center

## Behavior
When you use `/incident`, I will orchestrate multi-phase incident response:

### Phase 1 (Immediate - 0-5 min)
1. **Launch incident-commander agent** for:
   - Incident classification and severity assessment
   - Initial impact analysis
   - Communication plan activation
   - Resource mobilization
   - Command structure establishment

2. **Deploy crisis-management agent** for:
   - Stakeholder notification protocols
   - External communication strategy
   - Regulatory compliance checks
   - Escalation procedure management
   - Documentation coordination

### Phase 2 (Investigation - 5-30 min)
3. **Coordinate with technical specialists**:
   - **debugger**: Root cause analysis
   - **security-auditor**: Security incident analysis
   - **performance-specialist**: Performance degradation analysis
   - **devops-sre**: Infrastructure impact assessment

4. **Evidence collection and preservation**:
   - System logs and metrics capture
   - Configuration snapshots  
   - Error message compilation
   - Timeline reconstruction
   - Impact quantification

### Phase 3 (Resolution - Ongoing)
5. **Solution implementation coordination**:
   - Fix development and testing
   - Rollback preparation
   - Deployment coordination
   - Recovery validation
   - Service restoration

## Examples
```
/incident outage sev1 --scope api --war-room
/incident security sev2 --impact compliance --stakeholders security-team
/incident performance sev3 --scope database --timeline 2h
/incident data sev1 --impact revenue --scope payments
/incident outage sev2 --scope frontend --stakeholders customer-success
```

## Incident Response Framework

### Severity Definitions
- **SEV1**: Complete service unavailable, revenue impact >$10K/hr
- **SEV2**: Core functionality degraded, affecting >25% users
- **SEV3**: Partial functionality impacted, workarounds available
- **SEV4**: Minor issues, minimal user impact, scheduled fix acceptable

### Response Time SLAs
- **SEV1**: Initial response <5 min, first update <15 min
- **SEV2**: Initial response <15 min, first update <30 min  
- **SEV3**: Initial response <1 hour, first update <2 hours
- **SEV4**: Initial response <4 hours, scheduled resolution

## Multi-Agent Orchestration

### Critical Incident Pattern (SEV1/SEV2)
```
PHASE 1 (Parallel - 0-5 min):
├── incident-commander: War room setup, initial assessment
├── crisis-management: Stakeholder notifications
└── devops-sre: System status verification

PHASE 2 (Parallel - 5-15 min):
├── debugger: Root cause investigation
├── performance-specialist: Impact analysis
├── security-auditor: Security implications
└── monitoring-specialist: Metrics analysis

PHASE 3 (Sequential - 15+ min):
├── Appropriate specialist: Solution implementation
├── devops-sre: Deployment and rollback readiness
└── crisis-management: Recovery communications
```

### Standard Incident Pattern (SEV3/SEV4)
```
PHASE 1 (Sequential - 0-30 min):
├── incident-commander: Classification and assignment
└── Relevant specialist: Investigation and analysis

PHASE 2 (As needed):
├── Development specialist: Fix implementation
└── crisis-management: Stakeholder updates
```

## Communication Protocols

### Internal Communications
- **War Room**: Dedicated incident channel
- **Status Updates**: Regular interval updates
- **Escalation**: Automatic based on duration/impact
- **Documentation**: Real-time incident log
- **Handoffs**: Structured shift transitions

### External Communications
- **Status Page**: Public incident transparency
- **Customer Notifications**: Proactive impact alerts
- **Partner Updates**: B2B impact communications
- **Regulatory Reports**: Compliance notifications
- **Press Statements**: Public relations coordination

## Incident Command Structure

### Roles and Responsibilities
- **Incident Commander**: Overall incident coordination
- **Technical Lead**: Solution implementation oversight
- **Communications Lead**: Stakeholder management
- **Subject Matter Experts**: Domain-specific analysis
- **Scribe**: Documentation and timeline tracking

### Decision Authority
- **IC (Incident Commander)**: Primary decision maker
- **Technical Lead**: Implementation decisions
- **Business Owner**: Business impact decisions
- **Legal/Compliance**: Regulatory decisions
- **Executive Sponsor**: Escalation decisions

## Advanced Features

### Automated Response
- **Alert Correlation**: Intelligent incident detection
- **Auto-Escalation**: Time-based severity increases
- **Runbook Execution**: Automated remediation steps
- **Resource Scaling**: Auto-scaling during incidents
- **Rollback Triggers**: Automatic failure recovery

### Post-Incident Analysis
- **Root Cause Analysis**: Comprehensive investigation
- **Timeline Reconstruction**: Detailed incident chronology
- **Impact Assessment**: Business and technical impact
- **Process Improvement**: Response optimization
- **Prevention Planning**: Future incident mitigation

### Compliance Integration
- **SOX**: Financial reporting incident procedures
- **GDPR**: Data breach notification requirements
- **HIPAA**: Healthcare data incident protocols
- **PCI-DSS**: Payment processing incident handling
- **SOC2**: Security incident documentation

## Integration Points

### Monitoring Systems
- **Alert Integration**: Automatic incident creation
- **Metrics Dashboard**: Real-time impact visualization
- **Log Analysis**: Automated evidence collection
- **Synthetic Monitoring**: Service validation
- **Business Metrics**: Revenue impact tracking

### Communication Tools
- **Slack/Teams**: Incident command channels
- **PagerDuty**: On-call escalation management
- **Zoom/Meet**: War room video conferences
- **Status Pages**: Customer communication
- **JIRA**: Incident tracking and follow-up

### Documentation Systems
- **Wiki**: Runbook and procedure storage
- **Git**: Configuration and code changes
- **Time Tracking**: Response time measurement
- **Audit Logs**: Compliance documentation
- **Knowledge Base**: Solution repository

## Output Deliverables

1. **Incident Response Plan**: Structured response procedures
2. **Communication Templates**: Pre-drafted notifications
3. **Escalation Matrix**: Contact lists and procedures
4. **Runbook Collection**: Common incident solutions
5. **Post-Mortem Template**: Incident analysis framework
6. **Training Materials**: Team preparedness resources
7. **Compliance Documentation**: Regulatory requirement guides

## Best Practices Implementation

### Response Excellence
- **Clear Command Structure**: Defined roles and authority
- **Structured Communication**: Regular, factual updates
- **Evidence Preservation**: Maintain investigation integrity
- **Customer Focus**: Minimize user impact
- **Continuous Improvement**: Learn from each incident

### Technical Standards
- **Rollback Readiness**: Always have a rollback plan
- **Impact Isolation**: Contain damage scope
- **Monitoring Enhancement**: Improve detection
- **Automation Investment**: Reduce manual toil
- **Resilience Building**: Strengthen system robustness

## Success Metrics

### Response Metrics
- **MTTR (Mean Time to Recovery)**: Incident resolution speed
- **MTTA (Mean Time to Acknowledge)**: Response promptness
- **False Positive Rate**: Alert accuracy
- **Escalation Rate**: Proper severity classification
- **Customer Impact**: User experience preservation

### Process Metrics
- **Runbook Coverage**: Documented solution percentage
- **Training Effectiveness**: Team preparedness scores
- **Communication Clarity**: Stakeholder satisfaction
- **Follow-up Completion**: Action item closure rate
- **Prevention Success**: Repeat incident reduction

## Prerequisites
- **Incident Type**: Clear problem classification
- **System Access**: Administrative privileges
- **Contact Lists**: Current stakeholder information
- **Runbooks**: Existing procedure documentation
- **Monitoring**: Current system visibility

## Notes
- Emphasizes structured command and control
- Balances speed with thorough investigation
- Maintains compliance with regulatory requirements
- Supports both technical and business stakeholders
- Provides framework for continuous improvement
- Scales from minor issues to major outages