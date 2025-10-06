---
description: Orchestrate development workflows by calling other commands
argument-hint: [-f|--full|-l|--lite]
---

# /ship-it Command

## Usage

```bash
/ship-it                         # Normal workflow: docs → review → test → commit → push
/ship-it --full | -f             # Full workflow: docs → review → test → commit → push → pr
/ship-it --lite | -l             # Lite workflow: commit → push
```

## Description

Orchestrates complete development workflows by calling streamlined commands in sequence. Acts as a pure coordinator
that delegates to specialized commands (/docs, /review, /test, /commit, /push, /pr) instead of deploying agents
directly.

**Philosophy:** Simple command orchestration following KISS principle. Each step invokes an existing command and reports
results.

## Workflow Modes

### Lite Mode (`--lite` or `-l`)

Fast workflow for quick commits and pushes:

```yaml
Step 1: /commit     # Create commit with generated message
Step 2: /push       # Push to remote
```

**Use case:** Hot fixes, quick updates, documentation tweaks

### Normal Mode (default, no arguments)

Standard development workflow with quality checks:

```yaml
Step 1: /docs       # Update documentation based on changes
Step 2: /review     # Code review with linters and security
Step 3: /test       # Run test suite
Step 4: /commit     # Create commit with generated message
Step 5: /push       # Push to remote
```

**Use case:** Feature development, bug fixes, regular commits

### Full Mode (`--full` or `-f`)

Complete workflow including PR creation:

```yaml
Step 1: /docs       # Update documentation
Step 2: /review     # Code review
Step 3: /test       # Run tests
Step 4: /commit     # Create commit
Step 5: /push       # Push to remote
Step 6: /pr main    # Create PR (only if none exists)
```

**Use case:** Feature completion, ready for code review

## Behavior

### Command Orchestration

Each step follows this pattern:

1. **Announce Step:** Display "📋 Step N/M: [Step Name]"
2. **Invoke Command:** Use SlashCommand tool to call the command
3. **Show Output:** Display command's output to user
4. **Check Result:** Determine if command succeeded or failed
5. **Handle Outcome:**
   - **Success:** Mark step complete, continue to next step
   - **Failure:** Report error, halt workflow

### Error Handling

**Halt-on-Failure Strategy:**

Any command failure stops the workflow immediately. User must fix the issue and re-run /ship-it.

```yaml
If /docs fails:
  - Report: Documentation update failed
  - Action: Halt workflow, user fixes docs manually

If /review fails:
  - Report: Code quality issues detected
  - Action: Halt workflow, user fixes issues manually
  - Tip: Review the linter output and fix violations

If /test fails:
  - Report: Tests are failing
  - Action: Halt workflow, user fixes tests
  - Tip: Run /test directly to debug failures

If /commit fails:
  - Report: Pre-commit hook failure
  - Action: Halt workflow, user fixes hook issues
  - Note: NEVER uses --no-verify

If /push fails:
  - Report: Push failed (auth, network, hooks)
  - Action: Halt workflow, user resolves issue
  - Tip: Check git credentials and network

If /pr fails:
  - Report: PR creation failed
  - Action: Workflow still successful (changes pushed)
  - Note: User can run /pr manually if needed
```

### Smart Skipping

Commands automatically skip when appropriate:

```yaml
/commit:
  - Skips if: No changes to commit (clean working tree)
  - Reports: "✅ No changes to commit"

/push:
  - Skips if: Already up to date with remote
  - Reports: "✅ Already up to date"

/pr:
  - Skips if: PR already exists for current branch
  - Reports: "✅ PR already exists: [URL]"
```

### Workflow Determination

Based on `$ARGUMENTS`:

```bash
# Detect workflow mode
if [[ "$ARGUMENTS" == *"--lite"* ]] || [[ "$ARGUMENTS" == *"-l"* ]]; then
  mode="lite"
  steps=2
elif [[ "$ARGUMENTS" == *"--full"* ]] || [[ "$ARGUMENTS" == *"-f"* ]]; then
  mode="full"
  steps=6
else
  mode="normal"
  steps=5
fi
```

## Expected Output

### Successful Normal Workflow

```text
🚀 Starting ship-it workflow: normal
────────────────────────────────────────

📋 Step 1/5: Update Documentation
  Running: /docs

  Analyzing README.md...
    - Updated installation steps for Node 18+
    - Added new API endpoint examples
    - Fixed broken links (3 found)
  ✅ README.md updated

  ✅ Step 1 complete

📋 Step 2/5: Code Review
  Running: /review

  🔍 Reviewing changed files...

  📋 Changed Files: 3 files
    - src/auth/login.ts
    - src/api/endpoints.ts
    - README.md

  🔧 Running Linters:
    ✅ ESLint: 0 issues
    ✅ Prettier: All files formatted correctly
    ✅ TypeScript: No type errors

  📊 Review Summary:

  ✅ Overall: Good code quality with minor improvements needed

  ✅ Step 2 complete

📋 Step 3/5: Run Tests
  Running: /test

  🔍 Discovering test command...

  ✅ Found: npm test (from package.json scripts)

  🧪 Running tests...

  Test Suites: 3 passed, 3 total
  Tests:       45 passed, 45 total
  Time:        8.234 s

  ✅ All tests passed (45/45)

  ✅ Step 3 complete

📋 Step 4/5: Create Commit
  Running: /commit

  Analyzing repository changes...

  📋 Changes Summary:
    Modified: 3 files
      - src/auth/login.ts (authentication improvements)
      - src/api/endpoints.ts (API updates)
      - README.md (documentation updates)

  📝 Commit Message:
  feat(auth): implement JWT token refresh mechanism

  - Add automatic token refresh before expiration
  - Include comprehensive test coverage for auth flows
  - Update README with new authentication setup steps

  🤖 Generated with Claude Code
  Co-Authored-By: Claude <noreply@anthropic.com>

  ✅ Commit created: a1b2c3d

  ✅ Step 4 complete

📋 Step 5/5: Push Changes
  Running: /push

  📤 Pushing changes to remote...

  📋 Repository Status:
    Current branch: feature/auth-improvements
    Remote: origin/feature/auth-improvements
    Commits ahead: 3

  📤 Pushing to origin/feature/auth-improvements...
  ✅ Push successful

  🎉 Pushed 3 commits:
    - a1b2c3d feat(auth): implement JWT token refresh
    - b2c3d4e fix(auth): handle expired tokens
    - c3d4e5f test(auth): add token expiry tests

  ✅ Step 5 complete

🎉 Ship-it workflow complete!
────────────────────────────────────────
Mode: normal
Steps completed: 5/5
Total time: 1m 42s
All checks passed ✅
```

### Successful Full Workflow (with PR)

```text
🚀 Starting ship-it workflow: full
────────────────────────────────────────

[Steps 1-5 same as normal workflow]

📋 Step 6/6: Create Pull Request
  Running: /pr main

  🔍 Analyzing changes from main...
    Files changed: 3
    Commits: 3

  📝 Generating PR content...
    Title: feat(auth): implement JWT token refresh mechanism

  ✅ Pull request created:
    https://github.com/owner/repo/pull/123

  ✅ Step 6 complete

🎉 Ship-it workflow complete!
────────────────────────────────────────
Mode: full
Steps completed: 6/6
Total time: 2m 18s
All checks passed ✅
PR created: #123
```

### Lite Workflow

```text
🚀 Starting ship-it workflow: lite
────────────────────────────────────────

📋 Step 1/2: Create Commit
  Running: /commit

  Analyzing repository changes...

  📝 Commit Message:
  chore: update dependencies to latest versions

  ✅ Commit created: d4e5f6a

  ✅ Step 1 complete

📋 Step 2/2: Push Changes
  Running: /push

  📤 Pushing to origin/main...
  ✅ Push successful

  ✅ Step 2 complete

🎉 Ship-it workflow complete!
────────────────────────────────────────
Mode: lite
Steps completed: 2/2
Total time: 12s
```

### Workflow Halted (Test Failure)

```text
🚀 Starting ship-it workflow: normal
────────────────────────────────────────

📋 Step 1/5: Update Documentation
  Running: /docs

  ✅ Documentation updated

  ✅ Step 1 complete

📋 Step 2/5: Code Review
  Running: /review

  ✅ Code review passed

  ✅ Step 2 complete

📋 Step 3/5: Run Tests
  Running: /test

  🔍 Discovering test command...

  ✅ Found: pytest -v (from pytest.ini)

  🧪 Running tests...

  ======================== test session starts ========================
  tests/test_auth.py::test_login PASSED                         [ 20%]
  tests/test_auth.py::test_logout FAILED                        [ 40%]
  tests/test_api.py::test_get_user PASSED                       [ 60%]
  tests/test_api.py::test_create_user FAILED                    [ 80%]
  tests/test_utils.py::test_helpers PASSED                      [100%]

  ============================= FAILURES ==============================
  ______________________ test_logout _________________________________

      def test_logout():
  >       assert logout_user() == True
  E       AssertionError: assert False == True

  tests/test_auth.py:12: AssertionError

  ______________________ test_create_user ____________________________

      def test_create_user():
  >       response = api.create_user({"name": "test"})
  E       KeyError: 'email'

  tests/test_api.py:25: KeyError

  ==================== 2 failed, 3 passed in 2.34s ===================

  ❌ 2 of 5 tests failed

❌ Ship-it workflow halted at Step 3/5
────────────────────────────────────────
Reason: Tests failed

Failed tests:
  1. test_logout (tests/test_auth.py:12)
     AssertionError: assert False == True

  2. test_create_user (tests/test_api.py:25)
     KeyError: 'email'

💡 Next steps:
  1. Fix the failing tests
  2. Run /test to verify fixes
  3. Run /ship-it again to complete workflow
```

### PR Already Exists (Smart Skip)

```text
📋 Step 6/6: Create Pull Request
  Running: /pr main

  🔍 Checking for existing PR...

  ✅ PR already exists: https://github.com/owner/repo/pull/119

  ✅ Step 6 complete (skipped - PR exists)
```

## Performance Metrics

```yaml
Execution Times:
  Lite: 10-20 seconds (commit + push only)
  Normal: 1-2 minutes (5 steps with quality checks)
  Full: 1.5-2.5 minutes (6 steps including PR)

Command Delegation:
  Lite: 2 commands (/commit, /push)
  Normal: 5 commands (/docs, /review, /test, /commit, /push)
  Full: 6 commands (/docs, /review, /test, /commit, /push, /pr)

Agent Usage:
  - /ship-it deploys: 0 agents (pure orchestrator)
  - Delegated commands may deploy: 0-2 agents each
  - Total agents: Depends on delegated commands' behavior
```

## Quality Gates

```yaml
Non-Negotiable Rules:
  - NEVER bypass quality gates with --no-verify
  - Halt workflow on any command failure
  - Respect existing PRs (don't create duplicates)
  - Trust delegated commands' error handling
  - Show all command outputs to user
```

## Success Criteria

✅ Workflow executes commands in correct sequence
✅ Each command's output visible to user
✅ Failures halt workflow with clear error reporting
✅ Smart skipping for no-op situations
✅ No direct agent deployment (pure orchestration)
✅ Fast execution (1-3 minutes for most workflows)
✅ Clear progress reporting at each step

## Notes

- Pure command orchestrator - delegates all work to specialized commands
- No direct agent deployment - relies on command implementations
- DRY principle - no duplicated logic from other commands
- Transparent execution - user sees all command outputs
- Maintainable - fix commands once, /ship-it benefits
- Flexible - can run commands individually or via workflow
- Consistent - same behavior via /ship-it or direct command invocation
- Fast - minimal overhead, command execution only
