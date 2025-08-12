import { EventEmitter } from 'events';
import { createHash } from 'crypto';

// =============================================================================
// Core Interfaces
// =============================================================================

/**
 * Cache entry with metadata and TTL
 */
export interface CacheEntry<T = any> {
  /** Cached value */
  value: T;
  /** Entry creation timestamp */
  createdAt: Date;
  /** Last access timestamp */
  lastAccessed: Date;
  /** Time to live in milliseconds */
  ttl: number;
  /** Entry expiration timestamp */
  expiresAt: Date;
  /** Access count */
  accessCount: number;
  /** Entry size in bytes (estimated) */
  size: number;
  /** Entry metadata */
  metadata?: Record<string, any>;
}

/**
 * Cache statistics
 */
export interface CacheStats {
  /** Total cache hits */
  hits: number;
  /** Total cache misses */
  misses: number;
  /** Cache hit ratio (0-1) */
  hitRatio: number;
  /** Total entries in cache */
  entryCount: number;
  /** Total cache size in bytes */
  totalSize: number;
  /** Memory usage percentage (0-1) */
  memoryUsage: number;
  /** Average entry age in milliseconds */
  averageAge: number;
  /** Most accessed keys */
  topKeys: Array<{ key: string; accessCount: number }>;
  /** Cache operations per second */
  operationsPerSecond: number;
}

/**
 * Cache configuration options
 */
export interface CacheConfig {
  /** Maximum number of entries */
  maxEntries: number;
  /** Maximum cache size in bytes */
  maxSize: number;
  /** Default TTL in milliseconds */
  defaultTtl: number;
  /** Enable Redis fallback */
  enableRedis: boolean;
  /** Redis configuration */
  redis?: RedisConfig;
  /** Eviction policy */
  evictionPolicy: 'lru' | 'lfu' | 'ttl' | 'random';
  /** Statistics collection interval */
  statsInterval: number;
  /** Background cleanup interval */
  cleanupInterval: number;
  /** Enable compression for large values */
  enableCompression: boolean;
  /** Compression threshold in bytes */
  compressionThreshold: number;
}

/**
 * Redis configuration
 */
export interface RedisConfig {
  /** Redis host */
  host: string;
  /** Redis port */
  port: number;
  /** Redis password */
  password?: string;
  /** Redis database number */
  db: number;
  /** Connection timeout */
  connectTimeout: number;
  /** Key prefix for MCP cache */
  keyPrefix: string;
  /** Enable Redis cluster mode */
  enableCluster: boolean;
  /** Cluster nodes (if cluster mode) */
  clusterNodes?: Array<{ host: string; port: number }>;
}

/**
 * Cache operation result
 */
export interface CacheOperation<T = any> {
  /** Operation success indicator */
  success: boolean;
  /** Cached value (if successful) */
  value?: T;
  /** Operation source */
  source: 'memory' | 'redis' | 'miss';
  /** Operation duration in milliseconds */
  duration: number;
  /** Error message (if failed) */
  error?: string;
}

/**
 * Cache key pattern for organized storage
 */
export interface CacheKeyPattern {
  /** Pattern namespace */
  namespace: string;
  /** Pattern type */
  type: string;
  /** Pattern identifier */
  id: string;
  /** Additional parameters */
  params?: Record<string, string>;
}

// =============================================================================
// Redis Client Interface (for dependency injection)
// =============================================================================

/**
 * Redis client interface for dependency injection
 */
export interface RedisClient {
  get(key: string): Promise<string | null>;
  set(key: string, value: string, ttl?: number): Promise<void>;
  del(key: string): Promise<number>;
  exists(key: string): Promise<number>;
  keys(pattern: string): Promise<string[]>;
  flushdb(): Promise<void>;
  ping(): Promise<string>;
  disconnect(): Promise<void>;
}

// =============================================================================
// In-Memory Cache Implementation
// =============================================================================

/**
 * High-performance in-memory cache with LRU eviction
 */
class InMemoryCache<T = any> extends EventEmitter {
  private cache: Map<string, CacheEntry<T>> = new Map();
  private accessOrder: string[] = [];
  private readonly config: CacheConfig;
  private stats: CacheStats;
  private statsTimer?: NodeJS.Timeout;
  private cleanupTimer?: NodeJS.Timeout;

  constructor(config: Partial<CacheConfig> = {}) {
    super();
    
    this.config = {
      maxEntries: 10000,
      maxSize: 100 * 1024 * 1024, // 100MB
      defaultTtl: 300000, // 5 minutes
      enableRedis: false,
      evictionPolicy: 'lru',
      statsInterval: 60000, // 1 minute
      cleanupInterval: 30000, // 30 seconds
      enableCompression: false,
      compressionThreshold: 1024, // 1KB
      ...config
    };

    this.stats = this.initializeStats();
    this.startBackgroundTasks();
  }

  /**
   * Get value from cache
   */
  async get(key: string): Promise<CacheOperation<T>> {
    const startTime = Date.now();
    
    try {
      const entry = this.cache.get(key);
      
      if (!entry) {
        this.stats.misses++;
        return {
          success: false,
          source: 'miss',
          duration: Date.now() - startTime
        };
      }

      // Check if entry is expired
      if (entry.expiresAt < new Date()) {
        this.cache.delete(key);
        this.removeFromAccessOrder(key);
        this.stats.misses++;
        return {
          success: false,
          source: 'miss',
          duration: Date.now() - startTime
        };
      }

      // Update access information
      entry.lastAccessed = new Date();
      entry.accessCount++;
      this.updateAccessOrder(key);

      this.stats.hits++;
      this.emit('cacheHit', { key, entry });

      return {
        success: true,
        value: entry.value,
        source: 'memory',
        duration: Date.now() - startTime
      };
    } catch (error) {
      this.emit('cacheError', { operation: 'get', key, error });
      return {
        success: false,
        source: 'miss',
        duration: Date.now() - startTime,
        error: error.message
      };
    }
  }

  /**
   * Set value in cache
   */
  async set(key: string, value: T, ttl?: number): Promise<CacheOperation<void>> {
    const startTime = Date.now();
    
    try {
      const actualTtl = ttl || this.config.defaultTtl;
      const now = new Date();
      const size = this.estimateSize(value);

      // Check if we need to evict entries
      await this.ensureCapacity(size);

      const entry: CacheEntry<T> = {
        value,
        createdAt: now,
        lastAccessed: now,
        ttl: actualTtl,
        expiresAt: new Date(now.getTime() + actualTtl),
        accessCount: 1,
        size
      };

      this.cache.set(key, entry);
      this.updateAccessOrder(key);
      
      this.emit('cacheSet', { key, entry });

      return {
        success: true,
        source: 'memory',
        duration: Date.now() - startTime
      };
    } catch (error) {
      this.emit('cacheError', { operation: 'set', key, error });
      return {
        success: false,
        source: 'memory',
        duration: Date.now() - startTime,
        error: error.message
      };
    }
  }

  /**
   * Delete value from cache
   */
  async delete(key: string): Promise<CacheOperation<boolean>> {
    const startTime = Date.now();
    
    try {
      const existed = this.cache.delete(key);
      if (existed) {
        this.removeFromAccessOrder(key);
        this.emit('cacheDelete', { key });
      }

      return {
        success: true,
        value: existed,
        source: 'memory',
        duration: Date.now() - startTime
      };
    } catch (error) {
      this.emit('cacheError', { operation: 'delete', key, error });
      return {
        success: false,
        source: 'memory',
        duration: Date.now() - startTime,
        error: error.message
      };
    }
  }

  /**
   * Check if key exists in cache
   */
  async exists(key: string): Promise<boolean> {
    const entry = this.cache.get(key);
    return entry !== undefined && entry.expiresAt >= new Date();
  }

  /**
   * Clear all cache entries
   */
  async clear(): Promise<void> {
    const count = this.cache.size;
    this.cache.clear();
    this.accessOrder.length = 0;
    this.emit('cacheCleared', { count });
  }

  /**
   * Get cache statistics
   */
  getStats(): CacheStats {
    return { ...this.stats };
  }

  /**
   * Get cache size information
   */
  getSizeInfo(): { entries: number; bytes: number; percentage: number } {
    const entries = this.cache.size;
    const bytes = Array.from(this.cache.values()).reduce((sum, entry) => sum + entry.size, 0);
    const percentage = bytes / this.config.maxSize;

    return { entries, bytes, percentage };
  }

  /**
   * Cleanup expired entries
   */
  cleanup(): number {
    const now = new Date();
    let cleanedCount = 0;

    for (const [key, entry] of this.cache.entries()) {
      if (entry.expiresAt < now) {
        this.cache.delete(key);
        this.removeFromAccessOrder(key);
        cleanedCount++;
      }
    }

    if (cleanedCount > 0) {
      this.emit('cacheCleanup', { cleanedCount });
    }

    return cleanedCount;
  }

  /**
   * Destroy cache and cleanup resources
   */
  destroy(): void {
    if (this.statsTimer) {
      clearInterval(this.statsTimer);
    }
    if (this.cleanupTimer) {
      clearInterval(this.cleanupTimer);
    }
    
    this.cache.clear();
    this.accessOrder.length = 0;
    this.removeAllListeners();
  }

  // =============================================================================
  // Private Methods
  // =============================================================================

  private initializeStats(): CacheStats {
    return {
      hits: 0,
      misses: 0,
      hitRatio: 0,
      entryCount: 0,
      totalSize: 0,
      memoryUsage: 0,
      averageAge: 0,
      topKeys: [],
      operationsPerSecond: 0
    };
  }

  private updateAccessOrder(key: string): void {
    // Remove from current position
    this.removeFromAccessOrder(key);
    // Add to end (most recently used)
    this.accessOrder.push(key);
  }

  private removeFromAccessOrder(key: string): void {
    const index = this.accessOrder.indexOf(key);
    if (index > -1) {
      this.accessOrder.splice(index, 1);
    }
  }

  private async ensureCapacity(newEntrySize: number): Promise<void> {
    // Check entry count limit
    while (this.cache.size >= this.config.maxEntries) {
      await this.evictEntry();
    }

    // Check size limit
    const currentSize = Array.from(this.cache.values()).reduce((sum, entry) => sum + entry.size, 0);
    while (currentSize + newEntrySize > this.config.maxSize && this.cache.size > 0) {
      await this.evictEntry();
    }
  }

  private async evictEntry(): Promise<void> {
    let keyToEvict: string | undefined;

    switch (this.config.evictionPolicy) {
      case 'lru':
        keyToEvict = this.accessOrder[0];
        break;
      case 'lfu':
        keyToEvict = this.findLeastFrequentlyUsed();
        break;
      case 'ttl':
        keyToEvict = this.findEarliestExpiry();
        break;
      case 'random':
        const keys = Array.from(this.cache.keys());
        keyToEvict = keys[Math.floor(Math.random() * keys.length)];
        break;
    }

    if (keyToEvict) {
      await this.delete(keyToEvict);
      this.emit('cacheEviction', { key: keyToEvict, policy: this.config.evictionPolicy });
    }
  }

  private findLeastFrequentlyUsed(): string | undefined {
    let minAccessCount = Infinity;
    let leastUsedKey: string | undefined;

    for (const [key, entry] of this.cache.entries()) {
      if (entry.accessCount < minAccessCount) {
        minAccessCount = entry.accessCount;
        leastUsedKey = key;
      }
    }

    return leastUsedKey;
  }

  private findEarliestExpiry(): string | undefined {
    let earliestExpiry = new Date(Date.now() + 365 * 24 * 60 * 60 * 1000); // Far future
    let earliestKey: string | undefined;

    for (const [key, entry] of this.cache.entries()) {
      if (entry.expiresAt < earliestExpiry) {
        earliestExpiry = entry.expiresAt;
        earliestKey = key;
      }
    }

    return earliestKey;
  }

  private estimateSize(value: any): number {
    try {
      return JSON.stringify(value).length * 2; // Rough estimate (UTF-16)
    } catch {
      return 1024; // Default size if estimation fails
    }
  }

  private startBackgroundTasks(): void {
    // Statistics collection
    this.statsTimer = setInterval(() => {
      this.updateStats();
    }, this.config.statsInterval);

    // Cleanup expired entries
    this.cleanupTimer = setInterval(() => {
      this.cleanup();
    }, this.config.cleanupInterval);
  }

  private updateStats(): void {
    const totalOperations = this.stats.hits + this.stats.misses;
    this.stats.hitRatio = totalOperations > 0 ? this.stats.hits / totalOperations : 0;
    this.stats.entryCount = this.cache.size;
    this.stats.totalSize = Array.from(this.cache.values()).reduce((sum, entry) => sum + entry.size, 0);
    this.stats.memoryUsage = this.stats.totalSize / this.config.maxSize;

    // Calculate average age
    const now = Date.now();
    const ages = Array.from(this.cache.values()).map(entry => now - entry.createdAt.getTime());
    this.stats.averageAge = ages.length > 0 ? ages.reduce((sum, age) => sum + age, 0) / ages.length : 0;

    // Calculate top keys
    const keyAccessCounts = Array.from(this.cache.entries())
      .map(([key, entry]) => ({ key, accessCount: entry.accessCount }))
      .sort((a, b) => b.accessCount - a.accessCount)
      .slice(0, 10);
    this.stats.topKeys = keyAccessCounts;

    this.emit('statsUpdated', this.stats);
  }
}

// =============================================================================
// Main Cache Manager
// =============================================================================

/**
 * High-performance cache manager with Redis fallback
 * Provides in-memory caching with optional Redis persistence
 */
export class CacheManager extends EventEmitter {
  private readonly memoryCache: InMemoryCache;
  private redisClient?: RedisClient;
  private readonly config: CacheConfig;
  private readonly keyNamespace: string;

  constructor(config: Partial<CacheConfig> = {}, redisClient?: RedisClient) {
    super();
    
    this.config = {
      maxEntries: 10000,
      maxSize: 100 * 1024 * 1024, // 100MB
      defaultTtl: 300000, // 5 minutes
      enableRedis: false,
      evictionPolicy: 'lru',
      statsInterval: 60000,
      cleanupInterval: 30000,
      enableCompression: false,
      compressionThreshold: 1024,
      ...config
    };

    this.memoryCache = new InMemoryCache(this.config);
    this.redisClient = redisClient;
    this.keyNamespace = 'mcp:cache:';

    this.setupEventHandlers();
  }

  /**
   * Get value from cache (memory first, then Redis)
   */
  async get<T = any>(key: string): Promise<CacheOperation<T>> {
    const startTime = Date.now();
    
    try {
      // Try memory cache first
      const memoryResult = await this.memoryCache.get<T>(key);
      if (memoryResult.success) {
        return memoryResult;
      }

      // Fallback to Redis if enabled
      if (this.config.enableRedis && this.redisClient) {
        const redisKey = this.buildRedisKey(key);
        const redisValue = await this.redisClient.get(redisKey);
        
        if (redisValue) {
          const parsedValue = JSON.parse(redisValue);
          
          // Store back in memory cache for faster future access
          await this.memoryCache.set(key, parsedValue, this.config.defaultTtl);
          
          return {
            success: true,
            value: parsedValue,
            source: 'redis',
            duration: Date.now() - startTime
          };
        }
      }

      return {
        success: false,
        source: 'miss',
        duration: Date.now() - startTime
      };
    } catch (error) {
      this.emit('cacheError', { operation: 'get', key, error });
      return {
        success: false,
        source: 'miss',
        duration: Date.now() - startTime,
        error: error.message
      };
    }
  }

  /**
   * Set value in cache (memory and Redis)
   */
  async set<T = any>(key: string, value: T, ttl?: number): Promise<CacheOperation<void>> {
    const startTime = Date.now();
    
    try {
      const actualTtl = ttl || this.config.defaultTtl;
      
      // Set in memory cache
      const memoryResult = await this.memoryCache.set(key, value, actualTtl);
      
      // Set in Redis if enabled
      if (this.config.enableRedis && this.redisClient) {
        try {
          const redisKey = this.buildRedisKey(key);
          const serializedValue = JSON.stringify(value);
          await this.redisClient.set(redisKey, serializedValue, Math.floor(actualTtl / 1000));
        } catch (redisError) {
          console.warn('Redis set failed, continuing with memory cache only:', redisError);
        }
      }

      return {
        success: memoryResult.success,
        source: 'memory',
        duration: Date.now() - startTime
      };
    } catch (error) {
      this.emit('cacheError', { operation: 'set', key, error });
      return {
        success: false,
        source: 'memory',
        duration: Date.now() - startTime,
        error: error.message
      };
    }
  }

  /**
   * Delete value from cache (memory and Redis)
   */
  async delete(key: string): Promise<CacheOperation<boolean>> {
    const startTime = Date.now();
    
    try {
      // Delete from memory cache
      const memoryResult = await this.memoryCache.delete(key);
      
      // Delete from Redis if enabled
      if (this.config.enableRedis && this.redisClient) {
        try {
          const redisKey = this.buildRedisKey(key);
          await this.redisClient.del(redisKey);
        } catch (redisError) {
          console.warn('Redis delete failed:', redisError);
        }
      }

      return {
        success: memoryResult.success,
        value: memoryResult.value,
        source: 'memory',
        duration: Date.now() - startTime
      };
    } catch (error) {
      this.emit('cacheError', { operation: 'delete', key, error });
      return {
        success: false,
        source: 'memory',
        duration: Date.now() - startTime,
        error: error.message
      };
    }
  }

  /**
   * Check if key exists in cache
   */
  async exists(key: string): Promise<boolean> {
    // Check memory cache first
    if (await this.memoryCache.exists(key)) {
      return true;
    }

    // Check Redis if enabled
    if (this.config.enableRedis && this.redisClient) {
      try {
        const redisKey = this.buildRedisKey(key);
        const exists = await this.redisClient.exists(redisKey);
        return exists > 0;
      } catch {
        return false;
      }
    }

    return false;
  }

  /**
   * Invalidate cache entries by pattern
   */
  async invalidatePattern(pattern: string): Promise<number> {
    let invalidatedCount = 0;

    // Handle memory cache invalidation
    const memoryKeys = Array.from(this.memoryCache['cache'].keys());
    for (const key of memoryKeys) {
      if (this.matchesPattern(key, pattern)) {
        await this.memoryCache.delete(key);
        invalidatedCount++;
      }
    }

    // Handle Redis invalidation if enabled
    if (this.config.enableRedis && this.redisClient) {
      try {
        const redisPattern = this.buildRedisKey(pattern);
        const redisKeys = await this.redisClient.keys(redisPattern);
        for (const redisKey of redisKeys) {
          await this.redisClient.del(redisKey);
          invalidatedCount++;
        }
      } catch (error) {
        console.warn('Redis pattern invalidation failed:', error);
      }
    }

    this.emit('patternInvalidated', { pattern, count: invalidatedCount });
    return invalidatedCount;
  }

  /**
   * Clear all cache entries
   */
  async clear(): Promise<void> {
    await this.memoryCache.clear();
    
    if (this.config.enableRedis && this.redisClient) {
      try {
        await this.redisClient.flushdb();
      } catch (error) {
        console.warn('Redis clear failed:', error);
      }
    }

    this.emit('cacheCleared');
  }

  /**
   * Get comprehensive cache statistics
   */
  async getStats(): Promise<CacheStats & { redis?: any }> {
    const memoryStats = this.memoryCache.getStats();
    const result: CacheStats & { redis?: any } = { ...memoryStats };

    if (this.config.enableRedis && this.redisClient) {
      try {
        // Add Redis statistics if available
        result.redis = {
          connected: true,
          // Additional Redis stats could be added here
        };
      } catch {
        result.redis = { connected: false };
      }
    }

    return result;
  }

  /**
   * Generate cache key from pattern
   */
  static buildKey(pattern: CacheKeyPattern): string {
    const parts = [pattern.namespace, pattern.type, pattern.id];
    
    if (pattern.params) {
      const paramString = Object.entries(pattern.params)
        .sort(([a], [b]) => a.localeCompare(b))
        .map(([key, value]) => `${key}=${value}`)
        .join('&');
      parts.push(createHash('md5').update(paramString).digest('hex').substring(0, 8));
    }

    return parts.join(':');
  }

  /**
   * Warm up cache with frequently accessed data
   */
  async warmUp(entries: Array<{ key: string; value: any; ttl?: number }>): Promise<void> {
    console.log(`Warming up cache with ${entries.length} entries...`);
    
    const promises = entries.map(({ key, value, ttl }) => 
      this.set(key, value, ttl)
    );
    
    await Promise.allSettled(promises);
    
    this.emit('cacheWarmedUp', { entryCount: entries.length });
  }

  /**
   * Cleanup resources
   */
  async destroy(): Promise<void> {
    this.memoryCache.destroy();
    
    if (this.redisClient) {
      try {
        await this.redisClient.disconnect();
      } catch (error) {
        console.warn('Redis disconnect failed:', error);
      }
    }
    
    this.removeAllListeners();
  }

  // =============================================================================
  // Private Methods
  // =============================================================================

  private buildRedisKey(key: string): string {
    return `${this.keyNamespace}${key}`;
  }

  private matchesPattern(key: string, pattern: string): boolean {
    // Simple glob-style pattern matching
    const regexPattern = pattern
      .replace(/\*/g, '.*')
      .replace(/\?/g, '.');
    
    const regex = new RegExp(`^${regexPattern}$`);
    return regex.test(key);
  }

  private setupEventHandlers(): void {
    this.memoryCache.on('cacheHit', (data) => this.emit('cacheHit', data));
    this.memoryCache.on('cacheSet', (data) => this.emit('cacheSet', data));
    this.memoryCache.on('cacheDelete', (data) => this.emit('cacheDelete', data));
    this.memoryCache.on('cacheEviction', (data) => this.emit('cacheEviction', data));
    this.memoryCache.on('cacheCleanup', (data) => this.emit('cacheCleanup', data));
    this.memoryCache.on('cacheError', (data) => this.emit('cacheError', data));
    this.memoryCache.on('statsUpdated', (data) => this.emit('statsUpdated', data));
  }
}

// =============================================================================
// Exports
// =============================================================================

export type {
  CacheEntry,
  CacheStats,
  CacheConfig,
  RedisConfig,
  CacheOperation,
  CacheKeyPattern,
  RedisClient
};

export { CacheManager };