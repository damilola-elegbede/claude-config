---
description: Wave-based root cause analysis for complex bugs
argument-hint: [issue_description]
thinking-level: ultrathink
thinking-tokens: 31999
---

# /debug Command

## Usage

```bash
/debug [issue_description]      # Progressive multi-wave investigation with adaptive specialization
/debug --repro <steps>          # Focus on reproduction step creation
/debug --performance            # Performance-specific debugging analysis
/debug "memory leak crashes"    # Memory issue investigation
/debug "race condition"         # Concurrent access debugging
```

## Description

Systematic root cause analysis for complex bugs using wave-based multi-agent forensics.
Progressive investigation with adaptive specialization based on issue classification.
Specializes in hard-to-reproduce issues, race conditions, memory leaks, and production-only failures.

### Thinking Level: ULTRATHINK (31,999 tokens)

This command requires maximum thinking depth due to:
- **Iterative investigation waves**: 3-7+ waves of progressive forensic analysis
- **Complex bug pattern recognition**: Race conditions, memory leaks, intermittent failures
- **Multi-system root cause analysis**: Distributed system failures with cascading effects
- **Adaptive specialization logic**: Dynamic agent deployment based on issue classification
- **Production forensics complexity**: Analyzing logs, traces, and system states across environments

**Iterative Investigation Process**: Complex bugs often require multiple investigation waves beyond the standard
3-wave approach. The debugging process continues with additional waves until the root cause is fully identified and
resolved. Each wave builds progressively on previous findings, with Claude orchestrating continued investigation
cycles as needed.

## Expected Output

### Memory Leak Investigation

```text
🔍 Memory Leak Investigation: User Session Cache

📊 Evidence: Heap growing 50MB/hour, no GC pressure, correlates with logins
🎯 Root Cause: Session objects in WeakMap never cleaned, event listeners maintaining references
🔧 Fix: Added cleanup timer, proper listener removal, 24h TTL
✅ Verification: Memory stable after 2h testing
```

### Race Condition Analysis

```text
🧵 Race Condition Investigation: Payment Processing

📊 Evidence: Duplicate charges ~0.1% under high load, conflicting DB timestamps
🎯 Root Cause: Non-atomic validation+charge, no idempotency key enforcement
🔧 Fix: DB transactions, unique constraint, distributed lock
✅ Verification: No duplicates in 1000 concurrent test transactions
```

### Production-Only Bug Analysis

```text
🏭 Production-Only Investigation: API Timeout Errors

📊 Evidence: Works in dev/staging, 504 timeouts in prod, affects 30% of /users/search
🎯 Root Cause: 10M users vs 1K in staging, missing index, table scan at scale
🔧 Fix: Composite index (email, status, created_at), query optimization
✅ Verification: Response time 8s → 120ms
```

## Behavior

### Wave-Based Orchestration Strategy

Progressive investigation with adaptive specialization through coordinated agent waves:

```yaml
# WAVE 1: Initial Investigation (Parallel Foundation Team)
wave_1:
  trigger: Issue description provided
  parallel_agents:
    debugger:
      role: Basic root cause analysis and forensic evidence gathering
      input: Error logs, stack traces, system state, reproduction attempts
      output: Initial hypotheses, evidence patterns, investigation priorities

    codebase-analyst:
      role: Code pattern identification and architectural analysis
      input: Source code, error contexts, system architecture, change history
      output: Code smells, pattern analysis, potential root causes, scope assessment

    test-engineer:
      role: Reproduction attempts and validation strategy development
      input: Bug description, reproduction steps, test scenarios, environment data
      output: Reproduction reliability, test cases, validation plans, success rates

  duration: 3-5 minutes
  success_criteria: Basic understanding established, issue classified

# CLAUDE DECISION POINT: Issue Classification and Wave 2 Planning
claude_analysis:
  input: Wave 1 findings from all agents
  classification_types:
    - Memory Issues: ["memory leak", "growing heap", "OOM", "crashes", "GC pressure"]
    - Race Conditions: ["deadlock", "data corruption", "concurrent access", "intermittent", "timing"]
    - Production-Only: ["works in dev", "scale dependent", "env specific", "load dependent"]
    - Performance: ["slow response", "timeout", "high CPU", "resource exhaustion", "bottleneck"]
    - Test Failures: ["flaky tests", "CI failures", "test environment", "assertion errors"]

  output:
    - Issue type classification with confidence score
    - Specialized agent deployment plan for Wave 2
    - Investigation approach and resource allocation
    - Expected timeline and success metrics

# WAVE 2: Specialized Investigation (Adaptive Based on Issue Type)
wave_2_deployments:

  memory_issues:
    condition: Memory-related symptoms detected
    parallel_agents:
      - performance-engineer: Heap analysis, allocation tracking, GC profiling
      - performance-engineer: Memory metrics analysis, trend identification
      - debugger (instance-2): Memory leak specific investigation patterns
    approach: Parallel heap analysis, reference tracking, allocation pattern investigation
    expected_duration: 5-8 minutes

  race_conditions:
    condition: Concurrency or timing-related symptoms
    parallel_agents:
      - debugger (instance-2): Thread synchronization analysis
      - debugger (instance-3): Lock contention investigation
      - performance-engineer: Concurrent access profiling
    approach: Multiple debugger instances for comprehensive concurrency analysis
    expected_duration: 6-10 minutes

  production_only:
    condition: Environment-specific or scale-dependent issues
    parallel_agents:
      - platform-engineer: Infrastructure and environment analysis
      - devops: Deployment and configuration investigation
      - performance-engineer: Production metrics and log correlation
    approach: Environment comparison, scale testing, infrastructure analysis
    expected_duration: 7-12 minutes

  performance_degradation:
    condition: Speed, resource, or efficiency issues
    parallel_agents:
      - performance-engineer (instance-2): CPU and resource profiling
      - performance-engineer (instance-3): Database and query optimization
      - performance-engineer: Performance trend analysis
    approach: Comprehensive parallel profiling across all performance vectors
    expected_duration: 5-9 minutes

  test_failures:
    condition: Test-related or CI/CD issues
    parallel_agents:
      - test-engineer (instance-2): Test environment analysis
      - test-engineer (instance-3): Flaky test investigation
      - devops: CI/CD pipeline investigation
    approach: Multiple test engineer instances for comprehensive test failure analysis
    expected_duration: 4-7 minutes

# CLAUDE VALIDATION POINT: Root Cause Verification
claude_verification:
  input: Wave 2 specialized findings
  validation_criteria:
    - Root cause identified with high confidence (>80%)
    - Reproduction steps reliable and consistent
    - Fix approach clearly defined and scoped
    - Risk assessment completed

  decision_outcomes:
    root_cause_identified: Proceed to Wave 3 (Solution Implementation)
    inconclusive_results: Deploy additional specialized investigation waves
    multiple_root_causes: Coordinate parallel fix streams
    insufficient_evidence: Continue with Wave N+1 investigation cycles

# WAVE 3: Solution Implementation (Parallel Fix Deployment)
wave_3:
  trigger: Root cause verified with high confidence
  parallel_agents:

    fix_implementation:
      # Deploy appropriate fix agents based on issue type and scope
      backend-engineer: Server-side fixes, API changes, database modifications
      frontend-engineer: Client-side fixes, UI changes, state management
      devops: Infrastructure fixes, deployment changes, configuration updates
      database-admin: Schema changes, query optimization, index management

    test_validation:
      test-engineer (instance-4):
        role: Create comprehensive reproduction tests
        deliverables: Unit tests, integration tests, reproduction scenarios

      test-engineer (instance-5):
        role: Fix verification and regression testing
        deliverables: Verification test suite, performance benchmarks

    quality_assurance:
      code-reviewer:
        role: Fix quality verification and security assessment
        deliverables: Code review, security analysis, best practices validation

  coordination: All Wave 3 agents work in parallel with clear deliverable boundaries
  duration: 8-15 minutes depending on fix complexity
  success_criteria: Fix implemented, tested, and verified

# ITERATIVE WAVE CONTINUATION
adaptive_continuation:
  trigger: Wave 3 solution reveals deeper issues or incomplete resolution
  approach: |
    Complex bugs may require 4-7+ investigation waves for complete resolution.
    Each wave builds progressively on previous findings until root cause is fully resolved.

  wave_n_examples:
    wave_4: "Continue investigation cycles until root cause identified and verified"
    wave_5: "Deep architectural analysis if initial fixes reveal systemic issues"
    wave_6: "Cross-system impact analysis for distributed system bugs"
    wave_7: "Performance optimization after core fix implementation"

  continuation_triggers:
    - Wave 3 fix reveals additional underlying issues
    - Solution works partially but symptoms persist
    - Fix introduces new problems or regressions
    - Root cause analysis incomplete or confidence <80%
    - Distributed system effects require broader investigation
    - Performance implications need deeper analysis

  escalation_approach: |
    - Deploy specialized investigation teams for newly discovered issues
    - Expand scope to include related systems and dependencies
    - Engage architecture specialists for systemic problems
    - Continue until complete resolution with high confidence validation

  success_criteria: |
    Investigation continues until:
    ✅ Root cause fully identified with >90% confidence
    ✅ Complete fix implemented and thoroughly tested
    ✅ No residual symptoms or related issues detected
    ✅ Solution validated under realistic production conditions
    ✅ Prevention measures documented and implemented
```

### Concrete Investigation Patterns

#### Memory Leak Investigation

```bash
# Heap dump analysis pattern
investigate_memory_leak() {
  echo "🔍 Analyzing memory patterns..."

  # Multi-language memory profiling
  [[ -n "$JAVA_PID" ]] && jcmd $JAVA_PID GC.dump_heap heap.hprof
  [[ -x "$(command -v python)" ]] && echo "import tracemalloc; tracemalloc.start()" >> memory_trace.py
  [[ -x "$(command -v node)" ]] && echo "console.log(process.memoryUsage())" >> memory_check.js
}
```

#### Race Condition Analysis

```bash
# Thread synchronization analysis
analyze_race_condition() {
  echo "🧵 Analyzing concurrent access patterns..."

  # Multi-language thread analysis
  [[ -x "$(command -v jstack)" ]] && jstack $PID | grep -A3 -B3 "BLOCKED\|WAITING"
  [[ -x "$(command -v go)" ]] && echo "Run with: go run -race main.go"
  python -c "import threading; print(f'Active threads: {threading.active_count()}')" 2>/dev/null || true
}
```

#### Environment Difference Analysis

```bash
# Environment difference analysis
compare_environments() {
  echo "🔍 Comparing dev vs production environments..."

  diff -u dev.env prod.env 2>/dev/null || echo "Environment variables differ"
  [[ -f package.json ]] && { npm list --production > prod_deps.txt; diff dev_deps.txt prod_deps.txt; }
  echo "Memory: $(grep MemTotal /proc/meminfo 2>/dev/null || echo 'N/A')"
}
```

#### Performance Profiling Patterns

```javascript
// Performance profiling patterns
const performance_debug = {
  profile_cpu: () => { console.profile('cpu-analysis'); /* code */ console.profileEnd('cpu-analysis'); },
  track_memory: () => {
    const used = process.memoryUsage();
    console.log('Memory:', Object.keys(used).map(k => `${k}: ${Math.round(used[k]/1024/1024)}MB`));
  },
  analyze_queries: () => console.log('EXPLAIN ANALYZE SELECT ...')
};
```

### Wave Execution Timeline

```yaml
Total Investigation Time: 15-35+ minutes (adaptive based on complexity)

Wave 1 (Foundation): 3-5 minutes
  - All agents deploy simultaneously
  - Basic investigation and classification
  - Issue type determination

Claude Decision Point: 1-2 minutes
  - Analysis of Wave 1 findings
  - Wave 2 deployment planning
  - Resource allocation optimization

Wave 2 (Specialized): 4-12 minutes (varies by issue type)
  - Adaptive agent deployment based on issue classification
  - Deep dive investigation with appropriate specialists
  - Parallel instances for comprehensive coverage

Claude Validation: 1-2 minutes
  - Root cause verification
  - Solution approach validation
  - Wave 3 deployment authorization OR continuation planning

Wave 3 (Implementation): 8-15 minutes
  - Parallel fix implementation
  - Comprehensive test creation
  - Quality verification and validation

Wave N (Continuation): Variable duration
  - Additional investigation cycles as needed
  - Progressive problem resolution
  - Continues until complete resolution achieved

Adaptive Benefits:
  - Iterative approach handles complex multi-layered issues
  - Each wave builds on previous findings systematically
  - No time limits on achieving complete resolution
  - Higher accuracy through persistent investigation
  - Handles distributed system and architectural complexities
```

### Debugging Toolchain

#### Language-Specific Tools

```bash
# Java debugging
debug_java() { jstack $PID > threads.txt; jmap -dump:live,format=b,file=heap.hprof $PID; }

# Node.js debugging
debug_nodejs() { node --inspect-brk=9229 app.js; kill -USR1 $PID; }

# Python debugging
debug_python() { py-spy top --pid $PID; python -m cProfile script.py; }

# Go debugging
debug_go() { go run -race main.go; dlv attach $PID; }
```

#### Database Query Analysis

```sql
-- PostgreSQL debugging
EXPLAIN ANALYZE SELECT * FROM slow_table;
SET log_min_duration_statement = 1000;
```

### Reproduction Strategies

#### Intermittent Bug Reproduction

```bash
# Automated reproduction attempts
reproduce_intermittent() {
  local attempts=100 success_count=0

  for i in $(seq 1 $attempts); do
    echo "Attempt $i/$attempts"
    if run_test_scenario; then
      ((success_count++))
    else
      echo "Failure reproduced on attempt $i"
      capture_failure_state && break
    fi
    sleep $((RANDOM % 5))
  done

  echo "Success rate: $((success_count * 100 / attempts))%"
}
```

#### Environment Simulation

```bash
# Production environment simulation
simulate_production() {
  # Resource constraints + network latency + load
  docker run --memory=512m --cpus=0.5 myapp
  tc qdisc add dev eth0 root netem delay 100ms
  ab -n 10000 -c 100 http://localhost:8080/api/endpoint
}
```

### Progressive Verification & Follow-up

Deploy execution-evaluator after each wave to verify:

#### Wave 1 Verification

- ✅ **Issue classified** - Problem type identified with confidence
- ✅ **Evidence gathered** - Initial patterns and symptoms documented
- ✅ **Scope defined** - Impact and complexity assessed
- ✅ **Investigation plan** - Wave 2 deployment strategy confirmed

#### Wave 2 Verification

- ✅ **Root cause identified** - Clear explanation of why bug occurs
- ✅ **Reproduction reliable** - Consistent way to trigger the issue
- ✅ **Fix approach defined** - Solution strategy validated
- ✅ **Risk assessment** - Impact and complexity of fix understood

#### Wave 3 Verification

- ✅ **Fix implemented** - Solution addresses root cause completely
- ✅ **Tests created** - Reproduction and regression tests in place
- ✅ **Quality verified** - Code review and security validation complete
- ✅ **Prevention measures** - Steps to avoid similar issues documented

#### Wave N Verification (Continued Investigation)

- ✅ **Complete resolution** - All symptoms eliminated with >90% confidence
- ✅ **Systemic issues addressed** - Architectural or distributed system problems resolved
- ✅ **Performance validated** - Solution performs well under realistic conditions
- ✅ **Long-term stability** - Fix demonstrates durability over extended testing

### Examples

```text
User: /debug Memory leak causing crashes

Wave 1: debugger + codebase-analyst + test-engineer (3 min)
Claude: Issue classified as memory leak with 90% confidence

Wave 2: performance-engineer + performance-engineer + debugger-2 (6 min)
Claude: Root cause verified - event listeners not cleaned up

Wave 3: frontend-engineer + test-engineer-4 + code-reviewer (8 min)
Result: Fix implemented with cleanup in useEffect + comprehensive tests
```

```text
User: /debug Complex distributed system timeout

Wave 1: debugger + codebase-analyst + test-engineer (4 min)
Claude: Issue classified as distributed system problem, requires deeper investigation

Wave 2: platform-engineer + devops + performance-engineer (8 min)
Claude: Partial root cause identified - service mesh configuration issues

Wave 3: Initial fix attempt - service mesh reconfiguration (10 min)
Claude: Fix partially successful but latency spikes persist, continuing investigation

Wave 4: performance-engineer + platform-engineer-2 + performance-engineer-2 (12 min)
Claude: Discovered cascading failure pattern in dependent services

Wave 5: backend-engineer + devops-2 + database-admin (15 min)
Result: Complete resolution with circuit breakers, connection pooling, and monitoring
```

```text
User: /debug Race condition in payment system

Wave 1: debugger + codebase-analyst + test-engineer (4 min)
Claude: Issue classified as race condition with 95% confidence

Wave 2: debugger-2 + debugger-3 + performance-engineer (8 min)
Claude: Root cause verified - non-atomic payment flow

Wave 3: backend-engineer + database-admin + test-engineer-4 (12 min)
Result: Database transactions + idempotency keys + comprehensive testing
```

### Notes

- **Adaptive Wave Approach**: Investigation continues with additional waves until complete resolution
- **No Fixed Timeline**: Complex bugs may require 5-7+ waves for thorough resolution
- **Progressive Building**: Each wave builds systematically on previous findings
- **Quality Focus**: Investigation continues until >90% confidence in root cause and fix
- **Systemic Problem Handling**: Capable of addressing architectural and distributed system issues
- **Verification at Each Stage**: Claude validates progress and determines continuation needs
- **Resource Optimization**: Parallel execution within waves maximizes efficiency
- **Complete Resolution Goal**: Process continues until all symptoms eliminated and prevention measures in place
- **Documentation**: Each wave documents findings for knowledge transfer and future prevention
