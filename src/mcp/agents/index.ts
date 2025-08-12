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
   */
  async loadAgents(): Promise<void> {
    console.log('🚀 Loading MCP-enhanced agents...');
    
    const categories = Object.values(AgentCategory);
    let totalAgents = 0;

    for (const category of categories) {
      const categoryPath = path.join(this.agentsPath, category);
      
      if (!fs.existsSync(categoryPath)) {
        console.log(`⚠️ Category directory not found: ${category}`);
        continue;
      }

      const files = fs.readdirSync(categoryPath).filter(f => f.endsWith('.yaml'));
      
      for (const file of files) {
        try {
          const filePath = path.join(categoryPath, file);
          const content = fs.readFileSync(filePath, 'utf-8');
          const config = yaml.load(content) as AgentConfig;
          
          // Add category if not present
          if (!config.category) {
            config.category = category;
          }
          
          this.agents.set(config.id, config);
          this.agentsByCategory.get(category)?.add(config.id);
          
          this.emit('agentLoaded', { agent: config });
          totalAgents++;
        } catch (error) {
          console.error(`Failed to load agent ${file}:`, error);
        }
      }
    }

    this.isInitialized = true;
    console.log(`✅ Loaded ${totalAgents} MCP-enhanced agents`);
    this.emit('agentsLoaded', { count: totalAgents });
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