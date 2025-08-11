# /fix-tests Command

## Description
Performs deep-dive analysis of test failures using parallel agent orchestration. Deploys principal-architect, debugger, and test-engineer agents simultaneously to develop theories about failures, then consolidates findings into actionable recommendations. Upon approval, coordinates massive parallel agent deployment (up to 20+) to fix all issues concurrently.

## Usage
```
/fix-tests [test-path]
```

## Arguments
- `test-path` (optional): Specific test file or directory to analyze. If not provided, analyzes all failing tests.

## Behavior
When you use `/fix-tests`, I will:

### Phase 1: Discovery & Analysis (Parallel)
Deploy initial investigation team simultaneously:

1. **Principal-architect** - Analyzes system architecture for design flaws:
   - Reviews overall test architecture
   - Identifies architectural anti-patterns
   - Checks for systemic issues
   - Evaluates test isolation and dependencies

2. **Debugger** - Deep forensic analysis:
   - Traces execution paths of failing tests
   - Identifies race conditions and timing issues
   - Analyzes memory leaks or resource problems
   - Investigates intermittent failures

3. **Test-engineer** - Test-specific investigation:
   - Reviews test implementation quality
   - Checks test data and fixtures
   - Analyzes test coverage gaps
   - Identifies flaky test patterns

4. **Performance-specialist** - Performance-related failures:
   - Analyzes timeout issues
   - Checks resource consumption
   - Identifies bottlenecks causing test failures

5. **Codebase-analyst** - Dependency and integration issues:
   - Maps test dependencies
   - Identifies breaking changes
   - Analyzes module interactions
   - Checks for version conflicts

### Phase 2: Theory Consolidation
After parallel analysis completes:

1. **Gather all theories** from each agent
2. **Identify patterns** across multiple theories
3. **Prioritize root causes** by impact and likelihood
4. **Generate fix strategies** for each root cause
5. **Estimate complexity** and resource requirements

### Phase 3: Recommendation Presentation
Present consolidated findings:

```
=== TEST FAILURE ANALYSIS REPORT ===

IDENTIFIED ROOT CAUSES:
1. [Critical] Race condition in UserService tests
   - Detected by: debugger, test-engineer
   - Impact: 12 tests failing intermittently
   - Fix strategy: Add proper async/await handling

2. [High] Mock data inconsistency
   - Detected by: test-engineer, codebase-analyst
   - Impact: 8 tests with false negatives
   - Fix strategy: Centralize mock data management

3. [Medium] Test isolation issues
   - Detected by: principal-architect
   - Impact: 5 tests polluting global state
   - Fix strategy: Implement proper setup/teardown

RECOMMENDED SOLUTION APPROACH:
- Deploy 15 specialized agents in parallel
- Estimated time: 10-15 minutes
- Success probability: 95%

AGENT DEPLOYMENT PLAN:
- 3x backend-engineer: Fix async handling in services
- 2x frontend-architect: Fix UI component tests
- 2x test-engineer: Rewrite flaky tests
- 2x database-admin: Fix database test fixtures
- 1x security-auditor: Fix auth test mocks
- 1x performance-specialist: Optimize slow tests
- 2x debugger: Fix race conditions
- 1x devops: Fix CI/CD test environment
- 1x integration-specialist: Fix API test mocks

Proceed with parallel fix deployment? (y/n)
```

### Phase 4: Parallel Fix Execution
Upon approval, deploy all agents simultaneously:

1. **Massive parallel deployment** (10-20+ agents):
   - Each agent works on specific fix area
   - No dependencies between agents when possible
   - Real-time progress tracking

2. **Agent coordination**:
   ```
   PARALLEL EXECUTION GROUPS:
   
   Group A (Independent): Launch immediately
   - backend-engineer-1: Fix UserService async
   - backend-engineer-2: Fix OrderService async
   - frontend-architect-1: Fix Button component tests
   - test-engineer-1: Fix authentication tests
   - database-admin-1: Fix user fixtures
   
   Group B (Independent): Launch immediately  
   - frontend-architect-2: Fix Modal component tests
   - test-engineer-2: Fix payment tests
   - database-admin-2: Fix order fixtures
   - security-auditor: Fix JWT mocks
   - performance-specialist: Optimize test suite
   
   Group C (Dependent): Launch after Group A
   - integration-specialist: Fix E2E tests
   - devops: Update CI configuration
   ```

3. **Progress monitoring**:
   ```
   FIXING TESTS: [████████░░░░░░░] 55% (11/20 agents complete)
   
   ✅ backend-engineer-1: Fixed UserService.test.js
   ✅ frontend-architect-1: Fixed Button.test.tsx
   ⚡ test-engineer-1: Working on auth.test.js...
   ⚡ database-admin-1: Updating fixtures...
   ⏸️ integration-specialist: Waiting for dependencies...
   ```

### Phase 5: Verification & Report
After all fixes complete:

1. **Run comprehensive test suite**
2. **Verify all fixes work together**
3. **Generate detailed report**
4. **Commit changes with detailed message**

## Fix Strategies by Failure Type

### Race Conditions
- Deploy multiple debuggers to trace execution
- Backend-engineers add proper synchronization
- Test-engineers add wait conditions

### Flaky Tests
- Test-engineers rewrite with deterministic logic
- Add retry mechanisms where appropriate
- Improve test isolation

### Mock/Stub Issues
- Integration-specialists fix API mocks
- Database-admins fix data fixtures
- Security-auditors fix auth mocks

### Environment Issues
- DevOps fixes CI/CD configuration
- Platform-engineers fix test containers
- Cloud-architects fix cloud test environments

### Performance Issues
- Performance-specialists optimize slow tests
- Parallel test execution setup
- Resource allocation improvements

## Parallel Execution Capabilities

### Maximum Agent Deployment
- **Standard fixes**: 10-15 agents
- **Complex failures**: 15-20 agents
- **Critical situations**: 20-30 agents
- **Emergency**: No upper limit

### Coordination Strategies
1. **Independent parallel**: Agents work on unrelated fixes
2. **Pipeline parallel**: Agents work in stages
3. **Swarm approach**: Multiple agents per problem
4. **Divide and conquer**: Split large problems

## Example Scenarios

### Scenario 1: Large Test Suite Failure (100+ tests)
```
/fix-tests

Deploying initial analysis team...
✅ Principal-architect: Found 3 architectural issues
✅ Debugger: Found 5 race conditions
✅ Test-engineer: Found 15 test quality issues

RECOMMENDATION: Deploy 25 agents to fix all issues
Proceed? y

Launching 25 parallel agents...
[Progress tracking...]
✅ All tests now passing (0 failures, 342 passed)
```

### Scenario 2: Intermittent CI/CD Failures
```
/fix-tests tests/integration/

Analysis complete: Timing-dependent failures detected
RECOMMENDATION: Deploy 8 specialized agents
- 3 debuggers for race condition analysis
- 2 test-engineers for test rewriting
- 2 devops for CI environment fixes
- 1 performance-specialist for timeout tuning

Proceed? y
✅ Fixed 12 intermittent failures
```

### Scenario 3: Post-Refactor Test Breakage
```
/fix-tests

Detected: Major refactoring broke 50+ tests
RECOMMENDATION: Deploy 18 agents
- 5 backend-engineers: Update service tests
- 4 frontend-architects: Update component tests
- 3 integration-specialists: Fix API tests
- 3 test-engineers: Update test utilities
- 2 database-admins: Fix data models
- 1 principal-architect: Oversee coordination

Proceed? y
✅ All 54 broken tests now fixed
```

## Quality Assurance

### Pre-Fix Validation
- Snapshot current test results
- Identify all failure patterns
- Check for environmental factors

### Post-Fix Validation
- Run full test suite 3 times
- Verify no new failures introduced
- Check performance metrics
- Validate in CI/CD environment

### Rollback Capability
- Create backup branch before fixes
- Atomic commits per fix area
- Easy revert if issues arise

## Integration with Other Commands

### Workflow Integration
```bash
/test                    # Identify failures
/fix-tests              # Deep analysis and fix
/test                   # Verify all passing
/commit                 # Commit fixes
/push                   # Push to remote
```

### Command Synergy
- Works with `/test` for initial detection
- Integrates with `/debug` for deep analysis
- Uses `/review` to validate fixes
- Triggers `/commit` after successful fixes

## Advanced Features

### Pattern Learning
- Remembers common failure patterns
- Suggests preventive measures
- Builds knowledge base of fixes

### Predictive Analysis
- Identifies likely future failures
- Suggests proactive improvements
- Recommends test refactoring

### Emergency Mode
```bash
/fix-tests --emergency
```
- Deploys maximum agents immediately
- Skips approval step
- Prioritizes speed over optimization
- For production-down scenarios

## Success Metrics

### Efficiency Metrics
- Tests fixed per minute
- Agent utilization rate
- Parallel execution efficiency
- Time to resolution

### Quality Metrics
- Fix success rate (target: >95%)
- No regression rate (target: 100%)
- Test stability improvement
- Reduced flakiness percentage

## Configuration

### Agent Deployment Limits
```json
{
  "max_parallel_agents": 30,
  "default_agents": 15,
  "emergency_agents": "unlimited",
  "timeout_minutes": 30
}
```

### Customization Options
- Adjust parallel agent limits
- Configure approval requirements
- Set automatic fix thresholds
- Define critical test patterns

## Troubleshooting

### Common Issues
1. **Too many agents overwhelming system**
   - Solution: Reduce parallel limit
   - Use staged deployment

2. **Conflicting fixes**
   - Solution: Better coordination groups
   - Sequential fixing for conflicts

3. **Tests still failing after fixes**
   - Solution: Run second analysis round
   - Deploy specialized agents

## Notes

- **Massive parallelization**: Can deploy 20+ agents simultaneously
- **Intelligent orchestration**: Agents work without conflicts
- **Approval checkpoint**: User controls fix deployment
- **Comprehensive coverage**: Handles all test failure types
- **Learning system**: Improves with each use
- **Emergency capable**: Can handle critical situations
- **Full rollback**: Safe with atomic commits
- **CI/CD aware**: Fixes environment-specific issues
- **Cost-effective**: Parallel execution saves time
- **Success rate**: >95% fix rate on first attempt