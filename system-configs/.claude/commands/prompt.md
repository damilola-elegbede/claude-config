---
description: Optimize prompts using SCOPE framework for effectiveness
argument-hint: [text-to-optimize or --file <path> or leave empty for interactive]
---

# /prompt Command

## Usage

```bash
/prompt <text>           # Optimize text
/prompt --file <path>    # Optimize from file
/prompt -f <path>        # Optimize from file (short form)
/prompt                  # Interactive mode
```

## Description

Optimize prompts using the SCOPE framework. Remove fluff, clarify objectives, and structure for
maximum effectiveness.

**SYSTEM BOUNDARY**: This command ONLY optimizes prompts and returns the optimized text.
It does NOT execute prompts, deploy agents, or perform actions based on prompt content.

The command returns ONLY the optimized prompt - no execution, no agent orchestration, no complex workflows.
Simple input → optimized output.

## Expected Output

### Output Format

```text
OPTIMIZED PROMPT:
[Clean optimized text following SCOPE framework]

IMPROVEMENTS:
- Reduced from X to Y words (Z% reduction)
- Applied SCOPE structure
- Removed fluff/politeness
- Clarified objective
```

### Before/After Example

**Original (52 words):**

```text
I need you to please help me write a Python function that can validate
email addresses and return true if they're valid or false if they're not.
It should handle various edge cases and be robust.
```

**Optimized (15 words):**

```text
Write Python email validation function.
Requirements:
- Return boolean
- Handle edge cases
- RFC 5322 compliant
```

**Result**: 71% shorter, 100% clearer

### Examples

#### Basic Usage

```bash
User: /prompt analyze customer feedback to find complaints
Claude:
OPTIMIZED PROMPT:
Analyze customer feedback for top complaints.

Requirements:
- Input: [Specify format]
- Output: Ranked list with counts

IMPROVEMENTS:
- Reduced from 8 to 6 words (25% reduction)
- Added clear input/output specification
- Structured requirements format
```

#### File Input

```bash
User: /prompt --file verbose_prompt.txt
Claude:
OPTIMIZED PROMPT:
Write Python email validation function.

Requirements:
- Return boolean
- Handle edge cases
- RFC 5322 compliant

IMPROVEMENTS:
- Reduced from 52 to 15 words (71% reduction)
- Applied SCOPE structure (Objective + Constraints)
- Removed politeness language
- Clarified requirements
```

### Success Criteria

The command succeeds when it delivers:

- ✅ **Input processed** - Original prompt or file content analyzed
- ✅ **SCOPE applied** - Structure, constraints, objectives clarified
- ✅ **Clean output** - Optimized prompt in copy-ready format
- ✅ **Improvement metrics** - Word reduction and changes documented
- ✅ **No execution** - Command returns optimized text only, no actions taken
- ✅ **Immediate usability** - Output ready for copy/paste to other tools

## Behavior

### SCOPE Framework

```yaml
S - Situation: Context (only if essential)
C - Constraints: Requirements, limitations
O - Objective: Single clear goal (REQUIRED)
P - Persona: Role needed (optional)
E - Examples: Input/output (if ambiguous)
```

### Optimization Rules

1. Remove: "please", "thank you", "I need you to"
2. Use active voice and start with verbs
3. Every word must be essential
4. Structure with bullets or numbered lists

### Interactive Mode (Optional)

For `/prompt` without arguments:

1. Request input text
2. Apply SCOPE optimization
3. Return optimized version immediately
4. Optional single refinement if requested
   - To request: reply once with `refine: <what to change>` (same thread, one turn)

File input: Supports .md, .txt, .yaml, .json

### Notes

- **Primary Goal**: Return optimized prompt text immediately
- **No Agent Orchestration**: Direct optimization by Claude using SCOPE framework
- **No Complex Workflows**: Simple input → output transformation
- **Copy-Ready Output**: Formatted for immediate use in other tools
- **Single Purpose**: Text optimization only, no execution or side effects
