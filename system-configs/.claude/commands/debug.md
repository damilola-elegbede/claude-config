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
```

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
```

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
```

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
```

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
```

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
```

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
```

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
```

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
```

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
```

## Multi-Agent Coordination

### Complex Bug Investigation Team

```yaml
Primary Investigation:
  debugger: "Lead investigator, coordinates analysis"
  
Supporting Specialists:
  performance-specialist: "When performance-related symptoms detected"
  backend-engineer: "For server-side logic issues"
  frontend-architect: "For UI/UX related problems"
  database-admin: "For data integrity or query issues"
  security-auditor: "When security implications suspected"
  
Advanced Analysis:
  code-archaeologist: "For legacy code interactions"
  production-reliability-engineer: "For production environment issues"
  monitoring-specialist: "For observability and metrics analysis"
```

### Investigation Workflow

```bash
# Multi-agent debugging coordination
coordinate_debugging() {
  local issue_type="$1"
  
  case "$issue_type" in
    "memory")
      echo "Deploying debugger + code-archaeologist for memory analysis..."
      # Primary: debugger analyzes heap dumps
      # Secondary: code-archaeologist reviews allocation patterns
      ;;
    "performance")
      echo "Deploying debugger + performance-specialist + monitoring-specialist..."
      # Primary: debugger identifies bottlenecks
      # Secondary: performance-specialist optimizes
      # Tertiary: monitoring-specialist sets up alerting
      ;;
    "production")
      echo "Deploying debugger + production-reliability-engineer..."
      # Primary: debugger analyzes failure patterns
      # Secondary: production-reliability-engineer fixes infrastructure
      ;;
  esac
}
```

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
```

### Database Query Analysis

```sql
-- PostgreSQL debugging
EXPLAIN ANALYZE VERBOSE 
SELECT u.id, u.email, COUNT(o.id) as order_count
FROM users u 
LEFT JOIN orders o ON u.id = o.user_id 
WHERE u.created_at > '2024-01-01'
GROUP BY u.id, u.email
ORDER BY order_count DESC;

-- Enable query logging
SET log_statement = 'all';
SET log_min_duration_statement = 1000; -- Log slow queries
```

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
```

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

### Memory Leak Investigation

```bash
User: /debug Application memory keeps growing, crashes after 6 hours
Claude: 🔍 Deploying debugger + code-archaeologist for memory leak analysis...
📊 Collecting heap dumps and allocation patterns...
🎯 Found: Event listeners not being removed in component cleanup
🔧 Fix: Added proper cleanup in useEffect dependencies
✅ Verified: Memory stable after 12h test run
```

### Race Condition

```bash
User: /debug Users sometimes see duplicate charges in payment system
Claude: 🧵 Deploying debugger + backend-engineer for concurrency analysis...
📊 Analyzing payment flow under load...
🎯 Found: Payment validation + charge not atomic, race condition possible
🔧 Fix: Wrapped in database transaction + added idempotency keys
✅ Verified: No duplicates in 1000 concurrent payment test
```

### Production Mystery

```bash
User: /debug API timeouts only in production, works fine locally
Claude: 🏭 Deploying debugger + production-reliability-engineer...
📊 Comparing environments and analyzing production metrics...
🎯 Found: Missing database index causes table scan at production scale
🔧 Fix: Added composite index on high-traffic query columns
✅ Verified: Response time improved from 8s to 120ms
```

## Notes

- Focuses on systematic investigation over guesswork
- Uses appropriate tools for each programming language
- Emphasizes reproduction before attempting fixes
- Documents findings for future similar issues
- Coordinates multiple specialist agents for complex problems
- Always verifies fixes under realistic conditions
