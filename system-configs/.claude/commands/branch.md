---
name: "branch"
category: "git"
capabilities: ["branch-creation", "git-operations"]
tools: ["Write", "Read"]
description: "Context-aware branch creation with pattern matching for ticket systems and smart naming conventions"
---

# Context-Aware Branch Creation

Smart git branch management with ticket system integration and intelligent naming.

## Usage

```bash
/branch <feature-description>  # Creates feature/feature-description
/branch fix-<issue>            # Creates fix/fix-issue
/branch <TICKET-123>           # Creates feature/TICKET-123
/branch                        # Interactive mode with suggestions
```

## Behavior

### Intelligent Branch Naming

**Pattern Recognition**:

- Ticket patterns: `JIRA-123`, `GH-456`, `TICKET-789` → `feature/JIRA-123`
- Fix patterns: `fix-auth-bug` → `fix/auth-bug`
- Feature patterns: `user-dashboard` → `feature/user-dashboard`
- Hotfix patterns: `hotfix-critical-issue` → `hotfix/critical-issue`

### Smart Context Analysis

**Git State Assessment**:

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

### Automated Cleanup & Setup

**Branch Preparation**:

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

## Advanced Features

### Ticket System Integration

**Supported Systems**:

- **JIRA**: `PROJ-123` → `feature/PROJ-123`
- **GitHub Issues**: `#456` → `feature/gh-456`
- **Linear**: `LIN-789` → `feature/LIN-789`
- **Azure DevOps**: `ADO-012` → `feature/ADO-012`

### Smart Suggestions

**Interactive Mode Features**:

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

**Automatic Pattern Learning**:

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

## Examples

### Basic Feature Branch

```text
User: /branch user authentication
Claude: 🌿 Creating feature branch...
✅ Switched to main branch
✅ Pulled latest changes (2 new commits)
✅ Created and switched to: feature/user-authentication
📍 Ready for development on feature/user-authentication
```

### Ticket-Based Branch

```text
User: /branch JIRA-1234
Claude: 🎫 Detected ticket pattern...
✅ Analyzing JIRA-1234 context
✅ Created branch: feature/JIRA-1234
📋 Branch linked to: User Authentication Implementation
```

### Interactive Mode

```text
User: /branch
Claude: 🤔 What would you like to work on?

Recent context suggests:
1. feature/payment-integration (from recent commits)
2. fix/login-redirect-bug (from open issues)
3. feature/dashboard-redesign (from PR discussions)

Or describe your feature: ___
```

### Conflict Resolution

```text
User: /branch user-auth
Claude: ⚠️ Branch 'feature/user-auth' already exists

Suggestions:
1. feature/user-auth-v2
2. feature/user-auth-improvements
3. feature/user-auth-refactor

Choose option or provide new name: ___
```

## Integration Features

### Git Hook Integration

```yaml
Pre-commit Integration:
  - Validates branch naming conventions
  - Ensures branch is up-to-date
  - Checks for proper ticket references

Post-checkout Integration:
  - Sets up branch-specific configurations
  - Initializes development environment
  - Creates initial commit templates
```

### IDE Integration

```yaml
Development Environment:
  - VS Code workspace updates
  - IDE-specific branch configurations
  - Automatic file template setup
  - Context-aware snippet activation
```

## Workflow Integration

### CI/CD Preparation

**Automatic Setup**:

```yaml
Branch Configuration:
  - Sets appropriate upstream tracking
  - Configures branch protection if needed
  - Prepares for CI/CD integration
  - Sets up deployment previews
```

### Documentation Sync

**Context Documentation**:

```yaml
Branch Documentation:
  - Creates branch purpose documentation
  - Links to related tickets/issues
  - Maintains branch lifecycle history
  - Tracks development progress
```

## Error Handling

### Common Issues

**Git State Problems**:

```yaml
Uncommitted Changes:
  Action: Automatic stashing with descriptive message
  Recovery: Provides stash pop instructions

Merge Conflicts:
  Action: Resolves simple conflicts automatically
  Escalation: Guides user through manual resolution

Network Issues:
  Action: Retries with exponential backoff
  Fallback: Creates local branch, defers remote operations
```

### Recovery Scenarios

**Branch Creation Failures**:

```yaml
Name Conflicts:
  - Generate alternative names
  - Preserve user intent
  - Provide selection options

Permission Issues:
  - Check repository permissions
  - Suggest alternative approaches
  - Escalate to repository admin if needed
```

## Performance Optimization

### Execution Speed

**Optimization Strategies**:

```yaml
Git Operations:
  - Parallel fetch and branch operations
  - Cached git status checking
  - Optimized remote communication
  - Background preparation tasks

Context Analysis:
  - Cached pattern recognition
  - Pre-computed suggestions
  - Efficient git log analysis
  - Optimized file system operations
```

### Resource Management

**Efficient Processing**:

```yaml
Memory Usage:
  - Streaming git log analysis
  - Efficient pattern matching
  - Cached convention detection
  - Minimal working set retention

Network Efficiency:
  - Batched remote operations
  - Compressed data transfer
  - Connection reuse
  - Background sync operations
```

## Notes

- Always starts from updated main/master branch
- Handles uncommitted changes by stashing
- Resolves naming conflicts automatically
- Supports all major ticket numbering systems
- Includes execution verification for reliability
- Maintains git-flow conventions for team consistency
