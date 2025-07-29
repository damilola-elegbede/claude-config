# Agent Audit Command

Run comprehensive agent ecosystem validation by launching multiple agent-auditor instances in parallel, one for each agent category.

## Usage
```
/agent-audit
```

## Execution

Launch agent-auditor instances for all categories in parallel:

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

## Summary

After all parallel audits complete, provide a consolidated report showing:
- Total compliance score across all categories
- Critical issues that need immediate attention
- Missing agents by category
- Recommendations for ecosystem improvements