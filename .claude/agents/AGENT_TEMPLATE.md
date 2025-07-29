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