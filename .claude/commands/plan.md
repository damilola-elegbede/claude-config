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
```

## Command Execution Flow

### Plan Mode Entry

When you invoke `/plan`, I will:

1. **Enter plan mode** immediately to begin strategic planning
2. **Analyze task complexity** to determine the appropriate approach
3. **Generate a complete plan** in memory without writing any files
4. **Present a preview** for your review and approval
5. **Wait for your decision** before taking any action
6. **Write files only if approved** - no files created until you confirm

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

### Agent Selection Process

Based on task requirements, I will:

1. **Consult principal-architect** to determine technical approach
2. **Identify required specialists** based on task domain
3. **Assign project-orchestrator** for complex multi-phase work
4. **Include appropriate reviewers** (always includes code-reviewer)
5. **Optimize for parallel execution** when possible

Common agent patterns:

- **Feature development**: backend-engineer + frontend-architect + test-engineer
- **Bug fixes**: debugger + test-engineer + code-reviewer
- **Performance issues**: performance-specialist + monitoring-specialist
- **Security features**: security-auditor + backend-engineer + code-reviewer
- **Documentation**: tech-writer + codebase-analyst

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

1. **Wait for your response**:
   - **"yes" or approval**: Proceed to write all files
   - **"modify" or changes**: Adjust plan and re-present
   - **"cancel" or rejection**: Abort without writing files
2. **Exit plan mode** using ExitPlanMode tool with your decision
   - On approval: Exit with intent=write, plan_id=<id>, approved=true
   - On modify: Stay in plan mode, re-present updated preview
   - On cancel: Exit with intent=discard, approved=false (no writes)
3. **Execute approved plan**: Write files only after confirmation
4. **Report completion**: Show where files were written

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
- `phase_1.1_<description>.md` - Phase 1, PR 1
- `phase_1.2_<description>.md` - Phase 1, PR 2
- `phase_1.3_<description>.md` - Phase 1, PR 3
- `phase_2.1_<description>.md` - Phase 2, PR 1
- `phase_2.2_<description>.md` - Phase 2, PR 2
- (continues for all PRs with phase_X.Y_description.md format)
- `rollback.md` - Rollback procedures

### PR File Contents (Detailed Task Descriptions)

Each PR file (`phase_X.Y_description.md`) contains comprehensive task breakdowns:

#### Required Sections in Each PR File

1. **PR Metadata**
   - Title, estimated LOC, dependencies
   - Required reviewers and merge order

2. **Detailed Task Breakdown**
   - **Granular task list** with specific implementation steps
   - **Task IDs** for tracking (e.g., T1.1.1, T1.1.2)
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

Example task detail level:

```text
Task T1.2.3: Implement password hashing in User model
- Agent: backend-engineer
- Time: 25-30 minutes
- Dependencies: T1.2.1 (User schema complete)
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

- PRs are numbered sequentially (1.1, 1.2, 1.3...)
- Dependencies are clearly marked
- Parallel execution opportunities identified
- Each PR is independently mergeable

### Error Handling

If issues occur during planning:

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

### Comparison

| Aspect | Without Preview | With Preview (Plan Mode) |
|--------|----------------|-------------------------|
| File Generation | Immediate | After approval only |
| User Control | Limited | Full control |
| Mistakes | Manual cleanup | Just cancel |
| Iteration | Delete and regenerate | Review and modify |
| Transparency | After the fact | Before generation |

## Examples

### Complex Task with Approval

```text
User: /plan implement user authentication with JWT

Claude: 📋 Entering plan mode for strategic planning...

[Generates comprehensive plan...]

## 📋 PLAN PREVIEW

### Task Summary
- **Description**: Implement user authentication with JWT
- **Complexity**: Complex (~1500 LOC)
- **Total Phases**: 3
- **Total PRs**: 9
[... detailed breakdown ...]

Ready to proceed with file generation?

[Exiting plan mode, awaiting approval...]

User: yes

Claude: ✅ Plan approved! Writing files...
📁 Files written to: .tmp/user-auth-jwt-x3f2/
```

### Cancelled Plan

```text
User: /plan add dark mode to entire app

Claude: 📋 Entering plan mode...

[Generates plan preview...]

Ready to proceed?

User: cancel

Claude: ❌ Plan cancelled. No files were written.
```

### Simple Mode

```text
User: /plan simple fix typo in button

Claude: 📋 Entering plan mode...

## 📋 PLAN PREVIEW
- **Description**: Fix typo in button
- **Complexity**: Simple (~5 LOC)
- **Files**: 1 implementation file

Ready to proceed?

User: yes

Claude: ✅ Writing: .tmp/fix-typo-2x1/implementation.md
```

## Notes

- Plan mode ensures no files are written without explicit approval
- All planning happens in memory until approval is received
- Complex plans can involve 10+ PR files but are only written if approved
- The preview checkpoint prevents filesystem clutter
- Users maintain full control over the planning process
- Supports iterative refinement without generating unwanted files
