/**
 * SPEC_05: Advanced Analytics and Reporting Framework
 * Provides comprehensive analytics, reporting, and optimization recommendations
 */

import { EventEmitter } from 'events';
import * as fs from 'fs/promises';
import * as path from 'path';

// Analytics Configuration
export interface AnalyticsConfig {
  dataSources: DataSourceConfig[];
  models: AnalyticsModel[];
  reporting: ReportingFramework;
  predictions: PredictiveConfig;
  optimization: OptimizationConfig;
}

export interface DataSourceConfig {
  id: string;
  type: 'prometheus' | 'logs' | 'metrics' | 'external-api';
  endpoint: string;
  queryInterval: number; // seconds
  retentionDays: number;
  authentication?: {
    type: 'bearer' | 'basic' | 'api-key';
    credentials: string;
  };
}

export interface AnalyticsModel {
  id: string;
  name: string;
  type: 'trend-analysis' | 'anomaly-detection' | 'correlation' | 'forecasting' | 'optimization';
  inputs: string[]; // metric names
  outputs: string[]; // derived metric names
  parameters: Record<string, any>;
  enabled: boolean;
}

export interface ReportingFramework {
  templates: ReportTemplate[];
  schedules: ReportSchedule[];
  distribution: DistributionConfig;
}

export interface ReportTemplate {
  id: string;
  name: string;
  type: 'executive' | 'performance' | 'system-health' | 'optimization' | 'capacity';
  sections: ReportSection[];
  format: 'html' | 'pdf' | 'json';
}

export interface ReportSection {
  id: string;
  title: string;
  type: 'metrics' | 'charts' | 'table' | 'analysis' | 'recommendations';
  config: any;
}

export interface ReportSchedule {
  id: string;
  templateId: string;
  frequency: 'hourly' | 'daily' | 'weekly' | 'monthly' | 'quarterly';
  recipients: string[];
  enabled: boolean;
}

export interface DistributionConfig {
  email: {
    enabled: boolean;
    smtpConfig?: any;
  };
  slack: {
    enabled: boolean;
    webhookUrl?: string;
  };
  storage: {
    enabled: boolean;
    path: string;
  };
}

export interface PredictiveConfig {
  forecastingHorizon: number; // days
  confidenceInterval: number; // percentage
  models: {
    trendAnalysis: boolean;
    seasonalityDetection: boolean;
    anomalyPrediction: boolean;
    capacityForecasting: boolean;
  };
}

export interface OptimizationConfig {
  enabled: boolean;
  thresholds: {
    performanceDegradation: number; // percentage
    resourceWaste: number; // percentage
    costInefficiency: number; // percentage
  };
  recommendations: {
    autoGenerate: boolean;
    categories: OptimizationCategory[];
  };
}

export type OptimizationCategory = 
  | 'performance-tuning'
  | 'resource-scaling' 
  | 'workflow-optimization'
  | 'technology-updates'
  | 'cost-reduction';

// Time Series Data Structure
export interface TimeSeriesData {
  timestamp: number;
  metrics: Record<string, number>;
}

export interface AnalyticsResult {
  id: string;
  type: string;
  timestamp: number;
  insights: Insight[];
  recommendations: Recommendation[];
  confidence: number;
  data: any;
}

export interface Insight {
  type: 'trend' | 'anomaly' | 'correlation' | 'pattern';
  description: string;
  severity: 'info' | 'warning' | 'critical';
  confidence: number;
  evidence: any[];
}

export interface Recommendation {
  id: string;
  category: OptimizationCategory;
  title: string;
  description: string;
  priority: 'low' | 'medium' | 'high' | 'critical';
  impact: {
    performance: number; // percentage improvement expected
    cost: number; // cost impact (positive = savings)
    effort: 'low' | 'medium' | 'high';
  };
  implementation: {
    steps: string[];
    estimatedTime: string;
    prerequisites: string[];
  };
  validation: {
    metrics: string[];
    successCriteria: string[];
  };
}

// Advanced Analytics Engine
export class AnalyticsEngine extends EventEmitter {
  private config: AnalyticsConfig;
  private dataStore: Map<string, TimeSeriesData[]> = new Map();
  private models: Map<string, AnalyticsModel> = new Map();
  private results: Map<string, AnalyticsResult[]> = new Map();
  private collectTimer: NodeJS.Timeout | null = null;
  private analysisTimer: NodeJS.Timeout | null = null;

  constructor(config: AnalyticsConfig) {
    super();
    this.config = config;
    this.initializeModels();
  }

  async start(): Promise<void> {
    console.log('Starting analytics engine...');
    
    // Start data collection
    this.collectTimer = setInterval(async () => {
      await this.collectData();
    }, 30000); // Collect every 30 seconds

    // Start analysis
    this.analysisTimer = setInterval(async () => {
      await this.runAnalysis();
    }, 300000); // Analyze every 5 minutes

    this.emit('started');
  }

  stop(): void {
    if (this.collectTimer) {
      clearInterval(this.collectTimer);
      this.collectTimer = null;
    }
    
    if (this.analysisTimer) {
      clearInterval(this.analysisTimer);
      this.analysisTimer = null;
    }

    console.log('Analytics engine stopped');
    this.emit('stopped');
  }

  private initializeModels(): void {
    for (const modelConfig of this.config.models) {
      if (modelConfig.enabled) {
        this.models.set(modelConfig.id, modelConfig);
      }
    }
  }

  private async collectData(): Promise<void> {
    for (const dataSource of this.config.dataSources) {
      try {
        const data = await this.fetchFromDataSource(dataSource);
        this.storeData(dataSource.id, data);
      } catch (error) {
        console.error(`Failed to collect data from ${dataSource.id}:`, error);
      }
    }
  }

  private async fetchFromDataSource(dataSource: DataSourceConfig): Promise<TimeSeriesData[]> {
    switch (dataSource.type) {
      case 'prometheus':
        return this.fetchFromPrometheus(dataSource);
      case 'metrics':
        return this.fetchMetricsData(dataSource);
      case 'logs':
        return this.fetchLogData(dataSource);
      case 'external-api':
        return this.fetchFromExternalAPI(dataSource);
      default:
        throw new Error(`Unsupported data source type: ${dataSource.type}`);
    }
  }

  private async fetchFromPrometheus(dataSource: DataSourceConfig): Promise<TimeSeriesData[]> {
    // Simulate Prometheus query
    const now = Date.now();
    const data: TimeSeriesData[] = [];

    // Generate sample time series data
    for (let i = 0; i < 10; i++) {
      const timestamp = now - (i * 60000); // 1 minute intervals
      data.push({
        timestamp,
        metrics: {
          cpu_usage: Math.random() * 100,
          memory_usage: Math.random() * 100,
          response_time: 100 + Math.random() * 400,
          request_rate: 50 + Math.random() * 200,
          error_rate: Math.random() * 5
        }
      });
    }

    return data.reverse(); // Sort chronologically
  }

  private async fetchMetricsData(dataSource: DataSourceConfig): Promise<TimeSeriesData[]> {
    // Simulate custom metrics collection
    const now = Date.now();
    return [{
      timestamp: now,
      metrics: {
        code_analysis_time: 18 + Math.random() * 6, // 18-24 seconds
        ui_workflow_duration: 4.8 + Math.random() * 2.4, // 4.8-7.2 minutes
        mcp_utilization: 0.75 + Math.random() * 0.15, // 75-90%
        cache_hit_rate: 0.85 + Math.random() * 0.1, // 85-95%
        workflow_efficiency: 0.40 + Math.random() * 0.10 // 40-50%
      }
    }];
  }

  private async fetchLogData(dataSource: DataSourceConfig): Promise<TimeSeriesData[]> {
    // Simulate log-based metrics extraction
    return [{
      timestamp: Date.now(),
      metrics: {
        error_count: Math.floor(Math.random() * 10),
        warning_count: Math.floor(Math.random() * 20),
        processing_time: Math.random() * 1000
      }
    }];
  }

  private async fetchFromExternalAPI(dataSource: DataSourceConfig): Promise<TimeSeriesData[]> {
    // Simulate external API data
    try {
      const response = await fetch(dataSource.endpoint, {
        headers: this.getAuthHeaders(dataSource.authentication)
      });
      
      if (!response.ok) {
        throw new Error(`API request failed: ${response.status}`);
      }
      
      const data = await response.json();
      return this.transformExternalData(data);
    } catch (error) {
      console.error(`External API fetch failed:`, error);
      return [];
    }
  }

  private getAuthHeaders(auth?: DataSourceConfig['authentication']): Record<string, string> {
    if (!auth) return {};
    
    switch (auth.type) {
      case 'bearer':
        return { 'Authorization': `Bearer ${auth.credentials}` };
      case 'api-key':
        return { 'X-API-Key': auth.credentials };
      case 'basic':
        return { 'Authorization': `Basic ${auth.credentials}` };
      default:
        return {};
    }
  }

  private transformExternalData(data: any): TimeSeriesData[] {
    // Transform external data format to internal format
    return [{
      timestamp: Date.now(),
      metrics: data.metrics || {}
    }];
  }

  private storeData(sourceId: string, data: TimeSeriesData[]): void {
    if (!this.dataStore.has(sourceId)) {
      this.dataStore.set(sourceId, []);
    }
    
    const sourceData = this.dataStore.get(sourceId)!;
    sourceData.push(...data);
    
    // Apply retention policy
    const retentionMs = this.config.dataSources.find(ds => ds.id === sourceId)?.retentionDays * 24 * 60 * 60 * 1000 || 90 * 24 * 60 * 60 * 1000;
    const cutoff = Date.now() - retentionMs;
    
    const filteredData = sourceData.filter(d => d.timestamp > cutoff);
    this.dataStore.set(sourceId, filteredData);
  }

  private async runAnalysis(): Promise<void> {
    console.log('Running analytics models...');
    
    for (const [modelId, model] of this.models) {
      try {
        const result = await this.executeModel(model);
        this.storeResult(modelId, result);
        this.emit('analysisResult', result);
      } catch (error) {
        console.error(`Model ${modelId} execution failed:`, error);
      }
    }
  }

  private async executeModel(model: AnalyticsModel): Promise<AnalyticsResult> {
    switch (model.type) {
      case 'trend-analysis':
        return this.executeTrendAnalysis(model);
      case 'anomaly-detection':
        return this.executeAnomalyDetection(model);
      case 'correlation':
        return this.executeCorrelationAnalysis(model);
      case 'forecasting':
        return this.executeForecasting(model);
      case 'optimization':
        return this.executeOptimizationAnalysis(model);
      default:
        throw new Error(`Unknown model type: ${model.type}`);
    }
  }

  private async executeTrendAnalysis(model: AnalyticsModel): Promise<AnalyticsResult> {
    const data = this.getModelInputData(model);
    const insights: Insight[] = [];
    const recommendations: Recommendation[] = [];

    // Analyze trends for each input metric
    for (const metricName of model.inputs) {
      const metricData = data.map(d => d.metrics[metricName]).filter(v => v !== undefined);
      
      if (metricData.length < 10) continue;
      
      const trend = this.calculateTrend(metricData);
      const significance = Math.abs(trend.slope) * trend.confidence;
      
      if (significance > 0.1) {
        const direction = trend.slope > 0 ? 'increasing' : 'decreasing';
        const severity = significance > 0.3 ? 'warning' : 'info';
        
        insights.push({
          type: 'trend',
          description: `${metricName} is ${direction} with ${(significance * 100).toFixed(1)}% significance`,
          severity: severity as 'info' | 'warning',
          confidence: trend.confidence,
          evidence: [
            { slope: trend.slope, r_squared: trend.rSquared, data_points: metricData.length }
          ]
        });

        // Generate recommendations based on trend
        if (metricName === 'response_time' && trend.slope > 0) {
          recommendations.push({
            id: `perf-${Date.now()}`,
            category: 'performance-tuning',
            title: 'Address Response Time Degradation',
            description: 'System response time is trending upward, indicating performance degradation',
            priority: 'high',
            impact: {
              performance: 15,
              cost: -1000,
              effort: 'medium'
            },
            implementation: {
              steps: [
                'Analyze current bottlenecks',
                'Implement caching optimizations',
                'Scale infrastructure resources',
                'Monitor improvements'
              ],
              estimatedTime: '1-2 weeks',
              prerequisites: ['Performance profiling tools', 'Infrastructure access']
            },
            validation: {
              metrics: ['response_time', 'throughput'],
              successCriteria: ['Response time reduced by 10%', 'No increase in error rate']
            }
          });
        }
      }
    }

    return {
      id: `trend-${Date.now()}`,
      type: 'trend-analysis',
      timestamp: Date.now(),
      insights,
      recommendations,
      confidence: insights.length > 0 ? Math.max(...insights.map(i => i.confidence)) : 0,
      data: { trends: insights.map(i => i.evidence).flat() }
    };
  }

  private async executeAnomalyDetection(model: AnalyticsModel): Promise<AnalyticsResult> {
    const data = this.getModelInputData(model);
    const insights: Insight[] = [];
    const recommendations: Recommendation[] = [];

    for (const metricName of model.inputs) {
      const metricData = data.map(d => d.metrics[metricName]).filter(v => v !== undefined);
      
      if (metricData.length < 20) continue;
      
      const anomalies = this.detectAnomalies(metricData);
      
      if (anomalies.length > 0) {
        insights.push({
          type: 'anomaly',
          description: `Detected ${anomalies.length} anomalies in ${metricName}`,
          severity: anomalies.length > 3 ? 'critical' : 'warning',
          confidence: 0.85,
          evidence: anomalies
        });

        if (metricName === 'error_rate' && anomalies.length > 2) {
          recommendations.push({
            id: `error-${Date.now()}`,
            category: 'performance-tuning',
            title: 'Investigate Error Rate Anomalies',
            description: 'Unusual error rate patterns detected that may indicate system issues',
            priority: 'critical',
            impact: {
              performance: 20,
              cost: -2000,
              effort: 'high'
            },
            implementation: {
              steps: [
                'Review error logs for patterns',
                'Check system health metrics',
                'Identify root cause',
                'Implement fixes',
                'Monitor for recurrence'
              ],
              estimatedTime: '3-5 days',
              prerequisites: ['Log access', 'System monitoring tools']
            },
            validation: {
              metrics: ['error_rate', 'system_availability'],
              successCriteria: ['Error rate below 1%', 'No recurring anomalies']
            }
          });
        }
      }
    }

    return {
      id: `anomaly-${Date.now()}`,
      type: 'anomaly-detection',
      timestamp: Date.now(),
      insights,
      recommendations,
      confidence: 0.85,
      data: { anomalies: insights.map(i => i.evidence).flat() }
    };
  }

  private async executeCorrelationAnalysis(model: AnalyticsModel): Promise<AnalyticsResult> {
    const data = this.getModelInputData(model);
    const insights: Insight[] = [];
    const recommendations: Recommendation[] = [];

    // Analyze correlations between metrics
    for (let i = 0; i < model.inputs.length; i++) {
      for (let j = i + 1; j < model.inputs.length; j++) {
        const metric1 = model.inputs[i];
        const metric2 = model.inputs[j];
        
        const data1 = data.map(d => d.metrics[metric1]).filter(v => v !== undefined);
        const data2 = data.map(d => d.metrics[metric2]).filter(v => v !== undefined);
        
        if (data1.length !== data2.length || data1.length < 10) continue;
        
        const correlation = this.calculateCorrelation(data1, data2);
        
        if (Math.abs(correlation) > 0.7) {
          const strength = Math.abs(correlation) > 0.9 ? 'strong' : 'moderate';
          const direction = correlation > 0 ? 'positive' : 'negative';
          
          insights.push({
            type: 'correlation',
            description: `${strength} ${direction} correlation (${correlation.toFixed(3)}) between ${metric1} and ${metric2}`,
            severity: 'info',
            confidence: Math.abs(correlation),
            evidence: [{ correlation, metric1, metric2, sample_size: data1.length }]
          });
        }
      }
    }

    return {
      id: `correlation-${Date.now()}`,
      type: 'correlation',
      timestamp: Date.now(),
      insights,
      recommendations,
      confidence: insights.length > 0 ? Math.max(...insights.map(i => i.confidence)) : 0,
      data: { correlations: insights.map(i => i.evidence).flat() }
    };
  }

  private async executeForecasting(model: AnalyticsModel): Promise<AnalyticsResult> {
    const data = this.getModelInputData(model);
    const insights: Insight[] = [];
    const recommendations: Recommendation[] = [];
    const forecasts: any[] = [];

    for (const metricName of model.inputs) {
      const metricData = data.map(d => d.metrics[metricName]).filter(v => v !== undefined);
      
      if (metricData.length < 30) continue;
      
      const forecast = this.forecastMetric(metricData, this.config.predictions.forecastingHorizon);
      forecasts.push({ metric: metricName, forecast });
      
      // Check for capacity issues
      if (metricName === 'cpu_usage' && forecast.projectedMax > 90) {
        insights.push({
          type: 'pattern',
          description: `CPU usage projected to exceed 90% within ${this.config.predictions.forecastingHorizon} days`,
          severity: 'warning',
          confidence: forecast.confidence,
          evidence: [forecast]
        });

        recommendations.push({
          id: `capacity-${Date.now()}`,
          category: 'resource-scaling',
          title: 'Scale CPU Resources',
          description: 'CPU usage forecasting indicates capacity constraints',
          priority: 'medium',
          impact: {
            performance: 25,
            cost: 500,
            effort: 'low'
          },
          implementation: {
            steps: [
              'Review current CPU utilization patterns',
              'Plan resource scaling strategy',
              'Implement scaling (auto or manual)',
              'Monitor capacity headroom'
            ],
            estimatedTime: '1 week',
            prerequisites: ['Infrastructure access', 'Budget approval']
          },
          validation: {
            metrics: ['cpu_usage', 'response_time'],
            successCriteria: ['CPU utilization <80%', 'No performance degradation']
          }
        });
      }
    }

    return {
      id: `forecast-${Date.now()}`,
      type: 'forecasting',
      timestamp: Date.now(),
      insights,
      recommendations,
      confidence: forecasts.length > 0 ? 0.8 : 0,
      data: { forecasts }
    };
  }

  private async executeOptimizationAnalysis(model: AnalyticsModel): Promise<AnalyticsResult> {
    const data = this.getModelInputData(model);
    const insights: Insight[] = [];
    const recommendations: Recommendation[] = [];

    // Analyze optimization opportunities
    const latestData = data[data.length - 1];
    if (!latestData) {
      return {
        id: `optimization-${Date.now()}`,
        type: 'optimization',
        timestamp: Date.now(),
        insights: [],
        recommendations: [],
        confidence: 0,
        data: {}
      };
    }

    // Check for resource waste
    const cpuUsage = latestData.metrics.cpu_usage || 0;
    const memoryUsage = latestData.metrics.memory_usage || 0;
    
    if (cpuUsage < 30 && memoryUsage < 40) {
      insights.push({
        type: 'pattern',
        description: 'Low resource utilization indicates potential cost optimization opportunity',
        severity: 'info',
        confidence: 0.9,
        evidence: [{ cpu: cpuUsage, memory: memoryUsage }]
      });

      recommendations.push({
        id: `cost-opt-${Date.now()}`,
        category: 'cost-reduction',
        title: 'Right-size Infrastructure Resources',
        description: 'Current resource utilization is low, consider downsizing for cost savings',
        priority: 'low',
        impact: {
          performance: -5, // Slight performance impact
          cost: -3000, // Cost savings
          effort: 'medium'
        },
        implementation: {
          steps: [
            'Analyze usage patterns over longer period',
            'Test with reduced resources in staging',
            'Implement gradual downsizing',
            'Monitor performance impact'
          ],
          estimatedTime: '2-3 weeks',
          prerequisites: ['Usage pattern analysis', 'Staging environment']
        },
        validation: {
          metrics: ['cpu_usage', 'memory_usage', 'response_time', 'cost'],
          successCriteria: ['Maintain <80% utilization', 'No performance degradation', '20% cost reduction']
        }
      });
    }

    // Check workflow efficiency
    const workflowEfficiency = latestData.metrics.workflow_efficiency || 0;
    if (workflowEfficiency < 0.4) { // Below 40% improvement target
      recommendations.push({
        id: `workflow-opt-${Date.now()}`,
        category: 'workflow-optimization',
        title: 'Optimize Development Workflows',
        description: 'Workflow efficiency below target, investigate bottlenecks',
        priority: 'medium',
        impact: {
          performance: 30,
          cost: -1500,
          effort: 'high'
        },
        implementation: {
          steps: [
            'Profile workflow bottlenecks',
            'Identify optimization opportunities',
            'Implement workflow improvements',
            'Train team on optimized processes'
          ],
          estimatedTime: '4-6 weeks',
          prerequisites: ['Workflow analysis tools', 'Team availability']
        },
        validation: {
          metrics: ['workflow_efficiency', 'code_analysis_time', 'ui_workflow_duration'],
          successCriteria: ['40%+ efficiency improvement', 'PRD targets met']
        }
      });
    }

    return {
      id: `optimization-${Date.now()}`,
      type: 'optimization',
      timestamp: Date.now(),
      insights,
      recommendations,
      confidence: 0.85,
      data: { current_metrics: latestData.metrics }
    };
  }

  // Mathematical helper methods
  private calculateTrend(data: number[]): { slope: number; rSquared: number; confidence: number } {
    const n = data.length;
    const x = Array.from({ length: n }, (_, i) => i);
    const y = data;

    const sumX = x.reduce((a, b) => a + b, 0);
    const sumY = y.reduce((a, b) => a + b, 0);
    const sumXY = x.reduce((sum, xi, i) => sum + xi * y[i], 0);
    const sumXX = x.reduce((sum, xi) => sum + xi * xi, 0);
    const sumYY = y.reduce((sum, yi) => sum + yi * yi, 0);

    const slope = (n * sumXY - sumX * sumY) / (n * sumXX - sumX * sumX);
    const intercept = (sumY - slope * sumX) / n;

    // Calculate R-squared
    const yMean = sumY / n;
    const totalSumSquares = y.reduce((sum, yi) => sum + Math.pow(yi - yMean, 2), 0);
    const residualSumSquares = y.reduce((sum, yi, i) => {
      const predicted = slope * x[i] + intercept;
      return sum + Math.pow(yi - predicted, 2);
    }, 0);
    
    const rSquared = 1 - (residualSumSquares / totalSumSquares);
    const confidence = Math.max(0, Math.min(1, rSquared));

    return { slope, rSquared, confidence };
  }

  private detectAnomalies(data: number[]): number[] {
    // Simple statistical anomaly detection using z-score
    const mean = data.reduce((a, b) => a + b, 0) / data.length;
    const stdDev = Math.sqrt(data.reduce((sum, x) => sum + Math.pow(x - mean, 2), 0) / data.length);
    
    const threshold = 2.5; // z-score threshold
    const anomalies: number[] = [];
    
    data.forEach((value, index) => {
      const zScore = Math.abs((value - mean) / stdDev);
      if (zScore > threshold) {
        anomalies.push(value);
      }
    });
    
    return anomalies;
  }

  private calculateCorrelation(x: number[], y: number[]): number {
    const n = x.length;
    const sumX = x.reduce((a, b) => a + b, 0);
    const sumY = y.reduce((a, b) => a + b, 0);
    const sumXY = x.reduce((sum, xi, i) => sum + xi * y[i], 0);
    const sumXX = x.reduce((sum, xi) => sum + xi * xi, 0);
    const sumYY = y.reduce((sum, yi) => sum + yi * yi, 0);

    const numerator = n * sumXY - sumX * sumY;
    const denominator = Math.sqrt((n * sumXX - sumX * sumX) * (n * sumYY - sumY * sumY));

    return denominator === 0 ? 0 : numerator / denominator;
  }

  private forecastMetric(data: number[], horizon: number): { projectedMax: number; projectedMin: number; confidence: number } {
    // Simple linear regression forecasting
    const trend = this.calculateTrend(data);
    const lastValue = data[data.length - 1];
    const projectedValue = lastValue + (trend.slope * horizon);
    
    // Add uncertainty bounds
    const stdDev = Math.sqrt(data.reduce((sum, x) => sum + Math.pow(x - data.reduce((a, b) => a + b) / data.length, 2), 0) / data.length);
    const uncertainty = stdDev * Math.sqrt(horizon);
    
    return {
      projectedMax: projectedValue + uncertainty,
      projectedMin: projectedValue - uncertainty,
      confidence: trend.confidence
    };
  }

  private getModelInputData(model: AnalyticsModel): TimeSeriesData[] {
    // Combine data from all sources
    const allData: TimeSeriesData[] = [];
    
    for (const sourceData of this.dataStore.values()) {
      allData.push(...sourceData);
    }
    
    // Sort by timestamp and return recent data (last 100 points)
    return allData
      .sort((a, b) => a.timestamp - b.timestamp)
      .slice(-100);
  }

  private storeResult(modelId: string, result: AnalyticsResult): void {
    if (!this.results.has(modelId)) {
      this.results.set(modelId, []);
    }
    
    const modelResults = this.results.get(modelId)!;
    modelResults.push(result);
    
    // Keep only last 50 results per model
    if (modelResults.length > 50) {
      modelResults.splice(0, modelResults.length - 50);
    }
  }

  // Public API methods
  async generateReport(templateId: string): Promise<string> {
    const template = this.config.reporting.templates.find(t => t.id === templateId);
    if (!template) {
      throw new Error(`Report template ${templateId} not found`);
    }

    const report = await this.buildReport(template);
    return this.formatReport(report, template.format);
  }

  private async buildReport(template: ReportTemplate): Promise<any> {
    const report = {
      title: template.name,
      generatedAt: new Date().toISOString(),
      sections: []
    };

    for (const section of template.sections) {
      const sectionData = await this.buildReportSection(section);
      report.sections.push(sectionData);
    }

    return report;
  }

  private async buildReportSection(section: ReportSection): Promise<any> {
    switch (section.type) {
      case 'metrics':
        return this.buildMetricsSection(section);
      case 'analysis':
        return this.buildAnalysisSection(section);
      case 'recommendations':
        return this.buildRecommendationsSection(section);
      default:
        return { title: section.title, content: 'Section not implemented' };
    }
  }

  private buildMetricsSection(section: ReportSection): any {
    const latestData = Array.from(this.dataStore.values())
      .flat()
      .sort((a, b) => b.timestamp - a.timestamp)[0];

    return {
      title: section.title,
      type: 'metrics',
      data: latestData?.metrics || {},
      timestamp: latestData?.timestamp || Date.now()
    };
  }

  private buildAnalysisSection(section: ReportSection): any {
    const allResults = Array.from(this.results.values()).flat();
    const insights = allResults.flatMap(r => r.insights);
    
    return {
      title: section.title,
      type: 'analysis',
      insights: insights.slice(0, 10), // Top 10 insights
      summary: {
        totalInsights: insights.length,
        criticalIssues: insights.filter(i => i.severity === 'critical').length,
        warnings: insights.filter(i => i.severity === 'warning').length
      }
    };
  }

  private buildRecommendationsSection(section: ReportSection): any {
    const allResults = Array.from(this.results.values()).flat();
    const recommendations = allResults.flatMap(r => r.recommendations);
    
    // Sort by priority
    const priorityOrder = { critical: 4, high: 3, medium: 2, low: 1 };
    const sortedRecommendations = recommendations
      .sort((a, b) => priorityOrder[b.priority] - priorityOrder[a.priority])
      .slice(0, 10);

    return {
      title: section.title,
      type: 'recommendations',
      recommendations: sortedRecommendations,
      summary: {
        totalRecommendations: recommendations.length,
        byPriority: {
          critical: recommendations.filter(r => r.priority === 'critical').length,
          high: recommendations.filter(r => r.priority === 'high').length,
          medium: recommendations.filter(r => r.priority === 'medium').length,
          low: recommendations.filter(r => r.priority === 'low').length
        },
        byCategory: this.groupRecommendationsByCategory(recommendations)
      }
    };
  }

  private groupRecommendationsByCategory(recommendations: Recommendation[]): Record<string, number> {
    return recommendations.reduce((acc, rec) => {
      acc[rec.category] = (acc[rec.category] || 0) + 1;
      return acc;
    }, {} as Record<string, number>);
  }

  private formatReport(report: any, format: string): string {
    switch (format) {
      case 'json':
        return JSON.stringify(report, null, 2);
      case 'html':
        return this.generateHTMLReport(report);
      default:
        return JSON.stringify(report, null, 2);
    }
  }

  private generateHTMLReport(report: any): string {
    return `
<!DOCTYPE html>
<html>
<head>
    <title>${report.title}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; line-height: 1.6; }
        .header { background: #f4f4f4; padding: 20px; border-radius: 5px; margin-bottom: 20px; }
        .section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .metrics { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; }
        .metric-card { background: #f9f9f9; padding: 15px; border-radius: 3px; }
        .insight { margin: 10px 0; padding: 10px; border-left: 4px solid #007cba; }
        .insight.warning { border-color: #ff9800; }
        .insight.critical { border-color: #f44336; }
        .recommendation { margin: 10px 0; padding: 15px; border: 1px solid #ddd; border-radius: 3px; }
        .priority-high { border-left: 4px solid #f44336; }
        .priority-medium { border-left: 4px solid #ff9800; }
        .priority-low { border-left: 4px solid #4caf50; }
    </style>
</head>
<body>
    <div class="header">
        <h1>${report.title}</h1>
        <p>Generated: ${report.generatedAt}</p>
    </div>
    
    ${report.sections.map((section: any) => this.formatHTMLSection(section)).join('')}
</body>
</html>`;
  }

  private formatHTMLSection(section: any): string {
    switch (section.type) {
      case 'metrics':
        return `
        <div class="section">
            <h2>${section.title}</h2>
            <div class="metrics">
                ${Object.entries(section.data).map(([key, value]: [string, any]) => 
                  `<div class="metric-card">
                     <strong>${key.replace(/_/g, ' ').toUpperCase()}</strong><br>
                     ${typeof value === 'number' ? value.toFixed(2) : value}
                   </div>`
                ).join('')}
            </div>
        </div>`;
      
      case 'analysis':
        return `
        <div class="section">
            <h2>${section.title}</h2>
            <p>Total Insights: ${section.summary.totalInsights} | 
               Critical: ${section.summary.criticalIssues} | 
               Warnings: ${section.summary.warnings}</p>
            ${section.insights.map((insight: Insight) => 
              `<div class="insight ${insight.severity}">
                 <strong>${insight.type.toUpperCase()}</strong>: ${insight.description}
                 <br><small>Confidence: ${(insight.confidence * 100).toFixed(1)}%</small>
               </div>`
            ).join('')}
        </div>`;
      
      case 'recommendations':
        return `
        <div class="section">
            <h2>${section.title}</h2>
            <p>Total Recommendations: ${section.summary.totalRecommendations}</p>
            ${section.recommendations.map((rec: Recommendation) => 
              `<div class="recommendation priority-${rec.priority}">
                 <h3>${rec.title}</h3>
                 <p>${rec.description}</p>
                 <p><strong>Priority:</strong> ${rec.priority} | 
                    <strong>Impact:</strong> ${rec.impact.performance}% performance, 
                    $${rec.impact.cost} cost, ${rec.impact.effort} effort</p>
               </div>`
            ).join('')}
        </div>`;
      
      default:
        return `<div class="section"><h2>${section.title}</h2><p>Content not available</p></div>`;
    }
  }

  getInsights(modelId?: string): Insight[] {
    if (modelId) {
      const results = this.results.get(modelId) || [];
      return results.flatMap(r => r.insights);
    }
    
    return Array.from(this.results.values())
      .flat()
      .flatMap(r => r.insights);
  }

  getRecommendations(category?: OptimizationCategory): Recommendation[] {
    const allRecommendations = Array.from(this.results.values())
      .flat()
      .flatMap(r => r.recommendations);
    
    if (category) {
      return allRecommendations.filter(r => r.category === category);
    }
    
    return allRecommendations;
  }
}

// Default configuration
export const defaultAnalyticsConfig: AnalyticsConfig = {
  dataSources: [
    {
      id: 'prometheus',
      type: 'prometheus',
      endpoint: 'http://localhost:9090',
      queryInterval: 30,
      retentionDays: 90
    },
    {
      id: 'mcp-metrics',
      type: 'metrics',
      endpoint: 'http://localhost:8080/metrics',
      queryInterval: 15,
      retentionDays: 30
    }
  ],
  models: [
    {
      id: 'trend-analysis',
      name: 'Performance Trend Analysis',
      type: 'trend-analysis',
      inputs: ['response_time', 'cpu_usage', 'memory_usage', 'error_rate'],
      outputs: ['performance_trend', 'degradation_risk'],
      parameters: { sensitivity: 0.1 },
      enabled: true
    },
    {
      id: 'anomaly-detection',
      name: 'Anomaly Detection',
      type: 'anomaly-detection',
      inputs: ['response_time', 'error_rate', 'throughput'],
      outputs: ['anomaly_score', 'anomaly_type'],
      parameters: { threshold: 2.5 },
      enabled: true
    },
    {
      id: 'capacity-forecasting',
      name: 'Capacity Forecasting',
      type: 'forecasting',
      inputs: ['cpu_usage', 'memory_usage', 'request_rate'],
      outputs: ['capacity_forecast', 'scaling_recommendation'],
      parameters: { horizon_days: 30 },
      enabled: true
    },
    {
      id: 'optimization-analysis',
      name: 'Optimization Opportunities',
      type: 'optimization',
      inputs: ['cpu_usage', 'memory_usage', 'workflow_efficiency', 'cost'],
      outputs: ['optimization_opportunities', 'cost_savings'],
      parameters: { threshold: 0.3 },
      enabled: true
    }
  ],
  reporting: {
    templates: [
      {
        id: 'executive-summary',
        name: 'Executive Performance Summary',
        type: 'executive',
        format: 'html',
        sections: [
          { id: 'metrics', title: 'Key Performance Indicators', type: 'metrics', config: {} },
          { id: 'analysis', title: 'Performance Analysis', type: 'analysis', config: {} },
          { id: 'recommendations', title: 'Optimization Recommendations', type: 'recommendations', config: {} }
        ]
      }
    ],
    schedules: [
      {
        id: 'daily-executive',
        templateId: 'executive-summary',
        frequency: 'daily',
        recipients: ['executives@company.com'],
        enabled: true
      }
    ],
    distribution: {
      email: { enabled: false },
      slack: { enabled: false },
      storage: { enabled: true, path: './reports' }
    }
  },
  predictions: {
    forecastingHorizon: 30,
    confidenceInterval: 95,
    models: {
      trendAnalysis: true,
      seasonalityDetection: true,
      anomalyPrediction: true,
      capacityForecasting: true
    }
  },
  optimization: {
    enabled: true,
    thresholds: {
      performanceDegradation: 10,
      resourceWaste: 30,
      costInefficiency: 20
    },
    recommendations: {
      autoGenerate: true,
      categories: [
        'performance-tuning',
        'resource-scaling',
        'workflow-optimization',
        'cost-reduction'
      ]
    }
  }
};

// Factory function
export function createAnalyticsEngine(config: Partial<AnalyticsConfig> = {}): AnalyticsEngine {
  const mergedConfig: AnalyticsConfig = {
    ...defaultAnalyticsConfig,
    ...config,
    predictions: {
      ...defaultAnalyticsConfig.predictions,
      ...config.predictions
    },
    optimization: {
      ...defaultAnalyticsConfig.optimization,
      ...config.optimization
    }
  };

  return new AnalyticsEngine(mergedConfig);
}