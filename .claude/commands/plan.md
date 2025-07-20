# /plan Command

## Description
Triggers a detailed planning workflow before implementing any feature or code changes. When you use `/plan`, I will create a comprehensive implementation plan and wait for your explicit approval before proceeding.

## Usage
```
/plan <task description>
```

## Example
```
/plan Add a dark mode toggle to the settings page
```

## Behavior
When you use `/plan`, I will:

1. **Stop and create a detailed plan** without writing any code or using modification tools
2. **Present the plan** in a structured markdown format including:
   - Executive Summary
   - Problem Statement & Business Impact
   - Proposed Solution Architecture
   - Technical Implementation Details
   - Risk Assessment & Mitigation
   - Success Metrics & KPIs
   - Timeline & Milestones
   - Dependencies & Prerequisites
   - Claude's Assessment (professional opinion and recommendations)

3. **Wait for explicit approval** by asking: "Please review this plan. Reply with approval to proceed with implementation."
4. **Execute with todo tracking** only after receiving clear approval

## Approval Indicators
I will look for clear approval intent, including:
- Direct approval words: "approved", "approve", "approval"
- Affirmative commands: "yes proceed", "go ahead", "go for it", "execute", "implement"
- Positive confirmations: "lgtm", "looks good to me", "ship it", "let's do it"
- Clear action directives: "start implementation", "begin coding", "make it happen"

## Non-Approval Responses
The following require re-confirmation:
- Questions about the plan
- Suggestions or feedback without clear approval
- Vague responses like "sounds good" without action words
- Any response that doesn't clearly indicate permission to execute

## When to Use /plan
Use this command when you want:
- A detailed implementation strategy before coding
- Risk assessment for complex changes
- Clear milestones and timeline estimates
- Formal approval workflow for critical features

## Notes
- This command enforces the planning workflow from CLAUDE.md
- Without `/plan`, I will proceed directly with implementation for straightforward tasks
- Plans can be iteratively refined based on your feedback