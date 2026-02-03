# Command Inventory

Post-optimization inventory of 18 commands (reduced from 21 after skill consolidation).

## Summary

| Category | Count | Execution Model |
|----------|-------|-----------------|
| Git Operations | 6 | Direct |
| Development | 2 | Wave-based |
| Quality | 2 | Hybrid |
| Orchestration | 2 | Wave-based |
| Utilities | 5 | Direct/Hybrid |
| Integration | 1 | Wave-based |
| **Total** | **18** | |

> **Note:** `/review`, `/debug`, and `/ship-it` are now **skills only** (not commands).
> See [Skills Guide](../skills/SKILLS_GUIDE.md) for orchestration workflows.

## Git Operations (6)

| Command | Description | Execution Model |
|---------|-------------|-----------------|
| `/branch` | Create branches with intelligent naming | Direct |
| `/commit` | Git commits with message generation | Direct |
| `/merge` | Merge branches with conflict handling | Direct |
| `/pr` | Create PRs with smart descriptions | Direct |
| `/push` | Push with validation | Direct |
| `/rebase` | Rebase on target branch | Direct |

## Development Commands (2)

| Command | Description | Execution Model | Flags |
|---------|-------------|-----------------|-------|
| `/implement` | Feature implementation from specs | Wave-based | `--spec`, `--tdd` |
| `/plan` | PRD and task file generation | Wave-based | `--no-execute`, `--simple` |

> **Note:** `/debug` is now a skill. Use `/debug` to invoke the debug skill for root cause analysis.
> For bug creation, use the debug skill with `--issue` flag.

## Quality Commands (2)

| Command | Description | Execution Model | Flags |
|---------|-------------|-----------------|-------|
| `/test` | Test discovery and execution | Hybrid | `--create`, `--framework`, `--coverage` |
| `/audit` | Unified agent/command validation | Wave-based | `--scope agents\|commands\|all`, `--fix` |

> **Note:** `/review` is now a skill. Use `/review` to invoke the review skill for dual-reviewer analysis.

## Orchestration Commands (2)

| Command | Description | Execution Model | Flags |
|---------|-------------|-----------------|-------|
| `/prime` | Repository understanding | Wave-based | `--lite`, `--full` |
| `/fix-ci` | CI failure diagnosis | Wave-based | `--learn` |

> **Note:** `/ship-it` is now a skill. Use `/ship-it` to invoke the ship-it skill for workflow orchestration.

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

## Removed Commands (6)

The following commands were consolidated or moved to skills:

| Removed | Replacement | Migration |
|---------|-------------|-----------|
| `/implementation-plan` | `/plan --no-execute` | Use `--no-execute` flag |
| `/agent-audit` | `/audit --scope agents` | Use `--scope agents` |
| `/command-audit` | `/audit --scope commands` | Use `--scope commands` |
| `/debug` (command) | `/debug` (skill) | Same invocation, now a skill |
| `/review` (command) | `/review` (skill) | Same invocation, now a skill |
| `/ship-it` (command) | `/ship-it` (skill) | Same invocation, now a skill |

### Why Skills Instead of Commands?

Orchestration workflows (`/debug`, `/review`, `/ship-it`) were moved to skills because:

- **Context isolation**: Skills support `context: fork` for isolated execution
- **Agent routing**: Skills support `agent: <type>` for specialized handling
- **Parallel execution**: Skills enable `run_in_background` for concurrent work
- **No duplication**: Skills and commands are mutually exclusive

See [Skills Guide](../skills/SKILLS_GUIDE.md) for the full comparison.

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
