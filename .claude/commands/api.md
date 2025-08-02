# /api Command

## Description
Quickly access expert API architecture through Claude orchestration for enterprise-scale API ecosystems. Claude coordinates with the api-architect who specializes in designing APIs handling 100K+ RPS with sub-50ms response times, implementing comprehensive API governance across 50+ microservices, and building contract-first development workflows supporting teams of 100+ developers.

## Behavior
This command coordinates with the api-architect to architect and implement mission-critical API ecosystems including multi-version API management, advanced rate limiting with quota enforcement, comprehensive security policies (OAuth2, mTLS, JWT validation), and observability frameworks providing detailed SLI/SLO tracking across service meshes.

## Usage
```
/api [specific API architecture requirement]
```

## Real-World Use Cases

### High-Performance API Design
- `/api design GraphQL federation schema aggregating 20+ microservices with <100ms resolution`
- `/api implement RESTful API with cursor-based pagination supporting 1M+ record sets`
- `/api build real-time API using Server-Sent Events with connection pooling for 50K+ clients`
- `/api optimize API gateway routing 100K RPS across 200+ backend services with circuit breakers`

### Enterprise API Governance
- `/api create OpenAPI 3.1 specification with shared schemas and automated code generation`
- `/api design API versioning strategy supporting 5+ concurrent versions with sunset policies`
- `/api implement API monetization platform with usage-based billing and tier management`
- `/api build contract testing framework ensuring backward compatibility across 100+ consumer apps`

### Advanced Integration Patterns
- `/api design event-driven API architecture with async processing and webhook delivery`
- `/api implement API composition layer aggregating data from 10+ heterogeneous systems`
- `/api build multi-tenant API with data isolation and customizable rate limits per tenant`
- `/api create FHIR-compliant healthcare API with audit logging and PHI encryption`

## Expert Capabilities

### API Design Mastery
- **RESTful Architecture**: HATEOAS implementation, resource modeling, HTTP semantics optimization
- **GraphQL Expertise**: Schema federation, N+1 query prevention, subscription management
- **AsyncAPI Specifications**: Event-driven API documentation, message schema validation
- **gRPC Services**: Protocol buffer optimization, streaming, load balancing strategies

### API Gateway & Infrastructure
- **Kong/Istio Configuration**: Advanced routing, canary deployments, traffic splitting
- **Rate Limiting**: Token bucket, sliding window, distributed quota enforcement
- **Load Balancing**: Weighted routing, health checks, fail-over strategies
- **Caching**: Multi-layer caching with TTL policies, cache invalidation patterns

### Security & Compliance
- **OAuth2/OIDC**: Multi-tenant authorization, scope management, token introspection
- **API Security**: JWT validation, certificate pinning, CORS policies, input sanitization
- **Compliance**: GDPR data portability, HIPAA audit trails, PCI-DSS tokenization
- **Threat Protection**: DDoS mitigation, bot detection, API abuse prevention

### Developer Experience & Governance
- **OpenAPI Toolchain**: Code generation, mock servers, automated testing integration
- **API Documentation**: Interactive docs, SDK generation, changelog automation
- **Contract Testing**: Consumer-driven contracts, schema evolution validation
- **Analytics**: Usage metrics, performance monitoring, developer adoption tracking

## Performance Benchmarks
- **Response Time**: p95 <100ms for CRUD operations, <50ms for cached responses
- **Throughput**: 100K+ RPS sustained with horizontal scaling and connection pooling
- **Availability**: 99.99% uptime with multi-region failover and circuit breakers
- **Error Rates**: <0.1% 5xx errors with comprehensive error handling and retry logic

## Technology Stack Expertise

### API Frameworks & Libraries
- **Node.js**: Express.js with helmet, compression, and async middleware optimization
- **Python**: FastAPI with Pydantic validation, async/await, automatic OpenAPI generation
- **Go**: Gin/Echo with middleware chaining, context handling, graceful shutdowns  
- **Java/Kotlin**: Spring Boot WebFlux, reactive streams, non-blocking I/O

### API Gateway Solutions
- **Kong Gateway**: Plugin ecosystem, service mesh integration, enterprise features
- **AWS API Gateway**: Lambda integration, custom authorizers, usage plans
- **Istio**: Service mesh ingress, traffic management, security policies
- **Traefik**: Dynamic configuration, Let's Encrypt automation, load balancing

### Documentation & Tooling
- **OpenAPI Ecosystem**: Swagger UI, Redoc, Prism mock servers, OpenAPI Generator
- **GraphQL Tooling**: Apollo Federation, GraphQL Playground, schema stitching
- **Testing Frameworks**: Postman automation, Newman CI/CD, contract testing
- **Monitoring**: API analytics, distributed tracing, custom metrics collection

### Security & Authentication
- **Identity Providers**: Auth0, Okta, Azure AD integration with SAML/OIDC
- **API Security Tools**: OWASP ZAP, Burp Suite Professional, security headers
- **Certificate Management**: Let's Encrypt automation, mTLS configuration
- **Secrets Management**: HashiCorp Vault, AWS Secrets Manager integration

## Anti-Patterns Avoided
- **Chatty APIs**: Efficient data fetching with field selection and batching
- **Version Sprawl**: Semantic versioning with clear deprecation timelines
- **Security Afterthoughts**: Security-first design with threat modeling
- **Poor Error Handling**: Consistent error formats with actionable error messages
- **Lack of Observability**: Comprehensive logging, metrics, and distributed tracing

## When to Engage

### Complexity Triggers
- API ecosystems supporting >10K developer integrations
- Multi-version API management across >20 concurrent versions  
- Real-time APIs requiring <100ms latency with high concurrency
- Enterprise integrations requiring complex authentication/authorization
- Regulatory compliance (FHIR, PSD2, Open Banking) implementation

### Scale Indicators
- API traffic exceeding 1M requests/day requiring optimization
- Multi-tenant architectures with tenant-specific customizations
- Event-driven architectures processing >100K events/hour
- Global API deployment across 3+ regions with consistency requirements
- Developer ecosystems with >50 consuming applications

## Related Commands
- `/backend` - For API implementation and microservices architecture
- `/security` - For comprehensive API security audits and compliance
- `/docs` - For API documentation, SDK generation, and developer portals
- `/architect` - For API strategy and enterprise architecture decisions
