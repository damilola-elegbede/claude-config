# /context Command

## Description
Quickly analyzes and understands any repository by scanning its structure, dependencies, and documentation. This command provides a comprehensive overview to get you up to speed on any codebase. It can be configured to run automatically when Claude Code starts in a git repository.

## Usage
```
/context
```

## Behavior
When you use `/context`, I will:

1. **Analyze repository structure**:
   - Identify project type and technology stack
   - Detect frameworks and build tools
   - Map important directories and their purposes
   - Find entry points and main modules

2. **Scan configuration files**:
   - Package managers (package.json, requirements.txt, go.mod, Cargo.toml, etc.)
   - Build configs (webpack, vite, tsconfig, etc.)
   - CI/CD pipelines (.github/workflows, .gitlab-ci.yml, etc.)
   - Development tools (.eslintrc, .prettierrc, etc.)

3. **Parse documentation**:
   - Summarize README.md
   - Identify available commands and scripts
   - Extract API documentation
   - Note architecture decisions

4. **Generate context report** including:
   - Project purpose and description
   - Technology stack overview
   - Directory structure explanation
   - Available scripts and commands
   - Key dependencies
   - Recent development activity
   - Development workflow

## Output Format
```
## Repository Context: [Project Name]

### Overview
[Brief description of the project]

### Technology Stack
- Language: [Primary language]
- Framework: [Main framework]
- Build Tool: [Build system]
- Package Manager: [Package manager]

### Project Structure
- `/src` - [Purpose]
- `/tests` - [Purpose]
- `/docs` - [Purpose]
[etc.]

### Key Files
- `[file]` - [Description]

### Available Commands
- `[command]` - [What it does]

### Dependencies
[Major dependencies and their purposes]

### Recent Activity
[Summary of recent commits/branches]

### Getting Started
[Quick steps to start developing]
```

## Auto-execution
To enable automatic context analysis on Claude Code startup:

1. This behavior is documented in CLAUDE.md
2. When Claude Code starts in a git repository, I will automatically run `/context`
3. The analysis runs asynchronously to avoid slowing down startup
4. You can disable this by adding a `.claude/noautocontext` file

## Performance
- Completes in under 5 seconds for typical repositories
- Uses parallel analysis with subagents for large codebases
- Caches results to speed up repeated analysis
- Limits depth for extremely large repositories

## Examples
```
# In any repository
/context

# Output for a React app:
## Repository Context: my-react-app

### Overview
A modern React application with TypeScript, using Vite for building and Jest for testing.

### Technology Stack
- Language: TypeScript
- Framework: React 18
- Build Tool: Vite
- Package Manager: npm

[... continues with full analysis ...]
```

## Notes
- Works with any programming language or framework
- Particularly useful when switching between projects
- Results are tailored to the repository type
- Helps identify best practices specific to the project