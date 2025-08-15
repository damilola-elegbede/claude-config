# Claude Configuration Repository: Smart Agent Orchestration Framework

<div align="center">

![CI](https://github.com/damilola/claude-config/workflows/CI/badge.svg)
![PR Checks](https://github.com/damilola/claude-config/workflows/PR%20Checks/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

<!-- markdownlint-disable-next-line MD036 -->
*Production-ready Smart Agent Orchestration Framework for Claude Code CLI*

[Quick Start](#-quick-start) • [Orchestration Framework](#-smart-agent-orchestration-framework) •
[Features](#-features) • [Commands](#-commands) • [Agent Ecosystem](#-agent-ecosystem) •
[Installation](#-installation) • [Contributing](#-contributing)

</div>

## 🎯 Overview

This repository delivers a **sophisticated Smart Agent Orchestration Framework** for Claude Code CLI, featuring
**41 specialized agents** (including the new execution-evaluator for command verification) and
**14 essential commands**.
Built from the ground up after a comprehensive cleanup that removed 85+ bloat files, this system provides intelligent
task delegation, parallel execution, continuous improvement capabilities, and automatic command verification for
enhanced development workflows.

## 🧠 Smart Agent Orchestration Framework

This repository implements a **production-ready orchestration framework** that intelligently manages 40+ specialized
agents with sophisticated task delegation and parallel execution capabilities.

### 🌟 Framework Core Principles

#### 🎯 Right Tool for the Job

- **Mandatory Specialist Delegation**: When a specialist exists, USE THEM - violation equals execution failure
- **Domain Expertise**: Each agent has deep specialization in their domain
- **Quality Boundaries**: Specialists maintain higher standards than generalist approaches

#### ⚡ Parallel-First Execution

- **Concurrent by Default**: Multiple agents work simultaneously whenever possible
- **Intelligent Coordination**: Framework optimizes task distribution and dependencies
- **Multi-Instance Support**: Run multiple instances of the same agent type for massive parallelization

#### 📊 Pragmatic Thresholds

- **Emergency Override**: Direct action when specialists aren't available or time-critical
- **Context-Aware Decisions**: Framework balances specialist deployment vs. direct execution
- **Performance Feedback Loop**: Continuous improvement based on execution metrics

#### 🔄 Continuous Improvement

- **Performance Monitoring**: Tracks execution times, success rates, and quality metrics
- **Adaptive Allocation**: Learns optimal agent combinations for common task patterns
- **Quality Evolution**: Agent capabilities improve through validated feedback cycles

### Key Framework Benefits

- **🎭 40+ Specialized Agents**: Complete coverage across 8 functional domains
- **⚡ Parallel Execution Engine**: Maximize concurrent operations for faster delivery
- **🧠 Intelligent Task Delegation**: Automatic specialist selection based on task requirements
- **🔄 One-Command Synchronization**: Deploy entire framework with `/sync`
- **🛡️ Quality Enforcement**: YAML validation, SYSTEM BOUNDARY protection, and compliance checking
- **📚 Comprehensive Documentation**: 26 essential documentation files with usage patterns
- **🔧 14 Essential Commands**: Carefully curated for maximum operational utility
- **🎯 Production-Ready**: Battle-tested configurations with quality gates and security boundaries

## 🚀 Quick Start

### 1. Install Claude Code CLI

```bash
# Install via npm
npm install -g @anthropic/claude-code

# Or via Homebrew (macOS)
brew install claude-code
```yaml

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
```yaml

### 3. Experience the Orchestration Framework

```bash
# Repository analysis with parallel codebase-analyst agents
/context

# Intelligent test execution with framework discovery
/test

# Multi-agent code review (code-reviewer + security-auditor + test-engineer)
/review

# Comprehensive agent ecosystem validation with parallel execution
/agent-audit

# Experience parallel agent deployment
/resolve-cr [pr-number]  # Deploys multiple specialized agents for PR comment resolution
```yaml

## ✨ Features

### 🧠 Smart Orchestration Engine

- **Intelligent Task Delegation**: Automatically routes tasks to appropriate specialists
- **Parallel Execution Framework**: Concurrent agent deployment for maximum efficiency
- **Performance Feedback Loop**: Continuous improvement based on execution metrics
- **Multi-Instance Coordination**: Run multiple instances of same agent type for scalability

### 🔄 Configuration Management

- **Production-Ready Framework**: Battle-tested configurations with quality gates
- **One-Command Deployment**: Deploy entire framework to system with `/sync`
- **Automatic Validation**: YAML compliance and security boundary checking
- **Backup Management**: Automatic backups with rollback capabilities

### 🛠️ Core Commands (14 Essential Tools)

#### ⭐⭐⭐⭐⭐ Five-Star Commands (10) - Orchestration Excellence

- **`/test`** - **Multi-Agent Test Execution**: Auto-discovers frameworks, deploys test-engineer for complex scenarios
- **`/context`** - **Parallel Repository Analysis**: Deploys multiple codebase-analyst agents concurrently
- **`/plan`** - **Strategic Orchestration**: Principal-architect consultation with TDD methodology and parallel
  execution

- **`/agent-audit`** - **Ecosystem Health Check**: Parallel validation across all 8 agent categories
- **`/resolve-cr`** - **Multi-Agent PR Resolution**: Intelligent specialist deployment based on comment analysis
- **`/debug`** - **Systematic Investigation**: Debugger agent with evidence gathering and hypothesis testing
- **`/pr`** - **Intelligent PR Creation**: Tech-writer + codebase-analyst collaboration for comprehensive descriptions
- **`/review`** - **Multi-Dimensional Analysis**: Parallel deployment of code-reviewer, security-auditor, and
  test-engineer

- **`/deps`** - **Security-First Management**: Dependency-manager agent with vulnerability scanning
- **`/fix-ci`** - **Pattern Recognition**: DevOps agent with automated failure analysis and remediation

#### ⭐⭐⭐⭐ Four-Star Commands (4) - Enhanced Operations

- **`/commit`** - **Smart Git Operations**: Git-workflow agent with semantic commit generation and quality gates
- **`/push`** - **Safe Repository Operations**: Comprehensive pre-push validation with rollback capabilities
- **`/branch`** - **Context-Aware Branching**: Intelligent naming conventions based on repository analysis
- **`/sync`** - **Framework Deployment**: Complete orchestration framework synchronization with validation

### 🔊 Audio Notifications

- Task completion sounds (Swish.m4r)
- Stop event notifications (Chord.m4r)
- Permission request alerts (Aurora.m4r)
- Non-blocking background playback

## 📋 Commands

### Orchestration Framework Command Portfolio

- **Total Commands**: 14 essential orchestration commands (refined from 40+ candidates)
- **5-Star Commands**: 10 (71%) - Production-ready with sophisticated agent coordination
- **4-Star Commands**: 4 (29%) - Enhanced operations with multi-agent capabilities
- **Average Rating**: 4.7/5.0 - Industry-leading orchestration quality
- **Design Philosophy**: Intelligent specialist delegation with parallel-first execution
- **Performance Focus**: Continuous improvement through execution metrics and feedback loops
- **Verification Layer**: Automatic execution-evaluator deployment after every command

### Core Development Commands

#### `/test` - Intelligent Test Execution

```bash
/test
# Automatically discovers and runs tests
# Creates starter tests if none exist
# Detects test frameworks from package.json/README
```yaml

#### `/context` - Parallel Repository Analysis

```bash
/context
# Deploys multiple codebase-analyst agents concurrently
# Orchestrates comprehensive architecture, tech stack, and purpose analysis
# Auto-executes on Claude Code startup with intelligent load balancing
# Performance feedback loop for optimal agent allocation
```yaml

#### `/review` - Multi-Agent Quality Review

```bash
/review [file|directory]
# Orchestrates parallel deployment: code-reviewer + security-auditor + test-engineer
# Comprehensive quality validation with specialist expertise
# Performance tracking and continuous improvement metrics
# Production-ready quality gates with detailed reporting
```yaml

#### `/debug` - Orchestrated Systematic Debugging

```bash
/debug "app crashes when user logs out"
# Deploys debugger agent with systematic investigation methodology
# Coordinates evidence gathering from multiple sources
# Hypothesis formation and testing with specialist precision
# Root cause identification with validated fixes
```yaml

### Planning & Orchestration

#### `/plan` - Orchestrated Strategic Planning

```bash
/plan "Add user authentication"
# Deploys principal-architect agent for strategic requirements
# Coordinates parallel tactical planning with specialist input
# Generates TDD phases (8-15 files each) with quality gates
# Intelligent framework orchestration for complex feature development
# Outputs to ./.tmp/<feature-name>/ with comprehensive documentation
```yaml

#### `/fix-ci` - Intelligent CI Failure Resolution

```bash
/fix-ci [pr_number]
# Deploys devops agent with pattern recognition capabilities
# Orchestrates targeted fixes across multiple failure types
# Coordinates with test-engineer and security-auditor as needed
# Performance tracking for continuous improvement of fix strategies
# Automated verification with rollback capabilities
```yaml

### Quality & Security

#### Shell Script Validation System

This repository includes comprehensive **ShellCheck validation** to prevent bash syntax errors and ensure script quality:

**Features:**
- **Automated CI Validation**: All shell scripts validated on push/PR
- **Pre-commit Hooks**: Local validation before commits
- **Developer Tools**: Setup and fix scripts for easy adoption
- **Configurable Rules**: Balanced exclusions for practical development

**Usage:**
```bash
# One-time setup for developers
./scripts/setup-shellcheck.sh

# Run validation locally
shellcheck scripts/*.sh

# Auto-fix common issues
./scripts/fix-shellcheck-issues.sh
```

**CI Integration:**

- Critical scripts must pass strict validation
- Comprehensive workflow validates all repository scripts
- Results uploaded as artifacts for review
- Excludes style-only issues while catching real problems

See [ShellCheck Validation Documentation](docs/SHELLCHECK_VALIDATION.md) for complete details.

#### `/deps` - Security-Focused Dependency Management

```bash
/deps audit    # Find and fix vulnerabilities
/deps update   # Safe updates with testing
/deps clean    # Remove unused packages
# Multi-language support (npm, pip, cargo, etc.)
```yaml

#### `/agent-audit` - Orchestrated Ecosystem Validation

```bash
/agent-audit
# Deploys 8 parallel agent-auditor instances across all categories
# Comprehensive validation of 40+ agent configurations
# Performance metrics and capability gap analysis
# Continuous improvement recommendations with quality feedback loops
# Production-ready health monitoring for the entire orchestration framework
```yaml

#### `/resolve-cr` - Multi-Agent PR Resolution

```bash
/resolve-cr [pr-number]
# Intelligent parsing of CodeRabbit PR comments for specialist deployment
# Orchestrates multiple specialized agents based on comment analysis
# Coordinates with test-engineer and code-reviewer for validation
# Performance tracking and success rate optimization
# Seamless integration with /test and /commit orchestration workflow
```yaml

Note: Previously named `/resolve-rabbit`.

### Git Operations

#### `/commit` - Smart Git Commits

```bash
/commit
# Analyzes changes comprehensively
# Creates semantic commit messages
# Adds AI co-authorship attribution
```yaml

#### `/push` - Safe Push to Remote

```bash
/push
# Safety checks for branch status
# Sets up tracking for new branches
# Prevents accidental force pushes
```yaml

## 🎭 Agent Ecosystem: 40+ Specialists

The Smart Agent Orchestration Framework includes **40+ specialized agents** organized across 8 functional domains,
with sophisticated parallel execution and multi-instance capabilities:

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

### 🚀 Smart Orchestration Examples

The framework demonstrates intelligent parallel execution and specialist coordination across complex real-world
scenarios:

#### Multi-Platform Development Orchestration

```yaml
Project: Mobile App with Backend
Orchestration Strategy: Parallel specialist deployment with dependency management
Execution:
  - backend-engineer: API development & microservices
  - frontend-engineer: Admin dashboard & web interfaces
  - mobile-engineer #1: iOS native development
  - mobile-engineer #2: Android native development
  - design-system: Component library & design tokens
  - ux-researcher: User testing & feedback integration
Performance Metrics: 70% faster delivery through parallel execution
```yaml

#### Cloud Infrastructure Orchestration

```yaml
Project: Kubernetes-based Microservices Platform
Orchestration Strategy: Infrastructure-first with continuous validation
Execution:
  - platform-engineer: Platform architecture & developer experience
  - kubernetes-admin: Cluster setup & workload orchestration
  - monitoring-specialist: Observability stack & alerting
  - devops: CI/CD pipelines & deployment automation
  - cloud-architect: Cost optimization & multi-cloud strategy
Continuous Improvement: Performance feedback drives resource allocation
```yaml

#### Quality Assurance Orchestration

```yaml
Project: Production Readiness Assessment
Orchestration Strategy: Multi-dimensional quality validation with parallel execution
Execution:
  - code-reviewer: Code quality & best practices validation
  - security-auditor: Vulnerability assessment & OWASP compliance
  - test-engineer: Coverage analysis & test strategy optimization
  - performance-analyst: Performance profiling & bottleneck identification
  - accessibility-auditor: WCAG compliance & inclusive design validation
  - execution-evaluator: Command verification & success assessment
Quality Gates: 95% coverage across all quality dimensions
```yaml

#### Framework Health Orchestration

```yaml
Project: Orchestration Framework Self-Assessment
Orchestration Strategy: Parallel ecosystem validation across all domains
Execution (8 concurrent instances):
  - agent-auditor #1: Development agents (6 specialists)
  - agent-auditor #2: Infrastructure agents (8 specialists)
  - agent-auditor #3: Architecture agents (2 specialists)
  - agent-auditor #4: Design agents (4 specialists)
  - agent-auditor #5: Quality agents (6 specialists)
  - agent-auditor #6: Security agents (2 specialists)
  - agent-auditor #7: Analysis agents (8 specialists)
  - agent-auditor #8: Operations agents (11 specialists)
Performance Tracking: Real-time capability assessment and gap analysis
```yaml

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

#### Quality & Testing (7 agents)

- **test-engineer**: Test strategy, implementation, execution, CI/CD automation
- **code-reviewer**: Quality review, security checks, best practices validation
- **execution-evaluator**: Command execution verification, success validation, side-effect detection
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

## 🆕 Smart Orchestration Framework Updates

### Latest Framework Enhancements

- **Production-Ready Orchestration**: Sophisticated task delegation with performance feedback loops
- **Parallel-First Architecture**: Concurrent agent deployment optimized for maximum efficiency
- **40+ Specialized Agents**: Complete coverage across 8 functional domains with continuous expansion
- **Intelligent Task Routing**: Automatic specialist selection based on task complexity and requirements
- **Performance Monitoring**: Real-time execution metrics with continuous improvement algorithms
- **Multi-Instance Coordination**: Scalable agent deployment with intelligent load balancing

### Advanced Orchestration Capabilities

- **Smart Agent Selection**: Context-aware specialist deployment with performance optimization
- **Parallel Execution Engine**: Sophisticated coordination of concurrent agent operations
- **Quality Feedback Loops**: Continuous improvement based on execution success rates and performance metrics
- **Emergency Override System**: Pragmatic thresholds for direct action when specialists unavailable
- **Boundary Protection**: Enhanced SYSTEM BOUNDARY enforcement with automatic violation detection
- **Framework Self-Assessment**: Comprehensive ecosystem health monitoring with automated optimization

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
```yaml

### Configuration Flow

```mermaid
graph TB
    A[Repository] --> B[/sync Command]
    B --> C{Validation}
    C --> D[Backup Existing]
    D --> E[Deploy to ~/.claude/]
    E --> F[40+ Agents Available]
    E --> G[14 Commands Available]
    F --> H[Enhanced Claude CLI]
    G --> H
```yaml

## 💡 Real-World Orchestration Use Cases

### Enterprise Development Setup

```bash
# Deploy the complete Smart Agent Orchestration Framework
git clone https://github.com/damilola/claude-config.git
cd claude-config

# One-command framework deployment
/sync

# Experience intelligent orchestration: 40+ agents and 14 commands available
# Multi-agent repository analysis with performance optimization
/context

# Orchestrated test execution with framework intelligence
/test

# Multi-dimensional code review with parallel specialist deployment
/review
```yaml

### Production-Ready Quality Assurance

```bash
# Comprehensive quality orchestration
/review src/                    # Multi-agent quality validation
/agent-audit                   # Framework health assessment
/resolve-cr PR-123            # Multi-specialist PR comment resolution

# Continuous improvement workflow
git pull origin main && /sync  # Framework updates
/test                         # Orchestrated test validation
```yaml

### Advanced Framework Development

```bash
# Intelligent agent development with orchestration support
cp system-configs/.claude/agents/AGENT_TEMPLATE.md system-configs/.claude/agents/my-specialist.md

# Framework validation and deployment
./scripts/validate-agent-yaml.py  # Quality gates
/sync                             # Framework deployment
/agent-audit                      # Comprehensive ecosystem validation

# Performance tracking and continuous improvement
```yaml

## 💻 Installation

### Prerequisites

- Node.js 16+ or Python 3.8+
- Git
- Claude Code CLI

### Option 1: Smart Orchestration Framework Deployment

```bash
# Clone the orchestration framework repository
git clone https://github.com/damilola/claude-config.git
cd claude-config

# Deploy complete framework with one command
claude-code
/sync

# Validate framework deployment and agent ecosystem health
/agent-audit
```yaml

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
```yaml

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
```yaml

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
```yaml

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
```yaml

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
```yaml

#### Configuration Sync Issues

```bash
# Ensure you're in the claude-config repository
pwd  # Should show .../claude-config

# Check repository status
git status

# Force sync with validation
/sync
```yaml

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

**A:** Use the `/sync` command from within the claude-config repository. It will validate and deploy all
configurations to your `~/.claude/` directory.

### Q: How often should I update my configurations?

**A:** Run `git pull` in the claude-config repository periodically, then `/sync` to get the latest agent
definitions and commands.

### Q: What's the difference between the repository CLAUDE.md and system-configs/CLAUDE.md?

**A:** The repository CLAUDE.md describes this configuration repository. The system-configs/CLAUDE.md is deployed
to your home directory for global Claude configuration.

### Q: How do I know which agent to use?

**A:** Check the [Agent Selection Guide](docs/AGENT_SELECTION_GUIDE.md) or use `/agent-audit` to see all
available agents.

### Q: Why did my agent task fail with "SYSTEM BOUNDARY" error?

**A:** This security feature prevents agents from invoking themselves or other agents. Always let Claude handle
agent coordination.

### Q: Can agents write files directly?

**A:** No. Agents generate content, Claude writes files. This maintains security and consistency.

### Q: How can I contribute a new agent?

**A:** Use the template in `system-configs/.claude/agents/AGENT_TEMPLATE.md`, ensure valid YAML front-matter and
SYSTEM BOUNDARY protection, then submit a PR.

## 🔒 Security & Framework Protection

- **Enhanced SYSTEM BOUNDARY Protection**: Multi-layered prevention of unauthorized agent self-invocation
- **Orchestration Security**: Framework-level validation of all agent operations and task delegation
- **Principle of Least Privilege**: Each specialist has minimal required permissions with role-based access
- **No Stored Credentials**: Configuration files contain no secrets, security through architecture
- **Continuous Security Monitoring**: Automated security assessments via the security-auditor agent
- **Production-Ready Security Gates**: Comprehensive security validation throughout the orchestration pipeline

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Anthropic team for Claude and Claude Code CLI - enabling sophisticated AI orchestration
- Contributors who shaped the Smart Agent Orchestration Framework and specialist ecosystem
- Open source community for inspiration, tools, and continuous improvement principles
- Production teams who validated the framework's enterprise readiness and performance capabilities

---

<div align="center">

<!-- markdownlint-disable-next-line MD036 -->
*Built with ❤️ by the Smart Agent Orchestration Community*

<!-- markdownlint-disable-next-line MD036 -->
**Experience the future of intelligent development workflows**

[Report Bug](https://github.com/damilola/claude-config/issues) •
[Request Feature](https://github.com/damilola/claude-config/issues) •
[Documentation](https://github.com/damilola/claude-config/wiki) •
[Framework Guide](system-configs/.claude/agents/README.md)
