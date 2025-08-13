# /pr Command

## Description
Creates pull requests with intelligent analysis of your changes and generates comprehensive PR descriptions automatically.

## Usage
```
/pr [target_branch]
```

## What It Does
1. **Analyzes your changes**: Diffs against target branch to understand scope and impact
2. **Generates smart PR content**: Creates title, description, and identifies breaking changes
3. **Creates the PR**: Opens with proper labels and reviewer suggestions

## PR Description Generated
```markdown
## Summary
[Automatically generated based on your changes]

## Changes
- [Specific files and modifications detected]
- [Breaking changes highlighted if present]

## Testing
- [ ] Tests added/updated for new functionality
- [ ] All existing tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Documentation updated if needed
- [ ] No console errors introduced
```

## Examples
```bash
/pr                    # Create PR to main
/pr develop           # Create PR to develop branch
```

## Value
- **Saves 10+ minutes** per PR on description writing
- **Catches breaking changes** automatically
- **Suggests appropriate reviewers** based on file changes
- **Consistent PR format** across team

## Requirements
- Current branch has commits ahead of target
- GitHub CLI installed (`gh` command)