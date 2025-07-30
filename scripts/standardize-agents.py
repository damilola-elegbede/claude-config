#!/usr/bin/env python3
"""
Standardize all agents according to the consolidated 26-agent system.
This script ensures proper YAML front-matter and handles consolidation.

CRITICAL: This script enforces the orchestration anti-pattern rule:
NO AGENT MAY HAVE ACCESS TO THE Task TOOL. Only Claude can orchestrate agents.
All agent-to-agent coordination MUST go through Claude as the orchestration engine.
"""

import os
import re
import shutil
from pathlib import Path
from datetime import datetime

# Define the final 26 agents with their categories and colors
FINAL_AGENTS = {
    # 🔵 Development & Implementation (6 agents)
    'backend-engineer': {'color': 'blue', 'category': 'development', 'level': 'senior'},
    'frontend-engineer': {'color': 'blue', 'category': 'development', 'level': 'senior'},
    'fullstack-lead': {'color': 'blue', 'category': 'development', 'level': 'senior'},
    'mobile-engineer': {'color': 'blue', 'category': 'development', 'level': 'senior'},
    'data-engineer': {'color': 'blue', 'category': 'development', 'level': 'senior'},
    'ml-engineer': {'color': 'blue', 'category': 'development', 'level': 'senior'},
    
    # 🟢 Quality & Testing (5 agents)
    'test-engineer': {'color': 'green', 'category': 'quality', 'level': 'senior'},
    'code-reviewer': {'color': 'green', 'category': 'quality', 'level': 'senior'},
    'debugger': {'color': 'green', 'category': 'quality', 'level': 'specialist'},
    'security-auditor': {'color': 'green', 'category': 'quality', 'level': 'specialist'},
    'performance-engineer': {'color': 'green', 'category': 'quality', 'level': 'specialist'},
    
    # 🟣 Architecture (2 agents)
    'principal-architect': {'color': 'purple', 'category': 'architecture', 'level': 'principal'},
    'api-architect': {'color': 'purple', 'category': 'architecture', 'level': 'senior'},
    
    # 🩷 Design (2 agents)
    'ui-designer': {'color': 'pink', 'category': 'design', 'level': 'specialist'},
    'mobile-ui': {'color': 'pink', 'category': 'design', 'level': 'specialist'},
    
    # 🟣 Analysis & Research (3 agents)
    'codebase-analyst': {'color': 'purple', 'category': 'analysis', 'level': 'specialist'},
    'researcher': {'color': 'purple', 'category': 'analysis', 'level': 'specialist'},
    'business-analyst': {'color': 'purple', 'category': 'analysis', 'level': 'specialist'},
    
    # 🟡 Infrastructure & Operations (3 agents)
    'devops': {'color': 'yellow', 'category': 'infrastructure', 'level': 'senior'},
    'platform-engineer': {'color': 'yellow', 'category': 'infrastructure', 'level': 'senior'},
    'cloud-architect': {'color': 'yellow', 'category': 'infrastructure', 'level': 'senior'},
    
    # 🟠 Documentation & Support (3 agents)
    'tech-writer': {'color': 'orange', 'category': 'documentation', 'level': 'specialist'},
    'project-orchestrator': {'color': 'orange', 'category': 'documentation', 'level': 'senior'},
    'product-strategist': {'color': 'orange', 'category': 'documentation', 'level': 'senior'},
    
    # ⚪ Specialized Support (2 agents)
    'accessibility-auditor': {'color': 'white', 'category': 'specialized', 'level': 'specialist'},
    'database-admin': {'color': 'white', 'category': 'specialized', 'level': 'specialist'},
}

# Agents to be removed or consolidated
DEPRECATED_AGENTS = {
    'qa-tester': 'test-engineer',  # Merge into test-engineer
    'doc-updater': 'tech-writer',  # Merge into tech-writer
    'reliability-engineer': 'platform-engineer',  # Merge into platform-engineer
    'senior-dev': None,  # Remove - not in final 26
    'fullstack-dev': 'fullstack-lead',  # Rename to fullstack-lead
    'db-admin': 'database-admin',  # Rename to database-admin
    'test-data-manager': None,  # Remove - not in final 26
    'agent-architect': None,  # Remove - not in final 26
    'agent-auditor': None,  # Remove - not in final 26
    'arch-reviewer': None,  # Remove - not in final 26
    'tech-lead': None,  # Remove - not in final 26
}

def extract_content_sections(file_path):
    """Extract YAML and markdown content from file."""
    with open(file_path, 'r') as f:
        content = f.read()
    
    match = re.match(r'^---\n(.*?)\n---\n(.*)', content, re.DOTALL)
    if match:
        return match.group(1), match.group(2)
    return '', content

def create_standardized_yaml(agent_name, agent_info, existing_yaml=''):
    """Create standardized YAML front-matter."""
    
    # Parse some basic info from existing YAML if available
    description = ''
    domain_expertise = []
    
    if existing_yaml:
        desc_match = re.search(r'description:\s*(.+)', existing_yaml)
        if desc_match:
            description = desc_match.group(1).strip()
    
    if not description:
        descriptions = {
            'backend-engineer': 'Expert backend engineer specializing in server-side architecture, APIs, databases, and distributed systems',
            'frontend-engineer': 'Expert frontend engineer specializing in user interfaces, client-side applications, and performance optimization',
            'fullstack-lead': 'Senior full-stack developer handling end-to-end development with auto-escalation for complex requirements',
            'mobile-engineer': 'Expert mobile engineer for native and cross-platform mobile application development',
            'data-engineer': 'Expert data engineer specializing in data pipelines, ETL/ELT systems, and data warehouse architecture',
            'ml-engineer': 'Expert ML engineer for machine learning systems, model deployment, and MLOps',
            'test-engineer': 'Comprehensive testing strategy, test implementation, and quality assurance expert',
            'code-reviewer': 'Pre-commit code quality review, style compliance, and PR readiness specialist',
            'debugger': 'Complex bug investigation and systematic root cause analysis expert',
            'security-auditor': 'Security vulnerability assessment and compliance review specialist',
            'performance-engineer': 'Performance optimization, load testing, and benchmarking expert',
            'principal-architect': 'System architecture design, technical roadmaps, and implementation planning leader',
            'api-architect': 'API design, governance, implementation, and lifecycle management expert',
            'ui-designer': 'Visual design, UX optimization, and design systems specialist for web/desktop',
            'mobile-ui': 'Mobile UI/UX design specialist for iOS/Android design patterns',
            'codebase-analyst': 'Internal code analysis, architecture assessment, and technical reporting expert',
            'researcher': 'External research, technology evaluation, and industry analysis specialist',
            'business-analyst': 'Requirements analysis, stakeholder communication, and process mapping expert',
            'devops': 'Deployment automation, CI/CD pipelines, and application deployment coordinator',
            'platform-engineer': 'Production reliability, monitoring, and SRE practices specialist',
            'cloud-architect': 'Cloud deployment and infrastructure design expert',
            'tech-writer': 'Technical documentation, API docs, and knowledge management specialist',
            'project-orchestrator': 'Multi-agent coordination and parallel execution planning expert',
            'product-strategist': 'Strategic product guidance and feature prioritization specialist',
            'accessibility-auditor': 'Accessibility testing and WCAG compliance specialist',
            'database-admin': 'Database security, optimization, and administration expert'
        }
        description = descriptions.get(agent_name, f'Expert {agent_name} agent')
    
    # Define domain expertise based on agent type
    domain_map = {
        'backend-engineer': ['server_architecture', 'api_development', 'database_design', 'distributed_systems'],
        'frontend-engineer': ['ui_development', 'client_applications', 'performance_optimization', 'user_experience'],
        'fullstack-lead': ['full_stack_development', 'system_integration', 'technical_leadership'],
        'mobile-engineer': ['mobile_development', 'native_apps', 'cross_platform', 'app_deployment'],
        'data-engineer': ['data_pipelines', 'etl_systems', 'data_warehousing', 'big_data'],
        'ml-engineer': ['machine_learning', 'model_deployment', 'mlops', 'ai_systems'],
        'test-engineer': ['test_strategy', 'test_automation', 'quality_assurance', 'test_coverage'],
        'code-reviewer': ['code_quality', 'style_compliance', 'pr_review', 'best_practices'],
        'debugger': ['bug_investigation', 'root_cause_analysis', 'system_debugging'],
        'security-auditor': ['security_assessment', 'vulnerability_testing', 'compliance_review'],
        'performance-engineer': ['performance_optimization', 'load_testing', 'benchmarking'],
        'principal-architect': ['system_architecture', 'technical_strategy', 'architectural_decisions'],
        'api-architect': ['api_design', 'api_governance', 'api_lifecycle', 'contract_design'],
        'ui-designer': ['visual_design', 'ux_design', 'design_systems', 'web_desktop_ui'],
        'mobile-ui': ['mobile_ux', 'ios_design', 'android_design', 'mobile_patterns'],
        'codebase-analyst': ['code_analysis', 'architecture_assessment', 'technical_reporting'],
        'researcher': ['technology_research', 'industry_analysis', 'best_practices_research'],
        'business-analyst': ['requirements_analysis', 'stakeholder_management', 'process_mapping'],
        'devops': ['deployment_automation', 'cicd_pipelines', 'infrastructure_automation'],
        'platform-engineer': ['site_reliability', 'monitoring_observability', 'production_operations'],
        'cloud-architect': ['cloud_infrastructure', 'cloud_deployment', 'infrastructure_design'],
        'tech-writer': ['technical_documentation', 'api_documentation', 'knowledge_management'],
        'project-orchestrator': ['multi_agent_coordination', 'project_planning', 'execution_optimization'],
        'product-strategist': ['product_strategy', 'feature_prioritization', 'product_planning'],
        'accessibility-auditor': ['accessibility_testing', 'wcag_compliance', 'inclusive_design'],
        'database-admin': ['database_administration', 'database_security', 'database_optimization']
    }
    
    domain_expertise = domain_map.get(agent_name, ['general_expertise'])
    
    yaml_content = f"""---
name: {agent_name}
description: {description}
color: {agent_info['color']}
specialization_level: {agent_info['level']}

domain_expertise:"""
    
    for expertise in domain_expertise:
        yaml_content += f"\n  - {expertise}"
    
    # Tools section
    yaml_content += "\n\ntools:"
    yaml_content += "\n  allowed:"
    
    # Define allowed tools based on agent category
    if agent_info['category'] == 'development':
        yaml_content += "\n    read: \"Analyzing existing code and documentation\""
        yaml_content += "\n    write: \"Implementing features and creating code\""
        yaml_content += "\n    bash: \"Running development commands and scripts\""
        yaml_content += "\n    # NO Task tool - Claude handles all orchestration"
    elif agent_info['category'] in ['quality', 'analysis']:
        yaml_content += "\n    read: \"Analyzing code and documentation\""
        yaml_content += "\n    grep: \"Searching for patterns and issues\""
        yaml_content += "\n    bash: \"Running analysis and test commands\""
        yaml_content += "\n    # NO Task tool - Claude handles all orchestration"
    elif agent_info['category'] == 'architecture':
        yaml_content += "\n    read: \"Reviewing existing architecture and code\""
        yaml_content += "\n    write: \"Creating architectural documentation and specs\""
        yaml_content += "\n    # NO Task tool - Claude handles all orchestration"
    elif agent_info['category'] == 'infrastructure':
        yaml_content += "\n    read: \"Analyzing infrastructure and configurations\""
        yaml_content += "\n    write: \"Creating infrastructure code and configs\""
        yaml_content += "\n    bash: \"Running infrastructure commands\""
        yaml_content += "\n    # NO Task tool - Claude handles all orchestration"
    else:
        yaml_content += "\n    read: \"Accessing relevant information\""
        yaml_content += "\n    write: \"Creating documentation and reports\""
        yaml_content += "\n    # NO Task tool - Claude handles all orchestration"
    
    yaml_content += "\n  forbidden:"
    if agent_info['category'] != 'infrastructure':
        yaml_content += "\n    deploy: \"Production deployment restricted to infrastructure agents\""
    else:
        yaml_content += "\n    none: \"Infrastructure agents have broad access for operations\""
    
    # Coordination protocols
    yaml_content += "\n\ncoordination_protocols:"
    yaml_content += "\n  handoff_to:"
    
    # Define handoffs based on agent type
    handoff_map = {
        'backend-engineer': {'frontend-engineer': 'API integration specifications', 'test-engineer': 'Test requirements'},
        'frontend-engineer': {'backend-engineer': 'API requirements', 'ui-designer': 'Design implementation'},
        'fullstack-lead': {'principal-architect': 'Complex architectural decisions', 'test-engineer': 'Quality validation'},
        'test-engineer': {'code-reviewer': 'Quality gate approval', 'debugger': 'Complex test failures'},
        'principal-architect': {'api-architect': 'API design requirements', 'cloud-architect': 'Infrastructure needs'},
        'devops': {'platform-engineer': 'Production monitoring setup', 'security-auditor': 'Security validation'}
    }
    
    handoffs = handoff_map.get(agent_name, {'test-engineer': 'Quality validation'})
    for target, reason in handoffs.items():
        yaml_content += f"\n    {target}: \"{reason}\""
    
    yaml_content += "\n  parallel_compatible:"
    
    # Define parallel compatible agents
    parallel_map = {
        'backend-engineer': ['frontend-engineer', 'test-engineer', 'devops'],
        'frontend-engineer': ['backend-engineer', 'ui-designer', 'test-engineer'],
        'test-engineer': ['code-reviewer', 'security-auditor', 'performance-engineer'],
        'principal-architect': ['api-architect', 'cloud-architect', 'product-strategist']
    }
    
    parallel_agents = parallel_map.get(agent_name, ['test-engineer', 'code-reviewer'])
    for agent in parallel_agents:
        yaml_content += f"\n    - {agent}"
    
    yaml_content += "\n  escalation_path:"
    
    # Define escalation paths
    escalation_map = {
        'backend-engineer': 'principal-architect',
        'frontend-engineer': 'principal-architect',
        'fullstack-lead': 'principal-architect',
        'test-engineer': 'project-orchestrator',
        'code-reviewer': 'tech-lead',
        'api-architect': 'principal-architect'
    }
    
    escalation = escalation_map.get(agent_name, 'principal-architect')
    yaml_content += f"\n    {escalation}: \"Complex decisions beyond current scope\""
    
    # Knowledge base and examples
    yaml_content += "\n\nknowledge_base:"
    yaml_content += f"\n  - {agent_info['category'].title()} best practices and patterns"
    yaml_content += "\n\nexamples:"
    yaml_content += f"\n  - scenario: \"Typical {agent_name.replace('-', ' ')} task\""
    yaml_content += f"\n    approach: \"Systematic approach using {agent_info['category']} expertise\""
    
    yaml_content += "\n---"
    
    return yaml_content

def process_agent(agent_name, agents_dir, deprecated_dir):
    """Process a single agent file."""
    file_path = agents_dir / f"{agent_name}.md"
    
    # Check if this is a deprecated agent
    if agent_name in DEPRECATED_AGENTS:
        target = DEPRECATED_AGENTS[agent_name]
        if target is None:
            # Move to deprecated
            print(f"Deprecating: {agent_name}")
            if file_path.exists():
                shutil.move(str(file_path), str(deprecated_dir / f"{agent_name}.md"))
        else:
            # This agent is being merged/renamed
            print(f"Consolidating: {agent_name} -> {target}")
            if file_path.exists():
                # Save content for potential merge
                shutil.copy(str(file_path), str(deprecated_dir / f"{agent_name}.md"))
                os.remove(file_path)
        return
    
    # Check if this is a final agent
    if agent_name not in FINAL_AGENTS:
        print(f"Unknown agent: {agent_name} (moving to deprecated)")
        if file_path.exists():
            shutil.move(str(file_path), str(deprecated_dir / f"{agent_name}.md"))
        return
    
    # Process final agent
    agent_info = FINAL_AGENTS[agent_name]
    
    if file_path.exists():
        # Update existing file
        yaml_section, markdown_content = extract_content_sections(file_path)
        new_yaml = create_standardized_yaml(agent_name, agent_info, yaml_section)
        
        with open(file_path, 'w') as f:
            f.write(new_yaml)
            f.write('\n')
            f.write(markdown_content)
        
        print(f"Updated: {agent_name}")
    else:
        # Create new file for agents that don't exist yet
        print(f"Creating: {agent_name}")
        new_yaml = create_standardized_yaml(agent_name, agent_info)
        
        # Basic template content
        markdown_content = f"""
# {agent_name.replace('-', ' ').title()}

## Identity
You are an expert {agent_name.replace('-', ' ')} specializing in {agent_info['category']} tasks.

## Core Capabilities
- Primary expertise in {agent_info['category']} domain
- Collaborative approach with other agents
- Focus on quality and best practices

## When to Engage
- When {agent_info['category']} expertise is required
- For tasks requiring {agent_name.replace('-', ' ')} skills

## Coordination
- Works well with parallel agents for efficient execution
- Clear handoff protocols with downstream agents
- Escalates complex decisions appropriately
"""
        
        with open(file_path, 'w') as f:
            f.write(new_yaml)
            f.write('\n')
            f.write(markdown_content)

def main():
    """Main execution function."""
    agents_dir = Path('/Users/damilola/Documents/Projects/claude-config/.claude/agents')
    deprecated_dir = Path('/Users/damilola/Documents/Projects/claude-config/.claude/deprecated/agents')
    
    # Create deprecated directory
    deprecated_dir.mkdir(parents=True, exist_ok=True)
    
    print("=== Agent Standardization Process ===\n")
    
    # Get all existing agent files
    existing_agents = [f.stem for f in agents_dir.glob('*.md') if f.name != 'README.md']
    
    print(f"Found {len(existing_agents)} existing agent files")
    print(f"Target: {len(FINAL_AGENTS)} final agents\n")
    
    # Process existing agents
    for agent_name in sorted(existing_agents):
        process_agent(agent_name, agents_dir, deprecated_dir)
    
    # Create any missing final agents
    print("\n=== Creating Missing Agents ===\n")
    for agent_name in sorted(FINAL_AGENTS.keys()):
        if agent_name not in existing_agents:
            process_agent(agent_name, agents_dir, deprecated_dir)
    
    # Generate summary report
    print("\n=== Summary Report ===\n")
    
    final_agents = list(agents_dir.glob('*.md'))
    final_agents = [f for f in final_agents if f.name != 'README.md']
    
    print(f"Final agent count: {len(final_agents)}")
    print(f"Deprecated agents: {len(list(deprecated_dir.glob('*.md')))}")
    
    # Create detailed report
    report_path = Path('/Users/damilola/Documents/Projects/claude-config/docs/agent-standardization-report.md')
    with open(report_path, 'w') as f:
        f.write(f"# Agent Standardization Report\n\n")
        f.write(f"Generated: {datetime.now().isoformat()}\n\n")
        f.write(f"## Summary\n\n")
        f.write(f"- Final agents: {len(final_agents)}\n")
        f.write(f"- Deprecated: {len(list(deprecated_dir.glob('*.md')))}\n")
        f.write(f"- Target: {len(FINAL_AGENTS)}\n\n")
        
        f.write("## Final Agent List\n\n")
        for category in ['development', 'quality', 'architecture', 'analysis', 'infrastructure', 'documentation', 'specialized']:
            agents_in_cat = [name for name, info in FINAL_AGENTS.items() if info['category'] == category]
            if agents_in_cat:
                f.write(f"### {category.title()} ({len(agents_in_cat)} agents)\n")
                for agent in sorted(agents_in_cat):
                    info = FINAL_AGENTS[agent]
                    f.write(f"- **{agent}** ({info['color']}, {info['level']})\n")
                f.write("\n")
    
    print(f"\nReport saved to: {report_path}")

if __name__ == '__main__':
    main()