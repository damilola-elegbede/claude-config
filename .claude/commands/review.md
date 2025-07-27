# /review Command

## Description
Runs comprehensive code review using the code-reviewer agent to check code quality, style compliance, and production readiness before creating pull requests.

## Usage
```
/review [file_path|directory]
```

## Arguments
- `file_path|directory` (optional): Specific file or directory to review. If omitted, reviews all changes in the current branch.

## Behavior
When you use `/review`, I will:

1. **Determine review scope**:
   - If path provided: Review specific file/directory
   - If no path: Review all uncommitted changes and branch differences
   
2. **Launch code-reviewer agent** to analyze:
   - Code quality and maintainability
   - Style guide compliance
   - Best practices adherence
   - Security patterns
   - Performance considerations
   - Test coverage quality
   
3. **Coordinate with other quality agents** if needed:
   - qa-tester for test coverage analysis
   - security-auditor for security concerns
   - performance-engineer for performance issues
   
4. **Generate comprehensive report** including:
   - Overall code quality assessment
   - Specific issues by category
   - Actionable improvement suggestions
   - PR readiness evaluation

## Examples
```
/review                          # Review all changes in current branch
/review src/api/auth.js         # Review specific file
/review src/components/         # Review entire directory
/review --staged               # Review only staged changes
```

## Quality Checks
- **Style**: Formatting, naming conventions, file organization
- **Best Practices**: Design patterns, error handling, logging
- **Maintainability**: Code complexity, documentation, modularity  
- **Security**: Input validation, authentication, data handling
- **Performance**: Algorithm efficiency, resource usage, caching
- **Testing**: Test coverage, test quality, edge cases

## Output Format
The review provides:
1. **Summary**: Overall assessment and PR readiness
2. **Critical Issues**: Must-fix before merge
3. **Warnings**: Should-fix for code quality
4. **Suggestions**: Nice-to-have improvements
5. **Positive Feedback**: Well-implemented patterns

## Integration
- Works with git hooks for pre-commit reviews
- Integrates with CI/CD pipelines
- Supports custom linting rules
- Respects .eslintrc, .prettierrc, etc.

## Prerequisites
- Git repository (for branch comparisons)
- Code files to review
- Optional: Linting configuration files

## Notes
- Review depth scales with code complexity
- Focuses on actionable feedback
- Balances thoroughness with pragmatism
- Learns from previous reviews in the project