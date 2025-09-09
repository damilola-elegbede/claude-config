---
description: Comprehensive command optimization through wave-based orchestration
---

# /command-audit Command

## Usage

```bash
# Comprehensive wave-based command audit
/command-audit

# Run specific validation waves
/command-audit --wave1    # Basic validation only
/command-audit --wave2    # Enhancement analysis only
/command-audit --wave3    # Report generation only

# Apply discovered optimizations
/command-audit --apply-fixes
```

## Description

Orchestrates comprehensive command optimization through systematic wave-based analysis. Deploys specialized agent
teams in parallel waves for validation, enhancement analysis, and optimization recommendations.
Transforms from simple validation to complete command ecosystem optimization.

## Wave-Based Orchestration Architecture

### Wave 1: Basic Validation (Parallel Foundation)

Deploy multiple specialist agents simultaneously for foundational analysis:

**Parallel Agent Deployment:**

- **code-reviewer**: Syntax validation, structure compliance, template adherence
- **security-auditor**: Security pattern analysis, sensitive operation detection
- **test-engineer**: Testability assessment, validation strategy evaluation

**Claude Analysis Phase:** Categorize discovered issues by severity levels:

- **Critical**: Breaks functionality, security vulnerabilities, template violations
- **High**: Performance impacts, missing agent specifications, poor structure
- **Medium**: Documentation gaps, style inconsistencies, optimization opportunities
- **Low**: Minor formatting issues, optional improvements

### Wave 2: Command Enhancement Analysis (Strategic Optimization)

Deploy enhancement specialists based on Wave 1 categorization:

**Parallel Agent Deployment:**

- **performance-engineer**: Optimization opportunities, parallel execution patterns
- **tech-writer**: Documentation quality, clarity improvements, user experience
- **project-orchestrator**: Workflow optimization, agent coordination patterns

**Claude Decision Phase:** Determine enhancement priorities:

- **High-Impact Optimizations**: Commands with significant performance/usability gains
- **Agent Coordination Improvements**: Better parallel execution patterns
- **Documentation Enhancement**: Critical clarity and completeness gaps
- **Workflow Optimization**: Cross-command integration opportunities

### Wave 3: Report Generation & Implementation (Comprehensive Output)

Generate actionable optimization roadmap:

**Deliverables:**

- **Comprehensive Audit Report**: Multi-dimensional analysis with prioritized recommendations
- **Fix Recommendations**: Automated fixes vs. manual improvements with implementation guides
- **Enhancement Priorities**: Strategic roadmap for command ecosystem optimization

## Expected Output

### Executive Dashboard

```text
COMMAND OPTIMIZATION AUDIT - Wave-Based Analysis Complete
────────────────────────────────────────────────────────────────

Commands Analyzed: [total] | Critical Issues: [count] | Optimizations Found: [count]
Security Score: [rating] | Performance Score: [rating] | Documentation Score: [rating]
Auto-Fix Available: [count] | Manual Optimization: [count] | Enhancement Opportunities: [count]
```

### Wave Analysis Results

#### Wave 1: Validation Foundation Results

**Critical Issues Detected:**

- Template compliance violations
- Security vulnerabilities in sensitive operations
- Broken or invalid agent references
- Syntax errors and structural problems

**Severity Classification:**
| Command | Critical | High | Medium | Low | Test Coverage | Security Score |
|---------|----------|------|--------|-----|---------------|----------------|
| /commit | 0 | 1 | 2 | 3 | 85% | 9/10 |
| /push | 0 | 0 | 1 | 2 | 90% | 10/10 |
| /pr | 0 | 1 | 3 | 5 | 75% | 8/10 |

#### Wave 2: Enhancement Analysis Results

**Optimization Opportunities:**

- Parallel execution improvements
- Agent coordination enhancements
- Performance bottleneck elimination
- Documentation completeness gaps

**Enhancement Priority Matrix:**
| Command | Impact | Complexity | ROI Score | Optimization Type | Recommended Agents |
|---------|--------|------------|-----------|-------------------|-------------------|
| /commit | High | Medium | 8.5 | Parallel execution | code-reviewer, test-engineer |
| /push | High | Low | 9.0 | Quality gates | devops, security-auditor |
| /pr | Medium | High | 6.5 | Content generation | tech-writer, business-analyst |

#### Wave 3: Implementation Roadmap

**Immediate Actions (Auto-Fix):**

```bash
# High-confidence automatic improvements
./scripts/auto-fix-commands.sh --syntax --formatting --references
```

**Manual Optimization Tasks:**

1. **High-Priority Enhancements** (Immediate impact)
2. **Agent Coordination Improvements** (Parallel execution patterns)
3. **Documentation Quality** (User experience improvements)
4. **Strategic Optimizations** (Long-term ecosystem health)

## Behavior

### Wave 1: Basic Validation Execution

**Parallel Agent Coordination:**

```bash
# Deploy code-reviewer instances for comprehensive syntax validation
TASK: code-reviewer-syntax "Validate command syntax, structure, template compliance"
TASK: code-reviewer-agents "Verify agent references against 28 production agents"
TASK: code-reviewer-format "Check markdown quality, code blocks, formatting"

# Deploy security-auditor for security pattern analysis
TASK: security-auditor-patterns "Analyze security-sensitive operations"
TASK: security-auditor-refs "Validate security agent usage in critical commands"

# Deploy test-engineer for testability assessment
TASK: test-engineer-coverage "Assess command testability and validation strategies"
TASK: test-engineer-integration "Evaluate integration test requirements"
```

**Issue Categorization Logic:**

- **Critical**: Template violations, security gaps, broken references
- **High**: Missing parallelization, performance impacts, structural issues
- **Medium**: Documentation gaps, style inconsistencies, minor optimizations
- **Low**: Formatting preferences, optional enhancements

### Wave 2: Enhancement Analysis Execution

**Strategic Agent Deployment:**

```bash
# Deploy performance-engineer for optimization analysis
TASK: performance-engineer-parallel "Identify parallelization opportunities"
TASK: performance-engineer-bottlenecks "Detect performance bottlenecks"

# Deploy tech-writer for documentation enhancement
TASK: tech-writer-clarity "Analyze documentation clarity and completeness"
TASK: tech-writer-examples "Evaluate example quality and coverage"

# Deploy project-orchestrator for workflow optimization
TASK: project-orchestrator-coordination "Optimize agent coordination patterns"
TASK: project-orchestrator-workflows "Enhance cross-command workflows"
```

**Enhancement Priority Calculation:**

- **Impact Score** (1-10): User value, performance improvement, security enhancement
- **Complexity Score** (1-10): Implementation difficulty, risk assessment
- **ROI Score**: Impact/Complexity ratio for optimization prioritization

### Wave 3: Report Generation & Recommendations

**Comprehensive Analysis Integration:**

```bash
# Consolidate findings from all waves
CONSOLIDATION: Merge validation results, enhancement analysis, priority rankings
REPORTING: Generate executive summary, detailed findings, implementation roadmap
RECOMMENDATIONS: Create actionable fix scripts, manual optimization guides
```

**Implementation Strategy:**

1. **Auto-Fix Deployment**: Safe, high-confidence improvements
2. **Manual Enhancement Guide**: Step-by-step optimization instructions
3. **Strategic Roadmap**: Long-term command ecosystem evolution

### Success Criteria Verification

Deploy execution-evaluator to verify comprehensive optimization:

- ✅ **Wave 1 Complete** - All validation agents deployed, issues categorized by severity
- ✅ **Wave 2 Complete** - Enhancement analysis finished, priorities established
- ✅ **Wave 3 Complete** - Comprehensive report generated with actionable recommendations
- ✅ **Critical Issues Identified** - All template violations, security gaps documented
- ✅ **Optimization Opportunities** - Performance, parallelization, documentation improvements mapped
- ✅ **Implementation Roadmap** - Clear priorities with auto-fix and manual optimization paths
- ✅ **Agent Coordination** - Parallel execution patterns optimized across command ecosystem
- ✅ **Security Enhanced** - All security-sensitive operations properly validated
- ✅ **Performance Optimized** - Parallel execution and bottleneck elimination opportunities identified
- ✅ **Documentation Improved** - Clarity, completeness, and user experience enhancements prioritized

## Advanced Orchestration Features

### Dynamic Agent Scaling

Based on repository size and complexity:

- **Small repos (<20 commands)**: 3-5 agents per wave
- **Medium repos (20-50 commands)**: 5-10 agents per wave
- **Large repos (50+ commands)**: 10-20 agents per wave

### Intelligent Issue Correlation

Cross-reference issues across commands to identify:

- **Systematic Problems**: Template violations across multiple commands
- **Security Patterns**: Consistent security gaps requiring global fixes
- **Optimization Opportunities**: Common parallelization improvements

### Progressive Enhancement

Each wave builds on previous findings:

- **Wave 1 → Wave 2**: Severity categorization drives enhancement focus
- **Wave 2 → Wave 3**: Priority analysis determines implementation order
- **Iterative Improvement**: Continuous optimization based on usage patterns

This comprehensive wave-based orchestration transforms simple command validation into strategic command ecosystem
optimization, ensuring maximum parallel efficiency, security compliance, and user experience enhancement.
