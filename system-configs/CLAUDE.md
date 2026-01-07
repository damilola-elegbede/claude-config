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

## Mistakes to Avoid

- Don't create documentation files unless explicitly requested
- Don't add features beyond what was asked
- Don't refactor surrounding code when fixing a bug
- Don't bypass quality gates to save time
