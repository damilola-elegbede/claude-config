# /backend Command

## Description
Quickly access expert backend engineering through Claude orchestration for production-scale server-side systems. Claude coordinates with the backend-engineer specialist who specializes in high-throughput APIs, distributed systems, and enterprise-grade infrastructure handling 100K+ RPS with sub-100ms latency requirements.

## Behavior
This command coordinates with the backend-engineer specialist to architect and implement mission-critical backend systems including microservices handling distributed transactions, event-driven architectures with message queues, and database systems optimized for concurrent access patterns exceeding 10K QPS.

## Usage
```
/backend [specific technical requirement]
```

## Real-World Use Cases

### High-Performance Systems
- `/backend design microservices handling 50K RPS with circuit breakers and bulkhead patterns`
- `/backend implement event sourcing with Kafka for financial transactions`
- `/backend optimize PostgreSQL for 100K concurrent connections with connection pooling`
- `/backend build distributed cache layer with Redis Cluster for sub-10ms response times`

### Distributed Architecture
- `/backend implement SAGA pattern for distributed transactions across payment/inventory/shipping services`
- `/backend design API gateway with rate limiting (1000 RPS per user) and JWT validation`
- `/backend build event-driven architecture with dead letter queues and retry policies`
- `/backend implement CQRS with separate read/write databases for order management`

### Performance Engineering
- `/backend profile and optimize Go service from 200ms to <50ms p99 latency`
- `/backend implement database sharding strategy for 10TB user data across regions`
- `/backend design connection pooling for microservices handling 500 concurrent requests`
- `/backend optimize JVM heap settings for Spring Boot service processing 1M events/hour`

## Expert Capabilities

### Distributed Systems Mastery
- **Consensus Algorithms**: Raft, PBFT implementation for distributed state management
- **CAP Theorem Application**: Designing systems choosing consistency vs availability trade-offs
- **Distributed Transactions**: Two-phase commit, SAGA patterns, eventual consistency models
- **Service Mesh**: Istio/Linkerd configuration for traffic management and observability

### High-Performance Database Engineering
- **Query Optimization**: Index strategies reducing query time from seconds to <10ms
- **Horizontal Scaling**: Database sharding across 50+ nodes with consistent hashing
- **Replication Strategies**: Master-slave, master-master setups with conflict resolution
- **Connection Management**: Pooling strategies for 10K+ concurrent database connections

### Message Queue Architecture
- **Kafka Expertise**: Multi-region clusters processing 1M+ messages/second with exactly-once semantics
- **RabbitMQ Patterns**: Work queues, pub/sub, RPC patterns with guaranteed delivery
- **Redis Pub/Sub**: Real-time data distribution with sub-millisecond latency
- **Event Streaming**: Schema evolution, compaction strategies, consumer group management

### Security Implementation
- **OAuth2/OIDC**: Multi-tenant authentication with custom claim validation
- **API Security**: Rate limiting (token bucket), CORS policies, input sanitization
- **Encryption**: AES-256 at rest, TLS 1.3 in transit, key rotation strategies
- **Threat Modeling**: STRIDE methodology for distributed system vulnerabilities

## Performance Benchmarks
- **API Latency**: p50 <20ms, p99 <100ms for database-backed endpoints
- **Throughput**: 100K+ RPS sustained with auto-scaling Kubernetes deployments
- **Database Performance**: <5ms query response for 99% of operations on indexed data
- **Message Processing**: 1M+ events/second with <100ms end-to-end latency

## Technology Stack Expertise

### Languages & Frameworks
- **Go**: Gin, Echo, gRPC with context cancellation and graceful shutdowns
- **Java**: Spring Boot with WebFlux, Hibernate optimizations, JVM tuning
- **Python**: FastAPI with async/await, SQLAlchemy with connection pooling
- **Node.js**: Express.js with clustering, event loop optimization
- **Rust**: Actix-web, Tokio async runtime for zero-cost abstractions

### Database Technologies
- **PostgreSQL**: Advanced indexing (GIN, GiST), partitioning, streaming replication
- **MongoDB**: Aggregation pipelines, sharding across replica sets
- **Redis**: Cluster mode, Lua scripting, memory optimization techniques
- **Cassandra**: Wide column design, eventual consistency, multi-datacenter replication

### Infrastructure & DevOps
- **Kubernetes**: HPA/VPA, service mesh integration, custom operators
- **Docker**: Multi-stage builds, distroless images, security scanning
- **Monitoring**: Prometheus metrics, Jaeger tracing, structured logging
- **CI/CD**: GitLab CI with automated testing, canary deployments

## Anti-Patterns Avoided
- **Database N+1 Queries**: Implementing eager loading and batch operations
- **Synchronous Service Calls**: Async patterns with timeout and retry logic  
- **Shared Database Antipattern**: Database-per-service with event-driven sync
- **Missing Circuit Breakers**: Hystrix/resilience4j for fault tolerance
- **Inadequate Monitoring**: Missing SLI/SLO definitions and alerting

## When to Engage

### Complexity Triggers
- Systems requiring >10K RPS sustained throughput
- Sub-100ms latency requirements for user-facing APIs
- Multi-region deployment with data consistency requirements
- Event-driven architectures with >1M events/day processing
- Microservices coordination across 5+ independent services

### Scale Indicators
- Database queries against >100GB datasets
- Message queues processing >100K messages/hour
- Concurrent user sessions >50K active connections
- Integration with 3+ external services requiring fault tolerance
- Transaction volumes requiring distributed commit protocols

## Related Commands
- `/api` - For contract-first API design and OpenAPI specifications
- `/data` - For ETL pipelines and data warehouse integration
- `/perf` - For advanced performance profiling and optimization
- `/security` - For comprehensive security audit and compliance
