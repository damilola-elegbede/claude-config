---
name: markdown-linting
description: Markdownlint rules MD001-MD058 quick reference for consistent documentation formatting.
category: format
user-invocable: false
---

# Markdown Linting Reference

## Critical Rules

### MD001: Heading Level Increment

Headings must increment by one level only. No skipping levels.

```markdown
<!-- BAD -->
# Title
### Subsection (skipped H2)

<!-- GOOD -->
# Title
## Section
### Subsection
```

### MD003: Heading Style

Use consistent ATX-style headings (`#` prefix).

```markdown
<!-- BAD: Mixed styles -->
# ATX Heading
Setext Heading
==============

<!-- GOOD: Consistent ATX -->
# Main Heading
## Sub Heading
```

### MD009: Trailing Spaces

No trailing whitespace except exactly 2 spaces for intentional line breaks.

### MD013: Line Length

Maximum **150 characters** per line. Exempt: tables and code blocks.

Break long lines at logical points (after commas, before conjunctions).

### MD022: Heading Blank Lines

Headings must be surrounded by blank lines.

```markdown
<!-- BAD -->
Some text.
## Heading
More text.

<!-- GOOD -->
Some text.

## Heading

More text.
```

### MD024: No Duplicate Headings

No duplicate heading text at the same level (allowed in different parent sections).

### MD025: Single H1

Only one H1 (`#`) heading per document, at the start.

### MD031: Fenced Code Block Blank Lines

Fenced code blocks must be surrounded by blank lines.

````markdown
<!-- BAD -->
Some text.
```bash
echo "hello"
```
More text.

<!-- GOOD -->
Some text.

```bash
echo "hello"
```

More text.
````

### MD032: List Blank Lines

Lists must be surrounded by blank lines.

```markdown
<!-- BAD -->
Some text.
- Item 1
- Item 2
More text.

<!-- GOOD -->
Some text.

- Item 1
- Item 2

More text.
```

### MD033: No Inline HTML

Avoid raw HTML in markdown. Use markdown syntax instead.

### MD034: No Bare URLs

Wrap URLs in angle brackets or use link syntax.

```markdown
<!-- BAD -->
Visit https://example.com for details.

<!-- GOOD -->
Visit <https://example.com> for details.
Visit [Example](https://example.com) for details.
```

### MD040: Code Block Language

All fenced code blocks must specify a language.

````markdown
<!-- BAD -->
```
echo "hello"
```

<!-- GOOD -->
```bash
echo "hello"
```
````

**Allowed languages:**

```text
bash, javascript, python, yaml, json, typescript, shell, text,
markdown, mermaid, http, xml, html, css, sql, dockerfile, go,
rust, java, cpp, c, jsonc, prometheus, hcl, terraform, ruby,
php, swift, kotlin, promql, sh, powershell, ps1, zsh
```

### MD041: First Line H1

First content line should be an H1 heading (YAML front matter is exempt).

### MD047: File Ending

Files must end with exactly one newline character.

### MD050: Bold Style

Use `**asterisks**` for bold consistently. Never `__underscores__`.

### MD058: Table Blank Lines

Tables must be surrounded by blank lines.

```markdown
<!-- BAD -->
Some text.
| Col 1 | Col 2 |
|-------|-------|
| A     | B     |
More text.

<!-- GOOD -->
Some text.

| Col 1 | Col 2 |
|-------|-------|
| A     | B     |

More text.
```

## YAML/JSON Standards in Markdown

- **Indentation**: Always 2 spaces (never tabs)
- **Key-value spacing**: `key: value` (space after colon)
- **YAML quotes**: Prefer single quotes for strings with special characters
- **JSON quotes**: Always double quotes (per JSON spec)
- **Booleans**: Use `true`/`false` (never `yes`/`no` or `on`/`off`)
- **Arrays**: Consistent `-` prefix with proper indentation
- **Comments**: `#` with space after for inline documentation

## Common Violations and Fixes

| Violation | Fix |
|-----------|-----|
| Skipped heading level | Add intermediate heading level |
| Missing blank lines around headings | Add blank line before and after |
| Missing blank lines around code blocks | Add blank line before and after |
| Missing blank lines around lists | Add blank line before and after |
| Missing blank lines around tables | Add blank line before and after |
| Unspecified code block language | Add language identifier after opening fence |
| Trailing whitespace | Remove trailing spaces (or use exactly 2 for line break) |
| Multiple H1 headings | Use single H1 at document start |
| Lines exceeding 150 chars | Break at logical points |
| Wrong bold style (`__text__`) | Use `**text**` instead |
| File not ending with newline | Add single trailing newline |
| Bare URLs | Wrap in `<>` or use `[text](url)` syntax |
| Inline HTML | Replace with markdown equivalent |

## Pre-Submission Checklist

- [ ] MD001: Heading hierarchy verified (no level skipping)
- [ ] MD009: All trailing spaces removed (except intentional line breaks)
- [ ] MD013: Line length under 150 characters (tables/code exempt)
- [ ] MD022: Blank lines added around all headings
- [ ] MD024: No duplicate headings exist
- [ ] MD025: Single H1 confirmed at document start
- [ ] MD031: Blank lines surround all code blocks
- [ ] MD032: Blank lines surround all lists
- [ ] MD040: Language specified for all code blocks
- [ ] MD047: File ends with exactly one newline
- [ ] MD050: Consistent `**bold**` formatting used
- [ ] MD058: Blank lines surround all tables
- [ ] YAML: 2-space indentation and proper booleans verified
