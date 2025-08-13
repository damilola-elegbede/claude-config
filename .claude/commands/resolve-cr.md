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

1. **Identify the target PR** from current branch or provided number
2. **Exhaustively search** for ALL CodeRabbit review comments
3. **Extract improvement suggestions** from "Prompts for AI Agents" sections
4. **Deploy specialized agents** to implement fixes
5. **Apply all changes** in organized commits
6. **Report completion** with summary of resolutions

## Search Strategy

### Comprehensive Comment Discovery

I search for CodeRabbit comments using multiple methods in parallel:

#### Primary Search Endpoints (Parallel Execution)
- `/pulls/{pr}/reviews` - Review-level comments
- `/pulls/{pr}/comments` - Inline review comments
- `/issues/{pr}/comments` - Conversation comments (backup)

#### Search Patterns
- Primary: `@coderabbitai` mentions
- Secondary: `coderabbitai[bot]` user comments
- Tertiary: `Prompts for AI Agents` sections

#### Search Verification
- **Never assume comments don't exist** after first attempt
- **Never assume comments are resolved** without verification
- **Always retry** with different methods if initial search returns empty
- **Use GraphQL** as fallback for comprehensive search

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

### Phase 2: Agent Deployment

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

### Phase 3: Implementation

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

### Phase 4: Commit Organization

I create organized commits:

```
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

```
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

## Error Handling

### Common Issues and Solutions

| Issue | Solution |
|-------|----------|
| No PR found for branch | Check if PR exists, provide PR number explicitly |
| No CodeRabbit comments | Verify CodeRabbit ran on PR, check PR status |
| API rate limit | Wait and retry, use authentication token |
| Merge conflicts | Resolve conflicts, then re-run command |
| Test failures after fix | Review changes, may need manual adjustment |

## Best Practices

1. **Run tests first** to ensure clean baseline
2. **Review changes** before committing
3. **Group related fixes** in single commits
4. **Document why** changes were made
5. **Verify no regressions** after applying fixes
6. **Check CI status** after pushing changes

## Notes

- CodeRabbit comments are typically found in PR review comments, not issue comments
- The command processes ALL comments found, not just unresolved ones
- Some suggestions may require human judgment and are flagged for manual review
- Complex architectural changes are identified but not automatically applied
- The command respects existing code style and conventions