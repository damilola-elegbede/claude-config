# /fix-ci Command

## Description

Intelligently resolves CI/CD failures through pattern recognition, automatic fix generation, and predictive failure prevention. Reduces mean time to recovery (MTTR) by automatically diagnosing and fixing common CI issues.

## Usage

```bash
/fix-ci [options]
```

## Options

- `--pr <number>` - Fix specific pull request CI failures
- `--branch <name>` - Fix specific branch (default: current)
- `--predict` - Predict and prevent failures before they occur
- `--optimize` - Optimize CI pipeline performance
- `--report` - Generate CI health report

## Behavior

When you invoke `/fix-ci`, I will:

1. **Fetch CI failure data** from the CI/CD system
2. **Analyze failure patterns** to identify root causes
3. **Generate appropriate fixes** based on failure type
4. **Apply fixes automatically** when confidence is high
5. **Create a commit** with the fixes
6. **Re-trigger CI** to verify the fix worked
7. **Report results** with any manual steps needed

## Failure Categories

I identify and fix these types of CI failures:

### Build Failures

- **Import/Module errors** - Missing dependencies, incorrect paths
- **Compilation errors** - Syntax errors, type mismatches
- **Configuration issues** - Invalid config files, missing env vars
- **Resource constraints** - Out of memory, disk space issues

### Test Failures

- **Assertion failures** - Update test expectations
- **Timeouts** - Increase timeout limits or optimize slow code
- **Flaky tests** - Add retries, fix race conditions
- **Mock/Stub issues** - Update mocks to match implementation
- **Snapshot mismatches** - Update snapshots after verifying changes

### Code Quality Failures

- **Linting errors** - Auto-fix formatting and style issues
- **Type errors** - Fix type annotations and interfaces
- **Coverage drops** - Identify untested code paths
- **Security vulnerabilities** - Apply security patches

### Environment Issues

- **Missing dependencies** - Install required packages
- **Version mismatches** - Align versions across environments
- **Permission errors** - Fix file/directory permissions
- **Network failures** - Add retries for external services

## Fix Strategies

### Automatic Fixes (High Confidence)

I automatically apply these fixes when confidence is >90%:

1. **Linting/Formatting** - Run auto-fixers (prettier, black, gofmt)
2. **Import sorting** - Organize and fix import statements
3. **Dependency updates** - Add missing packages to manifests
4. **Snapshot updates** - Update test snapshots after verification
   - Only after confirming UI/output changes are intentional
   - For broad diffs, require manual approval or linked design sign-off
5. **Timeout increases** - Adjust timeouts for slow tests
6. **Environment variables** - Add missing vars to CI config

### Semi-Automatic Fixes (Medium Confidence)

I generate fixes but request approval when confidence is 70-90%:

1. **Test expectations** - Update assertions based on actual output
2. **Type corrections** - Fix type definitions and annotations
3. **Mock updates** - Adjust mocks to match new signatures
4. **Config corrections** - Fix YAML/JSON configuration errors
5. **Memory limits** - Increase resource allocations

### Manual Fixes (Low Confidence)

I provide guidance but require manual intervention when confidence is <70%:

1. **Logic errors** - Suggest where business logic may be wrong
2. **Breaking changes** - Identify incompatible dependency updates
3. **Infrastructure issues** - External service problems
4. **Security violations** - Require security team review

## Failure Pattern Recognition

I recognize patterns to identify root causes:

### Common Patterns

| Pattern | Likely Cause | Fix Strategy |
|---------|-------------|--------------|
| "Cannot find module" | Missing dependency | Add to package.json |
| "Timeout of X exceeded" | Slow test/network | Increase timeout |
| "Snapshot mismatch" | UI/output changed | Update snapshot |
| "ECONNREFUSED" | Service not running | Start service/mock |
| "heap out of memory" | Memory leak/limit | Increase limit/fix leak |
| "permission denied" | File permissions | Fix chmod/chown |
| "rate limit exceeded" | API limit hit | Add delays/caching |

### Flaky Test Detection

I identify flaky tests by:

- Multiple runs with different results
- Timing-dependent failures
- Order-dependent test failures
- Environment-specific failures
- Random/intermittent failures

For flaky tests, I:

1. Add retry mechanisms
2. Fix race conditions
3. Isolate test dependencies
4. Mock external services
5. Ensure proper cleanup

## Predictive Failure Prevention

When using `--predict`, I:

### Analyze Risk Factors

- Recent code changes that often cause failures
- Dependencies with known issues
- Test coverage gaps
- Complex code sections prone to bugs
- Historical failure patterns

### Preventive Actions

- Run additional tests locally before push
- Check for common issues in changed files
- Verify dependency compatibility
- Ensure environment consistency
- Add missing test coverage

## Pipeline Optimization

When using `--optimize`, I:

### Identify Bottlenecks

- Slow test suites
- Sequential jobs that could parallelize
- Redundant test runs
- Unnecessary build steps
- Cache misses

### Optimization Strategies

- Parallelize independent jobs
- Implement test splitting
- Add caching for dependencies
- Skip unchanged components
- Use incremental builds
- Optimize Docker layers

## CI Health Report

When using `--report`, I generate:

```text
## CI Health Report

### Success Rate
- Last 24 hours: 85%
- Last 7 days: 78%
- Last 30 days: 82%

### Common Failure Causes
1. Flaky tests (35%)
2. Dependency issues (25%)
3. Timeout failures (20%)
4. Linting errors (15%)
5. Other (5%)

### Problem Areas
- Slowest tests: [list of slow tests]
- Flaky tests: [list of unreliable tests]
- Frequent failures: [commonly failing jobs]

### Recommendations
1. Fix these flaky tests first
2. Increase timeouts for these tests
3. Add caching for these dependencies
4. Parallelize these test suites
```

## Agent Coordination

### Primary Agent

- **devops**: Leads CI/CD troubleshooting and fixes

### Supporting Agents

- **test-engineer**: For test-related failures
- **debugger**: For complex failure analysis
- **performance-specialist**: For performance issues
- **quality-gatekeeper**: For quality gates and standards

## Success Metrics

Fix success is measured by:

- CI passes after fix application
- No regression in other tests
- Fix doesn't break other branches
- Solution is permanent, not temporary
- MTTR reduced from baseline

## Workflow Example

```text
User: /fix-ci

Claude: 🔍 Analyzing CI failure on current branch...

Found 3 failures:
1. ❌ Test timeout in auth.test.js
2. ❌ Linting errors in 5 files
3. ❌ Snapshot mismatch in Button.test.jsx

Applying automatic fixes:
✅ Fixed linting errors (auto-formatted)
✅ Updated snapshot after verifying changes
✅ Increased timeout from 5s to 10s

Creating commit: "fix: resolve CI failures - timeout, lint, snapshot"
Pushing fixes...
Re-triggering CI...

✅ CI is now passing! All failures resolved.
```

## Notes

- Always verify fixes don't introduce new issues
- Some failures may indicate real bugs, not CI issues
- Flaky tests should be fixed, not just retried
- Document why timeouts were increased
- Regular CI optimization prevents accumulation of tech debt
- Consider splitting long-running test suites
