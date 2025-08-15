# Agent Specification API

## Overview

The Agent Specification format defines how AI agents are configured in the Claude
Code ecosystem. Each agent is defined in a Markdown file with YAML frontmatter
that specifies its metadata, capabilities, and tool permissions. This
specification supports the current ecosystem of 29 specialized agents across 8
categories.

## File Format

Agent specifications use Markdown files (`.md`) with YAML frontmatter delimited
by `---` markers. The frontmatter contains structured metadata, while the
Markdown body contains the agent's detailed documentation and instructions.

```markdown
---
name: agent-name
description: Brief description of the agent's purpose
color: blue
category: development
tools: Read, Write, Edit, Grep, Glob
---

# Agent Name

[Agent documentation and instructions...]
```

## YAML Frontmatter Schema

### Required Fields

#### `name` (string, required)

- **Type**: String
- **Pattern**: `^[a-z0-9-]+$` (lowercase letters, numbers, and hyphens)
- **Description**: Unique identifier for the agent
- **Constraints**: Must match the filename (without `.md` extension)
- **Example**: `backend-engineer`, `api-documenter`, `test-engineer`

#### `description` (string, required)

- **Type**: String
- **Max Length**: 250 characters
- **Description**: Concise description of the agent's purpose and when to use it
- **Best Practice**: Include "MUST BE USED" conditions for clarity
- **Example**: `"Use for building server-side systems, APIs, microservices. MUST BE
  USED for high-performance optimization (>10k RPS)"`

#### `color` (string, required)

- **Type**: String (color name only)
- **Valid Color Names**: `blue`, `green`, `red`, `purple`, `yellow`, `orange`,
  `white`, `brown`, `cyan`, `pink`, `teal`
- **Description**: Visual identifier color for the agent
- **Constraints**: Should align with the agent's category color assignment (see
  Category Colors section)
- **Examples**: `"blue"`, `"green"`, `"teal"`

#### `tools` (string, required)

- **Type**: String (comma-separated list or empty string)
- **Description**: Tools the agent has permission to use
- **Format**: Tool names separated by commas and optional spaces, or empty string for no tools
- **Examples**:
  - `"Read, Write, Edit, MultiEdit, Grep, Glob, LS, Bash, TodoWrite"`
  - `"Read, Grep, Glob, LS, TodoWrite"`
  - `""` (empty string for specialized agents with no tool access)

### Optional Fields

#### `category` (string, optional but recommended)

- **Type**: String (enum)
- **Valid Values**: `development`, `infrastructure`, `architecture`, `design`, `quality`, `security`, `analysis`,
  `operations`
- **Description**: Primary category the agent belongs to
- **Note**: While technically optional, this field is strongly recommended for proper categorization and
  agent organization

## Category System

### Categories and Color Assignments

| Category | Primary Color | Purpose |
|----------|---------------|---------|
| `development` | `blue` | Core programming and implementation |
| `infrastructure` | `orange` | Systems, operations, and deployment |
| `architecture` | `purple` | System design and technical planning |
| `design` | `pink` | User experience and interface design |
| `quality` | `green` | Testing, review, and validation |
| `security` | `red` | Security assessment and compliance |
| `analysis` | `yellow` | Research, documentation, and analysis |
| `operations` | `teal` | Support, coordination, and workflow management |

### Category Rules

1. Each agent should be assigned to exactly one category (recommended)
2. Agents should use one of the standard color names only
3. Categories determine the agent's primary focus area and expertise
4. Standard color names provide consistent visual identification

## Tool Permissions

### Available Tools

Tools define what capabilities an agent has access to. Common tools include:

#### File System Tools

- `Read` - Read file contents
- `Write` - Create new files
- `Edit` - Modify existing files
- `MultiEdit` - Make multiple edits to a single file
- `LS` - List directory contents
- `Glob` - Find files by pattern

#### Search and Analysis Tools

- `Grep` - Search file contents with regex
- `WebSearch` - Search the web for information
- `WebFetch` - Fetch and analyze web content

#### Development Tools

- `Bash` - Execute shell commands
- `TodoWrite` - Manage task lists
- `NotebookRead` - Read Jupyter notebooks
- `NotebookEdit` - Edit Jupyter notebooks

#### Planning Tools

- `ExitPlanMode` - Exit planning mode when ready to implement

#### Specialized Tools

Some agents may have access to additional specialized tools not listed here.

### Tool Permission Patterns

Different agent types typically have different tool access patterns:

**Development Agents**: Full file manipulation and execution

```yaml
tools: Read, Write, Edit, MultiEdit, Grep, Glob, LS, Bash, TodoWrite
```

**Analysis Agents**: Read-only access with search capabilities

```yaml
tools: Read, Grep, Glob, LS, TodoWrite
```

**Security Agents**: Read and analysis without execution

```yaml
tools: Read, Grep, Glob, LS
```

**Infrastructure Agents**: Full system access including web tools

```yaml
tools: Read, Write, Edit, MultiEdit, Grep, Glob, LS, Bash, TodoWrite, WebFetch
```

**Documentation Agents**: File access with web research capabilities

```yaml
tools: Read, Write, Edit, Grep, Glob, LS, TodoWrite, WebFetch, WebSearch
```

**Specialized Agents**: May have no tools or very specific tool combinations

```yaml
tools: ""
# or
tools: Read, Grep, Glob
```

## Complete Specification Example

### Backend Engineer Agent

```yaml
---
name: backend-engineer
description: Use for building server-side systems, APIs, microservices, databases, and distributed
  architectures. MUST BE USED for high-performance optimization (>10k RPS), event-driven systems, and
  cloud-native backend development
color: blue
category: development
tools: Read, Write, Edit, MultiEdit, Grep, Glob, LS, Bash, TodoWrite
---

# Backend Engineer

## Working with Claude Orchestration Engine

You are a specialized agent working under the coordination of Claude...

## Identity
You are an expert backend engineer specializing in server-side architecture...

## Core Capabilities
[Detailed capabilities documentation...]
```

### Accessibility Auditor Agent

```yaml
---
name: accessibility-auditor
description: Use for WCAG compliance audits, screen reader testing, keyboard navigation checks, and
  accessibility remediation. MUST BE USED when implementing accessible UI components or fixing accessibility
  violations
color: yellow
category: quality
tools: Read, Edit, MultiEdit, Write, Grep, Glob, LS, WebFetch, WebSearch, TodoWrite
---

# Accessibility Auditor

## Working with Claude Orchestration Engine
[Standard orchestration section...]

## Identity
You are an accessibility compliance specialist...
```

## Agent Loading and Discovery

### File Location

- Agents are stored in: `.claude/agents/`
- Each agent has its own `.md` file
- Filename must match the `name` field in YAML frontmatter

### Loading Process

1. Claude Code scans the `.claude/agents/` directory
2. Each `.md` file is parsed for YAML frontmatter
3. Agents are validated against the schema
4. Valid agents are registered and made available

### Non-Agent Files

The following files in the agents directory are documentation, not agent definitions:

- `README.md`
- `AGENT_CATEGORIES.md`
- `AGENT_TEMPLATE.md`
- `AUDIT_VERIFICATION_PROTOCOL.md`
- `CONSOLIDATED_AGENTS_LIST.md`
- `ORCHESTRATION_PATTERNS.md`
- Other documentation files

## Validation Rules

### Required Field Validation

1. All required fields must be present
2. Fields must have non-empty values
3. Field types must match schema

### Name Validation

- Must be lowercase with hyphens
- Must match filename (without `.md`)
- Must be unique across all agents

### Description Validation

- Maximum 250 characters
- Should be clear and actionable
- Should include "MUST BE USED" conditions when applicable

### Color Validation

- Must be from the valid color list: blue, green, red, purple, yellow, orange, white, brown, cyan, pink, teal
- Should align with category assignment
- Consistency across similar agents

### Tools Validation

- Must be comma-separated list or empty string
- Tool names must be valid (when provided)
- No duplicate tools
- Appropriate for agent's role
- Empty string is acceptable for specialized agents

## Best Practices

### Writing Descriptions

1. Start with primary use case
2. List key capabilities
3. Include "MUST BE USED" for specific scenarios
4. Keep under 250 characters
5. Be specific and actionable

Example:

```yaml
description: Use for building React/Vue/Angular apps, state management, and frontend optimization. MUST BE
  USED for responsive design, accessibility implementation, and Core Web Vitals
```

### Tool Selection

1. Only request tools the agent needs
2. Follow category patterns
3. Avoid over-permissioning
4. Consider security implications

### Category Assignment

1. Choose the most appropriate primary category
2. Ensure color matches category
3. Consider the agent's main focus
4. Review similar agents for consistency

## Error Handling

### Common Validation Errors

#### Missing Required Field

```
Error: Missing required field: tools
Solution: Add the tools field with appropriate permissions or empty string
```

#### Name Mismatch

```
Error: Name mismatch: YAML says 'backend-engineer' but filename is 'backend.md'
Solution: Ensure name field matches filename (without .md extension)
```

#### Invalid Color

```
Error: Invalid color format 'invalid-color'
Solution: Use a valid color name (e.g., 'blue', 'green', 'teal')
```

#### Description Too Long

```
Error: Description too long (275 chars). Should be under 250.
Solution: Shorten the description while keeping key information
```

#### Empty Tools Field

```
Note: Empty tools field is valid for specialized agents
Action: No action required if intentional
```

## Integration with Claude Code

### Agent Selection

Claude Code uses the specification to:

1. Match user requests to appropriate agents
2. Understand agent capabilities
3. Enforce tool permissions
4. Display agent information

### Parallel Execution

Multiple instances of the same agent can run concurrently:

- Specifications define capabilities, not instances
- Claude orchestrates multiple instances as needed
- Each instance has the same permissions

### Command Mapping

Some commands automatically select agents:

- `/test` → `test-engineer`
- `/review` → `code-reviewer`
- `/security` → `security-auditor`
- `/perf` → `performance-engineer`
- `/docs` → `tech-writer` or `api-documenter`
- `/debug` → `debugger`
- `/context` → `codebase-analyst` (often multiple instances)

## Version Control

### Changes to Specifications

1. Agent specs are version controlled
2. Changes require validation
3. Breaking changes should be documented
4. Maintain backwards compatibility when possible

### Migration Process

When updating specifications:

1. Update the YAML frontmatter
2. Run validation script
3. Test agent functionality
4. Update dependent documentation

## Validation Script

A Python validation script is provided for agent validation:

```bash
# Validate all agents
python scripts/validate-agent-yaml.py

# Output includes:
# - Validation status for each agent
# - Detailed error messages
# - Summary statistics
# - Category distribution analysis
# - Tool usage patterns
# - Color validation results
```

## Future Considerations

### Potential Extensions

- Additional metadata fields (version, dependencies, priority)
- Tool permission levels (read/write/admin)
- Agent relationships and dependencies
- Performance metrics and resource limits
- Custom validation rules per category
- Agent capability matrices
- Integration testing requirements

### Backwards Compatibility

- New fields should be optional with sensible defaults
- Existing agents should continue working without modification
- Deprecation notices for removed features with migration paths
- Support for standard color names only
- Graceful handling of empty tools fields
