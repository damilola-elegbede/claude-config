# /check-pr Command

## Description
Automatically analyzes CI/CD failures on the current PR and deploys specialist agents to resolve issues. MUST BE USED when CI/CD checks fail. Use PROACTIVELY after push to ensure PR passes all automated checks.

## Usage
```
/check-pr [pr-number]
```

## Arguments
- `pr-number` (optional): Specific PR number to check. If not provided, uses the current branch's PR.

## Behavior
When you use `/check-pr`, I will:

1. **Identify the PR**:
   - Use current branch's PR if no argument provided
   - Or use the specified PR number
   - Verify PR exists and is accessible

2. **Fetch CI/CD status**:
   - Query PR checks via `gh pr checks`
   - Identify all failing, pending, and passing checks
   - Retrieve detailed logs for failed checks
   - Parse error messages and failure patterns

3. **Analyze failure types**:
   - **Build failures**: Compilation errors, dependency issues
   - **Test failures**: Unit, integration, E2E test failures
   - **Linting violations**: Code style, formatting issues
   - **Security scans**: Vulnerability findings, SAST/DAST results
   - **Performance regressions**: Benchmark failures
   - **Coverage drops**: Below threshold coverage
   - **Docker/container issues**: Build or deployment failures
   - **Infrastructure problems**: Terraform, CloudFormation errors

4. **Deploy specialist agents**:
   Based on failure type, deploy appropriate agents in parallel:
   - **devops**: CI/CD pipeline issues, build configuration
   - **debugger**: Test failures, runtime errors
   - **security-auditor**: Security scan failures
   - **backend-engineer**: API/server test failures
   - **frontend-architect**: UI test failures
   - **performance-specialist**: Performance regression
   - **test-engineer**: Coverage issues, flaky tests
   - **database-admin**: Migration or database test failures
   - **cloud-architect**: Infrastructure deployment issues

5. **Execute automated fixes**:
   - Apply fixes directly to the codebase
   - Update configuration files
   - Fix linting violations
   - Patch security vulnerabilities
   - Resolve dependency conflicts
   - Fix failing tests or mark as flaky
   - Update CI/CD pipeline configuration

6. **Verify fixes locally**:
   - Run affected tests locally
   - Execute linters on changed files
   - Validate configuration changes
   - Ensure fixes don't introduce new issues

7. **Commit and push fixes**:
   - Create atomic commits for each fix type
   - Push changes to update PR
   - Trigger CI/CD re-run automatically

8. **Monitor re-run**:
   - Wait for CI/CD to re-execute
   - Verify all checks now pass
   - If failures persist, iterate with different approach
   - Report final status

## CI/CD Platform Support

### GitHub Actions
```bash
gh pr checks                    # View check status
gh run view <run-id> --log      # Get detailed logs
gh workflow run <workflow>      # Trigger re-run
```

### GitLab CI
```bash
glab ci view                    # View pipeline status
glab ci trace <job-id>          # Get job logs
glab ci retry <pipeline-id>     # Retry pipeline
```

### CircleCI
```bash
circleci workflow show          # View workflow status
circleci job logs              # Get job logs
circleci workflow rerun        # Retry workflow
```

## Failure Analysis Patterns

### Build Failures
**Symptoms**: Compilation errors, missing dependencies, syntax errors
**Agents**: devops, backend-engineer, frontend-architect
**Common Fixes**:
- Update package versions in package.json/requirements.txt
- Fix import statements
- Resolve type errors
- Update build configuration

### Test Failures
**Symptoms**: Assertion failures, timeout errors, flaky tests
**Agents**: debugger, test-engineer
**Common Fixes**:
- Fix test assertions
- Update test data/mocks
- Increase timeout values
- Add retry logic for flaky tests
- Fix race conditions

### Linting Violations
**Symptoms**: ESLint, Prettier, Black, RuboCop errors
**Agents**: backend-engineer, frontend-architect
**Common Fixes**:
- Auto-format code
- Fix style violations
- Update linter configuration
- Add linter disable comments where appropriate

### Security Issues
**Symptoms**: CVE findings, OWASP violations, secrets detected
**Agents**: security-auditor, devops
**Common Fixes**:
- Update vulnerable dependencies
- Remove exposed secrets
- Fix security headers
- Implement input validation

### Coverage Drops
**Symptoms**: Coverage below threshold
**Agents**: test-engineer
**Common Fixes**:
- Add missing unit tests
- Increase test coverage for new code
- Update coverage thresholds if justified

## Smart Resolution Strategies

### Priority-Based Fixing
1. **Security issues** (always first)
2. **Build failures** (blocks everything)
3. **Test failures** (blocks merge)
4. **Linting issues** (quality gates)
5. **Coverage drops** (maintainability)
6. **Performance issues** (optimization)

### Parallel Agent Deployment
Deploy multiple agents simultaneously for different failure types:
```
Build Failure → devops
Test Failures → debugger + test-engineer
Linting → backend-engineer + frontend-architect
Security → security-auditor
```

### Iterative Resolution
If first attempt fails:
1. Analyze why fix didn't work
2. Deploy different specialist agent
3. Try alternative approach
4. Escalate to user if unresolvable

## Example Workflows

### Simple linting fix
```bash
/check-pr
# Detects ESLint violations
# Deploys frontend-architect
# Auto-formats code
# Commits and pushes
# ✅ All checks pass
```

### Complex multi-failure scenario
```bash
/check-pr 123
# Detects: build failure + 3 test failures + security issue
# Deploys: devops + debugger + security-auditor (parallel)
# Fixes: dependency issue + test assertions + CVE patch
# Commits fixes in logical groups
# Pushes and monitors re-run
# ✅ PR ready to merge
```

### Persistent failure handling
```bash
/check-pr
# Initial fix attempt
# Some checks still failing
# Analyzes new failure pattern
# Deploys different agents
# Applies alternative fixes
# ✅ Eventually resolves all issues
```

## Integration with Other Commands

### Typical workflow
```bash
/push                    # Push changes (includes linting)
/check-pr                # Fix any CI/CD failures
/ship                    # Complete deployment pipeline
```

### With PR review fixes
```bash
/resolve-cr          # Fix CodeRabbit comments
/check-pr                # Fix CI/CD issues
/push                    # Push all fixes
```

## Configuration

### Required Tools
- GitHub CLI (`gh`) or equivalent for your platform
- Repository write access
- CI/CD visibility permissions

### Supported CI/CD Systems
- GitHub Actions
- GitLab CI/CD
- CircleCI
- Jenkins (with API access)
- Azure DevOps
- Bitbucket Pipelines
- Travis CI

## Success Metrics

The command succeeds when:
- ✅ All CI/CD checks turn green
- ✅ No security vulnerabilities remain
- ✅ Tests pass with required coverage
- ✅ Code meets style standards
- ✅ Build artifacts generated successfully

## Failure Handling

If unable to fix automatically:
1. Provides detailed analysis of the issue
2. Suggests manual intervention steps
3. Creates TODO comments in code for complex fixes
4. Opens draft issues for tracking unresolved problems

## Notes

- MUST BE USED when CI/CD checks fail on a PR
- Use PROACTIVELY after push to prevent PR delays
- Deploys specialist agents based on failure type
- Handles multiple failure types in parallel
- Commits fixes with clear messages
- Safe re-run if some issues persist
- Integrates with all major CI/CD platforms
- Provides detailed logs and analysis
- Can iterate multiple times to resolve complex issues