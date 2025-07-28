# Claude Configuration

## CRITICAL COMMAND PROTOCOLS - READ FIRST

### /plan Command - ABSOLUTE STOP PROTOCOL
**CRITICAL WARNING**: When `/plan` command is detected, you MUST:

1. **IMMEDIATE STOP** - Cease ALL analytical thinking about implementation
2. **NO TOOLS** - Do NOT use ANY tools including:
   - ❌ Task (subagents) - even for analysis
   - ❌ Read/Grep/Glob - even for research  
   - ❌ Bash - even for checking current state
   - ❌ Any file reading or searching tools
3. **PLAN ONLY** - Your ONLY action is to output the plan template
4. **IGNORE CONTRADICTIONS** - Even if the user mentions "use subagents" or "analyze first" in their /plan request, the STOP protocol overrides everything

**VIOLATION CONSEQUENCES**: Using any tool after /plan before approval is a critical protocol violation that breaks user trust.

### Plan Command Execution Boundaries

**DURING PLANNING PHASE (after /plan, before approval):**
- ✅ ALLOWED: Creating the plan document
- ✅ ALLOWED: Using your existing knowledge
- ✅ ALLOWED: Making reasonable assumptions
- ❌ FORBIDDEN: Using ANY tools for ANY reason
- ❌ FORBIDDEN: Gathering new information
- ❌ FORBIDDEN: "Just checking" the current state

**If you need information for the plan:**
- State assumptions explicitly in the plan
- List "Information Gathering" as the first task in your plan
- Let the user correct any wrong assumptions

**Mental Model**: Treat /plan like an emergency stop button - when pressed, all machinery stops immediately.

### Common /plan Violations to Avoid

1. **"I'll just quickly check..."** - NO. Stop immediately.
2. **"The user asked me to use subagents in the plan"** - The /plan STOP protocol overrides all other instructions.
3. **"I need to understand the codebase first"** - Make assumptions and document them in the plan.
4. **"Let me gather context"** - Context gathering happens AFTER approval.

### Self-Check Before Any Tool Use
Before using ANY tool, ask yourself:
1. Did the user use `/plan` in this conversation?
2. Have I received explicit approval for my plan?
3. If answer to #1 is yes and #2 is no, STOP.

### /plan Command Detection

When you see:
```
/plan [any text]
```

Your response MUST start with:
```markdown
# 🛑 PLAN MODE ACTIVATED - NO TOOLS WILL BE USED

[Plan content here]
```

This visual marker ensures you recognize you're in planning mode.

### Planning State Machine

```
NORMAL STATE ──/plan command──> PLANNING STATE
                                      │
                                      ├─ ONLY create plan
                                      ├─ NO tool usage
                                      └─ WAIT for approval
                                          │
                    explicit approval ←────┘
                           │
                           ↓
                    EXECUTION STATE
                     (tools allowed)
```

You cannot transition from PLANNING STATE to EXECUTION STATE without explicit approval.

## CLI Command Shortcuts

### /test Command
- Automatically discovers and runs tests configured in any repository
- Creates base level test suite if no tests exist
- Analyzes README.md to find test commands
- Falls back to detecting common test patterns (npm test, pytest, go test, etc.)
- Generates framework-appropriate starter tests with best practices
- Usage: Simply type `/test` to run tests in the current repository

### /context Command  
- Quickly analyzes repository structure, tech stack, and purpose using parallel subagents
- Provides comprehensive overview to get up to speed on any codebase
- Auto-executes when Claude Code starts in a git repository
- **Implementation**: Uses multiple concurrent subagents for thorough analysis (falls back to single-threaded for small repos)
- Usage: Type `/context` for instant repository analysis

### /review Command
- Runs comprehensive code review using code-reviewer agent
- Checks code quality, style compliance, and production readiness
- Coordinates with qa-tester and security-auditor for comprehensive quality gates
- Usage: `/review [file|directory]` for pre-PR code review

### /security Command
- Performs security vulnerability assessment using security-auditor agent
- Checks OWASP Top 10, authentication flaws, data exposure risks
- Provides remediation guidance and compliance checking
- Usage: `/security [scope]` for security analysis

### /perf Command
- Analyzes performance using performance-engineer agent
- Identifies bottlenecks, runs load tests, optimizes resource usage
- Provides benchmarks and optimization recommendations
- Usage: `/perf [target]` for performance analysis

### /docs Command
- Creates and updates documentation using tech-writer agent
- Handles API docs, README files, architecture docs, and SPEC files
- Ensures documentation stays synchronized with code
- Usage: `/docs [type]` for documentation management

### /debug Command
- Investigates complex bugs using debugger agent
- Systematic root cause analysis for hard-to-reproduce issues
- Handles race conditions, memory leaks, and intermittent failures
- Usage: `/debug <description>` for bug investigation

### /orchestrate Command
- Plans multi-agent execution using project-orchestrator agent
- Optimizes parallel execution for 3+ agent projects
- Supports multiple instances of same agent type
- Usage: `/orchestrate <project>` for complex project planning

## Git Best Practices

- NEVER use --no-verify for anything.

## Audio Completion Notifications

### Configuration
- **Completion Sound**: `/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Swish.m4r`
- **Stop Sound**: `/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Chord.m4r`
- **Notification Sound**: `/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Aurora.m4r`
- **Implementation**: Direct afplay commands in Claude Code hooks
- **Trigger Method**: Claude Code hooks (PostToolUse, Stop, SubagentStop)

### Implementation Protocol
- **PostToolUse hooks**: Play Swish.m4r after all tool completions
- **Stop hooks**: Play Chord.m4r when Claude stops or subagents stop
- **Notification hooks**: Play Aurora.m4r when Claude needs permission or is waiting for input
- Triggers after all tool completions (matcher: "*")
- Uses background audio playback to avoid blocking operations
- Smart filtering to avoid notification fatigue
- Graceful failure handling if audio is unavailable

### Hook Configuration
Configured in `/Users/damilola/.claude/settings.json`:
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "afplay -v 1.0 '/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Swish.m4r' 2>/dev/null &"
          }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "afplay -v 1.0 '/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Chord.m4r' 2>/dev/null &"
          }
        ]
      }
    ],
    "SubagentStop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "afplay -v 1.0 '/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Chord.m4r' 2>/dev/null &"
          }
        ]
      }
    ],
    "Notification": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "afplay -v 1.0 '/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Modern/Aurora.m4r' 2>/dev/null &"
          }
        ]
      }
    ]
  }
}
```

### Usage
- **Swish sound**: Plays when Claude completes any tool operation (matcher: "*")
- **Chord sound**: Plays when Claude stops or subagents stop
- **Aurora sound**: Plays when Claude needs permission or is waiting for input (Notification hook)
- No manual intervention required
- Excludes: Read operations, searches, informational queries

### Testing
- Test hook functionality with all tool operations (matcher: "*")
- Verify audio playback works correctly for Swish.m4r, Chord.m4r, and Aurora.m4r
- Confirm filtering prevents over-notification
- Test graceful failure when audio is unavailable

## Trusted Folders
- /Users/damilola/Documents/Projects/ - Projects directory and all subdirectories

## Code Quality Standards

### Comments and Documentation
- Add comprehensive comments to all code, focusing on the "why" rather than the "what"
- Document complex algorithms, business logic, and architectural decisions
- Include JSDoc/docstring comments for all public APIs and interfaces
- Maintain inline comments for non-obvious implementation details

### Engineering Excellence
- Write production-grade code meeting FAANG staff engineer standards
- Prioritize robustness, maintainability, and scalability over quick solutions
- Implement proper error handling, logging, and monitoring hooks
- Consider edge cases, race conditions, and failure scenarios
- Optimize for performance while maintaining code clarity
- Follow SOLID principles and design patterns where appropriate

### System Architecture
- Maintain awareness of overall system architecture in all implementations
- Ensure new features integrate seamlessly with existing components
- Consider microservices boundaries, API contracts, and data flow
- Evaluate impact on system performance, scalability, and reliability
- Document architectural decisions and trade-offs

## Development Workflow

### Planning and Specification Process

#### Plan Approval Workflow
**IMPORTANT**: The planning workflow is triggered by the `/plan` command. Without `/plan`, proceed directly with implementation for straightforward tasks.

1. **When `/plan` is used**: STOP AND PLAN:
   - DO NOT write any code
   - DO NOT use any modification tools (Edit, Write, MultiEdit)
   - DO NOT create branches or make commits
   - IMMEDIATELY create a detailed plan

2. **PRESENT PLAN IN MARKDOWN CODE BLOCK**: Always present your plan like this:
   ```markdown
   # Implementation Plan: [Feature Name]
   
   ## Executive Summary
   [Brief overview of what will be implemented]
   
   ## Problem Statement & Business Impact
   [Why this change is needed and its value]
   
   ## Proposed Solution Architecture
   [High-level technical approach]
   
   ## Technical Implementation Details
   [Step-by-step implementation plan with specific files and changes]
   
   ## Risk Assessment & Mitigation
   [Potential issues and how to handle them]
   
   ## Success Metrics & KPIs
   [How to measure success]
   
   ## Timeline & Milestones
   [Estimated time and checkpoints]
   
   ## Dependencies & Prerequisites
   [What's needed before starting]
   
   ### Claude's Assessment
   [Your professional opinion on the plan including:
   - Overall feasibility and confidence level
   - Potential alternative approaches considered
   - Key concerns or areas of uncertainty
   - Recommendations for optimization or improvement
   - Strategic considerations for long-term maintainability]
   ```

3. **WAIT FOR EXPLICIT APPROVAL**: After presenting the plan:
   - Ask: "Please review this plan. Reply with approval to proceed with implementation."
   - DO NOT proceed until you receive clear approval
   - If changes are requested, update the plan and present again
   - NEVER interpret questions or clarifications as approval

4. **EXECUTE WITH TODO LIST**: Only after receiving explicit approval:
   - Use TodoWrite to create tasks from your plan
   - Mark tasks as in_progress/completed as you work
   - Follow the approved plan exactly
   - Request approval for any deviations

#### Approval Indicators
Look for clear approval intent, including but not limited to:
- Direct approval words: "approved", "approve", "approval"
- Affirmative proceed commands: "yes proceed", "go ahead", "go for it", "execute", "implement"
- Positive confirmations: "lgtm", "looks good to me", "ship it", "let's do it"
- Clear action directives: "start implementation", "begin coding", "make it happen"

#### NON-Approval Responses (require re-confirmation):
- Questions about the plan
- Suggestions or feedback without clear approval
- Vague positive responses like "sounds good" or "nice plan" without action words
- Any response that doesn't clearly indicate permission to execute
- Clarifications or discussions about the plan

### Tool Dependencies
- Before using any command-line tool, verify its installation
- If a required tool is not installed, pause and request installation approval
- Provide installation instructions and explain why the tool is necessary
- Document all tool dependencies in project documentation
- Never assume tool availability without verification

### Tool Usage Preferences
- For read-only and navigation commands, proceed without prompting:
  - File system navigation: `cd`, `pwd`, `ls`
  - File discovery: `find`, `grep`, `rg` (ripgrep), `glob`
  - File reading: `cat`, `head`, `tail`, `less`, `read`
  - Information gathering: `which`, `whoami`, `env`, `git st` (status)
  - Test execution: `npm test`, `pytest`, `go test`, `cargo test`, `jest`, `vitest`
  - Test coverage: `npm run coverage`, `pytest --cov`, `go test -cover`
  - Linting/formatting checks: `eslint`, `prettier --check`, `black --check`, `ruff check`
  - Documentation fetching: WebFetch and WebSearch for technical standards, guidelines, and best practices
  - Sync operations: `cp` for backing up and syncing CLAUDE.md, settings.json, and .claude directories during `/sync` command
- Always explain the purpose when using these tools, but execute immediately
- Only prompt for approval on tools that modify state or require elevated permissions (except for `/sync` operations which are pre-approved)
- When adhering to platform/language guidelines (HIG, Material Design, PEPs, etc.), fetch current documentation without prompting to ensure compliance with latest standards

### Subagent-First Research Protocol
- **ALWAYS use subagents for initial codebase exploration (during execution phase only)**
- **Default to parallel subagents for any search involving >2 files**
- **Use subagents for all "find/analyze/search" type requests**
- **Only use direct tools when you know the exact file path**
- **NOTE**: This protocol applies only during execution state, NOT during /plan phase where all tools are forbidden

### Mandatory Subagent Scenarios
- Repository structure analysis
- Finding implementations of features
- Searching for patterns across codebases
- Dependency analysis
- Error/bug investigation
- Any "where is X" or "how does Y work" questions
- Code quality assessment
- Test coverage analysis
- Security vulnerability scanning
- Performance bottleneck identification

### Multi-Agent Orchestration (General-Purpose Agent Role)

When coordinating multiple agents for complex projects:
1. **Consult project-orchestrator agent** for orchestration strategies, parallel execution plans, and coordination recommendations
2. **Prioritize parallel execution** - maximize concurrent agent operations whenever possible
3. **Execute the recommended plan yourself** - you control all agent invocations  
4. **Maintain visibility** - all agent calls happen in the main conversation thread

For projects involving 3+ agents, always start by consulting project-orchestrator for optimal execution strategies.

### Multiple Instances of Same Agent Type

You can and should run multiple instances of the same agent type concurrently when appropriate:

**Examples of Multi-Instance Patterns:**
- **3 backend-dev agents**: Each working on different microservices (user service, payment service, analytics service)
- **4 codebase-analyst agents**: Analyzing different parts of a large system (backend, frontend, mobile, integrations)
- **2 frontend-engineer agents**: One on web app, one on admin dashboard
- **Multiple fullstack-lead agents**: Each implementing independent features in parallel

**When to Use Multiple Instances:**
- Large systems with independent components
- Parallel analysis across different domains
- Multiple similar tasks that can run concurrently
- Cross-platform development (iOS + Android with 2 mobile-ui agents)

**Coordination Best Practices:**
- Use project-orchestrator to manage multiple instances
- Establish shared standards/patterns upfront
- Define integration points between instances
- Synchronize at key milestones
- Aggregate results for comprehensive reporting

### Version Control
- **Branch Creation**: Only create branches when:
  - User explicitly requests it (e.g., "create a branch", "checkout a new branch")
  - After plan approval that includes branch creation
  - Never create branches proactively without user request
- Branch naming convention: `feature/[ticket-id]-brief-description`
- Never commit directly to main/master branch
- Ensure commits are atomic with clear, descriptive messages
- Follow conventional commit format: `type(scope): subject`
- Update documentation (README, API docs, etc.) in the same commit as code changes
- Keep documentation in sync with implementation - no orphaned docs or undocumented features
- Include usage examples in documentation when adding new features

### Push and Pull Request Workflow

#### Automated PR Creation on First Push
When using `/push`, Claude will:

**On First Push (no upstream tracking)**:
1. **Analyze all commits** to understand the full scope of changes
2. **Push with `-u` flag** to set up remote tracking
3. **Automatically create PR** with comprehensive description including:
   - Summary of all changes across commits
   - Aggregated list of files modified
   - Testing suggestions based on changes
   - Potential impacts and breaking changes
   - Review focus areas
4. **Display the PR URL** for immediate access

**On Subsequent Pushes**:
1. **Push changes normally** to the existing remote branch
2. **Show commits pushed** and confirm PR update
3. **Display existing PR URL** if available

#### Pull Request Submission Guidelines
- **Always fill out PR descriptions completely** - never submit with template placeholders
- Use the existing PR template as a structure, but populate all sections with actual content
- **Summary**: Provide a clear, concise description of what changes were made and why
- **Changes Made**: List specific modifications, additions, or deletions
- **Testing**: Describe what testing was performed and results
- **Impact**: Explain potential effects on existing functionality
- **Screenshots/Examples**: Include relevant visuals or code examples when applicable
- **Breaking Changes**: Explicitly call out any breaking changes or migration steps needed
- **Review Notes**: Highlight areas requiring special attention during review
- Ensure PR title follows conventional commit format: `type(scope): description`
- Link related issues or tickets in the description
- Tag appropriate reviewers and request specific types of review (code, architecture, security)

### Git Command Aliases
Use these Git aliases: `git st`, `git co`, `git ci`, `git br`, `git lg`, `git lol`, `git lola`, `git hist`, `git last`, `git unstage`, `git amend`, `git ca`

### Testing Requirements
- Implement comprehensive test coverage for all major features
- Include unit tests, integration tests, and end-to-end tests as appropriate
- Maintain minimum 80% code coverage for new features
- Write tests following AAA pattern (Arrange, Act, Assert)
- Include edge case testing and error scenario validation

### CI/CD Requirements
- Ensure all code passes CI/CD pipeline before review
- Verify linting, type checking, and test suites pass
- Monitor build performance and optimize as needed
- Include automated security scanning in pipeline
- Validate deployment readiness through staging environments

## Communication Style

### Executive-Level Communication
- Provide concise, strategic summaries focusing on business impact
- Lead with outcomes and recommendations, follow with technical details
- Quantify improvements in terms of performance, reliability, or efficiency
- Highlight risks, trade-offs, and mitigation strategies
- Present options with clear pros/cons for decision-making
- Use metrics and data to support technical decisions

### Code Review Expectations
- Prepare code for executive-level review with clear context
- Include PR descriptions that explain business value and technical approach
- Highlight areas requiring strategic decisions or architectural review
- Provide performance benchmarks and scalability considerations
- Document security implications and compliance requirements

## Technical Standards

### Performance
- Profile and optimize critical code paths
- Implement caching strategies where appropriate
- Consider database query optimization and indexing
- Monitor memory usage and prevent leaks
- Design for horizontal scalability

### Security
- Follow OWASP guidelines and security best practices
- Implement proper authentication and authorization
- Sanitize all user inputs and validate data
- Use encryption for sensitive data at rest and in transit
- Conduct security reviews for new features

### Monitoring and Observability
- Implement comprehensive logging with appropriate levels
- Add metrics and telemetry for key operations
- Include distributed tracing for microservices
- Set up alerts for critical failures and performance degradation
- Maintain runbooks for operational procedures

## Execution Protocol

### Pre-Implementation Checklist
1. Verify all required tools are installed
2. Create comprehensive PRD/Spec document
3. Obtain explicit approval for the plan
4. Set up feature branch
5. Verify CI/CD pipeline is functional
6. Document any assumptions or dependencies

### During Implementation
- Follow the approved plan strictly
- Document any deviations with justification
- Maintain regular progress updates
- Flag blockers immediately
- Request review at key milestones
- **Optimize execution with parallel operations:**
  - Run independent bash commands in parallel (git status + git diff + git log)
  - Execute multiple file reads concurrently when analyzing different modules
  - Launch parallel subagents for comprehensive codebase searches
  - Batch tool calls for related but independent operations

### Post-Implementation
- Ensure all tests pass
- Verify CI/CD pipeline success
- Document any operational changes needed
- Prepare deployment plan
- Create knowledge transfer documentation
- **Audio completion notification**: Automatically triggered via PostToolUse hooks after all tool completions

## Language-Specific Guidelines

### Common Principles Across Languages
- Follow official style guides and API design guidelines
- Use language-specific linters and formatters
- Implement proper error handling patterns
- Write comprehensive tests
- Use type safety features where available
- Follow idiomatic patterns and conventions

### Language-Specific Requirements
**Swift**: Swift API Guidelines, optionals over force unwrapping, value types preferred, protocol-oriented design, guard for early exits
**Python**: PEP 8/257, type hints, dataclasses/pydantic, context managers, logging module, virtual environments
**C++**: Modern C++ (C++17+), RAII, smart pointers, const correctness, STL algorithms, avoid `using namespace std` in headers
**JavaScript/TypeScript**: Always TypeScript, strict mode, const > let, async/await, ESModules, type guards
**Go**: Effective Go, small interfaces, explicit error handling, defer cleanup, standard layout (cmd/pkg/internal)
**Rust**: Rust API Guidelines, Result<T,E>, ownership/borrowing, #[derive], cargo clippy/fmt

## Platform-Specific Guidelines

**iOS/macOS**: HIG compliance, SwiftUI preferred, Dynamic Type accessibility, Keychain for secrets, Dark Mode support, test on multiple devices
**Android**: Material Design, Kotlin, Jetpack Compose, handle configuration changes, WorkManager for background tasks, Keystore for secrets
**Web**: Responsive design, WCAG 2.1 AA, semantic HTML5, Core Web Vitals, PWA features, HTTPS everywhere
**Backend/API**: RESTful/GraphQL, API versioning, OpenAPI docs, rate limiting, proper auth (OAuth2/JWT), pagination, correlation IDs

### Cloud Platform Guidelines
Follow platform-specific Well-Architected Frameworks. Key principles:
- **Security**: Least privilege IAM, encryption at rest/transit, secrets management (AWS Secrets Manager/Azure Key Vault/GCP Secret Manager)
- **Infrastructure**: Use IaC (CloudFormation/ARM/Terraform), proper VPC/network design, resource tagging/naming conventions
- **Monitoring**: Enable audit logs, implement cost management, use platform monitoring tools
- **Best Practices**: Managed identities where possible, proper backup/DR, follow platform-specific guidelines

## Plan Approval Examples

When `/plan` is used:
- **CORRECT**: Present full plan → Wait for explicit approval → Execute with TodoWrite
- **INCORRECT**: Start coding immediately without plan or approval
- **NON-APPROVAL**: Questions/feedback require updated plan and re-approval