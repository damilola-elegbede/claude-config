# Markdown Validation Environment Setup

## Overview

This document describes the exact environment requirements and setup for consistent markdown validation between
local development and CI environments.

## Environment Requirements

### Dependencies

- **Node.js**: Version 18 or higher
- **npm**: Latest version
- **markdownlint-cli2**: v0.13.0 (installed via package.json)

### Installation

```bash
# Install exact dependencies (required for consistency)
npm ci

# Verify markdownlint-cli2 version
npx markdownlint-cli2 --version
# Expected output: markdownlint-cli2 v0.13.0 (markdownlint v0.34.0)
```

## Configuration Files

### Primary Configuration

- **File**: `.markdownlint-cli2.jsonc`
- **Purpose**: Defines linting rules and file exclusions
- **Key exclusions**:
  - `node_modules/**` - Package dependencies  
  - `.git/**` - Git metadata
  - `docs/markdown-quality-report.md` - Auto-generated report
  - `system-configs/.claude/agents/*.md` - Agent definitions (special format)

### Baseline Tracking

- **File**: `tests/markdown/.baseline_violations`
- **Purpose**: Tracks violation count trends
- **Current baseline**: 0 violations
- **Update trigger**: When violations decrease below baseline

## Validation Commands

### Direct Validation

```bash
# Basic validation (matches CI exactly)
npx markdownlint-cli2 "**/*.md" --config .markdownlint-cli2.jsonc

# Count violations (for scripting)
npx markdownlint-cli2 "**/*.md" --config .markdownlint-cli2.jsonc 2>&1 | grep -E "^.+:[0-9]+(:([0-9]+))?[[:space:]]+" | wc -l | tr -d ' '
```

### Scripted Validation

```bash
# Comprehensive quality gate validation
./scripts/validate-markdown-quality.sh validate

# Run full test suite
./tests/markdown/test_markdown_quality.sh

# Apply automated fixes
./scripts/validate-markdown-quality.sh fix
```

## Environment Consistency Issues and Solutions

### Issue 1: Global vs Local Package Installation

**Problem**: CI installs markdownlint-cli2 globally while local uses npm packages.

**Solution**: Both environments now use `npm ci` to install exact package versions.

```yaml
# CI Configuration (fixed)
- name: Install dependencies
  run: npm ci

# NOT: npm install -g markdownlint-cli2
```

### Issue 2: Violation Counting Discrepancies

**Problem**: Different regex patterns for counting violations led to inconsistent results.

**Solution**: Standardized on exact pattern across all scripts:

```bash
# Standard violation counting pattern
grep -E "^.+:[0-9]+(:([0-9]+))?[[:space:]]+"
```

### Issue 3: Auto-generated File Pollution

**Problem**: The markdown quality report generated new violations each time it was created.

**Solution**: Excluded auto-generated files from validation:

```jsonc
{
  "ignores": [
    "docs/markdown-quality-report.md"
  ]
}
```

### Issue 4: File Exclusion Pattern Differences

**Problem**: Local scripts and CI used different file exclusion patterns.

**Solution**: Centralized exclusion patterns in `.markdownlint-cli2.jsonc` configuration.

## Verification Process

### Local Development

```bash
# 1. Clean environment check
npm ci

# 2. Verify zero violations
npx markdownlint-cli2 "**/*.md" --config .markdownlint-cli2.jsonc
# Expected: "Summary: 0 error(s)"

# 3. Run comprehensive validation
./scripts/validate-markdown-quality.sh validate
# Expected: "🎉 QUALITY GATE PASSED"

# 4. Test suite validation
./tests/markdown/test_markdown_quality.sh
# Expected: "All markdown quality tests passed!"
```

### CI Environment

The CI environment mirrors local setup exactly:

```yaml
- name: Install dependencies
  run: npm ci

- name: Run markdown quality validation  
  run: ./scripts/validate-markdown-quality.sh validate

- name: Run markdown quality tests
  run: ./tests/markdown/test_markdown_quality.sh
```

## Troubleshooting

### Common Issues

1. **Version Mismatch**

   ```bash
   # Check versions match
   npx markdownlint-cli2 --version
   # Should show: markdownlint-cli2 v0.13.0
   ```

2. **Baseline Drift**

   ```bash
   # Reset baseline if corrupted
   echo "0" > tests/markdown/.baseline_violations
   ```

3. **Cache Issues**

   ```bash
   # Clear npm cache
   npm ci --cache-clean
   ```

4. **File Pattern Issues**

   ```bash
   # Test exact file matching
   npx markdownlint-cli2 "**/*.md" --config .markdownlint-cli2.jsonc --verbose
   ```

## Quality Standards

### Success Criteria

- ✅ Local validation shows 0 violations
- ✅ CI validation shows 0 violations  
- ✅ Both environments report identical counts
- ✅ Test suite passes in both environments
- ✅ Baseline remains stable at 0

### Failure Indicators

- ❌ Local shows 0 but CI shows violations
- ❌ Violation counts differ between environments  
- ❌ Test suite passes locally but fails in CI
- ❌ Baseline trending upward

## Maintenance

### Regular Tasks

1. **Weekly**: Verify baseline stability
2. **Monthly**: Update markdownlint-cli2 version
3. **Per-release**: Validate all environments match

### Update Process

1. Update package.json versions
2. Run `npm ci` in all environments
3. Verify validation results match
4. Update documentation if behavior changes

## Integration Points

### Pre-commit Hooks

```bash
# Validate before commit
./scripts/validate-markdown-quality.sh validate
```

### Editor Integration

```json
{
  "markdownlint.config": ".markdownlint-cli2.jsonc",
  "markdownlint.run": "onSave"
}
```

### CI Pipeline Integration

- Runs on all markdown file changes
- Blocks merge if validation fails
- Provides quality reports on PRs

---

*This document ensures consistent markdown validation across all development environments.*
