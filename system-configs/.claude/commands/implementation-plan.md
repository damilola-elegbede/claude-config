---
description: Generate detailed implementation plans without execution
argument-hint: "[description] [--no-execute|--verbose|--minimal|--compare <approach>]"
thinking-level: ultrathink
thinking-tokens: 31999
---

# /implementation-plan Command

## Usage

```bash
# Analyze and plan implementation without execution
/implementation-plan "Add user authentication system" --no-execute

# Detailed fix planning
/implementation-plan "Fix cart CSS loading issues per Codex analysis"

# Feature implementation planning
/implementation-plan "Implement dark mode toggle with theme persistence"

# Refactoring plan
/implementation-plan "Refactor database queries for performance optimization"
```

## Description

Analyze proposed solutions and provide detailed implementation plans without executing any changes. Generates
comprehensive task breakdowns with exact file paths, specific code changes, dependencies, and verification steps.

### Thinking Level: ULTRATHINK (31,999 tokens)

This command requires maximum thinking depth due to:
- **Line-by-line change analysis**: Detailed code modifications with exact line numbers and snippets
- **Comprehensive risk assessment**: Edge cases, breaking changes, and migration requirements
- **Execution sequencing logic**: Complex dependency graphs and parallel execution planning
- **Multi-file coordination**: Changes across dozens of files with intricate relationships
- **Verification strategy design**: Test scenarios, validation steps, and rollback procedures

## Expected Output

Structured implementation plan with:

1. **File Modification List**: Complete paths of all files to be modified
2. **Specific Changes**: Line-by-line changes with code snippets
3. **Task Grouping**: Changes organized by logical tasks/components
4. **Execution Order**: Dependencies and sequencing requirements
5. **Edge Cases**: Special scenarios and error handling
6. **Verification Plan**: Testing and validation steps

## Behavior

### Analysis Phase

Before generating the plan:

```yaml
Code Analysis:
  - Scan relevant files for current implementation
  - Identify dependencies and imports
  - Map component relationships
  - Detect potential conflicts

Pattern Recognition:
  - Follow existing code conventions
  - Match current file organization
  - Preserve established patterns
  - Maintain consistency

Risk Assessment:
  - Identify breaking changes
  - Flag dependency issues
  - Note migration requirements
  - Highlight testing needs
```

### Plan Structure

Generate comprehensive implementation blueprint:

```yaml
Section 1 - Overview:
  Summary: Brief description of changes
  Scope: Files and components affected
  Risk Level: Low/Medium/High
  Estimated Complexity: Simple/Moderate/Complex

Section 2 - File Modifications:
  For each file:
    - Full absolute path
    - Current state summary
    - Specific changes needed
    - Line numbers for modifications
    - Exact code to add/remove/modify
    - Rationale for changes

Section 3 - Task Breakdown:
  Task Group 1:
    - Purpose/goal
    - Files involved
    - Changes required
    - Dependencies
    - Verification steps

  Task Group 2:
    - [Similar structure]

Section 4 - Execution Sequence:
  1. Prerequisites/setup
  2. Core implementation order
  3. Integration steps
  4. Cleanup/finalization

Section 5 - Edge Cases:
  - Scenario identification
  - Handling strategies
  - Fallback approaches
  - Error recovery

Section 6 - Verification:
  - Unit test requirements
  - Integration test scenarios
  - Manual testing steps
  - Success criteria
```

### Output Format

Deliver actionable, copy-paste ready plan:

```markdown
## Implementation Plan: [Description]

### 📋 Overview
- **Objective**: [Clear goal statement]
- **Files to Modify**: [Count] files
- **Risk Assessment**: [Low/Medium/High]
- **Dependencies**: [List key dependencies]

### 📁 File Modifications

#### 1. `/path/to/file1.js`
**Current State**: [Brief description]
**Changes Required**:

Line 15-20: Add import statement
\`\`\`javascript
import { NewComponent } from './components/NewComponent';
\`\`\`

Line 145: Replace existing function
\`\`\`javascript
// Remove:
function oldImplementation() { ... }

// Add:
function newImplementation() {
  // New logic here
}
\`\`\`

#### 2. `/path/to/file2.css`
[Similar structure]

### 🔧 Task Groups

#### Task 1: Core Implementation
**Files**: file1.js, file2.js
**Purpose**: Implement main functionality
**Steps**:
1. Add new component class
2. Wire up event handlers
3. Update state management

#### Task 2: Styling Updates
**Files**: styles.css, theme.css
**Purpose**: Apply visual changes
**Steps**:
1. Add new CSS classes
2. Update existing selectors
3. Ensure responsive behavior

### 📊 Execution Order

1. **Setup Phase**
   - Backup current files
   - Install dependencies if needed

2. **Implementation Phase**
   - Task 1: Core functionality
   - Task 2: Styling updates
   - Task 3: Integration

3. **Verification Phase**
   - Run existing tests
   - Add new test cases
   - Manual verification

### ⚠️ Edge Cases & Considerations

1. **Browser Compatibility**
   - IE11 requires polyfills for...
   - Safari needs vendor prefixes for...

2. **Performance Impact**
   - Large datasets may require pagination
   - Consider lazy loading for...

### ✅ Verification Steps

1. **Automated Tests**
   - Run: `npm test`
   - Expected: All tests pass
   - New tests for: [features]

2. **Manual Testing**
   - Check feature in Chrome/Firefox/Safari
   - Verify responsive design
   - Test error scenarios

3. **Success Criteria**
   - [ ] Feature works as specified
   - [ ] No regression in existing features
   - [ ] Performance metrics maintained
   - [ ] Accessibility standards met
```

### Special Flags

Handle command options:

```yaml
--no-execute (default):
  - Plan only, no implementation
  - Safe mode for review
  - Default behavior

--verbose:
  - Include code context
  - Show before/after comparisons
  - Add implementation notes

--minimal:
  - File list and key changes only
  - Quick overview format
  - Less detailed output

--compare [approach]:
  - Compare multiple approaches
  - Side-by-side analysis
  - Trade-off evaluation
```

### Common Use Cases

#### Bug Fix Planning

```bash
/implementation-plan "Fix cart CSS loading issues"
```

- Identify root cause files
- Map CSS dependencies
- Plan load order fixes
- Include regression tests

#### Feature Implementation

```bash
/implementation-plan "Add dark mode toggle"
```

- Component structure planning
- State management approach
- Theme switching logic
- Persistence strategy

#### Refactoring Strategy

```bash
/implementation-plan "Refactor API client to use async/await"
```

- Identify all callback patterns
- Plan conversion approach
- Handle error boundaries
- Maintain backwards compatibility

#### Performance Optimization

```bash
/implementation-plan "Optimize database queries for dashboard"
```

- Query analysis
- Index planning
- Caching strategy
- Migration approach

## Success Criteria

Effective implementation planning:

- Complete file list with paths
- Specific, actionable changes
- Clear execution sequence
- Risk identification
- Verification strategy
- No actual code execution

## Command Philosophy

Transform vague requirements into precise, executable plans. Bridge the gap between "what" and "how" without
premature implementation. Enable review, discussion, and refinement before committing to changes.

```yaml
Planning Benefits:
  - Review before execution
  - Identify issues early
  - Coordinate team efforts
  - Document decisions
  - Reduce implementation errors

Key Principles:
  - Specificity over generality
  - Actionable over theoretical
  - Complete over partial
  - Structured over scattered
  - Verifiable over assumed
```
