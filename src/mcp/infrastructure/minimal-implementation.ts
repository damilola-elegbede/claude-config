/**
 * SPEC_01 Minimal Implementation
 * Demonstrates core MCP infrastructure functionality
 */

import { EventEmitter } from 'events';
import * as fs from 'fs';
import * as path from 'path';
import * as os from 'os';

// Minimal types
interface MCPServer {
  id: string;
  name: string;
  command: string;
  args?: string[];
  env?: Record<string, string>;
  status: 'healthy' | 'degraded' | 'failed';
  capabilities: string[];
  metrics: {
    responseTime: number;
    successRate: number;
    lastCheck: Date;
  };
}

interface RoutingDecision {
  serverId: string;
  serverName: string;
  confidence: number;
  strategy: string;
  decisionTime: number;
}

/**
 * Minimal MCP Infrastructure implementation demonstrating SPEC_01 requirements
 */
export class MinimalMCPInfrastructure extends EventEmitter {
  private servers: Map<string, MCPServer> = new Map();
  private routingCache: Map<string, RoutingDecision> = new Map();
  private circuitBreakerStates: Map<string, 'closed' | 'open' | 'half-open'> = new Map();
  private isStarted = false;

  constructor(private config: any = {}) {
    super();
  }

  /**
   * Start infrastructure - SPEC_01: Discovery and Registration
   */
  async start(): Promise<void> {
    if (this.isStarted) return;

    console.log('🚀 Starting MCP Infrastructure...');

    // Discover servers from settings.json
    const discoveryStart = Date.now();
    await this.discoverServers();
    const discoveryTime = Date.now() - discoveryStart;

    // Verify sub-500ms discovery (SPEC_01 requirement)
    if (discoveryTime < 500) {
      console.log(`✅ Server discovery completed in ${discoveryTime}ms (<500ms target)`);
    } else {
      console.warn(`⚠️ Server discovery took ${discoveryTime}ms (>500ms target)`);
    }

    this.isStarted = true;
    this.emit('infrastructureStarted');

    // Start health monitoring
    this.startHealthMonitoring();

    console.log(`✅ MCP Infrastructure started with ${this.servers.size} servers`);
  }

  /**
   * Discover MCP servers - SPEC_01: Automatic detection
   */
  private async discoverServers(): Promise<void> {
    const settingsPath = this.config.settingsPath ||
      path.join(os.homedir(), '.claude', 'settings.json');

    try {
      // Read settings if exists
      if (fs.existsSync(settingsPath)) {
        const settings = JSON.parse(fs.readFileSync(settingsPath, 'utf-8'));

        if (settings.mcpServers) {
          for (const [name, config] of Object.entries(settings.mcpServers as any)) {
            const serverConfig = config as any;
            const server: MCPServer = {
              id: `mcp-${name}`,
              name,
              command: serverConfig.command,
              args: serverConfig.args,
              env: serverConfig.env,
              status: 'healthy',
              capabilities: this.getServerCapabilities(name),
              metrics: {
                responseTime: 50 + Math.random() * 100, // Simulated
                successRate: 0.95 + Math.random() * 0.05,
                lastCheck: new Date()
              }
            };

            this.servers.set(server.id, server);
            this.circuitBreakerStates.set(server.id, 'closed');
            this.emit('serverDiscovered', { server });
          }
        }
      }

      // Add demo servers if no config
      if (this.servers.size === 0) {
        this.addDemoServers();
      }
    } catch (error) {
      console.error('Discovery error:', error);
      this.addDemoServers(); // Fallback to demo
    }
  }

  /**
   * Get server capabilities - SPEC_01: Capability mapping
   */
  private getServerCapabilities(name: string): string[] {
    const capabilityMap: Record<string, string[]> = {
      'filesystem': ['Read', 'Write', 'Edit', 'LS', 'Glob'],
      'github': ['CreateRepo', 'GetRepo', 'ListIssues', 'CreatePR'],
      'shadcn-ui': ['AddComponent', 'ListComponents', 'UpdateComponent'],
      'spotify': ['PlayTrack', 'SearchTracks', 'GetPlaylists']
    };

    return capabilityMap[name] || ['Generic'];
  }

  /**
   * Add demo servers for testing
   */
  private addDemoServers(): void {
    const demoServers = ['filesystem', 'github', 'shadcn-ui'];

    for (const name of demoServers) {
      const server: MCPServer = {
        id: `mcp-${name}`,
        name,
        command: 'npx',
        args: [`@modelcontextprotocol/server-${name}`],
        status: 'healthy',
        capabilities: this.getServerCapabilities(name),
        metrics: {
          responseTime: 50 + Math.random() * 100,
          successRate: 0.95 + Math.random() * 0.05,
          lastCheck: new Date()
        }
      };

      this.servers.set(server.id, server);
      this.circuitBreakerStates.set(server.id, 'closed');
    }
  }

  /**
   * Route tool to best server - SPEC_01: Sub-100ms routing
   */
  async routeTool(toolName: string, agentId?: string): Promise<RoutingDecision> {
    const routingStart = Date.now();
    const cacheKey = `${toolName}:${agentId || 'default'}`;

    // Check cache first
    if (this.routingCache.has(cacheKey)) {
      const cached = this.routingCache.get(cacheKey)!;
      const age = Date.now() - cached.decisionTime;

      if (age < 30000) { // 30 second cache
        console.log(`✅ Cache hit for ${toolName} (${Date.now() - routingStart}ms)`);
        return cached;
      }
    }

    // Find best server
    let bestServer: MCPServer | null = null;
    let bestScore = -1;

    for (const server of this.servers.values()) {
      // Skip if circuit breaker is open
      if (this.circuitBreakerStates.get(server.id) === 'open') {
        continue;
      }

      // Check if server has capability
      if (!server.capabilities.some(cap =>
        cap.toLowerCase().includes(toolName.toLowerCase()) ||
        toolName.toLowerCase().includes(cap.toLowerCase())
      )) {
        continue;
      }

      // Calculate score (SPEC_01: Performance-based selection)
      const score = this.calculateServerScore(server);

      if (score > bestScore) {
        bestScore = score;
        bestServer = server;
      }
    }

    // Fallback to any healthy server
    if (!bestServer) {
      for (const server of this.servers.values()) {
        if (server.status === 'healthy' &&
            this.circuitBreakerStates.get(server.id) !== 'open') {
          bestServer = server;
          break;
        }
      }
    }

    if (!bestServer) {
      throw new Error(`No server available for tool: ${toolName}`);
    }

    const decision: RoutingDecision = {
      serverId: bestServer.id,
      serverName: bestServer.name,
      confidence: bestScore,
      strategy: 'performance-weighted',
      decisionTime: Date.now()
    };

    // Cache decision
    this.routingCache.set(cacheKey, decision);

    const routingTime = Date.now() - routingStart;

    // Verify sub-100ms routing (SPEC_01 requirement)
    if (routingTime < 100) {
      console.log(`✅ Routing decision for ${toolName} in ${routingTime}ms (<100ms target)`);
    } else {
      console.warn(`⚠️ Routing decision took ${routingTime}ms (>100ms target)`);
    }

    this.emit('routingDecision', decision);
    return decision;
  }

  /**
   * Calculate server score - SPEC_01: Performance-based preference
   */
  private calculateServerScore(server: MCPServer): number {
    let score = 0;

    // Performance score (lower response time is better)
    score += (200 - server.metrics.responseTime) / 200;

    // Reliability score
    score += server.metrics.successRate;

    // Status score
    if (server.status === 'healthy') score += 1;
    else if (server.status === 'degraded') score += 0.5;

    return score / 3; // Normalize
  }

  /**
   * Execute with circuit breaker - SPEC_01: Fault tolerance
   */
  async executeWithCircuitBreaker<T>(
    serverId: string,
    operation: () => Promise<T>
  ): Promise<T> {
    const state = this.circuitBreakerStates.get(serverId);

    if (state === 'open') {
      throw new Error(`Circuit breaker open for server: ${serverId}`);
    }

    try {
      const result = await operation();

      // Record success
      if (state === 'half-open') {
        this.circuitBreakerStates.set(serverId, 'closed');
        console.log(`✅ Circuit breaker closed for ${serverId}`);
      }

      return result;
    } catch (error) {
      // Record failure
      this.recordFailure(serverId);
      throw error;
    }
  }

  /**
   * Record failure for circuit breaker - SPEC_01: Automatic failure detection
   */
  private recordFailure(serverId: string): void {
    // Simple circuit breaker: open after 3 failures
    const server = this.servers.get(serverId);
    if (server) {
      server.metrics.successRate *= 0.9; // Decay success rate

      if (server.metrics.successRate < 0.7) {
        this.circuitBreakerStates.set(serverId, 'open');
        console.warn(`⚠️ Circuit breaker opened for ${serverId}`);

        // Schedule half-open attempt
        setTimeout(() => {
          this.circuitBreakerStates.set(serverId, 'half-open');
          console.log(`🔄 Circuit breaker half-open for ${serverId}`);
        }, 30000); // 30 second recovery
      }
    }
  }

  /**
   * Execute with fallback - SPEC_01: Fallback patterns
   */
  async executeWithFallback<T>(
    primaryServerId: string,
    operation: (serverId: string) => Promise<T>
  ): Promise<T> {
    const fallbackStart = Date.now();

    try {
      // Try primary server
      return await this.executeWithCircuitBreaker(
        primaryServerId,
        () => operation(primaryServerId)
      );
    } catch (primaryError) {
      console.warn(`Primary server ${primaryServerId} failed, trying fallback...`);

      // Find fallback server
      for (const [serverId, server] of this.servers.entries()) {
        if (serverId === primaryServerId) continue;
        if (server.status !== 'healthy') continue;
        if (this.circuitBreakerStates.get(serverId) === 'open') continue;

        try {
          const result = await operation(serverId);

          const fallbackTime = Date.now() - fallbackStart;

          // Verify sub-200ms fallback (SPEC_01 requirement)
          if (fallbackTime < 200) {
            console.log(`✅ Fallback completed in ${fallbackTime}ms (<200ms target)`);
          } else {
            console.warn(`⚠️ Fallback took ${fallbackTime}ms (>200ms target)`);
          }

          return result;
        } catch (fallbackError) {
          continue; // Try next server
        }
      }

      throw primaryError; // All fallbacks failed
    }
  }

  /**
   * Start health monitoring - SPEC_01: Real-time health monitoring
   */
  private startHealthMonitoring(): void {
    setInterval(() => {
      for (const server of this.servers.values()) {
        // Simulate health check
        const isHealthy = Math.random() > 0.05; // 95% healthy

        const oldStatus = server.status;
        server.status = isHealthy ? 'healthy' : 'degraded';
        server.metrics.lastCheck = new Date();

        if (oldStatus !== server.status) {
          this.emit('serverStatusChanged', { server, oldStatus });
        }
      }
    }, this.config.healthCheckInterval || 10000); // 10 second default
  }

  /**
   * Get infrastructure status
   */
  getStatus(): any {
    return {
      started: this.isStarted,
      servers: Array.from(this.servers.values()).map(s => ({
        id: s.id,
        name: s.name,
        status: s.status,
        circuitBreaker: this.circuitBreakerStates.get(s.id),
        metrics: s.metrics
      })),
      cacheSize: this.routingCache.size
    };
  }

  /**
   * Stop infrastructure
   */
  async stop(): Promise<void> {
    this.isStarted = false;
    this.servers.clear();
    this.routingCache.clear();
    this.circuitBreakerStates.clear();
    this.removeAllListeners();
    console.log('✅ MCP Infrastructure stopped');
  }
}

// Export for testing
export default MinimalMCPInfrastructure;
