---
description: Safely push changes to remote repository with wave-based orchestration
argument-hint: [--simple|--force|--dry-run]
---

# /push Command

## Usage

```bash
/push                   # Wave-based orchestration push
/push --simple          # Quick push without quality checks
/push --force           # Force push (use carefully)
/push --dry-run         # Preview what would be pushed
```

## Description

Safely pushes changes to remote repository using advanced wave-based orchestration for comprehensive
quality gates, auto-recovery, and CI/CD monitoring. Deploys specialized agents in three coordinated
waves with automatic issue resolution between phases.

**CRITICAL**: This command NEVER uses `--no-verify`. Pre-push hooks are the last line of
defense before code reaches the remote repository. If pre-push hooks fail, the issues must
be fixed immediately, never bypassed.

## Wave-Based Orchestration

### Wave 1: Pre-Push Validation (Parallel)

Simultaneous quality gate validation with three specialized agents:

```yaml
Parallel Agent Deployment:
  - test-engineer: Complete test suite execution and coverage analysis
  - devops: CI/CD readiness check and pipeline validation
  - security-auditor: Security vulnerability scanning and compliance check

Execution: All agents run simultaneously for maximum efficiency
Duration: 15-30 seconds (parallel execution)
```

**Claude Analysis Phase**: Identifies blocking issues and determines if Wave 2 is needed

### Wave 2: Issue Resolution (Conditional)

Deployed only when Wave 1 identifies blocking issues:

```yaml
Conditional Agent Deployment:
  - test-engineer: Fix failing tests and coverage issues
  - devops: Resolve CI/CD configuration issues and pipeline problems
  - security-auditor: Fix security vulnerabilities and compliance issues
  - platform-engineer: Fix environment setup and dependency conflicts

Auto-Recovery Logic:
  - Pre-push hook failures → Deploy appropriate fix agents
  - Test failures → Deploy test-engineer for fixes
  - Security issues → Deploy security-auditor for remediation
  - Build failures → Deploy devops for pipeline fixes

Execution: Targeted parallel deployment based on issue types
Duration: 20-45 seconds (varies by issue complexity)
```

**Claude Verification Phase**: Confirms all issues resolved and system ready to push

### Wave 3: Push & Monitor

Execute push operation with real-time monitoring:

```yaml
Push Execution:
  - Execute git push with quality gate enforcement
  - Real-time CI/CD pipeline monitoring
  - Automatic failure detection and classification

Auto-Recovery for Push Failures:
  - Pipeline failures → Deploy devops for immediate fixes
  - Build failures → Deploy platform-engineer for environment issues
  - Test failures → Deploy test-engineer for fix and retry

Monitoring Duration: Until CI/CD pipeline completes or fails
```

## Expected Output

### Wave-Based Push Report

```markdown
# Push Wave-Based Orchestration Report

## Wave 1: Pre-Push Validation ✅
- **test-engineer**: All 127 tests passing, coverage at 94.2%
- **devops**: CI/CD pipeline ready, all checks configured properly
- **security-auditor**: No vulnerabilities detected, dependencies secure

**Claude Analysis**: No blocking issues detected, proceeding to Wave 3

## Wave 3: Push & Monitor ✅
- **Branch**: feature/user-authentication
- **Commits**: 4 commits pushed successfully
- **CI/CD Pipeline**: ✅ Build passing, tests completed
- **Deployment**: Successfully deployed to staging environment

## Summary
✅ **Push Successful** - All quality gates passed
🚀 **CI/CD Status**: Pipeline completed successfully
💡 **Next Steps**: Ready for PR creation and merge
```

### Wave 2 Auto-Recovery Example

```markdown
# Push Auto-Recovery Report

## Wave 1: Pre-Push Validation ⚠️
- **test-engineer**: 2 test failures in authentication module
- **devops**: Missing environment variables in CI config
- **security-auditor**: 1 dependency vulnerability found

**Claude Analysis**: Blocking issues detected, deploying Wave 2 resolution

## Wave 2: Issue Resolution ✅
- **test-engineer**: Resolved authentication test race conditions
- **devops**: Added missing env vars to CI/CD configuration
- **security-auditor**: Updated vulnerable dependency to v2.1.4

**Claude Verification**: All issues resolved, system ready to push

## Wave 3: Push & Monitor ✅
- **Push Status**: Successful after auto-recovery
- **CI/CD Pipeline**: All checks passing
- **Total Resolution Time**: 2 minutes 34 seconds
```

## Behavior

### Wave-Based Execution Strategy

#### Default Mode - Full Wave Orchestration

**What it does**: Three-wave orchestration with auto-recovery

```yaml
Wave 1 - Pre-Push Validation (Always):
  Parallel Agents: test-engineer + devops + security-auditor
  Purpose: Comprehensive quality gate validation
  Duration: 15-30 seconds

Wave 2 - Issue Resolution (Conditional):
  Triggered: When Wave 1 detects blocking issues
  Parallel Agents: test-engineer + devops + security-auditor + platform-engineer
  Purpose: Auto-resolve all detected issues
  Duration: 20-45 seconds

Wave 3 - Push & Monitor (Always):
  Purpose: Execute push with real-time CI/CD monitoring
  Auto-Recovery: Deploy fix agents for pipeline failures
  Duration: Until pipeline completion
```

#### Simple Mode (--simple) - Direct Push

**What it does**: Skip orchestration, direct push with basic checks

```yaml
Operations:
  - Basic safety validation only
  - No agent deployment
  - Direct git push execution
  - No auto-recovery mechanisms

Duration: 10-15 seconds
Use Case: Hot fixes, emergency pushes
```

### Auto-Recovery Mechanisms

#### Pre-Push Hook Failure Recovery

```yaml
Failure Detection:
  - Parse pre-push hook error output
  - Classify issue type (testing, security, build, CI/CD)
  - Deploy appropriate specialist agents

Recovery Agents:
  - Test failures → test-engineer with debugging capability
  - Security issues → security-auditor with remediation
  - Build/CI issues → devops with pipeline expertise
  - Environment issues → platform-engineer with config fixes

Recovery Process:
  1. Identify root cause of pre-push failure
  2. Deploy targeted agent(s) for resolution
  3. Re-validate with original failing checks
  4. Retry push operation automatically
```

#### CI/CD Pipeline Failure Recovery

```yaml
Pipeline Monitoring:
  - Real-time status checking every 30 seconds
  - Automatic failure classification when detected
  - Immediate deployment of recovery agents

Recovery Types:
  - Build failures → platform-engineer for environment fixes
  - Test failures → test-engineer for flaky test resolution
  - Deployment failures → devops for infrastructure issues
  - Security gate failures → security-auditor for compliance fixes

Recovery Timeline:
  - Detection: Within 30 seconds of failure
  - Agent deployment: Immediate parallel execution
  - Resolution attempt: 2-5 minutes depending on complexity
  - Retry mechanism: Automatic with exponential backoff
```

### Quality Gate Enforcement

#### Never Bypass Philosophy

```yaml
Prohibited Practices:
  - NEVER use: git push --no-verify
  - NEVER bypass: pre-push hooks without resolution
  - NEVER skip: security or quality validations
  - NEVER force push: without explicit team coordination

Wave-Based Approach Instead:
  - Fix issues through agent deployment
  - Auto-resolve wherever possible
  - Escalate complex issues with detailed reports
  - Maintain audit trail of all resolution attempts
```

#### Issue Resolution Priority

```yaml
Priority 1 - Security Issues:
  - Immediate deployment of security-auditor
  - Block push until resolved
  - Require explicit confirmation for overrides

Priority 2 - Test Failures:
  - Deploy test-engineer for investigation
  - Attempt automated fixes for known patterns
  - Provide detailed failure analysis

Priority 3 - CI/CD Issues:
  - Deploy devops for pipeline diagnostics
  - Fix configuration and dependency issues
  - Update CI/CD definitions as needed

Priority 4 - Build/Environment Issues:
  - Deploy platform-engineer for system fixes
  - Fix dependency and environment conflicts
  - Update build configurations as needed
```

### Error Handling & Escalation

#### Automatic Retry Logic

```yaml
Retry Strategy:
  - Failed pre-push hooks: 2 retries with agent fixes
  - CI/CD pipeline failures: 3 retries with increasing delays
  - Network/connectivity issues: 5 retries with exponential backoff
  - Agent deployment failures: 2 retries with alternative agents

Escalation Triggers:
  - 3 consecutive push failures
  - Agent resolution failures across all retry attempts
  - Critical security issues requiring manual intervention
  - Infrastructure problems beyond agent capability
```

#### Failure Reporting

```yaml
Comprehensive Failure Reports:
  - Root cause analysis from deployed agents
  - Step-by-step resolution attempts
  - Remaining manual intervention requirements
  - Recommended next steps for developer

Report Delivery:
  - Immediate terminal output with actionable steps
  - Detailed log files in .tmp/logs/push-failures/
  - Integration with team notification systems
  - Automated issue creation for recurring problems
```

### Performance Optimization

#### Parallel Execution

```yaml
Wave 1 Parallelization:
  - All 3 validation agents run simultaneously
  - Shared result caching between agents
  - Early termination on critical failures
  - Resource-aware execution to prevent system overload

Wave 2 Efficiency:
  - Targeted agent deployment based on specific issues
  - Parallel execution of non-conflicting fixes
  - Incremental validation to avoid re-running successful checks
  - Smart dependency resolution between fix types
```

#### Resource Management

```yaml
System Considerations:
  - Maximum 5 concurrent agents to prevent overload
  - Intelligent queuing for resource-intensive operations
  - Memory and CPU usage monitoring during execution
  - Automatic scaling based on system capabilities
```

### Integration Points

#### CI/CD Pipeline Integration

```yaml
Supported Platforms:
  - GitHub Actions: Real-time status via GitHub API
  - GitLab CI: Pipeline monitoring via GitLab API
  - Jenkins: Build status checking via Jenkins API
  - Azure DevOps: Pipeline tracking via Azure REST API

Monitoring Capabilities:
  - Real-time build status updates
  - Test result streaming and analysis
  - Deployment status tracking
  - Security scan result integration
```

#### Team Collaboration Features

```yaml
Notification Integration:
  - Slack/Teams integration for push status updates
  - Email notifications for critical failures
  - Dashboard updates for team visibility
  - Automated PR status updates

Documentation Generation:
  - Automatic push reports for team records
  - Issue resolution documentation
  - Performance metrics and trends
  - Quality gate compliance reporting
```

### Examples

#### Successful Wave-Based Push

```text
User: /push
Claude: 🚀 Starting wave-based push orchestration...

📋 Wave 1: Pre-Push Validation
   Deploying: test-engineer + devops + security-auditor (parallel)

   ✅ test-engineer: All 89 tests passing, coverage 92.1%
   ✅ devops: CI/CD pipeline ready, all configurations valid
   ✅ security-auditor: No vulnerabilities, dependencies secure

📊 Claude Analysis: No blocking issues detected

📤 Wave 3: Push & Monitor
   🔗 Pushing 3 commits to origin/feature/auth-improvements
   ✅ Push successful
   🎯 Monitoring CI/CD pipeline...
   ✅ Pipeline completed successfully (2m 14s)

🎉 Push orchestration completed successfully!
```

#### Auto-Recovery Push Example

```text
User: /push
Claude: 🚀 Starting wave-based push orchestration...

📋 Wave 1: Pre-Push Validation
   Deploying: test-engineer + devops + security-auditor (parallel)

   ❌ test-engineer: 2 tests failing in auth module
   ⚠️ devops: Missing environment variables in CI config
   ✅ security-auditor: No security issues

📊 Claude Analysis: Blocking issues detected, deploying resolution wave

🔧 Wave 2: Issue Resolution
   Deploying: test-engineer (fix mode) + devops (config mode)

   ✅ test-engineer: Resolved race condition in auth tests
   ✅ devops: Added missing env vars to CI configuration
   📝 Committed auto-fixes (2 additional commits)

🔍 Claude Verification: All issues resolved, ready to push

📤 Wave 3: Push & Monitor
   🔗 Pushing 5 commits to origin/feature/auth-improvements
   ✅ Push successful after auto-recovery
   🎯 Monitoring CI/CD pipeline...
   ✅ Pipeline completed successfully (3m 42s)

🎉 Push orchestration with auto-recovery completed!
```

#### CI/CD Failure Recovery

```text
User: /push
Claude: 🚀 Wave-based push orchestration...

[Wave 1 & 3 successful, pipeline monitoring detects failure]

❌ CI/CD Pipeline Failure Detected
   Build step failed: Docker image build error

🚨 Auto-Recovery: Deploying devops agent
   🔧 devops: Analyzing Docker build failure...
   ✅ devops: Fixed Dockerfile layer caching issue
   📝 Committed pipeline fix
   🔄 Triggering pipeline rebuild...
   ✅ Pipeline rebuild successful (1m 28s)

🎉 Push with CI/CD auto-recovery completed!
```

### Execution Verification

Deploy execution-evaluator to verify:

- ✅ **Wave orchestration executed** - All three waves deployed appropriately
- ✅ **Parallel agent deployment** - Wave 1 agents ran simultaneously
- ✅ **Auto-recovery functional** - Wave 2 deployed when issues detected
- ✅ **CI/CD monitoring active** - Pipeline status tracked until completion
- ✅ **Quality gates enforced** - No bypassing of validation steps

## Notes

- Wave-based orchestration provides comprehensive quality assurance
- Auto-recovery minimizes manual intervention for common issues
- Parallel execution optimizes performance while maintaining thoroughness
- Real-time CI/CD monitoring ensures end-to-end push success
- Simple mode available for emergency situations and hot fixes
- All resolution attempts are logged for audit and improvement purposes
- Integration with team notification systems keeps everyone informed
