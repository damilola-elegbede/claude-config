#!/usr/bin/env python3
"""
Standardize all agents according to the AGENT_TEMPLATE.md format.
This script ensures proper YAML front-matter matching the concise 46-line template.

CRITICAL: This script enforces the orchestration anti-pattern rule:
NO AGENT MAY HAVE ACCESS TO THE Task TOOL. Only Claude can orchestrate agents.
All agents follow the standardized template in system-configs/.claude/agents/AGENT_TEMPLATE.md
"""

import os
import re
import shutil
from pathlib import Path
from datetime import datetime

# Define the 28 production agents with their metadata
PRODUCTION_AGENTS = {
    # Development & Implementation
    'backend-engineer': {
        'description': 'MUST BE USED for server-side architecture, microservices, distributed systems, and database engineering. Use PROACTIVELY for high-performance optimization (>10k RPS), event-driven architecture, and complex backend infrastructure.',
        'tools': 'Read, Write, Edit, Bash, Grep, Glob',
        'model': 'sonnet',
        'category': 'development',
        'color': 'blue'
    },
    'frontend-engineer': {
        'description': 'Expert frontend engineer specializing in user interfaces, client-side applications, and performance optimization. Implements modern React/Vue/Angular applications with focus on user experience.',
        'tools': 'Read, Write, Edit, Bash, Grep, Glob',
        'model': 'sonnet',
        'category': 'development',
        'color': 'blue'
    },
    'fullstack-lead': {
        'description': 'Senior full-stack developer handling end-to-end development with auto-escalation for complex requirements. Coordinates frontend and backend implementation with technical leadership.',
        'tools': 'Read, Write, Edit, Bash, Grep, Glob',
        'model': 'sonnet',
        'category': 'development',
        'color': 'blue'
    },
    'mobile-engineer': {
        'description': 'Expert mobile engineer for native and cross-platform mobile application development. Specializes in iOS, Android, React Native, and Flutter applications.',
        'tools': 'Read, Write, Edit, Bash, Grep',
        'model': 'sonnet',
        'category': 'development',
        'color': 'blue'
    },
    'data-engineer': {
        'description': 'Expert data engineer specializing in data pipelines, ETL/ELT systems, and data warehouse architecture. Handles big data processing, streaming, and analytics infrastructure.',
        'tools': 'Read, Write, Edit, Bash, Grep',
        'model': 'sonnet',
        'category': 'development',
        'color': 'blue'
    },
    'ml-engineer': {
        'description': 'MUST BE USED for enterprise ML model deployment and advanced MLOps pipelines. Use PROACTIVELY for complex model serving architectures, feature store design, and distributed training infrastructure.',
        'tools': 'Read, Write, Edit, Bash, Grep',
        'model': 'opus',
        'category': 'development',
        'color': 'blue'
    },
    
    # Quality & Testing
    'test-engineer': {
        'description': 'MUST BE USED for comprehensive test strategy design and intelligent test implementation across frameworks. Use PROACTIVELY for untested code paths, CI/CD pipeline changes, and quality gate failures.',
        'tools': 'Read, Write, Edit, Bash, Grep',
        'model': 'sonnet',
        'category': 'quality',
        'color': 'green'
    },
    'code-reviewer': {
        'description': 'MUST BE USED for pre-commit reviews, vulnerability detection, and production readiness assessment. Use PROACTIVELY after code changes for quality review, security checks, best practices validation, and comprehensive code analysis.',
        'tools': 'Read, Grep, Bash',
        'model': 'sonnet',
        'category': 'quality',
        'color': 'green'
    },
    'debugger': {
        'description': 'MUST BE USED for investigating complex intermittent bugs, race conditions, and production-only failures. Use PROACTIVELY for distributed system failures, timing-dependent bugs, and concurrency issues requiring forensic analysis.',
        'tools': 'Read, Grep, Bash, Glob',
        'model': 'sonnet',
        'category': 'quality',
        'color': 'green'
    },
    'security-auditor': {
        'description': 'MUST BE USED for OWASP Top 10 checks, threat modeling, and vulnerability detection. Use PROACTIVELY for security audits, vulnerability assessments, compliance reviews, and threat detection.',
        'tools': 'Read, Grep, Bash, Edit',
        'model': 'opus',
        'category': 'security',
        'color': 'red'
    },
    'performance-engineer': {
        'description': 'Performance optimization, load testing, and benchmarking expert. Optimizes systems for speed, scalability, and resource efficiency.',
        'tools': 'Read, Grep, Bash, Edit',
        'model': 'sonnet',
        'category': 'quality',
        'color': 'green'
    },
    
    # Architecture
    'principal-architect': {
        'description': 'Use PROACTIVELY for system-wide architecture design and comprehensive technical roadmaps. MUST BE USED for complex architectural decisions, enterprise-scale implementation planning, and technical strategy development.',
        'tools': 'Read, Write',
        'model': 'opus',
        'category': 'architecture',
        'color': 'purple'
    },
    'api-architect': {
        'description': 'MUST BE USED for comprehensive API architecture, OpenAPI specs, and governance policy implementation. Use PROACTIVELY for API strategy, versioning management, GraphQL federation, and enterprise standardization.',
        'tools': 'Read, Write, Edit, Grep, Glob',
        'model': 'sonnet',
        'category': 'architecture',
        'color': 'purple'
    },
    'frontend-architect': {
        'description': 'MUST BE USED for architecting complex frontend systems >100k DAU and micro-frontend orchestration. Use PROACTIVELY for performance bottlenecks, Core Web Vitals degradation, and advanced React patterns.',
        'tools': 'Read, Write, Edit, MultiEdit, Grep, Glob, LS, Bash',
        'model': 'opus',
        'category': 'architecture',
        'color': 'purple'
    },
    
    # Design
    'ui-designer': {
        'description': 'MUST BE USED for comprehensive UI/UX design optimization and advanced design system architecture. Use PROACTIVELY for design inconsistencies, accessibility violations, and user experience friction points.',
        'tools': 'Read, Write, Edit',
        'model': 'sonnet',
        'category': 'design',
        'color': 'pink'
    },
    'mobile-ui': {
        'description': 'Mobile UI/UX design specialist for iOS/Android design patterns. Creates native mobile experiences following platform guidelines.',
        'tools': 'Read, Write',
        'model': 'sonnet',
        'category': 'design',
        'color': 'pink'
    },
    'ux-researcher': {
        'description': 'MUST BE USED for comprehensive user research strategy and advanced usability testing methodologies. Use PROACTIVELY for user experience friction, conversion optimization opportunities, and user feedback patterns.',
        'tools': 'Read, Write, Edit, Grep, Glob, LS, WebFetch',
        'model': 'sonnet',
        'category': 'design',
        'color': 'pink'
    },
    
    # Analysis & Research
    'codebase-analyst': {
        'description': 'Use PROACTIVELY for comprehensive code architecture analysis and technical debt assessment. MUST BE USED for evaluating codebases, creating executive summaries, and identifying security risks and performance bottlenecks.',
        'tools': 'Read, Grep, Glob, Bash',
        'model': 'sonnet',
        'category': 'analysis',
        'color': 'yellow'
    },
    'researcher': {
        'description': 'External research, technology evaluation, and industry analysis specialist. Provides comprehensive research insights and best practices.',
        'tools': 'Read, Grep, WebSearch, WebFetch',
        'model': 'sonnet',
        'category': 'analysis',
        'color': 'yellow'
    },
    'business-analyst': {
        'description': 'Requirements analysis, stakeholder communication, and process mapping expert. Specializes in translating business needs into technical specifications.',
        'tools': 'Read, Write, Grep',
        'model': 'sonnet',
        'category': 'analysis',
        'color': 'yellow'
    },
    'product-strategist': {
        'description': 'Strategic product guidance and feature prioritization specialist. Aligns technical development with business objectives.',
        'tools': 'Read, Write',
        'model': 'sonnet',
        'category': 'analysis',
        'color': 'yellow'
    },
    
    # Infrastructure & Operations
    'devops': {
        'description': 'MUST BE USED for complex CI/CD pipeline orchestration, enterprise Kubernetes clusters, and Infrastructure as Code at scale. Use PROACTIVELY for deployment bottlenecks, reliability issues, and multi-cloud Terraform deployments.',
        'tools': 'Read, Write, Bash',
        'model': 'sonnet',
        'category': 'infrastructure',
        'color': 'orange'
    },
    'platform-engineer': {
        'description': 'Use PROACTIVELY for platform engineering and developer experience optimization. MUST BE USED for building comprehensive platforms that empower development teams, implementing developer portals, and standardized workflows.',
        'tools': 'Read, Write, Edit, Bash, Grep',
        'model': 'sonnet',
        'category': 'infrastructure',
        'color': 'orange'
    },
    'cloud-architect': {
        'description': 'MUST BE USED for comprehensive cloud architecture design, enterprise migration strategies, and multi-cloud implementations. Use PROACTIVELY for AWS/Azure/GCP deployments, IaC development, and cloud-native pattern implementation.',
        'tools': 'Read, Write, Edit, Bash, Grep, Glob',
        'model': 'opus',
        'category': 'infrastructure',
        'color': 'orange'
    },
    'database-admin': {
        'description': 'Use PROACTIVELY for database optimization, security hardening, and performance tuning. MUST BE USED for query optimization, index management, high-availability configuration, and disaster recovery planning.',
        'tools': 'Read, Write, Edit, Bash, Grep',
        'model': 'sonnet',
        'category': 'infrastructure',
        'color': 'orange'
    },
    
    # Documentation & Coordination
    'tech-writer': {
        'description': 'Use PROACTIVELY for documentation, READMEs, API docs, and work summaries. MUST BE USED after completing multi-step tasks (3+ operations) or multi-file changes (5+ files).',
        'tools': 'Read, Write',
        'model': 'haiku',
        'category': 'documentation',
        'color': 'white'
    },
    'project-orchestrator': {
        'description': 'Use PROACTIVELY for multi-agent strategy planning. MUST BE USED for parallel execution analysis, resource optimization, workflow coordination, and team efficiency recommendations.',
        'tools': 'Read, Write',
        'model': 'sonnet',
        'category': 'coordination',
        'color': 'white'
    },
    'accessibility-auditor': {
        'description': 'MUST BE USED for WCAG compliance audits and accessibility violations remediation. Use PROACTIVELY for inclusive design validation, screen reader testing, keyboard navigation, and color contrast issues.',
        'tools': 'Read, Write, Edit, Grep, Glob',
        'model': 'sonnet',
        'category': 'quality',
        'color': 'green'
    }
}

def validate_agent_format(file_path):
    """Validate if an agent file follows the AGENT_TEMPLATE.md format."""
    with open(file_path, 'r') as f:
        lines = f.readlines()
    
    if len(lines) < 40 or len(lines) > 60:
        return False, f"File has {len(lines)} lines (expected ~46)"
    
    # Check for required YAML fields
    yaml_content = []
    in_yaml = False
    for line in lines:
        if line.strip() == '---':
            if not in_yaml:
                in_yaml = True
            else:
                break
        elif in_yaml:
            yaml_content.append(line)
    
    yaml_text = ''.join(yaml_content)
    required_fields = ['name:', 'description:', 'tools:', 'model:', 'category:']
    
    for field in required_fields:
        if field not in yaml_text:
            return False, f"Missing required YAML field: {field}"
    
    # Check for deprecated fields
    deprecated_fields = ['specialization_level:', 'domain_expertise:', 'coordination_protocols:', 'knowledge_base:', 'escalation_path:']
    for field in deprecated_fields:
        if field in yaml_text:
            return False, f"Contains deprecated field: {field}"
    
    # Check for required sections
    content = ''.join(lines)
    required_sections = ['## Identity', '## Core Capabilities', '## When to Engage', '## When NOT to Engage', '## Coordination', '## SYSTEM BOUNDARY']
    
    for section in required_sections:
        if section not in content:
            return False, f"Missing required section: {section}"
    
    return True, "Valid format"

def create_agent_from_template(agent_name, agent_info):
    """Create an agent file following the AGENT_TEMPLATE.md format."""
    
    # Determine the title case name
    title_name = agent_name.replace('-', ' ').title()
    
    # Create the content based on template
    content = f"""---
name: {agent_name}
description: {agent_info['description']}
tools: {agent_info['tools']}
model: {agent_info['model']}
category: {agent_info['category']}

color: {agent_info['color']}
---

# {title_name}

## Identity

Expert {agent_name.replace('-', ' ')} specializing in {get_specialization(agent_name, agent_info['category'])}. {get_value_proposition(agent_name, agent_info['category'])}

## Core Capabilities

{get_core_capabilities(agent_name, agent_info['category'])}

## When to Engage

{get_engagement_triggers(agent_name, agent_info['category'])}

## When NOT to Engage

{get_disengagement_conditions(agent_name, agent_info['category'])}

## Coordination

{get_coordination_info(agent_name, agent_info['category'])}

## SYSTEM BOUNDARY

This agent cannot invoke other agents or create Task calls. Only Claude has orchestration authority."""
    
    return content

def get_specialization(agent_name, category):
    """Get specialization text for an agent."""
    specializations = {
        'backend-engineer': 'distributed systems, microservices architecture, and high-performance server implementations',
        'frontend-engineer': 'modern UI frameworks, client-side performance, and responsive design',
        'test-engineer': 'test strategy design, automation frameworks, and quality assurance',
        'security-auditor': 'vulnerability assessment, threat modeling, and security compliance',
        'api-architect': 'API design patterns, versioning strategies, and contract-first development',
        'codebase-analyst': 'code architecture analysis, technical debt assessment, and performance bottlenecks'
    }
    return specializations.get(agent_name, f'{category} domain expertise')

def get_value_proposition(agent_name, category):
    """Get value proposition for an agent."""
    propositions = {
        'backend-engineer': 'Combines strategic architectural thinking with production-grade implementation skills for 100k+ RPS systems.',
        'frontend-engineer': 'Delivers pixel-perfect, performant user interfaces with exceptional user experience.',
        'security-auditor': 'Ensures comprehensive security coverage through systematic vulnerability assessment and threat modeling.',
        'test-engineer': 'Guarantees quality through intelligent test design and comprehensive coverage strategies.'
    }
    return propositions.get(agent_name, f'Provides expert {category} capabilities with focus on quality and efficiency.')

def get_core_capabilities(agent_name, category):
    """Get core capabilities list for an agent."""
    capabilities = {
        'backend-engineer': """- Distributed systems design with consensus algorithms and CAP theorem application
- Microservices architecture with proper service boundaries and communication patterns
- Performance optimization for sub-100ms latency and 100k+ RPS handling
- Database engineering including sharding, replication, and query optimization
- Event-driven architecture with message queues and streaming platforms""",
        
        'frontend-engineer': """- Modern framework expertise (React, Vue, Angular) with advanced patterns
- Performance optimization including bundle size, lazy loading, and rendering
- Responsive design and cross-browser compatibility
- State management and data flow architecture
- Accessibility and internationalization implementation""",
        
        'security-auditor': """- OWASP Top 10 vulnerability assessment and remediation
- Security code review and threat modeling
- Authentication and authorization system validation
- Cryptography implementation review
- Compliance verification (SOC2, PCI-DSS, GDPR)"""
    }
    
    return capabilities.get(agent_name, f"""- Core {category} expertise
- Best practices implementation
- Quality assurance and validation
- Performance optimization
- Documentation and knowledge transfer""")

def get_engagement_triggers(agent_name, category):
    """Get engagement triggers for an agent."""
    triggers = {
        'backend-engineer': """- Server-side code modifications or new API endpoints
- Database schema changes or query optimization needs
- Performance issues exceeding 100ms latency thresholds
- Microservices architecture design or modifications""",
        
        'security-auditor': """- Authentication or authorization code changes
- Handling sensitive data or PII
- Security vulnerability reports or incidents
- Compliance audit requirements""",
        
        'test-engineer': """- New feature implementation requiring test coverage
- CI/CD pipeline failures or quality gate violations
- Test framework selection or migration
- Coverage gaps identified in codebase"""
    }
    
    return triggers.get(agent_name, f"""- {category.title()} expertise required
- Complex technical challenges in domain
- Quality or performance concerns
- User request for specialized assistance""")

def get_disengagement_conditions(agent_name, category):
    """Get disengagement conditions for an agent."""
    conditions = {
        'backend-engineer': """- Pure frontend or UI-only changes
- Documentation updates without code changes""",
        
        'frontend-engineer': """- Backend-only API changes without UI impact
- Database or infrastructure modifications""",
        
        'security-auditor': """- Non-security code refactoring
- Pure performance optimization without security implications"""
    }
    
    return conditions.get(agent_name, f"""- Tasks outside {category} domain
- Simple tasks better handled directly by Claude""")

def get_coordination_info(agent_name, category):
    """Get coordination information for an agent."""
    coordination = {
        'backend-engineer': """Works in parallel with frontend-engineer for full-stack features.
Escalates to principal-architect for system-wide architectural decisions.""",
        
        'frontend-engineer': """Works in parallel with backend-engineer for API integration.
Escalates to frontend-architect for complex architectural patterns.""",
        
        'security-auditor': """Works in parallel with code-reviewer for comprehensive review.
Escalates to Claude when security fixes require architectural changes."""
    }
    
    return coordination.get(agent_name, f"""Works in parallel with related {category} agents.
Escalates to Claude when blocked or requiring cross-domain coordination.""")

def main():
    """Main execution function."""
    agents_dir = Path('system-configs/.claude/agents')
    
    print("=== Agent Standardization to AGENT_TEMPLATE.md Format ===\n")
    print(f"Target: 28 production agents following 46-line template\n")
    
    # Get existing agent files (excluding template and README)
    existing_agents = [f.stem for f in agents_dir.glob('*.md') 
                      if f.name not in ['AGENT_TEMPLATE.md', 'README.md']]
    
    print(f"Found {len(existing_agents)} existing agent files")
    
    # Validate existing agents
    validation_results = []
    for agent_name in sorted(existing_agents):
        file_path = agents_dir / f"{agent_name}.md"
        valid, message = validate_agent_format(file_path)
        validation_results.append((agent_name, valid, message))
        
        if valid:
            print(f"✅ {agent_name}: Valid format")
        else:
            print(f"⚠️  {agent_name}: {message}")
    
    # Count valid agents
    valid_count = sum(1 for _, valid, _ in validation_results if valid)
    
    print(f"\n=== Summary ===")
    print(f"Valid agents: {valid_count}/{len(existing_agents)}")
    print(f"Target agents: 28")
    
    if valid_count == 28:
        print("\n✅ All agents follow the AGENT_TEMPLATE.md format!")
    else:
        print(f"\n⚠️  {28 - valid_count} agents need updating to match template")
    
    # Generate report
    report_path = Path('.tmp/reports/agent-validation-report.md')
    report_path.parent.mkdir(parents=True, exist_ok=True)
    
    with open(report_path, 'w') as f:
        f.write(f"# Agent Validation Report\n\n")
        f.write(f"Generated: {datetime.now().isoformat()}\n\n")
        f.write(f"## Summary\n\n")
        f.write(f"- Total agents: {len(existing_agents)}\n")
        f.write(f"- Valid format: {valid_count}\n")
        f.write(f"- Need updating: {len(existing_agents) - valid_count}\n\n")
        
        f.write("## Validation Results\n\n")
        for agent_name, valid, message in sorted(validation_results):
            status = "✅" if valid else "❌"
            f.write(f"- {status} **{agent_name}**: {message}\n")
    
    print(f"\nReport saved to: {report_path}")

if __name__ == '__main__':
    main()