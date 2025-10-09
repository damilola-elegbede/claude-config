---
description: Documentation generation and updates
argument-hint: [scope|--audit|--audit-and-fix|--clean]
---

# /docs Command

## Usage

```bash
/docs                    # Update documentation based on recent changes
/docs --audit            # Analyze documentation gaps only
/docs --audit-and-fix    # Analyze gaps, get approval, deploy parallel tech-writers to fix
/docs --clean            # Organize temporary docs and clean workspace
/docs api                # Focused API documentation update
/docs readme             # README.md refresh only
/docs architecture       # System design docs only
/docs setup              # Installation and setup docs
```

## Description

Generates and updates documentation by analyzing code changes and identifying gaps. Uses direct execution for simple
updates and delegates to tech-writer agent for comprehensive documentation generation.

**IMPORTANT: This command explicitly excludes all CLAUDE.md files from any operations.** CLAUDE.md files at any level
(root directory, home directory, project directory, or nested locations) are never read, written, modified, or analyzed
by the /docs command.

## Protected Files

The following files are **NEVER** touched, read, written, or modified:

- **CLAUDE.md** (any location: root, home, project, nested directories)
- **~/.claude/CLAUDE.md** (home directory configuration)
- **./CLAUDE.md** (project root configuration)
- **Any path containing CLAUDE.md** (all nested locations)

These files contain critical system configurations that must remain isolated from documentation generation.

## Behavior

### Default Mode - Smart Documentation Updates

**What it does:** Analyzes recent changes and updates relevant documentation

1. **Identify Changes:** Check git diff and changed files to understand scope
2. **Find Documentation Gaps:** Scan for missing or outdated docs
3. **Generate Updates:**
   - Simple updates (typos, version numbers): Claude handles directly
   - Comprehensive docs (new features, APIs): Delegate to single tech-writer agent
4. **Organize:** Place documentation in appropriate locations

### Audit Mode (--audit)

**What it does:** Reports documentation gaps without making changes

1. Scan codebase for undocumented components (excluding CLAUDE.md)
2. Check API endpoint documentation completeness
3. Verify README and setup docs are current
4. Report findings without generating documentation

### Audit-and-Fix Mode (--audit-and-fix)

**What it does:** Comprehensive documentation analysis with approval-based parallel tech-writer deployment

1. **Analysis Phase:** Deploy multiple analyst agents to scan codebase comprehensively
   - Identify undocumented components (excluding CLAUDE.md)
   - Analyze API endpoint documentation completeness
   - Review README and setup documentation currency
   - Categorize gaps by type (API docs, architecture, setup, etc.)

2. **Approval Phase:** Present findings and get user confirmation
   - Display comprehensive gap analysis report
   - Show planned tech-writer deployment strategy
   - Request approval before proceeding with fixes

3. **Parallel Execution Phase:** Deploy specialized tech-writer agents simultaneously
   - One tech-writer per documentation category/gap type
   - All agents execute in parallel for maximum efficiency
   - Each agent focuses on specific documentation domain

4. **Consolidation Phase:** Verify and report completion
   - Confirm all documentation generated successfully
   - Provide summary of files created/updated
   - Report any issues requiring manual intervention

**Execution Pattern:**

- Analysis: Multiple research agents in parallel
- User approval checkpoint
- Implementation: Multiple tech-writer agents in parallel
- Consolidation: Single report generation

### Clean Mode (--clean)

**What it does:** Organizes temporary documentation files

```bash
# Move temporary files to .tmp/ directory
*-analysis.md → .tmp/analysis/
*-report.md → .tmp/reports/
draft-*.md → .tmp/drafts/
temp-*.md → .tmp/drafts/

# EXCLUSION: CLAUDE.md files are never moved or organized
```

### Focused Updates

**What it does:** Updates specific documentation scope

- `api` - API endpoint documentation and OpenAPI specs
- `readme` - README.md comprehensive refresh
- `architecture` - System design and component docs
- `setup` - Installation, configuration, deployment docs

## Implementation Strategy

### Direct Execution (Claude handles)

Use for simple, straightforward documentation tasks:

- Fixing typos and formatting issues
- Updating version numbers
- Adding missing function comments
- Updating installation steps
- Quick README tweaks

### Single Agent Delegation (tech-writer)

Deploy single tech-writer agent for comprehensive tasks:

- New feature documentation from scratch
- Complete API documentation suite
- Architecture documentation with diagrams
- Multi-section user guides
- Cross-referenced documentation systems

**Decision criteria:** If task requires >1500 tokens or spans multiple new documents, delegate to tech-writer.

### Parallel Agent Deployment (--audit-and-fix)

Deploy multiple agents for comprehensive documentation overhaul:

**Analysis Phase:**

- Multiple researcher agents scan different codebase areas in parallel
- Each researcher focuses on specific documentation domain
- Consolidate findings into categorized gap report

**Approval Checkpoint:**

- Present comprehensive findings to user
- Show planned tech-writer deployment strategy
- Get explicit approval before proceeding

**Implementation Phase:**

- Deploy one tech-writer agent per documentation category
- All tech-writers execute simultaneously in parallel
- Each agent has focused, non-overlapping scope

**Decision criteria:** Use --audit-and-fix when comprehensive documentation audit and systematic gap resolution needed.

## Expected Output

### Simple Update Example

```text
User: /docs readme
Claude: Analyzing README.md...
  - Updated installation steps for Node 18+
  - Added new API endpoint examples
  - Fixed broken links (3 found)
✅ README.md updated
```

### Comprehensive Generation Example

```text
User: /docs api
Claude: Analyzing API documentation needs...
  - Found 8 undocumented endpoints
  - Missing OpenAPI specification

Delegating to tech-writer for comprehensive API docs...

✅ Generated:
  - docs/api/README.md (endpoint overview)
  - docs/api/authentication.md (auth flows)
  - docs/api/openapi.yaml (OpenAPI 3.0 spec)
  - docs/api/examples/ (request/response examples)
```

### Audit Report Example

```text
User: /docs --audit
Claude: 📋 Documentation Gap Analysis

Missing Documentation:
  - 5 API endpoints lack documentation
  - README installation steps outdated (Node 16 → 18)
  - Architecture diagrams missing
  - No deployment guide

Outdated Documentation:
  - API authentication docs reference old OAuth flow
  - Setup guide mentions deprecated CLI flags

Recommendations:
  - Run `/docs api` for API documentation
  - Run `/docs readme` for README refresh
  - Run `/docs architecture` for design docs
```

### Audit-and-Fix Example

```text
User: /docs --audit-and-fix
Claude: Deploying 3 researcher agents to analyze documentation gaps...

📋 Comprehensive Documentation Gap Analysis

Missing Documentation:
  Category: API Documentation
    - 5 endpoints lack documentation (auth, users, payments)
    - No OpenAPI specification
    - Missing request/response examples

  Category: Setup & Deployment
    - Installation steps outdated (Node 16 → 18)
    - No Docker deployment guide
    - Missing environment configuration docs

  Category: Architecture
    - System design diagrams missing
    - No component interaction docs
    - Database schema undocumented

Proposed Fix Strategy:
  - Deploy 3 tech-writer agents in parallel:
    → Agent 1: API documentation (endpoints, OpenAPI, examples)
    → Agent 2: Setup documentation (installation, deployment, config)
    → Agent 3: Architecture documentation (diagrams, components, schema)

Proceed with parallel tech-writer deployment? (y/n): y

Deploying 3 tech-writer agents in parallel...

✅ Documentation Generation Complete

Agent 1 - API Documentation:
  - docs/api/README.md (endpoint overview)
  - docs/api/authentication.md (auth flows)
  - docs/api/openapi.yaml (OpenAPI 3.0 spec)
  - docs/api/examples/ (5 request/response examples)

Agent 2 - Setup Documentation:
  - README.md (updated installation for Node 18)
  - docs/deployment/docker.md (Docker setup guide)
  - docs/deployment/configuration.md (environment vars)

Agent 3 - Architecture Documentation:
  - docs/architecture/system-design.md (diagrams)
  - docs/architecture/components.md (interaction flows)
  - docs/architecture/database-schema.md (schema docs)

📊 Summary: 12 files created/updated by 3 parallel agents
```

## Quality Standards

- **Accuracy:** Documentation reflects current code behavior
- **Completeness:** All public APIs and features documented
- **Clarity:** Documentation written for target audience
- **Consistency:** Formatting and style maintained across documents
- **Protection:** CLAUDE.md files never accessed or modified

## Notes

- Focuses on core documentation needs without over-engineering
- Uses direct execution for speed on simple tasks
- Delegates to single specialized agent only when needed
- **--audit-and-fix mode deploys parallel agents for comprehensive documentation overhaul**
- Maintains clean workspace with .tmp/ organization
- Protects system configuration files (CLAUDE.md) by design
- Typical execution time: 10-60 seconds (simple), 2-5 minutes (--audit-and-fix with parallel agents)
