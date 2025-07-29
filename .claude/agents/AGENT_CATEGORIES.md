# Agent Categories and Color Assignments

This document defines the official agent categories and their corresponding color assignments for the Claude Code agent ecosystem.

## Categories

### 1. **Development** (blue)
**Purpose**: Core programming and implementation  
**Color**: `blue`  
**Agents**: 
- backend-engineer
- frontend-engineer
- fullstack-lead
- mobile-engineer
- ml-engineer

### 2. **Infrastructure** (orange)
**Purpose**: Systems, operations, and deployment  
**Color**: `orange`  
**Agents**:
- devops
- cloud-architect
- platform-engineer
- reliability-engineer
- database-admin

### 3. **Architecture** (purple)
**Purpose**: System design and technical planning  
**Color**: `purple`  
**Agents**:
- api-architect
- principal-architect

### 4. **Design** (purple)
**Purpose**: User experience and interface design  
**Color**: `purple`  
**Agents**:
- ui-designer
- mobile-ui

### 5. **Quality** (green)
**Purpose**: Testing, review, and validation  
**Color**: `green`  
**Agents**:
- test-engineer
- performance-engineer
- code-reviewer
- accessibility-auditor
- test-runner
- error-resolver

### 6. **Security** (red)
**Purpose**: Security assessment and compliance  
**Color**: `red`  
**Agents**:
- security-auditor
- security-tester
- agent-auditor

### 7. **Analysis** (yellow)
**Purpose**: Research, documentation, and analysis  
**Color**: `yellow`  
**Agents**:
- data-engineer
- business-analyst
- codebase-analyst
- tech-writer
- researcher
- documentation-finder
- search-coordinator

### 8. **Operations** (orange)
**Purpose**: Support, coordination, and strategic planning  
**Color**: `orange`  
**Agents**:
- incident-commander
- debugger
- product-strategist
- file-navigator
- dependency-manager
- git-workflow
- config-specialist
- file-writer

## Color Assignment Guidelines

When creating new agents, use the color associated with their primary category:

- **blue**: Development work (coding, implementation)
- **orange**: Infrastructure and operations (deployment, monitoring, coordination)
- **purple**: Design and architecture (system design, UI/UX)
- **green**: Quality assurance (testing, reviews)
- **red**: Security and compliance (auditing, threat analysis)
- **yellow**: Analysis and research (data, documentation, investigation)

## Usage

1. All agents must be assigned to exactly one category
2. The agent's color field must match their category's color
3. When creating new agents, consult this document for proper categorization
4. The agent-auditor uses these categories for gap analysis

## Maintenance

This document is the single source of truth for agent categorization. Any changes to categories or color assignments should be made here first, then propagated to individual agent files.