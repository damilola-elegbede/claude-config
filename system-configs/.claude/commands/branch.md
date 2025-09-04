---
description: Context-aware branch creation with smart naming
argument-hint: [feature-description]
---

# Branch Creation with Smart Context Analysis

Create intelligent git branches using pattern matching for ticket systems, smart naming conventions,
and automated git workflow management. Analyze the user's input to determine branch type and apply
appropriate naming patterns.

## Context

### Intelligent Branch Naming

Apply pattern recognition for different branch types:

- **Ticket patterns**: `JIRA-123`, `GH-456`, `TICKET-789` → `feature/JIRA-123`
- **Fix patterns**: `fix-auth-bug` → `fix/auth-bug`
- **Feature patterns**: `user-dashboard` → `feature/user-dashboard`
- **Hotfix patterns**: `hotfix-critical-issue` → `hotfix/critical-issue`

### Smart Context Analysis

Perform comprehensive git state assessment:

```yaml
Pre-Creation Checks:
  - Ensure working on main/master branch
  - Stash uncommitted changes if present
  - Pull latest changes from remote
  - Validate branch name availability

Context Gathering:
  - Recent commit messages analysis
  - Current PR/issue context
  - Team branching conventions
  - Project-specific patterns
```

### Branch Preparation Process

Execute automated cleanup and setup:

```yaml
Setup Process:
  1. Switch to main branch
  2. Pull latest changes
  3. Create and switch to new branch
  4. Verify branch creation success

Naming Conflicts:
  - Auto-append timestamp if branch exists
  - Suggest alternative names
  - Preserve user intent in naming
```

### Ticket System Integration

Support major ticket systems:

- **JIRA**: `PROJ-123` → `feature/PROJ-123`
- **GitHub Issues**: `#456` → `feature/gh-456`
- **Linear**: `LIN-789` → `feature/LIN-789`
- **Azure DevOps**: `ADO-012` → `feature/ADO-012`

### Interactive Mode

When no arguments provided, offer context-aware suggestions:

```yaml
Context-Aware Suggestions:
  - Based on recent commit messages
  - Extracted from current working files
  - Derived from open PR titles
  - Generated from project patterns

Suggestion Categories:
  - Feature branches for new work
  - Fix branches for bug reports
  - Hotfix branches for critical issues
  - Experimental branches for POCs
```

### Team Convention Detection

Automatically analyze and adapt to project patterns:

```yaml
Convention Analysis:
  - Analyze existing branch names
  - Detect team naming patterns
  - Learn project-specific conventions
  - Adapt suggestions accordingly

Pattern Examples:
  - feature/user-story-123
  - bugfix/issue-456
  - enhancement/performance-optimization
  - docs/update-readme
```

## Expected Output

Execute the complete branch creation workflow:

1. **Git State Assessment**: Analyze current repository state and handle uncommitted changes
2. **Pattern Recognition**: Identify branch type from user input using intelligent pattern matching
3. **Branch Creation**: Create appropriately named branch following team conventions
4. **Verification**: Confirm successful branch creation and provide user feedback
5. **Context Documentation**: Track branch purpose and link to related tickets/issues

For interactive mode (no arguments), provide intelligent suggestions based on repository context and team patterns.

Handle common scenarios:

- **Naming Conflicts**: Generate alternative names preserving user intent
- **Uncommitted Changes**: Automatic stashing with descriptive messages
- **Network Issues**: Retry operations with fallback to local-only mode
- **Permission Problems**: Provide clear guidance and escalation paths

Always maintain git-flow conventions and ensure reliable execution with comprehensive error handling.
