# Agent YAML Front-Matter Template
# This template defines the standard structure for all agent configuration files

---
# Required fields
name: agent-name  # Unique identifier for the agent (lowercase, hyphenated)
description: Brief one-line description of the agent's primary purpose and expertise

# Visual and hierarchy fields  
color: blue  # Visual identifier color
specialization_level: specialist  # One of: junior, specialist, senior, principal

# Expertise and capabilities
domain_expertise: 
  - primary_skill
  - secondary_skill
  - tertiary_skill

# Tool access configuration
tools:
  allowed: 
    - Glob
    - Grep
    - Read
    # Add other allowed tools
  forbidden:
    - Write  # List tools this agent should not access
    - MultiEdit
  rationale: Clear explanation of why these tool permissions are appropriate

# Coordination and escalation
parallel_compatible:
  - other-agent-1  # Agents that can work in parallel with this one
  - other-agent-2

escalation_to:
  - senior-agent-1  # Agents to escalate complex issues to
  - senior-agent-2

# Optional: Coordination protocols (if agent has specific coordination patterns)
coordination_protocols:
  with_agent_name:
    description: How this agent coordinates with the specified agent
    patterns:
      - Pattern 1 description
      - Pattern 2 description

# Optional: Examples section (extracted from description)
examples:
  - context: Brief context description
    user_request: What the user asks
    assistant_response: How the assistant uses this agent
    commentary: Optional explanation of why this agent is appropriate
    
  - context: Another example context
    user_request: Another user request
    assistant_response: Assistant's response
    commentary: Explanation

# Optional: Knowledge base or reference information
knowledge_base:
  key_area_1: Description or list of knowledge
  key_area_2: Additional knowledge areas

# Critical architecture constraints
architecture_constraints:
  agent_isolation: "NEVER call other agents directly - only the main agent can invoke subagents using Task tool"
  coordination_method: "All inter-agent coordination must go through main agent mediation"
  escalation_protocol: "Escalation means recommending main agent use higher-level agent, not direct calls"

# End of front-matter
---