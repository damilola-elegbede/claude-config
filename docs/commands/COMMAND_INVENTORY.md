# Command Inventory

Post-optimization inventory of 21 commands (reduced from 23).

## Summary

| Category | Count | Execution Model |
|----------|-------|-----------------|
| Git Operations | 5 | Direct |
| Development | 4 | Wave-based |
| Quality | 3 | Hybrid |
| Orchestration | 3 | Wave-based |
| Utilities | 5 | Direct/Hybrid |
| **Total** | **21** | |

## Git Operations (5)

| Command | Description | Execution Model |
|---------|-------------|-----------------|
| `/branch` | Create branches with intelligent naming | Direct |
| `/commit` | Git commits with message generation | Direct |
| `/pr` | Create PRs with smart descriptions | Direct |
| `/push` | Push with validation | Direct |
| `/rebase` | Rebase on target branch | Direct |

## Development Commands (4)

| Command | Description | Execution Model | Flags |
|---------|-------------|-----------------|-------|
| `/implement` | Feature implementation from specs | Wave-based | `--spec`, `--tdd` |
| `/plan` | PRD and task file generation | Wave-based | `--no-execute`, `--simple` |
| `/debug` | Root cause analysis | Wave-based | `--save`, `--repro`, `--performance` |
| `/bug` | GitHub issue creation | Wave-based | `--from-debug`, `--priority`, `--labels` |

## Quality Commands (3)

| Command | Description | Execution Model | Flags |
|---------|-------------|-----------------|-------|
| `/review` | Code review with linting | Hybrid | `--full`, `--fix`, `--security` |
| `/test` | Test discovery and execution | Hybrid | `--create`, `--framework`, `--coverage` |
| `/audit` | Unified agent/command validation | Wave-based | `--scope agents\|commands\|all`, `--fix` |

## Orchestration Commands (3)

| Command | Description | Execution Model | Flags |
|---------|-------------|-----------------|-------|
| `/prime` | Repository understanding | Wave-based | `--lite`, `--full` |
| `/ship-it` | Release workflow orchestration | Orchestrator | `-d`, `-t`, `-c`, `-r`, `-p`, `-pr`, `--dry-run` |
| `/fix-ci` | CI failure diagnosis | Wave-based | `--learn` |

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

| Removed | Merged Into | Migration |
|---------|-------------|-----------|
| `/implementation-plan` | `/plan --no-execute` | Use `--no-execute` flag |
| `/agent-audit` | `/audit --scope agents` | Use `--scope agents` |
| `/command-audit` | `/audit --scope commands` | Use `--scope commands` |

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

# Commit changes
/commit

# Create PR
/pr main

# Push safely
/push
```
