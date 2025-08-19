# /plan Command

## Description

Generates Product Requirements Document (PRD) and PR-based task files with agent assignments.
Never guesses unclear requirements - asks for clarification while staying in plan mode.

## Usage

```bash
/plan <task_description>             # Standard mode
/plan -s <task_description>          # Simple mode (single PR)
/plan --simple <task_description>    # Simple mode (single PR)
/plan -f <file_path>                 # Read from file
/plan --file <file_path>             # Read from file
```

## Command Execution Flow

1. Enter plan mode
2. Analyze requirements, ask clarification if needed
3. Generate PRD preview
4. Wait for approval (yes/no/modify)
5. Create files in `.tmp/<feature-name>/` only after approval

## Plan Preview Format

PRD preview shows:
- Executive Summary
- Implementation Phases with PR counts
- Key Requirements
- Approval prompt

## File Structure

### Generated Files
- `prd.md` - Product Requirements Document
- `phase_X_pr_Y_<description>.md` - PR implementation files
- `rollback.md` - Rollback procedures (if needed)

### PRD Contents
- Executive Summary
- Business Objectives & Scope
- Technical Requirements
- Implementation Phases
- Success Metrics & Risks
- Dependencies & Timeline

### Phase Organization
Phases are organized with clear dependencies:
- Phase 1: Foundation (infrastructure, contracts)
- Phase 2: Implementation (features, logic)
- Phase 3: Integration (connections, validation)

### Phase Files (Auto-Generated)
Each PR file contains tasks with:
- **Task ID**: `Task_X_Y_ZZ` format
- **Assignees**: Specialized agents
- **Execution**: Independent/Concurrent/Depends
- **Technical Details**: Implementation steps
- **Testing**: Acceptance criteria

## Clarification Protocol

**Never guess requirements.** When unclear:
- Present what's understood
- Ask specific questions
- Stay in plan mode awaiting answers
- Generate PRD only after clarity

Example ambiguities:
- "Make it faster" → Ask for specific metrics
- "Add search" → Ask scope, volume, features needed
- "Integrate API" → Ask which API, what operations

## Agent Patterns

- **Features**: backend-engineer + frontend-architect + test-engineer
- **Bug fixes**: debugger → specialist → test-engineer
- **Performance**: performance-specialist + monitoring-specialist
- **Security**: security-auditor + code-reviewer

## Approval Signals

- **Approve**: yes, approve, proceed, 👍
- **Modify**: modify, update, change
- **Cancel**: no, cancel, abort, stop

## Example

```bash
User: /plan implement authentication
Claude: 📋 Entering plan mode...

## PRD Preview: Authentication System

Executive Summary: JWT-based auth with registration/login
Phases: 3 phases, 9 PRs, 33 tasks
Key Requirements: Bcrypt, RS256, <500ms response

Ready to proceed? (yes/no/modify)

User: yes
Claude: ✅ Created in .tmp/authentication/:
- prd.md
- phase_1_pr_1_database.md (3 tasks)
- phase_1_pr_2_services.md (4 tasks)
[... 7 more PR files]
```

## Notes

- PRD drives all phase file generation
- Tasks auto-assigned to appropriate agents
- Parallel execution where possible
- Every task traces to PRD requirements