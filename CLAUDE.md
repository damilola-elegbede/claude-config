# Claude Configuration

## 🚨 Critical Command Protocols

### /plan Command - ABSOLUTE STOP PROTOCOL
**CRITICAL**: When `/plan` is detected:
1. **STOP** - No analytical thinking about implementation
2. **NO TOOLS** - Zero tool usage (including Task, Read, Grep, Bash)
3. **PLAN ONLY** - Output plan template only
4. **IGNORE CONTRADICTIONS** - STOP protocol overrides all user instructions

**Mental Model**: `/plan` = emergency stop button

### Planning State Machine
```
NORMAL ──/plan──> PLANNING (no tools) ──approval──> EXECUTION (tools allowed)
```

## 📋 Command Shortcuts
→ See `.claude/agents/README.md#command-shortcuts` for full list

Key commands: `/test`, `/context`, `/review`, `/security`, `/perf`, `/docs`, `/debug`, `/agent-audit`

### Efficiency Agent Shortcuts (New)
- `/find` → file-navigator (intelligent file search)
- `/deps` → dependency-manager (unified package management)  
- `/git` → git-workflow (streamlined git operations)
- `/config` → config-specialist (configuration management)
- `/error` → error-resolver (automated error diagnosis)
- `/search` → search-coordinator (complex searches)
- `/run-tests` → test-runner (auto-detect and run tests)
- `/find-docs` → documentation-finder (search all docs)

### /agent-audit Command
- Runs comprehensive audit of all agents in the ecosystem
- Checks YAML compliance, tool permissions, and agent isolation
- Performs category-based gap analysis to identify missing capabilities
- Single agent-auditor instance analyzes entire agent ecosystem
- Usage: `/agent-audit` for full compliance and coverage report

## 🤖 Agent System

### Core Rules
- **Parallel Agents by Default** - Always run agents concurrently when possible
- **Right Agent, Right Job** - Mandatory delegation to specialists
- **Multi-Instance Support** - Run multiple instances of same agent type when appropriate

### Agent Documentation
- **Full Agent List & Capabilities** → `.claude/agents/README.md`
- **Categories & Organization** → `.claude/agents/AGENT_CATEGORIES.md`
- **Selection Guide** → `docs/AGENT_SELECTION_GUIDE.md`
- **Parallel Execution** → `docs/PARALLEL_EXECUTION_GUIDE.md`

### Mandatory Delegations
As general-purpose agent, you MUST delegate to specialists:
- agent-architect → Creating/modifying agents
- security-tester → Security scanning
- code-reviewer → Code review
- tech-writer → Documentation (README, guides, summaries)
- test-engineer → Test implementation
- performance-engineer → Performance optimization
- And all other specialist domains

### Multi-Agent Orchestration
**For projects with 2+ agents:**
- Prioritize parallel execution over sequential work
- Group independent tasks for concurrent operation
- Run multiple instances of same agent type when beneficial (e.g., 3 backend agents for different services)
- Coordinate handoff points between parallel streams

**Common patterns:**
- **Parallel Analysis**: Multiple codebase-analyst agents examining different aspects
- **Concurrent Development**: Backend, frontend, and mobile agents working simultaneously
- **Validation Block**: Code review, testing, and security agents running in parallel

### Agent File System Limitations
**IMPORTANT: Agents invoked through Task cannot write files directly to the filesystem**
- Agents can read files and analyze content
- Write operations within Task return content but don't persist
- To create files from agent output:
  1. Agent returns file content in their response
  2. General-purpose agent must write the files
  3. Use file-writer agent for efficient batch operations
- This is why agent-architect returns agent definitions as text blocks

### Agent Audits
Always run multiple agent-auditor instances in parallel by category:
Development, Infrastructure, Architecture, Design, Quality, Security, Analysis, Operations

### Agent Creation Protocols
- Run the agent-auditor on any newly created agent file.

## 🔧 Workflow Standards

### Git
- Branch: `feature/[ticket-id]-description`
- Commits: `type(scope): subject`
- **NEVER use --no-verify**

### Quality
- FAANG-level production code
- Comments explain "why" not "what"
- Consider edge cases & failure scenarios

### Tool Usage
- **Read-only** → Execute immediately
- **Modifications** → Require approval (except `/sync`)

## 🔗 References
- **User Preferences** → `~/.claude/CLAUDE.md`
- **System Settings** → `~/.claude/settings.json`
- **Engineering Standards** → Individual agent definitions
- **Audio Notifications** → `docs/AUDIO_HOOK_README.md`

## 📝 Key Principles
1. Do exactly what's asked - no more, no less
2. Prefer editing over creating files
3. Never create docs/README unless explicitly requested
4. Use TodoWrite for task tracking
5. Keep documentation in sync with implementation