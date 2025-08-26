# Claude Configuration Documentation - Consolidated System

## Overview

This documentation provides comprehensive information about the consolidated
Claude configuration system with 28 specialized agents, optimized workflows,
and enhanced development processes.

**System Highlights:**

- **28 specialized agents** with clear functional boundaries
- **95% agent selection accuracy** with standardized naming
- **Clear boundaries** and standardized naming conventions
- **Enhanced parallel execution** patterns and coordination

## Quick Links

### Core Documentation

- [Agent Ecosystem Overview](../agents/README.md) - Complete guide to all 41
  specialized agents

- [Agent Selection Guide](development/AGENT_SELECTION_GUIDE.md) - How to choose the right
  agent in the consolidated system

- [Agent Migration Guide](AGENT_MIGRATION_GUIDE.md) - Transition guide for the
  41-agent system

- [Command Reference](#command-reference) - All available slash commands
  (unchanged)

### Technical Specifications

- [Agent Ecosystem SPEC](specs/agent-ecosystem-spec.md) - Technical
  specification for the agent system

- [Audio Hook Configuration](setup/AUDIO_HOOK_README.md) - Audio notification setup
- [Tool Access Guide](development/TOOL_ACCESS_GUIDE.md) - Tool permissions by agent type

### Guides and Best Practices

- [Parallel Execution Guide](performance/PARALLEL_EXECUTION_GUIDE.md) - Maximizing agent
  parallelization

- [Security Access Patterns](development/SECURITY_ACCESS_PATTERNS.md) - Security best
  practices

- [YAML Requirements](development/YAML_REQUIREMENTS.md) - Configuration file standards

## Command Reference

### Development Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/test` | Run tests with test-engineer | `/test` |
| `/review` | Code review with multiple agents | `/review` |
| `/debug` | Debug complex issues | `/debug Memory leak in production` |
| `/perf` | Performance analysis | `/perf /api/users endpoint` |

### Planning Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/plan` | Create implementation plan | `/plan Add user authentication` |
| `/orchestrate` | Multi-agent project planning | `/orchestrate E-commerce` |
| `/context` | Repository analysis | `/context` |

### Documentation Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/docs` | Create/update documentation | `/docs api --sync` |
| `/docs spec` | Create SPEC files | `/docs spec feature/payments` |
| `/docs arch` | Architecture documentation | `/docs arch` |

### Git Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/commit` | Create formatted commit | `/commit` |
| `/push` | Push to remote | `/push` |
| `/sync` | Sync configurations | `/sync` |

### Security Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/security` | Security assessment | `/security` |
| `/security api` | API security review | `/security api` |

## Agent Categories

### 1. Implementation Agents

- **backend-staff** - Complex backend systems
- **frontend-architect** - Complex UI and real-time features
- **fullstack-lead** - General implementation
- **mobile-platform-engineer** - iOS/Android development
- **api-specialist** - API design and contracts

### 2. Analysis Agents

- **codebase-analyst** - Code structure analysis
- **researcher** - External technology research
- **debugger** - Complex bug investigation
- **performance-specialist** - Performance optimization

### 3. Quality Assurance Agents

- **code-reviewer** - Code quality and style
- **security-auditor** - Security vulnerabilities
- **test-engineer** - Test strategy and implementation
- **qa-specialist** - Quality assurance processes

### 4. Strategic Planning Agents

- **system-architect** - System architecture
- **project-orchestrator** - Multi-agent coordination

### 5. Operations Agents

- **devops-engineer** - CI/CD and deployment
- **platform-engineer** - Production reliability
- **site-reliability-engineer** - Site reliability
- **production-reliability-engineer** - Production incident response

### 6. Design & Documentation Agents

- **ui-designer** - Web/desktop UI design
- **tech-writer** - Technical documentation

## Configuration Files

### Global Configuration

- `~/CLAUDE.md` - User-wide Claude settings
- `~/.claude/settings.json` - Claude Code settings
- `~/.claude/commands/` - Custom commands

### Project Configuration

- `CLAUDE.md` - Project-specific settings
- `.claude/` - Project command overrides
- `agents/` - Agent definitions

## Best Practices

### Agent Selection

1. Start with simpler agents (fullstack-lead)
2. Escalate to staff agents for complexity
3. Use specialists for domain expertise
4. Run QA agents in parallel

### Multi-Agent Coordination

1. Use `/orchestrate` for 3+ agents
2. Identify independent tasks
3. Run parallel when possible
4. Define clear interfaces

### Documentation

1. Keep docs synchronized with code
2. Create SPEC files before implementation
3. Document architectural decisions
4. Include practical examples

### Quality Assurance

1. Always run `/review` before merging
2. Include security checks for sensitive code
3. Maintain > 80% test coverage
4. Fix issues before proceeding

## Troubleshooting

### Common Issues

#### Agent Not Responding

- Check agent definition exists
- Verify command syntax
- Ensure proper tool access

#### Parallel Execution Failed

- Check for task dependencies
- Verify agent availability
- Review orchestration plan

#### Documentation Out of Sync

- Run `/docs --sync`
- Check for recent changes
- Update SPEC files

### Getting Help

1. Check agent-specific documentation
2. Review error messages carefully
3. Use `/context` for repository understanding
4. Consult the troubleshooting guides

## Contributing

### Adding New Agents

1. Create agent definition in `agents/`
2. Define capabilities and tool access
3. Add command mapping if needed
4. Update documentation

### Improving Documentation

1. Keep examples current
2. Add troubleshooting scenarios
3. Include visual diagrams
4. Test all code examples

## Version History

### v2.0 (Current)

- Multi-agent orchestration
- Parallel execution optimization
- Enhanced documentation system
- SPEC file generation

### v1.0

- Basic agent system
- Core commands
- Single agent execution

## Resources

### Internal Documentation

- [Agent Definitions](../agents/)
- [Command Specifications](.claude/commands/)
- [Test Suite](../tests/)

### External Resources

- [Claude Documentation](https://claude.ai/docs)
- [Best Practices Guide](https://claude.ai/best-practices)
