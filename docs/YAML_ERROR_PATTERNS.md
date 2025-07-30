# YAML Front-Matter Error Patterns Documentation

## Overview
Analysis of the .claude/agents/ directory reveals that while all agent files have proper YAML delimiter structure, there are several patterns that could cause parsing issues or maintenance problems.

## Error Pattern Categories

### 1. Multiline String Handling
**Pattern**: Using pipe (`|`) for multiline descriptions
**Files Affected**: debugger.md, devops.md, mobile-ui.md, product-strategist.md, security-auditor.md
**Issue**: While valid YAML, multiline strings can cause:
- Indentation sensitivity issues
- Parser compatibility problems
- Difficulty in maintaining consistent formatting
- Potential quote escaping issues within the multiline content

**Example**:
```yaml
description: |
  Very long description spanning
  multiple lines with examples...
```

### 2. Embedded Complex Content in Descriptions
**Pattern**: Including full examples with XML-like tags within description fields
**Files Affected**: Most agent files
**Issue**: 
- Makes YAML harder to parse and validate
- Mixing markup within YAML strings
- Potential for malformed XML-like content
- Difficult to maintain and update

**Example**:
```yaml
description: Use this agent... <example>Context: User needs...</example>
```

### 3. Inconsistent Field Structure
**Pattern**: Different agents have different optional fields
**Issue**: 
- No standardized schema across agent files
- Some have coordination_protocols, others don't
- Varying field names and structures

### 4. Very Long Single-Line Descriptions
**Pattern**: Extremely long description values on a single line
**Files Affected**: api-engineer.md, backend-engineer.md, frontend-engineer.md, others
**Issue**:
- Hard to read and maintain
- Potential line length issues in some editors
- Difficult to review changes in version control

## Best Practices for YAML Front-Matter

### 1. Use Structured Fields
Instead of embedding everything in description:
```yaml
---
name: agent-name
description: Brief, clear description of the agent's purpose
examples:
  - context: User needs X
    request: How to do Y
    response: Using agent for Z
coordination:
  with_agent_a: Description of coordination
  with_agent_b: Description of coordination
---
```

### 2. Keep Descriptions Concise
- Primary description should be 1-2 sentences
- Move detailed information to dedicated fields
- Use clear, simple language

### 3. Standardize Schema
All agent files should follow the same structure:
- Required fields: name, description, color, specialization_level
- Optional fields: coordination_protocols, domain_expertise, tools, etc.
- Consistent field naming conventions

### 4. Avoid Complex Nesting
- Limit nesting to 2-3 levels maximum
- Use flat structures where possible
- Keep arrays simple

## Validation Requirements

1. **Schema Validation**: Implement JSON Schema for YAML validation
2. **Length Limits**: Set reasonable limits for string fields
3. **Required Fields**: Enforce presence of core fields
4. **Format Validation**: Ensure consistent formatting across files
5. **Content Validation**: Check for valid agent names, colors, etc.

## Migration Strategy

1. **Phase 1**: Create standardized template
2. **Phase 2**: Convert existing files to new format
3. **Phase 3**: Implement validation tooling
4. **Phase 4**: Add pre-commit hooks and CI/CD checks

This documentation will guide the Phase 2 implementation of fixes.