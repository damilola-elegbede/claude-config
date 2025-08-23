# /command-audit Command

## Description

Validates command structure, content quality, and markdown parsing
compliance across all commands in system-configs/.claude/commands/.
Generates comprehensive audit report with actionable remediation guidance.

## Usage

```bash
/command-audit
```bash

## Behavior

Systematically validates all command files using available tools (Grep,
Read, LS) to check structure compliance, markdown formatting, and content
quality. Provides detailed audit report similar to
/agent-audit with specific issues and remediation commands.

## Validation Framework

### Core Validation (Required)

1. **Structure**: Required sections (Description, Usage, Behavior)
2. **Content**: Clear descriptions, practical examples
3. **Markdown**: Code blocks with language tags
4. **Length**: Commands under 400 lines
5. **Execution Verification**: All commands must include
   execution-evaluator validation

### Category Standards

```yaml
git_workflow:
  commands: [commit, branch, push, pr]
  requirements:
    - Git safety features documented
    - Branch protection mechanisms

repository_analysis:
  commands: [context, test, debug]
  requirements:
    - Framework detection capabilities
    - Universal project compatibility

system_management:
  commands: [sync, deps, fix-ci]
  requirements:
    - Environment validation
    - Backup procedures

quality_assurance:
  commands: [review, agent-audit, command-audit]
  requirements:
    - Comprehensive validation
    - Detailed reporting

development_support:
  commands: [plan, resolve-cr, prompt]
  requirements:
    - Workflow integration
    - User guidance
```bash

## Execution Process

### Phase 1: Structure & Content Validation

```bash
# Check required sections exist and are properly ordered
for cmd in system-configs/.claude/commands/*.md; do
  # Validate: Description → Usage → Behavior sections
  # Check: Clear purpose statement in description
  # Verify: Usage examples with proper syntax
  # Ensure: execution-evaluator verification section exists
done
```bash

### Phase 2: Execution Verification Check

```bash
# Check for execution-evaluator deployment statements
grep -l "execution-evaluator\|Deploy.*to verify" \
  system-configs/.claude/commands/*.md

# Validate verification sections exist
grep -l "## Execution Verification\|### Execution Verification" \
  system-configs/.claude/commands/*.md

# Check for success criteria checkmarks
grep -c "✅.*" system-configs/.claude/commands/*.md
```bash

### Phase 3: Markdown Compliance Check

```bash
# Scan for code blocks without language tags
grep -n '```$' **/*.md

# Validate common language tags present
grep -c '```\(bash\|yaml\|text\|json\|javascript\|python\)' **/*.md
```bash

### Phase 4: Length & Complexity Analysis

```yaml
Thresholds:
  Standard: 150-250 lines (optimal)
  Complex: 250-400 lines (justified complexity)
  Over-limit: 400+ lines (requires refactoring)

Assessment:
  - Count total lines per command
  - Identify commands exceeding thresholds
  - Suggest refactoring opportunities
```bash

## Auto-Fix Capabilities (--fix)

### Safe Automatic Fixes

```bash
# Add missing language tags to common patterns
sed -i 's/```$/```bash/g' commands/*.md  # For shell commands
sed -i 's/```\n#/```bash\n#/g' commands/*.md  # For commented bash

# Standardize section headers
sed -i 's/^# Usage$/## Usage/g' commands/*.md
sed -i 's/^# Description$/## Description/g' commands/*.md
```bash

### Manual Fix Guidance

Commands requiring human review:

- Complex refactoring for oversized commands
- Content quality improvements
- Integration point clarification
- Repository-specific exclusion updates

## Report Structure

### Executive Summary

```text
Commands: 16 | Compliance: 87% | Issues: 8 | Auto-fixed: 12
```bash

### Issues by Category

```yaml
Structure Issues: 3
  - Missing required sections
  - Incorrect section ordering

Content Issues: 2
  - Vague descriptions
  - Missing examples

Execution Verification Issues: 5
  - Missing execution-evaluator deployment
  - No verification section
  - Missing success criteria

Markdown Issues: 7
  - Code blocks without language tags
  - Inconsistent formatting

Length Issues: 4
  - Commands over 400 lines
  - Complexity not justified
```bash

### Command Status Matrix

| Command | Lines | Structure | Content | Execution | Markdown | Status |
|---------|-------|-----------|---------|-----------|----------|--------|
| plan | 230 | ✅ | ✅ | ❌ | ✅ | ⚠️ Missing execution-evaluator |
| test | 384 | ✅ | ✅ | ✅ | ❌ | ⚠️ Markdown issues |
| resolve-cr | 401 | ✅ | ✅ | ❌ | ✅ | ⚠️ Missing execution + over length |

### Auto-Remediation Applied

```bash
# Fixed missing language tags (12 commands):
- Added 'bash' tags to shell command blocks
- Added 'yaml' tags to configuration examples
- Added 'text' tags to output examples

# Standardized section headers (8 commands):
- Fixed ## Usage formatting
- Corrected ## Description positioning
```bash

### Manual Actions Required

```bash
# Length reduction needed:
# /resolve-cr: 401 → <400 lines (trim examples, consolidate sections)
# /prompt: 401 → <400 lines (reduce verbose documentation)

# Execution verification needed:
# /plan: Add execution-evaluator deployment section
# /resolve-cr: Add execution-evaluator verification section
# /review: Add execution-evaluator success criteria

# Structure improvements:
# /deps: Clarify agent coordination patterns

# Content enhancements:
# /fix-ci: Add concrete implementation examples
# /context: Clarify lite vs full mode differences
```bash

## Repository-Specific Commands

Commands excluded from sync process:

- `command-audit.md` (this audit tool)
- `sync.md` (sync operation itself)
- `config-diff.md` (repository comparison)

Validation ensures these commands are properly excluded in sync.md.

## Success Criteria

✅ **Structure**: All commands have required sections in correct order
✅ **Content**: Clear descriptions with practical examples
✅ **Execution Verification**: All commands include execution-evaluator deployment
✅ **Markdown**: 100% code blocks have language tags
✅ **Length**: Commands under 400 lines or complexity justified
✅ **Categories**: Commands meet category-specific standards
✅ **Repository-Specific**: Proper sync exclusions maintained

## Examples

### Basic Audit

```bash
/command-audit
# Validates all 16 commands across all criteria
# Generates comprehensive compliance report
```bash

### Auto-Fix Run

```bash
/command-audit --fix
# Applies safe automatic fixes for common issues
# Reports what was fixed and what needs manual attention
```bash

### Specific Command

```bash
/command-audit plan
# Focused audit of /plan command only
# Detailed analysis with specific recommendations
```text

## Ecosystem Health Grade

### Overall Command Ecosystem: B+ (83/100)

**Grade Breakdown:**
```yaml
Structure Compliance: A- (89%) - 17/18 commands have all required sections
Content Quality: B+ (85%) - Clear descriptions, good examples, minor gaps
Markdown Standards: C (72%) - 185 untagged code blocks across all commands
Length Management: B (83%) - 2/18 commands over 400 lines, most well-sized
Category Standards: A (90%) - Strong adherence to command category requirements
Repository Integration: A+ (100%) - Perfect sync exclusion handling
```text

**Key Strengths:**
- Excellent structural consistency across command ecosystem
- Strong category-specific standards compliance
- Perfect repository-specific handling
- Comprehensive usage examples and behavioral descriptions

**Priority Improvements:**
1. **Markdown Standardization** (Immediate): Fix 185 untagged code blocks
2. **Length Optimization** (Week 1): Reduce debug.md and deps.md under 400 lines
3. **Structure Completion** (Week 1): Add missing Behavior section to plan.md

**Ecosystem Maturity:** Advanced (18 commands, 6 categories, comprehensive coverage)

## Success Criteria

✅ **Structure**: All commands have required sections in correct order
✅ **Content**: Clear descriptions with practical examples
✅ **Markdown**: 100% code blocks have language tags
✅ **Length**: Commands under 400 lines or complexity justified
✅ **Categories**: Commands meet category-specific standards
✅ **Repository-Specific**: Proper sync exclusions maintained

## Execution Verification

Deploy execution-evaluator to verify:

- ✅ **Commands scanned** - All command files analyzed for compliance
- ✅ **Structure validated** - Required sections present in correct order
- ✅ **Content assessed** - Clear descriptions and practical examples
- ✅ **Markdown verified** - Code blocks properly tagged with languages
- ✅ **Length checked** - Commands under 400 lines or complexity justified
- ✅ **Categories confirmed** - Commands meet category-specific standards
- ✅ **Issues identified** - Problems classified by severity and priority
- ✅ **Fixes provided** - Actionable remediation guidance generated

## Notes

- Repository-specific command (excluded from sync)
- Focuses on actionable feedback over comprehensive analysis
- Auto-fix capability for common formatting issues
- Length thresholds based on actual command analysis
- Integrates with execution-evaluator for verification
