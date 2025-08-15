/**
 * SPEC_05: Comprehensive Analytics and Reporting System
 * Executive dashboard with KPI tracking, ROI metrics, and automated report generation
 */

import { EventEmitter } from 'events';
import * as fs from 'fs/promises';
import * as path from 'path';
import { createWriteStream } from 'fs';
import {
  PerformanceMetrics,
  AnalyticsResult,
  Insight,
  Recommendation,
  OptimizationCategory,
  MonitoringSystemConfig
} from '../types';
import { AnalyticsEngine } from './analytics-engine';
import { DashboardServer } from './performance-dashboard';

// =============================================================================
// Executive Dashboard Types
// =============================================================================

/**
 * Executive KPI metrics for stakeholder reporting
 */
export interface ExecutiveKPIs {
  /** Timestamp of metrics collection */
  timestamp: number;
  /** Overall system performance score (0-100) */
  performanceScore: number;
  /** Workflow efficiency improvement percentage (target: 40-50%) */
  workflowEfficiencyImprovement: number;
  /** Code analysis time reduction percentage (target: 60%) */
  codeAnalysisImprovement: number;
  /** UI development time reduction percentage (target: 40%) */
  uiDevelopmentImprovement: number;
  /** System uptime percentage (target: 99.5%) */
  systemUptime: number;
  /** MCP server utilization percentage (target: 80%+) */
  mcpUtilization: number;
  /** Return on investment percentage */
  roiPercentage: number;
  /** Total cost savings in USD */
  costSavings: number;
  /** Developer productivity increase percentage */
  productivityIncrease: number;
  /** Time-to-market improvement percentage */
  timeToMarketImprovement: number;
}

/**
 * ROI calculation components
 */
export interface ROIMetrics {
  /** Initial investment in system implementation */
  initialInvestment: number;
  /** Monthly operational costs */
  operationalCosts: number;
  /** Monthly cost savings from efficiency gains */
  monthlySavings: number;
  /** Developer time saved per month (hours) */
  developerTimeSaved: number;
  /** Average developer hourly rate */
  developerHourlyRate: number;
  /** Infrastructure cost savings per month */
  infrastructureSavings: number;
  /** Quality improvement impact (reduced bug costs) */
  qualitySavings: number;
  /** Time to ROI breakeven in months */
  breakEvenMonths: number;
  /** Net present value of investment */
  netPresentValue: number;
  /** Internal rate of return percentage */
  internalRateOfReturn: number;
}

/**
 * Performance trend analysis data
 */
export interface TrendAnalysis {
  /** Metric name being analyzed */
  metricName: string;
  /** Time period for analysis */
  period: {
    start: number;
    end: number;
  };
  /** Statistical trend data */
  trend: {
    direction: 'increasing' | 'decreasing' | 'stable';
    slope: number;
    confidence: number;
    significance: 'low' | 'medium' | 'high';
  };
  /** Forecast for next period */
  forecast: {
    predicted: number;
    confidenceInterval: [number, number];
    horizon: number;
  };
  /** Achievement against targets */
  targetProgress: {
    target: number;
    current: number;
    achievement: number; // percentage
    onTrack: boolean;
  };
}

/**
 * Automated report configuration
 */
export interface ReportConfig {
  /** Report identifier */
  id: string;
  /** Report name */
  name: string;
  /** Report type */
  type: 'executive' | 'performance' | 'roi' | 'technical' | 'stakeholder';
  /** Report template */
  template: ReportTemplate;
  /** Generation schedule */
  schedule: {
    frequency: 'realtime' | 'hourly' | 'daily' | 'weekly' | 'monthly' | 'quarterly';
    timezone: string;
    recipients: ReportRecipient[];
  };
  /** Report delivery options */
  delivery: {
    email: boolean;
    slack: boolean;
    webhook: boolean;
    storage: boolean;
  };
  /** Export formats */
  formats: ('json' | 'html' | 'pdf' | 'csv' | 'xlsx')[];
  /** Active status */
  enabled: boolean;
}

/**
 * Report recipient configuration
 */
export interface ReportRecipient {
  /** Recipient identifier */
  id: string;
  /** Display name */
  name: string;
  /** Email address */
  email?: string;
  /** Slack user ID or channel */
  slack?: string;
  /** Webhook URL for custom delivery */
  webhook?: string;
  /** Role-based permissions */
  role: 'executive' | 'manager' | 'developer' | 'stakeholder';
  /** Preferred delivery method */
  preferredDelivery: 'email' | 'slack' | 'webhook';
}

/**
 * Report template structure
 */
export interface ReportTemplate {
  /** Template identifier */
  id: string;
  /** Template name */
  name: string;
  /** Template description */
  description: string;
  /** Template sections */
  sections: ReportSection[];
  /** Styling configuration */
  styling: {
    theme: 'corporate' | 'modern' | 'minimal' | 'dark';
    primaryColor: string;
    logoUrl?: string;
    customCSS?: string;
  };
  /** Localization settings */
  localization: {
    locale: string;
    currency: string;
    timezone: string;
  };
}

/**
 * Report section definition
 */
export interface ReportSection {
  /** Section identifier */
  id: string;
  /** Section title */
  title: string;
  /** Section type */
  type: 'kpi' | 'chart' | 'table' | 'insights' | 'recommendations' | 'roi' | 'trends' | 'custom';
  /** Section configuration */
  config: {
    /** Metrics to include */
    metrics?: string[];
    /** Chart configuration */
    chart?: ChartConfig;
    /** Table configuration */
    table?: TableConfig;
    /** Time range for data */
    timeRange?: string;
    /** Custom rendering options */
    customOptions?: Record<string, any>;
  };
  /** Section priority for ordering */
  priority: number;
  /** Section visibility conditions */
  visibility?: {
    roles: string[];
    conditions?: Record<string, any>;
  };
}

/**
 * Chart configuration
 */
export interface ChartConfig {
  /** Chart type */
  type: 'line' | 'bar' | 'pie' | 'gauge' | 'heatmap' | 'scatter';
  /** Chart dimensions */
  dimensions: { width: number; height: number };
  /** Data aggregation method */
  aggregation: 'avg' | 'sum' | 'min' | 'max' | 'count';
  /** Chart styling */
  styling: {
    colors: string[];
    legend: boolean;
    gridLines: boolean;
    animations: boolean;
  };
}

/**
 * Table configuration
 */
export interface TableConfig {
  /** Columns to display */
  columns: TableColumn[];
  /** Sorting configuration */
  sorting: {
    column: string;
    direction: 'asc' | 'desc';
  };
  /** Pagination settings */
  pagination: {
    pageSize: number;
    showPagination: boolean;
  };
  /** Styling options */
  styling: {
    striped: boolean;
    bordered: boolean;
    hover: boolean;
  };
}

/**
 * Table column definition
 */
export interface TableColumn {
  /** Column key */
  key: string;
  /** Column title */
  title: string;
  /** Column type */
  type: 'string' | 'number' | 'date' | 'currency' | 'percentage' | 'boolean';
  /** Column formatting */
  format?: {
    decimals?: number;
    currency?: string;
    dateFormat?: string;
  };
  /** Column width */
  width?: string;
  /** Sort capability */
  sortable: boolean;
}

/**
 * Generated report instance
 */
export interface GeneratedReport {
  /** Report instance ID */
  id: string;
  /** Report configuration ID */
  configId: string;
  /** Generation timestamp */
  generatedAt: number;
  /** Report data */
  data: {
    kpis: ExecutiveKPIs;
    trends: TrendAnalysis[];
    insights: Insight[];
    recommendations: Recommendation[];
    roi: ROIMetrics;
    customSections: Record<string, any>;
  };
  /** Report metadata */
  metadata: {
    generationTime: number;
    dataPoints: number;
    coverage: {
      start: number;
      end: number;
    };
    version: string;
  };
  /** Delivery status */
  delivery: {
    status: 'pending' | 'delivered' | 'failed' | 'partial';
    attempts: number;
    lastAttempt: number;
    recipients: {
      id: string;
      status: 'pending' | 'delivered' | 'failed';
      deliveredAt?: number;
      error?: string;
    }[];
  };
}

// =============================================================================
// Comprehensive Reporting System
// =============================================================================

/**
 * Advanced reporting system with executive dashboard, automated reports,
 * and comprehensive analytics for MCP optimization platform
 */
export class ComprehensiveReportingSystem extends EventEmitter {
  private analyticsEngine: AnalyticsEngine;
  private dashboardServer: DashboardServer;
  private reportConfigs: Map<string, ReportConfig> = new Map();
  private generatedReports: Map<string, GeneratedReport> = new Map();
  private scheduledJobs: Map<string, NodeJS.Timeout> = new Map();

  // KPI tracking
  private kpiHistory: ExecutiveKPIs[] = [];
  private roiCalculator: ROICalculator;
  private trendAnalyzer: TrendAnalyzer;

  // Export capabilities
  private exportHandlers: Map<string, ExportHandler> = new Map();

  // PRD validation targets
  private readonly PRD_TARGETS = {
    codeAnalysisImprovement: 60, // 60% improvement target
    uiDevelopmentImprovement: 40, // 40% improvement target
    workflowEfficiency: 45, // 40-50% efficiency target
    systemUptime: 99.5, // 99.5% uptime target
    mcpUtilization: 80, // 80%+ utilization target
    responseTime: 300, // <400ms target
    cacheHitRate: 90 // >90% cache hit rate
  };

  constructor(
    analyticsEngine: AnalyticsEngine,
    dashboardServer: DashboardServer,
    config: Partial<MonitoringSystemConfig> = {}
  ) {
    super();

    this.analyticsEngine = analyticsEngine;
    this.dashboardServer = dashboardServer;
    this.roiCalculator = new ROICalculator();
    this.trendAnalyzer = new TrendAnalyzer();

    this.initializeExportHandlers();
    this.loadDefaultReportConfigs();
    this.setupEventHandlers();
  }

  /**
   * Initialize export handlers for different formats
   */
  private initializeExportHandlers(): void {
    this.exportHandlers.set('json', new JSONExportHandler());
    this.exportHandlers.set('html', new HTMLExportHandler());
    this.exportHandlers.set('pdf', new PDFExportHandler());
    this.exportHandlers.set('csv', new CSVExportHandler());
    this.exportHandlers.set('xlsx', new ExcelExportHandler());
  }

  /**
   * Load default report configurations
   */
  private loadDefaultReportConfigs(): void {
    const defaultConfigs: ReportConfig[] = [
      {
        id: 'executive-dashboard',
        name: 'Executive Performance Dashboard',
        type: 'executive',
        template: this.createExecutiveTemplate(),
        schedule: {
          frequency: 'daily',
          timezone: 'UTC',
          recipients: [
            {
              id: 'exec-1',
              name: 'Executive Team',
              email: 'executives@company.com',
              role: 'executive',
              preferredDelivery: 'email'
            }
          ]
        },
        delivery: {
          email: true,
          slack: true,
          webhook: false,
          storage: true
        },
        formats: ['html', 'pdf', 'json'],
        enabled: true
      },
      {
        id: 'roi-analysis',
        name: 'ROI and Cost Analysis Report',
        type: 'roi',
        template: this.createROITemplate(),
        schedule: {
          frequency: 'weekly',
          timezone: 'UTC',
          recipients: [
            {
              id: 'finance-1',
              name: 'Finance Team',
              email: 'finance@company.com',
              role: 'stakeholder',
              preferredDelivery: 'email'
            }
          ]
        },
        delivery: {
          email: true,
          slack: false,
          webhook: false,
          storage: true
        },
        formats: ['html', 'xlsx', 'json'],
        enabled: true
      },
      {
        id: 'technical-performance',
        name: 'Technical Performance Report',
        type: 'technical',
        template: this.createTechnicalTemplate(),
        schedule: {
          frequency: 'daily',
          timezone: 'UTC',
          recipients: [
            {
              id: 'dev-1',
              name: 'Development Team',
              email: 'developers@company.com',
              role: 'developer',
              preferredDelivery: 'slack'
            }
          ]
        },
        delivery: {
          email: false,
          slack: true,
          webhook: true,
          storage: true
        },
        formats: ['json', 'html'],
        enabled: true
      }
    ];

    defaultConfigs.forEach(config => {
      this.reportConfigs.set(config.id, config);
    });
  }

  /**
   * Setup event handlers for analytics and dashboard events
   */
  private setupEventHandlers(): void {
    // Listen to analytics events
    this.analyticsEngine.on('analysisResult', (result: AnalyticsResult) => {
      this.updateKPIsFromAnalysis(result);
    });

    // Listen to dashboard metrics updates
    this.dashboardServer.on('metricsUpdate', (metrics: PerformanceMetrics) => {
      this.updateKPIsFromMetrics(metrics);
    });

    // Periodic KPI collection
    setInterval(() => {
      this.collectCurrentKPIs();
    }, 60000); // Every minute
  }

  // =============================================================================
  // KPI Tracking and Collection
  // =============================================================================

  /**
   * Update KPIs from analytics results
   */
  private async updateKPIsFromAnalysis(result: AnalyticsResult): Promise<void> {
    try {
      const currentKPIs = await this.getCurrentKPIs();

      // Update KPIs based on analysis insights
      if (result.type === 'trend-analysis') {
        this.updateTrendKPIs(currentKPIs, result);
      } else if (result.type === 'optimization') {
        this.updateOptimizationKPIs(currentKPIs, result);
      }

      this.emit('kpisUpdated', currentKPIs);
    } catch (error) {
      console.error('Failed to update KPIs from analysis:', error);
    }
  }

  /**
   * Update KPIs from performance metrics
   */
  private async updateKPIsFromMetrics(metrics: PerformanceMetrics): Promise<void> {
    try {
      const kpis: ExecutiveKPIs = {
        timestamp: metrics.timestamp,
        performanceScore: this.calculatePerformanceScore(metrics),
        workflowEfficiencyImprovement: metrics.workflowEfficiency * 100,
        codeAnalysisImprovement: this.calculateCodeAnalysisImprovement(metrics),
        uiDevelopmentImprovement: this.calculateUIDevelopmentImprovement(metrics),
        systemUptime: metrics.systemUptime,
        mcpUtilization: metrics.mcpServerUtilization,
        roiPercentage: await this.calculateCurrentROI(),
        costSavings: await this.calculateCostSavings(),
        productivityIncrease: await this.calculateProductivityIncrease(),
        timeToMarketImprovement: await this.calculateTimeToMarketImprovement()
      };

      this.kpiHistory.push(kpis);

      // Keep only last 10000 entries (approximately 7 days at 1-minute intervals)
      if (this.kpiHistory.length > 10000) {
        this.kpiHistory = this.kpiHistory.slice(-10000);
      }

      this.emit('kpisUpdated', kpis);
    } catch (error) {
      console.error('Failed to update KPIs from metrics:', error);
    }
  }

  /**
   * Collect current KPIs snapshot
   */
  private async collectCurrentKPIs(): Promise<ExecutiveKPIs> {
    const snapshot = this.dashboardServer.getPerformanceSnapshot();
    const roi = await this.roiCalculator.calculateCurrentROI();

    const kpis: ExecutiveKPIs = {
      timestamp: Date.now(),
      performanceScore: this.calculatePerformanceScore(snapshot),
      workflowEfficiencyImprovement: snapshot.workflowEfficiency * 100,
      codeAnalysisImprovement: this.calculateCodeAnalysisImprovement(snapshot),
      uiDevelopmentImprovement: this.calculateUIDevelopmentImprovement(snapshot),
      systemUptime: snapshot.systemUptime,
      mcpUtilization: snapshot.mcpServerUtilization,
      roiPercentage: roi.internalRateOfReturn,
      costSavings: roi.monthlySavings * 12, // Annual savings
      productivityIncrease: await this.calculateProductivityIncrease(),
      timeToMarketImprovement: await this.calculateTimeToMarketImprovement()
    };

    return kpis;
  }

  /**
   * Calculate overall performance score (0-100)
   */
  private calculatePerformanceScore(metrics: PerformanceMetrics): number {
    const weights = {
      responseTime: 0.2,
      uptime: 0.25,
      cacheHitRate: 0.15,
      mcpUtilization: 0.15,
      workflowEfficiency: 0.25
    };

    // Normalize each metric to 0-100 scale
    const responseTimeScore = Math.max(0, 100 - (metrics.systemResponseTime / 10));
    const uptimeScore = metrics.systemUptime;
    const cacheScore = metrics.cacheHitRate;
    const mcpScore = metrics.mcpServerUtilization;
    const workflowScore = metrics.workflowEfficiency * 100;

    const totalScore =
      responseTimeScore * weights.responseTime +
      uptimeScore * weights.uptime +
      cacheScore * weights.cacheHitRate +
      mcpScore * weights.mcpUtilization +
      workflowScore * weights.workflowEfficiency;

    return Math.round(Math.min(100, Math.max(0, totalScore)));
  }

  /**
   * Calculate code analysis improvement percentage
   */
  private calculateCodeAnalysisImprovement(metrics: PerformanceMetrics): number {
    const baselineTime = 30; // seconds (before optimization)
    const improvement = ((baselineTime - metrics.codeAnalysisTime) / baselineTime) * 100;
    return Math.max(0, Math.min(100, improvement));
  }

  /**
   * Calculate UI development improvement percentage
   */
  private calculateUIDevelopmentImprovement(metrics: PerformanceMetrics): number {
    const baselineTime = 12; // minutes (before optimization)
    const improvement = ((baselineTime - metrics.uiWorkflowDuration) / baselineTime) * 100;
    return Math.max(0, Math.min(100, improvement));
  }

  /**
   * Calculate current ROI percentage
   */
  private async calculateCurrentROI(): Promise<number> {
    const roi = await this.roiCalculator.calculateCurrentROI();
    return roi.internalRateOfReturn;
  }

  /**
   * Calculate total cost savings
   */
  private async calculateCostSavings(): Promise<number> {
    const roi = await this.roiCalculator.calculateCurrentROI();
    return roi.monthlySavings * 12; // Annual savings
  }

  /**
   * Calculate productivity increase percentage
   */
  private async calculateProductivityIncrease(): Promise<number> {
    // Based on time savings from improved workflows
    const currentKPIs = this.kpiHistory[this.kpiHistory.length - 1];
    if (!currentKPIs) return 0;

    const codeImprovement = currentKPIs.codeAnalysisImprovement / 100;
    const uiImprovement = currentKPIs.uiDevelopmentImprovement / 100;

    // Weighted average of improvements
    return ((codeImprovement * 0.6 + uiImprovement * 0.4) * 100);
  }

  /**
   * Calculate time-to-market improvement
   */
  private async calculateTimeToMarketImprovement(): Promise<number> {
    const productivityIncrease = await this.calculateProductivityIncrease();
    // Assume time-to-market improvement is 80% of productivity increase
    return productivityIncrease * 0.8;
  }

  // =============================================================================
  // Report Generation
  // =============================================================================

  /**
   * Generate automated report
   */
  public async generateReport(configId: string, options: {
    timeRange?: { start: number; end: number };
    format?: string;
    recipients?: string[];
  } = {}): Promise<GeneratedReport> {
    const config = this.reportConfigs.get(configId);
    if (!config) {
      throw new Error(`Report configuration ${configId} not found`);
    }

    const reportId = `${configId}-${Date.now()}`;
    const startTime = Date.now();

    try {
      // Collect all necessary data
      const reportData = await this.collectReportData(config, options.timeRange);

      // Generate report instance
      const report: GeneratedReport = {
        id: reportId,
        configId,
        generatedAt: Date.now(),
        data: reportData,
        metadata: {
          generationTime: Date.now() - startTime,
          dataPoints: this.kpiHistory.length,
          coverage: options.timeRange || {
            start: Date.now() - 24 * 60 * 60 * 1000,
            end: Date.now()
          },
          version: '1.0.0'
        },
        delivery: {
          status: 'pending',
          attempts: 0,
          lastAttempt: 0,
          recipients: config.schedule.recipients.map(r => ({
            id: r.id,
            status: 'pending'
          }))
        }
      };

      this.generatedReports.set(reportId, report);

      // Deliver report
      await this.deliverReport(report, options.format);

      this.emit('reportGenerated', report);
      return report;

    } catch (error) {
      console.error(`Failed to generate report ${configId}:`, error);
      throw error;
    }
  }

  /**
   * Collect all data needed for report generation
   */
  private async collectReportData(
    config: ReportConfig,
    timeRange?: { start: number; end: number }
  ): Promise<GeneratedReport['data']> {
    const range = timeRange || {
      start: Date.now() - 24 * 60 * 60 * 1000,
      end: Date.now()
    };

    // Get current KPIs
    const currentKPIs = await this.collectCurrentKPIs();

    // Get trend analysis
    const trends = await this.generateTrendAnalysis(range);

    // Get insights and recommendations
    const insights = this.analyticsEngine.getInsights();
    const recommendations = this.analyticsEngine.getRecommendations();

    // Calculate ROI
    const roi = await this.roiCalculator.calculateCurrentROI();

    return {
      kpis: currentKPIs,
      trends,
      insights: insights.slice(0, 10), // Top 10 insights
      recommendations: recommendations.slice(0, 10), // Top 10 recommendations
      roi,
      customSections: await this.generateCustomSections(config)
    };
  }

  /**
   * Generate trend analysis for time range
   */
  private async generateTrendAnalysis(timeRange: { start: number; end: number }): Promise<TrendAnalysis[]> {
    const relevantKPIs = this.kpiHistory.filter(
      kpi => kpi.timestamp >= timeRange.start && kpi.timestamp <= timeRange.end
    );

    if (relevantKPIs.length < 2) {
      return [];
    }

    const trends: TrendAnalysis[] = [];
    const metrics = [
      'performanceScore',
      'workflowEfficiencyImprovement',
      'codeAnalysisImprovement',
      'uiDevelopmentImprovement',
      'systemUptime',
      'mcpUtilization',
      'roiPercentage'
    ];

    for (const metric of metrics) {
      const values = relevantKPIs.map(kpi => (kpi as any)[metric] as number);
      const trendAnalysis = this.trendAnalyzer.analyzeTrend(values, metric);

      if (trendAnalysis) {
        trends.push({
          metricName: metric,
          period: timeRange,
          trend: trendAnalysis.trend,
          forecast: trendAnalysis.forecast,
          targetProgress: this.calculateTargetProgress(metric, values[values.length - 1])
        });
      }
    }

    return trends;
  }

  /**
   * Calculate progress against PRD targets
   */
  private calculateTargetProgress(metric: string, current: number): TrendAnalysis['targetProgress'] {
    const targets: Record<string, number> = {
      codeAnalysisImprovement: this.PRD_TARGETS.codeAnalysisImprovement,
      uiDevelopmentImprovement: this.PRD_TARGETS.uiDevelopmentImprovement,
      workflowEfficiencyImprovement: this.PRD_TARGETS.workflowEfficiency,
      systemUptime: this.PRD_TARGETS.systemUptime,
      mcpUtilization: this.PRD_TARGETS.mcpUtilization
    };

    const target = targets[metric] || 100;
    const achievement = (current / target) * 100;
    const onTrack = achievement >= 80; // Consider on track if >80% of target

    return {
      target,
      current,
      achievement,
      onTrack
    };
  }

  /**
   * Generate custom sections based on report configuration
   */
  private async generateCustomSections(config: ReportConfig): Promise<Record<string, any>> {
    const sections: Record<string, any> = {};

    for (const section of config.template.sections) {
      if (section.type === 'custom') {
        sections[section.id] = await this.generateCustomSection(section);
      }
    }

    return sections;
  }

  /**
   * Generate custom section data
   */
  private async generateCustomSection(section: ReportSection): Promise<any> {
    // Implement custom section generation based on configuration
    return {
      title: section.title,
      data: {},
      generatedAt: Date.now()
    };
  }

  // =============================================================================
  // Report Delivery
  // =============================================================================

  /**
   * Deliver generated report to configured recipients
   */
  private async deliverReport(report: GeneratedReport, preferredFormat?: string): Promise<void> {
    const config = this.reportConfigs.get(report.configId);
    if (!config) return;

    report.delivery.attempts++;
    report.delivery.lastAttempt = Date.now();

    const deliveryPromises: Promise<void>[] = [];

    for (const recipient of config.schedule.recipients) {
      const deliveryFormat = preferredFormat || this.getPreferredFormat(recipient, config.formats);

      if (recipient.preferredDelivery === 'email' && config.delivery.email) {
        deliveryPromises.push(this.deliverByEmail(report, recipient, deliveryFormat));
      }

      if (recipient.preferredDelivery === 'slack' && config.delivery.slack) {
        deliveryPromises.push(this.deliverBySlack(report, recipient, deliveryFormat));
      }

      if (recipient.preferredDelivery === 'webhook' && config.delivery.webhook) {
        deliveryPromises.push(this.deliverByWebhook(report, recipient, deliveryFormat));
      }
    }

    // Storage delivery
    if (config.delivery.storage) {
      deliveryPromises.push(this.storeReport(report, config.formats));
    }

    try {
      await Promise.all(deliveryPromises);
      report.delivery.status = 'delivered';
    } catch (error) {
      console.error('Report delivery failed:', error);
      report.delivery.status = 'failed';
    }
  }

  /**
   * Get preferred export format for recipient
   */
  private getPreferredFormat(recipient: ReportRecipient, availableFormats: string[]): string {
    const rolePreferences: Record<string, string[]> = {
      executive: ['pdf', 'html'],
      manager: ['html', 'pdf'],
      developer: ['json', 'html'],
      stakeholder: ['html', 'xlsx']
    };

    const preferences = rolePreferences[recipient.role] || ['html'];

    for (const format of preferences) {
      if (availableFormats.includes(format)) {
        return format;
      }
    }

    return availableFormats[0] || 'json';
  }

  /**
   * Deliver report via email
   */
  private async deliverByEmail(
    report: GeneratedReport,
    recipient: ReportRecipient,
    format: string
  ): Promise<void> {
    if (!recipient.email) return;

    try {
      const exportHandler = this.exportHandlers.get(format);
      if (!exportHandler) {
        throw new Error(`No export handler for format: ${format}`);
      }

      const content = await exportHandler.export(report);

      // In production, integrate with actual email service
      console.log(`Email delivery to ${recipient.email}:`, {
        subject: `${this.reportConfigs.get(report.configId)?.name} - ${new Date().toLocaleDateString()}`,
        format,
        contentLength: content.length
      });

      // Update delivery status
      const recipientStatus = report.delivery.recipients.find(r => r.id === recipient.id);
      if (recipientStatus) {
        recipientStatus.status = 'delivered';
        recipientStatus.deliveredAt = Date.now();
      }
    } catch (error) {
      console.error(`Email delivery failed for ${recipient.id}:`, error);
      const recipientStatus = report.delivery.recipients.find(r => r.id === recipient.id);
      if (recipientStatus) {
        recipientStatus.status = 'failed';
        recipientStatus.error = error instanceof Error ? error.message : String(error);
      }
    }
  }

  /**
   * Deliver report via Slack
   */
  private async deliverBySlack(
    report: GeneratedReport,
    recipient: ReportRecipient,
    format: string
  ): Promise<void> {
    if (!recipient.slack) return;

    try {
      const config = this.reportConfigs.get(report.configId);
      const summary = this.generateReportSummary(report);

      // In production, integrate with Slack API
      console.log(`Slack delivery to ${recipient.slack}:`, {
        channel: recipient.slack,
        message: `📊 ${config?.name}\n${summary}`,
        format
      });

      const recipientStatus = report.delivery.recipients.find(r => r.id === recipient.id);
      if (recipientStatus) {
        recipientStatus.status = 'delivered';
        recipientStatus.deliveredAt = Date.now();
      }
    } catch (error) {
      console.error(`Slack delivery failed for ${recipient.id}:`, error);
      const recipientStatus = report.delivery.recipients.find(r => r.id === recipient.id);
      if (recipientStatus) {
        recipientStatus.status = 'failed';
        recipientStatus.error = error instanceof Error ? error.message : String(error);
      }
    }
  }

  /**
   * Deliver report via webhook
   */
  private async deliverByWebhook(
    report: GeneratedReport,
    recipient: ReportRecipient,
    format: string
  ): Promise<void> {
    if (!recipient.webhook) return;

    try {
      const exportHandler = this.exportHandlers.get('json'); // Always send JSON for webhooks
      if (!exportHandler) return;

      const payload = await exportHandler.export(report);

      const response = await fetch(recipient.webhook, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-Report-ID': report.id,
          'X-Report-Config': report.configId
        },
        body: payload
      });

      if (!response.ok) {
        throw new Error(`Webhook responded with status: ${response.status}`);
      }

      const recipientStatus = report.delivery.recipients.find(r => r.id === recipient.id);
      if (recipientStatus) {
        recipientStatus.status = 'delivered';
        recipientStatus.deliveredAt = Date.now();
      }
    } catch (error) {
      console.error(`Webhook delivery failed for ${recipient.id}:`, error);
      const recipientStatus = report.delivery.recipients.find(r => r.id === recipient.id);
      if (recipientStatus) {
        recipientStatus.status = 'failed';
        recipientStatus.error = error instanceof Error ? error.message : String(error);
      }
    }
  }

  /**
   * Store report to file system
   */
  private async storeReport(report: GeneratedReport, formats: string[]): Promise<void> {
    const reportDir = path.join(process.cwd(), 'reports', report.configId);

    try {
      await fs.mkdir(reportDir, { recursive: true });

      for (const format of formats) {
        const exportHandler = this.exportHandlers.get(format);
        if (!exportHandler) continue;

        const content = await exportHandler.export(report);
        const filename = `${report.id}.${format}`;
        const filepath = path.join(reportDir, filename);

        if (format === 'json') {
          await fs.writeFile(filepath, content, 'utf8');
        } else {
          await fs.writeFile(filepath, content);
        }
      }
    } catch (error) {
      console.error('Failed to store report:', error);
      throw error;
    }
  }

  /**
   * Generate summary text for reports
   */
  private generateReportSummary(report: GeneratedReport): string {
    const kpis = report.data.kpis;
    return [
      `Performance Score: ${kpis.performanceScore}%`,
      `Workflow Efficiency: ${kpis.workflowEfficiencyImprovement.toFixed(1)}%`,
      `Code Analysis Improvement: ${kpis.codeAnalysisImprovement.toFixed(1)}%`,
      `System Uptime: ${kpis.systemUptime.toFixed(1)}%`,
      `ROI: ${kpis.roiPercentage.toFixed(1)}%`,
      `Cost Savings: $${kpis.costSavings.toLocaleString()}`
    ].join('\n');
  }

  // =============================================================================
  // Template Creation
  // =============================================================================

  /**
   * Create executive dashboard template
   */
  private createExecutiveTemplate(): ReportTemplate {
    return {
      id: 'executive-template',
      name: 'Executive Performance Dashboard',
      description: 'High-level KPI dashboard for executives and stakeholders',
      sections: [
        {
          id: 'executive-summary',
          title: 'Executive Summary',
          type: 'kpi',
          config: {
            metrics: [
              'performanceScore',
              'workflowEfficiencyImprovement',
              'roiPercentage',
              'costSavings'
            ]
          },
          priority: 1
        },
        {
          id: 'prd-validation',
          title: 'PRD Target Achievement',
          type: 'chart',
          config: {
            metrics: [
              'codeAnalysisImprovement',
              'uiDevelopmentImprovement',
              'systemUptime',
              'mcpUtilization'
            ],
            chart: {
              type: 'gauge',
              dimensions: { width: 800, height: 400 },
              aggregation: 'avg',
              styling: {
                colors: ['#ff4444', '#ffaa00', '#44ff44'],
                legend: true,
                gridLines: false,
                animations: true
              }
            }
          },
          priority: 2
        },
        {
          id: 'roi-analysis',
          title: 'Return on Investment',
          type: 'roi',
          config: {
            timeRange: '30d'
          },
          priority: 3
        },
        {
          id: 'trend-analysis',
          title: 'Performance Trends',
          type: 'trends',
          config: {
            metrics: ['performanceScore', 'workflowEfficiencyImprovement'],
            timeRange: '7d'
          },
          priority: 4
        },
        {
          id: 'key-insights',
          title: 'Key Insights',
          type: 'insights',
          config: {},
          priority: 5
        },
        {
          id: 'recommendations',
          title: 'Strategic Recommendations',
          type: 'recommendations',
          config: {},
          priority: 6
        }
      ],
      styling: {
        theme: 'corporate',
        primaryColor: '#007cba',
        logoUrl: '/assets/company-logo.png'
      },
      localization: {
        locale: 'en-US',
        currency: 'USD',
        timezone: 'UTC'
      }
    };
  }

  /**
   * Create ROI analysis template
   */
  private createROITemplate(): ReportTemplate {
    return {
      id: 'roi-template',
      name: 'ROI Analysis Report',
      description: 'Detailed return on investment and cost analysis',
      sections: [
        {
          id: 'roi-summary',
          title: 'ROI Summary',
          type: 'kpi',
          config: {
            metrics: ['roiPercentage', 'costSavings', 'breakEvenMonths']
          },
          priority: 1
        },
        {
          id: 'cost-breakdown',
          title: 'Cost Analysis',
          type: 'table',
          config: {
            table: {
              columns: [
                { key: 'category', title: 'Cost Category', type: 'string', sortable: true },
                { key: 'initial', title: 'Initial Investment', type: 'currency', format: { currency: 'USD' }, sortable: true },
                { key: 'operational', title: 'Monthly Operational', type: 'currency', format: { currency: 'USD' }, sortable: true },
                { key: 'savings', title: 'Monthly Savings', type: 'currency', format: { currency: 'USD' }, sortable: true }
              ],
              sorting: { column: 'category', direction: 'asc' },
              pagination: { pageSize: 10, showPagination: false },
              styling: { striped: true, bordered: true, hover: true }
            }
          },
          priority: 2
        },
        {
          id: 'roi-projections',
          title: 'ROI Projections',
          type: 'chart',
          config: {
            chart: {
              type: 'line',
              dimensions: { width: 800, height: 400 },
              aggregation: 'sum',
              styling: {
                colors: ['#007cba', '#28a745'],
                legend: true,
                gridLines: true,
                animations: true
              }
            }
          },
          priority: 3
        }
      ],
      styling: {
        theme: 'corporate',
        primaryColor: '#28a745'
      },
      localization: {
        locale: 'en-US',
        currency: 'USD',
        timezone: 'UTC'
      }
    };
  }

  /**
   * Create technical performance template
   */
  private createTechnicalTemplate(): ReportTemplate {
    return {
      id: 'technical-template',
      name: 'Technical Performance Report',
      description: 'Detailed technical metrics and performance analysis',
      sections: [
        {
          id: 'system-health',
          title: 'System Health Overview',
          type: 'kpi',
          config: {
            metrics: [
              'systemUptime',
              'mcpUtilization',
              'cacheHitRate',
              'responseTime'
            ]
          },
          priority: 1
        },
        {
          id: 'performance-metrics',
          title: 'Performance Metrics',
          type: 'chart',
          config: {
            metrics: [
              'codeAnalysisTime',
              'uiWorkflowDuration',
              'systemResponseTime'
            ],
            chart: {
              type: 'line',
              dimensions: { width: 800, height: 400 },
              aggregation: 'avg',
              styling: {
                colors: ['#007cba', '#28a745', '#ffc107'],
                legend: true,
                gridLines: true,
                animations: true
              }
            },
            timeRange: '24h'
          },
          priority: 2
        },
        {
          id: 'technical-insights',
          title: 'Technical Insights',
          type: 'insights',
          config: {},
          priority: 3
        },
        {
          id: 'optimization-recommendations',
          title: 'Technical Recommendations',
          type: 'recommendations',
          config: {},
          priority: 4
        }
      ],
      styling: {
        theme: 'modern',
        primaryColor: '#6c757d'
      },
      localization: {
        locale: 'en-US',
        currency: 'USD',
        timezone: 'UTC'
      }
    };
  }

  // =============================================================================
  // Public API
  // =============================================================================

  /**
   * Start the reporting system
   */
  public async start(): Promise<void> {
    console.log('Starting comprehensive reporting system...');

    // Schedule automated reports
    this.scheduleAutomatedReports();

    // Start real-time KPI collection
    this.emit('started');

    console.log('Comprehensive reporting system started successfully');
  }

  /**
   * Stop the reporting system
   */
  public stop(): void {
    console.log('Stopping comprehensive reporting system...');

    // Clear all scheduled jobs
    for (const [id, timer] of this.scheduledJobs) {
      clearInterval(timer);
    }
    this.scheduledJobs.clear();

    this.emit('stopped');
    console.log('Comprehensive reporting system stopped');
  }

  /**
   * Schedule automated report generation
   */
  private scheduleAutomatedReports(): void {
    for (const [configId, config] of this.reportConfigs) {
      if (!config.enabled) continue;

      const interval = this.getScheduleInterval(config.schedule.frequency);

      const timer = setInterval(async () => {
        try {
          await this.generateReport(configId);
          console.log(`Automated report generated: ${configId}`);
        } catch (error) {
          console.error(`Failed to generate automated report ${configId}:`, error);
        }
      }, interval);

      this.scheduledJobs.set(configId, timer);
    }
  }

  /**
   * Get schedule interval in milliseconds
   */
  private getScheduleInterval(frequency: ReportConfig['schedule']['frequency']): number {
    const intervals = {
      realtime: 60000, // 1 minute
      hourly: 60 * 60 * 1000, // 1 hour
      daily: 24 * 60 * 60 * 1000, // 1 day
      weekly: 7 * 24 * 60 * 60 * 1000, // 1 week
      monthly: 30 * 24 * 60 * 60 * 1000, // 30 days
      quarterly: 90 * 24 * 60 * 60 * 1000 // 90 days
    };

    return intervals[frequency] || intervals.daily;
  }

  /**
   * Get current executive KPIs
   */
  public async getCurrentKPIs(): Promise<ExecutiveKPIs> {
    return this.collectCurrentKPIs();
  }

  /**
   * Get KPI history for time range
   */
  public getKPIHistory(timeRange?: { start: number; end: number }): ExecutiveKPIs[] {
    if (!timeRange) {
      return [...this.kpiHistory];
    }

    return this.kpiHistory.filter(
      kpi => kpi.timestamp >= timeRange.start && kpi.timestamp <= timeRange.end
    );
  }

  /**
   * Get trend analysis for metrics
   */
  public async getTrendAnalysis(
    timeRange: { start: number; end: number }
  ): Promise<TrendAnalysis[]> {
    return this.generateTrendAnalysis(timeRange);
  }

  /**
   * Get ROI analysis
   */
  public async getROIAnalysis(): Promise<ROIMetrics> {
    return this.roiCalculator.calculateCurrentROI();
  }

  /**
   * Export report in specific format
   */
  public async exportReport(
    reportId: string,
    format: 'json' | 'html' | 'pdf' | 'csv' | 'xlsx'
  ): Promise<string | Buffer> {
    const report = this.generatedReports.get(reportId);
    if (!report) {
      throw new Error(`Report ${reportId} not found`);
    }

    const exportHandler = this.exportHandlers.get(format);
    if (!exportHandler) {
      throw new Error(`Export format ${format} not supported`);
    }

    return exportHandler.export(report);
  }

  /**
   * Get available reports
   */
  public getAvailableReports(): GeneratedReport[] {
    return Array.from(this.generatedReports.values());
  }

  /**
   * Update KPIs from external systems
   */
  private updateTrendKPIs(kpis: ExecutiveKPIs, result: AnalyticsResult): void {
    // Update KPIs based on trend analysis results
    // Implementation depends on specific trend insights
  }

  /**
   * Update KPIs from optimization analysis
   */
  private updateOptimizationKPIs(kpis: ExecutiveKPIs, result: AnalyticsResult): void {
    // Update KPIs based on optimization results
    // Implementation depends on specific optimization insights
  }
}

// =============================================================================
// Support Classes
// =============================================================================

/**
 * ROI calculation engine
 */
class ROICalculator {
  private readonly DEFAULT_CONFIG = {
    initialInvestment: 100000, // $100k implementation cost
    developerHourlyRate: 120, // $120/hour average
    monthlyOperationalCosts: 5000 // $5k/month operational
  };

  async calculateCurrentROI(): Promise<ROIMetrics> {
    // In production, this would integrate with actual cost tracking systems
    const monthlySavings = this.calculateMonthlySavings();
    const breakEvenMonths = this.DEFAULT_CONFIG.initialInvestment / monthlySavings;

    return {
      initialInvestment: this.DEFAULT_CONFIG.initialInvestment,
      operationalCosts: this.DEFAULT_CONFIG.monthlyOperationalCosts,
      monthlySavings,
      developerTimeSaved: 160, // hours/month
      developerHourlyRate: this.DEFAULT_CONFIG.developerHourlyRate,
      infrastructureSavings: 2000, // $2k/month
      qualitySavings: 3000, // $3k/month from reduced bugs
      breakEvenMonths,
      netPresentValue: this.calculateNPV(monthlySavings, breakEvenMonths),
      internalRateOfReturn: this.calculateIRR(monthlySavings)
    };
  }

  private calculateMonthlySavings(): number {
    // Time savings: 160 hours * $120/hour = $19,200
    const timeSavings = 160 * this.DEFAULT_CONFIG.developerHourlyRate;

    // Infrastructure savings: $2,000
    const infraSavings = 2000;

    // Quality improvements: $3,000
    const qualitySavings = 3000;

    return timeSavings + infraSavings + qualitySavings - this.DEFAULT_CONFIG.monthlyOperationalCosts;
  }

  private calculateNPV(monthlySavings: number, months: number): number {
    const discountRate = 0.1; // 10% annual discount rate
    let npv = -this.DEFAULT_CONFIG.initialInvestment;

    for (let i = 1; i <= months; i++) {
      npv += monthlySavings / Math.pow(1 + discountRate / 12, i);
    }

    return npv;
  }

  private calculateIRR(monthlySavings: number): number {
    // Simplified IRR calculation
    const annualSavings = monthlySavings * 12;
    const roi = (annualSavings / this.DEFAULT_CONFIG.initialInvestment) * 100;
    return Math.min(roi, 500); // Cap at 500%
  }
}

/**
 * Trend analysis engine
 */
class TrendAnalyzer {
  analyzeTrend(values: number[], metricName: string): {
    trend: TrendAnalysis['trend'];
    forecast: TrendAnalysis['forecast'];
  } | null {
    if (values.length < 3) return null;

    const trend = this.calculateTrend(values);
    const forecast = this.generateForecast(values, trend);

    return { trend, forecast };
  }

  private calculateTrend(values: number[]): TrendAnalysis['trend'] {
    const n = values.length;
    const x = Array.from({ length: n }, (_, i) => i);

    // Linear regression
    const sumX = x.reduce((a, b) => a + b, 0);
    const sumY = values.reduce((a, b) => a + b, 0);
    const sumXY = x.reduce((sum, xi, i) => sum + xi * values[i], 0);
    const sumXX = x.reduce((sum, xi) => sum + xi * xi, 0);

    const slope = (n * sumXY - sumX * sumY) / (n * sumXX - sumX * sumX);

    // Calculate R-squared for confidence
    const yMean = sumY / n;
    const totalSumSquares = values.reduce((sum, yi) => sum + Math.pow(yi - yMean, 2), 0);
    const residualSumSquares = values.reduce((sum, yi, i) => {
      const predicted = slope * x[i] + (sumY - slope * sumX) / n;
      return sum + Math.pow(yi - predicted, 2);
    }, 0);

    const rSquared = 1 - (residualSumSquares / totalSumSquares);
    const confidence = Math.max(0, Math.min(1, rSquared));

    return {
      direction: slope > 0.01 ? 'increasing' : slope < -0.01 ? 'decreasing' : 'stable',
      slope,
      confidence,
      significance: confidence > 0.7 ? 'high' : confidence > 0.4 ? 'medium' : 'low'
    };
  }

  private generateForecast(values: number[], trend: TrendAnalysis['trend']): TrendAnalysis['forecast'] {
    const lastValue = values[values.length - 1];
    const predicted = lastValue + trend.slope * 5; // 5 periods ahead

    // Calculate uncertainty
    const stdDev = this.calculateStandardDeviation(values);
    const uncertainty = stdDev * Math.sqrt(5);

    return {
      predicted,
      confidenceInterval: [predicted - uncertainty, predicted + uncertainty],
      horizon: 5
    };
  }

  private calculateStandardDeviation(values: number[]): number {
    const mean = values.reduce((a, b) => a + b) / values.length;
    const variance = values.reduce((sum, x) => sum + Math.pow(x - mean, 2), 0) / values.length;
    return Math.sqrt(variance);
  }
}

// =============================================================================
// Export Handlers
// =============================================================================

/**
 * Base export handler interface
 */
interface ExportHandler {
  export(report: GeneratedReport): Promise<string | Buffer>;
}

/**
 * JSON export handler
 */
class JSONExportHandler implements ExportHandler {
  async export(report: GeneratedReport): Promise<string> {
    return JSON.stringify(report, null, 2);
  }
}

/**
 * HTML export handler
 */
class HTMLExportHandler implements ExportHandler {
  async export(report: GeneratedReport): Promise<string> {
    const config = report.configId;
    const data = report.data;

    return `
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>MCP Analytics Report - ${new Date(report.generatedAt).toLocaleDateString()}</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 20px;
            background-color: #f8f9fa;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .header {
            border-bottom: 2px solid #007cba;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        .header h1 {
            color: #007cba;
            margin: 0;
            font-size: 2.5em;
        }
        .header .meta {
            color: #6c757d;
            font-size: 14px;
            margin-top: 10px;
        }
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .kpi-card {
            background: linear-gradient(135deg, #007cba, #0056b3);
            color: white;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
        }
        .kpi-value {
            font-size: 2.5em;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .kpi-label {
            font-size: 14px;
            opacity: 0.9;
        }
        .section {
            margin: 30px 0;
            padding: 20px;
            border: 1px solid #dee2e6;
            border-radius: 8px;
        }
        .section h2 {
            color: #495057;
            margin-top: 0;
            border-bottom: 1px solid #dee2e6;
            padding-bottom: 10px;
        }
        .insights-list {
            list-style: none;
            padding: 0;
        }
        .insight {
            margin: 15px 0;
            padding: 15px;
            border-left: 4px solid #007cba;
            background: #f8f9fa;
            border-radius: 0 4px 4px 0;
        }
        .insight.warning {
            border-left-color: #ffc107;
        }
        .insight.critical {
            border-left-color: #dc3545;
        }
        .recommendation {
            margin: 15px 0;
            padding: 20px;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            background: white;
        }
        .recommendation h4 {
            margin-top: 0;
            color: #007cba;
        }
        .priority-high {
            border-left: 4px solid #dc3545;
        }
        .priority-medium {
            border-left: 4px solid #ffc107;
        }
        .priority-low {
            border-left: 4px solid #28a745;
        }
        .roi-summary {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            padding: 30px;
            border-radius: 8px;
            margin: 20px 0;
        }
        .roi-metric {
            display: inline-block;
            margin: 10px 20px 10px 0;
        }
        .roi-metric .value {
            font-size: 1.8em;
            font-weight: bold;
            display: block;
        }
        .roi-metric .label {
            font-size: 12px;
            opacity: 0.9;
        }
        .trend-item {
            margin: 15px 0;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 4px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .trend-direction {
            font-weight: bold;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
        }
        .trend-increasing {
            background: #28a745;
            color: white;
        }
        .trend-decreasing {
            background: #dc3545;
            color: white;
        }
        .trend-stable {
            background: #6c757d;
            color: white;
        }
        .footer {
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #dee2e6;
            text-align: center;
            color: #6c757d;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>MCP Analytics Report</h1>
            <div class="meta">
                Generated: ${new Date(report.generatedAt).toLocaleString()} |
                Report ID: ${report.id} |
                Coverage: ${new Date(report.metadata.coverage.start).toLocaleDateString()} - ${new Date(report.metadata.coverage.end).toLocaleDateString()}
            </div>
        </div>

        <!-- Executive Summary -->
        <div class="kpi-grid">
            <div class="kpi-card">
                <div class="kpi-value">${data.kpis.performanceScore}%</div>
                <div class="kpi-label">Performance Score</div>
            </div>
            <div class="kpi-card">
                <div class="kpi-value">${data.kpis.workflowEfficiencyImprovement.toFixed(1)}%</div>
                <div class="kpi-label">Workflow Efficiency</div>
            </div>
            <div class="kpi-card">
                <div class="kpi-value">${data.kpis.roiPercentage.toFixed(1)}%</div>
                <div class="kpi-label">ROI Percentage</div>
            </div>
            <div class="kpi-card">
                <div class="kpi-value">$${data.kpis.costSavings.toLocaleString()}</div>
                <div class="kpi-label">Annual Cost Savings</div>
            </div>
        </div>

        <!-- ROI Analysis -->
        <div class="roi-summary">
            <h3 style="margin-top: 0;">Return on Investment Analysis</h3>
            <div class="roi-metric">
                <span class="value">${data.roi.internalRateOfReturn.toFixed(1)}%</span>
                <span class="label">Internal Rate of Return</span>
            </div>
            <div class="roi-metric">
                <span class="value">${data.roi.breakEvenMonths.toFixed(1)}</span>
                <span class="label">Months to Break Even</span>
            </div>
            <div class="roi-metric">
                <span class="value">$${data.roi.monthlySavings.toLocaleString()}</span>
                <span class="label">Monthly Savings</span>
            </div>
            <div class="roi-metric">
                <span class="value">${data.roi.developerTimeSaved.toLocaleString()}h</span>
                <span class="label">Developer Hours Saved/Month</span>
            </div>
        </div>

        <!-- PRD Target Achievement -->
        <div class="section">
            <h2>PRD Target Achievement</h2>
            <div class="kpi-grid">
                <div class="kpi-card" style="background: ${data.kpis.codeAnalysisImprovement >= 60 ? '#28a745' : '#ffc107'}">
                    <div class="kpi-value">${data.kpis.codeAnalysisImprovement.toFixed(1)}%</div>
                    <div class="kpi-label">Code Analysis Improvement (Target: 60%)</div>
                </div>
                <div class="kpi-card" style="background: ${data.kpis.uiDevelopmentImprovement >= 40 ? '#28a745' : '#ffc107'}">
                    <div class="kpi-value">${data.kpis.uiDevelopmentImprovement.toFixed(1)}%</div>
                    <div class="kpi-label">UI Development Improvement (Target: 40%)</div>
                </div>
                <div class="kpi-card" style="background: ${data.kpis.systemUptime >= 99.5 ? '#28a745' : '#ffc107'}">
                    <div class="kpi-value">${data.kpis.systemUptime.toFixed(1)}%</div>
                    <div class="kpi-label">System Uptime (Target: 99.5%)</div>
                </div>
                <div class="kpi-card" style="background: ${data.kpis.mcpUtilization >= 80 ? '#28a745' : '#ffc107'}">
                    <div class="kpi-value">${data.kpis.mcpUtilization.toFixed(1)}%</div>
                    <div class="kpi-label">MCP Utilization (Target: 80%)</div>
                </div>
            </div>
        </div>

        <!-- Performance Trends -->
        ${data.trends.length > 0 ? `
        <div class="section">
            <h2>Performance Trends</h2>
            ${data.trends.map(trend => `
            <div class="trend-item">
                <div>
                    <strong>${this.formatMetricName(trend.metricName)}</strong>
                    <br>
                    <small>Target Progress: ${trend.targetProgress.achievement.toFixed(1)}% (${trend.targetProgress.onTrack ? 'On Track' : 'Behind'})</small>
                </div>
                <span class="trend-direction trend-${trend.trend.direction}">
                    ${trend.trend.direction.toUpperCase()}
                </span>
            </div>
            `).join('')}
        </div>
        ` : ''}

        <!-- Key Insights -->
        ${data.insights.length > 0 ? `
        <div class="section">
            <h2>Key Insights</h2>
            <ul class="insights-list">
                ${data.insights.slice(0, 5).map(insight => `
                <li class="insight ${insight.severity}">
                    <strong>${insight.type.toUpperCase()}:</strong> ${insight.description}
                    <br>
                    <small>Confidence: ${(insight.confidence * 100).toFixed(1)}%</small>
                </li>
                `).join('')}
            </ul>
        </div>
        ` : ''}

        <!-- Strategic Recommendations -->
        ${data.recommendations.length > 0 ? `
        <div class="section">
            <h2>Strategic Recommendations</h2>
            ${data.recommendations.slice(0, 5).map(rec => `
            <div class="recommendation priority-${rec.priority}">
                <h4>${rec.title}</h4>
                <p>${rec.description}</p>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin-top: 15px;">
                    <div>
                        <strong>Priority:</strong> ${rec.priority.toUpperCase()}<br>
                        <strong>Expected Impact:</strong> ${rec.impact.performance}% performance improvement
                    </div>
                    <div>
                        <strong>Cost Impact:</strong> $${rec.impact.cost.toLocaleString()}<br>
                        <strong>Implementation Effort:</strong> ${rec.impact.effort.toUpperCase()}
                    </div>
                    <div>
                        <strong>Timeline:</strong> ${rec.implementation.estimatedTime}<br>
                        <strong>Category:</strong> ${rec.category.replace(/-/g, ' ').toUpperCase()}
                    </div>
                </div>
            </div>
            `).join('')}
        </div>
        ` : ''}

        <div class="footer">
            <p>This report was generated automatically by the MCP Analytics and Reporting System</p>
            <p>For questions or support, contact the system administration team</p>
        </div>
    </div>
</body>
</html>`;
  }

  private formatMetricName(name: string): string {
    return name
      .replace(/([A-Z])/g, ' $1')
      .replace(/^./, str => str.toUpperCase())
      .replace(/\b\w/g, l => l.toUpperCase());
  }
}

/**
 * PDF export handler
 */
class PDFExportHandler implements ExportHandler {
  async export(report: GeneratedReport): Promise<Buffer> {
    // In production, this would use a library like puppeteer or pdf-lib
    // For now, return HTML content as a placeholder
    const htmlHandler = new HTMLExportHandler();
    const htmlContent = await htmlHandler.export(report);

    // Placeholder: convert HTML to PDF using puppeteer
    return Buffer.from(htmlContent, 'utf8');
  }
}

/**
 * CSV export handler
 */
class CSVExportHandler implements ExportHandler {
  async export(report: GeneratedReport): Promise<string> {
    const kpis = report.data.kpis;
    const trends = report.data.trends;

    const csvLines = [
      // Header
      'Metric,Value,Unit,Timestamp',
      // KPI data
      `Performance Score,${kpis.performanceScore},%,${new Date(kpis.timestamp).toISOString()}`,
      `Workflow Efficiency,${kpis.workflowEfficiencyImprovement.toFixed(2)},%,${new Date(kpis.timestamp).toISOString()}`,
      `Code Analysis Improvement,${kpis.codeAnalysisImprovement.toFixed(2)},%,${new Date(kpis.timestamp).toISOString()}`,
      `UI Development Improvement,${kpis.uiDevelopmentImprovement.toFixed(2)},%,${new Date(kpis.timestamp).toISOString()}`,
      `System Uptime,${kpis.systemUptime.toFixed(2)},%,${new Date(kpis.timestamp).toISOString()}`,
      `MCP Utilization,${kpis.mcpUtilization.toFixed(2)},%,${new Date(kpis.timestamp).toISOString()}`,
      `ROI Percentage,${kpis.roiPercentage.toFixed(2)},%,${new Date(kpis.timestamp).toISOString()}`,
      `Cost Savings,${kpis.costSavings.toFixed(2)},USD,${new Date(kpis.timestamp).toISOString()}`,
      `Productivity Increase,${kpis.productivityIncrease.toFixed(2)},%,${new Date(kpis.timestamp).toISOString()}`,
      `Time to Market Improvement,${kpis.timeToMarketImprovement.toFixed(2)},%,${new Date(kpis.timestamp).toISOString()}`
    ];

    // Add trend data if available
    if (trends.length > 0) {
      csvLines.push('');
      csvLines.push('Trend Analysis');
      csvLines.push('Metric,Direction,Slope,Confidence,Target Achievement');

      trends.forEach(trend => {
        csvLines.push(
          `${trend.metricName},${trend.trend.direction},${trend.trend.slope.toFixed(4)},${(trend.trend.confidence * 100).toFixed(1)}%,${trend.targetProgress.achievement.toFixed(1)}%`
        );
      });
    }

    return csvLines.join('\n');
  }
}

/**
 * Excel export handler
 */
class ExcelExportHandler implements ExportHandler {
  async export(report: GeneratedReport): Promise<Buffer> {
    // In production, this would use a library like exceljs or xlsx
    // For now, return CSV content as a fallback
    const csvHandler = new CSVExportHandler();
    const csvContent = await csvHandler.export(report);

    return Buffer.from(csvContent, 'utf8');
  }
}

// =============================================================================
// Exports
// =============================================================================

export {
  ComprehensiveReportingSystem,
  type ExecutiveKPIs,
  type ROIMetrics,
  type TrendAnalysis,
  type ReportConfig,
  type ReportTemplate,
  type GeneratedReport,
  type ReportRecipient
};

// Factory function
export function createReportingSystem(
  analyticsEngine: AnalyticsEngine,
  dashboardServer: DashboardServer,
  config?: Partial<MonitoringSystemConfig>
): ComprehensiveReportingSystem {
  return new ComprehensiveReportingSystem(analyticsEngine, dashboardServer, config);
}

export default ComprehensiveReportingSystem;
