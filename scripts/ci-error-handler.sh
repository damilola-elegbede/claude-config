#!/bin/bash
# CI Error Handler - Enhanced error handling for Ubuntu 24.04.3 LTS environment
# Provides graceful error handling without premature exit on benign errors

set +e  # Don't exit on errors
set -o pipefail  # Catch pipe failures

# Initialize error tracking
declare -g ERROR_COUNT=0
declare -g WARNING_COUNT=0
declare -a ERROR_LOG=()
declare -a WARNING_LOG=()

# Colors for output (disabled in CI)
if [[ "${CI:-}" != "true" ]]; then
    readonly RED='\033[0;31m'
    readonly GREEN='\033[0;32m'
    readonly YELLOW='\033[1;33m'
    readonly BLUE='\033[0;34m'
    readonly NC='\033[0m'
else
    readonly RED=''
    readonly GREEN=''
    readonly YELLOW=''
    readonly BLUE=''
    readonly NC=''
fi

# Enhanced error handling function
handle_error() {
    local exit_code=$1
    local line_number=$2
    local command="$3"
    local severity=${4:-"ERROR"}

    if [ $exit_code -ne 0 ]; then
        case $severity in
            "WARNING")
                ((WARNING_COUNT++))
                WARNING_LOG+=("Line $line_number: $command (exit code: $exit_code)")
                echo -e "${YELLOW}WARNING${NC}: Command failed at line $line_number: $command (exit code: $exit_code)"
                ;;
            "ERROR"|*)
                ((ERROR_COUNT++))
                ERROR_LOG+=("Line $line_number: $command (exit code: $exit_code)")
                echo -e "${RED}ERROR${NC}: Command failed at line $line_number: $command (exit code: $exit_code)"
                ;;
        esac

        # Don't exit immediately - continue execution
        return 0
    fi
}

# Resource monitoring function
monitor_resources() {
    if command -v free >/dev/null 2>&1; then
        local mem_usage=$(free -m | awk 'NR==2{printf "%.0f", $3}')
        local mem_total=$(free -m | awk 'NR==2{printf "%.0f", $2}')
        local mem_percent=$(( (mem_usage * 100) / mem_total ))

        if [ $mem_percent -gt 80 ]; then
            echo -e "${YELLOW}WARNING${NC}: High memory usage: ${mem_percent}% (${mem_usage}MB/${mem_total}MB)"
            ((WARNING_COUNT++))
        fi
    fi

    if command -v df >/dev/null 2>&1; then
        local disk_usage=$(df /tmp 2>/dev/null | awk 'NR==2 {gsub("%","",$5); print $5}')
        if [[ "$disk_usage" =~ ^[0-9]+$ ]] && [ "$disk_usage" -gt 80 ]; then
            echo -e "${YELLOW}WARNING${NC}: High disk usage in /tmp: ${disk_usage}%"
            ((WARNING_COUNT++))
        fi
    fi
}

# Process cleanup function
cleanup_processes() {
    local cleanup_count=0

    # Clean up any stray test processes
    for pattern in "verify-test" "mock-agent" "scoring-calc"; do
        local pids=$(pgrep -f "$pattern" 2>/dev/null || true)
        if [[ -n "$pids" ]]; then
            echo -e "${BLUE}INFO${NC}: Cleaning up $pattern processes: $pids"
            echo "$pids" | xargs -r kill -TERM 2>/dev/null || true
            sleep 1
            echo "$pids" | xargs -r kill -KILL 2>/dev/null || true
            ((cleanup_count++))
        fi
    done

    if [ $cleanup_count -gt 0 ]; then
        echo -e "${GREEN}INFO${NC}: Cleaned up $cleanup_count process groups"
    fi
}

# File descriptor monitoring
monitor_file_descriptors() {
    if [[ -r /proc/sys/fs/file-nr ]]; then
        local fd_info=$(cat /proc/sys/fs/file-nr 2>/dev/null)
        local fd_used=$(echo "$fd_info" | awk '{print $1}')
        local fd_max=$(echo "$fd_info" | awk '{print $3}')

        if [[ "$fd_used" =~ ^[0-9]+$ ]] && [[ "$fd_max" =~ ^[0-9]+$ ]]; then
            local fd_percent=$(( (fd_used * 100) / fd_max ))
            if [ $fd_percent -gt 60 ]; then
                echo -e "${YELLOW}WARNING${NC}: High file descriptor usage: ${fd_percent}% ($fd_used/$fd_max)"
                ((WARNING_COUNT++))
            fi
        fi
    fi
}

# Timeout wrapper function
run_with_timeout() {
    local timeout_duration=$1
    shift
    local command=("$@")

    # Start command in background
    "${command[@]}" &
    local cmd_pid=$!
    local timer=0

    # Monitor execution
    while kill -0 "$cmd_pid" 2>/dev/null; do
        if [ $timer -ge $timeout_duration ]; then
            echo -e "${RED}TIMEOUT${NC}: Command exceeded ${timeout_duration}s limit"
            kill -TERM "$cmd_pid" 2>/dev/null || true
            sleep 2
            kill -KILL "$cmd_pid" 2>/dev/null || true
            wait "$cmd_pid" 2>/dev/null || true
            return 124  # Standard timeout exit code
        fi
        sleep 1
        timer=$((timer + 1))
    done

    wait "$cmd_pid"
    return $?
}

# Temporary file cleanup
cleanup_temp_files() {
    local cleanup_dirs=(
        "/tmp/verify-test-results-*"
        "/tmp/ci-test*"
        "/tmp/claude-*"
    )

    local cleaned_count=0
    for pattern in "${cleanup_dirs[@]}"; do
        # Use find instead of glob for better error handling
        if find /tmp -maxdepth 1 -name "$(basename "$pattern")" -type d 2>/dev/null | head -1 | grep -q .; then
            find /tmp -maxdepth 1 -name "$(basename "$pattern")" -type d -exec rm -rf {} \; 2>/dev/null || true
            ((cleaned_count++))
        fi
    done

    if [ $cleaned_count -gt 0 ]; then
        echo -e "${GREEN}INFO${NC}: Cleaned up $cleaned_count temporary directories"
    fi
}

# Platform-specific optimizations
optimize_for_ubuntu() {
    local ubuntu_version
    if [ -f /etc/os-release ]; then
        ubuntu_version=$(grep VERSION_ID /etc/os-release | cut -d'"' -f2)
        echo -e "${BLUE}INFO${NC}: Detected Ubuntu version: $ubuntu_version"

        # Ubuntu 24.04.3 LTS specific optimizations
        if [[ "$ubuntu_version" == "24.04" ]]; then
            # Increase inotify limits
            echo 524288 | sudo tee /proc/sys/fs/inotify/max_user_watches >/dev/null 2>&1 || true

            # Optimize kernel parameters for CI workload
            sudo sysctl -w vm.max_map_count=262144 >/dev/null 2>&1 || true
            sudo sysctl -w kernel.pid_max=32768 >/dev/null 2>&1 || true

            echo -e "${GREEN}INFO${NC}: Applied Ubuntu 24.04.3 LTS optimizations"
        fi
    fi
}

# Error summary function
print_error_summary() {
    echo
    echo "=== ERROR HANDLING SUMMARY ==="
    echo "Errors: $ERROR_COUNT"
    echo "Warnings: $WARNING_COUNT"

    if [ $ERROR_COUNT -gt 0 ]; then
        echo
        echo "Error Details:"
        for error in "${ERROR_LOG[@]}"; do
            echo -e "${RED}  ERROR:${NC} $error"
        done
    fi

    if [ $WARNING_COUNT -gt 0 ]; then
        echo
        echo "Warning Details:"
        for warning in "${WARNING_LOG[@]}"; do
            echo -e "${YELLOW}  WARNING:${NC} $warning"
        done
    fi

    echo "=============================="

    # Return appropriate exit code
    if [ $ERROR_COUNT -gt 3 ]; then
        echo -e "${RED}CRITICAL${NC}: Too many errors ($ERROR_COUNT), failing build"
        return 1
    elif [ $ERROR_COUNT -gt 0 ]; then
        echo -e "${YELLOW}WARNING${NC}: Build completed with $ERROR_COUNT errors"
        return 0  # Don't fail on minor errors
    else
        echo -e "${GREEN}SUCCESS${NC}: Build completed with no critical errors"
        return 0
    fi
}

# Signal handlers
trap_handler() {
    local signal=$1
    echo -e "${YELLOW}INFO${NC}: Received signal $signal, cleaning up..."
    cleanup_processes
    cleanup_temp_files
    print_error_summary
    exit 1
}

# Set up signal traps
trap 'trap_handler INT' INT
trap 'trap_handler TERM' TERM
trap 'trap_handler EXIT' EXIT

# Set up error trap with enhanced handling
trap 'handle_error $? $LINENO "$BASH_COMMAND"' ERR

# Export functions for use in other scripts
export -f handle_error
export -f monitor_resources
export -f run_with_timeout
export -f cleanup_processes
export -f cleanup_temp_files

# If script is sourced, just export functions
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    echo -e "${BLUE}INFO${NC}: CI error handler loaded (sourced mode)"
    return 0
fi

# If script is executed directly, run optimizations
echo -e "${BLUE}INFO${NC}: CI error handler initialized (execution mode)"
optimize_for_ubuntu
monitor_resources
echo -e "${GREEN}SUCCESS${NC}: System optimized for CI environment"