#!/usr/bin/env python3
"""
Basic test script for performance-predictor agent structure and integration
Validates agent format, integration points, and core ML concepts without external dependencies
"""

import json
import yaml
import re
from datetime import datetime
import os

def test_agent_format():
    """Test agent YAML frontmatter format and structure"""
    print("Testing agent format and structure...")
    
    try:
        with open('.claude/agents/performance-predictor.md', 'r') as f:
            content = f.read()
        
        # Extract YAML frontmatter
        yaml_match = re.search(r'^---\n(.*?)\n---', content, re.DOTALL)
        if not yaml_match:
            print("❌ No YAML frontmatter found")
            return {'error': 'no_yaml_frontmatter'}
        
        yaml_content = yaml_match.group(1)
        agent_config = yaml.safe_load(yaml_content)
        
        # Validate required fields
        required_fields = ['name', 'description', 'tools', 'model', 'color', 'category']
        missing_fields = [field for field in required_fields if field not in agent_config]
        
        if missing_fields:
            print(f"❌ Missing required fields: {missing_fields}")
            return {'error': f'missing_fields: {missing_fields}'}
        
        # Validate field values
        validations = {
            'name': agent_config['name'] == 'performance-predictor',
            'model': agent_config['model'] == 'sonnet',
            'color': agent_config['color'] == 'yellow',
            'category': agent_config['category'] == 'analysis',
            'description_pattern': 'MUST BE USED for' in agent_config['description'],
            'proactive_pattern': 'Use PROACTIVELY' in agent_config['description']
        }
        
        all_valid = all(validations.values())
        
        print(f"✅ Agent Format Validation:")
        for key, valid in validations.items():
            print(f"   - {key}: {'PASS' if valid else 'FAIL'}")
        
        return {
            'format_valid': all_valid,
            'validations': validations
        }
        
    except Exception as e:
        print(f"❌ Agent format test failed: {e}")
        return {'error': str(e)}

def test_system_boundary():
    """Test SYSTEM BOUNDARY protection is present"""
    print("\nTesting SYSTEM BOUNDARY protection...")
    
    try:
        with open('.claude/agents/performance-predictor.md', 'r') as f:
            content = f.read()
        
        # Check for SYSTEM BOUNDARY section
        boundary_present = 'SYSTEM BOUNDARY' in content
        task_tool_protection = 'Task tool' in content and 'RESERVED EXCLUSIVELY for Claude' in content
        termination_protection = 'AUTOMATICALLY TERMINATE' in content
        
        print(f"✅ System Boundary Protection:")
        print(f"   - SYSTEM BOUNDARY section: {'PASS' if boundary_present else 'FAIL'}")
        print(f"   - Task tool protection: {'PASS' if task_tool_protection else 'FAIL'}")
        print(f"   - Auto-termination clause: {'PASS' if termination_protection else 'FAIL'}")
        
        return {
            'boundary_protection': boundary_present and task_tool_protection and termination_protection
        }
        
    except Exception as e:
        print(f"❌ System boundary test failed: {e}")
        return {'error': str(e)}

def test_ml_capabilities():
    """Test ML capabilities and concepts are properly defined"""
    print("\nTesting ML capabilities definition...")
    
    try:
        with open('.claude/agents/performance-predictor.md', 'r') as f:
            content = f.read()
        
        # Check for key ML concepts
        ml_concepts = {
            'time_series': any(term in content.lower() for term in ['prophet', 'arima', 'time series', 'forecasting']),
            'anomaly_detection': any(term in content.lower() for term in ['isolation forest', 'anomaly detection', 'outlier']),
            'capacity_planning': any(term in content.lower() for term in ['capacity planning', 'scaling', 'resource']),
            'model_validation': any(term in content.lower() for term in ['accuracy', 'mape', 'rmse', 'validation']),
            'ensemble_methods': any(term in content.lower() for term in ['ensemble', 'model combination', 'weighted']),
            'confidence_intervals': any(term in content.lower() for term in ['confidence', 'interval', 'uncertainty'])
        }
        
        all_concepts_present = all(ml_concepts.values())
        
        print(f"✅ ML Capabilities Coverage:")
        for concept, present in ml_concepts.items():
            print(f"   - {concept.replace('_', ' ').title()}: {'PASS' if present else 'FAIL'}")
        
        return {
            'ml_concepts_complete': all_concepts_present,
            'ml_concepts': ml_concepts
        }
        
    except Exception as e:
        print(f"❌ ML capabilities test failed: {e}")
        return {'error': str(e)}

def test_integration_points():
    """Test integration system definitions"""
    print("\nTesting integration system definitions...")
    
    try:
        with open('.claude/agents/performance-predictor.md', 'r') as f:
            content = f.read()
        
        # Check for integration systems
        integrations = {
            'prometheus': 'prometheus' in content.lower(),
            'datadog': 'datadog' in content.lower(),
            'cloudwatch': 'cloudwatch' in content.lower(),
            'grafana': 'grafana' in content.lower(),
            'new_relic': 'new relic' in content.lower(),
            'kubernetes': any(term in content.lower() for term in ['k8s', 'kubernetes', 'kubectl']),
            'apis': 'api' in content.lower() and 'curl' in content.lower()
        }
        
        integration_count = sum(integrations.values())
        
        print(f"✅ Integration Points Coverage:")
        for integration, present in integrations.items():
            print(f"   - {integration.replace('_', ' ').title()}: {'PASS' if present else 'FAIL'}")
        
        print(f"   - Total Integrations: {integration_count}/7")
        
        return {
            'integration_coverage': integration_count >= 5,  # At least 5 integrations
            'integrations': integrations
        }
        
    except Exception as e:
        print(f"❌ Integration points test failed: {e}")
        return {'error': str(e)}

def test_code_examples():
    """Test presence of code examples and implementation details"""
    print("\nTesting code examples and implementation...")
    
    try:
        with open('.claude/agents/performance-predictor.md', 'r') as f:
            content = f.read()
        
        # Check for code blocks and implementation details
        code_blocks = content.count('```')
        bash_examples = 'bash' in content and 'curl' in content
        python_examples = 'python' in content or 'def ' in content
        json_examples = 'json' in content.lower()
        
        implementation_details = {
            'code_blocks_present': code_blocks >= 4,  # At least 2 code blocks (4 markers)
            'bash_examples': bash_examples,
            'python_examples': python_examples,
            'json_examples': json_examples,
            'api_calls': 'curl' in content or 'requests' in content
        }
        
        implementation_complete = sum(implementation_details.values()) >= 3
        
        print(f"✅ Implementation Examples:")
        for detail, present in implementation_details.items():
            print(f"   - {detail.replace('_', ' ').title()}: {'PASS' if present else 'FAIL'}")
        
        return {
            'implementation_complete': implementation_complete,
            'code_blocks': code_blocks // 2,  # Actual number of code blocks
            'implementation_details': implementation_details
        }
        
    except Exception as e:
        print(f"❌ Code examples test failed: {e}")
        return {'error': str(e)}

def test_performance_metrics():
    """Test performance metrics and success criteria"""
    print("\nTesting performance metrics and success criteria...")
    
    try:
        with open('.claude/agents/performance-predictor.md', 'r') as f:
            content = f.read()
        
        # Look for specific performance targets
        metrics = {
            'accuracy_target': '85%' in content or '0.85' in content,
            'incident_reduction': '70%' in content and 'incident' in content.lower(),
            'cost_reduction': '30%' in content and 'cost' in content.lower(),
            'false_positive': '10%' in content and 'false positive' in content.lower(),
            'uptime_target': '99' in content and '%' in content,
            'prediction_horizon': '7-day' in content or '30-day' in content
        }
        
        metrics_complete = sum(metrics.values()) >= 4
        
        print(f"✅ Performance Metrics Definition:")
        for metric, present in metrics.items():
            print(f"   - {metric.replace('_', ' ').title()}: {'PASS' if present else 'FAIL'}")
        
        return {
            'metrics_complete': metrics_complete,
            'metrics': metrics
        }
        
    except Exception as e:
        print(f"❌ Performance metrics test failed: {e}")
        return {'error': str(e)}

def test_deployment_triggers():
    """Test proactive deployment triggers"""
    print("\nTesting proactive deployment triggers...")
    
    try:
        with open('.claude/agents/performance-predictor.md', 'r') as f:
            content = f.read()
        
        # Check for deployment trigger section
        triggers_section = 'Proactive Deployment Triggers' in content
        trigger_conditions = content.lower().count('when') >= 3  # At least 3 trigger conditions
        automatic_deployment = 'automatically deployed' in content.lower()
        
        trigger_types = {
            'performance_degradation': 'degradation' in content.lower(),
            'threshold_approaching': 'threshold' in content.lower() or '80%' in content,
            'anomaly_detection': 'anomaly' in content.lower() and 'confidence' in content.lower(),
            'capacity_review': 'capacity' in content.lower() and 'review' in content.lower(),
            'cost_optimization': 'cost' in content.lower() and 'optimization' in content.lower()
        }
        
        trigger_coverage = sum(trigger_types.values())
        
        print(f"✅ Deployment Triggers:")
        print(f"   - Triggers Section Present: {'PASS' if triggers_section else 'FAIL'}")
        print(f"   - Multiple Conditions: {'PASS' if trigger_conditions else 'FAIL'}")
        print(f"   - Automatic Deployment: {'PASS' if automatic_deployment else 'FAIL'}")
        
        for trigger, present in trigger_types.items():
            print(f"   - {trigger.replace('_', ' ').title()}: {'PASS' if present else 'FAIL'}")
        
        return {
            'triggers_complete': triggers_section and trigger_conditions and trigger_coverage >= 4,
            'trigger_types': trigger_types
        }
        
    except Exception as e:
        print(f"❌ Deployment triggers test failed: {e}")
        return {'error': str(e)}

def run_comprehensive_test():
    """Run comprehensive validation test suite"""
    print("🚀 Performance Predictor Agent Validation Tests\n")
    print("=" * 60)
    
    results = {}
    
    # Run all tests
    results['agent_format'] = test_agent_format()
    results['system_boundary'] = test_system_boundary()
    results['ml_capabilities'] = test_ml_capabilities()
    results['integration_points'] = test_integration_points()
    results['code_examples'] = test_code_examples()
    results['performance_metrics'] = test_performance_metrics()
    results['deployment_triggers'] = test_deployment_triggers()
    
    # Calculate overall results
    print("\n" + "=" * 60)
    print("📊 OVERALL VALIDATION RESULTS")
    print("=" * 60)
    
    passes = 0
    total = 0
    
    for test_name, test_result in results.items():
        if isinstance(test_result, dict) and 'error' not in test_result:
            # Find main validation keys
            main_keys = [k for k in test_result.keys() if not k.endswith('s') and not k.startswith('_')]
            for key, value in test_result.items():
                if key in ['format_valid', 'boundary_protection', 'ml_concepts_complete', 
                          'integration_coverage', 'implementation_complete', 'metrics_complete',
                          'triggers_complete']:
                    total += 1
                    if value:
                        passes += 1
                        print(f"✅ {test_name.replace('_', ' ').title()}: PASS")
                    else:
                        print(f"❌ {test_name.replace('_', ' ').title()}: FAIL")
        else:
            total += 1
            if 'error' in test_result:
                print(f"⚠️  {test_name.replace('_', ' ').title()}: ERROR - {test_result['error']}")
            else:
                passes += 1
                print(f"✅ {test_name.replace('_', ' ').title()}: PASS")
    
    success_rate = (passes / total * 100) if total > 0 else 0
    
    print(f"\n🎯 Validation Success Rate: {passes}/{total} ({success_rate:.1f}%)")
    print(f"🎯 Target Success Rate: 90%")
    print(f"🎯 Overall Assessment: {'EXCELLENT' if success_rate >= 95 else 'PASS' if success_rate >= 90 else 'NEEDS IMPROVEMENT'}")
    
    # Agent readiness assessment
    print(f"\n📋 Agent Readiness Assessment:")
    readiness_factors = [
        ("YAML Format", results.get('agent_format', {}).get('format_valid', False)),
        ("System Security", results.get('system_boundary', {}).get('boundary_protection', False)),
        ("ML Capabilities", results.get('ml_capabilities', {}).get('ml_concepts_complete', False)),
        ("Integration Points", results.get('integration_points', {}).get('integration_coverage', False)),
        ("Implementation Examples", results.get('code_examples', {}).get('implementation_complete', False)),
        ("Performance Metrics", results.get('performance_metrics', {}).get('metrics_complete', False)),
        ("Deployment Automation", results.get('deployment_triggers', {}).get('triggers_complete', False))
    ]
    
    for factor, status in readiness_factors:
        print(f"   - {factor}: {'✅ READY' if status else '⚠️  NEEDS ATTENTION'}")
    
    all_ready = all(status for _, status in readiness_factors)
    print(f"\n🚀 Production Readiness: {'✅ READY FOR DEPLOYMENT' if all_ready else '⚠️  REQUIRES UPDATES'}")
    
    # Save results
    results_file = '/tmp/performance_predictor_validation.json'
    with open(results_file, 'w') as f:
        json.dump(results, f, indent=2, default=str)
    
    print(f"\n📁 Detailed validation results saved to: {results_file}")
    
    return results

if __name__ == "__main__":
    run_comprehensive_test()