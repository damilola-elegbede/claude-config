# Security Policy

## Supported Versions

This project maintains security updates for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| main    | :white_check_mark: |
| feature/* | :x:              |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take security vulnerabilities seriously. If you discover a security issue, please follow these steps:

### 1. Do Not Create Public Issues

**IMPORTANT**: Please do not create public GitHub issues for security vulnerabilities. This helps protect users until a fix is available.

### 2. Report Privately

Send security vulnerability reports to:
- Open a private security advisory on GitHub (preferred)
- Contact repository maintainers directly through secure channels

### 3. Include in Your Report

Please provide:
- Description of the vulnerability
- Steps to reproduce the issue
- Potential impact assessment
- Suggested fix (if available)
- Your contact information for follow-up

### 4. Response Timeline

- **Initial Response**: Within 48 hours
- **Status Update**: Within 5 business days
- **Resolution Target**: Based on severity
  - Critical: 24-48 hours
  - High: 3-5 days
  - Medium: 1-2 weeks
  - Low: Next release cycle

## Security Best Practices

### For Contributors

1. **Never commit secrets**: API keys, tokens, passwords
2. **Use environment variables**: For sensitive configuration
3. **Validate input**: All user inputs must be validated
4. **Follow least privilege**: Request minimal permissions
5. **Update dependencies**: Keep all dependencies current

### For Users

1. **Keep configurations secure**: Never share your `.claude/` directory
2. **Review agent permissions**: Understand what each agent can access
3. **Use official sources**: Only install from official repositories
4. **Regular updates**: Keep your installation current
5. **Report suspicious behavior**: Contact us if you notice unusual activity

## Security Features

### Built-in Protections

- **SYSTEM BOUNDARY Protection**: Prevents unauthorized agent invocations
- **Sole Executor Model**: Only Claude has execution authority
- **Tool Access Control**: Granular tool permissions per agent
- **Audit Logging**: All agent actions are logged
- **Input Validation**: All inputs validated before processing

### Configuration Security

```bash
# Secure your configuration directory
chmod 700 ~/.claude
chmod 600 ~/.claude/settings.json

# Never share these files
~/.claude/settings.json     # Contains personal configurations
~/.claude/api_keys.json     # Contains API keys (if used)
```

## Vulnerability Disclosure Policy

### Coordinated Disclosure

We follow a coordinated disclosure model:
1. Security issues are fixed in private
2. Patches are released to all supported versions
3. Public disclosure happens after patches are available
4. Credit is given to security researchers (with permission)

### Security Advisories

Security advisories are published through:
- GitHub Security Advisories
- Release notes for security updates
- Direct notification to affected users (when possible)

## Security Checklist for Releases

Before each release:
- [ ] Dependency vulnerability scan
- [ ] Static code analysis
- [ ] Security-focused code review
- [ ] Permission audit for new features
- [ ] Update security documentation

## Contact

For security-related questions that are not vulnerabilities:
- Open a discussion on GitHub
- Tag with `security-question` label

## Acknowledgments

We thank the following security researchers for responsible disclosure:
- (List will be updated as reports are received and resolved)

---

*Last updated: 2025-08-26*
*This security policy is subject to change. Check regularly for updates.*