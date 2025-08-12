/**
 * MCP Infrastructure Type Definitions
 * 
 * Comprehensive TypeScript interfaces for the MCP infrastructure system.
 * Provides strict typing for all components and operations.
 */

import { ChildProcess } from 'child_process';

// =============================================================================
// Core MCP Types
// =============================================================================

/**
 * MCP Server Configuration from Claude Code settings
 */
export interface MCPServerConfig {
  /** Command to execute (e.g., 'npx', 'uv') */
  command: string;
  /** Command arguments */
  args: string[];
  /** Environment variables for the server process */
  env?: Record<string, string>;
  /** Working directory for the server process */
  cwd?: string;
  /** Server-specific options */
  options?: Record<string, any>;
}

/**
 * Server status enumeration
 */
export type ServerStatus = 'healthy' | 'degraded' | 'failed' | 'unknown' | 'starting' | 'stopping';

/**
 * Tool capability definition
 */
export interface ToolCapability {
  /** Unique tool name */
  name: string;
  /** Human-readable description */
  description?: string;
  /** JSON schema for input parameters */
  inputSchema?: Record<string, any>;
  /** JSON schema for output format */
  outputSchema?: Record<string, any>;
  /** Tool category (filesystem, git, web, etc.) */
  category?: string;
  /** Required permissions */
  permissions?: string[];
  /** Estimated execution time in milliseconds */
  estimatedExecutionTime?: number;
}

/**
 * Complete MCP server information
 */
export interface MCPServerInfo {
  /** Unique server identifier */
  id: string;
  /** Human-readable server name */
  name: string;
  /** Server configuration */
  config: MCPServerConfig;
  /** Current server status */
  status: ServerStatus;
  /** Available tool capabilities */
  capabilities: ToolCapability[];
  /** Last health check timestamp */
  lastHealthCheck: Date;
  /** Last response time in milliseconds */
  responseTime: number;
  /** Consecutive failure count */
  failureCount: number;
  /** Server process reference */
  process?: ChildProcess;
  /** Server metadata */
  metadata?: ServerMetadata;
}

/**
 * Server metadata and additional information
 */
export interface ServerMetadata {
  /** Server version */
  version?: string;
  /** Server description */
  description?: string;
  /** Server vendor/author */
  vendor?: string;
  /** Supported MCP protocol version */
  protocolVersion?: string;
  /** Server tags for categorization */
  tags?: string[];
  /** Resource requirements */
  resources?: ResourceRequirements;
}

/**
 * Server resource requirements
 */
export interface ResourceRequirements {
  /** Memory requirement in MB */
  memory?: number;
  /** CPU requirement (0-1 representing percentage) */
  cpu?: number;
  /** Disk space requirement in MB */
  disk?: number;
  /** Network bandwidth requirement in Mbps */
  bandwidth?: number;
}

// =============================================================================
// Performance and Metrics Types
// =============================================================================

/**
 * Server performance metrics
 */
export interface ServerMetrics {
  /** Total number of requests processed */
  totalRequests: number;
  /** Number of successful requests */
  successfulRequests: number;
  /** Number of failed requests */
  failedRequests: number;
  /** Average response time in milliseconds */
  averageResponseTime: number;
  /** Timestamp of last request */
  lastRequestTime?: Date;
  /** Server uptime percentage (0-100) */
  uptimePercentage: number;
  /** Current load factor (0-1) */
  load: number;
  /** Memory usage in MB */
  memoryUsage?: number;
  /** CPU usage percentage (0-100) */
  cpuUsage?: number;
  /** Throughput (requests per second) */
  throughput?: number;
  /** Error rate percentage (0-100) */
  errorRate?: number;
}

/**
 * Historical metrics data point
 */
export interface MetricsDataPoint {
  /** Timestamp of the measurement */
  timestamp: Date;
  /** Partial metrics snapshot */
  metrics: Partial<ServerMetrics>;
}

/**
 * Performance benchmark results
 */
export interface PerformanceBenchmark {
  /** Benchmark name */
  name: string;
  /** Server ID being benchmarked */
  serverId: string;
  /** Tool name being tested */
  toolName: string;
  /** Number of test iterations */
  iterations: number;
  /** Average execution time */
  averageTime: number;
  /** Minimum execution time */
  minTime: number;
  /** Maximum execution time */
  maxTime: number;
  /** Standard deviation */
  standardDeviation: number;
  /** Success rate (0-1) */
  successRate: number;
  /** Benchmark timestamp */
  timestamp: Date;
}

// =============================================================================
// Registry Types
// =============================================================================

/**
 * Tool to server mapping
 */
export interface ToolMapping {
  /** Tool name */
  toolName: string;
  /** List of server IDs that support this tool */
  serverIds: string[];
  /** Preferred server ID for this tool */
  preferredServerId?: string;
  /** Tool-specific metadata */
  metadata?: ToolMappingMetadata;
}

/**
 * Tool mapping metadata
 */
export interface ToolMappingMetadata {
  /** Tool usage frequency */
  usageFrequency?: number;
  /** Last used timestamp */
  lastUsed?: Date;
  /** User preferences */
  userPreferences?: Record<string, any>;
  /** Performance history */
  performanceHistory?: PerformanceBenchmark[];
}

/**
 * Registry query parameters
 */
export interface RegistryQuery {
  /** Filter by tool name */
  toolName?: string;
  /** Filter by server status */
  serverStatus?: ServerStatus;
  /** Filter by required capabilities */
  capabilities?: string[];
  /** Filter by minimum uptime percentage */
  minUptimePercentage?: number;
  /** Filter by maximum response time */
  maxResponseTime?: number;
  /** Filter by server tags */
  tags?: string[];
  /** Filter by minimum throughput */
  minThroughput?: number;
  /** Sort criteria */
  sortBy?: 'performance' | 'uptime' | 'responseTime' | 'load';
  /** Sort direction */
  sortDirection?: 'asc' | 'desc';
  /** Limit results */
  limit?: number;
}

/**
 * Registry statistics
 */
export interface RegistryStats {
  /** Total number of registered servers */
  totalServers: number;
  /** Number of healthy servers */
  healthyServers: number;
  /** Number of degraded servers */
  degradedServers: number;
  /** Number of failed servers */
  failedServers: number;
  /** Total number of available tools */
  totalTools: number;
  /** Average response time across all servers */
  averageResponseTime: number;
  /** Total requests processed */
  totalRequests: number;
  /** Overall system load (0-1) */
  systemLoad: number;
  /** Memory usage across all servers */
  totalMemoryUsage: number;
}

// =============================================================================
// Configuration Types
// =============================================================================

/**
 * Discovery service configuration options
 */
export interface DiscoveryOptions {
  /** Path to Claude Code settings.json */
  settingsPath?: string;
  /** Discovery interval in milliseconds */
  discoveryInterval?: number;
  /** Health check interval in milliseconds */
  healthCheckInterval?: number;
  /** Health check timeout in milliseconds */
  healthCheckTimeout?: number;
  /** Maximum failures before marking server as failed */
  maxFailures?: number;
  /** Enable auto-recovery attempts */
  enableAutoRecovery?: boolean;
  /** Recovery check interval in milliseconds */
  recoveryCheckInterval?: number;
}

/**
 * Registry configuration options
 */
export interface ServerRegistryOptions {
  /** Maximum metrics history entries per server */
  maxMetricsHistory?: number;
  /** Metrics retention period in milliseconds */
  metricsRetentionPeriod?: number;
  /** Enable state persistence */
  enablePersistence?: boolean;
  /** Persistence interval in milliseconds */
  persistenceInterval?: number;
  /** Redis connection options */
  redisOptions?: RedisOptions;
}

/**
 * Redis configuration options
 */
export interface RedisOptions {
  /** Redis host */
  host?: string;
  /** Redis port */
  port?: number;
  /** Redis password */
  password?: string;
  /** Redis database number */
  db?: number;
  /** Connection timeout */
  connectTimeout?: number;
  /** Key prefix for MCP data */
  keyPrefix?: string;
}

// =============================================================================
// Event Types
// =============================================================================

/**
 * Base event interface
 */
export interface BaseEvent {
  /** Event timestamp */
  timestamp: Date;
  /** Event source */
  source: string;
  /** Event ID */
  eventId: string;
}

/**
 * Server discovery events
 */
export interface ServerDiscoveredEvent extends BaseEvent {
  /** Discovered server information */
  server: MCPServerInfo;
}

export interface ServerErrorEvent extends BaseEvent {
  /** Server name */
  name: string;
  /** Error that occurred */
  error: Error;
}

export interface DiscoveryCompleteEvent extends BaseEvent {
  /** List of discovered servers */
  servers: MCPServerInfo[];
  /** Discovery time in milliseconds */
  discoveryTime: number;
  /** Number of servers discovered */
  serverCount: number;
}

/**
 * Server status events
 */
export interface ServerStatusChangedEvent extends BaseEvent {
  /** Server information */
  server: MCPServerInfo;
  /** Previous status */
  previousStatus: ServerStatus;
}

export interface ServerFailedEvent extends BaseEvent {
  /** Failed server */
  server: MCPServerInfo;
  /** Failure reason */
  error: Error;
}

export interface ServerRecoveredEvent extends BaseEvent {
  /** Recovered server */
  server: MCPServerInfo;
}

/**
 * Registry events
 */
export interface ServerRegisteredEvent extends BaseEvent {
  /** Registered server */
  server: MCPServerInfo;
}

export interface ServerUnregisteredEvent extends BaseEvent {
  /** Unregistered server ID */
  serverId: string;
  /** Server information before unregistration */
  server: MCPServerInfo;
}

export interface MetricsUpdatedEvent extends BaseEvent {
  /** Server ID */
  serverId: string;
  /** Updated metrics */
  metrics: ServerMetrics;
}

export interface PreferenceUpdatedEvent extends BaseEvent {
  /** Tool name */
  toolName: string;
  /** Preferred server ID */
  serverId: string;
}

/**
 * Performance events
 */
export interface PerformanceBenchmarkEvent extends BaseEvent {
  /** Benchmark results */
  benchmark: PerformanceBenchmark;
}

export interface PerformanceThresholdEvent extends BaseEvent {
  /** Server ID */
  serverId: string;
  /** Metric that exceeded threshold */
  metric: string;
  /** Current value */
  currentValue: number;
  /** Threshold value */
  threshold: number;
}

// =============================================================================
// Error Types
// =============================================================================

/**
 * MCP infrastructure error base class
 */
export abstract class MCPInfrastructureError extends Error {
  abstract readonly code: string;
  abstract readonly category: string;
  
  constructor(message: string, public readonly context?: Record<string, any>) {
    super(message);
    this.name = this.constructor.name;
  }
}

/**
 * Server discovery error
 */
export class ServerDiscoveryError extends MCPInfrastructureError {
  readonly code = 'SERVER_DISCOVERY_ERROR';
  readonly category = 'discovery';
}

/**
 * Server connection error
 */
export class ServerConnectionError extends MCPInfrastructureError {
  readonly code = 'SERVER_CONNECTION_ERROR';
  readonly category = 'connection';
}

/**
 * Server registry error
 */
export class ServerRegistryError extends MCPInfrastructureError {
  readonly code = 'SERVER_REGISTRY_ERROR';
  readonly category = 'registry';
}

/**
 * Performance monitoring error
 */
export class PerformanceMonitoringError extends MCPInfrastructureError {
  readonly code = 'PERFORMANCE_MONITORING_ERROR';
  readonly category = 'performance';
}

// =============================================================================
// Utility Types
// =============================================================================

/**
 * Partial deep type for configuration updates
 */
export type DeepPartial<T> = {
  [P in keyof T]?: T[P] extends object ? DeepPartial<T[P]> : T[P];
};

/**
 * Required subset of properties
 */
export type RequiredSubset<T, K extends keyof T> = T & Required<Pick<T, K>>;

/**
 * Event handler function type
 */
export type EventHandler<T = any> = (event: T) => void | Promise<void>;

/**
 * Async function type
 */
export type AsyncFunction<T = any, R = any> = (arg: T) => Promise<R>;

// =============================================================================
// Circuit Breaker Types
// =============================================================================

/**
 * Circuit breaker state enumeration
 */
export type CircuitBreakerState = 'closed' | 'open' | 'half-open';

/**
 * Circuit breaker configuration
 */
export interface CircuitBreakerConfig {
  /** Number of failures before opening circuit */
  failureThreshold: number;
  /** Time in ms before allowing recovery attempts */
  recoveryTimeout: number;
  /** Maximum number of test calls in half-open state */
  halfOpenMaxCalls: number;
  /** Time window in ms for monitoring failure rates */
  monitoringWindow: number;
  /** Success threshold for closing circuit from half-open */
  successThreshold: number;
  /** Custom name for this circuit breaker */
  name?: string;
}

/**
 * Circuit breaker execution result
 */
export interface CircuitBreakerResult<T> {
  /** The result value if successful */
  value?: T;
  /** Whether the operation was executed */
  executed: boolean;
  /** Circuit breaker state at time of execution */
  state: CircuitBreakerState;
  /** Error if operation failed */
  error?: Error;
  /** Execution timestamp */
  timestamp: Date;
  /** Response time in milliseconds */
  responseTime?: number;
}

/**
 * Circuit breaker statistics
 */
export interface CircuitBreakerStats {
  /** Current state */
  state: CircuitBreakerState;
  /** Total number of calls */
  totalCalls: number;
  /** Number of successful calls */
  successfulCalls: number;
  /** Number of failed calls */
  failedCalls: number;
  /** Number of rejected calls (circuit open) */
  rejectedCalls: number;
  /** Current failure rate (0-1) */
  failureRate: number;
  /** Time until next recovery attempt (if circuit is open) */
  timeToRecovery?: number;
  /** Last state change timestamp */
  lastStateChange: Date;
  /** Average response time */
  averageResponseTime: number;
}

/**
 * Circuit breaker failure event
 */
export interface CircuitBreakerFailureEvent {
  /** Circuit breaker name */
  name: string;
  /** Error that caused the failure */
  error: Error;
  /** Response time of failed operation */
  responseTime: number;
  /** Current failure count */
  failureCount: number;
  /** Failure threshold */
  threshold: number;
  /** Timestamp */
  timestamp: Date;
}

/**
 * Circuit breaker state change event
 */
export interface CircuitBreakerStateChangeEvent {
  /** Circuit breaker name */
  name: string;
  /** Previous state */
  previousState: CircuitBreakerState;
  /** New state */
  newState: CircuitBreakerState;
  /** Reason for state change */
  reason: string;
  /** Timestamp */
  timestamp: Date;
}

// =============================================================================
// Fallback and Resilience Types
// =============================================================================

/**
 * Fallback policy configuration
 */
export interface FallbackPolicy {
  /** Policy name */
  name: string;
  /** Maximum number of retry attempts */
  maxRetries: number;
  /** Base retry delay in milliseconds */
  baseRetryDelay: number;
  /** Maximum retry delay in milliseconds */
  maxRetryDelay: number;
  /** Exponential backoff multiplier */
  backoffMultiplier: number;
  /** Whether to use jitter in retry delays */
  useJitter: boolean;
  /** Timeout for individual operations */
  operationTimeout: number;
  /** Whether to enable circuit breaker integration */
  enableCircuitBreaker: boolean;
}

/**
 * Fallback server configuration
 */
export interface FallbackServerConfig {
  /** Primary server */
  primary: MCPServerInfo;
  /** Fallback servers in priority order */
  fallbacks: MCPServerInfo[];
  /** Policy to use for this configuration */
  policy: string;
  /** Custom options for this server group */
  options?: {
    /** Health check interval */
    healthCheckInterval?: number;
    /** Maximum concurrent operations */
    maxConcurrency?: number;
    /** Custom circuit breaker config */
    circuitBreakerConfig?: Partial<CircuitBreakerConfig>;
  };
}

/**
 * Fallback operation context
 */
export interface FallbackContext {
  /** Operation identifier */
  operationId: string;
  /** Tool name being executed */
  toolName: string;
  /** Agent making the request */
  agentId?: string;
  /** Operation parameters */
  parameters?: any;
  /** Priority level (1-10) */
  priority?: number;
  /** Custom timeout for this operation */
  timeout?: number;
  /** Whether to skip certain fallback servers */
  skipServers?: string[];
}

/**
 * Fallback operation result
 */
export interface FallbackResult<T> {
  /** The result value if successful */
  value?: T;
  /** Whether the operation succeeded */
  success: boolean;
  /** Server that provided the result */
  serverId: string;
  /** Server name */
  serverName: string;
  /** Number of attempts made */
  attempts: number;
  /** Total execution time */
  totalTime: number;
  /** Error if operation failed */
  error?: Error;
  /** Whether fallback was used */
  usedFallback: boolean;
  /** Detailed execution log */
  executionLog: FallbackExecutionEntry[];
}

/**
 * Fallback execution log entry
 */
export interface FallbackExecutionEntry {
  /** Server ID that was attempted */
  serverId: string;
  /** Server name */
  serverName: string;
  /** Whether this attempt succeeded */
  success: boolean;
  /** Execution time for this attempt */
  executionTime: number;
  /** Error if attempt failed */
  error?: Error;
  /** Circuit breaker state at time of attempt */
  circuitBreakerState?: string;
  /** Timestamp */
  timestamp: Date;
}

/**
 * Fallback statistics
 */
export interface FallbackStats {
  /** Total operations */
  totalOperations: number;
  /** Successful operations */
  successfulOperations: number;
  /** Failed operations */
  failedOperations: number;
  /** Operations that used fallback */
  fallbackOperations: number;
  /** Average execution time */
  averageExecutionTime: number;
  /** Average number of attempts per operation */
  averageAttempts: number;
  /** Success rate by server */
  serverSuccessRates: Record<string, number>;
  /** Circuit breaker states */
  circuitBreakerStates: Record<string, string>;
}

/**
 * Resilience configuration for the MCP infrastructure
 */
export interface ResilienceConfig {
  /** Circuit breaker configuration */
  circuitBreaker?: {
    /** Default circuit breaker settings */
    defaultConfig?: Partial<CircuitBreakerConfig>;
    /** Per-server circuit breaker configurations */
    serverConfigs?: Record<string, Partial<CircuitBreakerConfig>>;
  };
  
  /** Fallback configuration */
  fallback?: {
    /** Default fallback policies */
    policies?: FallbackPolicy[];
    /** Tool-specific server configurations */
    serverConfigs?: Record<string, FallbackServerConfig>;
    /** Enable automatic fallback discovery */
    enableAutoDiscovery?: boolean;
  };
  
  /** Health monitoring configuration */
  healthMonitoring?: {
    /** Health check interval in milliseconds */
    interval?: number;
    /** Health check timeout */
    timeout?: number;
    /** Number of consecutive failures before marking unhealthy */
    failureThreshold?: number;
    /** Number of consecutive successes before marking healthy */
    recoveryThreshold?: number;
  };
  
  /** Performance targets */
  performance?: {
    /** Maximum acceptable response time in ms */
    maxResponseTime?: number;
    /** Minimum required success rate (0-1) */
    minSuccessRate?: number;
    /** Detection and switch time for fallback (ms) */
    fallbackDetectionTime?: number;
  };
}

/**
 * Resilience statistics
 */
export interface ResilienceStats {
  /** Total operations processed */
  totalOperations: number;
  /** Successful operations */
  successfulOperations: number;
  /** Failed operations */
  failedOperations: number;
  /** Operations that used fallback */
  fallbackOperations: number;
  /** Circuit breaker activations */
  circuitBreakerActivations: number;
  /** Average response time */
  averageResponseTime: number;
  /** Current failure rate */
  currentFailureRate: number;
  /** Server health status */
  serverHealth: Record<string, {
    isHealthy: boolean;
    circuitBreakerState: string;
    lastCheckTime: Date;
    consecutiveFailures: number;
    consecutiveSuccesses: number;
  }>;
  /** Fallback usage by tool */
  fallbackUsageByTool: Record<string, number>;
  /** Performance metrics */
  performance: {
    averageFallbackDetectionTime: number;
    p95ResponseTime: number;
    p99ResponseTime: number;
  };
}

/**
 * Health check result
 */
export interface HealthCheckResult {
  /** Server ID */
  serverId: string;
  /** Whether server is healthy */
  isHealthy: boolean;
  /** Response time for health check */
  responseTime: number;
  /** Error if health check failed */
  error?: Error;
  /** Timestamp */
  timestamp: Date;
}

/**
 * Resilience operation context
 */
export interface ResilienceContext {
  /** Tool name */
  toolName: string;
  /** Agent ID */
  agentId?: string;
  /** Operation parameters */
  parameters?: any;
  /** Priority (1-10) */
  priority?: number;
  /** Custom timeout */
  timeout?: number;
  /** Retry configuration */
  retryConfig?: Partial<FallbackPolicy>;
}

// =============================================================================
// Tool Routing Types
// =============================================================================

/**
 * Routing decision result
 */
export interface RoutingDecision {
  /** Selected server for the tool */
  selectedServer: MCPServerInfo;
  /** Confidence score (0-1) for the decision */
  confidence: number;
  /** Reasoning for the selection */
  reasoning: string;
  /** Decision timestamp */
  timestamp: Date;
  /** Execution time for routing decision */
  decisionTime: number;
  /** Alternative servers considered */
  alternatives?: MCPServerInfo[];
}

/**
 * Routing context for decision making
 */
export interface RoutingContext {
  /** Tool name being requested */
  toolName: string;
  /** Agent making the request */
  agentId?: string;
  /** Request priority (1-10, 10 being highest) */
  priority?: number;
  /** Request parameters for optimization hints */
  parameters?: Record<string, any>;
  /** Performance requirements */
  requirements?: PerformanceRequirements;
  /** Timeout for routing decision */
  timeout?: number;
}

/**
 * Performance requirements for routing
 */
export interface PerformanceRequirements {
  /** Maximum acceptable response time in ms */
  maxResponseTime?: number;
  /** Minimum required success rate (0-1) */
  minSuccessRate?: number;
  /** Maximum acceptable server load (0-1) */
  maxLoad?: number;
  /** Required availability percentage */
  minAvailability?: number;
}

/**
 * Base routing strategy interface
 */
export interface RoutingStrategy {
  /** Strategy name */
  readonly name: string;
  /** Strategy description */
  readonly description: string;
  
  /**
   * Evaluate servers for routing decision
   */
  evaluate(
    candidates: MCPServerInfo[],
    context: RoutingContext
  ): Promise<RoutingDecision>;
}

/**
 * Strategy configuration
 */
export interface StrategyConfig {
  /** Strategy weights for scoring */
  weights: {
    performance: number;
    availability: number;
    load: number;
    preference: number;
  };
  /** Strategy-specific options */
  options?: Record<string, any>;
}

/**
 * Tool router configuration
 */
export interface ToolRouterConfig {
  /** Default routing strategy */
  defaultStrategy: string;
  /** Strategy configurations */
  strategies: Record<string, StrategyConfig>;
  /** Tool-specific routing overrides */
  toolOverrides?: Record<string, string>;
  /** Agent-specific routing preferences */
  agentPreferences?: Record<string, Record<string, string>>;
  /** Enable adaptive routing */
  enableAdaptiveRouting?: boolean;
  /** Routing decision timeout */
  decisionTimeout?: number;
  /** Enable routing telemetry */
  enableTelemetry?: boolean;
}

// =============================================================================
// Agent Preference Types
// =============================================================================

/**
 * Agent-specific preferences and optimization profile
 */
export interface AgentProfile {
  /** Unique agent identifier */
  agentId: string;
  /** Agent display name */
  name: string;
  /** Agent category (e.g., 'development', 'analysis', 'infrastructure') */
  category: string;
  /** Tool usage patterns */
  toolUsage: Map<string, ToolUsagePattern>;
  /** Performance preferences */
  preferences: AgentPreferences;
  /** Learning configuration */
  learning: LearningConfig;
  /** Profile metadata */
  metadata: AgentMetadata;
}

/**
 * Tool usage pattern for an agent
 */
export interface ToolUsagePattern {
  /** Tool name */
  toolName: string;
  /** Usage frequency (requests per hour) */
  frequency: number;
  /** Typical request size/complexity */
  typicalComplexity: number;
  /** Performance requirements */
  requirements: PerformanceRequirements;
  /** Historical satisfaction scores */
  satisfactionHistory: number[];
  /** Last used timestamp */
  lastUsed: Date;
}

/**
 * Agent performance preferences
 */
export interface AgentPreferences {
  /** Preferred response time threshold (ms) */
  responseTimeThreshold: number;
  /** Minimum acceptable success rate (0-1) */
  minSuccessRate: number;
  /** Maximum acceptable server load (0-1) */
  maxServerLoad: number;
  /** Preference weights for server selection */
  weights: PreferenceWeights;
  /** Manual server preferences */
  serverPreferences: Map<string, ServerPreference>;
}

/**
 * Preference weights for different factors
 */
export interface PreferenceWeights {
  /** Response time importance (0-1) */
  responseTime: number;
  /** Reliability importance (0-1) */
  reliability: number;
  /** Server load importance (0-1) */
  load: number;
  /** Historical satisfaction importance (0-1) */
  satisfaction: number;
}

/**
 * Manual server preference
 */
export interface ServerPreference {
  /** Server ID */
  serverId: string;
  /** Preference strength (-1 to 1, negative means avoid) */
  preference: number;
  /** Reason for preference */
  reason: string;
  /** When preference was set */
  setAt: Date;
  /** Preference expiry */
  expiresAt?: Date;
}

/**
 * Learning configuration for adaptation
 */
export interface LearningConfig {
  /** Learning rate for preference updates (0-1) */
  learningRate: number;
  /** Exponential moving average alpha for metrics */
  emaAlpha: number;
  /** Minimum samples before making learning updates */
  minSamples: number;
  /** Maximum history to retain */
  maxHistory: number;
  /** Enable automatic preference learning */
  enableAutoLearning: boolean;
}

/**
 * Agent metadata
 */
export interface AgentMetadata {
  /** Creation timestamp */
  createdAt: Date;
  /** Last activity timestamp */
  lastActivity: Date;
  /** Total requests made */
  totalRequests: number;
  /** Agent version */
  version?: string;
  /** Custom tags */
  tags?: string[];
}

/**
 * Performance learning data point
 */
export interface PerformanceLearning {
  /** Server ID */
  serverId: string;
  /** Tool name */
  toolName: string;
  /** Agent ID */
  agentId: string;
  /** Response time in ms */
  responseTime: number;
  /** Success indicator */
  success: boolean;
  /** User satisfaction score (0-1) */
  satisfaction?: number;
  /** Request timestamp */
  timestamp: Date;
  /** Request context */
  context?: Record<string, any>;
}

/**
 * Preference override for manual control
 */
export interface PreferenceOverride {
  /** Override ID */
  id: string;
  /** Target scope */
  scope: OverrideScope;
  /** Override type */
  type: 'prefer' | 'avoid' | 'require' | 'exclude';
  /** Override strength (0-1) */
  strength: number;
  /** Override reason */
  reason: string;
  /** Override expiry */
  expiresAt?: Date;
  /** Created by */
  createdBy: string;
  /** Created timestamp */
  createdAt: Date;
}

/**
 * Override scope definition
 */
export interface OverrideScope {
  /** Agent ID (null for global) */
  agentId?: string;
  /** Tool name (null for all tools) */
  toolName?: string;
  /** Server ID */
  serverId: string;
}

/**
 * Preference engine configuration
 */
export interface PreferenceEngineConfig {
  /** Default learning configuration */
  defaultLearning: LearningConfig;
  /** Enable cross-agent learning */
  enableCrossAgentLearning: boolean;
  /** Performance threshold for learning */
  performanceThreshold: number;
  /** Satisfaction decay factor */
  satisfactionDecay: number;
  /** Maximum preference overrides per agent */
  maxOverrides: number;
}

// =============================================================================
// Cache Types
// =============================================================================

/**
 * Cache entry with metadata and TTL
 */
export interface CacheEntry<T = any> {
  /** Cached value */
  value: T;
  /** Entry creation timestamp */
  createdAt: Date;
  /** Last access timestamp */
  lastAccessed: Date;
  /** Time to live in milliseconds */
  ttl: number;
  /** Entry expiration timestamp */
  expiresAt: Date;
  /** Access count */
  accessCount: number;
  /** Entry size in bytes (estimated) */
  size: number;
  /** Entry metadata */
  metadata?: Record<string, any>;
}

/**
 * Cache statistics
 */
export interface CacheStats {
  /** Total cache hits */
  hits: number;
  /** Total cache misses */
  misses: number;
  /** Cache hit ratio (0-1) */
  hitRatio: number;
  /** Total entries in cache */
  entryCount: number;
  /** Total cache size in bytes */
  totalSize: number;
  /** Memory usage percentage (0-1) */
  memoryUsage: number;
  /** Average entry age in milliseconds */
  averageAge: number;
  /** Most accessed keys */
  topKeys: Array<{ key: string; accessCount: number }>;
  /** Cache operations per second */
  operationsPerSecond: number;
}

/**
 * Cache configuration options
 */
export interface CacheConfig {
  /** Maximum number of entries */
  maxEntries: number;
  /** Maximum cache size in bytes */
  maxSize: number;
  /** Default TTL in milliseconds */
  defaultTtl: number;
  /** Enable Redis fallback */
  enableRedis: boolean;
  /** Redis configuration */
  redis?: RedisConfig;
  /** Eviction policy */
  evictionPolicy: 'lru' | 'lfu' | 'ttl' | 'random';
  /** Statistics collection interval */
  statsInterval: number;
  /** Background cleanup interval */
  cleanupInterval: number;
  /** Enable compression for large values */
  enableCompression: boolean;
  /** Compression threshold in bytes */
  compressionThreshold: number;
}

/**
 * Redis configuration
 */
export interface RedisConfig {
  /** Redis host */
  host: string;
  /** Redis port */
  port: number;
  /** Redis password */
  password?: string;
  /** Redis database number */
  db: number;
  /** Connection timeout */
  connectTimeout: number;
  /** Key prefix for MCP cache */
  keyPrefix: string;
  /** Enable Redis cluster mode */
  enableCluster: boolean;
  /** Cluster nodes (if cluster mode) */
  clusterNodes?: Array<{ host: string; port: number }>;
}

/**
 * Cache operation result
 */
export interface CacheOperation<T = any> {
  /** Operation success indicator */
  success: boolean;
  /** Cached value (if successful) */
  value?: T;
  /** Operation source */
  source: 'memory' | 'redis' | 'miss';
  /** Operation duration in milliseconds */
  duration: number;
  /** Error message (if failed) */
  error?: string;
}

/**
 * Cache key pattern for organized storage
 */
export interface CacheKeyPattern {
  /** Pattern namespace */
  namespace: string;
  /** Pattern type */
  type: string;
  /** Pattern identifier */
  id: string;
  /** Additional parameters */
  params?: Record<string, string>;
}

/**
 * Redis client interface for dependency injection
 */
export interface RedisClient {
  get(key: string): Promise<string | null>;
  set(key: string, value: string, ttl?: number): Promise<void>;
  del(key: string): Promise<number>;
  exists(key: string): Promise<number>;
  keys(pattern: string): Promise<string[]>;
  flushdb(): Promise<void>;
  ping(): Promise<string>;
  disconnect(): Promise<void>;
}

// =============================================================================
// Exports
// =============================================================================

// =============================================================================
// Tool Execution Types
// =============================================================================

/**
 * Tool execution request
 */
export interface ToolExecutionRequest {
  /** Tool name to execute */
  toolName: string;
  /** Tool parameters */
  parameters: Record<string, any>;
  /** Agent making the request */
  agentId?: string;
  /** Request ID for tracking */
  requestId: string;
  /** Request priority (1-10) */
  priority?: number;
  /** Request timeout in milliseconds */
  timeout?: number;
  /** Performance requirements */
  requirements?: PerformanceRequirements;
}

/**
 * Tool execution response
 */
export interface ToolExecutionResponse<T = any> {
  /** Request ID */
  requestId: string;
  /** Whether execution succeeded */
  success: boolean;
  /** Execution result */
  result?: T;
  /** Error if execution failed */
  error?: Error;
  /** Server that handled the request */
  serverId: string;
  /** Execution time in milliseconds */
  executionTime: number;
  /** Response timestamp */
  timestamp: Date;
  /** Additional metadata */
  metadata?: {
    /** Circuit breaker state */
    circuitBreakerState?: CircuitBreakerState;
    /** Whether fallback was used */
    usedFallback?: boolean;
    /** Routing decision details */
    routingDecision?: RoutingDecision;
  };
}

/**
 * Tool execution context
 */
export interface ToolExecutionContext {
  /** Original request */
  request: ToolExecutionRequest;
  /** Selected server */
  server: MCPServerInfo;
  /** Routing decision */
  routingDecision: RoutingDecision;
  /** Circuit breaker instance */
  circuitBreaker?: any;
  /** Cache manager instance */
  cacheManager?: any;
  /** Start timestamp */
  startTime: Date;
}

// =============================================================================
// Branded Types for Type Safety
// =============================================================================

/**
 * Branded server ID for type safety
 */
export type ServerID = string & { readonly __brand: 'ServerID' };

/**
 * Branded agent ID for type safety
 */
export type AgentID = string & { readonly __brand: 'AgentID' };

/**
 * Branded tool name for type safety
 */
export type ToolName = string & { readonly __brand: 'ToolName' };

/**
 * Branded request ID for type safety
 */
export type RequestID = string & { readonly __brand: 'RequestID' };

// =============================================================================
// Infrastructure Configuration Types
// =============================================================================

/**
 * Complete MCP infrastructure configuration
 */
export interface MCPInfrastructureConfig {
  /** Discovery service configuration */
  discovery: DiscoveryOptions;
  /** Registry configuration */
  registry: ServerRegistryOptions;
  /** Circuit breaker configuration */
  circuitBreaker: {
    /** Default configuration */
    default: CircuitBreakerConfig;
    /** Per-server overrides */
    servers?: Record<string, Partial<CircuitBreakerConfig>>;
  };
  /** Tool router configuration */
  router: ToolRouterConfig;
  /** Cache configuration */
  cache: CacheConfig;
  /** Resilience configuration */
  resilience: ResilienceConfig;
  /** Preference engine configuration */
  preferences: PreferenceEngineConfig;
  /** Enable telemetry and monitoring */
  telemetry?: {
    /** Enable performance monitoring */
    enablePerformanceMonitoring?: boolean;
    /** Enable error tracking */
    enableErrorTracking?: boolean;
    /** Enable usage analytics */
    enableUsageAnalytics?: boolean;
    /** Telemetry export interval */
    exportInterval?: number;
  };
}

// Re-export all types for clean imports
export type {
  // Core types
  MCPServerConfig,
  ServerStatus,
  ToolCapability,
  MCPServerInfo,
  ServerMetadata,
  ResourceRequirements,
  
  // Metrics types
  ServerMetrics,
  MetricsDataPoint,
  PerformanceBenchmark,
  
  // Registry types
  ToolMapping,
  ToolMappingMetadata,
  RegistryQuery,
  RegistryStats,
  
  // Configuration types
  DiscoveryOptions,
  ServerRegistryOptions,
  RedisOptions,
  
  // Event types
  BaseEvent,
  ServerDiscoveredEvent,
  ServerErrorEvent,
  DiscoveryCompleteEvent,
  ServerStatusChangedEvent,
  ServerFailedEvent,
  ServerRecoveredEvent,
  ServerRegisteredEvent,
  ServerUnregisteredEvent,
  MetricsUpdatedEvent,
  PreferenceUpdatedEvent,
  PerformanceBenchmarkEvent,
  PerformanceThresholdEvent,
  
  // Circuit breaker types
  CircuitBreakerState,
  CircuitBreakerConfig,
  CircuitBreakerResult,
  CircuitBreakerStats,
  CircuitBreakerFailureEvent,
  CircuitBreakerStateChangeEvent,
  
  // Fallback and resilience types
  FallbackPolicy,
  FallbackServerConfig,
  FallbackContext,
  FallbackResult,
  FallbackExecutionEntry,
  FallbackStats,
  ResilienceConfig,
  ResilienceStats,
  HealthCheckResult,
  ResilienceContext,
  
  // Tool routing types
  RoutingDecision,
  RoutingContext,
  PerformanceRequirements,
  RoutingStrategy,
  StrategyConfig,
  ToolRouterConfig,
  
  // Agent preference types
  AgentProfile,
  ToolUsagePattern,
  AgentPreferences,
  PreferenceWeights,
  ServerPreference,
  LearningConfig,
  AgentMetadata,
  PerformanceLearning,
  PreferenceOverride,
  OverrideScope,
  PreferenceEngineConfig,
  
  // Cache types
  CacheEntry,
  CacheStats,
  CacheConfig,
  RedisConfig,
  CacheOperation,
  CacheKeyPattern,
  RedisClient,
  
  // Tool execution types
  ToolExecutionRequest,
  ToolExecutionResponse,
  ToolExecutionContext,
  
  // Branded types
  ServerID,
  AgentID,
  ToolName,
  RequestID,
  
  // Infrastructure configuration
  MCPInfrastructureConfig,
  
  // Utility types
  DeepPartial,
  RequiredSubset,
  EventHandler,
  AsyncFunction
};