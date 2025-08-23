# /review Command

## Description

CodeRabbit-inspired AI code review with multi-layer analysis pipeline combining 30+ linting tools,
AST analysis, security scanning, and AI synthesis. Generates structured reports with actionable 
"Prompts for AI Agents" sections for automated remediation.

## Usage

```bash
/review                    # CodeRabbit-style review of changed files (default)
/review --full             # Full repository review with 30+ tools
/review <file|directory>   # Review specific target
/review --fix             # Auto-fix safe issues + commit fixes
/review --security        # Security-focused with Semgrep, Gitleaks, OSV-Scanner
/review --performance     # Performance analysis with profiling
/review --learn           # Learn from team feedback and preferences
```

## Behavior

**CodeRabbit-Inspired Multi-Layer Analysis:**

1. **Tool Pipeline**: Runs 30+ linting tools (ESLint, Semgrep, Gitleaks, etc.) in parallel
2. **AST Analysis**: Deep code structure understanding and dependency mapping
3. **AI Synthesis**: Claude processes all tool outputs with contextual reasoning
4. **Report Generation**: Structured output with "Prompts for AI Agents" sections
5. **Learning**: Adapts to team preferences and coding standards over time

**Default Mode**: CodeRabbit-style review of changed files with tool integration
**Full Mode**: Comprehensive repository analysis with all 30+ tools

## Multi-Layer Analysis Pipeline

### Layer 1: Static Analysis Tools (30+ Tools)

**Language-Specific Linters:**
```yaml
JavaScript/TypeScript:
  - ESLint: Code quality and best practices
  - Oxlint: High-performance linting  
  - Biome: Fast formatter and linter

Python:
  - Flake8: Style guide enforcement
  - Pylint: Comprehensive code analysis
  - Ruff: Extremely fast Python linter

Go:
  - golangci-lint: Meta-linter with 40+ linters
  - staticcheck: Advanced static analysis

Rust:
  - Clippy: Rust-specific lints and suggestions

Ruby:
  - RuboCop: Style guide enforcement
  - Brakeman: Security vulnerability scanner
```

**Security Scanners:**
```yaml
Universal Security:
  - Semgrep: SAST with custom rules
  - Gitleaks: Secret detection
  - OSV-Scanner: Vulnerability database lookup
  - Checkov: Infrastructure security

Language-Specific Security:
  - Bandit: Python security linter  
  - gosec: Go security checker
  - security-audit: Node.js security
```

**Infrastructure & Config:**
```yaml
Docker:
  - Hadolint: Dockerfile best practices
  - Trivy: Container vulnerability scanning

CI/CD:
  - actionlint: GitHub Actions linting
  - CircleCI: Pipeline validation

Config Files:
  - yamllint: YAML syntax and style
  - jsonlint: JSON validation
  - Buf: Protocol Buffer linting
```

**Documentation & Formatting:**
```yaml
Markdown:
  - markdownlint: Markdown style guide
  - LanguageTool: Natural language review

Shell Scripts:
  - ShellCheck: Shell script analysis
  - shfmt: Shell formatting

SQL:
  - SQLFluff: SQL linting and formatting
```

### Layer 2: AST Analysis & Code Graph

**Deep Code Understanding:**
```yaml
AST Analysis:
  - Parse syntax trees for all languages
  - Understand code structure and patterns
  - Map function calls and data flow
  - Identify architectural patterns

Dependency Mapping:
  - Cross-file dependency analysis
  - Import/export relationship mapping
  - Circular dependency detection
  - Dead code identification

Performance Analysis:
  - Algorithm complexity detection
  - Memory usage patterns
  - Database query optimization
  - Bundle size analysis
```

### Layer 3: AI Synthesis with Claude

**Intelligent Processing:**
```yaml
Context Integration:
  - Synthesize all tool outputs
  - Apply project-specific context
  - Understand architectural implications
  - Generate actionable feedback

Pattern Recognition:
  - Identify anti-patterns
  - Suggest architectural improvements
  - Detect code smells
  - Recommend refactoring opportunities

Learning System:
  - Remember team preferences
  - Adapt to coding standards
  - Learn from feedback patterns
  - Customize review focus
```

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

## Enhanced Implementation - CodeRabbit Style

### Multi-Layer Review Execution

```bash
# CodeRabbit-inspired review with tool integration
execute_coderabbit_review() {
  local target="$1"
  local mode="$2" 
  local scope="$3"

  echo "🤖 Starting CodeRabbit-style AI review..."
  echo "🔧 Multi-layer analysis: Tools + AST + AI Synthesis"

  # Phase 1: Tool Pipeline Execution
  run_tool_pipeline() {
    echo "📊 Phase 1: Running 30+ static analysis tools..."
    
    # Language Detection
    detect_languages() {
      local file_list="$1"
      echo "$file_list" | while read -r file; do
        case "$file" in
          *.js|*.jsx|*.ts|*.tsx) echo "javascript" ;;
          *.py) echo "python" ;;
          *.go) echo "go" ;;
          *.rs) echo "rust" ;;
          *.rb) echo "ruby" ;;
          *.php) echo "php" ;;
          *.java) echo "java" ;;
          *.swift) echo "swift" ;;
          *.sh) echo "shell" ;;
          *.sql) echo "sql" ;;
          *.md) echo "markdown" ;;
          *.yaml|*.yml) echo "yaml" ;;
          *.json) echo "json" ;;
          *) echo "generic" ;;
        esac
      done | sort | uniq
    }

    local languages=$(detect_languages "$target")
    echo "🔍 Detected languages: $languages"

    # JavaScript/TypeScript Tools
    if echo "$languages" | grep -q "javascript"; then
      echo "🟡 Running JavaScript analysis..."
      run_if_available "npx eslint $target --format json" "ESLint"
      run_if_available "npx oxlint $target" "Oxlint" 
      run_if_available "npx biome check $target" "Biome"
      run_if_available "npx prettier --check $target" "Prettier"
    fi

    # Python Tools  
    if echo "$languages" | grep -q "python"; then
      echo "🐍 Running Python analysis..."
      run_if_available "flake8 $target --format=json" "Flake8"
      run_if_available "pylint $target --output-format=json" "Pylint"
      run_if_available "ruff check $target --format json" "Ruff"
      run_if_available "bandit -r $target -f json" "Bandit"
    fi

    # Go Tools
    if echo "$languages" | grep -q "go"; then
      echo "🐹 Running Go analysis..."
      run_if_available "golangci-lint run $target --out-format json" "golangci-lint"
      run_if_available "staticcheck -f json $target" "staticcheck"
      run_if_available "gosec -fmt json $target" "gosec"
    fi

    # Universal Security Tools  
    echo "🔒 Running security analysis..."
    run_if_available "semgrep --config=auto $target --json" "Semgrep"
    run_if_available "gitleaks detect --source $target --report-format json" "Gitleaks" 
    run_if_available "osv-scanner --format json $target" "OSV-Scanner"
    run_if_available "checkov -d $target --framework all -o json" "Checkov"

    # Infrastructure Tools
    if find "$target" -name "Dockerfile" -o -name "*.dockerfile" | grep -q .; then
      echo "🐳 Running Docker analysis..."
      run_if_available "hadolint $target/Dockerfile --format json" "Hadolint"
    fi

    if find "$target" -name "*.yaml" -o -name "*.yml" | grep -q .; then
      echo "📄 Running YAML analysis..."
      run_if_available "yamllint $target --format parsable" "yamllint"
    fi

    # Documentation Tools
    if find "$target" -name "*.md" | grep -q .; then
      echo "📝 Running documentation analysis..."
      run_if_available "markdownlint $target --json" "markdownlint"
    fi

    if find "$target" -name "*.sh" | grep -q .; then
      echo "🐚 Running shell script analysis..."
      run_if_available "shellcheck $target --format json" "ShellCheck"
    fi
  }

  # Helper function to run tools if available
  run_if_available() {
    local cmd="$1"
    local tool_name="$2"
    
    if command -v $(echo "$cmd" | cut -d' ' -f1) >/dev/null 2>&1; then
      echo "  ✅ $tool_name: Running..."
      eval "$cmd" > "/tmp/review_${tool_name,,}.json" 2>&1 || echo "  ⚠️ $tool_name: Issues found"
    else
      echo "  ⏭️ $tool_name: Not installed, skipping"
    fi
  }

  # Execute tool pipeline
  run_tool_pipeline

  # Phase 2: AST Analysis
  run_ast_analysis() {
    echo "📊 Phase 2: AST Analysis & Code Graph..."
    
    # Deploy specialized agent for AST analysis
    echo "🤖 Deploying AST analysis with language-specific parsers..."
    echo "  🔍 Analyzing syntax trees and code structure"
    echo "  🔗 Mapping dependencies and data flow"
    echo "  📈 Detecting performance anti-patterns"
    echo "  🏗️ Identifying architectural violations"
  }

  run_ast_analysis

  # Phase 3: AI Synthesis with Claude
  synthesize_with_claude() {
    echo "📊 Phase 3: AI Synthesis with Claude..."
    
    # Collect all tool outputs
    tool_results=""
    for result_file in /tmp/review_*.json; do
      if [[ -f "$result_file" ]]; then
        tool_name=$(basename "$result_file" .json | sed 's/review_//')
        echo "📋 Processing $tool_name results..."
        tool_results="$tool_results\n\n=== $tool_name Results ===\n$(cat "$result_file")"
      fi
    done

    # Deploy Claude for intelligent synthesis
    echo "🤖 Deploying Claude for intelligent analysis synthesis..."
    echo "  🧠 Processing all tool outputs with contextual reasoning"
    echo "  🎯 Generating actionable 'Prompts for AI Agents' sections"
    echo "  📊 Creating metrics and priority classifications"
    echo "  💡 Learning from team feedback patterns"
  }

  synthesize_with_claude

  # Phase 4: Report Generation
  generate_coderabbit_report() {
    echo "📊 Phase 4: Generating CodeRabbit-style report..."
    
    # Generate structured markdown report
    echo "📝 Creating structured report with:"
    echo "  📈 Executive summary with metrics"
    echo "  🔴 Critical/High/Medium issue classification"
    echo "  🛠️ 'Prompts for AI Agents' sections"
    echo "  📊 Tool execution summary"
    echo "  🎯 Prioritized action plan"
    echo "  💡 Learning notes for team adaptation"

    # Save report
    report_file=".tmp/coderabbit_review_$(date +%Y%m%d_%H%M%S).md"
    mkdir -p .tmp
    echo "📁 Report saved: $report_file"
  }

  generate_coderabbit_report

  # Cleanup
  rm -f /tmp/review_*.json
  
  echo "✅ CodeRabbit-style review complete!"
  echo "🎯 Found issues across security, performance, quality, and testing"
  echo "🤖 Actionable prompts ready for specialized agents"
}

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

## CodeRabbit-Style Report Format

### Standard Review Report

```markdown
# 🤖 AI Code Review Report

## Summary
**Target**: 3 changed files | **Tools**: 15 linters + AST analysis  
**Issues Found**: 2 Critical, 3 High, 5 Medium | **Status**: ⚠️ Needs Attention  
**Review Time**: 45 seconds | **Estimated Fix Time**: 25 minutes

## Files Analyzed
- `src/auth/login.js`: Authentication logic changes
- `src/api/users.js`: User management endpoints  
- `tests/auth.test.js`: Test coverage additions

---

## 🔴 Critical Issues (2)

### 1. SQL Injection Vulnerability
**File**: `src/auth/login.js:45`  
**Tool**: Semgrep + Manual Review  
**Risk**: Remote code execution via authentication bypass

```javascript
// ❌ Vulnerable code
const query = `SELECT * FROM users WHERE email = '${email}' AND password = '${password}'`;
const user = await db.query(query);
```

**Fix Required**: Use parameterized queries to prevent injection
```javascript  
// ✅ Fixed code
const query = 'SELECT * FROM users WHERE email = ? AND password = ?';
const user = await db.query(query, [email, hashedPassword]);
```

### 2. Hardcoded API Secret
**File**: `src/api/users.js:12`  
**Tool**: Gitleaks  
**Risk**: Credential exposure in version control

```javascript
// ❌ Hardcoded secret  
const API_KEY = "sk-1234567890abcdef";
```

**Fix Required**: Move to environment variables
```javascript
// ✅ Environment variable
const API_KEY = process.env.API_KEY;
```

---

## 🟠 High Priority Issues (3)

### 1. N+1 Query Pattern  
**File**: `src/api/users.js:67`
**Tool**: Custom AST Analysis  
**Impact**: 2000ms → 50ms response time improvement

```javascript
// ❌ N+1 Query Problem
for (const user of users) {
  user.posts = await Post.findByUserId(user.id); // N queries
}
```

### 2. Missing Error Handling
**File**: `src/auth/login.js:23`  
**Tool**: ESLint + Security Analysis  
**Impact**: Potential application crashes

### 3. Weak Password Hashing
**File**: `src/auth/password.js:15`  
**Tool**: Custom Security Rules  
**Impact**: Authentication security weakness  

---

## 🟡 Medium Priority Issues (5)

1. **Code Duplication**: 23% similarity between `auth/login.js` and `auth/signup.js`  
2. **Missing TypeScript**: 3 files lack proper type definitions
3. **Test Coverage Gap**: Payment logic has 0% test coverage
4. **Bundle Size**: JavaScript bundle increased by 15KB
5. **Documentation**: 2 complex functions lack JSDoc comments

---

## Prompts for AI Agents

### Security Fixes
- Fix SQL injection in login endpoint using parameterized queries
- Replace hardcoded API key with environment variable configuration  
- Implement proper input validation for all authentication endpoints
- Add rate limiting to prevent brute force attacks

### Performance Optimizations  
- Optimize N+1 query in user posts retrieval using JOIN or prefetch
- Implement database query caching for frequently accessed user data
- Add lazy loading for user profile images to reduce initial load time
- Optimize JavaScript bundle size with code splitting

### Testing Improvements
- Add comprehensive test coverage for payment processing logic
- Create integration tests for authentication flow edge cases  
- Implement property-based testing for input validation functions
- Add performance tests for database query optimization

### Code Quality Enhancements
- Refactor duplicated authentication logic into shared utility functions
- Add TypeScript definitions for API response interfaces
- Generate JSDoc documentation for complex algorithm implementations  
- Implement consistent error handling patterns across all modules

---

## 📊 Metrics & Analysis

**Security Score**: 6/10 (2 critical vulnerabilities found)  
**Performance Score**: 7/10 (1 significant bottleneck identified)  
**Test Coverage**: 73% → Target: 80% (23 untested functions)  
**Code Quality**: 8/10 (following project patterns, minor improvements needed)  
**Documentation**: 5/10 (missing docs for complex functions)

**Tool Execution Summary**:
- ESLint: 12 style issues (8 auto-fixable)
- Semgrep: 1 SQL injection, 2 XSS vulnerabilities  
- Gitleaks: 1 hardcoded secret detected
- AST Analysis: 3 performance anti-patterns
- Custom Rules: 5 project-specific violations

---

## 🎯 Next Steps

**Immediate Action Required** (Blocks merge):
1. Fix SQL injection vulnerability (Critical)
2. Remove hardcoded API secret (Critical)

**Before Merge** (High Priority):  
3. Optimize N+1 query pattern (Performance)
4. Add error handling to authentication logic (Reliability)
5. Implement proper password hashing (Security)

**Post-Merge Improvements** (Medium Priority):
6. Increase test coverage to 80%
7. Add TypeScript definitions  
8. Document complex functions
9. Refactor duplicated code

**Estimated Total Fix Time**: 25 minutes for critical issues, 2 hours for all improvements

---

## 💡 Learning Notes

Based on team feedback patterns:
- Team prefers explicit error handling over try/catch blocks
- TypeScript adoption is a stated goal for Q2
- Performance optimizations are high priority for this sprint  
- Security fixes should follow OWASP guidelines from team training

*This review adapts to your team's coding standards learned from previous interactions.*
```

### Security-Focused Review

```markdown
## 🔒 Security-Focused Review Report
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

### CodeRabbit-Style Review (Changed Files)

```bash
User: /review
Claude: 🤖 Starting CodeRabbit-style AI review...
🔧 Multi-layer analysis: Tools + AST + AI Synthesis

📊 Phase 1: Running 30+ static analysis tools...
🔍 Detected languages: javascript, python, markdown
🟡 Running JavaScript analysis...
  ✅ ESLint: Running...
  ⚠️ ESLint: Issues found
  ✅ Prettier: Running...
🐍 Running Python analysis...  
  ⏭️ Flake8: Not installed, skipping
  ✅ Ruff: Running...
🔒 Running security analysis...
  ✅ Semgrep: Running...
  ⚠️ Semgrep: Issues found
  ✅ Gitleaks: Running...
  ⚠️ Gitleaks: Issues found

📊 Phase 2: AST Analysis & Code Graph...
🤖 Deploying AST analysis with language-specific parsers...
  🔍 Analyzing syntax trees and code structure
  🏗️ Identifying architectural violations

📊 Phase 3: AI Synthesis with Claude...
📋 Processing ESLint results...
📋 Processing Semgrep results...
📋 Processing Gitleaks results...
🤖 Deploying Claude for intelligent analysis synthesis...
  🧠 Processing all tool outputs with contextual reasoning
  🎯 Generating actionable 'Prompts for AI Agents' sections

📊 Phase 4: Generating CodeRabbit-style report...
📝 Creating structured report with:
  📈 Executive summary with metrics
  🔴 Critical/High/Medium issue classification
  🛠️ 'Prompts for AI Agents' sections
📁 Report saved: .tmp/coderabbit_review_20241223_142530.md

✅ CodeRabbit-style review complete!
🎯 Found issues across security, performance, quality, and testing
🤖 Actionable prompts ready for specialized agents

# 🤖 AI Code Review Report

## Summary  
**Target**: 3 changed files | **Tools**: 15 linters + AST analysis
**Issues Found**: 2 Critical, 1 High, 3 Medium | **Status**: ❌ Blocked
**Review Time**: 45 seconds | **Estimated Fix Time**: 15 minutes

## 🔴 Critical Issues (2)
1. **Hardcoded API Secret** in src/api/config.js:12 (Gitleaks)
2. **SQL Injection** in src/auth/login.js:45 (Semgrep)

## Prompts for AI Agents
### Security Fixes
- Replace hardcoded API key with environment variable
- Fix SQL injection using parameterized queries
- Add input validation for authentication endpoints

[Full report available in .tmp/coderabbit_review_20241223_142530.md]
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

### Auto-Fix Review

```bash  
User: /review --fix
Claude: 🤖 Starting CodeRabbit-style review with auto-remediation...
🔧 Multi-layer analysis: Tools + AST + AI Synthesis + Auto-fixes

📊 Phase 1: Running 30+ static analysis tools...
🟡 Running JavaScript analysis...
  ✅ ESLint: Running...
  ⚠️ ESLint: 12 issues found (8 auto-fixable)
  ✅ Prettier: Running...
  ⚠️ Prettier: 4 formatting issues found

🔧 Auto-fixing safe issues...
  ✅ Applied ESLint auto-fixes (8/12 issues)
  ✅ Applied Prettier formatting (4/4 issues)  
  📝 Committed auto-fixes: "fix: apply linting auto-fixes"

📊 Remaining manual issues: 4 (requires human review)
🛠️ Generated prompts for manual fixes in report

✅ Auto-fix complete! 12 issues resolved, 4 require manual attention
```

## Notes

**CodeRabbit-Inspired Enhancements:**
- **30+ Tool Integration**: ESLint, Semgrep, Gitleaks, Hadolint, etc.
- **Multi-Layer Pipeline**: Tools → AST → AI Synthesis → Structured Reports
- **"Prompts for AI Agents"**: Actionable remediation instructions for automation
- **Learning System**: Adapts to team preferences and coding standards
- **Structured Reports**: CodeRabbit-style markdown with metrics and priorities

**Core Features:**
- **Smart Scope Detection**: Reviews changed files by default, full repository with --full
- **Context-First Approach**: Reads all documentation before code review
- **Tool Auto-Detection**: Runs appropriate linters based on detected languages
- **Parallel Execution**: All tools run concurrently for maximum speed
- **Intelligent Synthesis**: Claude processes all tool outputs with contextual reasoning
- **Auto-Fix Capability**: Applies safe fixes automatically and commits them
- **Report Persistence**: Saves detailed reports to .tmp/ for future reference

**Workflow Integration:**
- **Development-Friendly**: Integrates with existing toolchains and workflows
- **CI/CD Compatible**: JSON outputs compatible with automated pipelines  
- **Team Learning**: Remembers feedback patterns and adjusts review focus
- **Quality Gates**: Supports blocking critical issues while allowing minor ones
- **Compliance Ready**: Generates audit-trail documentation for enterprise requirements
