# /config-diff Command

## Description
Repository-specific command that compares Claude configuration files between this repository and your user settings. Shows differences between repository versions and installed versions to help you understand what changes would be applied by `/sync`.

## Usage
```
/config-diff [--detailed]
```

## Arguments
- `--detailed` (optional): Show line-by-line differences for changed files

## Behavior
When you use `/config-diff`, I will:

1. **Identify configuration locations**:
   - Repository files: `./CLAUDE.md`, `./.claude/commands/`, `./.claude/agents/`, `./settings.json`
   - User files: `~/CLAUDE.md`, `~/.claude/commands/`, `~/.claude/agents/`, `~/.claude/settings.json`

2. **Compare core configuration files**:
   - Check if `~/CLAUDE.md` exists and compare with `./CLAUDE.md`
   - Show file size differences and modification dates
   - Display summary of changes (lines added/removed)

3. **Compare command files**:
   - List commands only in repository (new commands)
   - List commands only in user config (deprecated/custom commands)
   - List commands present in both but different (modified commands)
   - **Note**: Excludes `sync.md` and `config-diff.md` from comparison (repo-specific)

4. **Compare agent files**:
   - List agents only in repository (new agents)
   - List agents only in user config (deprecated/custom agents)
   - List agents present in both but different (modified agents)
   - **Note**: Excludes documentation files (README.md, AGENT_TEMPLATE.md, etc.)

5. **Compare settings.json**:
   - Check for differences in hooks configuration
   - Identify new settings in repository version
   - Highlight user customizations that would be preserved

6. **Generate summary report**:
   - Total files to be added/modified/removed
   - Impact assessment (breaking changes, new features)
   - Recommendation on whether to sync

## Output Format

### Summary Mode (default)
```
=== Configuration Diff Summary ===

CLAUDE.md:
  Repository: 204 lines (modified: 2024-01-15)
  User:       604 lines (modified: 2024-01-10)
  Status:     DIFFERENT - Repository version streamlined by 66%

Commands (12 total):
  New in repo:        2 files (review.md, test.md)
  Modified:           3 files (commit.md, push.md, context.md)
  User-only:          1 file (custom-command.md)
  Unchanged:          6 files

Agents (38 total):
  New in repo:        5 agents
  Modified:          38 agents (Personality & Approach sections added)
  User-only:          2 agents (deprecated)
  Unchanged:          0 agents

Settings.json:
  Status:     DIFFERENT - New hooks added in repository version

Recommendation: Run /sync to update to latest configuration
  - 38 agents will be enhanced with personality traits
  - CLAUDE.md will be significantly streamlined
  - 2 new commands will be available
```

### Detailed Mode (--detailed)
Shows line-by-line diffs for each changed file using unified diff format.

## Files Compared

### Included in Comparison
- `CLAUDE.md` - Main configuration
- `.claude/commands/*.md` - All command files except repo-specific ones
- `.claude/agents/*.md` - Only actual agent files (excludes documentation)
- `settings.json` - Configuration settings

### Excluded from Comparison
**Repository-specific (never synced):**
- `.claude/commands/sync.md`
- `.claude/commands/config-diff.md`

**Documentation files (not agents):**
- `.claude/agents/README.md`
- `.claude/agents/AGENT_TEMPLATE.md`
- `.claude/agents/AGENT_CATEGORIES.md`
- `.claude/agents/AUDIT_VERIFICATION_PROTOCOL.md`

## Examples

### Basic comparison
```
/config-diff

=== Configuration Diff Summary ===
Files requiring update: 41
- CLAUDE.md: Repository version 66% smaller
- Commands: 2 new, 3 modified
- Agents: 38 modified (personality enhancements)
- Settings: New audio hooks available
```

### Detailed comparison
```
/config-diff --detailed

=== Detailed Configuration Diff ===

--- CLAUDE.md ---
@@ -1,604 +1,204 @@
-[detailed line-by-line diff]
+[showing specific changes]

--- .claude/agents/backend-engineer.md ---
@@ -145,2 +145,6 @@
+## Personality & Approach
+
+Challenge every architectural decision...
```

## Use Cases

1. **Pre-sync verification**: Check what changes `/sync` would apply
2. **Update tracking**: See what's new in the repository
3. **Customization preservation**: Identify user customizations
4. **Version comparison**: Understand configuration evolution

## Implementation Notes

The command uses these comparison strategies:
- **File existence**: Check if files exist in both locations
- **Content diff**: Quick comparison using built-in diff
- **Line diff**: Detailed comparison when requested
- **Metadata**: Compare file sizes and modification times

**Implementation**: The command executes `./scripts/config-diff.sh` from the repository root.

## Important Notes
- **This command is specific to the claude-config repository**
- It will NOT be copied to your global commands during sync
- Read-only operation - makes no changes to files
- Helps make informed decisions before running `/sync`
- Shows impact of repository updates on your configuration

## Related Commands
- `/sync` - Apply the differences shown by this command
- `/test` - Validate configuration files before syncing

## Troubleshooting
- If command fails, ensure you're in the claude-config repository
- User config files may not exist on first run (expected)
- Large diffs in detailed mode may be truncated for readability
- Use git diff for more advanced comparison options