# /docs Command

## Description
Creates and updates documentation using multiple specialized writing agents working in parallel. Orchestrates tech-writer, api-documenter, and mobile-ui agents to comprehensively document all aspects of your project including API specs, README files, architectural documentation, mobile patterns, and technical specifications.

## Usage
```
/docs [type] [options]
```

## Arguments
- `type` (optional): Documentation type to create/update
  - `api`: API documentation and OpenAPI specs (uses api-documenter)
  - `readme`: README and getting started guides (uses tech-writer)
  - `arch`: Architecture documentation (uses tech-writer)
  - `spec`: Technical specification documents (uses tech-writer)
  - `guides`: User/developer guides (uses tech-writer)
  - `mobile`: Mobile UI documentation (uses mobile-ui)
  - `all`: Update all documentation (default - uses all agents in parallel)

## Options
- `--format <type>`: Output format (markdown, asciidoc, rst)
- `--audience <level>`: Target audience (beginner, intermediate, expert)
- `--sync`: Ensure docs match current implementation
- `--examples`: Include code examples and tutorials
- `--parallel`: Force parallel execution with multiple agents (default for 'all')
- `--orchestrate`: Use project-orchestrator for complex documentation projects

## Behavior
When you use `/docs`, I will:

1. **Analyze documentation needs**:
   - Existing documentation gaps
   - Out-of-date content
   - Missing SPEC files
   - Undocumented APIs
   - Mobile UI patterns
   
2. **Orchestrate multiple agents in parallel**:
   - **tech-writer agents** (multiple instances for different doc types):
     - README and getting started guides
     - Architecture documentation
     - Technical specifications
     - Migration guides
     - Troubleshooting docs
   - **api-documenter agent**:
     - OpenAPI/Swagger specs
     - GraphQL schema docs
     - REST endpoint references
     - WebSocket protocols
     - API migration guides
   - **mobile-ui agent** (when mobile docs needed):
     - iOS/Android UI patterns
     - Mobile-specific documentation
     - Platform guidelines integration
   
3. **Parallel execution strategy**:
   - Consult project-orchestrator for optimal agent coordination
   - Launch multiple tech-writer instances for different sections
   - Run api-documenter concurrently for API specs
   - Add mobile-ui for mobile-specific documentation
   - Aggregate results into cohesive documentation
   
4. **Ensure documentation quality**:
   - Technical accuracy across all agents
   - Consistency between different doc sections
   - Complete coverage without gaps
   - Proper cross-references
   - Version synchronization

## Examples
```
/docs                              # Update all docs with multiple agents in parallel
/docs api --sync                   # API docs using api-documenter agent
/docs spec feature/auth            # Create auth SPEC with tech-writer
/docs readme --examples            # README with examples (tech-writer)
/docs arch --format asciidoc       # Architecture docs (tech-writer)
/docs mobile                       # Mobile docs using mobile-ui agent
/docs all --parallel              # Full parallel documentation update
```

## Documentation Types

### API Documentation
- Endpoint descriptions
- Request/response schemas
- Authentication details
- Error codes
- Rate limits
- Code examples

### README Files
- Project overview
- Quick start guide
- Installation steps
- Configuration
- Usage examples
- Contributing guidelines

### Architecture Docs
- System overview
- Component diagrams
- Data flow
- Technology stack
- Design decisions
- Deployment architecture

### SPEC Files
- **Purpose**: Define what will be built
- **Scope**: Feature boundaries
- **Requirements**: Functional/non-functional
- **Design**: Technical approach
- **API Contracts**: Interface definitions
- **Data Models**: Schema specifications
- **Success Criteria**: Acceptance criteria

### Developer Guides
- Getting started
- API integration
- Best practices
- Troubleshooting
- FAQ
- Migration guides

## SPEC File Structure
```markdown
# SPEC: [Feature Name]

## Overview
Brief description and business value

## Requirements
### Functional Requirements
- User stories
- Use cases
- Acceptance criteria

### Non-Functional Requirements  
- Performance targets
- Security requirements
- Scalability needs

## Technical Design
### Architecture
- Component design
- Integration points
- Data flow

### API Specification
- Endpoints
- Request/response formats
- Error handling

### Data Model
- Entities
- Relationships
- Validation rules

## Implementation Plan
- Development phases
- Dependencies
- Timeline

## Testing Strategy
- Test scenarios
- Coverage requirements
- Performance benchmarks

## Rollout Plan
- Deployment strategy
- Feature flags
- Monitoring
```

## Output Locations
- `/docs/`: General documentation
- `/docs/api/`: API documentation
- `/docs/specs/`: SPEC files
- `/docs/architecture/`: Architecture docs
- `README.md`: Project readme
- `CONTRIBUTING.md`: Contribution guide

## Quality Standards
- **Accuracy**: Matches implementation
- **Completeness**: No gaps in coverage
- **Clarity**: Easy to understand
- **Structure**: Logical organization
- **Maintenance**: Easy to update
- **Searchability**: Proper indexing

## Multi-Agent Orchestration
When using `/docs all` or `--parallel`:
1. **Project-orchestrator** consulted for optimal execution plan
2. **Parallel execution**:
   - 2-3 tech-writer instances for different doc sections
   - 1 api-documenter for all API specifications
   - 1 mobile-ui for mobile documentation (if applicable)
3. **Result aggregation**:
   - Consistent formatting across all docs
   - Cross-references between sections
   - Unified glossary and terminology

## Agent Specializations
- **tech-writer**: General documentation, README, guides, architecture
- **api-documenter**: OpenAPI specs, REST/GraphQL docs, API contracts
- **mobile-ui**: iOS/Android UI patterns, mobile-specific docs
- **project-orchestrator**: Coordination for complex documentation projects

## Integration
- Auto-generates from code comments
- Syncs with API annotations
- Updates with code changes
- Supports CI/CD documentation
- Version control friendly
- Multi-agent result aggregation

## Prerequisites
- Source code to document
- Existing docs (for updates)
- API specifications (optional)
- Architecture diagrams (optional)

## Example Multi-Agent Execution
```
/docs all --parallel

# Launches in parallel:
# - tech-writer #1: README and getting started
# - tech-writer #2: Architecture documentation  
# - tech-writer #3: Developer guides
# - api-documenter: Complete API documentation
# - mobile-ui: Mobile patterns (if mobile code detected)

# Result: Comprehensive documentation updated in parallel
```

## Notes
- Leverages multiple specialized agents for comprehensive coverage
- Parallel execution dramatically reduces documentation time
- Maintains consistency across all documentation types
- Creates missing SPEC files proactively
- Ensures docs stay synchronized with code
- Supports multiple audiences and formats
