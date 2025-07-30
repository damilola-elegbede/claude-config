#!/bin/bash
# Performance Optimizer for Claude Validation System
# Optimizes validation performance for large repositories
set -euo pipefail

REPO_ROOT=$(git rev-parse --show-toplevel)
OPTIMIZER_CONFIG="$REPO_ROOT/.claude/platform/performance.yml"
METRICS_DIR="$REPO_ROOT/.validation-metrics"
CACHE_DIR="$REPO_ROOT/.validation-cache"

# Colors
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# Initialize performance configuration
init_performance_config() {
    mkdir -p "$(dirname "$OPTIMIZER_CONFIG")" "$METRICS_DIR" "$CACHE_DIR"
    
    if [[ ! -f "$OPTIMIZER_CONFIG" ]]; then
        cat > "$OPTIMIZER_CONFIG" << 'EOF'
# Performance optimization configuration
performance:
  # Repository size thresholds
  thresholds:
    small_repo_files: 100
    medium_repo_files: 500
    large_repo_files: 1000
    huge_repo_files: 5000
  
  # Optimization strategies
  strategies:
    file_filtering:
      enabled: true
      ignore_patterns:
        - "*.log"
        - "*.tmp"
        - "node_modules/**"
        - ".git/**"
        - "*.cache"
    
    parallel_processing:
      enabled: true
      max_workers: 8
      chunk_size: 50
      
    caching:
      enabled: true
      ttl_hours: 24
      compression: true
      
    incremental_validation:
      enabled: true
      git_based: true
      since_commit: "HEAD~1"
      
    smart_skipping:
      enabled: true
      skip_unchanged: true
      hash_based: true

  # Platform-specific optimizations
  platform_specific:
    macos:
      use_fsevents: true
      parallel_io: true
    linux:
      use_inotify: true
      io_nice: true
    
  # Monitoring
  monitoring:
    enabled: true
    detailed_metrics: true
    performance_alerts: true
    benchmark_tracking: true
EOF
    fi
}

# Analyze repository characteristics
analyze_repository() {
    log_info "Analyzing repository characteristics..."
    
    local total_files=$(find . -type f \( ! -path './.git/*' ! -path './node_modules/*' \) | wc -l)
    local repo_size=$(du -sh . | cut -f1)
    local git_objects=$(git count-objects -v | grep 'count' | cut -d' ' -f2)
    local branch_count=$(git branch -a | wc -l)
    
    # Categorize repository size
    local repo_category
    if [[ $total_files -lt 100 ]]; then
        repo_category="small"
    elif [[ $total_files -lt 500 ]]; then
        repo_category="medium"
    elif [[ $total_files -lt 1000 ]]; then
        repo_category="large"
    else
        repo_category="huge"
    fi
    
    log_info "Repository analysis:"
    log_info "  Total files: $total_files"
    log_info "  Repository size: $repo_size"
    log_info "  Git objects: $git_objects"
    log_info "  Branches: $branch_count"
    log_info "  Category: $repo_category"
    
    # Store analysis results
    cat > "$METRICS_DIR/repo-analysis.json" << EOF
{
  "timestamp": "$(date -Iseconds)",
  "total_files": $total_files,
  "repo_size": "$repo_size",
  "git_objects": $git_objects,
  "branch_count": $branch_count,
  "category": "$repo_category",
  "analysis_duration": $SECONDS
}
EOF
    
    echo "$repo_category"
}

# Optimize for specific repository category
optimize_for_category() {
    local category="$1"
    
    log_info "Applying optimizations for $category repository..."
    
    case "$category" in
        small)
            optimize_small_repo
            ;;
        medium)
            optimize_medium_repo
            ;;
        large)
            optimize_large_repo
            ;;
        huge)
            optimize_huge_repo
            ;;
        *)
            log_warning "Unknown repository category: $category"
            optimize_medium_repo  # Default fallback
            ;;
    esac
}

# Small repository optimizations
optimize_small_repo() {
    log_info "Small repository optimizations:"
    
    # Disable complex caching for small repos
    update_config ".performance.strategies.caching.enabled" "false"
    update_config ".performance.strategies.parallel_processing.max_workers" "2"
    update_config ".performance.strategies.incremental_validation.enabled" "false"
    
    log_success "Small repo optimizations applied"
}

# Medium repository optimizations
optimize_medium_repo() {
    log_info "Medium repository optimizations:"
    
    # Balanced approach
    update_config ".performance.strategies.caching.enabled" "true"
    update_config ".performance.strategies.parallel_processing.max_workers" "4"
    update_config ".performance.strategies.incremental_validation.enabled" "true"
    update_config ".performance.strategies.file_filtering.enabled" "true"
    
    log_success "Medium repo optimizations applied"
}

# Large repository optimizations
optimize_large_repo() {
    log_info "Large repository optimizations:"
    
    # Aggressive caching and parallelization
    update_config ".performance.strategies.caching.enabled" "true"
    update_config ".performance.strategies.caching.compression" "true"
    update_config ".performance.strategies.parallel_processing.max_workers" "6"
    update_config ".performance.strategies.parallel_processing.chunk_size" "100"
    update_config ".performance.strategies.incremental_validation.enabled" "true"
    update_config ".performance.strategies.smart_skipping.enabled" "true"
    
    # Create file filtering rules
    create_advanced_filters
    
    log_success "Large repo optimizations applied"
}

# Huge repository optimizations
optimize_huge_repo() {
    log_info "Huge repository optimizations:"
    
    # Maximum performance settings
    update_config ".performance.strategies.caching.enabled" "true"
    update_config ".performance.strategies.caching.compression" "true"
    update_config ".performance.strategies.parallel_processing.max_workers" "8"
    update_config ".performance.strategies.parallel_processing.chunk_size" "200"
    update_config ".performance.strategies.incremental_validation.enabled" "true"
    update_config ".performance.strategies.smart_skipping.enabled" "true"
    update_config ".performance.strategies.file_filtering.enabled" "true"
    
    # Advanced optimizations
    create_advanced_filters
    setup_git_based_filtering
    create_performance_monitoring
    
    log_success "Huge repo optimizations applied"
}

# Update configuration helper
update_config() {
    local key="$1"
    local value="$2"
    
    if command -v yq >/dev/null 2>&1; then
        yq eval "$key = $value" -i "$OPTIMIZER_CONFIG"
    else
        log_warning "yq not available, manual config update needed for $key = $value"
    fi
}

# Create advanced file filtering
create_advanced_filters() {
    log_info "Creating advanced file filters..."
    
    # Create .claudeignore file if it doesn't exist
    if [[ ! -f "$REPO_ROOT/.claudeignore" ]]; then
        cat > "$REPO_ROOT/.claudeignore" << 'EOF'
# Claude Validate Ignore File
# Files and patterns to skip during validation

# Build artifacts
build/
dist/
out/
target/
*.o
*.so
*.dylib
*.dll

# Dependencies
node_modules/
vendor/
.venv/
venv/
__pycache__/

# IDE and editor files
.vscode/
.idea/
*.swp
*.swo
*~

# OS files
.DS_Store
Thumbs.db
desktop.ini

# Log files
*.log
*.log.*
logs/

# Temporary files
*.tmp
*.temp
.tmp/
.temp/

# Cache directories
.cache/
.npm/
.yarn/
.pnpm/

# Test coverage
coverage/
.coverage
.nyc_output/

# Documentation builds
_site/
.jekyll-cache/
.docusaurus/

# Large data files
*.csv
*.json
*.xml
data/
datasets/

# Binary files
*.pdf
*.docx
*.xlsx
*.pptx
*.zip
*.tar.gz
*.rar

# Media files
*.jpg
*.jpeg
*.png
*.gif
*.mp4
*.mov
*.avi
*.mp3
*.wav
EOF
        log_success "Created .claudeignore file"
    fi
}

# Setup Git-based filtering
setup_git_based_filtering() {
    log_info "Setting up Git-based incremental validation..."
    
    cat > "$REPO_ROOT/scripts/platform/git-filter.sh" << 'EOF'
#!/bin/bash
# Git-based incremental file filtering
set -euo pipefail

# Get files changed since last validation or specific commit
get_changed_files() {
    local since_ref="${1:-HEAD~1}"
    local filter_pattern="${2:-.*}"
    
    # Get changed files
    git diff --name-only "$since_ref" HEAD | grep -E "$filter_pattern" || true
    
    # Include untracked files that match pattern
    git ls-files --others --exclude-standard | grep -E "$filter_pattern" || true
}

# Get files in staging area
get_staged_files() {
    local filter_pattern="${1:-.*}"
    
    git diff --cached --name-only --diff-filter=ACM | grep -E "$filter_pattern" || true
}

# Smart file selection based on Git status
get_validation_files() {
    local mode="${1:-incremental}"  # incremental, staged, all
    local file_types="${2:-\.(md|sh|yml|yaml)$}"
    
    case "$mode" in
        staged)
            get_staged_files "$file_types"
            ;;
        incremental)
            get_changed_files "HEAD~1" "$file_types"
            ;;
        all)
            find . -type f -regex ".*$file_types" | grep -v -f .claudeignore 2>/dev/null || find . -type f -regex ".*$file_types"
            ;;
        *)
            echo "Usage: get_validation_files [staged|incremental|all] [file_pattern]" >&2
            return 1
            ;;
    esac
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    get_validation_files "$@"
fi
EOF
    
    chmod +x "$REPO_ROOT/scripts/platform/git-filter.sh"
    log_success "Git-based filtering setup complete"
}

# Create performance monitoring
create_performance_monitoring() {
    log_info "Setting up performance monitoring..."
    
    cat > "$REPO_ROOT/scripts/platform/perf-monitor.sh" << 'EOF'
#!/bin/bash
# Performance monitoring for validation system
set -euo pipefail

METRICS_DIR="${REPO_ROOT}/.validation-metrics"
PERF_LOG="$METRICS_DIR/performance.jsonl"

# Record performance metrics
record_metrics() {
    local operation="$1"
    local duration="$2"
    local files_count="$3"
    local cache_hit="${4:-false}"
    
    local timestamp=$(date -Iseconds)
    local metrics=$(cat << EOF
{
  "timestamp": "$timestamp",
  "operation": "$operation",
  "duration_seconds": $duration,
  "files_processed": $files_count,
  "cache_hit": $cache_hit,
  "throughput_files_per_second": $(echo "scale=2; $files_count / $duration" | bc -l 2>/dev/null || echo "0"),
  "system_load": $(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | tr -d ','),
  "memory_usage_mb": $(ps -o pid,rss,comm -p $$ | tail -1 | awk '{print $2/1024}')
}
EOF
)
    
    echo "$metrics" >> "$PERF_LOG"
}

# Generate performance report
generate_report() {
    local days="${1:-7}"
    
    if [[ ! -f "$PERF_LOG" ]]; then
        echo "No performance data available"
        return 1
    fi
    
    local since_date=$(date -d "$days days ago" -Iseconds 2>/dev/null || date -v-"${days}d" -Iseconds 2>/dev/null || echo "")
    
    echo "Performance Report (Last $days days)"
    echo "===================================="
    
    # Average duration by operation
    echo
    echo "Average Duration by Operation:"
    if command -v jq >/dev/null 2>&1; then
        jq -r --arg since "$since_date" '
            select(.timestamp >= $since) |
            "\(.operation) \(.duration_seconds)"
        ' "$PERF_LOG" | awk '
        {
            sum[$1] += $2
            count[$1]++
        }
        END {
            for (op in sum) {
                printf "  %-15s %.2fs\n", op ":", sum[op]/count[op]
            }
        }'
    fi
    
    # Cache hit rate
    echo
    echo "Cache Performance:"
    if command -v jq >/dev/null 2>&1; then
        local total_ops=$(jq -r --arg since "$since_date" 'select(.timestamp >= $since) | .operation' "$PERF_LOG" | wc -l)
        local cache_hits=$(jq -r --arg since "$since_date" 'select(.timestamp >= $since and .cache_hit == true) | .operation' "$PERF_LOG" | wc -l)
        
        if [[ $total_ops -gt 0 ]]; then
            local hit_rate=$(echo "scale=1; $cache_hits * 100 / $total_ops" | bc -l)
            echo "  Cache hit rate: ${hit_rate}%"
            echo "  Total operations: $total_ops"
            echo "  Cache hits: $cache_hits"
        fi
    fi
    
    # Performance trends
    echo
    echo "Performance Trends:"
    echo "  [Detailed trend analysis would require more complex processing]"
}

# Performance benchmarking
run_benchmark() {
    local test_files=$(find . -name "*.md" | head -100)  # Sample files
    local iterations=5
    
    echo "Running performance benchmark..."
    echo "Test files: $(echo "$test_files" | wc -l)"
    echo "Iterations: $iterations"
    echo
    
    for i in $(seq 1 $iterations); do
        local start_time=$(date +%s.%N)
        
        # Simulate validation work
        echo "$test_files" | while read -r file; do
            [[ -f "$file" ]] && head -10 "$file" >/dev/null
        done
        
        local end_time=$(date +%s.%N)
        local duration=$(echo "$end_time - $start_time" | bc -l)
        
        echo "Iteration $i: ${duration}s"
        record_metrics "benchmark" "$duration" "$(echo "$test_files" | wc -l)" "false"
    done
}

# Main execution
case "${1:-help}" in
    record)
        record_metrics "$2" "$3" "$4" "${5:-false}"
        ;;
    report)
        generate_report "${2:-7}"
        ;;
    benchmark)
        run_benchmark
        ;;
    *)
        echo "Usage: $0 {record|report|benchmark}"
        echo "  record <operation> <duration> <files> [cache_hit]"
        echo "  report [days]"
        echo "  benchmark"
        ;;
esac
EOF
    
    chmod +x "$REPO_ROOT/scripts/platform/perf-monitor.sh"
    log_success "Performance monitoring setup complete"
}

# Cross-platform optimizations
apply_platform_optimizations() {
    local platform=$(uname -s)
    
    log_info "Applying $platform-specific optimizations..."
    
    case "$platform" in
        Darwin)
            apply_macos_optimizations
            ;;
        Linux)
            apply_linux_optimizations
            ;;
        *)
            log_warning "Unknown platform: $platform, using generic optimizations"
            ;;
    esac
}

# macOS-specific optimizations
apply_macos_optimizations() {
    log_info "Applying macOS optimizations..."
    
    # Use fsevents for file watching
    update_config ".performance.platform_specific.macos.use_fsevents" "true"
    
    # Optimize for APFS
    update_config ".performance.platform_specific.macos.parallel_io" "true"
    
    # Create launch agent for background optimization (optional)
    local launch_agent_dir="$HOME/Library/LaunchAgents"
    local plist_file="$launch_agent_dir/com.claude.validation.optimizer.plist"
    
    if [[ ! -f "$plist_file" ]]; then
        mkdir -p "$launch_agent_dir"
        cat > "$plist_file" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.claude.validation.optimizer</string>
    <key>ProgramArguments</key>
    <array>
        <string>$REPO_ROOT/scripts/platform/performance-optimizer.sh</string>
        <string>background-optimize</string>
    </array>
    <key>StartInterval</key>
    <integer>3600</integer>
    <key>RunAtLoad</key>
    <false/>
</dict>
</plist>
EOF
        log_info "Created launch agent for background optimization"
    fi
    
    log_success "macOS optimizations applied"
}

# Linux-specific optimizations
apply_linux_optimizations() {
    log_info "Applying Linux optimizations..."
    
    # Use inotify for file watching
    update_config ".performance.platform_specific.linux.use_inotify" "true"
    
    # Set IO nice priority
    update_config ".performance.platform_specific.linux.io_nice" "true"
    
    # Check for available system optimizations
    if command -v ionice >/dev/null 2>&1; then
        log_info "ionice available for IO priority management"
    fi
    
    if command -v nice >/dev/null 2>&1; then
        log_info "nice available for CPU priority management"
    fi
    
    log_success "Linux optimizations applied"
}

# Background optimization runner
background_optimize() {
    log_info "Running background optimization..."
    
    # Clear old cache entries
    find "$CACHE_DIR" -type f -mtime +1 -delete 2>/dev/null || true
    
    # Compress old metrics
    find "$METRICS_DIR" -name "*.jsonl" -mtime +7 -exec gzip {} \; 2>/dev/null || true
    
    # Update repository analysis
    analyze_repository >/dev/null
    
    log_success "Background optimization complete"
}

# Performance testing suite
run_performance_tests() {
    log_info "Running performance test suite..."
    
    local test_results="$METRICS_DIR/performance-tests.json"
    local start_time=$(date +%s)
    
    # Test 1: File discovery performance
    log_info "Test 1: File discovery performance"
    local discovery_start=$(date +%s.%N)
    local file_count=$(find . -type f \( -name "*.md" -o -name "*.sh" \) | wc -l)
    local discovery_end=$(date +%s.%N)
    local discovery_duration=$(echo "$discovery_end - $discovery_start" | bc -l)
    
    # Test 2: YAML parsing performance
    log_info "Test 2: YAML parsing performance"
    local yaml_start=$(date +%s.%N)
    find .claude/agents -name "*.md" | head -10 | while read -r file; do
        head -20 "$file" | grep -E "^(name|description|tools):" >/dev/null || true
    done
    local yaml_end=$(date +%s.%N)
    local yaml_duration=$(echo "$yaml_end - $yaml_start" | bc -l)
    
    # Test 3: Cache performance
    log_info "Test 3: Cache performance"
    local cache_start=$(date +%s.%N)
    # Simulate cache operations
    for i in {1..100}; do
        echo "test-data-$i" > "$CACHE_DIR/test-$i.cache"
    done
    local cache_end=$(date +%s.%N)
    local cache_duration=$(echo "$cache_end - $cache_start" | bc -l)
    
    # Clean up test cache files
    rm -f "$CACHE_DIR"/test-*.cache
    
    local total_duration=$(($(date +%s) - start_time))
    
    # Store results
    cat > "$test_results" << EOF
{
  "timestamp": "$(date -Iseconds)",
  "tests": {
    "file_discovery": {
      "duration": $discovery_duration,
      "files_found": $file_count,
      "files_per_second": $(echo "scale=2; $file_count / $discovery_duration" | bc -l)
    },
    "yaml_parsing": {
      "duration": $yaml_duration,
      "files_processed": 10
    },
    "cache_operations": {
      "duration": $cache_duration,
      "operations": 100,
      "ops_per_second": $(echo "scale=2; 100 / $cache_duration" | bc -l)
    }
  },
  "total_duration": $total_duration,
  "system_info": {
    "platform": "$(uname -s)",
    "cpu_cores": $(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo "unknown"),
    "load_average": "$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | tr -d ',')",
    "available_memory": "$(free -m 2>/dev/null | awk '/^Mem:/{print $7}' || echo 'unknown')MB"
  }
}
EOF
    
    log_success "Performance tests completed in ${total_duration}s"
    log_info "Results saved to: $test_results"
}

# Main command dispatcher
main() {
    local command="${1:-analyze}"
    
    case "$command" in
        analyze)
            init_performance_config
            local category=$(analyze_repository)
            optimize_for_category "$category"
            apply_platform_optimizations
            ;;
        optimize)
            local category="${2:-$(analyze_repository)}"
            optimize_for_category "$category"
            ;;
        monitor)
            "$REPO_ROOT/scripts/platform/perf-monitor.sh" "${@:2}"
            ;;
        test)
            run_performance_tests
            ;;
        background-optimize)
            background_optimize
            ;;
        *)
            echo "Usage: $0 {analyze|optimize|monitor|test|background-optimize}"
            echo
            echo "Commands:"
            echo "  analyze                 Analyze repository and apply optimizations"
            echo "  optimize [category]     Apply optimizations for specific category"
            echo "  monitor [args]          Run performance monitoring"
            echo "  test                    Run performance test suite"
            echo "  background-optimize     Run background maintenance"
            exit 1
            ;;
    esac
}

# Execute main function
main "$@"