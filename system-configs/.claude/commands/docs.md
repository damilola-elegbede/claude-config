---
description: Documentation generation and updates
argument-hint: [scope|--audit|--clean]
---

# /docs Command

## Usage

```bash
/docs                    # Update docs based on recent changes
/docs --audit            # Analyze documentation gaps
/docs --clean            # Organize temp docs to .tmp/
/docs api                # API documentation only
/docs readme             # README.md refresh
/docs architecture       # System design docs
/docs setup              # Installation/setup docs
```

## Description

Generate and update documentation using tech-writer agent. Simple updates handled directly; comprehensive docs delegated to agent.

## Protected Files

**NEVER** touches CLAUDE.md files at any location.

## Behavior

1. **Analyze**: Check git diff and identify doc needs
2. **Generate**: Create/update documentation
3. **Organize**: Place docs in appropriate locations

### Modes

| Mode | Action |
|------|--------|
| Default | Update docs for recent changes |
| `--audit` | Report gaps without changes |
| `--clean` | Move temp docs to .tmp/ |
| Focused | Update specific scope only |

## Expected Output

```text
User: /docs readme

🔍 Analyzing README.md...

Deploying tech-writer agent...

✅ README.md updated:
  - Updated installation steps for Node 18+
  - Added new API endpoint examples
  - Fixed 3 broken links
```

### Audit Mode

```text
User: /docs --audit

📋 Documentation Gap Analysis

Missing:
  - 5 API endpoints undocumented
  - Architecture diagrams missing
  - No deployment guide

Outdated:
  - README installation steps (Node 16 → 18)
  - API auth docs reference old OAuth flow

Run `/docs api` or `/docs readme` to fix
```

### Comprehensive Update

```text
User: /docs api

🔍 Analyzing API documentation needs...
  Found 8 undocumented endpoints

Deploying tech-writer agent...

✅ Generated:
  - docs/api/README.md (endpoint overview)
  - docs/api/authentication.md (auth flows)
  - docs/api/openapi.yaml (OpenAPI 3.0 spec)
```

## Notes

- Uses tech-writer agent for comprehensive docs
- Simple updates (typos, versions) handled directly
- CLAUDE.md files explicitly protected
- Typical execution: 1-5 minutes
