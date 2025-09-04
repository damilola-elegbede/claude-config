---
description: File GitHub issues from conversation context or explicit bug reports
argument-hint: "[description] [--priority high] [--labels label1,label2]"
---

# Command Purpose

Files GitHub issues directly from conversation context or explicit bug reports using the GitHub MCP server.
Extracts context automatically and creates professional bug reports with proper formatting and labels.

Use the following options when processing user input:
- Simple description: `/bug <description>`
- Set priority: `/bug --priority <level>` (low, medium, high, critical)
- Add specific labels: `/bug --labels <label1,label2>`
- Auto-assign: `/bug --assign <username>`

## Context

### Agent Orchestration

**Launch all these concurrently:** Specialized agents for comprehensive bug reporting:

```yaml
tech-writer:
  role: Format issue descriptions and documentation
  input: Bug context, error details, reproduction steps
  output: Professional bug report with clear formatting
  parallel_with: [security-auditor, project-orchestrator]

security-auditor:
  role: Scan issue content for sensitive information before GitHub submission
  input: Bug description, stack traces, environment details, reproduction steps
  output: Security clearance or redaction recommendations
  parallel_with: [tech-writer, project-orchestrator]

project-orchestrator:
  role: **Execute in parallel (not sequentially):** Coordinate bug workflow and prioritization
  input: Bug severity, component analysis, team assignments
  output: Workflow coordination, team notifications, priority setting
  parallel_with: [tech-writer, security-auditor]
```

### Input Validation

- Sanitizes issue descriptions to prevent injection attacks
- Escapes special characters in markdown content
- Validates label names against GitHub's allowed format
- Truncates titles to 256 characters if needed

### Auto-Classification Keywords

- `security`: "injection", "XSS", "authentication", "breach" → security label + high priority
- `performance`: "slow", "timeout", "memory", "CPU" → performance label
- `ui/ux`: "layout", "responsive", "design" → ui/ux label
- `documentation`: "readme", "docs", "guide" → documentation label
- Default: bug label

### Issue Template

```markdown
**Description:** [Issue summary]
**Steps to Reproduce:** [Auto-extracted or manual]
**Expected vs Actual:** [Behavior comparison]
**Environment:** [Branch, OS, versions from context]
**Context:** [Recent commits, modified files]
---
*Filed by Claude Code*
```

### GitHub Integration

**MCP Operations:**

- Uses `mcp__github_create_issue` with GITHUB_TOKEN from environment
- Auto-detects repository from `git remote get-url origin`
- Applies labels based on content analysis and custom flags
- Links to current branch and active PR when applicable

**Context Extraction:**

- **Branch Analysis**: `fix/` → bug, `feature/` → enhancement
- **Error Detection**: Parses stack traces and error messages from conversation
- **Git Context**: Recent commits, modified files, current branch
- **Environment**: OS, versions from package files, project details

### Workflow Features

**Branch Linking**: Automatically references current branch in issue
**PR Integration**: Links to active PR if detected via `gh pr view`
**Smart Labeling**:

- Standard: `bug`, `enhancement`, `documentation`, `security`, `performance`
- Priority: `priority: critical/high/medium/low`
- Component: `component: frontend/backend/api/database`

### Prerequisites

- GitHub repository (detected from `git remote`)
- GITHUB_TOKEN environment variable
- GitHub MCP server configured in settings

### Auto-Validation

- Repository access and permissions
- Title length limits (truncates if >100 chars)
- Label existence (creates missing labels)
- Issue creation success and URL accessibility

### Error Handling

- Missing GitHub CLI → Installation guidance
- Authentication issues → Login prompts with token setup instructions
- Non-GitHub repos → Clear error messages with repo initialization help
- Network failures → Automatic retry with exponential backoff (3 attempts)
- Invalid token → Returns "Error: GitHub authentication failed. Set GITHUB_TOKEN environment variable"
- Rate limiting → Returns "Error: GitHub API rate limit exceeded. Try again in X minutes"
- Permission denied → Returns "Error: Insufficient permissions to create issues in this repository"

## Expected Output

Creates GitHub issues using `mcp__github_create_issue` with automatic context extraction from conversation
history, git status, current branch, and recent commits. Applies intelligent labeling and formatting based on
issue content. Returns the created issue number (e.g., "#123") immediately after successful creation for
tracking and reference.

### Examples

```bash
# Simple bug report
/bug Login form doesn't validate emails properly
→ Creates issue with bug label, extracts context from git/conversation
→ Returns: "Created issue #247 in owner/repo"

# Security issue with priority
/bug --priority critical --labels security SQL injection in user search
→ Creates high-priority security issue with proper labeling
→ Returns: "Created issue #248 (critical security) in owner/repo"

# From conversation context
User: "API timeouts after recent changes"
/bug
→ Analyzes conversation, detects performance issue, creates labeled issue
→ Returns: "Created issue #249 (performance) in owner/repo"

# Error scenarios
/bug Authentication broken
→ If GITHUB_TOKEN missing: "Error: GitHub authentication failed. Set GITHUB_TOKEN environment variable"
→ If network issue: "Retrying... (attempt 2/3)" then creates issue or fails with clear message
→ If rate limited: "Error: GitHub API rate limit exceeded. Try again in 47 minutes"
```

### Execution Verification

Deploy execution-evaluator to verify:

- ✅ **Issue created** - GitHub issue successfully created with valid issue number
- ✅ **Context extracted** - Repository context and conversation history analyzed
- ✅ **Labels applied** - Appropriate labels assigned based on content analysis
- ✅ **Format validated** - Professional issue format with proper markdown
- ✅ **Return value** - Issue number returned for tracking and reference
- ✅ **Authentication verified** - GitHub MCP server authentication successful
- ✅ **Repository access** - Proper permissions confirmed for issue creation

### Integration Notes

Uses GitHub MCP server (`mcp__github_create_issue`) with existing authentication. Auto-detects context from
git state, conversation history, and file changes. Creates professional issues with smart labeling and proper
markdown formatting. Returns the created issue number (e.g., "#123") upon successful creation for easy
reference and tracking.