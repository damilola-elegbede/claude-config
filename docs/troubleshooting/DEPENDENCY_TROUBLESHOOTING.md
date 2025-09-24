# Dependency Management and Build System Troubleshooting

## Overview

This document provides comprehensive troubleshooting guidance for dependency management and build system issues in the Claude Configuration Repository CI/CD pipeline.

## Common Issues and Solutions

### Python Dependencies

#### Issue: PyYAML Installation Failures

**Symptoms:**
- `pip install PyYAML` fails in CI
- ImportError when importing yaml module
- Version conflicts with system packages

**Solutions:**

1. **Version Pinning** (Implemented):
   ```bash
   pip install PyYAML==6.0.2
   ```

2. **System Dependencies** (Implemented):
   ```bash
   sudo apt-get install -y build-essential python3-dev
   ```

3. **Requirements File** (Implemented):
   ```bash
   pip install -r requirements.txt
   ```

#### Issue: pip Upgrade Process

**Symptoms:**
- Old pip version causing compatibility issues
- SSL certificate errors during package installation

**Solution:**
```bash
python -m pip install --upgrade pip>=24.0
```

### Node.js Dependencies

#### Issue: npm ci Failures

**Symptoms:**
- Network timeouts during package installation
- Rate limiting errors (429)
- Package integrity verification failures

**Solutions:**

1. **Retry Logic** (Implemented):
   ```bash
   for attempt in {1..3}; do
     if npm ci --prefer-offline --no-audit --progress=false; then
       break
     else
       sleep $((attempt * 5))
     fi
   done
   ```

2. **Registry Configuration** (Implemented):
   ```bash
   npm config set fetch-retry-mintimeout 20000
   npm config set fetch-retry-maxtimeout 120000
   npm config set fetch-retries 5
   ```

3. **Cache Optimization**:
   - Using `actions/setup-node@v5` with `cache: 'npm'`
   - Version pinned to `20.17.0` for consistency

#### Issue: Package-lock Integrity

**Symptoms:**
- Packages installed but not matching lock file
- Peer dependency warnings causing failures

**Solutions:**
- Always use `npm ci` instead of `npm install` in CI
- Verify package-lock.json is committed and up-to-date
- Use `--prefer-offline` to reduce network dependencies

### System Dependencies

#### Issue: Missing Build Tools

**Symptoms:**
- Native module compilation failures
- gcc/g++ not found errors
- Python header file missing errors

**Solution** (Implemented):
```bash
sudo apt-get update
sudo apt-get install -y build-essential python3-dev
```

#### Issue: File Permission Problems

**Symptoms:**
- Script execution permissions denied
- Tests fail due to non-executable files

**Solution** (Implemented):
```bash
# Fix permissions for test scripts
chmod +x tests/test.sh

# Fix permissions for all scripts
find scripts/ -name "*.sh" -type f -exec chmod +x {} \;
find scripts/ -name "*.py" -type f -exec chmod +x {} \;
```

### Resource Management

#### Issue: Disk Space Limitations

**Symptoms:**
- No space left on device errors
- Temporary file creation failures
- Package cache exhaustion

**Solutions:**

1. **Cleanup Operations** (Implemented):
   ```bash
   sudo apt-get clean
   docker system prune -f
   ```

2. **Resource Monitoring** (Implemented):
   ```bash
   df -h /tmp
   free -h
   ```

3. **Temp Directory Management**:
   ```bash
   export TMPDIR="/tmp/ci-test"
   mkdir -p "$TMPDIR"
   chmod 755 "$TMPDIR"
   ```

#### Issue: Memory Constraints

**Symptoms:**
- Out of memory errors during build
- Process killed by system
- Timeout errors in CI

**Solutions:**

1. **Resource Limits** (Implemented):
   ```bash
   sudo sysctl -w fs.file-max=65536
   ulimit -n 2048
   ```

2. **Test Timeouts**:
   - Individual step timeouts: 1-8 minutes
   - Job timeout: 15 minutes
   - Test-specific timeouts: 3-5 minutes

### CI Environment Configuration

#### Issue: Environment Variable Problems

**Symptoms:**
- Scripts behave differently in CI vs local
- Missing environment context
- Path resolution failures

**Solution** (Implemented):
```yaml
env:
  CI: true
  NO_COLOR: 1
  TERM: dumb
  TMPDIR: /tmp/ci-test
```

#### Issue: Ubuntu Version Compatibility

**Symptoms:**
- Package version mismatches
- System tool differences
- Dependency resolution conflicts

**Solutions:**
- Pin Python to specific version: `3.11.13`
- Pin Node.js to LTS version: `20.17.0`
- Use specific action versions: `@v5`, `@v4`

## Verification and Debugging

### Dependency Verification Script

Use the comprehensive verification script:
```bash
./.github/scripts/verify-dependencies.sh
```

This script checks:
- Python environment and PyYAML installation
- Node.js environment and package resolution
- System resources and temp directory access
- Memory and disk space availability

### Manual Debugging Steps

1. **Check Environment**:
   ```bash
   python --version
   node --version
   npm --version
   which python
   which node
   which npm
   ```

2. **Verify Dependencies**:
   ```bash
   python -c "import yaml; print(yaml.__version__)"
   npm list --depth=0
   pip list | grep -i yaml
   ```

3. **Check Resources**:
   ```bash
   df -h
   free -h
   ulimit -a
   ```

4. **Test Network Connectivity**:
   ```bash
   curl -I https://registry.npmjs.org/
   pip install --dry-run --verbose PyYAML
   ```

## Best Practices

### Version Management
- Pin all dependency versions in requirements.txt and package.json
- Use lock files (package-lock.json) and commit them
- Specify exact versions for CI actions

### Network Resilience
- Implement retry logic for all network operations
- Configure appropriate timeouts
- Use offline-first approaches where possible

### Resource Optimization
- Clean up temporary files and caches
- Monitor resource usage
- Set appropriate timeout limits

### Error Handling
- Implement comprehensive error reporting
- Use verbose logging for debugging
- Fail fast on critical dependency issues

## Contact and Escalation

For persistent dependency issues:
1. Check this troubleshooting guide first
2. Review CI logs for specific error patterns
3. Test locally with same dependency versions
4. Consider dependency version upgrades if security patches are available

Remember: All dependency management improvements should maintain backward compatibility and be tested in both CI and local environments.