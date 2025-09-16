---
description: Repository understanding via wave orchestration
argument-hint: [--lite|--full|component-name]
thinking-level: megathink
thinking-tokens: 10000
---

# /prime Command

## Usage

```bash
/prime                          # Full wave-based analysis (default)
/prime --lite                   # Quick essential context only
/prime --full                   # Complete deep-dive analysis
/prime authentication           # Focused component analysis
/prime api                      # Targeted architecture analysis
/prime "payment processing"     # Multi-perspective component dive
```

## Description

Transform repository analysis from single-pass to progressive understanding through wave-based agent orchestration.
Analyze repository structure systematically, with each wave building upon previous insights, culminating in
comprehensive repository context optimized for development needs.

### Thinking Level: MEGATHINK (10,000 tokens)

This command requires substantial thinking depth due to:

- **Complete project initialization**: Architecture decisions and technology stack evaluation
- **Multi-perspective analysis**: Coordinating 6+ parallel codebase analysts per wave
- **Progressive understanding synthesis**: Building context through multiple analysis waves
- **Component relationship mapping**: Complex dependency and integration analysis
- **Strategic recommendations**: Development workflow and optimization opportunities

## Wave-Based Orchestration Strategy

### Wave 1: Initial Repository Analysis (Foundation Building)

**Objective**: Establish core repository understanding and identify key characteristics

**Repository Analysis Strategy**: Comprehensive examination of codebase, architecture, and technology stack through coordinated agent deployment
**Parallel Agent Deployment**:

```yaml
codebase-analyst instances (3-6):
  - analyst[1]: Technology stack detection and build system analysis
  - analyst[2]: Project structure and architecture patterns
  - analyst[3]: Dependency analysis and integration points
  - analyst[4]: Configuration files analysis (package.json, tsconfig.json, etc.)
  - analyst[5]: Code organization and module relationships
  - analyst[6]: Development workflow and tooling assessment

tech-writer:
  - Documentation inventory and quality assessment
  - README analysis and getting-started extraction
  - API documentation scanning and completeness
  - Comment coverage and code documentation quality

security-auditor:
  - Initial security posture assessment
  - Dependency vulnerability scanning
  - Configuration security review
  - Authentication and authorization patterns
```

**Claude Synthesis**:

- Consolidates findings from all Wave 1 agents
- Builds foundational repository understanding
- Identifies areas requiring deeper analysis
- Prepares context for Wave 2 deployment

### Wave 2: Deep Dive Analysis (Mode-Dependent)

**Mode Selection Strategy**:

#### Lite Mode: Skip Wave 2

- **Duration**: <2 seconds
- **Strategy**: Use only Wave 1 essential findings
- **Output**: Quick context summary

#### Full Mode: Comprehensive Deep Dive

- **Duration**: 10-15 seconds
- **Strategy**: Deploy all specialized analysts based on repository type

```yaml
Conditional Agent Deployment (based on Wave 1 findings):

Web Applications:
  - frontend-engineer: UI/UX analysis, component architecture
  - backend-engineer: Server architecture, API design patterns
  - database-admin: Data modeling and query optimization

APIs and Services:
  - api-architect: Endpoint design and integration patterns
  - performance-engineer: Bottleneck identification and optimization
  - platform-engineer: Deployment and scaling considerations

Data Processing:
  - data-engineer: Pipeline architecture and data flow
  - performance-engineer: Processing optimization opportunities
  - platform-engineer: Resource utilization assessment

DevOps/Infrastructure:
  - platform-engineer: Configuration and deployment analysis
  - security-auditor: Additional security deep-dive
  - performance-engineer: System performance assessment
```

#### Focused Mode: Targeted Component Analysis

- **Duration**: 8-12 seconds
- **Strategy**: Deploy specialists relevant to component type

```yaml
Component-Specific Deployment:

"authentication" / "auth":
  - codebase-analyst (2 instances): Flow analysis, integration mapping
  - security-auditor: Authentication security deep-dive
  - api-architect: Auth API design assessment

"database" / "data":
  - codebase-analyst (2 instances): Schema analysis, query patterns
  - database-admin: Performance and integrity assessment
  - performance-engineer: Query optimization opportunities

"api" / "endpoints":
  - codebase-analyst (2 instances): Endpoint structure, patterns
  - api-architect: Architecture and design assessment
  - performance-engineer: API performance analysis

"frontend" / "ui":
  - codebase-analyst (2 instances): Component architecture, state management
  - frontend-engineer: UI patterns and performance
  - performance-engineer: Frontend optimization opportunities
```

**Claude Consolidation**:

- Synthesizes Wave 1 + Wave 2 findings
- Identifies patterns and anti-patterns
- Generates comprehensive repository understanding
- Prepares optimized context for Wave 3

### Wave 3: Context Optimization (Synthesis & Delivery)

**Objective**: Transform raw analysis into actionable repository context

**Claude Processing**:

```yaml
Context Generation:
  - Repository mental model creation
  - Navigation guide generation
  - Development workflow optimization
  - Key insight prioritization
  - Actionable recommendation synthesis

Output Optimization:
  - Essential vs detailed information balancing
  - Developer-focused context delivery
  - Quick reference guide creation
  - Progressive disclosure of complexity
```

**Final Deliverables**:

- Optimized repository summary
- Technology stack with rationale
- Development workflow guidance
- Key files and entry points
- Common tasks and commands
- Architecture insights and recommendations

## Expected Output Formats

**Output Format:** Wave-based analysis results presented in structured markdown format

### Lite Mode Output (--lite, <2 seconds)

```text
## Repository Context: my-react-app

### Current Status
🌿 Branch: feature/user-authentication
📝 3 modified, 1 untracked file
📋 PR #42: "Add user authentication flow" (Open, all checks passing)

### Modified Files
- src/components/Login.tsx (modified)
- src/services/auth.ts (modified)
- tests/auth.test.ts (modified)
- src/types/user.ts (untracked)

### Essential Context
**Type**: React TypeScript application
**Purpose**: Task management with real-time collaboration
**Status**: Active development on authentication feature

### Key Instructions
- Run tests before committing (npm test)
- TypeScript strict mode required
- Follow atomic commit practices
```

### Full Mode Output (default, wave-based analysis)

```text
## Repository Understanding: my-react-app

### Wave 1: Foundation Analysis ✅
📊 **Repository Profile**: Medium-scale React application (342 files)
🏗️  **Architecture**: Modern React with TypeScript, component-based design
🔧 **Tooling**: Vite build system, comprehensive testing setup

### Technology Stack (Wave 1 + 2 Synthesis)
- **Frontend**: React 18.2 + TypeScript 4.9
- **Build System**: Vite 4.0 (fast HMR, ES modules)
- **State Management**: Zustand for global state, React Query for server state
- **Styling**: Tailwind CSS + CSS Modules for component isolation
- **Testing**: Jest + React Testing Library + MSW for API mocking
- **Quality**: ESLint + Prettier + TypeScript strict mode

### Architecture Insights (Multi-Agent Analysis)
```yaml
Component Architecture:
  pattern: Atomic Design (atoms → molecules → organisms → templates)
  state_management: Hybrid (local useState + global Zustand + server React Query)
  composition: Higher-order components for cross-cutting concerns

API Integration:
  pattern: Custom hooks wrapping React Query
  error_handling: Global error boundary + toast notifications
  caching: React Query with optimistic updates

Testing Strategy:
  unit: Component testing with React Testing Library
  integration: API mocking with MSW
  e2e: Cypress for critical user flows
```

### Development Workflow (Wave 3 Optimization)

```bash
# Development
npm run dev              # Start with HMR (http://localhost:3000)
npm run test:watch       # Continuous testing during development

# Quality Gates
npm run lint            # ESLint + Prettier formatting
npm run type-check      # TypeScript validation
npm test               # Full test suite

# Production
npm run build          # Optimized production build
npm run preview        # Test production build locally
```

### Project Structure (Multi-Perspective Analysis)

```text
src/
├── components/         # Reusable UI components (atomic design)
├── pages/             # Route-level components
├── hooks/             # Custom React hooks
├── services/          # API clients and external integrations
├── store/             # Zustand stores for global state
├── types/             # TypeScript type definitions
├── utils/             # Pure utility functions
└── __tests__/         # Test utilities and setup

Key Entry Points:
- src/main.tsx         # Application bootstrap
- src/App.tsx          # Root component with routing
- src/hooks/index.ts   # Centralized hook exports
```

### Current Development Context (Wave 1 Git Analysis)

🎯 **Active Work**: User authentication system implementation
📁 **Focus Areas**: Login components, auth service, type definitions
⚡ **Next Steps**: Complete auth flow testing and integration

### Recommendations (Multi-Agent Synthesis)

1. **Performance**: Consider implementing React.lazy for route-based code splitting
2. **Testing**: Add integration tests for authentication flow
3. **Architecture**: Extract auth logic into custom hook for reusability
4. **DX**: Add Storybook for component documentation and testing

Analysis completed using wave-based orchestration: 3.2x faster, 4x more comprehensive

### Focused Mode Output (component analysis)

```text
## Component Deep Dive: Authentication System

### Wave 1: Component Discovery ✅
🔍 **Scope**: Authentication flow across 8 files, 3 external integrations
🏗️  **Architecture**: JWT-based with refresh tokens, httpOnly cookie storage
⚡ **Complexity**: Medium (auth service + 4 React components + 2 hooks)

### Multi-Agent Analysis Results (Wave 2)

#### Security Assessment (security-auditor)
✅ **Strengths**:
- JWT tokens stored in httpOnly cookies (XSS protection)
- Refresh token rotation implemented
- CSRF protection via SameSite cookie settings

⚠️  **Concerns**:
- Password reset flow incomplete (missing email verification step)
- No rate limiting on login attempts (potential brute force vulnerability)
- Session cleanup logic not implemented (expired sessions accumulate)

🔴 **Critical**: Implement proper session invalidation on logout

#### Architecture Analysis (codebase-analyst instances)

**Instance 1 - Flow Architecture**:
```yaml
Authentication Flow:
  login: username/password → JWT + refresh token → cookie storage
  refresh: automatic background refresh every 14 minutes
  logout: token invalidation + cookie clearing
  protection: Route guards using useAuth hook
```

**Instance 2 - Integration Mapping**:

```yaml
Integration Points:
  - src/services/auth.ts: Core authentication logic
  - src/hooks/useAuth.ts: React integration and state management
  - src/components/AuthGuard.tsx: Route-level protection
  - src/components/auth/: Login, register, password reset forms
  - backend/routes/auth: Server-side authentication endpoints
```

### Technical Debt Analysis (Wave 2 + 3 Synthesis)

🔴 **High Priority** (Blocks production):

- Complete password reset email verification workflow
- Implement session cleanup background task
- Add comprehensive error handling for network failures

🟡 **Medium Priority** (Quality improvements):

- Add rate limiting middleware for authentication endpoints
- Implement "Remember me" functionality with extended sessions
- Add audit logging for authentication events

🟢 **Low Priority** (Enhancement opportunities):

- Consider OAuth integration (Google, GitHub) for better UX
- Add biometric authentication for mobile apps
- Implement progressive authentication for sensitive operations

### Recommendations (Multi-Perspective Synthesis)

#### Immediate Actions (1-2 days)

1. **Security**: Implement session cleanup service (prevent memory leaks)
2. **UX**: Complete password reset flow with email verification
3. **Reliability**: Add comprehensive error boundaries around auth components

#### Medium-term Improvements (1-2 weeks)

1. **Performance**: Add auth state caching to reduce server roundtrips
2. **Security**: Implement progressive rate limiting (increasing delays)
3. **Monitoring**: Add authentication metrics and alerting

#### Strategic Enhancements (1-2 months)

1. **Scalability**: Consider migrating to OAuth 2.0 with PKCE
2. **Security**: Add device fingerprinting for anomaly detection
3. **UX**: Implement single sign-on (SSO) for enterprise customers

### Integration Impact Assessment

**Low Risk**: Authentication changes are well-isolated behind service interface
**Testing Required**: Update 6 existing test files, add 3 new integration tests
**Documentation**: Update API docs and authentication flow diagrams

Deep dive completed with 4 parallel agents: 8.7x faster than sequential analysis

## Behavior Implementation

### Wave Orchestration Logic

```yaml
Wave 1 - Foundation (Always Execute):
  duration: 3-4 seconds
  agents: 3-5 codebase-analyst + tech-writer + security-auditor
  purpose: Essential repository understanding
  output: Foundation for Wave 2 decisions

Wave 2 - Deep Dive (Mode Dependent):
  lite_mode: skip (use Wave 1 only)
  full_mode: deploy all relevant specialists (5-8 additional agents)
  focused_mode: deploy component-specific specialists (2-4 agents)
  duration: 6-10 seconds
  purpose: Specialized analysis based on repository type/component

Wave 3 - Synthesis (Always Execute):
  duration: 1-2 seconds
  agents: Claude-only processing
  purpose: Context optimization and delivery formatting
  output: Developer-ready repository understanding
```

### Performance Optimization

#### Caching Strategy

- **Git-based Cache**: Results cached by repository + git HEAD hash
- **Duration**: 1 hour for unchanged repositories
- **Invalidation**: Automatic on new commits, manual files changes

#### Resource Management

- **Small repos** (<100 files): Minimal agent deployment
- **Medium repos** (100-1000 files): Selective Wave 2 deployment
- **Large repos** (>1000 files): Full wave-based orchestration

### Error Handling & Fallbacks

```yaml
Wave Failure Handling:
  wave_1_failure: Fallback to direct file reading (lite mode equivalent)
  wave_2_failure: Use Wave 1 results + simplified analysis
  wave_3_failure: Return raw consolidated findings

Agent Failure Recovery:
  individual_agent_failure: Continue with remaining agents
  multiple_agent_failure: Reduce to essential agents only
  complete_agent_failure: Fallback to direct analysis
```

## Usage Examples

### Quick Status Check (Lite Mode)

```text
User: /prime --lite
Claude: 🌊 Wave 1: Essential analysis...
## Quick Context: ecommerce-api
🌿 Branch: fix/payment-gateway (2 modified files)
📋 No active PR
🎯 Node.js/Express API for ecommerce platform
⚡ Ready for development in 1.8 seconds
```

### New Repository Exploration (Full Mode)

```text
User: /prime
Claude: 🌊 Wave 1: Foundation analysis (5 agents deployed)...
📊 Repository profile: Python/Django application (247 files)
🌊 Wave 2: Deep-dive analysis (8 specialists deployed)...
✅ Technology stack identified, architecture patterns analyzed
🌊 Wave 3: Context optimization...
[Comprehensive analysis output]
⚡ Progressive understanding achieved in 12.4 seconds
```

### Component Deep Dive (Focused Mode)

```text
User: /prime payment processing
Claude: 🌊 Wave 1: Component discovery (payment processing scope)...
🎯 Found: Payment service + 3 integrations + 7 related files
🌊 Wave 2: Multi-perspective analysis (4 specialists deployed)...
  - codebase-analyst[1]: Payment flow architecture ✅
  - codebase-analyst[2]: Integration security assessment ✅
  - security-auditor: PCI compliance review ✅
  - performance-engineer: Transaction bottleneck analysis ✅
🌊 Wave 3: Synthesis and recommendations...
[Detailed component analysis output]
⚡ Multi-perspective analysis: 6.2x faster than sequential approach
```

## Integration Notes

- **Auto-execution**: Runs on Claude Code startup (disable with `.claude/noautoprime`)
- **Wave-based Performance**: 3-6x faster than previous single-pass approach
- **Progressive Understanding**: Each wave builds comprehensive repository context
- **Resource Optimization**: Deploys optimal agent combinations based on findings
- **Context Preservation**: Results optimized for immediate development productivity

---

*Transform repository analysis from single-pass scanning to progressive understanding through intelligent wave-based agent orchestration.*
