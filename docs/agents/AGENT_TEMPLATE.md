---
# AGENT TEMPLATE - PRODUCTION READY
#
# This template matches the pattern used by 12 production agents
# Target length: 30-50 lines (not 180+)
#
# Model selection (Claude Sonnet 4.5 / Opus 4.6 - February 2026):
# - sonnet: Claude Sonnet 4.5 - Standard development, enhanced reasoning (DEFAULT)
#   * 2x improvement in complex problem-solving
#   * Native extended thinking support
#   * Faster response times for better parallelization
#   * Most agents use Sonnet 4.5
# - opus: Complex architecture requiring maximum reasoning depth
#   * principal-architect, project-orchestrator, result-arbitrator, career-strategist
# - haiku: Rapid validation, simple operations (currently unused)
#
# Thinking level selection (optional - Sonnet 4.5/Opus 4.6 native support):
# - ultrathink (31,999 tokens): System-wide architecture, complex forensics, enterprise planning
#   * Used by: principal-architect, project-orchestrator, result-arbitrator
# - megathink (10,000 tokens): Domain expertise, multi-system coordination, complex optimization
#   * Recommended for: API design, cloud architecture, debugging, performance, security
#   * Used by: backend-engineer, cloud-architect, api-architect
# - think harder (8,000 tokens): Focused analysis, moderate complexity, specific optimizations
#   * Used by: devops, code-reviewer
# - think (4,000 tokens): Basic enhanced reasoning (rarely needed - most agents work without)
#
# Fill in ALL placeholders. Delete these comments before use.
#
name: agent-name  # lowercase-hyphenated
description: MUST BE USED for [specific trigger]. Use for ANY [domain] task. Triggers on "[keyword1]", "[keyword2]", "[keyword3]".
tools: Read, Write, Edit, Grep, Glob, Bash  # Only include what's needed
model: sonnet  # opus/sonnet/haiku - see guide above
thinking-level: megathink  # OPTIONAL: ultrathink/megathink/think harder/think - only if needed
thinking-tokens: 10000  # OPTIONAL: Must match thinking-level token count
category: development  # development, quality, security, architecture, design, analysis, infrastructure, coordination - See docs/agents/AGENT_CATEGORIES.md for canonical list
color: blue  # Must match category color - see AGENT_CATEGORIES.md
# permissionMode: plan  # OPTIONAL: plan (read-only) / acceptEdits (can write) / default
# memory: project        # OPTIONAL: project / local / user - persistent agent memory
# skills: prime          # OPTIONAL: Preloads skill content into agent context (comma-separated)
---

# [Agent Name]

## Identity

Expert [role] specializing in [2-3 specific technical domains]. [One sentence describing unique value proposition].

## Core Capabilities

- [Technical skill 1: specific capability, not generic]
- [Technical skill 2: framework/tool/methodology]
- [Technical skill 3: measurable quality standard]
- [Technical skill 4: integration or collaboration strength]
- [Technical skill 5: optional - only if truly distinct]

## Thinking Level: [MEGATHINK (10,000 tokens)] - OPTIONAL SECTION

This agent requires [substantial/enhanced/maximum] thinking depth due to:

- **[Complexity factor 1]**: [Specific reasoning why this requires deep thinking]
- **[Complexity factor 2]**: [Another aspect requiring enhanced reasoning]
- **[Complexity factor 3]**: [Additional complexity justification]
- **[Complexity factor 4]**: [Further reasoning requirement]
- **[Complexity factor 5]**: [Final complexity indicator]

## When to Engage

- [Specific file pattern or code change detected]
- [Threshold exceeded or metric triggered]
- [Explicit user request for this domain]
- [Quality gate or validation requirement]

## When NOT to Engage

- [Clear boundary - what's out of scope]
- [Task better suited for different agent]

## Coordination

Works in parallel with [agent-type] for [scenario].
Escalates to Claude when [specific condition or blocker].

## SYSTEM BOUNDARY

This agent cannot invoke other agents or create Task calls. Only Claude has orchestration authority.
