# About Me

I'm a technology executive who values efficiency, quality, and pragmatic solutions.
I work across diverse projects and prefer Claude to adapt to each context while
maintaining consistent standards.

## Communication Preferences

- Be concise and direct - I scan output quickly
- Lead with the answer, then explain if needed
- Use technical language appropriate to the task
- Skip unnecessary pleasantries and validation
- When uncertain, ask rather than assume

## Working Style

- I use Plan Mode frequently - iterate on the plan before executing
- I often run multiple Claude sessions in parallel on different tasks
- I prefer delegation to specialized agents for complex work
- I value verification - always provide a way to confirm work is correct

## Quality Standards

- Never bypass git hooks with --no-verify
- Run tests before considering work complete
- Code review is expected for non-trivial changes
- Security-sensitive code requires extra scrutiny
- Don't skip steps to save time - quality over speed

## Command Execution

When invoking a command (slash command, skill, or orchestrated step):

**Execute ALL steps defined in command specifications - never skip, abbreviate, or take
shortcuts unless the user explicitly requests it via flags. Command definitions are
contracts, not suggestions.**

Do not preemptively skip, shortcut, or modify the command's behavior based on your own
judgment. The command's instructions define how to handle all cases - including edge
cases, empty states, and "nothing to do" scenarios.

If a command has skip conditions, those conditions are evaluated BY the command during
execution, not by you before execution.

Wrong: "Skipping /docs because config files don't need documentation"
Right: Execute /docs, let its analysis phase determine if documentation is needed

## File Organization

All temporary files, reports, and working documents go in `.tmp/`:

- `.tmp/plans/` - Task planning documents
- `.tmp/reports/` - Generated summaries
- `.tmp/analysis/` - Investigation results
- `.tmp/drafts/` - Work-in-progress

Never create temporary files in repository root or source directories.

## Agent Usage

Use specialized agents when the task benefits from focused expertise:

- Debugging complex issues → debugger
- Security reviews → security-auditor
- Architecture decisions → architect
- Code review → code-reviewer
- Performance optimization → debugger (with --performance)

Don't over-delegate simple tasks. Use judgment.

## Agent Teams

Multiple Claude instances coordinated via TeamCreate with shared task list and mailbox.

**Any task that requires 2+ parallel agents or subagents MUST use TeamCreate.** Do not use
`run_in_background` with multiple Task calls — those agents are invisible API calls
with no terminal, no shared coordination, and no user visibility. TeamCreate gives
each agent a real tmux pane where you can watch them work live.

### When to Use TeamCreate

- **Any time you would spawn 2+ agents or subagents in the same workflow** — this is mandatory, not optional
- User needs to see parallel agent progress in real-time (tmux panes)
- Agents need shared task list coordination
- Workflow requires graceful shutdown of all agents

### When NOT to Use TeamCreate

- Single agent delegation (use `Task` directly)
- Sequential workflows where agents run one after another

### Known Limitation

TeamCreate only spawns `general-purpose` agents ([#24316][tc]). Mitigate by passing
`model: "sonnet"` and embedding the custom agent's Identity/Core Capabilities in spawn
prompts. Enforce read-only via prompt constraints (not `mode: "plan"` — it blocks file writes).

[tc]: https://github.com/anthropics/claude-code/issues/24316

### Patterns

| Pattern | Teammates | Use Case |
|---------|-----------|----------|
| Full-Stack Feature | backend, frontend, test-engineer | End-to-end feature |
| Deep Review | code-reviewer, security-reviewer, a11y-reviewer | Comprehensive audit |
| Research Sprint | researcher, architect | Technology evaluation |
| Debug Swarm | 3-5 debuggers with different hypotheses | Hard-to-reproduce bug |
| CI Fix | debugger-1..N, fixer-{domain} | Parallel CI failure resolution |

### Best Practices

- Give enough context in spawn prompts (embed agent identity + skill content)
- Size 5-6 tasks per teammate
- Assign explicit file ownership to prevent conflicts between teammates
- Always shutdown teammates and TeamDelete when done, even on failure
- Wait for all teammates to complete before synthesizing results

## Mistakes to Avoid

- Don't create documentation files unless explicitly requested
- Don't add features beyond what was asked
- Don't refactor surrounding code when fixing a bug
- Don't bypass quality gates to save time

## Skills System

Skills provide focused domain expertise without full agent orchestration.

### Execution Model

| Level | Type | Use When | Example |
|-------|------|----------|---------|
| 1 | Direct Execution | Simple, deterministic tasks | `/branch`, `/rebase`, `/merge` |
| 2 | Skills | Domain expertise, format-specific | `/review`, `/debug`, `/ship-it` |
| 3 | Agents | Complex specialists, deep analysis | `debugger`, `architect`, `security-auditor` |
| 4 | Agent Teams (TeamCreate) | 2+ parallel agents in same workflow | `/fix-ci`, `/review --deep`, `/implement` |

## Available Skills

Skills provide focused operations for common workflows:

**Git Operations:** `/branch`, `/commit`, `/push`, `/pr`, `/rebase`, `/merge`
**Quality:** `/test`, `/review`, `/audit`, `/docs`
**Development:** `/debug`, `/fix-ci`, `/implement`, `/resolve-comments`
**Planning:** `/plan`, `/prime`, `/prompt`, `/verify`, `/deps`
**Orchestration:** `/ship-it`, `/feature-lifecycle` (combines multiple skills)

## Task System

Use tasks for multi-phase operations requiring progress visibility.

### Best Practices

- Use for 3+ phases with dependencies or progress visibility needs
- Mark task `in_progress` BEFORE starting work
- Mark `completed` only when fully done — never if errors/blockers exist

## Agent Routing

| Keywords | Agent |
|----------|-------|
| fix, broken, bug, crash, error, not working | `debugger` |
| slow, performance, optimize, latency, memory | `debugger` |
| security, vulnerability, auth, injection | `security-auditor` |
| accessibility, a11y, wcag, aria, screen reader | `accessibility-auditor` |
| architecture, system design, infrastructure | `architect` |
| backend, server, api, microservice | `backend-engineer` |
| frontend, ui, component, react, css | `frontend-engineer` |
| test, spec, coverage, unit test | `test-engineer` |
| docs, documentation, readme | `tech-writer` |
| review, check, audit, quality | `code-reviewer` |
| deploy, ci/cd, pipeline, docker, kubernetes | `devops` |
| pipeline, etl, database, sql | `data-engineer` |
| research, compare, evaluate, analyze | `researcher` |
| mobile, ios, android, swift, kotlin | `mobile-engineer` |
| ml, machine learning, model training | `ml-engineer` |
| implement feature, build feature | `feature-agent` |

## Background Execution

**Rule: 2+ parallel agents or subagents → TeamCreate. Always.**

`run_in_background: true` is only for single-agent background tasks (no terminal,
invisible API call, output file only). For 2+ parallel agents, TeamCreate is mandatory
— it provides live tmux panes, shared coordination, and graceful shutdown.
