# /docs Command

## Description
Creates and updates documentation using the tech-writer agent, including API docs, README files, architectural documentation, and SPEC files for comprehensive technical specifications.

## Usage
```
/docs [type] [options]
```

## Arguments
- `type` (optional): Documentation type to create/update
  - `api`: API documentation and OpenAPI specs
  - `readme`: README and getting started guides
  - `arch`: Architecture documentation
  - `spec`: Technical specification documents
  - `guides`: User/developer guides
  - `all`: Update all documentation (default)

## Options
- `--format <type>`: Output format (markdown, asciidoc, rst)
- `--audience <level>`: Target audience (beginner, intermediate, expert)
- `--sync`: Ensure docs match current implementation
- `--examples`: Include code examples and tutorials

## Behavior
When you use `/docs`, I will:

1. **Analyze documentation needs**:
   - Existing documentation gaps
   - Out-of-date content
   - Missing SPEC files
   - Undocumented APIs
   
2. **Launch tech-writer agent** to create:
   - Comprehensive documentation
   - Technical specifications
   - API references
   - Architecture diagrams
   - Migration guides
   - Troubleshooting docs
   
3. **Generate SPEC files** for:
   - Feature specifications
   - System design documents
   - Interface contracts
   - Data models
   - Process flows
   
4. **Ensure documentation quality**:
   - Technical accuracy
   - Completeness
   - Clarity and readability
   - Proper structure
   - Cross-references

## Examples
```
/docs                              # Update all documentation
/docs api --sync                   # Sync API docs with code
/docs spec feature/auth            # Create auth feature SPEC
/docs readme --examples            # README with examples
/docs arch --format asciidoc       # Architecture in AsciiDoc
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

## Integration
- Auto-generates from code comments
- Syncs with API annotations
- Updates with code changes
- Supports CI/CD documentation
- Version control friendly

## Prerequisites
- Source code to document
- Existing docs (for updates)
- API specifications (optional)
- Architecture diagrams (optional)

## Notes
- Maintains documentation standards
- Creates missing SPEC files proactively
- Ensures docs stay synchronized
- Supports multiple audiences
- Generates both human and machine-readable docs