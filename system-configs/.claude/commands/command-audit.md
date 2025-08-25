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
6. **Agent Specification**: Commands must specify appropriate specialized agents
7. **Parallelization**: Commands must leverage parallel execution where possible

### Category Standards

```yaml
git_workflow:
  commands: [commit, branch, push, pr]
  requirements:
    - Git safety features documented
    - Branch protection mechanisms
  required_agents:
    - tech-writer (commit messages, PR descriptions)
    - code-reviewer (change validation)
    - security-auditor (sensitive data checks)
  parallelization:
    - Parallel validation checks before operations

repository_analysis:
  commands: [context, test, debug]
  requirements:
    - Framework detection capabilities
    - Universal project compatibility
  required_agents:
    - codebase-analyst (repository analysis)
    - test-engineer (test generation/execution)
    - debugger (issue investigation)
  parallelization:
    - Multiple analysts for different domains
    - Parallel test suite execution

system_management:
  commands: [sync, deps, fix-ci]
  requirements:
    - Environment validation
    - Backup procedures
  required_agents:
    - platform-engineer (environment setup)
    - devops (CI/CD issues)
    - security-auditor (dependency vulnerabilities)
  parallelization:
    - Parallel file validation
    - Simultaneous package manager scanning

quality_assurance:
  commands: [review, agent-audit, command-audit]
  requirements:
    - Comprehensive validation
    - Detailed reporting
  required_agents:
    - code-reviewer (quality checks)
    - security-auditor (security validation)
    - performance-engineer (performance analysis)
  parallelization:
    - Parallel tool execution
    - Multiple reviewer agents simultaneously

development_support:
  commands: [plan, resolve-cr, prompt, implement, docs, ship-it]
  requirements:
    - Workflow integration
    - User guidance
  required_agents:
    - product-strategist (planning)
    - tech-writer (documentation)
    - project-orchestrator (workflow coordination)
  parallelization:
    - Parallel phase execution
    - Multiple agents per workflow phase
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

### Phase 2: Agent Specification Validation

```bash
# Check for appropriate agent specifications
grep -l "backend-engineer\|frontend-architect\|test-engineer\|security-auditor" \
  system-configs/.claude/commands/*.md

# Validate agent usage patterns
for cmd in system-configs/.claude/commands/*.md; do
  # Check: Agent names match category requirements
  # Verify: Security-critical operations include security-auditor
  # Ensure: Complex tasks specify multiple specialists
done

# Identify missing agent specifications
commands_without_agents=$(grep -L "agent.*:" system-configs/.claude/commands/*.md)
```bash

### Phase 3: Parallelization Validation

```bash
# Check for parallel execution patterns
grep -l "parallel\|Parallel\|simultaneous\|concurrent" \
  system-configs/.claude/commands/*.md

# Validate parallel phase definitions
grep -l "Phase.*Parallel\|Parallel Wave\|Parallel Execution" \
  system-configs/.claude/commands/*.md

# Check for sequential-only anti-patterns
grep -l "Sequential Phase\|sequential execution\|one at a time" \
  system-configs/.claude/commands/*.md | \
  xargs -I {} echo "Review {} for parallelization opportunities"
```bash

### Phase 4: Execution Verification Check

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

### Phase 5: Markdown Compliance Check

```bash
# Scan for code blocks without language tags
grep -n '```$' **/*.md

# Validate common language tags present
grep -c '```\(bash\|yaml\|text\|json\|javascript\|python\)' **/*.md
```bash

### Phase 6: Length & Complexity Analysis

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

Agent Specification Issues: 12
  - Missing agent specifications
  - Inappropriate agent selection
  - No security-auditor for sensitive operations

Parallelization Issues: 8
  - Sequential execution where parallel possible
  - Missing parallel phase definitions
  - No concurrent agent deployment

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

| Command | Lines | Structure | Content | Agents | Parallel | Execution | Markdown | Status |
|---------|-------|-----------|---------|--------|----------|-----------|----------|--------|
| plan | 230 | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ | ⚠️ Missing agents + parallelization |
| test | 384 | ✅ | ✅ | ❌ | ❌ | ✅ | ❌ | ⚠️ Missing agents + parallel execution |
| commit | 185 | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ | ⚠️ Missing agents + validation |
| branch | 201 | ✅ | ✅ | ❌ | ❌ | ✅ | ✅ | ⚠️ Missing agent assistance |
| implement | 350 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ Good parallel + agents |
| docs | 290 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ Good parallel structure |

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
# Priority optimizations:
# - Reduce oversized commands to <400 lines
# - Enhance content with concrete examples where needed
# - Verify all commands have proper execution validation
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
✅ **Agent Specification**: All commands specify appropriate specialized agents
✅ **Parallelization**: Commands leverage parallel execution where possible
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

## Success Criteria

✅ **Structure**: All commands have required sections in correct order
✅ **Content**: Clear descriptions with practical examples
✅ **Agent Specification**: All commands specify appropriate specialized agents
✅ **Parallelization**: Commands leverage parallel execution where possible
✅ **Execution Verification**: All commands include execution-evaluator deployment
✅ **Markdown**: 100% code blocks have language tags
✅ **Length**: Commands under 400 lines or complexity justified
✅ **Categories**: Commands meet category-specific standards
✅ **Repository-Specific**: Proper sync exclusions maintained

## Execution Verification

Deploy execution-evaluator to verify:

- ✅ **Commands scanned** - All command files analyzed for compliance
- ✅ **Structure validated** - Required sections present in correct order
- ✅ **Content assessed** - Clear descriptions and practical examples
- ✅ **Agent specifications checked** - Appropriate agents specified for each command
- ✅ **Parallelization validated** - Parallel execution patterns where applicable
- ✅ **Execution verification confirmed** - Execution-evaluator deployment present
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
