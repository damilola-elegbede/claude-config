# Security Access Patterns Documentation

## Agent Tool Access Security Framework

This document defines the security access patterns and rationale for all Claude Code agents, ensuring appropriate tool restrictions while maintaining functional capabilities.

## Access Categories

### 1. Full Access (Staff-Level Implementation Agents)
**Agents**: backend-engineer, frontend-engineer, fullstack-lead, qa-engineer, devops
**Tools Allowed**: [Bash, Read, Write, Edit, MultiEdit, Glob, Grep, LS, WebFetch, WebSearch, TodoWrite, NotebookRead, NotebookEdit]
**Tools Forbidden**: []
**Security Rationale**: These agents implement production code and require comprehensive tool access to fulfill their responsibilities. They operate under the principle of "trusted implementation" with full capability to modify systems.

### 2. Read-Only Plus Analysis
**Agents**: security-auditor, debugger, code-reviewer, codebase-analyst, performance-engineer, researcher
**Tools Allowed**: [Glob, Grep, LS, Read, NotebookRead, WebFetch, WebSearch, Bash(read-only), TodoWrite]
**Tools Forbidden**: [Edit, MultiEdit, Write, NotebookEdit]
**Security Rationale**: Analysis agents focus on assessment and reporting without modifying production systems. This separation ensures analysis integrity and prevents accidental system modifications during security reviews.

### 3. Design Specification Access
**Agents**: ui-designer, mobile-ui
**Tools Allowed**: [Read, Write, Edit, MultiEdit, Glob, Grep, LS, WebFetch, WebSearch, TodoWrite, Bash(read-only)]
**Tools Forbidden**: [NotebookRead, NotebookEdit]
**Security Rationale**: Design agents create specifications and documentation but don't need system execution capabilities or data analysis tools.

### 4. Documentation Access
**Agents**: tech-writer, api-engineer
**Tools Allowed**: [Read, Write, Edit, MultiEdit, Glob, Grep, LS, WebFetch, WebSearch, TodoWrite, Bash(read-only)]
**Tools Forbidden**: [NotebookRead, NotebookEdit]
**Security Rationale**: Documentation agents need file modification capabilities for specifications but limited system access.

### 5. Strategic Planning Access
**Agents**: principal-architect
**Tools Allowed**: [Read, Write, Edit, MultiEdit, Glob, Grep, LS, WebFetch, WebSearch, TodoWrite, Bash(read-only)]
**Tools Forbidden**: [NotebookRead, NotebookEdit]
**Security Rationale**: Architects coordinate strategy and planning through the general-purpose agent, focusing on creating implementation plans without needing data analysis capabilities.

## Security Boundaries

### Critical Security Principles

1. **Principle of Least Privilege**: Each agent receives only the minimum tools necessary for its role
2. **Separation of Concerns**: Analysis agents cannot modify code; implementation agents focus on building
3. **Defense in Depth**: Multiple layers of access control prevent privilege escalation
4. **Audit Trail**: All tool restrictions are documented with clear rationale

### Risk Mitigation Strategies

#### High-Risk Mitigations
- **Analysis Agents**: Forbidden from Write/Edit operations to prevent accidental production modifications
- **Security Auditor**: Read-only access ensures security reviews don't alter the systems being audited
- **Design Agents**: Limited to specification tools, preventing system-level access

#### Medium-Risk Mitigations
- **Documentation Agents**: Controlled file access prevents system configuration changes
- **Coordination Agents**: Orchestrate through the general-purpose agent with limited system execution

## Agent-Specific Security Rationale

### Implementation Agents (Full Access)
- **backend-engineer**: Implements complex distributed systems requiring database and infrastructure access
- **frontend-engineer**: Manages build processes and deployment configurations requiring full system access
- **fullstack-lead**: Implements features within defined scope, needs complete toolset for effectiveness
- **qa-engineer**: Creates test infrastructure and automation requiring full implementation capabilities
- **devops**: Manages infrastructure automation requiring comprehensive system access

### Analysis Agents (Read-Only Plus Analysis)
- **security-auditor**: Performs vulnerability assessment without modifying audit targets
- **debugger**: Investigates issues through analysis without changing production systems
- **code-reviewer**: Reviews code quality without implementing changes
- **codebase-analyst**: Analyzes system architecture for reporting purposes only
- **performance-engineer**: Analyzes and tests performance without modifying implementations

### Design Agents (Specification Access)
- **ui-designer**: Creates design specifications and documentation for web/desktop platforms
- **mobile-ui**: Creates mobile-specific design specifications and platform compliance guidelines

### Documentation Agents (Documentation Access)
- **tech-writer**: Creates technical documentation and API specifications
- **api-engineer**: Designs API contracts and specifications without implementation

### Strategic Agents (Planning Access)
- **principal-architect**: Coordinates strategy and creates plans for the general-purpose agent to execute

## Compliance and Monitoring

### Security Monitoring
- All tool restrictions are explicitly defined in agent configurations
- Access patterns are documented with clear business justification
- Regular security audits validate access appropriateness

### Compliance Standards
- Follows principle of least privilege (ISO 27001)
- Implements separation of duties for security-critical functions
- Maintains audit trails for all access decisions
- Documents security rationale for regulatory compliance

## Emergency Procedures

### Security Incident Response
1. **Immediate**: Review affected agent access patterns
2. **Assessment**: Determine if tool restrictions prevented or limited damage
3. **Response**: Temporarily restrict agent access if needed
4. **Recovery**: Implement additional restrictions based on incident learnings

### Access Review Process
- Monthly review of agent tool access patterns
- Quarterly security assessment of access appropriateness
- Annual comprehensive security audit of all agent configurations
- Immediate review after any security incidents

## Change Management

### Adding New Agents
1. **Risk Assessment**: Evaluate required tools against security principles
2. **Access Design**: Implement minimum necessary tool access
3. **Documentation**: Document security rationale for all access decisions
4. **Review**: Security team approval for all new agent access patterns

### Modifying Existing Access
1. **Justification**: Business case for access changes
2. **Security Review**: Assessment of additional risks
3. **Testing**: Validation of new access patterns in non-production
4. **Approval**: Security team approval for production deployment

This framework ensures Claude Code agents operate securely while maintaining the functionality needed for effective software development assistance.