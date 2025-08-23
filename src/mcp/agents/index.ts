/**
 * SPEC_02: Agent Enhancement Framework
 *
 * Provides MCP-aware agent management and enhancement capabilities
 */

import * as fs from 'fs';
import * as path from 'path';
import * as yaml from 'js-yaml';
import { EventEmitter } from 'events';

/**
 * Agent configuration structure
 */
interface AgentConfig {
  id: string;
  name: string;
  category: string;
  mcp_integration: {
    enabled: boolean;
    tool_preferences: Record<string, any>;
    performance_profiles: Record<string, any>;
    fallback_strategies: any[];
  };
  optimization_profiles: Record<string, any>;
  backward_compatibility: {
    enabled: boolean;
    fallback_mode: string;
  };
}

/**
 * Agent category definitions
 */
export enum AgentCategory {
  DEVELOPMENT = 'development',
  ANALYSIS = 'analysis',
  INFRASTRUCTURE = 'infrastructure',
  SPECIALIZED = 'specialized'
}

/**
 * MCP-Enhanced Agent Manager
 * Implements SPEC_02 requirements for agent enhancement
 */
export class MCPAgentManager extends EventEmitter {
  private agents: Map<string, AgentConfig> = new Map();
  private agentsByCategory: Map<string, Set<string>> = new Map();
  private isInitialized = false;

  constructor(private agentsPath: string = path.join(__dirname)) {
    super();
    this.initializeCategories();
  }

  /**
   * Initialize agent categories
   */
  private initializeCategories(): void {
    Object.values(AgentCategory).forEach(category => {
      this.agentsByCategory.set(category, new Set());
    });
  }

  /**
   * Load all agent configurations
   * Note: Agent directories were removed. This loader is now deprecated.
   * The primary agent system uses the .claude/agents/ directory with Markdown format.
   */
  async loadAgents(): Promise<void> {
    console.log('⚠️ MCP YAML agent loader is deprecated. Agent directories removed.');
    console.log('📝 Primary agent system is now in system-configs/.claude/agents/ (Markdown format)');

    // For testing purposes, load mock agents
    if (process.env.NODE_ENV === 'test' || process.env.JEST_WORKER_ID) {
      this.loadMockAgents();
    }

    this.isInitialized = true;
    console.log(`✅ MCP agent manager initialized (${this.agents.size} agents loaded)`);
    this.emit('agentsLoaded', { count: this.agents.size });
  }

  /**
   * Load mock agents for testing
   */
  private loadMockAgents(): void {
    const mockAgents: AgentConfig[] = [
      {
        id: 'backend-engineer',
        name: 'Backend Engineer',
        category: 'development',
        mcp_integration: {
          enabled: true,
          tool_preferences: {
            'code-generation': { priority: 'high', timeout: 5000 },
            'testing': { priority: 'medium', timeout: 3000 }
          },
          performance_profiles: {
            'small': { workers: 1, memory: '512MB' },
            'medium': { workers: 2, memory: '1GB' },
            'large': { workers: 4, memory: '2GB' }
          },
          fallback_strategies: [
            { type: 'retry', max_attempts: 3 },
            { type: 'degrade', fallback_mode: 'simple' }
          ]
        },
        optimization_profiles: {
          'small': { parallel_tasks: 2, cache_size: 50 },
          'medium': { parallel_tasks: 4, cache_size: 100 },
          'large': { parallel_tasks: 8, cache_size: 200 }
        },
        backward_compatibility: {
          enabled: true,
          fallback_mode: 'standard'
        }
      },
      {
        id: 'frontend-architect',
        name: 'Frontend Architect',
        category: 'development',
        mcp_integration: {
          enabled: true,
          tool_preferences: {
            'ui-testing': { priority: 'high', timeout: 8000 },
            'performance': { priority: 'medium', timeout: 5000 }
          },
          performance_profiles: {
            'small': { workers: 1, memory: '256MB' },
            'medium': { workers: 2, memory: '512MB' },
            'large': { workers: 3, memory: '1GB' }
          },
          fallback_strategies: [
            { type: 'retry', max_attempts: 2 },
            { type: 'degrade', fallback_mode: 'basic' }
          ]
        },
        optimization_profiles: {
          'small': { parallel_tasks: 1, cache_size: 25 },
          'medium': { parallel_tasks: 3, cache_size: 75 },
          'large': { parallel_tasks: 6, cache_size: 150 }
        },
        backward_compatibility: {
          enabled: true,
          fallback_mode: 'standard'
        }
      },
      {
        id: 'codebase-analyst',
        name: 'Codebase Analyst',
        category: 'analysis',
        mcp_integration: {
          enabled: true,
          tool_preferences: {
            'static-analysis': { priority: 'high', timeout: 10000 },
            'dependency-analysis': { priority: 'medium', timeout: 7000 }
          },
          performance_profiles: {
            'small': { workers: 2, memory: '1GB' },
            'medium': { workers: 4, memory: '2GB' },
            'large': { workers: 6, memory: '4GB' }
          },
          fallback_strategies: [
            { type: 'retry', max_attempts: 3 },
            { type: 'degrade', fallback_mode: 'basic' }
          ]
        },
        optimization_profiles: {
          'small': { parallel_tasks: 3, cache_size: 100 },
          'medium': { parallel_tasks: 6, cache_size: 200 },
          'large': { parallel_tasks: 12, cache_size: 400 }
        },
        backward_compatibility: {
          enabled: true,
          fallback_mode: 'standard'
        }
      },
      {
        id: 'kubernetes-admin',
        name: 'Kubernetes Admin',
        category: 'infrastructure',
        mcp_integration: {
          enabled: true,
          tool_preferences: {
            'cluster-management': { priority: 'critical', timeout: 15000 },
            'monitoring': { priority: 'high', timeout: 8000 }
          },
          performance_profiles: {
            'small': { workers: 1, memory: '512MB' },
            'medium': { workers: 3, memory: '1GB' },
            'large': { workers: 5, memory: '2GB' }
          },
          fallback_strategies: [
            { type: 'retry', max_attempts: 5 },
            { type: 'circuit-breaker', threshold: 3 }
          ]
        },
        optimization_profiles: {
          'small': { parallel_tasks: 2, cache_size: 50 },
          'medium': { parallel_tasks: 5, cache_size: 150 },
          'large': { parallel_tasks: 10, cache_size: 300 }
        },
        backward_compatibility: {
          enabled: true,
          fallback_mode: 'kubectl'
        }
      },
      {
        id: 'security-auditor',
        name: 'Security Auditor',
        category: 'specialized',
        mcp_integration: {
          enabled: true,
          tool_preferences: {
            'vulnerability-scanning': { priority: 'critical', timeout: 20000 },
            'compliance-checking': { priority: 'high', timeout: 12000 }
          },
          performance_profiles: {
            'small': { workers: 2, memory: '1GB' },
            'medium': { workers: 4, memory: '2GB' },
            'large': { workers: 8, memory: '4GB' }
          },
          fallback_strategies: [
            { type: 'retry', max_attempts: 3 },
            { type: 'escalate', fallback_agent: 'manual-review' }
          ]
        },
        optimization_profiles: {
          'small': { parallel_tasks: 2, cache_size: 75 },
          'medium': { parallel_tasks: 4, cache_size: 150 },
          'large': { parallel_tasks: 8, cache_size: 300 }
        },
        backward_compatibility: {
          enabled: true,
          fallback_mode: 'standard'
        }
      }
    ];

    mockAgents.forEach(agent => {
      this.agents.set(agent.id, agent);
      const categoryAgents = this.agentsByCategory.get(agent.category) || new Set();
      categoryAgents.add(agent.id);
      this.agentsByCategory.set(agent.category, categoryAgents);
    });

    console.log(`📋 Loaded ${mockAgents.length} mock agents for testing`);
  }

  /**
   * Get agent by ID
   */
  getAgent(agentId: string): AgentConfig | undefined {
    return this.agents.get(agentId);
  }

  /**
   * Get agents by category
   */
  getAgentsByCategory(category: AgentCategory): AgentConfig[] {
    const agentIds = this.agentsByCategory.get(category) || new Set();
    return Array.from(agentIds).map(id => this.agents.get(id)!).filter(Boolean);
  }

  /**
   * Get MCP tool preferences for an agent
   */
  getToolPreferences(agentId: string, toolType: string): any {
    const agent = this.agents.get(agentId);
    if (!agent || !agent.mcp_integration.enabled) {
      return null;
    }

    return agent.mcp_integration.tool_preferences[toolType] || null;
  }

  /**
   * Get performance profile for an agent
   */
  getPerformanceProfile(agentId: string, profileName: string): any {
    const agent = this.agents.get(agentId);
    if (!agent) return null;

    return agent.mcp_integration.performance_profiles[profileName] ||
           agent.mcp_integration.performance_profiles.default ||
           null;
  }

  /**
   * Get optimal agent for a task based on MCP capabilities
   */
  getOptimalAgent(taskType: string, requirements?: {
    category?: AgentCategory;
    capabilities?: string[];
    performanceMode?: string;
  }): AgentConfig | null {
    let candidates = Array.from(this.agents.values());

    // Filter by category if specified
    if (requirements?.category) {
      candidates = candidates.filter(a => a.category === requirements.category);
    }

    // Filter by MCP enablement
    candidates = candidates.filter(a => a.mcp_integration.enabled);

    // Score agents based on task fit
    const scored = candidates.map(agent => {
      let score = 0;

      // Check if agent has preferences for this task type
      if (agent.mcp_integration.tool_preferences[taskType]) {
        score += 10;
      }

      // Check performance profile availability
      if (requirements?.performanceMode &&
          agent.mcp_integration.performance_profiles[requirements.performanceMode]) {
        score += 5;
      }

      // Check capabilities match
      if (requirements?.capabilities) {
        const agentCapabilities = Object.keys(agent.mcp_integration.tool_preferences);
        const matches = requirements.capabilities.filter(cap =>
          agentCapabilities.includes(cap)
        ).length;
        score += matches * 2;
      }

      return { agent, score };
    });

    // Sort by score and return best match
    scored.sort((a, b) => b.score - a.score);

    if (scored.length > 0 && scored[0].score > 0) {
      const selected = scored[0].agent;
      this.emit('agentSelected', {
        agent: selected,
        taskType,
        score: scored[0].score
      });
      return selected;
    }

    return null;
  }

  /**
   * Get fallback strategy for an agent
   */
  getFallbackStrategy(agentId: string): any[] {
    const agent = this.agents.get(agentId);
    if (!agent) return [];

    return agent.mcp_integration.fallback_strategies || [];
  }

  /**
   * Check if agent supports backward compatibility
   */
  isBackwardCompatible(agentId: string): boolean {
    const agent = this.agents.get(agentId);
    return agent?.backward_compatibility?.enabled || false;
  }

  /**
   * Get agent statistics
   */
  getStatistics(): any {
    const stats = {
      totalAgents: this.agents.size,
      mcpEnabled: 0,
      backwardCompatible: 0,
      byCategory: {} as Record<string, number>,
      performanceProfiles: new Set<string>(),
      toolTypes: new Set<string>()
    };

    for (const agent of this.agents.values()) {
      if (agent.mcp_integration.enabled) {
        stats.mcpEnabled++;
      }

      if (agent.backward_compatibility.enabled) {
        stats.backwardCompatible++;
      }

      // Count by category
      stats.byCategory[agent.category] = (stats.byCategory[agent.category] || 0) + 1;

      // Collect unique performance profiles
      Object.keys(agent.mcp_integration.performance_profiles).forEach(profile => {
        stats.performanceProfiles.add(profile);
      });

      // Collect unique tool types
      Object.keys(agent.mcp_integration.tool_preferences).forEach(tool => {
        stats.toolTypes.add(tool);
      });
    }

    return {
      ...stats,
      performanceProfiles: Array.from(stats.performanceProfiles),
      toolTypes: Array.from(stats.toolTypes)
    };
  }

  /**
   * Validate agent configuration
   */
  validateAgent(agentId: string): { valid: boolean; errors: string[] } {
    const agent = this.agents.get(agentId);
    const errors: string[] = [];

    if (!agent) {
      return { valid: false, errors: ['Agent not found'] };
    }

    // Check required fields
    if (!agent.id) errors.push('Missing agent ID');
    if (!agent.name) errors.push('Missing agent name');
    if (!agent.category) errors.push('Missing agent category');

    // Check MCP integration
    if (agent.mcp_integration.enabled) {
      if (!agent.mcp_integration.tool_preferences ||
          Object.keys(agent.mcp_integration.tool_preferences).length === 0) {
        errors.push('MCP enabled but no tool preferences defined');
      }

      if (!agent.mcp_integration.performance_profiles ||
          Object.keys(agent.mcp_integration.performance_profiles).length === 0) {
        errors.push('MCP enabled but no performance profiles defined');
      }

      if (!agent.mcp_integration.fallback_strategies ||
          agent.mcp_integration.fallback_strategies.length === 0) {
        errors.push('MCP enabled but no fallback strategies defined');
      }
    }

    // Check backward compatibility
    if (agent.backward_compatibility.enabled && !agent.backward_compatibility.fallback_mode) {
      errors.push('Backward compatibility enabled but no fallback mode specified');
    }

    return {
      valid: errors.length === 0,
      errors
    };
  }

  /**
   * Export agent configuration for deployment
   */
  exportConfiguration(): string {
    const config = {
      version: '2.0',
      spec: 'SPEC_02',
      agents: Array.from(this.agents.values()),
      statistics: this.getStatistics(),
      timestamp: new Date().toISOString()
    };

    return JSON.stringify(config, null, 2);
  }
}

/**
 * Create a singleton instance
 */
export const agentManager = new MCPAgentManager();

/**
 * Initialize and export
 */
export async function initializeAgents(): Promise<MCPAgentManager> {
  await agentManager.loadAgents();
  return agentManager;
}

export default MCPAgentManager;
