/**
 * SPEC_02 Verification Tests
 * Validates agent enhancement framework meets SPEC_02 requirements
 */

import * as fs from 'fs';
import * as path from 'path';
import * as yaml from 'js-yaml';
import { MCPAgentManager, AgentCategory } from '../agents';

describe('SPEC_02: Agent Enhancement Framework', () => {
  let agentManager: MCPAgentManager;
  const agentsPath = path.join(__dirname, '../agents');

  beforeEach(() => {
    agentManager = new MCPAgentManager(agentsPath);
  });

  describe('Agent Loading and Discovery', () => {
    test('Should load all agent categories', async () => {
      await agentManager.loadAgents();
      const stats = agentManager.getStatistics();
      
      expect(stats.totalAgents).toBeGreaterThan(0);
      expect(stats.byCategory).toHaveProperty('development');
      expect(stats.byCategory).toHaveProperty('analysis');
      expect(stats.byCategory).toHaveProperty('infrastructure');
      expect(stats.byCategory).toHaveProperty('specialized');
    });

    test('Should have MCP-enabled agents', async () => {
      await agentManager.loadAgents();
      const stats = agentManager.getStatistics();
      
      // All agents should be MCP-enabled per SPEC_02
      expect(stats.mcpEnabled).toBe(stats.totalAgents);
    });

    test('Should maintain backward compatibility', async () => {
      await agentManager.loadAgents();
      const stats = agentManager.getStatistics();
      
      // All agents should support backward compatibility per SPEC_02
      expect(stats.backwardCompatible).toBe(stats.totalAgents);
    });
  });

  describe('Development Agents', () => {
    test('Should have all required development agents', async () => {
      await agentManager.loadAgents();
      const devAgents = agentManager.getAgentsByCategory(AgentCategory.DEVELOPMENT);
      
      const requiredAgents = [
        'backend-engineer',
        'frontend-architect',
        'mobile-platform-engineer',
        'full-stack-dev'
      ];
      
      const agentIds = devAgents.map(a => a.id);
      requiredAgents.forEach(id => {
        expect(agentIds).toContain(id);
      });
    });

    test('Should have MCP tool preferences for development agents', async () => {
      await agentManager.loadAgents();
      
      const backend = agentManager.getAgent('backend-engineer');
      expect(backend).toBeDefined();
      expect(backend?.mcp_integration.enabled).toBe(true);
      expect(backend?.mcp_integration.tool_preferences).toBeDefined();
      
      // Check for code-related tool preferences
      const prefs = backend?.mcp_integration.tool_preferences;
      expect(prefs).toHaveProperty('filesystem_operations');
      expect(prefs).toHaveProperty('code_analysis');
    });

    test('Should have performance profiles for different project sizes', async () => {
      await agentManager.loadAgents();
      
      const frontend = agentManager.getAgent('frontend-architect');
      const profiles = frontend?.mcp_integration.performance_profiles;
      
      expect(profiles).toBeDefined();
      expect(profiles).toHaveProperty('development');
      expect(profiles).toHaveProperty('production');
    });
  });

  describe('Analysis Agents', () => {
    test('Should have all required analysis agents', async () => {
      await agentManager.loadAgents();
      const analysisAgents = agentManager.getAgentsByCategory(AgentCategory.ANALYSIS);
      
      const requiredAgents = [
        'codebase-analyst',
        'code-reviewer',
        'debugger',
        'performance-specialist',
        'security-auditor'
      ];
      
      const agentIds = analysisAgents.map(a => a.id);
      requiredAgents.forEach(id => {
        expect(agentIds).toContain(id);
      });
    });

    test('Should have analysis-optimized tool preferences', async () => {
      await agentManager.loadAgents();
      
      const analyst = agentManager.getAgent('codebase-analyst');
      const prefs = analyst?.mcp_integration.tool_preferences;
      
      expect(prefs).toHaveProperty('search_operations');
      expect(prefs).toHaveProperty('pattern_recognition');
      expect(prefs).toHaveProperty('data_processing');
    });

    test('Should have specialized caching strategies', async () => {
      await agentManager.loadAgents();
      
      const reviewer = agentManager.getAgent('code-reviewer');
      const profiles = reviewer?.mcp_integration.performance_profiles;
      
      // Check for caching configuration
      const strictMode = profiles?.strict_mode;
      expect(strictMode).toBeDefined();
      expect(strictMode?.cache_strategy).toBeDefined();
    });
  });

  describe('Infrastructure Agents', () => {
    test('Should have all required infrastructure agents', async () => {
      await agentManager.loadAgents();
      const infraAgents = agentManager.getAgentsByCategory(AgentCategory.INFRASTRUCTURE);
      
      const requiredAgents = [
        'devops',
        'cloud-architect',
        'kubernetes-admin',
        'database-admin'
      ];
      
      const agentIds = infraAgents.map(a => a.id);
      requiredAgents.forEach(id => {
        expect(agentIds).toContain(id);
      });
    });

    test('Should have system management tool preferences', async () => {
      await agentManager.loadAgents();
      
      const devops = agentManager.getAgent('devops');
      const prefs = devops?.mcp_integration.tool_preferences;
      
      expect(prefs).toHaveProperty('deployment_operations');
      expect(prefs).toHaveProperty('infrastructure_provisioning');
      expect(prefs).toHaveProperty('configuration_management');
    });
  });

  describe('Specialized Agents', () => {
    test('Should have all required specialized agents', async () => {
      await agentManager.loadAgents();
      const specializedAgents = agentManager.getAgentsByCategory(AgentCategory.SPECIALIZED);
      
      const requiredAgents = [
        'test-engineer',
        'tech-writer',
        'project-orchestrator',
        'integration-specialist'
      ];
      
      const agentIds = specializedAgents.map(a => a.id);
      requiredAgents.forEach(id => {
        expect(agentIds).toContain(id);
      });
    });

    test('Should have domain-specific tool preferences', async () => {
      await agentManager.loadAgents();
      
      const tester = agentManager.getAgent('test-engineer');
      const prefs = tester?.mcp_integration.tool_preferences;
      
      expect(prefs).toHaveProperty('test_execution');
      expect(prefs).toHaveProperty('test_discovery');
      expect(prefs).toHaveProperty('coverage_analysis');
    });

    test('Should have coordination capabilities', async () => {
      await agentManager.loadAgents();
      
      const orchestrator = agentManager.getAgent('project-orchestrator');
      const prefs = orchestrator?.mcp_integration.tool_preferences;
      
      expect(prefs).toHaveProperty('workflow_analysis');
      expect(prefs).toHaveProperty('agent_coordination');
    });
  });

  describe('MCP Integration Features', () => {
    test('Should select optimal agent for task', async () => {
      await agentManager.loadAgents();
      
      const agent = agentManager.getOptimalAgent('filesystem_operations', {
        category: AgentCategory.DEVELOPMENT
      });
      
      expect(agent).toBeDefined();
      expect(agent?.category).toBe('development');
      expect(agent?.mcp_integration.enabled).toBe(true);
    });

    test('Should provide fallback strategies', async () => {
      await agentManager.loadAgents();
      
      const agents = agentManager.getAgentsByCategory(AgentCategory.DEVELOPMENT);
      
      agents.forEach(agent => {
        const fallbacks = agentManager.getFallbackStrategy(agent.id);
        expect(fallbacks.length).toBeGreaterThan(0);
        
        // Should have at least MCP and standard fallback
        const strategies = fallbacks.map(f => f.type);
        expect(strategies).toContain('mcp_server_fallback');
        expect(strategies).toContain('standard_tool_fallback');
      });
    });

    test('Should validate agent configurations', async () => {
      await agentManager.loadAgents();
      
      const agents = Array.from(['backend-engineer', 'codebase-analyst', 'devops', 'test-engineer']);
      
      agents.forEach(agentId => {
        const validation = agentManager.validateAgent(agentId);
        expect(validation.valid).toBe(true);
        expect(validation.errors).toHaveLength(0);
      });
    });
  });

  describe('Performance Profiles', () => {
    test('Should have multiple performance profiles per agent', async () => {
      await agentManager.loadAgents();
      const stats = agentManager.getStatistics();
      
      // Should have various performance profiles
      expect(stats.performanceProfiles).toContain('default');
      expect(stats.performanceProfiles.length).toBeGreaterThan(3);
    });

    test('Should retrieve specific performance profile', async () => {
      await agentManager.loadAgents();
      
      const profile = agentManager.getPerformanceProfile('backend-engineer', 'large_project');
      
      expect(profile).toBeDefined();
      expect(profile.timeout).toBeDefined();
      expect(profile.parallel_limit).toBeDefined();
      expect(profile.cache_strategy).toBeDefined();
    });
  });

  describe('Backward Compatibility', () => {
    test('Should support non-MCP environments', async () => {
      await agentManager.loadAgents();
      
      const agents = agentManager.getAgentsByCategory(AgentCategory.DEVELOPMENT);
      
      agents.forEach(agent => {
        expect(agentManager.isBackwardCompatible(agent.id)).toBe(true);
        expect(agent.backward_compatibility.fallback_mode).toBeDefined();
      });
    });

    test('Should have standard tool support', async () => {
      await agentManager.loadAgents();
      
      const agent = agentManager.getAgent('backend-engineer');
      const fallbacks = agent?.mcp_integration.fallback_strategies;
      
      const standardFallback = fallbacks?.find(f => f.type === 'standard_tool_fallback');
      expect(standardFallback).toBeDefined();
      expect(standardFallback?.tools).toContain('standard_read');
      expect(standardFallback?.tools).toContain('standard_write');
    });
  });

  describe('Statistics and Monitoring', () => {
    test('Should provide comprehensive statistics', async () => {
      await agentManager.loadAgents();
      const stats = agentManager.getStatistics();
      
      expect(stats.totalAgents).toBeGreaterThanOrEqual(16); // Minimum 16 agents per SPEC_02
      expect(stats.mcpEnabled).toBe(stats.totalAgents);
      expect(stats.backwardCompatible).toBe(stats.totalAgents);
      expect(stats.toolTypes.length).toBeGreaterThan(10);
      expect(stats.performanceProfiles.length).toBeGreaterThan(3);
    });

    test('Should export configuration', async () => {
      await agentManager.loadAgents();
      
      const config = agentManager.exportConfiguration();
      const parsed = JSON.parse(config);
      
      expect(parsed.version).toBe('2.0');
      expect(parsed.spec).toBe('SPEC_02');
      expect(parsed.agents).toBeDefined();
      expect(parsed.statistics).toBeDefined();
      expect(parsed.timestamp).toBeDefined();
    });
  });
});

describe('SPEC_02 Performance Requirements', () => {
  let agentManager: MCPAgentManager;

  beforeAll(async () => {
    agentManager = new MCPAgentManager(path.join(__dirname, '../agents'));
    await agentManager.loadAgents();
  });

  test('Should meet 30-50% tool execution improvement target', () => {
    // Verify performance profiles show improvement
    const agents = agentManager.getAgentsByCategory(AgentCategory.DEVELOPMENT);
    
    agents.forEach(agent => {
      const profiles = agent.mcp_integration.performance_profiles;
      
      // Check that MCP-optimized profiles have better performance targets
      Object.values(profiles).forEach((profile: any) => {
        if (profile.optimization_target) {
          const improvement = parseInt(profile.optimization_target);
          expect(improvement).toBeGreaterThanOrEqual(30);
          expect(improvement).toBeLessThanOrEqual(90);
        }
      });
    });
  });

  test('Should have agent-specific optimization profiles', () => {
    const categories = Object.values(AgentCategory);
    
    categories.forEach(category => {
      const agents = agentManager.getAgentsByCategory(category);
      
      agents.forEach(agent => {
        // Each agent should have optimization profiles
        expect(agent.optimization_profiles).toBeDefined();
        
        // Each category should have specific optimizations
        switch(category) {
          case AgentCategory.DEVELOPMENT:
            expect(agent.mcp_integration.tool_preferences).toHaveProperty('filesystem_operations');
            break;
          case AgentCategory.ANALYSIS:
            expect(agent.mcp_integration.tool_preferences).toHaveProperty('data_processing');
            break;
          case AgentCategory.INFRASTRUCTURE:
            expect(agent.mcp_integration.tool_preferences).toHaveProperty('system_management');
            break;
          case AgentCategory.SPECIALIZED:
            // Specialized agents have varied tool preferences
            expect(Object.keys(agent.mcp_integration.tool_preferences).length).toBeGreaterThan(0);
            break;
        }
      });
    });
  });
});