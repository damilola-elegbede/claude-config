# Claude Commands Overview

## Essential Commands (14 Total)

This directory contains 14 essential commands that provide real value beyond simple agent delegation. These commands have been carefully curated from an original set of 40+ commands, removing bloat and focusing on tools that solve actual problems.

## Command Ratings

### ⭐⭐⭐⭐⭐ Five-Star Commands (2)
- **`/test`** - Auto-discovers and runs tests, creates starter tests if none exist
- **`/context`** - Repository analysis with parallel agents, auto-runs on startup

### ⭐⭐⭐⭐ Four-Star Commands (1)
- **`/plan`** - Strategic + tactical planning with TDD methodology, prevents massive PRs

### ⭐⭐⭐ Three-Star Commands (11)
- **`/review`** - Comprehensive code review with quality gates
- **`/debug`** - Systematic debugging for complex issues  
- **`/deps`** - Security-focused dependency management
- **`/fix-ci`** - Auto-fixes CI failures, gets PRs green
- **`/agent-audit`** - Validates agent configurations and capabilities
- **`/resolve-cr`** - Addresses code review comments systematically
- **`/pr`** - Creates pull requests with proper formatting
- **`/commit`** - Git commit with conventional format
- **`/push`** - Safe git push with checks
- **`/branch`** - Creates semantic branches
- **`/sync`** - Syncs Claude config files (repo-specific)

## What Was Removed

We removed 26 commands that were either:
- **Agent Wrappers** - Commands that just called a single agent (e.g., `/security`, `/perf`, `/docs`)
- **Document Theater** - Commands that created documents with no real value (`/write-prd`, `/write-spec`)
- **Redundant** - Commands that duplicated existing functionality (`/analyze-stack`, `/fix-tests`)
- **Trivial** - Commands for things easily done directly (`/config-diff`, `/tokens`)

## Command Categories

### Test & Quality
- `/test` - Intelligent test discovery and execution
- `/review` - Code quality validation  
- `/agent-audit` - Agent ecosystem validation

### Planning & Development
- `/plan` - Strategic and tactical planning with TDD
- `/debug` - Complex bug investigation
- `/deps` - Dependency security management
- `/fix-ci` - CI/CD failure resolution

### Git Workflow
- `/commit` - Semantic commits
- `/branch` - Semantic branch creation
- `/push` - Safe push operations
- `/pr` - Pull request creation
- `/resolve-cr` - Code review resolution

### Utility
- `/context` - Repository understanding
- `/sync` - Configuration synchronization

## Design Philosophy

Commands should:
1. **Solve Real Problems** - Not just wrap agent calls
2. **Add Value** - Do something that can't be done by just asking Claude
3. **Be Actionable** - Produce immediate, useful results
4. **Automate Complexity** - Handle multi-step workflows

Commands should NOT:
1. Create unnecessary documentation
2. Simply delegate to a single agent
3. Duplicate existing Claude capabilities
4. Add layers of abstraction without value

## Usage Examples

### Essential Workflow
```bash
# Understand the codebase
/context

# Create a feature plan
/plan "Add user authentication"

# Make changes and test
/test

# Review before committing
/review

# Commit and push
/commit
/push

# Fix any CI issues
/fix-ci
```

### Maintenance Workflow
```bash
# Check dependencies
/deps audit

# Fix security issues
/deps update

# Debug issues
/debug "Memory leak in production"

# Resolve code review comments
/resolve-cr 123
```

## Contributing New Commands

Before adding a new command, ask:
1. Does this solve a problem that can't be solved by deploying agents?
2. Does this automate a complex multi-step process?
3. Is this different from just having a conversation with Claude?
4. Will this save significant time or prevent errors?

If you answered "no" to any of these, reconsider whether the command is necessary.

## Command Implementation Standards

All commands should:
- Have clear, actionable descriptions
- Include usage examples
- Define success criteria
- Handle errors gracefully
- Integrate with existing workflows
- Follow the established rating system

Commands rated 3+ stars should remain in the repository. Commands rated 1-2 stars should be removed or significantly improved.