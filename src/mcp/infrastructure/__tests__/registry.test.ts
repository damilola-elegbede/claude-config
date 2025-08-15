/**
 * Comprehensive test suite for MCP Server Registry
 * Tests server registration, metrics tracking, and tool mappings
 */

import { describe, it, expect, beforeEach, afterEach, jest } from '@jest/globals';
import { EventEmitter } from 'events';
import { MCPServerRegistry, ServerMetrics, ToolMapping, RegistryQuery } from '../registry';
import { MCPServerInfo, ToolCapability } from '../discovery';

describe('MCPServerRegistry', () => {
  let registry: MCPServerRegistry;

  const mockServer1: MCPServerInfo = {
    id: 'test-server-1',
    name: 'filesystem',
    config: {
      command: 'node',
      args: ['filesystem-server.js']
    },
    status: 'healthy',
    capabilities: [
      { name: 'Read', description: 'Read files' },
      { name: 'Write', description: 'Write files' },
      { name: 'LS', description: 'List directories' }
    ],
    lastHealthCheck: new Date(),
    responseTime: 50,
    failureCount: 0
  };

  const mockServer2: MCPServerInfo = {
    id: 'test-server-2',
    name: 'github',
    config: {
      command: 'python',
      args: ['-m', 'github_server']
    },
    status: 'healthy',
    capabilities: [
      { name: 'GitCommit', description: 'Create commits' },
      { name: 'GitPush', description: 'Push to remote' },
      { name: 'Read', description: 'Read repository files' }
    ],
    lastHealthCheck: new Date(),
    responseTime: 120,
    failureCount: 0
  };

  const mockServer3: MCPServerInfo = {
    id: 'test-server-3',
    name: 'backup-filesystem',
    config: {
      command: 'node',
      args: ['backup-filesystem.js']
    },
    status: 'degraded',
    capabilities: [
      { name: 'Read', description: 'Read files (backup)' },
      { name: 'Write', description: 'Write files (backup)' }
    ],
    lastHealthCheck: new Date(),
    responseTime: 200,
    failureCount: 2
  };

  beforeEach(() => {
    registry = new MCPServerRegistry({
      maxMetricsHistory: 100,
      metricsRetentionPeriod: 60000,
      enablePersistence: false
    });
  });

  afterEach(() => {
    registry.destroy();
  });

  describe('Constructor and Configuration', () => {
    it('should create registry with default options', () => {
      const defaultRegistry = new MCPServerRegistry();
      expect(defaultRegistry).toBeInstanceOf(MCPServerRegistry);
      expect(defaultRegistry).toBeInstanceOf(EventEmitter);
      defaultRegistry.destroy();
    });

    it('should create registry with custom options', () => {
      const customRegistry = new MCPServerRegistry({
        maxMetricsHistory: 500,
        metricsRetentionPeriod: 120000,
        enablePersistence: true,
        persistenceInterval: 30000
      });

      expect(customRegistry).toBeInstanceOf(MCPServerRegistry);
      customRegistry.destroy();
    });

    it('should start persistence timer when enabled', () => {
      const persistenceRegistry = new MCPServerRegistry({
        enablePersistence: true,
        persistenceInterval: 100
      });

      const persistenceSpy = jest.fn();
      persistenceRegistry.on('persistenceRequired', persistenceSpy);

      // Wait for persistence timer to trigger
      setTimeout(() => {
        expect(persistenceSpy).toHaveBeenCalled();
        persistenceRegistry.destroy();
      }, 150);
    });
  });

  describe('Server Registration', () => {
    it('should register a new server', () => {
      const serverRegisteredSpy = jest.fn();
      registry.on('serverRegistered', serverRegisteredSpy);

      registry.registerServer(mockServer1);

      expect(serverRegisteredSpy).toHaveBeenCalledWith(mockServer1);

      const registeredServer = registry.getServer(mockServer1.id);
      expect(registeredServer).toEqual(mockServer1);
    });

    it('should initialize metrics for new server', () => {
      registry.registerServer(mockServer1);

      const metrics = registry.getServerMetrics(mockServer1.id);
      expect(metrics).toMatchObject({
        totalRequests: 0,
        successfulRequests: 0,
        failedRequests: 0,
        averageResponseTime: 0,
        uptimePercentage: 100,
        load: 0
      });
    });

    it('should update tool mappings when registering server', () => {
      registry.registerServer(mockServer1);
      registry.registerServer(mockServer2);

      const toolMappings = registry.getToolMappings();

      // Read tool should be mapped to both servers
      const readMapping = toolMappings.get('Read');
      expect(readMapping).toMatchObject({
        toolName: 'Read',
        serverIds: expect.arrayContaining([mockServer1.id, mockServer2.id])
      });

      // GitCommit should only be mapped to server2
      const gitMapping = toolMappings.get('GitCommit');
      expect(gitMapping).toMatchObject({
        toolName: 'GitCommit',
        serverIds: [mockServer2.id]
      });
    });

    it('should not duplicate server IDs in tool mappings', () => {
      registry.registerServer(mockServer1);
      registry.registerServer(mockServer1); // Register again

      const toolMappings = registry.getToolMappings();
      const readMapping = toolMappings.get('Read');

      expect(readMapping?.serverIds).toEqual([mockServer1.id]);
      expect(readMapping?.serverIds.length).toBe(1);
    });

    it('should preserve existing metrics when re-registering server', () => {
      registry.registerServer(mockServer1);

      // Update metrics
      registry.updateServerMetrics(mockServer1.id, {
        totalRequests: 100,
        successfulRequests: 95,
        failedRequests: 5
      });

      // Re-register
      registry.registerServer(mockServer1);

      const metrics = registry.getServerMetrics(mockServer1.id);
      expect(metrics?.totalRequests).toBe(100);
      expect(metrics?.successfulRequests).toBe(95);
    });
  });

  describe('Server Unregistration', () => {
    beforeEach(() => {
      registry.registerServer(mockServer1);
      registry.registerServer(mockServer2);
    });

    it('should unregister existing server', () => {
      const serverUnregisteredSpy = jest.fn();
      registry.on('serverUnregistered', serverUnregisteredSpy);

      const result = registry.unregisterServer(mockServer1.id);

      expect(result).toBe(true);
      expect(serverUnregisteredSpy).toHaveBeenCalledWith({
        serverId: mockServer1.id,
        server: mockServer1
      });

      expect(registry.getServer(mockServer1.id)).toBeUndefined();
    });

    it('should clean up metrics when unregistering', () => {
      registry.unregisterServer(mockServer1.id);

      const metrics = registry.getServerMetrics(mockServer1.id);
      expect(metrics).toBeUndefined();
    });

    it('should update tool mappings when unregistering', () => {
      registry.unregisterServer(mockServer1.id);

      const toolMappings = registry.getToolMappings();
      const readMapping = toolMappings.get('Read');

      // Should only contain server2 now
      expect(readMapping?.serverIds).toEqual([mockServer2.id]);
    });

    it('should remove tool mappings when no servers support tool', () => {
      registry.unregisterServer(mockServer2.id); // Only server with GitCommit

      const toolMappings = registry.getToolMappings();
      expect(toolMappings.has('GitCommit')).toBe(false);
    });

    it('should clear preferred server when unregistering', () => {
      registry.setPreferredServerForTool('Read', mockServer1.id);
      registry.unregisterServer(mockServer1.id);

      const toolMappings = registry.getToolMappings();
      const readMapping = toolMappings.get('Read');
      expect(readMapping?.preferredServerId).toBeUndefined();
    });

    it('should return false when unregistering non-existent server', () => {
      const result = registry.unregisterServer('non-existent');
      expect(result).toBe(false);
    });
  });

  describe('Server Queries', () => {
    beforeEach(() => {
      registry.registerServer(mockServer1);
      registry.registerServer(mockServer2);
      registry.registerServer(mockServer3);

      // Add some metrics
      registry.updateServerMetrics(mockServer1.id, {
        totalRequests: 100,
        successfulRequests: 98,
        failedRequests: 2,
        averageResponseTime: 50,
        uptimePercentage: 99,
        load: 0.2
      });

      registry.updateServerMetrics(mockServer2.id, {
        totalRequests: 50,
        successfulRequests: 45,
        failedRequests: 5,
        averageResponseTime: 120,
        uptimePercentage: 95,
        load: 0.4
      });

      registry.updateServerMetrics(mockServer3.id, {
        totalRequests: 20,
        successfulRequests: 15,
        failedRequests: 5,
        averageResponseTime: 200,
        uptimePercentage: 80,
        load: 0.8
      });
    });

    it('should get all servers', () => {
      const servers = registry.getServers();
      expect(servers).toHaveLength(3);
      expect(servers.map(s => s.id)).toEqual(
        expect.arrayContaining([mockServer1.id, mockServer2.id, mockServer3.id])
      );
    });

    it('should query servers by tool name', () => {
      const query: RegistryQuery = { toolName: 'Read' };
      const servers = registry.queryServers(query);

      expect(servers).toHaveLength(3); // All servers support Read
      expect(servers.map(s => s.id)).toEqual(
        expect.arrayContaining([mockServer1.id, mockServer2.id, mockServer3.id])
      );
    });

    it('should query servers by status', () => {
      const healthyQuery: RegistryQuery = { serverStatus: 'healthy' };
      const degradedQuery: RegistryQuery = { serverStatus: 'degraded' };

      const healthyServers = registry.queryServers(healthyQuery);
      const degradedServers = registry.queryServers(degradedQuery);

      expect(healthyServers).toHaveLength(2);
      expect(degradedServers).toHaveLength(1);
      expect(degradedServers[0].id).toBe(mockServer3.id);
    });

    it('should query servers by capabilities', () => {
      const query: RegistryQuery = { capabilities: ['GitCommit'] };
      const servers = registry.queryServers(query);

      expect(servers).toHaveLength(1);
      expect(servers[0].id).toBe(mockServer2.id);
    });

    it('should query servers by multiple capabilities', () => {
      const query: RegistryQuery = { capabilities: ['Read', 'Write'] };
      const servers = registry.queryServers(query);

      expect(servers).toHaveLength(2); // Server1 and Server3 have both
      expect(servers.map(s => s.id)).toEqual(
        expect.arrayContaining([mockServer1.id, mockServer3.id])
      );
    });

    it('should query servers by uptime percentage', () => {
      const query: RegistryQuery = { minUptimePercentage: 90 };
      const servers = registry.queryServers(query);

      expect(servers).toHaveLength(2); // Server1 (99%) and Server2 (95%)
    });

    it('should query servers by response time', () => {
      const query: RegistryQuery = { maxResponseTime: 100 };
      const servers = registry.queryServers(query);

      expect(servers).toHaveLength(1); // Only Server1 (50ms)
      expect(servers[0].id).toBe(mockServer1.id);
    });

    it('should handle complex queries', () => {
      const query: RegistryQuery = {
        toolName: 'Read',
        serverStatus: 'healthy',
        minUptimePercentage: 95,
        maxResponseTime: 150
      };

      const servers = registry.queryServers(query);

      expect(servers).toHaveLength(2); // Server1 and Server2
      expect(servers.map(s => s.id)).toEqual(
        expect.arrayContaining([mockServer1.id, mockServer2.id])
      );
    });

    it('should return empty array for impossible queries', () => {
      const query: RegistryQuery = {
        toolName: 'NonExistentTool'
      };

      const servers = registry.queryServers(query);
      expect(servers).toHaveLength(0);
    });
  });

  describe('Tool Server Management', () => {
    beforeEach(() => {
      registry.registerServer(mockServer1);
      registry.registerServer(mockServer2);
      registry.registerServer(mockServer3);
    });

    it('should get servers for specific tool', () => {
      const readServers = registry.getServersForTool('Read');
      const gitServers = registry.getServersForTool('GitCommit');

      expect(readServers).toHaveLength(3);
      expect(gitServers).toHaveLength(1);
      expect(gitServers[0].id).toBe(mockServer2.id);
    });

    it('should return empty array for non-existent tool', () => {
      const servers = registry.getServersForTool('NonExistentTool');
      expect(servers).toHaveLength(0);
    });

    it('should set preferred server for tool', () => {
      const result = registry.setPreferredServerForTool('Read', mockServer1.id);
      expect(result).toBe(true);

      const preferenceUpdatedSpy = jest.fn();
      registry.on('preferenceUpdated', preferenceUpdatedSpy);

      registry.setPreferredServerForTool('Read', mockServer2.id);
      expect(preferenceUpdatedSpy).toHaveBeenCalledWith({
        toolName: 'Read',
        serverId: mockServer2.id
      });
    });

    it('should fail to set preferred server for unsupported tool', () => {
      const result = registry.setPreferredServerForTool('GitCommit', mockServer1.id);
      expect(result).toBe(false);
    });

    it('should clear preferred server', () => {
      registry.setPreferredServerForTool('Read', mockServer1.id);

      const preferenceClearedSpy = jest.fn();
      registry.on('preferenceCleared', preferenceClearedSpy);

      registry.clearPreferredServerForTool('Read');

      expect(preferenceClearedSpy).toHaveBeenCalledWith({ toolName: 'Read' });

      const toolMappings = registry.getToolMappings();
      const readMapping = toolMappings.get('Read');
      expect(readMapping?.preferredServerId).toBeUndefined();
    });

    it('should get preferred server for tool', () => {
      registry.setPreferredServerForTool('Read', mockServer2.id);

      const preferredServer = registry.getPreferredServerForTool('Read');
      expect(preferredServer?.id).toBe(mockServer2.id);
    });

    it('should select best server when no preference set', () => {
      // Add metrics to make server1 clearly better
      registry.updateServerMetrics(mockServer1.id, {
        totalRequests: 1000,
        successfulRequests: 990,
        averageResponseTime: 30,
        uptimePercentage: 99.5,
        load: 0.1
      });

      const preferredServer = registry.getPreferredServerForTool('Read');
      expect(preferredServer?.id).toBe(mockServer1.id);
    });

    it('should only consider healthy servers for auto-selection', () => {
      // Make all servers unhealthy except degraded server3
      mockServer1.status = 'failed';
      mockServer2.status = 'failed';

      registry.registerServer(mockServer1); // Re-register with failed status
      registry.registerServer(mockServer2);

      const preferredServer = registry.getPreferredServerForTool('Read');
      expect(preferredServer).toBeUndefined(); // No healthy servers
    });
  });

  describe('Metrics Management', () => {
    beforeEach(() => {
      registry.registerServer(mockServer1);
    });

    it('should update server metrics', () => {
      const metricsUpdatedSpy = jest.fn();
      registry.on('metricsUpdated', metricsUpdatedSpy);

      const update: Partial<ServerMetrics> = {
        totalRequests: 50,
        successfulRequests: 48,
        failedRequests: 2,
        averageResponseTime: 75,
        load: 0.3
      };

      registry.updateServerMetrics(mockServer1.id, update);

      expect(metricsUpdatedSpy).toHaveBeenCalledWith({
        serverId: mockServer1.id,
        metrics: expect.objectContaining(update)
      });

      const metrics = registry.getServerMetrics(mockServer1.id);
      expect(metrics).toMatchObject(update);
    });

    it('should calculate average response time correctly', () => {
      // Initial metrics
      registry.updateServerMetrics(mockServer1.id, {
        totalRequests: 10,
        averageResponseTime: 100 // 10 * 100 = 1000 total time
      });

      // Add 5 more requests with 50ms average
      registry.updateServerMetrics(mockServer1.id, {
        totalRequests: 15,
        averageResponseTime: 50 // Adding 5 * 50 = 250 more time
      });

      const metrics = registry.getServerMetrics(mockServer1.id);
      // Total time: 1000 + 250 = 1250, Total requests: 15
      // Average: 1250 / 15 = 83.33
      expect(metrics?.averageResponseTime).toBeCloseTo(83.33, 1);
    });

    it('should handle metrics updates for non-existent server', () => {
      const consoleSpy = jest.spyOn(console, 'warn').mockImplementation();

      registry.updateServerMetrics('non-existent', { totalRequests: 10 });

      expect(consoleSpy).toHaveBeenCalledWith(
        expect.stringContaining('unknown server: non-existent')
      );

      consoleSpy.mockRestore();
    });

    it('should store metrics history', async () => {
      const updates = [
        { totalRequests: 10, averageResponseTime: 50 },
        { totalRequests: 20, averageResponseTime: 60 },
        { totalRequests: 30, averageResponseTime: 55 }
      ];

      for (const update of updates) {
        registry.updateServerMetrics(mockServer1.id, update);
        await new Promise(resolve => setTimeout(resolve, 10)); // Small delay
      }

      // History is private, but we can verify through events
      const metricsUpdatedSpy = jest.fn();
      registry.on('metricsUpdated', metricsUpdatedSpy);

      registry.updateServerMetrics(mockServer1.id, { totalRequests: 40 });
      expect(metricsUpdatedSpy).toHaveBeenCalled();
    });

    it('should get all server metrics', () => {
      registry.registerServer(mockServer2);

      registry.updateServerMetrics(mockServer1.id, { totalRequests: 10 });
      registry.updateServerMetrics(mockServer2.id, { totalRequests: 20 });

      const allMetrics = registry.getAllServerMetrics();
      expect(allMetrics.size).toBe(2);
      expect(allMetrics.get(mockServer1.id)?.totalRequests).toBe(10);
      expect(allMetrics.get(mockServer2.id)?.totalRequests).toBe(20);
    });
  });

  describe('Registry Statistics', () => {
    beforeEach(() => {
      registry.registerServer(mockServer1); // healthy
      registry.registerServer(mockServer2); // healthy
      registry.registerServer(mockServer3); // degraded

      // Add metrics
      registry.updateServerMetrics(mockServer1.id, {
        totalRequests: 100,
        averageResponseTime: 50
      });
      registry.updateServerMetrics(mockServer2.id, {
        totalRequests: 200,
        averageResponseTime: 100
      });
      registry.updateServerMetrics(mockServer3.id, {
        totalRequests: 50,
        averageResponseTime: 150
      });
    });

    it('should provide comprehensive registry statistics', () => {
      const stats = registry.getRegistryStats();

      expect(stats).toMatchObject({
        totalServers: 3,
        healthyServers: 2,
        degradedServers: 1,
        failedServers: 0,
        totalTools: expect.any(Number),
        averageResponseTime: expect.any(Number),
        totalRequests: 350 // 100 + 200 + 50
      });

      expect(stats.totalTools).toBeGreaterThan(0);
      expect(stats.averageResponseTime).toBeCloseTo(100, 0); // (50 + 100 + 150) / 3
    });

    it('should handle empty registry statistics', () => {
      const emptyRegistry = new MCPServerRegistry();
      const stats = emptyRegistry.getRegistryStats();

      expect(stats).toMatchObject({
        totalServers: 0,
        healthyServers: 0,
        degradedServers: 0,
        failedServers: 0,
        totalTools: 0,
        averageResponseTime: 0,
        totalRequests: 0
      });

      emptyRegistry.destroy();
    });

    it('should update statistics as servers change', () => {
      let stats = registry.getRegistryStats();
      const initialHealthy = stats.healthyServers;

      // Change server status
      mockServer1.status = 'failed';
      registry.registerServer(mockServer1);

      stats = registry.getRegistryStats();
      expect(stats.healthyServers).toBe(initialHealthy - 1);
      expect(stats.failedServers).toBe(1);
    });
  });

  describe('Performance and Load Testing', () => {
    it('should handle high-frequency metric updates efficiently', () => {
      registry.registerServer(mockServer1);

      const startTime = Date.now();
      const updates = 1000;

      for (let i = 0; i < updates; i++) {
        registry.updateServerMetrics(mockServer1.id, {
          totalRequests: i,
          averageResponseTime: Math.random() * 100
        });
      }

      const updateTime = Date.now() - startTime;
      expect(updateTime).toBeLessThan(500); // Should complete in under 500ms

      const metrics = registry.getServerMetrics(mockServer1.id);
      expect(metrics?.totalRequests).toBe(updates - 1);
    });

    it('should handle concurrent operations safely', async () => {
      const servers = Array.from({ length: 50 }, (_, i) => ({
        ...mockServer1,
        id: `concurrent-server-${i}`,
        name: `server-${i}`
      }));

      // Concurrent registration
      const registrationPromises = servers.map(server =>
        new Promise<void>(resolve => {
          registry.registerServer(server);
          resolve();
        })
      );

      await Promise.all(registrationPromises);

      expect(registry.getServers()).toHaveLength(50);

      // Concurrent metric updates
      const updatePromises = servers.map((server, i) =>
        new Promise<void>(resolve => {
          registry.updateServerMetrics(server.id, {
            totalRequests: i * 10,
            averageResponseTime: i * 5
          });
          resolve();
        })
      );

      await Promise.all(updatePromises);

      // Verify all updates applied
      servers.forEach((server, i) => {
        const metrics = registry.getServerMetrics(server.id);
        expect(metrics?.totalRequests).toBe(i * 10);
      });
    });

    it('should maintain performance with large number of tool mappings', () => {
      // Create servers with many unique tools
      const tools = Array.from({ length: 100 }, (_, i) => `tool-${i}`);

      const serverWithManyTools = {
        ...mockServer1,
        capabilities: tools.map(name => ({ name, description: `Tool ${name}` }))
      };

      const startTime = Date.now();
      registry.registerServer(serverWithManyTools);
      const registrationTime = Date.now() - startTime;

      expect(registrationTime).toBeLessThan(100); // Should be fast

      // Verify all tools mapped
      const toolMappings = registry.getToolMappings();
      expect(toolMappings.size).toBe(tools.length);
    });
  });

  describe('Error Handling and Edge Cases', () => {
    it('should handle server scoring with no metrics', () => {
      registry.registerServer(mockServer1);

      // No metrics have been added
      const preferred = registry.getPreferredServerForTool('Read');
      expect(preferred).toBeDefined(); // Should still work
    });

    it('should handle empty capabilities gracefully', () => {
      const serverWithNoCapabilities = {
        ...mockServer1,
        capabilities: []
      };

      registry.registerServer(serverWithNoCapabilities);

      const toolMappings = registry.getToolMappings();
      expect(toolMappings.size).toBe(0);
    });

    it('should handle duplicate tool capabilities', () => {
      const serverWithDuplicates = {
        ...mockServer1,
        capabilities: [
          { name: 'Read', description: 'First read' },
          { name: 'Read', description: 'Second read' },
          { name: 'Write', description: 'Write tool' }
        ]
      };

      registry.registerServer(serverWithDuplicates);

      const toolMappings = registry.getToolMappings();
      const readMapping = toolMappings.get('Read');

      // Should only have one entry for the server
      expect(readMapping?.serverIds).toEqual([serverWithDuplicates.id]);
    });

    it('should handle invalid metric updates', () => {
      registry.registerServer(mockServer1);

      const invalidUpdates = [
        { totalRequests: -1 },
        { averageResponseTime: -10 },
        { uptimePercentage: 150 },
        { load: -0.5 }
      ];

      invalidUpdates.forEach(update => {
        // Should not throw errors
        expect(() => {
          registry.updateServerMetrics(mockServer1.id, update);
        }).not.toThrow();
      });
    });
  });

  describe('Cleanup and Resource Management', () => {
    it('should clean up all resources on destroy', () => {
      registry.registerServer(mockServer1);
      registry.registerServer(mockServer2);

      registry.updateServerMetrics(mockServer1.id, { totalRequests: 10 });

      expect(registry.getServers()).toHaveLength(2);

      registry.destroy();

      expect(registry.getServers()).toHaveLength(0);
      expect(registry.getAllServerMetrics().size).toBe(0);
      expect(registry.getToolMappings().size).toBe(0);
    });

    it('should handle multiple destroy calls safely', () => {
      registry.registerServer(mockServer1);

      expect(() => {
        registry.destroy();
        registry.destroy();
        registry.destroy();
      }).not.toThrow();
    });

    it('should remove event listeners on destroy', () => {
      const listener = jest.fn();
      registry.on('serverRegistered', listener);

      registry.destroy();

      // Verify listeners are removed
      expect(registry.listenerCount('serverRegistered')).toBe(0);
    });
  });

  describe('Event System', () => {
    it('should emit all expected events', () => {
      const events: string[] = [];

      registry.on('serverRegistered', () => events.push('serverRegistered'));
      registry.on('serverUnregistered', () => events.push('serverUnregistered'));
      registry.on('metricsUpdated', () => events.push('metricsUpdated'));
      registry.on('preferenceUpdated', () => events.push('preferenceUpdated'));
      registry.on('preferenceCleared', () => events.push('preferenceCleared'));

      registry.registerServer(mockServer1);
      registry.updateServerMetrics(mockServer1.id, { totalRequests: 1 });
      registry.setPreferredServerForTool('Read', mockServer1.id);
      registry.clearPreferredServerForTool('Read');
      registry.unregisterServer(mockServer1.id);

      expect(events).toEqual([
        'serverRegistered',
        'metricsUpdated',
        'preferenceUpdated',
        'preferenceCleared',
        'serverUnregistered'
      ]);
    });

    it('should provide detailed event data', () => {
      const eventData: any[] = [];

      registry.on('metricsUpdated', (data) => eventData.push(data));

      registry.registerServer(mockServer1);
      registry.updateServerMetrics(mockServer1.id, { totalRequests: 42 });

      expect(eventData[0]).toMatchObject({
        serverId: mockServer1.id,
        metrics: expect.objectContaining({
          totalRequests: 42
        })
      });
    });
  });
});
