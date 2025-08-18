# /plan Command

## Description

Enters plan mode to generate strategic implementation plans organized by phases.
Creates a roadmap of focused PRs with clear dependencies and parallel opportunities.

## Usage

```bash
/plan <task_description>
/plan -s <task_description>      # Simple mode flag
/plan --simple <task_description> # Simple mode flag (long form)
/plan --file <file_path>         # Read task from file
/plan -f <file_path>             # Read task from file (short form)
```

## Command Execution Flow

When you invoke `/plan`, I will:

1. **Enter plan mode** for strategic planning
2. **Read file if provided** with --file flag
3. **Generate phased plan** with clear task breakdown
4. **Present preview** showing phases and dependencies
5. **Stay in plan mode** awaiting your decision
6. **Exit plan mode** only after approval
7. **Generate plan files** to `.tmp/<feature-name>/` if approved

### File Input Processing

When using `--file <file_path>` or `-f <file_path>`:

- Reads entire file as sole requirement source
- Supports `.md`, `.txt`, `.yaml`, `.json`, `.rst` formats
- Parses user stories, specs, bug reports, feature requests
- Ignores conversation context when file flag is used

## Complexity Assessment

- **Simple**: Single phase, one PR
  - Keywords: button, typo, color, text change
- **Medium**: 2-3 phases, multiple PRs
  - Keywords: feature, endpoint, component
- **Complex**: Multiple phases with dependencies
  - Keywords: system, migration, architecture

## Agent Deployment Patterns

- **Features**: backend-engineer + frontend-architect + test-engineer
- **Bug fixes**: debugger → specialist → test-engineer
- **Performance**: performance-specialist + monitoring-specialist
- **Security**: security-auditor with code-reviewer gates

## Plan Preview Format

Preview includes:

- Task summary with complexity
- Phase breakdown with dependencies
- Agent assignments per phase
- Parallel execution opportunities

## Approval Workflow

**IMPORTANT**: Stay IN plan mode until user responds.

1. **Present and wait** in plan mode
2. **Process response**:
   - "yes"/"approve": Exit plan mode, write files
   - "modify": Stay in plan mode, adjust
   - "cancel": Exit without writing
3. **Report completion** if approved

**Approval signals**: yes, approve, proceed, 👍, looks good
**Modification**: modify, update, change, revise
**Rejection**: no, cancel, abort, stop, reject, 👎

## File Generation

- `plan.md` - Overall strategy and phases
- `phase_X_description.md` - Detailed phase implementation
- `rollback.md` - Rollback procedures (if needed)

### Phase File Structure

Each phase file contains:

1. **Phase Overview**: What this phase accomplishes
2. **Tasks**: Numbered list with clear descriptions
3. **Dependencies**: What must complete before this phase
4. **Implementation Details**: Specific changes needed
5. **Acceptance Criteria**: How to verify completion

## Phase Organization

### Phase 1: Foundation

- Set up core infrastructure
- Define interfaces and contracts
- Create test framework
- Can execute tasks in parallel

### Phase 2: Implementation

- Build core functionality
- Implement business logic
- Create UI components
- Independent tasks run concurrently

### Phase 3: Integration

- Connect components
- Validate functionality
- Optimize performance
- Final security review

## Error Handling

- File not found: Request valid path
- Empty/binary files: Reject, request text input
- Agent unavailable: Use fallback agents
- Complexity overflow: Auto-split tasks
- Circular dependencies: Serialize execution
- After 3 failures: Generate simple fallback plan

## Benefits of Plan Mode

- **No wasted files**: Only created after approval
- **User control**: Review before commitment
- **Transparency**: See exactly what will be created
- **Optimized assignments**: Project-orchestrator ensures efficiency
- **Time savings**: 40-60% reduction through parallelization

## Examples

### Complex Planning

```bash
User: /plan implement authentication
Claude: 📋 Entering plan mode...

## Plan Preview: Authentication System

### Phase 1: Foundation
- Set up JWT configuration
- Create user model and schema
- Define auth middleware

### Phase 2: Implementation
- Build login/logout endpoints
- Implement password hashing
- Create session management

### Phase 3: Integration
- Add auth to existing routes
- Create auth UI components
- Security validation

Ready to proceed? (yes/no/modify)

User: yes
Claude: ✅ Plan files created in .tmp/authentication/
```

### Simple Mode Planning

```bash
User: /plan -s fix login button styling
Claude: 📋 Entering plan mode...

## Plan Preview: Fix Login Button Styling

### Single Phase Implementation
- Update button CSS classes in LoginForm component
- Test styling changes across different screen sizes
- Verify accessibility contrast ratios

Estimated: <30 minutes, single PR

Ready to proceed? (yes/no/modify)

User: yes
Claude: ✅ Simple plan created in .tmp/login-button-fix/
```

### File-Based Planning

```bash
User: /plan --simple --file feature-spec.md
Claude: 📋 Entering plan mode...
📖 Reading requirements from feature-spec.md...

## Plan Preview: Add Dark Mode Toggle

### Single Phase Implementation
- Create toggle component with theme context
- Update CSS variables for dark theme
- Add persistence with localStorage

Ready to proceed? (yes/no/modify)
```

## Arguments

- `task_description`: Direct requirements
- `-s/--simple`: Simple mode flag for streamlined single-phase plans
- `--file/-f <path>`: Read requirements from file

## Behavior Summary

1. **Planning**: Enter plan mode, analyze, orchestrate, preview
2. **Approval**: Wait for user decision in plan mode
3. **Execution**: Write files only after approval
4. **Quality**: TDD methodology, phased implementation
5. **Control**: Preview first, iterative refinement, cancellation support

## Notes

- Plans require explicit approval before file generation
- Phase organization ensures logical progression
- Dependencies clearly marked between phases
- Parallel opportunities highlighted within phases
- Use --file flag for requirements from files
