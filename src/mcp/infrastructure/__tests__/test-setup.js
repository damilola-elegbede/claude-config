/**
 * Jest test setup file for MCP Infrastructure tests
 * Configures global test environment and utilities
 */

// Extend Jest matchers with useful assertions
expect.extend({
  toBeWithinRange(received, floor, ceiling) {
    const pass = received >= floor && received <= ceiling;
    if (pass) {
      return {
        message: () =>
          `expected ${received} not to be within range ${floor} - ${ceiling}`,
        pass: true,
      };
    } else {
      return {
        message: () =>
          `expected ${received} to be within range ${floor} - ${ceiling}`,
        pass: false,
      };
    }
  },

  toBeValidDate(received) {
    const pass = received instanceof Date && !isNaN(received);
    if (pass) {
      return {
        message: () => `expected ${received} not to be a valid date`,
        pass: true,
      };
    } else {
      return {
        message: () => `expected ${received} to be a valid date`,
        pass: false,
      };
    }
  },

  toHaveLatencyLessThan(received, expectedMs) {
    const pass = typeof received === 'number' && received < expectedMs;
    if (pass) {
      return {
        message: () => `expected ${received}ms not to be less than ${expectedMs}ms`,
        pass: true,
      };
    } else {
      return {
        message: () => `expected ${received}ms to be less than ${expectedMs}ms`,
        pass: false,
      };
    }
  },

  toHavePerformanceWithin(received, metric, min, max) {
    if (!received || typeof received !== 'object' || !(metric in received)) {
      return {
        message: () => `expected object to have property '${metric}'`,
        pass: false,
      };
    }

    const value = received[metric];
    const pass = value >= min && value <= max;

    if (pass) {
      return {
        message: () => `expected ${metric}=${value} not to be within ${min}-${max}`,
        pass: true,
      };
    } else {
      return {
        message: () => `expected ${metric}=${value} to be within ${min}-${max}`,
        pass: false,
      };
    }
  },

  toBeHealthyServer(received) {
    const isHealthy = received && 
                     received.status === 'healthy' &&
                     received.responseTime >= 0 &&
                     received.failureCount >= 0 &&
                     Array.isArray(received.capabilities);

    if (isHealthy) {
      return {
        message: () => `expected server not to be healthy`,
        pass: true,
      };
    } else {
      return {
        message: () => `expected server to be healthy (status=healthy, responseTime>=0, failureCount>=0, capabilities=array)`,
        pass: false,
      };
    }
  }
});

// Global test configuration
global.TEST_CONFIG = {
  // Performance thresholds
  MAX_ROUTING_TIME: 100,     // ms
  MAX_DISCOVERY_TIME: 500,   // ms
  MAX_STARTUP_TIME: 2000,    // ms
  
  // Reliability thresholds
  MIN_SUCCESS_RATE: 0.95,    // 95%
  MIN_UPTIME: 0.90,          // 90%
  MAX_FAILURE_RATE: 0.05,    // 5%
  
  // Capacity limits
  MAX_CONCURRENT_REQUESTS: 1000,
  MAX_CACHE_SIZE: 100 * 1024 * 1024, // 100MB
  MAX_SERVERS_PER_REGISTRY: 500,
  
  // Timeouts
  DEFAULT_TEST_TIMEOUT: 10000,  // 10s
  INTEGRATION_TEST_TIMEOUT: 30000,  // 30s
  LOAD_TEST_TIMEOUT: 60000,    // 60s
};

// Global test utilities
global.TestUtils = {
  // Generate mock server data
  createMockServer(overrides = {}) {
    return {
      id: `mock-server-${Math.random().toString(36).substr(2, 9)}`,
      name: `mock-service-${Date.now()}`,
      config: {
        command: 'node',
        args: ['mock-server.js'],
        env: { NODE_ENV: 'test' }
      },
      status: 'healthy',
      capabilities: [
        { name: 'TestTool', description: 'Mock test tool' }
      ],
      lastHealthCheck: new Date(),
      responseTime: Math.floor(Math.random() * 100) + 10,
      failureCount: 0,
      ...overrides
    };
  },

  // Generate mock metrics
  createMockMetrics(overrides = {}) {
    return {
      totalRequests: Math.floor(Math.random() * 1000) + 100,
      successfulRequests: Math.floor(Math.random() * 950) + 90,
      failedRequests: Math.floor(Math.random() * 50) + 1,
      averageResponseTime: Math.floor(Math.random() * 200) + 50,
      uptimePercentage: Math.random() * 10 + 90,
      load: Math.random() * 0.5 + 0.1,
      ...overrides
    };
  },

  // Wait for condition to be true
  async waitFor(condition, timeout = 5000, interval = 100) {
    const startTime = Date.now();
    
    while (Date.now() - startTime < timeout) {
      if (await condition()) {
        return true;
      }
      await new Promise(resolve => setTimeout(resolve, interval));
    }
    
    throw new Error(`Condition not met within ${timeout}ms timeout`);
  },

  // Performance measurement utility
  async measurePerformance(operation, iterations = 1) {
    const times = [];
    
    for (let i = 0; i < iterations; i++) {
      const startTime = process.hrtime.bigint();
      await operation();
      const endTime = process.hrtime.bigint();
      
      times.push(Number(endTime - startTime) / 1000000); // Convert to milliseconds
    }
    
    return {
      min: Math.min(...times),
      max: Math.max(...times),
      average: times.reduce((sum, time) => sum + time, 0) / times.length,
      median: times.sort((a, b) => a - b)[Math.floor(times.length / 2)],
      p95: times.sort((a, b) => a - b)[Math.floor(times.length * 0.95)],
      iterations,
      times
    };
  },

  // Memory usage measurement
  getMemoryUsage() {
    const usage = process.memoryUsage();
    return {
      rss: Math.round(usage.rss / 1024 / 1024), // MB
      heapTotal: Math.round(usage.heapTotal / 1024 / 1024), // MB
      heapUsed: Math.round(usage.heapUsed / 1024 / 1024), // MB
      external: Math.round(usage.external / 1024 / 1024), // MB
    };
  },

  // Create test event emitter with tracking
  createEventTracker() {
    const events = [];
    const emitter = {
      emit: (event, data) => {
        events.push({ event, data, timestamp: new Date() });
      },
      getEvents: () => [...events],
      getEventsByType: (type) => events.filter(e => e.event === type),
      clear: () => events.length = 0,
      waitForEvent: (eventType, timeout = 5000) => {
        return new Promise((resolve, reject) => {
          const checkForEvent = () => {
            const event = events.find(e => e.event === eventType);
            if (event) {
              resolve(event);
            } else {
              setTimeout(checkForEvent, 100);
            }
          };
          
          setTimeout(() => reject(new Error(`Event ${eventType} not received within ${timeout}ms`)), timeout);
          checkForEvent();
        });
      }
    };
    
    return emitter;
  }
};

// Global error handling
process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled Rejection at:', promise, 'reason:', reason);
});

process.on('uncaughtException', (error) => {
  console.error('Uncaught Exception:', error);
});

// Clean up resources after each test
afterEach(() => {
  // Clear any lingering timers
  jest.clearAllTimers();
  
  // Force garbage collection if available
  if (global.gc) {
    global.gc();
  }
});

// Console customization for test output
const originalConsoleError = console.error;
console.error = (...args) => {
  // Filter out expected error messages during testing
  const message = args[0];
  if (typeof message === 'string' && (
    message.includes('Warning:') ||
    message.includes('Expected error for testing') ||
    message.includes('Mock error')
  )) {
    return; // Suppress expected test errors
  }
  
  originalConsoleError.apply(console, args);
};

// Set default test timeout
jest.setTimeout(global.TEST_CONFIG.DEFAULT_TEST_TIMEOUT);

console.log('🧪 MCP Infrastructure test environment initialized');
console.log(`📊 Performance thresholds: Routing<${global.TEST_CONFIG.MAX_ROUTING_TIME}ms, Discovery<${global.TEST_CONFIG.MAX_DISCOVERY_TIME}ms`);
console.log(`✅ Coverage requirement: 80% minimum across all metrics`);