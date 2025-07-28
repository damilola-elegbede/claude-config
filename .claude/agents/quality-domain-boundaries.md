# Quality Domain Boundaries

## Clear Responsibility Matrix

### qa-tester (Test Strategy & Execution)
**Primary Focus**: Test planning, implementation, and coverage
- Test framework selection and setup
- Test case design and implementation
- Coverage analysis and reporting
- Integration testing coordination
- Performance test scenarios
- Accessibility testing

**Does NOT handle**:
- Code style and maintainability (→ code-reviewer)
- Specific security vulnerabilities (→ security-auditor)
- Root cause bug analysis (→ debugger)

### code-reviewer (Code Quality & Standards)
**Primary Focus**: Pre-commit code quality validation
- Code style and formatting
- Best practices adherence
- Maintainability assessment
- PR readiness validation
- Documentation quality
- Design pattern compliance

**Does NOT handle**:
- Test implementation (→ qa-tester)
- Security vulnerability analysis (→ security-auditor)
- Bug investigation (→ debugger)

### debugger (Bug Investigation)
**Primary Focus**: Root cause analysis of issues
- Systematic bug investigation
- Memory leak detection
- Race condition analysis
- Performance anomaly investigation
- Intermittent failure diagnosis

**Does NOT handle**:
- Test case creation (→ qa-tester)
- Code quality review (→ code-reviewer)
- Security vulnerability assessment (→ security-auditor)

### security-auditor (Security Validation)
**Primary Focus**: Security vulnerability assessment
- OWASP Top 10 validation
- Authentication/authorization review
- Data exposure analysis
- Compliance verification
- Threat modeling

**Does NOT handle**:
- General test implementation (→ qa-tester)
- Code style review (→ code-reviewer)
- Non-security bug investigation (→ debugger)

## Handoff Patterns

### Quality Gate Workflow
```
1. code-reviewer: Initial code quality check
   ↓
2. qa-tester: Test coverage validation
   ↓
3. security-auditor: Security compliance
   ↓
4. Approval for merge/deploy
```

### Bug Resolution Flow
```
1. qa-tester: Discovers failing test
   ↓
2. debugger: Investigates root cause
   ↓
3. Developer: Implements fix
   ↓
4. code-reviewer: Reviews fix quality
   ↓
5. qa-tester: Validates fix with tests
```

### Security Issue Flow
```
1. security-auditor: Identifies vulnerability
   ↓
2. Developer: Implements remediation
   ↓
3. code-reviewer: Reviews security fix
   ↓
4. qa-tester: Adds security test cases
   ↓
5. security-auditor: Validates remediation
```

## Coordination Principles

1. **No Overlap**: Each agent has distinct responsibilities
2. **Clear Handoffs**: Explicit triggers for agent transitions
3. **Parallel When Possible**: Independent validations run concurrently
4. **Single Source of Truth**: One agent owns each quality aspect
5. **Escalation Clarity**: Clear paths for complex issues