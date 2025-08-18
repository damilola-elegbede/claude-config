# /branch Command

## Description

Creates intelligent git branches from conversation context, explicit input, or
file content. Always starts from updated main branch with conventional naming
patterns.

## Usage

```bash
/branch [description]        # Create branch from description
/branch --file <path>        # Create branch from file context
/branch                      # Create branch from conversation context
```

## Behavior

When invoked, I will create an intelligently named git branch based on the
context provided. I analyze conversation history, file content, or explicit
descriptions to generate conventional branch names that follow best practices.
The branch always starts from an updated main branch.

## Smart Branch Creation

### Automatic Context Analysis

```yaml
Conversation Context:
  - Scans recent messages for features, bugs, tasks
  - Extracts ticket numbers (JIRA-123, GH-456, #789)
  - Identifies work type from keywords

File Context (--file):
  - Bug reports → fix/ prefix
  - Feature specs → feature/ prefix  
  - Documentation → docs/ prefix
  - Performance → perf/ prefix
  - Refactoring → refactor/ prefix

Explicit Description:
  - Uses provided text directly
  - Applies conventional prefixes automatically
```

### Branch Naming Conventions

```bash
# Feature development
feature/user-authentication
feature/JIRA-123-payment-gateway
feature/oauth-integration

# Bug fixes  
fix/login-timeout-issue
fix/GH-456-memory-leak
fix/csrf-validation

# Other work types
docs/api-documentation
perf/database-optimization
refactor/auth-module
chore/dependency-updates
```

## Behavior

### Phase 1: Repository Preparation

```bash
# Switch to main and update
git checkout main
git pull origin main

# Verify clean state
git status --porcelain
```

### Phase 2: Context Analysis & Naming

```bash
# Context priority (highest to lowest):
1. File content (if --file provided)
2. Explicit description argument  
3. Recent conversation messages
4. Fallback to timestamp-based name

# Apply conventional prefixes based on keywords:
analyze_context() {
  if grep -qi "bug\|error\|fix\|issue" context; then
    prefix="fix"
  elif grep -qi "feature\|add\|implement\|create" context; then
    prefix="feature" 
  elif grep -qi "doc\|readme\|guide" context; then
    prefix="docs"
  elif grep -qi "performance\|slow\|optimize" context; then
    prefix="perf"
  elif grep -qi "refactor\|cleanup\|reorganize" context; then
    prefix="refactor"
  else
    prefix="feature"  # Default
  fi
}
```

### Phase 3: Branch Creation & Verification

```bash
# Create and switch to new branch
git checkout -b "$branch_name"

# Set upstream tracking if remote exists
git push -u origin "$branch_name" 2>/dev/null || true

# Verify success
git branch --show-current
git log --oneline -3
```

## Context Extraction Examples

### From Conversation

```text
User: "Need to fix the login timeout issue that's affecting mobile users"
Branch: fix/login-timeout-issue

User: "Let's implement OAuth authentication for third-party logins"  
Branch: feature/oauth-authentication

User: "Working on JIRA-456 to add payment processing"
Branch: feature/JIRA-456-payment-processing
```

### From File Content

```text
File: bug-report.md containing "SQL injection vulnerability in user search"
Branch: fix/sql-injection-user-search

File: feature-spec.md containing "Real-time notifications system"
Branch: feature/realtime-notifications

File: performance.md containing "Database query optimization"  
Branch: perf/database-query-optimization
```

## Advanced Features

### Ticket Number Detection

```bash
# Regex patterns for common ticket formats:
JIRA-\d+     # JIRA-123
GH-\d+       # GH-456  
#\d+         # #789
[A-Z]+-\d+   # ABC-123

# Automatic inclusion in branch names:
"Fix JIRA-123 user auth" → feature/JIRA-123-user-auth
"Resolve GH-456" → fix/GH-456
"Implement #789 notifications" → feature/789-notifications
```

### Conflict Resolution

```bash
# Handle existing branch names
check_branch_exists() {
  if git branch --list "$branch_name" | grep -q "$branch_name"; then
    echo "Branch exists, appending suffix..."
    branch_name="${branch_name}-$(date +%m%d)"
  fi
}

# Handle uncommitted changes
handle_uncommitted_changes() {
  if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "Uncommitted changes detected. Stashing..."
    git stash push -m "Auto-stash before branch creation"
    echo "Use 'git stash pop' to restore changes"
  fi
}
```

## Execution Verification

Deploy execution-evaluator to verify:

- ✅ **Main branch updated** - Latest changes pulled successfully
- ✅ **Branch created** - New branch exists with correct name
- ✅ **Switched successfully** - Currently on new branch
- ✅ **Proper naming** - Follows conventions with appropriate prefix
- ✅ **Clean state** - No uncommitted changes lost
- ✅ **Tracking setup** - Upstream configured if applicable

## Examples

### Basic Usage

```bash
User: /branch user authentication system
Claude: 🔄 Updating main branch...
✅ Switched to main, pulled latest changes
🌿 Creating branch: feature/user-authentication-system
✅ Created and switched to feature/user-authentication-system
📊 3 commits ahead of origin/main
```

### File-Based Context

```bash
User: /branch --file bug-report.md
Claude: 📖 Reading bug-report.md...
🔍 Detected: Bug report about memory leak
🔄 Updating main branch...
🌿 Creating branch: fix/memory-leak
✅ Created and switched to fix/memory-leak
```

### Conversation Context

```bash
User: Need to optimize the database queries, they're really slow
User: /branch
Claude: 🔍 Analyzing conversation context...
💡 Detected: Performance optimization work
🔄 Updating main branch...
🌿 Creating branch: perf/database-queries
✅ Created and switched to perf/database-queries
```

## Notes

- Always starts from updated main/master branch
- Handles uncommitted changes by stashing
- Resolves naming conflicts automatically
- Supports all major ticket numbering systems
- Includes execution verification for reliability
- Maintains git-flow conventions for team consistency
