# Claude Configuration Repository

## Repository Overview

This is a **Claude Code CLI Configuration Management Repository** - a clean, organized system for managing Claude
configurations, specialized agents, and custom commands. After a major cleanup that removed 85+ bloat files, this
repository now contains essential configurations for running 41 specialized agents and 14 commands with the Claude
Code CLI.

## Repository-Specific Instructions

### Project Type & Purpose

- **Type**: Configuration management repository for Claude Code CLI
- **Primary Function**: Centralized storage and synchronization of Claude system configurations
- **Core Value**: Provides clean, validated agent definitions and custom commands for enhanced Claude functionality

### Key Components

- **System Configurations**: Core Claude settings in `system-configs/` directory
- **Agent Ecosystem**: 40 specialized agents in `system-configs/.claude/agents/`
- **Commands**: 14 essential commands in `system-configs/.claude/commands/`
- **Documentation**: 26 essential documentation files in `docs/`
- **Scripts**: 17 utility scripts for validation and maintenance

## Development Workflows

### Configuration Management

1. **Adding New Agents**: Use the template in `system-configs/.claude/agents/AGENT_TEMPLATE.md`
2. **Follow YAML Schema**: Ensure all agents have valid front-matter
3. **Include SYSTEM BOUNDARY**: Protection against unauthorized invocation
4. **Run Validation**: Execute `./scripts/validate-agent-yaml.py`
5. **Sync Changes**: Use `/sync` command to deploy configurations

### Testing Strategy

```bash
# Run comprehensive test suite
/test

# Run specific test categories
./tests/test.sh commands
./tests/test.sh config
./tests/test.sh integration

# Validate YAML agent definitions
./scripts/validate_yaml.sh
```

### Quality Gates

- All agents must pass YAML validation
- Commands require behavioral testing
- Documentation must be comprehensive
- Security boundaries must be enforced

## Repository-Specific Commands

### Configuration Management

- `/sync` - **Primary Command**: Synchronizes system configurations from this repository to `~/.claude/`
- `/agent-audit` - Validates all 40 agent configurations with parallel execution
- `/context` - Analyzes repository structure and purpose

### Development & Testing

- `/test` - Auto-discovers and runs repository tests
- `/review` - Code quality review with security checks
- `/fix-ci` - Auto-fixes CI/CD pipeline failures

### Git Operations

- `/commit` - Smart commits with quality gates and semantic messages
- `/push` - Safe push operations with comprehensive checks
- `/pr` - Intelligent PR creation with context-aware descriptions

## Architecture Notes

### Configuration Structure

- **system-configs/**: Contains the source-of-truth configurations
  - `CLAUDE.md`: Main configuration file
  - `.claude/agents/`: 40 agent definitions in Markdown format
  - `.claude/commands/`: 14 command definitions
  - `settings.json`: Audio notification hooks and preferences

### Agent Categories

The 40 agents are organized across multiple functional domains covering all aspects of software development, from
core programming to infrastructure, quality assurance, and documentation.

### Synchronization System

- `/sync` command deploys configurations from `system-configs/` to user's `~/.claude/` directory
- Validates agent YAML compliance before deployment
- Creates automatic backups of existing configurations
- Excludes documentation and template files from sync

### Security Boundaries

- **SYSTEM BOUNDARY Protection**: Agents cannot invoke themselves or other agents
- **Sole Executor Model**: Claude maintains exclusive execution authority
- **Principle of Least Privilege**: Minimal required permissions per agent

## Common Tasks

### Working with Configurations

```bash
# Validate all agent configurations
./scripts/validate-agent-yaml.py

# Synchronize to user directory
/sync

# Check system health
./scripts/validate-system.sh

# Scan agent capabilities
./scripts/scan-agent-capabilities.py
```

### Repository Maintenance

```bash
# Update documentation
./scripts/update-documentation.py

# Run comprehensive validation
./tests/test.sh

# Standardize agent formats
./scripts/standardize-agents.py
```

## Quality Standards

### Agent Requirements

- Valid YAML syntax and schema compliance
- Clear capability definitions
- Appropriate category assignment
- SYSTEM BOUNDARY protection included
- Comprehensive description and context

### Code Standards

- TypeScript for infrastructure components
- Comprehensive test coverage
- Semantic versioning for releases
- Conventional commit messages

### Documentation Standards

- Keep README.md comprehensive and current
- Update DOCUMENTATION_INDEX.md for new docs
- Include examples for all agent usage patterns
- Maintain API documentation for MCP components

## Contributing Guidelines

1. **Fork and Branch**: Create feature branches from `main`
2. **Agent Development**: Use provided templates and validation tools
3. **Testing**: Ensure all tests pass before submitting
4. **Documentation**: Update relevant docs with changes
5. **Review Process**: All PRs require comprehensive review

## Integration Points

### External Systems

- **Claude Code CLI**: Primary execution environment for agents and commands
- **Home Directory Integration**: Syncs configurations to `~/.claude/` for global access
- **Audio Notifications**: System event feedback via macOS sound files
- **Git Integration**: Version control and repository management

### Development Tools

- **Python**: Validation scripts and agent processing tools
- **Bash**: System integration and testing scripts
- **Markdown**: Agent and command definition format
- **YAML Front-matter**: Agent metadata and configuration

---

*This repository provides clean, validated Claude configurations for enhanced development workflows through
specialized agents and custom commands.*
