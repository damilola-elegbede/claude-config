# /commit Command

## Description

Creates a git commit following Claude's standards with proper formatting
and co-authorship attribution.

## Usage

```bash
/commit
```

## Behavior

When you use `/commit`, I will:

1. **Check repository status** by running:
   - `git status` to see untracked files
   - `git diff` to see staged and unstaged changes
   - `git log` to match repository's commit style

2. **Run ENHANCED code review** using code-reviewer agent:
   - Execute ALL applicable linters (ESLint, Prettier, etc.) on staged files only
   - Analyze only staged changes (files in `git diff --cached --name-only`)
   - Identify all quality issues in staged files
   - Generate comprehensive review report with required fixes for staged
     changes

3. **Automated review remediation**:
   - Deploy specialized agents to address review comments:
     - backend-engineer for API and server-side issues
     - frontend-architect for UI/UX and client-side problems
     - test-engineer for missing tests or coverage gaps
     - security-auditor for vulnerability fixes
     - performance-specialist for optimization issues
     - tech-writer for missing documentation
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

5. **Smart review gate enforcement**:
   - After remediation attempts, re-run code review
   - **Critical issues** (security, breaking changes): Must be fixed
     (commit blocked until resolved)
   - **Non-critical issues** with documented rationale: Proceed with warning
   - **Non-critical issues** without rationale: Block commit until justified
   - Display final compliance report with fixes applied and rationales

6. **Analyze changes** to:
   - Summarize the nature of changes
   - Check for sensitive information
   - Draft a concise commit message
   - Include any review rationales if applicable

7. **Clean up and stage appropriate files**:
   - **Clean up temporary files** before staging:
     - Remove temporary HTML files (\*.tmp.html, \*.temp.html)
     - Delete temporary script files (\*.tmp.js, \*.temp.py, \*.tmp.sh)
     - Clean up generated documentation (if not meant for commit)
     - Remove build artifacts and cache files
     - Delete debug/test output files
   - Add relevant untracked files that should be committed
   - Include any files modified by remediation agents
   - Exclude files that shouldn't be committed (per .gitignore and common patterns)
   - **Automatic cleanup patterns**:
     - `*.tmp`, `*.temp`, `*.bak`, `*.orig`
     - `debug_*.html`, `test_output_*.txt`
     - `.DS_Store`, `Thumbs.db`
     - Node modules, build directories (if not in .gitignore)
     - IDE-generated files (`.vscode/`, `.idea/` if not intended)
     - Log files (`*.log`, `*.out`)
     - Coverage reports and temp test files (unless explicitly needed)

8. **Create commit** with:
   - Descriptive message following conventional format
   - Include review remediation summary if fixes were applied
   - Document any accepted issues with rationales
   - Claude co-authorship attribution:

     ```text
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

## File Cleanup Process

Before staging files for commit, the command automatically cleans up temporary and unwanted files:

### Automatic Cleanup Patterns

The following files are automatically detected and removed:

**Temporary Files**:

- `*.tmp`, `*.temp`, `*.bak`, `*.orig`
- `*.tmp.html`, `*.temp.html`, `*.tmp.js`, `*.temp.py`
- `debug_*.html`, `test_output_*.txt`, `scratch_*.md`

**System Files**:

- `.DS_Store`, `Thumbs.db`, `desktop.ini`
- `*.swp`, `*.swo`, `*~` (editor temp files)

**Build/Cache Artifacts** (if not in .gitignore):

- `node_modules/`, `dist/`, `build/`, `.cache/`
- `*.pyc`, `__pycache__/`, `.pytest_cache/`
- Coverage reports: `coverage/`, `.nyc_output/`

**Development Files**:

- IDE configs: `.vscode/settings.json`, `.idea/` (if not project-specific)
- Log files: `*.log`, `*.out`, `debug.txt`
- Test outputs: `test-results/`, `reports/`

### Smart Cleanup Logic

- **Preserve intentional files**: Files explicitly tracked in git are never cleaned
- **Respect .gitignore**: Uses existing ignore patterns as guidance
- **Project-aware**: Recognizes framework-specific temp files (React, Vue, Node, Python, etc.)
- **User confirmation**: Asks before removing files that might be important
- **Backup before delete**: Creates `.cleanup-backup/` for recovered files if needed

### Cleanup Override

Use these patterns to prevent cleanup of specific temp files:

- Add to `.gitkeep-temp` file in project root
- Use `# KEEP` comment in file header
- Prefix filename with `keep_` (e.g., `keep_temp_analysis.html`)

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
- **Test Coverage**: Maintain minimum 80% coverage on critical paths
  (coverage < 80% triggers remediation or requires documented justification)
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

- **Automatic file cleanup** removes temporary files before staging (with safety checks)
- If pre-commit hooks modify files, the commit will be retried once
- Empty commits are not created
- Enhanced code review with automated remediation is mandatory
- **Critical issues** (security, breaking changes) must be fixed before commit
- **Non-critical issues** are auto-fixed when possible or require documented rationale
- User explicitly requested features can override style warnings with justification
- All remediation attempts and rationales are tracked in commit message
- Final review results displayed with applied fixes and accepted rationales
- Cleanup creates backups of removed files in `.cleanup-backup/` directory for 24 hours
- Files explicitly tracked in git are never removed during cleanup
