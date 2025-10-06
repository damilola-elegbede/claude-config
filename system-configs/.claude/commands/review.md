---
description: Code review with linting and security scanning
argument-hint: [--full|--fix|--security|file-path]
---

# /review Command

## Usage

```bash
/review                          # Review changed files
/review --full                   # Full repository review
/review <file|directory>         # Review specific target
/review --fix                    # Auto-fix safe issues + commit
/review --security               # Security-focused analysis
```

## Description

Comprehensive code review combining automated linting tools, security scanning, and AI analysis. Runs available tools
directly and provides structured feedback with actionable recommendations.

## Behavior

### Default Mode - Changed Files Review

**What it does:** Reviews files changed since main branch

1. **Detect Changed Files**

   ```bash
   git diff --name-only main...HEAD
   ```

2. **Run Available Linters**
   - JavaScript/TypeScript: ESLint, Prettier
   - Python: Ruff, Pylint, Bandit
   - Go: golangci-lint
   - Security: Semgrep (if available)
   - Markdown: markdownlint
   - Shell: ShellCheck

3. **AI Analysis** (optional, for complex issues)
   - Deploy single code-reviewer agent if needed
   - Focus on architectural concerns and patterns
   - Identify issues tools can't catch

4. **Generate Report**
   - Structured findings by severity
   - File and line number references
   - Actionable fix recommendations

### Full Mode (--full)

**What it does:** Reviews entire repository

- Scans all source files
- Runs all available linters
- More comprehensive analysis
- Useful for audits and major refactors

### Fix Mode (--fix)

**What it does:** Automatically fixes safe issues

1. Run auto-fix for each available tool:

   ```bash
   npx eslint --fix .
   npx prettier --write .
   ruff check --fix .
   ```

2. Commit fixes if changes made:

   ```bash
   git add .
   git commit -m "fix: apply automated linting fixes"
   ```

3. Report remaining issues that need manual attention

### Security Mode (--security)

**What it does:** Security-focused review

1. **Run Security Tools**
   - Semgrep for vulnerability patterns
   - Bandit for Python security issues
   - npm audit / pip-audit for dependencies

2. **Security Analysis**
   - Deploy security-auditor agent for deep analysis
   - Focus on OWASP Top 10
   - Check for secrets and credentials
   - Validate input sanitization

3. **Report Security Findings**
   - Severity-based prioritization
   - CVE references where applicable
   - Remediation guidance

## Expected Output

### Standard Review

```text
User: /review
Claude: 🔍 Reviewing changed files...

📋 Changed Files: 3 files
  - src/api/auth.ts
  - src/utils/validator.ts
  - tests/auth.test.ts

🔧 Running Linters:
  ✅ ESLint: 2 issues found
  ✅ Prettier: All files formatted correctly
  ✅ TypeScript: No type errors

📊 Review Summary:

🟡 Medium Priority (2)
1. **Unused Variable** - src/api/auth.ts:45
   - Variable 'tempToken' declared but never used
   - Recommendation: Remove or use the variable

2. **Missing Error Handling** - src/api/auth.ts:67
   - Promise rejection not handled
   - Recommendation: Add .catch() or try/catch block

💡 Suggestions:
  - Consider adding JSDoc for public API functions
  - Test coverage looks good (95%)

✅ Overall: Good code quality with minor improvements needed
```

### Security Review

```text
User: /review --security
Claude: 🔒 Security-focused review...

🔧 Running Security Scanners:
  ✅ Semgrep: Scanning for vulnerabilities...
  ✅ npm audit: Checking dependencies...

🚨 Security Findings:

🔴 Critical (1)
1. **SQL Injection Risk** - src/database/queries.ts:34
   - Raw user input used in query: `SELECT * FROM users WHERE id = ${userId}`
   - Fix: Use parameterized queries
     ```typescript
     db.query('SELECT * FROM users WHERE id = ?', [userId])
     ```

🟡 Medium (1)

1. **Outdated Dependency** - package.json
   - lodash@4.17.20 has known vulnerability (CVE-2020-8203)
   - Fix: Update to lodash@4.17.21+

✅ No hardcoded secrets detected
✅ HTTPS used for all external requests
✅ Input validation present in API endpoints

```

⚠️ Action Required: Fix critical SQL injection before merge

### Auto-Fix Report

```text
User: /review --fix
Claude: 🔧 Auto-fixing safe issues...

Running Auto-Fixes:
  ✅ ESLint: Fixed 8 style issues
     • Removed 3 unused imports
     • Fixed 5 semicolon issues
  ✅ Prettier: Formatted 5 files
     • Consistent spacing applied
     • Line length normalized

📝 Committing auto-fixes...
✅ Commit created: fix: apply automated linting fixes

⚠️ Manual Fixes Still Needed (2):
  1. src/api/auth.ts:67 - Add error handling
  2. src/database/queries.ts:34 - Fix SQL injection risk

💡 Run `/review --security` for security analysis
```

## Tool Detection

### Automatic Language Detection

The command automatically detects and runs appropriate tools:

```yaml
JavaScript/TypeScript:
  - package.json present → Run ESLint, Prettier
  - tsconfig.json present → Run TypeScript compiler

Python:
  - *.py files present → Run Ruff, Pylint
  - requirements.txt present → Run pip-audit
  - Python security → Run Bandit

Go:
  - *.go files present → Run golangci-lint
  - go.mod present → Run go vet

Rust:
  - Cargo.toml present → Run clippy, rustfmt

General:
  - *.md files → Run markdownlint
  - *.sh files → Run ShellCheck
  - Always attempt Semgrep if installed
```

### Graceful Degradation

- If a tool isn't installed, it's skipped
- Command continues with available tools
- Reports which tools were used
- Suggests installing missing tools for better coverage

## AI Analysis Strategy

### When to Use code-reviewer Agent

Deploy single code-reviewer agent when:

- Linters found complex architectural issues
- Need pattern analysis across multiple files
- Require context-aware recommendations
- Analyzing design decisions

### Direct Execution (No Agent)

For simple reviews where linters provide sufficient feedback:

- Straightforward style issues
- Simple formatting problems
- Clear-cut best practice violations
- Basic type errors

**Decision criteria:** Use agent if linter findings require architectural context or span >3 files

## Report Format

### Structured Findings

```markdown
## Review Summary

🔴 Critical Issues (N)
1. [Issue type] - file:line
   - Description
   - Fix recommendation

🟠 High Priority (N)
1. [Issue type] - file:line
   - Description
   - Fix recommendation

🟡 Medium Priority (N)
1. [Issue type] - file:line
   - Description
   - Fix recommendation

## Prompts for AI Agents (if applicable)
- Actionable prompts for fixing complex issues
- Context for architectural improvements

## Tool Summary
- ESLint: X issues (Y auto-fixable)
- Prettier: Z files formatted
- Security: A vulnerabilities found

## Next Steps
1. Prioritized action items
2. Recommended follow-up commands
```

## Quality Standards

### Code Quality Checks

- Style consistency (linter rules)
- Type safety (TypeScript, type hints)
- Code complexity (cyclomatic complexity)
- Best practices adherence

### Security Checks

- Vulnerability scanning (Semgrep, Bandit)
- Dependency auditing (npm audit, pip-audit)
- Secret detection (patterns for API keys, passwords)
- Input validation verification

### Performance Checks

- Obvious performance anti-patterns
- N+1 query patterns
- Unnecessary re-renders (React)
- Memory leaks (event listeners)

## Notes

- Streamlined design focuses on running tools directly
- Uses single code-reviewer agent only when needed for context
- Fast execution: typically 30-60 seconds
- Leverages existing linting infrastructure
- Provides actionable, specific recommendations
- Auto-fix mode safely applies common fixes
- Security mode adds specialized vulnerability scanning
- Gracefully handles missing tools
- Clear severity-based prioritization
- Ready for CI/CD integration
