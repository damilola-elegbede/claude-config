# /command-audit Command

## Description

Comprehensive validation of command ecosystem to ensure structure integrity, content quality, and system
consistency. **This command generates a REPORT ONLY - it provides recommendations and optional patch snippets;
it does not make any changes automatically.** Repository-specific command that is excluded from sync process.

## Usage

```bash
/command-audit
```yaml

## Behavior

This command performs thorough validation of all commands across multiple dimensions, executed in parallel by
category for maximum efficiency.

## Purpose

Ensure command ecosystem maintains high standards of documentation, proper categorization, and adherence to system
design principles for optimal Claude Code CLI experience.

## Validation Scope

### 1. Structure Compliance

- **Required Sections**: Verify presence of Description, Usage, Behavior, Arguments (if applicable)
- **Section Order**: Validate consistent section ordering across commands
- **Format Consistency**: Ensure uniform markdown structure and styling
- **Header Hierarchy**: Proper H1/H2/H3 usage and nesting

### 2. Content Quality

- **Description Clarity**: Clear, concise command purpose statements
- **Behavior Documentation**: Comprehensive step-by-step workflow explanation
- **Usage Examples**: Practical, well-commented examples with context
- **Error Handling**: Documented troubleshooting and failure scenarios
- **Integration Points**: How command works with other commands in workflow

### 3. Markdown Parsing Standards

- **Code Fencing Consistency**: Ensure all code blocks use proper language tags (```bash, ```yaml, ```text, etc.)
- **Example Quality**: Verify examples are focused, well-commented, and provide clear context
- **Structured Formats**: Validate use of YAML for workflows and structured data
- **Code Format Separation**: Ensure clean separation between inline code and code blocks
- **Command Clarity**: Multi-line commands must include explanations and context

**Anti-Patterns to Detect**:
- Overly complex multi-line commands without explanation
- Inconsistent formatting between sections
- Mixed inline/block code formats creating ambiguity
- Missing language tags on code fences
- Poorly structured workflow examples

### 4. Functional Completeness

- **Execution-Evaluator Usage**: Commands performing actions must use execution-evaluator
- **Argument Handling**: Proper documentation of optional/required arguments
- **Output Format**: Consistent and predictable command output structure
- **Performance Considerations**: Documented timeouts, parallel execution patterns
- **Safety Features**: Error prevention, validation, and rollback mechanisms

### 5. Command Categories & Standards

Commands are validated based on their category with appropriate standards:

**Git Workflow** (commit, branch, push, pr):
- Must use execution-evaluator for git operations
- Git safety features documented
- Integration with other git workflow commands
- Proper branch management and cleanup

**Repository Analysis** (context, test, debug):
- Framework detection capabilities
- Parallel analysis when beneficial
- Caching and performance optimization
- Universal compatibility across project types

**System Management** (sync, deps, fix-ci):
- Environment validation
- Backup and rollback procedures
- Dependency management
- System state verification

**Quality Assurance** (review, agent-audit, command-audit):
- Comprehensive validation frameworks
- Detailed reporting with metrics
- Auto-remediation suggestions
- Standards enforcement

**Development Support** (plan, resolve-cr):
- Workflow integration
- Context awareness
- User guidance and assistance
- Documentation generation

### 6. Repository-Specific Command Detection

- **Sync Exclusion Validation**: Verify repository-specific commands are properly excluded from sync
- **Auto-Detection**: Identify commands that should be repository-specific
- **Sync Command Updates**: Ensure sync.md exclusion list is current and complete
- **Documentation Consistency**: Repository-specific nature properly documented

### 7. Length & Complexity Analysis

Based on current command analysis:

- **Simple Commands** (100-150 lines): Basic functionality, minimal configuration
- **Standard Commands** (150-250 lines): Moderate complexity with examples
- **Complex Commands** (250-400 lines): Advanced features, multiple workflows
- **Ultra-Complex Commands** (400+ lines): Requires justification and potential refactoring

**Warning Thresholds**:
- 275+ lines for standard commands
- 425+ lines for complex commands
- 500+ lines triggers refactoring recommendation

### 8. Usage Pattern Analysis

- **Command Dependencies**: Which commands reference other commands
- **Workflow Integration**: How commands work together in typical workflows
- **Argument Consistency**: Similar arguments across related commands
- **Naming Conventions**: Consistent command naming and argument patterns

## Execution Strategy

### Phase 1: Parallel Category Audits

Execute validation for each category simultaneously:

```yaml
parallel_execution:
  - category: git_workflow
    commands: [commit, branch, push, pr]
    validations: [structure, content, markdownParsing, functional, length, repoSpecific]
  - category: repository_analysis
    commands: [context, test, debug]
    validations: [structure, content, markdownParsing, functional, length, repoSpecific]
  - category: system_management
    commands: [sync, deps, fix-ci]
    validations: [structure, content, markdownParsing, functional, length, repoSpecific]
  - category: quality_assurance
    commands: [review, agent-audit, command-audit]
    validations: [structure, content, markdownParsing, functional, length, repoSpecific]
  - category: development_support
    commands: [plan, resolve-cr]
    validations: [structure, content, markdownParsing, functional, length, repoSpecific]
```yaml

### Phase 2: Cross-Command Analysis

- Command count validation per category
- Usage pattern consistency
- Integration point verification
- Workflow completeness assessment

### Phase 3: Remediation

- Auto-fix where possible (formatting, structure standardization)
- Generate specific fix commands for manual issues
- Update documentation based on actual functionality
- Document all changes made
- **Complexity reduction recommendations** for oversized commands

## Execution Verification

After audit completion, **execution-evaluator** is deployed to verify:

- All command files were scanned successfully
- Structure validation completed without errors
- Category assignments were checked
- Content quality standards were validated
- Markdown parsing standards were enforced
- Functional completeness verified
- Length analysis completed
- Repository-specific command detection accurate
- Report generated with all required sections
- Patch snippets (if any) are syntactically correct

## Report Structure

### Executive Summary

```text
Total Commands: XX | Categories: X/5 | Compliance: XX% | Issues Fixed: XX
Average Length: XXX lines | Repository-Specific: X commands
```yaml

### Category Health Matrix

| Category | Command Count | Avg Length | Compliance | Issues |
|----------|---------------|------------|------------|--------|
| git_workflow | 4 | 210 lines | XX% | X |
| repository_analysis | 3 | 165 lines | XX% | X |
| system_management | 3 | 195 lines | XX% | X |
| quality_assurance | 3 | 320 lines | XX% | X |
| development_support | 2 | 380 lines | XX% | X |

### Critical Issues

1. **Missing execution-evaluator**: [Commands performing actions without verification]
2. **Structure Violations**: [Commands missing required sections]
3. **Repository-Specific Detection**: [Commands that should be excluded from sync]
4. **Length Violations**: [Commands exceeding complexity thresholds]
5. **Markdown Parsing Violations**: [Commands with formatting/parsing issues]

### Markdown Parsing Compliance

| Command | Code Fencing | Language Tags | Example Quality | Format Consistency | Issues |
|---------|--------------|---------------|-----------------|-------------------|---------|
| commit | ✅ | ❌ | ✅ | ✅ | Missing yaml tags |
| branch | ✅ | ✅ | ❌ | ✅ | Complex examples without explanation |

**Parsing Standards Summary**:
- Code Fencing: XX/XX commands compliant
- Language Tags: XX/XX commands compliant  
- Example Quality: XX/XX commands compliant
- Format Consistency: XX/XX commands compliant

### Length & Complexity Analysis

| Command | Current Length | Category Limit | Status | Recommendation |
|---------|----------------|----------------|--------|----------------|
| review | 472 lines | 400 lines | ⚠️ Over | Consider refactoring into sub-commands |
| resolve-cr | 371 lines | 400 lines | ✅ OK | Good complexity for feature set |
| plan | 370 lines | 400 lines | ✅ OK | Well-structured complex command |

**Length Distribution**:
- Simple (100-150): X commands
- Standard (150-250): X commands  
- Complex (250-400): X commands
- Ultra-complex (400+): X commands

### Repository-Specific Command Analysis

**Current Repository-Specific Commands**:
- `sync.md` - ✅ Properly excluded from sync
- `command-audit.md` - ✅ Should be excluded (this audit command)

**Sync Exclusion Validation**:
- `sync.md` exclusion pattern: ✅ Current
- `command-audit.md` exclusion: ❌ Needs adding to sync.md
- Repository-specific documentation: ✅ Proper

### Usage Pattern Analysis

**Command Integration Matrix**:
- Most referenced: execution-evaluator (used by X commands)
- Workflow chains: branch → commit → push → pr
- Missing integrations: X command pairs could benefit from integration
- Argument consistency: XX% commands use consistent patterns

### Auto-Remediation Log

```bash
# Fixes applied automatically:
- Updated command-name: Standardized section ordering
- Fixed command-name: Added missing language tags
- Updated command-name: Added execution-evaluator verification
```yaml

### Manual Remediation Required

```bash
# Execute these commands to fix remaining issues:

# Add command-audit.md to sync exclusion list (WARNING: Verify $filename content before execution):
# SAFE: First check the filename variable content, then execute:
# if [[ "$filename" =~ ^[a-zA-Z0-9._-]+\.md$ ]]; then
#   sed -i '' 's/config-diff\.md"/config-diff.md" \&\& "$filename" != "command-audit.md"/' system-configs/.claude/commands/sync.md
# fi

# Standardize section formatting:
sed -i '' 's/## Behavior/## Behavior/' command-name.md

# Add missing execution-evaluator usage:
# Review command-name.md and add execution-evaluator verification section

# Length reduction suggestions:
# Consider breaking down oversized commands into focused sub-commands
```yaml

## Success Criteria

✅ **Structure Compliance**: 100% commands have required sections in proper order
✅ **Content Quality**: Clear descriptions, comprehensive behavior documentation, practical examples
✅ **Markdown Parsing Standards**: Consistent code fencing, language tags, and example quality
✅ **Functional Completeness**: Execution-evaluator usage, proper argument handling, error documentation
✅ **Category Standards**: Commands meet category-specific requirements and integration patterns
✅ **Length Management**: Commands within reasonable complexity limits with justification for exceptions
✅ **Repository-Specific Detection**: Proper identification and exclusion from sync process
✅ **Usage Pattern Consistency**: Coherent argument patterns and workflow integration

## Implementation Notes

- Claude executes all validations directly (no command-auditor agent needed)
- Parallel execution by category for efficiency
- Auto-fix safe issues, provide commands for complex ones
- Focus on maintaining established categories and patterns
- Generate actionable report suitable for immediate implementation
- **This command is repository-specific** and excluded from sync process
- Integration patterns should be documented and followed consistently
- Repository-specific commands must be properly excluded from sync.md

## Architectural Justification for Complexity

**Command Length**: 302 lines (approaching 400-line complexity threshold)

**Justification**: This command establishes the validation framework for the entire command ecosystem (15 commands). The complexity is justified by:

1. **Comprehensive Validation**: 8 distinct validation dimensions requiring detailed specifications
2. **Parallel Execution Framework**: Complex orchestration logic for category-based validation
3. **Detailed Reporting**: Extensive reporting structure with metrics, remediation, and auto-fix guidance
4. **Standards Definition**: Establishes quality standards that other commands must follow
5. **Repository Integration**: Complex sync exclusion and repository-specific command handling

**Refactoring Consideration**: While approaching the complexity limit, breaking this command into sub-commands would
fragment the cohesive validation framework and make it harder to maintain consistency across the validation process.
