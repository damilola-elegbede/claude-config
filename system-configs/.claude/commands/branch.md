# /branch Command

## Description

Intelligently creates and switches to a new git branch based on context from the conversation or explicit input. Always starts from the latest main branch to ensure branches are up-to-date.

## Usage

```bash
/branch [context]
```

## Arguments

- `context` (optional): Description or context for the branch. If not provided, uses context from the current conversation window.

## Behavior

When you use `/branch`, I will:

1. **Switch to main and update**:
   - Checkout main/master branch
   - Pull latest changes from remote
   - Ensure local main is up-to-date

2. **Analyze context**:
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
```

### Using conversation context

```text
User: "I need to add a dark mode toggle to the settings page"
User: /branch
# Creates: feature/dark-mode-settings-toggle

User: "The API is returning 500 errors on user profile updates"
User: /branch
# Creates: fix/api-500-user-profile-updates
```

## Smart Context Analysis

The command analyzes multiple context sources:

1. **Explicit arguments** - Highest priority
2. **Recent conversation** - Last 5-10 messages
3. **Issue/ticket mentions** - JIRA, GitHub issues, etc.
4. **Code snippets** - Feature/component names
5. **Error messages** - For bug fix branches

## Integration with Other Commands

Typical workflow:

```bash
/branch implement oauth2 login    # Create feature branch
# ... make changes ...
/commit                           # Commit with review
/push                            # Push with quality gates
/pr                              # Create pull request
```

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
