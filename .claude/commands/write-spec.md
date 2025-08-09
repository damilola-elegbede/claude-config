# /write-spec Command

## Description
Generates detailed technical specification (SPEC) files from a Product Requirements Document (PRD). Creates multiple SPEC files in implementation order, each containing high-level context, objectives, implementation notes, and granular task prompts ready for execution.

## Usage
```
/write-spec <prd-path>
```

## Arguments
- `prd-path` (required): Path to the PRD file, typically in `.tmp/` directory

## Behavior
When you use `/write-spec`, I will:

1. **Parse PRD Document**:
   - Read and analyze the PRD structure
   - Extract functional and technical requirements
   - Identify implementation phases
   - Determine component dependencies

2. **Generate Implementation Order**:
   - Analyze dependencies between components
   - Create optimal build sequence
   - Identify parallel work streams
   - Define integration points

3. **Create SPEC Files**:
   - Generate one SPEC file per major component/phase
   - Number files in implementation order
   - Place in same directory as source PRD
   - Format: `SPEC_01_[component]_[timestamp].md`

4. **Deploy Specialized Agents**:
   - **tech-writer**: SPEC structure and documentation
   - **principal-architect**: Technical architecture details
   - **backend-engineer**: Backend implementation specs
   - **frontend-architect**: Frontend implementation specs
   - **test-engineer**: Testing specifications

## SPEC File Structure

Each SPEC file contains:

### 1. High-Level Context
```markdown
## High-Level Context
- Overall system objective
- Business value proposition
- Relationship to other components
- Position in implementation sequence
```

### 2. Mid-Level Objectives
```markdown
## Mid-Level Objectives
- Component-specific goals
- Success criteria
- Performance targets
- Integration requirements
```

### 3. Implementation Notes
```markdown
## Implementation Notes
- Technology stack decisions
- Architectural patterns to follow
- Code organization guidelines
- Best practices and conventions
- Security considerations
- Performance optimizations
```

### 4. Required Context
```markdown
## Required Context
- External dependencies
- API documentation links
- Database schemas
- Environment variables
- Configuration requirements
- Third-party service credentials
```

### 5. Beginning Context
```markdown
## Beginning Context (Prerequisites)
### Available Files
- Existing code files to modify
- Configuration files present
- Database migrations completed
- Dependencies installed

### System State
- Services that must be running
- Database state requirements
- Feature flags settings
- Environment setup
```

### 6. Ending Context
```markdown
## Ending Context (Deliverables)
### Files to Create/Modify
- New files that should exist
- Modified files with changes
- Configuration updates
- Test files created

### System State
- Services deployed and running
- Database changes applied
- Feature flags updated
- Metrics and monitoring in place
```

### 7. Low-Level Tasks
```markdown
## Low-Level Tasks (Implementation Prompts)

### Task 1: [Task Name]
**Prompt**: "Create a new file at `src/services/auth.ts` that implements JWT authentication. Include methods for token generation, validation, and refresh. Use the jsonwebtoken library and follow the existing service pattern in `src/services/user.ts`."

**Acceptance Criteria**:
- [ ] Token generation with configurable expiry
- [ ] Token validation with proper error handling
- [ ] Refresh token mechanism
- [ ] Unit tests with >80% coverage

### Task 2: [Task Name]
**Prompt**: "Modify the existing `src/middleware/auth.js` to use the new authentication service. Replace the current session-based auth with JWT validation. Ensure backward compatibility during migration period."

**Acceptance Criteria**:
- [ ] Middleware validates JWT tokens
- [ ] Falls back to session for migration
- [ ] Proper error responses
- [ ] Request object populated with user data
```

## Example Output

Given a PRD for user authentication, generates:

### SPEC_01_database_schema_20240115_143022.md
- Database tables for users, roles, permissions
- Migration scripts
- Seed data requirements

### SPEC_02_authentication_service_20240115_143022.md
- JWT implementation
- OAuth2 integration
- Password hashing
- Session management

### SPEC_03_api_endpoints_20240115_143022.md
- REST API design
- Request/response schemas
- Error handling
- Rate limiting

### SPEC_04_frontend_auth_20240115_143022.md
- Login/signup components
- Auth context/store
- Route protection
- Token management

### SPEC_05_testing_suite_20240115_143022.md
- Unit test specifications
- Integration test scenarios
- E2E test flows
- Performance benchmarks

## Implementation Order Logic

The command determines order based on:

1. **Infrastructure First**: Database, configuration, environment
2. **Core Services**: Authentication, authorization, data models
3. **API Layer**: Endpoints, middleware, validation
4. **Frontend**: UI components, state management, routing
5. **Integration**: Third-party services, webhooks, notifications
6. **Testing**: Unit, integration, E2E, performance
7. **Deployment**: CI/CD, monitoring, documentation

## Task Prompt Guidelines

Each low-level task prompt includes:

- **Specific file paths** to create or modify
- **Exact functionality** to implement
- **Code patterns** to follow
- **Libraries** to use
- **Error handling** requirements
- **Test coverage** expectations
- **Documentation** needs
- **Performance** constraints

## Smart Features

### Dependency Resolution
- Identifies inter-component dependencies
- Orders tasks to minimize blocking
- Highlights parallel work opportunities
- Flags circular dependencies

### Prompt Engineering
- Creates executable, unambiguous prompts
- Includes context and constraints
- References existing patterns
- Provides clear success criteria

### Progressive Enhancement
- Basic functionality first
- Enhanced features in later specs
- Maintains working state between specs
- Supports incremental deployment

## File Management

### Naming Convention
```
SPEC_[NN]_[component]_[YYYYMMDD]_[HHMMSS].md
```
Where NN is the implementation order (01, 02, 03...)

### Directory Structure
```
.tmp/
├── PRD_user-auth_20240115_143022.md
├── SPEC_01_database_schema_20240115_143025.md
├── SPEC_02_authentication_service_20240115_143025.md
├── SPEC_03_api_endpoints_20240115_143025.md
├── SPEC_04_frontend_auth_20240115_143025.md
└── SPEC_05_testing_suite_20240115_143025.md
```

## Typical Workflow

```bash
# 1. Create plan
/plan "Build user authentication system"

# 2. Generate PRD
/write-prd
# Output: .tmp/PRD_user-auth_20240115_143022.md

# 3. Generate SPEC files
/write-spec .tmp/PRD_user-auth_20240115_143022.md
# Output: Multiple SPEC files in order

# 4. Review SPEC files
ls -la .tmp/SPEC_*.md

# 5. Execute implementation
# Use each SPEC file as implementation guide
cat .tmp/SPEC_01_*.md
# Implement Task 1, Task 2, etc.
```

## Execution Guide

To implement from SPEC files:

1. **Start with SPEC_01**
2. **Complete all low-level tasks in order**
3. **Verify ending context matches**
4. **Run tests before moving to next SPEC**
5. **Commit after each SPEC completion**

## Quality Standards

Each SPEC ensures:
- **Complete implementation path** from start to finish
- **Testable deliverables** with clear acceptance criteria
- **Executable prompts** that can be run directly
- **Traceable requirements** back to PRD
- **Maintainable code** following best practices

## Agent Coordination

Multiple agents collaborate:
- **tech-writer**: Overall SPEC structure
- **principal-architect**: System design elements
- **backend-engineer**: Server-side specifications
- **frontend-architect**: Client-side specifications
- **test-engineer**: Testing requirements
- **devops**: Deployment specifications

## Advanced Features

### Multi-Phase Projects
- Generates separate SPEC sets per phase
- Maintains phase dependencies
- Supports parallel phase execution
- Includes phase integration specs

### Prompt Validation
- Checks prompt completeness
- Validates file paths
- Ensures dependencies exist
- Verifies acceptance criteria measurability

### Rollback Specifications
- Includes rollback procedures
- Database migration rollbacks
- Feature flag toggles
- Service degradation plans

## Notes

- MUST BE USED with a valid PRD file path
- Generates implementation-ready specifications
- Each SPEC is self-contained and executable
- Prompts are designed for direct AI execution
- Maintains consistency with existing codebase
- Supports both greenfield and brownfield projects
- Can regenerate specs with updated requirements
- Preserves implementation flexibility
- Enables parallel development when possible
- Creates audit trail from requirements to implementation