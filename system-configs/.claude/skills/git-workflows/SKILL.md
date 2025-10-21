---
name: git-workflows
description: Expertise in Git operations, branching strategies, and commit conventions
---

# Git Workflows Expertise

## Domain Focus

Expert knowledge in Git operations, branching strategies, commit conventions, and collaborative workflows.

## Core Capabilities

- Git branching and merging strategies
- Semantic commit messages
- Rebase and history management
- Pull request workflows
- Git hooks and quality gates

## When to Use This Skill

Invoke this skill when:

- Creating branches or managing git workflow
- Writing commit messages
- Resolving merge conflicts
- Setting up git hooks or pre-commit checks

## Common Patterns

### Branch Naming Convention

```bash
# Feature branches
feature/user-dashboard
feature/api-integration
feature/jira-123

# Fix branches
fix/auth-bug
fix/memory-leak
fix/gh-456

# Hotfix branches
hotfix/critical-security-patch
hotfix/production-crash
```

### Semantic Commit Messages

```bash
# Format: <type>(<scope>): <description>

feat(agents): add ml-engineer specialist for model deployment
fix(commands): resolve /sync validation error handling
docs(readme): update installation instructions
refactor(scripts): simplify YAML validation logic
test(agents): add comprehensive agent-audit tests
chore(deps): update dependencies to latest versions
```

### Safe Rebase Workflow

```bash
# Update feature branch from main
git checkout feature/my-feature
git fetch origin
git rebase origin/main

# If conflicts occur
git status  # See conflicted files
# Resolve conflicts in files
git add .
git rebase --continue

# Force push after rebase (feature branches only)
git push --force-with-lease origin feature/my-feature
```

## Best Practices

- Use feature/ prefix for new features
- Use fix/ prefix for bug fixes
- Write descriptive commit messages (50 char summary, 72 char body)
- Never force push to main/master
- Never use --no-verify to bypass hooks
- Rebase feature branches before merging
- Keep commits atomic (one logical change per commit)

## Quick Reference

| Task | Pattern | Example |
|------|---------|---------|
| Create branch | `git checkout -b type/name` | `git checkout -b feature/auth` |
| Commit | `type(scope): message` | `feat(api): add endpoint` |
| Rebase | `git rebase main` | Update from main branch |
| Amend commit | `git commit --amend` | Fix last commit |
| Safe force push | `git push --force-with-lease` | Push after rebase |

## Repository-Specific Workflow

### Creating a Feature

```bash
# 1. Create branch
git checkout main
git pull --rebase
git checkout -b feature/skills-integration

# 2. Make changes and commit
git add system-configs/.claude/skills/
git commit -m "feat(skills): add skills integration framework"

# 3. Push and create PR
git push -u origin feature/skills-integration
gh pr create --title "Add skills integration" --body "..."
```

### Quality Gate Compliance

```bash
# Pre-commit hooks run automatically
git commit -m "message"
# → Runs YAML validation
# → Runs markdown linting
# → Runs security checks

# NEVER bypass with --no-verify
# If hooks fail, fix the issues
```

## Common Operations

### Updating from Main

```bash
# Option 1: Rebase (preferred for feature branches)
git checkout feature/my-branch
git fetch origin
git rebase origin/main

# Option 2: Merge (for collaborative branches)
git merge origin/main
```

### Fixing Last Commit

```bash
# Amend commit message
git commit --amend -m "New message"

# Add forgotten files
git add forgotten-file.md
git commit --amend --no-edit
```

## Integration Notes

- Works alongside: /commit, /branch, /push, /pr commands
- Escalate to: principal-architect for branching strategy decisions
- Complements: Pre-commit hooks defined in .pre-commit-config.yaml
- Quality gates: Never bypass with --no-verify flag
