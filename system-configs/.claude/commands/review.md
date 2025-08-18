# /review Command

## Description

Multi-agent code review orchestrating specialized agents for comprehensive
quality validation across security, performance, testing, and accessibility
dimensions.

## Usage

```bash
/review                    # Review all changed files
/review <file|directory>   # Review specific target
/review --fix             # Auto-fix safe issues
/review --security        # Security-focused review
/review --performance     # Performance-focused review
```

## Agent Orchestration Strategy

### Standard Review (default)

**Parallel Agent Deployment:**

```yaml
Always Deployed:
  code-reviewer: "Code quality, patterns, maintainability analysis"
  security-auditor: "OWASP compliance, vulnerability detection"
  
Conditionally Deployed:
  test-engineer: "If test files present or coverage gaps detected"
  performance-specialist: "If performance issues or slow code detected"
  accessibility-auditor: "If frontend/UI files present (.jsx, .vue, .html)"
  
Coordination: All agents work simultaneously, results aggregated by severity
```

### Focused Reviews

```yaml
--security Mode:
  agents: [security-auditor, code-reviewer]
  focus: "OWASP Top 10, dependency vulnerabilities, secrets"
  
--performance Mode:
  agents: [performance-specialist, code-reviewer]
  focus: "Algorithm complexity, database queries, memory usage"
  
--fix Mode:
  agents: [code-reviewer + auto-remediation specialists]
  behavior: "Auto-apply safe fixes, report non-automatable issues"
```

## Review Categories & Examples

### Code Quality Issues

**Real Examples:**

```javascript
// ❌ Critical: Null pointer exception
function getUserEmail(user) {
  return user.email.toLowerCase(); // user could be null
}

// ✅ Fixed: Null safety
function getUserEmail(user) {
  return user?.email?.toLowerCase() || '';
}

// ❌ High: O(n²) complexity  
function findDuplicates(arr) {
  const duplicates = [];
  for (let i = 0; i < arr.length; i++) {
    for (let j = i + 1; j < arr.length; j++) {
      if (arr[i] === arr[j]) duplicates.push(arr[i]);
    }
  }
  return duplicates;
}

// ✅ Fixed: O(n) complexity
function findDuplicates(arr) {
  const seen = new Set();
  const duplicates = new Set();
  for (const item of arr) {
    if (seen.has(item)) duplicates.add(item);
    seen.add(item);
  }
  return Array.from(duplicates);
}
```

### Security Vulnerabilities

**Real Examples:**

```javascript
// ❌ Critical: SQL injection
const query = `SELECT * FROM users WHERE id = ${userId}`;

// ✅ Fixed: Parameterized query
const query = 'SELECT * FROM users WHERE id = ?';
db.query(query, [userId]);

// ❌ High: XSS vulnerability
document.innerHTML = `<div>${userInput}</div>`;

// ✅ Fixed: Proper escaping
document.textContent = userInput; // or use DOMPurify
```

### Performance Issues

**Real Examples:**

```python
# ❌ High: N+1 query problem
def get_user_posts(user_ids):
    users = []
    for user_id in user_ids:
        user = User.objects.get(id=user_id)  # N queries
        posts = Post.objects.filter(user=user)  # N more queries
        users.append({'user': user, 'posts': posts})
    return users

# ✅ Fixed: Single query with prefetch
def get_user_posts(user_ids):
    return User.objects.filter(id__in=user_ids)\
                      .prefetch_related('posts')\
                      .values('id', 'name', 'posts__title')
```

### Test Coverage Gaps

**Real Examples:**

```javascript
// ❌ High: Critical function untested
function processPayment(amount, cardToken) {
  if (amount <= 0) throw new Error('Invalid amount');
  return chargeCard(cardToken, amount);
}
// No tests exist for this critical payment function

// ✅ Required: Comprehensive test coverage
describe('processPayment', () => {
  test('throws error for negative amounts', () => {
    expect(() => processPayment(-10, 'token')).toThrow('Invalid amount');
  });
  
  test('throws error for zero amounts', () => {
    expect(() => processPayment(0, 'token')).toThrow('Invalid amount');
  });
  
  test('processes valid payment', async () => {
    const result = await processPayment(100, 'valid-token');
    expect(result.success).toBe(true);
  });
});
```

## Concrete Review Process

### File Analysis Pipeline

```bash
# Multi-agent review coordination
coordinate_review() {
  local target="$1"
  local mode="$2"
  
  echo "🔍 Starting multi-agent review of $target..."
  
  # Analyze file types to determine agent deployment
  file_types=$(find "$target" -type f -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.go" | \
               head -10 | xargs file --mime-type)
  
  # Deploy agents based on file content
  agents_to_deploy=("code-reviewer" "security-auditor")
  
  if echo "$file_types" | grep -q "test\|spec"; then
    agents_to_deploy+=("test-engineer")
  fi
  
  if echo "$file_types" | grep -q "html\|jsx\|vue"; then
    agents_to_deploy+=("accessibility-auditor")
  fi
  
  if [[ "$mode" == "--performance" ]] || detect_performance_concerns "$target"; then
    agents_to_deploy+=("performance-specialist")
  fi
  
  echo "🤖 Deploying agents: ${agents_to_deploy[*]}"
  
  # Execute review in parallel
  for agent in "${agents_to_deploy[@]}"; do
    echo "Deploying $agent for $target review..." &
  done
  wait
  
  echo "📋 Aggregating findings..."
}

# Detect performance-related files
detect_performance_concerns() {
  local target="$1"
  
  # Look for performance-sensitive patterns
  if grep -r "setTimeout\|setInterval\|for.*length\|O(n" "$target" >/dev/null 2>&1; then
    return 0
  fi
  
  # Check for database query files
  if grep -r "SELECT\|INSERT\|UPDATE\|DELETE" "$target" >/dev/null 2>&1; then
    return 0
  fi
  
  return 1
}
```

### Issue Severity Classification

```yaml
Critical Issues (Block Merge):
  Security:
    - SQL injection vulnerabilities
    - XSS attack vectors  
    - Hardcoded secrets/API keys
    - Authentication bypasses
    
  Reliability:
    - Null pointer exceptions
    - Infinite loops
    - Memory leaks
    - Deadlock conditions

High Priority (Fix Before Merge):
  Performance:
    - O(n²) or worse algorithms
    - N+1 database queries
    - Memory allocation in loops
    - Blocking I/O on main thread
    
  Testing:
    - Critical functions untested
    - Payment/security logic without tests
    - Edge cases not covered

Medium Priority (Consider Fixing):
  Code Quality:
    - Cyclomatic complexity >10
    - Functions >50 lines
    - Code duplication
    - Inconsistent naming
    
  Documentation:
    - Missing JSDoc/docstrings
    - Complex logic without comments
    - Outdated documentation

Low Priority (Optional):
  Style:
    - Formatting inconsistencies
    - Unused imports
    - Console.log statements
    - Minor linting violations
```

## Review Report Examples

### Security-Focused Review

```markdown
## Security Review Report
**Target**: src/auth/ | **Issues**: 3 Critical, 2 High | **Status**: ❌ Blocked

### 🔴 Critical Security Issues
1. **SQL Injection** in `auth/login.js:45`
   - **Risk**: Remote code execution via login form
   - **Fix**: Use parameterized queries: `db.query('SELECT * FROM users WHERE email = ?', [email])`
   
2. **Hardcoded JWT Secret** in `config/jwt.js:12`
   - **Risk**: Token forgery if secret leaked
   - **Fix**: Move to environment variable: `process.env.JWT_SECRET`

### 🟠 High Priority Issues  
1. **Weak Password Hashing** in `auth/password.js:23`
   - **Current**: MD5 hashing (cryptographically broken)
   - **Fix**: Use bcrypt with salt rounds ≥12

### ✅ Security Strengths
- CSRF protection properly implemented
- Input validation present on all endpoints
- HTTPS enforcement configured

### 🎯 Recommendations
1. Implement rate limiting on authentication endpoints
2. Add logging for failed authentication attempts
3. Consider implementing 2FA for admin accounts
```

### Performance Review

```markdown
## Performance Review Report  
**Target**: src/api/ | **Issues**: 1 High, 3 Medium | **Estimated Impact**: 60% response time reduction

### 🟠 High Impact Issues
1. **N+1 Query Problem** in `api/users.js:67`
   - **Current**: 1 + N database queries for user list
   - **Impact**: 2000ms response time with 100 users
   - **Fix**: Use `JOIN` or `prefetch_related()`: reduces to 50ms

### 🟡 Medium Impact Issues
1. **Inefficient Array Operations** in `utils/search.js:34`
   - **Current**: O(n²) nested loops for filtering
   - **Fix**: Use `Set` for O(n) lookup: `const seen = new Set()`

2. **Excessive Bundle Size** in `frontend/components/`
   - **Current**: 2.3MB JavaScript bundle
   - **Fix**: Code splitting and lazy loading: reduces to 400KB initial

### 📊 Performance Metrics
- **Database Queries**: 15 → 3 (80% reduction)
- **Memory Usage**: 150MB → 90MB (40% reduction)  
- **Bundle Size**: 2.3MB → 400KB (83% reduction)
```

### Test Coverage Review

```markdown
## Test Coverage Review
**Target**: src/ | **Coverage**: 67% → Target: 80% | **Status**: ⚠️ Needs Improvement

### ❌ Critical Gaps (Untested)
1. **Payment Processing** (`payments/charge.js`)
   - 0% coverage on critical financial logic
   - **Required**: Unit tests for validation, error handling, success flows
   
2. **Authentication Logic** (`auth/validate.js`)  
   - Missing edge case tests (expired tokens, malformed input)
   - **Required**: Integration tests for auth flow

### 📈 Coverage Improvements Needed
- **Current Coverage**: 67% lines, 45% branches
- **Missing Tests**: 23 functions lack any test coverage
- **Flaky Tests**: 3 tests fail intermittently

### ✅ Well-Tested Areas
- User management: 95% coverage with edge cases
- API routing: 88% coverage with integration tests
- Database models: 92% coverage with mocking

### 🎯 Action Plan
1. Add comprehensive payment tests (highest priority)
2. Improve authentication test coverage to 90%
3. Fix flaky tests in user registration flow
4. Add property-based testing for data validation
```

## Execution Verification

Deploy execution-evaluator to verify:

- ✅ **All agents deployed** - Correct specialists assigned based on file types
- ✅ **Comprehensive analysis** - Security, performance, testing, quality covered
- ✅ **Issues prioritized** - Critical/High/Medium/Low classification applied
- ✅ **Actionable feedback** - Specific fixes provided with examples
- ✅ **Metrics calculated** - Coverage, complexity, performance impact measured
- ✅ **Report generated** - Complete findings documented with severity

## Examples

### Standard Multi-Agent Review

```bash
User: /review src/auth/
Claude: 🔍 Starting multi-agent review of src/auth/...
🤖 Deploying: code-reviewer, security-auditor, test-engineer
🔒 security-auditor: Found 2 critical SQL injection vulnerabilities
🧪 test-engineer: 23% test coverage, missing critical payment tests  
🔧 code-reviewer: 3 high complexity functions, 1 code duplication
📋 Generated comprehensive review report with 8 actionable fixes
```

### Security-Focused Review

```bash
User: /review --security
Claude: 🔒 Security-focused review mode...
🤖 Deploying: security-auditor, code-reviewer
🚨 Critical: Hardcoded API keys found in config/
🚨 Critical: SQL injection vulnerability in user search
⚠️ High: Weak password hashing (MD5)
📋 Security review complete: 3 critical, 2 high priority issues
```

### Auto-Fix Review

```bash
User: /review --fix
Claude: 🔧 Review with auto-remediation...
🤖 Deploying: code-reviewer + remediation specialists
✅ Auto-fixed: 12 linting violations
✅ Auto-fixed: 3 import organization issues
⚠️ Manual required: 2 security issues need human review
📝 Committed auto-fixes, generated manual fix report
```

## Notes

- Deploys multiple agents in parallel for comprehensive coverage
- Focuses on actionable feedback with specific code examples
- Prioritizes issues by severity and business impact
- Provides both automated fixes and manual guidance
- Integrates with development workflow for continuous quality
- Generates detailed reports suitable for team review and compliance
