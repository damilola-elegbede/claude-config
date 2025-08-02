# /docs Command

## Description
Creates and updates documentation using specialized tech-writer agents working in parallel. Orchestrates multiple tech-writer instances to comprehensively document all aspects of your project including API specs, README files, architectural documentation, and technical specifications.

## Usage
```
/docs [type] [options]
```

## Arguments
- `type` (optional): Documentation type to create/update
  - `api`: API documentation and OpenAPI specs (uses tech-writer)
  - `readme`: README and getting started guides (uses tech-writer)
  - `arch`: Architecture documentation (uses tech-writer)
  - `spec`: Technical specification documents (uses tech-writer)
  - `guides`: User/developer guides (uses tech-writer)
  - `all`: Update all documentation (default - uses multiple tech-writer agents in parallel)

## Options
- `--format <type>`: Output format (markdown, asciidoc, rst)
- `--audience <level>`: Target audience (beginner, intermediate, expert)
- `--sync`: Ensure docs match current implementation
- `--examples`: Include code examples and tutorials
- `--parallel`: Force parallel execution with multiple agents (default for 'all')
- `--comprehensive`: Create comprehensive documentation across all areas

## Behavior
When you use `/docs`, I will:

1. **Analyze documentation needs**:
   - Existing documentation gaps
   - Out-of-date content
   - Missing SPEC files
   - Undocumented APIs
   - Mobile UI patterns
   
2. **Orchestrate multiple tech-writer agents in parallel**:
   - **tech-writer agents** (multiple instances for different doc types):
     - README and getting started guides
     - Architecture documentation
     - Technical specifications
     - API documentation and OpenAPI specs
     - Migration guides
     - Troubleshooting docs
     - Mobile UI patterns and platform guidelines
   
3. **Parallel execution strategy**:
   - Claude orchestrates optimal agent coordination
   - Launch multiple tech-writer instances for different sections
   - Run specialized tech-writer for API specifications
   - Include mobile documentation patterns when needed
   - Aggregate results into cohesive documentation
   
4. **Ensure documentation quality**:
   - Technical accuracy across all agents
   - Consistency between different doc sections
   - Complete coverage without gaps
   - Proper cross-references
   - Version synchronization

## Examples
```
/docs                              # Update all docs with multiple tech-writer agents in parallel
/docs api --sync                   # API docs using specialized tech-writer
/docs spec feature/auth            # Create auth SPEC with tech-writer
/docs readme --examples            # README with examples (tech-writer)
/docs arch --format asciidoc       # Architecture docs (tech-writer)
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
   - 2-4 tech-writer instances for different doc sections
   - Specialized assignments for API specs, mobile docs, architecture
3. **Result aggregation**:
   - Consistent formatting across all docs
   - Cross-references between sections
   - Unified glossary and terminology

## Agent Specializations
- **tech-writer**: Comprehensive documentation including README, guides, architecture, API specs, mobile patterns
- **Claude orchestration**: Coordination for complex documentation projects

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
# - tech-writer #3: API documentation and specifications
# - tech-writer #4: Developer guides and mobile patterns

# Result: Comprehensive documentation updated in parallel
```

## Notes
- Leverages multiple tech-writer agents for comprehensive coverage
- Parallel execution dramatically reduces documentation time
- Maintains consistency across all documentation types
- Creates missing SPEC files proactively
- Ensures docs stay synchronized with code
- Supports multiple audiences and formats
