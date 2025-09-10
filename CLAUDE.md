This is a Claude Code CLI Configuration Repository - a clean, organized system for managing Claude
configurations, specialized agents, and custom commands with the Claude Code CLI.

The core Claude configurations live in the system-configs directory, which serves as the source of truth for all
system settings. This directory contains the main CLAUDE.md configuration file, the .claude subdirectory with agents
and commands definitions, and a settings.json file for audio notification preferences. All agent definitions are
stored as Markdown files with YAML front-matter in system-configs/.claude/agents/, while custom commands reside in
system-configs/.claude/commands/. These configurations are designed to be synced to your home directory for use with
the Claude Code CLI.

The sync command is the primary mechanism for deploying configurations from this repository to your local Claude
setup. Running /sync copies all configurations from system-configs/ to ~/.claude/, validating agent YAML compliance
before deployment and creating automatic backups of existing configurations. The sync process intelligently excludes
documentation and template files, ensuring only active configurations are deployed. This command should be run
whenever you modify agents or commands in this repository to update your local Claude environment.

To create new agents or commands, use the provided templates located in the docs directory. For agents, follow the
template at docs/agents/AGENT_TEMPLATE.md, ensuring proper YAML front-matter syntax and including the required SYSTEM
BOUNDARY protection that prevents agents from invoking themselves or other agents. For commands, use the template at
docs/commands/COMMAND_TEMPLATE.md to maintain consistency with existing command patterns. After creating new
configurations, run the validation scripts like ./scripts/validate-agent-yaml.py to ensure compliance before syncing
changes to your local environment.

