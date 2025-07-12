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
- **Location**: `/Users/damilola/.claude/settings.local.json`
- **Purpose**: Claude Code local settings
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

## Installation Instructions

To restore these configurations on a new computer:

1. **Copy CLAUDE.md** to your home directory:
   ```bash
   cp CLAUDE.md ~/CLAUDE.md
   ```

2. **Copy Claude Code settings and commands**:
   ```bash
   cp -r .claude ~/.claude
   ```

**Alternative**: Once installed, you can use the `/sync` command from within this repository to update your configuration files automatically.

## Using Claude Commands

Once installed, you can use the following commands in Claude:

- **`/plan <task>`** - Present a detailed implementation plan before coding
  - Example: `/plan Add user authentication to the app`
  - Claude will create a comprehensive plan and wait for approval

- **`/commit`** - Create a properly formatted git commit
  - Automatically adds co-authorship attribution
  - Follows conventional commit format

- **`/push`** - Push changes to remote repository
  - Includes safety checks for branch and working directory
  - Sets up tracking for new branches

- **`/test`** - Run tests in any repository
  - Creates base level test suite if no tests exist
  - Automatically discovers test commands from README.md
  - Falls back to common test patterns (npm test, pytest, etc.)
  - Generates framework-appropriate starter tests
  - Works with any language or framework

- **`/context`** - Get instant repository overview
  - Analyzes project structure and technology stack
  - Summarizes documentation and available commands
  - Auto-runs when Claude Code starts in a git repository

- **`/sync`** - Sync configurations to user settings (repo-specific command)
  - Only available within the claude-config repository
  - Copies CLAUDE.md to ~/CLAUDE.md
  - Copies command files to ~/.claude/commands/
  - Creates backups before overwriting

## Repository Structure

```
claude-config/
├── CLAUDE.md                    # Main configuration with coding standards
├── .claude/                     # Claude Code directory
│   ├── commands/               # Custom commands
│   │   ├── plan.md            # /plan command
│   │   ├── commit.md          # /commit command
│   │   ├── push.md            # /push command
│   │   ├── test.md            # /test command
│   │   ├── context.md         # /context command
│   │   └── sync.md            # /sync command (repo-specific)
│   └── settings.local.json    # Local settings
├── .github/                     # GitHub specific files
│   ├── workflows/              # GitHub Actions workflows
│   │   ├── ci.yml             # Main CI workflow
│   │   └── pr-checks.yml      # Pull request checks
│   └── BRANCH_PROTECTION.md   # Branch protection setup guide
├── tests/                       # Test suite for configurations
│   ├── commands/               # Tests for each command
│   ├── config/                 # Configuration validation tests
│   ├── integration/            # Integration tests
│   └── utils.sh               # Test utilities
├── test.sh                     # Test runner script
├── .gitignore                  # Excludes temporary files and sensitive data
├── README.md                   # This file
└── LICENSE                     # MIT License
```

## Testing

This repository includes a comprehensive test suite to ensure all configurations and commands work correctly.

### Running Tests

To run all tests:
```bash
./test.sh
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