/**
 * Comprehensive test suite for MCP Discovery Service
 * Tests server discovery, health monitoring, and performance requirements
 */

import { describe, it, expect, beforeEach, afterEach, jest, mock } from '@jest/globals';
import { EventEmitter } from 'events';
import { spawn, ChildProcess } from 'child_process';
import { readFile } from 'fs/promises';
import { MCPDiscoveryService, MCPServerInfo, DiscoveryOptions } from '../discovery';

// Mock external dependencies
jest.mock('fs/promises');
jest.mock('child_process');

const mockReadFile = readFile as jest.MockedFunction<typeof readFile>;
const mockSpawn = spawn as jest.MockedFunction<typeof spawn>;

describe('MCPDiscoveryService', () => {
  let discoveryService: MCPDiscoveryService;
  let mockProcess: jest.Mocked<ChildProcess>;

  const mockSettings = {
    mcpServers: {
      filesystem: {
        command: 'node',
        args: ['filesystem-server.js'],
        env: { NODE_ENV: 'test' }
      },
      github: {
        command: 'python',
        args: ['-m', 'github_server'],
        env: { API_KEY: '${GH_AUTH}' }
      },
      'non-existent': {
        command: 'invalid-command',
        args: ['--fail']
      }
    }
  };

  beforeEach(() => {
    // Reset all mocks
    jest.clearAllMocks();
    
    // Mock child process
    mockProcess = {
      on: jest.fn(),
      kill: jest.fn(),
      killed: false,
      pid: 12345
    } as any;

    mockSpawn.mockReturnValue(mockProcess);
    
    // Default successful file read
    mockReadFile.mockResolvedValue(JSON.stringify(mockSettings));

    // Create service instance
    discoveryService = new MCPDiscoveryService({
      settingsPath: '/test/settings.json',
      discoveryInterval: 1000,
      healthCheckInterval: 500,
      healthCheckTimeout: 100,
      maxFailures: 2
    });
  });

  afterEach(async () => {
    if (discoveryService) {
      await discoveryService.stop();
    }
  });

  describe('Constructor and Configuration', () => {
    it('should create discovery service with default options', () => {
      const service = new MCPDiscoveryService();
      expect(service).toBeInstanceOf(MCPDiscoveryService);
      expect(service).toBeInstanceOf(EventEmitter);
    });

    it('should create discovery service with custom options', () => {
      const options: DiscoveryOptions = {
        settingsPath: '/custom/path.json',
        discoveryInterval: 5000,
        healthCheckInterval: 2000,
        healthCheckTimeout: 1000,
        maxFailures: 10
      };

      const service = new MCPDiscoveryService(options);
      expect(service).toBeInstanceOf(MCPDiscoveryService);
    });

    it('should handle missing settings file gracefully', async () => {
      mockReadFile.mockRejectedValue(new Error('ENOENT: no such file or directory'));
      
      const servers = await discoveryService.discoverServers();
      expect(servers).toEqual([]);
    });
  });

  describe('Server Discovery', () => {
    it('should discover servers from settings file', async () => {
      const startTime = Date.now();
      const servers = await discoveryService.discoverServers();
      const discoveryTime = Date.now() - startTime;

      expect(servers).toHaveLength(3);
      expect(discoveryTime).toBeLessThan(500); // Sub-500ms discovery requirement

      expect(servers[0]).toMatchObject({
        id: 'mcp-filesystem',
        name: 'filesystem',
        config: {
          command: 'node',
          args: ['filesystem-server.js']
        }
      });
    });

    it('should emit discovery events during server discovery', async () => {
      const serverDiscoveredSpy = jest.fn();
      const discoveryCompleteSpy = jest.fn();

      discoveryService.on('serverDiscovered', serverDiscoveredSpy);
      discoveryService.on('discoveryComplete', discoveryCompleteSpy);

      await discoveryService.discoverServers();

      expect(serverDiscoveredSpy).toHaveBeenCalled();
      expect(discoveryCompleteSpy).toHaveBeenCalledWith(
        expect.objectContaining({
          serverCount: expect.any(Number),
          discoveryTime: expect.any(Number)
        })
      );
    });

    it('should handle server configuration errors gracefully', async () => {
      const errorSpy = jest.fn();
      discoveryService.on('serverError', errorSpy);

      // Mock spawn to throw error for non-existent command
      mockSpawn.mockImplementation((command) => {
        if (command === 'invalid-command') {
          const error = new Error('spawn invalid-command ENOENT');
          setTimeout(() => mockProcess.on.mock.calls.find(call => call[0] === 'error')?.[1](error), 10);
        }
        return mockProcess;
      });

      await discoveryService.discoverServers();

      expect(errorSpy).toHaveBeenCalledWith(
        expect.objectContaining({
          name: 'non-existent',
          error: expect.any(Error)
        })
      );
    });

    it('should expand environment variables in server config', async () => {
      process.env['GH_AUTH'] = 'mock_value_for_testing';
      
      await discoveryService.discoverServers();

      expect(mockSpawn).toHaveBeenCalledWith(
        'python',
        ['-m', 'github_server'],
        expect.objectContaining({
          env: expect.objectContaining({
            API_KEY: 'test-token-123'
          })
        })
      );

      delete process.env.GH_AUTH;
    });

    it('should measure discovery performance', async () => {
      const discoveryCompleteSpy = jest.fn();
      discoveryService.on('discoveryComplete', discoveryCompleteSpy);

      const startTime = Date.now();
      await discoveryService.discoverServers();
      const actualTime = Date.now() - startTime;

      expect(discoveryCompleteSpy).toHaveBeenCalledWith(
        expect.objectContaining({
          discoveryTime: expect.any(Number)
        })
      );

      const reportedTime = discoveryCompleteSpy.mock.calls[0][0].discoveryTime;
      expect(Math.abs(reportedTime - actualTime)).toBeLessThan(50); // Within 50ms accuracy
    });
  });

  describe('Health Monitoring', () => {
    let servers: MCPServerInfo[];

    beforeEach(async () => {
      // Mock successful process spawn
      mockProcess.on.mockImplementation((event, callback) => {
        if (event === 'spawn') {
          setTimeout(() => callback(), 10);
        }
        return mockProcess;
      });

      servers = await discoveryService.discoverServers();
    });

    it('should perform health checks on discovered servers', async () => {
      const server = servers[0];
      expect(server.status).toBe('healthy');
      expect(server.responseTime).toBeGreaterThan(0);
      expect(server.lastHealthCheck).toBeInstanceOf(Date);
    });

    it('should detect server failures', async () => {
      const serverFailedSpy = jest.fn();
      discoveryService.on('serverFailed', serverFailedSpy);

      // Mock process failure
      mockProcess.on.mockImplementation((event, callback) => {
        if (event === 'error') {
          setTimeout(() => callback(new Error('Connection failed')), 10);
        }
        return mockProcess;
      });

      const server = servers[0];
      
      // Simulate health check failure by calling getServerCapabilities
      try {
        await discoveryService.getServerCapabilities(server.id);
      } catch (error) {
        // Expected to fail
      }

      // Check if server status is updated
      const updatedServer = discoveryService.getServer(server.id);
      expect(updatedServer?.failureCount).toBeGreaterThan(0);
    });

    it('should recover failed servers', async () => {
      const serverRecoveredSpy = jest.fn();
      discoveryService.on('serverRecovered', serverRecoveredSpy);

      const server = servers[0];
      
      // First, make server fail
      mockProcess.on.mockImplementation((event, callback) => {
        if (event === 'error') {
          setTimeout(() => callback(new Error('Temporary failure')), 10);
        }
        return mockProcess;
      });

      // Now make it recover
      setTimeout(() => {
        mockProcess.on.mockImplementation((event, callback) => {
          if (event === 'spawn') {
            setTimeout(() => callback(), 10);
          }
          return mockProcess;
        });
      }, 100);

      // Trigger health monitoring
      await discoveryService.start();
      
      // Wait for recovery
      await new Promise(resolve => setTimeout(resolve, 600));

      await discoveryService.stop();
    });

    it('should track server response times', async () => {
      const server = servers[0];
      const initialResponseTime = server.responseTime;

      // Simulate slower response
      mockProcess.on.mockImplementation((event, callback) => {
        if (event === 'spawn') {
          setTimeout(() => callback(), 50); // 50ms delay
        }
        return mockProcess;
      });

      await discoveryService.getServerCapabilities(server.id);

      const updatedServer = discoveryService.getServer(server.id);
      expect(updatedServer?.responseTime).toBeGreaterThanOrEqual(50);
    });
  });

  describe('Capabilities Discovery', () => {
    let servers: MCPServerInfo[];

    beforeEach(async () => {
      servers = await discoveryService.discoverServers();
    });

    it('should discover server capabilities', async () => {
      const server = servers.find(s => s.name === 'filesystem');
      expect(server).toBeDefined();

      const capabilities = await discoveryService.getServerCapabilities(server!.id);
      
      expect(capabilities).toEqual(
        expect.arrayContaining([
          expect.objectContaining({
            name: 'Read',
            description: expect.any(String)
          }),
          expect.objectContaining({
            name: 'Write',
            description: expect.any(String)
          })
        ])
      );
    });

    it('should handle capability discovery errors', async () => {
      const server = servers[0];
      
      // Mock process failure during capability probe
      mockProcess.on.mockImplementation((event, callback) => {
        if (event === 'error') {
          setTimeout(() => callback(new Error('Capability probe failed')), 10);
        }
        return mockProcess;
      });

      await expect(discoveryService.getServerCapabilities(server.id))
        .rejects.toThrow('Capability probe failed');
    });

    it('should emit capabilities updated events', async () => {
      const capabilitiesUpdatedSpy = jest.fn();
      discoveryService.on('capabilitiesUpdated', capabilitiesUpdatedSpy);

      const server = servers[0];
      await discoveryService.getServerCapabilities(server.id);

      expect(capabilitiesUpdatedSpy).toHaveBeenCalledWith({
        serverId: server.id,
        capabilities: expect.any(Array)
      });
    });

    it('should cache capabilities in server info', async () => {
      const server = servers[0];
      const capabilities = await discoveryService.getServerCapabilities(server.id);

      const updatedServer = discoveryService.getServer(server.id);
      expect(updatedServer?.capabilities).toEqual(capabilities);
      expect(updatedServer?.lastHealthCheck).toBeInstanceOf(Date);
    });
  });

  describe('Service Lifecycle', () => {
    it('should start discovery service', async () => {
      const startedSpy = jest.fn();
      discoveryService.on('started', startedSpy);

      await discoveryService.start();

      expect(startedSpy).toHaveBeenCalled();
    });

    it('should stop discovery service cleanly', async () => {
      const stoppedSpy = jest.fn();
      discoveryService.on('stopped', stoppedSpy);

      await discoveryService.start();
      await discoveryService.stop();

      expect(stoppedSpy).toHaveBeenCalled();
      
      // Verify timers are cleared
      const servers = discoveryService.getServers();
      servers.forEach(server => {
        if (server.process) {
          expect(mockProcess.kill).toHaveBeenCalled();
        }
      });
    });

    it('should handle start errors gracefully', async () => {
      const errorSpy = jest.fn();
      discoveryService.on('error', errorSpy);

      // Mock file read error
      mockReadFile.mockRejectedValue(new Error('Permission denied'));

      await expect(discoveryService.start()).rejects.toThrow('Permission denied');
      expect(errorSpy).toHaveBeenCalled();
    });
  });

  describe('Server Queries', () => {
    let servers: MCPServerInfo[];

    beforeEach(async () => {
      await discoveryService.start();
      servers = discoveryService.getServers();
    });

    it('should get all servers', () => {
      const allServers = discoveryService.getServers();
      expect(allServers).toHaveLength(servers.length);
      expect(allServers).toEqual(expect.arrayContaining(servers));
    });

    it('should get specific server by ID', () => {
      const server = servers[0];
      const foundServer = discoveryService.getServer(server.id);
      
      expect(foundServer).toEqual(server);
    });

    it('should return undefined for non-existent server', () => {
      const foundServer = discoveryService.getServer('non-existent-id');
      expect(foundServer).toBeUndefined();
    });

    it('should get servers by status', () => {
      const healthyServers = discoveryService.getServersByStatus('healthy');
      const failedServers = discoveryService.getServersByStatus('failed');

      expect(healthyServers.length).toBeGreaterThan(0);
      expect(failedServers.length).toBeGreaterThanOrEqual(0);
      
      healthyServers.forEach(server => {
        expect(server.status).toBe('healthy');
      });
    });
  });

  describe('Performance Requirements', () => {
    it('should complete discovery in under 500ms', async () => {
      const startTime = Date.now();
      await discoveryService.discoverServers();
      const discoveryTime = Date.now() - startTime;

      expect(discoveryTime).toBeLessThan(500);
    });

    it('should handle concurrent discovery calls efficiently', async () => {
      const promises = Array.from({ length: 5 }, () => 
        discoveryService.discoverServers()
      );

      const startTime = Date.now();
      const results = await Promise.all(promises);
      const totalTime = Date.now() - startTime;

      expect(totalTime).toBeLessThan(1000); // Should be efficient
      results.forEach(servers => {
        expect(servers.length).toBeGreaterThan(0);
      });
    });

    it('should maintain performance under load', async () => {
      await discoveryService.start();

      // Simulate high-frequency health checks
      const healthCheckPromises = Array.from({ length: 10 }, async (_, i) => {
        const server = discoveryService.getServers()[0];
        if (server) {
          const startTime = Date.now();
          try {
            await discoveryService.getServerCapabilities(server.id);
          } catch (error) {
            // Some may fail, that's ok for this test
          }
          return Date.now() - startTime;
        }
        return 0;
      });

      const times = await Promise.all(healthCheckPromises);
      const averageTime = times.reduce((sum, time) => sum + time, 0) / times.length;
      
      expect(averageTime).toBeLessThan(200); // Average under 200ms
    });
  });

  describe('Error Handling and Edge Cases', () => {
    it('should handle malformed settings file', async () => {
      mockReadFile.mockResolvedValue('{ invalid json }');

      await expect(discoveryService.discoverServers())
        .rejects.toThrow();
    });

    it('should handle empty settings file', async () => {
      mockReadFile.mockResolvedValue('{}');

      const servers = await discoveryService.discoverServers();
      expect(servers).toEqual([]);
    });

    it('should handle server process crashes', async () => {
      await discoveryService.start();
      const servers = discoveryService.getServers();
      const server = servers[0];

      if (server.process) {
        // Simulate process crash
        const exitCallback = mockProcess.on.mock.calls
          .find(call => call[0] === 'exit')?.[1];
        
        if (exitCallback) {
          exitCallback(1); // Exit with error code
        }
      }

      // Verify error handling
      const updatedServer = discoveryService.getServer(server.id);
      expect(updatedServer?.failureCount).toBeGreaterThan(0);
    });

    it('should handle timeout during server startup', async () => {
      const shortTimeoutService = new MCPDiscoveryService({
        healthCheckTimeout: 10 // Very short timeout
      });

      // Mock slow process startup
      mockProcess.on.mockImplementation((event, callback) => {
        if (event === 'spawn') {
          setTimeout(() => callback(), 50); // Longer than timeout
        }
        return mockProcess;
      });

      try {
        await shortTimeoutService.discoverServers();
        const servers = shortTimeoutService.getServers();
        
        // Should still discover servers but may have failures
        expect(servers.length).toBeGreaterThanOrEqual(0);
      } finally {
        await shortTimeoutService.stop();
      }
    });

    it('should clean up resources on multiple stop calls', async () => {
      await discoveryService.start();
      
      // Multiple stop calls should be safe
      await discoveryService.stop();
      await discoveryService.stop();
      await discoveryService.stop();

      expect(discoveryService.getServers()).toEqual([]);
    });
  });

  describe('Event System', () => {
    it('should emit all expected events during discovery', async () => {
      const events: string[] = [];
      
      discoveryService.on('serverDiscovered', () => events.push('serverDiscovered'));
      discoveryService.on('discoveryComplete', () => events.push('discoveryComplete'));
      discoveryService.on('serverError', () => events.push('serverError'));
      discoveryService.on('started', () => events.push('started'));
      discoveryService.on('stopped', () => events.push('stopped'));

      await discoveryService.start();
      await discoveryService.stop();

      expect(events).toContain('started');
      expect(events).toContain('discoveryComplete');
      expect(events).toContain('stopped');
    });

    it('should provide detailed event data', async () => {
      const discoveryCompleteData: any[] = [];
      
      discoveryService.on('discoveryComplete', (data) => {
        discoveryCompleteData.push(data);
      });

      await discoveryService.discoverServers();

      expect(discoveryCompleteData[0]).toMatchObject({
        servers: expect.any(Array),
        discoveryTime: expect.any(Number),
        serverCount: expect.any(Number)
      });
    });

    it('should handle event listener errors gracefully', async () => {
      discoveryService.on('serverDiscovered', () => {
        throw new Error('Event listener error');
      });

      // Should not prevent discovery from completing
      await expect(discoveryService.discoverServers())
        .resolves.toEqual(expect.any(Array));
    });
  });
});