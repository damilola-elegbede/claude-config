# /pr Command

## Description
Creates intelligent pull requests with comprehensive descriptions, impact analysis, and test plans. Automatically analyzes changes across multiple commits, generates meaningful PR titles and descriptions, and ensures all context is preserved for reviewers.

## Usage
```
/pr [target_branch]
```

## Arguments
- `target_branch` (optional): Target branch for the PR. Defaults to main/master.

## Behavior
When you use `/pr`, I will:

1. **Analyze all changes** since branch diverged:
   - Run git diff against target branch
   - Review all commits in the branch
   - Identify modified files and impact scope
   - Detect breaking changes or API modifications

2. **Generate intelligent PR content**:
   - **Title**: Concise summary following conventional commits
   - **Description**: Comprehensive change overview
   - **Breaking Changes**: Highlighted if present
   - **Testing**: Specific test scenarios
   - **Screenshots**: Prompt for UI changes
   - **Dependencies**: Note any new packages

3. **Coordinate quality checks**:
   - Ensure all tests pass
   - Verify no lint errors
   - Check for security vulnerabilities
   - Validate performance impact

4. **Create PR with rich metadata**:
   - Appropriate labels (feature, bug, docs, etc.)
   - Milestone assignment if applicable
   - Reviewer suggestions based on code ownership
   - Related issue linking

## PR Description Format
```markdown
## Summary
Brief overview of changes and motivation

## Changes
- Specific change 1 with context
- Specific change 2 with impact
- Additional modifications

## Breaking Changes
⚠️ Any breaking changes listed here

## Testing
- [ ] Unit tests for new functionality
- [ ] Integration tests for API changes
- [ ] Manual testing scenarios
- [ ] Performance benchmarks if applicable

## Screenshots/Demo
(For UI changes)

## Dependencies
- New packages added
- Version updates

## Checklist
- [ ] Tests pass locally
- [ ] Documentation updated
- [ ] No console errors
- [ ] Follows code style guidelines
```

## Examples
```bash
# Create PR to main branch
/pr

# Create PR to specific branch
/pr develop

# Create PR for hotfix
/pr release/v2.0
```

## Advanced Features

### Multi-Repository PRs
For changes spanning multiple repos:
- Identifies cross-repo dependencies
- Creates linked PRs
- Ensures coordinated merging

### PR Templates
Respects repository PR templates while enhancing with:
- Automated change detection
- Impact analysis
- Test coverage reports

### Smart Labels
Automatically applies labels based on:
- File paths (docs/, src/, tests/)
- Change types (feat, fix, chore)
- Impact scope (breaking, enhancement)

## Integration with Other Commands
- Run `/review` before creating PR
- Use `/test` to ensure all tests pass
- Apply `/security` for security-sensitive changes

## Git Workflow
```bash
# Typical workflow
git checkout -b feature/new-feature
# Make changes
/test
/review
/pr main
```

## Configuration
Respects repository settings:
- `.github/pull_request_template.md`
- CODEOWNERS file
- Branch protection rules
- Required status checks

## Quality Standards
PRs created with this command will:
- Have comprehensive descriptions
- Include test plans
- Link related issues
- Follow repository conventions
- Highlight risks and impacts

## Notes
- Works with GitHub, GitLab, Bitbucket
- Preserves commit history
- Supports draft PRs for WIP
- Handles fork-based workflows