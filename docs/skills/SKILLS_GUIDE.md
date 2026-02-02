# Skills Guide: Expertise Modules and Orchestration

## Overview

Skills provide focused domain expertise and complex workflow orchestration in the Claude Code framework.
They range from lightweight format expertise to sophisticated multi-phase workflows.

## Four-Tier Framework

```text
Level 1: Direct Execution
├─ Simple, deterministic tasks
├─ < 5 minutes completion
└─ Example: Fix typos, add imports

Level 2: Expertise Skills
├─ Lightweight domain expertise
├─ Format-specific operations
├─ No orchestration needed
└─ Example: YAML validation, Python idioms

Level 3: Orchestration Skills (NEW)
├─ Complex multi-phase workflows
├─ Context isolation (context: fork)
├─ Task tracking and parallel execution
├─ Agent routing
└─ Example: /review, /debug, /ship-it

Level 4: Agents
├─ Complex specialists
├─ Multi-step orchestration
└─ Example: backend-engineer, ml-engineer
```

## Skills vs Agents vs Commands

| Aspect | Expertise Skills | Orchestration Skills | Agents | Commands |
|--------|------------------|---------------------|--------|----------|
| **Purpose** | Domain knowledge | Complex workflows | Specialists | Simple invocation |
| **Complexity** | Simple, focused | Multi-phase | Multi-step | Straightforward |
| **Duration** | Seconds | Minutes | Minutes | Seconds-Minutes |
| **Context** | Main | Isolated (fork) | Isolated | Main |
| **Task Tracking** | No | Yes | No | Optional |
| **Examples** | yaml, python | /review, /ship-it | backend-engineer | /commit, /push |

## Claude Code Skill Features

Skills support advanced features from Claude Code's skill system:

| Feature | Description | Use Case |
|---------|-------------|----------|
| `context: fork` | Run in isolated context | Complex workflows, reviews |
| `agent: <type>` | Route to specific agent | Domain-specific work |
| `allowed-tools` | Restrict available tools | Security, focus |
| `user-invocable` | Control manual invocation | Background knowledge |

## Directory Structure

Skills use a directory-based structure:

```text
skills/<name>/
  SKILL.md          # Required: skill definition
  templates/        # Optional: supporting files
  examples/         # Optional: reference material
```

## Available Skills (Tier 1 - Core Skills)

### 1. yaml

**Category:** format
**Focus:** YAML syntax, validation, and frontmatter patterns

**Use When:**

- Creating or editing agent/command definitions
- Validating YAML frontmatter
- Troubleshooting YAML parsing errors

**Key Capabilities:**

- Agent and command frontmatter patterns
- YAML syntax validation
- Common anti-patterns identification
- Compliance checking

### 2. markdown

**Category:** format
**Focus:** Markdown formatting and linting compliance

**Use When:**

- Creating or editing documentation
- Fixing markdownlint violations
- Formatting technical content

**Key Capabilities:**

- Markdownlint rule compliance (MD001-MD058)
- Documentation structure patterns
- Code block formatting
- Table formatting

### 3. python

**Category:** language
**Focus:** Python best practices and validation scripts

**Use When:**

- Writing validation scripts
- Implementing automation tools
- Reviewing Python code

**Key Capabilities:**

- Python 3.8+ modern patterns
- Script validation and error handling
- File I/O with pathlib
- CLI argument parsing

### 4. bash

**Category:** workflow
**Focus:** Shell scripting and git hooks

**Use When:**

- Writing shell scripts
- Creating git hooks
- Building automation workflows

**Key Capabilities:**

- Safe script patterns (set -e, quotes, etc.)
- Git hook templates
- Error handling and exit codes
- Script portability

### 5. git-workflows

**Category:** workflow
**Focus:** Git operations and branching strategies

**Use When:**

- Managing branches
- Writing commit messages
- Resolving conflicts
- Setting up quality gates

**Key Capabilities:**

- Branch naming conventions
- Semantic commit messages
- Rebase workflows
- Quality gate compliance

## Orchestration Skills (Tier 2)

These skills use Claude Code's advanced features for complex workflows.

### 1. review

**Category:** orchestration
**Features:** `context: fork`
**Focus:** Dual-reviewer code analysis with parallel execution

**Use When:**

- Reviewing code changes before commit
- Running security and quality analysis
- Getting external (CodeRabbit) and internal reviews

**Key Capabilities:**

- Parallel reviewer execution (run_in_background)
- CodeRabbit CLI integration
- Security, performance, accessibility review
- Results passed to /resolve-comments for triage

### 2. debug

**Category:** orchestration
**Features:** `context: fork`, `agent: debugger`
**Focus:** Systematic root cause analysis

**Use When:**

- Investigating bugs and crashes
- Performance optimization (--performance flag)
- Creating GitHub issues from findings (--issue flag)

**Key Capabilities:**

- Isolated investigation context
- Structured root cause analysis
- Automatic fix implementation
- GitHub issue creation

### 3. ship-it

**Category:** orchestration
**Features:** `context: fork`, Task system integration
**Focus:** Complete development workflow orchestration

**Use When:**

- Shipping code through the full pipeline
- Running docs -> test -> commit -> review -> push -> pr
- Using composable workflow flags

**Key Capabilities:**

- Task dependency tracking
- Progress visibility through TaskList
- Composable flags (-d, -t, -c, -r, -p, -pr)
- Failure recovery with clear status

## Using Skills

### Invocation

Skills are automatically available in Claude Code CLI. Simply mention the skill domain:

```text
User: "Can you help me validate this YAML frontmatter?"
Claude: [Uses yaml skill for validation]

User: "Fix these markdownlint errors"
Claude: [Uses markdown skill for linting fixes]

User: "What's the best way to write this Python script?"
Claude: [Uses python skill for patterns and idioms]
```

### Integration with Agents and Commands

Skills complement agents and commands:

```text
User requests → Claude analyzes complexity

Simple task → Direct execution
Format-specific → Skill (yaml, markdown)
Complex task → Agent (backend-engineer)
Workflow → Command (/test, /review)
```

## Creating New Skills

### Skill Template

Use `docs/skills/SKILL_TEMPLATE.md` as the foundation:

```markdown
---
name: skill-name
description: Expertise in [domain]
category: language|format|framework|infrastructure|workflow
---

# [Skill Name] Expertise

## Domain Focus
[2-3 sentences about expertise area]

## Core Capabilities
- [4-5 specific capabilities]

## When to Use This Skill
- [3-4 specific triggers]

## Common Patterns
[2-3 code examples with explanations]

## Best Practices
- [3-5 key guidelines]

## Quick Reference
| Task | Pattern | Example |
|------|---------|---------|

## Integration Notes
- Works alongside: [related tools]
- Escalate to: [agent-name] for [scenarios]
```

### Validation

Validate new skills before syncing:

```bash
./scripts/validate-skills.py
```

### Deployment

Add skills to the framework via /sync:

```bash
# 1. Create skill in system-configs/.claude/skills/
# 2. Validate
./scripts/validate-skills.py

# 3. Sync to ~/.claude/
/sync

# 4. Verify
ls ~/.claude/skills/
```

## Skill Categories

### language

Programming language expertise:

- **python**: Python 3.8+ patterns, idioms, validation
- **typescript**: TypeScript patterns, type safety
- **go**: Go idioms, concurrency patterns
- **rust**: Rust ownership, safety patterns

### format

File format expertise:

- **yaml**: YAML syntax, frontmatter validation
- **markdown**: Markdown linting, documentation
- **json**: JSON schemas, validation
- **csv**: CSV parsing, data handling

### framework

Framework-specific patterns:

- **react**: React patterns, hooks, components
- **fastapi**: FastAPI patterns, async Python
- **django**: Django patterns, ORM usage
- **nextjs**: Next.js patterns, routing

### infrastructure

DevOps and infrastructure:

- **docker**: Dockerfile best practices
- **kubernetes**: K8s manifests, deployments
- **terraform**: IaC patterns, AWS/cloud
- **github-actions**: CI/CD workflows

### workflow

Process and workflow expertise:

- **git-workflows**: Git operations, branching
- **bash**: Shell scripting, automation
- **cicd**: CI/CD best practices
- **testing-patterns**: TDD/BDD, test organization

### orchestration

Complex multi-phase workflows with Claude Code features:

- **review**: Dual-reviewer code analysis with parallel execution
- **debug**: Systematic root cause analysis with context isolation
- **ship-it**: Complete development workflow with task tracking

**Orchestration skills use:**

- `context: fork` - Isolated execution context
- `agent: <type>` - Route to specialized agents
- Task system - Progress tracking with dependencies
- `run_in_background` - Parallel agent execution

## Best Practices

### When to Create an Expertise Skill

Create an expertise skill when:

- Domain expertise is reusable across projects
- Patterns and idioms are well-established
- No orchestration or multi-step execution needed
- Quick reference would be valuable

### When to Create an Orchestration Skill

Create an orchestration skill when:

- Workflow has multiple phases with dependencies
- Context isolation prevents pollution of main conversation
- Parallel execution would improve efficiency
- Task progress tracking provides value
- Agent routing benefits from specialization

### When NOT to Create a Skill

Don't create a skill when:

- Task is too simple (use command instead)
- Better suited as an agent (domain specialist)
- One-time or project-specific knowledge
- No clear category fit

### Skill Size and Scope

**Good:** Focused, 20-30 lines, specific domain

```markdown
# YAML Expertise
- YAML syntax rules
- Agent/command frontmatter patterns
- Validation checklist
- Common errors
```

**Bad:** Too broad, overlaps with agents

```markdown
# Backend Development Expertise
- API design, database, testing, deployment...
# → This should be backend-engineer agent
```

### Integration Patterns

Skills work best when:

1. **Complementing agents**: Provide quick reference while agents handle complex tasks
2. **Supporting commands**: Enable format-specific operations in workflows
3. **Enhancing direct execution**: Add expertise without orchestration overhead

## Skill Roadmap

### Expertise Skills (Tier 1 - Current)

- ✅ yaml
- ✅ markdown
- ✅ python
- ✅ bash
- ✅ git-workflows

### Orchestration Skills (Tier 2 - Current)

- ✅ review - Dual-reviewer with parallel execution
- ✅ debug - Root cause analysis with context isolation
- ✅ ship-it - Workflow orchestration with task tracking

### Planned Expertise Skills (Tier 3)

- [ ] typescript
- [ ] react
- [ ] docker
- [ ] testing-patterns
- [ ] api-design

### Planned Orchestration Skills (Tier 4)

- [ ] fix-ci - CI failure diagnosis and fix (upgrade from command)
- [ ] audit - Ecosystem validation (upgrade from command)
- [ ] prime - Codebase exploration (upgrade from command)

## Troubleshooting

### Skill Not Available

```bash
# Check if skills are synced
ls ~/.claude/skills/

# Re-sync if needed
/sync

# Verify sync output includes skills
```

### Validation Errors

```bash
# Run validation
./scripts/validate-skills.py

# Common issues:
# - Invalid category (must be: language, format, framework, infrastructure, workflow)
# - Invalid name format (must be lowercase-hyphenated)
# - Missing required fields (name, description, category)
```

### Skill vs Agent Confusion

**Use skill when:**

- Format-specific operation (YAML, Markdown, JSON)
- Language idioms and patterns (Python, TypeScript)
- Quick reference needed
- No orchestration required

**Use agent when:**

- Complex multi-step task
- Requires tool orchestration
- Strategic decisions needed
- Multiple files or systems involved

## Contributing New Skills

1. **Identify need**: Confirm skill doesn't overlap with existing agents
2. **Use template**: Start with `docs/skills/SKILL_TEMPLATE.md`
3. **Follow conventions**: Lowercase-hyphenated names, valid category
4. **Validate**: Run `./scripts/validate-skills.py`
5. **Test**: Ensure skill provides value without duplication
6. **Submit PR**: Include skill file and update this guide

## Resources

- **Skill Template**: `docs/skills/SKILL_TEMPLATE.md`
- **Validation Script**: `scripts/validate-skills.py`
- **Skills Directory**: `system-configs/.claude/skills/`
- **Sync Command**: `/sync` deploys skills to `~/.claude/skills/`

---

**Next Steps:**

1. Review existing Tier 1 skills for usage patterns
2. Propose new skills via GitHub issues
3. Contribute skills following the template
4. Share feedback on skill effectiveness
