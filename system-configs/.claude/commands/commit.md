---
description: Creates git commit with Claude standards and quality gates
argument-hint: [--amend]
---

# /commit Command

## Usage

```bash
/commit                         # Create commit with analysis and cleanup
/commit --amend                 # Amend last commit with staged changes
```

## Description

Creates a git commit following Claude's standards with proper formatting and co-authorship attribution.

**CRITICAL**: This command NEVER uses `--no-verify`. Quality gates exist to protect code integrity
and must always be respected. If pre-commit hooks fail, the issues must be fixed, not bypassed.

## Expected Output

### Parallel Status and Analysis Phase

```text
🔍 Deploying parallel analysis agents...
📊 Agent Status:
  - code-reviewer[1]: Analyzing frontend changes...
  - code-reviewer[2]: Analyzing backend changes...
  - code-reviewer[3]: Analyzing test/config changes...
  - security-auditor[1]: Scanning for secrets...
  - security-auditor[2]: Vulnerability assessment...
  - tech-writer: Generating commit messages...
  - test-engineer: Running affected tests...
```

### Commit Creation Output

```text
✅ Analysis complete (4.2 seconds)
🧹 Cleaning up temporary files...
📝 Staging changes:
  - src/components/Login.tsx
  - src/services/auth.ts
  - tests/auth.test.ts
  - src/types/user.ts

📋 Commit Message:
feat(auth): implement user login with JWT tokens

- Add login component with form validation
- Integrate JWT authentication service
- Include comprehensive test coverage
- Add TypeScript types for user data

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>

✅ Commit created: abc1234
```

### File Cleanup Process

Before staging files for commit, the command automatically cleans up temporary and unwanted files:

**Automatic Cleanup Patterns**:

- **Temporary Files**: `*.tmp`, `*.temp`, `*.bak`, `*.orig`, `*.tmp.html`, `*.temp.html`,
  `*.tmp.js`, `*.temp.py`, `debug_*.html`, `test_output_*.txt`, `scratch_*.md`
- **System Files**: `.DS_Store`, `Thumbs.db`, `desktop.ini`, `*.swp`, `*.swo`, `*~`
- **Build/Cache Artifacts**: `node_modules/`, `dist/`, `build/`, `.cache/`, `*.pyc`,
  `__pycache__/`, `.pytest_cache/`, coverage reports
- **Development Files**: IDE configs, log files, test outputs

**Smart Cleanup Logic**:

- **Preserve intentional files**: Files explicitly tracked in git are never cleaned
- **Respect .gitignore**: Uses existing ignore patterns as guidance
- **Project-aware**: Recognizes framework-specific temp files
- **User confirmation**: Asks before removing files that might be important
- **Backup before delete**: Creates `.cleanup-backup/` for recovered files

**Cleanup Override**: Add to `.gitkeep-temp` file, use `# KEEP` comment, or prefix with `keep_`

### Commit Message Format

Follows conventional commit format:

- `type(scope): subject`
- Types: feat, fix, docs, style, refactor, test, chore
- Subject: imperative mood, lowercase, no period

**Examples**:

- `feat(settings): add dark mode toggle`
- `fix(auth): resolve login timeout issue`
- `docs(readme): update installation instructions`

## Behavior

### Agent Orchestration Strategy

Deploy specialized agents and multiple instances for comprehensive commit preparation:

```yaml
# PARALLEL WAVE 1: Simultaneous Change Analysis
code-reviewer (instance pool):
  deployment: 2-3 instances based on number of changed files
  distribution:
    - instance_1: Frontend/UI changes
    - instance_2: Backend/API changes
    - instance_3: Test and configuration changes
  role: Analyze code changes for quality and completeness
  parallel_with: [tech-writer, security-auditor instances, test-engineer]
  output: Change summary, quality assessment per domain

tech-writer:
  role: Generate conventional commit messages
  input: Change analysis from all reviewers, repository commit style
  parallel_with: [code-reviewer instances, security-auditor instances, test-engineer]
  output: Multiple commit message options ranked by clarity

security-auditor (instance pool):
  deployment: 2 instances for thorough scanning
  distribution:
    - instance_1: Credentials, API keys, secrets scanning
    - instance_2: Security patterns, vulnerable dependencies
  role: Scan for sensitive data and security issues
  parallel_with: [code-reviewer instances, tech-writer, test-engineer]
  output: Security clearance or blocking issues

test-engineer:
  role: Verify tests still pass with staged changes
  input: Changed files, test suites affected
  parallel_with: [code-reviewer instances, tech-writer, security-auditor instances]
  output: Test status, breaking change detection

codebase-analyst:
  role: Analyze impact of changes on codebase
  input: Changed files, dependency graph
  parallel_with: [all other agents]
  output: Impact assessment, related files that might need updates
```

### Agent Coordination

```yaml
Parallel Execution Strategy:
  Phase 1 - Parallel Analysis (3-5 seconds):
    File Distribution:
      - Divide changed files among code-reviewer instances
      - Each instance analyzes different file types/domains
      - Security-auditor instances scan all files simultaneously

    Simultaneous Tasks:
      - code-reviewer instance 1: Frontend changes
      - code-reviewer instance 2: Backend changes
      - code-reviewer instance 3: Tests/configs
      - security-auditor instance 1: Secret scanning
      - security-auditor instance 2: Vulnerability check
      - tech-writer: Draft commit messages
      - test-engineer: Run affected tests
      - codebase-analyst: Impact analysis

  Phase 2 - Result Aggregation:
    - Combine all code-reviewer findings
    - Merge security scan results (any issue = block)
    - Select best commit message from tech-writer options
    - Incorporate test results and impact analysis

  Critical Path:
    - Security issues (any instance) → block commit
    - Test failures → suggest fixes first
    - All clear → proceed with best message

Performance Metrics:
  - Sequential: 15-20 seconds for large commits
  - Parallel: 3-5 seconds (75% faster)
  - More thorough analysis with multiple instances
```

### Quality Gate Enforcement

```yaml
Prohibited Practices:
  - NEVER use: git commit --no-verify
  - NEVER bypass: pre-commit hooks
  - NEVER skip: quality validation

Required Approach:
  - Fix issues identified by hooks
  - Run validation tools
  - Ensure all checks pass
  - Only commit clean code

If Hooks Fail:
  1. Read the error message carefully
  2. Fix the identified issues (lint, tests, security)
  3. Re-run validation
  4. Try commit again
  5. Never resort to --no-verify

Rationale:
  - Pre-commit hooks prevent broken code from entering history
  - Quality gates catch issues before they reach CI/CD
  - Bypassing hooks creates technical debt
  - Team productivity depends on clean commits
```

### Execution Verification

Deploy execution-evaluator to verify:

- ✅ **Commit created** - Git commit successfully created with valid hash
- ✅ **Message format** - Conventional commit format with proper structure
- ✅ **Co-authorship** - Claude attribution included in commit message
- ✅ **Files staged** - All intended files were committed to repository
- ✅ **Cleanup executed** - Temporary files removed before staging
- ✅ **Hooks respected** - Pre-commit hooks executed (no --no-verify used)
- ✅ **Clean state** - Repository in clean state after commit
- ✅ **Agent coordination** - Multi-agent validation completed successfully

### Prerequisites

- Git must be initialized in the repository
- Changes must exist (staged or unstaged)

### Notes

- **Automatic file cleanup** removes temporary files before staging (with safety checks)
- If pre-commit hooks modify files, the commit will be retried once
- Empty commits are not created
- Code review is handled separately by the /review command
- Cleanup creates backups of removed files in `.cleanup-backup/` directory for 24 hours
- Files explicitly tracked in git are never removed during cleanup
- The /commit command focuses on staging changes and creating clean commits
