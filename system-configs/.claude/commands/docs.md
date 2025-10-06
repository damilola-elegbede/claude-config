---
description: Documentation generation and updates
argument-hint: [scope|--audit|--clean]
---

# /docs Command

## Usage

```bash
/docs                    # Update documentation based on recent changes
/docs --audit            # Analyze documentation gaps only
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

### Agent Delegation (tech-writer)

Deploy single tech-writer agent for comprehensive tasks:

- New feature documentation from scratch
- Complete API documentation suite
- Architecture documentation with diagrams
- Multi-section user guides
- Cross-referenced documentation systems

**Decision criteria:** If task requires >1500 tokens or spans multiple new documents, delegate to tech-writer.

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
- Maintains clean workspace with .tmp/ organization
- Protects system configuration files (CLAUDE.md) by design
- Typical execution time: 10-60 seconds depending on scope
