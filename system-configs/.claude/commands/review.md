# /review Command

## Description

Multi-agent code review with comprehensive documentation analysis for context,
orchestrating specialized agents for security, performance, testing, and
accessibility validation.

## Usage

```bash
/review                    # Review changed files only (default)
/review --full             # Review entire codebase comprehensively
/review <file|directory>   # Review specific target
/review --fix             # Auto-fix safe issues
/review --security        # Security-focused review
/review --performance     # Performance-focused review
```

## Behavior

When invoked, I first read all documentation for context understanding, then
orchestrate multiple specialized agents for code review. By default, only
changed files are reviewed for efficiency. Agents receive documentation context
and work in parallel to analyze security, performance, testing, and accessibility
aspects with informed decisions.

**Default Mode**: Reviews only changed files (git diff) for fast feedback
**Full Mode**: Reviews entire repository for comprehensive system analysis

## Agent Orchestration Strategy

### Standard Review (default - changed files only)

**Scope**: Reviews files changed in current branch (git diff main...HEAD)

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

### Full Repository Review (--full mode)

**Scope**: Reviews entire codebase for comprehensive system analysis

**Extended Agent Deployment:**

```yaml
Core Quality:
  code-reviewer: "Repository-wide code quality analysis"
  security-auditor: "Complete security audit"
  performance-specialist: "System-wide performance analysis"

Infrastructure:
  devops: "CI/CD pipeline and deployment analysis"
  dependency-analyst: "Supply chain and dependency security"
  database-admin: "Database schema and performance review"

Testing & Documentation:
  test-engineer: "Complete test coverage and quality analysis"
  tech-writer: "Documentation completeness and accuracy"
  accessibility-auditor: "Comprehensive accessibility compliance"

Coordination: Comprehensive multi-domain analysis with executive summary
```

### Focused Reviews

```yaml
--security Mode:
  scope: "Changed files or full repository based on base command"
  agents: [security-auditor, code-reviewer]
  focus: "OWASP Top 10, dependency vulnerabilities, secrets"

--performance Mode:
  scope: "Changed files or full repository based on base command"
  agents: [performance-specialist, code-reviewer]
  focus: "Algorithm complexity, database queries, memory usage"

--fix Mode:
  scope: "Changed files only (safety requirement)"
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
# Multi-agent review coordination with documentation context
coordinate_review() {
  local target="$1"
  local mode="$2"
  local scope="$3"  # "changed" (default) or "full"

  echo "📚 Reading documentation for context..."

  # Read all documentation for context
  read_project_documentation() {
    echo "🔍 Analyzing project documentation:"

    # Core project files
    local doc_files=(
      "README.md" "CLAUDE.md" "package.json" "Cargo.toml" "pyproject.toml"
      "docs/" "documentation/" ".github/" "spec/" "design/"
    )

    for doc_path in "${doc_files[@]}"; do
      if [[ -e "$doc_path" ]]; then
        echo "📖 Reading: $doc_path"
        # Agent receives content for context
      fi
    done

    # Look for architecture decision records
    find . \( -path "*/adr/*" -o -path "*/decisions/*" \) -name "*.md" | while read -r adr; do
      echo "📋 Reading ADR: $adr"
    done

    # Find configuration files that define system behavior
    find . -name "*.json" -o -name "*.yaml" -o -name "*.toml" -o -name "*.ini" | \
    grep -E "(config|settings|env)" | while read -r config; do
      echo "⚙️ Reading config: $config"
    done
  }

  # Execute documentation reading
  read_project_documentation

  # Determine review scope and target files
  determine_review_scope() {
    local scope="$1"
    local target="$2"

    if [[ "$scope" == "full" ]]; then
      echo "🔍 Starting context-aware FULL REPOSITORY review..."
      review_target="."
      echo "📊 Scope: Complete codebase analysis"
    elif [[ -n "$target" ]]; then
      echo "🔍 Starting context-aware review of specific target: $target..."
      review_target="$target"
      echo "📊 Scope: Specific file/directory"
    else
      echo "🔍 Starting context-aware review of CHANGED FILES..."
      # Get changed files in current branch
      changed_files=$(git diff --name-only main...HEAD 2>/dev/null || git diff --name-only HEAD~1)
      if [[ -z "$changed_files" ]]; then
        echo "ℹ️ No changed files found, falling back to staged files"
        changed_files=$(git diff --cached --name-only)
      fi
      if [[ -z "$changed_files" ]]; then
        echo "ℹ️ No staged files found, falling back to working directory changes"
        changed_files=$(git diff --name-only)
      fi
      review_target="$changed_files"
      echo "📊 Scope: $(echo "$changed_files" | wc -l) changed files"
    fi
  }

  determine_review_scope "$scope" "$target"

  # Analyze file types to determine agent deployment
  if [[ "$scope" == "full" ]]; then
    file_types=$(find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.go" -o -name "*.sh" -o -name "*.md" \) | \
                 head -20 | xargs file --mime-type 2>/dev/null || echo "text/plain")
  else
    file_types=$(echo "$review_target" | head -10 | xargs file --mime-type 2>/dev/null || echo "text/plain")
  fi

  # Deploy agents based on scope and file content
  if [[ "$scope" == "full" ]]; then
    # Full repository review - deploy comprehensive agent set
    agents_to_deploy=("code-reviewer" "security-auditor" "performance-specialist" "test-engineer")
    agents_to_deploy+=("devops" "dependency-analyst" "tech-writer" "accessibility-auditor")
    echo "🤖 Full repository mode: Deploying comprehensive agent set"
  else
    # Changed files review - deploy targeted agents
    agents_to_deploy=("code-reviewer" "security-auditor")

    if echo "$file_types" | grep -q "test\|spec"; then
      agents_to_deploy+=("test-engineer")
    fi

    if echo "$file_types" | grep -q "html\|jsx\|vue"; then
      agents_to_deploy+=("accessibility-auditor")
    fi

    if [[ "$mode" == "--performance" ]] || detect_performance_concerns "$review_target"; then
      agents_to_deploy+=("performance-specialist")
    fi

    echo "🎯 Changed files mode: Deploying targeted agents"
  fi

  echo "🤖 Deploying context-aware agents: ${agents_to_deploy[*]}"

  # Prepare context summary for agents
  context_prompt="Based on the project documentation analysis:
  - Project architecture and patterns from README.md/CLAUDE.md
  - Configuration standards from config files
  - System boundaries and security models from agent definitions
  - Command vs agent distinctions from .claude/ structure
  - Review scope: $(if [[ "$scope" == "full" ]]; then echo "Full repository analysis"; else echo "Changed files only"; fi)

  Apply this context when reviewing code to make informed decisions about:
  - Whether security patterns are appropriate for the file type
  - What architectural patterns should be followed
  - How this code fits into the overall system design
  - Focus review effort based on scope (comprehensive vs. incremental)"

  # Execute context-aware review in parallel
  for agent in "${agents_to_deploy[@]}"; do
    if [[ "$scope" == "full" ]]; then
      echo "Deploying $agent with project context for FULL REPOSITORY review..." &
    else
      echo "Deploying $agent with project context for CHANGED FILES review..." &
    fi
    # Agent receives both target code AND documentation context
  done
  wait

  echo "📋 Aggregating context-aware findings..."
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

### Standard Review (Changed Files Only)

```bash
User: /review
Claude: 📚 Reading documentation for context...
📖 Reading: README.md, CLAUDE.md, package.json
🔍 Starting context-aware review of CHANGED FILES...
📊 Scope: 3 changed files
🎯 Changed files mode: Deploying targeted agents
🤖 Deploying context-aware agents: code-reviewer, security-auditor
🔒 security-auditor: Found 1 input validation issue in auth.js
🔧 code-reviewer: 2 minor style issues, following project patterns from CLAUDE.md
📋 Generated context-aware review with 3 actionable fixes (focused on changes)
```

### Full Repository Review

```bash
User: /review --full
Claude: 📚 Reading documentation for context...
📖 Reading: README.md, CLAUDE.md, package.json, all config files
🔍 Starting context-aware FULL REPOSITORY review...
📊 Scope: Complete codebase analysis
🤖 Full repository mode: Deploying comprehensive agent set
🤖 Deploying agents: code-reviewer, security-auditor, performance-specialist, test-engineer, devops, dependency-analyst, tech-writer, accessibility-auditor
🔒 security-auditor: Found 8 vulnerabilities across codebase
🧪 test-engineer: 67% coverage, 23 functions lack tests
⚡ performance-specialist: 5 N+1 queries, 3 memory leaks
🚀 devops: CI/CD pipeline needs 4 improvements
📋 Generated comprehensive system review with 62 blocking issues
```

### Specific Target Review

```bash
User: /review src/auth/
Claude: 📚 Reading documentation for context...
🔍 Starting context-aware review of specific target: src/auth/...
📊 Scope: Specific file/directory
🎯 Changed files mode: Deploying targeted agents
🤖 Deploying context-aware agents: code-reviewer, security-auditor, test-engineer
🔒 security-auditor: Found 2 SQL injection vulnerabilities in login.js
🧪 test-engineer: 23% test coverage, missing critical payment tests
🔧 code-reviewer: 3 high complexity functions, but following project patterns
📋 Generated targeted review with 8 actionable fixes
```

### Security-Focused Review

```bash
User: /review --security
Claude: 📚 Reading security documentation for context...
📖 Reading: .claude/agents/security-auditor.md, docs/security/
🔍 Starting context-aware review of CHANGED FILES...
🔒 Context-aware security-focused review mode...
🎯 Changed files mode: Deploying targeted agents
🤖 Deploying: security-auditor, code-reviewer with security context
🚨 Critical: Input validation missing in new login endpoint
⚠️ High: Weak password hashing in updated auth module
✅ Correctly identified: Commands don't need system boundary protection
📋 Security review of changes: 1 critical, 1 high priority issue

User: /review --full --security
Claude: 📚 Reading security documentation for context...
🔍 Starting context-aware FULL REPOSITORY review...
🔒 Context-aware security-focused review mode...
🤖 Full repository mode: Deploying comprehensive agent set
🚨 Critical: 8 hardcoded API keys found across codebase
🚨 Critical: 3 SQL injection vulnerabilities in legacy code
⚠️ High: 12 authentication bypass scenarios
📋 Complete security audit: 11 critical, 15 high priority issues
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

- **Smart Scope Detection**: Reviews changed files by default, full repository with --full
- **Context-First Approach**: Reads all documentation before code review
- **Informed Agent Deployment**: Agents receive project context for accurate analysis
- **Efficiency-Focused**: Default mode provides fast feedback on recent changes
- **Comprehensive Option**: --full mode enables complete system analysis when needed
- **Architecture-Aware**: Understands command vs agent distinctions, system boundaries
- **Pattern Recognition**: Applies project-specific patterns from CLAUDE.md/README.md
- **False Positive Prevention**: Context prevents misapplication of security models
- **Targeted Analysis**: Agent deployment adapts to review scope and file types
- Deploys multiple agents in parallel for comprehensive coverage
- Focuses on actionable feedback with specific code examples
- Prioritizes issues by severity and business impact
- Provides both automated fixes and manual guidance
- Integrates with development workflow for continuous quality
- Generates detailed reports suitable for team review and compliance
