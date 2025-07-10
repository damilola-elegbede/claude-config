# Claude Configuration

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
- Always explain the purpose when using these tools, but execute immediately
- Only prompt for approval on tools that modify state or require elevated permissions
- When adhering to platform/language guidelines (HIG, Material Design, PEPs, etc.), fetch current documentation without prompting to ensure compliance with latest standards

### Parallel Execution with Subagents
- **ALWAYS use the Task tool (subagents) for parallel operations when:**
  - Searching for files or patterns across multiple directories
  - Analyzing code structure in large codebases
  - Gathering information from multiple sources simultaneously
  - Performing independent analysis tasks that can run concurrently
- **Launch multiple subagents concurrently for maximum performance:**
  - Use a single message with multiple Task tool invocations
  - Each subagent should have a focused, autonomous task
  - Provide detailed instructions since subagents are stateless
- **Effective subagent usage patterns:**
  - File search: "Find all files containing pattern X in directories A, B, C"
  - Code analysis: "Analyze error handling in module X" + "Check test coverage for module Y"
  - Documentation: "Extract API signatures from service A" + "List dependencies in service B"
- **When NOT to use subagents:**
  - Simple file reads with known paths (use Read tool directly)
  - Sequential operations that depend on previous results
  - Tasks requiring state maintenance between operations

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

### Pull Request Submission Guidelines
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
Use these Git aliases for common operations:
- `git st` - Show status
- `git co` - Checkout branches
- `git ci` - Commit changes
- `git br` - Branch operations
- `git lg` - View log with graph (all branches)
- `git lol` - View log with graph (current branch)
- `git lola` - View log with graph (all branches)
- `git hist` - View formatted history
- `git last` - Show last commit
- `git unstage` - Unstage files
- `git amend` - Amend last commit
- `git ca` - Commit amend (shorthand)

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

## Language-Specific Guidelines

### Swift
- Follow Swift API Design Guidelines (https://swift.org/documentation/api-design-guidelines/)
- Use optionals appropriately - avoid force unwrapping unless absolutely certain
- Prefer value types (structs) over reference types (classes) when possible
- Use protocol-oriented programming where it improves code flexibility
- Follow naming conventions: lowerCamelCase for variables/functions, UpperCamelCase for types
- Use `guard` statements for early exits and unwrapping optionals
- Implement proper error handling with `Result` types or throwing functions
- Use `@available` annotations for API availability
- Prefer composition over inheritance
- Use extensions to organize code logically

### Python
- Follow PEP 8 style guide for code formatting
- Use type hints for all function signatures (Python 3.5+)
- Follow PEP 257 for docstring conventions
- Use `dataclasses` or `pydantic` for data structures
- Prefer list comprehensions and generator expressions where readable
- Use context managers (`with` statements) for resource management
- Implement proper exception handling with specific exception types
- Use `logging` module instead of print statements
- Follow the Zen of Python principles (`import this`)
- Use virtual environments for dependency management

### C++
- Follow modern C++ standards (C++17 or later preferred)
- Use RAII (Resource Acquisition Is Initialization) for resource management
- Prefer smart pointers over raw pointers
- Use `const` correctness throughout
- Follow the Rule of Five for classes managing resources
- Use STL algorithms over manual loops where possible
- Implement move semantics for performance
- Use `constexpr` for compile-time computations
- Avoid using `using namespace std;` in headers
- Use forward declarations to minimize compilation dependencies

### JavaScript/TypeScript
- Always use TypeScript for new projects
- Use strict mode and enable all strict compiler options
- Prefer `const` over `let`, avoid `var`
- Use arrow functions for callbacks and short functions
- Implement proper async/await error handling
- Use optional chaining and nullish coalescing
- Follow functional programming principles where appropriate
- Use ESModules over CommonJS for new code
- Implement proper type guards for runtime type checking
- Use branded types for domain modeling

### Go
- Follow Effective Go guidelines
- Keep interfaces small and focused
- Use channels for communication between goroutines
- Handle all errors explicitly - no silent failures
- Use defer for cleanup operations
- Keep package names short and lowercase
- Use table-driven tests for comprehensive testing
- Implement context.Context for cancellation and timeouts
- Follow standard project layout (cmd/, pkg/, internal/)
- Use go fmt, go vet, and golangci-lint

### Rust
- Follow Rust API Guidelines
- Use `Result<T, E>` for recoverable errors
- Implement the builder pattern for complex structs
- Use iterators instead of loops where possible
- Follow ownership and borrowing rules strictly
- Use `#[derive()]` for common traits
- Implement `From` and `Into` for type conversions
- Use feature flags for optional dependencies
- Document unsafe code blocks thoroughly
- Use cargo clippy and cargo fmt

## Platform-Specific Guidelines

### iOS/macOS Development
- Follow Human Interface Guidelines (HIG) strictly
- Use SwiftUI for new UI development, UIKit for legacy support
- Implement proper state management (Combine, async/await)
- Support Dynamic Type for accessibility
- Handle all device orientations and sizes appropriately
- Use Keychain for sensitive data storage
- Implement proper background task handling
- Support Dark Mode and High Contrast
- Use SF Symbols for consistent iconography
- Test on multiple device sizes and iOS versions

### Android Development
- Follow Material Design guidelines
- Use Kotlin as primary language
- Implement MVVM or MVI architecture patterns
- Use Jetpack Compose for new UI development
- Support multiple screen densities and sizes
- Handle configuration changes properly
- Use WorkManager for background tasks
- Implement proper lifecycle management
- Support both light and dark themes
- Use Android Keystore for sensitive data

### Web Development
- Ensure responsive design for all screen sizes
- Follow WCAG 2.1 AA accessibility standards
- Implement Progressive Web App (PWA) features where appropriate
- Use semantic HTML5 elements
- Optimize for Core Web Vitals
- Implement proper SEO meta tags
- Use lazy loading for images and heavy resources
- Support offline functionality with service workers
- Implement proper CORS handling
- Use HTTPS everywhere

### Backend/API Development
- Follow RESTful principles or GraphQL best practices
- Implement proper API versioning
- Use OpenAPI/Swagger for documentation
- Implement rate limiting and throttling
- Use proper HTTP status codes
- Implement comprehensive error responses
- Support pagination for large datasets
- Use proper authentication (OAuth2, JWT)
- Implement request/response validation
- Use correlation IDs for request tracking

### Cloud Platform Guidelines

#### AWS
- Follow Well-Architected Framework principles
- Use IAM roles and policies with least privilege
- Implement proper tagging strategy
- Use CloudFormation or CDK for infrastructure as code
- Enable CloudTrail for audit logging
- Implement cost optimization strategies
- Use appropriate storage classes for S3
- Implement proper VPC design with security groups
- Use Parameter Store or Secrets Manager for secrets
- Enable encryption at rest and in transit

#### Azure
- Follow Azure Well-Architected Framework
- Use Azure AD for authentication
- Implement proper resource groups and tagging
- Use ARM templates or Bicep for IaC
- Enable Azure Monitor and Application Insights
- Implement proper network security groups
- Use Key Vault for secrets management
- Follow naming conventions for resources
- Implement proper backup and disaster recovery
- Use managed identities where possible

#### Google Cloud Platform
- Follow Google Cloud Architecture Framework
- Use IAM with principle of least privilege
- Implement proper project and folder organization
- Use Deployment Manager or Terraform for IaC
- Enable Cloud Audit Logs
- Use Cloud KMS for encryption key management
- Implement proper VPC design with firewall rules
- Use Secret Manager for sensitive data
- Follow resource naming conventions
- Implement cost management with budgets and alerts

## Plan Approval Examples

### CORRECT Workflow Example:
```
User: Add a dark mode toggle to the settings page

Claude: I'll help you add a dark mode toggle to the settings page. Let me create a detailed implementation plan for your review.

```markdown
# Implementation Plan: Dark Mode Toggle

## Executive Summary
Add a user-configurable dark mode toggle to the application settings page that persists user preference and applies theme across the entire application.

## Problem Statement & Business Impact
Users need the ability to switch between light and dark themes for better accessibility and reduced eye strain. This improves user experience and extends usage time, particularly in low-light environments.

## Proposed Solution Architecture
- Add toggle component to Settings page
- Implement theme context provider for global state management
- Store preference in localStorage for persistence
- Apply theme classes using CSS variables for consistent styling

## Technical Implementation Details
1. Create ThemeContext in /contexts/ThemeContext.tsx
2. Add DarkModeToggle component in /components/settings/DarkModeToggle.tsx
3. Update Settings page to include toggle
4. Modify root CSS to support theme variables
5. Update all components to use theme-aware styling

## Risk Assessment & Mitigation
- Risk: Existing components may have hardcoded colors
- Mitigation: Audit all components for color usage before implementation

## Success Metrics & KPIs
- Toggle successfully switches theme
- Preference persists across sessions
- All UI elements properly themed

## Timeline & Milestones
- Estimated: 2-3 hours
- Milestone 1: Theme context and toggle component (1 hour)
- Milestone 2: CSS variable implementation (1 hour)
- Milestone 3: Testing and refinement (30-60 min)

## Dependencies & Prerequisites
- React Context API
- CSS variable support
- localStorage access
```

Please review this plan. Reply with approval to proceed with implementation.

User: looks good, go ahead

Claude: Thank you for the approval! I'll now proceed with implementing the dark mode toggle using the TodoWrite tool to track progress.

[Creates todos and begins implementation]
```

### INCORRECT Workflow Example (What NOT to do):
```
User: Add a dark mode toggle to the settings page

Claude: I'll add a dark mode toggle to your settings page. Let me start by creating the theme context...

[WRONG: Immediately starts coding without presenting plan or getting approval]
```

### Example of NON-Approval Response:
```
User: Add a dark mode toggle to the settings page

Claude: [Presents detailed plan]

User: What about mobile responsiveness?

Claude: Good question about mobile responsiveness. Let me update the plan to address that concern:

[Updates plan with mobile considerations]

Please review the updated plan. Reply with approval to proceed with implementation.

[CORRECT: Recognizes question as feedback, not approval]
```

## Critical Reminders
- **When `/plan` is used**: Create a detailed PRD/Spec plan BEFORE writing any code
- **When `/plan` is used**: Present plans in markdown code blocks for clarity
- **When `/plan` is used**: Wait for explicit approval before ANY implementation
- **Branch Creation**: Only create branches when explicitly requested by user
- **NEVER proceed based on ambiguous responses**
- Do what has been asked; nothing more, nothing less
- NEVER create files unless they're absolutely necessary for achieving your goal
- ALWAYS prefer editing an existing file to creating a new one
- NEVER proactively create documentation files (*.md) or README files unless explicitly requested