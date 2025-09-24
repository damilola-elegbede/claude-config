#!/bin/bash
# CI Resource Monitor - Tracks resource usage during Ubuntu 24.04.3 LTS builds
# Helps identify memory leaks, process accumulation, and disk space issues

set -euo pipefail

# Configuration
readonly MONITOR_INTERVAL=${MONITOR_INTERVAL:-5}  # seconds
readonly LOG_FILE="${TMPDIR:-/tmp}/ci-resource-monitor.log"
readonly ALERT_MEMORY_THRESHOLD=${ALERT_MEMORY_THRESHOLD:-80}  # percentage
readonly ALERT_DISK_THRESHOLD=${ALERT_DISK_THRESHOLD:-85}  # percentage
readonly ALERT_PROCESS_THRESHOLD=${ALERT_PROCESS_THRESHOLD:-100}  # count

# Colors (disabled in CI)
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

# Global tracking variables
declare -g MONITOR_PID=""
declare -g START_TIME=""
declare -g MAX_MEMORY_MB=0
declare -g MAX_PROCESSES=0
declare -g MAX_FILE_DESCRIPTORS=0
declare -g ALERT_COUNT=0

# Initialize monitoring
init_monitor() {
    START_TIME=$(date +%s)
    echo "$(date '+%Y-%m-%d %H:%M:%S') - CI Resource Monitor Started" > "$LOG_FILE"

    # Log initial system state
    log_system_info
    echo -e "${BLUE}INFO${NC}: Resource monitoring initialized (interval: ${MONITOR_INTERVAL}s)"
}

# Log system information
log_system_info() {
    {
        echo "=== System Information ==="
        echo "Date: $(date)"
        echo "Hostname: $(hostname 2>/dev/null || echo 'unknown')"
        echo "OS: $(uname -sr 2>/dev/null || echo 'unknown')"
        echo "CPU Cores: $(nproc 2>/dev/null || echo 'unknown')"

        if [ -f /proc/meminfo ]; then
            local total_mem=$(awk '/MemTotal:/ {print int($2/1024)}' /proc/meminfo)
            echo "Total Memory: ${total_mem}MB"
        fi

        if [ -f /etc/os-release ]; then
            echo "Distribution: $(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)"
        fi

        echo "=========================="
    } >> "$LOG_FILE"
}

# Get memory usage in MB
get_memory_usage() {
    if [ -f /proc/meminfo ]; then
        awk '/MemTotal:/{total=$2} /MemAvailable:/{avail=$2} END {used=total-avail; print int(used/1024), int(total/1024), int((used*100)/total)}' /proc/meminfo
    else
        echo "0 0 0"
    fi
}

# Get disk usage percentage for given path
get_disk_usage() {
    local path=${1:-"/tmp"}
    if command -v df >/dev/null 2>&1; then
        df "$path" 2>/dev/null | awk 'NR==2 {gsub("%","",$5); print $5}' || echo "0"
    else
        echo "0"
    fi
}

# Get process count
get_process_count() {
    if [ -d /proc ]; then
        find /proc -maxdepth 1 -name '[0-9]*' -type d 2>/dev/null | wc -l
    else
        ps aux 2>/dev/null | wc -l || echo "0"
    fi
}

# Get file descriptor usage
get_file_descriptor_usage() {
    if [ -f /proc/sys/fs/file-nr ]; then
        awk '{print $1, $3, int(($1*100)/$3)}' /proc/sys/fs/file-nr 2>/dev/null || echo "0 0 0"
    else
        echo "0 0 0"
    fi
}

# Get test-specific processes
get_test_processes() {
    local test_process_count=0
    local patterns=("verify-test" "mock-agent" "scoring-calc" "git.*test" "python.*test" "bash.*test")

    for pattern in "${patterns[@]}"; do
        local count=$(pgrep -f "$pattern" 2>/dev/null | wc -l)
        test_process_count=$((test_process_count + count))
    done

    echo "$test_process_count"
}

# Log resource snapshot
log_resources() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local elapsed=$(($(date +%s) - START_TIME))

    # Get current metrics
    local memory_info
    memory_info=($(get_memory_usage))
    local memory_used=${memory_info[0]:-0}
    local memory_total=${memory_info[1]:-0}
    local memory_percent=${memory_info[2]:-0}

    local disk_percent
    disk_percent=$(get_disk_usage "/tmp")

    local process_count
    process_count=$(get_process_count)

    local fd_info
    fd_info=($(get_file_descriptor_usage))
    local fd_used=${fd_info[0]:-0}
    local fd_total=${fd_info[1]:-0}
    local fd_percent=${fd_info[2]:-0}

    local test_processes
    test_processes=$(get_test_processes)

    # Update maximums
    if [ "$memory_used" -gt "$MAX_MEMORY_MB" ]; then
        MAX_MEMORY_MB=$memory_used
    fi

    if [ "$process_count" -gt "$MAX_PROCESSES" ]; then
        MAX_PROCESSES=$process_count
    fi

    if [ "$fd_used" -gt "$MAX_FILE_DESCRIPTORS" ]; then
        MAX_FILE_DESCRIPTORS=$fd_used
    fi

    # Log to file
    echo "$timestamp,${elapsed}s,${memory_used}MB,${memory_percent}%,${disk_percent}%,${process_count},${test_processes},${fd_used},${fd_percent}%" >> "$LOG_FILE"

    # Check for alerts
    check_alerts "$memory_percent" "$disk_percent" "$process_count" "$fd_percent"

    # Print status (only in verbose mode or if alerts)
    if [[ "${VERBOSE:-}" == "true" ]] || [[ $((elapsed % 30)) -eq 0 ]]; then
        printf "%s - Mem: %dMB (%d%%), Disk: %d%%, Processes: %d (%d test), FD: %d (%d%%)\n" \
               "$timestamp" "$memory_used" "$memory_percent" "$disk_percent" \
               "$process_count" "$test_processes" "$fd_used" "$fd_percent"
    fi
}

# Check for resource alerts
check_alerts() {
    local memory_percent=$1
    local disk_percent=$2
    local process_count=$3
    local fd_percent=$4

    # Memory alert
    if [[ "$memory_percent" =~ ^[0-9]+$ ]] && [ "$memory_percent" -gt "$ALERT_MEMORY_THRESHOLD" ]; then
        echo -e "${YELLOW}ALERT${NC}: High memory usage: ${memory_percent}% (threshold: ${ALERT_MEMORY_THRESHOLD}%)"
        ((ALERT_COUNT++))
    fi

    # Disk alert
    if [[ "$disk_percent" =~ ^[0-9]+$ ]] && [ "$disk_percent" -gt "$ALERT_DISK_THRESHOLD" ]; then
        echo -e "${YELLOW}ALERT${NC}: High disk usage in /tmp: ${disk_percent}% (threshold: ${ALERT_DISK_THRESHOLD}%)"
        ((ALERT_COUNT++))
    fi

    # Process count alert
    if [[ "$process_count" =~ ^[0-9]+$ ]] && [ "$process_count" -gt "$ALERT_PROCESS_THRESHOLD" ]; then
        echo -e "${YELLOW}ALERT${NC}: High process count: ${process_count} (threshold: ${ALERT_PROCESS_THRESHOLD})"
        ((ALERT_COUNT++))
    fi

    # File descriptor alert
    if [[ "$fd_percent" =~ ^[0-9]+$ ]] && [ "$fd_percent" -gt 70 ]; then
        echo -e "${YELLOW}ALERT${NC}: High file descriptor usage: ${fd_percent}%"
        ((ALERT_COUNT++))
    fi
}

# Monitor in background
monitor_resources() {
    while [ -f "/tmp/ci-monitoring-active" ]; do
        log_resources
        sleep "$MONITOR_INTERVAL"
    done
}

# Start monitoring
start_monitoring() {
    init_monitor

    # Create monitoring marker
    touch "/tmp/ci-monitoring-active"

    # Start background monitoring
    monitor_resources &
    MONITOR_PID=$!

    echo -e "${GREEN}INFO${NC}: Resource monitoring started (PID: $MONITOR_PID)"

    # Set trap for cleanup
    trap 'stop_monitoring' EXIT INT TERM
}

# Stop monitoring
stop_monitoring() {
    if [ -n "$MONITOR_PID" ] && kill -0 "$MONITOR_PID" 2>/dev/null; then
        echo -e "${BLUE}INFO${NC}: Stopping resource monitoring (PID: $MONITOR_PID)..."

        # Remove monitoring marker
        rm -f "/tmp/ci-monitoring-active"

        # Wait for monitor to finish
        sleep 2

        # Kill monitor if still running
        if kill -0 "$MONITOR_PID" 2>/dev/null; then
            kill -TERM "$MONITOR_PID" 2>/dev/null || true
            sleep 1
            kill -KILL "$MONITOR_PID" 2>/dev/null || true
        fi

        # Generate final report
        generate_report

        MONITOR_PID=""
    fi
}

# Generate monitoring report
generate_report() {
    local end_time=$(date +%s)
    local total_duration=$((end_time - START_TIME))

    echo
    echo "=== CI Resource Monitoring Report ==="
    echo "Duration: ${total_duration}s ($(date -d@$total_duration -u +%H:%M:%S))"
    echo "Peak Memory: ${MAX_MEMORY_MB}MB"
    echo "Peak Processes: $MAX_PROCESSES"
    echo "Peak File Descriptors: $MAX_FILE_DESCRIPTORS"
    echo "Total Alerts: $ALERT_COUNT"
    echo

    # Show resource trend
    if [ -f "$LOG_FILE" ]; then
        echo "Resource Trend (last 10 samples):"
        echo "Time,Memory(MB),Memory(%),Disk(%),Processes,Test Processes,File Descriptors"
        tail -n 10 "$LOG_FILE" | grep -v "===" | tail -n 10
        echo
    fi

    # Performance assessment
    if [ $ALERT_COUNT -eq 0 ]; then
        echo -e "${GREEN}Assessment: Excellent${NC} - No resource alerts detected"
    elif [ $ALERT_COUNT -le 3 ]; then
        echo -e "${YELLOW}Assessment: Good${NC} - Minor resource pressure ($ALERT_COUNT alerts)"
    else
        echo -e "${RED}Assessment: Concerning${NC} - Significant resource pressure ($ALERT_COUNT alerts)"
    fi

    echo "Log file: $LOG_FILE"
    echo "====================================="
}

# Show current status
show_status() {
    if [ -n "$MONITOR_PID" ] && kill -0 "$MONITOR_PID" 2>/dev/null; then
        echo -e "${GREEN}Status: Monitoring active${NC} (PID: $MONITOR_PID)"
        log_resources
    else
        echo -e "${RED}Status: Monitoring inactive${NC}"
    fi
}

# Main execution logic
case "${1:-start}" in
    "start")
        start_monitoring
        ;;
    "stop")
        stop_monitoring
        ;;
    "status")
        show_status
        ;;
    "report")
        if [ -f "$LOG_FILE" ]; then
            generate_report
        else
            echo "No monitoring log found at: $LOG_FILE"
        fi
        ;;
    *)
        echo "Usage: $0 {start|stop|status|report}"
        echo
        echo "Commands:"
        echo "  start   - Start resource monitoring in background"
        echo "  stop    - Stop monitoring and generate report"
        echo "  status  - Show current monitoring status"
        echo "  report  - Generate report from existing log"
        echo
        echo "Environment Variables:"
        echo "  MONITOR_INTERVAL - Monitoring interval in seconds (default: 5)"
        echo "  ALERT_MEMORY_THRESHOLD - Memory alert threshold % (default: 80)"
        echo "  ALERT_DISK_THRESHOLD - Disk alert threshold % (default: 85)"
        echo "  ALERT_PROCESS_THRESHOLD - Process count alert (default: 100)"
        echo "  VERBOSE - Show detailed output (default: false)"
        exit 1
        ;;
esac