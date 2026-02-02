---
name: debug
description: Root cause analysis for bugs and performance issues
category: orchestration
context: fork
agent: debugger
user-invocable: true
allowed-tools: Read, Grep, Bash, Glob
---

# /debug Skill

Systematic debugging skill using a specialized debugger agent. Investigates root causes,
proposes fixes, and optionally creates GitHub issues from findings.

## Usage

```bash
/debug <issue_description>       # Debug the issue
/debug --performance <issue>     # Focus on performance debugging
/debug --issue                   # Create GitHub issue from findings
```

## Architecture

This skill uses:

- `context: fork` - Isolates debugging context from main conversation
- `agent: debugger` - Routes to specialized debugger agent with investigation tools

The debugger agent has access to Read, Grep, Bash, and Glob tools for thorough investigation.

## Execution

### Step 1: Parse Arguments

```text
PARSE: $ARGUMENTS for:
  - issue_description: The problem to investigate
  - --performance: Focus on CPU/memory/latency issues
  - --issue: Create GitHub issue from findings

OUTPUT: "Investigating: {issue_description}"
```

### Step 2: Deploy Debugger Agent

The debugger agent performs systematic investigation:

```text
Task tool:
  subagent_type: "debugger"
  description: "Investigate root cause"
  prompt: |
    Investigate the following issue: {issue_description}

    IF --performance flag:
      Focus on performance aspects:
      - CPU usage patterns
      - Memory allocation/leaks
      - Latency bottlenecks
      - Algorithm complexity

    ELSE:
      Standard debugging approach:
      - Reproduce the issue
      - Identify affected code paths
      - Trace to root cause
      - Propose fix

    Return structured analysis:
    {
      "root_cause": "Description of the actual problem",
      "evidence": ["List of evidence supporting conclusion"],
      "confidence": "percentage",
      "affected_files": ["list of files"],
      "fix_approach": "Recommended solution"
    }
```

### Step 3: Apply Fix

```text
IF: root cause identified with high confidence (>80%)
  Implement the recommended fix
  Run tests to verify

ELSE:
  Present findings and ask for guidance
```

### Step 4: Verify Fix

```text
RUN: relevant tests
CHECK: issue no longer reproduces

OUTPUT verification results
```

### Step 5: Create Issue (if --issue flag)

```text
IF: --issue flag provided
  gh issue create with:
    - Title: Summary of root cause
    - Body:
      - Root cause analysis
      - Steps to reproduce
      - Fix applied (if any)
      - Prevention recommendations
```

## Expected Output

```text
Investigating: Memory leak causing crashes

Deploying debugger agent...

Root Cause Analysis:
  Issue: Event listeners not cleaned up in useEffect
  Evidence: Heap growing 50MB/hour, correlates with component mounts
  Confidence: 92%

Fix Applied:
  - Added cleanup function to useEffect in UserSession.tsx
  - Implemented proper listener removal

Verification:
  - Tests passing
  - Memory stable after 10 minute test

Issue resolved
```

### With --issue Flag

```text
/debug --issue Payment timeout

[Debug analysis completes...]

Creating GitHub issue...
Issue #142 created: "Payment timeout - Database connection pool exhaustion"
```

## Notes

- Single debugger agent handles all investigation
- Use `--performance` for CPU/memory/latency issues
- Use `--issue` to document findings as GitHub issue
- `context: fork` keeps debugging context separate from main work
