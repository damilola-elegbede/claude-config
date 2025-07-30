# Agent Specification API

## Overview

The Agent Specification format defines how AI agents are configured in the Claude Code ecosystem. Each agent is defined in a Markdown file with YAML frontmatter that specifies its metadata, capabilities, and tool permissions.

## File Format

Agent specifications use Markdown files (`.md`) with YAML frontmatter delimited by `---` markers. The frontmatter contains structured metadata, while the Markdown body contains the agent's detailed documentation and instructions.

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
- **Example**: `"Use for building server-side systems, APIs, microservices. MUST BE USED for high-performance optimization (>10k RPS)"`

#### `color` (string, required)
- **Type**: String (color name or hex code)
- **Valid Color Names**: `blue`, `green`, `red`, `purple`, `yellow`, `orange`, `white`, `brown`, `cyan`, `pink`, `teal`
- **Valid Hex Codes**: `#FFD700` (gold), `#008080` (teal), etc.
- **Description**: Visual identifier color for the agent
- **Constraints**: Should align with the agent's category color assignment (see Category Colors section)

#### `tools` (string, required)
- **Type**: String (comma-separated list)
- **Description**: Tools the agent has permission to use
- **Format**: Tool names separated by commas and optional spaces
- **Example**: `"Read, Write, Edit, MultiEdit, Grep, Glob, LS, Bash, TodoWrite"`
- **Empty Tools**: Use empty string or no value for agents with no tool access

### Optional Fields

#### `category` (string, recommended)
- **Type**: String (enum)
- **Valid Values**: `development`, `infrastructure`, `architecture`, `design`, `quality`, `security`, `analysis`, `operations`
- **Description**: Primary category the agent belongs to
- **Note**: While technically optional, this field is strongly recommended for proper categorization

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
| `operations` | `teal` | Support, coordination, and strategic planning |

### Category Rules
1. Each agent should be assigned to exactly one category
2. The agent's `color` field should generally align with their category's color
3. Categories determine the agent's primary focus area and expertise
4. Some flexibility exists for color variations (e.g., hex codes like `#FFD700` for specialized agents)

## Tool Permissions

### Available Tools

Tools define what capabilities an agent has access to. Current available tools include:

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

**Research Agents**: Read access with web capabilities
```yaml
tools: Read, Grep, Glob, LS, TodoWrite, WebFetch
```

**Specialized Tools**: Some agents may have unique tool combinations
```yaml
tools: Read, Edit, MultiEdit, Write, Grep, Glob, LS, WebFetch, WebSearch, TodoWrite
```

## Complete Specification Examples

### Backend Engineer Agent

```yaml
---
name: backend-engineer
description: Use for building server-side systems, APIs, microservices, databases, and distributed architectures. MUST BE USED for high-performance optimization (>10k RPS), event-driven systems, and cloud-native backend development
color: blue
category: development
tools: Read, Write, Edit, MultiEdit, Grep, Glob, LS, Bash, TodoWrite
---

# Backend Engineer

## Identity
You are an expert backend engineer specializing in server-side architecture...

## Core Capabilities
[Detailed capabilities documentation...]
```

### API Documenter Agent

```yaml
---
name: api-documenter
description: Use for generating API documentation, OpenAPI specs from code, SDK docs, and developer guides. MUST BE USED when creating interactive API docs or Postman collections
color: yellow
category: analysis
tools: Read, Write, Edit, Grep, Glob, LS, TodoWrite
---

# API Documenter

## Identity
You are an API documentation specialist...
```

### Accessibility Auditor Agent

```yaml
---
name: accessibility-auditor
description: Use for WCAG compliance audits, screen reader testing, keyboard navigation checks, and accessibility remediation. MUST BE USED when implementing accessible UI components or fixing accessibility violations
color: "#FFD700"
category: quality
tools: Read, Edit, MultiEdit, Write, Grep, Glob, LS, WebFetch, WebSearch, TodoWrite
---

# Accessibility Expert

## Identity
You are an accessibility expert specializing in WCAG compliance...
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
- `AGENT_SELECTION_GUIDE.md`
- `ENHANCEMENT_SUMMARY.md`
- `PARALLEL_EXECUTION_GUIDE.md`
- `SECURITY_ACCESS_PATTERNS.md`
- `TOOL_ACCESS_GUIDE.md`
- `TOOL_ACCESS_STANDARDIZATION_SUMMARY.md`

## Validation Rules

### Required Field Validation
1. All required fields must be present
2. Fields must have non-empty values (except tools which can be empty)
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
- Must be from the valid color list or a valid hex code
- Should generally align with category assignment
- Consistency across similar agents is preferred

### Tools Validation
- Must be comma-separated list or empty string
- Tool names must be valid
- No duplicate tools
- Appropriate for agent's role

## Best Practices

### Writing Descriptions
1. Start with primary use case
2. List key capabilities
3. Include "MUST BE USED" for specific scenarios
4. Keep under 250 characters
5. Be specific and actionable

Example:
```yaml
description: Use for building React/Vue/Angular apps, state management, and frontend optimization. MUST BE USED for responsive design, accessibility implementation, and Core Web Vitals
```

### Tool Selection
1. Only request tools the agent needs
2. Follow category patterns
3. Avoid over-permissioning
4. Consider security implications

### Category Assignment
1. Choose the most appropriate primary category
2. Ensure color generally matches category
3. Consider the agent's main focus
4. Review similar agents for consistency

## Error Handling

### Common Validation Errors

#### Missing Required Field
```
Error: Missing required field: tools
Solution: Add the tools field with appropriate permissions (or empty string)
```

#### Name Mismatch
```
Error: Name mismatch: YAML says 'backend-engineer' but filename is 'backend-engineer.md'
Solution: Ensure name field matches filename
```

#### Invalid Color
```
Error: Invalid color 'lime'. Must be one of: blue, green, red, purple, yellow, orange, white, brown, cyan, pink, teal
Solution: Use a valid color from the list or a hex code like #FFD700
```

#### Description Too Long
```
Error: Description too long (275 chars). Should be under 250.
Solution: Shorten the description while keeping key information
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
- `/docs` → `tech-writer` or `api-documenter`

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

A Python validation script is provided at `scripts/validate-agent-yaml.py`:

```bash
# Validate all agents
python scripts/validate-agent-yaml.py

# Output includes:
# - Validation status for each agent
# - Detailed error messages
# - Summary statistics
# - Report generation
```

## Future Considerations

### Potential Extensions
- Additional metadata fields (version, dependencies)
- Tool permission levels (read/write/admin)
- Agent relationships and dependencies
- Performance metrics and limits
- Custom validation rules

### Backwards Compatibility
- New fields should be optional
- Existing agents should continue working
- Deprecation notices for removed features