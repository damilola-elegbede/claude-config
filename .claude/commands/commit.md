# /commit Command

## Description
Creates a git commit following Claude's standards with proper formatting and co-authorship attribution.

## Usage
```
/commit
```

## Behavior
When you use `/commit`, I will:

1. **Check repository status** by running:
   - `git status` to see untracked files
   - `git diff` to see staged and unstaged changes
   - `git log` to match repository's commit style

2. **Run STRICT MODE code review** using code-reviewer agent:
   - Execute ALL applicable linters (ESLint, Prettier, etc.) on staged files only
   - Analyze only staged changes (files in `git diff --cached --name-only`)
   - Enforce zero-tolerance quality standards for staged files
   - Block commit for ANY violations in staged files (no warnings)
   - Generate strict review report with required fixes for staged changes

3. **Automated review remediation** (NEW):
   - Deploy specialized agents to address review comments:
     - backend-engineer for API and server-side issues
     - frontend-architect for UI/UX and client-side problems
     - test-engineer for missing tests or coverage gaps
     - security-auditor for vulnerability fixes
     - performance-specialist for optimization issues
   - Agents work in parallel when possible
   - Each agent focuses on their domain expertise
   - Automatic re-review after fixes applied

4. **Rationale documentation**:
   - For issues that won't be fixed, document the reason:
     - User explicitly requested the implementation
     - Breaking change required for new feature
     - Performance trade-off accepted
     - Technical debt tracked for future sprint
   - Store rationale in commit message or `.review-rationale.md`
   - Include context for future maintainers

5. **Strict review gate enforcement**:
   - After remediation attempts, re-run code review
   - If issues remain with documented rationale: Proceed with warning
   - If issues remain without rationale: Block commit
   - Display final compliance report with fixes applied
   - Show any remaining issues with their rationales

6. **Analyze changes** to:
   - Summarize the nature of changes
   - Check for sensitive information
   - Draft a concise commit message
   - Include any review rationales if applicable

7. **Stage appropriate files**:
   - Add relevant untracked files
   - Include any files modified by remediation agents
   - Exclude files that shouldn't be committed

8. **Create commit** with:
   - Descriptive message following conventional format
   - Include review remediation summary if fixes were applied
   - Document any accepted issues with rationales
   - Claude co-authorship attribution:
     ```
     🤖 Generated with [Claude Code](https://claude.ai/code)
     
     Co-Authored-By: Claude <noreply@anthropic.com>
     ```

9. **Verify success** by checking git status after commit

## Commit Message Format
Follows conventional commit format:
- `type(scope): subject`
- Types: feat, fix, docs, style, refactor, test, chore
- Subject: imperative mood, lowercase, no period

## Examples
- `feat(settings): add dark mode toggle`
- `fix(auth): resolve login timeout issue`
- `docs(readme): update installation instructions`

## Enhanced Review & Remediation Process

### Automated Remediation Workflow
1. **Initial Review**: code-reviewer identifies all issues
2. **Agent Deployment**: Specialized agents fix issues in parallel:
   - **Linter Issues**: backend-engineer or frontend-architect auto-fix
   - **Test Gaps**: test-engineer writes missing tests
   - **Security**: security-auditor patches vulnerabilities
   - **Performance**: performance-specialist optimizes code
   - **Documentation**: tech-writer adds missing docs
3. **Re-Review**: Verify fixes resolved issues
4. **Rationale Check**: Document why any remaining issues are acceptable

### Review Requirements
The enhanced review enforces:
- **Linter Compliance**: Auto-fix or document rationale
- **Security**: Must fix all vulnerabilities (no exceptions)
- **Code Quality**: Fix complexity issues or justify design
- **Style Compliance**: Auto-format with tools
- **Test Coverage**: Add tests or document why not needed
- **Documentation**: Generate missing docs automatically
- **Performance**: Optimize or document trade-offs
- **Error Handling**: Add error handling or explain edge cases

### Review Outcomes
1. **100% Fixed**: All issues remediated → Commit proceeds
2. **Partial Fix + Rationale**: Some issues remain with valid reasons → Commit proceeds with documentation
3. **Unfixed Without Rationale**: Issues remain unexplained → Commit BLOCKED
4. **Security/Critical Issues**: Must be fixed (no rationale accepted) → Commit BLOCKED until resolved

## Prerequisites
- Git must be initialized in the repository
- Changes must exist (staged or unstaged)
- Code must pass review checks (no critical issues)

## Notes
- If pre-commit hooks modify files, the commit will be retried once
- Empty commits are not created
- Code review with automated remediation is mandatory
- Critical issues (security) must be fixed before commit
- Non-critical issues are auto-fixed or require rationale
- User explicitly requested features override style warnings
- All remediation attempts are tracked in commit message
- Review results displayed with fixes applied and rationales
