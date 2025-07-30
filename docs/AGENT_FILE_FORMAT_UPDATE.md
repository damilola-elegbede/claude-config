# Agent File Format Update Summary

## Overview
This document summarizes the updates made to clarify that Claude Code agents are Markdown (.md) files with YAML frontmatter, not pure YAML files, as per Anthropic's official documentation.

## Changes Made

### 1. Template File Renamed
- **Old**: `AGENT_TEMPLATE.yaml`
- **New**: `AGENT_TEMPLATE.md`
- **Reason**: Aligns with actual agent file format

### 2. Documentation Updates

#### docs/YAML_REQUIREMENTS.md
- Added clarification that agents are Markdown files with YAML frontmatter
- Updated all references from `AGENT_TEMPLATE.yaml` to `AGENT_TEMPLATE.md`
- Added note referencing Anthropic's documentation

#### scripts/validate_yaml.sh
- Updated to skip `AGENT_TEMPLATE.md` instead of `AGENT_TEMPLATE.yaml`
- Script already correctly validates .md files

### 3. Agent Updates

#### agent-auditor.md
- Added section explaining that agents are .md files, not .yaml files
- Clarified audit process should look for .md files
- Referenced Anthropic's documentation standards

#### agent-architect.md
- Updated all references to use .md extension
- Clarified that new agents must be saved as .md files
- Updated template references from .yaml to .md
- Emphasized Markdown format with YAML frontmatter

## Key Takeaways

1. **All agents are Markdown files** (.md) with YAML frontmatter between `---` markers
2. **No pure YAML files** should be used for agents
3. **This follows Anthropic's official Claude Code documentation**
4. **The audit incorrectly reported "missing" agents** because it was looking for .yaml files

## Impact

- No functional changes to existing agents
- Clearer documentation for future agent creation
- Aligned with Anthropic's standards
- Prevents confusion about file formats

## References
