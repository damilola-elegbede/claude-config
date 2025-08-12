/**
 * Comprehensive test suite for MCP Circuit Breaker
 * Tests fault tolerance, state transitions, and failure recovery
 */

import { describe, it, expect, beforeEach, afterEach, jest } from '@jest/globals';
import { EventEmitter } from 'events';
import {
  CircuitBreaker,
  CircuitBreakerManager,
  CircuitBreakerConfig,
  CircuitBreakerState,
  CircuitBreakerStats,
  FailureEvent,
  StateChangeEvent
} from '../circuit-breaker';

describe('CircuitBreaker', () => {
  let circuitBreaker: CircuitBreaker;
  
  const defaultConfig: CircuitBreakerConfig = {
    failureThreshold: 5,
    recoveryTimeout: 1000,
    halfOpenMaxCalls: 3,
    monitoringWindow: 5000,
    successThreshold: 2,
    name: 'test-service'
  };

  beforeEach(() => {
    circuitBreaker = new CircuitBreaker(defaultConfig);
  });

  afterEach(() => {
    circuitBreaker.removeAllListeners();
  });

  describe('Constructor and Configuration', () => {
    it('should create circuit breaker with valid configuration', () => {
      expect(circuitBreaker).toBeInstanceOf(CircuitBreaker);
      expect(circuitBreaker).toBeInstanceOf(EventEmitter);
      expect(circuitBreaker.getState()).toBe('closed');
    });

    it('should use provided name or default', () => {
      const namedCB = new CircuitBreaker({ ...defaultConfig, name: 'custom-service' });
      const unnamedCB = new CircuitBreaker({ ...defaultConfig, name: undefined });
      
      expect(namedCB.getConfig().name).toBe('custom-service');
      expect(unnamedCB.getConfig().name).toBe('CircuitBreaker');
    });

    it('should validate configuration parameters', () => {
      const invalidConfigs = [
        { ...defaultConfig, failureThreshold: 0 },
        { ...defaultConfig, recoveryTimeout: -1 },
        { ...defaultConfig, halfOpenMaxCalls: 0 },
        { ...defaultConfig, monitoringWindow: 0 },
        { ...defaultConfig, successThreshold: 10, halfOpenMaxCalls: 5 } // Success > max calls
      ];

      invalidConfigs.forEach((config, index) => {
        expect(() => new CircuitBreaker(config)).toThrow();
      });
    });

    it('should calculate default success threshold', () => {
      const config = { ...defaultConfig };
      delete (config as any).successThreshold;
      
      const cb = new CircuitBreaker(config);
      expect(cb.getConfig().successThreshold).toBe(Math.ceil(defaultConfig.halfOpenMaxCalls / 2));
    });
  });

  describe('Basic Execution', () => {
    it('should execute successful operations', async () => {
      const mockOperation = jest.fn().mockResolvedValue('success');
      
      const result = await circuitBreaker.execute(mockOperation);

      expect(result.executed).toBe(true);
      expect(result.value).toBe('success');
      expect(result.state).toBe('closed');
      expect(result.error).toBeUndefined();
      expect(result.responseTime).toBeGreaterThan(0);
      expect(mockOperation).toHaveBeenCalledTimes(1);
    });

    it('should handle failed operations', async () => {
      const mockError = new Error('Operation failed');
      const mockOperation = jest.fn().mockRejectedValue(mockError);
      
      const result = await circuitBreaker.execute(mockOperation);

      expect(result.executed).toBe(true);
      expect(result.value).toBeUndefined();
      expect(result.error).toBe(mockError);
      expect(result.state).toBe('closed');
      expect(result.responseTime).toBeGreaterThan(0);
    });

    it('should track response times accurately', async () => {
      const delay = 100;
      const mockOperation = jest.fn().mockImplementation(
        () => new Promise(resolve => setTimeout(() => resolve('delayed'), delay))
      );
      
      const result = await circuitBreaker.execute(mockOperation);

      expect(result.responseTime).toBeGreaterThanOrEqual(delay - 10); // Allow 10ms tolerance
      expect(result.responseTime).toBeLessThan(delay + 50); // Upper bound
    });

    it('should emit events for successful operations', async () => {
      const successSpy = jest.fn();
      circuitBreaker.on('callSuccess', successSpy);

      await circuitBreaker.execute(() => Promise.resolve('test'));

      expect(successSpy).toHaveBeenCalledWith(
        expect.objectContaining({
          name: 'test-service',
          responseTime: expect.any(Number),
          state: 'closed',
          timestamp: expect.any(Date)
        })
      );
    });

    it('should emit events for failed operations', async () => {
      const failureSpy = jest.fn();
      circuitBreaker.on('callFailure', failureSpy);

      const error = new Error('Test error');
      await circuitBreaker.execute(() => Promise.reject(error));

      expect(failureSpy).toHaveBeenCalledWith(
        expect.objectContaining({
          name: 'test-service',
          error,
          responseTime: expect.any(Number),
          state: 'closed',
          timestamp: expect.any(Date)
        })
      );
    });
  });

  describe('State Transitions', () => {
    it('should transition from closed to open after failure threshold', async () => {
      const stateChangeSpy = jest.fn();
      const failureSpy = jest.fn();
      
      circuitBreaker.on('stateChange', stateChangeSpy);
      circuitBreaker.on('failure', failureSpy);

      const mockError = new Error('Service unavailable');

      // Execute failures up to threshold
      for (let i = 0; i < defaultConfig.failureThreshold; i++) {
        await circuitBreaker.execute(() => Promise.reject(mockError));
        expect(circuitBreaker.getState()).toBe('closed');
      }

      // One more failure should open circuit
      await circuitBreaker.execute(() => Promise.reject(mockError));
      
      expect(circuitBreaker.getState()).toBe('open');
      expect(stateChangeSpy).toHaveBeenCalledWith(
        expect.objectContaining({
          previousState: 'closed',
          newState: 'open',
          reason: expect.stringContaining('Failure threshold exceeded')
        })
      );
      expect(failureSpy).toHaveBeenCalled();
    });

    it('should reject executions when circuit is open', async () => {
      // Force circuit to open
      circuitBreaker.forceOpen('Test open');

      const rejectedSpy = jest.fn();
      circuitBreaker.on('callRejected', rejectedSpy);

      const result = await circuitBreaker.execute(() => Promise.resolve('should not execute'));

      expect(result.executed).toBe(false);
      expect(result.error?.message).toContain('Circuit breaker test-service is open');
      expect(rejectedSpy).toHaveBeenCalled();
    });

    it('should transition to half-open after recovery timeout', async () => {
      const shortTimeoutCB = new CircuitBreaker({
        ...defaultConfig,
        recoveryTimeout: 100 // 100ms
      });

      const stateChangeSpy = jest.fn();
      shortTimeoutCB.on('stateChange', stateChangeSpy);

      // Force open
      shortTimeoutCB.forceOpen();
      expect(shortTimeoutCB.getState()).toBe('open');

      // Wait for recovery timeout
      await new Promise(resolve => setTimeout(resolve, 150));

      // Next execution should trigger half-open
      await shortTimeoutCB.execute(() => Promise.resolve('test'));
      
      expect(stateChangeSpy).toHaveBeenCalledWith(
        expect.objectContaining({
          previousState: 'open',
          newState: 'half-open',
          reason: 'Recovery timeout elapsed'
        })
      );
    });

    it('should transition from half-open to closed on success', async () => {
      circuitBreaker.forceOpen();
      
      // Manually set to half-open state
      const stateChangeSpy = jest.fn();
      circuitBreaker.on('stateChange', stateChangeSpy);
      
      // Use reflection to set state (normally done by timeout)
      (circuitBreaker as any).state = 'half-open';
      (circuitBreaker as any).halfOpenCalls = 0;
      (circuitBreaker as any).successCount = 0;

      // Execute successful operations to meet success threshold
      for (let i = 0; i < defaultConfig.successThreshold; i++) {
        const result = await circuitBreaker.execute(() => Promise.resolve('success'));
        expect(result.executed).toBe(true);
      }

      expect(circuitBreaker.getState()).toBe('closed');
      expect(stateChangeSpy).toHaveBeenCalledWith(
        expect.objectContaining({
          previousState: 'half-open',
          newState: 'closed',
          reason: 'Sufficient successful calls in half-open state'
        })
      );
    });

    it('should transition from half-open to open on failure', async () => {
      // Set to half-open state
      (circuitBreaker as any).state = 'half-open';
      (circuitBreaker as any).halfOpenCalls = 0;

      const stateChangeSpy = jest.fn();
      circuitBreaker.on('stateChange', stateChangeSpy);

      // Any failure in half-open should reopen circuit
      await circuitBreaker.execute(() => Promise.reject(new Error('Half-open failure')));

      expect(circuitBreaker.getState()).toBe('open');
      expect(stateChangeSpy).toHaveBeenCalledWith(
        expect.objectContaining({
          previousState: 'half-open',
          newState: 'open',
          reason: 'Failure in half-open state'
        })
      );
    });

    it('should limit calls in half-open state', async () => {
      // Set to half-open
      (circuitBreaker as any).state = 'half-open';
      (circuitBreaker as any).halfOpenCalls = defaultConfig.halfOpenMaxCalls;

      const result = await circuitBreaker.execute(() => Promise.resolve('should be rejected'));

      expect(result.executed).toBe(false);
      expect(result.error?.message).toContain('half-open');
    });
  });

  describe('Statistics and Monitoring', () => {
    it('should provide comprehensive statistics', async () => {
      // Execute some operations
      await circuitBreaker.execute(() => Promise.resolve('success1'));
      await circuitBreaker.execute(() => Promise.resolve('success2'));
      await circuitBreaker.execute(() => Promise.reject(new Error('failure1')));

      const stats = circuitBreaker.getStats();

      expect(stats).toMatchObject({
        state: 'closed',
        totalCalls: 3,
        successfulCalls: 2,
        failedCalls: 1,
        rejectedCalls: 0,
        failureRate: 1/3,
        lastStateChange: expect.any(Date),
        averageResponseTime: expect.any(Number)
      });

      expect(stats.timeToRecovery).toBeUndefined(); // Not open
    });

    it('should calculate failure rate correctly', async () => {
      const operations = [
        () => Promise.resolve('success'),
        () => Promise.reject(new Error('fail')),
        () => Promise.resolve('success'),
        () => Promise.reject(new Error('fail')),
        () => Promise.reject(new Error('fail'))
      ];

      for (const op of operations) {
        await circuitBreaker.execute(op);
      }

      const stats = circuitBreaker.getStats();
      expect(stats.failureRate).toBeCloseTo(0.6, 2); // 3 failures out of 5 calls
    });

    it('should calculate average response time', async () => {
      const delays = [50, 100, 150];
      
      for (const delay of delays) {
        await circuitBreaker.execute(() => 
          new Promise(resolve => setTimeout(() => resolve('success'), delay))
        );
      }

      const stats = circuitBreaker.getStats();
      const expectedAverage = delays.reduce((sum, delay) => sum + delay, 0) / delays.length;
      
      expect(stats.averageResponseTime).toBeCloseTo(expectedAverage, -1); // Within 10ms
    });

    it('should track time to recovery when open', async () => {
      const shortRecovery = new CircuitBreaker({
        ...defaultConfig,
        recoveryTimeout: 5000
      });

      shortRecovery.forceOpen();
      
      const stats = shortRecovery.getStats();
      expect(stats.timeToRecovery).toBeGreaterThan(0);
      expect(stats.timeToRecovery).toBeLessThanOrEqual(5000);
    });

    it('should track rejected calls when circuit is open', async () => {
      circuitBreaker.forceOpen();

      await circuitBreaker.execute(() => Promise.resolve('rejected1'));
      await circuitBreaker.execute(() => Promise.resolve('rejected2'));

      const stats = circuitBreaker.getStats();
      expect(stats.rejectedCalls).toBe(2);
      expect(stats.totalCalls).toBe(0); // Rejected calls don't count as total calls
    });
  });

  describe('Manual Control', () => {
    it('should force circuit to open state', () => {
      const stateChangeSpy = jest.fn();
      circuitBreaker.on('stateChange', stateChangeSpy);

      circuitBreaker.forceOpen('Manual intervention');

      expect(circuitBreaker.getState()).toBe('open');
      expect(stateChangeSpy).toHaveBeenCalledWith(
        expect.objectContaining({
          newState: 'open',
          reason: 'Manual intervention'
        })
      );
    });

    it('should force circuit to closed state', () => {
      // First open it
      circuitBreaker.forceOpen();
      expect(circuitBreaker.getState()).toBe('open');

      const stateChangeSpy = jest.fn();
      circuitBreaker.on('stateChange', stateChangeSpy);

      circuitBreaker.forceClosed('Manual reset');

      expect(circuitBreaker.getState()).toBe('closed');
      expect(stateChangeSpy).toHaveBeenCalledWith(
        expect.objectContaining({
          newState: 'closed',
          reason: 'Manual reset'
        })
      );
    });

    it('should reset circuit breaker state', async () => {
      // Build up some state
      for (let i = 0; i < 3; i++) {
        await circuitBreaker.execute(() => Promise.reject(new Error('failure')));
      }

      const statsBefore = circuitBreaker.getStats();
      expect(statsBefore.failedCalls).toBe(3);

      circuitBreaker.reset();

      const statsAfter = circuitBreaker.getStats();
      expect(statsAfter.failedCalls).toBe(0);
      expect(statsAfter.successfulCalls).toBe(0);
      expect(statsAfter.totalCalls).toBe(0);
      expect(circuitBreaker.getState()).toBe('closed');
    });
  });

  describe('Error Handling and Edge Cases', () => {
    it('should handle synchronous errors in operations', async () => {
      const syncError = new Error('Synchronous error');
      const operation = jest.fn(() => {
        throw syncError;
      });

      const result = await circuitBreaker.execute(operation);

      expect(result.executed).toBe(true);
      expect(result.error).toBe(syncError);
      expect(result.value).toBeUndefined();
    });

    it('should handle operations that return undefined', async () => {
      const operation = jest.fn().mockResolvedValue(undefined);

      const result = await circuitBreaker.execute(operation);

      expect(result.executed).toBe(true);
      expect(result.value).toBeUndefined();
      expect(result.error).toBeUndefined();
    });

    it('should handle very fast operations', async () => {
      const operation = jest.fn().mockResolvedValue('instant');

      const result = await circuitBreaker.execute(operation);

      expect(result.responseTime).toBeGreaterThanOrEqual(0);
      expect(result.responseTime).toBeLessThan(10); // Should be very fast
    });

    it('should handle operations with complex return types', async () => {
      const complexResult = {
        data: [1, 2, 3],
        metadata: { timestamp: new Date() },
        nested: { deeply: { value: 'test' } }
      };

      const operation = jest.fn().mockResolvedValue(complexResult);

      const result = await circuitBreaker.execute(operation);

      expect(result.value).toEqual(complexResult);
    });

    it('should maintain state consistency under concurrent operations', async () => {
      const operations = Array.from({ length: 50 }, (_, i) => 
        circuitBreaker.execute(() => 
          i % 2 === 0 
            ? Promise.resolve(`success-${i}`)
            : Promise.reject(new Error(`failure-${i}`))
        )
      );

      const results = await Promise.all(operations);

      expect(results).toHaveLength(50);
      
      const stats = circuitBreaker.getStats();
      expect(stats.totalCalls).toBe(50);
      expect(stats.successfulCalls + stats.failedCalls).toBe(50);
    });
  });

  describe('Monitoring Window and Failure Rate', () => {
    it('should clean up old failures outside monitoring window', async () => {
      const shortWindowCB = new CircuitBreaker({
        ...defaultConfig,
        monitoringWindow: 100 // 100ms window
      });

      // Create failures
      await shortWindowCB.execute(() => Promise.reject(new Error('old failure')));
      
      // Wait for window to pass
      await new Promise(resolve => setTimeout(resolve, 150));
      
      // Add more failures - should only count recent ones
      for (let i = 0; i < defaultConfig.failureThreshold - 1; i++) {
        await shortWindowCB.execute(() => Promise.reject(new Error('new failure')));
      }

      // Should still be closed because old failure was cleaned up
      expect(shortWindowCB.getState()).toBe('closed');
    });

    it('should use rate-based failure detection', async () => {
      // Configure for rate-based detection
      const rateCB = new CircuitBreaker({
        ...defaultConfig,
        failureThreshold: 2,
        monitoringWindow: 1000
      });

      // Create high failure rate scenario
      const operations = [
        () => Promise.reject(new Error('fail1')),
        () => Promise.resolve('success1'),
        () => Promise.reject(new Error('fail2')),
        () => Promise.resolve('success2')
      ];

      for (const op of operations) {
        await rateCB.execute(op);
      }

      // With 50% failure rate and 2 failures, should trigger
      expect(rateCB.getState()).toBe('open');
    });
  });

  describe('Event System Comprehensive Testing', () => {
    it('should emit failure events with detailed information', async () => {
      const failureEvents: FailureEvent[] = [];
      circuitBreaker.on('failure', (event: FailureEvent) => {
        failureEvents.push(event);
      });

      const error = new Error('Test failure');
      await circuitBreaker.execute(() => Promise.reject(error));

      expect(failureEvents).toHaveLength(1);
      expect(failureEvents[0]).toMatchObject({
        name: 'test-service',
        error,
        responseTime: expect.any(Number),
        failureCount: 1,
        threshold: defaultConfig.failureThreshold,
        timestamp: expect.any(Date)
      });
    });

    it('should emit state change events with complete context', async () => {
      const stateChanges: StateChangeEvent[] = [];
      circuitBreaker.on('stateChange', (event: StateChangeEvent) => {
        stateChanges.push(event);
      });

      circuitBreaker.forceOpen('Test state change');

      expect(stateChanges).toHaveLength(1);
      expect(stateChanges[0]).toMatchObject({
        name: 'test-service',
        previousState: 'closed',
        newState: 'open',
        reason: 'Test state change',
        timestamp: expect.any(Date)
      });
    });

    it('should handle event listener errors gracefully', async () => {
      circuitBreaker.on('callSuccess', () => {
        throw new Error('Event listener error');
      });

      // Should not prevent operation from completing
      const result = await circuitBreaker.execute(() => Promise.resolve('test'));
      expect(result.value).toBe('test');
    });
  });
});

describe('CircuitBreakerManager', () => {
  let manager: CircuitBreakerManager;

  const defaultConfig = {
    failureThreshold: 3,
    recoveryTimeout: 1000,
    halfOpenMaxCalls: 2,
    monitoringWindow: 2000
  };

  beforeEach(() => {
    manager = new CircuitBreakerManager(defaultConfig);
  });

  afterEach(() => {
    manager.destroy();
  });

  describe('Circuit Breaker Creation and Management', () => {
    it('should create and return circuit breakers', () => {
      const cb1 = manager.getCircuitBreaker('service1');
      const cb2 = manager.getCircuitBreaker('service2');

      expect(cb1).toBeDefined();
      expect(cb2).toBeDefined();
      expect(cb1).not.toBe(cb2);
    });

    it('should return same instance for same service name', () => {
      const cb1 = manager.getCircuitBreaker('same-service');
      const cb2 = manager.getCircuitBreaker('same-service');

      expect(cb1).toBe(cb2);
    });

    it('should use custom config when creating circuit breakers', () => {
      const customConfig = {
        failureThreshold: 10,
        recoveryTimeout: 5000
      };

      const cb = manager.getCircuitBreaker('custom-service', customConfig);
      
      expect(cb.getConfig().failureThreshold).toBe(10);
      expect(cb.getConfig().recoveryTimeout).toBe(5000);
    });

    it('should merge custom config with defaults', () => {
      const partialConfig = {
        failureThreshold: 8
      };

      const cb = manager.getCircuitBreaker('partial-config-service', partialConfig);
      const config = cb.getConfig();
      
      expect(config.failureThreshold).toBe(8);
      expect(config.recoveryTimeout).toBe(defaultConfig.recoveryTimeout);
    });
  });

  describe('Event Forwarding', () => {
    it('should forward events from individual circuit breakers', async () => {
      const stateChangeEvents: any[] = [];
      const failureEvents: any[] = [];
      const rejectedEvents: any[] = [];

      manager.on('stateChange', (event) => stateChangeEvents.push(event));
      manager.on('failure', (event) => failureEvents.push(event));
      manager.on('callRejected', (event) => rejectedEvents.push(event));

      const cb = manager.getCircuitBreaker('test-service');
      
      // Trigger events
      cb.forceOpen('Test');
      await cb.execute(() => Promise.reject(new Error('Test failure')));
      await cb.execute(() => Promise.resolve('Should be rejected'));

      expect(stateChangeEvents).toHaveLength(1);
      expect(failureEvents).toHaveLength(1);
      expect(rejectedEvents).toHaveLength(1);
    });

    it('should handle events from multiple circuit breakers', async () => {
      const allEvents: any[] = [];
      manager.on('stateChange', (event) => allEvents.push({ type: 'stateChange', ...event }));
      manager.on('failure', (event) => allEvents.push({ type: 'failure', ...event }));

      const cb1 = manager.getCircuitBreaker('service1');
      const cb2 = manager.getCircuitBreaker('service2');

      cb1.forceOpen('Service1 test');
      cb2.forceOpen('Service2 test');

      expect(allEvents).toHaveLength(2);
      expect(allEvents.find(e => e.name === 'service1')).toBeDefined();
      expect(allEvents.find(e => e.name === 'service2')).toBeDefined();
    });
  });

  describe('Bulk Operations', () => {
    it('should get all circuit breakers', () => {
      manager.getCircuitBreaker('service1');
      manager.getCircuitBreaker('service2');
      manager.getCircuitBreaker('service3');

      const allCBs = manager.getAllCircuitBreakers();
      
      expect(allCBs.size).toBe(3);
      expect(allCBs.has('service1')).toBe(true);
      expect(allCBs.has('service2')).toBe(true);
      expect(allCBs.has('service3')).toBe(true);
    });

    it('should get statistics for all circuit breakers', async () => {
      const cb1 = manager.getCircuitBreaker('service1');
      const cb2 = manager.getCircuitBreaker('service2');

      // Generate some activity
      await cb1.execute(() => Promise.resolve('success'));
      await cb2.execute(() => Promise.reject(new Error('failure')));

      const allStats = manager.getAllStats();

      expect(allStats).toHaveProperty('service1');
      expect(allStats).toHaveProperty('service2');
      expect(allStats.service1.successfulCalls).toBe(1);
      expect(allStats.service2.failedCalls).toBe(1);
    });

    it('should reset all circuit breakers', async () => {
      const cb1 = manager.getCircuitBreaker('service1');
      const cb2 = manager.getCircuitBreaker('service2');

      // Build up some state
      await cb1.execute(() => Promise.reject(new Error('failure')));
      await cb2.execute(() => Promise.reject(new Error('failure')));
      
      cb1.forceOpen('Test');

      const allResetSpy = jest.fn();
      manager.on('allReset', allResetSpy);

      manager.resetAll();

      expect(allResetSpy).toHaveBeenCalled();
      expect(cb1.getState()).toBe('closed');
      expect(cb2.getState()).toBe('closed');
      expect(cb1.getStats().failedCalls).toBe(0);
      expect(cb2.getStats().failedCalls).toBe(0);
    });
  });

  describe('Circuit Breaker Removal', () => {
    it('should remove circuit breakers', () => {
      manager.getCircuitBreaker('temp-service');
      expect(manager.getAllCircuitBreakers().has('temp-service')).toBe(true);

      const removedSpy = jest.fn();
      manager.on('circuitBreakerRemoved', removedSpy);

      const removed = manager.removeCircuitBreaker('temp-service');

      expect(removed).toBe(true);
      expect(manager.getAllCircuitBreakers().has('temp-service')).toBe(false);
      expect(removedSpy).toHaveBeenCalledWith({ name: 'temp-service' });
    });

    it('should return false when removing non-existent circuit breaker', () => {
      const removed = manager.removeCircuitBreaker('non-existent');
      expect(removed).toBe(false);
    });

    it('should clean up event listeners when removing', () => {
      const cb = manager.getCircuitBreaker('cleanup-test');
      const initialListeners = cb.listenerCount('stateChange');
      
      manager.removeCircuitBreaker('cleanup-test');
      
      // Should have fewer listeners (manager's listeners removed)
      expect(cb.listenerCount('stateChange')).toBeLessThan(initialListeners);
    });
  });

  describe('Configuration Management', () => {
    it('should update default configuration', () => {
      const configUpdatedSpy = jest.fn();
      manager.on('defaultConfigUpdated', configUpdatedSpy);

      const newConfig = {
        failureThreshold: 10,
        recoveryTimeout: 2000
      };

      manager.updateDefaultConfig(newConfig);

      expect(configUpdatedSpy).toHaveBeenCalledWith(
        expect.objectContaining(newConfig)
      );

      // New circuit breakers should use updated defaults
      const cb = manager.getCircuitBreaker('new-service');
      expect(cb.getConfig().failureThreshold).toBe(10);
      expect(cb.getConfig().recoveryTimeout).toBe(2000);
    });

    it('should not affect existing circuit breakers when updating defaults', () => {
      const existingCB = manager.getCircuitBreaker('existing');
      const originalThreshold = existingCB.getConfig().failureThreshold;

      manager.updateDefaultConfig({ failureThreshold: 99 });

      expect(existingCB.getConfig().failureThreshold).toBe(originalThreshold);
    });
  });

  describe('Cleanup and Resource Management', () => {
    it('should clean up all resources on destroy', () => {
      const cb1 = manager.getCircuitBreaker('service1');
      const cb2 = manager.getCircuitBreaker('service2');

      const cb1ListenersBefore = cb1.listenerCount('stateChange');
      const cb2ListenersBefore = cb2.listenerCount('stateChange');

      manager.destroy();

      expect(manager.getAllCircuitBreakers().size).toBe(0);
      expect(cb1.listenerCount('stateChange')).toBeLessThan(cb1ListenersBefore);
      expect(cb2.listenerCount('stateChange')).toBeLessThan(cb2ListenersBefore);
    });

    it('should handle multiple destroy calls safely', () => {
      manager.getCircuitBreaker('test-service');
      
      expect(() => {
        manager.destroy();
        manager.destroy();
        manager.destroy();
      }).not.toThrow();
    });

    it('should remove manager event listeners on destroy', () => {
      const listener = jest.fn();
      manager.on('stateChange', listener);

      const listenersBefore = manager.listenerCount('stateChange');
      manager.destroy();
      
      expect(manager.listenerCount('stateChange')).toBe(0);
    });
  });

  describe('Edge Cases and Error Handling', () => {
    it('should handle empty service names gracefully', () => {
      const cb1 = manager.getCircuitBreaker('');
      const cb2 = manager.getCircuitBreaker('  '); // Whitespace

      expect(cb1).toBeDefined();
      expect(cb2).toBeDefined();
      expect(cb1).not.toBe(cb2);
    });

    it('should handle service names with special characters', () => {
      const specialNames = [
        'service@domain.com',
        'service/path/name',
        'service:8080',
        'service_with_underscores',
        'service-with-dashes',
        'service.with.dots'
      ];

      specialNames.forEach(name => {
        const cb = manager.getCircuitBreaker(name);
        expect(cb).toBeDefined();
        expect(cb.getConfig().name).toBe(name);
      });
    });

    it('should handle concurrent access to same service', () => {
      const promises = Array.from({ length: 10 }, () => 
        Promise.resolve(manager.getCircuitBreaker('concurrent-service'))
      );

      return Promise.all(promises).then(circuitBreakers => {
        // All should be the same instance
        const firstCB = circuitBreakers[0];
        circuitBreakers.forEach(cb => {
          expect(cb).toBe(firstCB);
        });
      });
    });

    it('should maintain integrity under high concurrency', async () => {
      const services = Array.from({ length: 50 }, (_, i) => `service-${i}`);
      
      // Create many circuit breakers concurrently
      const creationPromises = services.map(service => 
        Promise.resolve(manager.getCircuitBreaker(service))
      );

      await Promise.all(creationPromises);

      expect(manager.getAllCircuitBreakers().size).toBe(50);

      // Verify each service has its own circuit breaker
      services.forEach(service => {
        expect(manager.getAllCircuitBreakers().has(service)).toBe(true);
      });
    });
  });
});