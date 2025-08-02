# Efficiency Agents Guide

## Overview

**IMPORTANT:** This document is maintained for historical reference. The efficiency agent concept has been integrated into the main 29-agent portfolio. The workflows described below are now handled by specialized agents like `production-reliability-engineer`, `supply-chain-security-engineer`, and others in the current system.

Originally, efficiency agents were specialized tools designed to minimize tool calls and streamline common development workflows in the Claude Code ecosystem. These concepts have been absorbed into our streamlined agent architecture.

## Core Philosophy

The efficiency agent category follows these principles:
- **Single-Purpose Excellence**: Each agent masters one specific workflow
- **Minimal Tool Usage**: Reduces multi-step operations to single delegations
- **Speed-Optimized**: Prioritizes rapid execution for common tasks
- **Smart Defaults**: Makes intelligent assumptions to reduce back-and-forth
- **Composable**: Designed to work seamlessly with other agents

## The Efficiency Agent Suite

*Note: The efficiency agent category has been consolidated into the main 29-agent portfolio. The concepts below demonstrate streamlined workflow patterns now integrated into our specialized agents.*

### 1. file-navigator (Consolidated)
**Purpose**: Rapid file system exploration and navigation  
**Reduces**: Multiple `ls`, `find`, and `cd` commands to single operations

**Key Capabilities:**
- Intelligent directory traversal with pattern matching
- Smart file discovery across project hierarchies
- Bulk file location and path resolution
- Project structure mapping and visualization

**Example Usage:**
```bash
# Before (5-7 tool calls):
cd src
ls
cd components
ls
find . -name "*.tsx"
cd ../utils
ls

# After (1 delegation):
Task: "Use file-navigator to find all React components and utility files in the src directory"
```

### 2. dependency-manager (Now: supply-chain-security-engineer)
**Purpose**: Streamlined package and dependency operations  
**Reduces**: Multiple package manager commands and version checks

**Key Capabilities:**
- Multi-package installation and updates
- Cross-package-manager support (npm, yarn, pip, go mod)
- Dependency conflict resolution
- Version compatibility checking
- Lock file management

**Example Usage:**
```bash
# Before (4-6 tool calls):
cat package.json
npm list
npm install react@latest
npm install @types/react@latest
npm audit fix

# After (1 delegation):
Task: "Use dependency-manager to update React and its types to latest compatible versions"
```

### 3. git-workflow
**Purpose**: Complex git operations in single commands  
**Reduces**: Multi-step git workflows to atomic operations

**Key Capabilities:**
- Smart branch creation with naming conventions
- Automated stash/restore for branch switching
- Bulk commit operations with conventional commits
- Interactive rebase automation
- Conflict resolution assistance

**Example Usage:**
```bash
# Before (6-8 tool calls):
git status
git stash
git checkout main
git pull
git checkout -b feature/new-feature
git stash pop

# After (1 delegation):
Task: "Use git-workflow to create feature/new-feature branch from latest main"
```

### 4. config-specialist
**Purpose**: Multi-file configuration management  
**Reduces**: Reading, parsing, and updating multiple config files

**Key Capabilities:**
- Cross-format config handling (JSON, YAML, TOML, INI, .env)
- Environment-specific configuration management
- Schema validation and migration
- Secret management integration
- Configuration inheritance resolution

**Example Usage:**
```bash
# Before (5-7 tool calls):
cat .env
cat .env.example
cat config/development.json
edit .env
edit config/development.json

# After (1 delegation):
Task: "Use config-specialist to update database configuration across all environments"
```

### 5. error-resolver (Now: production-reliability-engineer)
**Purpose**: Rapid error diagnosis and resolution  
**Reduces**: Multiple debugging and log analysis steps

**Key Capabilities:**
- Stack trace analysis and root cause identification
- Common error pattern matching
- Automated fix suggestions with code patches
- Log aggregation and correlation
- Error tracking integration

**Example Usage:**
```bash
# Before (6-8 tool calls):
cat error.log
grep "ERROR" logs/
cat package.json
npm list problematic-package
cat src/problem-file.js
edit src/problem-file.js

# After (1 delegation):
Task: "Use error-resolver to diagnose and fix the TypeError in production logs"
```

### 6. search-coordinator
**Purpose**: Advanced code search and analysis  
**Reduces**: Multiple grep/ripgrep commands across files

**Key Capabilities:**
- Multi-pattern simultaneous search
- Context-aware code searching
- Semantic search capabilities
- Cross-reference analysis
- Search result ranking and filtering

**Example Usage:**
```bash
# Before (5-7 tool calls):
grep -r "useState" src/
grep -r "useEffect" src/
rg "import.*from 'react'" --type ts
find . -name "*.test.tsx" -exec grep -l "useState" {} \;

# After (1 delegation):
Task: "Use search-coordinator to find all React hooks usage in test files"
```

### 7. test-runner
**Purpose**: Intelligent test execution and management  
**Reduces**: Multiple test commands and coverage analysis

**Key Capabilities:**
- Smart test selection based on changes
- Parallel test execution optimization
- Coverage gap identification
- Test failure pattern analysis
- Cross-framework test coordination

**Example Usage:**
```bash
# Before (4-6 tool calls):
git diff --name-only
npm test -- --findRelatedTests src/utils/helpers.js
npm test -- --coverage
cat coverage/lcov-report/index.html

# After (1 delegation):
Task: "Use test-runner to run affected tests for recent changes with coverage"
```

### 8. documentation-finder
**Purpose**: Rapid documentation and knowledge retrieval  
**Reduces**: Multiple file searches for docs and comments

**Key Capabilities:**
- Multi-source documentation aggregation
- API documentation extraction
- Comment and docstring analysis
- External documentation linking
- Knowledge graph navigation

**Example Usage:**
```bash
# Before (5-7 tool calls):
find . -name "README*"
grep -r "API" docs/
cat src/api/user.js
grep "@param" src/api/user.js
cat docs/api/users.md

# After (1 delegation):
Task: "Use documentation-finder to gather all user API documentation"
```

### 9. file-writer
**Purpose**: Bulk file operations and scaffolding  
**Reduces**: Multiple file creation and editing commands

**Key Capabilities:**
- Template-based file generation
- Bulk file modifications with patterns
- Project scaffolding from specifications
- File migration and refactoring
- Code generation from schemas

**Example Usage:**
```bash
# Before (8-10 tool calls):
mkdir src/components/Button
cat > src/components/Button/Button.tsx
cat > src/components/Button/Button.test.tsx
cat > src/components/Button/Button.stories.tsx
cat > src/components/Button/index.ts
cat > src/components/Button/Button.module.css

# After (1 delegation):
Task: "Use file-writer to scaffold a new Button component with tests and stories"
```

## Integration Patterns

### Working with Other Agents

Efficiency agents are designed to complement specialist agents:

```yaml
# Example: Full-stack feature implementation
1. file-navigator + codebase-analyst:
   - Navigator finds relevant files
   - Analyst provides deep understanding

2. dependency-manager + backend-engineer:
   - Dependency manager sets up packages
   - Backend engineer implements features

3. git-workflow + code-reviewer:
   - Git workflow manages branches
   - Code reviewer ensures quality

4. error-resolver + debugger:
   - Error resolver handles common issues
   - Debugger tackles complex problems
```

### Command Shortcuts (Historical)

These workflows are now handled by the main agent portfolio:

- File operations → Use appropriate development agents
- Dependencies → `supply-chain-security-engineer`
- Git workflows → Standard git commands + development agents
- Configuration → Infrastructure agents (`devops`, `platform-engineer`)
- Error resolution → `production-reliability-engineer`
- Search → Built into all analysis agents
- Testing → `test-engineer`
- Documentation → `tech-writer`
- File scaffolding → Development agents with file creation capabilities

## Performance Metrics

### Tool Call Reduction Examples

| Task | Traditional Approach | With Efficiency Agent | Reduction |
|------|---------------------|----------------------|-----------|
| Find all test files | 5-7 tool calls | 1 delegation | 80-85% |
| Update dependencies | 4-6 tool calls | 1 delegation | 75-83% |
| Create feature branch | 6-8 tool calls | 1 delegation | 83-87% |
| Fix common error | 6-8 tool calls | 1 delegation | 83-87% |
| Scaffold component | 8-10 tool calls | 1 delegation | 87-90% |

### Time Savings

- **Average time per tool call**: 2-3 seconds
- **Average delegation overhead**: 3-4 seconds
- **Net time saved**: 50-80% for common workflows

## Best Practices

### When to Use Efficiency Agents

✅ **Ideal Use Cases:**
- Repetitive, well-defined tasks
- Multi-step operations with clear patterns
- High-frequency development workflows
- Tasks requiring multiple similar tool calls
- Bulk operations across many files

❌ **When to Use Specialists Instead:**
- Complex architectural decisions
- Deep code analysis requirements
- Security-critical operations
- Performance optimization
- Production debugging

### Composition Strategies

1. **Sequential Efficiency**: Chain efficiency agents for complex workflows
   ```
   file-navigator → search-coordinator → file-writer
   ```

2. **Parallel Efficiency**: Run multiple efficiency agents simultaneously
   ```
   dependency-manager + config-specialist + git-workflow
   ```

3. **Hybrid Workflows**: Combine efficiency and specialist agents
   ```
   file-navigator → codebase-analyst → file-writer
   ```

## Advanced Usage

### Custom Workflows

Efficiency agents can be combined into custom workflows:

```yaml
# Example: Full component creation workflow
workflow: create-feature-component
  steps:
    - file-navigator: Locate component directory
    - dependency-manager: Ensure required packages
    - file-writer: Scaffold component structure (now: frontend-architect/backend-engineer)
    - test-runner: Verify initial tests pass
    - git-workflow: Create feature branch and commit
```

### Performance Optimization Tips

1. **Batch Operations**: Group related tasks for single delegations
2. **Smart Defaults**: Leverage agent intelligence to reduce specifications
3. **Parallel Execution**: Run independent efficiency agents concurrently
4. **Cache Awareness**: Efficiency agents maintain operation caches
5. **Pattern Learning**: Agents adapt to project-specific patterns

## Troubleshooting

### Common Issues

**Issue**: Agent performs more operations than expected  
**Solution**: Provide more specific constraints in delegation

**Issue**: Results don't match traditional approach  
**Solution**: Verify agent has latest project context

**Issue**: Performance not improved  
**Solution**: Ensure task fits efficiency agent profile

### Debug Mode

Enable verbose output for efficiency agents:
```bash
Task: "Use file-navigator in debug mode to trace search algorithm"
```

## Future Enhancements

### Planned Features
- Cross-agent operation caching
- ML-powered pattern recognition
- Custom workflow recording
- Performance analytics dashboard
- Integration with IDE plugins

### Experimental Features
- Predictive file navigation
- Automatic error prevention
- Smart dependency suggestions
- Workflow optimization recommendations

## Summary

Efficiency agents represent a paradigm shift in development automation, reducing tool call overhead while maintaining precision and flexibility. By mastering single workflows and providing intelligent defaults, they enable developers to focus on creative problem-solving rather than repetitive operations.
