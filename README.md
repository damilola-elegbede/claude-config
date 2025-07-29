# Claude Configuration Repository

This repository contains backup copies of Claude configurations for easy restoration on new computers.

## Configuration Files

### 1. CLAUDE.md
- **Location**: `/Users/damilola/CLAUDE.md`
- **Purpose**: Main Claude configuration with coding standards, workflow guidelines, and language-specific rules
- **Contents**: Comprehensive development guidelines including:
  - Code quality standards
  - Planning and approval workflows (use `/plan` command to trigger)
  - Language and platform-specific guidelines
  - Git aliases and version control practices

### 2. Claude Code Settings
- **Location**: `/Users/damilola/.claude/settings.json`
- **Purpose**: Claude Code settings with audio notification hooks
- **Features**: Automatic audio notifications for task completion and stop events
- **Note**: Each project can have its own `.claude` directory with project-specific settings

### 3. Claude Commands
- **Location**: `.claude/commands/`
- **Purpose**: Custom Claude commands for enhanced workflow
- **Available Commands**:
  - `/plan` - Triggers detailed planning workflow before implementation
  - `/commit` - Creates git commits with Claude standards
  - `/push` - Safely pushes changes to remote repository
  - `/test` - Automatically discovers and runs tests in any repository
  - `/context` - Analyzes repository structure and provides comprehensive overview
  - `/sync` - (Repo-specific) Syncs configuration from this repo to user settings
  - `/review` - Runs comprehensive code review using code-reviewer agent
  - `/security` - Performs security vulnerability assessment
  - `/perf` - Analyzes performance and identifies optimization opportunities
  - `/docs` - Creates and updates documentation including SPEC files
  - `/debug` - Investigates complex bugs with systematic root cause analysis
  - `/orchestrate` - Plans optimal multi-agent execution for complex projects

### 4. Audio Notification System
- **Documentation**: `docs/AUDIO_HOOK_README.md`
- **Purpose**: Provides audio feedback for Claude Code operations
- **Features**:
  - Swish.m4r sound for task completions (Write, Edit, MultiEdit, Bash, TodoWrite)
  - Ding.m4r sound for stop events (Claude stops, subagent stops)
  - Direct afplay commands for simplicity
  - Background playback (non-blocking)

### 5. Agent Ecosystem
- **Documentation**: `agents/README.md`
- **Purpose**: Specialized AI agents for different development tasks
- **Categories**:
  - Implementation Agents (backend-staff, frontend-staff, fullstack-lead)
  - Analysis Agents (codebase-analyst, debugger, researcher)
  - Quality Assurance Agents (code-reviewer, security-auditor, test-engineer)
  - Strategic Planning Agents (principal-architect, project-orchestrator)
  - Design & Documentation Agents (ui-designer, tech-writer)
- **Features**:
  - Multi-agent parallel execution
  - Automatic agent selection based on task
  - Command shortcuts for common operations
  - Orchestration for complex projects

## Installation Instructions

To restore these configurations on a new computer:

1. **Copy CLAUDE.md** to your home directory:
   ```bash
   cp CLAUDE.md ~/CLAUDE.md
   ```

2. **Copy Claude Code settings and commands**:
   ```bash
   cp -r .claude ~/.claude
   cp settings.json ~/.claude/settings.json
   ```

**Alternative**: Once installed, you can use the `/sync` command from within this repository to update your configuration files automatically. The sync command will:
- Back up existing files before overwriting
- Copy CLAUDE.md, command files, agent configurations, and settings.json
- Exclude repository-specific files (sync.md command and docs/ folder contents)

## Using Claude Commands

Once installed, you can use the following commands in Claude:

### Planning & Development
- **`/plan <task>`** - Present a detailed implementation plan before coding
  - Example: `/plan Add user authentication to the app`
  - Claude will create a comprehensive plan and wait for approval

- **`/orchestrate <project>`** - Plan multi-agent execution for complex projects
  - Example: `/orchestrate Build e-commerce platform`
  - Optimizes parallel execution and coordinates multiple agents

- **`/context`** - Get instant repository overview
  - Analyzes project structure and technology stack
  - Uses multiple codebase-analyst agents in parallel
  - Auto-runs when Claude Code starts in a git repository

### Quality & Testing
- **`/test`** - Run tests in any repository
  - Creates base level test suite if no tests exist
  - Automatically discovers test commands from README.md
  - Falls back to common test patterns (npm test, pytest, etc.)
  - Generates framework-appropriate starter tests

- **`/review`** - Comprehensive code review
  - Runs code-reviewer, security-auditor, and qa-tester in parallel
  - Checks code quality, security vulnerabilities, and test coverage

- **`/security`** - Security vulnerability assessment
  - OWASP Top 10 compliance check
  - Authentication and authorization review
  - Provides remediation recommendations

- **`/perf`** - Performance analysis and optimization
  - Identifies bottlenecks and optimization opportunities
  - Provides benchmarks and performance metrics

### Documentation & Debugging
- **`/docs [type]`** - Create and update documentation
  - `/docs api` - API documentation with OpenAPI specs
  - `/docs spec` - Technical specification documents
  - `/docs arch` - Architecture documentation
  - Updates README files and maintains sync with code

- **`/debug <description>`** - Investigate complex bugs
  - Systematic root cause analysis
  - Handles intermittent failures and race conditions

### Git Operations
- **`/commit`** - Create a properly formatted git commit
  - Automatically adds co-authorship attribution
  - Follows conventional commit format

- **`/push`** - Push changes to remote repository
  - Includes safety checks for branch and working directory
  - Sets up tracking for new branches

- **`/sync`** - Sync configurations to user settings (repo-specific command)
  - Only available within the claude-config repository
  - Copies CLAUDE.md to ~/CLAUDE.md
  - Copies command files to ~/.claude/commands/ (excludes sync.md)
  - Copies agent configurations to ~/.claude/agents/
  - Copies settings.json with audio hooks
  - Creates backups before overwriting
  - Excludes repository documentation (docs/ folder)

## Repository Structure

```
claude-config/
├── CLAUDE.md                    # Main configuration with coding standards
├── agents/                      # Agent definitions and documentation
│   ├── README.md               # Complete agent ecosystem guide
│   ├── backend-staff.md        # Backend specialist agent
│   ├── frontend-staff.md       # Frontend specialist agent
│   ├── test-engineer.md        # Test automation agent
│   ├── tech-writer.md          # Documentation specialist
│   ├── security-auditor.md     # Security assessment agent
│   ├── codebase-analyst.md     # Code analysis specialist
│   └── project-orchestrator.md # Multi-agent coordinator
├── .claude/                     # Claude Code directory
│   ├── commands/               # Custom commands
│   │   ├── plan.md            # /plan command
│   │   ├── commit.md          # /commit command
│   │   ├── push.md            # /push command
│   │   ├── test.md            # /test command
│   │   ├── context.md         # /context command
│   │   ├── review.md          # /review command
│   │   ├── security.md        # /security command
│   │   ├── perf.md            # /perf command
│   │   ├── docs.md            # /docs command
│   │   ├── debug.md           # /debug command
│   │   ├── orchestrate.md     # /orchestrate command
│   │   └── sync.md            # /sync command (repo-specific)
│   ├── agents/                 # Specialized agent configurations
│   │   └── ...                # 19 agent configuration files
│   └── settings.local.json    # Local settings
├── .github/                     # GitHub specific files
│   ├── workflows/              # GitHub Actions workflows
│   │   ├── ci.yml             # Main CI workflow
│   │   └── pr-checks.yml      # Pull request checks
│   └── BRANCH_PROTECTION.md   # Branch protection setup guide
├── docs/                        # Repository documentation
│   ├── index.md                # Documentation home page
│   ├── api/                    # API documentation
│   │   └── agent-api.md       # Agent system API reference
│   ├── specs/                  # Technical specifications
│   │   └── agent-ecosystem-spec.md # Agent ecosystem SPEC
│   ├── AUDIO_HOOK_README.md    # Audio notification setup guide
│   ├── AGENT_SELECTION_GUIDE.md # How to choose the right agent
│   ├── PARALLEL_EXECUTION_GUIDE.md # Multi-agent parallelization
│   └── ...                     # Other documentation files
├── scripts/                     # Utility scripts
│   ├── validate_yaml.sh        # Agent YAML validation script
│   └── check_yaml.py           # Python YAML validation utility
├── tests/                       # Test suite for configurations
│   ├── commands/               # Tests for each command
│   ├── config/                 # Configuration validation tests
│   ├── integration/            # Integration tests
│   ├── utils.sh               # Test utilities
│   ├── test.sh                # Test runner script
│   ├── test_yaml_validation.sh # YAML validation tests
│   └── pre-commit-yaml-validation.sh # Pre-commit hook
├── .markdownlint-cli2.jsonc    # Markdown linter configuration with comments
├── .gitignore                  # Excludes temporary files and sensitive data
├── README.md                   # This file
└── LICENSE                     # MIT License
```

## Testing

This repository includes a comprehensive test suite to ensure all configurations and commands work correctly.

### Running Tests

To run all tests:
```bash
./tests/test.sh
```

### Test Structure

- **Command Tests** (`tests/commands/`): Validates each command file exists and has proper structure
- **Configuration Tests** (`tests/config/`): Validates CLAUDE.md and command files
- **Integration Tests** (`tests/integration/`): Tests command consistency and repository structure

### Test Results

The test runner will show:
- ✓ Green checkmarks for passing tests
- ✗ Red X marks for failing tests
- Summary of total tests run, passed, and failed

## CI/CD and Branch Protection

This repository uses GitHub Actions to ensure code quality and test all changes before merging.

### Automated Checks

All pull requests must pass the following checks:
- **Test Suite**: Runs all configuration and command tests
- **Structure Validation**: Verifies all required files exist
- **Markdown Linting**: Ensures consistent documentation formatting
- **Command Validation**: Checks command file structure
- **Security Scan**: Detects potential sensitive data

### Setting Up Branch Protection

To protect the `main` branch:
1. Go to Settings → Branches in your GitHub repository
2. Add a rule for the `main` branch
3. Enable "Require status checks to pass before merging"
4. Select all the workflow checks as required
5. See `.github/BRANCH_PROTECTION.md` for detailed setup instructions

### Workflow Status

![CI](https://github.com/damilola/claude-config/workflows/CI/badge.svg)
![PR Checks](https://github.com/damilola/claude-config/workflows/PR%20Checks/badge.svg)

## Notes

- The `.claude` directories in individual projects contain project-specific settings
- Claude Code creates these directories automatically when you work on a project
- The main configuration that affects all Claude interactions is in `CLAUDE.md`
- The `/plan` command triggers the formal planning workflow; without it, tasks proceed directly
- Always backup these files before making significant changes