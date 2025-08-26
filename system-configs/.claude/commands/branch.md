# /branch Command

## Description

Creates intelligent git branches from conversation context, explicit input, or
file content. Always starts from updated main branch with conventional naming
patterns.

## Usage

```bash
/branch [description]        # Create branch from description
/branch --file <path>        # Create branch from file context
/branch -f <path>            # Create branch from file context (short form)
/branch                      # Create branch from conversation context
```bash

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

File Context (--file or -f):
  - Bug reports → fix/ prefix
  - Feature specs → feature/ prefix
  - Documentation → docs/ prefix
  - Performance → perf/ prefix
  - Refactoring → refactor/ prefix

Explicit Description:
  - Uses provided text directly
  - Applies conventional prefixes automatically
```bash

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
```bash

## Agent Orchestration

### Parallel Analysis Phase - Multi-Agent Deployment

**Launch all these concurrently:** Multiple agents for intelligent branch creation:

```yaml
# PARALLEL WAVE: All agents work simultaneously (2-3 seconds total)
tech-writer:
  role: Generate clear, conventional branch names and documentation
  input: Work type, ticket numbers, description
  output: Properly formatted branch name, branch documentation
  parallel_with: [code-reviewer, security-auditor, codebase-analyst, project-orchestrator]

code-reviewer:
  role: Validate branch strategy and naming conventions
  input: Branch name proposal, git history, team standards
  output: Naming validation, convention compliance check
  parallel_with: [tech-writer, security-auditor, codebase-analyst, project-orchestrator]

security-auditor:
  role: Review for sensitive information in branch names
  input: Branch name, context analysis
  output: Security clearance, sensitive data warnings
  parallel_with: [tech-writer, code-reviewer, codebase-analyst, project-orchestrator]

codebase-analyst:
  role: Analyze existing branches and patterns
  input: Current branch structure, naming patterns in use
  output: Consistency recommendations, conflict detection
  parallel_with: [tech-writer, code-reviewer, security-auditor, project-orchestrator]

project-orchestrator:
  role: Determine work type and project context
  input: Conversation history, file content, project structure
  output: Work classification, priority assessment
  parallel_with: [tech-writer, code-reviewer, security-auditor, codebase-analyst]
```bash

### Agent Coordination

```yaml
Parallel Execution Strategy:
  Phase 1 - Context Analysis (All agents simultaneously):
    - project-orchestrator: Classifies work type and priority
    - codebase-analyst: Examines existing branch patterns
    - tech-writer: Drafts multiple branch name options
    - code-reviewer: Prepares convention validation
    - security-auditor: Scans for sensitive data patterns

  Phase 2 - Convergence (Instant):
    - All agent outputs combined
    - Best branch name selected based on consensus
    - Any conflicts resolved by priority rules

  Execution Time:
    - Sequential: 8-10 seconds
    - Parallel: 2-3 seconds (70% faster)

  Benefits:
    - More comprehensive analysis
    - Better naming consistency
    - Reduced chance of conflicts
    - Security validation built-in
```

## Execution Process

### Phase 1: Parallel Context Analysis (Agents)

```bash
# Execute in parallel (not sequentially)
parallel_analysis() {
  # project-orchestrator: Determine work type and strategy
  # business-analyst: Extract requirements and tickets
  # tech-writer: Prepare naming conventions
}

# Aggregate results from all agents
branch_strategy=$(combine_agent_outputs)
```bash

### Phase 2: Repository Preparation

```bash
# Switch to main and update
git checkout main
git pull origin main

# Verify clean state
git status --porcelain
```bash

### Phase 3: Intelligent Naming (Agent-Driven)

```bash
# Context priority (highest to lowest):
1. File content (if --file provided)
2. Explicit description argument
3. Recent conversation messages
4. Fallback to timestamp-based name

# Apply conventional prefixes based on agent analysis:
analyze_context() {
  # project-orchestrator determines prefix
  if [[ $work_type == "bug" ]]; then
    prefix="fix"
  elif [[ $work_type == "feature" ]]; then
    prefix="feature"
  elif [[ $work_type == "documentation" ]]; then
    prefix="docs"
  elif [[ $work_type == "performance" ]]; then
    prefix="perf"
  elif [[ $work_type == "refactoring" ]]; then
    prefix="refactor"
  else
    prefix="feature"  # Default
  fi
}
```bash

### Phase 3: Branch Creation & Verification

```bash
# Create and switch to new branch
git checkout -b "$branch_name"

# Set upstream tracking if remote exists
git push -u origin "$branch_name" 2>/dev/null || true

# Verify success
git branch --show-current
git log --oneline -3
```bash

## Context Extraction Examples

### From Conversation

```text
User: "Need to fix the login timeout issue that's affecting mobile users"
Branch: fix/login-timeout-issue

User: "Let's implement OAuth authentication for third-party logins"
Branch: feature/oauth-authentication

User: "Working on JIRA-456 to add payment processing"
Branch: feature/JIRA-456-payment-processing
```bash

### From File Content

```text
File: bug-report.md containing "SQL injection vulnerability in user search"
Branch: fix/sql-injection-user-search

File: feature-spec.md containing "Real-time notifications system"
Branch: feature/realtime-notifications

File: performance.md containing "Database query optimization"
Branch: perf/database-query-optimization
```bash

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
```bash

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
```bash

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
```bash

### File-Based Context

```bash
User: /branch --file bug-report.md
Claude: 📖 Reading bug-report.md...
🔍 Detected: Bug report about memory leak
🔄 Updating main branch...
🌿 Creating branch: fix/memory-leak
✅ Created and switched to fix/memory-leak
```bash

### Conversation Context

```bash
User: Need to optimize the database queries, they're really slow
User: /branch
Claude: 🔍 Analyzing conversation context...
💡 Detected: Performance optimization work
🔄 Updating main branch...
🌿 Creating branch: perf/database-queries
✅ Created and switched to perf/database-queries
```bash

## Notes

- Always starts from updated main/master branch
- Handles uncommitted changes by stashing
- Resolves naming conflicts automatically
- Supports all major ticket numbering systems
- Includes execution verification for reliability
- Maintains git-flow conventions for team consistency
