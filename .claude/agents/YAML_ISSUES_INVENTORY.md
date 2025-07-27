# YAML Front-Matter Issues Inventory

## Summary
- **Total MD files**: 23
- **Files with YAML front-matter**: 17
- **Files without YAML front-matter**: 6 (guide/documentation files)
- **All agent files have proper delimiter structure**

## Files Without YAML Front-Matter (Non-agent documentation)
These are documentation files and don't require YAML front-matter:
1. AGENT_SELECTION_GUIDE.md
2. ENHANCEMENT_SUMMARY.md  
3. PARALLEL_EXECUTION_GUIDE.md
4. SECURITY_ACCESS_PATTERNS.md
5. TOOL_ACCESS_GUIDE.md
6. TOOL_ACCESS_STANDARDIZATION_SUMMARY.md

## Agent Files With Multiline YAML Descriptions
These files use pipe (`|`) for multiline descriptions which may cause parsing issues:
1. **debugger.md** - Uses multiline description with complex coordination_protocols
2. **devops.md** - Very long multiline description with multiple examples
3. **mobile-ui.md** - Multiline description with examples and coordination patterns
4. **product-strategy-expert.md** - Multiline description with strategic examples
5. **security-auditor.md** - Multiline description with security examples

## Common YAML Patterns Found

### 1. Multiline String Format
Files use the pipe (`|`) character for multiline strings in the description field. This is valid YAML but may cause issues if parsers expect different formatting.

### 2. Complex Nested Structures
Some files (like debugger.md) have complex nested YAML structures with:
- coordination_protocols
- nested lists under those protocols
- mixed indentation levels

### 3. Long Description Fields
Several files have extremely long description fields with embedded examples, which while valid YAML, may be difficult to maintain and parse reliably.

### 4. Consistent Structure
All agent files follow this pattern:
```yaml
---
name: agent-name
description: [string or multiline string]
[additional fields...]
---
```

## Recommendations for Phase 2

1. **Standardize Description Format**: Convert long multiline descriptions to single-line strings with escaped quotes
2. **Extract Examples**: Move inline examples from descriptions to a separate `examples` field
3. **Simplify Complex Structures**: Flatten deeply nested coordination_protocols
4. **Add Validation**: Implement YAML schema validation to catch issues early
5. **Create Template**: Standardize agent file format for consistency

## Next Steps
- Phase 2 will focus on standardizing the YAML format
- Create a validation script to ensure consistency
- Implement pre-commit hooks to prevent future issues