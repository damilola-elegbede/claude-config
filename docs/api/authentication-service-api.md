# Authentication Service API Documentation

## Overview

The Claude Code CLI Authentication Service provides comprehensive security mechanisms for user authentication, session management, and authorization across the agent ecosystem. This API enables secure access control for all agent invocations, command executions, and system operations.

## Table of Contents

1. [Authentication Methods](#authentication-methods)
2. [Session Management](#session-management)
3. [Authorization & Permissions](#authorization--permissions)
4. [Security Endpoints](#security-endpoints)
5. [Multi-Factor Authentication](#multi-factor-authentication)
6. [API Key Management](#api-key-management)
7. [OAuth2 Integration](#oauth2-integration)
8. [Security Monitoring](#security-monitoring)

## Authentication Methods

### JWT Authentication

#### Issue JWT Token

```http
POST /auth/token
```

##### Request Body:

```json
{
  "username": "user@example.com",
  "password": "secure_password",
  "grant_type": "password",
  "scope": "agent:invoke command:execute system:read"
}
```

##### Response:

```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "refresh_token": "def50200e3b0c44298fc1c14...",
  "scope": "agent:invoke command:execute system:read",
  "issued_at": "2024-01-15T10:00:00Z"
}
```

#### Refresh JWT Token

```http
POST /auth/refresh
```

##### Request Body:

```json
{
  "refresh_token": "def50200e3b0c44298fc1c14...",
  "grant_type": "refresh_token"
}
```

##### Response:

```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "refresh_token": "abc12345d6e7f8g9h0i1j2k3...",
  "scope": "agent:invoke command:execute system:read"
}
```

### API Key Authentication

#### Generate API Key

```http
POST /auth/api-keys
```

##### Request Body:

```json
{
  "name": "Production API Access",
  "description": "API key for production environment",
  "permissions": [
    "agent:invoke",
    "command:execute",
    "system:read"
  ],
  "expires_at": "2024-12-31T23:59:59Z",
  "rate_limit": {
    "requests_per_hour": 1000,
    "burst_limit": 50
  }
}
```

##### Response:

```json
{
  "api_key": "sk_live_abcdef123456789...",
  "key_id": "key_12345",
  "name": "Production API Access",
  "permissions": [
    "agent:invoke",
    "command:execute",
    "system:read"
  ],
  "created_at": "2024-01-15T10:00:00Z",
  "expires_at": "2024-12-31T23:59:59Z",
  "last_used": null,
  "rate_limit": {
    "requests_per_hour": 1000,
    "burst_limit": 50
  }
}
```

#### List API Keys

```http
GET /auth/api-keys
```

##### Response:

```json
{
  "api_keys": [
    {
      "key_id": "key_12345",
      "name": "Production API Access",
      "permissions": ["agent:invoke", "command:execute"],
      "created_at": "2024-01-15T10:00:00Z",
      "expires_at": "2024-12-31T23:59:59Z",
      "last_used": "2024-01-15T14:30:00Z",
      "usage_count": 247,
      "status": "active"
    }
  ],
  "total": 1
}
```

#### Revoke API Key

```http
DELETE /auth/api-keys/{key_id}
```

##### Response:

```json
{
  "message": "API key revoked successfully",
  "key_id": "key_12345",
  "revoked_at": "2024-01-15T15:00:00Z"
}
```

## Session Management

### Create Session

```http
POST /auth/sessions
```

##### Request Body:

```json
{
  "user_id": "user_123",
  "device_info": {
    "device_type": "desktop",
    "os": "macOS",
    "browser": "Claude Desktop",
    "ip_address": "192.168.1.100"
  },
  "preferences": {
    "timeout": 7200,
    "remember_device": true
  }
}
```

##### Response:

```json
{
  "session_id": "sess_abcdef123456",
  "user_id": "user_123",
  "created_at": "2024-01-15T10:00:00Z",
  "expires_at": "2024-01-15T12:00:00Z",
  "device_info": {
    "device_type": "desktop",
    "os": "macOS",
    "browser": "Claude Desktop",
    "ip_address": "192.168.1.100"
  },
  "status": "active",
  "permissions": [
    "agent:invoke",
    "command:execute",
    "system:read"
  ]
}
```

### Validate Session

```http
GET /auth/sessions/{session_id}/validate
```

##### Response:

```json
{
  "valid": true,
  "session_id": "sess_abcdef123456",
  "user_id": "user_123",
  "expires_at": "2024-01-15T12:00:00Z",
  "time_remaining": 3600,
  "permissions": [
    "agent:invoke",
    "command:execute",
    "system:read"
  ],
  "rate_limit_status": {
    "requests_remaining": 950,
    "reset_time": "2024-01-15T11:00:00Z"
  }
}
```

### Extend Session

```http
PUT /auth/sessions/{session_id}/extend
```

##### Request Body:

```json
{
  "extend_by": 3600
}
```

##### Response:

```json
{
  "session_id": "sess_abcdef123456",
  "old_expires_at": "2024-01-15T12:00:00Z",
  "new_expires_at": "2024-01-15T13:00:00Z",
  "extended_by": 3600
}
```

### Terminate Session

```http
DELETE /auth/sessions/{session_id}
```

##### Response:

```json
{
  "message": "Session terminated successfully",
  "session_id": "sess_abcdef123456",
  "terminated_at": "2024-01-15T11:30:00Z"
}
```

## Authorization & Permissions

### Permission Scopes

#### Agent Permissions

| Scope | Description | Examples |
|-------|-------------|----------|
| `agent:invoke` | Invoke specific agents | Call backend-engineer, frontend-architect |
| `agent:invoke:*` | Invoke all agents | Full agent access |
| `agent:invoke:development` | Invoke development category agents | backend-engineer, test-engineer |
| `agent:invoke:security` | Invoke security category agents | security-auditor, compliance-specialist |
| `agent:list` | List available agents | Get agent capabilities |
| `agent:status` | Check agent execution status | Monitor running tasks |

#### Command Permissions

| Scope | Description | Examples |
|-------|-------------|----------|
| `command:execute` | Execute basic commands | /test, /sync, /commit |
| `command:execute:*` | Execute all commands | Full command access |
| `command:execute:admin` | Execute admin commands | /deploy, /monitor |
| `command:list` | List available commands | Get command documentation |

#### System Permissions

| Scope | Description | Examples |
|-------|-------------|----------|
| `system:read` | Read system status | Health checks, metrics |
| `system:write` | Modify system configuration | Update settings, manage users |
| `system:admin` | Full system administration | User management, system config |
| `audit:read` | Access audit logs | Security monitoring |
| `audit:write` | Create audit entries | Log security events |

### Check Permissions

```http
POST /auth/permissions/check
```

##### Request Body:

```json
{
  "user_id": "user_123",
  "requested_permissions": [
    "agent:invoke:backend-engineer",
    "command:execute:test",
    "system:read"
  ],
  "context": {
    "agent_type": "backend-engineer",
    "command": "/test",
    "resource": "project_abc"
  }
}
```

##### Response:

```json
{
  "user_id": "user_123",
  "permissions": [
    {
      "permission": "agent:invoke:backend-engineer",
      "granted": true,
      "reason": "User has agent:invoke:development scope"
    },
    {
      "permission": "command:execute:test",
      "granted": true,
      "reason": "User has command:execute scope"
    },
    {
      "permission": "system:read",
      "granted": false,
      "reason": "Insufficient privileges - requires system:read scope"
    }
  ],
  "overall_granted": false,
  "required_scopes": ["system:read"]
}
```

### Grant Permissions

```http
POST /auth/permissions/grant
```

##### Request Body:

```json
{
  "user_id": "user_123",
  "permissions": [
    "system:read",
    "agent:invoke:security"
  ],
  "expires_at": "2024-06-15T00:00:00Z",
  "granted_by": "admin_456",
  "reason": "Security audit role assignment"
}
```

##### Response:

```json
{
  "user_id": "user_123",
  "granted_permissions": [
    {
      "permission": "system:read",
      "granted_at": "2024-01-15T10:00:00Z",
      "expires_at": "2024-06-15T00:00:00Z",
      "granted_by": "admin_456"
    },
    {
      "permission": "agent:invoke:security",
      "granted_at": "2024-01-15T10:00:00Z",
      "expires_at": "2024-06-15T00:00:00Z",
      "granted_by": "admin_456"
    }
  ],
  "total_permissions": 5
}
```

## Multi-Factor Authentication

### Initiate MFA Setup

```http
POST /auth/mfa/setup
```

##### Request Body:

```json
{
  "user_id": "user_123",
  "method": "totp",
  "device_name": "iPhone 12"
}
```

##### Response:

```json
{
  "setup_token": "mfa_setup_abc123",
  "method": "totp",
  "secret_key": "JBSWY3DPEHPK3PXP",
  "qr_code_url": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA...",
  "backup_codes": [
    "12345-67890",
    "98765-43210",
    "55555-11111"
  ],
  "expires_at": "2024-01-15T10:15:00Z"
}
```

### Complete MFA Setup

```http
POST /auth/mfa/setup/complete
```

##### Request Body:

```json
{
  "setup_token": "mfa_setup_abc123",
  "verification_code": "123456"
}
```

##### Response:

```json
{
  "user_id": "user_123",
  "mfa_enabled": true,
  "method": "totp",
  "setup_completed_at": "2024-01-15T10:10:00Z",
  "backup_codes_remaining": 3
}
```

### Verify MFA Code

```http
POST /auth/mfa/verify
```

##### Request Body:

```json
{
  "user_id": "user_123",
  "code": "123456",
  "code_type": "totp"
}
```

##### Response:

```json
{
  "valid": true,
  "user_id": "user_123",
  "verified_at": "2024-01-15T10:00:00Z",
  "remaining_attempts": 2,
  "backup_codes_remaining": 3
}
```

### Disable MFA

```http
DELETE /auth/mfa/{user_id}
```

##### Request Body:

```json
{
  "verification_code": "123456",
  "confirmation": "I understand this reduces account security"
}
```

##### Response:

```json
{
  "user_id": "user_123",
  "mfa_disabled": true,
  "disabled_at": "2024-01-15T10:00:00Z",
  "backup_codes_invalidated": 3
}
```

## OAuth2 Integration

### Authorization Code Flow

#### Authorization Request

```http
GET /auth/oauth2/authorize
```

##### Query Parameters:

```text
response_type=code
client_id=claude_desktop_app
redirect_uri=https://app.example.com/callback
scope=agent:invoke command:execute
state=random_state_string
code_challenge=E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM
code_challenge_method=S256
```

##### Response:
Redirects to `redirect_uri` with authorization code:

```text
https://app.example.com/callback?code=auth_code_123&state=random_state_string
```

#### Token Exchange

```http
POST /auth/oauth2/token
```

##### Request Body:

```json
{
  "grant_type": "authorization_code",
  "code": "auth_code_123",
  "redirect_uri": "https://app.example.com/callback",
  "client_id": "claude_desktop_app",
  "client_secret": "client_secret_456",
  "code_verifier": "dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk"
}
```

##### Response:

```json
{
  "access_token": "oauth2_access_token_xyz",
  "token_type": "Bearer",
  "expires_in": 3600,
  "refresh_token": "oauth2_refresh_token_abc",
  "scope": "agent:invoke command:execute"
}
```

### Client Registration

```http
POST /auth/oauth2/clients
```

##### Request Body:

```json
{
  "client_name": "Third-party Integration",
  "client_type": "confidential",
  "redirect_uris": [
    "https://app.example.com/callback",
    "https://staging.example.com/callback"
  ],
  "scopes": [
    "agent:invoke",
    "command:execute"
  ],
  "grant_types": [
    "authorization_code",
    "refresh_token"
  ]
}
```

##### Response:

```json
{
  "client_id": "client_abcdef123456",
  "client_secret": "secret_789xyz",
  "client_name": "Third-party Integration",
  "client_type": "confidential",
  "redirect_uris": [
    "https://app.example.com/callback",
    "https://staging.example.com/callback"
  ],
  "allowed_scopes": [
    "agent:invoke",
    "command:execute"
  ],
  "created_at": "2024-01-15T10:00:00Z"
}
```

## Security Monitoring

### Security Events

```http
GET /auth/security/events
```

##### Query Parameters:

- `user_id` (optional): Filter by user
- `event_type` (optional): Filter by event type
- `start_date` (optional): Start date for filtering
- `end_date` (optional): End date for filtering
- `limit` (optional): Number of events to return (default: 100)

##### Response:

```json
{
  "events": [
    {
      "event_id": "event_123",
      "event_type": "login_success",
      "user_id": "user_123",
      "timestamp": "2024-01-15T10:00:00Z",
      "ip_address": "192.168.1.100",
      "user_agent": "Claude Desktop/1.0",
      "details": {
        "session_id": "sess_abc123",
        "mfa_used": true,
        "device_trusted": true
      },
      "risk_score": 0.1
    },
    {
      "event_id": "event_124",
      "event_type": "permission_denied",
      "user_id": "user_123",
      "timestamp": "2024-01-15T10:05:00Z",
      "ip_address": "192.168.1.100",
      "details": {
        "requested_permission": "system:admin",
        "resource": "/admin/users",
        "reason": "Insufficient privileges"
      },
      "risk_score": 0.3
    }
  ],
  "total": 45,
  "page": 1,
  "per_page": 100
}
```

### Failed Login Attempts

```http
GET /auth/security/failed-logins
```

##### Response:

```json
{
  "failed_attempts": [
    {
      "attempt_id": "attempt_123",
      "user_id": "user_123",
      "timestamp": "2024-01-15T09:55:00Z",
      "ip_address": "192.168.1.200",
      "user_agent": "Unknown",
      "failure_reason": "invalid_password",
      "attempts_count": 3,
      "locked_until": null
    }
  ],
  "summary": {
    "total_failed_attempts": 15,
    "unique_ips": 5,
    "locked_accounts": 2,
    "time_range": "24_hours"
  }
}
```

### Account Lockout Status

```http
GET /auth/security/lockouts/{user_id}
```

##### Response:

```json
{
  "user_id": "user_123",
  "is_locked": false,
  "failed_attempts": 2,
  "lockout_threshold": 5,
  "lockout_duration": 900,
  "last_failed_attempt": "2024-01-15T09:55:00Z",
  "reset_time": "2024-01-15T10:55:00Z"
}
```

### Unlock Account

```http
POST /auth/security/unlock/{user_id}
```

##### Request Body:

```json
{
  "admin_user_id": "admin_456",
  "reason": "User verified through alternative channel",
  "reset_failed_attempts": true
}
```

##### Response:

```json
{
  "user_id": "user_123",
  "unlocked": true,
  "unlocked_at": "2024-01-15T10:00:00Z",
  "unlocked_by": "admin_456",
  "failed_attempts_reset": true
}
```

## Error Handling

### Authentication Errors

```json
{
  "error": {
    "code": "INVALID_CREDENTIALS",
    "message": "The provided username or password is incorrect",
    "details": {
      "attempts_remaining": 3,
      "lockout_threshold": 5,
      "can_reset_password": true
    },
    "timestamp": "2024-01-15T10:00:00Z",
    "request_id": "req_auth_123"
  }
}
```

### Authorization Errors

```json
{
  "error": {
    "code": "INSUFFICIENT_PERMISSIONS",
    "message": "User lacks required permissions for this operation",
    "details": {
      "required_permissions": ["system:admin"],
      "user_permissions": ["system:read", "agent:invoke"],
      "resource": "/admin/users",
      "suggestions": [
        "Contact administrator for permission upgrade",
        "Use a different endpoint with appropriate permissions"
      ]
    },
    "timestamp": "2024-01-15T10:00:00Z",
    "request_id": "req_auth_124"
  }
}
```

### Rate Limiting Errors

```json
{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Too many authentication attempts",
    "details": {
      "limit": 100,
      "window": "1 hour",
      "reset_time": "2024-01-15T11:00:00Z",
      "retry_after": 300
    },
    "timestamp": "2024-01-15T10:00:00Z",
    "request_id": "req_auth_125"
  }
}
```

## OpenAPI Specification

```yaml
openapi: 3.0.0
info:
  title: Claude Authentication Service API
  version: 1.0.0
  description: Comprehensive authentication and authorization API for Claude Code CLI

security:
  - bearerAuth: []
  - apiKeyAuth: []

paths:
  /auth/token:
    post:
      summary: Issue JWT token
      tags: [Authentication]
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required:
                - username
                - password
                - grant_type
              properties:
                username:
                  type: string
                  format: email
                password:
                  type: string
                  format: password
                grant_type:
                  type: string
                  enum: [password]
                scope:
                  type: string
                  description: Space-separated list of requested scopes
      responses:
        200:
          description: Token issued successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TokenResponse'
        401:
          description: Invalid credentials
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

  /auth/refresh:
    post:
      summary: Refresh JWT token
      tags: [Authentication]
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required:
                - refresh_token
                - grant_type
              properties:
                refresh_token:
                  type: string
                grant_type:
                  type: string
                  enum: [refresh_token]
      responses:
        200:
          description: Token refreshed successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TokenResponse'

  /auth/api-keys:
    post:
      summary: Generate new API key
      tags: [API Keys]
      security:
        - bearerAuth: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateApiKeyRequest'
      responses:
        201:
          description: API key created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ApiKeyResponse'

    get:
      summary: List API keys
      tags: [API Keys]
      security:
        - bearerAuth: []
      responses:
        200:
          description: List of API keys
          content:
            application/json:
              schema:
                type: object
                properties:
                  api_keys:
                    type: array
                    items:
                      $ref: '#/components/schemas/ApiKey'
                  total:
                    type: integer

  /auth/sessions:
    post:
      summary: Create new session
      tags: [Session Management]
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateSessionRequest'
      responses:
        201:
          description: Session created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/SessionResponse'

  /auth/sessions/{sessionId}/validate:
    get:
      summary: Validate session
      tags: [Session Management]
      parameters:
        - name: sessionId
          in: path
          required: true
          schema:
            type: string
      responses:
        200:
          description: Session validation result
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/SessionValidationResponse'

components:
  schemas:
    TokenResponse:
      type: object
      properties:
        access_token:
          type: string
        token_type:
          type: string
          enum: [Bearer]
        expires_in:
          type: integer
        refresh_token:
          type: string
        scope:
          type: string

    CreateApiKeyRequest:
      type: object
      required:
        - name
        - permissions
      properties:
        name:
          type: string
        description:
          type: string
        permissions:
          type: array
          items:
            type: string
        expires_at:
          type: string
          format: date-time
        rate_limit:
          type: object
          properties:
            requests_per_hour:
              type: integer
            burst_limit:
              type: integer

    ApiKeyResponse:
      type: object
      properties:
        api_key:
          type: string
        key_id:
          type: string
        name:
          type: string
        permissions:
          type: array
          items:
            type: string
        created_at:
          type: string
          format: date-time
        expires_at:
          type: string
          format: date-time

    ApiKey:
      type: object
      properties:
        key_id:
          type: string
        name:
          type: string
        permissions:
          type: array
          items:
            type: string
        created_at:
          type: string
          format: date-time
        expires_at:
          type: string
          format: date-time
        last_used:
          type: string
          format: date-time
        usage_count:
          type: integer
        status:
          type: string
          enum: [active, revoked, expired]

    CreateSessionRequest:
      type: object
      required:
        - user_id
      properties:
        user_id:
          type: string
        device_info:
          type: object
          properties:
            device_type:
              type: string
            os:
              type: string
            browser:
              type: string
            ip_address:
              type: string
        preferences:
          type: object
          properties:
            timeout:
              type: integer
            remember_device:
              type: boolean

    SessionResponse:
      type: object
      properties:
        session_id:
          type: string
        user_id:
          type: string
        created_at:
          type: string
          format: date-time
        expires_at:
          type: string
          format: date-time
        device_info:
          type: object
        status:
          type: string
          enum: [active, expired, terminated]
        permissions:
          type: array
          items:
            type: string

    SessionValidationResponse:
      type: object
      properties:
        valid:
          type: boolean
        session_id:
          type: string
        user_id:
          type: string
        expires_at:
          type: string
          format: date-time
        time_remaining:
          type: integer
        permissions:
          type: array
          items:
            type: string
        rate_limit_status:
          type: object
          properties:
            requests_remaining:
              type: integer
            reset_time:
              type: string
              format: date-time

    ErrorResponse:
      type: object
      properties:
        error:
          type: object
          properties:
            code:
              type: string
            message:
              type: string
            details:
              type: object
            timestamp:
              type: string
              format: date-time
            request_id:
              type: string

  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
    apiKeyAuth:
      type: apiKey
      in: header
      name: X-API-Key
```

## Best Practices

### Security Recommendations

1. **Token Management**
   - Use short-lived access tokens (1 hour)
   - Implement secure refresh token rotation
   - Store tokens securely on client side

2. **API Key Security**
   - Rotate API keys regularly (quarterly)
   - Use environment variables, never hardcode
   - Implement proper key scoping

3. **Session Security**
   - Enable MFA for sensitive operations
   - Monitor session activity
   - Implement session timeout policies

4. **Rate Limiting**
   - Implement exponential backoff
   - Monitor for abuse patterns
   - Use circuit breakers for protection

5. **Audit & Monitoring**
   - Log all authentication events
   - Monitor failed login attempts
   - Implement real-time alerting

---

The Authentication Service API provides enterprise-grade security features for the Claude Code CLI ecosystem, ensuring secure access to all agent operations and system functions while maintaining usability and performance.
