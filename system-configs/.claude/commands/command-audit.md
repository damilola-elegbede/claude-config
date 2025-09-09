---
description: Command validation and Template Compliance analysis
---

# /command-audit Command

## Usage

```bash
# Comprehensive wave-based command audit
/command-audit

# Run specific validation waves
/command-audit --wave1    # Basic validation only
/command-audit --wave2    # Enhancement analysis only
/command-audit --wave3    # Report generation only

# Apply discovered optimizations
/command-audit --apply-fixes
```

## Description

Orchestrates comprehensive command optimization through systematic wave-based analysis. Validates all commands against
COMMAND_TEMPLATE.md standards, ensuring frontmatter structure compliance, YAML syntax validation, and Agent
Specification accuracy. Deploys specialized agent teams in parallel waves for validation, enhancement analysis, and
optimization recommendations.

## Command Validation Process

### Template Compliance Validation

All commands undergo rigorous Template Compliance analysis against COMMAND_TEMPLATE.md:

**Frontmatter Structure Validation:**

- **YAML frontmatter** delimiter validation (opening/closing `---`)
- **Required description field** presence and format compliance
- **YAML syntax** validation using built-in parsers
- **Description length** must not exceed 60 char limit for autocomplete compatibility
- **Argument-hint format** validation using `[bracket]` notation when present

**Frontmatter Valid Categories:**

- ✅ **Template Compliance**: Matches COMMAND_TEMPLATE.md structure
- ✅ **Frontmatter Valid**: Valid YAML syntax with proper delimiter usage
- ✅ **Content Quality**: Comprehensive documentation, Markdown Quality, and examples: Comprehensive documentation and examples
- ✅ **Agent Specification**: Valid agent references and coordination patterns

### Validation Process Architecture

**Process Validation Framework:**

1. **Syntax YAML Validation**: Parse and validate YAML frontmatter structure
2. **Template Structure**: Compare against COMMAND_TEMPLATE.md requirements
3. **Agent Specification**: Verify referenced agents exist in the 28-agent ecosystem
4. **Autocomplete Compatibility**: Ensure description field supports CLI autocomplete (60 character limit)

## Wave-Based Orchestration Architecture

### Wave 1: Basic Validation (Parallel Foundation)

Deploy multiple specialist agents simultaneously for foundational Template Compliance analysis:

**Parallel Agent Deployment:**

- **code-reviewer**: YAML syntax validation, frontmatter structure compliance, COMMAND_TEMPLATE.md adherence
- **security-auditor**: Security pattern analysis, Agent Specification validation, sensitive operation detection
- **test-engineer**: Testability assessment, validation strategy evaluation, frontmatter YAML compliance

**Validation Process Execution:**

```bash
# Deploy code-reviewer instances for comprehensive Template Compliance validation
TASK: code-reviewer-template "Validate against COMMAND_TEMPLATE.md structure and frontmatter requirements"
TASK: code-reviewer-yaml "Verify YAML frontmatter syntax, delimiter placement, required description field"
TASK: code-reviewer-autocomplete "Check description field 60 char limit for autocomplete compatibility"
TASK: code-reviewer-argument-hint "Validate argument-hint format using [bracket] notation when present"
```

**Claude Analysis Phase - Frontmatter Valid Categorization:**

- **Critical**: Missing YAML frontmatter delimiter, broken syntax YAML, missing required description field
- **High**: Template Compliance violations, invalid Agent Specification, poor frontmatter structure
- **Medium**: Description exceeds 60 character autocomplete limit, missing argument-hint format
- **Low**: Minor YAML formatting, optional Content Quality improvements

### Wave 2: Command Enhancement Analysis (Strategic Optimization)

Deploy enhancement specialists based on Wave 1 Template Compliance categorization:

**Parallel Agent Deployment:**

- **performance-engineer**: Optimization opportunities, parallel execution patterns, Agent Specification improvements
- **tech-writer**: Documentation quality, clarity improvements, Content Quality enhancement, Markdown Quality improvement, COMMAND_TEMPLATE.md compliance
- **project-orchestrator**: Workflow optimization, agent coordination patterns, Process Validation improvements

**Enhancement Priority Calculation:**

- **Template Compliance Score** (1-10): COMMAND_TEMPLATE.md adherence, frontmatter structure quality
- **Frontmatter Valid Score** (1-10): YAML syntax correctness, delimiter usage, required field presence
- **Agent Specification Score** (1-10): Valid agent references, coordination pattern quality
- **Content Quality Score** (1-10): Documentation completeness, example quality, autocomplete compatibility

### Wave 3: Report Generation & Implementation (Comprehensive Output)

Generate actionable Template Compliance optimization roadmap with Process Validation results:

**Deliverables:**

- **Template Compliance Audit**: Multi-dimensional analysis against COMMAND_TEMPLATE.md standards
- **Frontmatter Valid Report**: YAML syntax validation, delimiter compliance, required description field analysis
- **Agent Specification Analysis**: Verification of all agent references against 28-agent ecosystem
- **Content Quality Assessment**: Documentation completeness, autocomplete compatibility, argument-hint format validation

## Expected Output

### Executive Dashboard - Template Compliance Status

```text
COMMAND VALIDATION AUDIT - Template Compliance Analysis Complete
────────────────────────────────────────────────────────────────

Commands Analyzed: [total] | Template Compliance: [score] | Frontmatter Valid: [count]
YAML Syntax Score: [rating] | Agent Specification: [rating] | Content Quality: [rating]
Autocomplete Compatible: [count] | Argument-hint Format: [count] | Process Validation: Complete
```

### Wave Analysis Results

#### Wave 1: Template Compliance Foundation Results

**Critical Issues Detected:**

- COMMAND_TEMPLATE.md compliance violations
- Missing YAML frontmatter delimiter or invalid syntax YAML
- Absent required description field or exceeds 60 char autocomplete limit
- Invalid Agent Specification references
- Broken frontmatter structure with delimiter problems

**Frontmatter Valid Classification:**

| Command | Template Compliance | Frontmatter Valid | YAML Syntax | Agent Specification | Content Quality | Autocomplete |
|---------|---------------------|-------------------|-------------|---------------------|------------------|--------------|
| /commit | ✅ Compliant | ✅ Valid | ✅ Valid | ✅ Valid | ✅ High | ✅ 45 char |
| /push | ⚠️ Minor Issues | ✅ Valid | ✅ Valid | ✅ Valid | ✅ High | ✅ 38 char |
| /pr | ❌ Non-compliant | ❌ Invalid | ❌ Syntax Error | ❌ Invalid | ⚠️ Medium | ❌ 78 char |

#### Wave 2: Process Validation Enhancement Results

**Template Compliance Optimization Opportunities:**

- COMMAND_TEMPLATE.md structure alignment for non-compliant commands
- Frontmatter structure standardization across command ecosystem
- YAML syntax correction and delimiter normalization
- Agent Specification updates for deprecated or invalid references
- Description field optimization for 60 character autocomplete compatibility
- Argument-hint format standardization using [bracket] notation

**Content Quality Enhancement Matrix:**

| Command | Template Gap | Frontmatter Issues | Agent Refs | Autocomplete Fix | Priority |
|---------|--------------|-------------------|------------|------------------|----------|
| /commit | Minor format | None | Valid | Compliant | Low |
| /push | Structure alignment | Delimiter spacing | Valid | Compliant | Medium |
| /pr | Full rewrite needed | Invalid YAML syntax | 3 broken refs | 18 char over limit | Critical |

#### Wave 3: Implementation Roadmap - Template Compliance

**Immediate Actions (Auto-Fix Available):**

```bash
# High-confidence Template Compliance improvements
./scripts/auto-fix-commands.sh --template-compliance --frontmatter-yaml --delimiter-fix
./scripts/validate-agent-refs.sh --fix-invalid-specifications
```

**Manual Template Compliance Tasks:**

1. **Critical Template Compliance** (Immediate - breaks COMMAND_TEMPLATE.md standards)
   - Fix invalid YAML frontmatter delimiter placement
   - Add missing required description field
   - Correct syntax YAML errors preventing parsing
   - Update invalid Agent Specification references

2. **Frontmatter Valid Improvements** (High Priority - structure standardization)
   - Standardize frontmatter structure across all commands
   - Normalize YAML syntax formatting and delimiter usage
   - Ensure all commands have valid required description field

3. **Content Quality Enhancements** (Medium Priority - user experience)
   - Optimize description fields for 60 char autocomplete compatibility
   - Standardize argument-hint format using [bracket] notation
   - Enhance documentation completeness and example quality

4. **Agent Specification Updates** (Strategic - ecosystem alignment)
   - Validate all agent references against current 28-agent ecosystem
   - Update deprecated agent coordination patterns
   - Enhance Process Validation for agent deployment strategies

## Behavior

### Wave 1: Template Compliance Validation Execution

**Parallel Agent Coordination for COMMAND_TEMPLATE.md Validation:**

```bash
# Deploy code-reviewer instances for comprehensive Template Compliance validation
TASK: code-reviewer-template "Validate all commands against COMMAND_TEMPLATE.md structure requirements"
TASK: code-reviewer-frontmatter "Verify YAML frontmatter syntax, delimiter placement, required description field presence"
TASK: code-reviewer-yaml-syntax "Parse and validate YAML syntax in all command frontmatter sections"
TASK: code-reviewer-autocomplete "Ensure description fields meet 60 character autocomplete compatibility limit"
TASK: code-reviewer-argument-hint "Validate argument-hint format compliance using [bracket] notation standards"

# Deploy security-auditor for Agent Specification validation
TASK: security-auditor-agent-refs "Validate all Agent Specification references against 28-agent ecosystem"
TASK: security-auditor-template-security "Analyze COMMAND_TEMPLATE.md compliance for security pattern adherence"

# Deploy test-engineer for Process Validation assessment
TASK: test-engineer-frontmatter-tests "Assess frontmatter YAML validation testability and Process Validation strategies"
TASK: test-engineer-template-compliance "Evaluate Template Compliance testing coverage and validation framework"
```

**Template Compliance Issue Categorization Logic:**

- **Critical**: Missing YAML frontmatter delimiter, invalid syntax YAML, absent required description field, COMMAND_TEMPLATE.md structure violations
- **High**: Invalid Agent Specification references, frontmatter structure non-compliance, delimiter formatting issues
- **Medium**: Description exceeds 60 character autocomplete limit, missing argument-hint format, Content Quality gaps
- **Low**: Minor YAML formatting preferences, optional Template Compliance improvements

### Wave 2: Process Validation Enhancement Execution

**Strategic Agent Deployment for Template Compliance Enhancement:**

```bash
# Deploy performance-engineer for Template Compliance optimization analysis
TASK: performance-engineer-template-perf "Identify Template Compliance performance optimization opportunities"
TASK: performance-engineer-frontmatter-efficiency "Analyze frontmatter YAML processing efficiency and delimiter parsing"

# Deploy tech-writer for Content Quality and COMMAND_TEMPLATE.md alignment
TASK: tech-writer-template-docs "Enhance documentation alignment with COMMAND_TEMPLATE.md standards"
TASK: tech-writer-frontmatter-clarity "Improve frontmatter structure documentation and required description field examples"
TASK: tech-writer-autocomplete-optimization "Optimize description fields for 60 character autocomplete compatibility"

# Deploy project-orchestrator for Agent Specification and Process Validation workflow optimization
TASK: project-orchestrator-agent-coordination "Optimize Agent Specification patterns for better coordination"
TASK: project-orchestrator-validation-workflows "Enhance Process Validation workflows for Template Compliance checking"
```

**Template Compliance Priority Calculation:**

- **Template Compliance Score** (1-10): COMMAND_TEMPLATE.md adherence × structure quality × frontmatter completeness
- **Frontmatter Valid Score** (1-10): YAML syntax correctness × delimiter usage × required description field presence
- **Agent Specification Score** (1-10): Valid references × coordination patterns × 28-agent ecosystem alignment
- **Process Validation Score** (1-10): Validation workflow completeness × testing coverage × automation quality

### Wave 3: Template Compliance Report Generation & Recommendations

**Comprehensive Template Compliance Analysis Integration:**

```bash
# Consolidate Template Compliance findings from all validation waves
CONSOLIDATION: Merge COMMAND_TEMPLATE.md validation, frontmatter YAML analysis, Agent Specification verification
REPORTING: Generate Template Compliance Executive Summary, Status Matrix for Frontmatter Valid analysis, Process Validation roadmap
RECOMMENDATIONS: Create actionable YAML syntax fixes, delimiter corrections, autocomplete optimization scripts
```

**Template Compliance Implementation Strategy:**

1. **Auto-Fix Deployment**: Safe, high-confidence Template Compliance improvements (YAML syntax, delimiter fixing)
2. **Manual Enhancement Guide**: Step-by-step frontmatter structure optimization, Agent Specification updates
3. **Strategic Roadmap**: Long-term Content Quality evolution and Process Validation framework enhancement

### Success Criteria Verification - Template Compliance Focus

Deploy execution-evaluator to verify comprehensive Template Compliance optimization:

- ✅ **Wave 1 Complete** - All Template Compliance validation agents deployed, COMMAND_TEMPLATE.md adherence assessed
- ✅ **Wave 2 Complete** - Process Validation enhancement analysis finished, frontmatter priorities established
- ✅ **Wave 3 Complete** - Template Compliance report generated with actionable YAML syntax recommendations
- ✅ **Frontmatter Valid** - All commands have proper YAML frontmatter delimiter usage and required description field
- ✅ **COMMAND_TEMPLATE.md Compliance** - Full structure alignment with template standards documented
- ✅ **Agent Specification Validated** - All agent references verified against 28-agent ecosystem
- ✅ **Autocomplete Compatible** - Description fields optimized for 60 character CLI autocomplete limit
- ✅ **Content Quality Enhanced** - Documentation completeness and argument-hint format standardized
- ✅ **Process Validation Optimized** - YAML syntax validation and delimiter checking workflows implemented
- ✅ **Syntax YAML Corrected** - All YAML parsing errors resolved with proper frontmatter structure

## Advanced Template Compliance Features

### Dynamic Agent Specification Validation

Based on current 28-agent ecosystem and COMMAND_TEMPLATE.md requirements:

- **Small command sets (<10 commands)**: 3-5 Template Compliance agents per wave
- **Medium command sets (10-25 commands)**: 5-10 frontmatter validation agents per wave
- **Large command sets (25+ commands)**: 10-20 YAML syntax validation agents per wave

### Intelligent Template Compliance Correlation

Cross-reference Template Compliance issues across commands to identify:

- **Systematic COMMAND_TEMPLATE.md Violations**: Structure problems across multiple commands
- **Frontmatter Patterns**: Consistent YAML syntax issues requiring global fixes
- **Agent Specification Gaps**: Common invalid references needing ecosystem updates

### Progressive Template Compliance Enhancement

Each wave builds on previous Template Compliance findings:

- **Wave 1 → Wave 2**: COMMAND_TEMPLATE.md violation categorization drives frontmatter enhancement focus
- **Wave 2 → Wave 3**: Agent Specification priority analysis determines Process Validation implementation order
- **Iterative Template Compliance**: Continuous optimization based on YAML syntax validation patterns

This comprehensive wave-based orchestration transforms simple command validation into strategic Template Compliance
ecosystem optimization, ensuring maximum COMMAND_TEMPLATE.md adherence, frontmatter YAML validity, Agent Specification
accuracy, and autocomplete compatibility enhancement.
