---
description: Direct branch creation with intelligent naming patterns
argument-hint: [feature-description]
---

# /branch Command

## Usage

```bash
# Create branch with intelligent naming
/branch user-dashboard
→ Creates feature/user-dashboard branch

# From ticket patterns
/branch JIRA-123
→ Creates feature/jira-123 branch

# Fix patterns
/branch fix-auth-bug
→ Creates fix/auth-bug branch

# Interactive mode (no arguments)
/branch
→ Context-aware analysis and recommendations
```

## Description

Create git branches with intelligent naming patterns based on context and description. Analyzes input to determine
appropriate branch type and name, then executes git operations directly.

## Expected Output

Direct execution workflow for efficient branch creation:

1. **Context Analysis**: Analyze description to determine branch type and naming pattern
2. **Branch Creation**: Execute git commands with intelligent naming
3. **Basic Setup**: Switch to new branch and confirm creation

## Behavior

### Intelligent Pattern Recognition

Apply context-aware naming automatically:

```yaml
Ticket Patterns:
  - JIRA-123 → feature/jira-123
  - GH-456 → feature/gh-456
  - BUG-789 → fix/bug-789
  - HOTFIX-101 → hotfix/hotfix-101

Feature Patterns:
  - user-dashboard → feature/user-dashboard
  - api-integration → feature/api-integration
  - performance-opt → enhancement/performance-opt
  - auth-system → feature/auth-system

Fix Patterns:
  - fix-auth-bug → fix/auth-bug
  - bugfix-login → fix/login-issue
  - auth-bug → fix/auth-bug
  - data-corruption → hotfix/data-corruption

Experimental Patterns:
  - experiment-* → experiment/*
  - poc-* → experiment/*
  - test-* → experiment/*
```

### Branch Type Detection

Determine branch type from input patterns:

```yaml
Feature Branch Indicators:
  - No prefix or "feature-" prefix
  - Ticket numbers (JIRA-*, GH-*, etc.)
  - Component names (dashboard, api, auth)

Fix Branch Indicators:
  - "fix", "bugfix", "bug" in description
  - "BUG-" ticket prefix
  - Issue-related keywords

Hotfix Branch Indicators:
  - "hotfix" prefix
  - "critical", "urgent" keywords
  - Production issue references

Enhancement Branch Indicators:
  - "enhancement", "improve", "optimize"
  - Performance-related terms
  - "refactor", "cleanup" keywords

Experimental Branch Indicators:
  - "experiment", "poc", "test"
  - "prototype", "spike" keywords
  - Research and exploration terms
```

### Direct Execution Flow

Execute branch creation with minimal overhead:

1. **Input Analysis**
   - Parse description for type and naming hints
   - Check for existing branch conflicts
   - Determine appropriate prefix and format

2. **Name Generation**
   - Apply intelligent naming patterns
   - Sanitize input (lowercase, replace spaces/special chars)
   - Add appropriate prefix based on type
   - Handle conflicts with timestamp suffix if needed

3. **Git Operations**

   ```bash
   # Check current repository state
   git status --porcelain

   # Handle uncommitted changes if needed
   git stash push -m "Auto-stash before branch creation"

   # Create and switch to new branch
   git checkout -b <generated-branch-name>

   # Confirm creation
   git branch --show-current
   ```

4. **Confirmation**
   - Display created branch name
   - Show current branch status
   - Provide next steps guidance

### Interactive Mode

When no arguments provided:

1. **Repository Analysis**
   - Check recent commits for context
   - Examine current branch and uncommitted changes
   - Scan for open issues or common patterns

2. **Suggestion Generation**
   - Suggest branch types based on recent activity
   - Provide naming templates for common patterns
   - Offer guided branch creation

3. **User Selection**
   - Present categorized options
   - Allow custom input with pattern assistance
   - Apply selected pattern and create branch

### Error Handling

Handle common scenarios gracefully:

```yaml
Uncommitted Changes:
  - Check git status
  - Auto-stash with descriptive message
  - Proceed with branch creation
  - Remind user about stashed changes

Naming Conflicts:
  - Detect existing branch with same name
  - Append timestamp: feature/user-dashboard-20250109-143052
  - Confirm with user before proceeding

Network Issues:
  - Create branch locally
  - Note that remote operations may be needed later
  - Provide commands for future remote setup

Permission Issues:
  - Report specific permission problems
  - Suggest solutions (SSH key, authentication)
  - Provide fallback local-only workflow
```

### Branch Name Sanitization

Clean and format branch names:

```yaml
Sanitization Rules:
  - Convert to lowercase
  - Replace spaces with hyphens
  - Remove special characters except hyphens
  - Trim leading/trailing hyphens
  - Limit length to 50 characters
  - Ensure valid git branch name format

Examples:
  - "User Dashboard Feature" → "feature/user-dashboard-feature"
  - "Fix Auth Bug!!!" → "fix/auth-bug"
  - "API Integration - Phase 1" → "feature/api-integration-phase-1"
  - "JIRA-1234: User Management" → "feature/jira-1234-user-management"
```

## Success Criteria

Simple and effective branch creation:

- Branch created with appropriate intelligent naming
- User switched to new branch successfully
- Clear confirmation of branch creation
- Guidance for next steps provided
- Minimal execution time and complexity

## Command Philosophy

Transform branch creation from manual naming decisions to intelligent, context-aware automation while maintaining
simplicity and speed. Focus on direct execution rather than complex orchestration.

```yaml
Direct Execution Benefits:
  - Fast branch creation (seconds, not minutes)
  - Clear, predictable naming patterns
  - Minimal system overhead
  - Easy to understand and debug
  - Consistent behavior across environments

Key Capabilities Preserved:
  - Intelligent naming based on context
  - Pattern recognition for different branch types
  - Conflict resolution with fallback naming
  - Interactive mode for guidance
  - Error handling for common scenarios
```
