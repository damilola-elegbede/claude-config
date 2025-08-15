import { EventEmitter } from 'events';

// =============================================================================
// Core Interfaces
// =============================================================================

/**
 * Circuit breaker state
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
 * Failure event data
 */
export interface FailureEvent {
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
 * State change event data
 */
export interface StateChangeEvent {
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
// Circuit Breaker Implementation
// =============================================================================

/**
 * Circuit breaker implementation for fault tolerance
 *
 * Implements the circuit breaker pattern to prevent cascading failures
 * and provide fast failure detection for degraded services.
 */
class CircuitBreaker extends EventEmitter {
  private readonly config: Required<CircuitBreakerConfig>;
  private state: CircuitBreakerState = 'closed';
  private failureCount = 0;
  private successCount = 0;
  private totalCalls = 0;
  private successfulCalls = 0;
  private failedCalls = 0;
  private rejectedCalls = 0;
  private lastFailureTime?: Date;
  private lastStateChange = new Date();
  private halfOpenCalls = 0;
  private responseTimeSum = 0;
  private recentFailures: Date[] = [];

  constructor(config: CircuitBreakerConfig) {
    super();

    this.config = {
      failureThreshold: config.failureThreshold,
      recoveryTimeout: config.recoveryTimeout,
      halfOpenMaxCalls: config.halfOpenMaxCalls,
      monitoringWindow: config.monitoringWindow,
      successThreshold: config.successThreshold || Math.ceil(config.halfOpenMaxCalls / 2),
      name: config.name || 'CircuitBreaker'
    };

    // Validate configuration
    this.validateConfig();
  }

  /**
   * Execute a function with circuit breaker protection
   */
  async execute<T>(fn: () => Promise<T>): Promise<CircuitBreakerResult<T>> {
    const startTime = Date.now();
    const timestamp = new Date();

    // Check if circuit should allow execution
    if (!this.canExecute()) {
      this.rejectedCalls++;
      const result: CircuitBreakerResult<T> = {
        executed: false,
        state: this.state,
        error: new Error(`Circuit breaker ${this.config.name} is ${this.state}`),
        timestamp
      };

      this.emit('callRejected', {
        name: this.config.name,
        state: this.state,
        timestamp
      });

      return result;
    }

    this.totalCalls++;

    // Track half-open calls
    if (this.state === 'half-open') {
      this.halfOpenCalls++;
    }

    try {
      const value = await fn();
      const responseTime = Date.now() - startTime;

      // Record success
      this.onSuccess(responseTime);

      const result: CircuitBreakerResult<T> = {
        value,
        executed: true,
        state: this.state,
        timestamp,
        responseTime
      };

      this.emit('callSuccess', {
        name: this.config.name,
        responseTime,
        state: this.state,
        timestamp
      });

      return result;
    } catch (error) {
      const responseTime = Date.now() - startTime;

      // Record failure
      this.onFailure(error as Error, responseTime);

      const result: CircuitBreakerResult<T> = {
        executed: true,
        state: this.state,
        error: error as Error,
        timestamp,
        responseTime
      };

      this.emit('callFailure', {
        name: this.config.name,
        error: error as Error,
        responseTime,
        state: this.state,
        timestamp
      });

      return result;
    }
  }

  /**
   * Force circuit breaker to open state
   */
  forceOpen(reason: string = 'Manually forced open'): void {
    this.changeState('open', reason);
  }

  /**
   * Force circuit breaker to closed state
   */
  forceClosed(reason: string = 'Manually forced closed'): void {
    this.reset();
    this.changeState('closed', reason);
  }

  /**
   * Reset circuit breaker to initial state
   */
  reset(): void {
    this.failureCount = 0;
    this.successCount = 0;
    this.halfOpenCalls = 0;
    this.lastFailureTime = undefined;
    this.recentFailures = [];
    this.changeState('closed', 'Reset to initial state');
  }

  /**
   * Get current circuit breaker statistics
   */
  getStats(): CircuitBreakerStats {
    const now = Date.now();
    const timeToRecovery = this.state === 'open' && this.lastFailureTime
      ? Math.max(0, this.config.recoveryTimeout - (now - this.lastFailureTime.getTime()))
      : undefined;

    return {
      state: this.state,
      totalCalls: this.totalCalls,
      successfulCalls: this.successfulCalls,
      failedCalls: this.failedCalls,
      rejectedCalls: this.rejectedCalls,
      failureRate: this.calculateFailureRate(),
      timeToRecovery,
      lastStateChange: this.lastStateChange,
      averageResponseTime: this.successfulCalls > 0 ? this.responseTimeSum / this.successfulCalls : 0
    };
  }

  /**
   * Get current state
   */
  getState(): CircuitBreakerState {
    return this.state;
  }

  /**
   * Get configuration
   */
  getConfig(): CircuitBreakerConfig {
    return { ...this.config };
  }

  // =============================================================================
  // Private Methods
  // =============================================================================

  private validateConfig(): void {
    if (this.config.failureThreshold <= 0) {
      throw new Error('Failure threshold must be greater than 0');
    }
    if (this.config.recoveryTimeout <= 0) {
      throw new Error('Recovery timeout must be greater than 0');
    }
    if (this.config.halfOpenMaxCalls <= 0) {
      throw new Error('Half-open max calls must be greater than 0');
    }
    if (this.config.monitoringWindow <= 0) {
      throw new Error('Monitoring window must be greater than 0');
    }
    if (this.config.successThreshold > this.config.halfOpenMaxCalls) {
      throw new Error('Success threshold cannot be greater than half-open max calls');
    }
  }

  private canExecute(): boolean {
    const now = Date.now();

    switch (this.state) {
      case 'closed':
        return true;

      case 'open':
        // Check if recovery timeout has passed
        if (this.lastFailureTime &&
            now - this.lastFailureTime.getTime() >= this.config.recoveryTimeout) {
          this.changeState('half-open', 'Recovery timeout elapsed');
          return true;
        }
        return false;

      case 'half-open':
        // Allow limited calls in half-open state
        return this.halfOpenCalls < this.config.halfOpenMaxCalls;

      default:
        return false;
    }
  }

  private onSuccess(responseTime: number): void {
    this.successfulCalls++;
    this.responseTimeSum += responseTime;

    if (this.state === 'half-open') {
      this.successCount++;

      // Check if we have enough successes to close the circuit
      if (this.successCount >= this.config.successThreshold) {
        this.changeState('closed', 'Sufficient successful calls in half-open state');
        this.reset();
      }
    } else if (this.state === 'closed') {
      // Reset failure count on success in closed state
      this.failureCount = 0;
    }
  }

  private onFailure(error: Error, responseTime: number): void {
    this.failedCalls++;
    this.failureCount++;
    this.lastFailureTime = new Date();
    this.recentFailures.push(this.lastFailureTime);

    // Clean up old failures outside monitoring window
    this.cleanupOldFailures();

    // Emit failure event
    this.emit('failure', {
      name: this.config.name,
      error,
      responseTime,
      failureCount: this.failureCount,
      threshold: this.config.failureThreshold,
      timestamp: this.lastFailureTime
    } as FailureEvent);

    if (this.state === 'closed') {
      // Check if we should open the circuit
      if (this.shouldOpen()) {
        this.changeState('open', `Failure threshold exceeded (${this.failureCount}/${this.config.failureThreshold})`);
      }
    } else if (this.state === 'half-open') {
      // Any failure in half-open state opens the circuit
      this.changeState('open', 'Failure in half-open state');
      this.halfOpenCalls = 0;
      this.successCount = 0;
    }
  }

  private shouldOpen(): boolean {
    // Simple threshold-based check
    if (this.failureCount >= this.config.failureThreshold) {
      return true;
    }

    // Rate-based check within monitoring window
    const recentFailureCount = this.recentFailures.length;
    if (recentFailureCount >= this.config.failureThreshold) {
      const failureRate = recentFailureCount / Math.max(this.totalCalls, 1);
      return failureRate >= 0.5; // 50% failure rate
    }

    return false;
  }

  private calculateFailureRate(): number {
    if (this.totalCalls === 0) return 0;
    return this.failedCalls / this.totalCalls;
  }

  private cleanupOldFailures(): void {
    const cutoffTime = Date.now() - this.config.monitoringWindow;
    this.recentFailures = this.recentFailures.filter(
      failureTime => failureTime.getTime() > cutoffTime
    );
  }

  private changeState(newState: CircuitBreakerState, reason: string): void {
    const previousState = this.state;
    this.state = newState;
    this.lastStateChange = new Date();

    // Reset counters when changing state
    if (newState === 'half-open') {
      this.halfOpenCalls = 0;
      this.successCount = 0;
    }

    // Emit state change event
    this.emit('stateChange', {
      name: this.config.name,
      previousState,
      newState,
      reason,
      timestamp: this.lastStateChange
    } as StateChangeEvent);

    console.log(`Circuit breaker ${this.config.name}: ${previousState} -> ${newState} (${reason})`);
  }
}

// =============================================================================
// Circuit Breaker Manager
// =============================================================================

/**
 * Manager for multiple circuit breakers
 */
class CircuitBreakerManager extends EventEmitter {
  private circuitBreakers: Map<string, CircuitBreaker> = new Map();
  private defaultConfig: CircuitBreakerConfig;

  constructor(defaultConfig?: Partial<CircuitBreakerConfig>) {
    super();

    this.defaultConfig = {
      failureThreshold: 5,
      recoveryTimeout: 30000, // 30 seconds
      halfOpenMaxCalls: 3,
      monitoringWindow: 60000, // 1 minute
      successThreshold: 2,
      ...defaultConfig
    };
  }

  /**
   * Get or create a circuit breaker for a service
   */
  getCircuitBreaker(name: string, config?: Partial<CircuitBreakerConfig>): CircuitBreaker {
    let circuitBreaker = this.circuitBreakers.get(name);

    if (!circuitBreaker) {
      circuitBreaker = new CircuitBreaker({
        ...this.defaultConfig,
        ...config,
        name
      });

      // Forward events from individual circuit breakers
      circuitBreaker.on('stateChange', (event) => {
        this.emit('stateChange', event);
      });
      circuitBreaker.on('failure', (event) => {
        this.emit('failure', event);
      });
      circuitBreaker.on('callRejected', (event) => {
        this.emit('callRejected', event);
      });

      this.circuitBreakers.set(name, circuitBreaker);
    }

    return circuitBreaker;
  }

  /**
   * Get all circuit breakers
   */
  getAllCircuitBreakers(): Map<string, CircuitBreaker> {
    return new Map(this.circuitBreakers);
  }

  /**
   * Get circuit breaker statistics for all services
   */
  getAllStats(): Record<string, CircuitBreakerStats> {
    const stats: Record<string, CircuitBreakerStats> = {};

    for (const [name, cb] of this.circuitBreakers) {
      stats[name] = cb.getStats();
    }

    return stats;
  }

  /**
   * Force all circuit breakers to closed state
   */
  resetAll(): void {
    for (const circuitBreaker of this.circuitBreakers.values()) {
      circuitBreaker.reset();
    }
    this.emit('allReset');
  }

  /**
   * Remove a circuit breaker
   */
  removeCircuitBreaker(name: string): boolean {
    const circuitBreaker = this.circuitBreakers.get(name);
    if (circuitBreaker) {
      circuitBreaker.removeAllListeners();
      this.circuitBreakers.delete(name);
      this.emit('circuitBreakerRemoved', { name });
      return true;
    }
    return false;
  }

  /**
   * Update default configuration
   */
  updateDefaultConfig(config: Partial<CircuitBreakerConfig>): void {
    this.defaultConfig = { ...this.defaultConfig, ...config };
    this.emit('defaultConfigUpdated', this.defaultConfig);
  }

  /**
   * Cleanup all circuit breakers
   */
  destroy(): void {
    for (const circuitBreaker of this.circuitBreakers.values()) {
      circuitBreaker.removeAllListeners();
    }
    this.circuitBreakers.clear();
    this.removeAllListeners();
  }
}

// =============================================================================
// Exports
// =============================================================================

export type {
  CircuitBreakerConfig,
  CircuitBreakerResult,
  CircuitBreakerStats,
  FailureEvent,
  StateChangeEvent
};

export {
  CircuitBreaker,
  CircuitBreakerManager
};
