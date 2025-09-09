---
description: Documentation management with wave-based orchestration
argument-hint: [scope|--audit|--clean]
---

# /docs Command

## Usage

```bash
/docs                    # Progressive documentation enhancement (3 waves)
/docs --audit            # Wave 1 gap analysis only
/docs --clean            # Clean temporary docs and organize
/docs api                # Focused API documentation update
/docs readme             # README.md refresh only
/docs architecture       # System design docs only
/docs setup              # Installation and setup docs
```

## Description

Progressive documentation enhancement system using wave-based orchestration. Identifies gaps systematically, generates
documentation in parallel waves, and applies quality enhancement passes. Each wave includes quality gates to ensure
comprehensive coverage and excellence.

**IMPORTANT: This command explicitly excludes all CLAUDE.md files from any operations.** CLAUDE.md files at any level
(root directory, home directory, project directory, or nested locations) are never read, written, modified, or
analyzed by the /docs command. These configuration files are protected system files that must remain untouched
during documentation operations.

## Protected Files

The following files are **NEVER** touched, read, written, or modified by the /docs command:

- **CLAUDE.md** (any location: root, home, project, nested directories)
- **~/.claude/CLAUDE.md** (home directory configuration)
- **./CLAUDE.md** (project root configuration)
- **Any path containing CLAUDE.md** (all nested locations)

These files contain critical system configurations and agent orchestration instructions that must remain isolated
from documentation generation processes.

## Expected Output

### Wave-Based Progressive Enhancement

```text
User: /docs
Claude: 🌊 Wave 1: Gap Analysis & Assessment
📊 Deploying analysis wave...
  - codebase-analyst[1]: Scanning undocumented components (excluding CLAUDE.md)...
  - codebase-analyst[2]: Checking API completeness...
  - tech-writer: Assessing documentation quality...
  - api-architect: Evaluating API documentation...

📋 Wave 1 Results:
  - 8 undocumented code sections identified
  - 5 missing API endpoints found
  - README.md installation steps outdated
  - Architecture diagrams need updates
  - CLAUDE.md files skipped (protected system files)

🌊 Wave 2: Documentation Generation
⚡ Deploying 6 parallel generators...
  - tech-writer[1]: README.md refresh...
  - tech-writer[2]: API documentation...
  - tech-writer[3]: Architecture docs...
  - tech-writer[4]: User guides...
  - api-architect: OpenAPI specifications...
  - accessibility-auditor: Accessibility guidelines...

✅ Wave 2 Complete: Core documentation generated

🌊 Wave 3: Quality Enhancement & Polish
🔍 Deploying enhancement wave...
  - tech-writer[5]: Cross-referencing and polish...
  - ux-researcher: User experience guidelines...
  - business-analyst: Business context integration...

📚 All waves complete in 3m 15s
✨ Documentation suite enhanced with quality gates
```

### Audit-Only Mode

```text
User: /docs --audit
Claude: 🔍 Running Wave 1 gap analysis only...
📊 codebase-analyst[1]: Frontend documentation gaps (excluding CLAUDE.md)...
📊 codebase-analyst[2]: Backend API coverage...
📊 tech-writer: Quality assessment...
📊 api-architect: API completeness check...

📋 Documentation Gap Analysis:
- 5 missing API endpoints
- README.md installation steps outdated
- Architecture diagrams need updates
- 3 configuration options undocumented
- Mobile development docs missing
- Accessibility guidelines incomplete
- CLAUDE.md files skipped (system protection)
```

## Behavior

### Wave-Based Orchestration Strategy

#### Wave 1: Gap Analysis & Assessment (45-60 seconds)

```yaml
Parallel Gap Analysis:
  codebase-analyst (instance pool):
    deployment: 2-3 instances for comprehensive scanning
    distribution:
      - instance_1: Frontend components and UI documentation needs
      - instance_2: Backend services, API endpoints, data models
      - instance_3: Infrastructure, deployment, configuration docs
    role: Identify undocumented code sections and missing documentation
    exclusions: All CLAUDE.md files at any level are skipped during scanning
    output: Comprehensive gap inventory with priority rankings
    protection: CLAUDE.md files never included in analysis or recommendations

  tech-writer (assessment instance):
    role: Evaluate existing documentation quality and structure
    parallel_with: [codebase-analyst instances]
    focus: Content quality, organization, clarity, completeness
    exclusions: CLAUDE.md files are never assessed or modified
    output: Quality assessment with improvement recommendations

  api-architect:
    role: Assess API documentation completeness and accuracy
    parallel_with: [codebase-analyst instances, tech-writer]
    focus: OpenAPI specs, endpoint coverage, schema documentation
    exclusions: CLAUDE.md files are never analyzed for API documentation needs
    output: API documentation requirements and missing specifications

Claude Analysis Phase:
  consolidation: Merge findings from all analysis instances
  prioritization: Rank documentation gaps by importance and impact
  resource_planning: Determine Wave 2 instance allocation based on scope
  quality_gate: Verify complete gap identification before Wave 2
  protection_verification: Confirm CLAUDE.md files were never accessed
```

#### Wave 2: Parallel Documentation Generation (2-3 minutes)

```yaml
High-Priority Documentation Generation:
  tech-writer (instance pool):
    deployment: 4-6 instances based on documentation scope
    calculation: min(6, number_of_priority_doc_types)
    distribution:
      - instance_1: README.md comprehensive refresh
      - instance_2: Core API documentation and examples
      - instance_3: Architecture and design documentation
      - instance_4: User guides and tutorials
      - instance_5: Installation and setup documentation
      - instance_6: Developer guides and contribution docs
    parallel_execution: All high-priority documents generated simultaneously
    role: Create comprehensive documentation for identified gaps
    exclusions: CLAUDE.md files are never modified or referenced
    output: Complete documentation suite addressing Wave 1 findings

  api-architect (specialized generation):
    parallel_with: [tech-writer instances]
    role: Generate OpenAPI specifications and API contracts
    focus: Endpoint documentation, request/response schemas, authentication
    exclusions: CLAUDE.md files are never used as source material
    output: Complete API documentation with interactive examples

  accessibility-auditor:
    parallel_with: [tech-writer instances]
    role: Create accessibility documentation and guidelines
    focus: WCAG compliance, testing procedures, implementation guides
    exclusions: CLAUDE.md files are never analyzed for accessibility
    output: Comprehensive accessibility documentation

  mobile-engineer:
    parallel_with: [tech-writer instances]
    role: Mobile development documentation and platform guides
    focus: iOS/Android setup, platform-specific considerations, testing
    exclusions: CLAUDE.md files are never referenced for mobile documentation
    output: Mobile development documentation suite

Claude Review Phase:
  completeness_check: Verify all Wave 1 gaps addressed
  quality_assessment: Review generated content for accuracy and clarity
  missing_sections: Identify any documentation still needed for Wave 3
  integration_planning: Plan cross-references and navigation improvements
  protection_verification: Confirm no CLAUDE.md files were modified
```

#### Wave 3: Quality Enhancement & Integration (1-2 minutes)

```yaml
Quality Enhancement and Polish:
  tech-writer (enhancement instance):
    role: Polish documentation, add cross-references, improve navigation
    focus: Consistency, clarity, organization, comprehensive linking
    input: All Wave 2 documentation outputs
    exclusions: CLAUDE.md files are never included in cross-referencing
    output: Polished, interconnected documentation suite

  ux-researcher:
    parallel_with: [tech-writer enhancement]
    role: Add user experience guidelines and usability documentation
    focus: User journey documentation, interface guidelines, best practices
    exclusions: CLAUDE.md files are never analyzed for UX patterns
    output: UX documentation and user-centered design guides

  business-analyst:
    parallel_with: [tech-writer enhancement, ux-researcher]
    role: Add business context, value propositions, and strategic alignment
    focus: Business requirements, stakeholder documentation, ROI context
    exclusions: CLAUDE.md files are never referenced for business context
    output: Business-aligned documentation with strategic context

Claude Final Integration:
  cross_reference_validation: Ensure all internal links work correctly
  completeness_verification: Confirm all original gaps are addressed
  quality_standards_check: Verify documentation meets excellence criteria
  organization_optimization: Final structure and navigation improvements
  protection_verification: Final confirmation CLAUDE.md files remain untouched
```

### Progressive Enhancement Benefits

#### Quality Gates Between Waves

```yaml
Wave 1 → Wave 2 Gate:
  requirements:
    - Complete gap inventory from all analysis instances
    - Priority ranking established
    - Resource allocation plan confirmed
    - No critical documentation areas missed
    - CLAUDE.md protection verified

Wave 2 → Wave 3 Gate:
  requirements:
    - All high-priority documentation generated
    - Content accuracy verified
    - Examples tested and functional
    - API documentation complete and validated
    - No CLAUDE.md files modified

Wave 3 → Completion Gate:
  requirements:
    - Cross-references established
    - Navigation optimized
    - Quality standards met
    - Business context integrated
    - User experience guidelines included
    - CLAUDE.md files remain completely untouched
```

#### Documentation Targets by Wave

```yaml
Wave 1 Targets (Gap Analysis):
  Code Documentation:
    - Undocumented functions and classes
    - Missing API endpoint documentation
    - Configuration options without documentation
    - Setup and deployment procedures
    - EXCLUSION: CLAUDE.md files are never scanned or analyzed

  Quality Assessment:
    - Outdated installation instructions
    - Broken links and examples
    - Inconsistent formatting
    - Missing troubleshooting sections
    - EXCLUSION: CLAUDE.md files are never assessed for quality

Wave 2 Targets (Core Generation):
  Essential Documentation:
    - README.md: Complete project overview
    - API Documentation: All endpoints with examples
    - Architecture: System design and components
    - User Guides: Installation and usage
    - Developer Guides: Contribution and development
    - EXCLUSION: CLAUDE.md files are never generated or modified

  Specialized Documentation:
    - OpenAPI specifications
    - Accessibility guidelines
    - Mobile development guides
    - Security documentation
    - EXCLUSION: CLAUDE.md files are never referenced as source material

Wave 3 Targets (Enhancement):
  Quality Improvements:
    - Cross-referencing between documents
    - Navigation and organization
    - Consistency and clarity
    - User experience guidelines
    - Business context and value propositions
    - EXCLUSION: CLAUDE.md files are never included in cross-references
```

### Execution Strategy

#### Wave Orchestration Pattern

```yaml
Wave 1 Execution (Gap Analysis):
  trigger: Immediate parallel deployment
  agents: 4-5 instances (codebase-analyst × 2-3, tech-writer × 1, api-architect × 1)
  duration: 45-60 seconds
  success_criteria: Complete gap inventory with priorities
  gate_check: Verify all documentation areas assessed (excluding CLAUDE.md)
  protection: Confirm CLAUDE.md files were never accessed

Wave 2 Execution (Core Generation):
  trigger: Wave 1 gate passed
  agents: 6-8 instances (tech-writer × 4-6, api-architect × 1, specialists × 1-2)
  duration: 2-3 minutes
  success_criteria: All priority documentation generated
  gate_check: Verify content accuracy and completeness
  protection: Confirm no CLAUDE.md files were modified

Wave 3 Execution (Enhancement):
  trigger: Wave 2 gate passed
  agents: 3-4 instances (tech-writer × 1, ux-researcher × 1, business-analyst × 1)
  duration: 1-2 minutes
  success_criteria: Polished, integrated documentation suite
  gate_check: Final quality and consistency verification
  protection: Final verification CLAUDE.md files remain untouched

Total Time Optimization:
  - Sequential approach: 8-12 minutes
  - Wave-based parallel: 4-6 minutes (2-3x faster)
  - Quality assurance: Built-in gates between waves
  - Progressive enhancement: Each wave builds on previous
  - System protection: CLAUDE.md files never accessed throughout process
```

#### Quality Standards by Wave

```yaml
Wave 1 Standards (Analysis):
  Completeness: All code sections scanned for documentation needs (excluding CLAUDE.md)
  Accuracy: Current state of documentation accurately assessed
  Prioritization: Gaps ranked by importance and user impact
  Protection: CLAUDE.md files completely ignored during analysis

Wave 2 Standards (Generation):
  Functionality: All code examples execute successfully
  Accuracy: Version numbers and references are current
  Completeness: All identified gaps addressed with quality content
  Consistency: Formatting and style maintained across documents
  Protection: No CLAUDE.md files referenced or modified

Wave 3 Standards (Enhancement):
  Navigation: Clear document structure with working cross-references
  Clarity: Content optimized for target audience comprehension
  Integration: Business context and user experience considerations included
  Excellence: Documentation exceeds basic requirements with value-added content
  Protection: CLAUDE.md files never included in any cross-referencing or linking
```

### Cleanup Targets

#### Temporary Files Organization

```text
# Analysis and report files from all waves
*-analysis.md → .tmp/analysis/
*-report.md → .tmp/reports/
*-status.md → .tmp/reports/
wave-*-findings.md → .tmp/analysis/

# Draft and working documents
draft-*.md → .tmp/drafts/
temp-*.md → .tmp/drafts/
notes-*.md → .tmp/drafts/
enhancement-*.md → .tmp/drafts/

# EXCLUSION: CLAUDE.md files are never moved or organized by cleanup
```

### Execution Verification

Deploy execution-evaluator to verify:

- ✅ **Wave 1 Completeness** - All documentation gaps identified and prioritized (CLAUDE.md excluded)
- ✅ **Wave 2 Generation** - Core documentation created addressing all priority gaps
- ✅ **Wave 3 Enhancement** - Quality improvements and integration completed
- ✅ **Quality Gates** - Each wave met success criteria before proceeding
- ✅ **Progressive Enhancement** - Documentation quality improved through systematic waves
- ✅ **Agent Coordination** - All wave deployments executed successfully with no conflicts
- ✅ **System Protection** - CLAUDE.md files never accessed, read, written, or modified throughout entire process

### Notes

- **Wave-Based Orchestration**: Progressive enhancement through 3 distinct quality-gated waves
- **Quality Gates**: Each wave must meet success criteria before next wave deploys
- **Parallel Efficiency**: 6-8 agents per wave for maximum parallel processing
- **Progressive Enhancement**: Each wave builds systematically on previous wave outputs
- **Comprehensive Coverage**: Analysis → Generation → Enhancement ensures no gaps remain
- **Performance Target**: 4-6 minutes for complete documentation overhaul (2-3x faster than sequential)
- **System Protection**: CLAUDE.md files are completely excluded from all documentation operations
- Automatically adapts wave scope based on project size and documentation needs
- Maintains quality standards while maximizing parallel execution efficiency
- Organizes all temporary files and maintains clean workspace throughout process
- **Zero-Touch Policy**: CLAUDE.md files at any level remain completely untouched by design
