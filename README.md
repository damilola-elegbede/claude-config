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

### 2. .claude.json
- **Location**: `/Users/damilola/.claude.json`
- **Purpose**: Claude JSON configuration file (contains sensitive user data)
- **Usage**: General Claude settings and preferences
- **Note**: This file contains personal information and is excluded from the repository. Use `.claude.json.template` as a reference

### 3. Claude Desktop Configuration
- **File**: `claude_desktop_config.json`
- **Install Location**: `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Purpose**: Claude desktop application settings
- **Platform**: macOS specific

### 4. Claude Code Settings
- **Location**: `/Users/damilola/.claude/settings.local.json`
- **Purpose**: Claude Code local settings
- **Note**: Each project can have its own `.claude` directory with project-specific settings

### 5. Claude Commands
- **Location**: `.claude/commands/`
- **Purpose**: Custom Claude commands for enhanced workflow
- **Available Commands**:
  - `/plan` - Triggers detailed planning workflow before implementation
  - `/commit` - Creates git commits with Claude standards
  - `/push` - Safely pushes changes to remote repository

## Installation Instructions

To restore these configurations on a new computer:

1. **Copy CLAUDE.md** to your home directory:
   ```bash
   cp CLAUDE.md ~/CLAUDE.md
   ```

2. **Create .claude.json** from template (contains sensitive data, not in repo):
   ```bash
   cp .claude.json.template ~/.claude.json
   # Edit ~/.claude.json to add your personal settings
   ```

3. **Copy Claude desktop config** (macOS):
   ```bash
   mkdir -p ~/Library/Application\ Support/Claude
   cp claude_desktop_config.json ~/Library/Application\ Support/Claude/
   ```

4. **Copy Claude Code settings and commands**:
   ```bash
   cp -r .claude ~/.claude
   ```

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

## Repository Structure

```
claude-config/
├── CLAUDE.md                    # Main configuration with coding standards
├── .claude.json.template        # Template for Claude settings (actual .claude.json is gitignored)
├── claude_desktop_config.json   # Claude desktop app configuration
├── .claude/                     # Claude Code directory
│   ├── commands/               # Custom commands
│   │   ├── plan.md            # /plan command
│   │   ├── commit.md          # /commit command
│   │   └── push.md            # /push command
│   └── settings.local.json    # Local settings
├── .gitignore                  # Excludes temporary files and sensitive data
├── README.md                   # This file
└── LICENSE                     # MIT License
```

## Notes

- The `.claude` directories in individual projects contain project-specific settings
- Claude Code creates these directories automatically when you work on a project
- The main configuration that affects all Claude interactions is in `CLAUDE.md`
- The `/plan` command triggers the formal planning workflow; without it, tasks proceed directly
- Always backup these files before making significant changes