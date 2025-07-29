# Agent Audit Command

Run comprehensive agent ecosystem validation by launching multiple agent-auditor instances in parallel, one for each agent category.

## Usage
```
/agent-audit
```

## Purpose
Comprehensive validation of the entire agent ecosystem through parallel category-based audits.

## Execution Protocol

### Phase 1: Parallel Category Audits
Launch agent-auditor instances for all categories simultaneously:

<function_calls>
<invoke name="Task">
<parameter name="description">Audit Development agents</parameter>
<parameter name="prompt">Use the agent-auditor to validate all agents in the Development category (blue). Check for compliance with AGENT_TEMPLATE.md standards, validate YAML structure, and perform gap analysis for missing agents.</parameter>
<parameter name="subagent_type">agent-auditor</parameter>
</invoke>
<invoke name="Task">
<parameter name="description">Audit Infrastructure agents</parameter>
<parameter name="prompt">Use the agent-auditor to validate all agents in the Infrastructure category (orange). Check for compliance with AGENT_TEMPLATE.md standards, validate YAML structure, and perform gap analysis for missing agents.</parameter>
<parameter name="subagent_type">agent-auditor</parameter>
</invoke>
<invoke name="Task">
<parameter name="description">Audit Architecture agents</parameter>
<parameter name="prompt">Use the agent-auditor to validate all agents in the Architecture category (purple). Check for compliance with AGENT_TEMPLATE.md standards, validate YAML structure, and perform gap analysis for missing agents.</parameter>
<parameter name="subagent_type">agent-auditor</parameter>
</invoke>
<invoke name="Task">
<parameter name="description">Audit Design agents</parameter>
<parameter name="prompt">Use the agent-auditor to validate all agents in the Design category (purple). Check for compliance with AGENT_TEMPLATE.md standards, validate YAML structure, and perform gap analysis for missing agents.</parameter>
<parameter name="subagent_type">agent-auditor</parameter>
</invoke>
<invoke name="Task">
<parameter name="description">Audit Quality agents</parameter>
<parameter name="prompt">Use the agent-auditor to validate all agents in the Quality category (green). Check for compliance with AGENT_TEMPLATE.md standards, validate YAML structure, and perform gap analysis for missing agents.</parameter>
<parameter name="subagent_type">agent-auditor</parameter>
</invoke>
<invoke name="Task">
<parameter name="description">Audit Security agents</parameter>
<parameter name="prompt">Use the agent-auditor to validate all agents in the Security category (red). Check for compliance with AGENT_TEMPLATE.md standards, validate YAML structure, and perform gap analysis for missing agents.</parameter>
<parameter name="subagent_type">agent-auditor</parameter>
</invoke>
<invoke name="Task">
<parameter name="description">Audit Analysis agents</parameter>
<parameter name="prompt">Use the agent-auditor to validate all agents in the Analysis category (yellow). Check for compliance with AGENT_TEMPLATE.md standards, validate YAML structure, and perform gap analysis for missing agents.</parameter>
<parameter name="subagent_type">agent-auditor</parameter>
</invoke>
<invoke name="Task">
<parameter name="description">Audit Operations agents</parameter>
<parameter name="prompt">Use the agent-auditor to validate all agents in the Operations category (orange). Check for compliance with AGENT_TEMPLATE.md standards, validate YAML structure, and perform gap analysis for missing agents.</parameter>
<parameter name="subagent_type">agent-auditor</parameter>
</invoke>
</function_calls>

### Phase 2: Validation Dimensions
Each audit validates compliance across:
- **YAML Structure**: Required fields, proper formatting, valid syntax
- **Template Adherence**: Compliance with AGENT_TEMPLATE.md standards
- **Tool Permissions**: Appropriate tools for agent responsibilities
- **Category Assignment**: Correct categorization and color coding
- **Coordination Protocols**: Inter-agent communication patterns
- **Gap Analysis**: Missing capabilities within each category

## Executive Report Structure

### 1. Executive Summary
**Health Score: XX/100** | **Agents: XX** | **Production Ready: XX%** | **Critical Issues: X**

### 2. Category Performance Matrix
| Category | Agent Count | Health Score | Status | Critical Issues |
|----------|-------------|-------------|---------|----------------|
| Development | X | XX/100 | Status | X |
| Infrastructure | X | XX/100 | Status | X |
| Quality | X | XX/100 | Status | X |
| Security | X | XX/100 | Status | X |
| Analysis | X | XX/100 | Status | X |
| Architecture | X | XX/100 | Status | X |
| Design | X | XX/100 | Status | X |
| Operations | X | XX/100 | Status | X |

### 3. Critical Issues Analysis
For each critical issue identified:
- **Issue Description**: Specific problem found
- **Impact Assessment**: How it affects agent functionality
- **Affected Agents**: Which agents are impacted
- **Fix Commands**: Exact bash/sed commands to resolve
- **Priority Level**: Critical/High/Medium/Low

### 4. Gap Analysis Report
#### Missing Critical Capabilities
- **High Priority Gaps**: Essential missing agent types
- **Medium Priority Gaps**: Important but not critical
- **Low Priority Gaps**: Nice-to-have capabilities
- **Justification**: Why each gap matters for ecosystem completeness

#### Coverage Assessment
- Domain coverage percentage by category
- Overlap analysis between similar agents
- Specialization boundary clarity

### 5. Next Steps & Action Plan

#### Immediate Actions (Execute Now)
```bash
# Critical fixes with specific commands
sed -i '' 's/old/new/' agent-file.md
# Additional fixes...
```

#### Short-term Actions (Next Sprint)
- Specific agent improvements needed
- Category reorganization requirements
- Tool permission optimizations

#### Strategic Actions (Next Quarter)
- New agent creation priorities
- Ecosystem architecture improvements
- Coordination protocol enhancements

### 6. Technical Remediation Guide

#### Ready-to-Execute Fixes
Specific bash commands for each identified issue:
```bash
# Example fixes
sed -i '' '6s/.*/tools: Read, Write, Edit/' agent.md
git add . && git commit -m "fix: agent compliance issues"
```

#### Manual Review Required
Issues that need human judgment:
- Content quality assessments
- Strategic capability decisions
- Category boundary clarifications

## Success Criteria

✅ **Ecosystem Health**: Minimum 85/100 overall score  
✅ **Production Ready**: 95%+ agents validated for immediate use  
✅ **Critical Issues**: All identified with specific remediation  
✅ **Gap Coverage**: Comprehensive analysis of missing capabilities  
✅ **Action Plan**: Prioritized roadmap with timelines  
✅ **Technical Spec**: Executive-level decision-making support  

## Implementation Notes

- All audits run in parallel for maximum efficiency
- Results aggregated into single comprehensive report
- Each category audit is independent and can be executed separately
- Focus on actionable recommendations over theoretical analysis
- Executive summary suitable for technical leadership review

## Output Format

The command generates a structured markdown report containing:
1. High-level executive summary with key metrics
2. Detailed findings by category with specific scores
3. Prioritized action items with exact commands
4. Strategic recommendations for ecosystem evolution
5. Technical specification suitable for decision-making