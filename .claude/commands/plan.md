# /plan Command

## Description

Generates comprehensive strategic requirements and tactical implementation broken down into individual PR files. Each PR is independently reviewable, contains complete implementation details, and follows TDD methodology. Creates a roadmap of small, focused PRs that can be developed in parallel when possible.

## Usage

```bash
/plan <task_description>
/plan simple <task_description>  # For tasks <100 LOC
```

## Complexity Determination

- **Simple tasks** (<100 LOC): Single PR, no phases, minimal orchestration
- **Medium tasks** (100-1000 LOC): 2-3 phases, 4-7 PRs
- **Complex tasks** (>1000 LOC): Full phase breakdown, 8+ PRs
- Use "simple" keyword to force simple mode for quick tasks

## Command Execution Flow

### 1. Task Analysis & Orchestration (5-15 seconds based on complexity)

```text
Input → Complexity Analysis → Mode Selection (simple/medium/complex)
   ↓
Simple Mode: Direct Implementation → Single PR File
   OR
Complex Mode: Agent Selection → Strategic Planning (principal-architect)
   ↓
Phase Breakdown → PR Generation → Task Assignment (project-orchestrator)
   ↓
File Writing with Parallel Execution Plans
```

### 2. Complexity Analysis

```javascript
function analyzeComplexity(taskDescription) {
    // Check for explicit simple mode
    if (taskDescription.startsWith('simple ')) {
        return {
            mode: 'simple',
            estimatedLOC: '<100',
            description: taskDescription.replace('simple ', '')
        };
    }
    
    // Analyze task indicators
    const indicators = {
        simple: ['button', 'typo', 'color', 'text', 'label', 'tooltip'],
        medium: ['feature', 'endpoint', 'component', 'integration'],
        complex: ['system', 'migration', 'architecture', 'redesign', 'platform']
    };
    
    const estimatedLOC = estimateLinesOfCode(taskDescription);
    
    if (estimatedLOC < 100) return { mode: 'simple', estimatedLOC };
    if (estimatedLOC < 1000) return { mode: 'medium', estimatedLOC };
    return { mode: 'complex', estimatedLOC };
}
```

### 3. Agent Selection (Consulting Principal-Architect)

```javascript
async function selectAgents(taskDescription, complexity) {
    // Simple mode - minimal agents
    if (complexity.mode === 'simple') {
        const primaryAgent = await principalArchitect.selectPrimaryAgent(taskDescription);
        return [primaryAgent, 'code-reviewer'];
    }
    
    // Complex mode - full orchestration
    const agents = ['principal-architect', 'project-orchestrator'];
    
    // Principal-architect determines required specialists
    const requiredSpecialists = await principalArchitect.analyze({
        task: taskDescription,
        complexity: complexity,
        availableAgents: getAllAvailableAgents()
    });
    
    // Add specialists recommended by principal-architect
    agents.push(...requiredSpecialists.essential);
    
    // Always include for quality
    agents.push('test-engineer', 'code-reviewer');
    
    // Add optional specialists if under limit
    if (agents.length < 8) {
        agents.push(...requiredSpecialists.optional.slice(0, 8 - agents.length));
    }
    
    // Fallback if principal-architect unavailable
    if (!requiredSpecialists) {
        console.warn('Principal-architect unavailable, using keyword matching');
        return selectAgentsByKeywords(taskDescription);
    }
    
    return agents.slice(0, 8); // Max 8 agents
}
```

### 4. Task Orchestration Process with Realistic Time Estimates

**How Principal-Architect and Project-Orchestrator Collaborate:**
```javascript
async function orchestrateTasks(pr, complexity) {
    // Principal-architect determines technical approach
    const technicalPlan = await principalArchitect.analyze({
        requirements: pr.requirements,
        constraints: pr.constraints,
        availableAgents: getAvailableAgents()
    });
    
    // Project-orchestrator optimizes execution
    const executionPlan = await projectOrchestrator.optimize({
        tasks: technicalPlan.tasks,
        agents: technicalPlan.suggestedAgents,
        dependencies: technicalPlan.dependencies
    });
    
    // Handle disagreements - Principal-architect has final say
    if (executionPlan.conflicts) {
        console.log('Orchestrator conflict detected, deferring to principal-architect');
        executionPlan = technicalPlan.fallbackPlan;
    }
    
    // Add realistic time buffers
    const addTimeBuffers = (task) => {
        const baseTime = task.estimatedTime;
        const complexityMultiplier = { simple: 1.2, medium: 1.5, complex: 2.0 }[complexity.mode];
        const uncertaintyBuffer = task.hasExternalDeps ? 1.3 : 1.1;
        
        return {
            ...task,
            estimatedTime: Math.ceil(baseTime * complexityMultiplier * uncertaintyBuffer),
            bestCase: baseTime,
            worstCase: Math.ceil(baseTime * 3),
            bufferReason: `${(complexityMultiplier - 1) * 100}% complexity, ${(uncertaintyBuffer - 1) * 100}% uncertainty`
        };
    };
    
    executionPlan.tasks = executionPlan.tasks.map(addTimeBuffers);
    
    // Calculate realistic time savings
    const sequentialTime = executionPlan.tasks.reduce((sum, t) => sum + t.estimatedTime, 0);
    const parallelTime = calculateCriticalPath(executionPlan.tasks);
    const actualSavings = Math.round(((sequentialTime - parallelTime) / sequentialTime) * 100);
    
    return {
        taskAssignments: executionPlan.assignments,
        parallelGroups: executionPlan.groups,
        timeSavings: `${sequentialTime} min → ${parallelTime} min (${actualSavings}% reduction)`,
        criticalPath: executionPlan.criticalPath,
        confidence: complexity.mode === 'simple' ? 'High' : 'Medium',
        warning: actualSavings > 60 ? 'Time savings may be optimistic' : null
    };
}
```

### 5. Error Handling, Failure Modes & Escape Hatches

**Command Failures and Recovery:**
```javascript
try {
    const complexity = analyzeComplexity(taskDescription);
    const plan = await generatePlan(taskDescription, complexity);
    
    // PR Size Validation
    await validatePRSizes(plan.prs, {
        maxLinesPerPR: 500,
        maxFilesPerPR: 10,
        maxTotalPRs: 15
    });
    
    const phases = await breakdownIntoPhases(plan);
    const prs = await generatePRFiles(phases);
    await writePRFiles(prs);
    
} catch (error) {
    // Specific failure handlers
    if (error.type === 'AGENT_CONFLICT') {
        // Principal-architect breaks ties
        return await principalArchitect.resolve(error.conflicts);
    }
    
    if (error.type === 'COMPLEXITY_OVERFLOW') {
        // Auto-split into smaller tasks
        return splitIntoSubtasks(taskDescription, { maxComplexity: 'medium' });
    }
    
    if (error.type === 'PR_TOO_LARGE') {
        // Split PR into smaller chunks
        return splitPR(error.pr, { maxLines: 300 });
    }
    
    if (error.type === 'PR_DEPENDENCY_CYCLE') {
        // Break cycle by serializing
        return serializePRs(error.prs);
    }
    
    if (error.type === 'AGENT_UNAVAILABLE') {
        // Use fallback agent
        const fallback = selectFallbackAgent(error.agent);
        console.warn(`${error.agent} unavailable, using ${fallback}`);
        return retryWithAgent(fallback);
    }
    
    if (error.type === 'TEST_BEFORE_IMPL_IMPOSSIBLE') {
        // External API case - allow implementation first
        return switchToImplementationFirst(plan);
    }
    
    // Escape hatches
    if (error.retryCount > 3) {
        return {
            fallback: 'simple',
            message: 'Complex planning failed, generated simple single-file plan',
            plan: generateSimplePlan(taskDescription)
        };
    }
    
    throw new PlanGenerationError(error);
}

// Escape Hatch Rules
const escapeHatches = {
    'BLOCKED_2_HOURS': 'Escalate to principal-architect for guidance',
    'PR_OVER_500_LINES': 'Auto-split into multiple PRs',
    'TESTS_FAIL_3_TIMES': 'Create investigation task for debugger agent',
    'MERGE_CONFLICT': 'Create conflict resolution PR',
    'REVIEW_BOTTLENECK': 'Allow parallel review with reduced requirements',
    'AGENT_OVERLOAD': 'Redistribute tasks to available agents',
    'CIRCULAR_DEPENDENCY': 'Break cycle, serialize execution'
};
```

## File Organization

### Simple Mode Output (Single PR)
For simple tasks, generates a single PR file:
```
./.tmp/<feature-name>/
├── implementation.md           # Single PR with all changes
└── .cleanup                    # Auto-cleanup metadata
```

#### Simple PR Format: `implementation.md`
```markdown
# Simple Implementation: <Task Description>

## Task Summary
- **Complexity**: Simple (<100 LOC)
- **Primary Agent**: backend-engineer (selected by principal-architect)
- **Reviewer**: code-reviewer
- **Estimated Time**: 30-45 min (with buffer)

## Implementation
### Files to Modify
- `src/components/Button.js` - Add logout functionality

### Changes
\```javascript
// Add logout button handler
const handleLogout = () => {
    localStorage.clear();
    window.location.href = '/login';
};
\```

## Testing
- Manual test: Click logout button
- Verify session cleared
- Verify redirect to login

## Checklist
- [ ] Implementation complete
- [ ] Manually tested
- [ ] Code review passed
```

### Complex Mode Output (Multiple Phases/PRs)

### Directory Structure
```
./.tmp/<feature-name>/
├── plan.md                           # Strategic requirements (2-4 pages)
├── phase_1.1_test_scaffolding.md    # Phase 1, PR 1: Test environment setup
├── phase_1.2_model_tests.md         # Phase 1, PR 2: Model unit tests
├── phase_1.3_api_tests.md           # Phase 1, PR 3: API integration tests
├── phase_2.1_data_models.md         # Phase 2, PR 1: Database models
├── phase_2.2_business_logic.md      # Phase 2, PR 2: Core business logic
├── phase_2.3_api_endpoints.md       # Phase 2, PR 3: REST API implementation
├── phase_2.4_middleware.md          # Phase 2, PR 4: Authentication middleware
├── phase_3.1_integration.md         # Phase 3, PR 1: Service integration
├── phase_3.2_validation.md          # Phase 3, PR 2: E2E validation
├── rollback.md                      # Rollback procedures
└── .cleanup                          # Auto-cleanup metadata
```

### PR File Naming Convention
```
phase_<phase_number>.<pr_number>_<description>.md
```

**Examples:**
- `phase_1.1_test_scaffolding.md` - Phase 1, PR 1: Setting up test infrastructure
- `phase_2.3_api_endpoints.md` - Phase 2, PR 3: API endpoint implementation
- `phase_3.2_validation.md` - Phase 3, PR 2: End-to-end validation

**Naming Rules:**
- Phase number: Single digit (1-9)
- PR number: Sequential within phase (1, 2, 3...)
- Description: Snake_case, descriptive of PR content
- Each PR should be independently reviewable and mergeable

### Auto-Cleanup Strategy
```javascript
// .cleanup file contains:
{
    "created": "2024-01-15T14:30:00Z",
    "expires": "2024-01-22T14:30:00Z",  // 7-day retention
    "feature": "user-authentication",
    "phases": 3,
    "total_prs": 9,  // Total number of PR files generated
    "pr_status": {
        "phase_1": ["merged", "merged", "in_review"],
        "phase_2": ["draft", "draft", "draft", "draft"],
        "phase_3": ["planned", "planned"]
    },
    "status": "in-progress",
    "cleanup_on_merge": true
}
```

### Feature Name Generation
```javascript
function generateFeatureName(description) {
    // Extract core functionality
    const keywords = extractKeywords(description);
    const feature = keywords.slice(0, 3).join('-');
    
    // Ensure uniqueness
    const timestamp = Date.now().toString(36);
    return `${feature}-${timestamp}`.toLowerCase()
        .replace(/[^a-z0-9-]/g, '-')
        .replace(/-+/g, '-')
        .slice(0, 50);  // Max 50 chars
}
```

## Strategic Plan Format

### Requirements Document Template
```markdown
# <Feature Name> - Strategic Requirements

## Executive Summary
- **Objective**: [Clear business goal]
- **Scope**: [What's included/excluded]
- **Success Metrics**: [Measurable outcomes]
- **Estimated PRs**: [Total number of PRs across all phases]
- **Estimated Effort**: [Phase-based time estimates]

## Functional Requirements
| ID | Requirement | Priority | Acceptance Criteria |
|----|------------|----------|-------------------|
| FR-001 | [Requirement] | P0 | [Testable criteria] |

## Non-Functional Requirements
| ID | Category | Requirement | Measurement |
|----|----------|------------|-------------|
| NFR-001 | Performance | [Requirement] | [SLA/metric] |

## Technical Architecture
- **Pattern**: [Architecture pattern]
- **Stack**: [Technology choices with rationale]
- **Dependencies**: [External systems/libraries]
- **Security**: [Security considerations]

## Risk Assessment
| Risk | Probability | Impact | Mitigation | Affected PRs |
|------|------------|--------|------------|-------------|
| [Risk] | Low/Med/High | Low/Med/High | [Strategy] | [PR numbers] |

## PR Dependencies & Coordination

### Critical Path
```mermaid
graph LR
    PR1.1[Test Setup] --> PR1.2[Unit Tests]
    PR1.2 --> PR2.1[Models]
    PR2.1 --> PR2.2[Logic]
    PR2.2 --> PR2.3[APIs]
    PR2.3 --> PR3.1[Integration]
```

### Parallel Opportunities
- Phase 1: PRs 1.2 and 1.3 can be developed in parallel after 1.1
- Phase 2: PRs 2.3 and 2.4 can be developed in parallel after 2.2
- Phase 3: PRs 3.2 and 3.3 can be developed in parallel after 3.1

### Review Requirements & Bottleneck Management
- Each PR requires 2 reviews minimum
- **code-reviewer** reviews ALL PRs for quality, best practices, and maintainability
- Security-critical PRs require security-auditor review
- API changes require api-architect review
- Test PRs require test-engineer review

#### Review Load Balancing
```javascript
async function manageReviewQueue(pr) {
    const reviewerLoad = await getReviewerWorkload();
    
    // If code-reviewer has >5 PRs queued
    if (reviewerLoad['code-reviewer'] > 5) {
        // Allow senior-engineer or principal-architect to review
        pr.reviewers.push('senior-engineer');
        console.warn('code-reviewer overloaded, added senior-engineer as backup');
    }
    
    // Stagger PR submissions to avoid bottlenecks
    if (reviewerLoad.average > 3) {
        return {
            delay: '2 hours',
            reason: 'Review queue congested, staggering submissions'
        };
    }
    
    return { delay: 0 };
}
```

## Implementation Roadmap

### Phase Overview
1. **Phase 1 - Test Foundation**: 3-4 PRs
   - PR 1.1: Test environment setup
   - PR 1.2: Unit test scaffolding
   - PR 1.3: Integration test framework
   - PR 1.4: Interface definitions

2. **Phase 2 - Core Implementation**: 4-5 PRs
   - PR 2.1: Data models and schemas
   - PR 2.2: Business logic layer
   - PR 2.3: API endpoints
   - PR 2.4: Middleware and auth
   - PR 2.5: Error handling

3. **Phase 3 - Integration & Validation**: 2-3 PRs
   - PR 3.1: Service integration
   - PR 3.2: End-to-end validation
   - PR 3.3: Performance optimization

### PR Sizing Guidelines
- **Small PR**: <150 LOC (configuration, simple features)
- **Medium PR**: 150-400 LOC (typical feature implementation)
- **Large PR**: 400-600 LOC (complex features, requires splitting discussion)

### Merge Strategy
- Sequential within phases (PR 1.1 → 1.2 → 1.3)
- Phase dependencies (All Phase 1 → Phase 2 starts)
- Feature flags for partial deployments
```

## Tactical Phase Format

Each phase is broken down into independently reviewable PRs. Each PR gets its own file with complete implementation details.

### Phase Structure Overview
```markdown
Phase 1: Test-First Development
├── PR 1: Test environment setup
├── PR 2: Model unit tests
├── PR 3: API integration test scaffolding
└── PR 4: Interface definitions

Phase 2: Core Implementation
├── PR 1: Database models and schemas
├── PR 2: Business logic layer
├── PR 3: API endpoints
├── PR 4: Authentication middleware
└── PR 5: Error handling and validation

Phase 3: Integration & Validation
├── PR 1: Service integration
├── PR 2: End-to-end tests
└── PR 3: Performance validation
```

### PR File Format Example: `phase_1.1_test_scaffolding.md`
```markdown
# Phase 1, PR 1: Test Environment Setup

## PR Metadata
- **Phase**: 1 (Test-First Development)
- **PR Number**: 1 of 4
- **PR Title**: "feat: Add test environment setup and configuration"
- **Estimated LOC**: ~150
- **Dependencies**: None
- **Reviewers**: @test-engineer, @backend-engineer, @code-reviewer
- **Merge Order**: Must merge before phase_1.2
- **Orchestration**: Determined by @principal-architect and @project-orchestrator

## PR Description
This PR sets up the foundational test environment and configuration needed for TDD approach. It includes test runners, assertion libraries, and mock utilities.

## Task Assignments & Dependencies

### Task Breakdown
| Task ID | Description | Assigned Agent | Dependencies | Est. Time |
|---------|-------------|----------------|--------------|-----------|
| T1.1.1 | Create test directory structure | backend-engineer | None | 15-20 min |
| T1.1.2 | Install and configure test framework | test-engineer | T1.1.1 | 20-35 min |
| T1.1.3 | Set up database test utilities | backend-engineer | T1.1.1 | 30-50 min |
| T1.1.4 | Create test environment config | devops | None | 20 min |
| T1.1.5 | Write test helper functions | test-engineer | T1.1.2 | 25 min |
| T1.1.6 | Add CI test configuration | devops | T1.1.2, T1.1.4 | 20 min |

### Parallel Execution Plan
```
Execution Group 1 (Parallel):
├── backend-engineer: T1.1.1 - Create directory structure
└── devops: T1.1.4 - Create environment config

Execution Group 2 (After Group 1):
├── test-engineer: T1.1.2 - Configure test framework
└── backend-engineer: T1.1.3 - Database utilities

Execution Group 3 (After Group 2):
├── test-engineer: T1.1.5 - Helper functions
└── devops: T1.1.6 - CI configuration
```

### Agent Coordination Notes
- **Principal-architect**: Defined testing architecture and framework choices
- **Project-orchestrator**: Optimized task parallelization, estimated 35-45% time reduction (not the optimistic 50%)
- **Critical path**: T1.1.1 → T1.1.2 → T1.1.5 (60-90 min with buffers)
- **Conflict Resolution**: Principal-architect has final decision authority on technical approaches

## Files Changed
- `test/setup.js` - Test environment configuration (test-engineer)
- `test/helpers/database.js` - Database test utilities (backend-engineer)
- `package.json` - Test dependencies (test-engineer)
- `.env.test` - Test environment variables (devops)
- `.github/workflows/test.yml` - CI configuration (devops)

## Implementation Details

### File: `test/setup.js`
```javascript
// Environment configuration
process.env.NODE_ENV = 'test';
process.env.JWT_SECRET = 'test-secret-key-never-use-in-production';
process.env.BCRYPT_ROUNDS = '4'; // Fast for tests

const chai = require('chai');
const chaiHttp = require('chai-http');
const sinon = require('sinon');

chai.use(chaiHttp);

global.expect = chai.expect;
global.sinon = sinon;

// Cleanup after each test
afterEach(() => {
    sinon.restore();
});
```

**Rationale**: Test environment must be isolated from production configs. Using lower bcrypt rounds speeds up test execution without compromising test validity.

## PR Checklist
- [ ] All tests pass
- [ ] Code follows project style guide
- [ ] Documentation updated
- [ ] No console.logs or debug code
- [ ] Security considerations addressed

## Merge Instructions
1. Ensure CI passes
2. Merge to main
3. No deployment needed (test infrastructure only)
```

### PR File Format Example: `phase_1.2_model_tests.md`
```markdown
# Phase 1, PR 2: Model Unit Tests

## PR Metadata
- **Phase**: 1 (Test-First Development)
- **PR Number**: 2 of 4
- **PR Title**: "test: Add comprehensive model unit tests for TDD"
- **Estimated LOC**: ~300
- **Dependencies**: phase_1.1 (test environment)
- **Reviewers**: @test-engineer, @security-auditor, @code-reviewer
- **Merge Order**: After phase_1.1, before phase_2.1
- **Orchestration**: Determined by @principal-architect and @project-orchestrator

## PR Description
Implements comprehensive unit tests for the User model following TDD principles. These tests will initially fail and drive the implementation in Phase 2.

## Task Assignments & Dependencies

### Task Breakdown
| Task ID | Description | Assigned Agent | Dependencies | Est. Time |
|---------|-------------|----------------|--------------|-----------|
| T1.2.1 | Design test scenarios | test-engineer | None | 20 min |
| T1.2.2 | Write password hashing tests | security-auditor | T1.2.1 | 30 min |
| T1.2.3 | Write validation tests | test-engineer | T1.2.1 | 25 min |
| T1.2.4 | Write security feature tests | security-auditor | T1.2.1 | 35 min |
| T1.2.5 | Create test fixtures | backend-engineer | None | 15 min |
| T1.2.6 | Write integration test stubs | test-engineer | T1.2.3, T1.2.5 | 20 min |

### Parallel Execution Plan
```
Execution Group 1 (Parallel):
├── test-engineer: T1.2.1 - Design test scenarios
└── backend-engineer: T1.2.5 - Create fixtures

Execution Group 2 (After T1.2.1):
├── security-auditor: T1.2.2 - Password tests
├── test-engineer: T1.2.3 - Validation tests
└── security-auditor: T1.2.4 - Security tests

Execution Group 3 (After Group 2):
└── test-engineer: T1.2.6 - Integration stubs
```

### Agent Coordination Notes
- **Principal-architect**: Defined test coverage requirements and security test priorities
- **Project-orchestrator**: Identified parallel test writing opportunities, reducing time from 145 min to ~75 min
- **Critical path**: T1.2.1 → T1.2.3 → T1.2.6 (65 min)

## Files Changed
- `test/models/user.test.js` - User model tests (test-engineer, security-auditor)
- `test/fixtures/users.js` - Test fixtures (backend-engineer)
- `test/helpers/assertions.js` - Custom assertions (test-engineer)

## Implementation Details

### File: `test/models/user.test.js`
```javascript
const User = require('../../src/models/User'); // Will fail initially
const ValidationError = require('../../src/errors/ValidationError');

describe('User Model', () => {
    describe('Password Hashing', () => {
        it('should hash password on creation', async () => {
            // Test implementation
        });
        
        it('should not rehash unchanged passwords', async () => {
            // Test implementation
        });
    });
    
    describe('Input Validation', () => {
        it('should reject invalid email formats', async () => {
            // Test implementation
        });
        
        it('should enforce password complexity', async () => {
            // Test implementation
        });
    });
    
    describe('Security Features', () => {
        it('should not expose password in JSON', () => {
            // Test implementation
        });
        
        it('should rate limit password comparisons', async () => {
            // Test implementation
        });
    });
});
```

## PR Checklist
- [ ] Tests written following TDD principles
- [ ] All tests are initially failing (red)
- [ ] No implementation code included
- [ ] Documentation complete

## Merge Instructions
1. Review test coverage and scenarios
2. Ensure tests align with requirements
3. Merge after approval from test-engineer
```

### PR File Format Example: `phase_2.1_data_models.md`
```markdown
# Phase 2, PR 1: Database Models and Schemas

## PR Metadata
- **Phase**: 2 (Core Implementation)
- **PR Number**: 1 of 5
- **PR Title**: "feat: Implement User model with secure password handling"
- **Estimated LOC**: ~250
- **Dependencies**: phase_1.2 (tests must be failing)
- **Reviewers**: @backend-engineer, @security-auditor, @code-reviewer
- **Merge Order**: First PR in Phase 2
- **Orchestration**: Determined by @principal-architect and @project-orchestrator

## PR Description
Implements the User model with bcrypt password hashing, validation rules, and security features to make Phase 1 tests pass.

## Task Assignments & Dependencies

### Task Breakdown
| Task ID | Description | Assigned Agent | Dependencies | Est. Time |
|---------|-------------|----------------|--------------|-----------|
| T2.1.1 | Create database schema | backend-engineer | None | 25 min |
| T2.1.2 | Implement password hashing | security-auditor | T2.1.1 | 30 min |
| T2.1.3 | Add input validation | backend-engineer | T2.1.1 | 20 min |
| T2.1.4 | Implement rate limiting | security-auditor | T2.1.1 | 25 min |
| T2.1.5 | Add JWT token methods | backend-engineer | T2.1.1 | 20 min |
| T2.1.6 | Configure database connection | devops | None | 15 min |
| T2.1.7 | Run tests and verify | test-engineer | T2.1.2, T2.1.3, T2.1.4, T2.1.5 | 15 min |
| T2.1.8 | Code quality review | code-reviewer | T2.1.2, T2.1.3, T2.1.4, T2.1.5 | 20 min |

### Parallel Execution Plan
```
Execution Group 1 (Parallel):
├── backend-engineer: T2.1.1 - Create schema
└── devops: T2.1.6 - Configure database

Execution Group 2 (After T2.1.1):
├── security-auditor: T2.1.2 - Password hashing
├── backend-engineer: T2.1.3 - Input validation
├── security-auditor: T2.1.4 - Rate limiting
└── backend-engineer: T2.1.5 - JWT methods

Execution Group 3 (After Group 2):
├── test-engineer: T2.1.7 - Verify tests pass
└── code-reviewer: T2.1.8 - Code quality review
```

### Agent Coordination Notes
- **Principal-architect**: Designed model architecture with security-first approach
- **Project-orchestrator**: Parallelized independent tasks, realistic reduction from 150 min to ~95 min (37% savings)
- **Critical path**: T2.1.1 → T2.1.2 → T2.1.7 (70 min)
- **Risk**: Security features must be implemented correctly first time

## Files Changed
- `src/models/User.js` - User model implementation (backend-engineer, security-auditor)
- `src/models/index.js` - Model exports (backend-engineer)
- `src/config/database.js` - Database configuration (devops)
- `src/utils/security.js` - Security utilities (security-auditor)

## Implementation Details

### File: `src/models/User.js`
```javascript
const bcrypt = require('bcrypt');
const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    email: {
        type: String,
        required: true,
        unique: true,
        lowercase: true,
        // Validation implementation
    },
    password: {
        type: String,
        required: true,
        // Security implementation
    }
}, { timestamps: true });

// Password hashing middleware
userSchema.pre('save', async function(next) {
    // Implementation details
});

// Instance methods
userSchema.methods.comparePassword = async function(plaintext) {
    // Implementation details
};

module.exports = mongoose.model('User', userSchema);
```

## PR Checklist
- [ ] All Phase 1 tests now pass
- [ ] Security best practices implemented
- [ ] Code follows project conventions
- [ ] No hardcoded secrets

## Merge Instructions
1. Run Phase 1 tests to verify they pass
2. Security review required
3. Merge after approval

```

### PR File Format Example: `phase_3.1_integration.md`
```markdown
# Phase 3, PR 1: Service Integration

## PR Metadata
- **Phase**: 3 (Integration & Validation)
- **PR Number**: 1 of 3
- **PR Title**: "feat: Integrate authentication service with API endpoints"
- **Estimated LOC**: ~200
- **Dependencies**: All Phase 2 PRs merged
- **Reviewers**: @principal-architect, @test-engineer, @code-reviewer
- **Merge Order**: First PR in Phase 3
- **Orchestration**: Determined by @principal-architect and @project-orchestrator

## PR Description
Integrates the authentication components into the main application, connecting models, middleware, and routes.

## Task Assignments & Dependencies

### Task Breakdown
| Task ID | Description | Assigned Agent | Dependencies | Est. Time |
|---------|-------------|----------------|--------------|-----------|
| T3.1.1 | Set up Express app structure | backend-engineer | None | 20 min |
| T3.1.2 | Integrate auth routes | backend-engineer | T3.1.1 | 15 min |
| T3.1.3 | Configure middleware stack | backend-engineer | T3.1.1 | 20 min |
| T3.1.4 | Set up error handlers | backend-engineer | T3.1.3 | 15 min |
| T3.1.5 | Add request logging | monitoring-specialist | T3.1.1 | 20 min |
| T3.1.6 | Configure CORS and security | security-auditor | T3.1.1 | 25 min |
| T3.1.7 | Run integration tests | test-engineer | T3.1.2, T3.1.4, T3.1.6 | 20 min |
| T3.1.8 | Final code review | code-reviewer | All tasks | 25 min |

### Parallel Execution Plan
```
Execution Group 1:
└── backend-engineer: T3.1.1 - Express setup

Execution Group 2 (After T3.1.1):
├── backend-engineer: T3.1.2 - Auth routes
├── backend-engineer: T3.1.3 - Middleware
├── monitoring-specialist: T3.1.5 - Logging
└── security-auditor: T3.1.6 - CORS/Security

Execution Group 3 (After dependencies):
├── backend-engineer: T3.1.4 - Error handlers
└── test-engineer: T3.1.7 - Integration tests

Execution Group 4 (Final):
└── code-reviewer: T3.1.8 - Final code review
```

### Agent Coordination Notes
- **Principal-architect**: Defined integration patterns and middleware ordering
- **Project-orchestrator**: Identified 4 parallel tasks in Group 2, reducing time from 135 min to ~65 min
- **Critical path**: T3.1.1 → T3.1.3 → T3.1.4 (55 min)
- **Note**: Security configuration can run parallel to route integration

## Files Changed
- `src/app.js` - Application setup (backend-engineer)
- `src/routes/index.js` - Route registration (backend-engineer)
- `src/server.js` - Server configuration (backend-engineer)
- `src/middleware/logging.js` - Request logging (monitoring-specialist)
- `src/middleware/security.js` - Security headers (security-auditor)

## Implementation Details

### File: `src/app.js`
```javascript
const express = require('express');
const authRoutes = require('./routes/auth');

const app = express();

// Middleware setup
app.use(express.json());

// Route registration
app.use('/api/auth', authRoutes);

// Error handling
app.use(errorHandler);

module.exports = app;
```

## PR Checklist
- [ ] Integration tests pass
- [ ] End-to-end flow verified
- [ ] API documentation updated
- [ ] No breaking changes

## Merge Instructions
1. Run full test suite
2. Deploy to staging environment
3. Smoke test critical paths
4. Merge and monitor
```

## Phase Overview and PR Dependencies

### Phase Dependency Chain
```
Phase 1 PRs (Tests/TDD):
  phase_1.1 → phase_1.2 → phase_1.3 → phase_1.4
                                          ↓
Phase 2 PRs (Implementation):
  phase_2.1 → phase_2.2 → phase_2.3 → phase_2.4 → phase_2.5
                                                      ↓
Phase 3 PRs (Integration):
  phase_3.1 → phase_3.2 → phase_3.3
```

### Rollback Procedures

Each PR can be independently rolled back if issues arise:

1. **PR-level rollback**: Revert individual PR merges
2. **Phase-level rollback**: Revert all PRs in a phase
3. **Feature rollback**: Complete feature removal

### PR Rollback Commands
```bash
# Rollback specific PR
git revert <pr-merge-commit>

# Rollback entire phase
git revert <first-pr-commit>..<last-pr-commit>

# Emergency rollback
./scripts/rollback.sh phase_2.3
```

## Phase 3 Completion Criteria
✅ All API endpoints implemented and tested
✅ Integration tests passing
✅ Security headers configured
✅ Performance benchmarks met (<200ms response time)
✅ Ready for production deployment

## Deployment Readiness Checklist
- [ ] Environment variables configured
- [ ] SSL certificates installed
- [ ] Rate limiting configured
- [ ] Monitoring alerts set up
- [ ] Backup strategy implemented
- [ ] Rollback procedure documented
```

## Rollback Procedures

### Rollback Strategy Document
```markdown
# Rollback Procedures

## Phase Rollback Matrix

| Phase | Rollback Action | Time | Risk |
|-------|----------------|------|------|
| Phase 1 | Delete test files only | 5min | None |
| Phase 2 | Revert model/middleware changes | 15min | Low |
| Phase 3 | Revert routes, maintain tests | 10min | Low |

## Emergency Rollback Script
```bash
#!/bin/bash
# rollback.sh - Emergency rollback for authentication feature

PHASE=$1
BACKUP_DIR="./.tmp/backups"

case $PHASE in
    1)
        echo "Rolling back Phase 1: Tests"
        rm -rf test/models/user.test.js
        rm -rf test/setup.js
        rm -rf src/interfaces/
        rm -rf src/errors/
        ;;
    2)
        echo "Rolling back Phase 2: Implementation"
        git checkout HEAD -- src/models/User.js
        git checkout HEAD -- src/middleware/auth.js
        ;;
    3)
        echo "Rolling back Phase 3: Integration"
        git checkout HEAD -- src/routes/auth.js
        rm -rf test/integration/auth.test.js
        ;;
    all)
        echo "Complete rollback"
        git checkout HEAD -- .
        rm -rf ./.tmp/user-authentication-*
        ;;
    *)
        echo "Usage: ./rollback.sh [1|2|3|all]"
        exit 1
        ;;
esac

echo "Rollback complete for Phase $PHASE"
```

## Monitoring Script
```bash
#!/bin/bash
# monitor.sh - Monitor feature implementation progress

check_phase() {
    local phase=$1
    local test_file=$2
    
    if [ -f "$test_file" ]; then
        npm test "$test_file" --silent
        if [ $? -eq 0 ]; then
            echo "✅ Phase $phase: Tests passing"
        else
            echo "⚠️ Phase $phase: Tests failing (expected for TDD)"
        fi
    else
        echo "❌ Phase $phase: Not started"
    fi
}

echo "=== Feature Implementation Status ==="
check_phase 1 "test/models/user.test.js"
check_phase 2 "src/models/User.js"
check_phase 3 "test/integration/auth.test.js"
```
```

## Performance Specifications

### Execution Benchmarks
| Operation | Target | Maximum | Monitoring |
|-----------|--------|---------|------------|
| Plan generation | <10s | 30s | Agent response times |
| File writing | <2s | 5s | Disk I/O metrics |
| Agent deployment | <5s | 15s | Parallel execution tracking |
| Total execution | <20s | 45s | End-to-end timing |

### Resource Limits
```javascript
const RESOURCE_LIMITS = {
    maxAgents: 8,              // Maximum concurrent agents
    maxFileSize: 100_000,       // 100KB per file
    maxTotalSize: 1_000_000,    // 1MB total output
    maxPhases: 10,              // Maximum implementation phases
    maxFilesPerPhase: 15,       // Maximum files per phase
    timeoutSeconds: 45          // Total command timeout
};
```

## Agent Conflict Resolution

### Conflict Detection and Resolution
```javascript
function resolveAgentConflicts(opinions) {
    const conflicts = detectConflicts(opinions);
    
    if (conflicts.length === 0) {
        return mergeOpinions(opinions);
    }
    
    // Priority-based resolution
    const priorityOrder = [
        'security-auditor',     // Security always wins
        'principal-architect',  // Architecture decisions next
        'performance-specialist', // Performance considerations
        'test-engineer',        // Testing requirements
        'backend-engineer',     // Implementation details
        'frontend-architect'    // UI/UX decisions
    ];
    
    for (const conflict of conflicts) {
        const winner = priorityOrder.find(agent => 
            conflict.agents.includes(agent)
        );
        
        if (winner) {
            conflict.resolution = opinions[winner];
            conflict.reason = `${winner} has priority for ${conflict.type}`;
        } else {
            // Fall back to user clarification
            conflict.resolution = 'USER_CLARIFICATION_REQUIRED';
        }
    }
    
    return applyResolutions(opinions, conflicts);
}
```

## Security Configurations

### Environment Variables
```bash
# .env.example
NODE_ENV=development
JWT_PRIVATE_KEY_PATH=./keys/private.pem  # Generated, not stored
JWT_PUBLIC_KEY_PATH=./keys/public.pem    # Generated, not stored
JWT_EXPIRES_IN=24h
BCRYPT_ROUNDS=12                         # Production: 12-14
RATE_LIMIT_WINDOW=60000                  # 1 minute
RATE_LIMIT_MAX_ATTEMPTS=5
COOKIE_SECURE=true                        # Production only
COOKIE_SAMESITE=strict
```

### Key Generation Script
```bash
#!/bin/bash
# generate-keys.sh - Generate RSA keys for JWT signing

mkdir -p keys

# Generate private key
openssl genpkey -algorithm RSA -out keys/private.pem -pkeyopt rsa_keygen_bits:2048

# Generate public key
openssl rsa -pubout -in keys/private.pem -out keys/public.pem

# Set proper permissions
chmod 600 keys/private.pem
chmod 644 keys/public.pem

echo "✅ RSA keys generated in ./keys/"
```

## Command Integration

### Implementation Hook
```javascript
// Implementation in Claude Code command handler
async function handlePlanCommand(taskDescription) {
    const monitor = new PerformanceMonitor();
    
    try {
        monitor.start('total');
        
        // Step 1: Select agents
        monitor.start('agent_selection');
        const agents = selectAgents(taskDescription);
        monitor.end('agent_selection');
        
        // Step 2: Generate strategic plan
        monitor.start('strategic_planning');
        const strategicPlan = await generateStrategicPlan(
            taskDescription, 
            agents
        );
        monitor.end('strategic_planning');
        
        // Step 3: Generate tactical phases
        monitor.start('tactical_breakdown');
        const tacticalPhases = await generateTacticalPhases(
            strategicPlan,
            'principal-architect'
        );
        monitor.end('tactical_breakdown');
        
        // Step 4: Write files
        monitor.start('file_writing');
        const outputDir = await writeFiles(
            strategicPlan,
            tacticalPhases
        );
        monitor.end('file_writing');
        
        monitor.end('total');
        
        return {
            success: true,
            outputDir,
            metrics: monitor.getMetrics(),
            summary: generateSummary(strategicPlan, tacticalPhases)
        };
        
    } catch (error) {
        monitor.end('total');
        
        return {
            success: false,
            error: error.message,
            metrics: monitor.getMetrics(),
            rollback: getRollbackInstructions(error)
        };
    }
}
```

## Success Metrics

### Quality Gates
- ✅ All examples follow TDD (tests before implementation)
- ✅ Error handling comprehensive with specific error types
- ✅ Security vulnerabilities addressed (environment variables, validation)
- ✅ Performance specifications defined with measurable SLAs
- ✅ Rollback procedures documented for each phase
- ✅ Agent selection algorithm deterministic
- ✅ File cleanup strategy implemented
- ✅ Conflict resolution strategy defined
- ✅ Resource limits enforced
- ✅ Monitoring and observability built-in

## Real-World Considerations

### Common Reality Checks
- **Merge Conflicts**: Will happen, especially in Phase 2-3 PRs
- **Flaky Tests**: Add retry logic, don't assume tests always pass
- **External API Limits**: Rate limiting will affect integration tests
- **Review Delays**: Humans take time, add 24-48 hour buffer for reviews
- **Dependency Updates**: May break between PR creation and merge
- **CI/CD Queues**: Shared resources cause delays

### Deployment Strategy (Not Covered in PRs)
```javascript
// Add deployment phase after Phase 3
const deploymentPhase = {
    staging: {
        agent: 'devops',
        tasks: ['deploy', 'smoke-test', 'monitor'],
        time: '2-4 hours with rollback buffer'
    },
    production: {
        agent: 'devops',
        reviewers: ['principal-architect', 'incident-commander'],
        tasks: ['canary-deploy', 'monitor', 'full-deploy'],
        time: '4-8 hours with validation'
    }
};
```

## Notes

### PR-Based Implementation Strategy
- **One PR = One File**: Each PR gets its own dedicated markdown file with complete implementation details
- **PR Size**: Each PR is designed to be independently reviewable (typically 150-400 LOC)
- **Dependencies**: Clear dependency chain between PRs ensures proper merge order
- **Naming Convention**: `phase_<phase>.<pr>_<description>.md` for easy identification
- **Rollback Friendly**: Each PR can be independently reverted without breaking the system

### Agent Orchestration Within PRs
- **Principal-Architect**: Determines technical approach and suggests agent assignments for each task
- **Project-Orchestrator**: Optimizes task parallelization and identifies the critical path
- **Task Assignment**: Each task within a PR is assigned to a specific agent based on expertise
- **Parallel Execution**: Independent tasks run simultaneously, reducing total execution time by 40-60%
- **Dependencies Tracked**: Task-level dependencies ensure correct execution order
- **Time Optimization**: Shows both sequential and parallel execution times for transparency

### Core Principles
- **TDD Discipline**: Tests MUST be written before implementation code
- **Security First**: All examples use environment variables, never hardcoded values
- **Error Recovery**: Every operation has defined error handling and rollback
- **Performance**: Caching strategies and resource limits prevent system overload
- **Maintainability**: Clear phase separation enables incremental development
- **Production Ready**: Examples include monitoring, logging, and observability