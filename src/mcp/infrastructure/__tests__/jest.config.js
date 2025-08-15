/**
 * Jest configuration for MCP Infrastructure tests
 */

module.exports = {
  // Test environment
  testEnvironment: 'node',

  // Test file patterns
  testMatch: [
    '**/__tests__/**/*.test.ts'
  ],

  // Module resolution
  moduleFileExtensions: ['ts', 'js', 'json'],

  // Transform TypeScript files
  transform: {
    '^.+\\.ts$': ['ts-jest', {
      useESM: false,
      tsconfig: {
        module: 'commonjs',
        target: 'es2020',
        lib: ['es2020'],
        moduleResolution: 'node',
        allowSyntheticDefaultImports: true,
        esModuleInterop: true,
        experimentalDecorators: true,
        emitDecoratorMetadata: true,
        skipLibCheck: true,
        forceConsistentCasingInFileNames: true
      }
    }]
  },

  // Module path mapping (adjust paths as needed)
  moduleNameMapping: {
    '^@/(.*)$': '<rootDir>/../../../$1',
    '^@mcp/(.*)$': '<rootDir>/../$1'
  },

  // Test setup
  setupFilesAfterEnv: ['<rootDir>/test-setup.js'],

  // Coverage configuration
  collectCoverage: true,
  coverageDirectory: '<rootDir>/coverage',
  coverageReporters: ['text', 'lcov', 'html', 'json'],

  // Coverage thresholds (80% minimum as required)
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80
    }
  },

  // Files to include in coverage
  collectCoverageFrom: [
    '../*.ts',
    '!../index.ts', // May have minimal logic
    '!../integration-test.ts', // Test file itself
    '!**/*.d.ts',
    '!**/node_modules/**'
  ],

  // Test timeout (important for integration tests)
  testTimeout: 30000,

  // Clear mocks between tests
  clearMocks: true,
  restoreMocks: true,

  // Verbose output for debugging
  verbose: true,

  // Fail fast on first error (optional)
  bail: false,

  // Parallel execution (adjust based on system)
  maxWorkers: 4,

  // Mock handling
  mockPathIgnorePatterns: [
    '/node_modules/',
    '/__fixtures__/'
  ],

  // Global setup/teardown (if needed)
  globalSetup: undefined,
  globalTeardown: undefined,

  // Error handling
  errorOnDeprecated: true,

  // Cache configuration
  cacheDirectory: '<rootDir>/.jest-cache'
};
