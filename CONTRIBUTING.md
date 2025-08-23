# Contributing to Claude Configuration Repository

Welcome! This guide helps you contribute effectively to the Claude Code CLI configuration ecosystem.

## Quick Start

1. Fork the repository
2. Create a feature branch from `main`
3. Make your changes following our standards
4. Run tests with `/test`
5. Submit a pull request

## Development Standards

### Agent Development

When creating agents, use the template in `system-configs/.claude/agents/AGENT_TEMPLATE.md`:

- Include valid YAML front-matter
- Add SYSTEM BOUNDARY protection
- Define clear capabilities
- Run validation: `./scripts/validate-agent-yaml.py`

### Command Development

Commands go in `system-configs/.claude/commands/`:

- Use clear, descriptive names
- Include comprehensive documentation
- Add usage examples
- Test thoroughly before committing

### Code Standards

- **Clarity over cleverness**: Write readable code
- **Consistent formatting**: Follow existing patterns
- **Error handling**: Graceful failure modes
- **Security first**: Consider security implications

## Testing

Run all tests before submitting:

```bash
/test
./tests/test.sh
```

## Git Workflow

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```bash
feat(agents): add performance monitoring agent
fix(sync): resolve file permission issues
docs(commands): update test documentation
```

### Pull Request Process

1. Create focused PRs (one feature per PR)
2. Update documentation as needed
3. Ensure all tests pass
4. Write descriptive PR descriptions

## Quality Gates

All contributions must pass:

- YAML validation for agents
- Test suite execution
- Documentation consistency
- Security boundary checks

## Getting Help

- Check existing documentation first
- Create detailed bug reports with `/bug`
- Ask questions in GitHub discussions

## Code of Conduct

- Be respectful and constructive
- Help others learn and grow
- Share knowledge openly
- Focus on solutions

Thank you for contributing!
