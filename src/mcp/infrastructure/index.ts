/**
 * MCP Infrastructure Main Export
 *
 * Provides unified access to all MCP infrastructure components with integration examples
 */

import { MCPDiscoveryService } from './discovery';
import { MCPServerRegistry } from './registry';
import { ToolRouter } from './tool-router';
import { PreferenceEngine } from './preference-engine';
import { CacheManager } from './cache-manager';
import { ResilienceManager, ResilienceConfig } from './resilience';
import { CircuitBreakerManager } from './circuit-breaker';
import { FallbackManager } from './fallback-manager';

// =============================================================================
// Integrated MCP Infrastructure
// =============================================================================

/**
 * Integrated MCP Infrastructure configuration
 */
export interface MCPInfrastructureConfig {
  /** Discovery service options */
  discovery?: {
    settingsPath?: string;
    discoveryInterval?: number;
    healthCheckInterval?: number;
  };

  /** Registry options */
  registry?: {
    enablePersistence?: boolean;
    persistenceInterval?: number;
  };

  /** Router configuration */
  router?: {
    defaultStrategy?: string;
    enableCaching?: boolean;
    cacheTtl?: number;
  };

  /** Preference engine options */
  preferences?: {
    enableAutoLearning?: boolean;
    learningRate?: number;
  };

  /** Cache manager options */
  cache?: {
    maxEntries?: number;
    maxSize?: number;
    enableRedis?: boolean;
  };

  /** Resilience configuration */
  resilience?: ResilienceConfig;
}

/**
 * Integrated MCP Infrastructure class
 * Orchestrates all components and provides unified interface
 */
export class MCPInfrastructure {
  public readonly discovery: MCPDiscoveryService;
  public readonly registry: MCPServerRegistry;
  public readonly router: ToolRouter;
  public readonly preferences: PreferenceEngine;
  public readonly cache: CacheManager;
  public readonly resilience: ResilienceManager;

  private isStarted = false;

  constructor(config: MCPInfrastructureConfig = {}) {
    // Initialize cache first (others may depend on it)
    this.cache = new CacheManager(config.cache);

    // Initialize registry
    this.registry = new MCPServerRegistry(config.registry);

    // Initialize discovery service
    this.discovery = new MCPDiscoveryService(config.discovery);

    // Initialize preference engine
    this.preferences = new PreferenceEngine(this.registry, config.preferences);

    // Initialize router with integrated components
    this.router = new ToolRouter(this.registry, {
      ...config.router,
      // Integrate with cache for routing decisions
      enableCaching: config.router?.enableCaching ?? true
    });

    // Initialize resilience manager
    this.resilience = new ResilienceManager(this.registry, config.resilience);

    this.setupIntegrations();
  }

  /**
   * Start all infrastructure components
   */
  async start(): Promise<void> {
    if (this.isStarted) {
      throw new Error('MCP Infrastructure is already started');
    }

    console.log('Starting MCP Infrastructure...');

    try {
      // Start discovery service (this will populate the registry)
      await this.discovery.start();

      // Start resilience manager
      await this.resilience.start();

      console.log('MCP Infrastructure started successfully');
      this.isStarted = true;
    } catch (error) {
      console.error('Failed to start MCP Infrastructure:', error);
      throw error;
    }
  }

  /**
   * Stop all infrastructure components
   */
  async stop(): Promise<void> {
    if (!this.isStarted) {
      return;
    }

    console.log('Stopping MCP Infrastructure...');

    try {
      await this.discovery.stop();
      await this.resilience.stop();
      this.router.destroy();
      this.preferences.destroy();
      await this.cache.destroy();
      this.registry.destroy();

      this.isStarted = false;
      console.log('MCP Infrastructure stopped');
    } catch (error) {
      console.error('Error stopping MCP Infrastructure:', error);
      throw error;
    }
  }

  /**
   * Route a tool request with full intelligence and resilience
   */
  async routeTool(toolName: string, agentId?: string, options?: {
    priority?: number;
    timeout?: number;
    requirements?: {
      maxResponseTime?: number;
      minSuccessRate?: number;
    };
  }) {
    if (!this.isStarted) {
      throw new Error('MCP Infrastructure not started');
    }

    // Get agent preferences
    const preferences = await this.preferences.getPreferences(
      agentId || 'default',
      toolName
    );

    // Route the request
    const decision = await this.router.route({
      toolName,
      agentId,
      priority: options?.priority,
      timeout: options?.timeout,
      requirements: {
        ...preferences.requirements,
        ...options?.requirements
      }
    });

    return decision;
  }

  /**
   * Execute a tool with full resilience protection
   */
  async executeToolWithResilience<T>(
    toolName: string,
    operation: (server: any) => Promise<T>,
    options?: {
      agentId?: string;
      priority?: number;
      timeout?: number;
      skipServers?: string[];
      requirements?: {
        maxResponseTime?: number;
        minSuccessRate?: number;
      };
    }
  ) {
    if (!this.isStarted) {
      throw new Error('MCP Infrastructure not started');
    }

    return await this.resilience.executeWithResilience({
      toolName,
      agentId: options?.agentId,
      priority: options?.priority,
      timeout: options?.timeout,
      skipServers: options?.skipServers,
      requirements: options?.requirements
    }, operation);
  }

  /**
   * Learn from tool execution performance
   */
  async recordPerformance(data: {
    serverId: string;
    toolName: string;
    agentId: string;
    responseTime: number;
    success: boolean;
    satisfaction?: number;
  }): Promise<void> {
    // Update server metrics in registry
    const metrics = this.registry.getServerMetrics(data.serverId);
    if (metrics) {
      this.registry.updateServerMetrics(data.serverId, {
        totalRequests: metrics.totalRequests + 1,
        successfulRequests: data.success
          ? metrics.successfulRequests + 1
          : metrics.successfulRequests,
        failedRequests: !data.success
          ? metrics.failedRequests + 1
          : metrics.failedRequests,
        averageResponseTime: data.responseTime, // Will be recalculated by registry
        lastRequestTime: new Date()
      });
    }

    // Learn preferences
    await this.preferences.learn({
      serverId: data.serverId,
      toolName: data.toolName,
      agentId: data.agentId,
      responseTime: data.responseTime,
      success: data.success,
      satisfaction: data.satisfaction,
      timestamp: new Date()
    });
  }

  /**
   * Get comprehensive system status
   */
  getSystemStatus(): {
    isStarted: boolean;
    discoveredServers: number;
    healthyServers: number;
    registryStats: any;
    cacheStats: any;
    preferenceStats: any;
    resilienceStats: any;
  } {
    const registryStats = this.registry.getRegistryStats();

    return {
      isStarted: this.isStarted,
      discoveredServers: this.discovery.getServers().length,
      healthyServers: this.discovery.getServersByStatus('healthy').length,
      registryStats,
      cacheStats: this.cache['memoryCache']?.getStats() || {},
      preferenceStats: this.preferences.getLearningStats(),
      resilienceStats: this.isStarted ? this.resilience.getStats() : {}
    };
  }

  // =============================================================================
  // Private Integration Setup
  // =============================================================================

  private setupIntegrations(): void {
    // Discovery -> Registry integration
    this.discovery.on('serverDiscovered', (server) => {
      this.registry.registerServer(server);
    });

    this.discovery.on('serverFailed', ({ server }) => {
      // Could remove from registry or mark as failed
      console.log(`Server ${server.name} failed, updating status`);
    });

    // Router -> Cache integration (if needed for custom caching logic)
    this.router.on('routingDecision', async (decision) => {
      // Cache frequently accessed routing decisions
      const cacheKey = `routing:${decision.selectedServer.id}:${Date.now()}`;
      // Custom caching logic could go here
    });

    // Preferences -> Cache integration
    this.preferences.on('preferenceUpdated', (update) => {
      // Invalidate routing cache when preferences change
      this.cache.invalidatePattern(`routing:*:${update.agentId}:*`);
    });

    // Resilience -> Registry integration
    this.resilience.on('operationFailed', (event) => {
      console.warn(`Operation failed for tool ${event.context.toolName}:`, event.result.error?.message);
    });

    this.resilience.on('circuitBreakerStateChange', (event) => {
      console.log(`Circuit breaker ${event.name}: ${event.previousState} -> ${event.newState} (${event.reason})`);
    });

    console.log('MCP Infrastructure integrations configured');
  }
}

// =============================================================================
// Usage Example
// =============================================================================

/**
 * Example usage of the integrated MCP infrastructure
 */
export async function exampleUsage(): Promise<void> {
  // Initialize infrastructure
  const infrastructure = new MCPInfrastructure({
    discovery: {
      discoveryInterval: 30000,
      healthCheckInterval: 10000
    },
    router: {
      defaultStrategy: 'performance_weighted',
      enableCaching: true,
      cacheTtl: 30000
    },
    preferences: {
      enableAutoLearning: true,
      learningRate: 0.1
    },
    cache: {
      maxEntries: 10000,
      maxSize: 100 * 1024 * 1024 // 100MB
    },
    resilience: {
      circuitBreaker: {
        defaultConfig: {
          failureThreshold: 5,
          recoveryTimeout: 30000,
          halfOpenMaxCalls: 3,
          monitoringWindow: 60000
        }
      },
      fallback: {
        enableAutoDiscovery: true
      },
      performance: {
        maxResponseTime: 30000,
        minSuccessRate: 0.95,
        fallbackDetectionTime: 200
      }
    }
  });

  try {
    // Start the infrastructure
    await infrastructure.start();

    // Route a tool request
    const decision = await infrastructure.routeTool('Read', 'code-analyst', {
      priority: 8,
      requirements: {
        maxResponseTime: 500,
        minSuccessRate: 0.95
      }
    });

    console.log('Routing decision:', {
      server: decision.selectedServer.name,
      confidence: decision.confidence,
      reasoning: decision.reasoning,
      decisionTime: decision.decisionTime
    });

    // Execute tool with resilience protection
    const resilientResult = await infrastructure.executeToolWithResilience(
      'Read',
      async (server) => {
        // Simulate tool execution
        await new Promise(resolve => setTimeout(resolve, 100));
        return { data: 'file contents', serverId: server.id };
      },
      {
        agentId: 'code-analyst',
        priority: 8,
        requirements: {
          maxResponseTime: 500,
          minSuccessRate: 0.95
        }
      }
    );

    console.log('Resilient execution result:', {
      success: resilientResult.success,
      server: resilientResult.serverName,
      attempts: resilientResult.attempts,
      totalTime: resilientResult.totalTime,
      usedFallback: resilientResult.usedFallback
    });

    // Record performance (this is now handled automatically by resilience manager)
    if (resilientResult.success) {
      await infrastructure.recordPerformance({
        serverId: resilientResult.serverId,
        toolName: 'Read',
        agentId: 'code-analyst',
        responseTime: resilientResult.totalTime,
        success: true,
        satisfaction: 0.9
      });
    }

    // Get system status
    const status = infrastructure.getSystemStatus();
    console.log('System status:', status);

  } catch (error) {
    console.error('Infrastructure error:', error);
  } finally {
    // Clean shutdown
    await infrastructure.stop();
  }
}

// =============================================================================
// Exports
// =============================================================================

export * from './discovery';
export * from './registry';
export * from './tool-router';
export * from './preference-engine';
export * from './cache-manager';
export * from './circuit-breaker';
export * from './fallback-manager';
export * from './resilience';
export * from '../types';

export {
  MCPInfrastructure,
  exampleUsage
};

export type {
  MCPInfrastructureConfig
};
