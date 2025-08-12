import { EventEmitter } from 'events';
import { MCPServerInfo, ServerMetrics, PerformanceBenchmark } from '../types';
import { MCPServerRegistry } from './registry';

// =============================================================================
// Core Interfaces
// =============================================================================

/**
 * Agent-specific preferences and optimization profile
 */
export interface AgentProfile {
  /** Unique agent identifier */
  agentId: string;
  /** Agent display name */
  name: string;
  /** Agent category (e.g., 'development', 'analysis', 'infrastructure') */
  category: string;
  /** Tool usage patterns */
  toolUsage: Map<string, ToolUsagePattern>;
  /** Performance preferences */
  preferences: AgentPreferences;
  /** Learning configuration */
  learning: LearningConfig;
  /** Profile metadata */
  metadata: AgentMetadata;
}

/**
 * Tool usage pattern for an agent
 */
export interface ToolUsagePattern {
  /** Tool name */
  toolName: string;
  /** Usage frequency (requests per hour) */
  frequency: number;
  /** Typical request size/complexity */
  typicalComplexity: number;
  /** Performance requirements */
  requirements: PerformanceRequirements;
  /** Historical satisfaction scores */
  satisfactionHistory: number[];
  /** Last used timestamp */
  lastUsed: Date;
}

/**
 * Agent performance preferences
 */
export interface AgentPreferences {
  /** Preferred response time threshold (ms) */
  responseTimeThreshold: number;
  /** Minimum acceptable success rate (0-1) */
  minSuccessRate: number;
  /** Maximum acceptable server load (0-1) */
  maxServerLoad: number;
  /** Preference weights for server selection */
  weights: PreferenceWeights;
  /** Manual server preferences */
  serverPreferences: Map<string, ServerPreference>;
}

/**
 * Preference weights for different factors
 */
export interface PreferenceWeights {
  /** Response time importance (0-1) */
  responseTime: number;
  /** Reliability importance (0-1) */
  reliability: number;
  /** Server load importance (0-1) */
  load: number;
  /** Historical satisfaction importance (0-1) */
  satisfaction: number;
}

/**
 * Manual server preference
 */
export interface ServerPreference {
  /** Server ID */
  serverId: string;
  /** Preference strength (-1 to 1, negative means avoid) */
  preference: number;
  /** Reason for preference */
  reason: string;
  /** When preference was set */
  setAt: Date;
  /** Preference expiry */
  expiresAt?: Date;
}

/**
 * Performance requirements for routing
 */
export interface PerformanceRequirements {
  /** Maximum acceptable response time (ms) */
  maxResponseTime?: number;
  /** Minimum required success rate (0-1) */
  minSuccessRate?: number;
  /** Maximum acceptable load (0-1) */
  maxLoad?: number;
  /** Required availability percentage */
  minAvailability?: number;
}

/**
 * Learning configuration for adaptation
 */
export interface LearningConfig {
  /** Learning rate for preference updates (0-1) */
  learningRate: number;
  /** Exponential moving average alpha for metrics */
  emaAlpha: number;
  /** Minimum samples before making learning updates */
  minSamples: number;
  /** Maximum history to retain */
  maxHistory: number;
  /** Enable automatic preference learning */
  enableAutoLearning: boolean;
}

/**
 * Agent metadata
 */
export interface AgentMetadata {
  /** Creation timestamp */
  createdAt: Date;
  /** Last activity timestamp */
  lastActivity: Date;
  /** Total requests made */
  totalRequests: number;
  /** Agent version */
  version?: string;
  /** Custom tags */
  tags?: string[];
}

/**
 * Performance learning data point
 */
export interface PerformanceLearning {
  /** Server ID */
  serverId: string;
  /** Tool name */
  toolName: string;
  /** Agent ID */
  agentId: string;
  /** Response time in ms */
  responseTime: number;
  /** Success indicator */
  success: boolean;
  /** User satisfaction score (0-1) */
  satisfaction?: number;
  /** Request timestamp */
  timestamp: Date;
  /** Request context */
  context?: Record<string, any>;
}

/**
 * Preference override for manual control
 */
export interface PreferenceOverride {
  /** Override ID */
  id: string;
  /** Target scope */
  scope: OverrideScope;
  /** Override type */
  type: 'prefer' | 'avoid' | 'require' | 'exclude';
  /** Override strength (0-1) */
  strength: number;
  /** Override reason */
  reason: string;
  /** Override expiry */
  expiresAt?: Date;
  /** Created by */
  createdBy: string;
  /** Created timestamp */
  createdAt: Date;
}

/**
 * Override scope definition
 */
export interface OverrideScope {
  /** Agent ID (null for global) */
  agentId?: string;
  /** Tool name (null for all tools) */
  toolName?: string;
  /** Server ID */
  serverId: string;
}

/**
 * Preference engine configuration
 */
export interface PreferenceEngineConfig {
  /** Default learning configuration */
  defaultLearning: LearningConfig;
  /** Enable persistence */
  enablePersistence: boolean;
  /** Persistence interval (ms) */
  persistenceInterval: number;
  /** Profile cleanup interval (ms) */
  cleanupInterval: number;
  /** Maximum profiles to maintain */
  maxProfiles: number;
  /** Default preference weights */
  defaultWeights: PreferenceWeights;
}

// =============================================================================
// Preference Engine Implementation
// =============================================================================

/**
 * Performance-based tool preference learning engine
 * Continuously adapts routing preferences based on real-world performance
 */
export class PreferenceEngine extends EventEmitter {
  private readonly registry: MCPServerRegistry;
  private readonly profiles: Map<string, AgentProfile> = new Map();
  private readonly learningData: PerformanceLearning[] = [];
  private readonly overrides: Map<string, PreferenceOverride> = new Map();
  private readonly config: PreferenceEngineConfig;
  private persistenceTimer?: NodeJS.Timeout;
  private cleanupTimer?: NodeJS.Timeout;

  constructor(registry: MCPServerRegistry, config: Partial<PreferenceEngineConfig> = {}) {
    super();
    
    this.registry = registry;
    this.config = {
      defaultLearning: {
        learningRate: 0.1,
        emaAlpha: 0.2,
        minSamples: 5,
        maxHistory: 1000,
        enableAutoLearning: true
      },
      enablePersistence: true,
      persistenceInterval: 60000, // 1 minute
      cleanupInterval: 300000, // 5 minutes
      maxProfiles: 1000,
      defaultWeights: {
        responseTime: 0.3,
        reliability: 0.3,
        load: 0.2,
        satisfaction: 0.2
      },
      ...config
    };

    if (this.config.enablePersistence) {
      this.startPersistenceTimer();
    }
    this.startCleanupTimer();
  }

  /**
   * Learn from performance data to improve preferences
   */
  async learn(data: PerformanceLearning): Promise<void> {
    try {
      // Store learning data
      this.learningData.push(data);
      
      // Trim learning data if too large
      if (this.learningData.length > this.config.defaultLearning.maxHistory) {
        this.learningData.splice(0, this.learningData.length - this.config.defaultLearning.maxHistory);
      }

      // Get or create agent profile
      const profile = await this.getOrCreateAgentProfile(data.agentId);
      
      // Update tool usage pattern
      this.updateToolUsagePattern(profile, data);
      
      // Learn preferences if auto-learning is enabled
      if (profile.learning.enableAutoLearning) {
        await this.updatePreferences(profile, data);
      }

      // Emit learning event
      this.emit('learningUpdate', { agentId: data.agentId, data });
      
    } catch (error) {
      console.error('Learning failed:', error);
      this.emit('learningError', { data, error });
    }
  }

  /**
   * Get preferences for an agent and tool
   */
  async getPreferences(agentId: string, toolName: string): Promise<{
    weights: PreferenceWeights;
    serverPreferences: Map<string, number>;
    requirements: PerformanceRequirements;
  }> {
    const profile = this.profiles.get(agentId);
    
    if (!profile) {
      // Return default preferences
      return {
        weights: this.config.defaultWeights,
        serverPreferences: new Map(),
        requirements: {}
      };
    }

    const toolUsage = profile.toolUsage.get(toolName);
    const serverPreferences = new Map<string, number>();

    // Calculate server preferences based on historical performance
    for (const [serverId, preference] of profile.preferences.serverPreferences) {
      if (this.isPreferenceValid(preference)) {
        serverPreferences.set(serverId, preference.preference);
      }
    }

    // Apply overrides
    this.applyOverrides(agentId, toolName, serverPreferences);

    return {
      weights: profile.preferences.weights,
      serverPreferences,
      requirements: toolUsage?.requirements || {}
    };
  }

  /**
   * Set manual preference override
   */
  async setPreferenceOverride(override: Omit<PreferenceOverride, 'id' | 'createdAt'>): Promise<string> {
    const id = `override_${Date.now()}_${Math.random().toString(36).substring(2)}`;
    const fullOverride: PreferenceOverride = {
      ...override,
      id,
      createdAt: new Date()
    };

    this.overrides.set(id, fullOverride);
    this.emit('preferenceOverrideSet', fullOverride);
    
    console.log(`Preference override set: ${override.type} ${override.scope.serverId} for ${override.scope.agentId || 'all agents'}/${override.scope.toolName || 'all tools'}`);
    
    return id;
  }

  /**
   * Remove preference override
   */
  async removePreferenceOverride(overrideId: string): Promise<boolean> {
    const removed = this.overrides.delete(overrideId);
    if (removed) {
      this.emit('preferenceOverrideRemoved', overrideId);
    }
    return removed;
  }

  /**
   * Get all active overrides
   */
  getPreferenceOverrides(agentId?: string, toolName?: string): PreferenceOverride[] {
    const now = Date.now();
    return Array.from(this.overrides.values()).filter(override => {
      // Check expiry
      if (override.expiresAt && override.expiresAt.getTime() < now) {
        return false;
      }
      
      // Filter by scope
      if (agentId && override.scope.agentId && override.scope.agentId !== agentId) {
        return false;
      }
      
      if (toolName && override.scope.toolName && override.scope.toolName !== toolName) {
        return false;
      }
      
      return true;
    });
  }

  /**
   * Get agent profile
   */
  getAgentProfile(agentId: string): AgentProfile | undefined {
    return this.profiles.get(agentId);
  }

  /**
   * Get all agent profiles
   */
  getAllAgentProfiles(): AgentProfile[] {
    return Array.from(this.profiles.values());
  }

  /**
   * Update agent profile configuration
   */
  async updateAgentProfile(agentId: string, updates: Partial<AgentProfile>): Promise<void> {
    const profile = this.profiles.get(agentId);
    if (!profile) {
      throw new Error(`Agent profile not found: ${agentId}`);
    }

    Object.assign(profile, updates);
    profile.metadata.lastActivity = new Date();
    
    this.emit('agentProfileUpdated', { agentId, profile });
  }

  /**
   * Get learning statistics
   */
  getLearningStats(): {
    totalLearningData: number;
    activeProfiles: number;
    activeOverrides: number;
    averageSatisfaction: number;
    toolUsageStats: Record<string, number>;
  } {
    const now = Date.now();
    const recentData = this.learningData.filter(d => 
      now - d.timestamp.getTime() < 24 * 60 * 60 * 1000 // Last 24 hours
    );

    const satisfactionScores = recentData
      .map(d => d.satisfaction)
      .filter(s => s !== undefined) as number[];

    const toolUsage: Record<string, number> = {};
    for (const data of recentData) {
      toolUsage[data.toolName] = (toolUsage[data.toolName] || 0) + 1;
    }

    return {
      totalLearningData: this.learningData.length,
      activeProfiles: this.profiles.size,
      activeOverrides: this.getPreferenceOverrides().length,
      averageSatisfaction: satisfactionScores.length > 0 
        ? satisfactionScores.reduce((sum, s) => sum + s, 0) / satisfactionScores.length 
        : 0,
      toolUsageStats: toolUsage
    };
  }

  /**
   * Export preferences for backup/migration
   */
  exportPreferences(): {
    profiles: AgentProfile[];
    overrides: PreferenceOverride[];
    learningData: PerformanceLearning[];
  } {
    return {
      profiles: Array.from(this.profiles.values()),
      overrides: Array.from(this.overrides.values()),
      learningData: this.learningData.slice() // Copy array
    };
  }

  /**
   * Import preferences from backup
   */
  async importPreferences(data: {
    profiles?: AgentProfile[];
    overrides?: PreferenceOverride[];
    learningData?: PerformanceLearning[];
  }): Promise<void> {
    if (data.profiles) {
      for (const profile of data.profiles) {
        this.profiles.set(profile.agentId, profile);
      }
    }

    if (data.overrides) {
      for (const override of data.overrides) {
        this.overrides.set(override.id, override);
      }
    }

    if (data.learningData) {
      this.learningData.push(...data.learningData);
      // Trim if necessary
      if (this.learningData.length > this.config.defaultLearning.maxHistory) {
        this.learningData.splice(0, this.learningData.length - this.config.defaultLearning.maxHistory);
      }
    }

    this.emit('preferencesImported', { 
      profileCount: data.profiles?.length || 0,
      overrideCount: data.overrides?.length || 0,
      dataPointCount: data.learningData?.length || 0
    });
  }

  /**
   * Cleanup resources
   */
  destroy(): void {
    if (this.persistenceTimer) {
      clearInterval(this.persistenceTimer);
    }
    if (this.cleanupTimer) {
      clearInterval(this.cleanupTimer);
    }
    
    this.profiles.clear();
    this.overrides.clear();
    this.learningData.length = 0;
    this.removeAllListeners();
  }

  // =============================================================================
  // Private Methods
  // =============================================================================

  private async getOrCreateAgentProfile(agentId: string): Promise<AgentProfile> {
    let profile = this.profiles.get(agentId);
    
    if (!profile) {
      profile = {
        agentId,
        name: agentId,
        category: 'unknown',
        toolUsage: new Map(),
        preferences: {
          responseTimeThreshold: 1000,
          minSuccessRate: 0.95,
          maxServerLoad: 0.8,
          weights: { ...this.config.defaultWeights },
          serverPreferences: new Map()
        },
        learning: { ...this.config.defaultLearning },
        metadata: {
          createdAt: new Date(),
          lastActivity: new Date(),
          totalRequests: 0
        }
      };
      
      this.profiles.set(agentId, profile);
      this.emit('agentProfileCreated', profile);
    }
    
    return profile;
  }

  private updateToolUsagePattern(profile: AgentProfile, data: PerformanceLearning): void {
    let usage = profile.toolUsage.get(data.toolName);
    
    if (!usage) {
      usage = {
        toolName: data.toolName,
        frequency: 0,
        typicalComplexity: 1,
        requirements: {},
        satisfactionHistory: [],
        lastUsed: new Date()
      };
      profile.toolUsage.set(data.toolName, usage);
    }

    // Update usage metrics
    usage.lastUsed = data.timestamp;
    usage.frequency = this.updateWithEMA(usage.frequency, 1, profile.learning.emaAlpha);
    
    if (data.satisfaction !== undefined) {
      usage.satisfactionHistory.push(data.satisfaction);
      if (usage.satisfactionHistory.length > 100) {
        usage.satisfactionHistory.shift();
      }
    }

    // Update profile metadata
    profile.metadata.lastActivity = data.timestamp;
    profile.metadata.totalRequests++;
  }

  private async updatePreferences(profile: AgentProfile, data: PerformanceLearning): Promise<void> {
    const minSamples = profile.learning.minSamples;
    const serverData = this.getLearningDataForServer(data.serverId, data.toolName, data.agentId);
    
    if (serverData.length < minSamples) {
      return; // Not enough data for learning
    }

    // Calculate performance metrics
    const avgResponseTime = serverData.reduce((sum, d) => sum + d.responseTime, 0) / serverData.length;
    const successRate = serverData.filter(d => d.success).length / serverData.length;
    const avgSatisfaction = this.calculateAverageSatisfaction(serverData);

    // Calculate preference score
    const responseTimeScore = Math.max(0, 1 - (avgResponseTime / 5000)); // Normalize to 5s
    const reliabilityScore = successRate;
    const satisfactionScore = avgSatisfaction;

    const weights = profile.preferences.weights;
    const preferenceScore = (
      (responseTimeScore * weights.responseTime) +
      (reliabilityScore * weights.reliability) +
      (satisfactionScore * weights.satisfaction)
    ) / (weights.responseTime + weights.reliability + weights.satisfaction);

    // Update server preference with exponential moving average
    const existing = profile.preferences.serverPreferences.get(data.serverId);
    const currentPreference = existing?.preference || 0.5;
    const newPreference = this.updateWithEMA(currentPreference, preferenceScore, profile.learning.learningRate);

    profile.preferences.serverPreferences.set(data.serverId, {
      serverId: data.serverId,
      preference: newPreference,
      reason: 'Learned from performance data',
      setAt: new Date()
    });

    this.emit('preferenceUpdated', {
      agentId: profile.agentId,
      serverId: data.serverId,
      toolName: data.toolName,
      oldPreference: currentPreference,
      newPreference
    });
  }

  private getLearningDataForServer(serverId: string, toolName: string, agentId: string): PerformanceLearning[] {
    return this.learningData.filter(d =>
      d.serverId === serverId &&
      d.toolName === toolName &&
      d.agentId === agentId
    );
  }

  private calculateAverageSatisfaction(data: PerformanceLearning[]): number {
    const satisfactionScores = data
      .map(d => d.satisfaction)
      .filter(s => s !== undefined) as number[];
    
    return satisfactionScores.length > 0
      ? satisfactionScores.reduce((sum, s) => sum + s, 0) / satisfactionScores.length
      : 0.5; // Neutral if no satisfaction data
  }

  private updateWithEMA(current: number, newValue: number, alpha: number): number {
    return alpha * newValue + (1 - alpha) * current;
  }

  private isPreferenceValid(preference: ServerPreference): boolean {
    if (preference.expiresAt && preference.expiresAt < new Date()) {
      return false;
    }
    return true;
  }

  private applyOverrides(agentId: string, toolName: string, serverPreferences: Map<string, number>): void {
    const overrides = this.getPreferenceOverrides(agentId, toolName);
    
    for (const override of overrides) {
      const serverId = override.scope.serverId;
      const current = serverPreferences.get(serverId) || 0;
      
      switch (override.type) {
        case 'prefer':
          serverPreferences.set(serverId, Math.max(current, override.strength));
          break;
        case 'avoid':
          serverPreferences.set(serverId, Math.min(current, -override.strength));
          break;
        case 'require':
          serverPreferences.set(serverId, 1);
          break;
        case 'exclude':
          serverPreferences.set(serverId, -1);
          break;
      }
    }
  }

  private startPersistenceTimer(): void {
    this.persistenceTimer = setInterval(() => {
      this.emit('persistenceRequired', this.exportPreferences());
    }, this.config.persistenceInterval);
  }

  private startCleanupTimer(): void {
    this.cleanupTimer = setInterval(() => {
      this.cleanupExpiredData();
    }, this.config.cleanupInterval);
  }

  private cleanupExpiredData(): void {
    const now = Date.now();
    
    // Remove expired overrides
    for (const [id, override] of this.overrides.entries()) {
      if (override.expiresAt && override.expiresAt.getTime() < now) {
        this.overrides.delete(id);
      }
    }

    // Remove old learning data
    const cutoff = now - (7 * 24 * 60 * 60 * 1000); // 7 days
    const validData = this.learningData.filter(d => d.timestamp.getTime() > cutoff);
    this.learningData.length = 0;
    this.learningData.push(...validData);

    // Clean up inactive profiles
    if (this.profiles.size > this.config.maxProfiles) {
      const profiles = Array.from(this.profiles.entries())
        .sort(([, a], [, b]) => b.metadata.lastActivity.getTime() - a.metadata.lastActivity.getTime())
        .slice(this.config.maxProfiles);
      
      for (const [agentId] of profiles) {
        this.profiles.delete(agentId);
      }
    }
  }
}

// =============================================================================
// Exports
// =============================================================================

export type {
  AgentProfile,
  ToolUsagePattern,
  AgentPreferences,
  PreferenceWeights,
  ServerPreference,
  PerformanceRequirements,
  LearningConfig,
  AgentMetadata,
  PerformanceLearning,
  PreferenceOverride,
  OverrideScope,
  PreferenceEngineConfig
};

export { PreferenceEngine };