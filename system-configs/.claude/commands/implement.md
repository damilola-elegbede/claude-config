---
description: Implement features from markdown specs
argument-hint: [spec-file.md] [--dry-run|--incremental]
---

# /implement Command

## Usage

```bash
/implement <spec-file.md>           # Implement from spec
/implement spec.md --dry-run        # Show plan without executing
/implement spec.md --incremental    # Only incomplete tasks
```

## Description

Reads a markdown specification and implements the described features. Deploys appropriate engineers based on the spec requirements.

## Behavior

1. **Parse**: Read specification and identify tasks
2. **Plan**: Determine which agents to deploy
3. **Implement**: Execute tasks with appropriate engineers
4. **Verify**: Run tests to confirm implementation

## Expected Output

```text
User: /implement feature-spec.md

📄 Reading specification: feature-spec.md
🔍 Identified 5 tasks across 2 domains

📋 Execution Plan:
  - backend-engineer: API endpoints (2 tasks)
  - frontend-engineer: UI components (2 tasks)
  - test-engineer: Integration tests (1 task)

Deploying agents...

✅ Task 1/5: Created user API endpoint
✅ Task 2/5: Added input validation
✅ Task 3/5: Built UserProfile component
✅ Task 4/5: Connected frontend to API
✅ Task 5/5: Added integration tests

🧪 Running tests...
✅ All tests passing

🎉 Implementation complete (5 tasks)
```

### Dry-Run Mode

```text
User: /implement spec.md --dry-run

📄 Dry run analysis for spec.md

📋 Would execute:
  - 3 backend tasks (backend-engineer)
  - 2 frontend tasks (frontend-engineer)
  - 1 test task (test-engineer)

Estimated time: 15-20 minutes

Ready to proceed? Run without --dry-run
```

## Specification Format

```markdown
# Feature Name

## Tasks

1. [ ] Create API endpoint for users
2. [ ] Add validation middleware
3. [ ] Build UserList component (depends on: 1)

## Acceptance Criteria

- [ ] Users can be listed and filtered
- [ ] Validation errors shown clearly
```

## Notes

- Automatically selects agents based on task type
- Respects task dependencies
- Use `--incremental` to resume partial implementations
- Typical execution: 10-30 minutes
