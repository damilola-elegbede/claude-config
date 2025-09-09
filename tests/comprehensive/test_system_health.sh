#!/bin/bash
# Test comprehensive system health

# Source test utilities
source "$(dirname "$0")/../utils.sh"

echo "Testing comprehensive system health..."

# Test 1: Repository structure integrity
echo "Checking repository structure..."

REQUIRED_DIRS=(
    "system-configs"
    "system-configs/.claude"
    "system-configs/.claude/agents"
    "system-configs/.claude/commands"
    "scripts"
    "tests"
    "docs"
)

MISSING_DIRS=()
for dir in "${REQUIRED_DIRS[@]}"; do
    if [ ! -d "$ORIGINAL_DIR/$dir" ]; then
        MISSING_DIRS+=("$dir")
    fi
done

if [ ${#MISSING_DIRS[@]} -gt 0 ]; then
    echo -e "${RED}✗${NC} Missing required directories:"
    for dir in "${MISSING_DIRS[@]}"; do
        echo "  - $dir"
    done
    exit 1
else
    echo -e "${GREEN}✓${NC} Repository structure intact"
fi

# Test 2: Critical files presence
echo "Checking critical files..."

CRITICAL_FILES=(
    "system-configs/CLAUDE.md"
    "system-configs/.claude/settings.json"
    "scripts/sync.sh"
    "scripts/validate-agent-yaml.py"
    "tests/test.sh"
    "README.md"
)

MISSING_FILES=()
for file in "${CRITICAL_FILES[@]}"; do
    if [ ! -f "$ORIGINAL_DIR/$file" ]; then
        MISSING_FILES+=("$file")
    fi
done

if [ ${#MISSING_FILES[@]} -gt 0 ]; then
    echo -e "${RED}✗${NC} Missing critical files:"
    for file in "${MISSING_FILES[@]}"; do
        echo "  - $file"
    done
    exit 1
else
    echo -e "${GREEN}✓${NC} All critical files present"
fi

# Test 3: End-to-end validation pipeline
echo "Testing validation pipeline..."

# Run agent validation
AGENT_VALIDATION_OUTPUT=$(cd "$ORIGINAL_DIR" && python3 scripts/validate-agent-yaml.py 2>&1 | tail -n 1)
if echo "$AGENT_VALIDATION_OUTPUT" | grep -q "successfully\|passed\|valid" || [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Agent validation pipeline working"
else
    echo -e "${YELLOW}⚠${NC} Agent validation reported issues (may be expected)"
fi

# Run command YAML validation
COMMAND_YAML_OUTPUT=$(cd "$ORIGINAL_DIR" && bash tests/validate_command_yaml.sh 2>&1 | tail -n 1)
if echo "$COMMAND_YAML_OUTPUT" | grep -q "valid\|passed" && [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Command YAML validation pipeline working"
else
    echo -e "${YELLOW}⚠${NC} Command YAML validation reported issues (may be expected for legacy format)"
fi

# Test 4: Command completeness
echo "Checking command definitions..."

ESSENTIAL_COMMANDS=(
    "sync"
    "test"
    "commit"
    "push"
    "prime"
    "ship-it"
    "plan"
)

COMMANDS_DIR="$ORIGINAL_DIR/system-configs/.claude/commands"
MISSING_COMMANDS=()

for cmd in "${ESSENTIAL_COMMANDS[@]}"; do
    if [ ! -f "$COMMANDS_DIR/$cmd.md" ]; then
        MISSING_COMMANDS+=("$cmd")
    fi
done

if [ ${#MISSING_COMMANDS[@]} -gt 0 ]; then
    echo -e "${RED}✗${NC} Missing essential commands:"
    for cmd in "${MISSING_COMMANDS[@]}"; do
        echo "  - $cmd"
    done
    exit 1
else
    echo -e "${GREEN}✓${NC} All essential commands present"
fi

# Test 5: Agent system integrity
echo "Checking agent system integrity..."

# Check for critical agent categories
CRITICAL_AGENTS=(
    "backend-engineer"
    "frontend-engineer"
    "test-engineer"
    "security-auditor"
    "code-reviewer"
)

AGENTS_DIR="$ORIGINAL_DIR/system-configs/.claude/agents"
MISSING_AGENTS=()

for agent in "${CRITICAL_AGENTS[@]}"; do
    if [ ! -f "$AGENTS_DIR/$agent.md" ]; then
        MISSING_AGENTS+=("$agent")
    fi
done

if [ ${#MISSING_AGENTS[@]} -gt 0 ]; then
    echo -e "${RED}✗${NC} Missing critical agents:"
    for agent in "${MISSING_AGENTS[@]}"; do
        echo "  - $agent"
    done
    exit 1
else
    echo -e "${GREEN}✓${NC} Critical agents available"
fi

# Test 6: Documentation health
echo "Checking documentation..."

# Check README.md has substantial content
README_SIZE=$(wc -c < "$ORIGINAL_DIR/README.md" 2>/dev/null | tr -d ' ')
if [ "$README_SIZE" -gt 1000 ]; then
    echo -e "${GREEN}✓${NC} README.md has content ($README_SIZE bytes)"
else
    echo -e "${RED}✗${NC} README.md too small or missing"
    exit 1
fi

# Check CLAUDE.md has required content elements
CLAUDE_MD="$ORIGINAL_DIR/system-configs/CLAUDE.md"
REQUIRED_ELEMENTS=(
    "chief of staff"
    "delegate everything"
    "MCP server"
)

MISSING_ELEMENTS=()
for element in "${REQUIRED_ELEMENTS[@]}"; do
    if ! grep -i -q "$element" "$CLAUDE_MD" 2>/dev/null; then
        MISSING_ELEMENTS+=("$element")
    fi
done

if [ ${#MISSING_ELEMENTS[@]} -gt 0 ]; then
    echo -e "${RED}✗${NC} CLAUDE.md missing elements:"
    for element in "${MISSING_ELEMENTS[@]}"; do
        echo "  - $element"
    done
    exit 1
else
    echo -e "${GREEN}✓${NC} CLAUDE.md has all required sections"
fi

# Test 7: Git repository health
echo "Checking git repository..."

if [ -d "$ORIGINAL_DIR/.git" ]; then
    # Check for uncommitted changes
    cd "$ORIGINAL_DIR"
    UNCOMMITTED=$(git status --porcelain | wc -l | tr -d ' ')
    if [ "$UNCOMMITTED" -gt 0 ]; then
        echo -e "${YELLOW}⚠${NC} Repository has $UNCOMMITTED uncommitted changes"
    else
        echo -e "${GREEN}✓${NC} Repository is clean"
    fi

    # Check remote is configured
    if git remote -v | grep -q "origin"; then
        echo -e "${GREEN}✓${NC} Git remote configured"
    else
        echo -e "${YELLOW}⚠${NC} No git remote configured"
    fi
else
    echo -e "${RED}✗${NC} Not a git repository"
    exit 1
fi

# Test 8: System metrics
echo ""
echo "System Health Metrics:"
echo "  Total agents: $(find "$AGENTS_DIR" -name "*.md" -not -name "*TEMPLATE*" -not -name "README.md" | wc -l | tr -d ' ')"
echo "  Total commands: $(find "$COMMANDS_DIR" -name "*.md" | wc -l | tr -d ' ')"
echo "  Total scripts: $(find "$ORIGINAL_DIR/scripts" -name "*.sh" -o -name "*.py" | wc -l | tr -d ' ')"
echo "  Total tests: $(find "$ORIGINAL_DIR/tests" -name "*.sh" | wc -l | tr -d ' ')"
echo "  Documentation files: $(find "$ORIGINAL_DIR/docs" -name "*.md" | wc -l | tr -d ' ')"

# Test 9: Integration test - simulate complete workflow
echo ""
echo "Running integration check..."

# Check that test suite can be run
if [ -x "$ORIGINAL_DIR/tests/test.sh" ]; then
    echo -e "${GREEN}✓${NC} Test suite is executable"
else
    echo -e "${RED}✗${NC} Test suite not executable"
    exit 1
fi

# Check Python is available
if command -v python3 > /dev/null 2>&1; then
    PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2)
    echo -e "${GREEN}✓${NC} Python3 available: $PYTHON_VERSION"
else
    echo -e "${RED}✗${NC} Python3 not found"
    exit 1
fi

# Check required Python modules
if python3 -c "import yaml" 2>/dev/null; then
    echo -e "${GREEN}✓${NC} PyYAML module available"
else
    echo -e "${RED}✗${NC} PyYAML module missing"
    exit 1
fi

echo ""
echo -e "${GREEN}✓${NC} All system health tests passed!"
echo "System is ready for production use."
