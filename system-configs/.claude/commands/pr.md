# /pr Command

## Description

Creates comprehensive pull requests with intelligent change analysis, automated description generation, breaking change detection, and smart reviewer assignment. Generates professional PR descriptions that follow best practices and team conventions.

## Usage

```bash
/pr [target_branch] [options]
```

## Arguments

- `target_branch` (optional): Target branch for the PR (default: main/master)
- `--draft`: Create as draft PR for work in progress
- `--no-reviewers`: Skip automatic reviewer assignment
- `--urgent`: Add urgent/priority labels

## Behavior

When you invoke `/pr`, I will:

1. **Validate PR readiness** - Check for uncommitted changes and branch status
2. **Analyze all changes** - Deep diff analysis against target branch
3. **Detect impact scope** - Identify breaking changes and affected systems
4. **Generate comprehensive description** - Create detailed, structured PR content
5. **Assign metadata** - Add appropriate labels, reviewers, and projects
6. **Create the pull request** - Submit via GitHub API with all metadata
7. **Report PR URL** - Provide link for immediate review
8. **Deploy execution-evaluator** to verify:
   - PR created successfully with correct target branch
   - Description follows template format
   - All commits included in PR
   - Labels and metadata properly assigned
   - PR accessible via provided URL

## Change Analysis Process

### Comprehensive Diff Analysis

I analyze your changes to understand:

#### Code Changes

- **Added features**: New functionality and capabilities
- **Modified behavior**: Changes to existing functionality
- **Refactoring**: Code improvements without behavior changes
- **Bug fixes**: Issues resolved with references
- **Performance**: Optimizations and improvements

#### Impact Assessment

- **Breaking changes**: API changes, removed features, incompatible updates
- **Database changes**: Schema modifications, migrations needed
- **Configuration changes**: New environment variables, settings
- **Dependency updates**: Package additions, version changes
- **Security implications**: Authentication, authorization, data handling

#### Test Coverage

- **New tests added**: Unit, integration, e2e tests
- **Test modifications**: Updated expectations, new test cases
- **Coverage changes**: Increase or decrease in coverage percentage
- **Test categories**: What types of tests were affected

## PR Description Generation

### Title Generation

I create semantic commit-style titles:

```text
feat: add user authentication with JWT tokens
fix: resolve memory leak in data processor
refactor: simplify database connection logic
chore: update dependencies to latest versions
docs: add API documentation for new endpoints
perf: optimize query performance with indexing
test: add integration tests for payment flow
```

### Description Structure

I generate comprehensive descriptions with:

```markdown
## 📋 Summary
[High-level overview of what this PR accomplishes and why]

## 🎯 Motivation and Context
- **Issue/Ticket**: #123 (if applicable)
- **Problem**: [What problem does this solve?]
- **Solution**: [How does this PR solve it?]
- **Alternative approaches**: [What other solutions were considered?]

## 📝 Changes Made

### Features Added
- ✨ [New feature or capability]
- ✨ [Additional functionality]

### Improvements
- 🔧 [Refactoring or optimization]
- 🎨 [UI/UX improvements]

### Bug Fixes
- 🐛 [Fixed issue with description]
- 🐛 [Resolved problem]

### Technical Details
- [Implementation approach]
- [Architecture decisions]
- [Performance considerations]

## 🧪 Testing

### Test Coverage
- ✅ Unit tests added for [components/functions]
- ✅ Integration tests for [workflows]
- ✅ E2E tests for [user journeys]
- 📊 Coverage: 85% → 92% (+7%)

### Manual Testing
- [ ] Tested locally with development data
- [ ] Tested with production-like data
- [ ] Tested edge cases and error conditions
- [ ] Tested on different browsers/devices (if applicable)

## 🚨 Breaking Changes
⚠️ **This PR contains breaking changes:**
- [Description of breaking change]
- **Migration required**: [Steps to migrate]
- **Affected consumers**: [Who needs to update]

## 📸 Screenshots/Videos
[If UI changes, include before/after screenshots]

## 🔄 Dependencies
- **Blocked by**: PR #456 (if applicable)
- **Blocks**: Issue #789 (if applicable)
- **Related PRs**: #234, #567

## 📚 Documentation
- [ ] README updated
- [ ] API documentation updated
- [ ] Inline comments added for complex logic
- [ ] CHANGELOG updated

## 🗺️ Plan Summary (if generated via /plan)
- Plan reference/ID: [link or identifier]
- ExitPlanMode approval: [link or status]
- Scope agreed: [key steps/tasks]
- Diff-of-intent: [attach or link non-destructive preview]

## ✅ Pre-merge Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Tests pass locally and in CI
- [ ] No console errors or warnings
- [ ] Performance impact assessed
- [ ] Security implications reviewed
- [ ] Documentation updated as needed
- [ ] Breaking changes communicated

## 🔮 Post-merge Actions
- [ ] Deploy to staging environment
- [ ] Run smoke tests
- [ ] Monitor error rates
- [ ] Update related documentation
- [ ] Notify affected teams (if breaking changes)

## 👥 Reviewer Notes
[Specific areas where reviewer attention is needed]
[Questions for reviewers]
[Context that might help review]
```

## Intelligent Label Assignment

I automatically assign labels based on changes:

| Change Type | Labels Applied |
|-------------|---------------|
| New features | `enhancement` |
| Bug fixes | `bug` |
| Documentation | `documentation` |
| Dependencies | `dependencies` |
| Performance | `enhancement` |
| Security fixes | `bug` |
| Breaking changes | `enhancement` |
| Database changes | `dependencies` |
| UI changes | `enhancement` |
| API changes | `enhancement` |
| Test additions | `enhancement` |
| Work in progress | `enhancement` |

## Smart Reviewer Assignment

I assign reviewers based on:

### Code Ownership

- Check CODEOWNERS file for automatic assignments
- Identify primary maintainers of changed files
- Consider recent contributors to affected code

### Expertise Matching

- **Frontend changes**: Assign UI/UX specialists
- **Backend changes**: Assign backend engineers
- **Database changes**: Assign database experts
- **Security changes**: Assign security team members
- **Performance changes**: Assign performance specialists

### Availability Consideration

- Check reviewer's recent PR review load
- Avoid overloading single reviewers
- Distribute reviews across team

### Review Requirements

- Ensure minimum reviewers based on:
  - Breaking changes: 2+ reviewers
  - Security changes: Security team review required
  - Database migrations: DBA review required
  - Public API changes: Architecture review required

## PR Workflow Integration

### Pre-PR Validation

Before creating the PR, I verify:

1. **Branch is up to date** with target branch
2. **/test run executed** with passing results (attach summary). If `--draft` is set, allow creation even if tests fail, but surface results prominently.
3. **No merge conflicts** exist
4. **Commit messages** follow conventions
5. **Required files** are included (tests, docs)

### Post-PR Actions

After creating the PR:

1. **Link related issues** automatically
2. **Add to project board** if configured
3. **Set milestone** based on branch/timing
4. **Request reviews** from appropriate people
5. **Post to Slack/Discord** if webhooks configured
6. **Trigger CI/CD** pipeline

## Conflict Resolution

If conflicts exist, I:

1. **Identify conflicting files** and their nature
2. **Suggest resolution approach** based on changes
3. **Offer to create merge commit** or rebase
4. **Highlight risky conflicts** needing careful review

## PR Templates Support

I respect and use:

- `.github/pull_request_template.md` if present
- Team-specific templates based on PR type
- Organization-wide PR standards
- Custom templates for specific workflows

## Success Metrics

PR quality is measured by:

- **First-time approval rate**: >80%
- **Review turnaround time**: <4 hours
- **Post-merge issues**: <5%
- **Description completeness**: All sections filled
- **Test coverage maintained**: No decrease
- **CI/CD passes**: Before review request

## Error Handling

| Scenario | Action |
|----------|--------|
| No changes to PR | Warn user, suggest checking branch |
| Target branch doesn't exist | List available branches |
| Merge conflicts | Identify conflicts, suggest resolution |
| CI/CD failures | Run /fix-ci first, then retry |
| No reviewers available | Suggest manual assignment |
| Rate limit hit | Wait and retry with backoff |

## Examples

### Feature PR

```bash
/pr
# Creates: "feat: add user dashboard with analytics"
# Assigns: frontend team, UI reviewers
# Labels: enhancement, frontend, feature
```

### Urgent Bug Fix

```bash
/pr main --urgent
# Creates: "fix: critical - resolve payment processing error"
# Assigns: senior engineers, on-call team
# Labels: bug, priority, critical
```

### Draft WIP

```bash
/pr develop --draft
# Creates: "WIP: refactor authentication system"
# Assigns: no reviewers yet
# Labels: draft, wip, refactor
```

## Integration with Other Commands

Works seamlessly with:

- `/commit` - Ensures commits are ready for PR
- `/test` - Validates tests before PR creation
- `/plan` - Uses Plan Preview Mode; requires explicit ExitPlanMode approval before any file writes and before PR creation. The accepted plan summary is embedded in the PR description.
- `/review` - Can trigger review after PR creation
- `/push` - Pushes changes before PR
- `/fix-ci` - Fixes issues before creating PR

## Notes

- Always ensure branch is pushed before creating PR
- PR descriptions should tell a story of why and how
- Good PRs are focused - one concern per PR
- Include screenshots for any UI changes
- Reference issues/tickets for traceability
- Consider breaking large PRs into smaller ones
- Draft PRs are useful for early feedback
