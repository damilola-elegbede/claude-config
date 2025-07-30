# /analyze Command

## Description
Quickly access codebase analysis expertise through Claude orchestration for internal code analysis, architecture assessment, and technical reporting. Claude will coordinate with the codebase-analyst specialist for comprehensive analysis of existing codebases.

## Usage
```
/analyze [scope or component]
```

## Behavior
This command coordinates with the codebase-analyst specialist to perform comprehensive code analysis. Claude orchestrates the analysis process by:
- Identifying the scope and components to analyze
- Invoking the codebase-analyst with appropriate parameters
- Aggregating findings into actionable insights
- Providing executive-level summaries when requested

## Examples
- `/analyze authentication service`
- `/analyze frontend architecture`
- `/analyze technical debt`
- `/analyze performance bottlenecks`

## Capabilities
The codebase-analyst specialist (coordinated through Claude) excels at:
- Architecture assessment
- Technical debt analysis
- Code quality evaluation
- Dependency analysis
- Security vulnerability scanning
- Performance profiling
- Executive reporting

## When to Use
- Understanding existing code
- Technical debt assessment
- Architecture documentation
- Code quality analysis
- Pre-refactoring analysis
- Executive summaries

## Related Commands
- `/context` - For repository overview
- `/debug` - For specific issues
- `/security` - For security analysis
