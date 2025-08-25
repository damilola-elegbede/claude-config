# /context Command

## Description

Analyzes repository structure, dependencies, and documentation to provide
comprehensive project understanding. Three modes: lite (quick), full
(comprehensive), and focused (component-specific).

## Usage

```bash
/context                     # Full repository analysis
/context --lite              # Quick essential context only
/context -l                  # Quick essential context only (short form)
/context <component>         # Focused component analysis
```bash

## Behavior

When invoked, I will analyze the repository structure, dependencies, and documentation
to provide comprehensive project understanding. In focused mode, I deploy 3-5
codebase-analyst instances to analyze different aspects of components simultaneously,
achieving 4-6x faster analysis than single-agent approaches.

## Analysis Modes

### Lite Mode (--lite or -l) - 2 Second Analysis

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
```bash

**Perfect for**:

- Quick orientation when switching tasks
- Status checks without full analysis
- Minimal resource usage scenarios

### Full Mode (default) - Parallel Multi-Agent Analysis

**What it does**: Comprehensive repository understanding with parallel agents

```yaml
Parallel Agent Deployment:
  codebase-analyst (Primary):
    - Technology stack detection
    - Architecture analysis
    - Dependency mapping
    - Code patterns identification

  test-engineer:
    - Test framework identification
    - Test coverage analysis
    - Quality gate detection
    - Testing strategy assessment

  debugger:
    - Error pattern identification
    - Debugging setup analysis
    - Common issue detection
    - Debug tool configuration

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

Agent Usage: codebase-analyst + tech-writer + business-analyst (parallel)

Output Format:
  - Complete technology stack
  - Directory structure with explanations
  - Available commands and scripts
  - Key dependencies and purposes
  - Recent development activity
  - Getting started instructions
```bash

**Perfect for**:

- New repository exploration
- Comprehensive project onboarding
- Technology stack identification

### Focused Mode (<component>) - Multi-Instance Component Analysis

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
```bash

## Execution Strategies

### Lite Mode Execution

```bash
# Essential file reading (no agents)
read_essential_files() {
  # Project instructions
  cat CLAUDE.md 2>/dev/null || echo "No CLAUDE.md found"

  # Project overview
  head -50 README.md 2>/dev/null || echo "No README.md found"

  # Git context
  git status --porcelain
  git log --oneline -5
  git branch --show-current

  # PR status
  gh pr status 2>/dev/null || echo "No active PR"
}
```bash

### Full Mode Execution

```bash
# Repository analysis with optional agent support
analyze_repository() {
  # Count files to determine strategy
  file_count=$(find . -type f -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.go" -o -name "*.rs" -o -name "*.java" | wc -l)

  if [ "$file_count" -gt 1000 ]; then
    echo "Large repository detected. Deploying codebase-analyst..."
    # Deploy agent for comprehensive analysis
  else
    echo "Medium repository. Direct analysis..."
    # Analyze directly without agent overhead
  fi
}
```bash

### Focused Mode Multi-Instance Deployment

```yaml
Component Analysis with Instance Pools:
  "authentication" / "auth":
    agents: codebase-analyst (3 instances) + security-auditor
    instance_distribution:
      - instance_1: Authentication flow analysis
      - instance_2: Session management patterns
      - instance_3: Security vulnerability assessment
      - security-auditor: Compliance and best practices

  "database" / "data":
    agents: codebase-analyst (4 instances)
    instance_distribution:
      - instance_1: Schema design analysis
      - instance_2: Query pattern optimization
      - instance_3: Index and performance analysis
      - instance_4: Data integrity and constraints

  "api" / "endpoints":
    agents: codebase-analyst (3 instances) + api-architect
    instance_distribution:
      - instance_1: Endpoint structure analysis
      - instance_2: Request/response patterns
      - instance_3: Integration point mapping
      - api-architect: API design and standards

  "frontend" / "ui":
    agents: codebase-analyst (4 instances)
    instance_distribution:
      - instance_1: Component architecture
      - instance_2: State management patterns
      - instance_3: Performance optimization
      - instance_4: UI/UX consistency

  "performance":
    agents: codebase-analyst (3 instances) + performance-engineer
    instance_distribution:
      - instance_1: Code-level bottlenecks
      - instance_2: Database query performance
      - instance_3: Frontend rendering analysis
      - performance-engineer: System-wide optimization

  "security":
    agents: codebase-analyst (2 instances) + security-auditor
    instance_distribution:
      - instance_1: Code vulnerability patterns
      - instance_2: Dependency security analysis
      - security-auditor: Comprehensive security audit
```bash

## Output Examples

### Lite Mode Output

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
```bash

### Full Mode Output

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
```bash

### Focused Mode Output

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
```bash

## Performance & Optimization

### Mode Comparison

| Mode | Duration | Resource Usage | Agent Deployment | Use Case |
|------|----------|----------------|------------------|----------|
| Lite | <2 seconds | Minimal | None | Quick status checks |
| Full | <5 seconds | Moderate | Large repos only | Project onboarding |
| Focused | 15-20 sec | Moderate-High | 3-5 instances | Deep component analysis |

### Caching Strategy

```bash
# Cache results for repeated analysis
cache_key="context_$(git rev-parse HEAD)_$(date +%Y%m%d)"
cache_file=".cache/$cache_key.json"

if [ -f "$cache_file" ] && [ $(($(date +%s) - $(stat -c %Y "$cache_file"))) -lt 3600 ]; then
  echo "Using cached analysis..."
  cat "$cache_file"
else
  echo "Performing fresh analysis..."
  # Run analysis and cache results
fi
```bash

## Execution Verification

Deploy execution-evaluator to verify:

- ✅ **Mode executed correctly** - Lite/Full/Focused ran as expected
- ✅ **Essential files read** - Key project files were analyzed
- ✅ **Technology stack identified** - Languages and frameworks detected
- ✅ **Agent coordination** - codebase-analyst deployed when appropriate
- ✅ **Output format consistent** - Report follows expected structure
- ✅ **Timely completion** - Analysis completed within performance targets

## Examples

### Quick Status Check

```bash
User: /context --lite
Claude: 📖 Reading essential files...
## Quick Context: ecommerce-api
🌿 Branch: fix/payment-gateway (2 modified files)
📋 No active PR
🎯 Node.js/Express API for ecommerce platform
```bash

### New Repository Exploration

```bash
User: /context
Claude: 🔍 Analyzing repository structure...
📊 Detected: Python/Django project (127 files)
✅ Technology stack identified
📝 Generating comprehensive context report...
[Full analysis output]
```bash

### Component Deep Dive with Multi-Instance

```bash
User: /context payment processing
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
```bash

## Notes

- Auto-executes on Claude Code startup (disable with `.claude/noautocontext`)
- **Multi-Instance Focused Mode**: 3-5 instances analyze components in parallel
- **Performance Improvement**: 15-20 seconds for deep analysis (was 1-2 minutes)
- Works with any programming language or framework
- Results tailored to repository type and size
- Agent deployment optimized based on repository complexity
- Caching prevents repeated analysis of unchanged code
