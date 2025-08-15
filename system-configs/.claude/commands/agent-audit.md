# /agent-audit Command

## Description

Comprehensive validation of agent ecosystem to ensure category integrity, template compliance, and system
consistency. **This command generates a REPORT ONLY - it provides recommendations and optional patch snippets;
it does not make any changes automatically.**

## Usage

```bash
/agent-audit
```

## Behavior

This command performs thorough validation of all agents across multiple dimensions, executed in parallel by
category for maximum efficiency.

## Purpose

Ensure agent ecosystem maintains high standards of consistency, proper categorization, and adherence to system
design principles.

## Validation Scope

### 1. Category Validation

- **Maximum Categories**: Ensure ≤ 8 categories exist
- **Category Assignment**: Verify each agent is in the correct category based on its role
- **Color Consistency**: Validate color assignments match category standards
- **Category Balance**: Report on distribution (not enforced, informational only)

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

Before any other validation, ensure all agent files have parseable YAML:

```yaml
yaml_validation:
  - Parse YAML front matter for each agent file
  - Identify agents with parsing failures
  - Report specific line numbers and error types
  - Skip further validation for unparseable agents
  - Generate fix commands for common YAML issues
```

### Phase 1: Parallel Category Audits

Execute validation for each category simultaneously (only for agents that passed YAML validation):

```yaml
parallel_execution:
  - category: development
    validations: [template, tools, description, markdownParsing, tier, modelAppropriateness]
  - category: infrastructure
    validations: [template, tools, description, markdownParsing, tier, modelAppropriateness]
  - category: quality
    validations: [template, tools, description, markdownParsing, tier, modelAppropriateness]
  - category: security
    validations: [template, tools, description, markdownParsing, tier, modelAppropriateness]
  - category: analysis
    validations: [template, tools, description, markdownParsing, tier, modelAppropriateness]
  - category: architecture
    validations: [template, tools, description, markdownParsing, tier, modelAppropriateness]
  - category: design
    validations: [template, tools, description, markdownParsing, tier, modelAppropriateness]
  - category: operations
    validations: [template, tools, description, markdownParsing, tier, modelAppropriateness]
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

## Execution Verification

After audit completion, **execution-evaluator** is deployed to verify:

- All agent files were scanned successfully
- YAML front matter parsing attempted for all agents
- Unparseable YAML agents were identified and reported
- Valid agents proceeded through full validation
- Category assignments were checked
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
| agent-name | ✅ | ✅ | ✅ | None |

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
```

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
```

## Success Criteria

✅ **YAML Parseability**: 100% of agent files have valid, parseable YAML front matter
✅ **Category Compliance**: ≤ 8 categories with proper color mapping
✅ **Template Adherence**: 100% AGENT_TEMPLATE.md compliance
✅ **Tool Validation**: No Task tool access, appropriate permissions
✅ **Anti-Pattern Free**: No orchestration or self-reference
✅ **Description Quality**: Clear "MUST BE USED" and "use PROACTIVELY" triggers
✅ **Markdown Parsing Standards**: Consistent code fencing, language tags, and example quality
✅ **Tier 1 Only**: All agents at tier 1 level
✅ **Model Appropriateness**: Each agent uses optimal model for its complexity
✅ **Documentation Sync**: All docs reflect current state

## Implementation Notes

- Claude executes all validations directly (no agent-auditor needed)
- Parallel execution by category for efficiency
- Auto-fix safe issues, provide commands for complex ones
- Focus on maintaining established categories (avoid frequent refactoring)
- Generate actionable report suitable for immediate implementation
