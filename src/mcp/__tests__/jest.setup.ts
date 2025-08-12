/**
 * Jest Test Setup
 * Global test configuration and utilities
 */

// Increase timeout for integration tests
jest.setTimeout(30000);

// Mock console methods to reduce test noise
const originalConsole = console;

beforeAll(() => {
  global.console = {
    ...originalConsole,
    log: jest.fn(),
    warn: jest.fn(),
    error: jest.fn(),
  };
});

afterAll(() => {
  global.console = originalConsole;
});

// Global test utilities
global.delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));