# /plan Command

## Description

Enters plan mode to generate comprehensive strategic requirements and tactical
implementation plans. Presents a preview for approval before writing any files.
Creates a roadmap of small, focused PRs that can be developed in parallel when
possible, with each PR independently reviewable and following TDD methodology.

## Usage

```bash
/plan <task_description>
/plan simple <task_description>  # For tasks <100 LOC
/plan --file <file_path>         # Read task from file
/plan -f <file_path>             # Read task from file (short form)
/plan simple --file <file_path>  # Simple mode with file input
/plan simple -f <file_path>      # Simple mode with file input (short form)
```

## Command Execution Flow

### Plan Mode Entry

When you invoke `/plan`, I will:

1. **Enter plan mode** immediately to begin strategic planning
2. **Read file if provided** with --file or -f flag, otherwise use provided description
3. **Analyze task complexity** from file content or description
4. **Deploy project-orchestrator** to:
   - Analyze project requirements and identify required agents
   - Design optimal execution phases with parallelization
   - Map tasks to specialized agents based on capabilities
   - Identify critical path and dependencies
   - Provide resource optimization strategies
5. **Generate a complete plan** incorporating orchestrator's recommendations
6. **Present a preview** for your review and approval showing:
   - Orchestrator's agent assignments
   - Parallel execution opportunities
   - Phase breakdown with timing estimates
7. **Stay in plan mode** while waiting for your decision
8. **Exit plan mode** ONLY after you approve using ExitPlanMode tool
9. **Write files only if approved** - no files created until you confirm
10. **Deploy execution-evaluator** to verify:
    - Plan generated successfully
    - Agent assignments are optimal
    - PR breakdown logical and independent
    - Files written match approved plan
    - No unauthorized files created

### File Input Processing

When using `--file <file_path>` or `-f <file_path>`:

1. **Read the entire file** using the Read tool
2. **Extract requirements** from the file content
3. **Parse structured formats** (Markdown, YAML, JSON, plain text)
4. **Identify task objectives** from:
   - User stories or requirements lists
   - Technical specifications
   - Bug reports or issue descriptions
   - Feature requests
   - Architecture documents
5. **Generate plan** based solely on file content
6. **Ignore conversation context** when --file or -f is used (file is the sole source)

**Supported File Formats**:

- `.md` - Markdown specifications
- `.txt` - Plain text requirements
- `.yaml`/`.yml` - Structured task definitions
- `.json` - JSON task specifications
- `.rst` - reStructuredText documents
- Any text-based format with clear requirements

### Complexity Assessment

I determine complexity based on task indicators and estimated lines of code:

- **Simple** (<100 LOC): Single PR, minimal orchestration
  - Keywords: button, typo, color, text change, label, tooltip
  - Example: "Fix login button text"

- **Medium** (100-1000 LOC): 2-3 phases, 4-7 PRs
  - Keywords: feature, endpoint, component, integration
  - Example: "Add user profile page"

- **Complex** (>1000 LOC): Full phase breakdown, 8+ PRs
  - Keywords: system, migration, architecture, redesign, platform
  - Example: "Implement authentication system"

Use `simple` keyword to force simple mode for quick tasks.

### Agent Selection Process (Orchestrated Assignment)

For optimal agent assignment, I collaborate with the project-orchestrator:

1. **Deploy project-orchestrator** to analyze task requirements and design agent assignments
2. **Orchestrator analyzes**:
   - Task complexity and domain requirements
   - Agent capabilities and specializations
   - Parallel execution opportunities
   - Resource optimization strategies
3. **Orchestrator provides**:
   - Detailed agent-to-task mapping
   - Execution phases with parallelization
   - Critical path identification
   - Risk mitigation strategies
4. **Principal-architect validates** technical approach if needed
5. **Always includes code-reviewer** for quality gates

The project-orchestrator uses these patterns for assignment:

- **Feature development**: Parallel deployment of backend-engineer + frontend-architect + test-engineer
- **Bug fixes**: Sequential debugger → specialist fix → test-engineer → code-reviewer
- **Performance issues**: Parallel performance-specialist + monitoring-specialist + database-admin
- **Security features**: Mandatory security-auditor + backend-engineer with code-reviewer gates
- **Documentation**: Parallel tech-writer + codebase-analyst for comprehensive coverage
- **Complex systems**: Multiple instances of same agent type for different components

### Plan Preview Format

Before writing any files, I present a comprehensive preview including:

- **Task Summary**: Description, complexity, total phases and PRs
- **Time Estimates**: Sequential vs parallel execution times
- **Agent Assignments**: Lead architects, specialists, and reviewers
- **Phase Breakdown**: Detailed PR structure with assignments
- **Parallel Opportunities**: Which PRs can run concurrently
- **Files to Generate**: Complete list of files that will be created
- **Risk Assessment**: Identified risks and mitigation strategies

### Approval Workflow

After presenting the preview:

**IMPORTANT**: Stay IN plan mode while waiting for approval. Only exit plan mode AFTER receiving user approval.

1. **Present plan and wait** (still in plan mode):
   - Show the complete plan preview
   - Remain in plan mode while awaiting user decision
   - Do NOT exit plan mode yet
2. **Process user response**:
   - **"yes" or approval**: Exit plan mode with ExitPlanMode tool, then write files
   - **"modify" or changes**: Stay in plan mode, adjust plan and re-present
   - **"cancel" or rejection**: Exit plan mode without writing files
3. **Execute based on decision**:
   - On approval: Use ExitPlanMode with the approved plan, then write files
   - On modify: Generate new preview with requested changes (stay in plan mode)
   - On cancel: Use ExitPlanMode to exit cleanly without creating files
4. **Report completion**: Show where files were written (if approved)

## Approval Indicators

The command recognizes these approval signals:

### Positive Approval

- "yes" - Standard approval
- "approve" - Formal approval
- "proceed" - Go ahead approval
- "👍" - Emoji approval
- "looks good" - Informal approval
- "generate" - Direct generation request
- "create files" - Explicit file creation request

### Modification Requests

- "modify" - Request changes
- "update" - Request updates
- "change" - Request modifications
- "revise" - Request revision
- "adjust" - Request adjustments

### Rejection Signals

- "no" - Standard rejection
- "cancel" - Cancellation request
- "abort" - Abort operation
- "stop" - Stop processing
- "reject" - Formal rejection
- "👎" - Emoji rejection

## Strategic Plan Format

The strategic plan includes:

1. **Executive Summary** - High-level overview and objectives
2. **Requirements Analysis** - Business and technical requirements
3. **Success Criteria** - Measurable outcomes
4. **Risk Assessment** - Potential challenges and mitigations
5. **Architectural Decisions** - Technology choices and patterns
6. **Phased implementation** - TDD methodology with parallel execution opportunities

### File Generation Strategy

When approved, files are written to `.tmp/<feature-name>/`:

**Simple tasks** generate:

- `implementation.md` - Single PR with all changes

**Complex tasks** generate:

- `plan.md` - Strategic requirements document
- `phase_1.01_<description>.md` - Phase 1, PR 1
- `phase_1.02_<description>.md` - Phase 1, PR 2
- `phase_1.03_<description>.md` - Phase 1, PR 3
- `phase_2.01_<description>.md` - Phase 2, PR 1
- `phase_2.02_<description>.md` - Phase 2, PR 2
- (continues for all PRs with phase_X.YY_description.md format)
- `rollback.md` - Rollback procedures

### PR File Contents (Detailed Task Descriptions)

Each PR file (`phase_X.YY_description.md`) contains comprehensive task breakdowns:

#### File Header Instructions (Added to Every Phase File)

Each phase file begins with clear reading instructions:

```markdown
# INSTRUCTIONS FOR READING THIS FILE

## How to Interpret This Document
This is a tactical implementation plan generated by the /plan command with agent assignments 
orchestrated by the project-orchestrator agent. Follow these guidelines:

1. **Task Structure**: Tasks are numbered (e.g., T1.01.01) for tracking and reference
2. **Agent Assignments**: Each task specifies which specialized agent should execute it
   - Assignments were optimized by project-orchestrator for parallel execution
   - Multiple instances of the same agent type may be assigned to different tasks
3. **Dependencies**: Tasks marked with dependencies must wait for prerequisite completion
4. **Parallel Execution**: Tasks without dependencies in the same section can run concurrently
5. **Acceptance Criteria**: Each task includes specific criteria that must be met

## Orchestration Strategy
This phase was designed by project-orchestrator with the following strategy:
- **Parallel Opportunities**: [List of tasks that can run simultaneously]
- **Critical Path**: [Tasks that must be sequential]
- **Resource Optimization**: [How agents are allocated efficiently]

## Execution Flow
- Start with tasks that have no dependencies
- Deploy multiple agents in parallel when possible (as indicated by orchestrator)
- Complete all tasks in a section before moving to the next
- Use the verification checkpoint at the end to ensure completion

## Important Notes
- This is a living document - update task status as you progress
- If blockers arise, consult project-orchestrator for re-orchestration
- The principal-architect checkpoint at the end verifies all work is complete
```

#### Required Sections in Each PR File

1. **PR Metadata**
   - Title, estimated LOC, dependencies
   - Required reviewers and merge order

2. **Detailed Task Breakdown**
   - **Granular task list** with specific implementation steps
   - **Task IDs** for tracking (e.g., T1.01.01, T1.01.02)
   - **Assigned agents** for each task
   - **Time estimates** per task (in minutes)
   - **Dependencies** between tasks
   - **Acceptance criteria** for each task

3. **Parallel Execution Plan**
   - Which tasks can run simultaneously
   - Critical path identification
   - Time savings from parallelization

4. **Implementation Details**
   - **Specific code changes** required
   - **File-by-file modifications**
   - **Exact functions/methods** to add or modify
   - **Database changes** if applicable
   - **Configuration updates** needed
   - **Test cases** to implement

5. **Review Requirements**
   - Specific reviewers needed
   - Areas requiring special attention
   - Security considerations
   - Performance implications

6. **Phase Completion Checkpoint**
   - **Principal-Architect Verification** (at end of file)
   - Comprehensive code review to verify:
     - All tasks in this phase are complete
     - Code matches the plan specifications
     - Tests are passing
     - Integration points are working
     - No regressions introduced
   - Example format:

   ```markdown
   ## Phase Completion Checkpoint
   
   **Agent**: principal-architect
   **Type**: Comprehensive verification
   
   Verify the following before marking this phase complete:
   - [ ] All tasks T1.01.01 through T1.01.XX are implemented
   - [ ] Code changes match specifications in this document
   - [ ] Unit tests are written and passing
   - [ ] Integration tests verify connections between components
   - [ ] Code follows project standards and patterns
   - [ ] No security vulnerabilities introduced
   - [ ] Performance metrics meet requirements
   - [ ] Documentation is updated where needed
   
   Run verification with: `principal-architect --verify phase_1.01`
   ```

Example task detail level:

```text
Task T1.02.03: Implement password hashing in User model
- Agent: backend-engineer
- Time: 25-30 minutes
- Dependencies: T1.02.01 (User schema complete)
- Details:
  * Add bcrypt dependency to package.json
  * Create pre-save hook in src/models/User.js
  * Hash password with 12 rounds
  * Add comparePassword method
  * Never expose raw password in JSON
- Acceptance: Password stored as hash, comparison works
```

### Phase Organization

Phases follow a logical progression:

1. **Phase 1 - Test Foundation**: Test infrastructure and TDD setup
2. **Phase 2 - Core Implementation**: Main functionality
3. **Phase 3 - Integration**: Service integration and validation

Within each phase:

- PRs are numbered sequentially (1.01, 1.02, 1.03...)
- Dependencies are clearly marked
- Parallel execution opportunities identified
- Each PR is independently mergeable

### Error Handling

If issues occur during planning:

- **File not found**: Report error and request valid file path
- **File unreadable**: Check permissions and file format
- **Empty file**: Inform user that file contains no requirements
- **Binary file**: Reject non-text files, request text-based input
- **Agent unavailable**: Use fallback agents with similar expertise
- **Complexity overflow**: Auto-split into smaller manageable tasks
- **PR too large**: Break down into multiple smaller PRs
- **Circular dependencies**: Serialize execution order
- **Planning timeout**: Fall back to simple mode

After 3 failed attempts, generate a simple single-file plan as fallback.

## Benefits of Plan Mode

### Why Preview Before Writing

1. **No wasted files**: Files only created after approval
2. **User control**: Review and approve before resource commitment
3. **Iterative refinement**: Modify requirements without file cleanup
4. **Transparency**: See exactly what will be created
5. **Resource efficiency**: Avoid generating 15+ files for misunderstood requirements
6. **Clear expectations**: Know scope, complexity, and deliverables upfront
7. **Optimized agent assignments**: Project-orchestrator ensures optimal agent selection and parallelization
8. **Time savings**: Parallel execution strategies can reduce total time by 40-60%

### Comparison

| Aspect | Without Preview | With Preview (Plan Mode) |
|--------|----------------|-------------------------|
| File Generation | Immediate | After approval only |
| User Control | Limited | Full control |
| Mistakes | Manual cleanup | Just cancel |
| Iteration | Delete and regenerate | Review and modify |
| Transparency | After the fact | Before generation |

## Examples

### File-Based Planning

#### Reading Requirements from File

```text
User: /plan --file requirements/auth-system.md
# Or alternatively:
User: /plan -f requirements/auth-system.md

Claude: 📋 Entering plan mode for strategic planning...
[Reading file: requirements/auth-system.md]

[Analyzing requirements from file...]

## 📋 PLAN PREVIEW

### Task Summary
- **Source**: requirements/auth-system.md
- **Description**: Implement OAuth2 authentication system with JWT tokens
- **Complexity**: Complex (~2000 LOC)
- **Total Phases**: 3
- **Total PRs**: 11
[... detailed breakdown based on file content ...]

Ready to proceed with file generation?

[Waiting for your approval in plan mode...]

User: yes

Claude: [Exiting plan mode with approved plan...]
✅ Plan approved! Writing files...
📁 Files written to: .tmp/oauth2-auth-jwt-a7x9/
```yaml

#### Simple Task from File

```text
User: /plan simple --file bugs/button-fix.txt
# Or alternatively:
User: /plan simple -f bugs/button-fix.txt

Claude: 📋 Entering plan mode...
[Reading file: bugs/button-fix.txt]

## 📋 PLAN PREVIEW
- **Source**: bugs/button-fix.txt
- **Description**: Fix submit button disabled state
- **Complexity**: Simple (~20 LOC)
- **Files**: 1 implementation file

Ready to proceed with file generation?

[Waiting for your approval in plan mode...]
```yaml

#### Structured YAML Input

```text
User: /plan --file tasks/feature.yaml
# Or alternatively:
User: /plan -f tasks/feature.yaml

Claude: 📋 Entering plan mode...
[Reading file: tasks/feature.yaml]
[Parsing YAML structure...]

## 📋 PLAN PREVIEW
- **Source**: tasks/feature.yaml (structured)
- **Description**: Multi-service integration feature
- **Complexity**: Complex (~3000 LOC)
- **Components Identified**:
  - Backend API changes
  - Frontend UI updates
  - Database migrations
  - Third-party integrations
[... phase breakdown from YAML structure ...]
```yaml

### Complex Task with Orchestrator Assignment

```text
User: /plan implement user authentication with JWT

Claude: 📋 Entering plan mode for strategic planning...

[Deploying project-orchestrator to analyze requirements and design agent assignments...]

Project Orchestrator Analysis:
- Identified 5 specialized agents needed
- Designed 3 parallel execution phases
- Optimized for 60% time reduction through parallelization

## 📋 PLAN PREVIEW

### Task Summary
- **Description**: Implement user authentication with JWT
- **Complexity**: Complex (~1500 LOC)
- **Total Phases**: 3
- **Total PRs**: 9
- **Orchestration Strategy**: Parallel-first with critical path optimization

### Agent Assignments (by project-orchestrator)
Phase 1 (Parallel):
- security-auditor: Design auth architecture and threat model
- api-architect: Design JWT token structure and endpoints
- database-admin: Design user schema and session storage

Phase 2 (Parallel):
- backend-engineer: Implement auth endpoints and JWT logic
- frontend-architect: Build login/signup UI components
- test-engineer: Create auth test suite

Phase 3 (Sequential):
- principal-architect: Integration verification
- code-reviewer: Final quality review

[... detailed breakdown ...]

Ready to proceed with file generation?

[Waiting for your approval in plan mode...]

User: yes

Claude: [Exiting plan mode with approved plan...]
✅ Plan approved! Writing files with orchestrated agent assignments...
📁 Files written to: .tmp/user-auth-jwt-x3f2/
```yaml

### Cancelled Plan

```text
User: /plan add dark mode to entire app

Claude: 📋 Entering plan mode...

[Generates plan preview...]

Ready to proceed?

User: cancel

Claude: ❌ Plan cancelled. No files were written.
```yaml

### Simple Mode

```text
User: /plan simple fix typo in button

Claude: 📋 Entering plan mode...

## 📋 PLAN PREVIEW
- **Description**: Fix typo in button
- **Complexity**: Simple (~5 LOC)
- **Files**: 1 implementation file

Ready to proceed with file generation?

[Waiting for your approval in plan mode...]

User: yes

Claude: [Exiting plan mode with approved plan...]
✅ Plan approved! Writing files...
📁 Files written to: .tmp/fix-typo-2x1/implementation.md
```yaml

## Arguments

- `task_description` (optional): Direct task description or requirements
- `simple` (optional): Forces simple mode for tasks <100 LOC
- `--file <file_path>` or `-f <file_path>` (optional): Path to file containing task requirements

**Note**: When using `--file` or `-f`, the file content becomes the sole source of requirements. Any additional task description is ignored.

## Behavior

The /plan command follows these behavioral patterns:

### Planning Phase

1. **Immediate plan mode entry**: Switches to strategic planning mode
2. **Comprehensive analysis**: Evaluates task complexity and requirements
3. **Agent orchestration**: Identifies optimal agent assignments
4. **Preview generation**: Creates detailed plan preview without writing files
5. **Approval waiting**: Pauses for explicit user confirmation

### Execution Phase

1. **File generation**: Only occurs after explicit approval
2. **Structured output**: Writes files to `.tmp/<feature-name>/` directory
3. **Progress reporting**: Shows exactly where files were created
4. **Error handling**: Gracefully handles planning failures with fallbacks

### Quality Assurance

1. **TDD methodology**: Emphasizes test-driven development patterns
2. **Phased implementation**: Breaks complex work into manageable phases
3. **Parallel optimization**: Identifies concurrent execution opportunities
4. **Review requirements**: Specifies required reviewers and quality gates

### User Control

1. **Preview first**: Never writes files without approval
2. **Iterative refinement**: Supports plan modifications before generation
3. **Cancellation support**: Allows aborting without file creation
4. **Transparency**: Shows complete plan structure before execution

## Notes

- Plan mode ensures no files are written without explicit approval for ALL tasks (including simple ones)
- All planning happens in memory until approval is received
- Complex plans can involve 10+ PR files but are only written if approved
- The preview checkpoint prevents filesystem clutter
- Users maintain full control over the planning process for both simple and complex tasks
- Supports iterative refinement without generating unwanted files
- **Even simple tasks require explicit approval before file generation**
- **File input**: When using `--file` or `-f`, the file content is the sole source of truth for requirements
- **File formats**: Any text-based file with clear requirements can be used as input
- **Absolute paths**: File paths can be relative or absolute
- **Large files**: The entire file is read, so very large files may take longer to process
