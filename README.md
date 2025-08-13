# Claude Configuration Repository

<div align="center">

![CI](https://github.com/damilola/claude-config/workflows/CI/badge.svg)
![PR Checks](https://github.com/damilola/claude-config/workflows/PR%20Checks/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

<!-- markdownlint-disable-next-line MD036 -->
*Clean, validated Claude configurations for enhanced development workflows*

[Quick Start](#-quick-start) • [Features](#-features) • [Commands](#-commands) • [Agent Ecosystem](#-agent-ecosystem) • [Installation](#-installation) • [Contributing](#-contributing)

</div>

## 🎯 Overview

This repository provides a comprehensive configuration management system for Claude Code CLI, featuring **40 specialized agents** and **14 essential commands**. After a major cleanup that removed 85+ bloat files, this repository now maintains clean, validated configurations for enhanced development workflows.

### 🌟 What Makes This Configuration System Unique

This repository transforms how you work with Claude Code CLI:

- **Clean Repository Structure**: Organized after removing 85+ bloat files, keeping only essential configurations
- **41 Validated Agents**: Each agent includes YAML front-matter validation and SYSTEM BOUNDARY protection
- **Synchronized Configurations**: `/sync` command seamlessly deploys configurations from repository to `~/.claude/`
- **Quality Assurance**: Built-in validation ensures all configurations meet strict quality standards
- **Documentation-First Approach**: Comprehensive documentation for every component

### Key Benefits

- **🧹 Clean Organization**: Essential files only - no bloat or redundancy
- **🎭 41 Specialized Agents**: Complete coverage of the software development lifecycle
- **🔄 Easy Synchronization**: One command syncs all configurations to your system
- **🛡️ Quality Gates**: YAML validation and compliance checking
- **📚 Comprehensive Documentation**: 26 essential documentation files
- **🔧 14 Essential Commands**: Carefully curated for maximum utility

## 🚀 Quick Start

### 1. Install Claude Code CLI

```bash
# Install via npm
npm install -g @anthropic/claude-code

# Or via Homebrew (macOS)
brew install claude-code
```

### 2. Clone and Setup Configuration

```bash
# Clone the repository
git clone https://github.com/damilola/claude-config.git
cd claude-config

# Quick setup using the sync command
claude-code
/sync

# Or manual setup
cp system-configs/CLAUDE.md ~/CLAUDE.md
cp -r system-configs/.claude ~/.claude
cp system-configs/settings.json ~/.claude/settings.json
```

### 3. Try Core Commands

```bash
# Get repository overview
/context

# Run tests with auto-discovery
/test

# Comprehensive code review
/review

# Validate agent configurations
/agent-audit
```

## ✨ Features

### 🔄 Configuration Management

- **Centralized Configuration**: All agent and command definitions in one place
- **One-Command Sync**: Deploy configurations from repository to system with `/sync`
- **Automatic Validation**: YAML compliance checking before deployment
- **Backup Management**: Automatic backups of existing configurations during sync

### 🛠️ Core Commands (14 Essential Tools)

#### ⭐⭐⭐⭐⭐ Five-Star Commands (10)

- **`/test`** - Auto-discovers and runs tests, creates starter tests if none exist
- **`/context`** - Repository analysis with parallel agents, auto-runs on startup
- **`/plan`** - Strategic planning with preview mode, TDD methodology, prevents file spam
- **`/agent-audit`** - Comprehensive agent validation with parallel execution
- **`/resolve-cr`** - Exhaustive CodeRabbit comment resolution with multi-agent deployment
- **`/debug`** - Systematic investigation for complex bugs, race conditions, memory leaks
- **`/pr`** - Intelligent PR creation with comprehensive descriptions and smart reviewer assignment
- **`/review`** - Multi-dimensional code analysis with security, performance, and quality checks
- **`/deps`** - Security-focused dependency management across all package managers
- **`/fix-ci`** - Pattern recognition and auto-fix for CI failures

#### ⭐⭐⭐⭐ Four-Star Commands (4)

- **`/commit`** - Smart commits with quality gates and auto-remediation
- **`/push`** - Safe push with comprehensive quality checks
- **`/branch`** - Intelligent branch naming from context
- **`/sync`** - Repository-specific configuration synchronization

### 🔊 Audio Notifications

- Task completion sounds (Swish.m4r)
- Stop event notifications (Chord.m4r)
- Permission request alerts (Aurora.m4r)
- Non-blocking background playback

## 📋 Commands

### Command Quality Summary

- **Total Commands**: 14 essential commands (cleaned from 40+)
- **5-Star Commands**: 10 (71%) - Excellent behavioral instructions, comprehensive functionality
- **4-Star Commands**: 4 (29%) - Good quality with minor improvement opportunities
- **Average Rating**: 4.7/5.0
- **Design Philosophy**: Each command solves real problems and provides substantial value

### Core Development Commands

#### `/test` - Intelligent Test Execution

```bash
/test
# Automatically discovers and runs tests
# Creates starter tests if none exist
# Detects test frameworks from package.json/README
```

#### `/context` - Repository Analysis

```bash
/context
# Runs multiple codebase-analyst agents in parallel
# Provides comprehensive project overview
# Auto-executes on Claude Code startup
```

#### `/review` - Code Quality Review

```bash
/review [file|directory]
# Runs code-reviewer + security-auditor + test-engineer
# Comprehensive quality validation
# Pre-commit best practices check
```

#### `/debug` - Systematic Debugging

```bash
/debug "app crashes when user logs out"
# Gathers evidence from logs and traces
# Forms and tests hypotheses
# Identifies root cause with fix
```

### Planning & Orchestration

#### `/plan` - Strategic & Tactical Planning

```bash
/plan "Add user authentication"
# Creates strategic requirements document
# Generates tactical TDD phases (8-15 files each)
# Principal-architect as primary consultant
# Outputs to ./.tmp/<feature-name>/
```

#### `/fix-ci` - Auto-Fix CI Failures

```bash
/fix-ci [pr_number]
# Analyzes CI failure logs
# Applies targeted fixes (lint, test, security)
# Verifies locally before pushing
# Gets your PR back to green
```

### Quality & Security

#### `/deps` - Security-Focused Dependency Management

```bash
/deps audit    # Find and fix vulnerabilities
/deps update   # Safe updates with testing
/deps clean    # Remove unused packages
# Multi-language support (npm, pip, cargo, etc.)
```

#### `/agent-audit` - Agent Ecosystem Validation

```bash
/agent-audit
# Validates all 41 agent configurations
# Checks for capability gaps
# Runs parallel audits by category
```

#### `/resolve-cr` - CodeRabbit Review Resolution

```bash
/resolve-cr [pr-number]
# Automatically fetches and resolves CodeRabbit PR comments
# Parses "Prompts for AI Agents" section
# Deploys specialized agents for fixes
# Integrates with /test and /commit workflow
```

Note: Previously named `/resolve-rabbit`.

### Git Operations

#### `/commit` - Smart Git Commits

```bash
/commit
# Analyzes changes comprehensively
# Creates semantic commit messages
# Adds AI co-authorship attribution
```

#### `/push` - Safe Push to Remote

```bash
/push
# Safety checks for branch status
# Sets up tracking for new branches
# Prevents accidental force pushes
```

## 🎭 Agent Ecosystem

The system includes **40 specialized agents** organized across multiple functional domains:

### 📊 Agent Categories Overview

| Category | Count | Purpose | Key Agents |
|----------|-------|---------|------------|
| **Development** | 6 | Core programming and implementation | backend-engineer, frontend-engineer, mobile-engineer, ml-engineer |
| **Infrastructure** | 8 | Systems, operations, and deployment | cloud-architect, devops, platform-engineer, kubernetes-admin |
| **Architecture** | 2 | System design and planning | principal-architect, api-architect |
| **Design** | 4 | User experience and interfaces | ui-designer, mobile-ui, design-system, ux-researcher |
| **Quality** | 6 | Testing, review, and validation | test-engineer, code-reviewer, performance-engineer, accessibility-auditor |
| **Security** | 2 | Security and compliance | security-auditor, security-tester |
| **Analysis** | 8 | Research and documentation | codebase-analyst, tech-writer, data-scientist, performance-analyst |
| **Operations** | 11 | Support and efficiency tools | debugger, file-navigator, incident-commander, error-resolver |

### 🚀 Parallel Execution Examples

#### Multi-Platform Development

```yaml
Project: Mobile App with Backend
Parallel Execution:
  - backend-engineer: API development
  - frontend-engineer: Admin dashboard
  - mobile-engineer #1: iOS app
  - mobile-engineer #2: Android app
  - design-system: Component library
  - ux-researcher: User testing
```

#### Cloud Infrastructure Deployment

```yaml
Project: Kubernetes-based Microservices Platform
Parallel Execution:
  - platform-engineer: Platform architecture
  - kubernetes-admin: Cluster setup & config
  - monitoring-specialist: Observability stack
  - devops: CI/CD pipelines
  - cloud-architect: Cost optimization
```

#### Comprehensive Code Audit

```yaml
Project: Security and Quality Review
Parallel Execution:
  - code-reviewer: Code quality check
  - security-auditor: Vulnerability scan
  - test-engineer: Coverage analysis
  - performance-analyst: Performance metrics
  - accessibility-auditor: WCAG compliance
```

#### Agent Ecosystem Health Check

```yaml
Project: Full Agent Audit
Parallel Execution (8 instances):
  - agent-auditor #1: Development agents
  - agent-auditor #2: Infrastructure agents
  - agent-auditor #3: Architecture agents
  - agent-auditor #4: Design agents
  - agent-auditor #5: Quality agents
  - agent-auditor #6: Security agents
  - agent-auditor #7: Analysis agents
  - agent-auditor #8: Operations agents
```

### 🎯 Complete Agent Roster

#### Development Specialists (6 agents)

- **backend-engineer**: Server-side systems, APIs, microservices, databases, distributed architectures
- **frontend-engineer**: React/Vue/Angular apps, state management, frontend optimization
- **mobile-engineer**: iOS/Android native, React Native, Flutter development
- **ml-engineer**: ML deployment, MLOps pipelines, production ML systems
- **database-migration-specialist**: Schema migrations, data migrations, zero-downtime deployments
- **integration-specialist**: Third-party APIs, webhooks, OAuth, external service connections

#### Infrastructure & Platform (8 agents)

- **platform-engineer**: Platform architecture, developer experience, internal tooling
- **kubernetes-admin**: K8s cluster management, workload orchestration, container operations
- **monitoring-specialist**: Observability infrastructure, metrics, logging, alerting strategies
- **cloud-architect**: Multi-cloud strategies, cost optimization, cloud-native patterns
- **devops**: CI/CD pipelines, containerization, IaC, deployment automation
- **network-engineer**: Cloud networking, load balancing, CDN setup, DNS management
- **data-engineer**: Data pipelines, ETL/ELT systems, stream processing, ML infrastructure
- **database-admin**: Database optimization, security hardening, performance tuning

#### Architecture & Planning (2 agents)

- **principal-architect**: System-wide architecture, technical roadmaps, cross-team coordination
- **api-architect**: API design, OpenAPI specs, governance policies, GraphQL federation

#### Design & User Experience (4 agents)

- **design-system**: Component libraries, design tokens, visual consistency
- **ux-researcher**: User research, usability testing, data-driven design decisions
- **ui-designer**: UI/UX design, visual hierarchy, accessibility compliance
- **mobile-ui**: iOS/Android specific patterns, gestures, platform adaptations

#### Quality & Testing (6 agents)

- **test-engineer**: Test strategy, implementation, execution, CI/CD automation
- **code-reviewer**: Quality review, security checks, best practices validation
- **performance-engineer**: Performance profiling, load testing, bottleneck analysis
- **accessibility-auditor**: WCAG compliance audits, screen reader testing, remediation
- **api-contract-tester**: API validation, contract tests, mock server generation
- **agent-auditor**: Agent file auditing, compliance validation, quality standards

#### Security & Compliance (2 agents)

- **security-auditor**: Security audits, vulnerability assessment, OWASP compliance
- **security-tester**: Penetration testing, SAST/DAST implementation, API security

#### Analysis & Documentation (8 agents)

- **performance-analyst**: System metrics analysis, bottleneck identification, optimization
- **data-scientist**: Statistical analysis, A/B testing, ML model evaluation
- **codebase-analyst**: Architecture analysis, technical debt assessment, risk identification
- **tech-writer**: Technical documentation, API docs, architecture records
- **business-analyst**: Requirements gathering, process mapping, stakeholder analysis
- **researcher**: Technology evaluation, market analysis, competitive research
- **log-analyst**: Log analysis, pattern detection, production issue debugging
- **api-documenter**: API documentation generation, OpenAPI specs, developer guides

#### Operations & Support (11 agents)

- **debugger**: Complex bug investigation, race conditions, systematic root cause analysis
- **file-navigator**: Intelligent file system exploration with context-aware patterns
- **incident-commander**: Production incidents, outages, crisis management
- **error-resolver**: Automated error context gathering and targeted fixes
- **dependency-manager**: Unified package management across all ecosystems
- **git-workflow**: Streamlined git operations with intelligent automation
- **search-coordinator**: Complex multi-pattern searches with maximum efficiency
- **documentation-finder**: Intelligent documentation discovery across all sources
- **config-specialist**: Configuration file management across projects
- **file-writer**: Efficient batch file writing and template generation
- **product-strategist**: Product vision, feature prioritization, go-to-market strategy

## 🆕 Recent Updates

### Enhanced Command System (Latest)

- **Streamlined Commands**: Reduced from 40 to 14 essential commands
- **TDD Planning**: `/plan` now generates test-driven development phases
- **CI/CD Integration**: `/fix-ci` automatically resolves build failures
- **41 Specialized Agents**: Complete coverage across 8 domains
- **Prevents Unauthorized Invocation**: Agents cannot invoke themselves or other agents
- **Sole Executor Paradigm**: Claude maintains exclusive execution authority
- **Automatic Termination**: Any attempt at agent self-invocation triggers immediate termination

### Recent Enhancements

- **Audit System**: Comprehensive agent ecosystem health checks with parallel execution
- **Multi-Instance Support**: Run multiple instances of same agent type for massive parallelization
- **Improved Error Handling**: Enhanced boundary violation detection and reporting
- **Performance Optimizations**: Faster agent startup and response times

## 🏗️ Architecture

### System Components

```text
claude-config/
├── CLAUDE.md                    # Project configuration
├── README.md                    # This documentation
├── QUICKSTART.md               # Quick setup guide
├── system-configs/             # Source configurations
│   ├── CLAUDE.md              # Core configuration file
│   ├── .claude/               # Claude Code configuration
│   │   ├── agents/            # 40 agent definitions + 4 docs
│   │   │   ├── README.md      # Agent ecosystem guide
│   │   │   └── *.md           # Individual agent specs
│   │   └── commands/          # 14 command definitions
│   └── settings.json          # Audio hooks and preferences
├── docs/                      # 26 documentation files
├── scripts/                   # 17 utility and validation scripts
└── tests/                     # Test suite for all components
```

### Configuration Flow

```mermaid
graph TB
    A[Repository] --> B[/sync Command]
    B --> C{Validation}
    C --> D[Backup Existing]
    D --> E[Deploy to ~/.claude/]
    E --> F[41 Agents Available]
    E --> G[14 Commands Available]
    F --> H[Enhanced Claude CLI]
    G --> H
```

## 💡 Real-World Use Cases

### Setting Up Claude for a New Project

```bash
# Clone this repository to your new project
git clone https://github.com/damilola/claude-config.git
cd claude-config

# Deploy all configurations
/sync

# Now you have access to 40 agents and 14 commands
# Use /context to analyze your project
# Use /test to run tests
# Use /review for code quality checks
```

### Repository Configuration Management

```bash
# Keep your Claude configurations up to date
cd claude-config
git pull origin main
/sync

# Validate all agent configurations
/agent-audit

# Run comprehensive repository tests
/test
```

### Agent Development Workflow

```bash
# Create a new agent using the template
cp system-configs/.claude/agents/AGENT_TEMPLATE.md system-configs/.claude/agents/my-new-agent.md

# Edit the agent configuration
# Validate the configuration
./scripts/validate-agent-yaml.py

# Deploy to your system
/sync

# Test the new agent
/agent-audit
```

## 💻 Installation

### Prerequisites

- Node.js 16+ or Python 3.8+
- Git
- Claude Code CLI

### Option 1: Quick Install with Sync Command

```bash
# Clone repository
git clone https://github.com/damilola/claude-config.git
cd claude-config

# Run Claude Code and sync
claude-code
/sync
```

### Option 2: Manual Installation

```bash
# Clone repository
git clone https://github.com/damilola/claude-config.git
cd claude-config

# Copy core configuration
cp system-configs/CLAUDE.md ~/CLAUDE.md

# Copy Claude settings and commands
cp -r system-configs/.claude ~/.claude
cp system-configs/settings.json ~/.claude/settings.json
```

### Option 3: Selective Installation

```bash
# Just the main configuration
cp system-configs/CLAUDE.md ~/CLAUDE.md

# Just the commands
cp -r system-configs/.claude/commands ~/.claude/commands

# Just the agent definitions
cp -r system-configs/.claude/agents ~/.claude/agents

# Just the audio settings
cp system-configs/settings.json ~/.claude/settings.json
```

## 🧪 Testing

### Running Tests

```bash
# Run all tests
./tests/test.sh

# Run specific test categories
./tests/test.sh commands
./tests/test.sh config
./tests/test.sh integration

# Validate YAML in agent definitions
./scripts/validate_yaml.sh
```

### Test Coverage

- ✅ Command validation
- ✅ Configuration structure
- ✅ Agent definition compliance
- ✅ Integration workflows
- ✅ YAML syntax validation

## 🔧 Troubleshooting

### Common Issues

#### Agent Not Found

```bash
# Check if configurations are synced
/sync

# Run agent audit to validate configurations
/agent-audit

# Check agent directory
ls ~/.claude/agents/
```

#### SYSTEM BOUNDARY Violation

If you see "SYSTEM BOUNDARY: operation not permitted", this means:

- An agent attempted to invoke itself or another agent
- Solution: Let Claude handle all agent coordination

#### Audio Notifications Not Working

```bash
# Check audio hook configuration
cat ~/.claude/settings.json | grep -A 10 "hooks"

# Test audio playback
afplay /System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Swish.m4r
```

#### Configuration Sync Issues

```bash
# Ensure you're in the claude-config repository
pwd  # Should show .../claude-config

# Check repository status
git status

# Force sync with validation
/sync
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Quick Contribution Steps

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests (`./tests/test.sh`)
5. Commit with conventional commits (`/commit`)
6. Push to your fork
7. Open a Pull Request

### Adding New Agents

1. Use the agent template: `system-configs/.claude/agents/AGENT_TEMPLATE.md`
2. Follow naming conventions (descriptive, lowercase, hyphenated)
3. Include valid YAML front-matter with all required fields
4. Include SYSTEM BOUNDARY protection in your agent
5. Run validation: `./scripts/validate-agent-yaml.py`
6. Deploy and test: `/sync` then `/agent-audit`

### Contribution Areas

- **New Agents**: Identify gaps in current capabilities
- **Command Enhancements**: Improve existing commands
- **Documentation**: Enhance guides and examples
- **Test Coverage**: Add test cases for edge scenarios
- **Performance**: Optimize agent response times

## 📚 Documentation

### Core Documentation

- [Agent Ecosystem Overview](system-configs/.claude/agents/README.md)
- [Agent Categories](system-configs/.claude/agents/AGENT_CATEGORIES.md)
- [Audio Notifications](docs/AUDIO_HOOK_README.md)
- [Agent Selection Guide](docs/AGENT_SELECTION_GUIDE.md)
- [Documentation Index](docs/DOCUMENTATION_INDEX.md)

### External Resources

- [Claude Code CLI Reference](https://docs.anthropic.com/en/docs/claude-code/cli-reference)
- [Sub-agents Guide](https://docs.anthropic.com/en/docs/claude-code/sub-agents)
- [Available Tools](https://docs.anthropic.com/en/docs/claude-code/settings#tools-available-to-claude)

## ❓ Frequently Asked Questions

### Q: How do I deploy configurations from this repository?

**A:** Use the `/sync` command from within the claude-config repository. It will validate and deploy all configurations to your `~/.claude/` directory.

### Q: How often should I update my configurations?

**A:** Run `git pull` in the claude-config repository periodically, then `/sync` to get the latest agent definitions and commands.

### Q: What's the difference between the repository CLAUDE.md and system-configs/CLAUDE.md?

**A:** The repository CLAUDE.md describes this configuration repository. The system-configs/CLAUDE.md is deployed to your home directory for global Claude configuration.

### Q: How do I know which agent to use?

**A:** Check the [Agent Selection Guide](docs/AGENT_SELECTION_GUIDE.md) or use `/agent-audit` to see all available agents.

### Q: Why did my agent task fail with "SYSTEM BOUNDARY" error?

**A:** This security feature prevents agents from invoking themselves or other agents. Always let Claude handle agent coordination.

### Q: Can agents write files directly?

**A:** No. Agents generate content, Claude writes files. This maintains security and consistency.

### Q: How can I contribute a new agent?

**A:** Use the template in `system-configs/.claude/agents/AGENT_TEMPLATE.md`, ensure valid YAML front-matter and SYSTEM BOUNDARY protection, then submit a PR.

## 🔒 Security

- **SYSTEM BOUNDARY Protection**: Prevents unauthorized agent self-invocation
- **Principle of Least Privilege**: Each agent has minimal required permissions
- **No Stored Credentials**: Configuration files contain no secrets
- **Regular Audits**: Use `/security` for comprehensive security assessments
- **Secure Orchestration**: Claude validates all agent operations

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Anthropic team for Claude and Claude Code CLI
- Contributors who helped shape the agent ecosystem
- Open source community for inspiration and tools

---

<div align="center">

<!-- markdownlint-disable-next-line MD036 -->
*Built with ❤️ by the Claude Configuration Community*

[Report Bug](https://github.com/damilola/claude-config/issues) • [Request Feature](https://github.com/damilola/claude-config/issues) • [Documentation](https://github.com/damilola/claude-config/wiki)
