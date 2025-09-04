---
description: Audit all commands for template compliance and quality standards
---

# Command Audit and Validation

Systematically validate all command files against the COMMAND_TEMPLATE.md format and quality standards. Check frontmatter compliance, structure, content quality, agent specifications, and markdown formatting. Generate comprehensive audit report with actionable remediation guidance.

## Context

Commands must follow the standardized template in `docs/commands/COMMAND_TEMPLATE.md` with proper frontmatter containing required `description` field and optional `argument-hint` field. All commands should specify appropriate specialized agents, leverage parallel execution where applicable, and maintain high-quality markdown formatting.

## Expected Output

Comprehensive audit report showing:

### Executive Summary
```text
Commands: [total] | Template Compliant: [%] | Issues: [count] | Auto-fixed: [count]
```

### Validation Framework

#### Core Template Validation (Required)
1. **Frontmatter Structure**: Required YAML frontmatter with `description` field
2. **Optional Fields**: Proper `argument-hint` formatting when present
3. **Content Structure**: Clear command purpose, context, and expected output
4. **Markdown Quality**: Code blocks with language tags, proper formatting
5. **Length Management**: Commands under 400 lines with justified complexity
6. **Agent References**: Valid references to the 28 production agents
7. **Parallel Execution**: Commands leverage parallel execution where applicable

#### Template Compliance Check
```bash
# Validate frontmatter structure for all commands
for cmd in system-configs/.claude/commands/*.md; do
  # Check: YAML frontmatter exists with --- delimiters
  # Verify: Required 'description' field present
  # Validate: Optional 'argument-hint' field format if present
  # Ensure: Description under 60 characters for autocomplete
done
```

#### Agent Specification Validation (28 Production Agents)
```bash
VALID_AGENTS=("backend-engineer" "frontend-engineer" "fullstack-lead" "mobile-engineer"
              "data-engineer" "ml-engineer" "test-engineer" "code-reviewer"
              "debugger" "security-auditor" "performance-engineer" "principal-architect"
              "api-architect" "frontend-architect" "ui-designer" "mobile-ui"
              "ux-researcher" "codebase-analyst" "researcher" "business-analyst"
              "product-strategist" "devops" "platform-engineer" "cloud-architect"
              "database-admin" "tech-writer" "project-orchestrator" "accessibility-auditor")

# Validate agent usage patterns
for cmd in system-configs/.claude/commands/*.md; do
  # Check: Agent names match 28 production agents
  # Verify: Security-critical operations include security-auditor
  # Ensure: Complex tasks specify multiple specialists
  # Validate: No references to deprecated agents
done
```

#### Frontmatter Validation Process
```bash
# Check for proper YAML frontmatter structure
grep -l "^---$" system-configs/.claude/commands/*.md | while read file; do
  # Verify frontmatter contains required 'description' field
  if ! grep -q "^description:" "$file"; then
    echo "Missing required 'description' field: $file"
  fi

  # Check description length for autocomplete compatibility
  desc_length=$(grep "^description:" "$file" | cut -d':' -f2- | tr -d ' ' | wc -c)
  if [ "$desc_length" -gt 60 ]; then
    echo "Description too long (>60 chars): $file"
  fi

  # Validate argument-hint format if present
  if grep -q "^argument-hint:" "$file"; then
    if ! grep -q "argument-hint:.*\[.*\]" "$file"; then
      echo "Invalid argument-hint format (should use [brackets]): $file"
    fi
  fi
done
```

### Command Status Matrix

| Command | Template | Frontmatter | Description | Agent Refs | Parallel | Markdown | Status |
|---------|----------|-------------|-------------|------------|----------|----------|--------|
| [Each command evaluated against all criteria] | ✅/❌ | ✅/❌ | ✅/❌ | ✅/❌ | ✅/❌ | ✅/❌ | Status |

### Issues by Category

#### Template Compliance Issues
- Missing YAML frontmatter
- Missing required 'description' field
- Invalid argument-hint format
- Description exceeds 60 character limit

#### Content Quality Issues
- Unclear command purpose
- Missing context or guidelines
- Vague expected output descriptions

#### Agent Specification Issues
- Missing agent specifications for complex tasks
- Invalid agent references (not in 28 production agents)
- Missing security-auditor for sensitive operations
- Inappropriate agent selection

#### Parallelization Issues
- Sequential execution where parallel possible
- Missing parallel phase definitions
- No concurrent agent deployment specified

#### Markdown Quality Issues
- Code blocks without language tags
- Inconsistent formatting
- Poor structure organization

### Auto-Fix Capabilities

#### Safe Automatic Fixes Applied
```bash
# Add missing language tags to common patterns
sed -i 's/```$/```bash/g' commands/*.md  # For shell commands
sed -i 's/```\n#/```bash\n#/g' commands/*.md  # For commented bash

# Standardize frontmatter structure
# Add missing frontmatter delimiters where needed
# Format existing descriptions for consistency
```

### Manual Actions Required

Priority fixes requiring human review:
- Add missing frontmatter to non-compliant commands
- Enhance content clarity and specificity
- Add appropriate agent specifications
- Implement parallel execution patterns
- Reduce oversized commands to under 400 lines

### Repository-Specific Exclusions

Commands excluded from sync process (validated for proper exclusion):
- `command-audit.md` (this audit tool)
- `sync.md` (sync operation itself)
- Any repository-management specific commands

### Success Criteria Verification

Deploy execution-evaluator to verify:
- ✅ **Template Compliance** - All commands follow COMMAND_TEMPLATE.md format
- ✅ **Frontmatter Valid** - Required description field present, proper YAML syntax
- ✅ **Content Quality** - Clear purpose, context, and expected output
- ✅ **Agent Specifications** - Appropriate agents specified for complex operations
- ✅ **Parallel Execution** - Commands leverage parallelization where applicable
- ✅ **Markdown Quality** - Proper formatting and language tags
- ✅ **Length Management** - Commands under 400 lines or complexity justified
- ✅ **Issues Identified** - All compliance gaps documented with remediation steps
- ✅ **Auto-Fixes Applied** - Safe formatting improvements implemented
- ✅ **Manual Actions** - Human-review items clearly specified

### Validation Categories

#### Git Workflow Commands
Required agents: tech-writer (messages), code-reviewer (validation), security-auditor (safety)
Parallelization: Concurrent validation checks before operations

#### Repository Analysis Commands
Required agents: codebase-analyst, test-engineer, debugger
Parallelization: Multiple domain analysts, parallel test execution

#### System Management Commands
Required agents: platform-engineer (setup), devops (CI/CD), security-auditor (vulnerabilities)
Parallelization: Concurrent file validation, simultaneous package scanning

#### Quality Assurance Commands
Required agents: code-reviewer, security-auditor, performance-engineer
Parallelization: Multiple reviewer agents simultaneously

#### Development Support Commands
Required agents: product-strategist (planning), tech-writer (docs), project-orchestrator (coordination)
Parallelization: Concurrent phase execution, multiple agents per workflow

### Example Usage

```bash
# Full audit of all commands
/command-audit

# Validate specific aspects
/command-audit --frontmatter  # Focus on YAML frontmatter compliance
/command-audit --fix          # Apply safe automatic fixes
```

This comprehensive audit ensures all commands maintain consistent quality, follow the standardized template format, and provide clear value to users through proper agent coordination and parallel execution patterns.