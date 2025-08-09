# Audit Verification Protocol for General-Purpose Agent

## Agent Standards Compliance

When auditing agents, verify compliance with Claude Code documentation standards:
- Agents use "MUST BE USED for" pattern for critical use cases
- Agents include "Use PROACTIVELY" for automatic deployment triggers
- Agents leverage Sonnet 4.1 capabilities with enhanced AI reasoning
- Agent descriptions follow required language patterns and specialization statements

## When Running Agent Audits

### 1. Pre-Audit Verification
Before spawning agent-auditor instances:
```bash
# Verify which agents actually exist
ls -la .claude/agents/*.md

# Check for empty files
for file in .claude/agents/*.md; do
  if [ ! -s "$file" ]; then
    echo "Empty file: $file"
  fi
done
```

### 2. Audit Request Preparation
When requesting audits:
- Explicitly list which agents to audit
- Include the category being audited
- Request file existence verification first
- Verify compliance with Claude Code documentation standards
- Check for proper "MUST BE USED" and "Use PROACTIVELY" language patterns
- Validate Sonnet 4.1 capability descriptions

Example:
```
"Please audit these Development & Implementation agents:
- backend-engineer
- frontend-engineer
- fullstack-lead
- mobile-engineer
- ml-engineer

First verify these files exist in .claude/agents/ directory, then proceed with compliance audit."
```

### 3. Post-Audit Validation
After receiving audit results:

#### Verify Critical Claims
```bash
# If audit claims "X agents missing", verify:
ls -la .claude/agents/[agent-name].md

# If audit claims "agent has issue Y", spot-check:
grep -n "pattern" .claude/agents/[agent-name].md

# Verify documentation standards compliance:
grep -n "MUST BE USED for" .claude/agents/[agent-name].md
grep -n "Use PROACTIVELY" .claude/agents/[agent-name].md
grep -n "Sonnet 4.1" .claude/agents/[agent-name].md
```

#### Cross-Check Metrics
- If "5 of 6 agents missing" → Actually count the files
- If "80% have tool violations" → Sample check a few
- If "All agents lack X" → Verify with at least 2-3 examples

### 4. Report Compilation
When creating the executive summary:

#### Include Verification Status
```markdown
## Audit Findings (Verified)
- ✅ Verified: Agent isolation violations in code-reviewer.md (line 127)
- ✅ Verified: Missing agents confirmed via file system check
- ⚠️  Unverified: Claim about 80% tool violations (needs sampling)
```

#### Flag Suspicious Results
- Extremely high failure rates (>80%)
- Claims of widespread missing files
- Contradictory findings between audits

### 5. Corrective Actions
If verification reveals audit errors:
1. Document what was incorrect
2. Re-run targeted audits on problem areas
3. Update agent-auditor if systematic issues found

## Example Verification Workflow

```python
# Pseudo-code for audit verification
audit_results = run_agent_audit(category="Development")

# Verify missing agents claim
for agent in audit_results.missing_agents:
    if file_exists(f".claude/agents/{agent}.md"):
        flag_false_positive(agent)

# Verify critical issues
for issue in audit_results.critical_issues:
    if issue.type == "tool_violation":
        actual_content = read_file(issue.agent_file)
        if not verify_issue_exists(actual_content, issue.pattern):
            flag_false_positive(issue)

# Calculate verified metrics
verified_score = calculate_score_from_verified_issues_only()
```

## Red Flags to Watch For

1. **Impossible Claims**: "100% of agents have X issue" (very unlikely)
2. **Missing Foundation**: Claims about missing core infrastructure that would break everything
3. **Contradictions**: Different audits giving wildly different results
4. **No File Paths**: Issues reported without specific file locations
5. **Round Numbers**: Suspiciously round percentages (exactly 80%, 90%, etc.)

## Verification Commands Toolbox

```bash
# Count agents by category
grep -l "category:.*development" .claude/agents/*.md | wc -l

# Find agent isolation violations
grep -n "agent_name\s*:" .claude/agents/*.md

# Check for empty files
find .claude/agents -name "*.md" -empty

# Verify specific claim
grep -A5 -B5 "pattern" .claude/agents/specific-agent.md

# List all agents with their descriptions
for f in .claude/agents/*.md; do
  echo "=== $(basename $f) ==="
  grep "^description:" "$f" || echo "No description found"
done

# Verify Claude Code documentation standards
for f in .claude/agents/*.md; do
  echo "=== $(basename $f) ==="
  echo "MUST BE USED pattern:"
  grep -q "MUST BE USED for" "$f" && echo "✅ Found" || echo "❌ Missing"
  echo "Use PROACTIVELY pattern:"
  grep -q "Use PROACTIVELY" "$f" && echo "✅ Found" || echo "❌ Missing"
  echo "Sonnet 4.1 capabilities:"
  grep -q "Sonnet 4.1" "$f" && echo "✅ Found" || echo "❌ Missing"
  echo "---"
done
```
