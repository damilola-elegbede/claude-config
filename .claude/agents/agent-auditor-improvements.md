# Recommended Improvements for agent-auditor

## 1. Add File Existence Verification
```yaml
audit_steps:
  1_verify_existence:
    - Check if agent file exists before auditing
    - Report "AGENT NOT FOUND" clearly if missing
    - Don't assume content for missing agents
```

## 2. Remove Hardcoded Gap Analysis
Replace lines 89-104 with dynamic gap detection:
```yaml
gap_analysis:
  methodology:
    - Analyze actual use case coverage from existing agents
    - Don't suggest predefined "missing" agents
    - Base recommendations on actual gaps found
```

## 3. Add Validation Step
```yaml
final_validation:
  - Verify all critical claims (e.g., "X agents missing")
  - Cross-check findings with actual file system
  - Include file paths in reports for verification
```

## 4. Improve Error Handling
```yaml
error_handling:
  file_not_found: "Report as 'Agent file not found' not as compliance failure"
  empty_files: "Report as 'Agent file empty' with clear status"
  malformed_yaml: "Report specific YAML parsing errors"
```

## 5. Add Summary Accuracy Check
```yaml
summary_generation:
  - Count actual files found vs claimed
  - Verify percentages against real data
  - Flag any mathematical inconsistencies
```

## Recommended Updates for General-Purpose Agent:

## 1. Pre-Audit Verification
- Always run `ls` or `Glob` to verify agents exist before auditing
- Check file contents aren't empty
- Validate category assignments before making claims

## 2. Result Validation
- Cross-check audit claims against file system
- Question suspicious findings (like 83% failure rate)
- Run verification commands for critical claims

## 3. Incremental Verification
- Don't propagate unverified claims
- Add "NEEDS VERIFICATION" flags to suspicious findings
- Use multiple small checks rather than accepting wholesale reports