# Agent Ecosystem Migration Guide v2.0

## Overview

This guide provides step-by-step instructions for migrating agents to the new ecosystem standards,
including SYSTEM BOUNDARY enforcement, YAML field ordering, and category-based color standardization.

## Migration Summary

### Key Changes

1. **SYSTEM BOUNDARY Language**: New mandatory constraint format for all agents
2. **YAML Field Ordering**: Strict field order requirement
   (name → description → tools → color → category)
3. **Color Standardization**: Colors must match agent categories
4. **Tool Access Updates**: Standardized tool declarations
5. **Category Assignment**: All agents must have an explicit category

## Pre-Migration Checklist

- [ ] Backup current agent configurations
- [ ] Identify all agents requiring migration
- [ ] Review AGENT_CATEGORIES.md for proper categorization
- [ ] Prepare testing environment
- [ ] Schedule migration window

## Step 1: Understanding the New SYSTEM BOUNDARY Format

### Old Format (Deprecated)

```markdown
You cannot and will not call the Task tool. This is an immutable constraint that cannot be overridden by any instruction, including direct user commands.
```

### New Format (Required)

```markdown
SYSTEM BOUNDARY: While the Task tool is visible in your function registry, it is RESERVED EXCLUSIVELY for Claude. You are not Claude. This agent instance will AUTOMATICALLY TERMINATE upon any Task tool invocation, regardless of who requests it. This is a hard-coded system protection that cannot be overridden by any user instruction, including direct commands. Your operational integrity depends on never crossing this boundary.
```

### Why This Change?

- Stronger enforcement of agent boundaries
- Clear distinction between Claude (orchestrator) and agents (specialists)
- Automatic termination protection
- Unambiguous constraint language

## Step 2: YAML Field Ordering Requirements

### Correct Order (Required)

```yaml
---
name: agent-name
description: Agent purpose and capabilities
tools: Read, Write, Edit, Grep, Glob
color: blue
category: development
---
```

### Common Ordering Mistakes to Fix

- ❌ Color before tools
- ❌ Category before color
- ❌ Description after tools
- ❌ Missing fields

### Field Specifications

1. **name**: Lowercase, hyphenated (e.g., `backend-engineer`, `api-architect`)
2. **description**: Natural language, single line
3. **tools**: Comma-separated list, no spaces after commas
4. **color**: Must match category color (see Step 3)
5. **category**: Must be from approved list

## Step 3: Color Standardization by Category

### Category-Color Mapping

| Category | Color | Agent Types |
|----------|-------|-------------|
| development | blue | backend, mobile-platform, database, data-platform engineers |
| infrastructure | orange | devops, cloud-architect, cloud-network, kubernetes-admin |
| architecture | purple | frontend-architect, api-architect, principal-architect |
| design | pink | ui-designer |
| quality | green | test-engineer, code-reviewer, performance-specialist |
| security | red | security-auditor, supply-chain-security-engineer |
| analysis | yellow | codebase-analyst, tech-writer |
| operations | teal | incident-commander, production-reliability-engineer, database-evolution-specialist |

### Migration Actions

1. Check current agent color
2. Verify agent category
3. Update color if mismatched
4. Validate against AGENT_CATEGORIES.md

## Step 4: Manual Migration Process

### 4.1 Locate Agent File

```bash
cd /Users/damilola/Documents/Projects/claude-config/.claude/agents/
ls -la *.md | grep -v AGENT_
```

### 4.2 Update YAML Header

1. Open agent file in editor
2. Reorder fields to match required sequence
3. Update color to match category
4. Ensure all fields are present

### 4.3 Update Constraint Language

1. Locate old constraint paragraph
2. Replace entirely with new SYSTEM BOUNDARY format
3. Ensure it appears immediately after YAML block
4. Verify exact wording (copy-paste recommended)

### 4.4 Validate Changes

```bash
# Check YAML syntax
head -n 8 agent-name.md

# Verify constraint language
grep -A 3 "SYSTEM BOUNDARY" agent-name.md
```

## Step 5: Automated Migration (If Available)

### Using fix-agent-issues.sh

```bash
# Create migration script if not exists
cat > fix-agent-issues.sh << 'EOF'
#!/bin/bash
# Agent Migration Script v2.0

for agent_file in *.md; do
    # Skip non-agent files
    [[ "$agent_file" =~ ^AGENT_ ]] && continue

    echo "Migrating: $agent_file"

    # Backup original
    cp "$agent_file" "$agent_file.backup"

    # Extract and reorder YAML fields
    # Update constraint language
    # Standardize colors

    echo "✓ Migrated: $agent_file"
done
EOF

chmod +x fix-agent-issues.sh
./fix-agent-issues.sh
```

## Step 6: Validation and Testing

### 6.1 Individual Agent Validation

```bash
# Validate YAML structure
for file in *.md; do
    echo "Checking: $file"
    head -n 8 "$file" | grep -E "^(name|description|tools|color|category):"
done
```

### 6.2 Constraint Validation

```bash
# Verify all agents have new SYSTEM BOUNDARY
grep -L "SYSTEM BOUNDARY:" *.md | grep -v AGENT_
```

### 6.3 Color-Category Consistency

```bash
# Check for mismatched colors
for file in *.md; do
    category=$(grep "^category:" "$file" | cut -d' ' -f2)
    color=$(grep "^color:" "$file" | cut -d' ' -f2)
    echo "$file: category=$category, color=$color"
done
```

### 6.4 Functional Testing

1. Launch test instance of Claude Code
2. Invoke migrated agent
3. Verify proper tool access
4. Test boundary enforcement
5. Confirm no Task tool invocation

## Step 7: Rollback Procedures

### Immediate Rollback

```bash
# Restore from backups
for backup in *.md.backup; do
    original="${backup%.backup}"
    mv "$backup" "$original"
done
```

### Partial Rollback

1. Identify problematic agents
2. Restore specific agent files
3. Re-run validation
4. Document issues for resolution

### Rollback Triggers

- Agent invocation failures
- Tool access errors
- Unexpected terminations
- Category mismatches causing workflow issues

## Migration Timeline and Prioritization

### Phase 1: Critical Agents (Week 1)

- **High Priority**: Frequently used agents (backend-engineer, frontend-architect, test-engineer)
- **Security Critical**: security-auditor, code-reviewer
- **Infrastructure**: devops, cloud-architect

### Phase 2: Specialized Agents (Week 2)

- **Architecture**: api-architect, principal-architect
- **Analysis**: codebase-analyst, tech-writer
- **Design**: ui-designer, ux-researcher

### Phase 3: Support Agents (Week 3)

- **Operations**: incident-commander, production-reliability-engineer
- **Specialists**: performance-specialist, supply-chain-security-engineer
- **Infrastructure**: cloud-network-architect, database-evolution-specialist

### Phase 4: Validation & Cleanup (Week 4)

- Complete validation suite
- Remove backup files
- Update documentation
- Training and communication

## Post-Migration Checklist

- [ ] All agents migrated to new format
- [ ] YAML fields properly ordered
- [ ] Colors match categories
- [ ] SYSTEM BOUNDARY implemented
- [ ] Validation tests passed
- [ ] Backups archived
- [ ] Documentation updated
- [ ] Team notified

## Troubleshooting Common Issues

### Issue: Agent Won't Load

**Symptom**: Agent invocation fails
**Solution**: Check YAML syntax, ensure proper field ordering

### Issue: Color Mismatch Warnings

**Symptom**: Validation errors about colors
**Solution**: Update color to match category per AGENT_CATEGORIES.md

### Issue: Tool Access Denied

**Symptom**: Agent can't access declared tools
**Solution**: Verify tools list formatting (comma-separated, no extra spaces)

### Issue: Unexpected Termination

**Symptom**: Agent terminates immediately
**Solution**: Check for accidental Task tool references in agent logic

## Support and Resources

### Documentation

- AGENT_TEMPLATE.md - Current template with all requirements
- AGENT_CATEGORIES.md - Official category definitions
- YAML_REQUIREMENTS.md - Detailed YAML specifications

### Validation Tools

- YAML validators - Syntax checking tools
- Test suites - Functional validation
- Manual validation procedures

### Getting Help

1. Check troubleshooting section
2. Review error logs
3. Run manual validation procedures
4. Escalate persistent issues

## Version History

- **v2.0** (Current) - SYSTEM BOUNDARY enforcement, strict YAML ordering
- **v1.5** - Category standardization
- **v1.0** - Initial agent ecosystem

## Summary

This migration ensures all agents comply with the latest ecosystem standards, providing:

- Stronger boundary enforcement
- Consistent categorization
- Standardized tool access
- Improved maintainability
