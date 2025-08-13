# /review Command

## Description
Pre-commit code review that catches issues before you create a PR. Focuses on code quality, security, and maintainability.

## Usage
```
/review [file_or_directory]
```

## Behavior
1. **Scans changed code**: Reviews uncommitted changes or specified files
2. **Finds real issues**: Security vulnerabilities, performance problems, bugs
3. **Provides fixes**: Actionable suggestions with code examples
4. **Rates PR readiness**: Clear go/no-go decision

## Review Categories
- **Critical**: Security issues, bugs that will break production
- **Important**: Performance problems, maintainability issues  
- **Style**: Formatting, naming conventions, best practices

## Output Format
```
✅ READY FOR PR
🔴 CRITICAL ISSUES (2)
🟡 IMPROVEMENTS (3)

CRITICAL:
- SQL injection risk in user.js:42
  Fix: Use parameterized queries
  
- Memory leak in component.tsx:15
  Fix: Add cleanup in useEffect
```

## Examples
```bash
/review                     # Review all changes
/review src/auth.js        # Review specific file
/review src/components/    # Review directory
```

## Value
- **Catches bugs early**: Before they reach PR review
- **Prevents security issues**: SQL injection, XSS, auth bypass
- **Saves review time**: Cleaner PRs for human reviewers
- **Improves code quality**: Consistent standards enforcement

## When to Use
- Before committing changes
- After major refactoring
- For security-sensitive code
- When unsure about code quality