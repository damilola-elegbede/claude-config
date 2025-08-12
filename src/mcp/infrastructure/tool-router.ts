/**
 * Intelligent Tool Router Implementation
 * 
 * Provides sub-100ms routing decisions using multiple strategies,
 * agent-specific optimization profiles, and performance caching.
 * 
 * @fileoverview SPEC_01 compliant implementation
 */

import { EventEmitter } from 'events';
import {
  MCPServerInfo,
  ToolCapability,
  RoutingDecision,
  RoutingContext,
  RoutingStrategy,
  ToolRouterConfig,
  PerformanceRequirements,
  AgentProfile,
  ServerMetrics,
  CacheEntry,
  CacheOperation,
  ServerID,
  AgentID,
  ToolName,
  RequestID,
  StrategyConfig
} from '../types/index.js';

/**
 * High-performance routing decision cache
 */
class RoutingCache {
  private readonly cache = new Map<string, CacheEntry<RoutingDecision>>();
  private readonly maxSize: number;
  private readonly defaultTtl: number;
  private hits = 0;
  private misses = 0;

  constructor(maxSize = 10000, defaultTtl = 30000) { // 30s TTL
    this.maxSize = maxSize;
    this.defaultTtl = defaultTtl;
  }

  private generateKey(context: RoutingContext): string {
    const keyParts = [
      context.toolName,
      context.agentId || 'global',
      context.priority || '5',
      JSON.stringify(context.requirements || {})
    ];
    return keyParts.join('|');
  }

  get(context: RoutingContext): CacheOperation<RoutingDecision> {
    const start = Date.now();
    const key = this.generateKey(context);
    const entry = this.cache.get(key);
    const duration = Date.now() - start;

    if (!entry || entry.expiresAt < new Date()) {
      this.misses++;
      if (entry) this.cache.delete(key);
      return { success: false, source: 'miss', duration };
    }

    this.hits++;
    entry.lastAccessed = new Date();
    entry.accessCount++;

    return {
      success: true,
      value: entry.value,
      source: 'memory',
      duration
    };
  }

  set(context: RoutingContext, decision: RoutingDecision, ttl = this.defaultTtl): void {
    if (this.cache.size >= this.maxSize) {
      this.evictLru();
    }

    const key = this.generateKey(context);
    const now = new Date();
    
    this.cache.set(key, {
      value: decision,
      createdAt: now,
      lastAccessed: now,
      ttl,
      expiresAt: new Date(now.getTime() + ttl),
      accessCount: 1,
      size: JSON.stringify(decision).length,
      metadata: { toolName: context.toolName, agentId: context.agentId }
    });
  }

  private evictLru(): void {
    let oldestEntry: [string, CacheEntry<RoutingDecision>] | null = null;
    let oldestTime = Date.now();

    for (const [key, entry] of this.cache.entries()) {
      if (entry.lastAccessed.getTime() < oldestTime) {
        oldestTime = entry.lastAccessed.getTime();
        oldestEntry = [key, entry];
      }
    }

    if (oldestEntry) {
      this.cache.delete(oldestEntry[0]);
    }
  }

  getStats() {
    const totalRequests = this.hits + this.misses;
    return {
      hits: this.hits,
      misses: this.misses,
      hitRatio: totalRequests > 0 ? this.hits / totalRequests : 0,
      entryCount: this.cache.size,
      totalSize: Array.from(this.cache.values()).reduce((sum, entry) => sum + entry.size, 0),
      memoryUsage: this.cache.size / this.maxSize,
      averageAge: this.calculateAverageAge(),
      topKeys: this.getTopKeys(),
      operationsPerSecond: 0 // Would need time window tracking for accuracy
    };
  }

  private calculateAverageAge(): number {
    if (this.cache.size === 0) return 0;
    const now = Date.now();
    const totalAge = Array.from(this.cache.values())
      .reduce((sum, entry) => sum + (now - entry.createdAt.getTime()), 0);
    return totalAge / this.cache.size;
  }

  private getTopKeys(): Array<{ key: string; accessCount: number }> {
    return Array.from(this.cache.entries())
      .map(([key, entry]) => ({ key, accessCount: entry.accessCount }))
      .sort((a, b) => b.accessCount - a.accessCount)
      .slice(0, 10);
  }

  clear(): void {
    this.cache.clear();
    this.hits = 0;
    this.misses = 0;
  }
}

/**
 * Performance-first routing strategy
 */
export class PerformanceFirstStrategy implements RoutingStrategy {
  readonly name = 'performance-first';
  readonly description = 'Prioritizes servers with best response time and reliability';

  async evaluate(
    candidates: MCPServerInfo[],
    context: RoutingContext
  ): Promise<RoutingDecision> {
    const start = Date.now();

    if (candidates.length === 0) {
      throw new Error('No candidate servers available for routing');
    }

    // Filter candidates based on requirements
    const viable = this.filterViableCandidates(candidates, context.requirements);
    if (viable.length === 0) {
      // Fall back to all candidates if requirements are too strict
      viable.push(...candidates);
    }

    // Score each candidate
    const scored = viable.map(server => ({
      server,
      score: this.calculatePerformanceScore(server, context)
    }));

    // Sort by score (highest first)
    scored.sort((a, b) => b.score - a.score);
    const selected = scored[0];

    return {
      selectedServer: selected.server,
      confidence: Math.min(selected.score, 1.0),
      reasoning: `Performance-first selection: ${selected.server.name} (score: ${selected.score.toFixed(3)}, response time: ${selected.server.responseTime}ms)`,
      timestamp: new Date(),
      decisionTime: Date.now() - start,
      alternatives: scored.slice(1, 4).map(s => s.server)
    };
  }

  private filterViableCandidates(
    candidates: MCPServerInfo[],
    requirements?: PerformanceRequirements
  ): MCPServerInfo[] {
    if (!requirements) return candidates;

    return candidates.filter(server => {
      if (requirements.maxResponseTime && server.responseTime > requirements.maxResponseTime) {
        return false;
      }
      if (requirements.minSuccessRate) {
        const successRate = server.metrics ? 
          (server.metrics.successfulRequests / (server.metrics.totalRequests || 1)) : 1;
        if (successRate < requirements.minSuccessRate) {
          return false;
        }
      }
      if (requirements.maxLoad && server.metrics?.load && server.metrics.load > requirements.maxLoad) {
        return false;
      }
      return server.status === 'healthy' || server.status === 'degraded';
    });
  }

  private calculatePerformanceScore(server: MCPServerInfo, context: RoutingContext): number {
    let score = 0;

    // Base health score
    switch (server.status) {
      case 'healthy': score += 0.4; break;
      case 'degraded': score += 0.2; break;
      default: score += 0.0; break;
    }

    // Response time score (inverse relationship, capped at 5000ms)
    const responseTime = Math.min(server.responseTime, 5000);
    score += 0.3 * (1 - responseTime / 5000);

    // Success rate score
    if (server.metrics) {
      const successRate = server.metrics.successfulRequests / (server.metrics.totalRequests || 1);
      score += 0.2 * successRate;
    } else {
      score += 0.15; // Default for servers without metrics
    }

    // Load score (lower is better)
    if (server.metrics?.load !== undefined) {
      score += 0.1 * (1 - server.metrics.load);
    } else {
      score += 0.05; // Neutral score for unknown load
    }

    // Priority boost for high-priority requests
    if (context.priority && context.priority >= 8) {
      score *= 1.1;
    }

    return Math.max(0, Math.min(1, score));
  }
}

/**
 * Agent-optimized routing strategy
 */
export class AgentOptimizedStrategy implements RoutingStrategy {
  readonly name = 'agent-optimized';
  readonly description = 'Uses agent-specific learning and preferences for optimal routing';

  constructor(private agentProfiles: Map<AgentID, AgentProfile>) {}

  async evaluate(
    candidates: MCPServerInfo[],
    context: RoutingContext
  ): Promise<RoutingDecision> {
    const start = Date.now();

    if (candidates.length === 0) {
      throw new Error('No candidate servers available for routing');
    }

    // Get agent profile for optimization
    const agentProfile = context.agentId ? this.agentProfiles.get(context.agentId as AgentID) : null;
    
    // Score candidates based on agent preferences and learning
    const scored = candidates.map(server => ({
      server,
      score: this.calculateAgentOptimizedScore(server, context, agentProfile)
    }));

    // Sort by score (highest first)
    scored.sort((a, b) => b.score - a.score);
    const selected = scored[0];

    const reasoning = agentProfile 
      ? `Agent-optimized for ${agentProfile.name}: ${selected.server.name} (score: ${selected.score.toFixed(3)})`
      : `Agent-optimized (fallback): ${selected.server.name} (score: ${selected.score.toFixed(3)})`;

    return {
      selectedServer: selected.server,
      confidence: Math.min(selected.score, 1.0),
      reasoning,
      timestamp: new Date(),
      decisionTime: Date.now() - start,
      alternatives: scored.slice(1, 3).map(s => s.server)
    };
  }

  private calculateAgentOptimizedScore(
    server: MCPServerInfo,
    context: RoutingContext,
    agentProfile?: AgentProfile | null
  ): number {
    let score = 0;

    // Base performance score
    switch (server.status) {
      case 'healthy': score += 0.3; break;
      case 'degraded': score += 0.15; break;
      default: return 0; // Skip failed servers
    }

    // Agent-specific preferences
    if (agentProfile) {
      const preferences = agentProfile.preferences;
      const weights = preferences.weights;

      // Response time preference
      const responseTimeScore = Math.max(0, 1 - server.responseTime / preferences.responseTimeThreshold);
      score += weights.responseTime * 0.25 * responseTimeScore;

      // Reliability preference
      if (server.metrics) {
        const reliability = server.metrics.successfulRequests / (server.metrics.totalRequests || 1);
        score += weights.reliability * 0.25 * Math.max(0, (reliability - preferences.minSuccessRate) / (1 - preferences.minSuccessRate));
      }

      // Load preference
      if (server.metrics?.load !== undefined) {
        const loadScore = Math.max(0, (preferences.maxServerLoad - server.metrics.load) / preferences.maxServerLoad);
        score += weights.load * 0.1 * loadScore;
      }

      // Historical satisfaction
      const toolUsage = agentProfile.toolUsage.get(context.toolName);
      if (toolUsage?.satisfactionHistory.length) {
        const avgSatisfaction = toolUsage.satisfactionHistory.reduce((a, b) => a + b, 0) / toolUsage.satisfactionHistory.length;
        score += weights.satisfaction * 0.1 * avgSatisfaction;
      }

      // Manual server preferences
      const serverPref = preferences.serverPreferences.get(server.id);
      if (serverPref && (!serverPref.expiresAt || serverPref.expiresAt > new Date())) {
        score += serverPref.preference * 0.1;
      }
    }

    // Tool-specific optimization
    const hasToolCapability = server.capabilities.some(cap => cap.name === context.toolName);
    if (hasToolCapability) {
      score += 0.1;
    }

    return Math.max(0, Math.min(1, score));
  }
}

/**
 * Load-balanced routing strategy
 */
export class LoadBalancedStrategy implements RoutingStrategy {
  readonly name = 'load-balanced';
  readonly description = 'Distributes requests evenly across healthy servers';

  async evaluate(
    candidates: MCPServerInfo[],
    context: RoutingContext
  ): Promise<RoutingDecision> {
    const start = Date.now();

    if (candidates.length === 0) {
      throw new Error('No candidate servers available for routing');
    }

    // Filter to healthy servers only
    const healthy = candidates.filter(s => s.status === 'healthy' || s.status === 'degraded');
    if (healthy.length === 0) {
      // Fall back to any available server
      healthy.push(...candidates);
    }

    // Select server with lowest load
    const selected = healthy.reduce((best, current) => {
      const currentLoad = current.metrics?.load || 0;
      const bestLoad = best.metrics?.load || 0;
      return currentLoad < bestLoad ? current : best;
    });

    const confidence = selected.status === 'healthy' ? 0.8 : 0.5;

    return {
      selectedServer: selected,
      confidence,
      reasoning: `Load-balanced selection: ${selected.name} (load: ${selected.metrics?.load || 'unknown'})`,
      timestamp: new Date(),
      decisionTime: Date.now() - start,
      alternatives: healthy.filter(s => s.id !== selected.id).slice(0, 2)
    };
  }
}

/**
 * Main tool router implementation
 */
export class ToolRouter extends EventEmitter {
  private readonly strategies = new Map<string, RoutingStrategy>();
  private readonly cache: RoutingCache;
  private readonly config: ToolRouterConfig;
  private readonly agentProfiles: Map<AgentID, AgentProfile>;
  private metrics = {
    totalRoutingDecisions: 0,
    averageDecisionTime: 0,
    cacheHitRate: 0,
    strategyUsage: new Map<string, number>()
  };

  constructor(
    config: ToolRouterConfig,
    agentProfiles: Map<AgentID, AgentProfile> = new Map()
  ) {
    super();
    this.config = config;
    this.agentProfiles = agentProfiles;
    this.cache = new RoutingCache();

    // Initialize default strategies
    this.registerStrategy(new PerformanceFirstStrategy());
    this.registerStrategy(new AgentOptimizedStrategy(agentProfiles));
    this.registerStrategy(new LoadBalancedStrategy());
  }

  /**
   * Register a routing strategy
   */
  registerStrategy(strategy: RoutingStrategy): void {
    this.strategies.set(strategy.name, strategy);
    this.metrics.strategyUsage.set(strategy.name, 0);
  }

  /**
   * Main routing method - sub-100ms guaranteed
   */
  async route(
    toolName: ToolName,
    candidates: MCPServerInfo[],
    context: Partial<RoutingContext> = {}
  ): Promise<RoutingDecision> {
    const routingStart = Date.now();
    
    // Build complete routing context
    const fullContext: RoutingContext = {
      toolName: toolName as string,
      agentId: context.agentId,
      priority: context.priority || 5,
      parameters: context.parameters,
      requirements: context.requirements,
      timeout: context.timeout || this.config.decisionTimeout || 50
    };

    try {
      // Check cache first (sub-10ms lookup)
      const cacheResult = this.cache.get(fullContext);
      if (cacheResult.success && cacheResult.value) {
        this.updateMetrics(routingStart, 'cache-hit');
        return cacheResult.value;
      }

      // Apply timeout protection
      const timeoutPromise = new Promise<never>((_, reject) =>
        setTimeout(() => reject(new Error('Routing decision timeout')), fullContext.timeout)
      );

      // Get routing decision with timeout
      const decision = await Promise.race([
        this.performRouting(candidates, fullContext),
        timeoutPromise
      ]);

      // Cache successful decisions
      this.cache.set(fullContext, decision);
      this.updateMetrics(routingStart, 'cache-miss');

      return decision;
    } catch (error) {
      // Emergency fallback - select first healthy server
      const fallback = this.createFallbackDecision(candidates, fullContext, error as Error);
      this.updateMetrics(routingStart, 'fallback');
      return fallback;
    }
  }

  private async performRouting(
    candidates: MCPServerInfo[],
    context: RoutingContext
  ): Promise<RoutingDecision> {
    // Filter candidates to only those supporting the requested tool
    const toolCandidates = candidates.filter(server =>
      server.capabilities.some(cap => cap.name === context.toolName)
    );

    if (toolCandidates.length === 0) {
      throw new Error(`No servers found supporting tool: ${context.toolName}`);
    }

    // Select routing strategy
    const strategyName = this.selectStrategy(context);
    const strategy = this.strategies.get(strategyName);
    
    if (!strategy) {
      throw new Error(`Unknown routing strategy: ${strategyName}`);
    }

    // Update strategy usage metrics
    const currentUsage = this.metrics.strategyUsage.get(strategyName) || 0;
    this.metrics.strategyUsage.set(strategyName, currentUsage + 1);

    // Execute routing decision
    return await strategy.evaluate(toolCandidates, context);
  }

  private selectStrategy(context: RoutingContext): string {
    // Tool-specific overrides
    const toolOverride = this.config.toolOverrides?.[context.toolName];
    if (toolOverride && this.strategies.has(toolOverride)) {
      return toolOverride;
    }

    // Agent-specific preferences
    if (context.agentId) {
      const agentStrategy = this.config.agentPreferences?.[context.agentId]?.[context.toolName];
      if (agentStrategy && this.strategies.has(agentStrategy)) {
        return agentStrategy;
      }
    }

    // High priority requests use performance-first
    if (context.priority && context.priority >= 8) {
      return 'performance-first';
    }

    // Agent-specific routing when agent profile available
    if (context.agentId && this.agentProfiles.has(context.agentId as AgentID)) {
      return 'agent-optimized';
    }

    // Default strategy
    return this.config.defaultStrategy;
  }

  private createFallbackDecision(
    candidates: MCPServerInfo[],
    context: RoutingContext,
    error: Error
  ): RoutingDecision {
    // Find any healthy server supporting the tool
    const viable = candidates.find(server => 
      (server.status === 'healthy' || server.status === 'degraded') &&
      server.capabilities.some(cap => cap.name === context.toolName)
    );

    const selected = viable || candidates[0];
    
    return {
      selectedServer: selected,
      confidence: 0.1, // Very low confidence for fallback
      reasoning: `Emergency fallback due to routing error: ${error.message}`,
      timestamp: new Date(),
      decisionTime: 0,
      alternatives: []
    };
  }

  private updateMetrics(startTime: number, type: 'cache-hit' | 'cache-miss' | 'fallback'): void {
    const decisionTime = Date.now() - startTime;
    
    this.metrics.totalRoutingDecisions++;
    this.metrics.averageDecisionTime = 
      (this.metrics.averageDecisionTime * (this.metrics.totalRoutingDecisions - 1) + decisionTime) / 
      this.metrics.totalRoutingDecisions;

    const cacheStats = this.cache.getStats();
    this.metrics.cacheHitRate = cacheStats.hitRatio;

    // Emit telemetry if enabled
    if (this.config.enableTelemetry) {
      this.emit('routing-metrics', {
        decisionTime,
        type,
        totalDecisions: this.metrics.totalRoutingDecisions,
        averageTime: this.metrics.averageDecisionTime,
        cacheHitRate: this.metrics.cacheHitRate
      });
    }
  }

  /**
   * Update agent profile for improved routing
   */
  updateAgentProfile(agentId: AgentID, profile: AgentProfile): void {
    this.agentProfiles.set(agentId, profile);
    // Re-register agent-optimized strategy with updated profiles
    this.registerStrategy(new AgentOptimizedStrategy(this.agentProfiles));
  }

  /**
   * Get routing performance metrics
   */
  getMetrics() {
    return {
      ...this.metrics,
      cacheStats: this.cache.getStats(),
      strategies: Array.from(this.strategies.keys()),
      strategyUsage: Object.fromEntries(this.metrics.strategyUsage)
    };
  }

  /**
   * Clear routing cache
   */
  clearCache(): void {
    this.cache.clear();
  }

  /**
   * Get available routing strategies
   */
  getStrategies(): string[] {
    return Array.from(this.strategies.keys());
  }
}

/**
 * Factory function for creating optimized tool router
 */
export function createToolRouter(
  config: Partial<ToolRouterConfig> = {}
): ToolRouter {
  const defaultConfig: ToolRouterConfig = {
    defaultStrategy: 'performance-first',
    strategies: {
      'performance-first': {
        weights: { performance: 0.4, availability: 0.3, load: 0.2, preference: 0.1 },
        options: { responseTimeThreshold: 1000 }
      },
      'agent-optimized': {
        weights: { performance: 0.25, availability: 0.25, load: 0.15, preference: 0.35 },
        options: { learningRate: 0.1 }
      },
      'load-balanced': {
        weights: { performance: 0.2, availability: 0.3, load: 0.5, preference: 0.0 },
        options: {}
      }
    },
    enableAdaptiveRouting: true,
    decisionTimeout: 50, // Sub-100ms guaranteed
    enableTelemetry: true
  };

  const mergedConfig = { ...defaultConfig, ...config };
  return new ToolRouter(mergedConfig);
}

// Export all classes and functions
export {
  RoutingCache,
  PerformanceFirstStrategy,
  AgentOptimizedStrategy,  
  LoadBalancedStrategy
};

// Export main router class as default
export default ToolRouter;