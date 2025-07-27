# /perf Command

## Description
Analyzes application performance using the performance-engineer agent to identify bottlenecks, optimize resource usage, and ensure scalability.

## Usage
```
/perf [target] [options]
```

## Arguments
- `target` (optional): Specific area to analyze
  - `api`: API endpoint performance
  - `db`: Database query optimization
  - `frontend`: Frontend bundle and rendering
  - `memory`: Memory usage and leaks
  - `full`: Comprehensive analysis (default)

## Options
- `--load <users>`: Simulate concurrent users
- `--profile`: Generate detailed profiling data
- `--benchmark`: Run performance benchmarks
- `--optimize`: Generate optimization code

## Behavior
When you use `/perf`, I will:

1. **Identify performance scope**:
   - Critical code paths
   - Resource-intensive operations
   - User-facing latencies
   - System bottlenecks
   
2. **Launch performance-engineer agent** to analyze:
   - Response time metrics
   - Resource utilization
   - Scalability limits
   - Memory patterns
   - CPU hotspots
   - I/O bottlenecks
   
3. **Conduct performance tests**:
   - Load testing simulation
   - Stress testing
   - Benchmark comparisons
   - Profiling analysis
   - Memory leak detection
   
4. **Generate performance report** with:
   - Executive summary
   - Key metrics and KPIs
   - Bottleneck identification
   - Optimization recommendations
   - Implementation priority

## Examples
```
/perf                              # Full performance analysis
/perf api --load 1000              # API load testing
/perf db --optimize                # Database optimization
/perf frontend --profile           # Frontend profiling
/perf memory                       # Memory leak detection
```

## Performance Metrics
- **Response Time**: P50, P95, P99 latencies
- **Throughput**: Requests/transactions per second
- **Resource Usage**: CPU, memory, disk, network
- **Error Rate**: Failed requests, timeouts
- **Scalability**: Concurrent user limits

## Analysis Areas
- **Backend Performance**:
  - API response times
  - Database query efficiency
  - Caching effectiveness
  - Service communication
  
- **Frontend Performance**:
  - Bundle size optimization
  - Render performance
  - Asset loading
  - Core Web Vitals
  
- **Infrastructure**:
  - Container resource limits
  - Auto-scaling triggers
  - Network latency
  - CDN effectiveness

## Output Format
1. **Performance Summary**: Overall health metrics
2. **Critical Issues**: Immediate bottlenecks
3. **Detailed Analysis**: Component breakdown
4. **Optimization Plan**: Prioritized improvements
5. **Benchmark Results**: Before/after comparisons

## Optimization Types
- **Code Level**: Algorithm improvements
- **Database**: Query optimization, indexing
- **Caching**: Strategy implementation
- **Architecture**: Service decomposition
- **Infrastructure**: Resource allocation

## Integration
- CI/CD performance gates
- Monitoring integration
- APM tool compatibility
- Load testing automation
- Performance budgets

## Prerequisites
- Running application/service
- Test data availability
- Performance baselines (optional)
- Load testing tools (auto-configured)

## Notes
- Simulates realistic load patterns
- Considers business metrics
- Provides ROI for optimizations
- Tracks performance over time
- Maintains optimization history