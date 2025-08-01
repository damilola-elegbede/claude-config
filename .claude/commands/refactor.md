# /refactor Command

## Description
Orchestrates systematic code refactoring using multiple specialized agents working in parallel. Analyzes code for improvement opportunities, implements changes safely, and ensures quality through comprehensive testing and review cycles.

## Usage
```
/refactor <scope> [refactoring_type]
```

## Arguments
- `scope`: File path, directory, or component to refactor
- `refactoring_type` (optional): Specific refactoring pattern to apply

## Behavior
When you use `/refactor`, I will:

1. **Launch parallel analysis phase**:
   - **codebase-analyst**: Identify refactoring opportunities
   - **code-reviewer**: Assess current code quality
   - **test-engineer**: Evaluate test coverage
   - **performance-specialist**: Benchmark current performance

2. **Create refactoring plan** with:
   - Prioritized improvements
   - Risk assessment
   - Rollback strategy
   - Success metrics

3. **Execute refactoring in phases**:
   - Apply changes incrementally
   - Run tests after each phase
   - Validate performance impact
   - Ensure backwards compatibility

4. **Quality assurance**:
   - Comprehensive test execution
   - Performance comparison
   - Security validation
   - Documentation updates

## Refactoring Patterns

### Code Structure
- **Extract Method**: Break down large functions
- **Extract Class**: Separate concerns
- **Inline**: Remove unnecessary abstraction
- **Move**: Relocate code to appropriate modules

### Design Patterns
- **Strategy Pattern**: Replace conditionals
- **Factory Pattern**: Centralize object creation
- **Observer Pattern**: Decouple components
- **Dependency Injection**: Improve testability

### Performance
- **Memoization**: Cache expensive computations
- **Lazy Loading**: Defer initialization
- **Database Optimization**: Query improvements
- **Algorithm Replacement**: O(n²) → O(n log n)

### Modern Patterns
- **Async/Await**: Replace callback hell
- **Functional**: Immutable transformations
- **Reactive**: Stream-based processing
- **Microservices**: Monolith decomposition

## Examples
```bash
# Refactor entire module
/refactor src/auth/

# Specific pattern application
/refactor src/services/UserService.js extract-methods

# Performance-focused refactoring
/refactor src/api/endpoints/ optimize-queries

# Legacy code modernization
/refactor lib/legacy/ modernize
```

## Multi-Agent Orchestration

### Phase 1: Analysis (Parallel)
```
├── codebase-analyst → Code smell detection
├── test-engineer → Coverage analysis
├── performance-specialist → Bottleneck identification
└── security-auditor → Vulnerability assessment
```

### Phase 2: Planning
```
principal-architect → Refactoring strategy
└── All agents provide input
```

### Phase 3: Implementation (Parallel)
```
├── backend-engineer → Server-side changes
├── frontend-architect → Client-side updates
├── test-engineer → Test modifications
└── tech-writer → Documentation updates
```

### Phase 4: Validation
```
├── code-reviewer → Quality check
├── test-engineer → Regression testing
└── performance-specialist → Benchmark comparison
```

## Refactoring Metrics

### Before/After Comparison
- **Complexity**: Cyclomatic complexity reduction
- **Performance**: Response time improvements
- **Maintainability**: Code duplication elimination
- **Test Coverage**: Coverage percentage increase
- **Bundle Size**: Reduction for frontend code

### Success Criteria
- All tests pass (100%)
- No performance regression
- Improved code metrics
- Zero breaking changes
- Documentation updated

## Safety Features

### Incremental Changes
- Small, atomic commits
- Feature flag protection
- Canary deployments
- Quick rollback capability

### Validation Gates
- Pre-commit hooks
- CI/CD pipeline checks
- Peer review process
- Production monitoring

## Common Refactoring Scenarios

### Legacy Modernization
```bash
/refactor legacy-api/ modernize
# - Replace callbacks with promises/async
# - Update deprecated dependencies
# - Implement modern error handling
# - Add TypeScript definitions
```

### Performance Optimization
```bash
/refactor src/data-processing/ optimize
# - Implement caching strategies
# - Optimize database queries
# - Add pagination/streaming
# - Parallelize operations
```

### Architecture Improvement
```bash
/refactor src/ extract-microservices
# - Identify service boundaries
# - Extract shared libraries
# - Implement API contracts
# - Setup service communication
```

## Integration Points
- Version control (Git)
- CI/CD pipelines
- Code quality tools
- Performance monitoring
- Test frameworks

## Best Practices
- Always have tests before refactoring
- Refactor in small increments
- Maintain backwards compatibility
- Document architectural decisions
- Measure impact quantitatively

## Notes
- Supports all major languages
- Preserves git history
- Generates refactoring reports
- Handles cross-file dependencies