# /agent-audit Command

## Description

Comprehensive validation of agent ecosystem to ensure category integrity, template compliance, and system
consistency. **This command generates a REPORT ONLY - it provides recommendations and optional patch snippets;
it does not make any changes automatically.**

## Usage

```bash
/agent-audit
```bash

## Behavior
## Parallel Validation Strategy - Multi-Instance Deployment

### Category-Based Parallelization with Instance Pools

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

# Performance Impact:
#   Sequential: 3-5 minutes for all agents
#   Parallel with instances: 30-45 seconds (5-6x faster)
#   Instance scaling: Automatic based on category count
```bash


This command performs thorough validation of all agents across multiple dimensions, executed in parallel by
category for maximum efficiency.

## Purpose

Ensure agent ecosystem maintains high standards of consistency, proper categorization, and adherence to system
design principles.

## Validation Scope

### 1. Category Validation (Per AGENT_CATEGORIES.md)

- **Exactly 8 Categories**: Validate against docs/agents/AGENT_CATEGORIES.md
- **Category Assignment**: Verify each agent matches AGENT_CATEGORIES.md assignments
- **Color Consistency**: Validate colors match AGENT_CATEGORIES.md specifications
  - Development (blue), Quality (green), Security (red), Architecture (purple)
  - Design (pink), Analysis (yellow), Infrastructure (orange), Coordination (cyan)
- **Category Balance**: Report distribution (max 7 agents per category recommended)

### 2. Template Compliance

- **AGENT_TEMPLATE.md Format**: All agents must follow the standard template
- **Required Sections**: Verify presence of all mandatory sections
- **YAML Front Matter Parsing**: Validate YAML syntax is parseable without errors
- **YAML Field Validation**: Ensure all required fields are present and properly formatted
- **Multi-line String Compliance**: Check description fields for proper YAML multi-line syntax
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

### 6. Markdown Parsing Standards

- **Code Fencing Consistency**: Ensure all code blocks use proper language tags (`bash`, `yaml`, `python`, etc.)
- **Example Quality**: Verify examples are focused, well-commented, and provide clear context
- **Structured Formats**: Validate use of YAML for workflows and structured data
- **Code Format Separation**: Ensure clean separation between inline code and code blocks
- **Command Clarity**: Multi-line commands must include explanations and context

**Anti-Patterns to Detect**:

- Overly complex multi-line commands without explanation
- Inconsistent formatting between sections
- Mixed inline/block code formats creating ambiguity
- Missing language tags on code fences
- Poorly structured workflow examples

### 7. Tier Validation

- **Tier 1 Only**: All agents must be tier 1 (no tier 2 agents allowed)
- **Model Assignment**: Verify appropriate model selection
- **Performance Optimization**: Ensure efficient agent deployment

### 8. Model Appropriateness Analysis

- **Strategic Tasks → Opus**: Complex reasoning, cross-domain expertise, high-stakes decisions
- **Technical Tasks → Sonnet**: Implementation, analysis, specialized domain work
- **Rule-Based Tasks → Haiku**: Pattern matching, compliance checking, structured validation
- **Cost Optimization**: Identify over-provisioned agents (using higher model than needed)
- **Capability Gaps**: Identify under-provisioned agents (needing higher model)
- **Usage Patterns**: Review actual complexity vs assigned model

## Execution Strategy

### Phase 0: YAML Validation (Critical - Run First)

Before any other validation, ensure all agent files conform to AGENT_TEMPLATE.md and AGENT_CATEGORIES.md:

```yaml
yaml_validation:
  templates:
    - docs/agents/AGENT_TEMPLATE.md  # Format specification
    - docs/agents/AGENT_CATEGORIES.md # Category definitions

  category_validation:
    valid_categories: [development, quality, security, architecture, design, analysis, infrastructure, coordination]
    category_colors:
      development: blue
      quality: green
      security: red
      architecture: purple
      design: pink
      analysis: yellow
      infrastructure: orange
      coordination: cyan

  field_validation:
    required: [name, description, tools, model, category, color]
    prohibited: [specialization_level, domain_expertise, coordination_protocols]

  format_validation:
    expected_lines: ~46 (range: 40-60)
    required_sections: [Identity, Core Capabilities, When to Engage, When NOT to Engage, Coordination, SYSTEM BOUNDARY]
```bash

### Phase 1: Multi-Instance Parallel Category Audits

Deploy multiple agent instances to validate all categories simultaneously:

```yaml
multi_instance_execution:
  instance_pool_strategy:
    - Calculate category count and agent distribution
    - Deploy one code-reviewer instance per category (max 8)
    - Each instance validates 5-10 agents within its category
    - All instances execute simultaneously

  validation_per_instance:
    - YAML front matter parsing and compliance
    - Template adherence verification
    - Tool permission validation
    - Description quality assessment
    - Markdown parsing standards
    - Tier and model appropriateness

  parallel_waves:
    wave_1: # All categories validated simultaneously
      - development_instance: Validate all development agents
      - infrastructure_instance: Validate all infrastructure agents
      - quality_instance: Validate all quality agents
      - security_instance: Validate all security agents
      - analysis_instance: Validate all analysis agents
      - architecture_instance: Validate all architecture agents
      - design_instance: Validate all design agents
      - operations_instance: Validate all operations agents

  aggregation:
    - Collect results from all instances
    - Merge validation reports
    - Identify cross-category issues
    - Generate consolidated report

# Execution Time Optimization:
#   - Sequential category validation: 20-30 seconds per category
#   - Parallel multi-instance: All categories in 30-45 seconds total
#   - Result: 5-6x faster validation with better resource utilization
```bash

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

## Execution Verification

After audit completion, **execution-evaluator** is deployed to verify:

- All agent files were scanned successfully
- YAML front matter parsing attempted for all agents
- Unparseable YAML agents were identified and reported
- Valid agents proceeded through full validation
- Tool permissions were validated
- Markdown parsing standards were enforced
- Code fencing and formatting consistency validated
- Report generated with all required sections including YAML issues
- Patch snippets (if any) are syntactically correct
- Fix commands for YAML issues were generated

## Report Structure

### Executive Summary

```text
Total Agents: XX | Categories: X/8 | Compliance: XX% | Issues Fixed: XX
```bash

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

**YAML Parsing Issues Found**:

- **Invalid multi-line strings**: X agents (description field not properly quoted/formatted)
- **Missing required fields**: X agents (name, description, tools, etc.)
- **Malformed YAML structure**: X agents (indentation errors, missing colons)
- **Special character escaping**: X agents (unescaped quotes in descriptions)

### Markdown Parsing Compliance

| Agent | Code Fencing | Language Tags | Example Quality | Format Consistency | Issues |
|-------|--------------|---------------|-----------------|-------------------|---------|
| agent-name | ✅ | ❌ | ✅ | ✅ | Missing bash tags |
| agent-name | ✅ | ✅ | ❌ | ✅ | Complex examples without explanation |

**Parsing Standards Summary**:

- Code Fencing: XX/XX agents compliant
- Language Tags: XX/XX agents compliant
- Example Quality: XX/XX agents compliant
- Format Consistency: XX/XX agents compliant
**Common Anti-Patterns Found**:

- Missing language tags on code fences: X agents
- Complex commands without explanation: X agents
- Mixed inline/block formatting: X agents
- Inconsistent section formatting: X agents

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
```bash

### Manual Remediation Required

```bash
# YAML Parsing Fixes (CRITICAL - Prefer YAML-aware tooling)
# Recommended (portable): use Python with python-frontmatter + PyYAML
#   pip install python-frontmatter pyyaml
python - <<'PY'
import io, yaml, frontmatter
path = 'agent-name.md'
post = frontmatter.load(path)

# Ensure multi-line description uses block scalar style (|).
desc = post.get('description')
if isinstance(desc, str) and '\n' in desc:
    class LiteralStr(str): pass
    def literal_representer(dumper, data):
        return dumper.represent_scalar('tag:yaml.org,2002:str', data, style='|')
    yaml.add_representer(LiteralStr, literal_representer)
    post['description'] = LiteralStr(desc)

# Ensure tools is a comma-separated string, not a YAML list.
tools = post.get('tools')
if isinstance(tools, list):
    post['tools'] = ', '.join(tools)

with io.open(path, 'w', encoding='utf-8') as f:
    frontmatter.dump(post, f)
PY

# Fallback (manual edit):
# ---
# description: |
#   Your multi-line description...
# tools: Read, Write, Grep
# ---

# Execute these commands to fix remaining issues:
sed -i '' 's/category: wrong/category: correct/' agent.md

# Model optimization suggestions (review before applying):
# Downgrade over-provisioned agents:
sed -i '' 's/model: opus/model: sonnet/' agent-name.md  # Save 40% cost
# Upgrade under-provisioned agents:
sed -i '' 's/model: haiku/model: sonnet/' agent-name.md  # Better capability
```bash

## Success Criteria

✅ **Agent Count**: Exactly 28 production agents
✅ **YAML Parseability**: 100% of agent files have valid YAML per AGENT_TEMPLATE.md
✅ **Template Adherence**: All 28 agents follow 46-line AGENT_TEMPLATE.md format
✅ **Required Fields**: name, description, tools, model, category, color present
✅ **No Deprecated Fields**: No specialization_level, domain_expertise, coordination_protocols, etc.
✅ **File Length**: All agents ~46 lines (40-60 range acceptable)
✅ **Required Sections**: Identity, Core Capabilities, When to Engage, When NOT to Engage, Coordination, SYSTEM BOUNDARY
✅ **Tool Validation**: No Task tool access, appropriate permissions
✅ **Anti-Pattern Free**: "Only Claude has orchestration authority" statement present
✅ **Description Quality**: Includes trigger phrases (MUST BE USED, Use PROACTIVELY, Expert, Specializes)
✅ **Model Appropriateness**: opus for complex reasoning, sonnet for standard, haiku for rapid tasks

## Implementation Notes

- **Multi-Instance Deployment**: Deploy 8+ code-reviewer instances for parallel category validation
- **Dynamic Scaling**: Instance count adjusts based on number of categories and agents
- **Work Distribution**: Each instance handles 5-10 agents maximum for optimal performance
- **Parallel Aggregation**: Results from all instances merge into comprehensive report
- **Performance Target**: Complete full audit in 30-45 seconds (vs 3-5 minutes sequential)
- Auto-fix safe issues, provide commands for complex ones
- Focus on maintaining established categories (avoid frequent refactoring)
- Generate actionable report suitable for immediate implementation
