/**
 * MCP Server Registry Implementation
 *
 * Production-grade registry service for MCP server management implementing SPEC_01.
 * Features:
 * - Thread-safe operations with concurrent access handling
 * - Performance metrics tracking and aggregation
 * - Query interface for tool-to-server mapping
 * - Intelligent server scoring and preference management
 * - Integration with discovery service
 * - Sub-100ms query response times
 * - Redis-backed persistence for high availability
 */

import { EventEmitter } from 'events';
import { performance } from 'perf_hooks';
import {
  MCPServerInfo,
  ServerStatus,
  ToolCapability,
  ToolMapping,
  ToolMappingMetadata,
  ServerMetrics,
  RegistryQuery,
  RegistryStats,
  ServerRegistryOptions,
  MetricsDataPoint,
  PerformanceBenchmark,
  ServerRegisteredEvent,
  ServerUnregisteredEvent,
  MetricsUpdatedEvent,
  PreferenceUpdatedEvent,
  ServerRegistryError,
  RedisClient,
  BaseEvent,
  DeepPartial
} from '../types/index.js';
import { MCPDiscoveryService } from './discovery.js';

/**
 * Internal server registry entry with enhanced metadata
 */
interface RegistryEntry {
  /** Server information */
  server: MCPServerInfo;
  /** Performance metrics */
  metrics: ServerMetrics;
  /** Metrics history for trend analysis */
  metricsHistory: MetricsDataPoint[];
  /** Tool mappings */
  toolMappings: Map<string, ToolMapping>;
  /** Registration timestamp */
  registeredAt: Date;
  /** Last updated timestamp */
  lastUpdated: Date;
  /** Server score for intelligent routing */
  score: number;
  /** Lock for thread-safe operations */
  lock: Promise<void> | null;
}

/**
 * Query cache entry for performance optimization
 */
interface QueryCacheEntry {
  /** Cached results */
  results: MCPServerInfo[];
  /** Cache timestamp */
  timestamp: Date;
  /** Query hash for cache key */
  queryHash: string;
  /** Time to live in milliseconds */
  ttl: number;
}

/**
 * Server scoring weights for intelligent routing
 */
interface ScoringWeights {
  /** Performance weight (0-1) */
  performance: number;
  /** Reliability weight (0-1) */
  reliability: number;
  /** Availability weight (0-1) */
  availability: number;
  /** Load weight (0-1) */
  load: number;
}

/**
 * MCP Server Registry
 *
 * Comprehensive registry service providing:
 * - Thread-safe server management with concurrent access control
 * - High-performance query interface with sub-100ms response times
 * - Intelligent server scoring and preference management
 * - Real-time metrics tracking and aggregation
 * - Redis-backed persistence for production environments
 * - Advanced query capabilities with filtering and sorting
 * - Tool-to-server mapping optimization
 * - Integration with MCP discovery service
 */
export class MCPServerRegistry extends EventEmitter {
  private readonly servers: Map<string, RegistryEntry> = new Map();
  private readonly toolMappings: Map<string, ToolMapping> = new Map();
  private readonly queryCache: Map<string, QueryCacheEntry> = new Map();
  private readonly options: Required<ServerRegistryOptions>;
  private readonly scoringWeights: ScoringWeights = {
    performance: 0.3,
    reliability: 0.25,
    availability: 0.25,
    load: 0.2
  };

  // Thread safety and concurrency control
  private readonly globalLock = Promise.resolve();
  private readonly operationQueue: Array<() => Promise<void>> = [];
  private isProcessingQueue = false;

  // Performance tracking
  private readonly performanceMetrics = {
    totalQueries: 0,
    averageQueryTime: 0,
    cacheHitRate: 0,
    totalCacheHits: 0,
    totalCacheMisses: 0,
    totalRegistrations: 0,
    totalUnregistrations: 0
  };

  // Service state
  private isRunning = false;
  private cleanupTimer?: NodeJS.Timeout;
  private metricsAggregationTimer?: NodeJS.Timeout;
  private redisClient?: RedisClient;

  constructor(
    options: ServerRegistryOptions = {},
    private readonly discoveryService?: MCPDiscoveryService,
    redisClient?: RedisClient
  ) {
    super();

    // Set maximum listeners for high-concurrency scenarios
    this.setMaxListeners(100);

    // Configure options with production defaults
    this.options = {
      maxMetricsHistory: options.maxMetricsHistory || 1000,
      metricsRetentionPeriod: options.metricsRetentionPeriod || 7 * 24 * 60 * 60 * 1000, // 7 days
      enablePersistence: options.enablePersistence ?? true,
      persistenceInterval: options.persistenceInterval || 30000, // 30 seconds
      redisOptions: options.redisOptions
    };

    this.redisClient = redisClient;

    // Setup error handling and monitoring
    this.setupErrorHandling();
    this.setupDiscoveryIntegration();
  }

  /**
   * Initialize the registry service
   */
  async initialize(): Promise<void> {
    if (this.isRunning) {
      throw new ServerRegistryError('Registry is already running');
    }

    try {
      console.log('🗄️  Initializing MCP Server Registry...');
      const startTime = performance.now();

      // Initialize Redis client if persistence is enabled
      if (this.options.enablePersistence && this.redisClient) {
        await this.initializeRedis();
        await this.loadPersistedData();
      }

      // Start background services
      this.startCleanupService();
      this.startMetricsAggregation();

      this.isRunning = true;
      const initTime = Math.round(performance.now() - startTime);

      const initEvent: BaseEvent = {
        timestamp: new Date(),
        source: 'server-registry',
        eventId: `init-${Date.now()}`
      };

      this.emit('initialized', initEvent);
      console.log(`✅ MCP Server Registry initialized in ${initTime}ms`);

    } catch (error) {
      console.error('❌ Failed to initialize MCP Server Registry:', error);
      throw new ServerRegistryError(`Registry initialization failed: ${error}`, { error });
    }
  }

  /**
   * Shutdown the registry service gracefully
   */
  async shutdown(): Promise<void> {
    if (!this.isRunning) {
      return;
    }

    console.log('🛑 Shutting down MCP Server Registry...');

    // Clear timers
    if (this.cleanupTimer) {
      clearTimeout(this.cleanupTimer);
    }
    if (this.metricsAggregationTimer) {
      clearTimeout(this.metricsAggregationTimer);
    }

    // Persist data if enabled
    if (this.options.enablePersistence && this.redisClient) {
      await this.persistData();
      await this.redisClient.disconnect();
    }

    // Clear caches and registries
    this.servers.clear();
    this.toolMappings.clear();
    this.queryCache.clear();

    this.isRunning = false;

    const shutdownEvent: BaseEvent = {
      timestamp: new Date(),
      source: 'server-registry',
      eventId: `shutdown-${Date.now()}`
    };

    this.emit('shutdown', shutdownEvent);
    console.log('✅ MCP Server Registry shutdown complete');
  }

  /**
   * Register a server with thread-safe operations
   */
  async registerServer(server: MCPServerInfo): Promise<void> {
    return this.executeWithLock(async () => {
      const startTime = performance.now();

      try {
        // Validate server information
        this.validateServerInfo(server);

        // Create registry entry
        const entry: RegistryEntry = {
          server: { ...server },
          metrics: this.initializeMetrics(),
          metricsHistory: [],
          toolMappings: new Map(),
          registeredAt: new Date(),
          lastUpdated: new Date(),
          score: 0,
          lock: null
        };

        // Calculate initial server score
        entry.score = await this.calculateServerScore(entry);

        // Register server
        this.servers.set(server.id, entry);

        // Update tool mappings
        await this.updateToolMappings(entry);

        // Clear query cache
        this.clearQueryCache();

        // Track metrics
        this.performanceMetrics.totalRegistrations++;

        const registrationTime = Math.round(performance.now() - startTime);

        // Emit registration event
        const registeredEvent: ServerRegisteredEvent = {
          timestamp: new Date(),
          source: 'server-registry',
          eventId: `registered-${server.id}-${Date.now()}`,
          server
        };

        this.emit('serverRegistered', registeredEvent);

        // Persist to Redis if enabled
        if (this.options.enablePersistence && this.redisClient) {
          await this.persistServerData(server.id, entry);
        }

        console.log(`✅ Server ${server.name} registered in ${registrationTime}ms (score: ${entry.score.toFixed(2)})`);

      } catch (error) {
        console.error(`❌ Failed to register server ${server.name}:`, error);
        throw new ServerRegistryError(`Server registration failed: ${error}`, { serverId: server.id, error });
      }
    });
  }

  /**
   * Unregister a server with cleanup
   */
  async unregisterServer(serverId: string): Promise<void> {
    return this.executeWithLock(async () => {
      const entry = this.servers.get(serverId);
      if (!entry) {
        throw new ServerRegistryError(`Server ${serverId} not found`, { serverId });
      }

      try {
        // Remove server
        this.servers.delete(serverId);

        // Remove tool mappings
        entry.toolMappings.forEach((mapping, toolName) => {
          const globalMapping = this.toolMappings.get(toolName);
          if (globalMapping) {
            globalMapping.serverIds = globalMapping.serverIds.filter(id => id !== serverId);
            if (globalMapping.serverIds.length === 0) {
              this.toolMappings.delete(toolName);
            } else if (globalMapping.preferredServerId === serverId) {
              // Reassign preferred server
              globalMapping.preferredServerId = this.findBestServerForTool(toolName);
            }
          }
        });

        // Clear query cache
        this.clearQueryCache();

        // Track metrics
        this.performanceMetrics.totalUnregistrations++;

        // Emit unregistration event
        const unregisteredEvent: ServerUnregisteredEvent = {
          timestamp: new Date(),
          source: 'server-registry',
          eventId: `unregistered-${serverId}-${Date.now()}`,
          serverId,
          server: entry.server
        };

        this.emit('serverUnregistered', unregisteredEvent);

        // Remove from Redis if enabled
        if (this.options.enablePersistence && this.redisClient) {
          await this.redisClient.del(`mcp:server:${serverId}`);
        }

        console.log(`✅ Server ${entry.server.name} unregistered`);

      } catch (error) {
        console.error(`❌ Failed to unregister server ${serverId}:`, error);
        throw new ServerRegistryError(`Server unregistration failed: ${error}`, { serverId, error });
      }
    });
  }

  /**
   * Update server metrics with performance tracking
   */
  async updateServerMetrics(serverId: string, metrics: DeepPartial<ServerMetrics>): Promise<void> {
    return this.executeWithLock(async () => {
      const entry = this.servers.get(serverId);
      if (!entry) {
        throw new ServerRegistryError(`Server ${serverId} not found for metrics update`, { serverId });
      }

      try {
        // Update metrics
        Object.assign(entry.metrics, metrics);
        entry.lastUpdated = new Date();

        // Add to metrics history
        const historyEntry: MetricsDataPoint = {
          timestamp: new Date(),
          metrics: { ...metrics }
        };

        entry.metricsHistory.push(historyEntry);

        // Trim history if needed
        if (entry.metricsHistory.length > this.options.maxMetricsHistory) {
          entry.metricsHistory = entry.metricsHistory.slice(-this.options.maxMetricsHistory);
        }

        // Recalculate server score
        entry.score = await this.calculateServerScore(entry);

        // Update tool mappings preferences
        await this.updateToolPreferences(entry);

        // Clear query cache
        this.clearQueryCache();

        // Emit metrics updated event
        const metricsEvent: MetricsUpdatedEvent = {
          timestamp: new Date(),
          source: 'server-registry',
          eventId: `metrics-${serverId}-${Date.now()}`,
          serverId,
          metrics: entry.metrics
        };

        this.emit('metricsUpdated', metricsEvent);

      } catch (error) {
        console.error(`❌ Failed to update metrics for server ${serverId}:`, error);
        throw new ServerRegistryError(`Metrics update failed: ${error}`, { serverId, error });
      }
    });
  }

  /**
   * High-performance query interface with sub-100ms response times
   */
  async queryServers(query: RegistryQuery): Promise<MCPServerInfo[]> {
    const startTime = performance.now();

    try {
      // Track query metrics
      this.performanceMetrics.totalQueries++;

      // Check cache first
      const cacheKey = this.generateCacheKey(query);
      const cachedResult = this.queryCache.get(cacheKey);

      if (cachedResult && this.isCacheEntryValid(cachedResult)) {
        this.performanceMetrics.totalCacheHits++;
        const queryTime = Math.round(performance.now() - startTime);
        this.updateAverageQueryTime(queryTime);

        console.log(`🎯 Query served from cache in ${queryTime}ms`);
        return [...cachedResult.results];
      }

      this.performanceMetrics.totalCacheMisses++;

      // Execute query
      let results = Array.from(this.servers.values());

      // Apply filters
      if (query.toolName) {
        results = results.filter(entry =>
          entry.server.capabilities.some(cap => cap.name === query.toolName)
        );
      }

      if (query.serverStatus) {
        results = results.filter(entry => entry.server.status === query.serverStatus);
      }

      if (query.capabilities && query.capabilities.length > 0) {
        results = results.filter(entry =>
          query.capabilities!.every(reqCap =>
            entry.server.capabilities.some(serverCap => serverCap.name === reqCap)
          )
        );
      }

      if (query.minUptimePercentage !== undefined) {
        results = results.filter(entry => entry.metrics.uptimePercentage >= query.minUptimePercentage!);
      }

      if (query.maxResponseTime !== undefined) {
        results = results.filter(entry => entry.server.responseTime <= query.maxResponseTime!);
      }

      if (query.tags && query.tags.length > 0) {
        results = results.filter(entry =>
          query.tags!.some(tag => entry.server.metadata?.tags?.includes(tag))
        );
      }

      if (query.minThroughput !== undefined) {
        results = results.filter(entry =>
          (entry.metrics.throughput || 0) >= query.minThroughput!
        );
      }

      // Sort results
      if (query.sortBy) {
        results.sort((a, b) => {
          let compareValue = 0;

          switch (query.sortBy) {
            case 'performance':
              compareValue = b.score - a.score;
              break;
            case 'uptime':
              compareValue = b.metrics.uptimePercentage - a.metrics.uptimePercentage;
              break;
            case 'responseTime':
              compareValue = a.server.responseTime - b.server.responseTime;
              break;
            case 'load':
              compareValue = a.metrics.load - b.metrics.load;
              break;
            default:
              compareValue = b.score - a.score;
          }

          return query.sortDirection === 'desc' ? -compareValue : compareValue;
        });
      }

      // Apply limit
      if (query.limit && query.limit > 0) {
        results = results.slice(0, query.limit);
      }

      // Extract server info
      const serverResults = results.map(entry => ({ ...entry.server }));

      // Cache results
      const cacheEntry: QueryCacheEntry = {
        results: serverResults,
        timestamp: new Date(),
        queryHash: cacheKey,
        ttl: 30000 // 30 seconds
      };
      this.queryCache.set(cacheKey, cacheEntry);

      const queryTime = Math.round(performance.now() - startTime);
      this.updateAverageQueryTime(queryTime);

      // Log performance warning if query is slow
      if (queryTime > 100) {
        console.warn(`⚠️  Query took ${queryTime}ms (target: <100ms)`);
      } else {
        console.log(`🎯 Query completed in ${queryTime}ms (${serverResults.length} results)`);
      }

      return serverResults;

    } catch (error) {
      const queryTime = Math.round(performance.now() - startTime);
      console.error(`❌ Query failed after ${queryTime}ms:`, error);
      throw new ServerRegistryError(`Query execution failed: ${error}`, { query, error });
    }
  }

  /**
   * Get tool-to-server mappings with intelligent preferences
   */
  getToolMappings(): Map<string, ToolMapping> {
    return new Map(this.toolMappings);
  }

  /**
   * Get best server for a specific tool
   */
  getBestServerForTool(toolName: string): MCPServerInfo | null {
    const mapping = this.toolMappings.get(toolName);
    if (!mapping || mapping.serverIds.length === 0) {
      return null;
    }

    const preferredServerId = mapping.preferredServerId || mapping.serverIds[0];
    const entry = this.servers.get(preferredServerId);

    return entry ? { ...entry.server } : null;
  }

  /**
   * Set manual preference for tool-to-server mapping
   */
  async setToolPreference(toolName: string, serverId: string): Promise<void> {
    return this.executeWithLock(async () => {
      const mapping = this.toolMappings.get(toolName);
      if (!mapping || !mapping.serverIds.includes(serverId)) {
        throw new ServerRegistryError(`Invalid tool preference: tool ${toolName} not available on server ${serverId}`, { toolName, serverId });
      }

      const previousPreference = mapping.preferredServerId;
      mapping.preferredServerId = serverId;

      // Update metadata
      if (!mapping.metadata) {
        mapping.metadata = {};
      }
      mapping.metadata.lastUsed = new Date();

      // Clear query cache
      this.clearQueryCache();

      // Emit preference updated event
      const preferenceEvent: PreferenceUpdatedEvent = {
        timestamp: new Date(),
        source: 'server-registry',
        eventId: `preference-${toolName}-${Date.now()}`,
        toolName,
        serverId
      };

      this.emit('preferenceUpdated', preferenceEvent);

      console.log(`✅ Tool preference updated: ${toolName} -> ${serverId} (was: ${previousPreference})`);
    });
  }

  /**
   * Get comprehensive registry statistics
   */
  getRegistryStats(): RegistryStats {
    const servers = Array.from(this.servers.values());
    const healthyServers = servers.filter(entry => entry.server.status === 'healthy');
    const degradedServers = servers.filter(entry => entry.server.status === 'degraded');
    const failedServers = servers.filter(entry => entry.server.status === 'failed');

    const totalResponseTime = servers.reduce((sum, entry) => sum + entry.server.responseTime, 0);
    const totalRequests = servers.reduce((sum, entry) => sum + entry.metrics.totalRequests, 0);
    const totalMemoryUsage = servers.reduce((sum, entry) => sum + (entry.metrics.memoryUsage || 0), 0);
    const totalLoad = servers.reduce((sum, entry) => sum + entry.metrics.load, 0);

    // Calculate cache hit rate
    const totalCacheOperations = this.performanceMetrics.totalCacheHits + this.performanceMetrics.totalCacheMisses;
    this.performanceMetrics.cacheHitRate = totalCacheOperations > 0
      ? this.performanceMetrics.totalCacheHits / totalCacheOperations
      : 0;

    return {
      totalServers: servers.length,
      healthyServers: healthyServers.length,
      degradedServers: degradedServers.length,
      failedServers: failedServers.length,
      totalTools: this.toolMappings.size,
      averageResponseTime: servers.length > 0 ? totalResponseTime / servers.length : 0,
      totalRequests,
      systemLoad: servers.length > 0 ? totalLoad / servers.length : 0,
      totalMemoryUsage
    };
  }

  /**
   * Get performance metrics for monitoring
   */
  getPerformanceMetrics() {
    return { ...this.performanceMetrics };
  }

  /**
   * Get servers by status with optional filtering
   */
  getServersByStatus(status: ServerStatus): MCPServerInfo[] {
    return Array.from(this.servers.values())
      .filter(entry => entry.server.status === status)
      .map(entry => ({ ...entry.server }));
  }

  /**
   * Get server by ID
   */
  getServer(serverId: string): MCPServerInfo | null {
    const entry = this.servers.get(serverId);
    return entry ? { ...entry.server } : null;
  }

  /**
   * Get server metrics by ID
   */
  getServerMetrics(serverId: string): ServerMetrics | null {
    const entry = this.servers.get(serverId);
    return entry ? { ...entry.metrics } : null;
  }

  /**
   * Get server metrics history
   */
  getServerMetricsHistory(serverId: string): MetricsDataPoint[] {
    const entry = this.servers.get(serverId);
    return entry ? [...entry.metricsHistory] : [];
  }

  // Private implementation methods

  private async executeWithLock<T>(operation: () => Promise<T>): Promise<T> {
    return new Promise((resolve, reject) => {
      this.operationQueue.push(async () => {
        try {
          const result = await operation();
          resolve(result);
        } catch (error) {
          reject(error);
        }
      });

      this.processQueue();
    });
  }

  private async processQueue(): Promise<void> {
    if (this.isProcessingQueue || this.operationQueue.length === 0) {
      return;
    }

    this.isProcessingQueue = true;

    while (this.operationQueue.length > 0) {
      const operation = this.operationQueue.shift();
      if (operation) {
        try {
          await operation();
        } catch (error) {
          console.error('Queue operation failed:', error);
        }
      }
    }

    this.isProcessingQueue = false;
  }

  private validateServerInfo(server: MCPServerInfo): void {
    if (!server.id || typeof server.id !== 'string') {
      throw new Error('Server ID is required and must be a string');
    }

    if (!server.name || typeof server.name !== 'string') {
      throw new Error('Server name is required and must be a string');
    }

    if (!server.config || typeof server.config !== 'object') {
      throw new Error('Server config is required and must be an object');
    }

    if (!Array.isArray(server.capabilities)) {
      throw new Error('Server capabilities must be an array');
    }
  }

  private initializeMetrics(): ServerMetrics {
    return {
      totalRequests: 0,
      successfulRequests: 0,
      failedRequests: 0,
      averageResponseTime: 0,
      uptimePercentage: 100,
      load: 0,
      memoryUsage: 0,
      cpuUsage: 0,
      throughput: 0,
      errorRate: 0
    };
  }

  private async calculateServerScore(entry: RegistryEntry): Promise<number> {
    const metrics = entry.metrics;
    const server = entry.server;

    // Performance score (0-1)
    const performanceScore = Math.max(0, Math.min(1,
      (1000 - server.responseTime) / 1000 * 0.5 +
      (metrics.throughput || 0) / 1000 * 0.3 +
      (1 - metrics.errorRate) * 0.2
    ));

    // Reliability score (0-1)
    const reliabilityScore = Math.max(0, Math.min(1,
      metrics.uptimePercentage / 100 * 0.6 +
      Math.max(0, (10 - server.failureCount) / 10) * 0.4
    ));

    // Availability score (0-1)
    const availabilityScore = server.status === 'healthy' ? 1 :
                             server.status === 'degraded' ? 0.5 : 0;

    // Load score (0-1, lower load is better)
    const loadScore = Math.max(0, 1 - metrics.load);

    // Calculate weighted score
    const score =
      performanceScore * this.scoringWeights.performance +
      reliabilityScore * this.scoringWeights.reliability +
      availabilityScore * this.scoringWeights.availability +
      loadScore * this.scoringWeights.load;

    return Math.round(score * 100) / 100; // Round to 2 decimal places
  }

  private async updateToolMappings(entry: RegistryEntry): Promise<void> {
    for (const capability of entry.server.capabilities) {
      const toolName = capability.name;
      let mapping = this.toolMappings.get(toolName);

      if (!mapping) {
        mapping = {
          toolName,
          serverIds: [],
          metadata: {
            usageFrequency: 0,
            lastUsed: new Date(),
            userPreferences: {},
            performanceHistory: []
          }
        };
        this.toolMappings.set(toolName, mapping);
      }

      // Add server to mapping if not already present
      if (!mapping.serverIds.includes(entry.server.id)) {
        mapping.serverIds.push(entry.server.id);
      }

      // Set as preferred if this is the first server or it has a better score
      if (!mapping.preferredServerId) {
        mapping.preferredServerId = entry.server.id;
      } else {
        const currentPreferred = this.servers.get(mapping.preferredServerId);
        if (!currentPreferred || entry.score > currentPreferred.score) {
          mapping.preferredServerId = entry.server.id;
        }
      }

      // Store tool mapping reference in entry
      entry.toolMappings.set(toolName, mapping);
    }
  }

  private async updateToolPreferences(entry: RegistryEntry): Promise<void> {
    // Update preferred servers based on new performance metrics
    for (const [toolName, mapping] of entry.toolMappings) {
      if (mapping.preferredServerId === entry.server.id) {
        // Check if another server might be better now
        const bestServerId = this.findBestServerForTool(toolName);
        if (bestServerId && bestServerId !== entry.server.id) {
          mapping.preferredServerId = bestServerId;
        }
      }
    }
  }

  private findBestServerForTool(toolName: string): string | undefined {
    const mapping = this.toolMappings.get(toolName);
    if (!mapping || mapping.serverIds.length === 0) {
      return undefined;
    }

    let bestServerId = mapping.serverIds[0];
    let bestScore = 0;

    for (const serverId of mapping.serverIds) {
      const entry = this.servers.get(serverId);
      if (entry && entry.server.status === 'healthy' && entry.score > bestScore) {
        bestScore = entry.score;
        bestServerId = serverId;
      }
    }

    return bestServerId;
  }

  private generateCacheKey(query: RegistryQuery): string {
    return Buffer.from(JSON.stringify(query)).toString('base64');
  }

  private isCacheEntryValid(entry: QueryCacheEntry): boolean {
    const age = Date.now() - entry.timestamp.getTime();
    return age < entry.ttl;
  }

  private clearQueryCache(): void {
    this.queryCache.clear();
  }

  private updateAverageQueryTime(queryTime: number): void {
    this.performanceMetrics.averageQueryTime =
      (this.performanceMetrics.averageQueryTime * (this.performanceMetrics.totalQueries - 1) + queryTime) /
      this.performanceMetrics.totalQueries;
  }

  private startCleanupService(): void {
    this.cleanupTimer = setInterval(() => {
      this.performCleanup();
    }, 60000); // Every minute
  }

  private startMetricsAggregation(): void {
    this.metricsAggregationTimer = setInterval(() => {
      this.aggregateMetrics();
    }, 30000); // Every 30 seconds
  }

  private performCleanup(): void {
    // Clean expired cache entries
    const now = Date.now();
    for (const [key, entry] of this.queryCache) {
      if (now - entry.timestamp.getTime() > entry.ttl) {
        this.queryCache.delete(key);
      }
    }

    // Clean old metrics history
    const cutoffTime = new Date(now - this.options.metricsRetentionPeriod);
    for (const entry of this.servers.values()) {
      entry.metricsHistory = entry.metricsHistory.filter(
        point => point.timestamp > cutoffTime
      );
    }
  }

  private aggregateMetrics(): void {
    // Aggregate system-wide metrics
    const stats = this.getRegistryStats();

    // Emit system metrics event
    this.emit('systemMetrics', {
      timestamp: new Date(),
      source: 'server-registry',
      eventId: `system-metrics-${Date.now()}`,
      stats
    });
  }

  private async initializeRedis(): Promise<void> {
    if (!this.redisClient) {
      return;
    }

    try {
      await this.redisClient.ping();
      console.log('✅ Redis connection established for registry persistence');
    } catch (error) {
      console.warn('⚠️  Redis connection failed, persistence disabled:', error);
      this.redisClient = undefined;
    }
  }

  private async loadPersistedData(): Promise<void> {
    if (!this.redisClient) {
      return;
    }

    try {
      const serverKeys = await this.redisClient.keys('mcp:server:*');

      for (const key of serverKeys) {
        const data = await this.redisClient.get(key);
        if (data) {
          const entry = JSON.parse(data) as RegistryEntry;
          entry.lock = null;
          entry.toolMappings = new Map(Object.entries(entry.toolMappings || {}));
          this.servers.set(entry.server.id, entry);
        }
      }

      const toolMappingKeys = await this.redisClient.keys('mcp:tool:*');

      for (const key of toolMappingKeys) {
        const data = await this.redisClient.get(key);
        if (data) {
          const mapping = JSON.parse(data) as ToolMapping;
          this.toolMappings.set(mapping.toolName, mapping);
        }
      }

      console.log(`✅ Loaded ${this.servers.size} servers and ${this.toolMappings.size} tool mappings from Redis`);
    } catch (error) {
      console.warn('⚠️  Failed to load persisted data from Redis:', error);
    }
  }

  private async persistData(): Promise<void> {
    if (!this.redisClient) {
      return;
    }

    try {
      // Persist servers
      for (const [serverId, entry] of this.servers) {
        await this.persistServerData(serverId, entry);
      }

      // Persist tool mappings
      for (const [toolName, mapping] of this.toolMappings) {
        await this.redisClient.set(
          `mcp:tool:${toolName}`,
          JSON.stringify(mapping),
          this.options.persistenceInterval * 2
        );
      }
    } catch (error) {
      console.error('❌ Failed to persist data to Redis:', error);
    }
  }

  private async persistServerData(serverId: string, entry: RegistryEntry): Promise<void> {
    if (!this.redisClient) {
      return;
    }

    try {
      const persistableEntry = {
        ...entry,
        toolMappings: Object.fromEntries(entry.toolMappings),
        lock: undefined
      };

      await this.redisClient.set(
        `mcp:server:${serverId}`,
        JSON.stringify(persistableEntry),
        this.options.persistenceInterval * 2
      );
    } catch (error) {
      console.error(`❌ Failed to persist server ${serverId}:`, error);
    }
  }

  private setupErrorHandling(): void {
    this.on('error', (error) => {
      console.error('🚨 MCP Registry error:', error);
    });

    this.on('serverRegistered', (event: ServerRegisteredEvent) => {
      console.log(`📝 Server registered: ${event.server.name} [${event.server.status}]`);
    });

    this.on('serverUnregistered', (event: ServerUnregisteredEvent) => {
      console.log(`📝 Server unregistered: ${event.server.name}`);
    });

    this.on('metricsUpdated', (event: MetricsUpdatedEvent) => {
      console.debug(`📊 Metrics updated for server: ${event.serverId}`);
    });
  }

  private setupDiscoveryIntegration(): void {
    if (!this.discoveryService) {
      return;
    }

    // Listen for discovery events
    this.discoveryService.on('serverDiscovered', async (event: any) => {
      try {
        await this.registerServer(event.server);
      } catch (error) {
        console.error('Failed to register discovered server:', error);
      }
    });

    this.discoveryService.on('serverFailed', async (event: any) => {
      try {
        const entry = this.servers.get(event.server.id);
        if (entry) {
          entry.server.status = 'failed';
          await this.updateServerMetrics(event.server.id, {
            errorRate: 1.0,
            uptimePercentage: 0
          });
        }
      } catch (error) {
        console.error('Failed to update failed server status:', error);
      }
    });

    this.discoveryService.on('serverRecovered', async (event: any) => {
      try {
        const entry = this.servers.get(event.server.id);
        if (entry) {
          entry.server.status = 'healthy';
          await this.updateServerMetrics(event.server.id, {
            errorRate: 0,
            uptimePercentage: 100
          });
        }
      } catch (error) {
        console.error('Failed to update recovered server status:', error);
      }
    });
  }
}

// Export singleton instance for convenience
export const mcpServerRegistry = new MCPServerRegistry();

// Export class for custom instantiation
export default MCPServerRegistry;
