# /sync Command

## Description

Synchronizes configuration files between source and destination directories based on `.syncconfig` file.
Supports any configuration management scenario with validation and safety checks.

## Usage

```bash
/sync                    # Sync based on .syncconfig
/sync --pull             # Pull from remote to local
/sync --push             # Push from local to remote
/sync --dry-run          # Preview changes without syncing
```

## Configuration File

Create `.syncconfig` in project root:

```yaml
# .syncconfig example
sync:
  - source: ./configs/
    dest: ~/.myapp/
    exclude: ["*.tmp", "*.backup"]
  
  - source: ./templates/
    dest: ~/.myapp/templates/
    validate: true
    
  - source: ./settings.json
    dest: ~/.myapp/settings.json
    merge: true  # Merge instead of overwrite
```

## Sync Process

### Phase 1: Read Configuration

```bash
# Parse .syncconfig file
if [[ ! -f ".syncconfig" ]]; then
  echo "❌ No .syncconfig file found"
  echo "💡 Create .syncconfig with source/dest mappings"
  exit 1
fi
```

### Phase 2: Validate & Sync

```bash
# For each mapping in .syncconfig
for mapping in mappings; do
  # Validate source exists
  if [[ ! -e "$source" ]]; then
    echo "❌ Source not found: $source"
    continue
  fi
  
  # Create dest directory if needed
  mkdir -p "$(dirname "$dest")"
  
  # Apply exclusion patterns
  rsync -av --exclude-from=<(printf '%s\n' "${excludes[@]}") \
    "$source" "$dest"
done
```

### Phase 3: Optional Validation

```bash
# Run validation if specified
if [[ "$validate" == "true" ]]; then
  # Check JSON validity
  if [[ "$dest" == *.json ]] && ! jq empty "$dest" 2>/dev/null; then
    echo "❌ Invalid JSON in $dest"
    return 1
  fi
fi
```

## Bidirectional Sync

### Pull Mode (--pull)

Downloads configuration from remote location to local:

```bash
/sync --pull
# Remote → Local based on .syncconfig
```

### Push Mode (--push)

Uploads local configuration to remote location:

```bash
/sync --push  
# Local → Remote based on .syncconfig
```

## Examples

### Basic Sync

```bash
User: /sync
Claude: 📖 Reading .syncconfig...
🔄 Syncing 3 mappings...
✅ ./configs/ → ~/.myapp/ (12 files)
✅ ./templates/ → ~/.myapp/templates/ (5 files)
✅ ./settings.json → ~/.myapp/settings.json (merged)
```

### Dry Run

```bash
User: /sync --dry-run
Claude: 📖 Preview mode...
Would sync:
- ./configs/ → ~/.myapp/ (12 files, 2.3KB)
- ./templates/ → ~/.myapp/templates/ (5 files, 1.1KB)
- ./settings.json → ~/.myapp/settings.json (merge)
```

## Notes

- Uses rsync for efficient file synchronization
- .syncconfig uses YAML for readability
- Supports patterns for exclusion (gitignore syntax)
- Merge option for JSON files preserves existing settings
- Version control .syncconfig for team consistency
