# /command-audit Command

## Description

Validates command structure, content quality, and markdown parsing compliance across all commands in system-configs/.claude/commands/. Generates comprehensive audit report with actionable remediation guidance.

## Usage

```bash
/command-audit
```

## Behavior

Systematically validates all command files using available tools (Grep, Read, LS) to check structure compliance, markdown formatting, and content quality. Provides detailed audit report similar to /agent-audit with specific issues and remediation commands.

## Validation Framework

### Core Validation (Required)

1. **Structure**: Required sections (Description, Usage, Behavior)
2. **Content**: Clear descriptions, practical examples
3. **Markdown**: Code blocks with language tags
4. **Length**: Commands under 400 lines

### Category Standards

```yaml
git_workflow:
  commands: [commit, branch, push, pr]
  requirements:
    - Must use execution-evaluator
    - Git safety features documented

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
```

## Execution Process

### Phase 1: Structure & Content Validation

```bash
# Check required sections exist and are properly ordered
for cmd in system-configs/.claude/commands/*.md; do
  # Validate: Description → Usage → Behavior sections
  # Check: Clear purpose statement in description
  # Verify: Usage examples with proper syntax
done
```

### Phase 2: Markdown Compliance Check

```bash
# Scan for code blocks without language tags
grep -n '```$' **/*.md

# Validate common language tags present
grep -c '```\(bash\|yaml\|text\|json\|javascript\|python\)' **/*.md
```

### Phase 3: Length & Complexity Analysis

```yaml
Thresholds:
  Standard: 150-250 lines (optimal)
  Complex: 250-400 lines (justified complexity)
  Over-limit: 400+ lines (requires refactoring)

Assessment:
  - Count total lines per command
  - Identify commands exceeding thresholds
  - Suggest refactoring opportunities
```

## Auto-Fix Capabilities (--fix)

### Safe Automatic Fixes

```bash
# Add missing language tags to common patterns
sed -i 's/```$/```bash/g' commands/*.md  # For shell commands
sed -i 's/```\n#/```bash\n#/g' commands/*.md  # For commented bash

# Standardize section headers
sed -i 's/^# Usage$/## Usage/g' commands/*.md
sed -i 's/^# Description$/## Description/g' commands/*.md
```

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
```

### Issues by Category

```yaml
Structure Issues: 3
  - Missing required sections
  - Incorrect section ordering

Content Issues: 2
  - Vague descriptions
  - Missing examples

Markdown Issues: 7
  - Code blocks without language tags
  - Inconsistent formatting

Length Issues: 4
  - Commands over 400 lines
  - Complexity not justified
```

### Command Status Matrix

| Command | Lines | Structure | Content | Markdown | Status |
|---------|-------|-----------|---------|----------|--------|
| plan | 230 | ✅ | ✅ | ✅ | ✅ Compliant |
| test | 384 | ✅ | ✅ | ❌ | ⚠️ Markdown issues |
| resolve-cr | 401 | ✅ | ✅ | ✅ | ⚠️ Over length |

### Auto-Remediation Applied

```bash
# Fixed missing language tags (12 commands):
- Added 'bash' tags to shell command blocks
- Added 'yaml' tags to configuration examples
- Added 'text' tags to output examples

# Standardized section headers (8 commands):
- Fixed ## Usage formatting
- Corrected ## Description positioning
```

### Manual Actions Required

```bash
# Length reduction needed:
# /resolve-cr: 401 → <400 lines (trim examples, consolidate sections)
# /prompt: 401 → <400 lines (reduce verbose documentation)

# Structure improvements:
# /debug: Add execution-evaluator verification section
# /deps: Clarify agent coordination patterns

# Content enhancements:
# /fix-ci: Add concrete implementation examples
# /context: Clarify lite vs full mode differences
```

## Repository-Specific Commands

Commands excluded from sync process:

- `command-audit.md` (this audit tool)
- `sync.md` (sync operation itself)
- `config-diff.md` (repository comparison)

Validation ensures these commands are properly excluded in sync.md.

## Success Criteria

✅ **Structure**: All commands have required sections in correct order
✅ **Content**: Clear descriptions with practical examples
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
```

### Auto-Fix Run

```bash
/command-audit --fix
# Applies safe automatic fixes for common issues
# Reports what was fixed and what needs manual attention
```

### Specific Command

```bash
/command-audit plan
# Focused audit of /plan command only
# Detailed analysis with specific recommendations
```

## Notes

- Repository-specific command (excluded from sync)
- Focuses on actionable feedback over comprehensive analysis
- Auto-fix capability for common formatting issues
- Length thresholds based on actual command analysis
- Integrates with execution-evaluator for verification
