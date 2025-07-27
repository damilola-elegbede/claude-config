# /security Command

## Description
Performs comprehensive security vulnerability assessment using the security-auditor agent to identify risks, check compliance, and provide remediation guidance.

## Usage
```
/security [scope] [options]
```

## Arguments
- `scope` (optional): Specific area to audit
  - `api`: API endpoints and authentication
  - `auth`: Authentication and authorization
  - `data`: Data handling and storage
  - `deps`: Dependency vulnerabilities
  - `full`: Complete security audit (default)

## Options
- `--compliance <standard>`: Check specific compliance (SOC2, PCI-DSS, GDPR, HIPAA)
- `--depth <level>`: Audit depth (quick, standard, deep)
- `--fix`: Generate remediation code/configs

## Behavior
When you use `/security`, I will:

1. **Identify audit scope**:
   - Code patterns and implementations
   - Dependencies and libraries
   - Configuration files
   - Infrastructure setup
   
2. **Launch security-auditor agent** to assess:
   - OWASP Top 10 vulnerabilities
   - Authentication/authorization flaws
   - Data exposure risks
   - Injection vulnerabilities
   - Cryptographic weaknesses
   - Configuration security
   
3. **Perform specialized checks**:
   - SQL/NoSQL injection
   - XSS vulnerabilities
   - CSRF protection
   - Session management
   - API security
   - Secrets/credentials exposure
   
4. **Generate security report** with:
   - Executive summary
   - Risk assessment by severity
   - Detailed vulnerability findings
   - Remediation recommendations
   - Compliance status

## Examples
```
/security                           # Full security audit
/security api                       # API security focus
/security auth --fix               # Auth audit with fixes
/security --compliance pci-dss     # PCI compliance check
/security deps                      # Dependency vulnerabilities
```

## Security Categories
- **Critical**: Immediate exploitation risk
- **High**: Significant security impact
- **Medium**: Moderate risk requiring attention
- **Low**: Minor issues or best practice violations
- **Info**: Security recommendations

## Vulnerability Types
- **Injection**: SQL, NoSQL, OS, LDAP injection
- **Authentication**: Weak auth, session issues
- **Data Exposure**: Sensitive data leaks, logging
- **Access Control**: Authorization bypasses
- **Security Misconfiguration**: Defaults, headers
- **XSS**: Reflected, stored, DOM-based
- **Deserialization**: Insecure object handling
- **Dependencies**: Known vulnerable components
- **Logging**: Insufficient monitoring
- **API**: Rate limiting, versioning, auth

## Output Format
1. **Risk Summary**: Overall security posture
2. **Critical Findings**: Must-fix vulnerabilities
3. **Detailed Analysis**: Per-vulnerability breakdown
4. **Remediation Guide**: Step-by-step fixes
5. **Compliance Report**: Standards adherence

## Integration
- CI/CD security gates
- Pre-deployment checks
- Dependency scanning
- Container security
- Infrastructure as Code scanning

## Prerequisites
- Source code access
- Dependency manifests (package.json, requirements.txt, etc.)
- Configuration files
- Optional: Previous security reports

## Notes
- Focuses on exploitable vulnerabilities
- Provides actionable remediation
- Considers business impact
- Supports incremental improvements
- Maintains security knowledge base