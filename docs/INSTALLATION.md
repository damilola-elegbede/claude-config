# Installation Guide

Complete setup and installation instructions for the Claude Configuration Repository - a Smart Agent Orchestration
Framework featuring dozens of specialized agents and essential commands.

**Current Configuration:**

- **Agents**: 28 specialized agents (verify count with system-configs/.claude/agents/)
- **Commands**: 20 essential commands (verify count with system-configs/.claude/commands/)

## Prerequisites

### Required Software

- **Node.js 16+** or **Python 3.8+** for development environments
- **Git** for version control and repository management
- **Claude Code CLI** - The foundation for agent orchestration
- **macOS, Linux, or Windows** with WSL support

### Claude Code CLI Installation

#### Option 1: NPM Installation (Recommended)

```bash
npm install -g @anthropic/claude-code
```

#### Option 2: Homebrew (macOS)

```bash
brew install claude-code
```

#### Option 3: Binary Download

```bash
# Check latest releases at:
# https://github.com/anthropics/claude-code/releases
curl -L https://github.com/anthropics/claude-code/releases/latest/download/claude-code-linux -o claude-code
chmod +x claude-code
sudo mv claude-code /usr/local/bin/
```

### Verification

```bash
# Verify Claude Code CLI installation
claude-code --version

# Verify system requirements
node --version  # Should be 16+
git --version   # Any recent version
```

## Installation Methods

### Method 1: Smart Framework Deployment (Recommended)

The fastest way to deploy the complete orchestration framework:

```bash
# 1. Clone the repository
git clone https://github.com/damilola-elegbede/claude-config.git
cd claude-config

# 2. Deploy complete framework with validation
claude-code
/sync

# 3. Verify installation
/agent-audit
/command-audit

# 4. Test orchestration capabilities
/context
/test
```

### Method 2: Manual Installation

For users who prefer manual control:

```bash
# 1. Clone repository
git clone https://github.com/damilola-elegbede/claude-config.git
cd claude-config

# 2. Create ~/.claude directory if it doesn't exist
mkdir -p ~/.claude

# 3. Copy core configuration
cp system-configs/CLAUDE.md ~/CLAUDE.md

# 4. Copy Claude settings and orchestration framework
cp -r system-configs/.claude/* ~/.claude/

# 5. Copy audio notification settings (optional)
cp system-configs/settings.json ~/.claude/settings.json
```

### Method 3: Selective Installation

Install only specific components:

```bash
# Core configuration only
cp system-configs/CLAUDE.md ~/CLAUDE.md

# Agent orchestration framework
cp -r system-configs/.claude/agents ~/.claude/agents

# Essential commands
cp -r system-configs/.claude/commands ~/.claude/commands

# Audio notifications
cp system-configs/.claude/settings.json ~/.claude/settings.json
```

## Post-Installation Setup

### 1. Verify Agent Ecosystem

```bash
# Check agent deployment
ls ~/.claude/agents/ | wc -l  # Should show 41+ files

# Validate agent configurations
./scripts/validate-agent-yaml.py

# Run comprehensive ecosystem audit
/agent-audit
```

### 2. Test Command Framework

```bash
# Check command deployment
ls ~/.claude/commands/ | wc -l  # Should show 18+ files

# Validate command ecosystem
/command-audit

# Test core commands
/context  # Repository analysis
/test     # Test discovery and execution
/review   # Multi-agent code review
```

### 3. Audio Notifications (Optional)

```bash
# Test audio system (macOS)
afplay /System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Swish.m4r

# Verify hook configuration
cat ~/.claude/settings.json | grep -A 5 'PostToolUse'
```

### 4. Repository Integration

```bash
# Set up for future updates
cd claude-config
git remote -v  # Verify origin points to your fork or upstream

# Create update alias (optional)
echo 'alias update-claude="cd ~/claude-config && git pull && /sync"' >> ~/.bashrc
source ~/.bashrc
```

## Verification Checklist

### Core Installation

- [ ] Claude Code CLI responds to `claude-code --version`
- [ ] Repository cloned successfully to `~/claude-config`
- [ ] Main configuration at `~/CLAUDE.md`
- [ ] Agent directory at `~/.claude/agents/` with 41+ files
- [ ] Command directory at `~/.claude/commands/` with 18+ files

### Agent Orchestration Framework

- [ ] `/agent-audit` runs without errors
- [ ] `/command-audit` validates all commands
- [ ] `/context` provides repository analysis
- [ ] `/test` discovers and runs tests
- [ ] `/review` deploys multiple agents

### Optional Features

- [ ] Audio notifications work (`/sync` plays completion sound)
- [ ] Git hooks configured (if applicable)
- [ ] Update workflow established

## Troubleshooting Installation Issues

### Claude Code CLI Not Found

```bash
# Check installation method
which claude-code
npm list -g @anthropic/claude-code

# Reinstall if necessary
npm uninstall -g @anthropic/claude-code
npm install -g @anthropic/claude-code
```

### Permission Errors

```bash
# Fix file permissions
chmod +x ~/.claude/agents/*
chmod +x ~/.claude/commands/*

# Check directory permissions
ls -la ~/.claude/
```

### Agent Validation Failures

```bash
# Run diagnostic script
./scripts/validate-agent-yaml.py --verbose

# Check specific agent files
head -20 ~/.claude/agents/backend-engineer.md

# Re-sync if corrupted
/sync --force
```

### Command Not Found

```bash
# Verify command files
ls ~/.claude/commands/

# Check command syntax
head -10 ~/.claude/commands/sync.md

# Re-deploy commands
cp -r system-configs/.claude/commands ~/.claude/
```

### Audio Issues (macOS)

```bash
# Test system audio
afplay /System/Library/Sounds/Ping.aiff

# Check hook configuration
cat ~/.claude/settings.json | jq '.hooks.PostToolUse'

# Disable audio if problematic
mv ~/.claude/settings.json ~/.claude/settings.json.bak
```

## Environment-Specific Setup

### macOS Setup

```bash
# Install Homebrew if needed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Claude Code CLI
brew install claude-code

# Audio notifications work out of the box
```

### Linux Setup

```bash
# Install Node.js via NodeSource
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Claude Code CLI
npm install -g @anthropic/claude-code

# Audio notifications require additional setup
sudo apt-get install alsa-utils  # For audio support
```

### Windows WSL Setup

```bash
# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Claude Code CLI
npm install -g @anthropic/claude-code

# Audio notifications not supported in WSL
```

### Docker Setup

```dockerfile
FROM node:18-slim

# Install Claude Code CLI
RUN npm install -g @anthropic/claude-code

# Copy configurations
COPY system-configs/.claude /root/.claude
COPY system-configs/CLAUDE.md /root/CLAUDE.md

WORKDIR /workspace
CMD ["claude-code"]
```

## Updating the Framework

### Regular Updates

```bash
# Navigate to repository
cd ~/claude-config

# Pull latest changes
git pull origin main

# Deploy updates
/sync

# Verify updates
/agent-audit
/command-audit
```

### Major Version Updates

```bash
# Backup current configuration
./scripts/backup-configs.sh

# Update repository
git pull origin main

# Review changelog
git log --oneline -10

# Deploy with validation
/sync --backup

# Test critical functionality
/context
/test
/review
```

## Advanced Configuration

### Custom Agent Development

```bash
# Use agent template
cp system-configs/.claude/agents/AGENT_TEMPLATE.md system-configs/.claude/agents/my-specialist.md

# Edit agent definition
vim system-configs/.claude/agents/my-specialist.md

# Validate and deploy
./scripts/validate-agent-yaml.py
/sync
/agent-audit
```

### Repository Integration

```bash
# Set up for contributions
git remote add upstream https://github.com/damilola-elegbede/claude-config.git
git checkout -b feature/my-enhancement

# Make changes and test
./tests/test.sh

# Commit and push
/commit
/push
/pr
```

## Support and Documentation

### Getting Help

- **Documentation**: [DOCUMENTATION_INDEX.md](./DOCUMENTATION_INDEX.md)
- **Agent Guide**: [../system-configs/.claude/agents/README.md](../system-configs/.claude/agents/README.md)
- **Troubleshooting**: [TROUBLESHOOTING.md](./TROUBLESHOOTING.md)
- **Issues**: [GitHub Issues](https://github.com/damilola-elegbede/claude-config/issues)

### Community Resources

- [Contributing Guide](./CONTRIBUTING.md)
- [Usage Examples](./USAGE_EXAMPLES.md)
- [Architecture Overview](./ARCHITECTURE.md)

---

**Installation Complete!** You now have access to 41 specialized agents and 18 essential commands through the
Claude Code CLI orchestration framework.
