# Branch Protection Setup

This document explains how to configure branch protection rules for the `main` branch to
ensure all changes pass tests before merging.

## Setting Up Branch Protection

1. **Navigate to Repository Settings**
   - Go to your repository on GitHub
   - Click on "Settings" tab
   - Select "Branches" from the left sidebar

2. **Add Branch Protection Rule**
   - Click "Add rule" button
   - Enter `main` as the branch name pattern

3. **Configure Protection Settings**

   ### Required Status Checks

   - ✅ **Require status checks to pass before merging**
   - ✅ **Require branches to be up to date before merging**

   Select these required status checks:
   - `Run Tests`
   - `Validate Repository Structure`
   - `Lint Markdown Files`
   - `Test Changes`
   - `Validate Commands`
   - `Security Scan`

   ### Additional Settings

   - ✅ **Require pull request reviews before merging** (recommended)
     - Required approving reviews: 1
     - Dismiss stale pull request approvals when new commits are pushed
   - ✅ **Require conversation resolution before merging**
   - ✅ **Include administrators** (optional but recommended)

4. **Save Changes**
   - Click "Create" to save the branch protection rule

## GitHub Actions Status Checks

The following workflows must pass for PRs to be mergeable:

### CI Workflow (`ci.yml`)

- **Run Tests**: Executes the full test suite
- **Validate Repository Structure**: Ensures all required files exist
- **Lint Markdown Files**: Checks markdown formatting

### PR Checks Workflow (`pr-checks.yml`)

- **Test Changes**: Runs tests and identifies changed files
- **Validate Commands**: Ensures command files have proper structure
- **Security Scan**: Checks for sensitive data patterns

## Bypass Protection (Emergency Only)

Administrators can bypass protection if needed:

1. Check "Include administrators" when setting up rules to enforce even for admins
2. Uncheck it if admins need ability to bypass in emergencies

## Monitoring

- All PR checks appear in the PR's "Checks" tab
- Failed checks block the merge button
- Detailed logs available by clicking on each check

## Troubleshooting

If checks are failing:

1. Click on the failing check for details
2. Review the logs to identify the issue
3. Fix the issue and push new commits
4. Checks will automatically re-run

## Best Practices

1. Always create PRs for changes (never push directly to main)
2. Wait for all checks to pass before requesting review
3. Keep PRs focused and small for easier review
