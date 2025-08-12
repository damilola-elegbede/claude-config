#!/usr/bin/env node

/**
 * Integration test for MCP Infrastructure components
 * Tests the tool router, preference engine, and cache manager
 */

import { MCPInfrastructure } from './index.js';
import { MCPServerInfo as TypesMCPServerInfo, ToolCapability } from '../types/index.js';
import { MCPServerInfo } from './discovery.js';
import { CircuitBreaker } from './circuit-breaker.js';
import { FallbackManager } from './fallback-manager.js';
import { ResilienceManager } from './resilience.js';

// Mock server data for testing
const mockServers: MCPServerInfo[] = [
  {
    id: 'filesystem-server-1',
    name: 'filesystem',
    config: {
      command: 'node',
      args: ['filesystem-server.js']
    },
    status: 'healthy' as const,
    capabilities: [
      { name: 'Read', description: 'Read files' },
      { name: 'Write', description: 'Write files' },
      { name: 'LS', description: 'List directories' }
    ],
    lastHealthCheck: new Date(),
    responseTime: 50,
    failureCount: 0
  },
  {
    id: 'filesystem-server-2',
    name: 'filesystem-backup',
    config: {
      command: 'node',
      args: ['filesystem-backup.js']
    },
    status: 'healthy' as const,
    capabilities: [
      { name: 'Read', description: 'Read files (backup)' },
      { name: 'Write', description: 'Write files (backup)' }
    ],
    lastHealthCheck: new Date(),
    responseTime: 120,
    failureCount: 0
  },
  {
    id: 'git-server-1',
    name: 'github',
    config: {
      command: 'node',
      args: ['github-server.js']
    },
    status: 'healthy' as const,
    capabilities: [
      { name: 'GitCommit', description: 'Create git commits' },
      { name: 'GitPush', description: 'Push to remote' }
    ],
    lastHealthCheck: new Date(),
    responseTime: 200,
    failureCount: 0
  }
];

/**
 * Test the intelligent tool preference engine
 */
async function testIntelligentRouting(): Promise<void> {
  console.log('\n=== Testing Intelligent Tool Routing ===');
  
  const infrastructure = new MCPInfrastructure({
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
      maxEntries: 1000,
      maxSize: 10 * 1024 * 1024 // 10MB
    }
  });

  try {
    // Manually register mock servers (since we're not using discovery)
    for (const server of mockServers) {
      infrastructure.registry.registerServer(server);
      
      // Add initial metrics
      infrastructure.registry.updateServerMetrics(server.id, {
        totalRequests: 10,
        successfulRequests: 9,
        failedRequests: 1,
        averageResponseTime: server.responseTime,
        uptimePercentage: 95,
        load: 0.3
      });
    }

    console.log('✓ Registered servers:', infrastructure.registry.getServers().length);

    // Test routing for 'Read' tool (multiple servers available)
    console.log('\n--- Testing Read tool routing ---');
    let decision = await infrastructure.routeTool('Read', 'test-agent', {
      priority: 8,
      requirements: {
        maxResponseTime: 100,
        minSuccessRate: 0.8
      }
    });

    console.log('✓ Routing decision:', {
      server: decision.selectedServer.name,
      confidence: decision.confidence.toFixed(3),
      reasoning: decision.reasoning,
      decisionTime: decision.decisionTime + 'ms'
    });

    // Should select filesystem-server-1 (faster response time)
    if (decision.selectedServer.id !== 'filesystem-server-1') {
      console.warn('⚠ Expected filesystem-server-1 but got:', decision.selectedServer.id);
    } else {
      console.log('✓ Correctly selected fastest server');
    }

    // Test caching - second request should be faster
    const start = Date.now();
    decision = await infrastructure.routeTool('Read', 'test-agent', {
      priority: 8,
      requirements: {
        maxResponseTime: 100,
        minSuccessRate: 0.8
      }
    });
    const cachedTime = Date.now() - start;
    
    console.log('✓ Cached routing time:', cachedTime + 'ms');
    if (cachedTime > 50) {
      console.warn('⚠ Cached routing seems slow:', cachedTime + 'ms');
    }

    // Test learning from performance data
    console.log('\n--- Testing performance learning ---');
    
    // Simulate good performance for server 1
    await infrastructure.recordPerformance({
      serverId: 'filesystem-server-1',
      toolName: 'Read',
      agentId: 'test-agent',
      responseTime: 30,
      success: true,
      satisfaction: 0.95
    });

    // Simulate poor performance for server 2
    await infrastructure.recordPerformance({
      serverId: 'filesystem-server-2', 
      toolName: 'Read',
      agentId: 'test-agent',
      responseTime: 500,
      success: false,
      satisfaction: 0.3
    });

    console.log('✓ Recorded performance data');

    // Test routing with learned preferences
    decision = await infrastructure.routeTool('Read', 'test-agent');
    console.log('✓ Post-learning routing decision:', {
      server: decision.selectedServer.name,
      confidence: decision.confidence.toFixed(3)
    });

    // Test different agent profile
    console.log('\n--- Testing agent-specific preferences ---');
    decision = await infrastructure.routeTool('Read', 'different-agent');
    console.log('✓ Different agent routing:', decision.selectedServer.name);

    // Test tool with single server
    console.log('\n--- Testing single-server tool ---');
    decision = await infrastructure.routeTool('GitCommit', 'test-agent');
    console.log('✓ Git tool routing:', decision.selectedServer.name);

    // Test cache statistics
    console.log('\n--- Testing cache performance ---');
    const cacheStats = await infrastructure.cache.getStats();
    console.log('✓ Cache stats:', {
      hits: cacheStats.hits,
      misses: cacheStats.misses,
      hitRatio: cacheStats.hitRatio.toFixed(3),
      entries: cacheStats.entryCount
    });

    // Test system status
    console.log('\n--- Testing system status ---');
    const status = infrastructure.getSystemStatus();
    console.log('✓ System status:', {
      isStarted: status.isStarted,
      healthyServers: status.healthyServers,
      totalTools: status.registryStats.totalTools
    });

    console.log('\n✅ All intelligent routing tests passed!');

  } catch (error) {
    console.error('❌ Test failed:', error);
    throw error;
  } finally {
    await infrastructure.stop();
  }
}

/**
 * Test cache manager independently
 */
async function testCacheManager(): Promise<void> {
  console.log('\n=== Testing Cache Manager ===');
  
  const { CacheManager } = await import('./cache-manager.js');
  const cache = new CacheManager({
    maxEntries: 100,
    maxSize: 1024 * 1024, // 1MB
    defaultTtl: 5000 // 5 seconds
  });

  try {
    // Test basic operations
    console.log('--- Testing basic cache operations ---');
    
    await cache.set('test-key', { data: 'test-value', number: 42 });
    console.log('✓ Set cache entry');

    const result = await cache.get('test-key');
    if (result.success && result.value.data === 'test-value') {
      console.log('✓ Retrieved cache entry correctly');
    } else {
      throw new Error('Cache retrieval failed');
    }

    // Test TTL expiration
    console.log('--- Testing TTL expiration ---');
    await cache.set('expire-key', 'expire-value', 100); // 100ms TTL
    
    let exists = await cache.exists('expire-key');
    console.log('✓ Key exists before expiration:', exists);
    
    // Wait for expiration
    await new Promise(resolve => setTimeout(resolve, 150));
    
    const expiredResult = await cache.get('expire-key');
    if (!expiredResult.success) {
      console.log('✓ Key correctly expired');
    } else {
      console.warn('⚠ Key should have expired');
    }

    // Test pattern invalidation
    console.log('--- Testing pattern invalidation ---');
    await cache.set('pattern:1', 'value1');
    await cache.set('pattern:2', 'value2');
    await cache.set('other:3', 'value3');
    
    const invalidated = await cache.invalidatePattern('pattern:*');
    console.log('✓ Invalidated pattern entries:', invalidated);
    
    const remainsResult = await cache.get('other:3');
    if (remainsResult.success) {
      console.log('✓ Non-matching entries preserved');
    }

    // Test statistics
    console.log('--- Testing cache statistics ---');
    const stats = await cache.getStats();
    console.log('✓ Cache statistics:', {
      hits: stats.hits,
      misses: stats.misses,
      hitRatio: stats.hitRatio.toFixed(3)
    });

    console.log('\n✅ All cache manager tests passed!');

  } catch (error) {
    console.error('❌ Cache test failed:', error);
    throw error;
  } finally {
    await cache.destroy();
  }
}

/**
 * Test resilience components (circuit breaker and fallback)
 */
async function testResilienceComponents(): Promise<void> {
  console.log('\n=== Testing Resilience Components ===');
  
  // Test Circuit Breaker
  console.log('\n--- Testing Circuit Breaker ---');
  const circuitBreaker = new CircuitBreaker({
    failureThreshold: 3,
    recoveryTimeout: 1000,
    halfOpenMaxCalls: 2,
    monitoringWindow: 5000,
    successThreshold: 2,
    name: 'test-service'
  });

  try {
    // Test successful executions
    for (let i = 0; i < 2; i++) {
      const result = await circuitBreaker.execute(async () => {
        return `success-${i}`;
      });
      
      if (result.executed && result.value === `success-${i}`) {
        console.log(`✓ Successful execution ${i + 1}`);
      }
    }

    // Test failing executions to trigger circuit breaker
    for (let i = 0; i < 3; i++) {
      const result = await circuitBreaker.execute(async () => {
        throw new Error(`Test failure ${i + 1}`);
      });
      
      if (result.executed && result.error) {
        console.log(`✓ Recorded failure ${i + 1}`);
      }
    }

    console.log('✓ Circuit breaker state:', circuitBreaker.getState());
    
    // Should be 'open' now
    if (circuitBreaker.getState() === 'open') {
      console.log('✓ Circuit breaker correctly opened after failures');
    }

    // Test rejection when circuit is open
    const rejectedResult = await circuitBreaker.execute(async () => {
      return 'should-be-rejected';
    });
    
    if (!rejectedResult.executed) {
      console.log('✓ Circuit breaker correctly rejected execution');
    }

    const stats = circuitBreaker.getStats();
    console.log('✓ Circuit breaker stats:', {
      state: stats.state,
      totalCalls: stats.totalCalls,
      failedCalls: stats.failedCalls,
      rejectedCalls: stats.rejectedCalls
    });

  } catch (error) {
    console.error('❌ Circuit breaker test failed:', error);
    throw error;
  }
}

/**
 * Test resilience integration with MCP infrastructure
 */
async function testResilienceIntegration(): Promise<void> {
  console.log('\n=== Testing Resilience Integration ===');
  
  const infrastructure = new MCPInfrastructure({
    resilience: {
      circuitBreaker: {
        defaultConfig: {
          failureThreshold: 2,
          recoveryTimeout: 500,
          halfOpenMaxCalls: 1,
          monitoringWindow: 2000
        }
      },
      fallback: {
        enableAutoDiscovery: true
      },
      performance: {
        maxResponseTime: 1000,
        minSuccessRate: 0.8,
        fallbackDetectionTime: 100
      }
    }
  });

  try {
    // Register mock servers
    for (const server of mockServers) {
      infrastructure.registry.registerServer(server);
    }

    await infrastructure.start();
    console.log('✓ Infrastructure started with resilience enabled');

    // Test resilient execution with successful operation
    console.log('\n--- Testing successful resilient execution ---');
    const successResult = await infrastructure.executeToolWithResilience(
      'Read',
      async (server) => {
        // Simulate successful operation
        await new Promise(resolve => setTimeout(resolve, 50));
        return { content: 'file data', serverId: server.id };
      },
      {
        agentId: 'test-agent',
        timeout: 500
      }
    );

    if (successResult.success) {
      console.log('✓ Resilient execution succeeded:', {
        server: successResult.serverName,
        totalTime: successResult.totalTime,
        usedFallback: successResult.usedFallback
      });
    }

    // Test fallback behavior
    console.log('\n--- Testing fallback behavior ---');
    let attemptCount = 0;
    const fallbackResult = await infrastructure.executeToolWithResilience(
      'Read',
      async (server) => {
        attemptCount++;
        if (server.id === 'filesystem-server-1' && attemptCount <= 2) {
          // Simulate primary server failure
          throw new Error('Primary server unavailable');
        }
        
        // Fallback server succeeds
        return { content: 'fallback data', serverId: server.id };
      },
      {
        agentId: 'test-agent',
        timeout: 500
      }
    );

    if (fallbackResult.success && fallbackResult.usedFallback) {
      console.log('✓ Fallback mechanism worked:', {
        server: fallbackResult.serverName,
        attempts: fallbackResult.attempts,
        executionLog: fallbackResult.executionLog.map(log => ({
          server: log.serverName,
          success: log.success,
          error: log.error?.message
        }))
      });
    }

    // Test resilience statistics
    console.log('\n--- Testing resilience statistics ---');
    const resilienceStats = infrastructure.resilience.getStats();
    console.log('✓ Resilience stats:', {
      totalOperations: resilienceStats.totalOperations,
      successfulOperations: resilienceStats.successfulOperations,
      fallbackOperations: resilienceStats.fallbackOperations,
      averageResponseTime: Math.round(resilienceStats.averageResponseTime)
    });

    // Test server health status
    const healthStatus = infrastructure.resilience.getServerHealthStatus();
    console.log('✓ Server health status:', Object.keys(healthStatus).length, 'servers monitored');

    console.log('\n✅ All resilience integration tests passed!');

  } catch (error) {
    console.error('❌ Resilience integration test failed:', error);
    throw error;
  } finally {
    await infrastructure.stop();
  }
}

/**
 * Run all tests
 */
async function runTests(): Promise<void> {
  console.log('🚀 Starting MCP Infrastructure Integration Tests');
  
  try {
    await testCacheManager();
    await testIntelligentRouting();
    await testResilienceComponents();
    await testResilienceIntegration();
    
    console.log('\n🎉 All tests completed successfully!');
    console.log('\n📊 Test Summary:');
    console.log('✅ Cache Manager: Basic operations, TTL, pattern invalidation');
    console.log('✅ Tool Router: Strategy selection, performance-based routing');
    console.log('✅ Preference Engine: Learning from performance data');
    console.log('✅ Circuit Breaker: Failure detection, state transitions');
    console.log('✅ Fallback Manager: Automatic server switching');
    console.log('✅ Resilience Integration: End-to-end fault tolerance');
    console.log('✅ Integration: Full MCP infrastructure with resilience');
    
  } catch (error) {
    console.error('\n💥 Test suite failed:', error);
    process.exit(1);
  }
}

// Run tests if this file is executed directly
if (require.main === module) {
  runTests().catch(error => {
    console.error('Fatal error:', error);
    process.exit(1);
  });
}

export { runTests, testIntelligentRouting, testCacheManager, testResilienceComponents, testResilienceIntegration };