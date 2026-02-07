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

Wrong: Running /resolve-comments in file mode because a prior /review passed --code-rabbit --local
Right: Parse the current invocation's arguments; no flags means default mode

This applies to:

- Individual commands (/docs, /test, /commit, etc.)
- Steps within orchestrators (/ship-it, /review, etc.)
- Any skill or agent invocation

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

## Agent Teams (Experimental)

Multiple Claude instances coordinated via shared task list and mailbox. Use for
multi-perspective analysis, parallel implementation, competing hypotheses, or
cross-layer coordination. Don't use for single-domain or sequential workflows.

| Pattern | Teammates | Use Case |
|---------|-----------|----------|
| Full-Stack Feature | backend, frontend, test-engineer | End-to-end feature |
| Deep Review | security-auditor, code-reviewer, accessibility-auditor | Comprehensive audit |
| Research Sprint | researcher, architect | Technology evaluation |
| Debug Swarm | 3-5 debuggers with different hypotheses | Hard-to-reproduce bug |

Best practices: give enough context in spawn prompt, size 5-6 tasks per teammate,
avoid file conflicts, wait for completion before synthesizing.

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
| 4 | Agent Teams | Multi-perspective, parallel exploration | Full-stack features, competing hypotheses |

### Orchestration Skills

| Skill | Purpose | Key Feature |
|-------|---------|-------------|
| `/review` | Dual-reviewer analysis | Parallel execution |
| `/debug` | Root cause investigation | Context isolation |
| `/ship-it` | Workflow orchestration | Task dependencies |
| `/feature-lifecycle` | End-to-end feature implementation | Autonomous plan→merge |

## Available Skills

Skills provide focused operations for common workflows:

**Git Operations:** `/branch`, `/commit`, `/push`, `/pr`, `/rebase`, `/merge`
**Quality:** `/test`, `/review`, `/audit`, `/docs`
**Development:** `/debug`, `/fix-ci`, `/implement`, `/resolve-comments`
**Planning:** `/plan`, `/prime`, `/prompt`, `/verify`, `/deps`
**Orchestration:** `/ship-it`, `/feature-lifecycle` (combines multiple skills)

## Task System

Use tasks for multi-phase operations requiring progress visibility.

### When to Use Tasks

- 3+ distinct phases in a workflow
- Dependencies between phases
- User needs progress visibility
- Complex orchestration across agents

### Task Patterns

| Pattern | Structure | Use Case |
|---------|-----------|----------|
| Sequential | A → B → C | Ordered steps with dependencies |
| Diamond | (A + B parallel) → C | Independent work then synthesis |
| Parallel with join | All complete → synthesis | Multiple analyses merged |

### Task Best Practices

- Mark task `in_progress` BEFORE starting work
- Mark `completed` only when fully done
- Never mark completed if errors/blockers exist
- Create new task for discovered blockers

## Agent Routing

Use this table to route requests to the appropriate specialized agent.

| Keywords | Agent | Category |
|----------|-------|----------|
| fix, broken, bug, crash, error, not working | `debugger` | development |
| slow, performance, optimize, faster, latency, memory | `debugger` | development |
| security, vulnerability, auth, hack, injection | `security-auditor` | quality |
| accessibility, a11y, wcag, aria, screen reader | `accessibility-auditor` | quality |
| architecture, system design, roadmap, infrastructure | `architect` | analysis |
| backend, server, api, microservice, distributed | `backend-engineer` | development |
| frontend, ui, component, react, vue, css, html | `frontend-engineer` | development |
| test, spec, coverage, unit test, integration test | `test-engineer` | quality |
| docs, documentation, readme, write up | `tech-writer` | quality |
| review, check, audit, quality | `code-reviewer` | quality |
| deploy, ci/cd, pipeline, docker, kubernetes | `devops` | development |
| pipeline, etl, database, sql, data warehouse | `data-engineer` | development |
| research, compare, evaluate, analyze, options | `researcher` | analysis |
| mobile, ios, android, swift, kotlin, react native | `mobile-engineer` | development |
| ml, machine learning, model training, pytorch | `ml-engineer` | development |
| implement feature, build feature, feature lifecycle | `feature-agent` | orchestration |

## Background Execution

Use `run_in_background: true` for parallel agent work. Launch ALL parallel agents
in a SINGLE message, then use TaskOutput to wait for completion before synthesis.

Used by: `/fix-ci` (parallel debuggers), `/review` (parallel reviewers), `/ship-it` (concurrent skills)
