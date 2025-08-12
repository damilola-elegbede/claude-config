import { EventEmitter } from 'events';
import { MCPServerInfo } from '../types';
import { CircuitBreaker, CircuitBreakerManager } from './circuit-breaker';

// =============================================================================
// Core Interfaces
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
    circuitBreakerConfig?: any;
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
 * Execution log entry
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

// =============================================================================
// Retry Logic with Exponential Backoff
// =============================================================================

/**
 * Retry handler with exponential backoff and jitter
 */
export class RetryHandler {
  /**
   * Calculate retry delay with exponential backoff and optional jitter
   */
  static calculateDelay(
    attempt: number,
    baseDelay: number,
    maxDelay: number,
    multiplier: number,
    useJitter: boolean = true
  ): number {
    // Calculate exponential backoff
    const exponentialDelay = Math.min(
      baseDelay * Math.pow(multiplier, attempt - 1),
      maxDelay
    );

    if (!useJitter) {
      return exponentialDelay;
    }

    // Add jitter (±25% of the calculated delay)
    const jitterRange = exponentialDelay * 0.25;
    const jitter = (Math.random() - 0.5) * 2 * jitterRange;
    
    return Math.max(0, exponentialDelay + jitter);
  }

  /**
   * Sleep for specified duration
   */
  static async sleep(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  /**
   * Execute operation with retry logic
   */
  static async executeWithRetry<T>(
    operation: () => Promise<T>,
    policy: FallbackPolicy,
    onRetry?: (attempt: number, error: Error) => void
  ): Promise<T> {
    let lastError: Error = new Error('Unknown error');

    for (let attempt = 1; attempt <= policy.maxRetries + 1; attempt++) {
      try {
        return await operation();
      } catch (error) {
        lastError = error as Error;

        // Don't retry if this was the last attempt
        if (attempt > policy.maxRetries) {
          break;
        }

        // Calculate delay and wait
        const delay = this.calculateDelay(
          attempt,
          policy.baseRetryDelay,
          policy.maxRetryDelay,
          policy.backoffMultiplier,
          policy.useJitter
        );

        if (onRetry) {
          onRetry(attempt, lastError);
        }

        await this.sleep(delay);
      }
    }

    throw lastError;
  }
}

// =============================================================================
// Fallback Manager Implementation
// =============================================================================

/**
 * Fallback manager for automatic server failover and recovery
 * 
 * Provides automatic fallback to alternative MCP servers with circuit breaker
 * integration and intelligent retry mechanisms.
 */
class FallbackManager extends EventEmitter {
  private policies: Map<string, FallbackPolicy> = new Map();
  private serverConfigs: Map<string, FallbackServerConfig> = new Map();
  private circuitBreakerManager: CircuitBreakerManager;
  private stats: FallbackStats;

  constructor(circuitBreakerManager?: CircuitBreakerManager) {
    super();
    
    this.circuitBreakerManager = circuitBreakerManager || new CircuitBreakerManager();
    this.stats = this.initializeStats();
    
    // Set up default policies
    this.setupDefaultPolicies();
    
    // Listen to circuit breaker events
    this.circuitBreakerManager.on('stateChange', (event) => {
      this.emit('circuitBreakerStateChange', event);
    });
  }

  /**
   * Register a fallback policy
   */
  registerPolicy(policy: FallbackPolicy): void {
    this.policies.set(policy.name, policy);
    this.emit('policyRegistered', { name: policy.name });
  }

  /**
   * Register a server configuration with fallbacks
   */
  registerServerConfig(toolName: string, config: FallbackServerConfig): void {
    this.serverConfigs.set(toolName, config);
    
    // Register circuit breakers for all servers if enabled
    const policy = this.policies.get(config.policy);
    if (policy?.enableCircuitBreaker) {
      const cbConfig = config.options?.circuitBreakerConfig || {};
      
      // Register circuit breaker for primary server
      this.circuitBreakerManager.getCircuitBreaker(config.primary.id, cbConfig);
      
      // Register circuit breakers for fallback servers
      for (const fallback of config.fallbacks) {
        this.circuitBreakerManager.getCircuitBreaker(fallback.id, cbConfig);
      }
    }

    this.emit('serverConfigRegistered', { toolName, config });
  }

  /**
   * Execute operation with automatic fallback
   */
  async executeWithFallback<T>(
    toolName: string,
    operation: (server: MCPServerInfo) => Promise<T>,
    context: FallbackContext
  ): Promise<FallbackResult<T>> {
    const startTime = Date.now();
    const executionLog: FallbackExecutionEntry[] = [];
    let totalAttempts = 0;

    try {
      this.stats.totalOperations++;

      // Get server configuration
      const serverConfig = this.serverConfigs.get(toolName);
      if (!serverConfig) {
        throw new Error(`No server configuration found for tool: ${toolName}`);
      }

      // Get policy
      const policy = this.policies.get(serverConfig.policy);
      if (!policy) {
        throw new Error(`Policy not found: ${serverConfig.policy}`);
      }

      // Build list of servers to try (primary + fallbacks)
      const serversToTry = [serverConfig.primary, ...serverConfig.fallbacks]
        .filter(server => !context.skipServers?.includes(server.id));

      if (serversToTry.length === 0) {
        throw new Error('No available servers to try');
      }

      // Try each server in order
      for (const server of serversToTry) {
        const serverStartTime = Date.now();
        
        try {
          totalAttempts++;

          // Check circuit breaker if enabled
          if (policy.enableCircuitBreaker) {
            const circuitBreaker = this.circuitBreakerManager.getCircuitBreaker(server.id);
            
            const cbResult = await circuitBreaker.execute(async () => {
              return await this.executeWithTimeout(
                () => operation(server),
                context.timeout || policy.operationTimeout
              );
            });

            if (!cbResult.executed) {
              throw cbResult.error || new Error('Circuit breaker rejected execution');
            }

            if (cbResult.value !== undefined) {
              // Success!
              const executionTime = Date.now() - serverStartTime;
              const totalTime = Date.now() - startTime;

              executionLog.push({
                serverId: server.id,
                serverName: server.name,
                success: true,
                executionTime,
                circuitBreakerState: circuitBreaker.getState(),
                timestamp: new Date()
              });

              this.updateSuccessStats(server.id, totalTime, totalAttempts, executionLog.length > 1);

              return {
                value: cbResult.value,
                success: true,
                serverId: server.id,
                serverName: server.name,
                attempts: totalAttempts,
                totalTime,
                usedFallback: executionLog.length > 1,
                executionLog
              };
            }
          } else {
            // Execute without circuit breaker
            const result = await this.executeWithTimeout(
              () => operation(server),
              context.timeout || policy.operationTimeout
            );

            const executionTime = Date.now() - serverStartTime;
            const totalTime = Date.now() - startTime;

            executionLog.push({
              serverId: server.id,
              serverName: server.name,
              success: true,
              executionTime,
              timestamp: new Date()
            });

            this.updateSuccessStats(server.id, totalTime, totalAttempts, executionLog.length > 1);

            return {
              value: result,
              success: true,
              serverId: server.id,
              serverName: server.name,
              attempts: totalAttempts,
              totalTime,
              usedFallback: executionLog.length > 1,
              executionLog
            };
          }
        } catch (error) {
          const executionTime = Date.now() - serverStartTime;
          const errorObj = error as Error;

          executionLog.push({
            serverId: server.id,
            serverName: server.name,
            success: false,
            executionTime,
            error: errorObj,
            circuitBreakerState: policy.enableCircuitBreaker 
              ? this.circuitBreakerManager.getCircuitBreaker(server.id).getState()
              : undefined,
            timestamp: new Date()
          });

          this.emit('serverFailure', {
            serverId: server.id,
            serverName: server.name,
            toolName,
            error: errorObj,
            attempt: totalAttempts,
            timestamp: new Date()
          });

          // If this is not the last server, continue to next fallback
          if (server !== serversToTry[serversToTry.length - 1]) {
            console.warn(`Server ${server.name} failed, trying fallback...`, errorObj.message);
            continue;
          }

          // This was the last server, operation failed
          throw errorObj;
        }
      }

      // Should not reach here
      throw new Error('All fallback servers failed');

    } catch (error) {
      const totalTime = Date.now() - startTime;
      this.updateFailureStats(totalTime, totalAttempts, executionLog.length > 1);

      return {
        success: false,
        serverId: '',
        serverName: '',
        attempts: totalAttempts,
        totalTime,
        error: error as Error,
        usedFallback: executionLog.length > 1,
        executionLog
      };
    }
  }

  /**
   * Get fallback statistics
   */
  getStats(): FallbackStats {
    return {
      ...this.stats,
      circuitBreakerStates: this.getCircuitBreakerStates()
    };
  }

  /**
   * Get server health status
   */
  getServerHealth(): Record<string, {
    isHealthy: boolean;
    circuitBreakerState: string;
    stats: any;
  }> {
    const health: Record<string, any> = {};
    
    for (const [serverId, circuitBreaker] of this.circuitBreakerManager.getAllCircuitBreakers()) {
      const stats = circuitBreaker.getStats();
      health[serverId] = {
        isHealthy: stats.state === 'closed',
        circuitBreakerState: stats.state,
        stats
      };
    }
    
    return health;
  }

  /**
   * Force recovery for a specific server
   */
  forceServerRecovery(serverId: string): boolean {
    const circuitBreaker = this.circuitBreakerManager.getAllCircuitBreakers().get(serverId);
    if (circuitBreaker) {
      circuitBreaker.forceClosed('Manual recovery');
      this.emit('serverRecoveryForced', { serverId });
      return true;
    }
    return false;
  }

  /**
   * Update policy configuration
   */
  updatePolicy(name: string, updates: Partial<FallbackPolicy>): boolean {
    const policy = this.policies.get(name);
    if (!policy) {
      return false;
    }

    const updatedPolicy = { ...policy, ...updates };
    this.policies.set(name, updatedPolicy);
    this.emit('policyUpdated', { name, policy: updatedPolicy });
    return true;
  }

  /**
   * Clear all statistics
   */
  clearStats(): void {
    this.stats = this.initializeStats();
    this.emit('statsCleared');
  }

  /**
   * Cleanup resources
   */
  destroy(): void {
    this.circuitBreakerManager.destroy();
    this.policies.clear();
    this.serverConfigs.clear();
    this.removeAllListeners();
  }

  // =============================================================================
  // Private Methods
  // =============================================================================

  private setupDefaultPolicies(): void {
    // Standard policy for most operations
    this.registerPolicy({
      name: 'standard',
      maxRetries: 3,
      baseRetryDelay: 1000,
      maxRetryDelay: 10000,
      backoffMultiplier: 2,
      useJitter: true,
      operationTimeout: 30000,
      enableCircuitBreaker: true
    });

    // Fast policy for low-latency operations
    this.registerPolicy({
      name: 'fast',
      maxRetries: 2,
      baseRetryDelay: 500,
      maxRetryDelay: 5000,
      backoffMultiplier: 1.5,
      useJitter: true,
      operationTimeout: 10000,
      enableCircuitBreaker: true
    });

    // Reliable policy for critical operations
    this.registerPolicy({
      name: 'reliable',
      maxRetries: 5,
      baseRetryDelay: 2000,
      maxRetryDelay: 30000,
      backoffMultiplier: 2.5,
      useJitter: true,
      operationTimeout: 60000,
      enableCircuitBreaker: true
    });
  }

  private async executeWithTimeout<T>(
    operation: () => Promise<T>,
    timeoutMs: number
  ): Promise<T> {
    return new Promise((resolve, reject) => {
      const timeout = setTimeout(() => {
        reject(new Error(`Operation timed out after ${timeoutMs}ms`));
      }, timeoutMs);

      operation()
        .then(result => {
          clearTimeout(timeout);
          resolve(result);
        })
        .catch(error => {
          clearTimeout(timeout);
          reject(error);
        });
    });
  }

  private initializeStats(): FallbackStats {
    return {
      totalOperations: 0,
      successfulOperations: 0,
      failedOperations: 0,
      fallbackOperations: 0,
      averageExecutionTime: 0,
      averageAttempts: 0,
      serverSuccessRates: {},
      circuitBreakerStates: {}
    };
  }

  private updateSuccessStats(
    serverId: string,
    executionTime: number,
    attempts: number,
    usedFallback: boolean
  ): void {
    this.stats.successfulOperations++;
    if (usedFallback) {
      this.stats.fallbackOperations++;
    }

    // Update averages
    this.stats.averageExecutionTime = 
      (this.stats.averageExecutionTime * (this.stats.successfulOperations - 1) + executionTime) / 
      this.stats.successfulOperations;

    this.stats.averageAttempts = 
      (this.stats.averageAttempts * (this.stats.totalOperations - 1) + attempts) / 
      this.stats.totalOperations;

    // Update server success rates
    const currentRate = this.stats.serverSuccessRates[serverId] || 0;
    this.stats.serverSuccessRates[serverId] = Math.min(1, currentRate + 0.1);
  }

  private updateFailureStats(
    executionTime: number,
    attempts: number,
    usedFallback: boolean
  ): void {
    this.stats.failedOperations++;
    if (usedFallback) {
      this.stats.fallbackOperations++;
    }

    this.stats.averageAttempts = 
      (this.stats.averageAttempts * (this.stats.totalOperations - 1) + attempts) / 
      this.stats.totalOperations;
  }

  private getCircuitBreakerStates(): Record<string, string> {
    const states: Record<string, string> = {};
    
    for (const [serverId, circuitBreaker] of this.circuitBreakerManager.getAllCircuitBreakers()) {
      states[serverId] = circuitBreaker.getState();
    }
    
    return states;
  }
}

// =============================================================================
// Exports
// =============================================================================

export type {
  FallbackPolicy,
  FallbackServerConfig,
  FallbackContext,
  FallbackResult,
  FallbackExecutionEntry,
  FallbackStats
};

export {
  RetryHandler,
  FallbackManager
};