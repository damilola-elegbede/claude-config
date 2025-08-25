# /prompt Command

## Description

Optimizes prompts using the SCOPE framework. Removes fluff, clarifies objectives, and structures for maximum effectiveness.

## Usage

```bash
/prompt <text>           # Optimize text
/prompt --file <path>    # Optimize from file
/prompt -f <path>        # Optimize from file (short form)
/prompt                  # Interactive mode
```bash

## Behavior
## Agent Orchestration

### Parallel Prompt Optimization

Deploy specialized agents for comprehensive optimization:

```yaml
tech-writer:
  role: Clarity and conciseness optimization
  input: Original prompt, context
  output: Clearer, more concise version

business-analyst:
  role: Objective extraction and refinement
  input: Prompt content, implied goals
  output: Clear objectives, success criteria

ux-researcher:
  role: User intent analysis
  input: Prompt context, user patterns
  output: Intent clarification, user needs
```bash

### Parallel Analysis Benefits

```yaml
Optimization Streams:
  - Clarity, brevity, effectiveness analyzed simultaneously
  - Multiple optimization strategies tested in parallel
  - Best approach selected from parallel results
```

When invoked, I will apply the SCOPE framework to optimize prompts for maximum
clarity and effectiveness. I remove unnecessary words, clarify objectives, and
structure prompts to achieve better results with fewer tokens.

## SCOPE Framework

```yaml
S - Situation: Context (only if essential)
C - Constraints: Requirements, limitations
O - Objective: Single clear goal (REQUIRED)
P - Persona: Role needed (optional)
E - Examples: Input/output (if ambiguous)
```bash

### Rules

1. Remove: "please", "thank you", "I need you to"
2. Use active voice and start with verbs
3. Every word must be essential
4. Structure with bullets or numbered lists

## Interactive Mode

1. Present optimized version
2. Options: `approve`, `revise`, `shorter`, `cancel`
3. Iterate until approved

File input: Supports .md, .txt, .yaml, .json

## Before/After Example

**Original (52 words):**

```text
I need you to please help me write a Python function that can validate
email addresses and return true if they're valid or false if they're not.
It should handle various edge cases and be robust.
```bash

**Optimized (15 words):**

```text
Write Python email validation function.
Requirements:
- Return boolean
- Handle edge cases
- RFC 5322 compliant
```bash

**Result**: 71% shorter, 100% clearer

## Examples

```bash
User: /prompt analyze customer feedback to find complaints
Claude:
╔═══════════════════════════════════╗
║ OPTIMIZED PROMPT                  ║
╚═══════════════════════════════════╝
Analyze customer feedback for top complaints.
Input: [Specify format]
Output: Ranked list with counts

Refine? (approve/revise/shorter)

User: revise - input is CSV with date, rating, comment
Claude:
╔═══════════════════════════════════╗
║ OPTIMIZED PROMPT v2               ║
╚═══════════════════════════════════╝
Analyze CSV for top complaints.
Input: CSV (date, rating, comment)
Output: Ranked complaints with frequency

User: approve
Claude: ✅ Prompt optimized!
```bash

## Execution Verification

Deploy execution-evaluator to verify:

- ✅ **Input analyzed** - Original prompt or file content processed and understood
- ✅ **Structure optimized** - Clear input/output format specification added
- ✅ **Clarity achieved** - Complex language simplified for maximum understanding
- ✅ **Ambiguity removed** - Vague terms replaced with specific instructions
- ✅ **User approval** - Interactive refinement completed to satisfaction
- ✅ **Final format** - Optimized prompt delivered in clear, actionable format
- ✅ **Objective clarity** - Core intent preserved while improving specificity

## Notes

- Focus on objective clarity above all else
- Interactive refinement until approved
- File input extracts core intent from verbose text
- Goal: Maximum clarity with minimum words
