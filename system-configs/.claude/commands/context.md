# /context Command

## Description

Quickly analyzes and understands any repository by scanning its structure, dependencies, and documentation. This
command provides a comprehensive overview to get you up to speed on any codebase. It can be configured to run
automatically when Claude Code starts in a git repository.

## Usage

```bash
/context [scope or component]
/context --lite
/context -l
```

## Arguments

- `scope or component` (optional): Specific area to analyze deeply. If omitted, provides full repository overview.
- `--lite` or `-l` (optional): Perform a lightweight context analysis by reading only CLAUDE.md, README.md, git status, and current PR information instead of full repository scan.

## Behavior

### Lightweight Analysis (--lite or -l flag)

When you use `/context --lite` or `/context -l`, I will perform a quick, focused analysis:

1. **Read essential documentation**:
   - Parse CLAUDE.md for project-specific instructions and configurations
   - Scan README.md for project overview and quick start information
   
2. **Check git status**:
   - Identify current branch
   - Show modified/staged/untracked files
   - Display recent commits
   
3. **Get PR information**:
   - Use `gh pr status` to find current PR if one exists for this branch
   - Show PR title, number, and review status
   - Display any CI/CD check results
   
4. **Generate lightweight context report** including:
   - Project name and purpose (from README)
   - Current working branch and its status
   - Active PR details (if applicable)
   - Modified files overview
   - Key project instructions (from CLAUDE.md)
   
This mode is ideal for:
- Quick orientation when switching between tasks
- Understanding current work context without full analysis
- Rapid project status checks
- Minimal resource usage

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

- **Full mode**: Completes in under 5 seconds for typical repositories
- **Lite mode**: Completes in under 2 seconds for instant context
- Uses parallel analysis with multiple codebase-analyst agents for large codebases (full mode)
- Caches results to speed up repeated analysis
- Limits depth for extremely large repositories
- Lite mode has minimal resource usage, reading only essential files

## Examples

```bash
# Full repository overview
/context

# Lightweight quick context
/context --lite
/context -l

# Specific component analysis
/context authentication service
/context frontend architecture
/context technical debt
/context performance bottlenecks
```

```text
# Output for --lite mode:
## Lightweight Context: my-react-app

### Current Branch
- Branch: feature/user-authentication
- Status: 3 files modified, 1 untracked

### Active PR
- PR #42: "Add user authentication flow"
- Status: Open, awaiting review
- Checks: All passing ✓

### Modified Files
- src/components/Login.tsx (modified)
- src/services/auth.ts (modified)
- tests/auth.test.ts (modified)
- src/types/user.ts (untracked)

### Project Overview (from README)
A modern React application for task management with real-time collaboration.

### Key Instructions (from CLAUDE.md)
- Run tests before committing
- Use TypeScript strict mode
- Follow atomic commit practices

# Output for full analysis:
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
- Use `--lite` flag for quick context without full repository scan
- Lite mode completes in under 2 seconds for instant context
