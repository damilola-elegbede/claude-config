# Common Tasks Tutorial: Step-by-Step Guide

## Overview

This tutorial provides step-by-step instructions for the most common development tasks using the Claude Configuration Framework. Each tutorial includes agent selection, coordination patterns, and expected outcomes to help you achieve optimal results.

## Getting Started: Prerequisites

### Framework Setup Verification

Before starting any tutorials, ensure your framework is properly configured:

```bash
# Verify Claude Code CLI installation
claude-code --version

# Check framework synchronization
/sync

# Validate agent ecosystem health
/agent-audit

# Confirm all 28 agents are available
ls ~/.claude/agents/ | wc -l  # Should show 28 agents
```

### Tutorial Navigation

Each tutorial follows this structure:

1. **Objective**: Clear goal definition
2. **Agent Selection**: Which specialists to use
3. **Step-by-Step Process**: Detailed execution guide
4. **Expected Outcomes**: What success looks like
5. **Troubleshooting**: Common issues and solutions

---

## Tutorial 1: Building a React Component Library

### Objective

Create a production-ready React component library with TypeScript, testing, and documentation.

### Agent Selection

- **Primary**: `frontend-engineer` (implementation)
- **Supporting**: `ui-designer` (design system), `test-engineer` (testing strategy)
- **Quality**: `code-reviewer` (code quality), `accessibility-auditor` (compliance)

### Step-by-Step Process

#### Step 1: Design System Foundation (Wave 1)

```bash
# Deploy ui-designer for design system creation
claude-code

Task for ui-designer:
"Create a comprehensive design system specification for a React component library including:
- Design tokens (colors, typography, spacing, shadows)
- Component specifications (Button, Input, Card, Modal)
- Responsive breakpoint strategy
- Accessibility color contrast requirements"
```

**Expected Output from ui-designer:**
- Design token definitions in JSON/CSS custom properties format
- Component visual specifications with all states (default, hover, active, disabled)
- Responsive behavior guidelines
- Accessibility requirements and ARIA patterns

#### Step 2: Component Architecture (Wave 1 - Parallel)

```bash
# Deploy frontend-architect for technical foundation
Task for frontend-architect:
"Design the technical architecture for a React component library including:
- Project structure and build configuration
- TypeScript setup with strict type checking
- Component composition patterns and prop APIs
- Bundle optimization and tree-shaking strategy"
```

**Expected Output from frontend-architect:**
- Project structure with clear separation of concerns
- TypeScript configuration with comprehensive type safety
- Component API design patterns for consistency
- Build configuration for optimal bundle size

#### Step 3: Core Implementation (Wave 2)

```bash
# Deploy frontend-engineer for implementation
Task for frontend-engineer:
"Implement React component library based on design system specifications:
- Setup development environment with Vite/Webpack
- Implement design tokens as CSS custom properties
- Create foundational components (Button, Input, Card)
- Add TypeScript types and comprehensive prop interfaces
- Setup Storybook for component documentation"
```

**Implementation Checklist:**
- [ ] Development environment setup complete
- [ ] Design tokens implemented and accessible
- [ ] Core components with all visual states
- [ ] TypeScript interfaces for all props
- [ ] Storybook stories for each component

#### Step 4: Testing Strategy (Wave 2 - Parallel)

```bash
# Deploy test-engineer for comprehensive testing
Task for test-engineer:
"Create comprehensive testing strategy for React component library:
- Unit tests for component logic and rendering
- Accessibility testing with @testing-library/jest-dom
- Visual regression testing setup
- Integration testing for component interactions"
```

**Testing Deliverables:**
- Jest configuration with React Testing Library
- Unit tests achieving 90%+ coverage
- Accessibility tests for WCAG compliance
- Visual regression testing with Chromatic or Percy

#### Step 5: Quality Validation (Wave 3)

```bash
# Deploy multiple quality agents in parallel

# Code quality review
Task for code-reviewer:
"Review React component library implementation for:
- Code quality and best practices
- TypeScript usage and type safety
- Performance optimization opportunities
- Documentation completeness"

# Accessibility compliance
Task for accessibility-auditor:
"Validate component library accessibility:
- WCAG 2.1 AA compliance
- Keyboard navigation support
- Screen reader compatibility
- Color contrast validation"
```

### Expected Final Outcomes

#### Deliverables Checklist

- [ ] **Component Library**: 5-10 production-ready React components
- [ ] **Design System**: Comprehensive design tokens and specifications
- [ ] **Documentation**: Storybook with component examples and guidelines
- [ ] **Testing**: 90%+ test coverage with accessibility validation
- [ ] **Build System**: Optimized build with tree-shaking and TypeScript support
- [ ] **Quality Gates**: ESLint, Prettier, and accessibility linting configured

#### Performance Metrics

- **Development Time**: 2-3 hours (vs 8-10 hours traditional approach)
- **Quality Score**: 95%+ across all quality dimensions
- **Accessibility**: 100% WCAG 2.1 AA compliance
- **Bundle Size**: <50KB gzipped for core components

### Troubleshooting Common Issues

#### Issue: Design-Implementation Mismatch

```yaml
Symptoms:
  - Components don't match design specifications
  - Inconsistent spacing or colors
  - Missing interactive states

Solution:
  1. Re-run ui-designer with specific component requirements
  2. frontend-engineer implements exact specifications
  3. Regular design review checkpoints during implementation
```

#### Issue: Testing Failures

```yaml
Symptoms:
  - Low test coverage
  - Accessibility test failures
  - TypeScript compilation errors

Solution:
  1. test-engineer creates comprehensive testing strategy
  2. accessibility-auditor validates WCAG compliance
  3. code-reviewer ensures TypeScript best practices
```

---

## Tutorial 2: Building a REST API with Authentication

### Objective

Create a secure REST API with user authentication, authorization, and comprehensive testing.

### Agent Selection

- **Primary**: `backend-engineer` (API implementation)
- **Supporting**: `api-architect` (API design), `security-auditor` (security)
- **Quality**: `test-engineer` (API testing), `database-admin` (data layer)

### Step-by-Step Process

#### Step 1: API Architecture Design (Wave 1)

```bash
# Deploy api-architect for API design
Task for api-architect:
"Design REST API architecture for user management system:
- OpenAPI 3.0 specification with all endpoints
- Authentication flow (JWT tokens, refresh tokens)
- Authorization patterns (RBAC, resource-based permissions)
- Error handling and status code conventions
- Rate limiting and security headers strategy"
```

**Expected Output:**
- Complete OpenAPI specification
- Authentication and authorization flow diagrams
- Error response standardization
- Security requirements documentation

#### Step 2: Security Framework (Wave 1 - Parallel)

```bash
# Deploy security-auditor for security planning
Task for security-auditor:
"Define comprehensive security framework for REST API:
- Authentication security (password hashing, token management)
- Authorization patterns and access control
- Input validation and sanitization requirements
- SQL injection and XSS prevention strategies
- OWASP compliance checklist"
```

**Security Deliverables:**
- Security requirements specification
- Threat model and mitigation strategies
- Input validation rules and patterns
- Security testing requirements

#### Step 3: Database Design (Wave 1 - Parallel)

```bash
# Deploy database-admin for data layer
Task for database-admin:
"Design database schema for user management API:
- User table with secure password storage
- Role and permission tables for RBAC
- Session and token management tables
- Database indexing strategy for performance
- Migration scripts for schema deployment"
```

**Database Outputs:**
- Complete database schema with relationships
- Migration scripts for all tables
- Indexing strategy for query optimization
- Backup and recovery procedures

#### Step 4: API Implementation (Wave 2)

```bash
# Deploy backend-engineer for implementation
Task for backend-engineer:
"Implement REST API based on architecture specifications:
- Express.js/FastAPI setup with middleware configuration
- User authentication endpoints (register, login, logout, refresh)
- Protected routes with JWT middleware
- Input validation with Joi/Zod schemas
- Error handling middleware with proper status codes
- API documentation with Swagger/ReDoc"
```

**Implementation Checklist:**
- [ ] Server setup with proper middleware stack
- [ ] Authentication endpoints with secure password handling
- [ ] JWT token generation and validation
- [ ] Protected routes with authorization checks
- [ ] Input validation for all endpoints
- [ ] Comprehensive error handling

#### Step 5: Testing Implementation (Wave 2 - Parallel)

```bash
# Deploy test-engineer for API testing
Task for test-engineer:
"Create comprehensive API testing suite:
- Unit tests for business logic and utilities
- Integration tests for API endpoints
- Authentication flow testing (login, logout, token refresh)
- Authorization testing (access control validation)
- Load testing for performance validation"
```

**Testing Framework:**
- Jest/Mocha unit tests with 90%+ coverage
- Supertest/Postman integration tests
- Authentication and authorization test scenarios
- Performance testing with Artillery/k6

#### Step 6: Security Validation (Wave 3)

```bash
# Deploy security-auditor for security testing
Task for security-auditor:
"Perform comprehensive security testing of REST API:
- Penetration testing for common vulnerabilities
- Authentication bypass attempt testing
- SQL injection and NoSQL injection testing
- XSS and CSRF vulnerability assessment
- Rate limiting and DOS protection validation"
```

### Expected Final Outcomes

#### API Deliverables

- [ ] **REST API**: Complete user management API with authentication
- [ ] **Documentation**: Interactive API documentation with Swagger
- [ ] **Security**: OWASP-compliant security implementation
- [ ] **Testing**: Comprehensive test suite with 90%+ coverage
- [ ] **Database**: Optimized schema with proper indexing
- [ ] **Deployment**: Production-ready configuration with monitoring

#### Security Compliance

- [ ] **Authentication**: Secure JWT implementation with refresh tokens
- [ ] **Authorization**: Role-based access control (RBAC)
- [ ] **Input Validation**: All inputs validated and sanitized
- [ ] **Rate Limiting**: API rate limiting and abuse prevention
- [ ] **Security Headers**: Proper security headers and CORS configuration

### Troubleshooting

#### Issue: Authentication Failures

```yaml
Symptoms:
  - JWT token validation errors
  - Session management issues
  - Password hashing problems

Solution:
  1. security-auditor reviews authentication implementation
  2. backend-engineer fixes security vulnerabilities
  3. test-engineer validates authentication flows
```

---

## Tutorial 3: Creating a Full-Stack Web Application

### Objective

Build a complete web application with React frontend, Node.js backend, and PostgreSQL database.

### Agent Selection

- **Architecture**: `principal-architect` (system design)
- **Backend**: `backend-engineer` (API), `database-admin` (data layer)
- **Frontend**: `frontend-engineer` (UI), `ui-designer` (design)
- **Quality**: `test-engineer` (testing), `devops` (deployment)

### Step-by-Step Process

#### Step 1: System Architecture (Wave 1)

```bash
# Deploy principal-architect for overall system design
Task for principal-architect:
"Design full-stack web application architecture:
- Technology stack selection (React, Node.js, PostgreSQL)
- System component interaction diagrams
- Data flow architecture and API design patterns
- Deployment architecture with CI/CD pipeline
- Scalability and performance considerations"
```

**Architecture Deliverables:**
- System architecture diagram
- Technology stack justification
- Component interaction specifications
- Deployment and infrastructure plan

#### Step 2: Database and API Design (Wave 1 - Parallel)

```bash
# Deploy database-admin for data architecture
Task for database-admin:
"Design PostgreSQL database for web application:
- Entity relationship diagram with all tables
- Database schema with proper normalization
- Indexing strategy for query performance
- Data migration and seeding strategies"

# Deploy api-architect for API design
Task for api-architect:
"Design REST API specification:
- OpenAPI 3.0 specification for all endpoints
- Request/response schemas with validation
- Authentication and authorization patterns
- Error handling and status code conventions"
```

#### Step 3: UI/UX Design (Wave 1 - Parallel)

```bash
# Deploy ui-designer for interface design
Task for ui-designer:
"Create comprehensive UI design for web application:
- Design system with components and design tokens
- Wireframes and mockups for all major pages
- Responsive design strategy for mobile and desktop
- User interaction patterns and micro-animations"

# Deploy ux-researcher for user experience
Task for ux-researcher:
"Conduct UX research and validation:
- User persona development and journey mapping
- Accessibility requirements and compliance strategy
- Usability testing plan and success metrics"
```

#### Step 4: Backend Implementation (Wave 2)

```bash
# Deploy backend-engineer for API development
Task for backend-engineer:
"Implement Node.js backend API:
- Express.js server with middleware configuration
- Database integration with PostgreSQL and Prisma/TypeORM
- Authentication and authorization implementation
- API endpoints following OpenAPI specification
- Error handling and logging middleware"
```

**Backend Implementation Checklist:**
- [ ] Express.js server with proper middleware
- [ ] Database connection and ORM setup
- [ ] Authentication system with JWT tokens
- [ ] All API endpoints implemented
- [ ] Input validation and error handling
- [ ] Logging and monitoring setup

#### Step 5: Frontend Implementation (Wave 2 - Parallel)

```bash
# Deploy frontend-engineer for React development
Task for frontend-engineer:
"Implement React frontend application:
- React application setup with TypeScript
- Component library implementation from design system
- State management with Redux/Zustand
- API integration with React Query/SWR
- Routing with React Router
- Form handling and validation"
```

**Frontend Implementation Checklist:**
- [ ] React application with TypeScript setup
- [ ] Component library matching design system
- [ ] State management implementation
- [ ] API integration with proper error handling
- [ ] Routing and navigation
- [ ] Form validation and user feedback

#### Step 6: Integration and Testing (Wave 3)

```bash
# Deploy test-engineer for comprehensive testing
Task for test-engineer:
"Create full-stack testing strategy:
- Backend API testing with comprehensive coverage
- Frontend component and integration testing
- End-to-end testing with Cypress/Playwright
- Performance testing and optimization validation"

# Deploy performance-engineer for optimization
Task for performance-engineer:
"Optimize application performance:
- Frontend bundle optimization and code splitting
- Backend API performance tuning
- Database query optimization
- Caching strategy implementation"
```

#### Step 7: Deployment and DevOps (Wave 3 - Parallel)

```bash
# Deploy devops for CI/CD and deployment
Task for devops:
"Setup production deployment infrastructure:
- CI/CD pipeline with GitHub Actions/GitLab CI
- Docker containerization for backend and frontend
- Production environment setup with proper configuration
- Monitoring and logging infrastructure
- Backup and disaster recovery procedures"
```

### Expected Final Outcomes

#### Complete Application Stack

- [ ] **Frontend**: React application with responsive design
- [ ] **Backend**: Node.js API with authentication and business logic
- [ ] **Database**: PostgreSQL with optimized schema and data
- [ ] **Testing**: Comprehensive test suite across all layers
- [ ] **Deployment**: Production-ready CI/CD pipeline
- [ ] **Monitoring**: Application monitoring and error tracking

#### Performance Metrics

- **Development Time**: 4-6 hours (vs 15-20 hours traditional)
- **Performance**: Lighthouse scores 90+ across all metrics
- **Test Coverage**: 85%+ across frontend and backend
- **Security**: OWASP compliance with security audit
- **Accessibility**: WCAG 2.1 AA compliance

---

## Tutorial 4: Mobile App Development with React Native

### Objective

Create a cross-platform mobile application with React Native, including native features and backend integration.

### Agent Selection

- **Mobile**: `mobile-engineer` (React Native development)
- **Backend**: `backend-engineer` (mobile-optimized API)
- **Design**: `ui-designer` (mobile design system)
- **Quality**: `test-engineer` (mobile testing)

### Step-by-Step Process

#### Step 1: Mobile Architecture and Design (Wave 1)

```bash
# Deploy mobile-engineer for architecture
Task for mobile-engineer:
"Design React Native application architecture:
- React Native setup with TypeScript configuration
- Navigation structure with React Navigation
- State management strategy (Redux/Zustand)
- Native module integration planning
- Platform-specific optimization strategies"

# Deploy ui-designer for mobile design
Task for ui-designer:
"Create mobile-first design system:
- Mobile component library (iOS and Android)
- Platform-specific design patterns and guidelines
- Responsive design for various screen sizes
- Touch interaction patterns and gestures"
```

#### Step 2: Backend API for Mobile (Wave 1 - Parallel)

```bash
# Deploy backend-engineer for mobile-optimized API
Task for backend-engineer:
"Create mobile-optimized backend API:
- RESTful API with mobile-specific endpoints
- Authentication with JWT and refresh tokens
- Push notification service integration
- File upload handling for images and media
- Offline sync capabilities with conflict resolution"
```

#### Step 3: React Native Implementation (Wave 2)

```bash
# Deploy mobile-engineer for implementation
Task for mobile-engineer:
"Implement React Native mobile application:
- App navigation and screen structure
- Component library implementation from designs
- API integration with error handling and retry logic
- Native feature integration (camera, notifications, storage)
- Platform-specific optimizations for iOS and Android"
```

**Mobile Implementation Checklist:**
- [ ] React Native project setup with TypeScript
- [ ] Navigation structure with stack and tab navigators
- [ ] Component library matching mobile design system
- [ ] API integration with proper offline handling
- [ ] Native feature integration (camera, push notifications)
- [ ] Platform-specific UI adaptations

#### Step 4: Testing and Optimization (Wave 3)

```bash
# Deploy test-engineer for mobile testing
Task for test-engineer:
"Create mobile testing strategy:
- Unit tests for business logic and components
- Integration tests for API communication
- End-to-end testing with Detox
- Performance testing and memory optimization
- Device testing across iOS and Android platforms"
```

### Expected Final Outcomes

#### Mobile Application Deliverables

- [ ] **React Native App**: Cross-platform mobile application
- [ ] **Native Features**: Camera, push notifications, local storage
- [ ] **API Integration**: Robust API communication with offline support
- [ ] **Testing**: Comprehensive mobile testing suite
- [ ] **Performance**: Optimized for mobile performance and battery life
- [ ] **App Store Ready**: Built and configured for iOS and Android deployment

---

## Tutorial 5: API Documentation and Developer Experience

### Objective

Create comprehensive API documentation with interactive examples and developer onboarding materials.

### Agent Selection

- **Documentation**: `tech-writer` (comprehensive docs)
- **API**: `api-architect` (specification review)
- **Development**: `backend-engineer` (example implementation)

### Step-by-Step Process

#### Step 1: API Documentation Strategy (Wave 1)

```bash
# Deploy tech-writer for documentation planning
Task for tech-writer:
"Create comprehensive API documentation strategy:
- Documentation structure and content organization
- Interactive API documentation with code examples
- Developer onboarding guides and tutorials
- API reference documentation with all endpoints
- SDK documentation and integration guides"
```

#### Step 2: Interactive Documentation (Wave 2)

```bash
# Deploy tech-writer for implementation
Task for tech-writer:
"Implement interactive API documentation:
- OpenAPI specification integration with Swagger/ReDoc
- Code examples in multiple programming languages
- Authentication flow documentation with examples
- Error handling documentation with troubleshooting guides
- SDK installation and usage documentation"
```

### Expected Final Outcomes

- [ ] **Interactive Docs**: Swagger/ReDoc documentation with try-it functionality
- [ ] **Developer Guides**: Step-by-step integration tutorials
- [ ] **Code Examples**: Multi-language code samples
- [ ] **Troubleshooting**: Comprehensive error handling guides

---

## Quick Reference: Agent Selection Guide

### By Task Type

| Task Category | Primary Agent | Supporting Agents | Quality Agents |
|---------------|---------------|-------------------|----------------|
| **Frontend Development** | frontend-engineer | ui-designer, frontend-architect | accessibility-auditor, code-reviewer |
| **Backend Development** | backend-engineer | api-architect, database-admin | security-auditor, test-engineer |
| **Mobile Development** | mobile-engineer | ui-designer, backend-engineer | test-engineer, performance-engineer |
| **API Design** | api-architect | backend-engineer, security-auditor | test-engineer, tech-writer |
| **Database Work** | database-admin | backend-engineer, security-auditor | performance-engineer, code-reviewer |
| **Testing** | test-engineer | Any implementation agent | accessibility-auditor, security-auditor |
| **Documentation** | tech-writer | Any subject matter expert | code-reviewer, ux-researcher |
| **DevOps/Deployment** | devops | platform-engineer, security-auditor | test-engineer, incident-commander |

### Performance Expectations

| Project Complexity | Agent Count | Time Reduction | Quality Improvement |
|-------------------|-------------|----------------|-------------------|
| **Simple** (1-2 components) | 2-3 agents | 3-4x faster | 85%+ quality score |
| **Medium** (Full feature) | 4-6 agents | 4-5x faster | 90%+ quality score |
| **Complex** (Full application) | 6-10 agents | 5-6x faster | 95%+ quality score |

---

*This tutorial guide provides practical, step-by-step instructions for common development tasks. Each tutorial is designed to be completed in 1-6 hours depending on complexity, with clear success criteria and troubleshooting guidance.*