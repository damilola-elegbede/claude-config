# /context Command

## Description

Analyzes repository structure, dependencies, and documentation to provide
comprehensive project understanding. Three modes: lite (quick), full
(comprehensive), and focused (component-specific).

## Usage

```bash
/context                     # Full repository analysis
/context --lite              # Quick essential context only  
/context <component>         # Focused component analysis
```

## Behavior

When invoked, I will analyze the repository structure, dependencies, and documentation
to provide comprehensive project understanding. The analysis adapts based on the
chosen mode: lite for quick overview, full for comprehensive analysis, or focused
for specific components.

## Analysis Modes

### Lite Mode (--lite) - 2 Second Analysis

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

**Perfect for**:

- Quick orientation when switching tasks
- Status checks without full analysis
- Minimal resource usage scenarios

### Full Mode (default) - 5 Second Analysis

**What it does**: Comprehensive repository understanding

```yaml
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

Agent Usage: codebase-analyst (for large repos >1000 files)

Output Format:
  - Complete technology stack
  - Directory structure with explanations
  - Available commands and scripts
  - Key dependencies and purposes
  - Recent development activity
  - Getting started instructions
```

**Perfect for**:

- New repository exploration
- Comprehensive project onboarding
- Technology stack identification

### Focused Mode (<component>) - Variable Duration

**What it does**: Deep component analysis using codebase-analyst

```yaml
Analysis Types:
  Architecture: "authentication service", "api architecture"
  Performance: "database queries", "frontend performance"
  Quality: "technical debt", "code quality"
  Security: "vulnerability assessment", "security review"

Agent Deployment: 
  - Single codebase-analyst for specific focus
  - Multiple codebase-analyst instances for complex analysis
  - Coordinated parallel execution for comprehensive coverage

Output Format:
  - Component-specific design patterns
  - Integration points and dependencies
  - Technical debt assessment
  - Refactoring opportunities
  - Risk analysis
  - Executive summary
```

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
```

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
```

### Focused Mode Agent Deployment

```yaml
Component Analysis Patterns:
  "authentication" / "auth": 
    agent: codebase-analyst
    focus: Security patterns, authentication flows, session management
    
  "database" / "data":
    agent: codebase-analyst  
    focus: Schema design, query patterns, performance optimization
    
  "api" / "endpoints":
    agent: codebase-analyst
    focus: API design, endpoint analysis, integration patterns
    
  "frontend" / "ui":
    agent: codebase-analyst
    focus: Component architecture, state management, performance
    
  "performance":
    agent: codebase-analyst
    focus: Bottleneck identification, optimization opportunities
    
  "security":
    agent: codebase-analyst
    focus: Vulnerability assessment, security patterns
```

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
```

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
```

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
```

## Performance & Optimization

### Mode Comparison

| Mode | Duration | Resource Usage | Agent Deployment | Use Case |
|------|----------|----------------|------------------|----------|
| Lite | <2 seconds | Minimal | None | Quick status checks |
| Full | <5 seconds | Moderate | Large repos only | Project onboarding |
| Focused | Variable | Moderate-High | Always | Deep component analysis |

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
```

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
```

### New Repository Exploration  

```bash
User: /context
Claude: 🔍 Analyzing repository structure...
📊 Detected: Python/Django project (127 files)
✅ Technology stack identified
📝 Generating comprehensive context report...
[Full analysis output]
```

### Component Deep Dive

```bash
User: /context payment processing
Claude: 🎯 Deploying codebase-analyst for payment processing analysis...
🔍 Analyzing payment flows, security patterns, and integration points...
📊 Found 3 payment providers, identified 2 security improvements...
[Focused analysis output]
```

## Notes

- Auto-executes on Claude Code startup (disable with `.claude/noautocontext`)
- Works with any programming language or framework
- Results tailored to repository type and size
- Agent deployment optimized based on repository complexity
- Caching prevents repeated analysis of unchanged code
