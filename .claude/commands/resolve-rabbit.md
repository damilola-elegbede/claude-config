# /resolve-rabbit Command

## Description
Automatically fetches and resolves ALL CodeRabbit AI review comments from the PR associated with the current branch, specifically focusing on EVERY "Prompts for AI Agents" section that contains actionable suggestions for code improvements. The command exhaustively searches all comment levels and processes ALL comments found - there are ALWAYS multiple comments present, not just one.

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
   - Always look for the PR associated with the current branch first
   - Or use the specified PR number if provided
   - Verify PR exists and is accessible

2. **Fetch ALL CodeRabbit comments** (ALWAYS multiple comments present):
   - Query ALL PR comments via GitHub API (top-level, review, and nested)
   - Filter for CodeRabbit bot comments (@coderabbitai)
   - **IMPORTANT: Continue searching until ALL comments are found**
   - Do NOT stop after finding the first comment
   - Collect comments from:
     • All top-level PR comments
     • All review comment threads
     • All conversation items
     • All inline code review comments
     • All nested reply threads
   - Extract EVERY "Prompts for AI Agents" section from ALL comments
   - Process ALL found prompts, not just the first one
   - Use the language from ALL sections to guide code changes

3. **Present pre-resolution summary**:
   - Display total count of "Prompts for AI Agents" sections found
   - Show number of affected files
   - Categorize findings by type:
     • Security issues
     • Error handling gaps
     • Type safety problems
     • Performance improvements
     • Code quality issues
     • Documentation needs
   - List affected files with issue counts per file
   - Show priority distribution of issues

4. **Post initial resolution comment** (immediately after summary):
   - Post "@coderabbitai resolve" comment on the PR
   - This notifies CodeRabbit that issues are being addressed
   - Posted BEFORE starting actual work on the fixes

5. **Analyze ALL suggestions**:
   - Process EVERY "Prompts for AI Agents" section found
   - Group ALL suggestions by file (from all comments)
   - Identify priority fixes across ALL comments (security, bugs, performance)
   - Determine execution order for dependent changes
   - Use exact language from ALL "Prompts for AI Agents" sections

6. **Execute resolutions for ALL comments**:
   - Apply code changes from ALL "Prompts for AI Agents" sections
   - Follow the specific instructions in EVERY prompt section found
   - Address ALL comments, not just the first one
   - Run relevant tests after each batch of changes
   - Verify changes don't break existing functionality
   - Document what was changed from each comment

7. **Create final resolution summary**:
   - List all addressed comments
   - Show files modified
   - Highlight any suggestions that couldn't be auto-resolved
   - Prepare commit message summarizing fixes

## Pre-Resolution Summary Format

When the command runs, you'll first see:

```
═══════════════════════════════════════════════════════════
🔍 CodeRabbit PR Analysis Summary
═══════════════════════════════════════════════════════════

📊 Total "Prompts for AI Agents" sections found: 12
📁 Files affected: 5

📝 Issue Categories:
• Security issues: 2
• Error handling gaps: 4  
• Type safety problems: 3
• Performance improvements: 2
• Code quality issues: 1
• Documentation needs: 0

📂 Affected Files:
• src/api/user.ts (3 issues)
• src/services/auth.js (2 issues)
• lib/database.ts (4 issues)
• components/Dashboard.tsx (2 issues)
• utils/helpers.js (1 issue)

🎯 Priority Distribution:
• High (Security/Bugs): 6 issues
• Medium (Type safety/Performance): 5 issues
• Low (Code quality): 1 issue

═══════════════════════════════════════════════════════════
Proceeding with automated resolution...
═══════════════════════════════════════════════════════════
```

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
- Collects ALL comments before starting any work
- Groups ALL changes from ALL comments by file
- Applies changes from ALL comments to each file
- Runs file-specific tests after processing ALL comments for that file
- Commits ALL changes from ALL comments in logical chunks

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
/resolve-rabbit          # Finds PR comments, posts @coderabbitai resolve, then auto-fixes suggestions
/test                    # Verify fixes work
/commit                  # Commit the fixes
/push                    # Update PR
```

## Comment Parsing

Recognizes CodeRabbit patterns:
- "**Prompts for AI Agents:**" (may be nested within review comments)
- "Consider adding error handling..."
- "Missing null check for..."
- "Potential security issue..."
- "Performance could be improved by..."
- Inline code suggestions with diffs

**Note:** CodeRabbit may embed "Prompts for AI Agents" sections within nested review comments rather than top-level PR comments. The command searches all comment levels to find these sections.

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
- Early termination after first comment (prevented - must process ALL)
- PR not accessible
- Merge conflicts during resolution
- Test failures after changes
- Unparseable suggestions

## Notes
- **CRITICAL: Must process ALL comments, not just the first one found**
- ALWAYS multiple CodeRabbit comments present - continue searching until all are found
- Verifies CodeRabbit bot user or app ID before processing comments to prevent spoofed comment submissions
- Only resolves comments from authenticated CodeRabbit bot user (@coderabbitai)
- **EXCLUSIVELY processes "Prompts for AI Agents" sections** - uses exact language from ALL sections
- Exhaustively searches ALL comment levels until every comment is found
- Provides comprehensive summary of ALL comments THEN posts "@coderabbitai resolve" BEFORE making changes
- Uses the specific language from ALL "Prompts for AI Agents" sections to guide code modifications
- Processes EVERY comment found - early termination after first comment is a failure
- Creates atomic commits for traceability
- Preserves code style and formatting
- Can be re-run safely (idempotent)
- Integrates with `/test` and `/commit` commands
- Supports GitHub PRs (via GitHub CLI)
