---
description: Analyze repository structure, dependencies, docs
argument-hint: [--lite|component-name]
---

# /prime Command

## Usage

```bash
/prime                          # Full comprehensive analysis with parallel agents
/prime --lite                   # Quick 2-second essential context
/prime authentication           # Deep component analysis with multi-instance
/prime api                      # Focused API architecture analysis
/prime "payment processing"     # Multi-instance component deep dive
```

## Description

Analyze repository structure, dependencies, and documentation to provide comprehensive project understanding.
Three modes: lite (quick), full (comprehensive), and focused (component-specific). Deploy parallel agents
for multi-instance analysis when needed.

## Expected Output

### Lite Mode Output (--lite, 2 seconds)

```text
## Quick Context: my-react-app

### Current Status
🌿 Branch: feature/user-authentication
📝 3 modified, 1 untracked file
📋 PR #42: "Add user authentication flow" (Open, all checks passing)

### Modified Files
- src/components/Login.tsx (modified)
- src/services/auth.ts (modified)
- tests/auth.test.ts (modified)
- src/types/user.ts (untracked)

### Project Purpose
Modern React task management app with real-time collaboration features

### Key Instructions
- Run tests before committing (npm test)
- TypeScript strict mode required
- Follow atomic commit practices
```

### Full Mode Output (default, parallel agents)

```text
## Repository Context: my-react-app

### Technology Stack
- **Language**: TypeScript 4.9
- **Framework**: React 18.2 with hooks
- **Build**: Vite 4.0 (fast HMR, ES modules)
- **Testing**: Jest + React Testing Library
- **Styling**: Tailwind CSS + CSS Modules
- **State**: Zustand for global state

### Project Structure
- `/src/components` - React components (atomic design)
- `/src/services` - API clients and business logic
- `/src/hooks` - Custom React hooks
- `/src/types` - TypeScript type definitions
- `/tests` - Unit and integration tests
- `/docs` - Architecture and API documentation

### Available Commands
- `npm run dev` - Start development server
- `npm run build` - Production build
- `npm test` - Run test suite
- `npm run lint` - ESLint + Prettier
- `npm run type-check` - TypeScript validation

### Key Dependencies
- React Query: Server state management
- React Router: Client-side routing
- Axios: HTTP client for API calls
- Zod: Runtime type validation

### Getting Started
1. `npm install` - Install dependencies
2. `cp .env.example .env` - Configure environment
3. `npm run dev` - Start development server
4. Open http://localhost:3000
```

### Focused Mode Output (component analysis)

```text
## Component Analysis: Authentication Service

### Architecture Assessment
✅ **Design Pattern**: JWT-based authentication with refresh tokens
✅ **Security**: Proper token storage in httpOnly cookies
⚠️  **Session Management**: No automatic cleanup of expired sessions

### Integration Points
- `/src/services/auth.ts` - Core authentication logic
- `/src/hooks/useAuth.ts` - React integration hook
- `/src/components/AuthGuard.tsx` - Route protection
- `/backend/auth` - Server-side authentication API

### Technical Debt
🔴 **High Priority**: Password reset flow incomplete
🟡 **Medium Priority**: Missing rate limiting on login attempts
🟢 **Low Priority**: Auth hooks could be optimized

### Recommendations
1. Implement proper session cleanup background task
2. Add comprehensive password reset workflow
3. Consider implementing OAuth providers for enhanced UX
4. Add audit logging for authentication events
```

## Behavior

### Analysis Modes

#### Lite Mode (--lite or -l) - 2 Second Analysis

**What it does**: Essential context without deep scanning

```yaml
Analysis Scope:
  - CLAUDE.md: Project instructions and configurations
  - README.md: Project overview and quick start
  - Git status: Current branch, modified files, commits
  - PR status: Active pull request details via gh CLI

Agent Usage: None (direct file reading only)

Output Format:
  - Current branch and status
  - Modified/staged files
  - Active PR information
  - Project purpose summary
  - Key development instructions
```

**Perfect for**: Quick orientation, status checks, minimal resource usage scenarios

#### Full Mode (default) - Parallel Multi-Agent Analysis

**What it does**: Comprehensive repository understanding with parallel agents

```yaml
Parallel Agent Deployment:
  codebase-analyst (Primary):
    - Technology stack detection
    - Architecture analysis
    - Dependency mapping
    - Code patterns identification

  tech-writer (Parallel):
    - Documentation inventory
    - README analysis
    - API docs scanning
    - Comment quality assessment

  business-analyst (Parallel):
    - Requirements extraction
    - Feature identification
    - Business logic mapping
    - User story detection

Parallel Analysis Benefits:
  - All agents analyze simultaneously
  - 5x faster than sequential analysis
  - Multiple perspectives on codebase
  - Comprehensive understanding in 3-5 seconds

Analysis Scope:
  Technology Stack:
    - Package managers: package.json, requirements.txt, go.mod, Cargo.toml
    - Build configs: webpack, vite, tsconfig, babel
    - CI/CD: .github/workflows, .gitlab-ci.yml
    - Dev tools: .eslintrc, .prettierrc, jest.config

  Project Structure:
    - Directory mapping and purposes
    - Entry points identification
    - Module organization
    - Asset locations

  Documentation:
    - README analysis
    - API documentation scanning
    - Architecture decisions
    - Available scripts/commands

Output Format:
  - Complete technology stack
  - Directory structure with explanations
  - Available commands and scripts
  - Key dependencies and purposes
  - Recent development activity
  - Getting started instructions
```

**Perfect for**: New repository exploration, comprehensive project onboarding, technology stack identification

#### Focused Mode (<component>) - Multi-Instance Component Analysis

**What it does**: Deep component analysis using multiple agent instances

```yaml
Analysis Types:
  Architecture: "authentication service", "api architecture"
  Performance: "database queries", "frontend performance"
  Quality: "technical debt", "code quality"
  Security: "vulnerability assessment", "security review"

Multi-Instance Agent Deployment:
  codebase-analyst (instance pool):
    deployment: 3-5 instances for comprehensive component analysis
    calculation: min(5, complexity_of_component)
    distribution:
      - instance_1: File structure and organization analysis
      - instance_2: Dependency graph and integration mapping
      - instance_3: Code patterns and anti-pattern detection
      - instance_4: Performance bottleneck identification
      - instance_5: Technical debt and refactoring assessment
    parallel_execution: All aspects analyzed simultaneously

  specialized_agents:
    - security-auditor: For security-focused analysis
    - performance-engineer: For performance components
    - api-architect: For API architecture analysis
    parallel_with: [codebase-analyst instances]

Output Format:
  - Multi-perspective component analysis
  - Integration points from all instances
  - Consolidated technical debt report
  - Prioritized refactoring opportunities
  - Risk analysis from multiple angles
  - Executive summary with key findings

Performance Impact:
  - Sequential: 1-2 minutes for deep analysis
  - Multi-instance: 15-20 seconds (4-6x faster)
  - Comprehensive coverage: Multiple perspectives in parallel
```

### Execution Strategies

#### Multi-Instance Deployment Patterns

```yaml
Component Analysis with Instance Pools:
  "authentication" / "auth":
    agents: codebase-analyst (3 instances) + security-auditor
    focus: Authentication flow, session management, security assessment

  "database" / "data":
    agents: codebase-analyst (4 instances)
    focus: Schema design, query patterns, performance, data integrity

  "api" / "endpoints":
    agents: codebase-analyst (3 instances) + api-architect
    focus: Endpoint structure, request/response patterns, integration points

  "frontend" / "ui":
    agents: codebase-analyst (4 instances)
    focus: Component architecture, state management, performance, UI consistency

  "performance":
    agents: codebase-analyst (3 instances) + performance-engineer
    focus: Code bottlenecks, database performance, frontend optimization

  "security":
    agents: codebase-analyst (2 instances) + security-auditor
    focus: Vulnerability patterns, dependency security, comprehensive audit
```

#### Repository Size Strategy

- **Small repos** (<100 files): Direct analysis without agent overhead
- **Medium repos** (100-1000 files): Selective agent deployment
- **Large repos** (>1000 files): Full parallel agent deployment

### Performance & Optimization

#### Mode Comparison

| Mode | Duration | Resource Usage | Agent Deployment | Use Case |
|------|----------|----------------|------------------|----------|
| Lite | <2 seconds | Minimal | None | Quick status checks |
| Full | <5 seconds | Moderate | Large repos only | Project onboarding |
| Focused | 15-20 sec | Moderate-High | 3-5 instances | Deep component analysis |

#### Caching Strategy

Results cached for 1 hour based on git HEAD + date. Prevents repeated analysis of unchanged code
and improves performance for frequent context checks.

### Usage Examples

#### Quick Status Check

```text
User: /prime --lite
Claude: 📖 Reading essential files...
## Quick Context: ecommerce-api
🌿 Branch: fix/payment-gateway (2 modified files)
📋 No active PR
🎯 Node.js/Express API for ecommerce platform
```

#### New Repository Exploration

```text
User: /prime
Claude: 🔍 Analyzing repository structure...
📊 Detected: Python/Django project (127 files)
✅ Technology stack identified
📝 Generating comprehensive context report...
[Full analysis output]
```

#### Component Deep Dive with Multi-Instance

```text
User: /prime payment processing
Claude: 🎯 Deploying multi-instance analyzers for payment processing...
📊 Instance Pool Status:
  - codebase-analyst[1]: Analyzing payment flow architecture...
  - codebase-analyst[2]: Mapping payment provider integrations...
  - codebase-analyst[3]: Identifying security vulnerabilities...
  - codebase-analyst[4]: Assessing performance bottlenecks...
  - security-auditor: Running PCI compliance checks...

⚡ Parallel Analysis Results (18 seconds):
🔍 Found 3 payment providers with 7 integration points
🔒 Identified 2 critical security improvements needed
⚠️ Performance: 2 bottlenecks in payment processing
📈 Technical debt: 4 refactoring opportunities

[Comprehensive multi-perspective analysis output]
✅ Analysis 4.8x faster with parallel instances
```

### Notes

- Auto-executes on Claude Code startup (disable with `.claude/noautoprime`)
- **Multi-Instance Focused Mode**: 3-5 instances analyze components in parallel
- **Performance Improvement**: 15-20 seconds for deep analysis (was 1-2 minutes)
- Works with any programming language or framework
- Results tailored to repository type and size
- Agent deployment optimized based on repository complexity
- Caching prevents repeated analysis of unchanged code
