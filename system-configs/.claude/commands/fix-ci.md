# /fix-ci Command

## Description

Orchestrates multiple specialized agents to comprehensively analyze and fix CI/CD failures by fetching real data from GitHub, performing parallel analysis, and applying targeted fixes through expert agents.

## Usage

```bash
/fix-ci [options]
```

## Options

- `--pr <number>` - Fix CI failures for a specific pull request
- `--branch <name>` - Fix CI failures for a specific branch (default: current)
- `--run-id <id>` - Target a specific workflow run ID
- `--all` - Analyze all recent failures (last 5 runs)

## Behavior

When you invoke `/fix-ci`, I will:

1. **Fetch CI Data** via git-workflow-specialist to get actual failure logs from GitHub
2. **Parallel Analysis** - Deploy multiple agents simultaneously to analyze failures:
   - Each agent examines the logs from their domain expertise
   - Ambiguous failures are analyzed by ALL potentially relevant agents
3. **Synthesize Findings** - Combine insights from all agents
4. **Parallel Fix Implementation** - Deploy appropriate agents to fix identified issues
5. **Verification** - Ensure all failures are addressed before completing
6. **Re-trigger CI** - Validate fixes work

## Core Workflow

### Phase 1: Data Collection

```yaml
Primary Agent:
  - git-workflow-specialist: Fetches CI logs and failure data from GitHub
  
Retrieves:
  - Failed workflow runs
  - Error messages and stack traces
  - Test failure details
  - Build logs
  - Performance metrics
```

### Phase 2: Parallel Analysis

```yaml
Simultaneous Deployment:
  debugger:
    - Analyzes stack traces
    - Identifies code-level bugs
    - Traces execution paths
    - Pinpoints logic errors
    
  devops:
    - Reviews CI/CD configuration
    - Checks environment variables
    - Validates pipeline syntax
    - Identifies infrastructure issues
    
  test-engineer:
    - Examines test failures
    - Identifies flaky tests
    - Reviews test coverage gaps
    - Analyzes assertion failures
    
  performance-specialist:
    - Detects performance regressions
    - Identifies resource bottlenecks
    - Analyzes timeout issues
    - Reviews memory/CPU usage
    
  security-auditor:
    - Checks security scan failures
    - Reviews vulnerability reports
    - Validates compliance checks
    - Analyzes authentication issues
    
  principal-architect: (if no clear owner)
    - Handles complex architectural issues
    - Reviews system-wide problems
    - Analyzes cross-cutting concerns
```

### Phase 3: Ambiguity Resolution

When a failure could belong to multiple domains:

```yaml
Example: "Connection timeout in auth test"
Deploy ALL relevant agents:
  - test-engineer (test failure)
  - performance-specialist (timeout)
  - security-auditor (auth-related)
  - debugger (potential code issue)

Each provides their perspective, ensuring comprehensive coverage
```

### Phase 4: Fix Implementation

Based on analysis results, deploy fixing agents in parallel:

```yaml
Parallel Fix Deployment:
  Code Issues → backend-engineer/frontend-architect
  Test Issues → test-engineer
  CI Config → devops
  Performance → performance-specialist
  Security → security-auditor
  Architecture → principal-architect
```

### Phase 5: Verification Loop

```yaml
Verification:
  1. Check all identified issues have fixes
  2. If any unaddressed → return to Phase 2
  3. Create comprehensive fix commit
  4. Push changes
  5. Re-trigger CI
  6. Monitor for success
  7. Deploy execution-evaluator to verify:
     - All CI failures were properly fetched
     - Analysis covered all failure types
     - Fixes were correctly applied
     - No regressions introduced
     - CI genuinely passing (not false positive)
```

## Failure Analysis Matrix

| Failure Type | Primary Analyst | Secondary Analysts | Fix Agent |
|-------------|-----------------|-------------------|-----------|
| Syntax Error | debugger | devops | backend-engineer |
| Test Failure | test-engineer | debugger | test-engineer |
| Build Config | devops | principal-architect | devops |
| Timeout | performance-specialist | test-engineer, debugger | performance-specialist |
| Security Scan | security-auditor | devops | security-auditor |
| Import Error | debugger | devops, test-engineer | backend-engineer |
| Type Error | debugger | test-engineer | backend-engineer |
| Resource Limit | performance-specialist | devops | devops |
| Flaky Test | test-engineer | debugger, performance-specialist | test-engineer |
| Network Error | devops | debugger, test-engineer | devops |
| Permission Error | devops | security-auditor | devops |
| Dependency Issue | devops | debugger, principal-architect | dependency-strategist |
| Unknown/Complex | principal-architect | ALL agents | varies |

## Parallel Execution Strategy

### Maximum Parallelization Points

1. **Initial Analysis**: ALL analysis agents run simultaneously
2. **Ambiguous Failures**: Multiple agents analyze the same failure
3. **Independent Fixes**: Different fixes applied to different files/systems
4. **Verification**: Multiple verification checks run in parallel

### Example Parallel Flow

```text
User: /fix-ci

[PARALLEL BATCH 1]
├── git-workflow-specialist: Fetch GitHub CI data
│
[PARALLEL BATCH 2 - Analysis]
├── debugger: Analyze code errors
├── devops: Check CI configuration
├── test-engineer: Review test failures
├── performance-specialist: Check performance issues
└── security-auditor: Scan security failures

[SYNTHESIS]
└── Claude: Combine all findings

[PARALLEL BATCH 3 - Fixes]
├── backend-engineer: Fix syntax errors in api/
├── test-engineer: Fix flaky tests
├── devops: Update CI timeout settings
└── performance-specialist: Optimize slow queries

[VERIFICATION]
└── All issues addressed? If no, return to BATCH 2
```

## Real GitHub Integration

### Data Fetched by git-workflow-specialist

```bash
# Get latest failed workflow runs
gh run list --workflow=ci.yml --status=failure --limit=5

# Get detailed failure logs
gh run view <run-id> --log-failed

# Get specific job failures
gh run view <run-id> --job=<job-id>

# Get PR check failures
gh pr checks <pr-number> --watch
```

### Failure Pattern Extraction

The git-workflow-specialist extracts:
- Error messages with line numbers
- Failed test names and assertions
- Build error details
- Timeout locations
- Security scan results
- Coverage reports

## Comprehensive Coverage Guarantee

The command continues until:

1. **All failures analyzed**: Every error in the CI log has been examined
2. **All fixes attempted**: Each identified issue has a fix implemented or documented
3. **No stone unturned**: Even unclear errors get principal-architect review
4. **Verification complete**: CI runs successfully or all blockers are documented

### Iteration Loop

```python
while ci_failures_exist:
    failures = git_workflow_specialist.fetch_failures()
    
    # Parallel analysis
    analyses = parallel_deploy([
        debugger.analyze(failures),
        devops.analyze(failures),
        test_engineer.analyze(failures),
        performance_specialist.analyze(failures),
        security_auditor.analyze(failures)
    ])
    
    # Determine fix agents
    fix_agents = determine_fix_agents(analyses)
    
    # Parallel fixes
    fixes = parallel_deploy(fix_agents)
    
    # Apply and verify
    apply_fixes(fixes)
    ci_failures_exist = check_ci_status()
    
    # Final validation
    if not ci_failures_exist:
        execution_evaluator.verify_complete_resolution()
```

## Success Criteria

The command succeeds when:

- ✅ All CI checks pass
- ✅ All identified issues have fixes applied
- ✅ No new failures introduced
- ✅ Performance not degraded
- ✅ Security checks still pass
- ✅ execution-evaluator confirms successful resolution

## Example Execution

```text
User: /fix-ci --pr 1234

Claude: Orchestrating CI fix for PR #1234...

[Phase 1: Data Collection]
Deploying git-workflow-specialist to fetch CI failures...

Found 4 failures in workflow run #5678:
1. ❌ TypeError in user.service.ts:45
2. ❌ Test timeout in auth.test.js
3. ❌ ESLint errors in 3 files
4. ❌ Docker build failed - missing dependency

[Phase 2: Parallel Analysis]
Deploying 5 agents for comprehensive analysis...

debugger: TypeError is null reference on undefined user object
test-engineer: Timeout suggests slow API mock or race condition
devops: Docker failure due to missing npm package in dockerfile
performance-specialist: Test timeout correlates with unoptimized query
security-auditor: No security implications detected

[Phase 3: Fix Implementation]
Deploying parallel fixes:
- backend-engineer: Fixing null reference with proper validation
- test-engineer: Adding proper async/await and increasing timeout
- devops: Updating Dockerfile with missing dependency
- code-reviewer: Auto-fixing ESLint issues

[Phase 4: Creating Fix]
All issues addressed. Creating fix commit...
Pushing fixes...
Re-triggering CI...

[Phase 5: Final Verification]
Deploying execution-evaluator to verify success...

execution-evaluator confirms:
✅ All 4 original failures properly identified
✅ Each failure received appropriate analysis
✅ Fixes correctly applied without side effects
✅ CI genuinely passing (not masking issues)
✅ No performance regressions detected

✅ CI is now passing! All 4 failures comprehensively resolved.
```

## Notes

- Leverages real GitHub CLI data, not assumptions
- Parallel analysis ensures no blind spots
- Multiple agents can analyze the same failure for comprehensive coverage
- Continues until ALL failures are addressed
- Fix delegation based on actual analysis, not patterns
- Maximum parallelization for speed