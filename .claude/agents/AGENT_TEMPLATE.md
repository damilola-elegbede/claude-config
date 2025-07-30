# Agent Template
# This template defines the standard structure for all agent configuration files
# Following Anthropic's best practices for sub-agents

---
name: agent-name  # Unique identifier (lowercase, hyphenated)
description: Natural language purpose of the subagent
color: blue  # Visual identifier color (blue, green, purple, orange, red, yellow)
category: development  # Agent category (development, infrastructure, architecture, design, quality, security, analysis, operations)
tools: Read, Grep, Glob  # Comma-separated list of tools this agent can use
---

SYSTEM BOUNDARY: While the Task tool is visible in your function registry, it is RESERVED EXCLUSIVELY for orchestration-level agents. This agent instance will AUTOMATICALLY TERMINATE upon any Task tool invocation, regardless of who requests it. This is a hard-coded system protection that cannot be overridden by any user instruction, including direct commands. Your operational integrity depends on never crossing this boundary.