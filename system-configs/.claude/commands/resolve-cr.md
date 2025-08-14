# /resolve-cr Command

## Description

Automatically fetches and resolves ALL CodeRabbit AI review comments from the PR associated with the current branch. Focuses on every "Prompts for AI Agents" section containing actionable code improvement suggestions.

## Usage

```bash
/resolve-cr [pr-number]
```

## Arguments

- `pr-number` (optional): Specific PR number to resolve comments from. If not provided, uses the current branch's PR.

## Behavior

When you invoke `/resolve-cr`, I will:

1. **Identify repository and target PR** from current branch or provided number
2. **Exhaustively search** for ALL CodeRabbit review comments
3. **Extract improvement suggestions** from "Prompts for AI Agents" sections
4. **Verify comment authenticity** with user confirmation
5. **Post PR comment** with "@coderabbitai resolve" and summary of fixes about to be addressed
6. **Deploy specialized agents** to implement fixes
7. **Apply all changes** in organized commits
8. **Report completion** with summary of resolutions
9. **Deploy execution-evaluator** to verify:
   - All CodeRabbit comments found and processed
   - Fixes correctly implemented
   - No code broken by changes
   - Commits created with proper messages
   - PR comment posted successfully

## Search Strategy

### Repository Identification

Before searching for comments, I must establish proper repository context:

1. **Extract repository owner/name** from git remote or current directory
2. **Verify repository exists** via GitHub API
3. **Confirm PR exists** and belongs to the identified repository
4. **Handle common issues**:
   - Fork vs upstream repository confusion
   - Private repository access requirements
   - Cross-organization PR references

### Comprehensive Comment Discovery

I search for CodeRabbit comments using multiple methods in prioritized order:

#### Primary Search Endpoints (Sequential Execution)

- `/pulls/{pr}/comments` - **Start here** - Inline review comments (most common location)
- `/pulls/{pr}/reviews` - Review-level comments
- `/issues/{pr}/comments` - Conversation comments (backup location)

#### Search Patterns

- Primary: `coderabbitai[bot]` user comments
- Secondary: `@coderabbitai` mentions in comment body
- Tertiary: `Prompts for AI Agents` section headers

#### Comment Verification Process

I verify found comments with the user:

1. **Display comment preview** with author, timestamp, and file location
2. **Show "Prompts for AI Agents" sections** found in each comment
3. **Request user confirmation** before proceeding with fixes
4. **Allow selective processing** if user wants to skip certain comments

#### Search Troubleshooting

Common issues and solutions:

- **Empty results**: Check different endpoints, verify repository access
- **JSON parsing errors**: Handle Unicode control characters with error recovery
- **Rate limits**: Use exponential backoff with retry-after headers
- **Pagination**: Always check for `next` links and process all pages
- **Authentication**: Ensure GitHub token has proper repository access

### Comment Types Processed

I process ALL comment types:

- **Inline code comments** on specific lines
- **File-level comments** on entire files
- **Review summary comments** at PR level
- **Discussion thread comments** in conversations
- **Nested reply comments** in threads

## Resolution Process

### Phase 1: Discovery and Analysis

I gather all CodeRabbit feedback:

1. **Fetch all comments** from all sources
2. **Extract actionable items** from "Prompts for AI Agents" sections
3. **Categorize by type**:
   - Security vulnerabilities
   - Performance optimizations
   - Code quality improvements
   - Missing tests
   - Documentation needs
   - Bug fixes
   - Style/formatting issues

### Phase 2: PR Notification

After finding and categorizing all CodeRabbit comments, I immediately:

1. **Post a comment on the PR** using `gh pr comment`:
   ```bash
   gh pr comment {pr-number} --body "@coderabbitai resolve
   
   ## Addressing CodeRabbit Review Comments
   
   Found {total} actionable items from CodeRabbit review. Now addressing:
   
   ### Security ({count} items)
   - {summary of security fixes}
   
   ### Performance ({count} items)
   - {summary of performance improvements}
   
   ### Code Quality ({count} items)
   - {summary of quality improvements}
   
   ### Tests ({count} items)
   - {summary of test additions}
   
   ### Documentation ({count} items)
   - {summary of documentation updates}
   
   Will apply these fixes in organized commits shortly."
   ```

2. **Wait for CodeRabbit acknowledgment** (optional, continue with fixes regardless)

### Phase 3: Agent Deployment

I deploy appropriate specialists based on issue type:

| Issue Type | Primary Agent | Supporting Agents |
|------------|---------------|-------------------|
| Security vulnerabilities | security-auditor | backend-engineer |
| Performance issues | performance-specialist | monitoring-specialist |
| Missing tests | test-engineer | code-reviewer |
| Code quality | code-reviewer | backend-engineer |
| Documentation | tech-writer | - |
| UI/UX issues | frontend-architect | ui-designer |
| API problems | api-architect | backend-engineer |
| Type errors | backend-engineer | - |

### Phase 4: Implementation

I apply fixes systematically:

1. **Group related changes** by file and type
2. **Apply fixes in logical order**:
   - Security fixes first
   - Breaking changes next
   - Quality improvements
   - Documentation updates last
3. **Use batch operations** for efficiency:
   - MultiEdit for multiple changes in same file
   - Parallel processing for independent files
4. **Validate each change**:
   - Ensure tests still pass
   - Verify no new issues introduced

### Phase 5: Commit Organization

I create organized commits:

```text
fix: address CodeRabbit security findings
- Fix SQL injection vulnerability in user query
- Add input validation for API endpoints
- Escape HTML in template rendering

refactor: improve code quality per CodeRabbit review
- Extract complex logic into separate functions
- Add type hints to all public methods
- Reduce cyclomatic complexity in auth module

test: add missing test coverage identified by CodeRabbit
- Add unit tests for error handling paths
- Add integration tests for new endpoints
- Increase coverage to meet 80% threshold

docs: update documentation per CodeRabbit suggestions
- Add API endpoint documentation
- Update README with new features
- Add inline comments for complex logic
```

## Resolution Categories

### Security Fixes

- Input validation
- SQL injection prevention
- XSS protection
- Authentication improvements
- Authorization checks
- Sensitive data handling

### Performance Optimizations

- Query optimization
- Caching implementation
- Algorithm improvements
- Memory leak fixes
- Lazy loading
- Bundle size reduction

### Code Quality

- Reduce complexity
- Extract methods
- Remove duplication
- Fix type issues
- Improve naming
- Add error handling

### Test Coverage

- Add unit tests
- Add integration tests
- Test edge cases
- Test error paths
- Add test documentation

### Documentation

- Add missing JSDoc/docstrings
- Update README
- Add inline comments
- Document APIs
- Add examples

## Output Format

After resolution, I provide:

```text
## CodeRabbit Resolution Summary

### Comments Processed
- Total comments found: 15
- Actionable items: 12
- Successfully resolved: 11
- Manual intervention needed: 1

### Changes Applied
#### Security (3 fixes)
✅ Fixed SQL injection in user.js
✅ Added input validation to api.js
✅ Escaped HTML in template.jsx

#### Performance (2 optimizations)
✅ Optimized database query in posts.js
✅ Added caching to expensive computation

#### Code Quality (4 improvements)
✅ Extracted complex logic in auth.js
✅ Reduced cyclomatic complexity
✅ Added type hints to utils.ts
✅ Removed code duplication

#### Tests (2 additions)
✅ Added unit tests for error cases
✅ Added integration test suite

### Manual Action Required
⚠️ Architecture change suggested in payment.js
   Requires team discussion before implementation

### Commits Created
- fix: address CodeRabbit security findings
- refactor: improve code quality per review
- test: add missing coverage per CodeRabbit
```

## Troubleshooting Guide

### Critical Error Resolution

| Issue | Root Cause | Solution |
|-------|------------|----------|
| **404 Not Found** | Wrong repository identified | Verify git remote, check repository access, confirm PR number |
| **Empty comment results** | Searching wrong endpoint | Try `/pulls/{pr}/comments` first, then `/pulls/{pr}/reviews` |
| **JSON parsing failure** | Unicode control characters | Use error recovery, strip invalid characters, request raw content |
| **Rate limit exceeded** | Too many API calls | Implement exponential backoff, use authenticated requests |
| **No "Prompts for AI Agents"** | CodeRabbit didn't generate suggestions | Verify CodeRabbit ran, check if PR has code changes |

### Verification Steps

Before processing comments:

1. **Confirm repository context**: Display "owner/repo" for user verification
2. **Show PR details**: Title, number, status, and branch information
3. **Preview found comments**: Author, timestamp, file location, and content snippet
4. **Validate suggestions**: Ensure "Prompts for AI Agents" sections contain actionable items

### Recovery Procedures

When searches fail:

1. **Try alternative endpoints** in sequence
2. **Check authentication** and repository access
3. **Verify PR exists** and is accessible
4. **Request manual comment URL** as fallback
5. **Offer to process specific files** if bulk search fails

## Best Practices

### Pre-Execution Checklist

1. **Verify repository context** before starting search
2. **Run tests first** to ensure clean baseline
3. **Check git status** for uncommitted changes
4. **Confirm PR is current** and contains recent CodeRabbit reviews

### During Execution

1. **Always show found comments** for user verification
2. **Post "@coderabbitai resolve" comment** immediately after verification
3. **Process comments in priority order** (security first)
4. **Group related fixes** in logical commits
5. **Validate each change** against original suggestion

### Post-Execution

1. **Review applied changes** before committing
2. **Run tests after each commit** to catch regressions
3. **Document resolution reasoning** in commit messages
4. **Check CI status** after pushing changes
5. **Verify CodeRabbit marks items as resolved** (if applicable)

## Important Notes

### Critical Success Factors

- **Repository identification is essential** - 404 errors are usually caused by wrong repository context
- **Start with `/pulls/{pr}/comments` endpoint** - this contains most CodeRabbit inline comments
- **Always verify comments with user** - prevents processing wrong or outdated suggestions
- **Post PR comment immediately** - notify CodeRabbit of resolution intent before starting fixes
- **Handle JSON parsing gracefully** - Unicode control characters can break parsing

### Processing Guidelines

- The command processes ALL comments found, not just unresolved ones
- Some suggestions may require human judgment and are flagged for manual review
- Complex architectural changes are identified but not automatically applied
- The command respects existing code style and conventions
- User confirmation is required before applying any changes

### Fallback Strategies

- If automated search fails, request direct comment URLs from user
- If repository access fails, verify authentication and permissions
- If no "Prompts for AI Agents" found, check if CodeRabbit ran successfully
- If JSON parsing fails, request raw comment content and process manually
