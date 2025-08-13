# /agent-audit Command

## Description

Comprehensive validation of agent ecosystem to ensure category integrity, template compliance, and system consistency. **This command generates a REPORT ONLY - it provides recommendations and optional patch snippets; it does not make any changes automatically.**

## Usage

```bash
/agent-audit
```

## Behavior

This command performs thorough validation of all agents across multiple dimensions, executed in parallel by category for maximum efficiency.

## Purpose

Ensure agent ecosystem maintains high standards of consistency, proper categorization, and adherence to system design principles.

## Validation Scope

### 1. Category Validation

- **Maximum Categories**: Ensure ≤ 8 categories exist
- **Category Assignment**: Verify each agent is in the correct category based on its role
- **Color Consistency**: Validate color assignments match category standards
- **Category Balance**: Report on distribution (not enforced, informational only)

### 2. Template Compliance

- **AGENT_TEMPLATE.md Format**: All agents must follow the standard template
- **Required Sections**: Verify presence of all mandatory sections
- **YAML Frontmatter**: Validate structure and field completeness
- **System Boundary**: Ensure anti-pattern warning is present

### 3. Tool Assignment Validation

- **Tool Appropriateness**: Verify tools match agent responsibilities
- **No Task Tool**: Ensure no agent has access to Task tool (Claude exclusive)
- **Tool Categories**: Validate read-only vs write vs execute permissions

### 4. Anti-Pattern Enforcement

- **No Orchestration**: Agents must not attempt to coordinate other agents
- **No Self-Reference**: Agents cannot reference themselves
- **No Task Tool Usage**: Task tool is reserved exclusively for Claude
- **Clear Boundaries**: Agents stay within their domain expertise

### 5. Description Quality

- **Actionable Triggers**: Descriptions must include "MUST BE USED" scenarios
- **Proactive Triggers**: Include "use PROACTIVELY" for agents that should be used without explicit request
- **Clear Scope**: Well-defined boundaries of responsibility
- **Usage Context**: When Claude should select this agent
- **Updated Descriptions**: Derive from agent's actual capabilities if needed

### 6. Tier Validation

- **Tier 1 Only**: All agents must be tier 1 (no tier 2 agents allowed)
- **Model Assignment**: Verify appropriate model selection
- **Performance Optimization**: Ensure efficient agent deployment

### 7. Model Appropriateness Analysis

- **Strategic Tasks → Opus**: Complex reasoning, cross-domain expertise, high-stakes decisions
- **Technical Tasks → Sonnet**: Implementation, analysis, specialized domain work
- **Rule-Based Tasks → Haiku**: Pattern matching, compliance checking, structured validation
- **Cost Optimization**: Identify over-provisioned agents (using higher model than needed)
- **Capability Gaps**: Identify under-provisioned agents (needing higher model)
- **Usage Patterns**: Review actual complexity vs assigned model

## Execution Strategy

### Phase 1: Parallel Category Audits

Execute validation for each category simultaneously:

```yaml
parallel_execution:
  - category: development
    validations: [template, tools, description, tier, modelAppropriateness]
  - category: infrastructure  
    validations: [template, tools, description, tier, modelAppropriateness]
  - category: quality
    validations: [template, tools, description, tier, modelAppropriateness]
  - category: security
    validations: [template, tools, description, tier, modelAppropriateness]
  - category: analysis
    validations: [template, tools, description, tier, modelAppropriateness]
  - category: architecture
    validations: [template, tools, description, tier, modelAppropriateness]
  - category: design
    validations: [template, tools, description, tier, modelAppropriateness]
  - category: operations
    validations: [template, tools, description, tier, modelAppropriateness]
```

### Phase 2: Cross-Category Analysis

- Category count validation
- Color assignment consistency
- Coverage gap identification
- Redundancy detection

### Phase 3: Remediation

- Auto-fix where possible (formatting, tier updates)
- Generate specific fix commands for manual issues
- Update descriptions based on capabilities
- Document all changes made
- **Model changes are RECOMMENDATIONS ONLY** (not auto-applied)

## Report Structure

### Executive Summary

```text
Total Agents: XX | Categories: X/8 | Compliance: XX% | Issues Fixed: XX
```

### Category Health Matrix

| Category | Agent Count | Compliance | Color | Issues |
|----------|------------|------------|-------|--------|
| development | X | XX% | blue | X |
| infrastructure | X | XX% | orange | X |
| quality | X | XX% | green | X |
| security | X | XX% | red | X |

### Critical Issues

1. **Task Tool Violations**: [List any agents with Task tool access]
2. **Orchestration Attempts**: [Agents trying to coordinate others]
3. **Missing Templates**: [Non-compliant agent formats]
4. **Tier 2 Agents**: [Any agents not at tier 1]

### Model Appropriateness Analysis

| Agent | Current Model | Suggested Model | Reasoning | Cost Impact |
|-------|---------------|-----------------|-----------|-------------|
| agent-name | opus | sonnet | Technical task, no strategic reasoning needed | -40% |
| agent-name | haiku | sonnet | Complex analysis requires more capability | +20% |

**Model Distribution**:

- Opus: X agents (Y% - Target: 15-20%)
- Sonnet: X agents (Y% - Target: 60-70%)  
- Haiku: X agents (Y% - Target: 15-20%)

**Optimization Opportunities**:

- Over-provisioned agents: X (potential savings: $Y/month)
- Under-provisioned agents: X (recommended upgrades)

### Auto-Remediation Log

```bash
# Fixes applied automatically:
- Updated agent-name: Set tier to 1
- Fixed agent-name: Removed Task tool access
- Updated agent-name: Added SYSTEM BOUNDARY warning
```

### Manual Remediation Required

```bash
# Execute these commands to fix remaining issues:
sed -i '' 's/category: wrong/category: correct/' agent.md

# Model optimization suggestions (review before applying):
# Downgrade over-provisioned agents:
sed -i '' 's/model: opus/model: sonnet/' agent-name.md  # Save 40% cost
# Upgrade under-provisioned agents:
sed -i '' 's/model: haiku/model: sonnet/' agent-name.md  # Better capability
```

## Success Criteria

✅ **Category Compliance**: ≤ 8 categories with proper color mapping  
✅ **Template Adherence**: 100% AGENT_TEMPLATE.md compliance  
✅ **Tool Validation**: No Task tool access, appropriate permissions  
✅ **Anti-Pattern Free**: No orchestration or self-reference  
✅ **Description Quality**: Clear "MUST BE USED" and "use PROACTIVELY" triggers  
✅ **Tier 1 Only**: All agents at tier 1 level  
✅ **Model Appropriateness**: Each agent uses optimal model for its complexity  
✅ **Documentation Sync**: All docs reflect current state  

## Implementation Notes

- Claude executes all validations directly (no agent-auditor needed)
- Parallel execution by category for efficiency
- Auto-fix safe issues, provide commands for complex ones
- Focus on maintaining established categories (avoid frequent refactoring)
- Generate actionable report suitable for immediate implementation
