# /commit Command

## Description

Creates a git commit following Claude's standards with proper formatting
and co-authorship attribution.

**CRITICAL**: This command NEVER uses `--no-verify`. Quality gates exist to protect code
integrity and must always be respected. If pre-commit hooks fail, the issues must be fixed,
not bypassed.

## Usage

```bash
/commit
```yaml

## Agent Orchestration

### Parallel Validation Phase - Multi-Agent Instance Deployment

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
```bash

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

## Quality Gate Enforcement

### Never Bypass Hooks

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

## Behavior

When you use `/commit`, I will:

1. **Parallel Status Check** (All simultaneously):
   - `git status` to see untracked files
   - `git diff` to see staged and unstaged changes
   - `git log` to match repository's commit style

2. **Deploy Agents for Parallel Analysis**:
   - code-reviewer: Analyze change quality
   - tech-writer: Draft commit message
   - security-auditor: Check for sensitive data

3. **Clean up and stage appropriate files**:
   - **Clean up temporary files** before staging:
     - Remove temporary HTML files (\*.tmp.html, \*.temp.html)
     - Delete temporary script files (\*.tmp.js, \*.temp.py, \*.tmp.sh)
     - Clean up generated documentation (if not meant for commit)
     - Remove build artifacts and cache files
     - Delete debug/test output files
   - Add relevant untracked files that should be committed
   - Include any files modified by remediation agents
   - Exclude files that shouldn't be committed (per .gitignore and common patterns)
   - **Automatic cleanup patterns**:
     - `*.tmp`, `*.temp`, `*.bak`, `*.orig`
     - `debug_*.html`, `test_output_*.txt`
     - `.DS_Store`, `Thumbs.db`
     - Node modules, build directories (if not in .gitignore)
     - IDE-generated files (`.vscode/`, `.idea/` if not intended)
     - Log files (`*.log`, `*.out`)
     - Coverage reports and temp test files (unless explicitly needed)

4. **Create commit** with:
   - Descriptive message following conventional format
   - Claude co-authorship attribution:

     ```text
     🤖 Generated with [Claude Code](https://claude.ai/code)

     Co-Authored-By: Claude <noreply@anthropic.com>
     ```

5. **Verify success** by checking git status after commit

6. **Deploy execution-evaluator** to validate:
    - Commit was created successfully
    - Message format is correct
    - Co-authorship attribution included
    - All intended files were committed
    - No temporary files were committed
    - **CRITICAL**: Verify --no-verify flag was NOT used (hooks must run)

## Commit Message Format

Follows conventional commit format:

- `type(scope): subject`
- Types: feat, fix, docs, style, refactor, test, chore
- Subject: imperative mood, lowercase, no period

## Examples

- `feat(settings): add dark mode toggle`
- `fix(auth): resolve login timeout issue`
- `docs(readme): update installation instructions`

## File Cleanup Process

Before staging files for commit, the command automatically cleans up temporary and unwanted files:

### Automatic Cleanup Patterns

The following files are automatically detected and removed:

**Temporary Files**:

- `*.tmp`, `*.temp`, `*.bak`, `*.orig`
- `*.tmp.html`, `*.temp.html`, `*.tmp.js`, `*.temp.py`
- `debug_*.html`, `test_output_*.txt`, `scratch_*.md`

**System Files**:

- `.DS_Store`, `Thumbs.db`, `desktop.ini`
- `*.swp`, `*.swo`, `*~` (editor temp files)

**Build/Cache Artifacts** (if not in .gitignore):

- `node_modules/`, `dist/`, `build/`, `.cache/`
- `*.pyc`, `__pycache__/`, `.pytest_cache/`
- Coverage reports: `coverage/`, `.nyc_output/`

**Development Files**:

- IDE configs: `.vscode/settings.json`, `.idea/` (if not project-specific)
- Log files: `*.log`, `*.out`, `debug.txt`
- Test outputs: `test-results/`, `reports/`

### Smart Cleanup Logic

- **Preserve intentional files**: Files explicitly tracked in git are never cleaned
- **Respect .gitignore**: Uses existing ignore patterns as guidance
- **Project-aware**: Recognizes framework-specific temp files (React, Vue, Node, Python, etc.)
- **User confirmation**: Asks before removing files that might be important
- **Backup before delete**: Creates `.cleanup-backup/` for recovered files if needed

### Cleanup Override

Use these patterns to prevent cleanup of specific temp files:

- Add to `.gitkeep-temp` file in project root
- Use `# KEEP` comment in file header
- Prefix filename with `keep_` (e.g., `keep_temp_analysis.html`)

## Streamlined Commit Process

The /commit command focuses on staging changes and creating clean commits. Code review and quality gates are
handled by the /review command in the ship-it workflow.

## Prerequisites

- Git must be initialized in the repository
- Changes must exist (staged or unstaged)

## Notes

- **Automatic file cleanup** removes temporary files before staging (with safety checks)
- If pre-commit hooks modify files, the commit will be retried once
- Empty commits are not created
- Code review is handled separately by the /review command
- Cleanup creates backups of removed files in `.cleanup-backup/` directory for 24 hours
- Files explicitly tracked in git are never removed during cleanup
