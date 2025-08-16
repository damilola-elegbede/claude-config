# /branch Command

## Description

Intelligently creates and switches to a new git branch based on context from the conversation or explicit
input. Always starts from the latest main branch to ensure branches are up-to-date.

## Usage

```bash
/branch [context]
/branch --file <file_path>
/branch -f <file_path>
```

## Arguments

- `context` (optional): Description or context for the branch. If not provided, uses context from the current
  conversation window.
- `--file <file_path>` or `-f <file_path>` (optional): Read context from a file instead of using conversation context or explicit arguments.

## Behavior

When you use `/branch`, I will:

1. **Switch to main and update**:
   - Checkout main/master branch
   - Pull latest changes from remote
   - Ensure local main is up-to-date

2. **Analyze context**:
   - If --file or -f flag provided: Read and analyze file content for context
   - If explicit context provided: Use that for branch naming
   - If no argument: Analyze conversation context for:
     - Feature being discussed
     - Bug being fixed
     - Task being implemented
     - Issue number or ticket reference

3. **Generate intelligent branch name**:
   - Follow git-flow conventions (feature/, fix/, chore/, etc.)
   - Use kebab-case for branch names
   - Include ticket numbers if mentioned (e.g., feature/JIRA-123-user-auth)
   - Keep names concise but descriptive

4. **Create and switch to new branch**:
   - Create branch from updated main
   - Switch to the new branch
   - Set up tracking if needed

5. **Confirm branch creation**:
   - Show current branch status
   - Display branch creation summary
   - List recent commits from main

6. **Deploy execution-evaluator** to verify:
   - Branch created successfully with correct naming
   - Switched to new branch
   - Branch starts from latest main/master
   - Tracking configured if needed
   - No uncommitted changes lost

## File Input Processing

When using `--file <file_path>` or `-f <file_path>`:

1. **Read the entire file** using the Read tool
2. **Extract context** from the file content:
   - Issue descriptions or bug reports
   - Feature specifications or requirements
   - Task definitions or user stories
   - Technical design documents
   - Error logs or stack traces
3. **Analyze content type** to determine appropriate branch prefix:
   - Bug reports/errors → `fix/`
   - Feature specs → `feature/`
   - Documentation → `docs/`
   - Performance issues → `perf/`
   - Refactoring plans → `refactor/`
4. **Generate branch name** based solely on file content
5. **Ignore conversation context** when --file or -f is used (file is the sole source)

**Supported File Formats**:
- `.md` - Markdown documents
- `.txt` - Plain text files
- `.yaml`/`.yml` - YAML specifications
- `.json` - JSON data
- `.log` - Log files
- `.rst` - reStructuredText
- Any text-based format

## Branch Naming Conventions

### Automatic Prefixes

Based on context analysis:

- `feature/` - New functionality or enhancements
- `fix/` - Bug fixes or issue resolutions
- `chore/` - Maintenance, refactoring, or tooling
- `docs/` - Documentation updates
- `test/` - Test additions or modifications
- `perf/` - Performance improvements
- `style/` - Code style or formatting changes
- `refactor/` - Code restructuring without behavior change

### Name Generation Examples

| Context | Generated Branch Name |
|---------|----------------------|
| "Add user authentication" | `feature/user-authentication` |
| "Fix login timeout issue" | `fix/login-timeout` |
| "Update README" | `docs/update-readme` |
| "JIRA-456: Add payment gateway" | `feature/JIRA-456-payment-gateway` |
| "Refactor database queries" | `refactor/database-queries` |
| "Improve API performance" | `perf/api-optimization` |

## Examples

### With explicit context

```bash
/branch add stripe payment integration
# Creates: feature/stripe-payment-integration

/branch fix memory leak in worker process
# Creates: fix/memory-leak-worker-process

/branch PROJ-789 implement user notifications
# Creates: feature/PROJ-789-user-notifications
```yaml

### Using file input

```bash
/branch --file requirements/oauth-integration.md
/branch -f requirements/oauth-integration.md
# Reads OAuth feature spec, creates: feature/oauth-integration

/branch --file bugs/login-timeout.txt
/branch -f bugs/login-timeout.txt
# Reads bug report, creates: fix/login-timeout-issue

/branch --file tasks/JIRA-1234.yaml
/branch -f tasks/JIRA-1234.yaml
# Reads JIRA export, creates: feature/JIRA-1234-user-dashboard

/branch --file errors/production-crash.log
/branch -f errors/production-crash.log
# Reads error log, creates: fix/production-crash-nullpointer
```yaml

### File content examples

**Feature specification file** (requirements/payment.md):

```markdown
# Payment Gateway Integration
Implement Stripe payment processing for subscriptions...
```

→ Creates: `feature/stripe-payment-gateway`

**Bug report file** (bugs/api-error.txt):

```text
Users reporting 403 Forbidden errors when accessing profile endpoint
after recent deployment. Affects approximately 15% of requests...
```

→ Creates: `fix/api-403-profile-endpoint`

**Task definition file** (tasks/refactor.yaml):

```yaml
title: Refactor database connection pooling
type: technical-debt
description: Current connection pool implementation is inefficient...
```

→ Creates: `refactor/database-connection-pooling`

### Using conversation context

```text
User: "I need to add a dark mode toggle to the settings page"
User: /branch
# Creates: feature/dark-mode-settings-toggle

User: "The API is returning 500 errors on user profile updates"
User: /branch
# Creates: fix/api-500-user-profile-updates
```yaml

## Smart Context Analysis

The command analyzes multiple context sources in priority order:

1. **File input (--file or -f)** - Highest priority when provided
2. **Explicit arguments** - Direct context passed to command
3. **Recent conversation** - Last 5-10 messages
4. **Issue/ticket mentions** - JIRA, GitHub issues, etc.
5. **Code snippets** - Feature/component names
6. **Error messages** - For bug fix branches

When --file or -f is used, it becomes the sole source of context, overriding all other sources.

## Integration with Other Commands

Typical workflow:

```bash
/branch implement oauth2 login    # Create feature branch
# ... make changes ...
/commit                           # Commit with review
/push                            # Push with quality gates
/pr                              # Create pull request
```yaml

## Safety Features

- **Always from main**: Ensures branches start from latest stable code
- **Automatic fetch**: Gets latest remote changes before branching
- **Name validation**: Ensures git-compatible branch names
- **Duplicate prevention**: Warns if branch already exists
- **Context preservation**: Branch name reflects actual work being done

## Advanced Features

### Issue Integration

Automatically detects and includes:

- JIRA ticket numbers (PROJ-123)
- GitHub issue numbers (#456)
- Linear issue IDs (ENG-789)
- Shortcut story IDs (sc-1234)

### Multi-word Handling

Intelligently converts phrases:

- "User Profile Manager" → `user-profile-manager`
- "API v2 Migration" → `api-v2-migration`
- "iOS/Android Support" → `ios-android-support`

### Context Inference

Can understand intent from:

- Error stack traces → fix branch
- Feature descriptions → feature branch
- "Update docs" mentions → docs branch
- Performance discussions → perf branch

## Configuration

Respects repository settings:

- Branch naming conventions in `.gitmessage`
- Protected branch rules
- Team-specific prefixes
- Organization standards

## Notes

- Branch names are limited to 50 characters for readability
- Special characters are converted to hyphens
- Uppercase converted to lowercase
- Creates from main/master (configurable)
- Supports both GitHub Flow and Git Flow conventions
- Context window includes last 10 messages by default
- **File input**: When using --file or -f, the file content is the sole source for branch naming
- **File formats**: Any text-based file can be used as input
- **File paths**: Can be relative or absolute paths
- **Large files**: The entire file is read and analyzed for context extraction
