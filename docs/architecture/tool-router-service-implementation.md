# Tool Router Service Implementation Architecture

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Service Architecture](#service-architecture)
3. [Routing Engine Design](#routing-engine-design)
4. [Tool Registry Management](#tool-registry-management)
5. [Request Processing Pipeline](#request-processing-pipeline)
6. [Load Balancing and Failover](#load-balancing-and-failover)
7. [Security and Authorization](#security-and-authorization)
8. [Performance Optimization](#performance-optimization)
9. [Monitoring and Observability](#monitoring-and-observability)
10. [Deployment and Configuration](#deployment-and-configuration)

## Executive Summary

The Tool Router Service acts as the central hub for tool invocation and management within the Claude ecosystem. It provides intelligent routing, load balancing, and execution coordination for all tool requests while maintaining security boundaries and performance optimization.

### Core Capabilities

- **Intelligent Routing**: Dynamic tool selection based on capability matching
- **Load Balancing**: Distributes requests across available tool instances
- **Circuit Breaking**: Fault tolerance and graceful degradation
- **Security Enforcement**: Tool access control and permission validation
- **Performance Monitoring**: Real-time metrics and health tracking

## Service Architecture

### High-Level Component Overview

```mermaid
graph TB
    subgraph "Client Layer"
        Claude[Claude Orchestrator]
        Agents[Agent Instances]
        UI[Dashboard UI]
    end

    subgraph "Tool Router Service"
        Gateway[API Gateway]
        Router[Routing Engine]
        Registry[Tool Registry]
        LB[Load Balancer]
        CB[Circuit Breaker]
        Auth[Authorization]
    end

    subgraph "Tool Ecosystem"
        Tools1[File System Tools]
        Tools2[External API Tools]
        Tools3[Computation Tools]
        Tools4[MCP Tools]
        Health[Health Monitors]
    end

    subgraph "Infrastructure"
        Cache[Redis Cache]
        Metrics[Metrics Store]
        Logs[Log Aggregation]
    end

    Claude --> Gateway
    Agents --> Gateway
    UI --> Gateway

    Gateway --> Auth
    Auth --> Router
    Router --> Registry
    Router --> LB
    LB --> CB
    CB --> Tools1
    CB --> Tools2
    CB --> Tools3
    CB --> Tools4

    Router --> Cache
    Router --> Metrics
    Gateway --> Logs
    Tools1 --> Health
    Tools2 --> Health
    Tools3 --> Health
    Tools4 --> Health

    style Gateway fill:#e3f2fd
    style Router fill:#f3e5f5
    style Registry fill:#e8f5e8
    style Tools1 fill:#fff3e0
```

### Service Layers

| Layer | Component | Responsibility | Technology |
|-------|-----------|----------------|------------|
| **Gateway** | API Gateway | Request ingress, authentication | Express.js, Passport |
| **Routing** | Routing Engine | Tool selection, request distribution | Node.js, Custom Logic |
| **Registry** | Tool Registry | Tool discovery, capability management | Redis, JSON Schema |
| **Load Balancing** | Load Balancer | Instance selection, health checking | Custom LB, Health Checks |
| **Circuit Breaking** | Circuit Breaker | Fault tolerance, graceful degradation | Opossum, Custom Metrics |
| **Tools** | Tool Instances | Actual tool execution | Various Technologies |

## Routing Engine Design

### Core Routing Architecture

```mermaid
graph LR
    subgraph "Request Analysis"
        Parser[Request Parser]
        Validator[Input Validator]
        Enricher[Context Enricher]
    end

    subgraph "Routing Logic"
        Matcher[Capability Matcher]
        Selector[Tool Selector]
        Ranker[Priority Ranker]
    end

    subgraph "Execution Control"
        Allocator[Resource Allocator]
        Dispatcher[Request Dispatcher]
        Tracker[Execution Tracker]
    end

    Parser --> Validator
    Validator --> Enricher
    Enricher --> Matcher
    Matcher --> Selector
    Selector --> Ranker
    Ranker --> Allocator
    Allocator --> Dispatcher
    Dispatcher --> Tracker

    style Parser fill:#e8eaf6
    style Matcher fill:#e0f2f1
    style Allocator fill:#fff8e1
```

### Routing Algorithm Implementation

```typescript
interface RoutingRequest {
  toolName: string;
  operation: string;
  parameters: Record<string, any>;
  context: RequestContext;
  constraints: RoutingConstraints;
}

interface RoutingConstraints {
  maxLatency?: number;
  requiredCapabilities?: string[];
  excludeInstances?: string[];
  preferredRegion?: string;
  loadBalancingStrategy?: LoadBalancingStrategy;
}

class RoutingEngine {
  private registry: ToolRegistry;
  private loadBalancer: LoadBalancer;
  private circuitBreaker: CircuitBreaker;
  private metricsCollector: MetricsCollector;

  async routeRequest(request: RoutingRequest): Promise<RoutingDecision> {
    // Step 1: Parse and validate request
    const validatedRequest = await this.validateRequest(request);

    // Step 2: Find matching tools
    const candidates = await this.findCandidateTools(validatedRequest);

    // Step 3: Apply constraints and filters
    const filteredCandidates = this.applyConstraints(candidates, request.constraints);

    // Step 4: Rank candidates by priority
    const rankedCandidates = await this.rankCandidates(filteredCandidates, request.context);

    // Step 5: Select optimal tool instance
    const selectedTool = await this.selectTool(rankedCandidates, request.constraints);

    // Step 6: Create routing decision
    return this.createRoutingDecision(selectedTool, request);
  }

  private async findCandidateTools(request: RoutingRequest): Promise<ToolInstance[]> {
    const toolDefinitions = await this.registry.findByCapability(request.operation);

    return toolDefinitions
      .filter(tool => this.isCompatible(tool, request))
      .map(tool => this.getAvailableInstances(tool))
      .flat()
      .filter(instance => this.circuitBreaker.isHealthy(instance.id));
  }

  private async rankCandidates(
    candidates: ToolInstance[],
    context: RequestContext
  ): Promise<ScoredToolInstance[]> {
    const rankings = await Promise.all(
      candidates.map(async (candidate) => {
        const score = await this.calculateScore(candidate, context);
        return { ...candidate, score };
      })
    );

    return rankings.sort((a, b) => b.score - a.score);
  }

  private async calculateScore(
    instance: ToolInstance,
    context: RequestContext
  ): Promise<number> {
    const factors = await Promise.all([
      this.getLatencyScore(instance),
      this.getLoadScore(instance),
      this.getReliabilityScore(instance),
      this.getAffinityScore(instance, context),
      this.getCostScore(instance)
    ]);

    // Weighted scoring algorithm
    const weights = [0.3, 0.25, 0.2, 0.15, 0.1]; // Latency, Load, Reliability, Affinity, Cost
    return factors.reduce((total, factor, index) => total + factor * weights[index], 0);
  }
}
```

### Capability Matching System

```typescript
interface ToolCapability {
  name: string;
  version: string;
  parameters: ParameterSchema[];
  constraints: CapabilityConstraints;
  metadata: CapabilityMetadata;
}

interface ParameterSchema {
  name: string;
  type: ParameterType;
  required: boolean;
  validation: ValidationRule[];
  description: string;
}

class CapabilityMatcher {
  matchCapabilities(
    requestedCapability: string,
    availableCapabilities: ToolCapability[]
  ): MatchResult[] {
    return availableCapabilities
      .map(capability => this.scoreMatch(requestedCapability, capability))
      .filter(match => match.score > 0.5) // Minimum compatibility threshold
      .sort((a, b) => b.score - a.score);
  }

  private scoreMatch(
    requested: string,
    available: ToolCapability
  ): MatchResult {
    let score = 0;

    // Exact name match
    if (requested === available.name) {
      score += 1.0;
    }
    // Semantic similarity
    else if (this.isSemanticMatch(requested, available.name)) {
      score += 0.8;
    }
    // Pattern matching
    else if (this.isPatternMatch(requested, available.name)) {
      score += 0.6;
    }

    // Version compatibility
    score *= this.getVersionCompatibilityScore(available.version);

    // Parameter compatibility
    score *= this.getParameterCompatibilityScore(available.parameters);

    return {
      capability: available,
      score,
      reasoning: this.generateMatchReasoning(requested, available, score)
    };
  }
}
```

## Tool Registry Management

### Registry Data Model

```mermaid
erDiagram
    Tool ||--o{ ToolInstance : "has"
    Tool ||--o{ ToolCapability : "provides"
    Tool ||--o{ ToolVersion : "versioned by"
    ToolInstance ||--o{ InstanceMetrics : "generates"
    ToolInstance ||--o{ HealthCheck : "monitored by"
    ToolCapability ||--o{ ParameterSchema : "defines"

    Tool {
        string id PK
        string name
        string category
        string description
        json configuration
        timestamp createdAt
        timestamp updatedAt
    }

    ToolInstance {
        string id PK
        string toolId FK
        string endpoint
        string status
        json capabilities
        json metadata
        timestamp lastSeen
    }

    ToolCapability {
        string id PK
        string toolId FK
        string name
        string version
        json schema
        json constraints
    }

    InstanceMetrics {
        string instanceId FK
        timestamp timestamp
        float latency
        float successRate
        float cpuUsage
        float memoryUsage
    }
```

### Registry Implementation

```typescript
class ToolRegistry {
  private redis: Redis;
  private eventEmitter: EventEmitter;
  private healthChecker: HealthChecker;

  async registerTool(toolDefinition: ToolDefinition): Promise<void> {
    // Validate tool definition
    await this.validateToolDefinition(toolDefinition);

    // Register in storage
    await this.redis.hset(
      `tools:${toolDefinition.id}`,
      this.serializeToolDefinition(toolDefinition)
    );

    // Index capabilities for fast lookup
    await this.indexCapabilities(toolDefinition);

    // Start health monitoring
    this.healthChecker.monitor(toolDefinition.id);

    // Emit registration event
    this.eventEmitter.emit('tool:registered', { toolId: toolDefinition.id });
  }

  async registerInstance(instance: ToolInstance): Promise<void> {
    // Validate instance
    await this.validateInstance(instance);

    // Register instance
    await this.redis.hset(
      `instances:${instance.id}`,
      this.serializeInstance(instance)
    );

    // Add to tool's instance list
    await this.redis.sadd(`tool:${instance.toolId}:instances`, instance.id);

    // Initialize metrics tracking
    await this.initializeMetrics(instance.id);

    // Emit instance registration event
    this.eventEmitter.emit('instance:registered', { instanceId: instance.id });
  }

  async findByCapability(capability: string): Promise<ToolDefinition[]> {
    // Use capability index for fast lookup
    const toolIds = await this.redis.smembers(`capability:${capability}:tools`);

    // Fetch tool definitions
    const tools = await Promise.all(
      toolIds.map(id => this.getTool(id))
    );

    return tools.filter(tool => tool !== null);
  }

  async getHealthyInstances(toolId: string): Promise<ToolInstance[]> {
    const instanceIds = await this.redis.smembers(`tool:${toolId}:instances`);

    const instances = await Promise.all(
      instanceIds.map(id => this.getInstance(id))
    );

    return instances.filter(instance =>
      instance && instance.status === 'healthy'
    );
  }

  private async indexCapabilities(tool: ToolDefinition): Promise<void> {
    for (const capability of tool.capabilities) {
      await this.redis.sadd(`capability:${capability.name}:tools`, tool.id);

      // Create reverse index for semantic search
      const keywords = this.extractKeywords(capability.name, capability.description);
      for (const keyword of keywords) {
        await this.redis.sadd(`keyword:${keyword}:capabilities`, capability.name);
      }
    }
  }
}
```

## Request Processing Pipeline

### Pipeline Architecture

```mermaid
graph LR
    subgraph "Ingress Stage"
        Auth[Authentication]
        RateLimit[Rate Limiting]
        Validate[Request Validation]
    end

    subgraph "Routing Stage"
        Parse[Request Parsing]
        Match[Tool Matching]
        Select[Instance Selection]
    end

    subgraph "Execution Stage"
        Prepare[Request Preparation]
        Execute[Tool Execution]
        Monitor[Execution Monitoring]
    end

    subgraph "Response Stage"
        Aggregate[Response Aggregation]
        Transform[Response Transform]
        Deliver[Response Delivery]
    end

    Auth --> RateLimit
    RateLimit --> Validate
    Validate --> Parse
    Parse --> Match
    Match --> Select
    Select --> Prepare
    Prepare --> Execute
    Execute --> Monitor
    Monitor --> Aggregate
    Aggregate --> Transform
    Transform --> Deliver

    style Auth fill:#ffebee
    style Parse fill:#e8f5e8
    style Execute fill:#e3f2fd
    style Transform fill:#fff3e0
```

### Pipeline Implementation

```typescript
class RequestPipeline {
  private stages: PipelineStage[];
  private metricsCollector: MetricsCollector;
  private errorHandler: ErrorHandler;

  constructor(config: PipelineConfig) {
    this.stages = this.initializePipelines(config);
  }

  async process(request: IncomingRequest): Promise<PipelineResult> {
    const context = this.createPipelineContext(request);

    try {
      // Execute pipeline stages sequentially
      for (const stage of this.stages) {
        await this.executeStage(stage, context);

        // Check for early termination
        if (context.shouldTerminate) {
          break;
        }
      }

      return this.createSuccessResult(context);
    } catch (error) {
      return this.handlePipelineError(error, context);
    } finally {
      await this.recordMetrics(context);
    }
  }

  private async executeStage(
    stage: PipelineStage,
    context: PipelineContext
  ): Promise<void> {
    const startTime = Date.now();

    try {
      await stage.execute(context);

      this.metricsCollector.recordStageSuccess(
        stage.name,
        Date.now() - startTime
      );
    } catch (error) {
      this.metricsCollector.recordStageError(stage.name, error);

      if (stage.isCritical) {
        throw error;
      }

      // Log non-critical errors but continue
      console.warn(`Non-critical stage ${stage.name} failed:`, error);
    }
  }
}

// Pipeline Stages Implementation
class AuthenticationStage implements PipelineStage {
  name = 'authentication';
  isCritical = true;

  async execute(context: PipelineContext): Promise<void> {
    const token = this.extractToken(context.request);

    if (!token) {
      throw new AuthenticationError('Missing authentication token');
    }

    const principal = await this.validateToken(token);
    context.principal = principal;

    // Check tool access permissions
    await this.validateToolAccess(principal, context.request.toolName);
  }
}

class ToolMatchingStage implements PipelineStage {
  name = 'tool_matching';
  isCritical = true;

  constructor(
    private registry: ToolRegistry,
    private matcher: CapabilityMatcher
  ) {}

  async execute(context: PipelineContext): Promise<void> {
    const { toolName, operation } = context.request;

    // Find tools that can handle this request
    const candidates = await this.registry.findByCapability(operation);

    if (candidates.length === 0) {
      throw new ToolNotFoundError(`No tools found for operation: ${operation}`);
    }

    // Score and rank candidates
    const matches = this.matcher.matchCapabilities(operation, candidates);
    context.toolMatches = matches;

    // Select primary tool
    context.selectedTool = matches[0]?.capability;

    if (!context.selectedTool) {
      throw new IncompatibleToolError(`No compatible tools found for: ${operation}`);
    }
  }
}

class ExecutionStage implements PipelineStage {
  name = 'execution';
  isCritical = true;

  constructor(
    private loadBalancer: LoadBalancer,
    private executor: ToolExecutor
  ) {}

  async execute(context: PipelineContext): Promise<void> {
    const { selectedTool, request } = context;

    // Get healthy instance
    const instance = await this.loadBalancer.selectInstance(selectedTool.id);

    if (!instance) {
      throw new NoHealthyInstanceError(`No healthy instances for tool: ${selectedTool.name}`);
    }

    // Execute tool request
    const executionRequest = this.prepareExecutionRequest(request, instance);
    const result = await this.executor.execute(executionRequest);

    context.executionResult = result;
    context.usedInstance = instance;
  }
}
```

## Load Balancing and Failover

### Load Balancing Strategies

```mermaid
graph TB
    subgraph "Load Balancing Strategies"
        RR[Round Robin]
        WRR[Weighted Round Robin]
        LC[Least Connections]
        WLC[Weighted Least Connections]
        LR[Least Response Time]
        CH[Consistent Hashing]
    end

    subgraph "Health Checking"
        Active[Active Health Checks]
        Passive[Passive Health Checks]
        CB[Circuit Breaker]
    end

    subgraph "Failover Mechanisms"
        Retry[Retry Logic]
        Fallback[Fallback Tools]
        Graceful[Graceful Degradation]
    end

    RR --> Active
    WRR --> Active
    LC --> Passive
    WLC --> Passive
    LR --> CB
    CH --> CB

    Active --> Retry
    Passive --> Fallback
    CB --> Graceful

    style RR fill:#e8f5e8
    style Active fill:#fff3e0
    style Retry fill:#ffebee
```

### Load Balancer Implementation

```typescript
enum LoadBalancingStrategy {
  ROUND_ROBIN = 'round_robin',
  WEIGHTED_ROUND_ROBIN = 'weighted_round_robin',
  LEAST_CONNECTIONS = 'least_connections',
  LEAST_RESPONSE_TIME = 'least_response_time',
  CONSISTENT_HASH = 'consistent_hash',
  RANDOM = 'random'
}

class LoadBalancer {
  private strategies: Map<LoadBalancingStrategy, LoadBalancingImplementation>;
  private healthChecker: HealthChecker;
  private metricsCollector: MetricsCollector;

  constructor(config: LoadBalancerConfig) {
    this.strategies = new Map([
      [LoadBalancingStrategy.ROUND_ROBIN, new RoundRobinStrategy()],
      [LoadBalancingStrategy.WEIGHTED_ROUND_ROBIN, new WeightedRoundRobinStrategy()],
      [LoadBalancingStrategy.LEAST_CONNECTIONS, new LeastConnectionsStrategy()],
      [LoadBalancingStrategy.LEAST_RESPONSE_TIME, new LeastResponseTimeStrategy()],
      [LoadBalancingStrategy.CONSISTENT_HASH, new ConsistentHashStrategy()],
      [LoadBalancingStrategy.RANDOM, new RandomStrategy()]
    ]);
  }

  async selectInstance(
    toolId: string,
    strategy: LoadBalancingStrategy = LoadBalancingStrategy.LEAST_RESPONSE_TIME,
    context?: SelectionContext
  ): Promise<ToolInstance | null> {
    // Get healthy instances
    const healthyInstances = await this.getHealthyInstances(toolId);

    if (healthyInstances.length === 0) {
      await this.recordNoHealthyInstances(toolId);
      return null;
    }

    // Apply load balancing strategy
    const strategyImpl = this.strategies.get(strategy);
    if (!strategyImpl) {
      throw new Error(`Unknown load balancing strategy: ${strategy}`);
    }

    const selectedInstance = await strategyImpl.selectInstance(
      healthyInstances,
      context
    );

    // Record selection metrics
    await this.recordInstanceSelection(selectedInstance, strategy);

    return selectedInstance;
  }

  private async getHealthyInstances(toolId: string): Promise<ToolInstance[]> {
    const allInstances = await this.registry.getInstances(toolId);

    const healthyInstances = await Promise.all(
      allInstances.map(async (instance) => {
        const isHealthy = await this.healthChecker.isHealthy(instance.id);
        return isHealthy ? instance : null;
      })
    );

    return healthyInstances.filter(instance => instance !== null);
  }
}

// Strategy Implementations
class LeastResponseTimeStrategy implements LoadBalancingImplementation {
  async selectInstance(
    instances: ToolInstance[],
    context?: SelectionContext
  ): Promise<ToolInstance> {
    // Get current metrics for all instances
    const instanceMetrics = await Promise.all(
      instances.map(async (instance) => {
        const metrics = await this.getInstanceMetrics(instance.id);
        return { instance, metrics };
      })
    );

    // Sort by average response time
    instanceMetrics.sort((a, b) => a.metrics.avgResponseTime - b.metrics.avgResponseTime);

    return instanceMetrics[0].instance;
  }

  private async getInstanceMetrics(instanceId: string): Promise<InstanceMetrics> {
    // Implementation to fetch real-time metrics
    // This could be from Redis, Prometheus, or other metrics store
  }
}

class ConsistentHashStrategy implements LoadBalancingImplementation {
  private hashRing: ConsistentHashRing;

  async selectInstance(
    instances: ToolInstance[],
    context?: SelectionContext
  ): Promise<ToolInstance> {
    // Update hash ring with current instances
    this.hashRing.updateInstances(instances);

    // Use request context to generate hash key
    const hashKey = this.generateHashKey(context);

    // Find instance using consistent hashing
    return this.hashRing.getInstanceForKey(hashKey);
  }

  private generateHashKey(context?: SelectionContext): string {
    if (context?.sessionId) {
      return context.sessionId; // Session affinity
    }

    if (context?.userId) {
      return context.userId; // User affinity
    }

    return Date.now().toString(); // Fallback to timestamp
  }
}
```

### Circuit Breaker Implementation

```typescript
enum CircuitState {
  CLOSED = 'closed',     // Normal operation
  OPEN = 'open',         // Failing, blocking requests
  HALF_OPEN = 'half_open' // Testing recovery
}

class CircuitBreaker {
  private circuits: Map<string, Circuit>;
  private config: CircuitBreakerConfig;
  private metricsCollector: MetricsCollector;

  constructor(config: CircuitBreakerConfig) {
    this.config = config;
    this.circuits = new Map();
  }

  async execute<T>(
    instanceId: string,
    operation: () => Promise<T>
  ): Promise<T> {
    const circuit = this.getOrCreateCircuit(instanceId);

    if (circuit.state === CircuitState.OPEN) {
      if (this.shouldAttemptReset(circuit)) {
        circuit.state = CircuitState.HALF_OPEN;
      } else {
        throw new CircuitOpenError(`Circuit breaker is open for instance: ${instanceId}`);
      }
    }

    try {
      const result = await operation();
      this.onSuccess(circuit);
      return result;
    } catch (error) {
      this.onFailure(circuit, error);
      throw error;
    }
  }

  private getOrCreateCircuit(instanceId: string): Circuit {
    if (!this.circuits.has(instanceId)) {
      this.circuits.set(instanceId, {
        instanceId,
        state: CircuitState.CLOSED,
        failureCount: 0,
        successCount: 0,
        lastFailureTime: null,
        lastSuccessTime: null,
        nextAttemptTime: null
      });
    }

    return this.circuits.get(instanceId)!;
  }

  private onSuccess(circuit: Circuit): void {
    circuit.failureCount = 0;
    circuit.successCount++;
    circuit.lastSuccessTime = Date.now();

    if (circuit.state === CircuitState.HALF_OPEN) {
      if (circuit.successCount >= this.config.successThreshold) {
        circuit.state = CircuitState.CLOSED;
        this.metricsCollector.recordCircuitClosed(circuit.instanceId);
      }
    }
  }

  private onFailure(circuit: Circuit, error: Error): void {
    circuit.failureCount++;
    circuit.lastFailureTime = Date.now();

    if (circuit.failureCount >= this.config.failureThreshold) {
      circuit.state = CircuitState.OPEN;
      circuit.nextAttemptTime = Date.now() + this.config.timeout;
      this.metricsCollector.recordCircuitOpened(circuit.instanceId, error);
    }
  }

  private shouldAttemptReset(circuit: Circuit): boolean {
    return circuit.nextAttemptTime && Date.now() >= circuit.nextAttemptTime;
  }
}
```

## Security and Authorization

### Security Architecture

```mermaid
graph TB
    subgraph "Authentication Layer"
        JWT[JWT Validation]
        OAuth[OAuth 2.0]
        ApiKey[API Key Auth]
        Cert[Certificate Auth]
    end

    subgraph "Authorization Layer"
        RBAC[Role-Based Access]
        ABAC[Attribute-Based Access]
        Policies[Policy Engine]
        ACL[Access Control Lists]
    end

    subgraph "Security Controls"
        RateLimit[Rate Limiting]
        Encryption[TLS/mTLS]
        Audit[Audit Logging]
        Validation[Input Validation]
    end

    JWT --> RBAC
    OAuth --> RBAC
    ApiKey --> ABAC
    Cert --> ABAC

    RBAC --> Policies
    ABAC --> Policies
    Policies --> ACL

    RBAC --> RateLimit
    ABAC --> Encryption
    Policies --> Audit
    ACL --> Validation

    style JWT fill:#ffebee
    style RBAC fill:#e8f5e8
    style RateLimit fill:#fff3e0
```

### Authorization Implementation

```typescript
interface AuthorizationContext {
  principal: Principal;
  resource: Resource;
  action: string;
  environment: EnvironmentAttributes;
}

interface Principal {
  id: string;
  type: PrincipalType;
  roles: string[];
  permissions: string[];
  attributes: Record<string, any>;
}

interface Resource {
  type: ResourceType;
  id: string;
  owner: string;
  attributes: Record<string, any>;
}

class AuthorizationEngine {
  private policyEngine: PolicyEngine;
  private roleManager: RoleManager;
  private auditLogger: AuditLogger;

  async authorize(context: AuthorizationContext): Promise<AuthorizationResult> {
    try {
      // Step 1: Validate input
      this.validateAuthorizationContext(context);

      // Step 2: Check explicit deny policies first
      const denyResult = await this.checkDenyPolicies(context);
      if (denyResult.decision === Decision.DENY) {
        await this.auditLogger.logDeny(context, denyResult.reason);
        return denyResult;
      }

      // Step 3: Check allow policies
      const allowResult = await this.checkAllowPolicies(context);
      if (allowResult.decision === Decision.ALLOW) {
        await this.auditLogger.logAllow(context);
        return allowResult;
      }

      // Step 4: Default deny
      const defaultDeny = this.createDenyResult('Default deny policy');
      await this.auditLogger.logDeny(context, defaultDeny.reason);
      return defaultDeny;

    } catch (error) {
      await this.auditLogger.logError(context, error);
      return this.createDenyResult(`Authorization error: ${error.message}`);
    }
  }

  private async checkAllowPolicies(
    context: AuthorizationContext
  ): Promise<AuthorizationResult> {
    // Check role-based permissions
    const roleResult = await this.checkRolePermissions(context);
    if (roleResult.decision === Decision.ALLOW) {
      return roleResult;
    }

    // Check attribute-based policies
    const abacResult = await this.checkAttributePolicies(context);
    if (abacResult.decision === Decision.ALLOW) {
      return abacResult;
    }

    // Check resource-specific policies
    const resourceResult = await this.checkResourcePolicies(context);
    return resourceResult;
  }

  private async checkRolePermissions(
    context: AuthorizationContext
  ): Promise<AuthorizationResult> {
    const { principal, resource, action } = context;

    // Get effective permissions from all roles
    const effectivePermissions = await this.roleManager.getEffectivePermissions(
      principal.roles
    );

    // Check if any permission allows this action on this resource
    for (const permission of effectivePermissions) {
      if (this.permissionMatches(permission, resource.type, action)) {
        return this.createAllowResult(`Role permission: ${permission}`);
      }
    }

    return this.createDenyResult('No matching role permissions');
  }

  private async checkAttributePolicies(
    context: AuthorizationContext
  ): Promise<AuthorizationResult> {
    const policies = await this.policyEngine.getPoliciesForResource(
      context.resource.type
    );

    for (const policy of policies) {
      const result = await this.policyEngine.evaluate(policy, context);
      if (result.decision === Decision.ALLOW) {
        return result;
      }
    }

    return this.createDenyResult('No matching attribute policies');
  }
}

// Tool-specific authorization policies
class ToolAuthorizationPolicies {
  static readonly FILE_SYSTEM_POLICY = {
    name: 'file_system_access',
    rules: [
      {
        effect: 'ALLOW',
        principals: ['role:agent', 'role:admin'],
        actions: ['read', 'write'],
        resources: ['file:system/*'],
        conditions: {
          'path.within': ['/tmp/', '/var/tmp/', '/app/workspace/']
        }
      },
      {
        effect: 'DENY',
        principals: ['*'],
        actions: ['write', 'execute'],
        resources: ['file:system/*'],
        conditions: {
          'path.matches': ['/etc/*', '/sys/*', '/proc/*']
        }
      }
    ]
  };

  static readonly EXTERNAL_API_POLICY = {
    name: 'external_api_access',
    rules: [
      {
        effect: 'ALLOW',
        principals: ['role:agent', 'role:admin'],
        actions: ['call'],
        resources: ['api:external/*'],
        conditions: {
          'rate_limit': '100/hour',
          'approved_domains': ['api.github.com', 'api.openai.com']
        }
      }
    ]
  };

  static readonly MCP_TOOL_POLICY = {
    name: 'mcp_tool_access',
    rules: [
      {
        effect: 'ALLOW',
        principals: ['role:mcp-client'],
        actions: ['invoke', 'list_resources', 'subscribe'],
        resources: ['mcp:tool/*'],
        conditions: {
          'tool.approved': true,
          'session.authenticated': true
        }
      }
    ]
  };
}
```

## Performance Optimization

### Caching Strategy

```mermaid
graph TB
    subgraph "Multi-Layer Cache"
        L1[L1: In-Memory Cache]
        L2[L2: Redis Cache]
        L3[L3: Database Cache]
    end

    subgraph "Cache Types"
        ToolCache[Tool Registry Cache]
        ResultCache[Execution Result Cache]
        MetricsCache[Metrics Cache]
        AuthCache[Authorization Cache]
    end

    subgraph "Cache Policies"
        TTL[Time-To-Live]
        LRU[Least Recently Used]
        WriteThrough[Write Through]
        WriteBack[Write Back]
    end

    L1 --> ToolCache
    L1 --> AuthCache
    L2 --> ResultCache
    L2 --> MetricsCache
    L3 --> ToolCache
    L3 --> ResultCache

    ToolCache --> TTL
    ResultCache --> LRU
    MetricsCache --> WriteThrough
    AuthCache --> WriteBack

    style L1 fill:#e8f5e8
    style L2 fill:#fff3e0
    style L3 fill:#ffebee
```

### Performance Optimization Implementation

```typescript
class PerformanceOptimizer {
  private cacheManager: CacheManager;
  private connectionPool: ConnectionPool;
  private requestBatcher: RequestBatcher;
  private compressionManager: CompressionManager;

  constructor(config: PerformanceConfig) {
    this.cacheManager = new CacheManager(config.cache);
    this.connectionPool = new ConnectionPool(config.connection);
    this.requestBatcher = new RequestBatcher(config.batching);
    this.compressionManager = new CompressionManager(config.compression);
  }

  async optimizeRequest(request: ToolRequest): Promise<OptimizedRequest> {
    // Step 1: Check cache for recent results
    const cacheKey = this.generateCacheKey(request);
    const cachedResult = await this.cacheManager.get(cacheKey);

    if (cachedResult && this.isCacheValid(cachedResult)) {
      return this.createCachedResponse(cachedResult);
    }

    // Step 2: Optimize request parameters
    const optimizedParams = await this.optimizeParameters(request.parameters);

    // Step 3: Apply compression if beneficial
    const compressedRequest = await this.compressionManager.compress(
      { ...request, parameters: optimizedParams }
    );

    // Step 4: Pool similar requests for batching
    const batchedRequest = await this.requestBatcher.addToBatch(compressedRequest);

    return batchedRequest;
  }

  private async optimizeParameters(parameters: any): Promise<any> {
    // Remove unnecessary parameters
    const essential = this.extractEssentialParameters(parameters);

    // Optimize data structures
    const optimized = this.optimizeDataStructures(essential);

    // Apply parameter compression
    const compressed = await this.compressParameters(optimized);

    return compressed;
  }
}

// Connection pooling for tool instances
class ConnectionPool {
  private pools: Map<string, Pool>;
  private config: ConnectionPoolConfig;

  constructor(config: ConnectionPoolConfig) {
    this.config = config;
    this.pools = new Map();
  }

  async getConnection(instanceId: string): Promise<Connection> {
    let pool = this.pools.get(instanceId);

    if (!pool) {
      pool = this.createPool(instanceId);
      this.pools.set(instanceId, pool);
    }

    return pool.acquire();
  }

  private createPool(instanceId: string): Pool {
    return new Pool({
      min: this.config.minConnections,
      max: this.config.maxConnections,
      acquireTimeoutMillis: this.config.acquireTimeout,
      createTimeoutMillis: this.config.createTimeout,
      idleTimeoutMillis: this.config.idleTimeout,
      reapIntervalMillis: this.config.reapInterval,

      create: async () => {
        return this.createConnection(instanceId);
      },

      destroy: async (connection: Connection) => {
        return connection.close();
      },

      validate: async (connection: Connection) => {
        return connection.ping();
      }
    });
  }
}

// Request batching for efficiency
class RequestBatcher {
  private batches: Map<string, RequestBatch>;
  private config: BatchingConfig;
  private timer: NodeJS.Timeout | null = null;

  async addToBatch(request: ToolRequest): Promise<BatchedRequest> {
    const batchKey = this.generateBatchKey(request);
    let batch = this.batches.get(batchKey);

    if (!batch) {
      batch = this.createBatch(batchKey);
      this.batches.set(batchKey, batch);
    }

    batch.requests.push(request);

    // Start flush timer if this is the first request
    if (batch.requests.length === 1) {
      this.scheduleFlush(batchKey);
    }

    // Flush immediately if batch is full
    if (batch.requests.length >= this.config.maxBatchSize) {
      await this.flushBatch(batchKey);
    }

    return {
      batchId: batch.id,
      position: batch.requests.length - 1,
      promise: batch.promise
    };
  }

  private async flushBatch(batchKey: string): Promise<void> {
    const batch = this.batches.get(batchKey);
    if (!batch || batch.requests.length === 0) {
      return;
    }

    try {
      // Execute batch request
      const results = await this.executeBatchRequest(batch);
      batch.resolve(results);
    } catch (error) {
      batch.reject(error);
    } finally {
      this.batches.delete(batchKey);
    }
  }
}
```

## Monitoring and Observability

### Metrics Collection Architecture

```mermaid
graph TB
    subgraph "Metrics Sources"
        Router[Router Metrics]
        Tools[Tool Metrics]
        System[System Metrics]
        Business[Business Metrics]
    end

    subgraph "Collection Layer"
        Agent[Metrics Agent]
        Aggregator[Aggregator]
        Buffer[Buffer/Queue]
    end

    subgraph "Storage Layer"
        Prometheus[Prometheus]
        InfluxDB[InfluxDB]
        ElasticSearch[ElasticSearch]
    end

    subgraph "Analysis Layer"
        Grafana[Grafana Dashboards]
        Alerting[Alert Manager]
        Analytics[Analytics Engine]
    end

    Router --> Agent
    Tools --> Agent
    System --> Aggregator
    Business --> Aggregator

    Agent --> Buffer
    Aggregator --> Buffer
    Buffer --> Prometheus
    Buffer --> InfluxDB
    Buffer --> ElasticSearch

    Prometheus --> Grafana
    InfluxDB --> Analytics
    ElasticSearch --> Alerting

    style Agent fill:#e8f5e8
    style Prometheus fill:#fff3e0
    style Grafana fill:#e3f2fd
```

### Metrics Implementation

```typescript
interface MetricsCollector {
  // Request metrics
  recordRequest(toolName: string, operation: string, duration: number): void;
  recordSuccess(toolName: string, operation: string): void;
  recordError(toolName: string, operation: string, error: Error): void;

  // Performance metrics
  recordLatency(instanceId: string, latency: number): void;
  recordThroughput(instanceId: string, requestCount: number): void;
  recordResourceUsage(instanceId: string, cpu: number, memory: number): void;

  // Business metrics
  recordToolUsage(toolName: string, userId: string): void;
  recordFeatureUsage(feature: string, userId: string): void;
  recordCostMetrics(operation: string, cost: number): void;
}

class PrometheusMetricsCollector implements MetricsCollector {
  private requestCounter: Counter<string>;
  private latencyHistogram: Histogram<string>;
  private errorCounter: Counter<string>;
  private throughputGauge: Gauge<string>;

  constructor() {
    this.requestCounter = new Counter({
      name: 'tool_requests_total',
      help: 'Total number of tool requests',
      labelNames: ['tool_name', 'operation', 'status']
    });

    this.latencyHistogram = new Histogram({
      name: 'tool_request_duration_seconds',
      help: 'Tool request duration in seconds',
      labelNames: ['tool_name', 'operation'],
      buckets: [0.01, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10]
    });

    this.errorCounter = new Counter({
      name: 'tool_errors_total',
      help: 'Total number of tool errors',
      labelNames: ['tool_name', 'operation', 'error_type']
    });

    this.throughputGauge = new Gauge({
      name: 'tool_throughput_requests_per_second',
      help: 'Tool throughput in requests per second',
      labelNames: ['tool_name']
    });
  }

  recordRequest(toolName: string, operation: string, duration: number): void {
    this.requestCounter
      .labels(toolName, operation, 'success')
      .inc();

    this.latencyHistogram
      .labels(toolName, operation)
      .observe(duration / 1000); // Convert to seconds
  }

  recordError(toolName: string, operation: string, error: Error): void {
    this.requestCounter
      .labels(toolName, operation, 'error')
      .inc();

    this.errorCounter
      .labels(toolName, operation, error.constructor.name)
      .inc();
  }
}

// Health monitoring implementation
class HealthMonitor {
  private healthChecks: Map<string, HealthCheck>;
  private checkInterval: number;
  private alertManager: AlertManager;

  constructor(config: HealthMonitorConfig) {
    this.healthChecks = new Map();
    this.checkInterval = config.checkInterval;
    this.alertManager = new AlertManager(config.alerting);
  }

  registerHealthCheck(instanceId: string, check: HealthCheck): void {
    this.healthChecks.set(instanceId, check);
    this.scheduleHealthCheck(instanceId);
  }

  private async performHealthCheck(instanceId: string): Promise<void> {
    const check = this.healthChecks.get(instanceId);
    if (!check) return;

    try {
      const result = await check.execute();

      if (result.healthy) {
        await this.handleHealthyInstance(instanceId, result);
      } else {
        await this.handleUnhealthyInstance(instanceId, result);
      }
    } catch (error) {
      await this.handleHealthCheckError(instanceId, error);
    }
  }

  private async handleUnhealthyInstance(
    instanceId: string,
    result: HealthCheckResult
  ): Promise<void> {
    // Mark instance as unhealthy
    await this.registry.markUnhealthy(instanceId, result.reason);

    // Trigger alert
    await this.alertManager.triggerAlert({
      type: 'instance_unhealthy',
      instanceId,
      reason: result.reason,
      timestamp: new Date()
    });

    // Remove from load balancer rotation
    await this.loadBalancer.removeInstance(instanceId);
  }
}
```

## Deployment and Configuration

### Deployment Architecture

```yaml
# Docker Compose deployment
version: '3.8'

services:
  tool-router:
    image: claude-ecosystem/tool-router:latest
    ports:
      - "3000:3000"
      - "9090:9090"  # Metrics port
    environment:
      NODE_ENV: production
      REDIS_URL: redis://redis:6379
      POSTGRES_URL: postgresql://postgres:password@postgres:5432/toolrouter
    depends_on:
      - redis
      - postgres
    volumes:
      - ./config:/app/config:ro
      - logs:/app/logs
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
    deploy:
      replicas: 3
      resources:
        limits:
          memory: 512M
          cpus: "0.5"
        reservations:
          memory: 256M
          cpus: "0.25"

  redis:
    image: redis:7-alpine
    volumes:
      - redis-data:/data
    command: redis-server --appendonly yes --maxmemory 256mb

  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: toolrouter
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    volumes:
      - postgres-data:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql

volumes:
  redis-data:
  postgres-data:
  logs:
```

### Configuration Management

```typescript
interface ToolRouterConfig {
  server: ServerConfig;
  routing: RoutingConfig;
  security: SecurityConfig;
  performance: PerformanceConfig;
  monitoring: MonitoringConfig;
}

interface RoutingConfig {
  defaultStrategy: LoadBalancingStrategy;
  healthCheckInterval: number;
  circuitBreaker: CircuitBreakerConfig;
  retryPolicy: RetryPolicyConfig;
  caching: CachingConfig;
}

// Configuration validation and loading
class ConfigurationManager {
  private config: ToolRouterConfig;
  private validator: ConfigValidator;

  async loadConfiguration(configPath: string): Promise<ToolRouterConfig> {
    const rawConfig = await this.loadRawConfig(configPath);
    const validatedConfig = await this.validator.validate(rawConfig);

    this.config = this.applyDefaults(validatedConfig);
    return this.config;
  }

  private applyDefaults(config: Partial<ToolRouterConfig>): ToolRouterConfig {
    return {
      server: {
        port: 3000,
        host: '0.0.0.0',
        keepAliveTimeout: 65000,
        headersTimeout: 66000,
        ...config.server
      },
      routing: {
        defaultStrategy: LoadBalancingStrategy.LEAST_RESPONSE_TIME,
        healthCheckInterval: 30000,
        circuitBreaker: {
          failureThreshold: 5,
          successThreshold: 3,
          timeout: 30000
        },
        retryPolicy: {
          maxRetries: 3,
          backoffMultiplier: 2,
          initialDelay: 1000
        },
        caching: {
          ttl: 300000,
          maxSize: 1000
        },
        ...config.routing
      },
      security: {
        authentication: {
          jwt: {
            secret: process.env.JWT_SECRET!,
            expiresIn: '24h'
          }
        },
        authorization: {
          enableRBAC: true,
          enableABAC: true
        },
        rateLimit: {
          windowMs: 900000,
          max: 100
        },
        ...config.security
      },
      performance: {
        connectionPool: {
          minConnections: 5,
          maxConnections: 20,
          acquireTimeout: 10000,
          createTimeout: 5000,
          idleTimeout: 30000,
          reapInterval: 1000
        },
        batching: {
          enabled: true,
          maxBatchSize: 10,
          flushInterval: 100
        },
        compression: {
          enabled: true,
          threshold: 1024,
          algorithm: 'gzip'
        },
        ...config.performance
      },
      monitoring: {
        metrics: {
          enabled: true,
          port: 9090,
          path: '/metrics'
        },
        health: {
          enabled: true,
          path: '/health',
          checkInterval: 30000
        },
        logging: {
          level: 'info',
          format: 'json'
        },
        ...config.monitoring
      }
    };
  }
}
```

## Summary

The Tool Router Service provides a comprehensive, scalable, and secure foundation for tool management and execution within the Claude ecosystem. Its architecture prioritizes:

- **Intelligent Routing**: Advanced capability matching and load balancing
- **High Availability**: Circuit breaking, failover, and health monitoring
- **Performance**: Connection pooling, caching, and request batching
- **Security**: Multi-layer authentication, authorization, and audit logging
- **Observability**: Comprehensive metrics, logging, and alerting
- **Scalability**: Horizontal scaling support with container deployment

The service acts as the critical infrastructure component that enables efficient, reliable, and secure tool execution across the entire Claude ecosystem.