# /commit Command

## Description

Creates a git commit following Claude's standards with proper formatting
and co-authorship attribution.

## Usage

```bash
/commit
```yaml

## Agent Orchestration

### Parallel Validation Phase

Deploy specialized agents simultaneously for comprehensive commit preparation:

```yaml
code-reviewer:
  role: Analyze code changes for quality and completeness
  input: git diff output, staged and unstaged changes
  output: Change summary, quality assessment, improvement suggestions

tech-writer:
  role: Generate conventional commit messages
  input: Change analysis, repository commit style
  output: Properly formatted commit message with clear description

security-auditor:
  role: Scan for sensitive data and security issues
  input: All changed files, new additions
  output: Security clearance or blocking issues
```bash

### Agent Coordination

```yaml
Parallel Execution:
  - All three agents analyze changes simultaneously
  - Security-auditor has veto power on commits
  - Results merge for final commit decision

Critical Path:
  - If security-auditor finds issues → block commit
  - If code-reviewer finds critical issues → suggest fixes first
  - If all clear → proceed with tech-writer's message
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
```bash

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

The /commit command focuses on staging changes and creating clean commits. Code review and quality gates are handled by the /review command in the ship-it workflow.

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
