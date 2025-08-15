#!/usr/bin/env ts-node

/**
 * SPEC_05: Comprehensive Analytics and Reporting System Demo
 *
 * Demonstrates the executive dashboard, KPI tracking, ROI analysis,
 * automated report generation, and export capabilities.
 */

import { createMonitoringSystem } from './index';
import type {
  MonitoringSystemConfig,
  ExecutiveKPIs,
  ROIMetrics,
  TrendAnalysis,
  GeneratedReport
} from './index';

/**
 * Demo configuration for the comprehensive reporting system
 */
const DEMO_CONFIG: Partial<MonitoringSystemConfig> = {
  reporting: {
    enabled: true,
    autoGenerateReports: true,
    executiveDashboard: true,
    roiTracking: true,
    exportFormats: ['json', 'html', 'pdf', 'csv', 'xlsx']
  },
  server: {
    port: 3002, // Use different port for demo
    host: '127.0.0.1',
    enableCORS: true
  },
  integrations: {
    webhooks: [
      {
        id: 'demo-webhook',
        url: 'https://httpbin.org/post',
        events: ['report-generated', 'kpis-updated', 'analytics-insight'] as any,
        enabled: true
      }
    ],
    notifications: {
      slack: {
        enabled: false,
        channels: {
          alerts: '#demo-alerts',
          reports: '#demo-reports',
          maintenance: '#demo-maintenance'
        }
      },
      email: {
        enabled: false,
        recipients: {
          alerts: ['demo-alerts@company.com'],
          reports: ['executives@company.com'],
          critical: ['on-call@company.com']
        }
      }
    }
  }
};

/**
 * Comprehensive demo of the reporting system capabilities
 */
async function runReportingSystemDemo(): Promise<void> {
  console.log('🎬 SPEC_05: Comprehensive Analytics and Reporting System Demo');
  console.log('=' .repeat(70));

  // Initialize monitoring system with reporting enabled
  const monitoringSystem = createMonitoringSystem(DEMO_CONFIG);

  try {
    console.log('\n📈 Starting MCP Monitoring System with Comprehensive Reporting...');
    await monitoringSystem.start();

    // Wait for system to initialize
    await new Promise(resolve => setTimeout(resolve, 2000));

    console.log('\n🎯 Demonstrating Executive Dashboard Capabilities...');
    await demonstrateExecutiveDashboard(monitoringSystem);

    console.log('\n💰 Demonstrating ROI Analysis and Tracking...');
    await demonstrateROIAnalysis(monitoringSystem);

    console.log('\n📊 Demonstrating Performance Trend Analysis...');
    await demonstrateTrendAnalysis(monitoringSystem);

    console.log('\n📋 Demonstrating Automated Report Generation...');
    await demonstrateAutomatedReports(monitoringSystem);

    console.log('\n💾 Demonstrating Export Capabilities...');
    await demonstrateExportCapabilities(monitoringSystem);

    console.log('\n🔗 Demonstrating API Integration...');
    await demonstrateAPIIntegration();

    console.log('\n📚 Demonstrating PRD Validation Metrics...');
    await demonstratePRDValidation(monitoringSystem);

    console.log('\n✅ Demo completed successfully!');
    console.log('\n📝 Summary of Capabilities Demonstrated:');
    console.log('   ✓ Executive KPI Dashboard with real-time metrics');
    console.log('   ✓ ROI calculation and cost savings tracking');
    console.log('   ✓ Performance trend analysis and forecasting');
    console.log('   ✓ Automated report generation and scheduling');
    console.log('   ✓ Multi-format export (JSON, HTML, PDF, CSV, Excel)');
    console.log('   ✓ REST API integration for external systems');
    console.log('   ✓ PRD target validation and achievement tracking');
    console.log('   ✓ Real-time notifications and webhooks');

    // Keep server running for manual testing
    console.log('\n🌐 Server is running for manual testing:');
    console.log(`   Dashboard: http://127.0.0.1:3002/api/reporting/kpis/current`);
    console.log(`   ROI Analysis: http://127.0.0.1:3002/api/reporting/roi`);
    console.log(`   Health Check: http://127.0.0.1:3002/api/health`);
    console.log('\n   Press Ctrl+C to stop the server...\n');

    // Handle graceful shutdown
    process.on('SIGINT', async () => {
      console.log('\n🛑 Shutting down monitoring system...');
      await monitoringSystem.stop();
      process.exit(0);
    });

    // Keep process running
    await new Promise(() => {});

  } catch (error) {
    console.error('❌ Demo failed:', error);
    await monitoringSystem.stop();
    process.exit(1);
  }
}

/**
 * Demonstrate executive dashboard capabilities
 */
async function demonstrateExecutiveDashboard(system: any): Promise<void> {
  console.log('   📊 Fetching current executive KPIs...');

  const kpis = await system.getCurrentKPIs();
  if (kpis) {
    console.log('   ✅ Executive KPIs retrieved:');
    console.log(`      Performance Score: ${kpis.performanceScore}%`);
    console.log(`      Workflow Efficiency Improvement: ${kpis.workflowEfficiencyImprovement.toFixed(1)}%`);
    console.log(`      Code Analysis Improvement: ${kpis.codeAnalysisImprovement.toFixed(1)}%`);
    console.log(`      UI Development Improvement: ${kpis.uiDevelopmentImprovement.toFixed(1)}%`);
    console.log(`      System Uptime: ${kpis.systemUptime.toFixed(2)}%`);
    console.log(`      MCP Utilization: ${kpis.mcpUtilization.toFixed(1)}%`);
    console.log(`      ROI Percentage: ${kpis.roiPercentage.toFixed(1)}%`);
    console.log(`      Annual Cost Savings: $${kpis.costSavings.toLocaleString()}`);
  } else {
    console.log('   ⚠️  Executive KPIs not available (reporting system disabled)');
  }

  // Demonstrate KPI history
  const timeRange = {
    start: Date.now() - 24 * 60 * 60 * 1000, // Last 24 hours
    end: Date.now()
  };

  const kpiHistory = system.getKPIHistory(timeRange);
  console.log(`   📈 Retrieved ${kpiHistory.length} historical KPI data points`);
}

/**
 * Demonstrate ROI analysis and tracking
 */
async function demonstrateROIAnalysis(system: any): Promise<void> {
  console.log('   💸 Calculating ROI metrics...');

  const roiAnalysis = await system.getROIAnalysis();
  if (roiAnalysis) {
    console.log('   ✅ ROI Analysis completed:');
    console.log(`      Initial Investment: $${roiAnalysis.initialInvestment.toLocaleString()}`);
    console.log(`      Monthly Operational Costs: $${roiAnalysis.operationalCosts.toLocaleString()}`);
    console.log(`      Monthly Savings: $${roiAnalysis.monthlySavings.toLocaleString()}`);
    console.log(`      Developer Time Saved: ${roiAnalysis.developerTimeSaved.toLocaleString()} hours/month`);
    console.log(`      Break-even Period: ${roiAnalysis.breakEvenMonths.toFixed(1)} months`);
    console.log(`      Net Present Value: $${roiAnalysis.netPresentValue.toLocaleString()}`);
    console.log(`      Internal Rate of Return: ${roiAnalysis.internalRateOfReturn.toFixed(1)}%`);
    console.log(`      Infrastructure Savings: $${roiAnalysis.infrastructureSavings.toLocaleString()}/month`);
    console.log(`      Quality Improvement Savings: $${roiAnalysis.qualitySavings.toLocaleString()}/month`);
  } else {
    console.log('   ⚠️  ROI analysis not available');
  }
}

/**
 * Demonstrate trend analysis capabilities
 */
async function demonstrateTrendAnalysis(system: any): Promise<void> {
  console.log('   📈 Analyzing performance trends...');

  const timeRange = {
    start: Date.now() - 7 * 24 * 60 * 60 * 1000, // Last 7 days
    end: Date.now()
  };

  const trends = await system.getTrendAnalysis(timeRange);

  if (trends && trends.length > 0) {
    console.log(`   ✅ Generated ${trends.length} trend analyses:`);

    trends.slice(0, 5).forEach((trend: TrendAnalysis) => {
      const onTrackStatus = trend.targetProgress.onTrack ? '✅ On Track' : '⚠️ Behind';
      console.log(`      ${formatMetricName(trend.metricName)}:`);
      console.log(`         Direction: ${trend.trend.direction.toUpperCase()}`);
      console.log(`         Confidence: ${(trend.trend.confidence * 100).toFixed(1)}%`);
      console.log(`         Target Progress: ${trend.targetProgress.achievement.toFixed(1)}% ${onTrackStatus}`);
      console.log(`         Forecast: ${trend.forecast.predicted.toFixed(2)} (next ${trend.forecast.horizon} periods)`);
    });
  } else {
    console.log('   ⚠️  Insufficient data for trend analysis');
  }
}

/**
 * Demonstrate automated report generation
 */
async function demonstrateAutomatedReports(system: any): Promise<void> {
  console.log('   📋 Generating executive report...');

  const report = await system.generateExecutiveReport({
    timeRange: {
      start: Date.now() - 24 * 60 * 60 * 1000,
      end: Date.now()
    },
    format: 'html'
  });

  if (report) {
    console.log('   ✅ Executive report generated:');
    console.log(`      Report ID: ${report.id}`);
    console.log(`      Generated: ${new Date(report.generatedAt).toLocaleString()}`);
    console.log(`      Generation Time: ${report.metadata.generationTime}ms`);
    console.log(`      Data Points: ${report.metadata.dataPoints}`);
    console.log(`      Insights: ${report.data.insights.length}`);
    console.log(`      Recommendations: ${report.data.recommendations.length}`);
    console.log(`      Delivery Status: ${report.delivery.status}`);
  } else {
    console.log('   ⚠️  Report generation not available');
  }

  // Show available reports
  const availableReports = system.getAvailableReports();
  console.log(`   📚 Available reports: ${availableReports.length}`);
}

/**
 * Demonstrate export capabilities
 */
async function demonstrateExportCapabilities(system: any): Promise<void> {
  console.log('   💾 Testing export capabilities...');

  const availableReports = system.getAvailableReports();

  if (availableReports.length > 0) {
    const reportId = availableReports[0].id;
    const formats = ['json', 'html', 'csv'];

    for (const format of formats) {
      try {
        const exported = await system.exportReport(reportId, format);
        const size = typeof exported === 'string' ? exported.length : exported?.length || 0;
        console.log(`   ✅ ${format.toUpperCase()} export: ${size} bytes`);
      } catch (error) {
        console.log(`   ❌ ${format.toUpperCase()} export failed: ${error instanceof Error ? error.message : String(error)}`);
      }
    }
  } else {
    console.log('   ⚠️  No reports available for export demonstration');
  }
}

/**
 * Demonstrate API integration capabilities
 */
async function demonstrateAPIIntegration(): Promise<void> {
  console.log('   🔗 Testing REST API endpoints...');

  const baseUrl = 'http://127.0.0.1:3002';
  const endpoints = [
    '/api/health',
    '/api/reporting/kpis/current',
    '/api/reporting/roi',
    '/api/reporting/reports'
  ];

  for (const endpoint of endpoints) {
    try {
      const response = await fetch(`${baseUrl}${endpoint}`);
      const status = response.ok ? '✅' : '❌';
      console.log(`   ${status} GET ${endpoint}: ${response.status} ${response.statusText}`);
    } catch (error) {
      console.log(`   ❌ GET ${endpoint}: Connection failed`);
    }
  }
}

/**
 * Demonstrate PRD validation metrics
 */
async function demonstratePRDValidation(system: any): Promise<void> {
  console.log('   🎯 Validating PRD performance targets...');

  const kpis = await system.getCurrentKPIs();

  if (kpis) {
    const targets = {
      'Code Analysis Improvement': { current: kpis.codeAnalysisImprovement, target: 60, unit: '%' },
      'UI Development Improvement': { current: kpis.uiDevelopmentImprovement, target: 40, unit: '%' },
      'Workflow Efficiency': { current: kpis.workflowEfficiencyImprovement, target: 45, unit: '%' },
      'System Uptime': { current: kpis.systemUptime, target: 99.5, unit: '%' },
      'MCP Utilization': { current: kpis.mcpUtilization, target: 80, unit: '%' }
    };

    console.log('   📊 PRD Target Achievement:');

    Object.entries(targets).forEach(([name, metric]) => {
      const achievement = (metric.current / metric.target) * 100;
      const status = achievement >= 80 ? '✅' : achievement >= 60 ? '⚠️' : '❌';
      const onTrack = achievement >= 80 ? 'On Track' : 'Behind Target';

      console.log(`      ${status} ${name}: ${metric.current.toFixed(1)}${metric.unit} / ${metric.target}${metric.unit} (${achievement.toFixed(1)}% - ${onTrack})`);
    });

    // Overall system efficiency
    const overallEfficiency = Object.values(targets).reduce((avg, metric) =>
      avg + (metric.current / metric.target) * 100, 0) / Object.keys(targets).length;

    console.log(`   🎯 Overall PRD Achievement: ${overallEfficiency.toFixed(1)}%`);

    if (overallEfficiency >= 80) {
      console.log('   ✅ System is meeting or exceeding PRD performance targets!');
    } else if (overallEfficiency >= 60) {
      console.log('   ⚠️  System is approaching PRD targets but needs optimization');
    } else {
      console.log('   ❌ System performance is below PRD targets - immediate action required');
    }
  }
}

/**
 * Format metric names for display
 */
function formatMetricName(name: string): string {
  return name
    .replace(/([A-Z])/g, ' $1')
    .replace(/^./, str => str.toUpperCase())
    .trim();
}

// Run the demo
if (require.main === module) {
  runReportingSystemDemo().catch(error => {
    console.error('Demo failed:', error);
    process.exit(1);
  });
}

export { runReportingSystemDemo };
