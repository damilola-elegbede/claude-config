#!/bin/bash
# Claude Platform Engineering Demo
# Showcases the self-service developer platform capabilities
set -euo pipefail

REPO_ROOT=$(git rev-parse --show-toplevel)
SCRIPT_DIR="$REPO_ROOT/scripts/platform"

# Colors
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# Demo functions
show_header() {
    clear
    echo -e "${CYAN}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                 Claude Validation Platform                   ║
║              Platform Engineering Demo                       ║
╚══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo
}

demo_developer_cli() {
    echo -e "${BLUE}🚀 Developer CLI Demo${NC}"
    echo "======================"
    echo
    
    echo "The claude-validate CLI provides a comprehensive interface for developers:"
    echo
    
    echo -e "${GREEN}$ claude-validate help${NC}"
    "$SCRIPT_DIR/claude-validate" help | head -20
    echo
    
    echo "Press Enter to continue..."
    read -r
    
    echo -e "${GREEN}$ claude-validate doctor${NC}"
    "$SCRIPT_DIR/claude-validate" doctor
    echo
    
    echo "Press Enter to continue..."
    read -r
}

demo_performance_optimization() {
    echo -e "${BLUE}⚡ Performance Optimization Demo${NC}"
    echo "================================="
    echo
    
    echo "Automatic performance optimization based on repository characteristics:"
    echo
    
    echo -e "${GREEN}$ performance-optimizer.sh analyze${NC}"
    "$SCRIPT_DIR/performance-optimizer.sh" analyze
    echo
    
    echo "Press Enter to continue..."
    read -r
}

demo_developer_portal() {
    echo -e "${BLUE}🏠 Developer Portal Demo${NC}"
    echo "========================="
    echo
    
    echo "Self-service developer portal with interactive tools:"
    echo
    
    echo -e "${GREEN}$ developer-portal.sh dashboard${NC}"
    "$SCRIPT_DIR/developer-portal.sh" dashboard
    echo
    
    echo "Press Enter to continue..."
    read -r
    
    echo "Available portal features:"
    echo "  • Interactive setup wizard"
    echo "  • Troubleshooting assistance"
    echo "  • Performance monitoring"
    echo "  • Integration templates"
    echo
    
    echo "Press Enter to continue..."
    read -r
}

demo_workflow_integration() {
    echo -e "${BLUE}🔗 Workflow Integration Demo${NC}"
    echo "============================="
    echo
    
    echo "Seamless integration with development workflows:"
    echo
    
    echo "Git Integration:"
    echo "  ✅ Pre-commit hooks with performance optimization"
    echo "  ✅ Commit message validation and enhancement"
    echo "  ✅ Pre-push comprehensive validation"
    echo
    
    echo "CI/CD Integration:"
    echo "  ✅ GitHub Actions workflows"
    echo "  ✅ GitLab CI pipelines"
    echo "  ✅ Jenkins integration"
    echo
    
    echo "IDE Integration:"
    echo "  ✅ VS Code tasks and launch configs"
    echo "  ✅ Vim/Neovim commands and mappings"
    echo "  ✅ Emacs interactive functions"
    echo
    
    echo "Platform Integration:"
    echo "  ✅ Node.js/npm scripts"
    echo "  ✅ Python validation wrapper"
    echo "  ✅ Go integration"
    echo "  ✅ Rust/Cargo integration"
    echo
    
    echo "Press Enter to continue..."
    read -r
}

demo_make_targets() {
    echo -e "${BLUE}🛠️  Make Targets Demo${NC}"
    echo "===================="
    echo
    
    echo "New platform engineering Make targets:"
    echo
    
    echo -e "${GREEN}Platform Commands:${NC}"
    echo "  make platform-setup          # Setup developer platform"
    echo "  make platform-wizard         # Interactive setup wizard"
    echo "  make platform-optimize       # Performance optimization"
    echo "  make platform-dashboard      # Performance dashboard"
    echo "  make platform-troubleshoot   # Interactive troubleshooting"
    echo
    
    echo -e "${GREEN}Developer Experience:${NC}"
    echo "  make dev-onboard             # Complete developer onboarding"
    echo "  make dev-quick-start         # Quick start for new developers"
    echo "  make dev-status              # Comprehensive status"
    echo
    
    echo -e "${GREEN}Integration Helpers:${NC}"
    echo "  make integrate-nodejs        # Node.js integration"
    echo "  make integrate-python        # Python integration"
    echo "  make integrate-ci            # CI/CD integration"
    echo "  make integrate-ide           # IDE integration"
    echo
    
    echo "Press Enter to continue..."
    read -r
}

demo_self_service_features() {
    echo -e "${BLUE}🎯 Self-Service Features Demo${NC}"
    echo "=============================="
    echo
    
    echo "Platform features that enable developer self-service:"
    echo
    
    echo -e "${GREEN}1. Auto-Configuration:${NC}"
    echo "   • Repository size detection and optimization"
    echo "   • Platform-specific settings (macOS/Linux)"
    echo "   • Project type detection and integration"
    echo
    
    echo -e "${GREEN}2. Interactive Tools:${NC}"
    echo "   • Setup wizard with guided configuration"
    echo "   • Troubleshooting with automated diagnosis"
    echo "   • Performance dashboard with recommendations"
    echo
    
    echo -e "${GREEN}3. Intelligent Caching:${NC}"
    echo "   • File-level caching with TTL"
    echo "   • Dependency-aware invalidation"
    echo "   • Performance monitoring and optimization"
    echo
    
    echo -e "${GREEN}4. Comprehensive Monitoring:${NC}"
    echo "   • Real-time performance metrics"
    echo "   • Health diagnostics"
    echo "   • Automated issue detection"
    echo
    
    echo "Press Enter to continue..."
    read -r
}

demo_quick_start() {
    echo -e "${BLUE}🚀 Quick Start Demo${NC}"
    echo "==================="
    echo
    
    echo "How a new developer would get started:"
    echo
    
    echo -e "${GREEN}Step 1: Quick Start${NC}"
    echo "$ make dev-quick-start"
    echo "  → Sets up basic environment"
    echo "  → Runs health checks"
    echo "  → Provides next steps"
    echo
    
    echo -e "${GREEN}Step 2: Full Onboarding (Optional)${NC}"
    echo "$ make dev-onboard"
    echo "  → Interactive setup wizard"
    echo "  → Platform optimization"
    echo "  → Integration setup"
    echo
    
    echo -e "${GREEN}Step 3: Daily Usage${NC}"
    echo "$ claude-validate validate    # Run validation"
    echo "$ make platform-dashboard     # Check performance"
    echo "$ git commit                  # Hooks run automatically"
    echo
    
    echo -e "${GREEN}Step 4: Troubleshooting${NC}"
    echo "$ make platform-troubleshoot  # Interactive help"
    echo "$ claude-validate doctor      # Health check"
    echo "$ claude-validate fix --auto  # Auto-fix issues"
    echo
    
    echo "Press Enter to continue..."
    read -r
}

show_summary() {
    echo -e "${CYAN}📋 Platform Engineering Summary${NC}"
    echo "==============================="
    echo
    
    echo -e "${GREEN}✅ Completed Deliverables:${NC}"
    echo
    echo "1. 🛠️  Developer CLI Tool (claude-validate)"
    echo "   • Comprehensive command-line interface"
    echo "   • Interactive configuration and diagnostics"
    echo "   • Performance monitoring and caching"
    echo
    
    echo "2. ⚡ Performance Optimization System"
    echo "   • Automatic repository analysis and optimization"
    echo "   • Cross-platform optimizations (macOS/Linux)"
    echo "   • Intelligent caching and parallel processing"
    echo
    
    echo "3. 🏠 Self-Service Developer Portal"
    echo "   • Interactive setup wizard"
    echo "   • Troubleshooting assistance"
    echo "   • Performance dashboard and metrics"
    echo
    
    echo "4. 🔗 Workflow Integration System"
    echo "   • Git hooks with performance optimization"
    echo "   • CI/CD pipeline templates and integration"
    echo "   • IDE integration for all major editors"
    echo "   • Platform-specific integrations (Node.js, Python, etc.)"
    echo
    
    echo "5. 🎯 Self-Service Capabilities"
    echo "   • Automated environment setup"
    echo "   • Interactive troubleshooting"
    echo "   • Performance optimization recommendations"
    echo "   • Comprehensive documentation and guidance"
    echo
    
    echo "6. 📊 Enhanced Make Targets"
    echo "   • 20+ new platform engineering commands"
    echo "   • Developer onboarding workflows"
    echo "   • Integration helpers for common platforms"
    echo
    
    echo -e "${YELLOW}🚀 Ready for Developer Adoption:${NC}"
    echo "   • Self-service onboarding: make dev-onboard"
    echo "   • Quick start: make dev-quick-start"
    echo "   • Interactive help: make platform-troubleshoot"
    echo "   • Performance optimization: make platform-optimize"
    echo
}

# Main demo flow
main() {
    show_header
    
    echo "Welcome to the Claude Validation Platform Engineering Demo!"
    echo
    echo "This demo showcases the comprehensive platform engineering solution"
    echo "that makes validation tooling self-service and developer-friendly."
    echo
    echo "Press Enter to start the demo..."
    read -r
    
    show_header
    demo_developer_cli
    
    show_header
    demo_performance_optimization
    
    show_header
    demo_developer_portal
    
    show_header
    demo_workflow_integration
    
    show_header
    demo_make_targets
    
    show_header
    demo_self_service_features
    
    show_header
    demo_quick_start
    
    show_header
    show_summary
    
    echo
    echo -e "${GREEN}Thank you for exploring the Claude Validation Platform!${NC}"
    echo
    echo "To get started, run:"
    echo "  make dev-quick-start    # Quick setup"
    echo "  make dev-onboard        # Full onboarding"
    echo "  make help               # See all available commands"
    echo
}

# Run demo
main "$@"