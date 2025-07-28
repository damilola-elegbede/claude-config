# Tool Access Standardization Summary

## Standardized Tool Access Categories

### 1. Full Access
**Agents**: backend-dev, frontend-engineer, devops, platform-engineer
**Purpose**: Implementation agents requiring complete tool access
```yaml
tool_access: full_access
tool_restrictions:
  allowed: [Bash, Read, Write, Edit, MultiEdit, Glob, Grep, LS, WebFetch, WebSearch, TodoWrite, NotebookRead, NotebookEdit]
  forbidden: []
  rationale: "[Agent type] requires full tool access to implement complex systems, manage infrastructure, and handle deployment configurations"
```

### 2. Full Implementation  
**Agents**: fullstack-lead, qa-tester
**Purpose**: Implementation agents with full access but more focused scope
```yaml
tool_access: full_implementation
tool_restrictions:
  allowed: [Bash, Read, Write, Edit, MultiEdit, Glob, Grep, LS, WebFetch, WebSearch, TodoWrite, NotebookRead, NotebookEdit]
  forbidden: []
  rationale: "[Agent type] requires full tool access to implement features, create tests, and modify configurations within their scope"
```

### 3. Read + Analysis
**Agents**: code-reviewer, security-auditor, researcher, product-strategist, debugger, performance-engineer, codebase-analyst
**Purpose**: Quality/assessment agents that analyze but don't modify code
```yaml
tool_access: read_only_plus_analysis
tool_restrictions:
  allowed: [Bash(read-only), Read, Glob, Grep, LS, WebFetch, WebSearch, TodoWrite, NotebookRead]
  forbidden: [Edit, MultiEdit, Write, NotebookEdit]
  rationale: "[Agent type] analyzes and provides feedback/recommendations but doesn't modify code - focuses on assessment and coordination"
```

### 4. Documentation Access
**Agents**: tech-writer, api-engineer
**Purpose**: Writing-focused agents needing file creation/editing but not code modification
```yaml
tool_access: documentation_access
tool_restrictions:
  allowed: [Bash(read-only), Read, Write, Edit, MultiEdit, Glob, Grep, LS, WebFetch, WebSearch, TodoWrite]
  forbidden: [NotebookRead, NotebookEdit]
  rationale: "[Agent type] creates specifications/documentation but doesn't modify runtime systems or analyze data notebooks"
```

### 5. Design Specification
**Agents**: ui-designer, mobile-ui, principal-architect
**Purpose**: Planning agents creating specs and designs with file creation capabilities
```yaml
tool_access: design_specification
tool_restrictions:
  allowed: [Bash(read-only), Read, Write, Edit, MultiEdit, Glob, Grep, LS, WebFetch, WebSearch, TodoWrite]
  forbidden: [NotebookRead, NotebookEdit]
  rationale: "[Agent type] creates designs/specifications and requires file creation but doesn't analyze data notebooks"
```

### 6. Strategic Planning
**Agents**: project-orchestrator
**Purpose**: High-level coordination with selective tool access
```yaml
tool_access: strategic_planning
tool_restrictions:
  allowed: [Bash(read-only), Read, Glob, Grep, LS, WebFetch, WebSearch, TodoWrite]
  forbidden: [Edit, MultiEdit, Write, NotebookRead, NotebookEdit]
  rationale: "Project orchestrator coordinates and tracks progress but doesn't implement code or create detailed documentation - focuses on coordination and task management"
```

## Standardization Rules Applied

1. **Consistent Tool Lists**: All agents in the same access category have identical tool lists
2. **Standard Ordering**: Tools are ordered consistently: [Bash, Read, Write, Edit, MultiEdit, Glob, Grep, LS, WebFetch, WebSearch, TodoWrite, NotebookRead, NotebookEdit]. For read-only access, use Bash(read-only) in place of Bash.
3. **Coordination**: Agents coordinate through the general-purpose agent rather than direct subagent invocation
4. **Bash Access**: Specified as "Bash(read-only)" for restricted access or "Bash" for full access
5. **Rationale Required**: Every agent has a clear business justification for its access level
6. **NotebookEdit Consistency**: Explicitly listed in forbidden section for non-data-analysis agents

## Files Updated

✅ All 19 agent files standardized with consistent tool access documentation
✅ Added missing tool access sections to: tech-writer, product-strategist, project-orchestrator
✅ Fixed inconsistent tool lists across same access categories
✅ Standardized formatting and rationale explanations
✅ Aligned access levels with agent responsibilities

## Verification Complete

All agent files now have standardized, consistent tool access documentation that clearly communicates security boundaries and agent capabilities while maintaining business justification for access levels.