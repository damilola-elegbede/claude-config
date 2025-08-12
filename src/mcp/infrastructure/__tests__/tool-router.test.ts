/**
 * Comprehensive test suite for MCP Tool Router
 * Tests intelligent routing strategies, performance optimization, and caching
 */

import { describe, it, expect, beforeEach, afterEach, jest } from '@jest/globals';
import { EventEmitter } from 'events';
import {
  ToolRouter,
  PerformanceWeightedStrategy,
  RoundRobinStrategy,
  FailoverStrategy,
  RoutingContext,
  RoutingDecision,
  ToolRouterConfig,
  PerformanceRequirements
} from '../tool-router';
import { MCPServerRegistry, ServerMetrics } from '../registry';
import { MCPServerInfo } from '../discovery';

describe('ToolRouter', () => {
  let registry: MCPServerRegistry;
  let router: ToolRouter;

  const mockServer1: MCPServerInfo = {
    id: 'fast-server',
    name: 'filesystem-fast',
    config: { command: 'node', args: ['fast.js'] },
    status: 'healthy',
    capabilities: [
      { name: 'Read', description: 'Fast read operations' },
      { name: 'Write', description: 'Fast write operations' }
    ],
    lastHealthCheck: new Date(),
    responseTime: 30,
    failureCount: 0
  };

  const mockServer2: MCPServerInfo = {
    id: 'slow-server',
    name: 'filesystem-slow',
    config: { command: 'node', args: ['slow.js'] },
    status: 'healthy',
    capabilities: [
      { name: 'Read', description: 'Slow read operations' },
      { name: 'Write', description: 'Slow write operations' }
    ],
    lastHealthCheck: new Date(),
    responseTime: 150,
    failureCount: 0
  };

  const mockServer3: MCPServerInfo = {
    id: 'degraded-server',
    name: 'filesystem-backup',
    config: { command: 'node', args: ['backup.js'] },
    status: 'degraded',
    capabilities: [
      { name: 'Read', description: 'Backup read operations' }
    ],
    lastHealthCheck: new Date(),
    responseTime: 200,
    failureCount: 3
  };

  const mockServer4: MCPServerInfo = {
    id: 'failed-server',
    name: 'filesystem-failed',
    config: { command: 'node', args: ['failed.js'] },
    status: 'failed',
    capabilities: [
      { name: 'Read', description: 'Failed server' }
    ],
    lastHealthCheck: new Date(),
    responseTime: 1000,
    failureCount: 10
  };

  beforeEach(() => {
    registry = new MCPServerRegistry();
    
    // Register mock servers
    [mockServer1, mockServer2, mockServer3, mockServer4].forEach(server => {
      registry.registerServer(server);
    });

    // Add performance metrics
    registry.updateServerMetrics(mockServer1.id, {
      totalRequests: 1000,
      successfulRequests: 990,
      failedRequests: 10,
      averageResponseTime: 30,
      uptimePercentage: 99,
      load: 0.2
    });

    registry.updateServerMetrics(mockServer2.id, {
      totalRequests: 500,
      successfulRequests: 480,
      failedRequests: 20,
      averageResponseTime: 150,
      uptimePercentage: 96,
      load: 0.5
    });

    registry.updateServerMetrics(mockServer3.id, {
      totalRequests: 100,
      successfulRequests: 70,
      failedRequests: 30,
      averageResponseTime: 200,
      uptimePercentage: 85,
      load: 0.8
    });

    registry.updateServerMetrics(mockServer4.id, {
      totalRequests: 50,
      successfulRequests: 20,
      failedRequests: 30,
      averageResponseTime: 1000,
      uptimePercentage: 40,
      load: 0.9
    });

    // Create router
    router = new ToolRouter(registry, {
      enableCaching: true,
      cacheTtl: 1000,
      decisionTimeout: 100
    });
  });

  afterEach(() => {
    router.destroy();
    registry.destroy();
  });

  describe('Constructor and Configuration', () => {
    it('should create router with default configuration', () => {
      const defaultRouter = new ToolRouter(registry);
      expect(defaultRouter).toBeInstanceOf(ToolRouter);
      expect(defaultRouter).toBeInstanceOf(EventEmitter);
      defaultRouter.destroy();
    });

    it('should create router with custom configuration', () => {
      const config: Partial<ToolRouterConfig> = {
        defaultStrategy: 'round_robin',
        enableCaching: false,
        decisionTimeout: 50,
        toolStrategies: {
          'Read': 'failover'
        },
        agentStrategies: {
          'test-agent': 'performance_weighted'
        }
      };

      const customRouter = new ToolRouter(registry, config);
      expect(customRouter).toBeInstanceOf(ToolRouter);
      customRouter.destroy();
    });

    it('should register built-in strategies automatically', () => {
      const strategies = router.getStrategies();
      expect(strategies).toContain('performance_weighted');
      expect(strategies).toContain('round_robin');
      expect(strategies).toContain('failover');
    });

    it('should allow custom strategy registration', () => {
      const customStrategy = {
        name: 'custom_strategy',
        description: 'Custom routing strategy',
        async evaluate() {
          return {
            selectedServer: mockServer1,
            confidence: 0.9,
            reasoning: 'Custom selection',
            timestamp: new Date(),
            decisionTime: 10
          } as RoutingDecision;
        }
      };

      router.registerStrategy(customStrategy);
      expect(router.getStrategies()).toContain('custom_strategy');
    });
  });

  describe('Routing Performance Requirements', () => {
    it('should complete routing decisions in under 100ms', async () => {
      const context: RoutingContext = {
        toolName: 'Read',
        agentId: 'test-agent'
      };

      const startTime = Date.now();
      const decision = await router.route(context);
      const routingTime = Date.now() - startTime;

      expect(routingTime).toBeLessThan(100);
      expect(decision.decisionTime).toBeLessThan(100);
      expect(decision.selectedServer).toBeDefined();
    });

    it('should handle concurrent routing requests efficiently', async () => {
      const contexts = Array.from({ length: 20 }, (_, i) => ({
        toolName: 'Read',
        agentId: `agent-${i}`
      }));

      const startTime = Date.now();
      const decisions = await Promise.all(
        contexts.map(context => router.route(context))
      );
      const totalTime = Date.now() - startTime;

      expect(totalTime).toBeLessThan(500); // 20 decisions in under 500ms
      expect(decisions).toHaveLength(20);
      decisions.forEach(decision => {
        expect(decision.selectedServer).toBeDefined();
        expect(decision.decisionTime).toBeLessThan(100);
      });
    });

    it('should handle timeout correctly', async () => {
      const shortTimeoutRouter = new ToolRouter(registry, {
        decisionTimeout: 1 // Very short timeout
      });

      // Mock a slow strategy
      const slowStrategy = {
        name: 'slow_strategy',
        description: 'Intentionally slow strategy',
        async evaluate() {
          await new Promise(resolve => setTimeout(resolve, 100));
          return {
            selectedServer: mockServer1,
            confidence: 0.5,
            reasoning: 'Slow decision',
            timestamp: new Date(),
            decisionTime: 100
          } as RoutingDecision;
        }
      };

      shortTimeoutRouter.registerStrategy(slowStrategy);
      shortTimeoutRouter.updateStrategyConfig('slow_strategy', {
        weights: { performance: 1, availability: 0, load: 0, preference: 0 }
      });

      const context: RoutingContext = {
        toolName: 'Read',
        timeout: 1
      };

      await expect(shortTimeoutRouter.route(context))
        .rejects.toThrow(/timed out/i);

      shortTimeoutRouter.destroy();
    });
  });

  describe('Performance-Weighted Strategy', () => {
    let strategy: PerformanceWeightedStrategy;

    beforeEach(() => {
      strategy = new PerformanceWeightedStrategy({
        weights: { performance: 0.4, availability: 0.3, load: 0.2, preference: 0.1 }
      });
    });

    it('should select fastest healthy server', async () => {
      const candidates = [mockServer1, mockServer2, mockServer3];
      const context: RoutingContext = { toolName: 'Read' };

      const decision = await strategy.evaluate(candidates, context, registry);

      expect(decision.selectedServer.id).toBe(mockServer1.id); // Fastest server
      expect(decision.confidence).toBeGreaterThan(0.5);
      expect(decision.reasoning).toContain('Performance-weighted');
    });

    it('should filter servers by requirements', async () => {
      const candidates = [mockServer1, mockServer2, mockServer3, mockServer4];
      const context: RoutingContext = {
        toolName: 'Read',
        requirements: {
          maxResponseTime: 100, // Excludes slow servers
          minSuccessRate: 0.9,  // Excludes degraded servers
          maxLoad: 0.6          // Excludes highly loaded servers
        }
      };

      const decision = await strategy.evaluate(candidates, context, registry);

      expect(decision.selectedServer.id).toBe(mockServer1.id);
      expect(decision.alternatives?.length).toBe(0); // Only one server meets requirements
    });

    it('should handle no qualifying servers', async () => {
      const candidates = [mockServer1, mockServer2];
      const context: RoutingContext = {
        toolName: 'Read',
        requirements: {
          maxResponseTime: 10, // Impossible requirement
        }
      };

      await expect(strategy.evaluate(candidates, context, registry))
        .rejects.toThrow('No servers meet requirements');
    });

    it('should provide confidence scoring', async () => {
      const candidates = [mockServer1, mockServer2];
      const context: RoutingContext = { toolName: 'Read' };

      const decision = await strategy.evaluate(candidates, context, registry);

      expect(decision.confidence).toBeGreaterThan(0);
      expect(decision.confidence).toBeLessThanOrEqual(1);
    });

    it('should include alternative servers', async () => {
      const candidates = [mockServer1, mockServer2, mockServer3];
      const context: RoutingContext = { toolName: 'Read' };

      const decision = await strategy.evaluate(candidates, context, registry);

      expect(decision.alternatives).toBeDefined();
      expect(decision.alternatives!.length).toBeGreaterThan(0);
      expect(decision.alternatives!.map(s => s.id)).not.toContain(decision.selectedServer.id);
    });
  });

  describe('Round-Robin Strategy', () => {
    let strategy: RoundRobinStrategy;

    beforeEach(() => {
      strategy = new RoundRobinStrategy();
    });

    it('should distribute requests evenly', async () => {
      const candidates = [mockServer1, mockServer2]; // Only healthy servers
      const context: RoutingContext = { toolName: 'Read' };

      const decisions = [];
      for (let i = 0; i < 4; i++) {
        const decision = await strategy.evaluate(candidates, context, registry);
        decisions.push(decision.selectedServer.id);
      }

      // Should alternate between servers
      expect(decisions).toEqual([
        mockServer1.id, mockServer2.id,
        mockServer1.id, mockServer2.id
      ]);
    });

    it('should handle single server gracefully', async () => {
      const candidates = [mockServer1];
      const context: RoutingContext = { toolName: 'Read' };

      for (let i = 0; i < 3; i++) {
        const decision = await strategy.evaluate(candidates, context, registry);
        expect(decision.selectedServer.id).toBe(mockServer1.id);
      }
    });

    it('should only use healthy servers', async () => {
      const candidates = [mockServer1, mockServer3, mockServer4]; // Mixed health
      const context: RoutingContext = { toolName: 'Read' };

      const decision = await strategy.evaluate(candidates, context, registry);
      expect(decision.selectedServer.status).toBe('healthy');
      expect(decision.selectedServer.id).toBe(mockServer1.id);
    });

    it('should fail when no healthy servers available', async () => {
      const candidates = [mockServer3, mockServer4]; // Only unhealthy servers
      const context: RoutingContext = { toolName: 'Read' };

      await expect(strategy.evaluate(candidates, context, registry))
        .rejects.toThrow('No healthy servers available');
    });
  });

  describe('Failover Strategy', () => {
    let strategy: FailoverStrategy;

    beforeEach(() => {
      strategy = new FailoverStrategy();
    });

    it('should prioritize healthy servers', async () => {
      const candidates = [mockServer3, mockServer1, mockServer4]; // Mixed order
      const context: RoutingContext = { toolName: 'Read' };

      const decision = await strategy.evaluate(candidates, context, registry);

      expect(decision.selectedServer.status).toBe('healthy');
      expect(decision.selectedServer.id).toBe(mockServer1.id);
    });

    it('should provide alternatives in priority order', async () => {
      const candidates = [mockServer4, mockServer3, mockServer2, mockServer1];
      const context: RoutingContext = { toolName: 'Read' };

      const decision = await strategy.evaluate(candidates, context, registry);

      expect(decision.selectedServer.status).toBe('healthy');
      expect(decision.alternatives).toBeDefined();
      
      // Should be sorted by status priority
      const allServers = [decision.selectedServer, ...decision.alternatives!];
      const healthyCount = allServers.filter(s => s.status === 'healthy').length;
      const degradedCount = allServers.filter(s => s.status === 'degraded').length;
      
      expect(healthyCount).toBeGreaterThan(0);
    });

    it('should handle degraded server as primary when no healthy available', async () => {
      const candidates = [mockServer3, mockServer4]; // No healthy servers
      const context: RoutingContext = { toolName: 'Read' };

      const decision = await strategy.evaluate(candidates, context, registry);

      expect(decision.selectedServer.status).toBe('degraded');
      expect(decision.confidence).toBeLessThan(0.9); // Lower confidence for degraded
    });
  });

  describe('Routing Decision Making', () => {
    it('should route to optimal server based on strategy', async () => {
      const context: RoutingContext = {
        toolName: 'Read',
        agentId: 'test-agent'
      };

      const decision = await router.route(context);

      expect(decision.selectedServer).toBeDefined();
      expect(decision.selectedServer.status).toBe('healthy');
      expect(decision.confidence).toBeGreaterThan(0);
      expect(decision.reasoning).toBeDefined();
      expect(decision.timestamp).toBeInstanceOf(Date);
      expect(decision.decisionTime).toBeGreaterThan(0);
    });

    it('should use tool-specific strategy override', async () => {
      router.updateStrategyConfig('failover', {
        weights: { performance: 0, availability: 1, load: 0, preference: 0 }
      });

      const customRouter = new ToolRouter(registry, {
        defaultStrategy: 'performance_weighted',
        toolStrategies: {
          'Read': 'failover'
        }
      });

      const context: RoutingContext = {
        toolName: 'Read',
        agentId: 'test-agent'
      };

      const decision = await customRouter.route(context);
      expect(decision.reasoning).toContain('Failover');

      customRouter.destroy();
    });

    it('should use agent-specific strategy override', async () => {
      const customRouter = new ToolRouter(registry, {
        defaultStrategy: 'performance_weighted',
        agentStrategies: {
          'special-agent': 'round_robin'
        }
      });

      const context: RoutingContext = {
        toolName: 'Read',
        agentId: 'special-agent'
      };

      const decision = await customRouter.route(context);
      expect(decision.reasoning).toContain('Round-robin');

      customRouter.destroy();
    });

    it('should fallback to default strategy for unknown strategies', async () => {
      const customRouter = new ToolRouter(registry, {
        toolStrategies: {
          'Read': 'non_existent_strategy'
        }
      });

      const consoleSpy = jest.spyOn(console, 'warn').mockImplementation();

      const context: RoutingContext = {
        toolName: 'Read'
      };

      const decision = await customRouter.route(context);
      expect(decision).toBeDefined();
      expect(consoleSpy).toHaveBeenCalledWith(
        expect.stringContaining('Strategy not found: non_existent_strategy')
      );

      consoleSpy.mockRestore();
      customRouter.destroy();
    });

    it('should handle tools with no available servers', async () => {
      const context: RoutingContext = {
        toolName: 'NonExistentTool',
        agentId: 'test-agent'
      };

      await expect(router.route(context))
        .rejects.toThrow('No servers registered for tool: NonExistentTool');
    });

    it('should respect custom timeout in context', async () => {
      const context: RoutingContext = {
        toolName: 'Read',
        timeout: 50
      };

      const decision = await router.route(context);
      expect(decision.decisionTime).toBeLessThan(50);
    });
  });

  describe('Caching System', () => {
    it('should cache routing decisions', async () => {
      const context: RoutingContext = {
        toolName: 'Read',
        agentId: 'test-agent',
        priority: 5
      };

      // First call
      const decision1 = await router.route(context);
      
      // Second call should be faster (cached)
      const startTime = Date.now();
      const decision2 = await router.route(context);
      const cachedTime = Date.now() - startTime;

      expect(cachedTime).toBeLessThan(10); // Should be very fast
      expect(decision2.selectedServer.id).toBe(decision1.selectedServer.id);
    });

    it('should respect cache TTL', async () => {
      const shortCacheRouter = new ToolRouter(registry, {
        cacheTtl: 100 // 100ms TTL
      });

      const context: RoutingContext = {
        toolName: 'Read',
        agentId: 'cache-test'
      };

      const decision1 = await shortCacheRouter.route(context);
      
      // Wait for cache to expire
      await new Promise(resolve => setTimeout(resolve, 150));
      
      const decision2 = await shortCacheRouter.route(context);
      
      // Decisions might be different due to cache miss
      expect(decision2.timestamp.getTime()).toBeGreaterThan(decision1.timestamp.getTime());

      shortCacheRouter.destroy();
    });

    it('should generate different cache keys for different contexts', async () => {
      const context1: RoutingContext = { toolName: 'Read', agentId: 'agent1' };
      const context2: RoutingContext = { toolName: 'Read', agentId: 'agent2' };
      const context3: RoutingContext = { toolName: 'Write', agentId: 'agent1' };

      const [decision1, decision2, decision3] = await Promise.all([
        router.route(context1),
        router.route(context2),
        router.route(context3)
      ]);

      // Each should have independent caching
      expect(decision1).toBeDefined();
      expect(decision2).toBeDefined();
      expect(decision3).toBeDefined();
    });

    it('should disable caching when configured', async () => {
      const noCacheRouter = new ToolRouter(registry, {
        enableCaching: false
      });

      const context: RoutingContext = {
        toolName: 'Read',
        agentId: 'no-cache-test'
      };

      const startTime = Date.now();
      await noCacheRouter.route(context);
      const firstCallTime = Date.now() - startTime;

      const startTime2 = Date.now();
      await noCacheRouter.route(context);
      const secondCallTime = Date.now() - startTime2;

      // Both calls should take similar time (no caching benefit)
      expect(Math.abs(firstCallTime - secondCallTime)).toBeLessThan(50);

      noCacheRouter.destroy();
    });

    it('should clear cache when requested', async () => {
      const context: RoutingContext = {
        toolName: 'Read',
        agentId: 'clear-test'
      };

      await router.route(context);
      
      const cacheClearedSpy = jest.fn();
      router.on('cacheCleared', cacheClearedSpy);

      router.clearCache();
      expect(cacheClearedSpy).toHaveBeenCalled();

      // Next call should not be cached
      const startTime = Date.now();
      await router.route(context);
      const timeAfterClear = Date.now() - startTime;
      
      expect(timeAfterClear).toBeGreaterThan(5); // Should take actual processing time
    });
  });

  describe('Event System', () => {
    it('should emit routing decision events', async () => {
      const routingDecisionSpy = jest.fn();
      router.on('routingDecision', routingDecisionSpy);

      const context: RoutingContext = {
        toolName: 'Read',
        agentId: 'event-test'
      };

      await router.route(context);

      expect(routingDecisionSpy).toHaveBeenCalledWith(
        expect.objectContaining({
          selectedServer: expect.any(Object),
          confidence: expect.any(Number),
          reasoning: expect.any(String),
          fromCache: false
        })
      );
    });

    it('should emit cache hit events', async () => {
      const routingDecisionSpy = jest.fn();
      router.on('routingDecision', routingDecisionSpy);

      const context: RoutingContext = {
        toolName: 'Read',
        agentId: 'cache-event-test'
      };

      await router.route(context); // First call
      await router.route(context); // Cached call

      expect(routingDecisionSpy).toHaveBeenCalledTimes(2);
      expect(routingDecisionSpy.mock.calls[1][0].fromCache).toBe(true);
    });

    it('should emit routing error events', async () => {
      const routingErrorSpy = jest.fn();
      router.on('routingError', routingErrorSpy);

      const context: RoutingContext = {
        toolName: 'NonExistentTool'
      };

      await expect(router.route(context)).rejects.toThrow();
      
      expect(routingErrorSpy).toHaveBeenCalledWith(
        expect.objectContaining({
          context: expect.any(Object),
          error: expect.any(Error),
          timestamp: expect.any(Date)
        })
      );
    });

    it('should emit strategy registration events', () => {
      const strategyRegisteredSpy = jest.fn();
      router.on('strategyRegistered', strategyRegisteredSpy);

      const customStrategy = {
        name: 'test_strategy',
        description: 'Test strategy',
        async evaluate() {
          return {
            selectedServer: mockServer1,
            confidence: 0.5,
            reasoning: 'Test',
            timestamp: new Date(),
            decisionTime: 1
          } as RoutingDecision;
        }
      };

      router.registerStrategy(customStrategy);
      expect(strategyRegisteredSpy).toHaveBeenCalledWith({ name: 'test_strategy' });
    });
  });

  describe('Strategy Configuration Management', () => {
    it('should update strategy configurations', () => {
      const strategyConfigUpdatedSpy = jest.fn();
      router.on('strategyConfigUpdated', strategyConfigUpdatedSpy);

      const newConfig = {
        weights: { performance: 0.6, availability: 0.2, load: 0.1, preference: 0.1 }
      };

      router.updateStrategyConfig('performance_weighted', newConfig);
      
      expect(strategyConfigUpdatedSpy).toHaveBeenCalledWith({
        name: 'performance_weighted',
        config: newConfig
      });
    });

    it('should throw error for unknown strategy configuration', () => {
      expect(() => {
        router.updateStrategyConfig('unknown_strategy', {
          weights: { performance: 1, availability: 0, load: 0, preference: 0 }
        });
      }).toThrow('Strategy not found: unknown_strategy');
    });
  });

  describe('Load Testing and Performance', () => {
    it('should handle high-frequency routing requests', async () => {
      const requests = Array.from({ length: 100 }, (_, i) => ({
        toolName: 'Read',
        agentId: `load-test-agent-${i}`
      }));

      const startTime = Date.now();
      const decisions = await Promise.all(
        requests.map(context => router.route(context))
      );
      const totalTime = Date.now() - startTime;

      expect(totalTime).toBeLessThan(2000); // 100 decisions in under 2 seconds
      expect(decisions).toHaveLength(100);
      decisions.forEach(decision => {
        expect(decision.selectedServer).toBeDefined();
      });
    });

    it('should maintain performance with many strategies', () => {
      // Register many custom strategies
      for (let i = 0; i < 20; i++) {
        const strategy = {
          name: `strategy_${i}`,
          description: `Test strategy ${i}`,
          async evaluate() {
            return {
              selectedServer: mockServer1,
              confidence: 0.5,
              reasoning: `Strategy ${i}`,
              timestamp: new Date(),
              decisionTime: 1
            } as RoutingDecision;
          }
        };
        
        router.registerStrategy(strategy);
      }

      expect(router.getStrategies().length).toBeGreaterThan(20);
    });

    it('should handle concurrent strategy updates safely', async () => {
      const updatePromises = Array.from({ length: 10 }, (_, i) => 
        new Promise<void>((resolve) => {
          setTimeout(() => {
            router.updateStrategyConfig('performance_weighted', {
              weights: { 
                performance: 0.4 + (i * 0.01), 
                availability: 0.3, 
                load: 0.2, 
                preference: 0.1 
              }
            });
            resolve();
          }, i * 10);
        })
      );

      await Promise.all(updatePromises);

      // Should not throw errors and router should still function
      const decision = await router.route({ toolName: 'Read' });
      expect(decision).toBeDefined();
    });
  });

  describe('Error Handling and Edge Cases', () => {
    it('should handle empty server registry gracefully', async () => {
      const emptyRegistry = new MCPServerRegistry();
      const emptyRouter = new ToolRouter(emptyRegistry);

      await expect(emptyRouter.route({ toolName: 'Read' }))
        .rejects.toThrow('No servers registered for tool: Read');

      emptyRouter.destroy();
      emptyRegistry.destroy();
    });

    it('should handle strategy evaluation errors', async () => {
      const errorStrategy = {
        name: 'error_strategy',
        description: 'Strategy that throws errors',
        async evaluate() {
          throw new Error('Strategy evaluation failed');
        }
      };

      router.registerStrategy(errorStrategy);

      const customRouter = new ToolRouter(registry, {
        defaultStrategy: 'error_strategy'
      });

      await expect(customRouter.route({ toolName: 'Read' }))
        .rejects.toThrow('Strategy evaluation failed');

      customRouter.destroy();
    });

    it('should handle malformed routing contexts', async () => {
      const malformedContexts = [
        { toolName: '' },
        { toolName: null as any },
        { toolName: undefined as any },
        { toolName: 'Read', priority: -1 },
        { toolName: 'Read', timeout: -100 }
      ];

      for (const context of malformedContexts) {
        await expect(router.route(context)).rejects.toThrow();
      }
    });

    it('should clean up resources properly', () => {
      const testRouter = new ToolRouter(registry);
      
      // Add some cached data
      testRouter.route({ toolName: 'Read' }).catch(() => {});
      
      expect(() => testRouter.destroy()).not.toThrow();
      
      // Should not throw on subsequent destroy calls
      expect(() => testRouter.destroy()).not.toThrow();
    });

    it('should handle extremely high priority values', async () => {
      const context: RoutingContext = {
        toolName: 'Read',
        priority: Number.MAX_SAFE_INTEGER
      };

      const decision = await router.route(context);
      expect(decision).toBeDefined();
    });

    it('should handle zero timeout gracefully', async () => {
      const context: RoutingContext = {
        toolName: 'Read',
        timeout: 0
      };

      await expect(router.route(context)).rejects.toThrow(/timed out/i);
    });
  });

  describe('Integration with Registry Changes', () => {
    it('should adapt to server registration changes', async () => {
      // Add a new high-performance server
      const superFastServer: MCPServerInfo = {
        id: 'super-fast-server',
        name: 'super-filesystem',
        config: { command: 'node', args: ['super-fast.js'] },
        status: 'healthy',
        capabilities: [{ name: 'Read', description: 'Ultra-fast reads' }],
        lastHealthCheck: new Date(),
        responseTime: 5,
        failureCount: 0
      };

      registry.registerServer(superFastServer);
      registry.updateServerMetrics(superFastServer.id, {
        totalRequests: 100,
        successfulRequests: 100,
        failedRequests: 0,
        averageResponseTime: 5,
        uptimePercentage: 100,
        load: 0.1
      });

      const context: RoutingContext = { toolName: 'Read' };
      const decision = await router.route(context);

      // Should now select the super fast server
      expect(decision.selectedServer.id).toBe(superFastServer.id);
    });

    it('should handle server unregistration', async () => {
      const context: RoutingContext = { toolName: 'Read' };
      
      // Get initial decision
      const decision1 = await router.route(context);
      const initialServerId = decision1.selectedServer.id;

      // Remove the selected server
      registry.unregisterServer(initialServerId);

      // Clear cache to force new decision
      router.clearCache();

      // Should select a different server
      const decision2 = await router.route(context);
      expect(decision2.selectedServer.id).not.toBe(initialServerId);
    });

    it('should adapt to metrics changes', async () => {
      // Make the slow server much faster
      registry.updateServerMetrics(mockServer2.id, {
        totalRequests: 2000,
        successfulRequests: 1990,
        failedRequests: 10,
        averageResponseTime: 10, // Much faster now
        uptimePercentage: 99.5,
        load: 0.1
      });

      router.clearCache(); // Force fresh decision

      const context: RoutingContext = { toolName: 'Read' };
      const decision = await router.route(context);

      // Should now prefer the improved server
      const selectedMetrics = registry.getServerMetrics(decision.selectedServer.id);
      expect(selectedMetrics?.averageResponseTime).toBeLessThan(50);
    });
  });
});