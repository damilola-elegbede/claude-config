# /agent-audit Command

## Description

Orchestrate comprehensive agent ecosystem validation through parallel category-based audits using Claude's orchestration capabilities.

## Usage
```
/agent-audit
```

## Behavior
This command coordinates comprehensive validation of the entire agent ecosystem through Claude-orchestrated parallel audits.

## Purpose
Comprehensive validation of the entire agent ecosystem through Claude-orchestrated parallel audits.

## Orchestration Strategy

Claude should execute the following parallel audit strategy:

### Phase 1: Parallel Category Audits
Launch agent-auditor instances for all categories simultaneously through Claude's orchestration:

1. **Development Category Audit** (Blue agents)
   - Validate all agents in Development category
   - Check AGENT_TEMPLATE.md compliance
   - Validate YAML structure
   - Perform gap analysis for missing agents

2. **Infrastructure Category Audit** (Orange agents)
   - Validate all agents in Infrastructure category
   - Check AGENT_TEMPLATE.md compliance
   - Validate YAML structure
   - Perform gap analysis for missing agents

3. **Architecture Category Audit** (Purple agents)
   - Validate all agents in Architecture category
   - Check AGENT_TEMPLATE.md compliance
   - Validate YAML structure
   - Perform gap analysis for missing agents

4. **Design Category Audit** (Pink agents)
   - Validate all agents in Design category
   - Check AGENT_TEMPLATE.md compliance
   - Validate YAML structure
   - Perform gap analysis for missing agents

5. **Quality Category Audit** (Green agents)
   - Validate all agents in Quality category
   - Check AGENT_TEMPLATE.md compliance
   - Validate YAML structure
   - Perform gap analysis for missing agents

6. **Security Category Audit** (Red agents)
   - Validate all agents in Security category
   - Check AGENT_TEMPLATE.md compliance
   - Validate YAML structure
   - Perform gap analysis for missing agents

7. **Analysis Category Audit** (Yellow agents)
   - Validate all agents in Analysis category
   - Check AGENT_TEMPLATE.md compliance
   - Validate YAML structure
   - Perform gap analysis for missing agents

8. **Operations Category Audit** (Orange agents)
   - Validate all agents in Operations category
   - Check AGENT_TEMPLATE.md compliance
   - Validate YAML structure
   - Perform gap analysis for missing agents

### Phase 2: Validation Dimensions
Each audit validates compliance across:
- **YAML Structure**: Required fields, proper formatting, valid syntax
- **Template Adherence**: Compliance with AGENT_TEMPLATE.md standards
- **Tool Permissions**: Appropriate tools for agent responsibilities
- **Category Assignment**: Correct categorization and color coding
- **Coordination Protocols**: Inter-agent communication patterns
- **Gap Analysis**: Missing capabilities within each category
- **Anti-Pattern Detection**: No agent self-referencing or Task tool usage

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

### 4. Anti-Pattern Detection Report
- **Task Tool Violations**: Agents referencing or using Task tool
- **Self-Referencing**: Agents calling themselves or other agents
- **Orchestration Violations**: Agents bypassing Claude coordination
- **Tool Access Violations**: Agents referencing tools they don't have

### 5. Gap Analysis Report
#### Missing Critical Capabilities
- **High Priority Gaps**: Essential missing agent types
- **Medium Priority Gaps**: Important but not critical
- **Low Priority Gaps**: Nice-to-have capabilities
- **Justification**: Why each gap matters for ecosystem completeness

#### Coverage Assessment
- Domain coverage percentage by category
- Overlap analysis between similar agents
- Specialization boundary clarity

### 6. Next Steps & Action Plan

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

### 7. Technical Remediation Guide

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
✅ **Anti-Pattern Compliance**: No agent self-referencing or Task tool usage  
✅ **Action Plan**: Prioritized roadmap with timelines  
✅ **Technical Spec**: Executive-level decision-making support  

## Implementation Notes

- Claude orchestrates all audits in parallel for maximum efficiency
- Results aggregated by Claude into single comprehensive report
- Each category audit is independent and can be executed separately
- Focus on actionable recommendations over theoretical analysis
- Executive summary suitable for technical leadership review
- Strict enforcement of orchestration principles

## Output Format

The command generates a structured markdown report containing:
1. High-level executive summary with key metrics
2. Detailed findings by category with specific scores
3. Anti-pattern detection results
4. Prioritized action items with exact commands
5. Strategic recommendations for ecosystem evolution
