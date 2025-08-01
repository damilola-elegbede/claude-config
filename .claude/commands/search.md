# /search Command

## Description
Performs intelligent multi-agent code search and knowledge discovery through specialized search-analyst and codebase-navigator agents to find patterns, understand relationships, and extract insights across complex codebases and documentation.

## Usage
```
/search <query> [options]
```

## Arguments
- `query`: Search terms, patterns, or questions
  - Code patterns: function names, classes, algorithms
  - Architectural concepts: design patterns, data flows
  - Business logic: feature implementations, workflows
  - Technical debt: deprecated code, TODO items

## Options
- `--type <scope>`: Search scope
  - `code`: Source code search (default)
  - `docs`: Documentation search
  - `config`: Configuration files
  - `tests`: Test code search
  - `all`: Comprehensive search

- `--depth <level>`: Analysis depth
  - `surface`: Quick pattern matching
  - `semantic`: Context-aware search
  - `deep`: Relationship analysis (default)

- `--format <output>`: Result format
  - `summary`: Executive summary
  - `detailed`: Comprehensive analysis
  - `interactive`: Q&A style results
  - `report`: Formal documentation

## Behavior
When you use `/search`, I will orchestrate intelligent search and analysis:

### Phase 1 (Query Analysis - 0-10 min)
1. **Launch search-analyst agent** for:
   - Query interpretation and expansion
   - Search strategy development
   - Pattern identification
   - Relevance scoring algorithms
   - Context understanding

2. **Deploy codebase-navigator agent** for:
   - Repository structure analysis
   - Dependency relationship mapping
   - Code organization patterns
   - Module interconnection analysis
   - Architecture overview

### Phase 2 (Multi-Dimensional Search - 10-30 min)
1. **Coordinate specialized search agents**:
   - **Pattern matching**: Exact and fuzzy code searches
   - **Semantic analysis**: Natural language understanding
   - **Relationship mapping**: Connection identification
   - **Impact analysis**: Change effect prediction
   - **Usage discovery**: Implementation examples

2. **Cross-reference analysis**:
   - Code-to-documentation links
   - Test coverage mapping
   - Configuration relationships
   - Dependency chain analysis
   - Historical change patterns

### Phase 3 (Insight Generation - 30+ min)
1. **Knowledge synthesis**:
   - Pattern consolidation
   - Insight extraction
   - Recommendation generation
   - Gap identification
   - Learning documentation

## Examples
```
/search "authentication implementation"          # Find auth-related code
/search "TODO performance" --type all          # Find performance-related tasks
/search "database connection patterns"         # Discover DB usage patterns
/search "deprecated functions" --depth deep    # Analyze deprecated code impact
/search "error handling strategies" --format interactive
/search "API rate limiting" --type code,docs   # Cross-reference search
/search "memory leak patterns" --depth semantic
```

## Search Categories

### Code Pattern Search
- **Function Signatures**: Method definitions and implementations
- **Class Hierarchies**: Inheritance and interface patterns
- **Design Patterns**: Singleton, Factory, Observer implementations
- **Algorithms**: Sorting, searching, optimization routines
- **Data Structures**: Custom collections, models, schemas

### Architectural Search
- **Service Boundaries**: Microservice interactions
- **Data Flow**: Information movement patterns
- **Integration Points**: External system connections
- **Scalability Patterns**: Load handling implementations
- **Security Implementations**: Authentication, authorization

### Business Logic Discovery
- **Feature Implementations**: User story code mapping
- **Workflow Engines**: Process automation logic
- **Business Rules**: Validation and calculation logic
- **Compliance Code**: Regulatory requirement implementations
- **Metrics and Analytics**: Tracking and measurement code

## Multi-Agent Orchestration

### Comprehensive Search Pattern
```
PHASE 1 (Parallel - 10 min):
├── search-analyst: Query expansion and strategy
├── codebase-navigator: Repository structure analysis
└── pattern-matcher: Initial pattern identification

PHASE 2 (Parallel - 20 min):
├── semantic-analyzer: Context understanding
├── relationship-mapper: Connection discovery  
├── usage-tracker: Implementation examples
└── impact-analyzer: Change effect analysis

PHASE 3 (Sequential - 15 min):
├── insight-generator: Pattern synthesis
├── knowledge-curator: Documentation creation
└── recommendation-engine: Actionable suggestions
```

### Specialized Search Patterns
```
Security Code Search:
├── security-auditor: Vulnerability pattern detection
├── search-analyst: Security-specific pattern matching
└── compliance-checker: Regulatory code verification

Performance Code Search:
├── performance-specialist: Bottleneck pattern identification
├── search-analyst: Performance-related code discovery
└── optimization-advisor: Improvement recommendations
```

## Advanced Search Features

### Semantic Understanding
- **Natural Language Queries**: Plain English search interpretation
- **Contextual Relevance**: Understanding intent beyond keywords
- **Synonym Expansion**: Related term discovery
- **Concept Mapping**: Abstract idea to concrete code mapping
- **Domain Knowledge**: Technology-specific understanding

### Relationship Analysis
- **Dependency Graphs**: Code interdependency visualization
- **Call Chains**: Function invocation patterns
- **Data Flow Tracking**: Information movement analysis
- **Version History**: Code evolution tracking
- **Impact Assessment**: Change ripple effect analysis

### Pattern Recognition
- **Anti-Pattern Detection**: Code smell identification
- **Best Practice Discovery**: Exemplary implementations
- **Consistency Analysis**: Coding standard adherence
- **Architecture Compliance**: Design pattern conformance
- **Technical Debt Mapping**: Maintenance burden identification

## Search Intelligence

### Query Enhancement
- **Auto-Completion**: Intelligent search suggestions
- **Query Expansion**: Related term inclusion
- **Filtering Options**: Scope refinement capabilities
- **Ranking Algorithms**: Relevance-based result ordering
- **Historical Learning**: Previous search pattern learning

### Context Awareness
- **Project Understanding**: Codebase-specific knowledge
- **Technology Stack**: Framework and library awareness
- **Naming Conventions**: Project-specific patterns
- **Architecture Patterns**: System design understanding
- **Business Domain**: Industry-specific terminology

### Result Presentation
- **Hierarchical Organization**: Structured result presentation  
- **Visual Relationships**: Graphical connection display
- **Code Snippets**: Relevant code segment highlighting
- **Cross-References**: Related finding connections
- **Interactive Exploration**: Drill-down capabilities

## Search Scopes

### Code Search
- **Source Files**: Application logic, utilities, libraries
- **Configuration**: Environment settings, deployment configs
- **Infrastructure**: Docker, Kubernetes, CI/CD definitions
- **Database**: Schemas, migrations, stored procedures
- **Frontend**: UI components, styling, client logic

### Documentation Search  
- **Technical Docs**: API documentation, architecture guides
- **User Guides**: End-user documentation, tutorials
- **Developer Docs**: Setup guides, contribution guidelines
- **Process Docs**: Workflows, procedures, standards
- **Decision Records**: Architecture decision documents

### Test Search
- **Unit Tests**: Component-level test coverage
- **Integration Tests**: System interaction validation
- **End-to-End Tests**: Full workflow validation
- **Performance Tests**: Load and stress testing
- **Security Tests**: Vulnerability assessment tests

## Output Formats

### Summary Format
- **Key Findings**: Most relevant discoveries
- **Pattern Overview**: Common implementation approaches
- **Recommendation Highlights**: Top actionable insights
- **Quick Stats**: Quantitative analysis results
- **Next Steps**: Suggested follow-up actions

### Detailed Analysis
- **Comprehensive Results**: All matching patterns
- **Relationship Maps**: Connection visualizations
- **Code Examples**: Implementation demonstrations
- **Comparative Analysis**: Alternative approaches
- **Deep Insights**: Advanced pattern analysis

### Interactive Results
- **Q&A Interface**: Follow-up question handling
- **Drill-Down Navigation**: Hierarchical exploration
- **Related Searches**: Connected query suggestions
- **Live Filtering**: Dynamic result refinement
- **Collaborative Notes**: Team knowledge sharing

## Integration Capabilities

### Development Tools
- **IDE Integration**: Search within development environments
- **Git Integration**: Version history search capabilities
- **CI/CD Integration**: Pipeline-specific searches
- **Issue Tracking**: Bug/feature search correlation
- **Code Review**: Pull request pattern analysis

### Knowledge Management
- **Wiki Integration**: Documentation cross-referencing
- **Knowledge Base**: Organizational knowledge search
- **Training Materials**: Learning resource discovery
- **Best Practices**: Standard implementation finding
- **Lessons Learned**: Historical insight extraction

### Collaboration Platforms
- **Slack/Teams**: Search result sharing
- **Documentation Sites**: Cross-platform search
- **Project Management**: Task-related code discovery
- **Communication Tools**: Discussion thread search
- **Meeting Notes**: Decision implementation tracking

## Search Analytics

### Usage Metrics
- **Search Frequency**: Most common queries
- **Success Rates**: Query resolution effectiveness
- **Time to Discovery**: Average search completion time
- **Pattern Trends**: Emerging code patterns
- **Knowledge Gaps**: Unaddressed search areas

### Quality Metrics
- **Relevance Scores**: Result accuracy measurements
- **Coverage Analysis**: Search scope completeness
- **False Positive Rates**: Irrelevant result percentages
- **User Satisfaction**: Search utility ratings
- **Knowledge Retention**: Learning effectiveness

## Prerequisites
- **Codebase Access**: Source code repository permissions
- **Documentation Access**: Technical documentation availability
- **Project Context**: Understanding of system architecture
- **Search Objectives**: Clear information needs
- **Time Constraints**: Search depth and scope requirements

## Success Indicators
- **Discovery Speed**: Rapid information location
- **Insight Quality**: Actionable findings generation
- **Knowledge Transfer**: Team learning facilitation
- **Problem Resolution**: Issue resolution acceleration
- **Innovation Support**: New development idea generation

## Notes
- Emphasizes understanding over simple text matching
- Provides context-aware, intelligent search capabilities
- Supports both specific queries and exploratory discovery
- Integrates multiple search methodologies for comprehensive results
- Facilitates knowledge sharing and team collaboration
- Adapts to project-specific patterns and conventions
- Continuously learns from search patterns and feedback