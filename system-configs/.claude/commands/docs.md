---
description: Comprehensive documentation management with parallel multi-instance generation
argument-hint: [scope|--audit|--clean]
---

# Documentation Management Command

Comprehensive documentation management system that identifies gaps, updates existing docs,
and maintains current documentation aligned with codebase reality. Deploys multiple agent
instances in parallel for 3-4x faster documentation generation across all document types.

## Usage

```bash
/docs                    # Complete documentation overhaul
/docs --audit            # Documentation gap analysis only
/docs --clean            # Clean temporary docs and organize
/docs $ARGUMENTS         # Focused documentation update (scope: api, readme, architecture, setup)
```

## Context

When invoked, I will deploy multiple tech-writer instances (4-6) to simultaneously update
different documentation types. Each instance handles specific documents (README, API docs,
CLAUDE.md, architecture docs) in parallel, achieving 3-4x faster documentation generation
than sequential processing.

## Core Workflow

### Phase 1: Multi-Instance Analysis & Gap Identification

```yaml
# PARALLEL WAVE: Multi-Instance Documentation Analysis (20-30 seconds)
codebase-analyst (instance pool):
  deployment: 2-3 instances for rapid analysis
  distribution:
    - instance_1: Frontend components and UI documentation needs
    - instance_2: Backend services and API documentation gaps
    - instance_3: Infrastructure and deployment documentation
  parallel_with: [tech-writer instances]
  output: Comprehensive gap analysis from multiple perspectives

tech-writer (initial assessment instance):
  role: Documentation inventory and quality assessment
  parallel_with: [codebase-analyst instances]
  output: Documentation gaps and update priorities

api-architect:
  role: API documentation requirements and OpenAPI specs
  parallel_with: [codebase-analyst instances, tech-writer]
  output: API documentation needs assessment
```

### Phase 2: Multi-Instance Documentation Generation

```yaml
# PARALLEL WAVE: Multi-Instance Document Creation (1-2 minutes total)
tech-writer (instance pool):
  deployment: 4-6 instances based on documentation scope
  calculation: min(6, number_of_doc_types)
  distribution:
    - instance_1: README.md updates (installation, usage, examples)
    - instance_2: CLAUDE.md updates (project instructions, workflows)
    - instance_3: API documentation (endpoints, schemas, examples)
    - instance_4: Architecture docs (design, components, patterns)
    - instance_5: User guides and tutorials
    - instance_6: Inline code documentation extraction
  parallel_execution: All document types updated simultaneously
  role: Generate/update specific documentation domains
  output: Multiple documents updated in parallel

api-architect (specialized instance):
  parallel_with: [tech-writer instance_3]
  role: OpenAPI specifications and API contracts
  output: Complete API documentation suite

codebase-analyst (documentation extractor):
  parallel_with: [tech-writer instances]
  role: Extract and organize code documentation
  output: Technical reference materials

# Performance Impact:
#   Sequential: 5-7 minutes for all documentation
#   Multi-instance parallel: 1-2 minutes (3-4x faster)
#   Document isolation: No conflicts between instances
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

```text
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

### Multi-Instance Parallel Orchestration

```yaml
Wave 1 (Multi-Instance Analysis - 20-30 seconds):
  - codebase-analyst instances: 2-3 parallel repository scanners
  - tech-writer: Documentation gap assessment
  - api-architect: API documentation requirements

Wave 2 (Multi-Instance Generation - 1-2 minutes):
  - tech-writer instances: 4-6 parallel document generators
    * Instance allocation based on document count/complexity
    * Each instance handles 1-2 document types maximum
    * Real-time progress tracking from all instances
  - api-architect: OpenAPI spec generation
  - codebase-analyst: Code documentation extraction

Wave 3 (Cleanup - 15 seconds):
  - Direct execution: File organization from all instances
  - Result aggregation: Merge outputs from all instances
  - Consistency check: Verify no conflicts between documents

Total Time Optimization:
  - Sequential approach: 8-10 minutes
  - Multi-instance parallel: 2-3 minutes (3-4x faster)
  - Resource utilization: Full parallel processing
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

## Expected Output

### Complete Documentation Overhaul with Multi-Instance

```text
User: /docs
Claude: 🚀 Deploying 6 tech-writer instances for parallel generation...
📊 Instance Pool Status:
  - tech-writer[1]: Updating README.md...
  - tech-writer[2]: Refreshing CLAUDE.md...
  - tech-writer[3]: Generating API documentation...
  - tech-writer[4]: Creating architecture docs...
  - tech-writer[5]: Writing user guides...
  - tech-writer[6]: Extracting code documentation...

⚡ Parallel Processing:
  - 12 documentation gaps identified
  - 6 documents updating simultaneously
  - Real-time progress: [████████░░] 80%

✅ All instances completed in 1m 47s (was 5-7 minutes)
🧹 Organizing outputs and temporary files...
📚 Documentation suite fully synchronized
```

### Documentation Audit Only

```text
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

```text
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

- **Multi-Instance Deployment**: 4-6 tech-writer instances work simultaneously
- **Dynamic Scaling**: Instance count adjusts based on documentation scope
- **Work Distribution**: Each instance handles 1-2 document types maximum
- **Performance Target**: 2-3 minutes for full documentation update (3-4x faster)
- Automatically detects project type and documentation needs
- Preserves existing documentation structure while improving content
- Organizes temporary files to maintain clean workspace
- Validates all examples and links for accuracy