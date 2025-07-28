# Quality Gate Protocol

## Overview
This protocol establishes mandatory quality checkpoints for all code changes before merge/deployment, coordinating multiple specialized agents for comprehensive validation.

## Quality Gate Stages

### Stage 1: Code Quality Review
**Agent**: code-reviewer
**Trigger**: Pre-commit/Pre-PR
**Validates**:
- Code style compliance
- Best practices adherence
- Documentation completeness
- Maintainability score
- Design pattern usage

**Pass Criteria**:
- No critical style violations
- All public APIs documented
- Cyclomatic complexity < 10
- No code smells detected

### Stage 2: Test Coverage Validation
**Agent**: qa-tester
**Trigger**: After code review pass
**Validates**:
- Unit test coverage ≥ 80%
- Integration test presence
- Edge case coverage
- Performance test coverage
- Accessibility compliance

**Pass Criteria**:
- Coverage threshold met
- All critical paths tested
- No failing tests
- Performance benchmarks pass

### Stage 3: Security Compliance
**Agent**: security-auditor
**Trigger**: After test validation pass
**Validates**:
- OWASP Top 10 compliance
- Authentication/authorization
- Data exposure risks
- Dependency vulnerabilities
- Compliance requirements

**Pass Criteria**:
- No high/critical vulnerabilities
- Auth patterns approved
- Data handling secure
- Dependencies updated

### Stage 4: Performance Validation (Optional)
**Agent**: performance-engineer
**Trigger**: For performance-critical changes
**Validates**:
- Response time targets
- Resource utilization
- Scalability limits
- Memory/CPU profiles

**Pass Criteria**:
- Meets SLA requirements
- No performance regression
- Resource usage acceptable

## Implementation Patterns

### Sequential Validation
```yaml
quality_gates:
  - stage: code_review
    agent: code-reviewer
    blocking: true
    
  - stage: test_coverage
    agent: qa-tester
    blocking: true
    depends_on: code_review
    
  - stage: security_check
    agent: security-auditor
    blocking: true
    depends_on: test_coverage
    
  - stage: performance_check
    agent: performance-engineer
    blocking: false
    condition: performance_critical
```

### Parallel Validation (Advanced)
```yaml
quality_gates:
  parallel_group_1:
    - agent: code-reviewer
    - agent: qa-tester
      
  parallel_group_2:
    depends_on: parallel_group_1
    - agent: security-auditor
    - agent: performance-engineer
```

## Automation Integration

### CI/CD Pipeline
```bash
# .github/workflows/quality-gates.yml
name: Quality Gates

on: [pull_request]

jobs:
  code-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Code Review Check
        run: |
          # Invoke code-reviewer agent
          
  test-coverage:
    needs: code-review
    runs-on: ubuntu-latest
    steps:
      - name: Test Coverage Check
        run: |
          # Invoke qa-tester agent
          
  security-audit:
    needs: test-coverage
    runs-on: ubuntu-latest
    steps:
      - name: Security Audit
        run: |
          # Invoke security-auditor agent
```

### Local Pre-commit Hooks
```bash
#!/bin/bash
# .git/hooks/pre-commit

echo "Running Quality Gates..."

# Stage 1: Code Review
if ! claude-code invoke code-reviewer; then
    echo "Code review failed"
    exit 1
fi

# Stage 2: Test Coverage
if ! claude-code invoke qa-tester --coverage-check; then
    echo "Test coverage insufficient"
    exit 1
fi

echo "Quality gates passed!"
```

## Failure Handling

### Immediate Failures
- **Code Review Failure**: Block commit, provide fix suggestions
- **Test Coverage Failure**: Block merge, highlight untested code
- **Security Failure**: Block deployment, escalate to security team

### Warning Conditions
- Performance regression < 10%: Warn but allow proceed
- Non-critical security findings: Create follow-up tickets
- Documentation gaps: Flag for improvement

## Reporting

### Quality Dashboard
```
┌─────────────────────────────────────┐
│       Quality Gate Summary          │
├─────────────────────────────────────┤
│ Code Review:      ✅ PASSED         │
│ Test Coverage:    ✅ 85%            │
│ Security:         ⚠️  1 Warning     │
│ Performance:      ✅ No Regression  │
├─────────────────────────────────────┤
│ Overall Status:   PASSED W/WARNINGS │
└─────────────────────────────────────┘
```

### Detailed Reports
- Code review report: `reports/code-review.html`
- Coverage report: `reports/coverage/index.html`
- Security report: `reports/security-scan.json`
- Performance report: `reports/performance-metrics.json`

## Exceptions and Overrides

### Emergency Hotfix Process
```bash
# For critical production fixes only
git commit -m "EMERGENCY: Fix critical bug" --no-verify
# Requires post-deployment validation
```

### Override Authority
- Tech Lead: Can override warnings
- Engineering Manager: Can override non-security blocks
- Security Team: Must approve all security overrides

## Continuous Improvement

### Metrics Tracking
- Gate pass/fail rates
- Average time through gates
- False positive rates
- Override frequency

### Regular Reviews
- Monthly: Review gate effectiveness
- Quarterly: Adjust thresholds
- Annually: Strategic gate evolution