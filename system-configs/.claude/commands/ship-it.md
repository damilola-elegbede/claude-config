# /ship-it Command

## Description

Instructs Claude to execute a development workflow by running multiple Claude commands in sequence.
Leverages Claude's full intelligence and agent orchestration for each step.

## Usage

```bash
/ship-it                    # Full workflow (default)
/ship-it --basic            # Basic workflow  
/ship-it --quick            # Quick workflow
```

## Workflows

```yaml
Full (Default): /review → /test → /commit → /push → /pr (if no PR exists)
Basic: /review --quick → /commit → /push
Quick: /commit → /push
```

## Behavior

When invoked, I will execute a sequence of Claude commands with full agent orchestration.
Each command runs with complete context awareness, specialized agents, and quality gates.
The workflow continues sequentially with fail-fast behavior (except /pr which is non-fatal).

## Execution Logic

```bash
ship_it() {
  local workflow="${1:-full}"
  
  echo "🚀 Starting ship-it workflow: $workflow"
  echo ""
  
  case "$workflow" in
    "quick")
      echo "I will now execute the Quick workflow:"
      echo "1. /commit - Smart git operations with quality gates"
      echo "2. /push - Safe repository operations with validation"
      ;;
    "basic") 
      echo "I will now execute the Basic workflow:"
      echo "1. /review --quick - Quick code review with essential checks"
      echo "2. /commit - Smart git operations with quality gates"
      echo "3. /push - Safe repository operations with validation"
      ;;
    "full"|*)
      echo "I will now execute the Full workflow:"
      echo "1. /review - Multi-agent code analysis with comprehensive quality gates"
      echo "2. /test - Intelligent test discovery and execution with framework detection"
      echo "3. /commit - Smart git operations with semantic commit generation"
      echo "4. /push - Safe repository operations with pre-push validation"
      echo "5. /pr - Intelligent PR creation with context-aware descriptions (if no PR exists)"
      ;;
  esac
  
  echo ""
  echo "Each command will use Claude's full intelligence with:"
  echo "• Agent orchestration and specialized expertise"
  echo "• Context awareness and quality gates"  
  echo "• Fail-fast behavior (stopping on first failure except /pr)"
  echo ""
  echo "Ready to begin the workflow."
}
```

## Examples

### Full Workflow

```bash
User: /ship-it
Claude: 🚀 Starting ship-it workflow: full

I will now execute the Full workflow:
1. /review - Multi-agent code analysis with comprehensive quality gates
2. /test - Intelligent test discovery and execution with framework detection
3. /commit - Smart git operations with semantic commit generation
4. /push - Safe repository operations with pre-push validation
5. /pr - Intelligent PR creation with context-aware descriptions (if no PR exists)

Each command will use Claude's full intelligence with:
• Agent orchestration and specialized expertise
• Context awareness and quality gates
• Fail-fast behavior (stopping on first failure except /pr)

Ready to begin the workflow.

[Claude then executes each command with full agent orchestration]
```

### Basic Workflow

```bash
User: /ship-it --basic
Claude: 🚀 Starting ship-it workflow: basic

I will now execute the Basic workflow:
1. /review --quick - Quick code review with essential checks
2. /commit - Smart git operations with quality gates
3. /push - Safe repository operations with validation

Each command will use Claude's full intelligence with:
• Agent orchestration and specialized expertise
• Context awareness and quality gates
• Fail-fast behavior (stopping on first failure except /pr)

Ready to begin the workflow.
```

### Quick Workflow

```bash
User: /ship-it --quick
Claude: 🚀 Starting ship-it workflow: quick

I will now execute the Quick workflow:
1. /commit - Smart git operations with quality gates
2. /push - Safe repository operations with validation

Each command will use Claude's full intelligence with:
• Agent orchestration and specialized expertise
• Context awareness and quality gates
• Fail-fast behavior (stopping on first failure except /pr)

Ready to begin the workflow.
```

## Key Features

- **Meta-Command**: Instructs Claude to execute command sequences with full intelligence
- **Agent Orchestration**: Each command uses specialized agents and quality gates  
- **Three Workflows**: Full (5 commands), basic (3 commands), quick (2 commands)
- **Context Awareness**: Commands run with complete repository and change context
- **Fail-Fast**: Workflow stops on first failure (except /pr which is non-fatal)

## Notes

- Commands are executed by Claude with full agent orchestration, not bash functions
- Each command leverages Claude's specialized agents and intelligence
- /pr command is non-fatal and will continue workflow even if it fails
- Default workflow is "full" if no flags specified
