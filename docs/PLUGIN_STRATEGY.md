# Plugin Strategy

This document explains the plugin retention decisions made during the optimization process.

## Summary

| Status | Count | Plugins |
|--------|-------|---------|
| Kept | 5 | frontend-design, agent-sdk-dev, security-guidance, explanatory-output-style, claude-opus-4-5-migration |
| Removed | 4 | code-review, commit-commands, pr-review-toolkit, feature-dev |

## Guiding Principle

**Keep plugins that provide unique capabilities not replicated by custom implementations.**

Plugins should complement, not duplicate, the custom command and agent ecosystem.

## Kept Plugins (5)

### frontend-design

- **Purpose**: Production-grade frontend interface generation
- **Unique Value**: Design quality and creative UI generation
- **No Custom Overlap**: No equivalent agent or command
- **Recommendation**: Use for UI component creation and design system work

### agent-sdk-dev

- **Purpose**: Claude Agent SDK development tooling
- **Unique Value**: Specialized SDK development assistance
- **No Custom Overlap**: Fills specialized development niche
- **Recommendation**: Use when building custom agents with Agent SDK

### security-guidance

- **Purpose**: Security best practices and guidance
- **Unique Value**: Complements security-auditor agent
- **Relationship**: Plugin provides guidance; agent performs audits
- **Recommendation**: Use alongside security-auditor for comprehensive security

### explanatory-output-style

- **Purpose**: Educational output formatting
- **Unique Value**: Insight blocks and learning-focused responses
- **No Custom Overlap**: Output style, not functionality
- **Recommendation**: Keep enabled for educational contexts

### claude-opus-4-5-migration

- **Purpose**: Migration guidance for Opus 4.5
- **Unique Value**: Temporary utility for model migration
- **Lifecycle**: Remove after migration complete
- **Recommendation**: Keep until all prompts migrated to Opus 4.5

## Removed Plugins (4)

### code-review (REMOVED)

- **Reason**: Duplicates `/review` command + `code-reviewer` agent
- **Custom Implementation**: More integrated with project workflows
- **Migration**: Use `/review --full` for comprehensive reviews

### commit-commands (REMOVED)

- **Reason**: Duplicates `/commit` command
- **Custom Implementation**: Integrated with git-workflows skill
- **Migration**: Use `/commit` for all commit operations

### pr-review-toolkit (REMOVED)

- **Reason**: Duplicates `/pr` command
- **Custom Implementation**: Smart title and description generation
- **Migration**: Use `/pr` for pull request creation

### feature-dev (REMOVED)

- **Reason**: Duplicates `/implement` command
- **Custom Implementation**: Wave orchestration with TDD support
- **Migration**: Use `/implement` for feature development

## Decision Framework

When evaluating plugins for retention:

```text
1. Does a custom command/agent provide equivalent functionality?
   YES → Consider removing plugin
   NO  → Keep plugin

2. Does the plugin complement existing implementations?
   YES → Keep plugin (e.g., security-guidance + security-auditor)
   NO  → Remove if redundant

3. Is the plugin a temporary utility?
   YES → Keep with planned removal date
   NO  → Evaluate based on unique value

4. Does keeping both cause confusion about which to use?
   YES → Remove plugin, document migration
   NO  → Keep both if complementary
```

## Plugin vs Custom Implementation Comparison

| Capability | Plugin | Custom | Winner | Reason |
|------------|--------|--------|--------|--------|
| Code Review | code-review | /review + code-reviewer | Custom | Integrated, multi-agent |
| Commits | commit-commands | /commit | Custom | Git-workflows integration |
| PR Creation | pr-review-toolkit | /pr | Custom | Smart generation |
| Feature Dev | feature-dev | /implement | Custom | Wave orchestration |
| Frontend Design | frontend-design | None | Plugin | Unique capability |
| Security | security-guidance | security-auditor | Both | Complementary |

## Future Plugin Evaluation

When considering new plugins:

1. Check for existing command/agent coverage
2. Evaluate unique value proposition
3. Consider integration complexity
4. Document decision in this file

## Maintenance

- Review plugin strategy quarterly
- Remove temporary plugins when no longer needed
- Update this document when plugins are added/removed
