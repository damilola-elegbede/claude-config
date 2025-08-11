# /scaffold Command

## Description

Intelligent multi-framework project and component scaffolding system that generates production-ready boilerplate code with tests, documentation, and best practices. Orchestrates multiple agents in parallel to analyze patterns, generate code, and integrate results across React, Vue, Angular, Node.js, Python, and other frameworks.

<description>
Intelligent multi-framework project and component scaffolding system that generates production-ready boilerplate code with tests, documentation, and best practices. Orchestrates multiple agents in parallel to analyze patterns, generate code, and integrate results across React, Vue, Angular, Node.js, Python, and other frameworks.
</description>

## Usage

```bash
/scaffold <type> <name> [options]
```

### Arguments

- `<type>`: Type of scaffold to generate
  - `component` - UI components (React/Vue/Angular)
  - `service` - Business logic services
  - `feature` - Complete features with UI + API
  - `api` - REST API endpoints
  - `model` - Data models/schemas
  - `module` - Framework modules/packages
  - `project` - Complete project initialization

- `<name>`: Name for the generated code (PascalCase or kebab-case)

### Options

<options>
  <framework>
    <flag>--framework</flag>
    <values>react|vue|angular|express|fastapi|django|spring|go|python</values>
    <default>auto-detect</default>
    <description>Target framework for generation</description>
  </framework>
  
  <testing>
    <flag>--with-tests</flag>
    <type>boolean</type>
    <default>true if test framework detected</default>
    <description>Generate comprehensive test suites</description>
  </testing>
  
  <stories>
    <flag>--with-stories</flag>
    <type>boolean</type>
    <default>true if Storybook detected</default>
    <description>Create Storybook stories and controls</description>
  </stories>
  
  <docs>
    <flag>--with-docs</flag>
    <type>boolean</type>
    <default>false</default>
    <description>Generate documentation and usage examples</description>
  </docs>
  
  <styling>
    <flag>--style</flag>
    <values>css|scss|styled-components|tailwind|css-modules</values>
    <default>auto-detect from project</default>
    <description>Styling approach to use</description>
  </styling>
  
  <typescript>
    <flag>--typescript</flag>
    <type>boolean</type>
    <default>auto-detect from tsconfig.json</default>
    <description>Generate TypeScript definitions</description>
  </typescript>
  
  <interactive>
    <flag>--interactive</flag>
    <type>boolean</type>
    <default>false</default>
    <description>Launch interactive mode with prompts</description>
  </interactive>
  
  <dry-run>
    <flag>--dry-run</flag>
    <type>boolean</type>
    <default>false</default>
    <description>Preview generation without creating files</description>
  </dry-run>
  
  <template>
    <flag>--template</flag>
    <type>string</type>
    <description>Custom template path or name</description>
  </template>
  
  <props>
    <flag>--props</flag>
    <type>string</type>
    <description>Component props (format: name:type,name:type)</description>
  </props>
</options>

## Behavior

<execution-flow>
  <phase name="1. Pattern Analysis" agents="1" duration="2-3s">
    <objective>Analyze existing codebase patterns and conventions</objective>
    <agent>codebase-analyst</agent>
    <tasks>
      <task>Detect framework and version</task>
      <task>Identify naming conventions</task>
      <task>Analyze directory structure</task>
      <task>Detect testing patterns</task>
      <task>Identify styling approach</task>
      <task>Map import patterns and aliases</task>
      <task>Determine state management approach</task>
    </tasks>
    <outputs>
      <output>Project patterns configuration</output>
      <output>Smart defaults for options</output>
      <output>Template selection criteria</output>
    </outputs>
  </phase>
  
  <phase name="2. Parallel Generation" agents="4" duration="5-10s">
    <objective>Generate code, tests, and documentation simultaneously</objective>
    <execution>parallel</execution>
    
    <agent name="frontend-architect">
      <responsibility>UI components and client-side logic</responsibility>
      <generates>
        <file>Component files with TypeScript interfaces</file>
        <file>Style files matching project conventions</file>
        <file>Props validation and hooks usage</file>
        <file>Storybook stories (if requested)</file>
      </generates>
    </agent>
    
    <agent name="backend-engineer">
      <responsibility>API endpoints and server-side services</responsibility>
      <generates>
        <file>Service classes with CRUD operations</file>
        <file>Controllers/routers with RESTful endpoints</file>
        <file>Data models with validation</file>
        <file>Database migrations (if applicable)</file>
      </generates>
    </agent>
    
    <agent name="test-engineer">
      <responsibility>Comprehensive test coverage</responsibility>
      <generates>
        <file>Unit tests with >80% coverage target</file>
        <file>Integration tests</file>
        <file>Test fixtures and mocks</file>
        <file>E2E tests (for features)</file>
      </generates>
    </agent>
    
    <agent name="tech-writer">
      <responsibility>Documentation and examples</responsibility>
      <generates>
        <file>Usage documentation</file>
        <file>API reference</file>
        <file>Code examples</file>
        <file>README updates (if requested)</file>
      </generates>
    </agent>
  </phase>
  
  <phase name="3. Integration & Validation" agents="1" duration="2-3s">
    <objective>Integrate generated code and validate output</objective>
    <agent>project-orchestrator</agent>
    <tasks>
      <task>Merge generated files with proper formatting</task>
      <task>Update index/barrel exports</task>
      <task>Register routes/modules in configuration</task>
      <task>Run linting and formatting (prettier, eslint)</task>
      <task>Execute tests to verify they pass</task>
      <task>Check for naming conflicts</task>
      <task>Generate summary report</task>
    </tasks>
    <validation>
      <check>All tests pass</check>
      <check>No linting errors</check>
      <check>No naming conflicts</check>
      <check>Proper imports/exports</check>
      <check>Files formatted correctly</check>
    </validation>
  </phase>
</execution-flow>

## Framework Support Matrix

<framework-support>
  <frontend>
    <framework name="React" versions="16+, 17, 18">
      <features>
        <feature>Functional components with hooks</feature>
        <feature>TypeScript interfaces</feature>
        <feature>styled-components, CSS modules, Tailwind</feature>
        <feature>React Testing Library + Jest</feature>
        <feature>Storybook integration</feature>
      </features>
      <templates>Component, Hook, Context, Feature, Page</templates>
    </framework>
    
    <framework name="Vue" versions="2.7, 3.x">
      <features>
        <feature>Composition API</feature>
        <feature>TypeScript support</feature>
        <feature>Scoped CSS, CSS modules</feature>
        <feature>Vue Test Utils + Vitest</feature>
        <feature>Vue Storybook</feature>
      </features>
      <templates>Component, Composable, Plugin, Feature, View</templates>
    </framework>
    
    <framework name="Angular" versions="14+, 15, 16, 17, 18">
      <features>
        <feature>Standalone components and signals</feature>
        <feature>TypeScript by default with strict mode</feature>
        <feature>Angular Material, Tailwind CSS, SCSS</feature>
        <feature>Jasmine + Karma, Jest support</feature>
        <feature>Storybook integration</feature>
        <feature>RxJS reactive programming</feature>
        <feature>Dependency injection</feature>
        <feature>Angular CLI integration</feature>
      </features>
      <templates>Component, Service, Module, Directive, Pipe, Guard, Interceptor, Feature</templates>
      <default-config>
        <structure>Feature-based with lazy loading</structure>
        <testing>Karma + Jasmine with TestBed</testing>
        <state>NgRx or Akita for complex state</state>
        <routing>Lazy-loaded feature modules</routing>
      </default-config>
      <best-practices>
        <practice>OnPush change detection strategy</practice>
        <practice>Smart/Presentational component pattern</practice>
        <practice>Reactive forms over template-driven</practice>
        <practice>Strict null checks and type safety</practice>
        <practice>Barrel exports for clean imports</practice>
      </best-practices>
    </framework>
  </frontend>
  
  <backend>
    <framework name="Express.js" versions="4.x">
      <features>
        <feature>RESTful API endpoints</feature>
        <feature>Middleware and validation</feature>
        <feature>JWT authentication</feature>
        <feature>Jest + Supertest</feature>
        <feature>OpenAPI/Swagger docs</feature>
      </features>
      <templates>Router, Service, Model, Middleware, API</templates>
    </framework>
    
    <framework name="FastAPI" versions="0.95+">
      <features>
        <feature>Pydantic models</feature>
        <feature>Automatic OpenAPI docs</feature>
        <feature>Async/await support</feature>
        <feature>Pytest + TestClient</feature>
        <feature>SQLAlchemy integration</feature>
      </features>
      <templates>Router, Service, Model, Dependency, API</templates>
    </framework>
    
    <framework name="Django" versions="4.0, 4.1, 4.2, 5.0">
      <features>
        <feature>Django REST Framework 3.14+</feature>
        <feature>Model serializers with nested relationships</feature>
        <feature>ViewSets with authentication and permissions</feature>
        <feature>Django TestCase and APITestCase</feature>
        <feature>OpenAPI/Swagger documentation</feature>
        <feature>Django ORM with migrations</feature>
        <feature>Class-based and function-based views</feature>
        <feature>Django admin customization</feature>
        <feature>Celery task queue integration</feature>
      </features>
      <templates>Model, Serializer, ViewSet, API, App, Admin, Form, Signal, Task</templates>
      <default-config>
        <structure>Apps with models, views, serializers</structure>
        <testing>Django TestCase with fixtures</testing>
        <authentication>Token or JWT authentication</authentication>
        <database>PostgreSQL with optimized queries</database>
      </default-config>
      <best-practices>
        <practice>Fat models, thin views pattern</practice>
        <practice>Custom managers and querysets</practice>
        <practice>Prefetch and select_related optimization</practice>
        <practice>Signal handlers for decoupled logic</practice>
        <practice>Custom middleware for cross-cutting concerns</practice>
      </best-practices>
      <integration-patterns>
        <pattern>REST API with pagination and filtering</pattern>
        <pattern>GraphQL with Graphene-Django</pattern>
        <pattern>WebSocket support with Django Channels</pattern>
        <pattern>Background tasks with Celery and Redis</pattern>
      </integration-patterns>
    </framework>
  </backend>
</framework-support>

## Examples

<examples>
  <example name="React Component with Tests and Stories">
    <command>/scaffold component UserProfile --framework=react --with-tests --with-stories --style=styled-components --props="name:string,avatar:string,isOnline:boolean"</command>
    <description>Generates a React component with TypeScript props, styled-components styling, comprehensive tests, and Storybook stories</description>
    <generated-files>
      <file>src/components/UserProfile/UserProfile.tsx</file>
      <file>src/components/UserProfile/UserProfile.styled.ts</file>
      <file>src/components/UserProfile/UserProfile.test.tsx</file>
      <file>src/components/UserProfile/UserProfile.stories.tsx</file>
      <file>src/components/UserProfile/index.ts</file>
    </generated-files>
  </example>
  
  <example name="Complete Feature with API">
    <command>/scaffold feature TaskManager --framework=react --with-tests --with-docs</command>
    <description>Creates a complete feature with React components, Express API endpoints, and comprehensive documentation</description>
    <generated-files>
      <file>src/features/TaskManager/TaskManager.tsx</file>
      <file>src/features/TaskManager/TaskList.tsx</file>
      <file>src/features/TaskManager/TaskItem.tsx</file>
      <file>src/api/routes/tasks.js</file>
      <file>src/api/services/taskService.js</file>
      <file>src/api/models/Task.js</file>
      <file>tests/features/TaskManager.test.tsx</file>
      <file>tests/api/tasks.test.js</file>
      <file>docs/features/TaskManager.md</file>
    </generated-files>
  </example>
  
  <example name="FastAPI Service with Models">
    <command>/scaffold api UserService --framework=fastapi --with-tests --with-docs</command>
    <description>Generates FastAPI router with CRUD operations, Pydantic models, and comprehensive tests</description>
    <generated-files>
      <file>app/routers/users.py</file>
      <file>app/models/user.py</file>
      <file>app/schemas/user.py</file>
      <file>app/services/user_service.py</file>
      <file>tests/test_users.py</file>
      <file>docs/api/users.md</file>
    </generated-files>
  </example>
  
  <example name="Vue Component with Composition API">
    <command>/scaffold component ProductCard --framework=vue --with-tests --style=scss --typescript</command>
    <description>Creates Vue 3 component using Composition API with TypeScript and SCSS styling</description>
    <generated-files>
      <file>src/components/ProductCard/ProductCard.vue</file>
      <file>src/components/ProductCard/ProductCard.scss</file>
      <file>src/components/ProductCard/ProductCard.spec.ts</file>
      <file>src/components/ProductCard/index.ts</file>
    </generated-files>
  </example>
  
  <example name="Interactive Mode">
    <command>/scaffold --interactive</command>
    <description>Launches interactive wizard with prompts for all options</description>
    <flow>
      <step>Select scaffold type (component, service, feature, etc.)</step>
      <step>Enter name (auto-suggests based on context)</step>
      <step>Choose framework (auto-detected options shown)</step>
      <step>Configure options (smart defaults pre-selected)</step>
      <step>Preview generation plan</step>
      <step>Confirm and execute</step>
    </flow>
  </example>
  
  <example name="Dry Run Mode">
    <command>/scaffold component Header --dry-run</command>
    <description>Previews what would be generated without creating files</description>
    <output>
      <preview>Files that would be created</preview>
      <preview>Content summaries</preview>
      <preview>Integration changes</preview>
      <preview>Estimated execution time</preview>
    </output>
  </example>
</examples>

## Pattern Detection

<pattern-detection>
  <naming-conventions>
    <detection>
      <pattern>PascalCase components (React, Angular)</pattern>
      <pattern>kebab-case files (Vue, general)</pattern>
      <pattern>camelCase variables and functions</pattern>
      <pattern>SCREAMING_SNAKE_CASE constants</pattern>
    </detection>
    <adaptation>
      <rule>Match existing component naming patterns</rule>
      <rule>Follow directory structure conventions</rule>
      <rule>Preserve import/export patterns</rule>
      <rule>Maintain consistent file extensions</rule>
    </adaptation>
  </naming-conventions>
  
  <project-structure>
    <feature-based>
      <structure>src/features/FeatureName/</structure>
      <generates>Components, services, and tests co-located</generates>
    </feature-based>
    <layer-based>
      <structure>src/components/, src/services/, src/utils/</structure>
      <generates>Separation by technical layer</generates>
    </layer-based>
    <domain-based>
      <structure>src/domains/DomainName/</structure>
      <generates>Business domain groupings</generates>
    </domain-based>
  </project-structure>
  
  <framework-detection>
    <indicators>
      <react>package.json contains react, .jsx/.tsx files present</react>
      <vue>package.json contains vue, .vue files present</vue>
      <angular>angular.json present, @angular packages</angular>
      <express>package.json contains express, app.js/server.js</express>
      <fastapi>requirements.txt contains fastapi, main.py present</fastapi>
    </indicators>
    <version-detection>
      <method>Parse package.json or requirements.txt versions</method>
      <fallback>Analyze import patterns and syntax usage</fallback>
    </version-detection>
  </framework-detection>
</pattern-detection>

## Agent Orchestration Strategy

<orchestration>
  <coordination>
    <pattern>Sequential analysis followed by parallel generation</pattern>
    <communication>Shared context object with project patterns</communication>
    <synchronization>Wait for all parallel agents before integration</synchronization>
    <error-handling>Graceful degradation on agent failures</error-handling>
  </coordination>
  
  <context-sharing>
    <shared-data>
      <item>Project patterns and conventions</item>
      <item>Framework configuration</item>
      <item>Naming conventions</item>
      <item>Testing setup</item>
      <item>Styling approach</item>
      <item>Import/export patterns</item>
    </shared-data>
    <agent-specific>
      <frontend>UI patterns, component structure, styling rules</frontend>
      <backend>API conventions, service patterns, data models</backend>
      <testing>Test framework, coverage requirements, mock patterns</testing>
      <docs>Documentation format, example patterns, API schemas</docs>
    </agent-specific>
  </context-sharing>
  
  <failure-recovery>
    <retry-logic>3 attempts with exponential backoff</retry-logic>
    <fallback-agents>Deploy alternative agents on primary failures</fallback-agents>
    <partial-success>Continue with available outputs, report missing pieces</partial-success>
    <rollback>Undo partial changes on integration failures</rollback>
  </failure-recovery>
</orchestration>

## Smart Defaults

<smart-defaults>
  <auto-detection>
    <tests>Enable if jest.config, pytest.ini, or test directories exist</tests>
    <stories>Enable if .storybook directory exists</stories>
    <typescript>Enable if tsconfig.json exists</typescript>
    <styling>Detect from webpack.config, package.json dependencies</styling>
    <framework>Analyze package.json, config files, directory structure</framework>
  </auto-detection>
  
  <intelligent-suggestions>
    <context-aware>
      <suggestion condition="React 18 + TypeScript + styled-components">
        Suggested: --with-tests --style=styled-components --typescript
      </suggestion>
      <suggestion condition="Vue 3 + Vite + TypeScript">
        Suggested: --with-tests --framework=vue --typescript
      </suggestion>
      <suggestion condition="FastAPI + SQLAlchemy + Pytest">
        Suggested: --with-tests --with-docs --framework=fastapi
      </suggestion>
    </context-aware>
  </intelligent-suggestions>
  
  <convention-matching>
    <naming>Convert input names to match existing conventions</naming>
    <structure>Place files following existing directory patterns</structure>
    <imports>Use existing import aliases and patterns</imports>
    <exports>Follow existing barrel export conventions</exports>
  </convention-matching>
</smart-defaults>

## Success Metrics

<metrics>
  <performance>
    <target name="Component Generation" value="<5 seconds" />
    <target name="Feature Generation" value="<30 seconds" />
    <target name="Full Project Setup" value="<60 seconds" />
  </performance>
  
  <quality>
    <target name="Generated Code Quality" value="100% linting compliance" />
    <target name="Test Coverage" value=">80% for generated tests" />
    <target name="Pattern Adherence" value="95% convention matching" />
  </quality>
  
  <adoption>
    <target name="Usage Rate" value=">80% of new components use scaffold" />
    <target name="Success Rate" value="95% of generations complete without errors" />
    <target name="User Satisfaction" value=">90% positive feedback" />
  </adoption>
</metrics>

## Error Handling

<error-handling>
  <validation-errors>
    <invalid-names>Provide suggestions for valid naming patterns</invalid-names>
    <unsupported-framework>List supported frameworks and versions</unsupported-framework>
    <missing-dependencies>Guide installation of required packages</missing-dependencies>
    <naming-conflicts>Suggest alternative names or show conflicts</naming-conflicts>
  </validation-errors>
  
  <generation-errors>
    <template-errors>Fallback to basic templates, report template issues</template-errors>
    <agent-failures>Retry with alternative agents, provide partial results</agent-failures>
    <integration-failures>Rollback changes, provide detailed error reports</integration-failures>
    <test-failures>Generate code without tests, report test issues</test-failures>
  </generation-errors>
  
  <recovery-strategies>
    <partial-success>Complete successful parts, report failed components</partial-success>
    <manual-fallback>Provide manual steps for failed automated tasks</manual-fallback>
    <rollback>Clean up partial changes on critical failures</rollback>
    <debugging>Verbose mode for troubleshooting generation issues</debugging>
  </recovery-strategies>
</error-handling>

## Integration Points

<integration>
  <git-workflow>
    <staging>Auto-stage generated files for review</staging>
    <ignore>Respect .gitignore patterns</ignore>
    <commits>Generate descriptive commit messages</commits>
    <branches>Support feature branch workflows</branches>
  </git-workflow>
  
  <ide-support>
    <file-watchers>Trigger IDE refresh after generation</file-watchers>
    <formatting>Apply IDE formatting rules</formatting>
    <imports>Organize imports using IDE settings</imports>
    <linting>Apply IDE linting configuration</linting>
  </ide-support>
  
  <ci-cd>
    <compatibility>Generated code works with existing CI/CD</compatibility>
    <testing>New tests integrate with test suites</testing>
    <building>Code builds without manual intervention</building>
    <deployment>Follows existing deployment patterns</deployment>
  </ci-cd>
</integration>