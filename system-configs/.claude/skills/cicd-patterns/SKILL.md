---
name: cicd-patterns
description: GitHub Actions workflow patterns, pipeline optimization, and CI/CD best practices.
category: infrastructure
user-invocable: false
---

# CI/CD Patterns Reference

## GitHub Actions Workflow Structure

### Triggers

```yaml
on:
  push:
    branches: [main, develop]
    paths-ignore: ['docs/**', '*.md']
  pull_request:
    branches: [main]
  workflow_dispatch:          # Manual trigger
  schedule:
    - cron: '0 6 * * 1'      # Weekly Monday 6am UTC
```

### Jobs and Steps

```yaml
jobs:
  lint:
    name: Code Quality Checks
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
      - name: Install dependencies
        run: npm ci --prefer-offline
      - name: Run linters
        run: npm run lint
```

### Matrix Strategies

```yaml
jobs:
  test:
    strategy:
      fail-fast: false
      matrix:
        os: [ubuntu-latest, macos-latest]
        node-version: [18, 20, 22]
        exclude:
          - os: macos-latest
            node-version: 18
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
      - run: npm ci && npm test
```

## Standard Pipeline Pattern

```text
lint -> test -> build -> deploy

  [lint]          Static analysis, formatting checks
    |
  [test]          Unit tests, integration tests (may run in parallel with lint)
    |
  [build]         Compile, bundle, Docker image
    |
  [deploy:staging]   Deploy to staging (auto on main)
    |
  [deploy:prod]      Deploy to production (manual approval)
```

### Job Dependencies

```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps: [...]

  test:
    runs-on: ubuntu-latest
    needs: lint
    steps: [...]

  build:
    runs-on: ubuntu-latest
    needs: [lint, test]
    if: github.ref == 'refs/heads/main'
    steps: [...]

  deploy:
    runs-on: ubuntu-latest
    needs: build
    environment: production
    steps: [...]
```

## Caching Strategies

### Node.js (npm)

```yaml
- uses: actions/setup-node@v4
  with:
    node-version: '18'
    cache: 'npm'
- run: npm ci --prefer-offline
```

### Python (pip)

```yaml
- uses: actions/setup-python@v5
  with:
    python-version: '3.12'
    cache: 'pip'
- run: pip install -r requirements.txt
```

### Go Modules

```yaml
- uses: actions/setup-go@v5
  with:
    go-version: '1.22'
    cache: true
- run: go build ./...
```

### Docker Layer Caching

```yaml
- uses: docker/build-push-action@v5
  with:
    context: .
    push: true
    tags: ${{ env.REGISTRY }}/${{ env.IMAGE }}:${{ github.sha }}
    cache-from: type=gha
    cache-to: type=gha,mode=max
```

### Custom Cache

```yaml
- uses: actions/cache@v4
  with:
    path: |
      ~/.cache/custom
      .build-cache
    key: ${{ runner.os }}-custom-${{ hashFiles('**/lockfile') }}
    restore-keys: |
      ${{ runner.os }}-custom-
```

## Security

### Secrets Management

```yaml
# Use GitHub encrypted secrets
env:
  API_KEY: ${{ secrets.API_KEY }}

# Use OIDC for cloud providers (no static credentials)
permissions:
  id-token: write
  contents: read

steps:
  - uses: aws-actions/configure-aws-credentials@v4
    with:
      role-to-assume: arn:aws:iam::123456789:role/deploy
      aws-region: us-east-1
```

### Minimal Permissions

```yaml
# Default: read-only
permissions:
  contents: read

# Explicit per-job when needed
jobs:
  deploy:
    permissions:
      contents: read
      id-token: write
      packages: write
```

### Dependency Pinning

```yaml
# Pin actions to SHA, not tags
- uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11  # v4.1.1

# Or at minimum, pin major version
- uses: actions/checkout@v4
```

### Security Scanning

```yaml
- name: Run Trivy vulnerability scanner
  uses: aquasecurity/trivy-action@master
  with:
    scan-type: 'fs'
    severity: 'CRITICAL,HIGH'
    exit-code: '1'
```

## Performance Optimization

### Parallel Jobs

```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps: [...]
  unit-test:
    runs-on: ubuntu-latest
    steps: [...]       # Runs in parallel with lint
  integration-test:
    runs-on: ubuntu-latest
    steps: [...]       # Runs in parallel with lint and unit-test
  build:
    needs: [lint, unit-test, integration-test]  # Waits for all
    steps: [...]
```

### Conditional Execution

```yaml
jobs:
  deploy:
    if: github.ref == 'refs/heads/main'
    steps: [...]

  docs:
    if: contains(github.event.head_commit.message, '[docs]')
    steps: [...]

  skip-ci:
    if: "!contains(github.event.head_commit.message, '[skip ci]')"
    steps: [...]
```

### Path Filtering

```yaml
on:
  push:
    paths:
      - 'src/**'
      - 'tests/**'
      - 'package.json'
    paths-ignore:
      - 'docs/**'
      - '*.md'
      - '.github/ISSUE_TEMPLATE/**'
```

### Artifact Passing

```yaml
jobs:
  build:
    steps:
      - run: npm run build
      - uses: actions/upload-artifact@v4
        with:
          name: build-output
          path: dist/
          retention-days: 1

  deploy:
    needs: build
    steps:
      - uses: actions/download-artifact@v4
        with:
          name: build-output
          path: dist/
```

## Monitoring

### Prometheus Patterns

```yaml
# Prometheus scrape config for Kubernetes
scrape_configs:
  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
      - role: pod
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: "true"
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
        action: replace
        target_label: __metrics_path__
        regex: (.+)
```

### Alerting Rules

```yaml
groups:
  - name: application
    rules:
      - alert: HighErrorRate
        expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.05
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "High error rate detected"

      - alert: HighLatency
        expr: histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m])) > 1
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "P99 latency above 1s"
```

## YAML Formatting Standards

- **Indentation**: 2 spaces consistently (never tabs)
- **Job naming**: Clear, descriptive names with proper casing
- **Environment variables**: UPPER_SNAKE_CASE
- **Secrets**: Never hardcode, always use secret stores
- **Caching**: Optimize for speed with proper cache keys
- **Artifacts**: Set appropriate retention policies
