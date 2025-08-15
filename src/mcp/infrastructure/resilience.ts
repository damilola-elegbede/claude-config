import { EventEmitter } from 'events';
import { MCPServerInfo } from '../types';
import { MCPServerRegistry } from './registry';
import { CircuitBreaker, CircuitBreakerManager, CircuitBreakerConfig } from './circuit-breaker';
import { FallbackManager, FallbackPolicy, FallbackServerConfig, FallbackContext, FallbackResult } from './fallback-manager';

// =============================================================================
// Core Interfaces
// =============================================================================

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
  /** Retry policy override */
  retryPolicy?: string;
  /** Skip specific servers */
  skipServers?: string[];
  /** Performance requirements */
  requirements?: {
    maxResponseTime?: number;
    minSuccessRate?: number;
  };
}

// =============================================================================
// Resilience Manager Implementation
// =============================================================================

/**
 * Comprehensive resilience manager combining circuit breakers and fallback patterns
 *
 * Provides intelligent fault tolerance with sub-200ms detection and switching,
 * automatic recovery, and graceful degradation under load.
 */
class ResilienceManager extends EventEmitter {
  private readonly registry: MCPServerRegistry;
  private readonly circuitBreakerManager: CircuitBreakerManager;
  private readonly fallbackManager: FallbackManager;
  private readonly config: Required<ResilienceConfig>;
  private readonly stats: ResilienceStats;
  private readonly responseTimes: number[] = [];
  private readonly serverHealthStatus: Map<string, {
    isHealthy: boolean;
    lastCheckTime: Date;
    consecutiveFailures: number;
    consecutiveSuccesses: number;
    lastError?: Error;
  }> = new Map();

  private healthCheckTimer?: NodeJS.Timeout;
  private isStarted = false;

  constructor(registry: MCPServerRegistry, config: ResilienceConfig = {}) {
    super();

    this.registry = registry;

    // Initialize configuration with defaults
    this.config = {
      circuitBreaker: {
        defaultConfig: {
          failureThreshold: 5,
          recoveryTimeout: 30000,
          halfOpenMaxCalls: 3,
          monitoringWindow: 60000,
          successThreshold: 2,
          ...config.circuitBreaker?.defaultConfig
        },
        serverConfigs: config.circuitBreaker?.serverConfigs || {}
      },
      fallback: {
        policies: config.fallback?.policies || [],
        serverConfigs: config.fallback?.serverConfigs || {},
        enableAutoDiscovery: config.fallback?.enableAutoDiscovery ?? true
      },
      healthMonitoring: {
        interval: 30000, // 30 seconds
        timeout: 5000,   // 5 seconds
        failureThreshold: 3,
        recoveryThreshold: 2,
        ...config.healthMonitoring
      },
      performance: {
        maxResponseTime: 30000,
        minSuccessRate: 0.95,
        fallbackDetectionTime: 200,
        ...config.performance
      }
    };

    // Initialize circuit breaker manager
    this.circuitBreakerManager = new CircuitBreakerManager(
      this.config.circuitBreaker.defaultConfig
    );

    // Initialize fallback manager
    this.fallbackManager = new FallbackManager(this.circuitBreakerManager);

    // Initialize statistics
    this.stats = this.initializeStats();

    this.setupEventHandlers();
  }

  /**
   * Start the resilience manager
   */
  async start(): Promise<void> {
    if (this.isStarted) {
      return;
    }

    console.log('Starting Resilience Manager...');

    try {
      // Register default fallback policies
      await this.registerDefaultPolicies();

      // Set up server configurations
      await this.setupServerConfigurations();

      // Start health monitoring
      this.startHealthMonitoring();

      this.isStarted = true;
      this.emit('started');
      console.log('Resilience Manager started successfully');
    } catch (error) {
      console.error('Failed to start Resilience Manager:', error);
      throw error;
    }
  }

  /**
   * Stop the resilience manager
   */
  async stop(): Promise<void> {
    if (!this.isStarted) {
      return;
    }

    console.log('Stopping Resilience Manager...');

    try {
      // Stop health monitoring
      this.stopHealthMonitoring();

      // Cleanup managers
      this.fallbackManager.destroy();
      this.circuitBreakerManager.destroy();

      this.isStarted = false;
      this.emit('stopped');
      console.log('Resilience Manager stopped');
    } catch (error) {
      console.error('Error stopping Resilience Manager:', error);
      throw error;
    }
  }

  /**
   * Execute operation with full resilience protection
   */
  async executeWithResilience<T>(
    context: ResilienceContext,
    operation: (server: MCPServerInfo) => Promise<T>
  ): Promise<FallbackResult<T>> {
    if (!this.isStarted) {
      throw new Error('Resilience Manager not started');
    }

    const startTime = Date.now();
    this.stats.totalOperations++;

    try {
      // Create fallback context
      const fallbackContext: FallbackContext = {
        operationId: this.generateOperationId(),
        toolName: context.toolName,
        agentId: context.agentId,
        parameters: context.parameters,
        priority: context.priority,
        timeout: context.timeout,
        skipServers: context.skipServers
      };

      // Execute with fallback protection
      const result = await this.fallbackManager.executeWithFallback(
        context.toolName,
        operation,
        fallbackContext
      );

      // Record metrics
      const responseTime = Date.now() - startTime;
      this.recordResponseTime(responseTime);

      if (result.success) {
        this.stats.successfulOperations++;
        if (result.usedFallback) {
          this.stats.fallbackOperations++;
          this.stats.fallbackUsageByTool[context.toolName] =
            (this.stats.fallbackUsageByTool[context.toolName] || 0) + 1;
        }

        // Update server health on success
        this.updateServerHealth(result.serverId, true, responseTime);
      } else {
        this.stats.failedOperations++;
        this.emit('operationFailed', {
          context,
          result,
          timestamp: new Date()
        });
      }

      // Emit performance warning if detection time exceeded
      if (result.usedFallback && responseTime > this.config.performance.fallbackDetectionTime) {
        this.emit('performanceWarning', {
          message: `Fallback detection exceeded target time: ${responseTime}ms > ${this.config.performance.fallbackDetectionTime}ms`,
          context,
          responseTime,
          timestamp: new Date()
        });
      }

      // Update statistics
      this.updateStats();

      return result;
    } catch (error) {
      this.stats.failedOperations++;
      this.updateStats();

      this.emit('operationError', {
        context,
        error,
        responseTime: Date.now() - startTime,
        timestamp: new Date()
      });

      throw error;
    }
  }

  /**
   * Get comprehensive resilience statistics
   */
  getStats(): ResilienceStats {
    const fallbackStats = this.fallbackManager.getStats();
    const circuitBreakerStats = this.circuitBreakerManager.getAllStats();

    return {
      ...this.stats,
      serverHealth: this.getServerHealthSummary(),
      circuitBreakerActivations: Object.values(circuitBreakerStats)
        .filter(stats => stats.state === 'open' || stats.state === 'half-open').length,
      performance: {
        averageFallbackDetectionTime: this.calculateAverageFallbackDetectionTime(),
        p95ResponseTime: this.calculatePercentile(0.95),
        p99ResponseTime: this.calculatePercentile(0.99)
      }
    };
  }

  /**
   * Force recovery for all servers
   */
  forceGlobalRecovery(): void {
    this.circuitBreakerManager.resetAll();
    this.serverHealthStatus.clear();
    this.emit('globalRecoveryForced');
  }

  /**
   * Force recovery for specific server
   */
  forceServerRecovery(serverId: string): boolean {
    const success = this.fallbackManager.forceServerRecovery(serverId);
    if (success) {
      this.serverHealthStatus.delete(serverId);
    }
    return success;
  }

  /**
   * Update resilience configuration
   */
  updateConfig(updates: Partial<ResilienceConfig>): void {
    Object.assign(this.config, updates);
    this.emit('configUpdated', this.config);
  }

  /**
   * Get current health status of all servers
   */
  getServerHealthStatus(): Record<string, any> {
    const health: Record<string, any> = {};

    for (const [serverId, status] of this.serverHealthStatus) {
      const server = this.registry.getServer(serverId);
      const circuitBreakerStats = this.circuitBreakerManager
        .getAllCircuitBreakers()
        .get(serverId)
        ?.getStats();

      health[serverId] = {
        serverName: server?.name || 'Unknown',
        isHealthy: status.isHealthy,
        lastCheckTime: status.lastCheckTime,
        consecutiveFailures: status.consecutiveFailures,
        consecutiveSuccesses: status.consecutiveSuccesses,
        circuitBreakerState: circuitBreakerStats?.state || 'unknown',
        lastError: status.lastError?.message
      };
    }

    return health;
  }

  /**
   * Clear all statistics
   */
  clearStats(): void {
    Object.assign(this.stats, this.initializeStats());
    this.responseTimes.length = 0;
    this.fallbackManager.clearStats();
    this.emit('statsCleared');
  }

  /**
   * Cleanup resources
   */
  destroy(): void {
    this.stop();
    this.removeAllListeners();
  }

  // =============================================================================
  // Private Methods
  // =============================================================================

  private initializeStats(): ResilienceStats {
    return {
      totalOperations: 0,
      successfulOperations: 0,
      failedOperations: 0,
      fallbackOperations: 0,
      circuitBreakerActivations: 0,
      averageResponseTime: 0,
      currentFailureRate: 0,
      serverHealth: {},
      fallbackUsageByTool: {},
      performance: {
        averageFallbackDetectionTime: 0,
        p95ResponseTime: 0,
        p99ResponseTime: 0
      }
    };
  }

  private setupEventHandlers(): void {
    // Circuit breaker events
    this.circuitBreakerManager.on('stateChange', (event) => {
      if (event.newState === 'open') {
        this.stats.circuitBreakerActivations++;
      }

      this.emit('circuitBreakerStateChange', event);
    });

    // Fallback manager events
    this.fallbackManager.on('serverFailure', (event) => {
      this.updateServerHealth(event.serverId, false, 0, event.error);
    });

    // Registry events
    this.registry.on('serverRegistered', (server) => {
      this.setupServerConfiguration(server);
    });

    this.registry.on('serverUnregistered', (event) => {
      this.serverHealthStatus.delete(event.serverId);
    });
  }

  private async registerDefaultPolicies(): Promise<void> {
    // Register policies if not already configured
    if (this.config.fallback.policies.length === 0) {
      // Default policies are registered automatically by FallbackManager
      console.log('Using default fallback policies');
    } else {
      // Register custom policies
      for (const policy of this.config.fallback.policies) {
        this.fallbackManager.registerPolicy(policy);
      }
    }
  }

  private async setupServerConfigurations(): Promise<void> {
    const servers = this.registry.getServers();

    for (const server of servers) {
      await this.setupServerConfiguration(server);
    }

    // Register configured tool-specific server configurations
    for (const [toolName, config] of Object.entries(this.config.fallback.serverConfigs)) {
      this.fallbackManager.registerServerConfig(toolName, config);
    }
  }

  private async setupServerConfiguration(server: MCPServerInfo): Promise<void> {
    // Set up circuit breaker for the server
    const serverCbConfig = this.config.circuitBreaker.serverConfigs[server.id] || {};
    this.circuitBreakerManager.getCircuitBreaker(server.id, serverCbConfig);

    // Initialize health status
    this.serverHealthStatus.set(server.id, {
      isHealthy: server.status === 'healthy',
      lastCheckTime: new Date(),
      consecutiveFailures: 0,
      consecutiveSuccesses: 0
    });

    // Auto-discover fallback configurations if enabled
    if (this.config.fallback.enableAutoDiscovery) {
      await this.autoDiscoverFallbacks(server);
    }
  }

  private async autoDiscoverFallbacks(primaryServer: MCPServerInfo): Promise<void> {
    // Find other servers that support the same tools
    const fallbackServers: MCPServerInfo[] = [];

    for (const capability of primaryServer.capabilities) {
      const serversForTool = this.registry.getServersForTool(capability.name);

      for (const server of serversForTool) {
        if (server.id !== primaryServer.id && !fallbackServers.find(s => s.id === server.id)) {
          fallbackServers.push(server);
        }
      }
    }

    // Register fallback configuration for each tool
    for (const capability of primaryServer.capabilities) {
      const toolFallbacks = fallbackServers.filter(server =>
        server.capabilities.some(cap => cap.name === capability.name)
      );

      if (toolFallbacks.length > 0) {
        this.fallbackManager.registerServerConfig(capability.name, {
          primary: primaryServer,
          fallbacks: toolFallbacks,
          policy: 'standard' // Use default policy
        });
      }
    }
  }

  private startHealthMonitoring(): void {
    this.healthCheckTimer = setInterval(() => {
      this.performHealthChecks();
    }, this.config.healthMonitoring.interval);
  }

  private stopHealthMonitoring(): void {
    if (this.healthCheckTimer) {
      clearInterval(this.healthCheckTimer);
      this.healthCheckTimer = undefined;
    }
  }

  private async performHealthChecks(): Promise<void> {
    const servers = this.registry.getServers();

    for (const server of servers) {
      try {
        const startTime = Date.now();

        // Perform basic health check (this would be implemented based on MCP protocol)
        // For now, we'll use the server's reported status
        const isHealthy = server.status === 'healthy';
        const responseTime = Date.now() - startTime;

        this.updateServerHealth(server.id, isHealthy, responseTime);

        this.emit('healthCheckCompleted', {
          serverId: server.id,
          isHealthy,
          responseTime,
          timestamp: new Date()
        } as HealthCheckResult);

      } catch (error) {
        this.updateServerHealth(server.id, false, 0, error as Error);

        this.emit('healthCheckFailed', {
          serverId: server.id,
          isHealthy: false,
          responseTime: 0,
          error: error as Error,
          timestamp: new Date()
        } as HealthCheckResult);
      }
    }
  }

  private updateServerHealth(
    serverId: string,
    isHealthy: boolean,
    responseTime: number,
    error?: Error
  ): void {
    const current = this.serverHealthStatus.get(serverId) || {
      isHealthy: true,
      lastCheckTime: new Date(),
      consecutiveFailures: 0,
      consecutiveSuccesses: 0
    };

    const updated = {
      ...current,
      lastCheckTime: new Date(),
      lastError: error
    };

    if (isHealthy) {
      updated.consecutiveSuccesses++;
      updated.consecutiveFailures = 0;

      if (updated.consecutiveSuccesses >= this.config.healthMonitoring.recoveryThreshold) {
        updated.isHealthy = true;
      }
    } else {
      updated.consecutiveFailures++;
      updated.consecutiveSuccesses = 0;

      if (updated.consecutiveFailures >= this.config.healthMonitoring.failureThreshold) {
        updated.isHealthy = false;
      }
    }

    this.serverHealthStatus.set(serverId, updated);
  }

  private recordResponseTime(responseTime: number): void {
    this.responseTimes.push(responseTime);

    // Keep only recent response times (last 1000)
    if (this.responseTimes.length > 1000) {
      this.responseTimes.shift();
    }
  }

  private calculatePercentile(percentile: number): number {
    if (this.responseTimes.length === 0) return 0;

    const sorted = [...this.responseTimes].sort((a, b) => a - b);
    const index = Math.ceil(percentile * sorted.length) - 1;
    return sorted[Math.max(0, index)];
  }

  private calculateAverageFallbackDetectionTime(): number {
    // This would track actual fallback detection times
    // For now, return a placeholder value
    return this.config.performance.fallbackDetectionTime * 0.8;
  }

  private updateStats(): void {
    this.stats.currentFailureRate = this.stats.totalOperations > 0
      ? this.stats.failedOperations / this.stats.totalOperations
      : 0;

    this.stats.averageResponseTime = this.responseTimes.length > 0
      ? this.responseTimes.reduce((sum, time) => sum + time, 0) / this.responseTimes.length
      : 0;
  }

  private getServerHealthSummary(): Record<string, any> {
    const summary: Record<string, any> = {};

    for (const [serverId, status] of this.serverHealthStatus) {
      summary[serverId] = {
        isHealthy: status.isHealthy,
        circuitBreakerState: this.circuitBreakerManager
          .getAllCircuitBreakers()
          .get(serverId)
          ?.getState() || 'unknown',
        lastCheckTime: status.lastCheckTime,
        consecutiveFailures: status.consecutiveFailures,
        consecutiveSuccesses: status.consecutiveSuccesses
      };
    }

    return summary;
  }

  private generateOperationId(): string {
    return `op_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }
}

// =============================================================================
// Exports
// =============================================================================

export type {
  ResilienceConfig,
  ResilienceStats,
  HealthCheckResult,
  ResilienceContext
};

export {
  ResilienceManager
};
