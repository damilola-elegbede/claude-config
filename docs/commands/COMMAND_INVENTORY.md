# Command Inventory

Post-optimization inventory of 21 commands.

## Summary

| Category | Count | Execution Model |
|----------|-------|-----------------|
| Git Operations | 6 | Direct |
| Development | 2 | Wave-based |
| Quality | 2 | Hybrid |
| Orchestration | 5 | Wave-based |
| Utilities | 5 | Direct/Hybrid |
| Integration | 1 | Wave-based |
| **Total** | **21** | |

> **Note:** `/review`, `/debug`, and `/ship-it` are commands (restored from skills).
> Skills don't receive CLI arguments, so these were moved back to commands.

## Git Operations (6)

| Command | Description | Execution Model |
|---------|-------------|-----------------|
| `/branch` | Create branches with intelligent naming | Direct |
| `/commit` | Git commits with message generation | Direct |
| `/merge` | Merge branches with conflict handling | Direct |
| `/pr` | Create PRs with smart descriptions | Direct |
| `/push` | Push with validation | Direct |
| `/rebase` | Rebase on target branch | Direct |

## Development Commands (3)

| Command | Description | Execution Model | Flags |
|---------|-------------|-----------------|-------|
| `/implement` | Feature implementation from specs | Wave-based | `--spec`, `--tdd` |
| `/plan` | PRD and task file generation | Wave-based | `--no-execute`, `--simple` |
| `/debug` | Root cause analysis | Wave-based | `--performance`, `--issue` |

## Quality Commands (3)

| Command | Description | Execution Model | Flags |
|---------|-------------|-----------------|-------|
| `/test` | Test discovery and execution | Hybrid | `--create`, `--framework`, `--coverage` |
| `/audit` | Unified agent/command validation | Wave-based | `--scope agents\|commands\|all`, `--fix` |
| `/review` | Dual-reviewer code analysis | Wave-based | `--full` |

## Orchestration Commands (3)

| Command | Description | Execution Model | Flags |
|---------|-------------|-----------------|-------|
| `/prime` | Repository understanding | Wave-based | `--lite`, `--full` |
| `/fix-ci` | CI failure diagnosis | Wave-based | `--learn` |
| `/ship-it` | Development workflow orchestration | Orchestrator | `-d`, `-t`, `-c`, `-r`, `-p`, `-pr`, `--dry-run` |

## Utility Commands (5)

| Command | Description | Execution Model | Flags |
|---------|-------------|-----------------|-------|
| `/sync` | Deploy configurations | Direct | `--dry-run`, `--backup`, `--force` |
| `/deps` | Dependency management | Wave-based | `audit`, `update`, `clean`, `--quick` |
| `/docs` | Documentation generation | Hybrid | `--audit`, `--audit-and-fix`, `--clean` |
| `/prompt` | Prompt optimization | Direct | `--file` |
| `/verify` | Command verification | Hybrid | `--last`, `--command`, `--depth` |

### Integration Commands (1)

| Command | Description | Execution Model | Flags |
|---------|-------------|-----------------|-------|
| `/resolve-comments` | CodeRabbit comment resolution | Wave-based | `--auto`, `--dry-run` |

## Removed Commands (3)

The following commands were consolidated:

| Removed | Replacement | Migration |
|---------|-------------|-----------|
| `/implementation-plan` | `/plan --no-execute` | Use `--no-execute` flag |
| `/agent-audit` | `/audit --scope agents` | Use `--scope agents` |
| `/command-audit` | `/audit --scope commands` | Use `--scope commands` |

### Why Commands Instead of Skills?

`/debug`, `/review`, and `/ship-it` were initially migrated to skills but have been restored as commands because:

- **Argument passing**: Skills don't receive `<command-args>` from CLI, so flags like `-c -p` were ignored
- **Practical functionality**: Commands properly handle argument parsing for composable workflows
- **Trade-off**: Commands don't support `context: fork`, but working flags are more important

## Execution Models

### Direct

- Single-step execution
- No agent delegation
- Fast, deterministic

### Wave-based

- Multi-step orchestration
- Agent delegation
- Parallel execution support

### Hybrid

- Direct execution with optional agent delegation
- Streaming output
- Context-aware escalation

### Orchestrator

- Calls other commands
- Workflow coordination
- Sequential/parallel command execution

## Usage Examples

### Development Workflow

```bash
# Plan without execution
/plan "Add user authentication" --no-execute

# Implement from spec
/implement auth-spec.md --tdd

# Debug with saved output
/debug "Login fails silently" --save

# Create bug from debug analysis
/bug --from-debug
```

### Quality Workflow

```bash
# Full audit
/audit --scope all

# Code review with fixes
/review --full --fix

# Test with coverage
/test --coverage
```

### Git Workflow

```bash
# Create feature branch
/branch add-oauth-support

# Merge main into current branch
/merge

# Merge specific branch with conflict strategy
/merge develop --theirs

# Commit changes
/commit

# Create PR
/pr main

# Push safely
/push
```
