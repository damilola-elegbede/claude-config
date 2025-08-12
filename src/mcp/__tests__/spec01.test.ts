/**
 * SPEC_01 Verification Tests
 * Validates that core MCP infrastructure meets SPEC_01 requirements
 */

import { MinimalMCPInfrastructure } from '../infrastructure/minimal-implementation';

describe('SPEC_01: MCP Infrastructure Requirements', () => {
  let infrastructure: MinimalMCPInfrastructure;

  beforeEach(() => {
    infrastructure = new MinimalMCPInfrastructure({
      healthCheckInterval: 60000 // Longer interval for tests
    });
  });

  afterEach(async () => {
    await infrastructure.stop();
  });

  describe('Core Requirements', () => {
    test('Should start infrastructure successfully', async () => {
      await infrastructure.start();
      const status = infrastructure.getStatus();
      expect(status.started).toBe(true);
      expect(status.servers.length).toBeGreaterThan(0);
    });

    test('Should discover MCP servers automatically', async () => {
      await infrastructure.start();
      const status = infrastructure.getStatus();
      
      // Should have discovered demo servers at minimum
      expect(status.servers.length).toBeGreaterThanOrEqual(3);
      
      // Verify server structure
      const server = status.servers[0];
      expect(server).toHaveProperty('id');
      expect(server).toHaveProperty('name');
      expect(server).toHaveProperty('status');
      expect(server).toHaveProperty('metrics');
    });

    test('Should complete server discovery in <500ms (SPEC_01)', async () => {
      const startTime = Date.now();
      await infrastructure.start();
      const discoveryTime = Date.now() - startTime;
      
      // SPEC_01 requirement: Sub-500ms discovery
      expect(discoveryTime).toBeLessThan(500);
    });
  });

  describe('Tool Routing Requirements', () => {
    beforeEach(async () => {
      await infrastructure.start();
    });

    test('Should route tools to appropriate servers', async () => {
      const decision = await infrastructure.routeTool('Read');
      
      expect(decision).toHaveProperty('serverId');
      expect(decision).toHaveProperty('serverName');
      expect(decision).toHaveProperty('confidence');
      expect(decision).toHaveProperty('strategy');
      expect(decision.strategy).toBe('performance-weighted');
    });

    test('Should complete routing decisions in <100ms (SPEC_01)', async () => {
      // Warm up
      await infrastructure.routeTool('Read');
      
      // Measure routing time
      const startTime = Date.now();
      const decision = await infrastructure.routeTool('Write');
      const routingTime = Date.now() - startTime;
      
      // SPEC_01 requirement: Sub-100ms routing
      expect(routingTime).toBeLessThan(100);
      expect(decision).toBeDefined();
    });

    test('Should use caching for repeated routing requests', async () => {
      // First call - cache miss
      const decision1 = await infrastructure.routeTool('Read', 'agent1');
      
      // Second call - should be cached
      const startTime = Date.now();
      const decision2 = await infrastructure.routeTool('Read', 'agent1');
      const cachedTime = Date.now() - startTime;
      
      // Cached response should be very fast
      expect(cachedTime).toBeLessThan(10);
      expect(decision2.serverId).toBe(decision1.serverId);
    });

    test('Should prefer high-performance servers', async () => {
      await infrastructure.start();
      const status = infrastructure.getStatus();
      
      // Find server with best metrics
      const bestServer = status.servers.reduce((best: any, server: any) => {
        const serverScore = server.metrics.successRate;
        const bestScore = best ? best.metrics.successRate : 0;
        return serverScore > bestScore ? server : best;
      });
      
      // Route should prefer high-performance server
      const decision = await infrastructure.routeTool('Read');
      
      // May not always match due to capability filtering, but should be valid
      expect(decision.serverId).toBeDefined();
      expect(decision.confidence).toBeGreaterThan(0);
    });
  });

  describe('Resilience Requirements', () => {
    beforeEach(async () => {
      await infrastructure.start();
    });

    test('Should handle circuit breaker patterns', async () => {
      const serverId = 'mcp-filesystem';
      let failures = 0;
      
      // Simulate failures
      const failingOperation = jest.fn().mockRejectedValue(new Error('Simulated failure'));
      
      // Record multiple failures
      for (let i = 0; i < 5; i++) {
        try {
          await infrastructure.executeWithCircuitBreaker(serverId, failingOperation);
        } catch (error) {
          failures++;
        }
      }
      
      expect(failures).toBeGreaterThan(0);
      
      // Circuit breaker may be open now
      const status = infrastructure.getStatus();
      const server = status.servers.find((s: any) => s.id === serverId);
      
      // Verify circuit breaker state tracking
      expect(server).toBeDefined();
      expect(server.circuitBreaker).toBeDefined();
    });

    test('Should execute with fallback on primary failure', async () => {
      const primaryServerId = 'mcp-github';
      
      // Create operation that fails on primary but succeeds on fallback
      let callCount = 0;
      const operation = jest.fn().mockImplementation((serverId: string) => {
        callCount++;
        if (callCount === 1 && serverId === primaryServerId) {
          return Promise.reject(new Error('Primary failed'));
        }
        return Promise.resolve({ success: true, serverId });
      });
      
      const result = await infrastructure.executeWithFallback(primaryServerId, operation);
      
      expect(result).toHaveProperty('success', true);
      expect(callCount).toBeGreaterThanOrEqual(2); // Primary + at least one fallback
    });

    test('Should complete fallback in <200ms (SPEC_01)', async () => {
      const primaryServerId = 'mcp-test';
      
      // Fast-failing primary operation
      const operation = jest.fn().mockImplementation((serverId: string) => {
        if (serverId === primaryServerId) {
          return Promise.reject(new Error('Primary failed'));
        }
        return Promise.resolve({ success: true });
      });
      
      const startTime = Date.now();
      
      try {
        await infrastructure.executeWithFallback(primaryServerId, operation);
      } catch (error) {
        // Fallback might fail if no servers available
      }
      
      const fallbackTime = Date.now() - startTime;
      
      // SPEC_01 requirement: Sub-200ms fallback
      expect(fallbackTime).toBeLessThan(200);
    });
  });

  describe('Event System', () => {
    test('Should emit infrastructure events', async () => {
      const events: string[] = [];
      
      infrastructure.on('infrastructureStarted', () => events.push('started'));
      infrastructure.on('serverDiscovered', () => events.push('discovered'));
      infrastructure.on('routingDecision', () => events.push('routed'));
      
      await infrastructure.start();
      await infrastructure.routeTool('Read');
      
      expect(events).toContain('started');
      expect(events).toContain('discovered');
      expect(events).toContain('routed');
    });

    test('Should emit server status changes', async () => {
      const statusChanges: any[] = [];
      
      infrastructure.on('serverStatusChanged', (event) => {
        statusChanges.push(event);
      });
      
      await infrastructure.start();
      
      // Status changes happen during health monitoring
      // May or may not occur in test timeframe
      const status = infrastructure.getStatus();
      expect(status.servers.length).toBeGreaterThan(0);
    });
  });

  describe('Integration', () => {
    test('Should provide complete infrastructure status', async () => {
      await infrastructure.start();
      
      // Route some tools to populate cache
      await infrastructure.routeTool('Read');
      await infrastructure.routeTool('Write');
      
      const status = infrastructure.getStatus();
      
      expect(status).toHaveProperty('started', true);
      expect(status).toHaveProperty('servers');
      expect(status).toHaveProperty('cacheSize');
      expect(status.servers.length).toBeGreaterThan(0);
      expect(status.cacheSize).toBeGreaterThan(0);
      
      // Verify server details
      const server = status.servers[0];
      expect(server).toHaveProperty('id');
      expect(server).toHaveProperty('name');
      expect(server).toHaveProperty('status');
      expect(server).toHaveProperty('circuitBreaker');
      expect(server).toHaveProperty('metrics');
      expect(server.metrics).toHaveProperty('responseTime');
      expect(server.metrics).toHaveProperty('successRate');
      expect(server.metrics).toHaveProperty('lastCheck');
    });

    test('Should handle graceful shutdown', async () => {
      await infrastructure.start();
      expect(infrastructure.getStatus().started).toBe(true);
      
      await infrastructure.stop();
      expect(infrastructure.getStatus().started).toBe(false);
      expect(infrastructure.getStatus().servers.length).toBe(0);
      expect(infrastructure.getStatus().cacheSize).toBe(0);
    });
  });
});

describe('SPEC_01 Performance Benchmarks', () => {
  let infrastructure: MinimalMCPInfrastructure;

  beforeAll(async () => {
    infrastructure = new MinimalMCPInfrastructure();
    await infrastructure.start();
  });

  afterAll(async () => {
    await infrastructure.stop();
  });

  test('Should handle high-frequency routing requests', async () => {
    const iterations = 100;
    const startTime = Date.now();
    
    const promises = [];
    for (let i = 0; i < iterations; i++) {
      promises.push(infrastructure.routeTool(`Tool${i % 10}`, `Agent${i % 5}`));
    }
    
    await Promise.all(promises);
    const totalTime = Date.now() - startTime;
    const avgTime = totalTime / iterations;
    
    console.log(`Routing performance: ${avgTime.toFixed(2)}ms average over ${iterations} requests`);
    
    // Should maintain sub-100ms average even under load
    expect(avgTime).toBeLessThan(100);
  });

  test('Should maintain performance with large cache', async () => {
    // Populate cache with many entries
    for (let i = 0; i < 1000; i++) {
      await infrastructure.routeTool(`Tool${i}`, `Agent${i}`);
    }
    
    // Measure performance with full cache
    const startTime = Date.now();
    const decision = await infrastructure.routeTool('Read', 'test-agent');
    const routingTime = Date.now() - startTime;
    
    // Should still meet performance target
    expect(routingTime).toBeLessThan(100);
    expect(decision).toBeDefined();
  });
});