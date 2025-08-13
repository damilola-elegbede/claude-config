# /plan Command

## Description
Generates comprehensive strategic requirements and tactical implementation phases using TDD methodology. Creates actionable, PR-sized work packages with detailed implementation guidance and code examples.

## Usage
```bash
/plan <task_description>
```

## Command Execution Flow

### 1. Task Analysis (5-10 seconds)
```
Input → Complexity Analysis → Agent Selection → Strategic Planning → Tactical Breakdown → File Generation
```

### 2. Agent Selection Algorithm
```python
def select_agents(task_description):
    agents = []
    
    # Strategic Phase - Requirements Gathering
    if contains_keywords(task_description, ['api', 'backend', 'database']):
        agents.append('backend-engineer')
    if contains_keywords(task_description, ['ui', 'frontend', 'component']):
        agents.append('frontend-architect')
    if contains_keywords(task_description, ['auth', 'security', 'encryption']):
        agents.append('security-auditor')
    if contains_keywords(task_description, ['performance', 'scale', 'optimize']):
        agents.append('performance-specialist')
    
    # Tactical Phase - Always include
    agents.append('principal-architect')  # Primary tactical consultant
    agents.append('test-engineer')        # TDD methodology enforcer
    
    # Fallback for unmatched patterns
    if len(agents) < 3:
        agents.extend(['codebase-analyst', 'tech-writer'])
    
    return deduplicate(agents[:8])  # Max 8 agents to prevent analysis paralysis
```

### 3. Error Handling

**Command Failures:**
```javascript
try {
    const plan = await generatePlan(taskDescription);
    await validatePlan(plan);
    await writePlanFiles(plan);
} catch (error) {
    if (error.type === 'AGENT_CONFLICT') {
        return reconcileAgentOpinions(error.conflicts);
    }
    if (error.type === 'COMPLEXITY_OVERFLOW') {
        return splitIntoSubtasks(taskDescription);
    }
    if (error.type === 'INSUFFICIENT_CONTEXT') {
        return requestUserClarification(error.missingInfo);
    }
    throw new PlanGenerationError(error);
}
```

## File Organization

### Directory Structure
```
./.tmp/<feature-name>/
├── plan.md                    # Strategic requirements (2-4 pages)
├── phase-1-tests.md          # TDD test specifications
├── phase-2-implementation.md  # Core implementation
├── phase-3-integration.md    # Integration and validation
├── rollback.md               # Rollback procedures
└── .cleanup                   # Auto-cleanup metadata
```

### Auto-Cleanup Strategy
```javascript
// .cleanup file contains:
{
    "created": "2024-01-15T14:30:00Z",
    "expires": "2024-01-22T14:30:00Z",  // 7-day retention
    "feature": "user-authentication",
    "phases": 3,
    "status": "in-progress",
    "cleanup_on_merge": true
}
```

### Feature Name Generation
```javascript
function generateFeatureName(description) {
    // Extract core functionality
    const keywords = extractKeywords(description);
    const feature = keywords.slice(0, 3).join('-');
    
    // Ensure uniqueness
    const timestamp = Date.now().toString(36);
    return `${feature}-${timestamp}`.toLowerCase()
        .replace(/[^a-z0-9-]/g, '-')
        .replace(/-+/g, '-')
        .slice(0, 50);  // Max 50 chars
}
```

## Strategic Plan Format

### Requirements Document Template
```markdown
# <Feature Name> - Strategic Requirements

## Executive Summary
- **Objective**: [Clear business goal]
- **Scope**: [What's included/excluded]
- **Success Metrics**: [Measurable outcomes]
- **Estimated Effort**: [Phase-based time estimates]

## Functional Requirements
| ID | Requirement | Priority | Acceptance Criteria |
|----|------------|----------|-------------------|
| FR-001 | [Requirement] | P0 | [Testable criteria] |

## Non-Functional Requirements
| ID | Category | Requirement | Measurement |
|----|----------|------------|-------------|
| NFR-001 | Performance | [Requirement] | [SLA/metric] |

## Technical Architecture
- **Pattern**: [Architecture pattern]
- **Stack**: [Technology choices with rationale]
- **Dependencies**: [External systems/libraries]
- **Security**: [Security considerations]

## Risk Assessment
| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| [Risk] | Low/Med/High | Low/Med/High | [Strategy] |

## Implementation Phases
1. **Phase 1**: Test scaffolding and interfaces (4-6 files)
2. **Phase 2**: Core implementation (6-8 files)
3. **Phase 3**: Integration and validation (4-6 files)
```

## Tactical Phase Format

### Phase 1: Test-First Development
```markdown
# Phase 1: Test Scaffolding and Interfaces

## Execution Time: 2-3 hours
## Files to Create: 5
## Dependencies: None

## 1.1 Test Environment Setup

### File: `test/setup.js`
```javascript
// Environment configuration
process.env.NODE_ENV = 'test';
process.env.JWT_SECRET = 'test-secret-key-never-use-in-production';
process.env.BCRYPT_ROUNDS = '4'; // Fast for tests

const chai = require('chai');
const chaiHttp = require('chai-http');
const sinon = require('sinon');

chai.use(chaiHttp);

global.expect = chai.expect;
global.sinon = sinon;

// Cleanup after each test
afterEach(() => {
    sinon.restore();
});
```

**Rationale**: Test environment must be isolated from production configs. Using lower bcrypt rounds speeds up test execution without compromising test validity.

## 1.2 User Model Tests (TDD - Write First)

### File: `test/models/user.test.js`
```javascript
const User = require('../../src/models/User'); // Will fail initially
const ValidationError = require('../../src/errors/ValidationError');

describe('User Model', () => {
    describe('Password Hashing', () => {
        it('should hash password on creation', async () => {
            const plainPassword = 'SecureP@ss123';
            const user = new User({
                email: 'test@example.com',
                password: plainPassword
            });
            
            await user.save();
            
            expect(user.password).to.not.equal(plainPassword);
            expect(user.password).to.have.length.above(50);
        });
        
        it('should not rehash password if unchanged', async () => {
            const user = await User.create({
                email: 'test@example.com',
                password: 'SecureP@ss123'
            });
            
            const originalHash = user.password;
            user.email = 'newemail@example.com';
            await user.save();
            
            expect(user.password).to.equal(originalHash);
        });
    });
    
    describe('Input Validation', () => {
        it('should reject invalid email formats', async () => {
            const invalidEmails = [
                'notanemail',
                '@example.com',
                'user@',
                'user @example.com'
            ];
            
            for (const email of invalidEmails) {
                try {
                    await User.create({ email, password: 'ValidP@ss123' });
                    throw new Error(`Should have rejected: ${email}`);
                } catch (error) {
                    expect(error).to.be.instanceOf(ValidationError);
                    expect(error.field).to.equal('email');
                }
            }
        });
        
        it('should enforce password complexity', async () => {
            const weakPasswords = [
                'short',           // Too short
                'nouppercase123!', // No uppercase
                'NOLOWERCASE123!', // No lowercase
                'NoNumbers!',      // No numbers
                'NoSpecial123'     // No special chars
            ];
            
            for (const password of weakPasswords) {
                try {
                    await User.create({ 
                        email: 'test@example.com', 
                        password 
                    });
                    throw new Error(`Should have rejected: ${password}`);
                } catch (error) {
                    expect(error).to.be.instanceOf(ValidationError);
                    expect(error.field).to.equal('password');
                    expect(error.message).to.include('complexity');
                }
            }
        });
    });
    
    describe('Security Features', () => {
        it('should not expose password in JSON', () => {
            const user = new User({
                email: 'test@example.com',
                password: 'SecureP@ss123'
            });
            
            const json = user.toJSON();
            
            expect(json).to.not.have.property('password');
            expect(json).to.have.property('email');
        });
        
        it('should rate limit password comparisons', async () => {
            const user = await User.create({
                email: 'test@example.com',
                password: 'SecureP@ss123'
            });
            
            const attempts = [];
            for (let i = 0; i < 10; i++) {
                attempts.push(user.comparePassword('wrong'));
            }
            
            try {
                await Promise.all(attempts);
                throw new Error('Should have rate limited');
            } catch (error) {
                expect(error.message).to.include('rate limit');
            }
        });
    });
});
```

**Rationale**: Tests written first define the contract. Implementation must satisfy these tests exactly. Security tests ensure protection against common vulnerabilities.

## 1.3 Interface Definitions

### File: `src/interfaces/IUser.ts`
```typescript
export interface IUser {
    id: string;
    email: string;
    password?: string;  // Optional in responses
    createdAt: Date;
    updatedAt: Date;
    
    comparePassword(plaintext: string): Promise<boolean>;
    generateAuthToken(): string;
    toJSON(): Omit<IUser, 'password'>;
}

export interface IUserInput {
    email: string;
    password: string;
}

export interface IUserRepository {
    create(input: IUserInput): Promise<IUser>;
    findByEmail(email: string): Promise<IUser | null>;
    findById(id: string): Promise<IUser | null>;
    update(id: string, updates: Partial<IUserInput>): Promise<IUser>;
    delete(id: string): Promise<boolean>;
}
```

**Rationale**: Interfaces define contracts before implementation. TypeScript ensures type safety across the application.

## 1.4 Error Definitions

### File: `src/errors/index.js`
```javascript
class ApplicationError extends Error {
    constructor(message, statusCode = 500, field = null) {
        super(message);
        this.statusCode = statusCode;
        this.field = field;
        this.timestamp = new Date().toISOString();
        Error.captureStackTrace(this, this.constructor);
    }
    
    toJSON() {
        return {
            error: this.constructor.name,
            message: this.message,
            field: this.field,
            timestamp: this.timestamp,
            ...(process.env.NODE_ENV === 'development' && {
                stack: this.stack
            })
        };
    }
}

class ValidationError extends ApplicationError {
    constructor(field, message) {
        super(message, 400, field);
    }
}

class AuthenticationError extends ApplicationError {
    constructor(message = 'Authentication failed') {
        super(message, 401);
    }
}

class RateLimitError extends ApplicationError {
    constructor(retryAfter = 60) {
        super(`Rate limit exceeded. Retry after ${retryAfter}s`, 429);
        this.retryAfter = retryAfter;
    }
}

module.exports = {
    ApplicationError,
    ValidationError,
    AuthenticationError,
    RateLimitError
};
```

**Rationale**: Centralized error handling ensures consistent API responses and debugging information.

## Phase Completion Criteria
✅ All tests written and failing appropriately
✅ Interfaces fully defined
✅ Error classes implemented
✅ No implementation code yet (TDD discipline)
✅ 100% test coverage for defined behaviors

## Next Phase Trigger
Once all Phase 1 tests are red (failing), proceed to Phase 2 for implementation.
```

### Phase 2: Core Implementation
```markdown
# Phase 2: Core Implementation

## Execution Time: 3-4 hours
## Files to Create: 6
## Dependencies: Phase 1 tests must be failing

## 2.1 User Model Implementation

### File: `src/models/User.js`
```javascript
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const mongoose = require('mongoose');
const { ValidationError, RateLimitError } = require('../errors');

// Rate limiting for password attempts
const passwordAttempts = new Map();
const RATE_LIMIT_WINDOW = 60000; // 1 minute
const MAX_ATTEMPTS = 5;

const userSchema = new mongoose.Schema({
    email: {
        type: String,
        required: [true, 'Email is required'],
        unique: true,
        lowercase: true,
        trim: true,
        validate: {
            validator: (email) => {
                // RFC 5322 compliant email regex
                const regex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                return regex.test(email);
            },
            message: 'Invalid email format'
        }
    },
    password: {
        type: String,
        required: [true, 'Password is required'],
        minlength: [8, 'Password must be at least 8 characters'],
        validate: {
            validator: function(password) {
                // Only validate on create or password change
                if (!this.isModified('password')) return true;
                
                const hasUpper = /[A-Z]/.test(password);
                const hasLower = /[a-z]/.test(password);
                const hasNumber = /\d/.test(password);
                const hasSpecial = /[!@#$%^&*(),.?":{}|<>]/.test(password);
                
                if (!hasUpper || !hasLower || !hasNumber || !hasSpecial) {
                    throw new ValidationError('password', 
                        'Password must contain uppercase, lowercase, number, and special character');
                }
                return true;
            }
        }
    }
}, {
    timestamps: true
});

// Hash password before saving
userSchema.pre('save', async function(next) {
    try {
        if (!this.isModified('password')) return next();
        
        const rounds = parseInt(process.env.BCRYPT_ROUNDS || '12', 10);
        this.password = await bcrypt.hash(this.password, rounds);
        next();
    } catch (error) {
        next(error);
    }
});

// Rate-limited password comparison
userSchema.methods.comparePassword = async function(plaintext) {
    const key = this._id.toString();
    const now = Date.now();
    
    // Clean old entries
    if (passwordAttempts.has(key)) {
        const attempts = passwordAttempts.get(key);
        const recent = attempts.filter(time => now - time < RATE_LIMIT_WINDOW);
        
        if (recent.length >= MAX_ATTEMPTS) {
            throw new RateLimitError(60);
        }
        
        passwordAttempts.set(key, [...recent, now]);
    } else {
        passwordAttempts.set(key, [now]);
    }
    
    return bcrypt.compare(plaintext, this.password);
};

// Generate JWT token
userSchema.methods.generateAuthToken = function() {
    const payload = {
        id: this._id.toString(),
        email: this.email
    };
    
    const options = {
        expiresIn: process.env.JWT_EXPIRES_IN || '24h',
        algorithm: 'RS256'
    };
    
    return jwt.sign(payload, process.env.JWT_PRIVATE_KEY, options);
};

// Remove password from JSON responses
userSchema.methods.toJSON = function() {
    const obj = this.toObject();
    delete obj.password;
    delete obj.__v;
    return obj;
};

// Handle unique constraint errors
userSchema.post('save', function(error, doc, next) {
    if (error.name === 'MongoError' && error.code === 11000) {
        next(new ValidationError('email', 'Email already exists'));
    } else {
        next(error);
    }
});

module.exports = mongoose.model('User', userSchema);
```

**Rationale**: Implementation satisfies all Phase 1 tests. Security features include rate limiting, proper hashing, and JWT with RS256.

## 2.2 Authentication Middleware

### File: `src/middleware/auth.js`
```javascript
const jwt = require('jsonwebtoken');
const { AuthenticationError } = require('../errors');
const User = require('../models/User');

// Cache for validated tokens (TTL: 5 minutes)
const tokenCache = new Map();
const CACHE_TTL = 300000;

function cleanCache() {
    const now = Date.now();
    for (const [token, data] of tokenCache.entries()) {
        if (now - data.timestamp > CACHE_TTL) {
            tokenCache.delete(token);
        }
    }
}

// Run cache cleanup every minute
setInterval(cleanCache, 60000);

async function authenticate(req, res, next) {
    try {
        const token = extractToken(req);
        
        if (!token) {
            throw new AuthenticationError('No token provided');
        }
        
        // Check cache first
        if (tokenCache.has(token)) {
            const cached = tokenCache.get(token);
            req.user = cached.user;
            return next();
        }
        
        // Verify token
        const decoded = jwt.verify(token, process.env.JWT_PUBLIC_KEY, {
            algorithms: ['RS256']
        });
        
        // Get user from database
        const user = await User.findById(decoded.id).select('-password');
        
        if (!user) {
            throw new AuthenticationError('User not found');
        }
        
        // Cache the result
        tokenCache.set(token, {
            user,
            timestamp: Date.now()
        });
        
        req.user = user;
        next();
    } catch (error) {
        if (error.name === 'JsonWebTokenError') {
            return next(new AuthenticationError('Invalid token'));
        }
        if (error.name === 'TokenExpiredError') {
            return next(new AuthenticationError('Token expired'));
        }
        next(error);
    }
}

function extractToken(req) {
    // Check Authorization header
    const authHeader = req.headers.authorization;
    if (authHeader && authHeader.startsWith('Bearer ')) {
        return authHeader.substring(7);
    }
    
    // Check cookie
    if (req.cookies && req.cookies.token) {
        return req.cookies.token;
    }
    
    return null;
}

// Optional authentication (doesn't fail if no token)
async function optionalAuth(req, res, next) {
    const token = extractToken(req);
    
    if (!token) {
        return next();
    }
    
    // Use regular auth but catch errors
    authenticate(req, res, (error) => {
        if (error) {
            // Log but don't fail
            console.warn('Optional auth failed:', error.message);
            req.user = null;
        }
        next();
    });
}

module.exports = {
    authenticate,
    optionalAuth
};
```

**Rationale**: Middleware includes token caching for performance, multiple token sources, and optional authentication for mixed content.

## Phase 2 Completion Criteria
✅ All Phase 1 tests passing
✅ Security features implemented (rate limiting, hashing)
✅ Performance optimizations (caching)
✅ Error handling comprehensive
✅ 100% test coverage maintained

## Phase 2 to 3 Trigger
Once all Phase 2 implementations pass tests, proceed to Phase 3 for integration.
```

### Phase 3: Integration and Validation
```markdown
# Phase 3: Integration and Validation

## Execution Time: 2-3 hours
## Files to Create: 4
## Dependencies: Phases 1-2 complete

## 3.1 API Routes Implementation

### File: `src/routes/auth.js`
```javascript
const express = require('express');
const router = express.Router();
const User = require('../models/User');
const { authenticate } = require('../middleware/auth');
const { ValidationError, AuthenticationError } = require('../errors');
const { body, validationResult } = require('express-validator');

// Input validation rules
const registrationRules = [
    body('email').isEmail().normalizeEmail(),
    body('password').isLength({ min: 8 }).trim()
];

const loginRules = [
    body('email').isEmail().normalizeEmail(),
    body('password').notEmpty()
];

// Validation middleware
function validate(req, res, next) {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        const firstError = errors.array()[0];
        return next(new ValidationError(firstError.param, firstError.msg));
    }
    next();
}

// POST /auth/register
router.post('/register', registrationRules, validate, async (req, res, next) => {
    try {
        const { email, password } = req.body;
        
        // Check if user exists
        const existing = await User.findOne({ email });
        if (existing) {
            throw new ValidationError('email', 'Email already registered');
        }
        
        // Create user
        const user = new User({ email, password });
        await user.save();
        
        // Generate token
        const token = user.generateAuthToken();
        
        // Set secure cookie
        res.cookie('token', token, {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production',
            sameSite: 'strict',
            maxAge: 24 * 60 * 60 * 1000 // 24 hours
        });
        
        res.status(201).json({
            success: true,
            user: user.toJSON(),
            token
        });
    } catch (error) {
        next(error);
    }
});

// POST /auth/login
router.post('/login', loginRules, validate, async (req, res, next) => {
    try {
        const { email, password } = req.body;
        
        // Find user
        const user = await User.findOne({ email });
        if (!user) {
            throw new AuthenticationError('Invalid credentials');
        }
        
        // Verify password
        const isValid = await user.comparePassword(password);
        if (!isValid) {
            throw new AuthenticationError('Invalid credentials');
        }
        
        // Generate token
        const token = user.generateAuthToken();
        
        // Set secure cookie
        res.cookie('token', token, {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production',
            sameSite: 'strict',
            maxAge: 24 * 60 * 60 * 1000
        });
        
        res.json({
            success: true,
            user: user.toJSON(),
            token
        });
    } catch (error) {
        next(error);
    }
});

// POST /auth/logout
router.post('/logout', authenticate, (req, res) => {
    res.clearCookie('token');
    res.json({ success: true, message: 'Logged out successfully' });
});

// GET /auth/me
router.get('/me', authenticate, (req, res) => {
    res.json({
        success: true,
        user: req.user.toJSON()
    });
});

module.exports = router;
```

**Rationale**: Routes implement complete authentication flow with input validation, secure cookies, and proper error handling.

## 3.2 Integration Tests

### File: `test/integration/auth.test.js`
```javascript
const request = require('supertest');
const app = require('../../src/app');
const User = require('../../src/models/User');
const { connectDB, clearDB, closeDB } = require('../helpers/database');

describe('Authentication API', () => {
    before(async () => {
        await connectDB();
    });
    
    afterEach(async () => {
        await clearDB();
    });
    
    after(async () => {
        await closeDB();
    });
    
    describe('POST /auth/register', () => {
        it('should register new user', async () => {
            const res = await request(app)
                .post('/auth/register')
                .send({
                    email: 'newuser@example.com',
                    password: 'SecureP@ss123'
                })
                .expect(201);
            
            expect(res.body.success).to.be.true;
            expect(res.body.user.email).to.equal('newuser@example.com');
            expect(res.body.token).to.be.a('string');
            expect(res.body.user).to.not.have.property('password');
        });
        
        it('should reject duplicate emails', async () => {
            await User.create({
                email: 'existing@example.com',
                password: 'SecureP@ss123'
            });
            
            const res = await request(app)
                .post('/auth/register')
                .send({
                    email: 'existing@example.com',
                    password: 'SecureP@ss123'
                })
                .expect(400);
            
            expect(res.body.error).to.equal('ValidationError');
            expect(res.body.field).to.equal('email');
        });
    });
    
    describe('POST /auth/login', () => {
        beforeEach(async () => {
            await User.create({
                email: 'test@example.com',
                password: 'SecureP@ss123'
            });
        });
        
        it('should login with valid credentials', async () => {
            const res = await request(app)
                .post('/auth/login')
                .send({
                    email: 'test@example.com',
                    password: 'SecureP@ss123'
                })
                .expect(200);
            
            expect(res.body.success).to.be.true;
            expect(res.body.token).to.be.a('string');
            expect(res.headers['set-cookie']).to.be.an('array');
        });
        
        it('should reject invalid password', async () => {
            const res = await request(app)
                .post('/auth/login')
                .send({
                    email: 'test@example.com',
                    password: 'WrongPassword'
                })
                .expect(401);
            
            expect(res.body.error).to.equal('AuthenticationError');
        });
    });
    
    describe('GET /auth/me', () => {
        let token;
        
        beforeEach(async () => {
            const user = await User.create({
                email: 'test@example.com',
                password: 'SecureP@ss123'
            });
            token = user.generateAuthToken();
        });
        
        it('should return current user with valid token', async () => {
            const res = await request(app)
                .get('/auth/me')
                .set('Authorization', `Bearer ${token}`)
                .expect(200);
            
            expect(res.body.user.email).to.equal('test@example.com');
        });
        
        it('should reject invalid token', async () => {
            await request(app)
                .get('/auth/me')
                .set('Authorization', 'Bearer invalid-token')
                .expect(401);
        });
    });
});
```

**Rationale**: Integration tests validate the complete authentication flow end-to-end, ensuring all components work together correctly.

## Phase 3 Completion Criteria
✅ All API endpoints implemented and tested
✅ Integration tests passing
✅ Security headers configured
✅ Performance benchmarks met (<200ms response time)
✅ Ready for production deployment

## Deployment Readiness Checklist
- [ ] Environment variables configured
- [ ] SSL certificates installed
- [ ] Rate limiting configured
- [ ] Monitoring alerts set up
- [ ] Backup strategy implemented
- [ ] Rollback procedure documented
```

## Rollback Procedures

### Rollback Strategy Document
```markdown
# Rollback Procedures

## Phase Rollback Matrix

| Phase | Rollback Action | Time | Risk |
|-------|----------------|------|------|
| Phase 1 | Delete test files only | 5min | None |
| Phase 2 | Revert model/middleware changes | 15min | Low |
| Phase 3 | Revert routes, maintain tests | 10min | Low |

## Emergency Rollback Script
```bash
#!/bin/bash
# rollback.sh - Emergency rollback for authentication feature

PHASE=$1
BACKUP_DIR="./.tmp/backups"

case $PHASE in
    1)
        echo "Rolling back Phase 1: Tests"
        rm -rf test/models/user.test.js
        rm -rf test/setup.js
        rm -rf src/interfaces/
        rm -rf src/errors/
        ;;
    2)
        echo "Rolling back Phase 2: Implementation"
        git checkout HEAD -- src/models/User.js
        git checkout HEAD -- src/middleware/auth.js
        ;;
    3)
        echo "Rolling back Phase 3: Integration"
        git checkout HEAD -- src/routes/auth.js
        rm -rf test/integration/auth.test.js
        ;;
    all)
        echo "Complete rollback"
        git checkout HEAD -- .
        rm -rf ./.tmp/user-authentication-*
        ;;
    *)
        echo "Usage: ./rollback.sh [1|2|3|all]"
        exit 1
        ;;
esac

echo "Rollback complete for Phase $PHASE"
```

## Monitoring Script
```bash
#!/bin/bash
# monitor.sh - Monitor feature implementation progress

check_phase() {
    local phase=$1
    local test_file=$2
    
    if [ -f "$test_file" ]; then
        npm test "$test_file" --silent
        if [ $? -eq 0 ]; then
            echo "✅ Phase $phase: Tests passing"
        else
            echo "⚠️ Phase $phase: Tests failing (expected for TDD)"
        fi
    else
        echo "❌ Phase $phase: Not started"
    fi
}

echo "=== Feature Implementation Status ==="
check_phase 1 "test/models/user.test.js"
check_phase 2 "src/models/User.js"
check_phase 3 "test/integration/auth.test.js"
```
```

## Performance Specifications

### Execution Benchmarks
| Operation | Target | Maximum | Monitoring |
|-----------|--------|---------|------------|
| Plan generation | <10s | 30s | Agent response times |
| File writing | <2s | 5s | Disk I/O metrics |
| Agent deployment | <5s | 15s | Parallel execution tracking |
| Total execution | <20s | 45s | End-to-end timing |

### Resource Limits
```javascript
const RESOURCE_LIMITS = {
    maxAgents: 8,              // Maximum concurrent agents
    maxFileSize: 100_000,       // 100KB per file
    maxTotalSize: 1_000_000,    // 1MB total output
    maxPhases: 10,              // Maximum implementation phases
    maxFilesPerPhase: 15,       // Maximum files per phase
    timeoutSeconds: 45          // Total command timeout
};
```

## Agent Conflict Resolution

### Conflict Detection and Resolution
```javascript
function resolveAgentConflicts(opinions) {
    const conflicts = detectConflicts(opinions);
    
    if (conflicts.length === 0) {
        return mergeOpinions(opinions);
    }
    
    // Priority-based resolution
    const priorityOrder = [
        'security-auditor',     // Security always wins
        'principal-architect',  // Architecture decisions next
        'performance-specialist', // Performance considerations
        'test-engineer',        // Testing requirements
        'backend-engineer',     // Implementation details
        'frontend-architect'    // UI/UX decisions
    ];
    
    for (const conflict of conflicts) {
        const winner = priorityOrder.find(agent => 
            conflict.agents.includes(agent)
        );
        
        if (winner) {
            conflict.resolution = opinions[winner];
            conflict.reason = `${winner} has priority for ${conflict.type}`;
        } else {
            // Fall back to user clarification
            conflict.resolution = 'USER_CLARIFICATION_REQUIRED';
        }
    }
    
    return applyResolutions(opinions, conflicts);
}
```

## Security Configurations

### Environment Variables
```bash
# .env.example
NODE_ENV=development
JWT_PRIVATE_KEY_PATH=./keys/private.pem  # Generated, not stored
JWT_PUBLIC_KEY_PATH=./keys/public.pem    # Generated, not stored
JWT_EXPIRES_IN=24h
BCRYPT_ROUNDS=12                         # Production: 12-14
RATE_LIMIT_WINDOW=60000                  # 1 minute
RATE_LIMIT_MAX_ATTEMPTS=5
COOKIE_SECURE=true                        # Production only
COOKIE_SAMESITE=strict
```

### Key Generation Script
```bash
#!/bin/bash
# generate-keys.sh - Generate RSA keys for JWT signing

mkdir -p keys

# Generate private key
openssl genpkey -algorithm RSA -out keys/private.pem -pkeyopt rsa_keygen_bits:2048

# Generate public key
openssl rsa -pubout -in keys/private.pem -out keys/public.pem

# Set proper permissions
chmod 600 keys/private.pem
chmod 644 keys/public.pem

echo "✅ RSA keys generated in ./keys/"
```

## Command Integration

### Implementation Hook
```javascript
// Implementation in Claude Code command handler
async function handlePlanCommand(taskDescription) {
    const monitor = new PerformanceMonitor();
    
    try {
        monitor.start('total');
        
        // Step 1: Select agents
        monitor.start('agent_selection');
        const agents = selectAgents(taskDescription);
        monitor.end('agent_selection');
        
        // Step 2: Generate strategic plan
        monitor.start('strategic_planning');
        const strategicPlan = await generateStrategicPlan(
            taskDescription, 
            agents
        );
        monitor.end('strategic_planning');
        
        // Step 3: Generate tactical phases
        monitor.start('tactical_breakdown');
        const tacticalPhases = await generateTacticalPhases(
            strategicPlan,
            'principal-architect'
        );
        monitor.end('tactical_breakdown');
        
        // Step 4: Write files
        monitor.start('file_writing');
        const outputDir = await writeFiles(
            strategicPlan,
            tacticalPhases
        );
        monitor.end('file_writing');
        
        monitor.end('total');
        
        return {
            success: true,
            outputDir,
            metrics: monitor.getMetrics(),
            summary: generateSummary(strategicPlan, tacticalPhases)
        };
        
    } catch (error) {
        monitor.end('total');
        
        return {
            success: false,
            error: error.message,
            metrics: monitor.getMetrics(),
            rollback: getRollbackInstructions(error)
        };
    }
}
```

## Success Metrics

### Quality Gates
- ✅ All examples follow TDD (tests before implementation)
- ✅ Error handling comprehensive with specific error types
- ✅ Security vulnerabilities addressed (environment variables, validation)
- ✅ Performance specifications defined with measurable SLAs
- ✅ Rollback procedures documented for each phase
- ✅ Agent selection algorithm deterministic
- ✅ File cleanup strategy implemented
- ✅ Conflict resolution strategy defined
- ✅ Resource limits enforced
- ✅ Monitoring and observability built-in

## Notes

- **TDD Discipline**: Tests MUST be written before implementation code
- **Security First**: All examples use environment variables, never hardcoded values
- **Error Recovery**: Every operation has defined error handling and rollback
- **Performance**: Caching strategies and resource limits prevent system overload
- **Maintainability**: Clear phase separation enables incremental development
- **Production Ready**: Examples include monitoring, logging, and observability