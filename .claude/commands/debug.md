# /debug Command

## Description

Performs systematic root cause analysis for complex bugs using multi-agent forensics. Specializes in hard-to-reproduce issues like race conditions, memory leaks, intermittent failures, and production-only bugs that traditional debugging cannot solve.

## Usage

```bash
/debug <issue_description>
```

## Behavior

When you invoke `/debug`, I will:

1. **Deploy the debugger agent** as the primary investigator
2. **Analyze the issue description** to identify symptom patterns
3. **Deploy specialized agents** based on the issue type
4. **Conduct systematic investigation** using appropriate techniques
5. **Generate reproduction steps** if possible
6. **Provide root cause analysis** with fix recommendations

## Issue Classification

I classify bugs into categories to determine the investigation approach:

### Intermittent Issues
- **Symptoms**: Works sometimes, fails unpredictably
- **Approach**: Statistical analysis, multiple reproduction attempts
- **Agents**: debugger, performance-specialist
- **Focus**: Timing, load conditions, environmental factors

### Race Conditions
- **Symptoms**: Concurrency failures, deadlocks, data corruption
- **Approach**: Thread analysis, lock inspection, timing manipulation
- **Agents**: debugger, backend-engineer
- **Focus**: Shared resources, synchronization points, atomic operations

### Memory Issues
- **Symptoms**: Growing memory usage, crashes, slow degradation
- **Approach**: Heap analysis, reference tracking, allocation patterns
- **Agents**: debugger, code-archaeologist
- **Focus**: Leak sources, circular references, resource cleanup

### Production-Only Bugs
- **Symptoms**: Works in dev/staging, fails in production
- **Approach**: Environment comparison, configuration analysis, scale testing
- **Agents**: debugger, production-reliability-engineer, monitoring-specialist
- **Focus**: Environment differences, data volumes, external dependencies

### Performance Degradation
- **Symptoms**: Slowness, timeouts, resource exhaustion
- **Approach**: Profiling, bottleneck analysis, load testing
- **Agents**: debugger, performance-specialist, performance-predictor
- **Focus**: Hot paths, N+1 queries, inefficient algorithms

## Investigation Process

### Phase 1: Evidence Collection

I gather all available information in parallel:

- **Logs**: Application, system, error, and audit logs
- **Stack Traces**: All available error traces and core dumps
- **Metrics**: CPU, memory, disk, network utilization
- **User Reports**: Symptoms, reproduction steps, affected users
- **Code Changes**: Recent commits, deployments, configuration changes
- **Environment**: Differences between working and failing environments

### Phase 2: Hypothesis Formation

Based on evidence, I form hypotheses about the root cause:

1. **Most Likely**: Based on symptom patterns and similar past issues
2. **Alternative**: Other possible causes to investigate
3. **Edge Cases**: Unlikely but severe possibilities to rule out

### Phase 3: Systematic Investigation

I use appropriate techniques based on the issue type:

#### Binary Search (for regressions)
- Find last working version
- Find first broken version
- Bisect commits to find exact breaking change
- Analyze the specific changes that caused the issue

#### Reproduction Attempts
- **Deterministic**: Exact step-by-step reproduction
- **Statistical**: Multiple runs to catch intermittent issues
- **Stress Testing**: High load to trigger race conditions
- **Time-Based**: For time-dependent issues
- **Synthetic**: Using artificial data/conditions

#### Differential Analysis
- Compare working vs failing environments
- Analyze configuration differences
- Examine data variations
- Review dependency versions

### Phase 4: Root Cause Identification

Once identified, I provide:

- **Primary Cause**: The direct cause of the issue
- **Contributing Factors**: Conditions that enable the bug
- **Impact Scope**: What systems/users are affected
- **Risk Assessment**: Likelihood of recurrence

### Phase 5: Solution Development

I deliver:

- **Immediate Fix**: Quick resolution to stop the bleeding
- **Proper Solution**: Comprehensive fix addressing root cause
- **Prevention Measures**: How to prevent similar issues
- **Test Cases**: To verify the fix and prevent regression

## Agent Coordination

### Primary Investigator
- **debugger**: Leads the investigation, coordinates other agents

### Specialist Support (deployed as needed)
- **performance-specialist**: For performance-related issues
- **code-archaeologist**: For historical code analysis and memory leaks
- **backend-engineer**: For concurrency and system-level issues
- **production-reliability-engineer**: For production-specific problems
- **monitoring-specialist**: For observability and metrics analysis
- **security-auditor**: When security implications are suspected

### Parallel Execution
When multiple hypotheses exist, I deploy agents in parallel to investigate different theories simultaneously, reducing time to resolution.

## Output Format

After investigation, I provide:

### Bug Report
```
## Issue: [Title]

### Summary
[One paragraph description of the issue and its impact]

### Root Cause
[Specific technical cause of the issue]

### Evidence
- [Key evidence point 1]
- [Key evidence point 2]
- [Key evidence point 3]

### Reproduction Steps
1. [Step to reproduce]
2. [Step to reproduce]
3. [Expected vs actual behavior]

### Solution
[Recommended fix with code changes if applicable]

### Prevention
[How to prevent this class of bug in the future]

### Test Coverage
[Test cases to add to prevent regression]
```

## Common Investigation Patterns

### Pattern: Intermittent Test Failures
1. Collect failure history and patterns
2. Identify environmental factors (time, load, data)
3. Add logging around failure points
4. Run with various conditions to find trigger
5. Implement deterministic reproduction

### Pattern: Memory Leak
1. Monitor memory growth over time
2. Identify allocation patterns
3. Track reference chains
4. Find retention points
5. Implement proper cleanup

### Pattern: Race Condition
1. Identify shared resources
2. Analyze synchronization mechanisms
3. Add strategic delays to expose timing issues
4. Review lock ordering
5. Implement proper synchronization

### Pattern: Production-Only Failure
1. Compare all environment variables
2. Analyze data volume differences
3. Check external service behaviors
4. Review configuration management
5. Implement environment parity

## Success Criteria

The investigation is complete when:

- Root cause is identified with evidence
- Issue can be reproduced reliably (or explanation why not)
- Fix is implemented and tested
- Prevention measures are in place
- Documentation is updated

## Notes

- Complex bugs often have multiple contributing factors
- Production issues take priority over development issues
- Always consider the cost of the bug vs cost of investigation
- Some bugs may require accepting and working around rather than fixing
- Document all findings for future reference