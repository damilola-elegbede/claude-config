# /fix-ci Command

## Description

Analyzes CI/CD failures from GitHub and deploys targeted fixes using appropriate specialists.

## Behavior

Automatically detects and fixes CI/CD pipeline failures by:

1. **Fetching failure details** from GitHub Actions using `gh` CLI
2. **Parallel analysis** deploying multiple specialist agents (debugger, devops, test-engineer, principal-architect)
3. **Synthesizing findings** to create a comprehensive fix plan
4. **Executing targeted fixes** using appropriate specialists based on failure patterns
5. **Verifying success** with execution-evaluator to ensure genuine CI resolution

The command operates with smart defaults for common issues (lint, tests, dependencies) while escalating
complex failures to appropriate domain experts. Includes automatic retry logic and fail-fast patterns for
infrastructure issues.

## Usage

```bash
/fix-ci [options]
```yaml

## Options

- `--pr <number>` - Fix CI for specific PR (default: current branch)
- `--run <id>` - Target specific workflow run
- `--fast` - Skip multi-agent analysis, apply quick fixes

## Workflow

### 1. Fetch & Analyze

```bash
# Get latest failure details
gh run list --status=failure --limit=1 --json databaseId,conclusion
gh run view <run-id> --log-failed
```text

Deploy analysis agents in parallel to thoroughly understand all failures:

- **debugger**: Analyze stack traces, errors, code issues
- **devops**: Review CI config, dependencies, infrastructure
- **test-engineer**: Examine test failures, flakiness, coverage
- **principal-architect**: Assess complex/unclear failures

Synthesize all analyses to create comprehensive fix plan.

### 2. Execute Fix Plan

Based on analysis, deploy appropriate specialist(s):

| Failure Pattern | Primary Agent | Quick Fix |
|----------------|---------------|-----------|
| Test failures | test-engineer | Fix assertions, mocks, timeouts |
| Type/syntax errors | debugger → backend-engineer | Fix code issues |
| Lint/format | Direct fix | Run formatter/linter |
| Build config | devops | Fix CI yaml, dependencies |
| Security scan | security-auditor | Address vulnerabilities |
| Performance | performance-specialist | Only if timeout-related |
| Unknown/complex | principal-architect | System-wide issues |

### 3. Verify

- Apply fixes
- Commit with descriptive message
- Push and monitor CI result
- Deploy execution-evaluator to confirm:
  - Failures were correctly identified
  - Appropriate fixes were applied
  - CI is genuinely passing (not false positive)

## Smart Defaults

1. **Thorough analysis** - Multiple agents analyze in parallel
2. **Targeted execution** - Fix based on comprehensive understanding
3. **Fast path for common issues**:
   - ESLint → Run `npm run lint:fix`
   - Missing deps → Check package.json
   - Flaky tests → Add retry or increase timeout
4. **Escalate if stuck** - After 2 attempts, get human help

## Example

```text
User: /fix-ci

Claude: Fetching CI failures from GitHub...

Found 2 failures. Deploying analysis agents in parallel...

debugger: ESLint errors are formatting issues, no logic problems
devops: No CI config issues, dependencies are correct
test-engineer: Test timeout due to missing await on async call
principal-architect: No architectural concerns

Analysis synthesis:
1. ❌ ESLint errors in 3 files → Simple formatting fix
2. ❌ Test "auth.test.js" timeout → Async handling issue

Executing fix plan:

[1/2] Fixing ESLint errors directly...
✓ Fixed with npm run lint:fix

[2/2] Deploying test-engineer for timeout issue...
✓ Increased timeout and added proper async handling

Created fix commit: "fix: resolve CI failures (lint + test timeout)"
Pushed. CI running... ✅ Passing!

Deploying execution-evaluator for final verification...
✓ All failures properly addressed
✓ No regressions introduced
✓ CI genuinely passing
```yaml

## Pragmatic Rules

- **Don't over-analyze** - If error message is clear, fix it
- **Batch simple fixes** - Combine lint/format/typos in one pass  
- **Fail fast** - If CI infrastructure issue, report and stop
- **Learn patterns** - Remember common fixes for this repo
- **Respect limits** - Max 2 retry attempts before escalating

## When NOT to Use

- Infrastructure failures (GitHub Actions down)
- Credential/secrets issues (needs human)
- Approved PR with passing CI (nothing to fix)
- Massive refactoring needed (use dedicated agents)
