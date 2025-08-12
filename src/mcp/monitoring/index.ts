/**
 * SPEC_05: Performance Monitoring and Analytics System
 * Main entry point for the comprehensive monitoring system
 */

import { EventEmitter } from 'events';
import { createServer } from 'http';
import { WebSocketServer, WebSocket } from 'ws';
import { 
  DashboardServer, 
  defaultDashboardConfig, 
  DashboardConfig,
  PerformanceMetrics,
  Alert
} from './performance-dashboard';
import { 
  BenchmarkEngine, 
  defaultBenchmarkConfig, 
  BenchmarkConfig,
  BenchmarkRun
} from './benchmarking-framework';
import { 
  AnalyticsEngine, 
  defaultAnalyticsConfig, 
  AnalyticsConfig,
  AnalyticsResult,
  Recommendation
} from './analytics-engine';
import {
  ComprehensiveReportingSystem,
  createReportingSystem,
  ExecutiveKPIs,
  ROIMetrics,
  TrendAnalysis,
  ReportConfig,
  GeneratedReport
} from './reporting-system';

// System Configuration
export interface MonitoringSystemConfig {
  dashboard: Partial<DashboardConfig>;
  benchmarking: Partial<BenchmarkConfig>;
  analytics: Partial<AnalyticsConfig>;
  reporting: {
    enabled: boolean;
    autoGenerateReports: boolean;
    executiveDashboard: boolean;
    roiTracking: boolean;
    exportFormats: ('json' | 'html' | 'pdf' | 'csv' | 'xlsx')[];
  };
  server: {
    port: number;
    host: string;
    enableCORS: boolean;
  };
  integrations: {
    webhooks: WebhookConfig[];
    notifications: NotificationConfig;
  };
}

export interface WebhookConfig {
  id: string;
  url: string;
  events: MonitoringEvent[];
  authentication?: {
    type: 'bearer' | 'api-key';
    token: string;
  };
  enabled: boolean;
}

export interface NotificationConfig {
  slack: {
    enabled: boolean;
    webhookUrl?: string;
    channels: {
      alerts: string;
      reports: string;
      maintenance: string;
    };
  };
  email: {
    enabled: boolean;
    smtpConfig?: {
      host: string;
      port: number;
      auth: { user: string; pass: string };
    };
    recipients: {
      alerts: string[];
      reports: string[];
      critical: string[];
    };
  };
}

export type MonitoringEvent = 
  | 'performance-alert'
  | 'benchmark-completed'
  | 'regression-detected'
  | 'analytics-insight'
  | 'optimization-recommendation'
  | 'system-status-change';

// System Status
export interface SystemStatus {
  status: 'healthy' | 'degraded' | 'critical' | 'maintenance';
  uptime: number;
  version: string;
  components: {
    dashboard: ComponentStatus;
    benchmarking: ComponentStatus;
    analytics: ComponentStatus;
  };
  lastUpdated: number;
}

export interface ComponentStatus {
  status: 'running' | 'stopped' | 'error';
  lastUpdate: number;
  metrics: {
    memoryUsage: number;
    cpuUsage: number;
    errorCount: number;
  };
}

// Main Monitoring System
export class MonitoringSystem extends EventEmitter {
  private config: MonitoringSystemConfig;
  private dashboard: DashboardServer;
  private benchmarkEngine: BenchmarkEngine;
  private analyticsEngine: AnalyticsEngine;
  private reportingSystem: ComprehensiveReportingSystem | null = null;
  private httpServer: any;
  private wsServer: WebSocketServer | null = null;
  private systemStatus: SystemStatus;

  constructor(config: Partial<MonitoringSystemConfig> = {}) {
    super();
    
    this.config = this.mergeConfig(config);
    
    // Initialize components
    this.dashboard = new DashboardServer(this.config.dashboard as DashboardConfig);
    this.benchmarkEngine = new BenchmarkEngine(this.config.benchmarking as BenchmarkConfig);
    this.analyticsEngine = new AnalyticsEngine(this.config.analytics as AnalyticsConfig);
    
    // Initialize reporting system if enabled
    if (this.config.reporting.enabled) {
      this.reportingSystem = createReportingSystem(this.analyticsEngine, this.dashboard, this.config);
    }
    
    this.systemStatus = this.initializeSystemStatus();
    
    this.setupEventHandlers();
    this.createHttpServer();
  }

  private mergeConfig(config: Partial<MonitoringSystemConfig>): MonitoringSystemConfig {
    return {
      dashboard: { ...defaultDashboardConfig, ...config.dashboard },
      benchmarking: { ...defaultBenchmarkConfig, ...config.benchmarking },
      analytics: { ...defaultAnalyticsConfig, ...config.analytics },
      reporting: {
        enabled: true,
        autoGenerateReports: true,
        executiveDashboard: true,
        roiTracking: true,
        exportFormats: ['json', 'html', 'pdf', 'csv'],
        ...config.reporting
      },
      server: {
        port: 3001,
        host: '0.0.0.0',
        enableCORS: true,
        ...config.server
      },
      integrations: {
        webhooks: [],
        notifications: {
          slack: { enabled: false, channels: { alerts: '#alerts', reports: '#reports', maintenance: '#maintenance' } },
          email: { enabled: false, recipients: { alerts: [], reports: [], critical: [] } }
        },
        ...config.integrations
      }
    };
  }

  private initializeSystemStatus(): SystemStatus {
    const components: SystemStatus['components'] = {
      dashboard: { status: 'stopped', lastUpdate: Date.now(), metrics: { memoryUsage: 0, cpuUsage: 0, errorCount: 0 } },
      benchmarking: { status: 'stopped', lastUpdate: Date.now(), metrics: { memoryUsage: 0, cpuUsage: 0, errorCount: 0 } },
      analytics: { status: 'stopped', lastUpdate: Date.now(), metrics: { memoryUsage: 0, cpuUsage: 0, errorCount: 0 } }
    };

    // Add reporting component if enabled
    if (this.config.reporting.enabled) {
      (components as any).reporting = { 
        status: 'stopped', 
        lastUpdate: Date.now(), 
        metrics: { memoryUsage: 0, cpuUsage: 0, errorCount: 0 } 
      };
    }

    return {
      status: 'healthy',
      uptime: Date.now(),
      version: '1.0.0',
      components,
      lastUpdated: Date.now()
    };
  }

  private setupEventHandlers(): void {
    // Dashboard events
    this.dashboard.on('metricsUpdate', (metrics: PerformanceMetrics) => {
      this.emit('performance-metrics', metrics);
      this.updateComponentStatus('dashboard');
    });

    this.dashboard.on('newAlert', (alert: Alert) => {
      this.handleAlert(alert);
      this.emit('performance-alert', alert);
    });

    // Benchmark events
    this.benchmarkEngine.on('benchmarkCompleted', (run: BenchmarkRun) => {
      this.emit('benchmark-completed', run);
      this.updateComponentStatus('benchmarking');
    });

    this.benchmarkEngine.on('regressionDetected', (regression: any) => {
      this.handleRegression(regression);
      this.emit('regression-detected', regression);
    });

    this.benchmarkEngine.on('benchmarkFailed', (failure: any) => {
      console.error('Benchmark failed:', failure);
      this.updateComponentStatus('benchmarking', true);
    });

    // Analytics events
    this.analyticsEngine.on('analysisResult', (result: AnalyticsResult) => {
      this.handleAnalysisResult(result);
      this.emit('analytics-insight', result);
      this.updateComponentStatus('analytics');
    });

    // Reporting events
    if (this.reportingSystem) {
      this.reportingSystem.on('reportGenerated', (report: GeneratedReport) => {
        console.log(`Report generated: ${report.id}`);
        this.updateComponentStatus('reporting' as any);
        this.emit('report-generated', report);
      });

      this.reportingSystem.on('kpisUpdated', (kpis: ExecutiveKPIs) => {
        this.emit('kpis-updated', kpis);
      });

      this.reportingSystem.on('started', () => {
        this.updateComponentStatus('reporting' as any);
      });
    }
  }

  private createHttpServer(): void {
    this.httpServer = createServer((req, res) => {
      // Enable CORS
      if (this.config.server.enableCORS) {
        res.setHeader('Access-Control-Allow-Origin', '*');
        res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
        res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
        
        if (req.method === 'OPTIONS') {
          res.writeHead(204);
          res.end();
          return;
        }
      }

      const url = new URL(req.url!, `http://${req.headers.host}`);
      
      try {
        this.handleHttpRequest(req, res, url);
      } catch (error) {
        console.error('HTTP request error:', error);
        res.writeHead(500, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Internal server error' }));
      }
    });

    // Setup WebSocket server
    this.wsServer = new WebSocketServer({ server: this.httpServer });
    
    this.wsServer.on('connection', (ws: WebSocket, req) => {
      console.log('WebSocket client connected:', req.url);
      
      // Add client to dashboard for real-time updates
      this.dashboard.addWebSocketClient(ws);
      
      // Send initial system status
      ws.send(JSON.stringify({
        type: 'system-status',
        data: this.systemStatus,
        timestamp: Date.now()
      }));
    });
  }

  private async handleHttpRequest(req: any, res: any, url: URL): Promise<void> {
    const path = url.pathname;
    const method = req.method;
    
    res.setHeader('Content-Type', 'application/json');

    // API Routes
    if (path === '/api/status') {
      res.writeHead(200);
      res.end(JSON.stringify(this.getSystemStatus()));
    } 
    else if (path === '/api/metrics') {
      const snapshot = this.dashboard.getPerformanceSnapshot();
      res.writeHead(200);
      res.end(JSON.stringify(snapshot));
    }
    else if (path === '/api/metrics/history') {
      const timeRange = this.parseTimeRange(url.searchParams);
      const report = this.dashboard.getPerformanceReport(timeRange);
      res.writeHead(200);
      res.end(JSON.stringify(report));
    }
    else if (path === '/api/benchmarks' && method === 'GET') {
      const suiteId = url.searchParams.get('suite');
      if (suiteId) {
        const results = this.benchmarkEngine.getResults(suiteId);
        res.writeHead(200);
        res.end(JSON.stringify(results));
      } else {
        const allResults = this.benchmarkEngine.getAllResults();
        const serialized = Object.fromEntries(allResults);
        res.writeHead(200);
        res.end(JSON.stringify(serialized));
      }
    }
    else if (path === '/api/benchmarks/run' && method === 'POST') {
      const body = await this.readRequestBody(req);
      const { suiteId } = JSON.parse(body);
      
      try {
        const run = await this.benchmarkEngine.runBenchmark(suiteId);
        res.writeHead(200);
        res.end(JSON.stringify(run));
      } catch (error) {
        res.writeHead(400);
        res.end(JSON.stringify({ error: error instanceof Error ? error.message : String(error) }));
      }
    }
    else if (path === '/api/benchmarks/report') {
      const suiteId = url.searchParams.get('suite');
      const format = url.searchParams.get('format') as 'json' | 'html' | 'csv' || 'json';
      
      if (!suiteId) {
        res.writeHead(400);
        res.end(JSON.stringify({ error: 'Missing suite parameter' }));
        return;
      }
      
      try {
        const report = await this.benchmarkEngine.generateReport(suiteId, format);
        
        if (format === 'html') {
          res.setHeader('Content-Type', 'text/html');
        } else if (format === 'csv') {
          res.setHeader('Content-Type', 'text/csv');
        }
        
        res.writeHead(200);
        res.end(report);
      } catch (error) {
        res.writeHead(400);
        res.end(JSON.stringify({ error: error instanceof Error ? error.message : String(error) }));
      }
    }
    else if (path === '/api/analytics/insights') {
      const modelId = url.searchParams.get('model');
      const insights = this.analyticsEngine.getInsights(modelId || undefined);
      res.writeHead(200);
      res.end(JSON.stringify(insights));
    }
    else if (path === '/api/analytics/recommendations') {
      const category = url.searchParams.get('category') as any;
      const recommendations = this.analyticsEngine.getRecommendations(category);
      res.writeHead(200);
      res.end(JSON.stringify(recommendations));
    }
    else if (path === '/api/analytics/report') {
      const templateId = url.searchParams.get('template') || 'executive-summary';
      
      try {
        const report = await this.analyticsEngine.generateReport(templateId);
        
        if (templateId.includes('html')) {
          res.setHeader('Content-Type', 'text/html');
        }
        
        res.writeHead(200);
        res.end(report);
      } catch (error) {
        res.writeHead(400);
        res.end(JSON.stringify({ error: error instanceof Error ? error.message : String(error) }));
      }
    }
    // Reporting System API Endpoints
    else if (path === '/api/reporting/kpis' && this.reportingSystem) {
      const timeRange = this.parseTimeRange(url.searchParams);
      const kpis = this.reportingSystem.getKPIHistory(timeRange);
      res.writeHead(200);
      res.end(JSON.stringify(kpis));
    }
    else if (path === '/api/reporting/kpis/current' && this.reportingSystem) {
      try {
        const currentKPIs = await this.reportingSystem.getCurrentKPIs();
        res.writeHead(200);
        res.end(JSON.stringify(currentKPIs));
      } catch (error) {
        res.writeHead(500);
        res.end(JSON.stringify({ error: error instanceof Error ? error.message : String(error) }));
      }
    }
    else if (path === '/api/reporting/roi' && this.reportingSystem) {
      try {
        const roiAnalysis = await this.reportingSystem.getROIAnalysis();
        res.writeHead(200);
        res.end(JSON.stringify(roiAnalysis));
      } catch (error) {
        res.writeHead(500);
        res.end(JSON.stringify({ error: error instanceof Error ? error.message : String(error) }));
      }
    }
    else if (path === '/api/reporting/trends' && this.reportingSystem) {
      const timeRange = this.parseTimeRange(url.searchParams);
      try {
        const trends = await this.reportingSystem.getTrendAnalysis(timeRange);
        res.writeHead(200);
        res.end(JSON.stringify(trends));
      } catch (error) {
        res.writeHead(500);
        res.end(JSON.stringify({ error: error instanceof Error ? error.message : String(error) }));
      }
    }
    else if (path === '/api/reporting/generate' && method === 'POST' && this.reportingSystem) {
      const body = await this.readRequestBody(req);
      try {
        const { configId, timeRange, format, recipients } = JSON.parse(body);
        const report = await this.reportingSystem.generateReport(configId, { timeRange, format, recipients });
        res.writeHead(200);
        res.end(JSON.stringify(report));
      } catch (error) {
        res.writeHead(400);
        res.end(JSON.stringify({ error: error instanceof Error ? error.message : String(error) }));
      }
    }
    else if (path.startsWith('/api/reporting/export/') && this.reportingSystem) {
      const reportId = path.split('/').pop();
      const format = url.searchParams.get('format') || 'json';
      
      if (!reportId) {
        res.writeHead(400);
        res.end(JSON.stringify({ error: 'Report ID is required' }));
        return;
      }
      
      try {
        const exportedContent = await this.reportingSystem.exportReport(reportId, format as any);
        
        // Set appropriate content type
        const contentTypes = {
          json: 'application/json',
          html: 'text/html',
          pdf: 'application/pdf',
          csv: 'text/csv',
          xlsx: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        };
        
        res.setHeader('Content-Type', contentTypes[format as keyof typeof contentTypes] || 'application/octet-stream');
        
        // Set download headers for non-JSON formats
        if (format !== 'json' && format !== 'html') {
          res.setHeader('Content-Disposition', `attachment; filename="report-${reportId}.${format}"`);
        }
        
        res.writeHead(200);
        res.end(exportedContent);
      } catch (error) {
        res.writeHead(404);
        res.end(JSON.stringify({ error: error instanceof Error ? error.message : String(error) }));
      }
    }
    else if (path === '/api/reporting/reports' && this.reportingSystem) {
      const reports = this.reportingSystem.getAvailableReports();
      res.writeHead(200);
      res.end(JSON.stringify(reports));
    }
    else if (path === '/api/health') {
      // Health check endpoint
      const health = {
        status: this.systemStatus.status,
        timestamp: Date.now(),
        uptime: Date.now() - this.systemStatus.uptime,
        components: Object.entries(this.systemStatus.components).map(([name, component]) => ({
          name,
          status: component.status,
          healthy: component.status === 'running'
        }))
      };
      
      res.writeHead(200);
      res.end(JSON.stringify(health));
    }
    else {
      // 404 Not Found
      res.writeHead(404);
      res.end(JSON.stringify({ error: 'Not Found' }));
    }
  }

  private parseTimeRange(params: URLSearchParams): { start: number; end: number } {
    const start = params.get('start');
    const end = params.get('end');
    const duration = params.get('duration') || '24h';
    
    const now = Date.now();
    
    if (start && end) {
      return {
        start: parseInt(start),
        end: parseInt(end)
      };
    }
    
    // Parse duration (e.g., '24h', '7d', '30m')
    const durationMs = this.parseDuration(duration);
    
    return {
      start: now - durationMs,
      end: now
    };
  }

  private parseDuration(duration: string): number {
    const match = duration.match(/^(\d+)([smhd])$/);
    if (!match) return 24 * 60 * 60 * 1000; // Default 24 hours
    
    const value = parseInt(match[1]);
    const unit = match[2];
    
    switch (unit) {
      case 's': return value * 1000;
      case 'm': return value * 60 * 1000;
      case 'h': return value * 60 * 60 * 1000;
      case 'd': return value * 24 * 60 * 60 * 1000;
      default: return 24 * 60 * 60 * 1000;
    }
  }

  private async readRequestBody(req: any): Promise<string> {
    return new Promise((resolve, reject) => {
      let body = '';
      req.on('data', (chunk: any) => {
        body += chunk.toString();
      });
      req.on('end', () => {
        resolve(body);
      });
      req.on('error', reject);
    });
  }

  private async handleAlert(alert: Alert): Promise<void> {
    console.log(`Alert: ${alert.severity} - ${alert.message}`);
    
    // Send webhooks
    await this.sendWebhooks('performance-alert', { alert });
    
    // Update system status if critical
    if (alert.severity === 'critical' || alert.severity === 'emergency') {
      this.updateSystemStatus('critical');
    }
  }

  private async handleRegression(regression: any): Promise<void> {
    console.log(`Performance regression detected:`, regression);
    
    // Send webhooks
    await this.sendWebhooks('regression-detected', { regression });
    
    // Notify critical channels
    await this.sendCriticalNotification(`Performance regression detected in ${regression.suite}`, regression);
    
    this.updateSystemStatus('degraded');
  }

  private async handleAnalysisResult(result: AnalyticsResult): Promise<void> {
    console.log(`Analytics result: ${result.type} - ${result.insights.length} insights, ${result.recommendations.length} recommendations`);
    
    // Send webhooks for insights and recommendations
    if (result.insights.length > 0) {
      await this.sendWebhooks('analytics-insight', { result });
    }
    
    if (result.recommendations.length > 0) {
      await this.sendWebhooks('optimization-recommendation', { 
        recommendations: result.recommendations 
      });
    }
  }

  private async sendWebhooks(event: MonitoringEvent, data: any): Promise<void> {
    const relevantWebhooks = this.config.integrations.webhooks.filter(
      wh => wh.enabled && wh.events.includes(event)
    );
    
    for (const webhook of relevantWebhooks) {
      try {
        const headers: Record<string, string> = { 'Content-Type': 'application/json' };
        
        if (webhook.authentication) {
          if (webhook.authentication.type === 'bearer') {
            headers['Authorization'] = `Bearer ${webhook.authentication.token}`;
          } else if (webhook.authentication.type === 'api-key') {
            headers['X-API-Key'] = webhook.authentication.token;
          }
        }
        
        const payload = {
          event,
          timestamp: Date.now(),
          system: 'mcp-monitoring',
          data
        };
        
        const response = await fetch(webhook.url, {
          method: 'POST',
          headers,
          body: JSON.stringify(payload)
        });
        
        if (!response.ok) {
          console.error(`Webhook ${webhook.id} failed:`, response.status, response.statusText);
        }
      } catch (error) {
        console.error(`Webhook ${webhook.id} error:`, error);
      }
    }
  }

  private async sendCriticalNotification(message: string, data: any): Promise<void> {
    // In production, this would integrate with actual notification services
    console.log(`CRITICAL NOTIFICATION: ${message}`, data);
  }

  private updateComponentStatus(component: keyof SystemStatus['components'], hasError: boolean = false): void {
    const componentStatus = this.systemStatus.components[component];
    componentStatus.status = hasError ? 'error' : 'running';
    componentStatus.lastUpdate = Date.now();
    componentStatus.metrics.errorCount += hasError ? 1 : 0;
    
    this.systemStatus.lastUpdated = Date.now();
    this.broadcastSystemStatus();
  }

  private updateSystemStatus(status: SystemStatus['status']): void {
    if (this.systemStatus.status !== status) {
      this.systemStatus.status = status;
      this.systemStatus.lastUpdated = Date.now();
      
      this.emit('system-status-change', { 
        oldStatus: this.systemStatus.status, 
        newStatus: status,
        timestamp: Date.now()
      });
      
      this.broadcastSystemStatus();
    }
  }

  private broadcastSystemStatus(): void {
    if (this.wsServer) {
      const message = JSON.stringify({
        type: 'system-status',
        data: this.systemStatus,
        timestamp: Date.now()
      });
      
      this.wsServer.clients.forEach((client) => {
        if (client.readyState === WebSocket.OPEN) {
          client.send(message);
        }
      });
    }
  }

  // Public API
  async start(): Promise<void> {
    console.log('Starting MCP Monitoring System...');
    
    try {
      // Start components
      this.dashboard.start();
      this.systemStatus.components.dashboard.status = 'running';
      
      await this.benchmarkEngine.start();
      this.systemStatus.components.benchmarking.status = 'running';
      
      await this.analyticsEngine.start();
      this.systemStatus.components.analytics.status = 'running';
      
      // Start reporting system if enabled
      if (this.reportingSystem) {
        await this.reportingSystem.start();
        (this.systemStatus.components as any).reporting.status = 'running';
        console.log('Comprehensive reporting system started');
      }
      
      // Start HTTP server
      await new Promise<void>((resolve, reject) => {
        this.httpServer.listen(this.config.server.port, this.config.server.host, (err: any) => {
          if (err) reject(err);
          else resolve();
        });
      });
      
      this.updateSystemStatus('healthy');
      
      console.log(`MCP Monitoring System started on ${this.config.server.host}:${this.config.server.port}`);
      console.log(`WebSocket endpoint: ws://${this.config.server.host}:${this.config.server.port}`);
      console.log(`Health check: http://${this.config.server.host}:${this.config.server.port}/api/health`);
      console.log(`Metrics API: http://${this.config.server.host}:${this.config.server.port}/api/metrics`);
      
      if (this.reportingSystem) {
        console.log(`Executive KPIs: http://${this.config.server.host}:${this.config.server.port}/api/reporting/kpis/current`);
        console.log(`ROI Analysis: http://${this.config.server.host}:${this.config.server.port}/api/reporting/roi`);
        console.log(`Trend Analysis: http://${this.config.server.host}:${this.config.server.port}/api/reporting/trends`);
        console.log(`Report Generation: POST http://${this.config.server.host}:${this.config.server.port}/api/reporting/generate`);
      }
      
      this.emit('started');
    } catch (error) {
      console.error('Failed to start monitoring system:', error);
      this.updateSystemStatus('critical');
      throw error;
    }
  }

  async stop(): Promise<void> {
    console.log('Stopping MCP Monitoring System...');
    
    this.updateSystemStatus('maintenance');
    
    // Stop components
    this.dashboard.stop();
    this.benchmarkEngine.stop();
    this.analyticsEngine.stop();
    
    if (this.reportingSystem) {
      this.reportingSystem.stop();
    }
    
    // Close WebSocket connections
    if (this.wsServer) {
      this.wsServer.clients.forEach((client) => {
        client.close();
      });
      this.wsServer.close();
    }
    
    // Close HTTP server
    await new Promise<void>((resolve) => {
      this.httpServer.close(() => {
        console.log('MCP Monitoring System stopped');
        resolve();
      });
    });
    
    this.emit('stopped');
  }

  getSystemStatus(): SystemStatus {
    return { ...this.systemStatus };
  }

  // Manual operations
  async runBenchmark(suiteId: string): Promise<BenchmarkRun> {
    return this.benchmarkEngine.runBenchmark(suiteId);
  }

  async generateReport(type: 'performance' | 'benchmark' | 'analytics', options: any = {}): Promise<string> {
    switch (type) {
      case 'performance':
        const timeRange = options.timeRange || {
          start: Date.now() - 24 * 60 * 60 * 1000,
          end: Date.now()
        };
        const report = this.dashboard.getPerformanceReport(timeRange);
        return JSON.stringify(report, null, 2);
      
      case 'benchmark':
        return this.benchmarkEngine.generateReport(options.suiteId, options.format || 'json');
      
      case 'analytics':
        return this.analyticsEngine.generateReport(options.templateId || 'executive-summary');
      
      default:
        throw new Error(`Unknown report type: ${type}`);
    }
  }

  getMetrics(): any {
    return this.dashboard.getPerformanceSnapshot();
  }

  getInsights(): any[] {
    return this.analyticsEngine.getInsights();
  }

  getRecommendations(): Recommendation[] {
    return this.analyticsEngine.getRecommendations();
  }

  // Reporting System Public API
  async getCurrentKPIs(): Promise<ExecutiveKPIs | null> {
    return this.reportingSystem ? await this.reportingSystem.getCurrentKPIs() : null;
  }

  getKPIHistory(timeRange?: { start: number; end: number }): ExecutiveKPIs[] {
    return this.reportingSystem ? this.reportingSystem.getKPIHistory(timeRange) : [];
  }

  async getROIAnalysis(): Promise<ROIMetrics | null> {
    return this.reportingSystem ? await this.reportingSystem.getROIAnalysis() : null;
  }

  async getTrendAnalysis(timeRange: { start: number; end: number }): Promise<TrendAnalysis[]> {
    return this.reportingSystem ? await this.reportingSystem.getTrendAnalysis(timeRange) : [];
  }

  async generateExecutiveReport(options: {
    timeRange?: { start: number; end: number };
    format?: string;
    recipients?: string[];
  } = {}): Promise<GeneratedReport | null> {
    return this.reportingSystem ? 
      await this.reportingSystem.generateReport('executive-dashboard', options) : 
      null;
  }

  async exportReport(reportId: string, format: 'json' | 'html' | 'pdf' | 'csv' | 'xlsx'): Promise<string | Buffer | null> {
    return this.reportingSystem ? 
      await this.reportingSystem.exportReport(reportId, format) : 
      null;
  }

  getAvailableReports(): GeneratedReport[] {
    return this.reportingSystem ? this.reportingSystem.getAvailableReports() : [];
  }
}

// Default system configuration
export const defaultMonitoringConfig: MonitoringSystemConfig = {
  dashboard: defaultDashboardConfig,
  benchmarking: defaultBenchmarkConfig,
  analytics: defaultAnalyticsConfig,
  reporting: {
    enabled: true,
    autoGenerateReports: true,
    executiveDashboard: true,
    roiTracking: true,
    exportFormats: ['json', 'html', 'pdf', 'csv']
  },
  server: {
    port: 3001,
    host: '0.0.0.0',
    enableCORS: true
  },
  integrations: {
    webhooks: [],
    notifications: {
      slack: {
        enabled: false,
        channels: {
          alerts: '#mcp-alerts',
          reports: '#mcp-reports',  
          maintenance: '#mcp-maintenance'
        }
      },
      email: {
        enabled: false,
        recipients: {
          alerts: [],
          reports: [],
          critical: []
        }
      }
    }
  }
};

// Factory function
export function createMonitoringSystem(config: Partial<MonitoringSystemConfig> = {}): MonitoringSystem {
  return new MonitoringSystem(config);
}

// Export all types and classes
export * from './performance-dashboard';
export * from './benchmarking-framework';
export * from './analytics-engine';
export * from './reporting-system';
export { MonitoringSystem as default };