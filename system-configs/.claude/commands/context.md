# /context Command

## Description

Quickly analyzes and understands any repository by scanning its structure, dependencies, and documentation. This
command provides a comprehensive overview to get you up to speed on any codebase. It can be configured to run
automatically when Claude Code starts in a git repository.

## Usage

```bash
/context [scope or component]
```yaml

## Arguments

- `scope or component` (optional): Specific area to analyze deeply. If omitted, provides full repository overview.

## Behavior

### Full Repository Analysis (no arguments)

When you use `/context` without arguments, I will:

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

5. **Deploy execution-evaluator** to verify:
   - Repository analysis completed successfully
   - All key directories were scanned
   - Technology stack correctly identified
   - Documentation parsed accurately
   - Context report comprehensive

### Focused Component Analysis (with scope argument)

When you use `/context <scope>`, I will coordinate with codebase-analyst agents to:

1. **Deep dive into specific areas**:
   - Architecture assessment of the component
   - Technical debt analysis
   - Code quality evaluation
   - Dependency analysis
   - Security vulnerability scanning
   - Performance profiling

2. **Provide targeted insights**:
   - Component-specific design patterns
   - Integration points with other systems
   - Potential refactoring opportunities
   - Risk assessment
   - Executive-level summaries

## Output Format

```text
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
```yaml

## Auto-execution

To enable automatic context analysis on Claude Code startup:

1. This behavior is documented in CLAUDE.md
2. When Claude Code starts in a git repository, I will automatically run `/context`
3. The analysis runs asynchronously to avoid slowing down startup
4. You can disable this by adding a `.claude/noautocontext` file

## Performance

- Completes in under 5 seconds for typical repositories
- Uses parallel analysis with multiple codebase-analyst agents for large codebases
- Caches results to speed up repeated analysis
- Limits depth for extremely large repositories

## Examples

```bash
# Full repository overview
/context

# Specific component analysis
/context authentication service
/context frontend architecture
/context technical debt
/context performance bottlenecks
```yaml

```text
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
```yaml

## Notes

- Works with any programming language or framework
- Particularly useful when switching between projects
- Results are tailored to the repository type
