# /resolve-rabbit Command

## Description
Automatically fetches and resolves all CodeRabbit AI review comments from the current PR, specifically focusing on the "Prompts for AI Agents" section that contains actionable suggestions for code improvements.

## Usage
```
/resolve-rabbit [pr-number]
```

## Arguments
- `pr-number` (optional): Specific PR number to resolve comments from. If not provided, uses the current branch's PR. Returns an error if no PR exists for the current branch.

## Behavior
When you use `/resolve-rabbit`, I will:

**Agent Deployment**: Uses specialized agents for different fix types:
- `backend-engineer`: Server-side and API fixes
- `frontend-architect`: UI/UX and client-side fixes
- `test-engineer`: Missing test coverage
- `security-auditor`: Security vulnerability patches
- `performance-specialist`: Performance optimizations
- `tech-writer`: Documentation updates

**Workflow Steps**:

1. **Identify the PR**:
   - Use current branch's PR if no argument provided
   - Or use the specified PR number
   - Verify PR exists and is accessible

2. **Fetch CodeRabbit comments**:
   - Query PR comments via GitHub API
   - Filter for CodeRabbit bot comments
   - Extract "Prompts for AI Agents" sections
   - Parse actionable suggestions and code improvements

3. **Analyze suggestions**:
   - Group related suggestions by file
   - Identify priority fixes (security, bugs, performance)
   - Determine execution order for dependent changes

4. **Execute resolutions**:
   - Apply suggested code changes
   - Run relevant tests after each change
   - Verify changes don't break existing functionality
   - Document what was changed and why

5. **Create resolution summary**:
   - List all addressed comments
   - Show files modified
   - Highlight any suggestions that couldn't be auto-resolved
   - Prepare commit message summarizing fixes

## CodeRabbit Comment Structure

Typically parses comments containing:
- **Summary**: Overview of issues found
- **Prompts for AI Agents**: Specific actionable fixes
- **Code suggestions**: Inline diff proposals
- **Security concerns**: Vulnerability fixes
- **Performance improvements**: Optimization suggestions

## Resolution Categories

### Auto-resolvable
- Missing error handling
- Type safety issues
- Null/undefined checks
- Simple refactoring
- Import optimizations
- Dead code removal
- Documentation additions

### Requires Review
- Architectural changes
- Breaking API changes
- Complex refactoring
- Security-critical modifications
- Performance trade-offs

## Prerequisites

- GitHub CLI (`gh`) installed and authenticated
- Git repository with GitHub remote
- Valid PR associated with current branch (or specified PR number)
- Read/write access to the repository

## Examples

```bash
/resolve-rabbit
# Fetches PR for current branch and resolves CodeRabbit suggestions

/resolve-rabbit 123
# Fetches PR #123 and applies fixes to current branch
```

## Smart Resolution Features

### Priority Ordering
1. Security vulnerabilities
2. Bug fixes
3. Type safety issues
4. Performance improvements
5. Code style/quality
6. Documentation

### Batch Processing
- Groups related changes by file
- Applies all changes to a file at once
- Runs file-specific tests after changes
- Commits in logical chunks if many changes

### Safety Checks
- Creates backup branch before changes
- Runs tests after each file modification
- Reverts changes if tests fail
- Flags manual review needed items

## Integration Workflow

### Relationship to Other Commands

**With `/review` command**:
- `/review` performs general code review on local changes
- `/resolve-rabbit` specifically addresses CodeRabbit PR comments
- Can use both: `/review` for pre-PR check, `/resolve-rabbit` for post-PR fixes

**With `/commit` command**:
- `/commit` includes automated review and remediation for local changes
- `/resolve-rabbit` focuses on external CodeRabbit feedback from PRs
- Use `/resolve-rabbit` → `/test` → `/commit` workflow for PR fixes

### Typical usage
```bash
# After CodeRabbit reviews your PR
/resolve-rabbit          # Auto-fix CodeRabbit suggestions
/test                    # Verify fixes work
/commit                  # Commit the fixes
/push                    # Update PR
```

## Comment Parsing

Recognizes CodeRabbit patterns:
- "**Prompts for AI Agents:**"
- "Consider adding error handling..."
- "Missing null check for..."
- "Potential security issue..."
- "Performance could be improved by..."
- Inline code suggestions with diffs

## Commit Message Format

Auto-generated commits follow:
```
fix: address CodeRabbit review comments

- Add error handling to API calls
- Fix potential null reference in user service
- Improve type safety in data models
- Optimize database queries

Resolves CodeRabbit suggestions from PR #123
```

## Configuration

Respects settings for:
- Auto-commit after resolution
- Test running preferences
- Batch size for changes
- Manual review triggers
- Excluded file patterns

## Future Enhancements

Planned features (not yet implemented):
- Selective resolution by category
- Dry run mode for preview
- Interactive mode for manual approval
- File-specific resolution

## Error Handling

Handles common scenarios:
- No CodeRabbit comments found
- PR not accessible
- Merge conflicts during resolution
- Test failures after changes
- Unparseable suggestions

## Notes
- Only resolves comments from CodeRabbit bot user
- Focuses on "Prompts for AI Agents" section
- Creates atomic commits for traceability
- Preserves code style and formatting
- Can be re-run safely (idempotent)
- Integrates with `/test` and `/commit` commands
- Supports GitHub PRs (via GitHub CLI)
