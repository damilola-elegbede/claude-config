---
description: Orchestrate development workflows with auto-resolution
argument-hint: [--full | --lite]
---

# /ship-it Command

## Usage

```bash
/ship-it                         # Basic workflow: docs audit → review → commit → push
/ship-it --full                  # Full workflow: docs → review → test → commit → push → pr
/ship-it --lite                  # Lite workflow: commit → push
```

Use `$ARGUMENTS` to determine workflow type (empty for basic, `--full` or `-f` for full, `--lite` or `-l` for lite).

## Description

Orchestrate development workflows by running multiple `/` commands in sequence with **automatic issue resolution**.
When commands report problems, attempt reasonable fixes but prioritize completing the workflow, especially ensuring
the PR gets created in full mode.

Execute one of three workflow types:

- **Basic (default)**: `/review --quick` → `/commit` → `/push`
- **Full (--full/-f)**: `/review` → `/test` → `/commit` → `/push` → `/pr`
- **Lite (--lite/-l)**: `/commit` → `/push`

## Expected Output

### Execution Flow Example

```text
🚀 Starting ship-it workflow: [basic|full|lite]

Step 1/5: /review
✅ Review completed

Step 2/5: /test
⚠️ 2 tests failing - attempting quick fix...
✅ Fixed 1 test, continuing with workflow

Step 3/5: /commit
✅ Commit created successfully

Step 4/5: /push
✅ Pushed to remote

Step 5/5: /pr (full mode only)
✅ Pull request created: https://github.com/owner/repo/pull/123

🎉 Ship-it workflow completed!
  - 4/5 commands succeeded
  - 1 test still failing (logged for manual review)
  - PR created successfully
```

## Behavior

### Core Principles

- **Limited Remediation**: Max 2 retry attempts per command to avoid getting stuck
- **Workflow Completion**: Prioritize completing all steps, especially PR creation in full mode
- **Smart Fixes**: Apply obvious fixes but don't over-engineer solutions
- **PR Guarantee**: In full mode, always attempt to create PR even if earlier steps had issues
- **Smart PR Detection**: Create PR only if none exists for current branch
- **Time Bounded**: Complete workflow within reasonable time (5-10 minutes max)

### Wave-Based Orchestration Pattern

#### Wave 1: Workflow Execution

Execute configured workflow commands in sequence, monitoring for failures in real-time.
Commands run with full error capture and issue classification.

#### Claude Analysis Phase

Between Wave 1 and Wave 2, Claude performs rapid failure analysis:

- Parse all error outputs simultaneously
- Classify issues by type and severity
- Calculate optimal agent deployment strategy
- Prepare parallel deployment configuration

#### Wave 2: Auto-Remediation (Enhanced)

Deploy multiple specialist instances per failure type in MASSIVE PARALLEL EXECUTION:

```yaml
Security Issues:
  - Deploy 3-5 security-auditor instances
  - Each instance handles different security aspects
  - Parallel scanning of auth, dependencies, vulnerabilities

Performance Issues:
  - Deploy 2-4 performance-specialist instances
  - Deploy 2-3 performance-engineer instances
  - Each targets specific bottlenecks simultaneously

Code Quality Issues:
  - Deploy 3-6 code-reviewer instances per file
  - Deploy backend-engineer/frontend-architect as needed
  - Parallel linting, formatting, structure fixes

Testing Issues:
  - Deploy 5-10 test-engineer instances
  - One instance per failing test file
  - Parallel test fixes and coverage additions

Documentation Issues:
  - Deploy 2-4 tech-writer instances
  - Deploy 1-2 accessibility-auditor instances
  - Parallel doc generation and updates

Infrastructure Issues:
  - Deploy 2-3 devops instances
  - Deploy 2-3 platform-engineer instances
  - Parallel environment and config fixes

Dependency Issues:
  - Deploy 3-4 security-auditor instances
  - Each handles different dependency chains
  - Parallel vulnerability patching
```

#### Claude Verification Phase

After Wave 2 remediation:

- Collect results from all parallel agents
- Verify fixes are comprehensive
- Prepare retry strategy if needed

#### Wave 3: Complete Workflow

After remediation attempt, continue with remaining commands:

- If a command fails after 2 retries, log issue and continue
- **Priority**: Complete all workflow steps
- **Full mode**: ALWAYS attempt to create PR as final step
- Don't let perfect be the enemy of done

### Enhanced Agent Routing Logic

```yaml
# PARALLEL DEPLOYMENT PATTERNS
Security Issues:
  instances: 3-5 security-auditor
  distribution:
    - Auth flow analysis
    - Session management audit
    - Dependency vulnerability scan
    - Permission boundary check
    - Secret detection sweep

Performance Issues:
  instances: 4-7 total
    - 2-4 performance-specialist (analysis)
    - 2-3 performance-engineer (optimization)
  distribution:
    - Database query optimization
    - Algorithm complexity reduction
    - Memory leak detection
    - Network latency analysis
    - Caching strategy implementation

Code Quality:
  instances: 5-10 total
    - 3-6 code-reviewer
    - 2-4 backend-engineer/frontend-architect
  distribution:
    - One instance per file with issues
    - Parallel linting across all files
    - Simultaneous structure improvements
    - Concurrent formatting fixes

Testing Issues:
  instances: 5-15 test-engineer
  distribution:
    - One instance per failing test file
    - Additional instances for coverage gaps
    - Parallel test generation
    - Concurrent fixture creation

Git/CI Issues:
  instances: 3-5 devops
  distribution:
    - Merge conflict resolution
    - Hook failure fixes
    - Pipeline repair
    - Branch management

Documentation:
  instances: 3-6 total
    - 2-4 tech-writer
    - 1-2 accessibility-auditor
  distribution:
    - API documentation
    - README updates
    - Code comments
    - Usage examples
```

### Parallel Workflow Orchestration

Deploy project-orchestrator for workflow optimization:

```yaml
project-orchestrator (Wave Planning):
  role: Design optimal wave execution strategy
  input: Workflow dependencies, failure patterns
  output: Wave configuration, parallelization plan

project-orchestrator (Resource Allocation):
  role: Calculate agent instance requirements
  input: Issue count, complexity metrics
  output: Instance deployment counts per agent type

project-orchestrator (Recovery Strategy):
  role: Handle critical failures and recovery
  input: Failure patterns, system state
  output: Recovery waves, escalation paths

Parallel Execution Patterns:
  Wave 1:
    - Sequential command execution
    - Real-time failure monitoring
  Wave 2:
    - 10-30+ agents deployed simultaneously
    - No sequential agent deployment
    - All fixes applied in parallel
  Wave 3:
    - Retry commands with all fixes
    - Continue until 100% success OR initiate Wave 4
  Wave N:
    - Exponentially scaled specialist deployment
    - Alternative remediation strategies
    - Never-ending until successful ship
```

### Issue Resolution by Command (Enhanced)

#### /docs Issues → Massive Parallel Fix

- Deploy 3-5 tech-writer instances simultaneously
- Each instance handles different doc sections
- Deploy api-architect for API docs in parallel
- Deploy codebase-analyst for example fixes
- All agents work concurrently, no waiting

#### /review Issues → Parallel Agent Army

- Deploy 3-5 security-auditor instances for vulnerabilities
- Deploy 2-4 performance-specialist instances for bottlenecks
- Deploy 5-10 code-reviewer instances for quality issues
- Deploy 5-8 test-engineer instances for coverage gaps
- Deploy 2-3 tech-writer instances for documentation
- ALL DEPLOYED IN ONE WAVE - 20-30 agents working simultaneously

#### /test Issues → Test Engineer Swarm

- Deploy 1 test-engineer per failing test file (could be 10-20 instances)
- Deploy additional instances for coverage gaps
- Deploy devops instances for environment issues
- All instances fix different tests simultaneously
- No sequential test fixing - pure parallel execution

#### /commit Issues → Parallel Resolution

- Deploy 2-3 devops instances for staging conflicts
- Deploy code-reviewer instances for hook failures
- Deploy execution-evaluator for file management
- Simultaneous conflict resolution and cleanup

#### /push Issues → Multi-Instance Recovery

- Deploy 3-5 specialists for hook failures
- Deploy 2-3 code-reviewer instances for linting
- Deploy 2-3 devops instances for merge conflicts
- All instances work on different aspects simultaneously

#### /pr Issues → Concurrent Enhancement

- Deploy 2-3 tech-writer instances for template/description
- Deploy devops for branch management
- Deploy code-reviewer for final quality check
- Parallel PR preparation and submission

### Continuous Wave Patterns (Never-Fail Philosophy)

#### Wave Execution Strategy

```yaml
Wave 1 (Execution):
  - Run commands sequentially
  - Capture all failures
  - No immediate retries

Wave 2 (Remediation):
  - Deploy 10-30+ agents simultaneously
  - All fixes applied in parallel
  - No sequential fixing
  - Complete remediation in one pass

Wave 3 (Verification):
  - Retry all failed commands
  - If ANY failure detected → initiate Wave 4
  - Continue workflow ONLY on 100% success

Wave 4+ (Continuous Remediation):
  - Deploy 2x previous wave's agent count
  - Try alternative remediation approaches
  - Deploy experimental specialist combinations
  - Each wave discovers new failure patterns
  - Waves continue until SHIPPED

Never-Fail Examples:
  Wave 3 → Wave 4: Deploy remediation armies until successfully shipped
  Wave 4 → Wave 5: Alternative strategies with 4x original agent deployment
  Wave 5 → Wave 6: Experimental approaches with specialized agent combinations
  Wave N → Wave N+1: Continue indefinitely - literally never gives up
```

#### Execution Limits

```yaml
Per Command: Maximum 2 retry attempts
Remediation: Deploy 5-10 agents for quick fixes only
Workflow Time: 5-10 minutes maximum
PR Creation: Always attempt in full mode, even if earlier steps failed
Philosophy: Complete the workflow and ship it, don't get stuck on perfection
```

### Workflow State Management

```yaml
Wave Tracking: .tmp/ship-it/waves.log with detailed wave execution
Progress Tracking: .tmp/ship-it/progress.log with issue resolution
Command Status: PENDING → EXECUTING → WAVE_2_REMEDIATION → WAVE_3_RETRY → [WAVE_N_CONTINUOUS] → COMPLETED
Agent Deployment: Track all parallel instances across ALL waves
Issue Classification: Security, Performance, Quality, Testing, Infrastructure
Fix History: Comprehensive audit trail of all remediation actions across waves
Success Metrics:
  - Commands fixed per wave
  - Total agents deployed (can exceed 100+ in later waves)
  - Parallel execution factor (scales exponentially)
  - Wave completion times
  - Overall success rate (target: 100% - no exceptions)
Continuous Wave Metrics:
  - Number of waves required for success
  - Agent scaling factor per wave
  - Alternative approaches attempted
  - Time to final success (no maximum)
```

### Performance Metrics

```yaml
Optimal Execution:
  - Basic workflow: 2-3 minutes
  - Full workflow: 3-5 minutes (including PR creation)
  - Lite workflow: 1-2 minutes

Remediation Approach:
  - Quick fixes only: 5-10 agents maximum
  - Max 2 retries per command
  - Continue workflow even if command fails

Success Indicators:
  - Workflow completes within time limit
  - PR created successfully in full mode
  - Most commands succeed (80%+ success rate acceptable)
  - Clear output showing what was completed
```
