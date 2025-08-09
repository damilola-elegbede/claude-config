# /write-prd Command

## Description
Transforms a technical implementation plan from `/plan` into a comprehensive Product Requirements Document (PRD). Uses PROACTIVELY deployed tech-writer agent to create professional, stakeholder-ready documentation in the `.tmp/` directory.

## Usage
```
/write-prd [plan-context]
```

## Arguments
- `plan-context` (optional): Description or context from a previous `/plan` command. If not provided, uses the most recent plan from conversation history.

## Behavior
When you use `/write-prd`, I will:

1. **Retrieve Implementation Plan**:
   - Extract plan from conversation history or provided context
   - Identify technical components and requirements
   - Parse implementation phases and dependencies

2. **Deploy Tech-Writer Agent**:
   - PROACTIVELY deploys specialized documentation agent
   - Transforms technical plan into business-readable PRD
   - Ensures comprehensive coverage of all aspects

3. **Generate PRD Structure**:
   - Executive Summary
   - Problem Statement
   - Solution Overview
   - User Stories & Personas
   - Functional Requirements
   - Non-Functional Requirements
   - Technical Architecture
   - Implementation Phases
   - Success Metrics
   - Risks & Mitigation
   - Timeline & Milestones
   - Appendices

4. **Output Location**:
   - Creates timestamped file in `.tmp/` directory
   - Format: `.tmp/PRD_[feature-name]_[timestamp].md`
   - Example: `.tmp/PRD_user-authentication_20240115_143022.md`

## PRD Template Structure

### 1. Executive Summary
- One-page overview for stakeholders
- Key benefits and business value
- High-level timeline and resource needs

### 2. Problem Statement
- Current state analysis
- Pain points and inefficiencies
- Opportunity cost of not implementing

### 3. Solution Overview
- Proposed approach
- Key features and capabilities
- Expected outcomes

### 4. User Stories & Personas
- Primary user personas
- User journeys and workflows
- Acceptance criteria per story

### 5. Functional Requirements
- Detailed feature specifications
- User interface requirements
- Business logic and rules
- Data requirements

### 6. Non-Functional Requirements
- Performance targets
- Security requirements
- Scalability needs
- Compliance requirements
- Accessibility standards

### 7. Technical Architecture
- System design overview
- Technology stack
- Integration points
- Data flow diagrams
- API specifications

### 8. Implementation Phases
- Phase breakdown with deliverables
- Dependencies and prerequisites
- Resource allocation
- Risk assessment per phase

### 9. Success Metrics
- KPIs and OKRs
- Measurement methodology
- Success criteria
- Post-launch evaluation plan

### 10. Risks & Mitigation
- Technical risks
- Business risks
- Mitigation strategies
- Contingency plans

### 11. Timeline & Milestones
- Gantt chart representation
- Critical path analysis
- Key milestones and checkpoints
- Go-live criteria

### 12. Appendices
- Technical specifications
- Mockups and wireframes
- Reference documentation
- Glossary of terms

## Examples

### From recent plan
```bash
/plan implement user authentication
# ... plan output ...
/write-prd
# Creates: .tmp/PRD_user-authentication_20240115_143022.md
```

### With explicit context
```bash
/write-prd "Multi-tenant SaaS platform with role-based access control, SSO integration, and audit logging"
# Creates: .tmp/PRD_multi-tenant-saas_20240115_144515.md
```

### Workflow integration
```bash
/plan complex feature        # Create implementation plan
/write-prd                  # Generate PRD from plan
/write-spec .tmp/PRD_*.md  # Generate SPEC files from PRD
```

## Output Format

The PRD follows industry standards:
- **Markdown formatting** for easy conversion
- **Professional language** suitable for stakeholders
- **Visual elements** using mermaid diagrams
- **Tables** for requirements matrices
- **Numbered sections** for easy reference

## Smart Features

### Context Extraction
- Automatically identifies plan from conversation
- Extracts technical details and requirements
- Infers business value from technical features
- Identifies stakeholders from context

### Business Translation
- Converts technical jargon to business language
- Adds ROI and value propositions
- Includes competitive analysis if relevant
- Provides executive-friendly summaries

### Completeness Checking
- Ensures all PRD sections are filled
- Flags missing information
- Suggests areas needing clarification
- Validates requirement completeness

## Integration Points

### Input Sources
- `/plan` command output
- `/orchestrate` strategic plans
- Conversation context
- Explicit requirements

### Output Consumers
- `/write-spec` for technical specifications
- Stakeholder review processes
- Project management tools
- Documentation systems

## File Management

### Naming Convention
```
.tmp/PRD_[feature-name]_[YYYYMMDD]_[HHMMSS].md
```

### Directory Structure
```
.tmp/
├── PRD_user-auth_20240115_143022.md
├── PRD_payment-gateway_20240115_150230.md
└── PRD_analytics-dashboard_20240115_161545.md
```

### Automatic Cleanup
- Files in `.tmp/` are temporary
- Not committed to version control
- Can be moved to permanent location after review

## Quality Standards

The generated PRD will include:
- **Comprehensive coverage** of all aspects
- **Clear acceptance criteria** for each requirement
- **Measurable success metrics**
- **Risk mitigation strategies**
- **Realistic timelines**
- **Stakeholder alignment** sections

## Agent Deployment

Uses specialized agents:
- **tech-writer**: Primary PRD generation
- **principal-architect**: Technical architecture sections
- **project-orchestrator**: Timeline and phase planning
- **codebase-analyst**: Current state analysis

## Typical Workflow

```bash
# 1. Create implementation plan
/plan "Build real-time collaboration features"

# 2. Generate PRD from plan
/write-prd
# Output: .tmp/PRD_realtime-collab_20240115_162030.md

# 3. Review and refine
cat .tmp/PRD_realtime-collab_*.md

# 4. Generate technical specs
/write-spec .tmp/PRD_realtime-collab_*.md

# 5. Share with stakeholders
cp .tmp/PRD_realtime-collab_*.md docs/requirements/
```

## Notes

- MUST BE USED after `/plan` for best results
- Automatically creates `.tmp/` directory if it doesn't exist
- Generates comprehensive, stakeholder-ready documentation
- Maintains traceability from plan to PRD to SPEC
- Suitable for agile and waterfall methodologies
- Can regenerate with refinements
- Preserves technical accuracy while improving readability
- Includes both business and technical perspectives
- Version-controlled through timestamps
- Can be exported to various formats (PDF, Word, etc.)