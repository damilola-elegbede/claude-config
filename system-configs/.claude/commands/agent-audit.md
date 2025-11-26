---
description: Validate agent ecosystem integrity and compliance
argument-hint: [--frontmatter|--fix]
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

Perform comprehensive validation of all agents in the agent ecosystem to ensure category integrity,
template compliance, and system consistency. By default this is **REPORT ONLY** (recommendations and patch
snippets, no changes). Use `--fix` to apply safe, automated fixes.

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

| Agent | Parseable | Valid Fields | Description Format | Thinking Keywords | Error Details |
|-------|-----------|--------------|-------------------|-------------------|---------------|
| debugger | ❌ | N/A | Multi-line without quotes | N/A | Line 3-4: Invalid YAML syntax |

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

### Wave-Based Orchestration Strategy

Execute validation through progressive waves of parallel agent deployment with remediation capabilities:

#### Wave 1: Initial Validation (30-45 seconds)

Deploy specialized agents for comprehensive parallel validation:

```yaml
code-reviewer (8 instances - one per category):
  deployment: 8 parallel instances for category-based validation
  distribution:
    - instance_1: development category (6 agents) - blue
    - instance_2: quality category (4 agents) - green
    - instance_3: security category (1 agent) - red
    - instance_4: architecture category (4 agents) - purple
    - instance_5: design category (3 agents) - pink
    - instance_6: analysis category (4 agents) - yellow
    - instance_7: infrastructure category (4 agents) - orange
    - instance_8: coordination category (3 agents) - cyan
  role: YAML validation, template compliance, required sections
  output: Per-category validation reports with specific compliance metrics
  success_criteria:
    - YAML parseability: 100%
    - Template adherence: All sections present
    - Required fields validation: name, description, tools, model, category, color
    - Optional fields validation: thinking-level, thinking-tokens (if present)
```

**Claude Analysis Phase**: Review Wave 1 results, identify categories with issues, determine need for Wave 2 deployment.

#### Wave 2: Deep Analysis (conditional - only if issues detected)

Deploy specialized analysis agents for problem areas:

```yaml
security-auditor (conditional deployment):
  trigger: Agents with elevated permissions or Task tool violations detected
  role: Validate system boundaries, tool permissions, anti-pattern enforcement
  focus:
    - Task tool access violations
    - Orchestration attempts
    - Security boundary compliance
    - Privilege escalation risks
  output: Security compliance assessment with risk levels

performance-engineer (conditional deployment):
  trigger: Resource-intensive agents or model optimization opportunities
  role: Analyze model assignments, resource utilization, performance optimization
  focus:
    - Model appropriateness (opus/sonnet/haiku)
    - Resource allocation patterns
    - Performance optimization recommendations
  output: Performance optimization recommendations

debugger (conditional deployment):
  trigger: YAML parsing failures or validation errors from Wave 1
  role: Root cause analysis of validation failures
  focus:
    - YAML syntax errors
    - Template format violations
    - Missing required sections
    - Parsing error diagnostics
  output: Detailed error analysis with fix recommendations
```

**Claude Consolidation Phase**: Aggregate findings from Waves 1-2, determine remediation strategies, plan Wave 3 execution.

#### Wave 3: Remediation (conditional - only if fixes needed)

Apply automated fixes and generate comprehensive recommendations:

```yaml
Automated Remediation Capabilities:
  yaml_fixes:
    - Multi-line description block scalar formatting (|)
    - Tools field comma-separated string conversion
    - Required field insertion with default values
    - Front-matter syntax error correction

  template_compliance:
    - Missing section insertion (Identity, Core Capabilities, etc.)
    - System boundary warning addition
    - Category/color alignment with AGENT_CATEGORIES.md

  model_optimization:
    - Cost optimization suggestions (opus → sonnet)
    - Capability enhancement (haiku → sonnet)
    - Performance tuning recommendations

Report Generation:
  - Executive summary with compliance percentages
  - Category health matrix with issue breakdown
  - Remediation script generation for manual application
  - Before/after validation metrics
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

### Progressive Validation Features

#### Auto-Fix Capabilities

- **YAML Syntax Repair**: Automatically fix common YAML parsing errors
- **Template Standardization**: Insert missing required sections
- **Field Normalization**: Standardize field formats and values
- **Category Alignment**: Auto-correct category/color mismatches

#### Remediation Reports

- **Fix Scripts**: Generate executable remediation commands
- **Manual Interventions**: Identify issues requiring human review
- **Optimization Suggestions**: Model and performance improvements
- **Compliance Tracking**: Before/after validation metrics

### Success Criteria

✅ **Agent Count**: Exactly 37 production agents
✅ **YAML Parseability**: 100% of agent files have valid YAML per AGENT_TEMPLATE.md
✅ **Template Adherence**: All 37 agents follow 46-line AGENT_TEMPLATE.md format
✅ **Required Fields**: name, description, tools, model, category, color present
✅ **Optional Fields**: thinking-level and thinking-tokens validated when present (ultrathink: 31999, megathink: 10000, think harder: 8000, think: 4000)
✅ **Natural Language Triggers**: Agent descriptions contain "Triggers on" keyword patterns for routing
✅ **Thinking Consistency**: thinking-level value matches thinking-tokens count
✅ **Tool Validation**: No Task tool access, appropriate permissions
✅ **Anti-Pattern Free**: "Only Claude has orchestration authority" statement present
✅ **Model Appropriateness**: opus for complex reasoning (4 agents), sonnet for standard (33 agents)
✅ **Thinking Enhancement**: Appropriate thinking levels for complex agents (architecture, forensics, analysis)
✅ **Remediation Success**: Auto-fixes applied successfully, manual interventions documented
