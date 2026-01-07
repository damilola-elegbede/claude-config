---
description: Root cause analysis for bugs and performance issues
argument-hint: [issue] [--issue|--performance]
---

# /debug Command

## Usage

```bash
/debug <issue_description>       # Debug the issue
/debug --performance <issue>     # Focus on performance debugging
/debug --issue                   # Create GitHub issue from findings
```

## Description

Systematic debugging using a single debugger agent. Investigates root causes, proposes fixes, and optionally creates GitHub issues from findings.

## Behavior

1. **Analyze**: Deploy debugger agent to investigate the issue
2. **Fix**: Implement the fix based on findings
3. **Verify**: Run tests to confirm the fix works

### With `--issue` Flag

After debugging, create a GitHub issue documenting:

- Root cause analysis
- Steps to reproduce
- Fix applied (if any)
- Prevention recommendations

## Expected Output

```text
User: /debug Memory leak causing crashes

🔍 Investigating: Memory leak causing crashes

Deploying debugger agent...

📊 Root Cause Analysis:
  Issue: Event listeners not cleaned up in useEffect
  Evidence: Heap growing 50MB/hour, correlates with component mounts
  Confidence: 92%

🔧 Fix Applied:
  - Added cleanup function to useEffect in UserSession.tsx
  - Implemented proper listener removal

✅ Verification:
  - Tests passing
  - Memory stable after 10 minute test

🎉 Issue resolved
```

### With --issue Flag

```text
User: /debug --issue Payment timeout

[Debug analysis completes...]

📝 Creating GitHub issue...
✅ Issue #142 created: "Payment timeout - Database connection pool exhaustion"
```

## Notes

- Single debugger agent handles all investigation
- Use `--performance` for CPU/memory/latency issues
- Use `--issue` to document findings as GitHub issue
- Typical execution: 2-5 minutes
