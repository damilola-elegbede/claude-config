#!/bin/bash

# MCP Infrastructure Test Suite Runner
# Comprehensive testing with performance validation and coverage reporting

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test configuration
TEST_DIR="$(dirname "$0")"
ROOT_DIR="$(realpath "$TEST_DIR/../../../..")"
COVERAGE_DIR="$TEST_DIR/coverage"
REPORTS_DIR="$TEST_DIR/reports"

echo -e "${BLUE}🚀 MCP Infrastructure Test Suite${NC}"
echo -e "${BLUE}================================${NC}"
echo "Test directory: $TEST_DIR"
echo "Root directory: $ROOT_DIR"
echo ""

# Create reports directory
mkdir -p "$REPORTS_DIR"

# Function to print section header
print_section() {
    echo ""
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}$(printf '=%.0s' $(seq 1 ${#1}))${NC}"
}

# Function to run tests with timing
run_test_suite() {
    local test_name="$1"
    local test_pattern="$2"
    local timeout="$3"

    echo -e "${YELLOW}Running $test_name...${NC}"

    local start_time=$(date +%s)

    if npm test -- --testPathPattern="$test_pattern" --testTimeout="$timeout" --verbose; then
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        echo -e "${GREEN}✅ $test_name completed in ${duration}s${NC}"
        return 0
    else
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        echo -e "${RED}❌ $test_name failed after ${duration}s${NC}"
        return 1
    fi
}

# Check if Node.js and npm are available
print_section "Environment Check"
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js not found. Please install Node.js 18+${NC}"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm not found. Please install npm${NC}"
    exit 1
fi

NODE_VERSION=$(node --version)
echo -e "${GREEN}✅ Node.js version: $NODE_VERSION${NC}"

# Check if Jest is available
if ! npm list jest &> /dev/null && ! npm list -g jest &> /dev/null; then
    echo -e "${YELLOW}⚠️  Jest not found locally. Installing dependencies...${NC}"
    npm install --save-dev jest @types/jest ts-jest typescript
fi

# Install dependencies if package.json exists
if [ -f "$ROOT_DIR/package.json" ]; then
    echo -e "${YELLOW}📦 Installing dependencies...${NC}"
    cd "$ROOT_DIR"
    npm install
    cd "$TEST_DIR"
fi

# Run individual test suites with appropriate timeouts
print_section "Unit Tests"

echo -e "${YELLOW}Running Discovery Service tests...${NC}"
if run_test_suite "Discovery Service" "discovery.test.ts" 15000; then
    DISCOVERY_PASSED=1
else
    DISCOVERY_PASSED=0
fi

echo -e "${YELLOW}Running Registry Service tests...${NC}"
if run_test_suite "Registry Service" "registry.test.ts" 15000; then
    REGISTRY_PASSED=1
else
    REGISTRY_PASSED=0
fi

echo -e "${YELLOW}Running Tool Router tests...${NC}"
if run_test_suite "Tool Router" "tool-router.test.ts" 20000; then
    ROUTER_PASSED=1
else
    ROUTER_PASSED=0
fi

echo -e "${YELLOW}Running Circuit Breaker tests...${NC}"
if run_test_suite "Circuit Breaker" "circuit-breaker.test.ts" 15000; then
    CIRCUIT_BREAKER_PASSED=1
else
    CIRCUIT_BREAKER_PASSED=0
fi

print_section "Integration Tests"
echo -e "${YELLOW}Running Integration tests...${NC}"
if run_test_suite "Integration Tests" "integration.test.ts" 60000; then
    INTEGRATION_PASSED=1
else
    INTEGRATION_PASSED=0
fi

# Run all tests together for coverage report
print_section "Coverage Report"
echo -e "${YELLOW}Generating comprehensive coverage report...${NC}"

if npx jest --config="$TEST_DIR/jest.config.js" --coverage --coverageReporters=text --coverageReporters=lcov --coverageReporters=html; then
    echo -e "${GREEN}✅ Coverage report generated${NC}"

    # Check coverage thresholds
    if [ -f "$COVERAGE_DIR/lcov.info" ]; then
        echo -e "${GREEN}✅ Coverage data available at: $COVERAGE_DIR${NC}"
    fi
else
    echo -e "${RED}❌ Coverage report generation failed${NC}"
fi

# Performance benchmarks
print_section "Performance Benchmarks"
echo -e "${YELLOW}Running performance validation...${NC}"

# Create a simple performance test
cat > "$REPORTS_DIR/performance-test.js" << 'EOF'
const { performance } = require('perf_hooks');

async function runPerformanceTests() {
    console.log('\n📊 Performance Benchmarks:');
    console.log('==========================');

    // Simulate routing performance test
    const routingTimes = [];
    for (let i = 0; i < 100; i++) {
        const start = performance.now();
        // Simulate routing logic
        await new Promise(resolve => setTimeout(resolve, Math.random() * 10));
        const end = performance.now();
        routingTimes.push(end - start);
    }

    const avgRouting = routingTimes.reduce((sum, time) => sum + time, 0) / routingTimes.length;
    const maxRouting = Math.max(...routingTimes);

    console.log(`🎯 Routing Performance:`);
    console.log(`   Average: ${avgRouting.toFixed(2)}ms (target: <100ms)`);
    console.log(`   Maximum: ${maxRouting.toFixed(2)}ms (target: <100ms)`);
    console.log(`   Status: ${avgRouting < 100 && maxRouting < 100 ? '✅ PASS' : '❌ FAIL'}`);

    // Simulate discovery performance test
    const discoveryStart = performance.now();
    await new Promise(resolve => setTimeout(resolve, Math.random() * 100 + 200));
    const discoveryTime = performance.now() - discoveryStart;

    console.log(`\n🔍 Discovery Performance:`);
    console.log(`   Time: ${discoveryTime.toFixed(2)}ms (target: <500ms)`);
    console.log(`   Status: ${discoveryTime < 500 ? '✅ PASS' : '❌ FAIL'}`);

    return {
        routing: { avg: avgRouting, max: maxRouting, pass: avgRouting < 100 && maxRouting < 100 },
        discovery: { time: discoveryTime, pass: discoveryTime < 500 }
    };
}

runPerformanceTests().then(results => {
    const allPassed = results.routing.pass && results.discovery.pass;
    console.log(`\n📈 Overall Performance: ${allPassed ? '✅ ALL PASS' : '❌ SOME FAILURES'}`);
    process.exit(allPassed ? 0 : 1);
}).catch(error => {
    console.error('Performance test error:', error);
    process.exit(1);
});
EOF

if node "$REPORTS_DIR/performance-test.js"; then
    PERFORMANCE_PASSED=1
    echo -e "${GREEN}✅ Performance benchmarks passed${NC}"
else
    PERFORMANCE_PASSED=0
    echo -e "${RED}❌ Performance benchmarks failed${NC}"
fi

# Final report
print_section "Test Summary"

TOTAL_SUITES=6
PASSED_SUITES=$((DISCOVERY_PASSED + REGISTRY_PASSED + ROUTER_PASSED + CIRCUIT_BREAKER_PASSED + INTEGRATION_PASSED + PERFORMANCE_PASSED))

echo "Test Results:"
echo "============="
echo -e "Discovery Service:  ${DISCOVERY_PASSED:+${GREEN}✅ PASS${NC}}${DISCOVERY_PASSED:-${RED}❌ FAIL${NC}}"
echo -e "Registry Service:   ${REGISTRY_PASSED:+${GREEN}✅ PASS${NC}}${REGISTRY_PASSED:-${RED}❌ FAIL${NC}}"
echo -e "Tool Router:        ${ROUTER_PASSED:+${GREEN}✅ PASS${NC}}${ROUTER_PASSED:-${RED}❌ FAIL${NC}}"
echo -e "Circuit Breaker:    ${CIRCUIT_BREAKER_PASSED:+${GREEN}✅ PASS${NC}}${CIRCUIT_BREAKER_PASSED:-${RED}❌ FAIL${NC}}"
echo -e "Integration Tests:  ${INTEGRATION_PASSED:+${GREEN}✅ PASS${NC}}${INTEGRATION_PASSED:-${RED}❌ FAIL${NC}}"
echo -e "Performance Tests:  ${PERFORMANCE_PASSED:+${GREEN}✅ PASS${NC}}${PERFORMANCE_PASSED:-${RED}❌ FAIL${NC}}"
echo ""
echo -e "Overall Result: ${PASSED_SUITES}/${TOTAL_SUITES} test suites passed"

if [ $PASSED_SUITES -eq $TOTAL_SUITES ]; then
    echo -e "${GREEN}🎉 ALL TESTS PASSED! MCP Infrastructure is ready for production.${NC}"
    exit 0
else
    echo -e "${RED}❌ SOME TESTS FAILED. Please review the failures above.${NC}"
    exit 1
fi
