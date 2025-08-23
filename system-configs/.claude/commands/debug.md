# /debug Command

## Description

Systematic root cause analysis for complex bugs using multi-agent forensics.
Specializes in hard-to-reproduce issues, race conditions, memory leaks, and
production-only failures.

## Usage

```bash
/debug <issue_description>      # Investigate specific bug
/debug --repro <steps>          # Focus on reproduction
/debug --performance            # Performance-specific debugging
```bash

## Behavior

When invoked, I will systematically investigate complex bugs using multi-agent
forensics. I deploy specialized agents based on the issue type (memory leaks,
race conditions, performance degradation) to perform root cause analysis and
provide targeted fixes.

## Investigation Framework

### Issue Classification & Agent Deployment

```yaml
Intermittent Issues:
  symptoms: ["works sometimes", "random failures", "can't reproduce"]
  agents: [debugger, performance-specialist]
  approach: Statistical analysis, environmental factor testing

Race Conditions:
  symptoms: ["deadlock", "data corruption", "concurrent access errors"]
  agents: [debugger, backend-engineer]
  approach: Thread analysis, lock inspection, timing manipulation

Memory Issues:
  symptoms: ["memory leak", "crashes", "growing heap", "OOM errors"]
  agents: [debugger, code-archaeologist]
  approach: Heap analysis, reference tracking, allocation patterns

Production-Only:
  symptoms: ["works locally", "staging ok", "prod fails"]
  agents: [debugger, production-reliability-engineer, monitoring-specialist]
  approach: Environment comparison, scale simulation

Performance Degradation:
  symptoms: ["getting slower", "timeouts", "resource exhaustion"]
  agents: [debugger, performance-specialist, performance-predictor]
  approach: Profiling, bottleneck analysis, load testing
```bash

## Concrete Investigation Patterns

### Memory Leak Investigation

```bash
# Heap dump analysis pattern
investigate_memory_leak() {
  echo "🔍 Analyzing memory patterns..."

  # Heap dump collection
  if command -v jcmd >/dev/null; then
    jcmd $PID GC.run_finalization
    jcmd $PID VM.gc
    jcmd $PID GC.dump_heap heap_before.hprof
  fi

  # Python memory profiling
  if python --version 2>/dev/null | grep -q "Python"; then
    echo "import tracemalloc; tracemalloc.start()" >> memory_trace.py
  fi

  # Node.js heap snapshots
  if node --version 2>/dev/null; then
    echo "console.log(process.memoryUsage())" >> memory_check.js
  fi
}
```bash

**Real Example Output:**

```text
🔍 Memory Leak Investigation: User Session Cache

📊 Evidence Collected:
- Heap growing 50MB/hour consistently
- No GC pressure, allocations not being freed
- Correlates with user login frequency

🎯 Root Cause Found:
- Session objects stored in WeakMap but never cleaned
- Event listeners maintaining references
- No TTL on session cache

🔧 Fix Applied:
- Added session cleanup timer (5min intervals)
- Implemented proper event listener removal
- Set 24h TTL on session cache entries

✅ Verification: Memory stable after 2h testing
```bash

### Race Condition Analysis

```bash
# Thread synchronization analysis
analyze_race_condition() {
  echo "🧵 Analyzing concurrent access patterns..."

  # Thread dump analysis (Java)
  if command -v jstack >/dev/null; then
    jstack $PID > thread_dump.txt
    grep -A5 -B5 "BLOCKED\|WAITING" thread_dump.txt
  fi

  # Go race detector
  if go version 2>/dev/null; then
    echo "Run with: go run -race main.go"
  fi

  # Python thread analysis
  if python --version 2>/dev/null; then
    echo "import threading; print(threading.active_count())" >> thread_check.py
  fi
}
```bash

**Real Example Output:**

```text
🧵 Race Condition Investigation: Payment Processing

📊 Evidence Collected:
- Duplicate charges appearing ~0.1% of transactions
- Only under high load (>100 req/sec)
- Database shows conflicting timestamps

🎯 Root Cause Found:
- Payment validation and charge creation not atomic
- Two requests can pass validation simultaneously
- No idempotency key enforcement

🔧 Fix Applied:
- Wrapped validation + charge in database transaction
- Added unique constraint on idempotency_key
- Implemented distributed lock for payment flow

✅ Verification: No duplicates in 1000 concurrent test transactions
```bash

### Production-Only Bug Analysis

```bash
# Environment difference analysis
compare_environments() {
  echo "🔍 Comparing dev vs production environments..."

  # Configuration diff
  diff dev.env prod.env || echo "Environment variables differ"

  # Dependency versions
  if [ -f package.json ]; then
    npm list --production > prod_deps.txt
    npm list > dev_deps.txt
    diff dev_deps.txt prod_deps.txt
  fi

  # Resource constraints
  echo "Production resource limits:"
  cat /proc/meminfo | grep MemTotal
  ulimit -a
}
```bash

**Real Example Output:**

```text
🏭 Production-Only Investigation: API Timeout Errors

📊 Evidence Collected:
- API works perfectly in dev/staging
- 504 timeouts only in production
- Affects 30% of requests to /users/search

🎯 Root Cause Found:
- Production database has 10M users vs 1K in staging
- Query missing index on frequently searched columns
- Query optimizer choosing table scan at scale

🔧 Fix Applied:
- Added composite index on (email, status, created_at)
- Optimized query to use covering index
- Added query timeout with proper error handling

✅ Verification: Response time dropped from 8s to 120ms
```bash

### Performance Degradation Analysis

```javascript
// Performance profiling patterns
const performance_debug = {
  // CPU profiling
  profile_cpu: () => {
    console.profile('cpu-analysis');
    // Run suspect code
    console.profileEnd('cpu-analysis');
  },

  // Memory allocation tracking
  track_allocations: () => {
    const used = process.memoryUsage();
    console.log('Memory usage:', {
      rss: Math.round(used.rss / 1024 / 1024 * 100) / 100 + ' MB',
      heapTotal: Math.round(used.heapTotal / 1024 / 1024 * 100) / 100 + ' MB',
      heapUsed: Math.round(used.heapUsed / 1024 / 1024 * 100) / 100 + ' MB'
    });
  },

  // Database query analysis
  analyze_queries: () => {
    // Enable query logging
    console.log('EXPLAIN ANALYZE SELECT ...');
  }
};
```bash

**Real Example Output:**

```text
⚡ Performance Investigation: Dashboard Loading Slowly

📊 Evidence Collected:
- Dashboard load time increased from 2s to 15s
- Started 3 days ago after user growth
- CPU usage normal, database shows slow queries

🎯 Root Cause Found:
- N+1 query problem in user dashboard
- Each dashboard widget making separate DB call
- 50+ queries for single dashboard load

🔧 Fix Applied:
- Implemented GraphQL DataLoader pattern
- Batched widget data queries into single call
- Added Redis caching for user preferences

✅ Verification: Dashboard loads in 1.8s (faster than before)
```bash

## Multi-Agent Coordination

### Agent Teams by Issue Type

```yaml
Memory: debugger + code-archaeologist
Performance: debugger + performance-specialist
Production: debugger + production-reliability-engineer
Security: debugger + security-auditor
```text


## Debugging Toolchain

### Language-Specific Tools

```bash
# Java debugging
debug_java() {
  jstack $PID > thread_dump.txt
  jmap -dump:live,format=b,file=heap.hprof $PID
  jstat -gc $PID 5s
}

# Node.js debugging
debug_nodejs() {
  node --inspect-brk=9229 app.js
  # Chrome DevTools: chrome://inspect
  kill -USR1 $PID  # Enable debugger
}

# Python debugging
debug_python() {
  py-spy top --pid $PID
  python -m cProfile -o profile.stats script.py
  python -c "import pdb; pdb.set_trace()"
}

# Go debugging
debug_go() {
  go run -race main.go
  dlv attach $PID
  go tool pprof http://localhost:6060/debug/pprof/profile
}
```bash

### Database Query Analysis

```sql
-- PostgreSQL debugging
EXPLAIN ANALYZE SELECT * FROM slow_table;
SET log_min_duration_statement = 1000;
```text

## Reproduction Strategies

### Intermittent Bug Reproduction

```bash
# Automated reproduction attempts
reproduce_intermittent() {
  local attempts=100
  local success_count=0

  for i in $(seq 1 $attempts); do
    echo "Attempt $i/$attempts"

    if run_test_scenario; then
      success_count=$((success_count + 1))
    else
      echo "Failure reproduced on attempt $i"
      capture_failure_state
      break
    fi

    # Vary conditions
    sleep $((RANDOM % 5))
  done

  echo "Success rate: $((success_count * 100 / attempts))%"
}
```bash

### Environment Simulation

```bash
# Production environment simulation
simulate_production() {
  # Resource constraints
  docker run --memory=512m --cpus=0.5 myapp

  # Network latency
  tc qdisc add dev eth0 root netem delay 100ms

  # High load simulation
  ab -n 10000 -c 100 http://localhost:8080/api/endpoint
}
```bash

## Verification & Follow-up

Deploy execution-evaluator to verify:

- ✅ **Root cause identified** - Clear explanation of why bug occurs
- ✅ **Reproduction steps** - Reliable way to trigger the issue
- ✅ **Fix implemented** - Solution addresses root cause
- ✅ **Verification tests** - Proof the fix works
- ✅ **Prevention measures** - Steps to avoid similar issues
- ✅ **Documentation** - Investigation findings documented

## Examples

```bash
User: /debug Memory leak causing crashes
Claude: 🔍 Memory analysis: Event listeners not cleaned up
🔧 Fix: Proper cleanup in useEffect
✅ Result: Memory stable
```text

```bash
User: /debug Duplicate payment charges
Claude: 🧵 Race condition: Non-atomic payment flow
🔧 Fix: Database transactions + idempotency
✅ Result: Zero duplicates in load test
```text

```bash
User: /debug Production API timeouts
Claude: 🏭 Scale issue: Missing database index
🔧 Fix: Added composite index
✅ Result: 8s → 120ms response time
```text

## Notes

- Focuses on systematic investigation over guesswork
- Uses appropriate tools for each programming language
- Emphasizes reproduction before attempting fixes
- Documents findings for future similar issues
- Coordinates multiple specialist agents for complex problems
- Always verifies fixes under realistic conditions
