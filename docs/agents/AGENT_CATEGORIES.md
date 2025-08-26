# Agent Categories and Color Assignments

## Overview

This document defines the official 8 agent categories and their corresponding color assignments for the Claude Code
agent ecosystem. All 28 production agents are organized into these categories based on their primary function and
expertise domain.

## The 8 Official Categories

### 1. **Development** (blue) - 7 agents

**Purpose**: Core programming, implementation, and application building  
**Agents**:

- backend-engineer
- frontend-engineer
- frontend-architect
- fullstack-lead
- mobile-engineer
- data-engineer
- ml-engineer

### 2. **Quality** (green) - 4 agents

**Purpose**: Testing, code review, validation, and quality assurance  
**Agents**:

- test-engineer
- code-reviewer
- performance-engineer
- accessibility-auditor

### 3. **Security** (red) - 1 agent

**Purpose**: Security assessment, vulnerability detection, and compliance  
**Agents**:

- security-auditor

### 4. **Architecture** (purple) - 3 agents

**Purpose**: System design, technical planning, and architectural decisions  
**Agents**:

- principal-architect
- api-architect
- cloud-architect

### 5. **Design** (pink) - 3 agents

**Purpose**: User experience, interface design, and user research  
**Agents**:

- ui-designer
- mobile-ui
- ux-researcher

### 6. **Analysis** (yellow) - 3 agents

**Purpose**: Research, codebase analysis, and requirements gathering  
**Agents**:

- codebase-analyst
- researcher
- business-analyst

### 7. **Infrastructure** (orange) - 4 agents

**Purpose**: Operations, deployment, platform engineering, and database management  
**Agents**:

- devops
- platform-engineer
- database-admin
- debugger

### 8. **Coordination** (cyan) - 3 agents

**Purpose**: Strategy, documentation, and project orchestration  
**Agents**:

- product-strategist
- project-orchestrator
- tech-writer

## Color Assignment Rules

1. **Exactly 8 Categories**: Claude supports exactly 8 agent colors, so we maintain exactly 8 categories
2. **Primary Function**: Agents are categorized by their primary function, not secondary capabilities
3. **No White Color**: White is not used as it has poor visibility in some UIs
4. **Consistent Assignment**: Each agent must have exactly one category and its corresponding color

## Category Validation Rules

When validating agents with `/agent-audit`:

1. **Color Match**: Agent's color field must match their category's assigned color
2. **Category Field**: Agent's category field must match one of the 8 official categories
3. **No Orphans**: Every agent must belong to exactly one category
4. **Count Limits**: No category should have more than 7 agents (balanced distribution)

## Usage in Agent Files

In each agent's YAML front-matter:

```yaml
---
name: agent-name
description: Agent description...
tools: Read, Write, Edit, Grep, Glob, Bash  # Only include what's needed
model: sonnet
category: development  # Must be one of the 8 categories
color: blue           # Must match category's color
---
```

## Maintenance

- **Adding Agents**: New agents must fit into one of the 8 existing categories
- **Rebalancing**: If a category grows too large (>7 agents), consider splitting responsibilities
- **Validation**: Run `/agent-audit` to verify all agents comply with category assignments
- **Documentation**: Update this file when category definitions evolve

## Quick Reference

| Category | Color | Count | Primary Focus |
|----------|-------|-------|---------------|
| Development | blue | 7 | Coding & Implementation |
| Quality | green | 4 | Testing & Validation |
| Security | red | 1 | Security & Compliance |
| Architecture | purple | 3 | System Design |
| Design | pink | 3 | UI/UX |
| Analysis | yellow | 3 | Research & Investigation |
| Infrastructure | orange | 4 | Operations & Platform |
| Coordination | cyan | 3 | Strategy & Documentation |

**Total**: 28 agents across 8 categories
