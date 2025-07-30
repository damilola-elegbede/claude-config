# /debug Command

## Description
Investigates complex bugs and mysterious issues through Claude orchestration with the debugger specialist to systematically find root causes of difficult-to-reproduce problems, edge cases, and intermittent failures.

## Usage
```
/debug <description> [options]
```

## Arguments
- `description`: Description of the bug or issue to investigate

## Options
- `--error <message>`: Specific error message to trace
- `--repro <steps>`: Steps to reproduce (if known)
- `--logs <path>`: Log files to analyze
- `--trace`: Enable detailed execution tracing

## Behavior
When you use `/debug`, I will:

1. **Gather initial context**:
   - Error messages and stack traces
   - Reproduction steps
   - System state when issue occurs
   - Recent code changes
   
2. **Coordinate with debugger specialist** through Claude for systematic investigation:
   - Root cause analysis
   - Code path tracing
   - State examination
   - Variable tracking
   - Memory analysis
   - Race condition detection
   
3. **Employ debugging techniques**:
   - Binary search isolation
   - Hypothesis testing
   - State snapshot comparison
   - Execution flow analysis
   - Resource monitoring
   
4. **Generate investigation report** with:
   - Root cause identification
   - Detailed explanation
   - Fix recommendations
   - Prevention strategies
   - Test cases to add

## Examples
```
/debug "app crashes on user logout"
/debug "memory leak in dashboard" --trace
/debug "random 500 errors" --logs /var/log/app.log
/debug "race condition in payment" --repro "1. Add item 2. Quick checkout"
/debug "data corruption issue" --error "Invalid state exception"
```

## Investigation Areas

### Common Bug Categories
- **Memory Issues**: Leaks, corruption, overflow
- **Concurrency**: Race conditions, deadlocks
- **State Management**: Inconsistent state, mutations
- **Integration**: API failures, timing issues
- **Performance**: Degradation, timeouts
- **Data**: Corruption, validation failures

### Debugging Techniques
- **Systematic Isolation**: Narrow down problem area
- **Execution Tracing**: Follow code paths
- **State Inspection**: Examine variables/memory
- **Differential Analysis**: Compare working/broken
- **Time Travel**: Replay execution history
- **Statistical Analysis**: Pattern detection

## Investigation Process
1. **Problem Definition**: Clear issue description
2. **Hypothesis Formation**: Potential causes
3. **Evidence Gathering**: Logs, traces, dumps
4. **Systematic Testing**: Validate hypotheses
5. **Root Cause Analysis**: Identify core issue
6. **Solution Verification**: Confirm fix works

## Output Format
1. **Executive Summary**: Issue and resolution
2. **Investigation Timeline**: Steps taken
3. **Root Cause Analysis**: Detailed findings
4. **Evidence**: Supporting data/logs
5. **Fix Implementation**: Code changes
6. **Prevention Plan**: Avoid recurrence

## Bug Complexity Levels
- **Simple**: Clear error, obvious fix
- **Moderate**: Requires investigation
- **Complex**: Multiple factors involved
- **Heisenbug**: Intermittent, hard to reproduce
- **Critical**: System-wide impact

## Tools Utilized
- Code analysis
- Log parsing
- Memory profiling
- Execution tracing
- State diffing
- Statistical analysis

## Integration
- Bug tracking systems
- Monitoring tools
- Log aggregation
- Error reporting
- CI/CD debugging

## Prerequisites
- Bug description
- Access to affected code
- Logs/error messages (helpful)
- Reproduction steps (if available)

## Notes
- Specializes in hard-to-find bugs
- Systematic approach to complex issues
- Documents investigation process
- Creates regression tests
