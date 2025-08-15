# /prompt Command

## Description

Transforms raw text or file content into world-class prompts optimized for Claude. Enters interactive mode to
refine prompts through iterative feedback until they meet your exact needs. Generates terse, actionable prompts
with all necessary components for successful execution.

## Usage

```bash
/prompt <raw_text>                # Convert text to optimized prompt
/prompt --file <file_path>        # Convert file content to prompt
/prompt                           # Interactive mode with guided input
```

## Behavior

### Interactive Mode Entry

When you invoke `/prompt`, I will:

1. **Enter prompt engineering mode** for collaborative refinement
2. **Read input** from text argument or file
3. **Analyze intent** to understand the core objective
4. **Generate optimized prompt** following Claude's best practices
5. **Present prompt** in a clear, formatted display
6. **Await feedback** while remaining in interactive mode
7. **Iterate** based on your revisions until satisfied
8. **Exit** only when you approve the final version

### Prompt Optimization Principles

#### Core Components (The SCOPE Framework)

1. **Situation** - Context and background (only if essential)
2. **Constraints** - Boundaries, limitations, requirements
3. **Objective** - Clear, singular goal
4. **Persona** - Role or expertise needed (if applicable)
5. **Examples** - Input/output pairs (when clarifying)

#### Terseness Rules

- **Remove fluff**: No "please", "thank you", "I need you to"
- **Active voice**: "Analyze X" not "X should be analyzed"
- **Direct instructions**: Start with verbs
- **Essential only**: Every word must earn its place
- **Structured format**: Use bullets, numbered lists for clarity

#### Claude-Optimized Patterns

```text
# Preferred Prompt Structure

[ROLE if needed]
[CONTEXT only if essential]

OBJECTIVE: [Single clear goal]

CONSTRAINTS:
- [Specific requirement 1]
- [Specific requirement 2]

INPUT: [What you're providing]
OUTPUT: [Expected format/structure]

[EXAMPLES if ambiguous]
```

### Approval Workflow

**Interactive Cycle**:

1. **Present optimized prompt**:

   ```text
   ═══════════════════════════════════
   OPTIMIZED PROMPT v1
   ═══════════════════════════════════

   [Generated prompt displayed here]

   ═══════════════════════════════════
   ```

2. **Await your response**:
   - **"approve"/"yes"**: Finalize and exit interactive mode
   - **"revise"/"modify"**: Request specific changes
   - **"shorter"**: Make more concise
   - **"expand"**: Add necessary detail
   - **"examples"**: Add clarifying examples
   - **"cancel"**: Exit without saving

3. **Iterate until satisfied**:
   - Apply requested changes
   - Present new version
   - Continue refinement cycle

### File Input Processing

When using `--file <file_path>`:

- **Read entire file** content
- **Detect document type**: Requirements, user story, bug report, etc.
- **Extract core intent** from verbose descriptions
- **Distill to essentials** for prompt generation

### Prompt Categories

#### Task Execution

```text
Analyze [data] for [specific patterns].
Output: [format]
Constraints: [limits]
```

#### Code Generation

```text
Implement [feature] in [language].
Requirements:
- [Requirement 1]
- [Requirement 2]
Follow [framework] conventions.
```

#### Analysis & Research

```text
Research [topic].
Focus: [specific aspects]
Depth: [level of detail]
Format: [structure]
```

#### Creative Tasks

```text
Generate [type] about [topic].
Tone: [style]
Length: [constraint]
Include: [elements]
```

## Examples

### Simple Text Input

```text
User: /prompt I need help writing a Python function that validates email addresses
and returns true if valid, false otherwise. Should handle edge cases.

Claude: 🎯 Entering prompt engineering mode...

═══════════════════════════════════
OPTIMIZED PROMPT v1
═══════════════════════════════════

Write Python email validation function.

Requirements:
- Return boolean (True/False)
- Handle edge cases
- Follow RFC 5322 basics

Input: String (email)
Output: Boolean

═══════════════════════════════════

How would you like to refine this prompt?
Options: approve | revise | shorter | expand | examples | cancel

User: examples

Claude: 🔄 Adding examples...

═══════════════════════════════════
OPTIMIZED PROMPT v2
═══════════════════════════════════

Write Python email validation function.

Requirements:
- Return boolean (True/False)
- Handle edge cases
- Follow RFC 5322 basics

Input: String (email)
Output: Boolean

Examples:
valid@email.com → True
invalid.email → False
user+tag@domain.co.uk → True

═══════════════════════════════════

How would you like to refine this prompt?

User: approve

Claude: ✅ Prompt optimized and ready for use!
```

### File-Based Input

```text
User: /prompt --file requirements/feature-spec.md

Claude: 🎯 Entering prompt engineering mode...
[Reading file: requirements/feature-spec.md]

═══════════════════════════════════
OPTIMIZED PROMPT v1
═══════════════════════════════════

Implement user authentication system.

Components:
- JWT token generation
- Password hashing (bcrypt)
- Session management
- Rate limiting

Stack: Node.js, Express, PostgreSQL

Output: REST API endpoints with middleware

═══════════════════════════════════

How would you like to refine this prompt?

User: shorter

Claude: 🔄 Making more concise...

═══════════════════════════════════
OPTIMIZED PROMPT v2
═══════════════════════════════════

Build JWT auth API: Node.js/Express/PostgreSQL.
Include: token generation, bcrypt hashing, sessions, rate limiting.

═══════════════════════════════════

How would you like to refine this prompt?

User: approve
```

### Interactive Guided Mode

```text
User: /prompt

Claude: 🎯 Entering prompt engineering mode...

What task would you like to create a prompt for?

User: I want to analyze customer feedback data to identify the top 3 complaints

Claude: 📝 Analyzing your requirements...

═══════════════════════════════════
OPTIMIZED PROMPT v1
═══════════════════════════════════

Analyze customer feedback. Identify top 3 complaints.

Input: [Feedback data format]
Output: Ranked list with frequencies
Method: Sentiment analysis + categorization

═══════════════════════════════════

How would you like to refine this prompt?

User: revise - need to specify the data is in CSV format with columns for date,
rating, and comment

Claude: 🔄 Applying your revisions...

═══════════════════════════════════
OPTIMIZED PROMPT v2
═══════════════════════════════════

Analyze customer feedback CSV. Identify top 3 complaints.

Input: CSV (columns: date, rating, comment)
Output: Ranked complaints with frequencies
Method: Parse comments, categorize issues, count occurrences

═══════════════════════════════════

How would you like to refine this prompt?

User: approve
```

## Prompt Quality Metrics

### Evaluation Criteria

✅ **Clarity**: Unambiguous objective
✅ **Completeness**: All necessary context included
✅ **Conciseness**: No unnecessary words
✅ **Structure**: Logical organization
✅ **Actionability**: Clear next steps
✅ **Constraints**: Well-defined boundaries
✅ **Format**: Expected output specified

### Anti-Patterns to Avoid

❌ **Vague objectives**: "Help me with my project"
❌ **Multiple goals**: Combining unrelated tasks
❌ **Excessive politeness**: "Could you please possibly..."
❌ **Assumed context**: Missing critical information
❌ **Open-ended outputs**: No format specification
❌ **Redundancy**: Repeating the same constraint
❌ **Narrative style**: Long paragraph descriptions

## Advanced Features

### Prompt Templates

The command recognizes common patterns and applies templates:

- **Code Review**: "Review [language] code for [specific issues]. Focus: [areas]."
- **Data Analysis**: "Analyze [dataset] for [metrics]. Format: [output type]."
- **Documentation**: "Document [component]. Include: [sections]. Style: [format]."
- **Debugging**: "Debug [issue] in [context]. Symptoms: [list]. Environment: [details]."
- **Refactoring**: "Refactor [code] to [goal]. Maintain: [behavior]. Improve: [metrics]."

### Context Stripping

Automatically removes:

- Pleasantries and social padding
- Redundant explanations
- Backstory unless essential
- Justifications for the request
- Meta-commentary about the task

### Enhancement Suggestions

Proactively suggests additions when detecting:

- Missing output format specification
- Absent constraints that could improve results
- Helpful examples that would clarify intent
- Role/persona that would enhance response quality
- Structure that would organize complex requests

## Implementation Notes

### Interactive Mode Management

- **State preservation**: Maintains context between iterations
- **Version tracking**: Numbers each prompt version
- **Diff display**: Can show changes between versions
- **History**: Keeps last 5 versions during session
- **Quick actions**: Keyboard shortcuts for common refinements

### File Processing

- **Size limit**: Files up to 100KB processed fully
- **Format detection**: Auto-identifies document structure
- **Extraction logic**: Pulls requirements, objectives, constraints
- **Summarization**: Condenses verbose specifications

### Output Options

After approval, the prompt can be:

- **Copied**: Ready for immediate use
- **Saved**: Written to specified file
- **Executed**: Run immediately with current Claude instance
- **Templated**: Saved as reusable template

## Success Indicators

✅ **Approval Rate**: Achieves satisfaction within 3 iterations
✅ **Reduction Ratio**: Typically 70-90% shorter than original
✅ **Clarity Score**: Unambiguous objectives and constraints
✅ **Actionability**: Claude can execute without clarification
✅ **Efficiency**: Generates optimal response on first attempt

## Notes

- Interactive mode maintains state until explicit approval or cancellation
- Each iteration preserves context from previous versions
- Optimizations are cumulative unless "reset" is requested
- Prompts are tailored to Claude's processing strengths
- Examples are included only when they add clarity
- The goal is maximum effectiveness with minimum tokens
- **Quality over brevity**: Never sacrifice clarity for terseness
- **Iterative refinement**: Most prompts improve through 2-3 cycles
