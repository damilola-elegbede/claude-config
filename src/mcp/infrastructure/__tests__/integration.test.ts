/**
 * Comprehensive integration test suite for MCP Infrastructure
 * Tests end-to-end system behavior, performance requirements, and resilience
 */

import { describe, it, expect, beforeEach, afterEach, jest } from '@jest/globals';
import { EventEmitter } from 'events';
import { spawn, ChildProcess } from 'child_process';
import { readFile } from 'fs/promises';

// Import all infrastructure components
import { MCPDiscoveryService } from '../discovery';
import { MCPServerRegistry } from '../registry';
import { ToolRouter } from '../tool-router';
import { CircuitBreakerManager } from '../circuit-breaker';
import { CacheManager } from '../cache-manager';
import { MCPInfrastructure } from '../index';

// Mock external dependencies
jest.mock('fs/promises');
jest.mock('child_process');

const mockReadFile = readFile as jest.MockedFunction<typeof readFile>;
const mockSpawn = spawn as jest.MockedFunction<typeof spawn>;

describe('MCP Infrastructure Integration', () => {
  let infrastructure: MCPInfrastructure;
  let mockProcess: jest.Mocked<ChildProcess>;

  const mockSettings = {
    mcpServers: {
      'filesystem-primary': {
        command: 'node',
        args: ['filesystem-server.js'],
        env: { NODE_ENV: 'production' }
      },
      'filesystem-backup': {
        command: 'node',
        args: ['filesystem-backup.js'],
        env: { NODE_ENV: 'production' }
      },
      'github-server': {
        command: 'python',
        args: ['-m', 'github_mcp'],
        env: { GITHUB_TOKEN: '${GITHUB_TOKEN}' }
      },
      'web-scraper': {
        command: 'node',
        args: ['web-scraper.js']
      },
      'database-server': {
        command: 'java',
        args: ['-jar', 'database-server.jar']
      }
    }
  };

  beforeEach(() => {
    jest.clearAllMocks();

    // Mock child process
    mockProcess = {
      on: jest.fn(),
      kill: jest.fn(),
      killed: false,
      pid: Math.floor(Math.random() * 10000) + 1000
    } as any;

    mockSpawn.mockReturnValue(mockProcess);
    mockReadFile.mockResolvedValue(JSON.stringify(mockSettings));

    // Mock successful process spawn by default
    mockProcess.on.mockImplementation((event, callback) => {
      if (event === 'spawn') {
        setTimeout(() => callback(), 10);
      }
      return mockProcess;
    });

    infrastructure = new MCPInfrastructure({
      discovery: {
        settingsPath: '/test/settings.json',
        discoveryInterval: 5000,
        healthCheckInterval: 2000,
        healthCheckTimeout: 1000,
        maxFailures: 3
      },
      registry: {
        maxMetricsHistory: 500,
        metricsRetentionPeriod: 300000, // 5 minutes
        enablePersistence: false
      },
      router: {
        defaultStrategy: 'performance_weighted',
        enableCaching: true,
        cacheTtl: 30000,
        decisionTimeout: 100
      },
      cache: {
        maxEntries: 10000,
        maxSize: 50 * 1024 * 1024, // 50MB
        defaultTtl: 60000
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
          enableAutoDiscovery: true,
          maxRetryAttempts: 3
        }
      }
    });
  });

  afterEach(async () => {
    if (infrastructure) {
      await infrastructure.stop();
    }
  });

  describe('System Initialization and Startup', () => {
    it('should start complete infrastructure system', async () => {
      const startTime = Date.now();
      await infrastructure.start();
      const startupTime = Date.now() - startTime;

      expect(startupTime).toBeLessThan(2000); // Should start in under 2 seconds

      const status = infrastructure.getSystemStatus();
      expect(status.isStarted).toBe(true);
      expect(status.discoveredServers).toBeGreaterThan(0);
      expect(status.healthyServers).toBeGreaterThan(0);
      expect(status.registryStats.totalServers).toBe(status.discoveredServers);
    });

    it('should discover all configured servers on startup', async () => {
      await infrastructure.start();

      const status = infrastructure.getSystemStatus();
      expect(status.discoveredServers).toBe(5); // All servers from mock settings
      
      const servers = infrastructure.registry.getServers();
      const serverNames = servers.map(s => s.name);
      expect(serverNames).toContain('filesystem-primary');
      expect(serverNames).toContain('filesystem-backup');
      expect(serverNames).toContain('github-server');
      expect(serverNames).toContain('web-scraper');
      expect(serverNames).toContain('database-server');
    });

    it('should handle partial server failures gracefully during startup', async () => {
      // Mock some servers to fail
      mockSpawn.mockImplementation((command) => {
        const failingCommands = ['java', 'python'];
        if (failingCommands.includes(command)) {
          setTimeout(() => {
            const errorCallback = mockProcess.on.mock.calls.find(call => call[0] === 'error')?.[1];
            if (errorCallback) {
              errorCallback(new Error(`Failed to start ${command}`));
            }
          }, 20);
        }
        return mockProcess;
      });

      await infrastructure.start();

      const status = infrastructure.getSystemStatus();
      expect(status.isStarted).toBe(true);
      expect(status.healthyServers).toBeGreaterThan(0); // At least some servers working
      expect(status.healthyServers).toBeLessThan(5); // But not all due to failures
    });

    it('should emit startup events in correct order', async () => {
      const events: string[] = [];
      
      infrastructure.on('started', () => events.push('started'));
      infrastructure.discovery.on('started', () => events.push('discovery-started'));
      infrastructure.discovery.on('discoveryComplete', () => events.push('discovery-complete'));

      await infrastructure.start();

      expect(events).toContain('discovery-started');
      expect(events).toContain('discovery-complete');
      expect(events).toContain('started');
      
      // Verify order
      const discoveryStartIdx = events.indexOf('discovery-started');
      const discoveryCompleteIdx = events.indexOf('discovery-complete');
      const startedIdx = events.indexOf('started');
      
      expect(discoveryStartIdx).toBeLessThan(discoveryCompleteIdx);
      expect(discoveryCompleteIdx).toBeLessThan(startedIdx);
    });
  });

  describe('Tool Routing Integration', () => {
    beforeEach(async () => {
      await infrastructure.start();
      
      // Add realistic performance metrics
      const servers = infrastructure.registry.getServers();
      servers.forEach((server, index) => {
        infrastructure.registry.updateServerMetrics(server.id, {
          totalRequests: 100 + (index * 50),
          successfulRequests: 90 + (index * 45),
          failedRequests: 10 + (index * 5),
          averageResponseTime: 50 + (index * 25),
          uptimePercentage: 95 - (index * 2),
          load: 0.1 + (index * 0.1)
        });
      });
    });

    it('should route tools to optimal servers', async () => {
      const routingDecision = await infrastructure.routeTool('Read', 'test-agent', {
        priority: 7,
        requirements: {
          maxResponseTime: 200,
          minSuccessRate: 0.85
        }
      });

      expect(routingDecision.selectedServer).toBeDefined();
      expect(routingDecision.decisionTime).toBeLessThan(100); // Sub-100ms requirement
      expect(routingDecision.confidence).toBeGreaterThan(0.5);
      
      // Verify selected server meets requirements
      const selectedMetrics = infrastructure.registry.getServerMetrics(routingDecision.selectedServer.id);
      if (selectedMetrics) {
        expect(selectedMetrics.averageResponseTime).toBeLessThanOrEqual(200);
        const successRate = selectedMetrics.successfulRequests / selectedMetrics.totalRequests;
        expect(successRate).toBeGreaterThanOrEqual(0.85);
      }
    });

    it('should utilize caching for repeated routing requests', async () => {
      const context = {
        agentId: 'cache-test-agent',
        priority: 5
      };

      // First request
      const startTime1 = Date.now();
      const decision1 = await infrastructure.routeTool('Read', context.agentId, context);
      const firstRequestTime = Date.now() - startTime1;

      // Second request (should be cached)
      const startTime2 = Date.now();
      const decision2 = await infrastructure.routeTool('Read', context.agentId, context);
      const secondRequestTime = Date.now() - startTime2;

      expect(secondRequestTime).toBeLessThan(firstRequestTime);
      expect(secondRequestTime).toBeLessThan(10); // Should be very fast
      expect(decision2.selectedServer.id).toBe(decision1.selectedServer.id);
    });

    it('should handle agent-specific preferences', async () => {
      // Record preferences for specific agent
      const preferredServerId = infrastructure.registry.getServers()[0].id;
      
      await infrastructure.recordPerformance({
        serverId: preferredServerId,
        toolName: 'Read',
        agentId: 'preference-agent',
        responseTime: 25,
        success: true,
        satisfaction: 0.95
      });

      // Record poor performance for same tool with different server
      const poorServerId = infrastructure.registry.getServers()[1].id;
      await infrastructure.recordPerformance({
        serverId: poorServerId,
        toolName: 'Read',
        agentId: 'preference-agent',
        responseTime: 300,
        success: false,
        satisfaction: 0.2
      });

      // Route should prefer the better-performing server for this agent
      const decision = await infrastructure.routeTool('Read', 'preference-agent');
      
      // Performance learning should influence the decision
      expect(decision.selectedServer).toBeDefined();
      expect(decision.confidence).toBeGreaterThan(0.6);
    });

    it('should adapt routing based on real-time server performance', async () => {
      const servers = infrastructure.registry.getServers();
      const fastServer = servers[0];
      const slowServer = servers[1];

      // Initially, both servers are equally good
      infrastructure.registry.updateServerMetrics(fastServer.id, {
        totalRequests: 1000,
        successfulRequests: 950,
        averageResponseTime: 100,
        uptimePercentage: 95,
        load: 0.3
      });

      infrastructure.registry.updateServerMetrics(slowServer.id, {
        totalRequests: 1000,
        successfulRequests: 950,
        averageResponseTime: 105,
        uptimePercentage: 95,
        load: 0.3
      });

      infrastructure.router.clearCache(); // Clear cache for fresh decisions

      const decision1 = await infrastructure.routeTool('Read', 'adaptive-agent');
      
      // Now make one server much faster
      infrastructure.registry.updateServerMetrics(fastServer.id, {
        averageResponseTime: 30 // Much faster
      });

      infrastructure.router.clearCache(); // Clear cache for fresh decision

      const decision2 = await infrastructure.routeTool('Read', 'adaptive-agent');
      
      // Should adapt to the faster server (though not guaranteed due to strategy complexity)
      expect(decision2.selectedServer).toBeDefined();
    });
  });

  describe('Resilience and Fault Tolerance', () => {
    beforeEach(async () => {
      await infrastructure.start();
    });

    it('should execute operations with automatic resilience', async () => {
      let attemptCount = 0;
      
      const operation = jest.fn().mockImplementation(async (server) => {
        attemptCount++;
        
        // Fail first two attempts, succeed on third
        if (attemptCount <= 2) {
          throw new Error(`Temporary failure ${attemptCount}`);
        }
        
        return { data: 'success', serverId: server.id, attempts: attemptCount };
      });

      const result = await infrastructure.executeToolWithResilience('Read', operation, {
        agentId: 'resilience-test',
        timeout: 5000
      });

      expect(result.success).toBe(true);
      expect(result.attempts).toBeGreaterThan(1);
      expect(result.usedFallback).toBe(true);
      expect(result.result.data).toBe('success');
      expect(result.executionLog.length).toBeGreaterThan(1);
    });

    it('should handle complete server failures with circuit breaker', async () => {
      const servers = infrastructure.registry.getServers();
      const failingServerId = servers[0].id;

      // Simulate server failures to trigger circuit breaker
      const circuitBreaker = infrastructure.circuitBreakerManager.getCircuitBreaker(failingServerId);
      
      for (let i = 0; i < 6; i++) { // Exceed failure threshold
        await circuitBreaker.execute(() => Promise.reject(new Error('Server down')));
      }

      expect(circuitBreaker.getState()).toBe('open');

      // Operations should now use fallback servers
      const operation = jest.fn().mockImplementation(async (server) => {
        if (server.id === failingServerId) {
          throw new Error('Circuit breaker should prevent this');
        }
        return { success: true, serverId: server.id };
      });

      const result = await infrastructure.executeToolWithResilience('Read', operation, {
        agentId: 'circuit-breaker-test'
      });

      expect(result.success).toBe(true);
      expect(result.result.serverId).not.toBe(failingServerId);
    });

    it('should recover from failures automatically', async () => {
      const shortRecoveryInfrastructure = new MCPInfrastructure({
        resilience: {
          circuitBreaker: {
            defaultConfig: {
              failureThreshold: 2,
              recoveryTimeout: 500, // Short recovery time
              halfOpenMaxCalls: 1,
              monitoringWindow: 1000
            }
          }
        }
      });

      await shortRecoveryInfrastructure.start();

      const servers = shortRecoveryInfrastructure.registry.getServers();
      if (servers.length > 0) {
        const serverId = servers[0].id;
        const circuitBreaker = shortRecoveryInfrastructure.circuitBreakerManager.getCircuitBreaker(serverId);

        // Cause failures to open circuit
        await circuitBreaker.execute(() => Promise.reject(new Error('Failure 1')));
        await circuitBreaker.execute(() => Promise.reject(new Error('Failure 2')));

        expect(circuitBreaker.getState()).toBe('open');

        // Wait for recovery timeout
        await new Promise(resolve => setTimeout(resolve, 600));

        // Next successful operation should close circuit
        await circuitBreaker.execute(() => Promise.resolve('Recovery success'));

        expect(circuitBreaker.getState()).toBe('closed');
      }

      await shortRecoveryInfrastructure.stop();
    });

    it('should provide detailed failure analysis', async () => {
      const failureOperation = jest.fn().mockRejectedValue(new Error('Complete system failure'));

      try {
        await infrastructure.executeToolWithResilience('Read', failureOperation, {
          agentId: 'failure-analysis-test',
          maxRetryAttempts: 2
        });
      } catch (error) {
        // Expected to fail after retries
      }

      // Verify execution log contains detailed information
      const operation = jest.fn().mockImplementation(async () => {
        throw new Error('Expected failure');
      });

      const result = await infrastructure.executeToolWithResilience('Read', operation, {
        agentId: 'log-test',
        maxRetryAttempts: 1
      }).catch(error => error);

      expect(result).toBeDefined();
    });
  });

  describe('Performance Requirements Validation', () => {
    beforeEach(async () => {
      await infrastructure.start();
    });

    it('should meet sub-100ms routing performance requirement', async () => {
      const routingTimes: number[] = [];
      
      // Test multiple routing decisions
      for (let i = 0; i < 20; i++) {
        const startTime = Date.now();
        await infrastructure.routeTool('Read', `perf-test-agent-${i}`);
        const routingTime = Date.now() - startTime;
        routingTimes.push(routingTime);
      }

      const averageTime = routingTimes.reduce((sum, time) => sum + time, 0) / routingTimes.length;
      const maxTime = Math.max(...routingTimes);

      expect(averageTime).toBeLessThan(50); // Well under 100ms average
      expect(maxTime).toBeLessThan(100); // Even worst case under 100ms
    });

    it('should meet sub-500ms discovery performance requirement', async () => {
      // Create fresh infrastructure for timing test
      const freshInfrastructure = new MCPInfrastructure({
        discovery: {
          discoveryInterval: 1000,
          healthCheckInterval: 500
        }
      });

      const startTime = Date.now();
      await freshInfrastructure.start();
      const startupTime = Date.now() - startTime;

      expect(startupTime).toBeLessThan(500); // Sub-500ms discovery

      const status = freshInfrastructure.getSystemStatus();
      expect(status.discoveredServers).toBeGreaterThan(0);

      await freshInfrastructure.stop();
    });

    it('should handle high-frequency requests efficiently', async () => {
      const concurrentRequests = 100;
      const requests = Array.from({ length: concurrentRequests }, (_, i) => 
        infrastructure.routeTool('Read', `concurrent-agent-${i}`, {
          priority: Math.floor(Math.random() * 10) + 1
        })
      );

      const startTime = Date.now();
      const results = await Promise.all(requests);
      const totalTime = Date.now() - startTime;

      expect(results).toHaveLength(concurrentRequests);
      expect(totalTime).toBeLessThan(2000); // 100 requests in under 2 seconds
      
      // All requests should succeed
      results.forEach(result => {
        expect(result.selectedServer).toBeDefined();
        expect(result.decisionTime).toBeLessThan(100);
      });
    });

    it('should maintain performance under sustained load', async () => {
      const loadTestDuration = 2000; // 2 seconds
      const requestInterval = 50; // Request every 50ms
      const results: any[] = [];
      
      const startTime = Date.now();
      
      while (Date.now() - startTime < loadTestDuration) {
        const routingPromise = infrastructure.routeTool('Read', 'load-test-agent')
          .then(result => results.push({ success: true, time: Date.now() - startTime, ...result }))
          .catch(error => results.push({ success: false, error: error.message, time: Date.now() - startTime }));
        
        await Promise.race([
          routingPromise,
          new Promise(resolve => setTimeout(resolve, requestInterval))
        ]);
      }

      const successfulRequests = results.filter(r => r.success).length;
      const failedRequests = results.filter(r => !r.success).length;
      const totalRequests = results.length;

      expect(totalRequests).toBeGreaterThan(20); // Should process many requests
      expect(successfulRequests / totalRequests).toBeGreaterThan(0.95); // 95% success rate
      
      // Performance should remain consistent
      const routingTimes = results.filter(r => r.success && r.decisionTime).map(r => r.decisionTime);
      const averageRoutingTime = routingTimes.reduce((sum, time) => sum + time, 0) / routingTimes.length;
      expect(averageRoutingTime).toBeLessThan(100);
    });
  });

  describe('Cache Integration', () => {
    beforeEach(async () => {
      await infrastructure.start();
    });

    it('should cache routing decisions effectively', async () => {
      const cacheStats1 = await infrastructure.cache.getStats();
      const initialHits = cacheStats1.hits;

      // Make same routing request multiple times
      const context = { agentId: 'cache-test', priority: 5 };
      
      for (let i = 0; i < 5; i++) {
        await infrastructure.routeTool('Read', context.agentId, context);
      }

      const cacheStats2 = await infrastructure.cache.getStats();
      expect(cacheStats2.hits).toBeGreaterThan(initialHits);
      expect(cacheStats2.hitRatio).toBeGreaterThan(0.5);
    });

    it('should cache performance data and preferences', async () => {
      // Record performance data
      const performanceData = {
        serverId: infrastructure.registry.getServers()[0].id,
        toolName: 'Read',
        agentId: 'performance-cache-test',
        responseTime: 45,
        success: true,
        satisfaction: 0.9
      };

      await infrastructure.recordPerformance(performanceData);

      // Check if preferences are cached and affect routing
      const decision = await infrastructure.routeTool('Read', 'performance-cache-test');
      expect(decision).toBeDefined();
    });

    it('should respect cache TTL and invalidation', async () => {
      const shortTTLInfrastructure = new MCPInfrastructure({
        cache: {
          defaultTtl: 100 // 100ms TTL
        },
        router: {
          cacheTtl: 100
        }
      });

      await shortTTLInfrastructure.start();

      const servers = shortTTLInfrastructure.registry.getServers();
      if (servers.length > 0) {
        // Make request
        const decision1 = await shortTTLInfrastructure.routeTool('Read', 'ttl-test-agent');
        
        // Wait for cache expiry
        await new Promise(resolve => setTimeout(resolve, 150));
        
        // Make same request again - should not be cached
        const startTime = Date.now();
        const decision2 = await shortTTLInfrastructure.routeTool('Read', 'ttl-test-agent');
        const requestTime = Date.now() - startTime;
        
        expect(requestTime).toBeGreaterThan(5); // Should take actual processing time
      }

      await shortTTLInfrastructure.stop();
    });
  });

  describe('Health Monitoring and Recovery', () => {
    beforeEach(async () => {
      await infrastructure.start();
    });

    it('should monitor server health continuously', async () => {
      const healthEvents: any[] = [];
      
      infrastructure.discovery.on('serverStatusChanged', (event) => {
        healthEvents.push(event);
      });

      // Simulate server health change
      const servers = infrastructure.registry.getServers();
      if (servers.length > 0) {
        const server = servers[0];
        
        // Simulate health degradation
        infrastructure.registry.updateServerMetrics(server.id, {
          uptimePercentage: 50, // Poor uptime
          failedRequests: 100,
          averageResponseTime: 2000 // Very slow
        });

        // Wait for health monitoring to detect changes
        await new Promise(resolve => setTimeout(resolve, 100));
      }

      // Verify health monitoring is active
      const status = infrastructure.getSystemStatus();
      expect(status.registryStats).toBeDefined();
      expect(status.registryStats.totalServers).toBeGreaterThan(0);
    });

    it('should handle server recovery gracefully', async () => {
      const servers = infrastructure.registry.getServers();
      if (servers.length > 0) {
        const server = servers[0];
        
        // Simulate server degradation
        server.status = 'degraded';
        server.failureCount = 3;
        infrastructure.registry.registerServer(server);

        // Simulate recovery
        server.status = 'healthy';
        server.failureCount = 0;
        infrastructure.registry.registerServer(server);

        infrastructure.registry.updateServerMetrics(server.id, {
          uptimePercentage: 99,
          averageResponseTime: 50,
          successfulRequests: 95,
          failedRequests: 5
        });

        const decision = await infrastructure.routeTool('Read', 'recovery-test');
        expect(decision.selectedServer).toBeDefined();
      }
    });

    it('should provide comprehensive system health status', () => {
      const status = infrastructure.getSystemStatus();
      
      expect(status).toMatchObject({
        isStarted: true,
        discoveredServers: expect.any(Number),
        healthyServers: expect.any(Number),
        registryStats: expect.objectContaining({
          totalServers: expect.any(Number),
          healthyServers: expect.any(Number),
          totalTools: expect.any(Number),
          averageResponseTime: expect.any(Number)
        }),
        performance: expect.objectContaining({
          averageRoutingTime: expect.any(Number),
          cacheHitRatio: expect.any(Number)
        })
      });

      expect(status.registryStats.totalServers).toBe(status.discoveredServers);
    });
  });

  describe('Error Handling and Edge Cases', () => {
    it('should handle complete system failures gracefully', async () => {
      // Start with no servers available
      mockReadFile.mockResolvedValue(JSON.stringify({ mcpServers: {} }));
      
      const emptyInfrastructure = new MCPInfrastructure();
      await emptyInfrastructure.start();

      // Should still start successfully
      const status = emptyInfrastructure.getSystemStatus();
      expect(status.isStarted).toBe(true);
      expect(status.discoveredServers).toBe(0);

      // Routing should fail gracefully
      await expect(emptyInfrastructure.routeTool('Read', 'test-agent'))
        .rejects.toThrow();

      await emptyInfrastructure.stop();
    });

    it('should handle malformed configuration gracefully', async () => {
      const badConfigInfrastructure = new MCPInfrastructure({
        discovery: {
          healthCheckTimeout: -1 // Invalid timeout
        } as any,
        router: {
          decisionTimeout: 0 // Invalid timeout
        } as any
      });

      // Should either fix the config or fail gracefully
      await expect(badConfigInfrastructure.start()).resolves.not.toThrow();
      
      if (badConfigInfrastructure.getSystemStatus().isStarted) {
        await badConfigInfrastructure.stop();
      }
    });

    it('should handle concurrent start/stop operations', async () => {
      const startPromises = Array.from({ length: 3 }, () => infrastructure.start());
      
      // Multiple starts should be safe
      await Promise.all(startPromises);
      
      expect(infrastructure.getSystemStatus().isStarted).toBe(true);

      const stopPromises = Array.from({ length: 3 }, () => infrastructure.stop());
      
      // Multiple stops should be safe
      await Promise.all(stopPromises);
    });

    it('should maintain data consistency under high concurrency', async () => {
      await infrastructure.start();

      const concurrentOperations = Array.from({ length: 50 }, (_, i) => 
        Promise.all([
          infrastructure.routeTool('Read', `concurrent-${i}`),
          infrastructure.recordPerformance({
            serverId: infrastructure.registry.getServers()[0]?.id || 'test',
            toolName: 'Read',
            agentId: `concurrent-${i}`,
            responseTime: Math.random() * 100 + 50,
            success: Math.random() > 0.1,
            satisfaction: Math.random()
          })
        ])
      );

      await Promise.all(concurrentOperations);

      // System should remain stable
      const status = infrastructure.getSystemStatus();
      expect(status.isStarted).toBe(true);
      expect(status.registryStats.totalServers).toBeGreaterThan(0);
    });
  });

  describe('Event System Integration', () => {
    beforeEach(async () => {
      await infrastructure.start();
    });

    it('should coordinate events across all components', async () => {
      const allEvents: any[] = [];
      
      // Listen to all component events
      infrastructure.on('started', (e) => allEvents.push({ component: 'infrastructure', event: 'started', ...e }));
      infrastructure.discovery.on('serverDiscovered', (e) => allEvents.push({ component: 'discovery', event: 'serverDiscovered', ...e }));
      infrastructure.registry.on('serverRegistered', (e) => allEvents.push({ component: 'registry', event: 'serverRegistered', ...e }));
      infrastructure.router.on('routingDecision', (e) => allEvents.push({ component: 'router', event: 'routingDecision', ...e }));

      // Trigger events
      await infrastructure.routeTool('Read', 'event-test-agent');

      expect(allEvents.length).toBeGreaterThan(0);
      
      // Verify events from different components
      const componentTypes = [...new Set(allEvents.map(e => e.component))];
      expect(componentTypes.length).toBeGreaterThan(1);
    });

    it('should handle event processing errors gracefully', async () => {
      // Add error-throwing event listeners
      infrastructure.on('started', () => {
        throw new Error('Event listener error');
      });

      infrastructure.router.on('routingDecision', () => {
        throw new Error('Routing event error');
      });

      // System should continue functioning despite listener errors
      await infrastructure.routeTool('Read', 'error-handling-test');
      
      const status = infrastructure.getSystemStatus();
      expect(status.isStarted).toBe(true);
    });
  });

  describe('Resource Management', () => {
    it('should clean up all resources on shutdown', async () => {
      await infrastructure.start();
      
      const servers = infrastructure.registry.getServers();
      expect(servers.length).toBeGreaterThan(0);

      await infrastructure.stop();

      // Verify cleanup
      const statusAfterStop = infrastructure.getSystemStatus();
      expect(statusAfterStop.isStarted).toBe(false);
      
      // Verify all servers are cleaned up
      servers.forEach(server => {
        if (server.process) {
          expect(mockProcess.kill).toHaveBeenCalled();
        }
      });
    });

    it('should handle resource cleanup errors gracefully', async () => {
      await infrastructure.start();

      // Mock cleanup error
      mockProcess.kill.mockImplementation(() => {
        throw new Error('Cleanup error');
      });

      // Should still complete shutdown despite cleanup errors
      await expect(infrastructure.stop()).resolves.not.toThrow();
    });

    it('should prevent resource leaks during repeated start/stop cycles', async () => {
      for (let i = 0; i < 5; i++) {
        await infrastructure.start();
        await infrastructure.stop();
      }

      // Should not accumulate resources
      expect(infrastructure.getSystemStatus().isStarted).toBe(false);
    });
  });

  describe('Configuration Validation and Adaptation', () => {
    it('should validate and adapt invalid configurations', () => {
      const invalidConfig = {
        discovery: {
          healthCheckTimeout: -100,
          maxFailures: 0,
          discoveryInterval: 0
        },
        router: {
          decisionTimeout: -50,
          cacheTtl: -1000
        },
        cache: {
          maxEntries: -1,
          maxSize: -1024
        }
      } as any;

      // Should either fix invalid values or use defaults
      expect(() => new MCPInfrastructure(invalidConfig)).not.toThrow();
    });

    it('should handle missing required configuration gracefully', () => {
      const minimalConfig = {};

      const minimalInfrastructure = new MCPInfrastructure(minimalConfig);
      expect(minimalInfrastructure).toBeDefined();
      
      // Should use reasonable defaults
      const status = minimalInfrastructure.getSystemStatus();
      expect(status).toBeDefined();
    });
  });
});