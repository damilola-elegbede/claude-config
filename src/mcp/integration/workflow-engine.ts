/**
 * SPEC_03: Advanced Workflow Engine for Integration Specialist
 * 
 * Custom MCP workflow patterns with optimization strategies, performance analytics,
 * and integration with the optimization engine. Designed to handle complex multi-step
 * workflows with parallel and sequential execution patterns.
 */

import { EventEmitter } from 'events';
import {
  MCPServerInfo,
  RoutingContext,
  ToolExecutionRequest,
  ToolExecutionResponse,
  PerformanceRequirements,
  ServerMetrics,
  CircuitBreakerState
} from '../types';
import { MCPOptimizationEngine } from './optimization-engine';

// =============================================================================
// Core Workflow Interfaces
// =============================================================================

export interface WorkflowStep {
  /** Unique step identifier */
  id: string;
  /** Step display name */
  name: string;
  /** Step description */
  description?: string;
  /** Tool to execute */
  toolName: string;
  /** Parameters for tool execution */
  parameters: Record<string, any>;
  /** Dependencies - steps that must complete first */
  dependencies: string[];
  /** Conditional execution expression */
  condition?: string;
  /** Retry configuration */
  retryConfig?: WorkflowRetryConfig;
  /** Timeout in milliseconds */
  timeout?: number;
  /** Step priority (1-10) */
  priority?: number;
  /** Whether step can be executed in parallel */
  canRunInParallel: boolean;
  /** Performance requirements */
  requirements?: PerformanceRequirements;
}

export interface WorkflowRetryConfig {
  /** Maximum number of retry attempts */
  maxAttempts: number;
  /** Base retry delay in milliseconds */
  baseDelay: number;
  /** Exponential backoff multiplier */
  backoffMultiplier: number;
  /** Maximum retry delay */
  maxDelay: number;
  /** Retry on specific error types */
  retryOnErrors?: string[];
}

export interface WorkflowDefinition {
  /** Unique workflow identifier */
  id: string;
  /** Workflow name */
  name: string;
  /** Workflow description */
  description?: string;
  /** Workflow version */
  version: string;
  /** Workflow steps */
  steps: WorkflowStep[];
  /** Global workflow configuration */
  config: WorkflowConfig;
  /** Input schema for workflow parameters */
  inputSchema?: Record<string, any>;
  /** Output schema for workflow results */
  outputSchema?: Record<string, any>;
  /** Workflow metadata */
  metadata?: WorkflowMetadata;
  /** Created timestamp */
  createdAt: Date;
  /** Last modified timestamp */
  updatedAt: Date;
}

export interface WorkflowConfig {
  /** Maximum concurrent parallel steps */
  maxConcurrency: number;
  /** Global workflow timeout in milliseconds */
  globalTimeout: number;
  /** Failure handling strategy */
  failureStrategy: 'abort' | 'continue' | 'skip-failed';
  /** Enable automatic step optimization */
  enableOptimization: boolean;
  /** Enable workflow caching */
  enableCaching: boolean;
  /** Cache TTL in milliseconds */
  cacheTtl?: number;
  /** Enable performance monitoring */
  enableMonitoring: boolean;
  /** Resource requirements */
  resources?: {
    maxMemory?: number;
    maxCpu?: number;
    maxDuration?: number;
  };
}

export interface WorkflowMetadata {
  /** Workflow author */
  author?: string;
  /** Workflow tags */
  tags?: string[];
  /** Workflow category */
  category?: string;
  /** Usage frequency */
  usageFrequency?: number;
  /** Performance statistics */
  performanceStats?: WorkflowPerformanceStats;
}

export interface WorkflowPerformanceStats {
  /** Total executions */
  totalExecutions: number;
  /** Successful executions */
  successfulExecutions: number;
  /** Failed executions */
  failedExecutions: number;
  /** Average execution time */
  averageExecutionTime: number;
  /** Median execution time */
  medianExecutionTime: number;
  /** 95th percentile execution time */
  p95ExecutionTime: number;
  /** Success rate */
  successRate: number;
  /** Last execution timestamp */
  lastExecution?: Date;
}

export interface WorkflowExecution {
  /** Unique execution identifier */
  executionId: string;
  /** Workflow definition ID */
  workflowId: string;
  /** Execution status */
  status: WorkflowExecutionStatus;
  /** Input parameters */
  input: Record<string, any>;
  /** Execution results */
  results?: Record<string, any>;
  /** Execution error */
  error?: Error;
  /** Step execution details */
  stepExecutions: Map<string, StepExecution>;
  /** Execution start time */
  startTime: Date;
  /** Execution end time */
  endTime?: Date;
  /** Total execution duration */
  duration?: number;
  /** Agent that initiated execution */
  agentId?: string;
  /** Execution context */
  context: WorkflowExecutionContext;
}

export type WorkflowExecutionStatus = 
  | 'pending' 
  | 'running' 
  | 'paused' 
  | 'completed' 
  | 'failed' 
  | 'cancelled' 
  | 'timeout';

export interface WorkflowExecutionContext {
  /** MCP servers available for execution */
  availableServers: MCPServerInfo[];
  /** Optimization engine instance */
  optimizationEngine?: MCPOptimizationEngine;
  /** Execution environment variables */
  environment?: Record<string, any>;
  /** Execution metadata */
  metadata?: Record<string, any>;
}

export interface StepExecution {
  /** Step ID */
  stepId: string;
  /** Execution status */
  status: StepExecutionStatus;
  /** Tool execution request */
  request?: ToolExecutionRequest;
  /** Tool execution response */
  response?: ToolExecutionResponse;
  /** Step execution error */
  error?: Error;
  /** Number of retry attempts */
  attempts: number;
  /** Step start time */
  startTime: Date;
  /** Step end time */
  endTime?: Date;
  /** Step execution duration */
  duration?: number;
  /** Server used for execution */
  serverId?: string;
  /** Execution logs */
  logs: string[];
}

export type StepExecutionStatus = 
  | 'pending' 
  | 'running' 
  | 'completed' 
  | 'failed' 
  | 'retrying' 
  | 'skipped' 
  | 'cancelled';

// =============================================================================
// Workflow Analytics Interfaces
// =============================================================================

export interface WorkflowAnalytics {
  /** Workflow performance metrics */
  performance: WorkflowPerformanceMetrics;
  /** Step performance breakdown */
  stepPerformance: Map<string, StepPerformanceMetrics>;
  /** Bottleneck identification */
  bottlenecks: WorkflowBottleneck[];
  /** Optimization recommendations */
  recommendations: OptimizationRecommendation[];
  /** Resource utilization */
  resourceUtilization: ResourceUtilization;
  /** Error analysis */
  errorAnalysis: ErrorAnalysis;
}

export interface WorkflowPerformanceMetrics {
  /** Total workflow executions analyzed */
  totalExecutions: number;
  /** Average execution time */
  averageExecutionTime: number;
  /** Execution time percentiles */
  percentiles: {
    p50: number;
    p75: number;
    p90: number;
    p95: number;
    p99: number;
  };
  /** Success rate */
  successRate: number;
  /** Parallel execution efficiency */
  parallelEfficiency: number;
  /** Resource utilization efficiency */
  resourceEfficiency: number;
}

export interface StepPerformanceMetrics {
  /** Step ID */
  stepId: string;
  /** Step name */
  stepName: string;
  /** Average execution time */
  averageTime: number;
  /** Success rate */
  successRate: number;
  /** Retry rate */
  retryRate: number;
  /** Server distribution */
  serverDistribution: Map<string, number>;
  /** Performance trend */
  trend: 'improving' | 'stable' | 'degrading';
}

export interface WorkflowBottleneck {
  /** Bottleneck type */
  type: 'step' | 'dependency' | 'resource' | 'server';
  /** Bottleneck location */
  location: string;
  /** Severity score (1-10) */
  severity: number;
  /** Impact description */
  impact: string;
  /** Suggested resolution */
  resolution: string;
  /** Confidence level */
  confidence: number;
}

export interface OptimizationRecommendation {
  /** Recommendation type */
  type: 'parallelization' | 'caching' | 'routing' | 'batching' | 'resource';
  /** Recommendation description */
  description: string;
  /** Expected performance improvement */
  expectedImprovement: number;
  /** Implementation complexity */
  complexity: 'low' | 'medium' | 'high';
  /** Priority level */
  priority: 'low' | 'medium' | 'high' | 'critical';
  /** Implementation steps */
  implementation: string[];
}

export interface ResourceUtilization {
  /** CPU utilization statistics */
  cpu: {
    average: number;
    peak: number;
    efficiency: number;
  };
  /** Memory utilization statistics */
  memory: {
    average: number;
    peak: number;
    efficiency: number;
  };
  /** Network utilization statistics */
  network: {
    average: number;
    peak: number;
    efficiency: number;
  };
  /** Server utilization breakdown */
  serverUtilization: Map<string, ServerUtilization>;
}

export interface ServerUtilization {
  /** Server ID */
  serverId: string;
  /** Usage percentage */
  usage: number;
  /** Request count */
  requestCount: number;
  /** Average response time */
  averageResponseTime: number;
  /** Error rate */
  errorRate: number;
}

export interface ErrorAnalysis {
  /** Total error count */
  totalErrors: number;
  /** Error rate */
  errorRate: number;
  /** Error categories */
  errorCategories: Map<string, ErrorCategoryStats>;
  /** Most common errors */
  commonErrors: Array<{
    error: string;
    count: number;
    percentage: number;
  }>;
  /** Error trends */
  trends: {
    increasing: string[];
    stable: string[];
    decreasing: string[];
  };
}

export interface ErrorCategoryStats {
  /** Category name */
  category: string;
  /** Error count */
  count: number;
  /** Percentage of total errors */
  percentage: number;
  /** Most frequent error in category */
  topError: string;
}

// =============================================================================
// Workflow Designer
// =============================================================================

export class WorkflowDesigner {
  private templates: Map<string, WorkflowTemplate> = new Map();
  private patterns: Map<string, WorkflowPattern> = new Map();

  constructor() {
    this.initializeBuiltInTemplates();
    this.initializeBuiltInPatterns();
  }

  /**
   * Create a new workflow definition
   */
  createWorkflow(
    name: string, 
    description?: string
  ): WorkflowDefinitionBuilder {
    return new WorkflowDefinitionBuilder(name, description);
  }

  /**
   * Create workflow from template
   */
  createFromTemplate(
    templateId: string, 
    parameters: Record<string, any>
  ): WorkflowDefinition {
    const template = this.templates.get(templateId);
    if (!template) {
      throw new Error(`Workflow template not found: ${templateId}`);
    }

    return this.instantiateTemplate(template, parameters);
  }

  /**
   * Register a custom workflow template
   */
  registerTemplate(template: WorkflowTemplate): void {
    this.templates.set(template.id, template);
  }

  /**
   * Register a custom workflow pattern
   */
  registerPattern(pattern: WorkflowPattern): void {
    this.patterns.set(pattern.id, pattern);
  }

  /**
   * Get available templates
   */
  getTemplates(): WorkflowTemplate[] {
    return Array.from(this.templates.values());
  }

  /**
   * Get available patterns
   */
  getPatterns(): WorkflowPattern[] {
    return Array.from(this.patterns.values());
  }

  /**
   * Validate workflow definition
   */
  validateWorkflow(workflow: WorkflowDefinition): ValidationResult {
    const errors: string[] = [];
    const warnings: string[] = [];

    // Validate step dependencies
    const stepIds = new Set(workflow.steps.map(s => s.id));
    for (const step of workflow.steps) {
      for (const dep of step.dependencies) {
        if (!stepIds.has(dep)) {
          errors.push(`Step '${step.id}' has invalid dependency '${dep}'`);
        }
      }
    }

    // Check for circular dependencies
    if (this.hasCircularDependencies(workflow.steps)) {
      errors.push('Workflow has circular dependencies');
    }

    // Validate concurrent steps
    const concurrentSteps = workflow.steps.filter(s => s.canRunInParallel);
    if (concurrentSteps.length > workflow.config.maxConcurrency) {
      warnings.push(`Workflow has more parallel steps than max concurrency (${workflow.config.maxConcurrency})`);
    }

    return {
      valid: errors.length === 0,
      errors,
      warnings
    };
  }

  private initializeBuiltInTemplates(): void {
    // Data Processing Pipeline Template
    this.templates.set('data-processing-pipeline', {
      id: 'data-processing-pipeline',
      name: 'Data Processing Pipeline',
      description: 'Template for data ingestion, processing, and output workflows',
      category: 'data',
      steps: [
        {
          id: 'ingest',
          name: 'Data Ingestion',
          toolName: '{{ ingestTool }}',
          parameters: '{{ ingestParams }}',
          canRunInParallel: false
        },
        {
          id: 'validate',
          name: 'Data Validation',
          toolName: 'validate-data',
          parameters: '{{ validateParams }}',
          dependencies: ['ingest'],
          canRunInParallel: true
        },
        {
          id: 'transform',
          name: 'Data Transformation',
          toolName: '{{ transformTool }}',
          parameters: '{{ transformParams }}',
          dependencies: ['validate'],
          canRunInParallel: true
        },
        {
          id: 'output',
          name: 'Data Output',
          toolName: '{{ outputTool }}',
          parameters: '{{ outputParams }}',
          dependencies: ['transform'],
          canRunInParallel: false
        }
      ] as any,
      parameters: {
        ingestTool: { type: 'string', required: true },
        ingestParams: { type: 'object', required: true },
        transformTool: { type: 'string', required: true },
        transformParams: { type: 'object', required: true },
        outputTool: { type: 'string', required: true },
        outputParams: { type: 'object', required: true },
        validateParams: { type: 'object', required: false }
      }
    });

    // API Integration Template
    this.templates.set('api-integration', {
      id: 'api-integration',
      name: 'API Integration Workflow',
      description: 'Template for complex API integration workflows with error handling',
      category: 'integration',
      steps: [
        {
          id: 'authenticate',
          name: 'Authentication',
          toolName: 'api-authenticate',
          parameters: '{{ authParams }}',
          canRunInParallel: false
        },
        {
          id: 'fetch-data',
          name: 'Fetch Data',
          toolName: 'api-request',
          parameters: '{{ fetchParams }}',
          dependencies: ['authenticate'],
          canRunInParallel: true
        },
        {
          id: 'process-response',
          name: 'Process Response',
          toolName: 'process-data',
          parameters: '{{ processParams }}',
          dependencies: ['fetch-data'],
          canRunInParallel: true
        },
        {
          id: 'handle-errors',
          name: 'Error Handling',
          toolName: 'error-handler',
          parameters: '{{ errorParams }}',
          dependencies: [],
          condition: 'hasErrors()',
          canRunInParallel: false
        }
      ] as any,
      parameters: {
        authParams: { type: 'object', required: true },
        fetchParams: { type: 'object', required: true },
        processParams: { type: 'object', required: true },
        errorParams: { type: 'object', required: false }
      }
    });
  }

  private initializeBuiltInPatterns(): void {
    // Fan-out/Fan-in Pattern
    this.patterns.set('fan-out-fan-in', {
      id: 'fan-out-fan-in',
      name: 'Fan-out/Fan-in',
      description: 'Distribute work across multiple parallel steps then aggregate results',
      category: 'parallelization',
      structure: {
        fanOut: true,
        fanIn: true,
        parallelSteps: true
      }
    });

    // Pipeline Pattern
    this.patterns.set('pipeline', {
      id: 'pipeline',
      name: 'Sequential Pipeline',
      description: 'Sequential processing pipeline with optional parallel stages',
      category: 'processing',
      structure: {
        sequential: true,
        stages: true,
        parallelWithinStages: false
      }
    });

    // Saga Pattern
    this.patterns.set('saga', {
      id: 'saga',
      name: 'Saga Pattern',
      description: 'Long-running transactions with compensation logic',
      category: 'transaction',
      structure: {
        compensation: true,
        longRunning: true,
        errorRecovery: true
      }
    });
  }

  private instantiateTemplate(
    template: WorkflowTemplate, 
    parameters: Record<string, any>
  ): WorkflowDefinition {
    const workflowId = `${template.id}-${Date.now()}`;
    
    // Replace template parameters in steps
    const instantiatedSteps: WorkflowStep[] = template.steps.map(step => ({
      ...step,
      id: step.id,
      name: this.replaceParameters(step.name, parameters),
      toolName: this.replaceParameters(step.toolName, parameters),
      parameters: this.replaceParameters(step.parameters, parameters),
      dependencies: step.dependencies || [],
      canRunInParallel: step.canRunInParallel || false,
      timeout: step.timeout,
      priority: step.priority,
      retryConfig: step.retryConfig
    }));

    return {
      id: workflowId,
      name: this.replaceParameters(template.name, parameters),
      description: template.description,
      version: '1.0.0',
      steps: instantiatedSteps,
      config: {
        maxConcurrency: 10,
        globalTimeout: 300000, // 5 minutes
        failureStrategy: 'abort',
        enableOptimization: true,
        enableCaching: true,
        enableMonitoring: true
      },
      createdAt: new Date(),
      updatedAt: new Date()
    };
  }

  private replaceParameters(template: any, parameters: Record<string, any>): any {
    if (typeof template === 'string') {
      return template.replace(/\{\{\s*(\w+)\s*\}\}/g, (_, key) => {
        return parameters[key] || `{{${key}}}`;
      });
    } else if (typeof template === 'object' && template !== null) {
      const result: any = Array.isArray(template) ? [] : {};
      for (const [key, value] of Object.entries(template)) {
        result[key] = this.replaceParameters(value, parameters);
      }
      return result;
    }
    return template;
  }

  private hasCircularDependencies(steps: WorkflowStep[]): boolean {
    const visited = new Set<string>();
    const recursionStack = new Set<string>();

    const hasCycle = (stepId: string, stepMap: Map<string, WorkflowStep>): boolean => {
      if (recursionStack.has(stepId)) {
        return true; // Circular dependency found
      }
      if (visited.has(stepId)) {
        return false; // Already processed
      }

      visited.add(stepId);
      recursionStack.add(stepId);

      const step = stepMap.get(stepId);
      if (step) {
        for (const dep of step.dependencies) {
          if (hasCycle(dep, stepMap)) {
            return true;
          }
        }
      }

      recursionStack.delete(stepId);
      return false;
    };

    const stepMap = new Map(steps.map(s => [s.id, s]));
    
    for (const step of steps) {
      if (hasCycle(step.id, stepMap)) {
        return true;
      }
    }

    return false;
  }
}

// Supporting interfaces for WorkflowDesigner

interface WorkflowTemplate {
  id: string;
  name: string;
  description: string;
  category: string;
  steps: Partial<WorkflowStep>[];
  parameters: Record<string, {
    type: string;
    required: boolean;
    default?: any;
  }>;
}

interface WorkflowPattern {
  id: string;
  name: string;
  description: string;
  category: string;
  structure: Record<string, any>;
}

interface ValidationResult {
  valid: boolean;
  errors: string[];
  warnings: string[];
}

/**
 * Builder class for creating workflow definitions
 */
export class WorkflowDefinitionBuilder {
  private workflow: Partial<WorkflowDefinition>;
  private steps: WorkflowStep[] = [];

  constructor(name: string, description?: string) {
    this.workflow = {
      id: `workflow-${Date.now()}`,
      name,
      description,
      version: '1.0.0',
      steps: [],
      config: {
        maxConcurrency: 10,
        globalTimeout: 300000,
        failureStrategy: 'abort',
        enableOptimization: true,
        enableCaching: true,
        enableMonitoring: true
      },
      createdAt: new Date(),
      updatedAt: new Date()
    };
  }

  /**
   * Add a step to the workflow
   */
  addStep(step: Omit<WorkflowStep, 'id' | 'dependencies' | 'canRunInParallel'>): WorkflowDefinitionBuilder {
    const workflowStep: WorkflowStep = {
      ...step,
      id: step.name.toLowerCase().replace(/\s+/g, '-'),
      dependencies: [],
      canRunInParallel: false
    };
    
    this.steps.push(workflowStep);
    return this;
  }

  /**
   * Set dependencies for the last added step
   */
  dependsOn(...stepIds: string[]): WorkflowDefinitionBuilder {
    if (this.steps.length > 0) {
      this.steps[this.steps.length - 1].dependencies = stepIds;
    }
    return this;
  }

  /**
   * Mark the last added step as parallelizable
   */
  parallel(canRunInParallel: boolean = true): WorkflowDefinitionBuilder {
    if (this.steps.length > 0) {
      this.steps[this.steps.length - 1].canRunInParallel = canRunInParallel;
    }
    return this;
  }

  /**
   * Configure workflow settings
   */
  configure(config: Partial<WorkflowConfig>): WorkflowDefinitionBuilder {
    this.workflow.config = { ...this.workflow.config!, ...config };
    return this;
  }

  /**
   * Set input schema
   */
  inputSchema(schema: Record<string, any>): WorkflowDefinitionBuilder {
    this.workflow.inputSchema = schema;
    return this;
  }

  /**
   * Set output schema
   */
  outputSchema(schema: Record<string, any>): WorkflowDefinitionBuilder {
    this.workflow.outputSchema = schema;
    return this;
  }

  /**
   * Build the final workflow definition
   */
  build(): WorkflowDefinition {
    this.workflow.steps = this.steps;
    return this.workflow as WorkflowDefinition;
  }
}

// =============================================================================
// Workflow Execution Engine
// =============================================================================

export class WorkflowExecutionEngine extends EventEmitter {
  private activeExecutions: Map<string, WorkflowExecution> = new Map();
  private optimizationEngine?: MCPOptimizationEngine;

  constructor(optimizationEngine?: MCPOptimizationEngine) {
    super();
    this.optimizationEngine = optimizationEngine;
  }

  /**
   * Execute a workflow
   */
  async executeWorkflow(
    workflow: WorkflowDefinition,
    input: Record<string, any>,
    context: Partial<WorkflowExecutionContext> = {}
  ): Promise<WorkflowExecution> {
    const executionId = `exec-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
    
    const execution: WorkflowExecution = {
      executionId,
      workflowId: workflow.id,
      status: 'pending',
      input,
      stepExecutions: new Map(),
      startTime: new Date(),
      agentId: context.metadata?.agentId,
      context: {
        availableServers: context.availableServers || [],
        optimizationEngine: this.optimizationEngine,
        environment: context.environment || {},
        metadata: context.metadata || {}
      }
    };

    this.activeExecutions.set(executionId, execution);
    this.emit('workflowStarted', { execution });

    try {
      execution.status = 'running';
      await this.executeWorkflowSteps(workflow, execution);
      
      execution.status = 'completed';
      execution.endTime = new Date();
      execution.duration = execution.endTime.getTime() - execution.startTime.getTime();
      
      this.emit('workflowCompleted', { execution });
    } catch (error) {
      execution.status = 'failed';
      execution.error = error instanceof Error ? error : new Error(String(error));
      execution.endTime = new Date();
      execution.duration = execution.endTime.getTime() - execution.startTime.getTime();
      
      this.emit('workflowFailed', { execution, error });
    } finally {
      this.activeExecutions.delete(executionId);
    }

    return execution;
  }

  /**
   * Cancel a running workflow execution
   */
  async cancelExecution(executionId: string): Promise<void> {
    const execution = this.activeExecutions.get(executionId);
    if (!execution) {
      throw new Error(`Execution not found: ${executionId}`);
    }

    execution.status = 'cancelled';
    execution.endTime = new Date();
    execution.duration = execution.endTime.getTime() - execution.startTime.getTime();

    this.emit('workflowCancelled', { execution });
  }

  /**
   * Get active executions
   */
  getActiveExecutions(): WorkflowExecution[] {
    return Array.from(this.activeExecutions.values());
  }

  /**
   * Get execution status
   */
  getExecutionStatus(executionId: string): WorkflowExecutionStatus | null {
    const execution = this.activeExecutions.get(executionId);
    return execution?.status || null;
  }

  private async executeWorkflowSteps(
    workflow: WorkflowDefinition,
    execution: WorkflowExecution
  ): Promise<void> {
    const stepMap = new Map(workflow.steps.map(s => [s.id, s]));
    const completedSteps = new Set<string>();
    const runningSteps = new Set<string>();
    
    // Continue until all steps are completed or execution fails
    while (completedSteps.size < workflow.steps.length && execution.status === 'running') {
      const readySteps = this.getReadySteps(workflow.steps, completedSteps, runningSteps);
      
      if (readySteps.length === 0) {
        // No ready steps, check if we're waiting on running steps
        if (runningSteps.size === 0) {
          throw new Error('Workflow execution stuck: no ready steps and no running steps');
        }
        // Wait for running steps to complete
        await new Promise(resolve => setTimeout(resolve, 100));
        continue;
      }

      // Execute ready steps (with concurrency limits)
      const parallelSteps = readySteps.filter(s => s.canRunInParallel);
      const sequentialSteps = readySteps.filter(s => !s.canRunInParallel);

      // Execute sequential steps first
      for (const step of sequentialSteps) {
        await this.executeStep(step, execution);
        completedSteps.add(step.id);
      }

      // Execute parallel steps with concurrency control
      if (parallelSteps.length > 0) {
        const concurrency = Math.min(parallelSteps.length, workflow.config.maxConcurrency);
        const chunks = this.chunkArray(parallelSteps, concurrency);
        
        for (const chunk of chunks) {
          const promises = chunk.map(step => {
            runningSteps.add(step.id);
            return this.executeStep(step, execution)
              .then(() => {
                completedSteps.add(step.id);
                runningSteps.delete(step.id);
              })
              .catch(error => {
                runningSteps.delete(step.id);
                if (workflow.config.failureStrategy === 'abort') {
                  throw error;
                }
                // For continue/skip-failed strategies, mark as completed with error
                completedSteps.add(step.id);
              });
          });

          await Promise.all(promises);
        }
      }
    }

    // Collect results from successful step executions
    const results: Record<string, any> = {};
    for (const [stepId, stepExecution] of execution.stepExecutions) {
      if (stepExecution.status === 'completed' && stepExecution.response?.success) {
        results[stepId] = stepExecution.response.result;
      }
    }
    execution.results = results;
  }

  private async executeStep(
    step: WorkflowStep,
    execution: WorkflowExecution
  ): Promise<void> {
    const stepExecution: StepExecution = {
      stepId: step.id,
      status: 'pending',
      attempts: 0,
      startTime: new Date(),
      logs: []
    };

    execution.stepExecutions.set(step.id, stepExecution);
    this.emit('stepStarted', { execution, step, stepExecution });

    try {
      stepExecution.status = 'running';
      
      // Check conditional execution
      if (step.condition && !this.evaluateCondition(step.condition, execution)) {
        stepExecution.status = 'skipped';
        stepExecution.endTime = new Date();
        stepExecution.duration = stepExecution.endTime.getTime() - stepExecution.startTime.getTime();
        this.emit('stepSkipped', { execution, step, stepExecution });
        return;
      }

      // Execute step with retry logic
      const maxAttempts = step.retryConfig?.maxAttempts || 1;
      let lastError: Error | undefined;

      for (let attempt = 1; attempt <= maxAttempts; attempt++) {
        stepExecution.attempts = attempt;
        
        try {
          if (attempt > 1) {
            stepExecution.status = 'retrying';
            const delay = this.calculateRetryDelay(step.retryConfig!, attempt);
            await new Promise(resolve => setTimeout(resolve, delay));
            stepExecution.logs.push(`Retrying step (attempt ${attempt}/${maxAttempts})`);
          }

          // Create tool execution request
          const request: ToolExecutionRequest = {
            toolName: step.toolName,
            parameters: this.resolveStepParameters(step.parameters, execution),
            agentId: execution.agentId,
            requestId: `${execution.executionId}-${step.id}-${attempt}`,
            priority: step.priority,
            timeout: step.timeout,
            requirements: step.requirements
          };

          stepExecution.request = request;

          // Execute through optimization engine if available
          let response: ToolExecutionResponse;
          if (this.optimizationEngine && execution.context.availableServers.length > 0) {
            response = await this.optimizationEngine.optimizeRequest(
              request,
              execution.context.availableServers
            );
          } else {
            // Fallback execution (mock for this implementation)
            response = await this.mockToolExecution(request);
          }

          stepExecution.response = response;
          stepExecution.serverId = response.serverId;

          if (response.success) {
            stepExecution.status = 'completed';
            stepExecution.logs.push(`Step completed successfully in ${response.executionTime}ms`);
            break;
          } else {
            throw response.error || new Error('Step execution failed');
          }

        } catch (error) {
          lastError = error instanceof Error ? error : new Error(String(error));
          stepExecution.logs.push(`Step failed on attempt ${attempt}: ${lastError.message}`);
          
          // Check if we should retry
          if (attempt === maxAttempts || !this.shouldRetry(lastError, step.retryConfig)) {
            throw lastError;
          }
        }
      }

    } catch (error) {
      stepExecution.status = 'failed';
      stepExecution.error = error instanceof Error ? error : new Error(String(error));
      this.emit('stepFailed', { execution, step, stepExecution, error: stepExecution.error });
      throw stepExecution.error;
    } finally {
      stepExecution.endTime = new Date();
      stepExecution.duration = stepExecution.endTime.getTime() - stepExecution.startTime.getTime();
      
      if (stepExecution.status === 'completed') {
        this.emit('stepCompleted', { execution, step, stepExecution });
      }
    }
  }

  private getReadySteps(
    steps: WorkflowStep[],
    completedSteps: Set<string>,
    runningSteps: Set<string>
  ): WorkflowStep[] {
    return steps.filter(step => {
      // Skip if already completed or running
      if (completedSteps.has(step.id) || runningSteps.has(step.id)) {
        return false;
      }

      // Check if all dependencies are completed
      return step.dependencies.every(dep => completedSteps.has(dep));
    });
  }

  private chunkArray<T>(array: T[], chunkSize: number): T[][] {
    const chunks: T[][] = [];
    for (let i = 0; i < array.length; i += chunkSize) {
      chunks.push(array.slice(i, i + chunkSize));
    }
    return chunks;
  }

  private evaluateCondition(condition: string, execution: WorkflowExecution): boolean {
    // Simple condition evaluation (in a real implementation, use a proper expression evaluator)
    try {
      // Create a context for condition evaluation
      const context = {
        input: execution.input,
        results: execution.results || {},
        hasErrors: () => {
          return Array.from(execution.stepExecutions.values())
            .some(se => se.status === 'failed');
        }
      };

      // This is a simplified evaluation - in production, use a safe expression evaluator
      // eslint-disable-next-line no-new-func
      const evaluator = new Function('context', `with(context) { return ${condition}; }`);
      return Boolean(evaluator(context));
    } catch (error) {
      // If condition evaluation fails, default to true
      return true;
    }
  }

  private resolveStepParameters(
    parameters: Record<string, any>,
    execution: WorkflowExecution
  ): Record<string, any> {
    // Deep clone parameters
    const resolved = JSON.parse(JSON.stringify(parameters));
    
    // Resolve parameter references (simplified implementation)
    this.resolveParameterReferences(resolved, {
      input: execution.input,
      results: execution.results || {}
    });
    
    return resolved;
  }

  private resolveParameterReferences(obj: any, context: Record<string, any>): void {
    if (typeof obj === 'string' && obj.startsWith('${') && obj.endsWith('}')) {
      // Simple parameter reference resolution
      const ref = obj.slice(2, -1);
      const value = this.getValueByPath(context, ref);
      return value !== undefined ? value : obj;
    } else if (typeof obj === 'object' && obj !== null) {
      for (const key in obj) {
        obj[key] = this.resolveParameterReferences(obj[key], context);
      }
    }
    return obj;
  }

  private getValueByPath(obj: any, path: string): any {
    return path.split('.').reduce((current, key) => current?.[key], obj);
  }

  private calculateRetryDelay(retryConfig: WorkflowRetryConfig, attempt: number): number {
    const delay = retryConfig.baseDelay * Math.pow(retryConfig.backoffMultiplier, attempt - 1);
    return Math.min(delay, retryConfig.maxDelay);
  }

  private shouldRetry(error: Error, retryConfig?: WorkflowRetryConfig): boolean {
    if (!retryConfig || !retryConfig.retryOnErrors) {
      return true;
    }
    
    return retryConfig.retryOnErrors.some(errorType => 
      error.name.includes(errorType) || error.message.includes(errorType)
    );
  }

  private async mockToolExecution(request: ToolExecutionRequest): Promise<ToolExecutionResponse> {
    // Mock implementation - in real usage, this would execute the actual tool
    const delay = Math.random() * 200 + 50; // 50-250ms
    await new Promise(resolve => setTimeout(resolve, delay));

    return {
      requestId: request.requestId,
      success: Math.random() > 0.1, // 90% success rate
      result: { message: `Mock result for ${request.toolName}`, data: request.parameters },
      serverId: 'mock-server',
      executionTime: delay,
      timestamp: new Date(),
      metadata: {
        circuitBreakerState: 'closed' as CircuitBreakerState,
        usedFallback: false
      }
    };
  }
}

// =============================================================================
// Workflow Optimizer
// =============================================================================

export class WorkflowOptimizer extends EventEmitter {
  private optimizationEngine?: MCPOptimizationEngine;
  private performanceHistory: Map<string, WorkflowPerformanceStats> = new Map();

  constructor(optimizationEngine?: MCPOptimizationEngine) {
    super();
    this.optimizationEngine = optimizationEngine;
  }

  /**
   * Optimize workflow definition based on performance data
   */
  async optimizeWorkflow(
    workflow: WorkflowDefinition,
    performanceData?: WorkflowPerformanceStats
  ): Promise<WorkflowDefinition> {
    const optimizedWorkflow = { ...workflow };
    
    // Update performance history
    if (performanceData) {
      this.performanceHistory.set(workflow.id, performanceData);
    }

    // Apply optimization strategies
    const optimizations = await this.analyzeOptimizationOpportunities(workflow, performanceData);
    
    for (const optimization of optimizations) {
      switch (optimization.type) {
        case 'parallelization':
          this.applyParallelizationOptimization(optimizedWorkflow, optimization);
          break;
        case 'caching':
          this.applyCachingOptimization(optimizedWorkflow, optimization);
          break;
        case 'routing':
          this.applyRoutingOptimization(optimizedWorkflow, optimization);
          break;
        case 'batching':
          this.applyBatchingOptimization(optimizedWorkflow, optimization);
          break;
        case 'resource':
          this.applyResourceOptimization(optimizedWorkflow, optimization);
          break;
      }
    }

    // Update workflow version
    const [major, minor, patch] = optimizedWorkflow.version.split('.').map(Number);
    optimizedWorkflow.version = `${major}.${minor}.${patch + 1}`;
    optimizedWorkflow.updatedAt = new Date();

    this.emit('workflowOptimized', { 
      originalWorkflow: workflow, 
      optimizedWorkflow, 
      optimizations 
    });

    return optimizedWorkflow;
  }

  /**
   * Analyze workflow performance and identify bottlenecks
   */
  async analyzePerformance(
    workflow: WorkflowDefinition,
    executions: WorkflowExecution[]
  ): Promise<WorkflowAnalytics> {
    const analytics: WorkflowAnalytics = {
      performance: this.calculatePerformanceMetrics(executions),
      stepPerformance: this.analyzeStepPerformance(workflow, executions),
      bottlenecks: this.identifyBottlenecks(workflow, executions),
      recommendations: await this.generateRecommendations(workflow, executions),
      resourceUtilization: this.analyzeResourceUtilization(executions),
      errorAnalysis: this.analyzeErrors(executions)
    };

    return analytics;
  }

  /**
   * Generate optimization recommendations
   */
  async generateRecommendations(
    workflow: WorkflowDefinition,
    executions: WorkflowExecution[]
  ): Promise<OptimizationRecommendation[]> {
    const recommendations: OptimizationRecommendation[] = [];
    
    // Analyze execution patterns
    const performance = this.calculatePerformanceMetrics(executions);
    const stepPerformance = this.analyzeStepPerformance(workflow, executions);
    
    // Parallelization recommendations
    const parallelizationRec = this.analyzeParallelizationOpportunities(workflow, stepPerformance);
    if (parallelizationRec) recommendations.push(parallelizationRec);
    
    // Caching recommendations
    const cachingRec = this.analyzeCachingOpportunities(workflow, executions);
    if (cachingRec) recommendations.push(cachingRec);
    
    // Resource optimization recommendations
    const resourceRec = this.analyzeResourceOptimizationOpportunities(workflow, executions);
    if (resourceRec) recommendations.push(resourceRec);
    
    return recommendations.sort((a, b) => {
      const priorityOrder = { 'critical': 4, 'high': 3, 'medium': 2, 'low': 1 };
      return priorityOrder[b.priority] - priorityOrder[a.priority];
    });
  }

  private async analyzeOptimizationOpportunities(
    workflow: WorkflowDefinition,
    performanceData?: WorkflowPerformanceStats
  ): Promise<OptimizationRecommendation[]> {
    const optimizations: OptimizationRecommendation[] = [];

    // Check for parallelization opportunities
    const sequentialSteps = workflow.steps.filter(step => !step.canRunInParallel);
    if (sequentialSteps.length > 2) {
      optimizations.push({
        type: 'parallelization',
        description: 'Convert independent sequential steps to parallel execution',
        expectedImprovement: 0.3,
        complexity: 'medium',
        priority: 'high',
        implementation: [
          'Identify steps with no dependencies',
          'Mark eligible steps as parallel',
          'Adjust concurrency limits'
        ]
      });
    }

    // Check for caching opportunities
    const readOnlySteps = workflow.steps.filter(step => 
      step.toolName.includes('read') || step.toolName.includes('fetch')
    );
    if (readOnlySteps.length > 0 && !workflow.config.enableCaching) {
      optimizations.push({
        type: 'caching',
        description: 'Enable caching for read-only operations',
        expectedImprovement: 0.4,
        complexity: 'low',
        priority: 'high',
        implementation: [
          'Enable workflow caching',
          'Configure appropriate TTL values',
          'Implement cache invalidation strategy'
        ]
      });
    }

    return optimizations;
  }

  private applyParallelizationOptimization(
    workflow: WorkflowDefinition,
    optimization: OptimizationRecommendation
  ): void {
    // Find steps that can be parallelized
    for (const step of workflow.steps) {
      if (!step.canRunInParallel && step.dependencies.length === 0) {
        step.canRunInParallel = true;
      }
    }

    // Increase concurrency if needed
    const parallelSteps = workflow.steps.filter(s => s.canRunInParallel).length;
    if (parallelSteps > workflow.config.maxConcurrency) {
      workflow.config.maxConcurrency = Math.min(parallelSteps, 20);
    }
  }

  private applyCachingOptimization(
    workflow: WorkflowDefinition,
    optimization: OptimizationRecommendation
  ): void {
    workflow.config.enableCaching = true;
    workflow.config.cacheTtl = 300000; // 5 minutes default
  }

  private applyRoutingOptimization(
    workflow: WorkflowDefinition,
    optimization: OptimizationRecommendation
  ): void {
    // Add performance requirements to steps that don't have them
    for (const step of workflow.steps) {
      if (!step.requirements) {
        step.requirements = {
          maxResponseTime: 5000,
          minSuccessRate: 0.95
        };
      }
    }
  }

  private applyBatchingOptimization(
    workflow: WorkflowDefinition,
    optimization: OptimizationRecommendation
  ): void {
    // Lower priority for steps that can be batched
    for (const step of workflow.steps) {
      if (!step.priority && step.canRunInParallel) {
        step.priority = 5; // Medium priority for batching
      }
    }
  }

  private applyResourceOptimization(
    workflow: WorkflowDefinition,
    optimization: OptimizationRecommendation
  ): void {
    // Set resource limits if not already configured
    if (!workflow.config.resources) {
      workflow.config.resources = {
        maxMemory: 1024, // 1GB
        maxCpu: 0.8, // 80%
        maxDuration: 600000 // 10 minutes
      };
    }
  }

  private calculatePerformanceMetrics(executions: WorkflowExecution[]): WorkflowPerformanceMetrics {
    if (executions.length === 0) {
      return {
        totalExecutions: 0,
        averageExecutionTime: 0,
        percentiles: { p50: 0, p75: 0, p90: 0, p95: 0, p99: 0 },
        successRate: 0,
        parallelEfficiency: 0,
        resourceEfficiency: 0
      };
    }

    const completedExecutions = executions.filter(e => e.status === 'completed');
    const executionTimes = completedExecutions
      .map(e => e.duration || 0)
      .sort((a, b) => a - b);

    const successRate = completedExecutions.length / executions.length;
    const averageExecutionTime = executionTimes.reduce((sum, time) => sum + time, 0) / executionTimes.length || 0;

    return {
      totalExecutions: executions.length,
      averageExecutionTime,
      percentiles: {
        p50: this.calculatePercentile(executionTimes, 0.5),
        p75: this.calculatePercentile(executionTimes, 0.75),
        p90: this.calculatePercentile(executionTimes, 0.9),
        p95: this.calculatePercentile(executionTimes, 0.95),
        p99: this.calculatePercentile(executionTimes, 0.99)
      },
      successRate,
      parallelEfficiency: this.calculateParallelEfficiency(completedExecutions),
      resourceEfficiency: this.calculateResourceEfficiency(completedExecutions)
    };
  }

  private analyzeStepPerformance(
    workflow: WorkflowDefinition,
    executions: WorkflowExecution[]
  ): Map<string, StepPerformanceMetrics> {
    const stepPerformance = new Map<string, StepPerformanceMetrics>();

    for (const step of workflow.steps) {
      const stepExecutions = executions
        .map(e => e.stepExecutions.get(step.id))
        .filter(se => se !== undefined) as StepExecution[];

      const completedStepExecutions = stepExecutions.filter(se => se.status === 'completed');
      const averageTime = completedStepExecutions.reduce((sum, se) => sum + (se.duration || 0), 0) / completedStepExecutions.length || 0;
      const successRate = completedStepExecutions.length / stepExecutions.length || 0;
      const retryRate = stepExecutions.filter(se => se.attempts > 1).length / stepExecutions.length || 0;

      const serverDistribution = new Map<string, number>();
      for (const se of completedStepExecutions) {
        if (se.serverId) {
          serverDistribution.set(se.serverId, (serverDistribution.get(se.serverId) || 0) + 1);
        }
      }

      stepPerformance.set(step.id, {
        stepId: step.id,
        stepName: step.name,
        averageTime,
        successRate,
        retryRate,
        serverDistribution,
        trend: 'stable' // Simplified - would need historical data for real trend analysis
      });
    }

    return stepPerformance;
  }

  private identifyBottlenecks(
    workflow: WorkflowDefinition,
    executions: WorkflowExecution[]
  ): WorkflowBottleneck[] {
    const bottlenecks: WorkflowBottleneck[] = [];
    const stepPerformance = this.analyzeStepPerformance(workflow, executions);

    // Identify slow steps
    const averageWorkflowTime = executions
      .filter(e => e.status === 'completed')
      .reduce((sum, e) => sum + (e.duration || 0), 0) / executions.length || 0;

    for (const [stepId, metrics] of stepPerformance) {
      const step = workflow.steps.find(s => s.id === stepId);
      if (!step) continue;

      // Step takes more than 30% of total workflow time
      if (metrics.averageTime > averageWorkflowTime * 0.3) {
        bottlenecks.push({
          type: 'step',
          location: stepId,
          severity: Math.min(10, Math.floor((metrics.averageTime / averageWorkflowTime) * 10)),
          impact: `Step consumes ${Math.round((metrics.averageTime / averageWorkflowTime) * 100)}% of total workflow time`,
          resolution: 'Consider optimizing this step or running it in parallel with other operations',
          confidence: 0.8
        });
      }

      // High retry rate
      if (metrics.retryRate > 0.2) {
        bottlenecks.push({
          type: 'step',
          location: stepId,
          severity: Math.min(10, Math.floor(metrics.retryRate * 20)),
          impact: `Step has ${Math.round(metrics.retryRate * 100)}% retry rate`,
          resolution: 'Investigate step reliability and consider adjusting retry configuration',
          confidence: 0.9
        });
      }
    }

    // Identify dependency bottlenecks
    for (const step of workflow.steps) {
      if (step.dependencies.length > 0) {
        const dependencyTimes = step.dependencies
          .map(depId => stepPerformance.get(depId)?.averageTime || 0)
          .reduce((sum, time) => sum + time, 0);

        const stepTime = stepPerformance.get(step.id)?.averageTime || 0;
        
        if (dependencyTimes > stepTime * 2) {
          bottlenecks.push({
            type: 'dependency',
            location: step.id,
            severity: 6,
            impact: 'Step is blocked by slow dependencies',
            resolution: 'Consider parallelizing dependencies or reducing dependency chain',
            confidence: 0.7
          });
        }
      }
    }

    return bottlenecks.sort((a, b) => b.severity - a.severity);
  }

  private analyzeParallelizationOpportunities(
    workflow: WorkflowDefinition,
    stepPerformance: Map<string, StepPerformanceMetrics>
  ): OptimizationRecommendation | null {
    const sequentialSteps = workflow.steps.filter(step => 
      !step.canRunInParallel && step.dependencies.length === 0
    );

    if (sequentialSteps.length >= 2) {
      const totalSequentialTime = sequentialSteps.reduce((sum, step) => {
        const metrics = stepPerformance.get(step.id);
        return sum + (metrics?.averageTime || 0);
      }, 0);

      const expectedImprovement = Math.min(0.6, totalSequentialTime * 0.4 / 1000); // Cap at 60%

      return {
        type: 'parallelization',
        description: `Convert ${sequentialSteps.length} independent sequential steps to parallel execution`,
        expectedImprovement,
        complexity: 'medium',
        priority: expectedImprovement > 0.3 ? 'high' : 'medium',
        implementation: [
          'Mark independent steps as parallelizable',
          `Increase max concurrency to ${Math.min(sequentialSteps.length, 10)}`,
          'Test parallel execution performance'
        ]
      };
    }

    return null;
  }

  private analyzeCachingOpportunities(
    workflow: WorkflowDefinition,
    executions: WorkflowExecution[]
  ): OptimizationRecommendation | null {
    if (workflow.config.enableCaching) {
      return null; // Already enabled
    }

    const readOperations = workflow.steps.filter(step =>
      step.toolName.toLowerCase().includes('read') ||
      step.toolName.toLowerCase().includes('get') ||
      step.toolName.toLowerCase().includes('fetch')
    );

    if (readOperations.length > 0) {
      return {
        type: 'caching',
        description: `Enable caching for ${readOperations.length} read operations`,
        expectedImprovement: 0.4,
        complexity: 'low',
        priority: 'high',
        implementation: [
          'Enable workflow caching configuration',
          'Set appropriate TTL for cached operations',
          'Implement cache invalidation strategy'
        ]
      };
    }

    return null;
  }

  private analyzeResourceOptimizationOpportunities(
    workflow: WorkflowDefinition,
    executions: WorkflowExecution[]
  ): OptimizationRecommendation | null {
    const longRunningExecutions = executions.filter(e => 
      e.duration && e.duration > 300000 // 5 minutes
    );

    if (longRunningExecutions.length > executions.length * 0.2) {
      return {
        type: 'resource',
        description: 'Optimize resource allocation for long-running workflows',
        expectedImprovement: 0.25,
        complexity: 'medium',
        priority: 'medium',
        implementation: [
          'Set resource limits for workflow execution',
          'Implement resource monitoring',
          'Add timeout handling for long operations'
        ]
      };
    }

    return null;
  }

  private analyzeResourceUtilization(executions: WorkflowExecution[]): ResourceUtilization {
    // Simplified implementation - in reality would integrate with actual resource monitoring
    return {
      cpu: {
        average: 45,
        peak: 80,
        efficiency: 0.75
      },
      memory: {
        average: 512,
        peak: 1024,
        efficiency: 0.6
      },
      network: {
        average: 10,
        peak: 50,
        efficiency: 0.8
      },
      serverUtilization: new Map()
    };
  }

  private analyzeErrors(executions: WorkflowExecution[]): ErrorAnalysis {
    const failedExecutions = executions.filter(e => e.status === 'failed');
    const totalErrors = failedExecutions.length;
    
    const errorCategories = new Map<string, ErrorCategoryStats>();
    const commonErrors: Array<{ error: string; count: number; percentage: number }> = [];

    // Analyze error patterns (simplified)
    for (const execution of failedExecutions) {
      const errorMessage = execution.error?.message || 'Unknown error';
      const category = this.categorizeError(errorMessage);
      
      if (!errorCategories.has(category)) {
        errorCategories.set(category, {
          category,
          count: 0,
          percentage: 0,
          topError: errorMessage
        });
      }
      
      const stats = errorCategories.get(category)!;
      stats.count++;
    }

    // Calculate percentages
    for (const [, stats] of errorCategories) {
      stats.percentage = (stats.count / totalErrors) * 100;
    }

    return {
      totalErrors,
      errorRate: totalErrors / executions.length,
      errorCategories,
      commonErrors,
      trends: {
        increasing: [],
        stable: [],
        decreasing: []
      }
    };
  }

  private categorizeError(errorMessage: string): string {
    const message = errorMessage.toLowerCase();
    
    if (message.includes('timeout')) return 'timeout';
    if (message.includes('connection')) return 'connection';
    if (message.includes('permission') || message.includes('auth')) return 'authorization';
    if (message.includes('not found')) return 'not_found';
    if (message.includes('validation')) return 'validation';
    
    return 'other';
  }

  private calculatePercentile(values: number[], percentile: number): number {
    if (values.length === 0) return 0;
    
    const index = percentile * (values.length - 1);
    const lower = Math.floor(index);
    const upper = Math.ceil(index);
    
    if (lower === upper) {
      return values[lower];
    }
    
    const weight = index - lower;
    return values[lower] * (1 - weight) + values[upper] * weight;
  }

  private calculateParallelEfficiency(executions: WorkflowExecution[]): number {
    // Simplified calculation - would need more detailed metrics in practice
    return 0.75; // 75% parallel efficiency
  }

  private calculateResourceEfficiency(executions: WorkflowExecution[]): number {
    // Simplified calculation - would need actual resource usage data
    return 0.65; // 65% resource efficiency
  }
}

// =============================================================================
// Main Workflow Engine
// =============================================================================

export class AdvancedWorkflowEngine extends EventEmitter {
  private designer: WorkflowDesigner;
  private executionEngine: WorkflowExecutionEngine;
  private optimizer: WorkflowOptimizer;
  private workflows: Map<string, WorkflowDefinition> = new Map();
  private executionHistory: Map<string, WorkflowExecution[]> = new Map();

  constructor(optimizationEngine?: MCPOptimizationEngine) {
    super();
    
    this.designer = new WorkflowDesigner();
    this.executionEngine = new WorkflowExecutionEngine(optimizationEngine);
    this.optimizer = new WorkflowOptimizer(optimizationEngine);

    this.setupEventHandlers();
  }

  /**
   * Create a new workflow
   */
  createWorkflow(name: string, description?: string): WorkflowDefinitionBuilder {
    return this.designer.createWorkflow(name, description);
  }

  /**
   * Register a workflow definition
   */
  registerWorkflow(workflow: WorkflowDefinition): void {
    this.workflows.set(workflow.id, workflow);
    this.emit('workflowRegistered', { workflow });
  }

  /**
   * Get a registered workflow
   */
  getWorkflow(workflowId: string): WorkflowDefinition | null {
    return this.workflows.get(workflowId) || null;
  }

  /**
   * List all registered workflows
   */
  listWorkflows(): WorkflowDefinition[] {
    return Array.from(this.workflows.values());
  }

  /**
   * Execute a workflow
   */
  async executeWorkflow(
    workflowId: string,
    input: Record<string, any>,
    context?: Partial<WorkflowExecutionContext>
  ): Promise<WorkflowExecution> {
    const workflow = this.workflows.get(workflowId);
    if (!workflow) {
      throw new Error(`Workflow not found: ${workflowId}`);
    }

    const execution = await this.executionEngine.executeWorkflow(workflow, input, context);
    
    // Store execution in history
    if (!this.executionHistory.has(workflowId)) {
      this.executionHistory.set(workflowId, []);
    }
    this.executionHistory.get(workflowId)!.push(execution);

    // Update workflow performance stats
    await this.updateWorkflowPerformanceStats(workflowId, execution);

    return execution;
  }

  /**
   * Analyze workflow performance
   */
  async analyzeWorkflow(workflowId: string): Promise<WorkflowAnalytics> {
    const workflow = this.workflows.get(workflowId);
    if (!workflow) {
      throw new Error(`Workflow not found: ${workflowId}`);
    }

    const executions = this.executionHistory.get(workflowId) || [];
    return await this.optimizer.analyzePerformance(workflow, executions);
  }

  /**
   * Optimize a workflow
   */
  async optimizeWorkflow(workflowId: string): Promise<WorkflowDefinition> {
    const workflow = this.workflows.get(workflowId);
    if (!workflow) {
      throw new Error(`Workflow not found: ${workflowId}`);
    }

    const executions = this.executionHistory.get(workflowId) || [];
    const performanceStats = this.calculatePerformanceStats(executions);
    
    const optimizedWorkflow = await this.optimizer.optimizeWorkflow(workflow, performanceStats);
    
    // Register the optimized workflow
    this.registerWorkflow(optimizedWorkflow);
    
    return optimizedWorkflow;
  }

  /**
   * Get workflow execution history
   */
  getExecutionHistory(workflowId: string): WorkflowExecution[] {
    return this.executionHistory.get(workflowId) || [];
  }

  /**
   * Generate workflow performance report
   */
  async generatePerformanceReport(workflowId: string): Promise<WorkflowPerformanceReport> {
    const analytics = await this.analyzeWorkflow(workflowId);
    const executions = this.getExecutionHistory(workflowId);
    
    return {
      workflowId,
      generatedAt: new Date(),
      executionCount: executions.length,
      analytics,
      summary: this.generateReportSummary(analytics)
    };
  }

  private setupEventHandlers(): void {
    this.executionEngine.on('workflowStarted', (event) => {
      this.emit('workflowExecutionStarted', event);
    });

    this.executionEngine.on('workflowCompleted', (event) => {
      this.emit('workflowExecutionCompleted', event);
    });

    this.executionEngine.on('workflowFailed', (event) => {
      this.emit('workflowExecutionFailed', event);
    });

    this.optimizer.on('workflowOptimized', (event) => {
      this.emit('workflowOptimized', event);
    });
  }

  private async updateWorkflowPerformanceStats(
    workflowId: string,
    execution: WorkflowExecution
  ): Promise<void> {
    const workflow = this.workflows.get(workflowId);
    if (!workflow) return;

    const executions = this.getExecutionHistory(workflowId);
    const stats = this.calculatePerformanceStats(executions);

    if (!workflow.metadata) {
      workflow.metadata = {};
    }
    workflow.metadata.performanceStats = stats;
  }

  private calculatePerformanceStats(executions: WorkflowExecution[]): WorkflowPerformanceStats {
    const completedExecutions = executions.filter(e => e.status === 'completed');
    const failedExecutions = executions.filter(e => e.status === 'failed');

    const executionTimes = completedExecutions
      .map(e => e.duration || 0)
      .sort((a, b) => a - b);

    const averageExecutionTime = executionTimes.reduce((sum, time) => sum + time, 0) / executionTimes.length || 0;
    const medianExecutionTime = executionTimes.length > 0 ? 
      executionTimes[Math.floor(executionTimes.length / 2)] : 0;
    const p95ExecutionTime = executionTimes.length > 0 ?
      executionTimes[Math.floor(executionTimes.length * 0.95)] : 0;

    return {
      totalExecutions: executions.length,
      successfulExecutions: completedExecutions.length,
      failedExecutions: failedExecutions.length,
      averageExecutionTime,
      medianExecutionTime,
      p95ExecutionTime,
      successRate: completedExecutions.length / executions.length || 0,
      lastExecution: executions.length > 0 ? executions[executions.length - 1].startTime : undefined
    };
  }

  private generateReportSummary(analytics: WorkflowAnalytics): string {
    const recommendations = analytics.recommendations.length;
    const bottlenecks = analytics.bottlenecks.length;
    const successRate = Math.round(analytics.performance.successRate * 100);

    return `Workflow shows ${successRate}% success rate with ${bottlenecks} identified bottlenecks and ${recommendations} optimization recommendations.`;
  }
}

// Supporting interfaces for workflow reporting

export interface WorkflowPerformanceReport {
  workflowId: string;
  generatedAt: Date;
  executionCount: number;
  analytics: WorkflowAnalytics;
  summary: string;
}

// =============================================================================
// Exports
// =============================================================================

export {
  WorkflowDesigner,
  WorkflowExecutionEngine,
  WorkflowOptimizer,
  WorkflowDefinitionBuilder
};

export default AdvancedWorkflowEngine;