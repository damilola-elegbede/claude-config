---
description: Validate agent ecosystem integrity and compliance
---

# /agent-audit Command

## Usage

```bash
# Full audit of all agents
/agent-audit

# Validate specific aspects
/agent-audit --frontmatter  # Focus on YAML frontmatter compliance
/agent-audit --fix          # Apply safe automatic fixes
```

## Description

Perform comprehensive validation of all agents in the agent ecosystem to ensure category integrity, template compliance, and system consistency. **This command generates a REPORT ONLY - it provides recommendations and optional patch snippets; it does not make any changes automatically.**

## Expected Output

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

1. **YAML Parsing Failures**: [Agents with unparseable YAML front matter]
2. **Task Tool Violations**: [List any agents with Task tool access]
3. **Orchestration Attempts**: [Agents trying to coordinate others]
4. **Missing Templates**: [Non-compliant agent formats]
5. **Tier 2 Agents**: [Any agents not at tier 1]
6. **Markdown Parsing Violations**: [Agents with formatting/parsing issues]

### YAML Front Matter Validation

| Agent | Parseable | Valid Fields | Description Format | Error Details |
|-------|-----------|--------------|-------------------|---------------|
| debugger | ❌ | N/A | Multi-line without quotes | Line 3-4: Invalid YAML syntax |

### Manual Remediation Required

```bash
# YAML Parsing Fixes (CRITICAL - Prefer YAML-aware tooling)
# Recommended (portable): use Python with python-frontmatter + PyYAML
python - <<'PY'
import io, yaml, frontmatter
path = 'agent-name.md'
post = frontmatter.load(path)

# Ensure multi-line description uses block scalar style (|)
desc = post.get('description')
if isinstance(desc, str) and '\n' in desc:
    class LiteralStr(str): pass
    def literal_representer(dumper, data):
        return dumper.represent_scalar('tag:yaml.org,2002:str', data, style='|')
    yaml.add_representer(LiteralStr, literal_representer)
    post['description'] = LiteralStr(desc)

# Ensure tools is a comma-separated string, not a YAML list
tools = post.get('tools')
if isinstance(tools, list):
    post['tools'] = ', '.join(tools)

with io.open(path, 'w', encoding='utf-8') as f:
    frontmatter.dump(post, f)
PY

# Model optimization suggestions (review before applying):
sed -i '' 's/model: opus/model: sonnet/' agent-name.md  # Save 40% cost
sed -i '' 's/model: haiku/model: sonnet/' agent-name.md  # Better capability
```

## Behavior

### Parallel Validation Strategy - Multi-Instance Deployment

Execute validation using parallel deployment of specialized agents to optimize performance:

```yaml
# PARALLEL WAVE 1: Multi-Instance Category Validation (30-45 seconds total)
code-reviewer (instance pool):
  deployment: 8 instances (one per category)
  calculation: min(8, number_of_categories)
  distribution:
    - instance_1: development category agents (3-5 agents)
    - instance_2: infrastructure category agents (3-5 agents)
    - instance_3: quality category agents (3-5 agents)
    - instance_4: security category agents (1-2 agents)
    - instance_5: analysis category agents (3-4 agents)
    - instance_6: architecture category agents (3-4 agents)
    - instance_7: design category agents (3-4 agents)
    - instance_8: operations/documentation agents (3-4 agents)
  parallel_with: [security-auditor instances, performance-engineer]
  role: Validate agent definitions, YAML compliance, template adherence
  output: Per-category validation reports generated simultaneously

security-auditor (instance pool):
  deployment: 2-3 instances for comprehensive security validation
  distribution:
    - instance_1: Tool permissions and access controls
    - instance_2: System boundaries and anti-patterns
    - instance_3: Security compliance and vulnerability assessment
  parallel_with: [code-reviewer instances, performance-engineer]
  role: Validate security boundaries and anti-patterns
  output: Security compliance reports from multiple angles

performance-engineer:
  role: Coordinate parallel execution and monitor performance
  input: Validation workflows, instance metrics
  output: Performance optimization, execution coordination

debugger:
  role: Investigate validation failures from all instances
  input: Aggregated failed validations, error patterns
  output: Root cause analysis, consolidated fix recommendations
```

### Validation Scope

#### 1. Category Validation (Per AGENT_CATEGORIES.md)

- **Exactly 8 Categories**: Validate against docs/agents/AGENT_CATEGORIES.md
- **Category Assignment**: Verify each agent matches AGENT_CATEGORIES.md assignments
- **Color Consistency**: Validate colors match AGENT_CATEGORIES.md specifications
- **Category Balance**: Report distribution (max 7 agents per category recommended)

#### 2. Template Compliance

- **AGENT_TEMPLATE.md Format**: All agents must follow the standard template
- **Required Sections**: Verify presence of all mandatory sections
- **YAML Front Matter Parsing**: Validate YAML syntax is parseable without errors
- **System Boundary**: Ensure anti-pattern warning is present

#### 3. Tool Assignment Validation

- **Tool Appropriateness**: Verify tools match agent responsibilities
- **No Task Tool**: Ensure no agent has access to Task tool (Claude exclusive)
- **Tool Categories**: Validate read-only vs write vs execute permissions

#### 4. Anti-Pattern Enforcement

- **No Orchestration**: Agents must not attempt to coordinate other agents
- **No Self-Reference**: Agents cannot reference themselves
- **No Task Tool Usage**: Task tool is reserved exclusively for Claude
- **Clear Boundaries**: Agents stay within their domain expertise

### Success Criteria

✅ **Agent Count**: Exactly 28 production agents
✅ **YAML Parseability**: 100% of agent files have valid YAML per AGENT_TEMPLATE.md
✅ **Template Adherence**: All 28 agents follow 46-line AGENT_TEMPLATE.md format
✅ **Required Fields**: name, description, tools, model, category, color present
✅ **Tool Validation**: No Task tool access, appropriate permissions
✅ **Anti-Pattern Free**: "Only Claude has orchestration authority" statement present
✅ **Model Appropriateness**: opus for complex reasoning, sonnet for standard, haiku for rapid tasks
