# /tokens Command

## Description
Shows current token usage for the active Claude Code session and available context window space. This command provides real-time insight into your conversation's token consumption, helping you understand how much context remains and optimize your session usage for better performance. Perfect for long sessions where context management becomes critical.

## Usage
```
/tokens
```

## Behavior
When you use `/tokens`, I will:

1. **Calculate current session usage** by analyzing:
   - All user messages and their approximate token count
   - All assistant responses including tool calls and outputs
   - Code blocks, file contents, and command structures
   - System context and conversation metadata

2. **Display real-time metrics** including:
   - Precise session token consumption estimate
   - Context window utilization percentage
   - Breakdown by message type and content category
   - Visual ASCII progress bars for quick assessment

3. **Show capacity information**:
   - Claude Sonnet 4: 200K context window, 64K output limit
   - Remaining space available for continued conversation
   - Performance impact predictions based on current usage

4. **Provide actionable insights**:
   - Session health status with emoji indicators
   - Optimization recommendations based on current usage patterns
   - Specific guidance on when to start fresh sessions

## Output Format
```
## 🎯 Token Usage Report

┌─────────────────────────────────────────────────────────────────┐
│                        SESSION OVERVIEW                        │
├─────────────────────────────────┬───────────────────────────────┤
│ 📊 Context Window (Sonnet 4)    │ 200,000 tokens              │
│ 🎯 Current Session Usage        │ 12,450 tokens (6.2%)        │
│ 🔋 Available Space              │ 187,550 tokens (93.8%)      │
│ 📝 Max Output per Response      │ 64,000 tokens               │
└─────────────────────────────────┴───────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                        USAGE BREAKDOWN                         │
├─────────────────────────────────┬───────────────────────────────┤
│ 💬 User Messages                │ 3,200 tokens                │
│ 🤖 Assistant Responses          │ 8,100 tokens                │
│ 💻 Code Blocks                  │ 850 tokens                  │
│ 🔧 Tool Interactions            │ 300 tokens                  │
└─────────────────────────────────┴───────────────────────────────┘

Context Usage Visualization:
🟢 Used: [████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] 12,450 / 200,000 (6.2%)
🔵 Available: [░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░████████████████████████████████] 93.8%

Performance Status:
┌─────────────────────────────────┬───────────────────────────────┐
│ 🟢 Context Health               │ Excellent (< 25% used)       │
│ ⚡ Response Speed               │ Optimal                       │
│ 🎚️ Memory Retention            │ High                          │
└─────────────────────────────────┴───────────────────────────────┘

Recommendations:
✅ Context management healthy - continue current session
💡 Capacity available for large analysis tasks  
🔄 New session recommended at 150K+ tokens (75%)
```

## Token Estimation Methodology
Since exact token counts aren't available from the API, I use intelligent estimation:

1. **Text Analysis**:
   - Approximate 3.5-4 characters per token (English text)
   - Account for code syntax complexity
   - Consider special tokens and formatting

2. **Message Tracking**:
   - Count conversation turns since session start
   - Weight different content types appropriately
   - Include system messages and tool calls

3. **Conservative Estimates**:
   - Slightly overestimate to ensure safety margins
   - Account for internal processing overhead
   - Include context from previous tool results

## Context Window Specifications
- **Claude Sonnet 4**: 200,000 tokens (~500+ pages)
- **Claude Sonnet 4 (Enterprise)**: 500,000 tokens
- **Output Limit**: 64,000 tokens per response
- **Pricing**: $3/million input, $15/million output tokens

## Usage Patterns
```
# Check current usage
/tokens

# Typical output for active session:
┌─────────────────────────────────┬───────────────────────────────┐
│ 🎯 Current Session Usage        │ 25,680 tokens (12.8%)       │
│ 🔋 Available Space              │ 174,320 tokens (87.2%)      │
│ ⚡ Status                       │ Healthy - continue session   │
└─────────────────────────────────┴───────────────────────────────┘

Context: [████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░] 12.8%

# When approaching limits:
┌─────────────────────────────────┬───────────────────────────────┐
│ 🎯 Current Session Usage        │ 145,200 tokens (72.6%)      │
│ 🔋 Available Space              │ 54,800 tokens (27.4%)       │
│ ⚠️ Status                       │ Consider fresh session soon  │
└─────────────────────────────────┴───────────────────────────────┘

Context: [███████████████████████████████████████░░░░░░░░░] 72.6% ⚠️
```

## Optimization Tips
1. **Session Management**:
   - Start new sessions at 75%+ usage for optimal performance
   - Use `/context` to quickly onboard new sessions
   - Archive important context before resetting

2. **Efficient Usage**:
   - Use specific queries to get focused responses
   - Leverage agents for complex tasks to manage context
   - Break large tasks into smaller, targeted operations

3. **Performance Monitoring**:
   - Regular `/tokens` checks during long sessions
   - Watch for response quality degradation as context fills
   - Balance thoroughness with context efficiency

## Integration with Other Commands
- Use before `/context` for large repositories
- Check after `/review` or `/debug` for complex analysis
- Monitor during `/orchestrate` for multi-agent coordination
- Verify capacity before `/docs` generation

## Notes
- Token estimates are conservative approximations
- Actual usage may vary based on content complexity
- Enterprise accounts have access to 500K context windows
- New sessions automatically optimize context allocation
- Real-time tracking helps maintain optimal performance