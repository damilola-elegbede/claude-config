---
name: coderabbit
description: Run CodeRabbit local code reviews. Use for pre-push review, catching issues early. Triggers on "coderabbit", "local review", "cr review". For full workflow, use /review or /ship-it -r.
---

# CodeRabbit CLI Expertise

## Domain Focus

Expert knowledge in CodeRabbit CLI for local AI-powered code reviews before pushing commits.

## Core Capabilities

- Local code review before push
- Uncommitted and committed change analysis
- AI-powered issue detection (race conditions, security, logic errors)
- Integration with Claude Code workflow

## When to Use This Skill

Invoke this skill when:

- Running quick local code reviews
- Checking code before committing or pushing
- Debugging CodeRabbit CLI issues
- Understanding CodeRabbit output

## Common Commands

### Review Uncommitted Changes

```bash
# AI-optimized output (best for automated fixing)
coderabbit --prompt-only --type uncommitted

# Human-readable detailed output
coderabbit --plain --type uncommitted

# Interactive mode (default)
coderabbit
```

### Review Committed Changes

```bash
# Review commits not yet pushed
coderabbit --prompt-only --type committed

# Compare against specific branch
coderabbit --base develop
```

### Review All Changes

```bash
# Both uncommitted and committed
coderabbit --prompt-only --type all
```

## Output Modes

| Flag | Purpose | Best For |
|------|---------|----------|
| `--prompt-only` | Minimal, AI-parseable | Automated fixing with Claude |
| `--plain` | Detailed text | Human review |
| (none) | Interactive | Manual exploration |

## Setup

```bash
# Install
curl -fsSL https://cli.coderabbit.ai/install.sh | sh
source ~/.zshrc

# Authenticate
coderabbit auth login

# Verify
coderabbit auth status
```

## Integration with Claude Code

Best practice workflow:

```text
"Run coderabbit --prompt-only in the background and fix any issues it reports"
```

This lets CodeRabbit analyze while Claude works, then Claude fixes issues automatically.

## Rate Limits

- **Free tier**: 1 review/hour (basic static analysis)
- **Pro tier**: 5 reviews/hour (full contextual analysis)

## Configuration

CodeRabbit reads `.coderabbit.yaml` from repository root for:

- Review profile (chill vs assertive)
- Path filters and instructions
- Tool integrations (linters)
- Tone customization

## Quick Reference

| Task | Command |
|------|---------|
| Quick review | `cr --prompt-only` |
| Full output | `cr --plain` |
| Check auth | `cr auth status` |
| Set base branch | `cr --base main` |
| Uncommitted only | `cr --type uncommitted` |

## Integration Notes

- Works alongside: /review command (runs CodeRabbit + AI reviewer in parallel)
- Complements: /ship-it -r for full workflow
- Config: .coderabbit.yaml in repository root
