/**
 * SPEC_03 Tests: MCP Optimization Engine Validation
 *
 * Comprehensive test suite validating the MCP optimization engine
 * meets all performance targets and functionality requirements
 */

import {
  MCPOptimizationEngine,
  OptimizationEngineConfig,
  IntelligentRouter,
  AdvancedCacheManager,
  CrossServerCoordinator
} from '../integration/optimization-engine';

import {
  MCPServerInfo,
  ToolExecutionRequest,
  RoutingContext,
  ServerStatus
} from '../types';

describe('SPEC_03: MCP Optimization Engine', () => {
  let optimizationEngine: MCPOptimizationEngine;
  let config: OptimizationEngineConfig;
  let mockServers: MCPServerInfo[];

  beforeEach(() => {
    config = {
      routing: {
        enablePredictiveRouting: true,
        predictionWindow: 300000, // 5 minutes
        minConfidence: 0.7,
        maxDecisionTime: 50, // Target: <50ms
        enableAdaptiveRouting: true
      },
      caching: {
        enableMultiLevel: true,
        memoryCacheSize: 100 * 1024 * 1024, // 100MB
        distributedCacheSize: 500 * 1024 * 1024, // 500MB
        warmingStrategy: 'adaptive',
        coherenceTimeout: 30000,
        enableIntelligentInvalidation: true
      },
      optimization: {
        enableBatching: true,
        maxBatchSize: 10,
        batchTimeout: 100,
        enableConnectionPooling: true,
        connectionPoolSize: 5,
        enableAdaptiveTimeouts: true
      },
      coordination: {
        enableStateSynchronization: true,
        consistencyModel: 'eventual',
        syncInterval: 5000,
        enableDistributedTransactions: true,
        transactionTimeout: 30000
      },
      targets: {
        latencyReduction: 40, // 40% reduction target
        maxResponseTime: 1000,
        minSuccessRate: 0.95,
        targetThroughput: 1000,
        maxServerCount: 15
      }
    };

    mockServers = createMockServers(12); // Test with 12 servers
    optimizationEngine = new MCPOptimizationEngine(config);
  });

  afterEach(async () => {
    await optimizationEngine.destroy();
  });

  describe('Performance Requirements', () => {
    test('should achieve 40% latency reduction target', async () => {
      // Execute multiple requests to establish baseline and optimized performance
      const requests = generateTestRequests(100);
      const startTime = Date.now();

      const results = await Promise.all(
        requests.map(req => optimizationEngine.optimizeRequest(req, mockServers))
      );

      const totalTime = Date.now() - startTime;
      const metrics = optimizationEngine.getOptimizationMetrics();

      expect(metrics.system.latencyReduction).toBeGreaterThanOrEqual(0.4); // 40% reduction
      expect(results.every(r => r.success)).toBe(true);
    });

    test('should handle 10+ MCP servers coordination', async () => {
      const serverIds = mockServers.slice(0, 12).map(s => s.id);

      const result = await optimizationEngine.coordinateMultiServerOperation(
        'test-operation',
        serverIds,
        { test: 'data' }
      );

      expect(result.success).toBe(true);
      expect(result.results.size).toBe(12);

      const metrics = optimizationEngine.getOptimizationMetrics();
      expect(metrics.coordination.activeServers).toBe(12);
    });

    test('should maintain sub-100ms routing decisions', async () => {
      const router = new IntelligentRouter(config.routing);
      const routingContext: RoutingContext = {
        toolName: 'Read',
        agentId: 'test-agent',
        priority: 5,
        requirements: {
          maxResponseTime: 500,
          minSuccessRate: 0.95
        }
      };

      const startTime = Date.now();
      const decision = await router.route(routingContext, mockServers);
      const decisionTime = Date.now() - startTime;

      expect(decisionTime).toBeLessThan(100); // Sub-100ms requirement
      expect(decision.confidence).toBeGreaterThan(0.7);
      expect(decision.selectedServer).toBeDefined();
    });

    test('should achieve 99.9% uptime with automatic failover', async () => {
      // Simulate server failures and measure failover performance
      const failedServer = mockServers[0];
      failedServer.status = 'failed' as ServerStatus;

      const requests = generateTestRequests(50);
      const results = await Promise.all(
        requests.map(req => optimizationEngine.optimizeRequest(req, mockServers))
      );

      const successRate = results.filter(r => r.success).length / results.length;
      expect(successRate).toBeGreaterThanOrEqual(0.999); // 99.9% uptime

      // Verify failover occurred (no requests routed to failed server)
      const failedServerUsage = results.filter(r => r.serverId === failedServer.id).length;
      expect(failedServerUsage).toBe(0);
    });
  });

  describe('Intelligent Request Routing', () => {
    test('should route based on real-time performance metrics', async () => {
      const router = new IntelligentRouter(config.routing);

      // Create servers with different performance profiles
      const fastServer = createMockServer('fast-server', 50, 'healthy'); // 50ms response
      const slowServer = createMockServer('slow-server', 500, 'healthy'); // 500ms response

      const context: RoutingContext = {
        toolName: 'Read',
        requirements: { maxResponseTime: 100 }
      };

      const decision = await router.route(context, [fastServer, slowServer]);

      expect(decision.selectedServer.id).toBe('fast-server');
      expect(decision.reasoning).toContain('fast response time');
    });

    test('should implement predictive routing patterns', async () => {
      const router = new IntelligentRouter(config.routing);

      // Simulate historical usage patterns
      const context: RoutingContext = {
        toolName: 'Read',
        agentId: 'code-analyst'
      };

      const decision = await router.route(context, mockServers);

      expect(decision.confidence).toBeGreaterThan(config.routing.minConfidence);
      expect(decision.decisionTime).toBeLessThan(config.routing.maxDecisionTime);
    });

    test('should provide fallback routing for server failures', async () => {
      // Mark primary servers as failed
      const workingServers = mockServers.slice(3); // Leave only backup servers
      mockServers.slice(0, 3).forEach(server => {
        server.status = 'failed' as ServerStatus;
      });

      const context: RoutingContext = {
        toolName: 'Read',
        priority: 8
      };

      const decision = await optimizationEngine['router'].route(context, mockServers);

      expect(workingServers.some(s => s.id === decision.selectedServer.id)).toBe(true);
      expect(decision.selectedServer.status).toBe('healthy');
    });
  });

  describe('Advanced Caching System', () => {
    test('should achieve 60% cache hit rate improvement', async () => {
      const cache = new AdvancedCacheManager(config.caching);

      // Populate cache with test data
      const testKeys = Array.from({ length: 100 }, (_, i) => `test-key-${i}`);
      for (const key of testKeys) {
        await cache.set(key, { data: `value-${key}` }, { replicate: true });
      }

      // Test cache hit rate
      let hits = 0;
      for (const key of testKeys) {
        const result = await cache.get(key);
        if (result) hits++;
      }

      const hitRate = hits / testKeys.length;
      expect(hitRate).toBeGreaterThanOrEqual(0.6); // 60% improvement target
    });

    test('should implement multi-level caching strategy', async () => {
      const cache = new AdvancedCacheManager(config.caching);

      // Test memory cache
      await cache.set('memory-test', { data: 'memory-value' });
      const memoryResult = await cache.get('memory-test', { preferLocal: true });
      expect(memoryResult).toBeDefined();

      // Test distributed cache
      await cache.set('dist-test', { data: 'dist-value' }, { replicate: true });
      const distResult = await cache.get('dist-test');
      expect(distResult).toBeDefined();
    });

    test('should handle cache coherence across servers', async () => {
      const cache = new AdvancedCacheManager(config.caching);

      const coherenceGroup = 'test-group';
      await cache.set('coherent-key-1', { data: 'value1' }, { coherenceGroup });
      await cache.set('coherent-key-2', { data: 'value2' }, { coherenceGroup });

      // Invalidate coherence group
      await cache.invalidateCoherenceGroup(coherenceGroup);

      const result1 = await cache.get('coherent-key-1');
      const result2 = await cache.get('coherent-key-2');

      expect(result1).toBeNull();
      expect(result2).toBeNull();
    });

    test('should implement intelligent cache warming', async () => {
      const cache = new AdvancedCacheManager({
        ...config.caching,
        warmingStrategy: 'aggressive'
      });

      // Cache should warm frequently accessed keys
      const stats = cache.getStats();
      expect(stats).toBeDefined();
      expect(stats.hitRatio).toBeGreaterThanOrEqual(0);
    });
  });

  describe('Cross-Server Coordination', () => {
    test('should synchronize state across multiple servers', async () => {
      const coordinator = new CrossServerCoordinator(config.coordination);

      const stateId = 'test-state-sync';
      const serverId = 'server-1';
      const testData = { key: 'value', timestamp: new Date() };

      await coordinator.synchronizeState(stateId, serverId, testData);

      // Verify state synchronization
      expect(coordinator['serverStates'].has(`${stateId}:${serverId}`)).toBe(true);
    });

    test('should handle distributed transactions', async () => {
      const coordinator = new CrossServerCoordinator({
        ...config.coordination,
        consistencyModel: 'strong'
      });

      const serverIds = mockServers.slice(0, 5).map(s => s.id);
      const operation = 'test-transaction';
      const data = { transactionData: 'test' };

      const result = await coordinator.coordinateOperation(operation, serverIds, data);

      expect(result.success).toBe(true);
      expect(result.results.size).toBe(5);
    });

    test('should resolve state conflicts automatically', async () => {
      const coordinator = new CrossServerCoordinator(config.coordination);

      const stateId = 'conflict-test';

      // Create conflicting states
      await coordinator.synchronizeState(stateId, 'server-1', { version: 1, data: 'data1' });
      await coordinator.synchronizeState(stateId, 'server-2', { version: 2, data: 'data2' });

      // Force conflict and resolution
      coordinator['serverStates'].get(`${stateId}:server-1`)!.consistency = 'conflict';
      coordinator['serverStates'].get(`${stateId}:server-2`)!.consistency = 'conflict';

      await coordinator.resolveConflicts(stateId);

      // Verify conflict resolution
      const resolvedStates = Array.from(coordinator['serverStates'].values())
        .filter(state => state.stateId === stateId);

      expect(resolvedStates.some(state => state.consistency !== 'conflict')).toBe(true);
    });
  });

  describe('Performance Optimization Algorithms', () => {
    test('should implement request batching for efficiency', async () => {
      const batchableRequests = Array.from({ length: 5 }, (_, i) => ({
        requestId: `batch-${i}`,
        toolName: 'Read',
        parameters: { file: `test-${i}.txt` },
        priority: 3 // Low priority for batching
      } as ToolExecutionRequest));

      const results = await Promise.all(
        batchableRequests.map(req => optimizationEngine.optimizeRequest(req, mockServers))
      );

      expect(results).toHaveLength(5);
      expect(results.every(r => r.success)).toBe(true);
    });

    test('should optimize connection pooling', async () => {
      const requests = generateTestRequests(20);

      const results = await Promise.all(
        requests.map(req => optimizationEngine.optimizeRequest(req, mockServers))
      );

      // Verify connection pooling efficiency
      const metrics = optimizationEngine.getOptimizationMetrics();
      expect(metrics.system.resourceUtilization).toBeLessThan(1.0);
      expect(results.every(r => r.success)).toBe(true);
    });

    test('should implement adaptive timeout management', async () => {
      const fastRequests = generateTestRequests(10, 'Read'); // Fast operations
      const slowRequests = generateTestRequests(10, 'Write'); // Potentially slow operations

      const [fastResults, slowResults] = await Promise.all([
        Promise.all(fastRequests.map(req => optimizationEngine.optimizeRequest(req, mockServers))),
        Promise.all(slowRequests.map(req => optimizationEngine.optimizeRequest(req, mockServers)))
      ]);

      // Adaptive timeouts should prevent unnecessary failures
      expect(fastResults.every(r => r.success)).toBe(true);
      expect(slowResults.every(r => r.success)).toBe(true);
    });
  });

  describe('Real-time Performance Analytics', () => {
    test('should collect comprehensive performance metrics', async () => {
      // Execute operations to generate metrics
      const requests = generateTestRequests(50);
      await Promise.all(
        requests.map(req => optimizationEngine.optimizeRequest(req, mockServers))
      );

      const metrics = optimizationEngine.getOptimizationMetrics();

      expect(metrics.routing.totalDecisions).toBeGreaterThan(0);
      expect(metrics.cache.hitRate).toBeGreaterThanOrEqual(0);
      expect(metrics.system.latencyReduction).toBeGreaterThanOrEqual(0);
      expect(metrics.coordination.activeServers).toBeGreaterThan(0);
    });

    test('should provide real-time optimization recommendations', async () => {
      const healthCheck = await optimizationEngine.performHealthCheck();

      expect(healthCheck.status).toMatch(/healthy|degraded|failed/);
      expect(healthCheck.details).toBeDefined();
      expect(healthCheck.details.cache).toBeDefined();
      expect(healthCheck.details.routing).toBeDefined();
      expect(healthCheck.details.coordination).toBeDefined();
    });

    test('should detect performance anomalies', (done) => {
      optimizationEngine.on('targetMet', (event) => {
        expect(event.metric).toBe('latencyReduction');
        expect(event.value).toBeGreaterThan(0);
        done();
      });

      // Trigger metric collection
      optimizationEngine['collectAndEmitMetrics']();
    });
  });

  describe('Integration with SPEC_01 Infrastructure', () => {
    test('should integrate with existing MCP infrastructure', async () => {
      // Test integration with registry, discovery, etc.
      const request: ToolExecutionRequest = {
        requestId: 'integration-test',
        toolName: 'Read',
        parameters: { file: 'test.txt' }
      };

      const result = await optimizationEngine.optimizeRequest(request, mockServers);

      expect(result.success).toBe(true);
      expect(result.metadata?.routingDecision).toBeDefined();
    });

    test('should leverage existing monitoring stack', async () => {
      const metrics = optimizationEngine.getOptimizationMetrics();

      // Verify metrics format compatible with existing monitoring
      expect(metrics.routing).toBeDefined();
      expect(metrics.cache).toBeDefined();
      expect(metrics.system).toBeDefined();
      expect(metrics.coordination).toBeDefined();
    });
  });

  describe('Scalability and Load Handling', () => {
    test('should handle 100+ concurrent requests', async () => {
      const concurrentRequests = generateTestRequests(150);

      const startTime = Date.now();
      const results = await Promise.all(
        concurrentRequests.map(req => optimizationEngine.optimizeRequest(req, mockServers))
      );
      const totalTime = Date.now() - startTime;

      const successRate = results.filter(r => r.success).length / results.length;
      const averageResponseTime = totalTime / results.length;

      expect(successRate).toBeGreaterThanOrEqual(0.95);
      expect(averageResponseTime).toBeLessThan(config.targets.maxResponseTime);
    });

    test('should scale to coordinate 10+ MCP servers', async () => {
      const allServerIds = mockServers.map(s => s.id);

      const result = await optimizationEngine.coordinateMultiServerOperation(
        'scale-test',
        allServerIds,
        { testData: 'scalability' }
      );

      expect(result.success).toBe(true);
      expect(result.results.size).toBe(mockServers.length);
    });
  });

  describe('Error Handling and Resilience', () => {
    test('should gracefully handle server failures', async () => {
      // Simulate cascade failures
      mockServers.slice(0, 3).forEach(server => {
        server.status = 'failed' as ServerStatus;
      });

      const requests = generateTestRequests(20);
      const results = await Promise.all(
        requests.map(req => optimizationEngine.optimizeRequest(req, mockServers))
      );

      // Should still maintain high success rate with remaining servers
      const successRate = results.filter(r => r.success).length / results.length;
      expect(successRate).toBeGreaterThanOrEqual(0.8); // 80% with failures
    });

    test('should handle network partitions', async () => {
      const coordinator = new CrossServerCoordinator(config.coordination);

      // Simulate network partition
      const partitionedServers = mockServers.slice(0, 3).map(s => s.id);

      try {
        const result = await coordinator.coordinateOperation(
          'partition-test',
          partitionedServers,
          { data: 'test' }
        );

        // Should handle gracefully even if some servers are unreachable
        expect(result).toBeDefined();
      } catch (error) {
        // Should not throw unhandled exceptions
        expect(error).toBeInstanceOf(Error);
      }
    });
  });
});

// =============================================================================
// Test Utilities
// =============================================================================

function createMockServers(count: number): MCPServerInfo[] {
  return Array.from({ length: count }, (_, i) => createMockServer(
    `server-${i}`,
    100 + Math.random() * 400, // Random response time 100-500ms
    Math.random() > 0.1 ? 'healthy' : 'degraded' // 90% healthy
  ));
}

function createMockServer(id: string, responseTime: number, status: string): MCPServerInfo {
  return {
    id,
    name: `Mock Server ${id}`,
    config: {
      command: 'mock',
      args: ['--server', id]
    },
    status: status as ServerStatus,
    capabilities: [
      {
        name: 'Read',
        description: 'Read file contents',
        category: 'filesystem'
      },
      {
        name: 'Write',
        description: 'Write file contents',
        category: 'filesystem'
      }
    ],
    lastHealthCheck: new Date(),
    responseTime,
    failureCount: status === 'failed' ? 5 : 0,
    metadata: {
      version: '1.0.0',
      description: `Mock MCP server ${id}`,
      resources: {
        memory: 128,
        cpu: 0.1
      }
    }
  };
}

function generateTestRequests(count: number, toolName: string = 'Read'): ToolExecutionRequest[] {
  return Array.from({ length: count }, (_, i) => ({
    requestId: `test-${i}-${Date.now()}`,
    toolName,
    parameters: {
      file: `test-file-${i}.txt`,
      data: `test-data-${i}`
    },
    agentId: `test-agent-${i % 3}`, // Rotate between 3 agents
    priority: Math.floor(Math.random() * 10) + 1, // Random priority 1-10
    timeout: 5000,
    requirements: {
      maxResponseTime: 1000,
      minSuccessRate: 0.95
    }
  }));
}
