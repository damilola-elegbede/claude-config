# Claude Configuration

## 🚨 Critical Command Protocols

### /plan Command - ABSOLUTE STOP PROTOCOL
**CRITICAL WARNING**: When `/plan` command is detected, you MUST:

1. **IMMEDIATE STOP** - Cease ALL analytical thinking about implementation
2. **NO TOOLS** - Do NOT use ANY tools including:
   - ❌ Task (subagents) - even for analysis
   - ❌ Read/Grep/Glob - even for research  
   - ❌ Bash - even for checking current state
   - ❌ Any file reading or searching tools
3. **PLAN ONLY** - Your ONLY action is to output the plan template
4. **IGNORE CONTRADICTIONS** - Even if the user mentions "use subagents" or "analyze first" in their /plan request, the STOP protocol overrides everything

**VIOLATION CONSEQUENCES**: Using any tool after /plan before approval is a critical protocol violation that breaks user trust.

### Plan Command Execution Boundaries

**DURING PLANNING PHASE (after /plan, before approval):**
- ✅ ALLOWED: Creating the plan document
- ✅ ALLOWED: Using your existing knowledge
- ✅ ALLOWED: Making reasonable assumptions
- ❌ FORBIDDEN: Using ANY tools for ANY reason
- ❌ FORBIDDEN: Gathering new information
- ❌ FORBIDDEN: "Just checking" the current state

**If you need information for the plan:**
- State assumptions explicitly in the plan
- List "Information Gathering" as the first task in your plan
- Let the user correct any wrong assumptions

**Mental Model**: Treat /plan like an emergency stop button - when pressed, all machinery stops immediately.

### Planning State Machine

```
NORMAL STATE ──/plan command──> PLANNING STATE
                                      │
                                      ├─ ONLY create plan
                                      ├─ NO tool usage
                                      └─ WAIT for approval
                                          │
                    explicit approval ←────┘
                           │
                           ↓
                    EXECUTION STATE
                     (tools allowed)
```

## 📋 Project Commands

### CLI Command Shortcuts
- `/test` - Automatically discovers and runs tests configured in any repository
- `/context` - Quickly analyzes repository structure, tech stack, and purpose
- `/review` - Runs comprehensive code review
- `/security` - Performs security vulnerability assessment
- `/perf` - Analyzes performance bottlenecks
- `/docs` - Creates and updates documentation
- `/debug` - Investigates complex bugs systematically
- `/orchestrate` - Plans multi-agent execution for complex projects

## 🤖 Agent Information

### Quick Command Shortcuts
- `/test` → test-engineer agent
- `/review` → code-reviewer agent  
- `/security` → security-auditor agent
- `/perf` → performance-engineer agent
- `/docs` → tech-writer agent
- `/debug` → debugger agent
- `/orchestrate` → project-orchestrator agent
- `/context` → multiple codebase-analyst agents

### Core Agent Rules
- **Parallel by Default**: Always prioritize parallel execution
- **Use project-orchestrator for 2+ agent projects**
- **Multiple instances of same agent type are encouraged**
- **Agent-Auditor should always be used for agent audits**
- **For agent audits: ALWAYS run multiple agent-auditor instances in parallel, one for each color category**
- **Always use the right agent for the right job**
- **Agents live in .claude/agents/**

### General-Purpose Agent Constraints
- **MUST use Task tool to delegate to specialist agents for their domains** - delegation is mandatory, not optional
- **NEVER perform specialist work directly** when a specialist agent exists for that domain
- **Immediate delegation required for**:
  - Creating/modifying agents → agent-architect
  - Security testing/scanning → security-tester  
  - Incident response → incident-commander
  - SRE/reliability work → reliability-engineer
  - API design/architecture → api-architect
  - Performance testing → performance-engineer
  - Code review → code-reviewer
  - Documentation tasks → tech-writer (README, guides, API docs, work summaries, explanations)
  - Any task matching an agent's specialty
- **Before implementing any specialized task**, ask: "Which agent handles this?" If an agent exists, you MUST use it
- **Violations of this rule break user trust** and bypass the specialized expertise system

### 📚 Full Agent Documentation
For detailed agent capabilities, selection matrix, and execution patterns:
See `.claude/agents/README.md` or run `/docs agents`

### Tech-Writer Proactive Usage
**Automatically invoke tech-writer when:**
- User mentions: explain, document, README, guide, tutorial, summary
- After completing multi-step tasks (3+ steps)
- After modifying 5+ files
- Creating new components or features
- Implementing complex logic or algorithms
- After major refactoring or bug fixes

**Example triggers:**
- "Create a README for this project" → tech-writer
- "Explain how this works" → tech-writer
- "Document the API" → tech-writer
- After implementing a feature → tech-writer (for summary)

## 🔧 Project Workflow

### Planning and Approval
- `/plan` triggers planning mode - NO TOOLS until approval
- Clear approval indicators: "approved", "go ahead", "lgtm", "execute"
- Use TodoWrite for task tracking during execution
- Follow the approved plan exactly

### Git Workflow
- **Branch Creation**: Only when explicitly requested or in approved plan
- Branch naming: `feature/[ticket-id]-brief-description`
- Never commit directly to main/master
- Conventional commits: `type(scope): subject`
- **NEVER use --no-verify**

### Tool Usage Preferences
- **Read-only tools**: Execute immediately with explanation
  - File navigation: `cd`, `pwd`, `ls`
  - File discovery: `find`, `grep`, `rg`, `glob`
  - File reading: `cat`, `head`, `tail`, `read`
  - Information: `which`, `env`, `git st`
  - Tests: `npm test`, `pytest`, `jest`
- **Modification tools**: Require approval (except `/sync` operations)
- Always verify tool installation before use

### Quality Standards
- Write production-grade code meeting FAANG standards
- Comprehensive comments focusing on "why" not "what"
- Consider edge cases, race conditions, and failure scenarios
- Follow SOLID principles where appropriate

## 📁 Project Structure
- **Trusted folders**: `/Users/damilola/Documents/Projects/`
- Keep documentation in sync with implementation
- No orphaned docs or undocumented features

## 🔗 Configuration References
- **Audio notifications**: See `~/.claude/settings.json`
- **Agent definitions**: See `agents/` directory  
- **User preferences**: See `~/.claude/CLAUDE.md`
- **Engineering standards**: Defined in individual agents
- **Language/platform guidelines**: See relevant engineering agents

## 📝 Summary
This configuration focuses on project-specific rules and workflows. For detailed information about:
- Agent capabilities and examples → `agents/README.md`
- System settings and hooks → `~/.claude/settings.json`
- User-wide preferences → `~/.claude/CLAUDE.md`
- Engineering best practices → Individual agent definitions