# /deps Command

## Description
Unified dependency management across all package managers and languages. Handles updates, security scanning, license compliance, and cross-project dependency synchronization with intelligent version conflict resolution.

## Usage
```
/deps <action> [options]
```

## Actions
- `install`: Install dependencies across all detected package managers
- `update`: Update dependencies with safety checks
- `audit`: Security vulnerability scanning
- `clean`: Remove unused dependencies
- `sync`: Synchronize versions across monorepo
- `analyze`: Dependency graph and usage analysis

## Behavior
When you use `/deps`, I will:

1. **Detect all package managers**:
   - npm/yarn/pnpm (package.json)
   - pip/poetry (requirements.txt/pyproject.toml)
   - maven/gradle (pom.xml/build.gradle)
   - cargo (Cargo.toml)
   - go mod (go.mod)
   - bundler (Gemfile)

2. **Coordinate specialist agents**:
   - **supply-chain-security-engineer**: Vulnerability assessment
   - **backend-engineer**: Impact analysis
   - **devops**: CI/CD integration
   - **codebase-analyst**: Usage detection

3. **Execute requested action**:
   - Parallel execution where possible
   - Intelligent conflict resolution
   - Automated testing after changes
   - Rollback on failure

## Examples
```bash
# Install all dependencies
/deps install

# Update with security audit
/deps update --audit --interactive

# Clean unused dependencies
/deps clean --aggressive

# Sync monorepo versions
/deps sync --strategy=highest

# Security vulnerability scan
/deps audit --fix --force
```

## Advanced Features

### Cross-Language Dependency Management
```bash
/deps install --parallel
# Detects and runs:
# - npm install
# - pip install -r requirements.txt
# - go mod download
# - cargo build
```

### Intelligent Updates
```bash
/deps update --smart
# - Respects semver ranges
# - Runs tests after each update
# - Rolls back breaking changes
# - Creates PR with changes
```

### Security-First Approach
```bash
/deps audit --comprehensive
# - CVE database scanning
# - License compliance checking
# - Dependency confusion attacks
# - Typosquatting detection
```

### Monorepo Synchronization
```bash
/deps sync --workspace
# - Detects all workspaces
# - Identifies version conflicts
# - Proposes resolution strategy
# - Updates all package files
```

## Dependency Strategies

### Version Resolution
- **Highest**: Use newest compatible version
- **Lowest**: Use oldest compatible version
- **Pinned**: Exact versions only
- **Range**: Flexible within semver

### Update Policies
- **Conservative**: Patch updates only
- **Balanced**: Minor updates allowed
- **Aggressive**: Major updates included
- **Security**: Security patches only

### Conflict Resolution
- **Interactive**: Prompt for decisions
- **Automatic**: Use predefined rules
- **Conservative**: Keep existing
- **Force**: Override conflicts

## Multi-Agent Coordination

### Security Audit Flow
```
├── supply-chain-security-engineer → Vulnerability scan
├── codebase-analyst → Usage analysis
├── test-engineer → Impact testing
└── backend-engineer → Fix implementation
```

### Update Flow
```
├── All package managers detected
├── Parallel update execution
├── Test suite validation
└── Rollback on failure
```

## Package Manager Support

### JavaScript/TypeScript
- **npm**: package.json, package-lock.json
- **yarn**: yarn.lock (v1, v2, v3)
- **pnpm**: pnpm-lock.yaml
- **Workspace**: Lerna, Nx, Rush

### Python
- **pip**: requirements.txt
- **poetry**: pyproject.toml, poetry.lock
- **pipenv**: Pipfile, Pipfile.lock
- **conda**: environment.yml

### Others
- **Ruby**: Gemfile, Gemfile.lock
- **Go**: go.mod, go.sum
- **Rust**: Cargo.toml, Cargo.lock
- **Java**: pom.xml, build.gradle
- **PHP**: composer.json, composer.lock
- **.NET**: *.csproj, packages.config

## Security Features

### Vulnerability Detection
- Known CVEs scanning
- Zero-day heuristics
- Dependency confusion
- Supply chain attacks

### License Compliance
- License compatibility matrix
- Commercial use restrictions
- Copyleft implications
- Attribution requirements

### SBOM Generation
```bash
/deps analyze --sbom --format=spdx
# Generates Software Bill of Materials
```

## Performance Optimization

### Parallel Installation
- Concurrent package manager execution
- Shared cache utilization
- Network request optimization
- CPU core utilization

### Dependency Reduction
- Tree shaking analysis
- Duplicate detection
- Alternative suggestions
- Bundle size impact

## Integration Points
- CI/CD pipelines
- Git hooks
- IDE integrations
- Security scanners
- Monitoring systems

## Best Practices
- Regular security audits
- Automated dependency updates
- Lock file commits
- Version pinning strategy
- Dependency documentation

## Notes
- Supports private registries
- Handles authentication
- Proxy configuration
- Offline mode capable
- Generates detailed reports