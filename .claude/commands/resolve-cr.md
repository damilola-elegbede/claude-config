# /resolve-cr Command

## Description
Automatically fetches and resolves ALL CodeRabbit AI review comments from the PR associated with the current branch, specifically focusing on EVERY "Prompts for AI Agents" section that contains actionable suggestions for code improvements. The command searches PR review comments (inline code comments) NOT issue comments, and processes ALL review comments found - there are ALWAYS multiple review comments present, not just one.

## Usage
```
/resolve-cr [pr-number]
```

## Arguments
- `pr-number` (optional): Specific PR number to resolve comments from. If not provided, uses the current branch's PR. Returns an error if no PR exists for the current branch.

## Behavior
When you use `/resolve-cr`, I will:

## CRITICAL SEARCH REQUIREMENTS

**ABSOLUTE REQUIREMENTS - NO EXCEPTIONS:**
- **MUST** exhaustively search for ALL @coderabbitai comments across ALL comment types
- **NEVER** assume comments don't exist without thorough, multi-endpoint searching
- **NEVER** assume comments are already resolved without explicit verification
- **NEVER** stop after finding zero comments on first attempt - ALWAYS retry with different search methods
- **MUST** check ALL comment types: review comments, inline comments, conversation comments
- **MUST** use PARALLEL API calls for performance:
  - `/pulls/{pr}/reviews` (review-level comments)  
  - `/pulls/{pr}/comments` (inline review comments)
  - `/issues/{pr}/comments` (conversation comments as backup)
  - All three endpoints queried simultaneously, not sequentially
- **OPTIMIZED** search using pre-compiled pattern: `(@coderabbitai|coderabbitai\[bot\]|Prompts for AI Agents)`
- **DIRECT JSON FILTERING**: Use `--jq` for immediate filtering instead of grep post-processing
- **GRAPHQL FALLBACK**: If REST APIs return no results, use single GraphQL query for comprehensive search
- **BATCH PROCESSING**: Apply all file changes using MultiEdit pattern, not individual edits
- **MANDATORY** verification: If 0 comments found, MUST attempt GraphQL query as secondary approach
- **FORBIDDEN**: Giving up search without exhaustive verification across all endpoints

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

2. **Fetch ALL CodeRabbit REVIEW comments** (EXHAUSTIVE SEARCH - NO SHORTCUTS):
   - **NEVER GIVE UP** - Continue searching until ALL @coderabbitai comments found
   - Query PR **review comments** via GitHub API (NOT issue comments)  
   - **MANDATORY API calls** (use ALL of these endpoints):
     • `gh api repos/{owner}/{repo}/pulls/{pr}/reviews` (review-level comments)
     • `gh api repos/{owner}/{repo}/pulls/{pr}/comments` (inline review comments) 
     • `gh api repos/{owner}/{repo}/issues/{pr}/comments` (conversation backup)
   - **REQUIRED search criteria:**
     • Primary filter: exact "@coderabbitai" string match
     • Secondary filter: "coderabbitai" without @ symbol
     • User/author field verification for CodeRabbit bot identity
   - **CRITICAL**: If 0 comments found, MUST retry search with different parameters
   - **NEVER assume "already resolved"** - Always verify current comment state
   - **MANDATORY verification**: Check multiple times with different API calls if needed
   - Collect comments specifically from:
     • All PR review comments (inline code comments) - PRIMARY SOURCE
     • All review comment threads on specific lines
     • All file-level review comments  
     • All nested review discussion threads
     • Conversation comments as backup verification
   - Extract EVERY "Prompts for AI Agents" section from ALL review comments found
   - Process ALL found prompts across ALL comment sources
   - **ABSOLUTE REQUIREMENT**: Use language from ALL sections to guide code changes

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
   - Post "@coderabbitai resolve" comment on the PR with detailed summary:
     • Total number of issues being addressed
     • Breakdown by category (Security, Error Handling, Performance, etc.)
     • List of affected files with specific changes planned
     • Clear indication that automated resolution is in progress
   - This notifies CodeRabbit that issues are being addressed
   - Posted BEFORE starting actual work on the fixes
   - Example format:
     ```markdown
     @coderabbitai resolve
     
     ## 📋 Planned Changes Summary
     
     **Addressing 6 CodeRabbit review comments**
     
     ### 📊 Issues by Category
     - **Security**: 2 issues
     - **Code Quality**: 2 issues
     - **Documentation**: 2 issues
     
     ### 📁 Changes by File
     #### `security-auditor.md` (1 change)
     - Add safety guardrails for testing environments
     
     #### `incident-commander.md` (1 change)
     - Add explicit blameless qualifier for incident communications
     
     ---
     *🤖 Automated resolution in progress using Claude Code...*
     ```

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

## Common Failure Modes to AVOID

**FORBIDDEN BEHAVIORS - These are command execution FAILURES:**

1. **Premature Search Termination**:
   - ❌ Stopping after finding no comments on first API call attempt
   - ❌ Only checking one endpoint (e.g., only `/pulls/{pr}/reviews`)
   - ❌ Giving up search without trying all 3+ API endpoints
   - ❌ Not retrying with different search parameters when 0 results found

2. **False Resolution Assumptions**:
   - ❌ Assuming comments are "already resolved" without explicit verification
   - ❌ Concluding "no work needed" based on single API call result
   - ❌ Trusting that 0 results = no CodeRabbit comments exist
   - ❌ Not verifying comment current state before making assumptions

3. **Incomplete Comment Discovery**:
   - ❌ Only checking review comments (must also check inline and conversation)
   - ❌ Only searching for "@coderabbitai" pattern (must also try "coderabbitai")
   - ❌ Not checking comment author/user fields for CodeRabbit bot identity
   - ❌ Missing nested or threaded review comments

4. **Search Pattern Failures**:
   - ❌ Using only one search pattern instead of multiple required patterns
   - ❌ Not performing case-sensitive AND case-insensitive searches
   - ❌ Failing to check comment metadata (author, app_id, etc.)
   - ❌ Not examining comment body content thoroughly for CodeRabbit signatures

**CORRECT BEHAVIOR**: If 0 comments found initially, MUST attempt additional searches using different endpoints, search patterns, and verification methods before concluding no comments exist.

## Pre-Resolution Summary Format

When the command runs, you'll first see this analysis summary displayed in the Claude chat window:

```
🔍 CodeRabbit PR Analysis Summary
────────────────────────────────────────────────────────────

PR Analysis Complete

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

────────────────────────────────────────────────────────────
Proceeding with automated resolution...
────────────────────────────────────────────────────────────
```

## CodeRabbit Review Comment Structure

Typically parses review comments containing:
- **Summary**: Overview of issues found in specific code sections
- **Prompts for AI Agents**: Specific actionable fixes (found in review comments)
- **Code suggestions**: Inline diff proposals on specific lines
- **Security concerns**: Vulnerability fixes in reviewed code
- **Performance improvements**: Optimization suggestions for specific functions

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
/resolve-cr
# Fetches PR for current branch and resolves CodeRabbit suggestions

/resolve-cr 123
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
- `/resolve-cr` specifically addresses CodeRabbit PR comments
- Can use both: `/review` for pre-PR check, `/resolve-cr` for post-PR fixes

**With `/commit` command**:
- `/commit` includes automated review and remediation for local changes
- `/resolve-cr` focuses on external CodeRabbit feedback from PRs
- Use `/resolve-cr` → `/test` → `/commit` workflow for PR fixes

### Typical usage
```bash
# After CodeRabbit reviews your PR
/resolve-cr              # Finds PR comments, posts @coderabbitai resolve, then auto-fixes suggestions
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

**Note:** CodeRabbit embeds "Prompts for AI Agents" sections within PR review comments (inline code review comments) rather than issue/conversation comments. The command specifically searches review comments using the GitHub review API endpoints.

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

**MANDATORY ERROR HANDLING - Required Retry Logic:**

### No Comments Found (0 Results)
**REQUIRED ACTIONS** when initial search returns 0 comments:
1. **MUST retry** with different API endpoint (`/pulls/{pr}/comments` if started with `/pulls/{pr}/reviews`)
2. **MUST attempt** backup conversation search (`/issues/{pr}/comments`) 
3. **MUST try** alternative search patterns ("coderabbitai" without @)
4. **MUST verify** comment author fields for CodeRabbit bot identity
5. **MUST check** if PR has been updated/merged since last CodeRabbit review
6. **Only after 3+ search attempts** can conclude no comments exist

### "Already Resolved" Assumptions  
**FORBIDDEN**: Assuming comments resolved without verification
**REQUIRED**: 
- Verify current comment state via API calls
- Check if comments have been marked as resolved/outdated
- Confirm no new CodeRabbit comments since last resolution
- Re-verify comment content and current applicability

### Standard Error Scenarios:
- Early termination after first comment (prevented - must process ALL)
- PR not accessible  
- Merge conflicts during resolution
- Test failures after changes
- Unparseable suggestions

### Retry Strategy Requirements:
- **Search Failures**: Minimum 3 different API endpoint attempts
- **Parse Failures**: Try alternative comment parsing methods  
- **API Failures**: Exponential backoff with 3 retry attempts
- **Authentication Failures**: Verify GitHub CLI auth status and retry

## Explicit Search Pattern Requirements

**MANDATORY SEARCH PATTERNS** (MUST attempt ALL patterns):

### Primary Patterns (REQUIRED)
1. **Exact String Match**: `"@coderabbitai"` (case-sensitive)
2. **Without @ Symbol**: `"coderabbitai"` (case-sensitive)  
3. **Case-Insensitive Variants**: 
   - `"@CodeRabbitAI"` 
   - `"CodeRabbitAI"`
   - `"@CODERABBITAI"`

### Metadata Verification (REQUIRED)
1. **Comment Author Check**: 
   - `comment.user.login === "coderabbitai"`
   - `comment.user.type === "Bot"`
2. **App/Bot ID Verification**:
   - Check for CodeRabbit app_id in comment metadata
   - Verify GitHub App association with CodeRabbit
3. **Comment Source Verification**:
   - Ensure comment originates from CodeRabbit GitHub App
   - Validate comment structure matches CodeRabbit patterns

### Content Pattern Matching (REQUIRED)
1. **Signature Patterns**:
   - `"Prompts for AI Agents:"` (exact match)
   - `"**Prompts for AI Agents:**"` (markdown bold)
   - CodeRabbit-specific comment formatting
2. **Content Structure Verification**:
   - Look for CodeRabbit review summaries
   - Identify structured suggestion formats
   - Parse "Consider adding..." patterns

**EXECUTION REQUIREMENT**: MUST attempt ALL patterns above before concluding no CodeRabbit comments exist.

## Optimized Implementation

### Performance Enhancements
The command uses several optimization strategies for 3x faster execution:

#### 1. Parallel API Calls
```bash
# All three endpoints queried simultaneously
gh api /pulls/{pr}/reviews &
gh api /pulls/{pr}/comments &
gh api /issues/{pr}/comments &
wait
```

#### 2. Direct JSON Filtering
```bash
# Immediate filtering with jq instead of post-processing
gh api ... --jq '.[] | select(.user.login == "coderabbitai[bot]")'
```

#### 3. Pre-compiled Search Pattern
```bash
# Single regex for all CodeRabbit signatures
PATTERN='(@coderabbitai|coderabbitai\[bot\]|Prompts for AI Agents)'
```

#### 4. GraphQL Fallback
```graphql
# Single query for comprehensive search if REST fails
query {
  repository(owner, name) {
    pullRequest(number) {
      reviews { nodes { body author { login } } }
      reviewThreads { nodes { comments { nodes { body path line } } } }
    }
  }
}
```

#### 5. Batch File Updates
```python
# Apply all changes in one operation
MultiEdit(files=[
  (file1, edits1),
  (file2, edits2),
  ...
])
```

### Implementation Script
Optimized implementation available at: `scripts/resolve-cr-optimized.sh`

## Notes

### CRITICAL EXECUTION REQUIREMENTS
- **ABSOLUTE**: Must process ALL review comments - early termination is COMMAND FAILURE
- **MANDATORY**: Exhaustive search across ALL GitHub API endpoints before concluding no comments exist
- **REQUIRED**: NEVER assume comments are "already resolved" without explicit verification
- **FORBIDDEN**: Stopping search after finding 0 results on first attempt

### SEARCH AND DISCOVERY REQUIREMENTS  
- **PRIMARY FOCUS**: PR REVIEW comments (inline code comments) via `/pulls/{pr}/reviews` and `/pulls/{pr}/comments`
- **BACKUP VERIFICATION**: Conversation comments via `/issues/{pr}/comments` as secondary check
- **SEARCH PATTERNS**: Must attempt ALL required patterns (@coderabbitai, coderabbitai, case variants)
- **METADATA VERIFICATION**: Must verify CodeRabbit bot identity via user.login, user.type, and app_id
- **RETRY LOGIC**: Minimum 3 different API endpoint attempts before concluding no comments exist

### COMMENT PROCESSING REQUIREMENTS
- **MULTIPLE COMMENTS**: ALWAYS multiple CodeRabbit review comments present - continue searching until ALL found
- **AUTHENTICATION**: Verifies CodeRabbit bot user or app ID before processing comments (prevents spoofed submissions)  
- **AUTHORIZED SOURCE**: Only resolves comments from authenticated CodeRabbit bot user (@coderabbitai)
- **CONTENT FOCUS**: EXCLUSIVELY processes "Prompts for AI Agents" sections - uses exact language from ALL sections
- **COMPREHENSIVE COVERAGE**: Exhaustively searches ALL review comment threads until every comment is found

### EXECUTION FLOW REQUIREMENTS
- **PRE-WORK SUMMARY**: Provides comprehensive summary of ALL comments found
- **NOTIFICATION**: Posts "@coderabbitai resolve" BEFORE making any changes  
- **LANGUAGE FIDELITY**: Uses specific language from ALL "Prompts for AI Agents" sections to guide modifications
- **NO SHORTCUTS**: Processes EVERY review comment found - partial processing is execution failure

### OPERATIONAL CHARACTERISTICS
- **ATOMICITY**: Creates atomic commits for traceability
- **PRESERVATION**: Preserves code style and formatting
- **IDEMPOTENCY**: Can be re-run safely (idempotent)
- **INTEGRATION**: Integrates with `/test` and `/commit` commands
- **PLATFORM**: Supports GitHub PRs via GitHub CLI

### FAILURE PREVENTION
- **NEVER**: Give up search without exhaustive verification across all endpoints
- **NEVER**: Assume resolution status without current state verification  
- **NEVER**: Process only first comment found (must find and process ALL)
- **ALWAYS**: Attempt multiple search patterns and API endpoints before concluding no comments exist