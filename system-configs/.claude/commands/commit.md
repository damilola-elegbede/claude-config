---
description: Creates git commit with wave-based orchestration and auto-remediation
argument-hint: [--amend]
---

# /commit Command

## Usage

```bash
/commit                         # Create commit with wave-based analysis and auto-fix
/commit --amend                 # Amend last commit with staged changes
```

## Description

Creates a git commit using wave-based orchestration with parallel analysis, auto-remediation, and quality gate
enforcement. This command implements a three-wave approach: pre-commit analysis, auto-fix issues, and final commit
creation.

**CRITICAL**: This command NEVER uses `--no-verify`. Quality gates exist to protect code integrity and must always be
respected. When pre-commit hooks fail, the command automatically deploys remediation agents to fix issues.

## Wave-Based Orchestration Strategy

### Wave 1: Pre-commit Analysis (Parallel)

Deploy multiple agent instances simultaneously for comprehensive analysis:

```yaml
# WAVE 1: SIMULTANEOUS PRE-COMMIT ANALYSIS
code-reviewer (multi-instance pool):
  deployment: 3-4 instances based on changed file types
  distribution:
    - instance_1: Frontend/UI changes (React, Vue, Angular files)
    - instance_2: Backend/API changes (Node.js, Python, Go files)
    - instance_3: Infrastructure changes (Docker, CI/CD, configs)
    - instance_4: Test and documentation changes
  role: Analyze code quality, style, and completeness
  parallel_with: [security-auditor instances, test-engineer]
  output: Quality assessment, blocking issues per domain

security-auditor (multi-instance pool):
  deployment: 2 instances for thorough security scanning
  distribution:
    - instance_1: Secrets scanning (API keys, passwords, tokens)
    - instance_2: Vulnerability patterns (SQL injection, XSS, dependencies)
  role: Identify security vulnerabilities and sensitive data
  parallel_with: [code-reviewer instances, test-engineer]
  output: Security clearance or blocking security issues

test-engineer:
  role: Verify all tests pass with current changes
  input: Changed files, existing test suites, test coverage
  parallel_with: [code-reviewer instances, security-auditor instances]
  output: Test results, coverage metrics, failing tests identification
```

### Claude Decision Point: Issue Identification

After Wave 1 completes, Claude analyzes all agent outputs to identify blocking issues:

- **Security Issues**: Any secrets, vulnerabilities, or security anti-patterns
- **Quality Issues**: Linting errors, code style violations, complexity issues
- **Test Failures**: Broken tests, insufficient coverage, missing tests
- **Documentation**: Missing docs for new features or APIs

**Decision Logic**:

- ✅ **No Issues Found**: Proceed directly to Wave 3 (Final Commit)
- ⚠️ **Issues Found**: Deploy Wave 2 (Auto-Fix Issues) with targeted agents
- 🚫 **Critical Security**: Block commit until manual intervention

### Wave 2: Auto-Fix Issues (Conditional Parallel)

Deploy only when Wave 1 identifies fixable issues. Each issue type gets dedicated agent instances:

```yaml
# WAVE 2: TARGETED AUTO-REMEDIATION (CONDITIONAL)
code-reviewer (fix-focused instances):
  condition: Linting errors OR style violations detected
  deployment: N instances where N = number of files with issues
  distribution: One instance per file requiring fixes
  role: Auto-fix linting errors, style issues, complexity problems
  parallel_with: [test-engineer instances, tech-writer]
  output: Fixed files, remaining manual issues

test-engineer (fix-focused instances):
  condition: Test failures OR coverage gaps detected
  deployment: 2-3 instances based on test failure types
  distribution:
    - instance_1: Fix broken unit tests
    - instance_2: Fix integration test failures
    - instance_3: Add missing test coverage
  role: Repair failing tests and improve coverage
  parallel_with: [code-reviewer instances, tech-writer]
  output: Fixed tests, new test files, coverage reports

tech-writer:
  condition: Missing documentation OR unclear commit scope
  role: Generate missing documentation and refine commit messages
  input: All changes, fixed issues, repository conventions
  parallel_with: [code-reviewer instances, test-engineer instances]
  output: Documentation updates, conventional commit messages

security-auditor:
  condition: Non-critical security issues detected
  role: Auto-remediate security anti-patterns and vulnerabilities
  deployment: 1 instance for pattern fixes
  parallel_with: [other fix agents]
  output: Secured code, security improvements
```

### Claude Verification: Confirm Fixes Applied

After Wave 2 completes, Claude verifies that all issues have been resolved:

- **Re-run Quality Checks**: Validate that fixes actually resolved issues
- **Test All Fixes**: Ensure auto-fixes didn't introduce new problems
- **Security Re-scan**: Confirm security issues were properly addressed
- **Prepare Final Staging**: Ready all fixed files for commit

**Verification Logic**:

- ✅ **All Issues Resolved**: Proceed to Wave 3 (Final Commit)
- ⚠️ **Partial Resolution**: Deploy additional targeted agents
- 🚫 **New Issues Introduced**: Rollback fixes and report to user

### Wave 3: Final Commit (Always Executed)

Generate comprehensive commit message and create commit with all fixes included:

```yaml
# WAVE 3: FINAL COMMIT CREATION
tech-writer:
  role: Generate final conventional commit message using conventional commit format
  input: All changes, fixes applied, repository commit style
  output: Polished commit message with fix descriptions

execution-evaluator:
  role: Create git commit and verify success
  input: Staged files, commit message, pre-commit hook results
  output: Commit hash, verification of clean state

codebase-analyst:
  role: Post-commit impact analysis
  input: Final committed changes
  parallel_with: [execution-evaluator]
  output: Impact summary, related areas to monitor
```

## Expected Output

### Wave 1: Pre-commit Analysis Output

```text
🌊 WAVE 1: Pre-commit Analysis
🔍 Deploying parallel analysis agents...

📊 Agent Status:
  - code-reviewer[frontend]: Analyzing React components... ✅ (2.1s)
  - code-reviewer[backend]: Analyzing API endpoints... ✅ (1.8s)
  - code-reviewer[infra]: Analyzing Docker configs... ✅ (1.2s)
  - code-reviewer[tests]: Analyzing test coverage... ⚠️ (2.0s)
  - security-auditor[secrets]: Scanning for credentials... ✅ (1.5s)
  - security-auditor[vulns]: Vulnerability assessment... ✅ (2.3s)
  - test-engineer: Running test suite... ❌ (3.1s)

⚠️ Issues Identified:
  - 3 linting errors in src/components/
  - 2 failing unit tests in auth module
  - Missing JSDoc for new API endpoints
  - Test coverage below 80% threshold

🎯 Decision: Deploy Wave 2 auto-remediation
```

### Wave 2: Auto-Fix Issues Output (Conditional)

```text
🌊 WAVE 2: Auto-Fix Issues
🔧 Deploying targeted remediation agents...

📊 Fix Status:
  - code-reviewer[src/components/Login.tsx]: Fixed ESLint errors... ✅ (1.2s)
  - code-reviewer[src/components/Form.tsx]: Fixed style violations... ✅ (0.9s)
  - code-reviewer[src/api/auth.ts]: Added missing JSDoc... ✅ (1.5s)
  - test-engineer[auth-unit]: Fixed authentication tests... ✅ (2.8s)
  - test-engineer[coverage]: Added missing test cases... ✅ (3.2s)
  - tech-writer: Generated commit message options... ✅ (1.1s)

✅ All Issues Resolved:
  - Linting: 3/3 errors fixed
  - Tests: 2/2 failures resolved
  - Coverage: 85% (target: 80%)
  - Documentation: JSDoc added

🎯 Decision: Proceed to Wave 3 final commit
```

### Wave 3: Final Commit Output

```text
🌊 WAVE 3: Final Commit
📝 Staging all changes and fixes...

📋 Final Commit Summary:
Files Changed: 8 files
  - src/components/Login.tsx (fixed linting)
  - src/components/Form.tsx (fixed style)
  - src/api/auth.ts (added docs)
  - tests/auth.test.ts (fixed tests)
  - tests/coverage.test.ts (new coverage)
  + 3 additional files

📝 Commit Message:
feat(auth): implement user authentication with JWT tokens

- Add login component with form validation and error handling
- Integrate JWT authentication service with refresh logic
- Include comprehensive test coverage (85%)
- Add JSDoc documentation for all public APIs
- Fix ESLint violations and style inconsistencies

Auto-fixes applied:
- Resolved 3 linting errors in components
- Fixed 2 failing authentication tests
- Added missing test coverage for edge cases

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>

✅ Commit created: a1b2c3d
🔍 Post-commit verification: All quality gates passed
```

## Auto-Remediation Capabilities

### Automatic Fix Categories

**Code Quality Issues**:

- ESLint/TSLint errors and warnings
- Prettier formatting violations
- Import statement organization
- Unused variable removal
- Code complexity reduction

**Test Issues**:

- Broken unit test repairs
- Missing test case generation
- Test coverage improvements
- Snapshot updates
- Mock configuration fixes

**Documentation Issues**:

- Missing JSDoc/docstring generation
- README updates for new features
- API documentation generation
- Inline comment improvements
- Type definition documentation

**Security Issues**:

- Remove accidental credential commits
- Fix security anti-patterns
- Update vulnerable dependencies
- Add security headers
- Input validation improvements

### Pre-commit Hook Failure Handling

When pre-commit hooks fail, the command automatically:

1. **Parse Hook Output**: Identify specific failure types and affected files
2. **Deploy Fix Agents**: Launch appropriate agents based on failure types
3. **Apply Fixes**: Auto-remediate all fixable issues in parallel
4. **Re-run Hooks**: Verify fixes resolved the hook failures
5. **Retry Commit**: Attempt commit again with fixes applied

**Hook Failure Types**:

- **Linting Failures**: Deploy code-reviewer for style fixes
- **Test Failures**: Deploy test-engineer for test repairs
- **Security Scan Failures**: Deploy security-auditor for vulnerability fixes
- **Format Failures**: Deploy code-reviewer for formatting corrections
- **Documentation Failures**: Deploy tech-writer for missing docs

### Quality Gate Enforcement

```yaml
Non-Negotiable Rules:
  - NEVER use: git commit --no-verify
  - NEVER bypass: pre-commit hooks
  - NEVER skip: security scanning
  - NEVER ignore: test failures

Auto-Remediation Strategy:
  - Attempt automated fixes first
  - Deploy multiple agent instances for parallel remediation
  - Verify fixes don't introduce new issues
  - Only escalate to user when auto-fix impossible

Escalation Triggers:
  - Critical security vulnerabilities requiring manual review
  - Complex logic errors in tests that need human analysis
  - Architecture changes affecting multiple systems
  - Merge conflicts requiring human resolution
```

## Performance Metrics

### Execution Time Comparison

**Traditional Sequential Approach**: 45-60 seconds

- Code review: 15s
- Security scan: 10s
- Test execution: 20s
- Fix issues: 15s (if needed)

**Wave-Based Parallel Approach**: 8-12 seconds

- Wave 1 (parallel analysis): 3-4s
- Wave 2 (parallel fixes): 3-5s (conditional)
- Wave 3 (final commit): 2-3s

**Performance Benefits**:

- 75-80% faster execution
- More thorough analysis with multiple instances
- Automatic issue remediation
- Higher code quality through comprehensive checks

### Agent Coordination Efficiency

```yaml
Parallelization Strategy:
  Wave 1: 6-8 agents running simultaneously
  Wave 2: 3-5 agents fixing issues in parallel (conditional)
  Wave 3: 2-3 agents for final commit coordination

Resource Optimization:
  - Intelligent file distribution among instances
  - Non-overlapping agent responsibilities
  - Conditional deployment based on actual issues
  - Parallel execution within each wave

Quality Improvements:
  - Multiple specialized reviews vs single general review
  - Targeted fixes by domain experts
  - Comprehensive security coverage
  - Automatic test coverage verification
```

## Prerequisites

- Git repository must be initialized
- Changes must exist (staged or unstaged)
- Pre-commit hooks properly configured (if present)

## Notes

- **Zero-tolerance quality policy**: Issues must be fixed, never bypassed
- **Automatic cleanup**: Removes temporary files before staging
- **Smart retry logic**: Handles pre-commit hook modifications gracefully
- **Comprehensive logging**: Tracks all agent activities and fixes applied
- **Rollback capability**: Can undo auto-fixes if they introduce problems
- **Educational output**: Explains what was fixed and why
- **Integration friendly**: Works with existing CI/CD pipelines and git workflows

The /commit command transforms commit creation from a manual, error-prone process into an automated, quality-assured
workflow that ensures every commit meets high standards while providing rapid feedback and automatic remediation.
