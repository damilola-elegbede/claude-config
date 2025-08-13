# /review Command

## Description

Performs comprehensive pre-commit code review using multiple specialized agents to catch issues before PR creation. Analyzes code quality, security vulnerabilities, performance issues, test coverage, and architectural concerns with actionable fix suggestions.

## Usage

```bash
/review [scope] [options]
```

## Arguments

- `scope` (optional): File, directory, or commit range to review
  - Default: All uncommitted changes
  - Examples: `src/auth.js`, `src/components/`, `HEAD~3`
- `--fix`: Automatically apply safe fixes
- `--security`: Deep security-focused review
- `--performance`: Performance-focused analysis
- `--strict`: Enforce highest quality standards

## Behavior

When you invoke `/review`, I will:

1. **Deploy code-reviewer agent** as primary coordinator
2. **Identify review scope** - uncommitted changes or specified files
3. **Deploy specialized agents** based on detected issues
4. **Perform multi-layer analysis** across all quality dimensions
5. **Generate actionable feedback** with specific fixes
6. **Provide PR readiness assessment** with clear go/no-go decision
7. **Optionally apply fixes** if requested

## Multi-Agent Review Process

### Primary Reviewer

- **code-reviewer**: Coordinates review, ensures completeness

### Specialist Reviewers (deployed as needed)

- **security-auditor**: Security vulnerabilities, OWASP Top 10
- **performance-specialist**: Performance bottlenecks, optimization
- **test-engineer**: Test coverage, test quality
- **principal-architect**: Architecture, design patterns
- **accessibility-auditor**: WCAG compliance, a11y issues
- **tech-writer**: Documentation, comments, naming

## Review Dimensions

### 1. Security Analysis

I check for:

#### Injection Vulnerabilities

- SQL injection risks
- Command injection
- XSS vulnerabilities
- Path traversal
- LDAP injection

#### Authentication & Authorization

- Weak authentication methods
- Missing authorization checks
- Session management issues
- Token handling problems
- Password policy violations

#### Data Protection

- Sensitive data exposure
- Insufficient encryption
- Insecure data storage
- PII handling issues
- Secrets in code

#### Configuration Security

- Insecure defaults
- Debug mode enabled
- Verbose error messages
- CORS misconfigurations

### 2. Code Quality Analysis

I evaluate:

#### Complexity Metrics

- Cyclomatic complexity
- Cognitive complexity
- Nesting depth
- Method length
- Class coupling

#### Maintainability

- Code duplication
- Dead code
- Unclear naming
- Missing abstractions
- Poor organization

#### Code Best Practices

- SOLID principles
- DRY violations
- Design patterns
- Error handling
- Resource management

### 3. Performance Analysis

I identify:

#### Algorithm Issues

- O(n²) or worse complexity
- Unnecessary loops
- Inefficient sorting
- Redundant computations

#### Database Performance

- N+1 queries
- Missing indexes
- Unnecessary joins
- Large result sets
- Lock contention

#### Memory Issues

- Memory leaks
- Large allocations
- Circular references
- Unbounded caches
- Resource cleanup

#### Frontend Performance

- Bundle size issues
- Render blocking resources
- Missing lazy loading
- Unnecessary re-renders
- Large DOM operations

### 4. Test Coverage Analysis

I verify:

#### Coverage Metrics

- Line coverage
- Branch coverage
- Function coverage
- Statement coverage

#### Test Quality

- Test isolation
- Assertion quality
- Edge case coverage
- Error path testing
- Mock appropriateness

#### Missing Tests

- Untested functions
- Uncovered branches
- Missing integration tests
- No error scenarios

### 5. Architecture Review

I assess:

#### Design Patterns

- Pattern appropriateness
- Consistency
- Over-engineering
- Under-abstraction

#### Dependencies

- Circular dependencies
- Tight coupling
- Interface violations
- Layer violations

#### Scalability

- Bottlenecks
- Single points of failure
- Resource limits
- Concurrency issues

## Issue Categorization

### Severity Levels

#### 🔴 Critical (Must Fix)

- **Security vulnerabilities** that could be exploited
- **Data loss risks** or corruption possibilities
- **Breaking changes** to public APIs
- **Legal/compliance** violations
- **Production crashes** waiting to happen

#### 🟠 High (Should Fix)

- **Performance degradation** >20%
- **Memory leaks** or resource issues
- **Poor error handling** that affects UX
- **Missing critical tests** for core functionality
- **Accessibility barriers** (WCAG AA violations)

#### 🟡 Medium (Consider Fixing)

- **Code smells** affecting maintainability
- **Minor performance** issues (<20% impact)
- **Incomplete documentation** for public APIs
- **Style inconsistencies** with project standards
- **Test coverage gaps** in non-critical paths

#### 🟢 Low (Nice to Have)

- **Formatting issues** (if no auto-formatter)
- **Minor naming** improvements
- **Optional optimizations**
- **Enhanced logging** suggestions
- **Comment improvements**

## Output Format

### Comprehensive Review Report

<!-- markdownlint-disable MD040 -->
```markdown
## Code Review Report

### 📊 Summary
- **Files Reviewed**: 12
- **Lines Analyzed**: 1,450
- **Issues Found**: 15 (2 critical, 5 high, 6 medium, 2 low)
- **Estimated Fix Time**: 2.5 hours
- **PR Readiness**: ❌ NOT READY (critical issues must be fixed)

### 🔴 Critical Issues (2)

#### 1. SQL Injection Vulnerability
**File**: `src/api/users.js:42-45`
**Issue**: Direct string concatenation in SQL query
```javascript
// Current (vulnerable):
const query = `SELECT * FROM users WHERE id = ${userId}`;

// Fix:
const query = 'SELECT * FROM users WHERE id = ?';
db.query(query, [userId]);
```

**Impact**: Allows database manipulation via malicious input
**References**: [OWASP SQL Injection](https://owasp.org/www-community/attacks/SQL_Injection)

#### 2. Authentication Bypass

**File**: `src/middleware/auth.js:15`
**Issue**: Weak token validation allows bypass

```javascript
// Current (vulnerable):
if (token && token.length > 0) { // Too permissive

// Fix:
if (token && jwt.verify(token, SECRET_KEY)) {
```

**Impact**: Unauthorized access to protected resources

### 🟠 High Priority Issues (5)

#### 1. Memory Leak in React Component

**File**: `src/components/Dashboard.jsx:23`
**Issue**: Event listener not cleaned up

```javascript
// Add cleanup:
useEffect(() => {
  const handler = (e) => handleResize(e);
  window.addEventListener('resize', handler);
  return () => window.removeEventListener('resize', handler); // Missing
}, []);
```

[Additional issues with fixes...]

### 🟡 Medium Priority Issues (6)

[List of maintainability and performance improvements...]

### 🟢 Low Priority Suggestions (2)

[Minor improvements and style issues...]

### ✅ What's Good

- Excellent test coverage in auth module (95%)
- Consistent error handling pattern
- Good separation of concerns
- Clear documentation in API endpoints

### 📈 Metrics Comparison

| Metric | Before | After (if fixed) | Target |
|--------|--------|------------------|--------|
| Security Score | 65/100 | 95/100 | >90 |
| Test Coverage | 78% | 78% | >80% |
| Complexity | 15.2 | 12.1 | <15 |
| Performance | B | A | A |

### 🔧 Auto-Fixable Issues

Run `/review --fix` to automatically fix:

- ✅ 4 formatting issues
- ✅ 2 import sorting issues
- ✅ 3 simple refactoring opportunities

### 📋 Next Steps

1. Fix 2 critical security issues immediately
2. Address 5 high priority issues before PR
3. Consider fixing medium issues for better quality
4. Run tests after fixes
5. Re-run `/review` to verify fixes

```
<!-- markdownlint-enable -->

## Fix Suggestions

### Automated Fixes

When using `--fix`, I automatically apply:

1. **Formatting corrections** using project formatter
2. **Import organization** and sorting
3. **Simple refactoring** (extract constants, remove dead code)
4. **Linting fixes** that don't change logic
5. **Type annotations** where obvious

### Manual Fix Guidance

For issues requiring human judgment, I provide:

1. **Exact code changes** with before/after examples
2. **Step-by-step instructions** for complex fixes
3. **Alternative approaches** with trade-offs
4. **Testing requirements** for the fix
5. **Documentation updates** needed

## Integration with Development Workflow

### Pre-Commit Hook

Integrate into git workflow:

```bash
# .git/hooks/pre-commit
#!/bin/bash
claude /review --strict
if [ $? -ne 0 ]; then
  echo "Code review failed. Fix issues before committing."
  exit 1
fi
```

### CI/CD Pipeline

Add as PR check:

```yaml
- name: Claude Code Review
  run: |
    claude /review \
      ${{ github.event.pull_request.base.sha }}..\
      ${{ github.event.pull_request.head.sha }}
    claude /review --security  # Additional security focus
```

### IDE Integration

Configure for on-save reviews:

- Review changed files automatically
- Show inline issue markers
- Provide quick-fix suggestions

## Review Profiles

### Security-Focused Review (`--security`)

- Deep vulnerability scanning
- Dependency vulnerability check
- Authentication/authorization audit
- Cryptography usage review
- Input validation verification

### Performance Review (`--performance`)

- Algorithm complexity analysis
- Database query optimization
- Memory usage profiling
- Frontend bundle analysis
- Caching opportunity identification

### Strict Review (`--strict`)

- Enforces all best practices
- Requires 90%+ test coverage
- No complexity above threshold
- Complete documentation required
- Zero security issues tolerated

## Success Metrics

Review effectiveness measured by:

- **Issue detection rate**: >90% of bugs caught
- **False positive rate**: <10% of warnings
- **Fix suggestion accuracy**: >95% correct
- **Time to review**: <30 seconds for most files
- **Developer satisfaction**: Helpful, not annoying

## Review Best Practices

1. **Review early and often** - Don't wait until PR time
2. **Fix critical issues immediately** - Security and bugs first
3. **Use --fix for simple issues** - Save time on formatting
4. **Review after major changes** - Catch issues early
5. **Combine with tests** - `/test` then `/review`
6. **Document why** - When ignoring suggestions

## Notes

- Reviews are non-blocking suggestions unless using --strict
- Security issues are always treated as critical
- Performance impacts are measured against baselines
- Test coverage requirements can be configured
- Reviews respect .eslintignore, .prettierignore, etc.
- Custom review rules can be added via configuration
