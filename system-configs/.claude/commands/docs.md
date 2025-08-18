# /docs Command

## Description

Comprehensive documentation management system that identifies gaps, updates existing docs,
and maintains current documentation aligned with codebase reality. Deploys multiple agents
in parallel for efficient analysis and updates.

## Usage

```bash
/docs                    # Complete documentation overhaul
/docs --audit            # Documentation gap analysis only
/docs --clean            # Clean temporary docs and organize
/docs <scope>            # Focused documentation update
```

## Behavior

When invoked, I will orchestrate parallel agents to comprehensively update all repository
documentation including CLAUDE.md, README.md, API docs, and technical specifications.
Identifies gaps, updates outdated content, and organizes temporary documentation files.

## Core Workflow

### Phase 1: Analysis & Gap Identification (Parallel)

```yaml
Agent Deployment:
  codebase-analyst: Repository structure and component analysis
  tech-writer: Documentation inventory and gap identification
  api-analyst: API documentation requirements assessment

Parallel Tasks:
  - Scan existing documentation completeness
  - Identify undocumented features and components
  - Analyze code-to-docs synchronization gaps
  - Assess documentation quality and clarity
  - Map API endpoints requiring documentation
```

### Phase 2: Documentation Generation (Parallel)

```yaml
Agent Coordination:
  tech-writer:
    - Update CLAUDE.md with current project reality
    - Refresh README.md with accurate setup/usage
    - Generate missing API documentation
    - Update architecture and design docs

  api-architect:
    - Create/update OpenAPI specifications
    - Document endpoint contracts and schemas
    - Generate API usage examples

  codebase-analyst:
    - Extract inline documentation from code
    - Document component interfaces and patterns
    - Create technical reference materials
```

### Phase 3: Cleanup & Organization (Sequential)

```yaml
File Management:
  Temporary Doc Cleanup:
    - Move analysis reports to .tmp/analysis/
    - Archive status documents to .tmp/reports/
    - Organize meeting notes to .tmp/drafts/
    - Clean up workspace documentation

  Organization Structure:
    - /docs/api/ - API documentation
    - /docs/architecture/ - System design docs
    - /docs/guides/ - User and developer guides
    - .tmp/analysis/ - Analysis reports
    - .tmp/reports/ - Status and progress reports
    - .tmp/drafts/ - Draft documents and notes
```

## Documentation Targets

### Core Documentation Files

```yaml
CLAUDE.md:
  purpose: Project-specific instructions and context
  updates: Current tech stack, workflows, agent usage patterns

README.md:
  purpose: Project overview and quick start
  updates: Installation, usage, examples, contribution guidelines

API Documentation:
  purpose: Endpoint documentation and contracts
  updates: OpenAPI specs, example requests/responses, authentication

Architecture Docs:
  purpose: System design and technical decisions
  updates: Component diagrams, data flow, integration patterns
```

### Gap Detection Patterns

```yaml
Missing Documentation:
  - New features without corresponding docs
  - API endpoints lacking documentation
  - Configuration options not documented
  - Installation/setup steps outdated

Outdated Content:
  - Version mismatches in installation guides
  - Deprecated API references
  - Broken links and examples
  - Incorrect command examples

Quality Issues:
  - Unclear explanations or missing context
  - Incomplete code examples
  - Missing troubleshooting sections
  - Poor organization and navigation
```

## Cleanup Targets

### Temporary Files to Organize

```bash
# Analysis and report files
*-analysis.md
*-report.md
*-status.md
*-summary.md
meeting-notes-*.md
progress-*.md

# Draft and working documents
draft-*.md
temp-*.md
notes-*.md
scratch-*.md
```

### Organization Rules

```bash
# Move to appropriate .tmp/ subdirectories
mv *-analysis.md .tmp/analysis/
mv *-report.md .tmp/reports/
mv *-status.md .tmp/reports/
mv draft-*.md .tmp/drafts/
mv notes-*.md .tmp/drafts/
```

## Execution Strategy

### Parallel Agent Orchestration

```yaml
Wave 1 (Analysis - 2 minutes):
  - codebase-analyst: Repository scan and component mapping
  - tech-writer: Documentation audit and gap analysis
  - api-analyst: API endpoint documentation assessment

Wave 2 (Generation - 5 minutes):
  - tech-writer: Core documentation updates (README, CLAUDE.md)
  - api-architect: API documentation generation
  - codebase-analyst: Technical reference creation

Wave 3 (Cleanup - 1 minute):
  - Direct execution: File organization and cleanup
  - Directory structure creation
  - Temporary file archival
```

### Focused Scope Examples

```bash
/docs api           # API documentation only
/docs readme        # README.md refresh only
/docs architecture  # System design docs only
/docs setup         # Installation and setup docs
```

## Quality Gates

### Documentation Standards

```yaml
Completeness:
  - All public APIs documented
  - Setup instructions tested and current
  - Examples include expected outputs
  - Error scenarios documented

Accuracy:
  - Code examples execute successfully
  - Version numbers match current release
  - Links resolve correctly
  - Screenshots reflect current UI

Clarity:
  - Clear headings and organization
  - Consistent formatting and style
  - Appropriate detail level for audience
  - Good use of examples and illustrations
```

## Examples

### Complete Documentation Overhaul

```bash
User: /docs
Claude: 🚀 Deploying parallel documentation agents...
📊 codebase-analyst: Scanning repository structure...
✍️ tech-writer: Auditing documentation gaps...
🔌 api-analyst: Analyzing API endpoints...

📝 Found 12 documentation gaps, 3 outdated sections
🔄 Updating CLAUDE.md, README.md, and API docs...
🧹 Organizing 8 temporary files to .tmp/

✅ Documentation suite updated and synchronized
```

### Documentation Audit Only

```bash
User: /docs --audit
Claude: 🔍 Running documentation gap analysis...
📊 codebase-analyst: Mapping undocumented components...
✍️ tech-writer: Assessing documentation quality...

📋 Documentation Audit Results:
- 5 missing API endpoints
- README.md installation steps outdated
- Architecture diagrams need updates
- 3 configuration options undocumented
```

### Cleanup and Organization

```bash
User: /docs --clean
Claude: 🧹 Cleaning and organizing documentation files...
📁 Creating .tmp/ directory structure...
📄 Moving 6 analysis reports to .tmp/reports/
📝 Archiving 4 draft documents to .tmp/drafts/
✅ Workspace cleaned and organized
```

## Execution Verification

Deploy execution-evaluator to verify:

- ✅ **Documentation completeness** - All gaps identified and addressed
- ✅ **Content accuracy** - Examples work, links resolve, versions current
- ✅ **File organization** - Temporary documents properly archived
- ✅ **Agent coordination** - Parallel execution completed successfully
- ✅ **Quality standards** - Documentation meets clarity and completeness criteria

## Notes

- Coordinates 3+ agents in parallel for efficiency
- Automatically detects project type and documentation needs
- Preserves existing documentation structure while improving content
- Organizes temporary files to maintain clean workspace
- Validates all examples and links for accuracy