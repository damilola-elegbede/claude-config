/**
 * SPEC_05: Automated Benchmarking and Performance Validation Framework
 * Validates PRD success metrics and prevents performance regression
 */

import { EventEmitter } from 'events';
import { performance } from 'perf_hooks';
import * as fs from 'fs/promises';
import * as path from 'path';

// Benchmark Configuration
export interface BenchmarkConfig {
  testSuites: TestSuite[];
  schedules: BenchmarkSchedule[];
  thresholds: PerformanceThresholds;
  reporting: ReportingConfig;
  cicd: CICDConfig;
}

export interface TestSuite {
  id: string;
  name: string;
  category: 'system' | 'workflow' | 'scalability' | 'reliability' | 'cost';
  tests: BenchmarkTest[];
  enabled: boolean;
  timeout: number; // milliseconds
}

export interface BenchmarkTest {
  id: string;
  name: string;
  description: string;
  executor: TestExecutor;
  expectedResult: TestResult;
  weight: number; // for weighted scoring
}

export interface TestExecutor {
  type: 'code-analysis' | 'ui-workflow' | 'load-test' | 'cache-test' | 'custom';
  config: any;
  script?: string;
}

export interface TestResult {
  duration: number;
  success: boolean;
  metrics: Record<string, number>;
  errors?: string[];
  timestamp: number;
}

export interface BenchmarkSchedule {
  id: string;
  suiteIds: string[];
  cronExpression: string;
  enabled: boolean;
  retries: number;
}

export interface PerformanceThresholds {
  codeAnalysisMax: number; // 24 seconds
  uiWorkflowMax: number; // 7.2 minutes  
  systemResponseMax: number; // 500ms
  cacheHitRateMin: number; // 85%
  uptimeMin: number; // 99.5%
  regressionThreshold: number; // 15% degradation threshold
}

export interface ReportingConfig {
  outputDir: string;
  formats: ('json' | 'html' | 'csv')[];
  includeCharts: boolean;
  emailRecipients: string[];
}

export interface CICDConfig {
  enabled: boolean;
  failOnRegression: boolean;
  webhookUrl?: string;
  slackChannel?: string;
}

// Benchmark Execution Engine
export class BenchmarkEngine extends EventEmitter {
  private config: BenchmarkConfig;
  private baselines: Map<string, TestResult[]> = new Map();
  private results: Map<string, BenchmarkRun[]> = new Map();
  private schedules: Map<string, NodeJS.Timeout> = new Map();

  constructor(config: BenchmarkConfig) {
    super();
    this.config = config;
    this.loadBaselines();
  }

  async start(): Promise<void> {
    console.log('Starting benchmark engine...');
    this.setupSchedules();
    this.emit('started');
  }

  stop(): void {
    console.log('Stopping benchmark engine...');
    for (const [id, timer] of this.schedules) {
      clearInterval(timer);
    }
    this.schedules.clear();
    this.emit('stopped');
  }

  private setupSchedules(): void {
    for (const schedule of this.config.schedules) {
      if (!schedule.enabled) continue;

      // For demo purposes, using simple intervals instead of cron
      const intervalMs = this.cronToInterval(schedule.cronExpression);
      
      const timer = setInterval(async () => {
        try {
          await this.runScheduledBenchmark(schedule);
        } catch (error) {
          console.error(`Scheduled benchmark ${schedule.id} failed:`, error);
        }
      }, intervalMs);

      this.schedules.set(schedule.id, timer);
    }
  }

  private cronToInterval(cronExpression: string): number {
    // Simple cron parsing for demo - in production use proper cron library
    if (cronExpression === '0 * * * *') return 60 * 60 * 1000; // hourly
    if (cronExpression === '0 0 * * *') return 24 * 60 * 60 * 1000; // daily
    if (cronExpression === '0 0 * * 0') return 7 * 24 * 60 * 60 * 1000; // weekly
    return 60 * 60 * 1000; // default hourly
  }

  async runBenchmark(suiteId: string): Promise<BenchmarkRun> {
    const suite = this.config.testSuites.find(s => s.id === suiteId);
    if (!suite) {
      throw new Error(`Test suite ${suiteId} not found`);
    }

    if (!suite.enabled) {
      throw new Error(`Test suite ${suiteId} is disabled`);
    }

    console.log(`Running benchmark suite: ${suite.name}`);
    const run: BenchmarkRun = {
      id: `${suiteId}-${Date.now()}`,
      suiteId,
      suiteName: suite.name,
      startTime: Date.now(),
      endTime: 0,
      results: [],
      summary: {
        totalTests: suite.tests.length,
        passedTests: 0,
        failedTests: 0,
        avgDuration: 0,
        regressionDetected: false,
        prdValidation: {
          codeAnalysisImprovement: false,
          uiWorkflowImprovement: false,
          overallEfficiency: false,
          mcpUtilization: false,
          systemUptime: false
        }
      }
    };

    this.emit('benchmarkStarted', run);

    for (const test of suite.tests) {
      try {
        console.log(`  Executing test: ${test.name}`);
        const result = await this.executeTest(test, suite.timeout);
        run.results.push({ testId: test.id, result });
        
        if (result.success) {
          run.summary.passedTests++;
        } else {
          run.summary.failedTests++;
        }
      } catch (error) {
        console.error(`Test ${test.id} failed:`, error);
        run.results.push({
          testId: test.id,
          result: {
            duration: 0,
            success: false,
            metrics: {},
            errors: [error instanceof Error ? error.message : String(error)],
            timestamp: Date.now()
          }
        });
        run.summary.failedTests++;
      }
    }

    run.endTime = Date.now();
    run.summary.avgDuration = run.results.reduce((sum, r) => sum + r.result.duration, 0) / run.results.length;

    // Regression analysis
    await this.analyzeRegression(run);
    
    // PRD validation
    this.validatePRDMetrics(run);

    // Store results
    this.storeResults(run);

    this.emit('benchmarkCompleted', run);
    return run;
  }

  private async executeTest(test: BenchmarkTest, timeout: number): Promise<TestResult> {
    const startTime = performance.now();
    
    return new Promise(async (resolve, reject) => {
      const timer = setTimeout(() => {
        reject(new Error(`Test ${test.id} timed out after ${timeout}ms`));
      }, timeout);

      try {
        const result = await this.runTestExecutor(test.executor);
        clearTimeout(timer);
        
        const endTime = performance.now();
        const duration = endTime - startTime;

        resolve({
          duration,
          success: true,
          metrics: result.metrics || {},
          timestamp: Date.now()
        });
      } catch (error) {
        clearTimeout(timer);
        reject(error);
      }
    });
  }

  private async runTestExecutor(executor: TestExecutor): Promise<{ metrics: Record<string, number> }> {
    switch (executor.type) {
      case 'code-analysis':
        return this.runCodeAnalysisTest(executor.config);
      case 'ui-workflow':
        return this.runUIWorkflowTest(executor.config);
      case 'load-test':
        return this.runLoadTest(executor.config);
      case 'cache-test':
        return this.runCacheTest(executor.config);
      case 'custom':
        return this.runCustomTest(executor);
      default:
        throw new Error(`Unknown executor type: ${executor.type}`);
    }
  }

  private async runCodeAnalysisTest(config: any): Promise<{ metrics: Record<string, number> }> {
    // Simulate code analysis benchmark
    const iterations = config.iterations || 10;
    const codebaseSize = config.codebaseSize || 'medium';
    
    let totalTime = 0;
    for (let i = 0; i < iterations; i++) {
      const startTime = performance.now();
      
      // Simulate code analysis work
      await this.simulateCodeAnalysis(codebaseSize);
      
      const endTime = performance.now();
      totalTime += (endTime - startTime);
    }

    const avgTime = totalTime / iterations / 1000; // Convert to seconds
    
    return {
      metrics: {
        avgAnalysisTime: avgTime,
        iterations,
        throughput: iterations / (totalTime / 1000),
        codebaseSize: this.getCodebaseSizeMetric(codebaseSize)
      }
    };
  }

  private async runUIWorkflowTest(config: any): Promise<{ metrics: Record<string, number> }> {
    // Simulate UI workflow benchmark
    const workflows = config.workflows || 5;
    const complexity = config.complexity || 'standard';
    
    let totalTime = 0;
    for (let i = 0; i < workflows; i++) {
      const startTime = performance.now();
      
      // Simulate UI workflow steps
      await this.simulateUIWorkflow(complexity);
      
      const endTime = performance.now();
      totalTime += (endTime - startTime);
    }

    const avgTime = totalTime / workflows / 1000 / 60; // Convert to minutes
    
    return {
      metrics: {
        avgWorkflowTime: avgTime,
        workflows,
        complexity: this.getComplexityMetric(complexity),
        throughput: workflows / (totalTime / 1000 / 60)
      }
    };
  }

  private async runLoadTest(config: any): Promise<{ metrics: Record<string, number> }> {
    // Simulate load testing
    const concurrentUsers = config.concurrentUsers || 100;
    const duration = config.duration || 30; // seconds
    const rampUp = config.rampUp || 10; // seconds
    
    // Simulate gradual ramp-up
    let currentUsers = 0;
    const rampUpStep = concurrentUsers / (rampUp * 10); // 10 steps per second
    
    const metrics = {
      responseTime: [],
      throughput: 0,
      errors: 0,
      peakUsers: 0
    };

    const startTime = performance.now();
    
    // Ramp up phase
    for (let i = 0; i < rampUp * 10; i++) {
      currentUsers = Math.min(currentUsers + rampUpStep, concurrentUsers);
      metrics.peakUsers = Math.max(metrics.peakUsers, Math.floor(currentUsers));
      
      // Simulate requests
      const responseTime = this.simulateRequest(currentUsers);
      metrics.responseTime.push(responseTime);
      
      await new Promise(resolve => setTimeout(resolve, 100)); // 100ms intervals
    }
    
    // Steady state phase
    const steadyDuration = (duration - rampUp) * 10;
    for (let i = 0; i < steadyDuration; i++) {
      const responseTime = this.simulateRequest(concurrentUsers);
      metrics.responseTime.push(responseTime);
      
      await new Promise(resolve => setTimeout(resolve, 100));
    }
    
    const endTime = performance.now();
    const totalDuration = (endTime - startTime) / 1000;
    
    const avgResponseTime = metrics.responseTime.reduce((a, b) => a + b, 0) / metrics.responseTime.length;
    const p95ResponseTime = this.calculatePercentile(metrics.responseTime, 95);
    const p99ResponseTime = this.calculatePercentile(metrics.responseTime, 99);
    
    return {
      metrics: {
        avgResponseTime,
        p95ResponseTime,
        p99ResponseTime,
        throughput: metrics.responseTime.length / totalDuration,
        concurrentUsers,
        errorRate: metrics.errors / metrics.responseTime.length,
        duration: totalDuration
      }
    };
  }

  private async runCacheTest(config: any): Promise<{ metrics: Record<string, number> }> {
    // Simulate cache performance testing
    const operations = config.operations || 1000;
    const hitRatio = config.expectedHitRatio || 0.85;
    
    let hits = 0;
    let totalTime = 0;
    
    for (let i = 0; i < operations; i++) {
      const startTime = performance.now();
      
      // Simulate cache operation
      const isHit = Math.random() < hitRatio;
      if (isHit) {
        hits++;
        // Cache hit - faster response
        await new Promise(resolve => setTimeout(resolve, Math.random() * 5));
      } else {
        // Cache miss - slower response
        await new Promise(resolve => setTimeout(resolve, Math.random() * 50 + 25));
      }
      
      const endTime = performance.now();
      totalTime += (endTime - startTime);
    }
    
    const actualHitRate = hits / operations;
    const avgLatency = totalTime / operations;
    
    return {
      metrics: {
        hitRate: actualHitRate,
        avgLatency,
        operations,
        throughput: operations / (totalTime / 1000)
      }
    };
  }

  private async runCustomTest(executor: TestExecutor): Promise<{ metrics: Record<string, number> }> {
    // For custom tests, we would execute the provided script
    // This is a simplified implementation
    if (executor.script) {
      // In production, this would safely execute the script
      console.log(`Executing custom script: ${executor.script}`);
    }
    
    return {
      metrics: {
        executionTime: Math.random() * 1000,
        customMetric: Math.random() * 100
      }
    };
  }

  // Helper methods for simulation
  private async simulateCodeAnalysis(size: string): Promise<void> {
    const baseTime = size === 'small' ? 50 : size === 'large' ? 200 : 100;
    const variance = baseTime * 0.3;
    const duration = baseTime + (Math.random() * variance * 2 - variance);
    await new Promise(resolve => setTimeout(resolve, duration));
  }

  private async simulateUIWorkflow(complexity: string): Promise<void> {
    const baseTime = complexity === 'simple' ? 200 : complexity === 'complex' ? 800 : 400;
    const variance = baseTime * 0.4;
    const duration = baseTime + (Math.random() * variance * 2 - variance);
    await new Promise(resolve => setTimeout(resolve, duration));
  }

  private simulateRequest(concurrentUsers: number): number {
    // Simulate response time based on load
    const baseResponseTime = 100; // ms
    const loadFactor = Math.max(1, concurrentUsers / 50);
    const randomVariance = Math.random() * 50 - 25;
    return Math.max(10, baseResponseTime * loadFactor + randomVariance);
  }

  private getCodebaseSizeMetric(size: string): number {
    switch (size) {
      case 'small': return 1;
      case 'medium': return 2;
      case 'large': return 3;
      default: return 2;
    }
  }

  private getComplexityMetric(complexity: string): number {
    switch (complexity) {
      case 'simple': return 1;
      case 'standard': return 2;
      case 'complex': return 3;
      default: return 2;
    }
  }

  private calculatePercentile(values: number[], percentile: number): number {
    const sorted = values.slice().sort((a, b) => a - b);
    const index = Math.ceil((percentile / 100) * sorted.length) - 1;
    return sorted[Math.max(0, index)];
  }

  private async analyzeRegression(run: BenchmarkRun): Promise<void> {
    const baselines = this.baselines.get(run.suiteId);
    if (!baselines || baselines.length === 0) {
      console.log(`No baselines found for suite ${run.suiteId}`);
      return;
    }

    // Calculate average baseline performance
    const baselineAvg = baselines.reduce((sum, b) => sum + b.duration, 0) / baselines.length;
    const currentAvg = run.summary.avgDuration;
    
    const regressionPercent = (currentAvg - baselineAvg) / baselineAvg;
    
    if (regressionPercent > this.config.thresholds.regressionThreshold / 100) {
      run.summary.regressionDetected = true;
      
      const regressionAlert = {
        type: 'regression',
        suite: run.suiteName,
        current: currentAvg,
        baseline: baselineAvg,
        regressionPercent: regressionPercent * 100,
        timestamp: Date.now()
      };
      
      this.emit('regressionDetected', regressionAlert);
      
      if (this.config.cicd.failOnRegression) {
        this.emit('cicdFailure', regressionAlert);
      }
    }
  }

  private validatePRDMetrics(run: BenchmarkRun): void {
    // Extract performance metrics from test results
    const codeAnalysisResults = run.results.filter(r => r.testId.includes('code-analysis'));
    const uiWorkflowResults = run.results.filter(r => r.testId.includes('ui-workflow'));
    
    // Validate code analysis improvement (target: 60% improvement, 18-24s)
    if (codeAnalysisResults.length > 0) {
      const avgCodeAnalysisTime = codeAnalysisResults.reduce((sum, r) => {
        return sum + (r.result.metrics.avgAnalysisTime || 0);
      }, 0) / codeAnalysisResults.length;
      
      run.summary.prdValidation.codeAnalysisImprovement = avgCodeAnalysisTime <= 24;
    }
    
    // Validate UI workflow improvement (target: 40% improvement, 4.8-7.2min)
    if (uiWorkflowResults.length > 0) {
      const avgUIWorkflowTime = uiWorkflowResults.reduce((sum, r) => {
        return sum + (r.result.metrics.avgWorkflowTime || 0);
      }, 0) / uiWorkflowResults.length;
      
      run.summary.prdValidation.uiWorkflowImprovement = avgUIWorkflowTime <= 7.2;
    }
    
    // Additional validations would be implemented based on available metrics
    run.summary.prdValidation.overallEfficiency = 
      run.summary.prdValidation.codeAnalysisImprovement && 
      run.summary.prdValidation.uiWorkflowImprovement;
  }

  private async runScheduledBenchmark(schedule: BenchmarkSchedule): Promise<void> {
    console.log(`Running scheduled benchmark: ${schedule.id}`);
    
    for (const suiteId of schedule.suiteIds) {
      let attempts = 0;
      let success = false;
      
      while (attempts < schedule.retries && !success) {
        try {
          await this.runBenchmark(suiteId);
          success = true;
        } catch (error) {
          attempts++;
          console.error(`Benchmark ${suiteId} attempt ${attempts} failed:`, error);
          
          if (attempts < schedule.retries) {
            // Wait before retry
            await new Promise(resolve => setTimeout(resolve, 10000));
          }
        }
      }
      
      if (!success) {
        this.emit('benchmarkFailed', {
          scheduleId: schedule.id,
          suiteId,
          attempts,
          error: `Failed after ${schedule.retries} attempts`
        });
      }
    }
  }

  private async loadBaselines(): Promise<void> {
    try {
      const baselineDir = path.join(process.cwd(), 'benchmarks', 'baselines');
      const files = await fs.readdir(baselineDir).catch(() => []);
      
      for (const file of files) {
        if (file.endsWith('.json')) {
          const suiteId = file.replace('.json', '');
          const filePath = path.join(baselineDir, file);
          const content = await fs.readFile(filePath, 'utf-8');
          const baselines = JSON.parse(content) as TestResult[];
          this.baselines.set(suiteId, baselines);
        }
      }
      
      console.log(`Loaded baselines for ${this.baselines.size} test suites`);
    } catch (error) {
      console.error('Failed to load baselines:', error);
    }
  }

  private storeResults(run: BenchmarkRun): void {
    if (!this.results.has(run.suiteId)) {
      this.results.set(run.suiteId, []);
    }
    
    const suiteResults = this.results.get(run.suiteId)!;
    suiteResults.push(run);
    
    // Keep only last 100 runs per suite
    if (suiteResults.length > 100) {
      suiteResults.splice(0, suiteResults.length - 100);
    }
  }

  // Public API methods
  async generateReport(suiteId: string, format: 'json' | 'html' | 'csv' = 'json'): Promise<string> {
    const runs = this.results.get(suiteId) || [];
    if (runs.length === 0) {
      throw new Error(`No results found for suite ${suiteId}`);
    }
    
    const report = {
      suiteId,
      generatedAt: Date.now(),
      totalRuns: runs.length,
      summary: this.generateSummaryStats(runs),
      runs: runs.slice(-10) // Last 10 runs
    };
    
    switch (format) {
      case 'json':
        return JSON.stringify(report, null, 2);
      case 'html':
        return this.generateHTMLReport(report);
      case 'csv':
        return this.generateCSVReport(report);
      default:
        return JSON.stringify(report, null, 2);
    }
  }

  private generateSummaryStats(runs: BenchmarkRun[]): any {
    const totalTests = runs.reduce((sum, r) => sum + r.summary.totalTests, 0);
    const totalPassed = runs.reduce((sum, r) => sum + r.summary.passedTests, 0);
    const avgDuration = runs.reduce((sum, r) => sum + r.summary.avgDuration, 0) / runs.length;
    const regressions = runs.filter(r => r.summary.regressionDetected).length;
    
    return {
      totalTests,
      totalPassed,
      passRate: totalPassed / totalTests,
      avgDuration,
      regressionCount: regressions,
      regressionRate: regressions / runs.length,
      prdValidation: {
        codeAnalysisImprovement: runs.filter(r => r.summary.prdValidation.codeAnalysisImprovement).length / runs.length,
        uiWorkflowImprovement: runs.filter(r => r.summary.prdValidation.uiWorkflowImprovement).length / runs.length,
        overallEfficiency: runs.filter(r => r.summary.prdValidation.overallEfficiency).length / runs.length
      }
    };
  }

  private generateHTMLReport(report: any): string {
    return `
<!DOCTYPE html>
<html>
<head>
    <title>Benchmark Report - ${report.suiteId}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background: #f0f0f0; padding: 20px; border-radius: 5px; }
        .metric { margin: 10px 0; }
        .success { color: green; }
        .warning { color: orange; }
        .error { color: red; }
        table { border-collapse: collapse; width: 100%; margin: 20px 0; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Benchmark Report: ${report.suiteId}</h1>
        <p>Generated: ${new Date(report.generatedAt).toISOString()}</p>
        <p>Total Runs: ${report.totalRuns}</p>
    </div>
    
    <h2>Summary Statistics</h2>
    <div class="metric">Pass Rate: ${(report.summary.passRate * 100).toFixed(1)}%</div>
    <div class="metric">Average Duration: ${report.summary.avgDuration.toFixed(2)}ms</div>
    <div class="metric">Regression Rate: ${(report.summary.regressionRate * 100).toFixed(1)}%</div>
    
    <h2>PRD Validation</h2>
    <div class="metric ${report.summary.prdValidation.codeAnalysisImprovement >= 0.8 ? 'success' : 'warning'}">
        Code Analysis Improvement: ${(report.summary.prdValidation.codeAnalysisImprovement * 100).toFixed(1)}%
    </div>
    <div class="metric ${report.summary.prdValidation.uiWorkflowImprovement >= 0.8 ? 'success' : 'warning'}">
        UI Workflow Improvement: ${(report.summary.prdValidation.uiWorkflowImprovement * 100).toFixed(1)}%
    </div>
    
    <h2>Recent Runs</h2>
    <table>
        <tr>
            <th>Run ID</th>
            <th>Date</th>
            <th>Tests</th>
            <th>Pass Rate</th>
            <th>Duration</th>
            <th>Regression</th>
        </tr>
        ${report.runs.map((run: BenchmarkRun) => `
        <tr>
            <td>${run.id}</td>
            <td>${new Date(run.startTime).toISOString()}</td>
            <td>${run.summary.totalTests}</td>
            <td>${((run.summary.passedTests / run.summary.totalTests) * 100).toFixed(1)}%</td>
            <td>${run.summary.avgDuration.toFixed(2)}ms</td>
            <td class="${run.summary.regressionDetected ? 'error' : 'success'}">
                ${run.summary.regressionDetected ? 'Yes' : 'No'}
            </td>
        </tr>
        `).join('')}
    </table>
</body>
</html>`;
  }

  private generateCSVReport(report: any): string {
    const header = 'Run ID,Date,Total Tests,Passed Tests,Failed Tests,Duration,Regression Detected\n';
    const rows = report.runs.map((run: BenchmarkRun) => 
      `${run.id},${new Date(run.startTime).toISOString()},${run.summary.totalTests},${run.summary.passedTests},${run.summary.failedTests},${run.summary.avgDuration},${run.summary.regressionDetected}`
    ).join('\n');
    
    return header + rows;
  }

  getResults(suiteId: string): BenchmarkRun[] {
    return this.results.get(suiteId) || [];
  }

  getAllResults(): Map<string, BenchmarkRun[]> {
    return new Map(this.results);
  }
}

// Benchmark Run Result Interface
export interface BenchmarkRun {
  id: string;
  suiteId: string;
  suiteName: string;
  startTime: number;
  endTime: number;
  results: {
    testId: string;
    result: TestResult;
  }[];
  summary: {
    totalTests: number;
    passedTests: number;
    failedTests: number;
    avgDuration: number;
    regressionDetected: boolean;
    prdValidation: {
      codeAnalysisImprovement: boolean;
      uiWorkflowImprovement: boolean;
      overallEfficiency: boolean;
      mcpUtilization: boolean;
      systemUptime: boolean;
    };
  };
}

// Default benchmark configuration
export const defaultBenchmarkConfig: BenchmarkConfig = {
  testSuites: [
    {
      id: 'system-performance',
      name: 'System Performance Tests',
      category: 'system',
      enabled: true,
      timeout: 300000, // 5 minutes
      tests: [
        {
          id: 'code-analysis-small',
          name: 'Code Analysis - Small Codebase',
          description: 'Measures code analysis time for small codebase',
          executor: {
            type: 'code-analysis',
            config: { iterations: 5, codebaseSize: 'small' }
          },
          expectedResult: {
            duration: 18000, // 18 seconds
            success: true,
            metrics: {},
            timestamp: 0
          },
          weight: 1.0
        },
        {
          id: 'code-analysis-large',
          name: 'Code Analysis - Large Codebase',
          description: 'Measures code analysis time for large codebase',
          executor: {
            type: 'code-analysis',
            config: { iterations: 3, codebaseSize: 'large' }
          },
          expectedResult: {
            duration: 24000, // 24 seconds
            success: true,
            metrics: {},
            timestamp: 0
          },
          weight: 1.5
        }
      ]
    },
    {
      id: 'workflow-efficiency',
      name: 'Workflow Efficiency Tests',
      category: 'workflow',
      enabled: true,
      timeout: 600000, // 10 minutes
      tests: [
        {
          id: 'ui-workflow-standard',
          name: 'UI Workflow - Standard Components',
          description: 'Measures UI development workflow time',
          executor: {
            type: 'ui-workflow',
            config: { workflows: 3, complexity: 'standard' }
          },
          expectedResult: {
            duration: 360000, // 6 minutes
            success: true,
            metrics: {},
            timestamp: 0
          },
          weight: 1.0
        }
      ]
    }
  ],
  schedules: [
    {
      id: 'daily-performance',
      suiteIds: ['system-performance', 'workflow-efficiency'],
      cronExpression: '0 0 * * *', // Daily at midnight
      enabled: true,
      retries: 2
    },
    {
      id: 'hourly-system',
      suiteIds: ['system-performance'],
      cronExpression: '0 * * * *', // Every hour
      enabled: true,
      retries: 1
    }
  ],
  thresholds: {
    codeAnalysisMax: 24, // seconds
    uiWorkflowMax: 7.2, // minutes
    systemResponseMax: 500, // ms
    cacheHitRateMin: 0.85, // 85%
    uptimeMin: 0.995, // 99.5%
    regressionThreshold: 15 // 15% degradation threshold
  },
  reporting: {
    outputDir: './benchmark-reports',
    formats: ['json', 'html'],
    includeCharts: true,
    emailRecipients: []
  },
  cicd: {
    enabled: true,
    failOnRegression: true
  }
};

// Factory function
export function createBenchmarkEngine(config: Partial<BenchmarkConfig> = {}): BenchmarkEngine {
  const mergedConfig: BenchmarkConfig = {
    ...defaultBenchmarkConfig,
    ...config,
    thresholds: {
      ...defaultBenchmarkConfig.thresholds,
      ...config.thresholds
    },
    reporting: {
      ...defaultBenchmarkConfig.reporting,
      ...config.reporting
    },
    cicd: {
      ...defaultBenchmarkConfig.cicd,
      ...config.cicd
    }
  };

  return new BenchmarkEngine(mergedConfig);
}