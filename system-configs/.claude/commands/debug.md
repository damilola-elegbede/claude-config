---
description: Systematic root cause analysis for complex bugs using multi-agent forensics
argument-hint: [issue_description]
---

# Debug Command

Systematic root cause analysis for complex bugs using multi-agent forensics.
Specializes in hard-to-reproduce issues, race conditions, memory leaks, and
production-only failures.

## Context

When invoked, I will systematically investigate complex bugs using multi-agent
forensics. I deploy specialized agents based on the issue type (memory leaks,
race conditions, performance degradation) to perform root cause analysis and
provide targeted fixes.

## Expected Output

- Root cause identification with clear explanation
- Reproduction steps for reliable issue triggering
- Targeted fix implementation addressing root cause
- Verification tests proving the fix works
- Prevention measures to avoid similar issues
- Documentation of investigation findings

## Usage Patterns

```bash
/debug $ARGUMENTS              # Investigate specific bug
/debug --repro <steps>          # Focus on reproduction
/debug --performance            # Performance-specific debugging
```

## Investigation Framework

### Parallel Agent Deployment Strategy

Deploy multiple specialized agents simultaneously for comprehensive forensic analysis:

```yaml
# PARALLEL WAVE 1: Initial Investigation (All agents deploy simultaneously)
debugger:
  role: Primary investigation and forensic analysis
  input: Error logs, system state, reproduction data
  output: Root cause analysis, fix recommendations
  parallel_with: [codebase-analyst, test-engineer, performance-engineer]

codebase-analyst:
  role: Analyze code structure and identify bug patterns
  input: Source code, error traces, system architecture
  output: Code pattern analysis, potential root causes
  parallel_with: [debugger, test-engineer, performance-engineer]

test-engineer:
  role: Design reproduction tests and validation strategies
  input: Bug description, reproduction steps, test scenarios
  output: Test cases, reproduction reliability, validation plans
  parallel_with: [debugger, codebase-analyst, performance-engineer]

performance-engineer:
  role: Profile performance bottlenecks and resource usage
  input: Performance metrics, resource logs, timing data
  output: Performance analysis, optimization opportunities
  parallel_with: [debugger, codebase-analyst, test-engineer]

# PARALLEL WAVE 2: Specialized Analysis (Based on issue type)
Issue Classification:
  Intermittent Issues:
    symptoms: ["works sometimes", "random failures", "can't reproduce"]
    parallel_agents: [debugger, codebase-analyst, test-engineer, monitoring-specialist]
    approach: Statistical analysis, environmental testing

  Race Conditions:
    symptoms: ["deadlock", "data corruption", "concurrent access errors"]
    parallel_agents: [debugger (2 instances), codebase-analyst, performance-engineer]
    approach: Concurrent thread analysis, lock inspection, timing manipulation

  Memory Issues:
    symptoms: ["memory leak", "crashes", "growing heap", "OOM errors"]
    parallel_agents: [debugger, codebase-analyst, test-engineer, performance-engineer]
    approach: Parallel heap analysis, reference tracking, allocation patterns

  Performance Degradation:
    symptoms: ["slow response", "high CPU", "timeout", "lag"]
    parallel_agents: [performance-engineer (3 instances), debugger, codebase-analyst]
    approach: Comprehensive parallel profiling across all resources
```

## Concrete Investigation Patterns

### Memory Leak Investigation

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

**Example Output:**

```text
🔍 Memory Leak Investigation: User Session Cache

📊 Evidence: Heap growing 50MB/hour, no GC pressure, correlates with logins
🎯 Root Cause: Session objects in WeakMap never cleaned, event listeners maintaining references
🔧 Fix: Added cleanup timer, proper listener removal, 24h TTL
✅ Verification: Memory stable after 2h testing
```

### Race Condition Analysis

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

**Example Output:**

```text
🧵 Race Condition Investigation: Payment Processing

📊 Evidence: Duplicate charges ~0.1% under high load, conflicting DB timestamps
🎯 Root Cause: Non-atomic validation+charge, no idempotency key enforcement
🔧 Fix: DB transactions, unique constraint, distributed lock
✅ Verification: No duplicates in 1000 concurrent test transactions
```

### Production-Only Bug Analysis

```bash
# Environment difference analysis
compare_environments() {
  echo "🔍 Comparing dev vs production environments..."

  diff -u dev.env prod.env 2>/dev/null || echo "Environment variables differ"
  [[ -f package.json ]] && { npm list --production > prod_deps.txt; diff dev_deps.txt prod_deps.txt; }
  echo "Memory: $(grep MemTotal /proc/meminfo 2>/dev/null || echo 'N/A')"
}
```

**Example Output:**

```text
🏭 Production-Only Investigation: API Timeout Errors

📊 Evidence: Works in dev/staging, 504 timeouts in prod, affects 30% of /users/search
🎯 Root Cause: 10M users vs 1K in staging, missing index, table scan at scale
🔧 Fix: Composite index (email, status, created_at), query optimization
✅ Verification: Response time 8s → 120ms
```

### Performance Degradation Analysis

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

**Example Output:**

```text
⚡ Performance Investigation: Dashboard Loading Slowly

📊 Evidence: Load time 2s → 15s after user growth, CPU normal, slow DB queries
🎯 Root Cause: N+1 query problem, 50+ queries per dashboard load
🔧 Fix: GraphQL DataLoader, batched queries, Redis caching
✅ Verification: Dashboard loads in 1.8s (faster than baseline)
```

## Multi-Agent Coordination

### Parallel Agent Teams by Issue Type

```yaml
Memory Issues:
  agents: [debugger, codebase-analyst, test-engineer, performance-engineer]
  execution_time: 60% faster than sequential

Performance Issues:
  agents: [performance-engineer (3 instances), debugger, codebase-analyst]
  execution_time: 70% faster with parallel instances

Production Issues:
  agents: [debugger, platform-engineer, monitoring-specialist, platform-engineer]
  execution_time: All agents work simultaneously

Security Issues:
  agents: [security-auditor (2 instances), debugger, codebase-analyst]
  execution_time: Multiple instances for comprehensive coverage

Complex Multi-Domain:
  wave_1: [debugger, codebase-analyst, test-engineer, performance-engineer]
  wave_2: [security-auditor, monitoring-specialist, platform-engineer]
  wave_3: Integration and correlation of findings
  execution_time: 80% faster than sequential investigation
```

## Debugging Toolchain

### Language-Specific Tools

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

### Database Query Analysis

```sql
-- PostgreSQL debugging
EXPLAIN ANALYZE SELECT * FROM slow_table;
SET log_min_duration_statement = 1000;
```

## Reproduction Strategies

### Intermittent Bug Reproduction

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

### Environment Simulation

```bash
# Production environment simulation
simulate_production() {
  # Resource constraints + network latency + load
  docker run --memory=512m --cpus=0.5 myapp
  tc qdisc add dev eth0 root netem delay 100ms
  ab -n 10000 -c 100 http://localhost:8080/api/endpoint
}
```

## Verification & Follow-up

Deploy execution-evaluator to verify:

- ✅ **Root cause identified** - Clear explanation of why bug occurs
- ✅ **Reproduction steps** - Reliable way to trigger the issue
- ✅ **Fix implemented** - Solution addresses root cause
- ✅ **Verification tests** - Proof the fix works
- ✅ **Prevention measures** - Steps to avoid similar issues
- ✅ **Documentation** - Investigation findings documented

## Examples

```text
User: /debug Memory leak causing crashes
Claude: 🔍 Memory analysis: Event listeners not cleaned up
🔧 Fix: Proper cleanup in useEffect
✅ Result: Memory stable
```

```text
User: /debug Duplicate payment charges
Claude: 🧵 Race condition: Non-atomic payment flow
🔧 Fix: Database transactions + idempotency
✅ Result: Zero duplicates in load test
```

```text
User: /debug Production API timeouts
Claude: 🏭 Scale issue: Missing database index
🔧 Fix: Added composite index
✅ Result: 8s → 120ms response time
```

## Notes

- Focuses on systematic investigation over guesswork
- Uses appropriate tools for each programming language
- Emphasizes reproduction before attempting fixes
- Documents findings for future similar issues
- Coordinates multiple specialist agents for complex problems
- Always verifies fixes under realistic conditions
