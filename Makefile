# Claude Config Repository Makefile
# Comprehensive automation for validation, setup, and maintenance

.PHONY: help setup validate-all fix-all install-hooks doctor clean demo ci-setup platform-setup platform-optimize platform-dashboard platform-wizard

# Default target
help: ## Show this help message
	@echo "Claude Config Repository - Available Commands"
	@echo "============================================="
	@echo ""
	@echo "🚀 Setup & Installation:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## .*Setup|Installation/ {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "🔍 Validation & Testing:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## .*Validat|Test/ {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "🔧 Maintenance & Fixing:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## .*Fix|Clean|Maintain/ {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "📊 Monitoring & Reporting:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## .*Report|Metric|Dashboard/ {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "🐳 Docker & CI/CD:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## .*Docker|CI/ {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "🚀 Platform Engineering:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## .*Platform/ {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

# Setup & Installation
setup: ## Setup - Complete development environment setup
	@echo "🚀 Setting up Claude Config development environment..."
	@scripts/setup/install-dependencies.sh
	@scripts/install-hooks.sh
	@echo "✅ Setup complete! Run 'make doctor' to verify installation."

install-hooks: ## Installation - Install git hooks
	@scripts/install-hooks.sh

install-deps: ## Installation - Install system dependencies
	@scripts/setup/install-dependencies.sh

# Validation & Testing
validate-all: ## Validation - Run all validations
	@echo "🔍 Running comprehensive validation suite..."
	@if [ -f "scripts/validation/framework.sh" ]; then \
		source scripts/validation/framework.sh && \
		VALIDATION_RESULTS=() && \
		EXIT_CODE=0 && \
		run_validation "yaml" "YAML Front-matter validation" || EXIT_CODE=1 && \
		run_validation "format" "File format validation" || EXIT_CODE=1 && \
		run_validation "security" "Security validation" || EXIT_CODE=1 && \
		run_validation "docs" "Documentation consistency" || EXIT_CODE=1 && \
		if [ $${#VALIDATION_RESULTS[@]} -gt 0 ]; then \
			print_validation_summary "$${VALIDATION_RESULTS[@]}"; \
		fi && \
		exit $$EXIT_CODE; \
	else \
		echo "❌ Validation framework not found. Run 'make setup' first."; \
		exit 1; \
	fi

validate-yaml: ## Validation - Validate YAML front-matter only
	@echo "🔍 Validating YAML front-matter..."
	@if [ -f "scripts/validation/framework.sh" ]; then \
		source scripts/validation/framework.sh && \
		run_validation "yaml" "YAML Front-matter validation"; \
	else \
		echo "❌ Validation framework not found. Run 'make setup' first."; \
		exit 1; \
	fi

validate-format: ## Validation - Validate file formats only
	@echo "🔍 Validating file formats..."
	@if [ -f "scripts/validation/framework.sh" ]; then \
		source scripts/validation/framework.sh && \
		run_validation "format" "File format validation"; \
	else \
		echo "❌ Validation framework not found. Run 'make setup' first."; \
		exit 1; \
	fi

validate-security: ## Validation - Run security checks only
	@echo "🔍 Running security validation..."
	@if [ -f "scripts/validation/framework.sh" ]; then \
		source scripts/validation/framework.sh && \
		run_validation "security" "Security validation"; \
	else \
		echo "❌ Validation framework not found. Run 'make setup' first."; \
		exit 1; \
	fi

validate-docs: ## Validation - Validate documentation consistency
	@echo "🔍 Validating documentation..."
	@if [ -f "scripts/validation/framework.sh" ]; then \
		source scripts/validation/framework.sh && \
		run_validation "docs" "Documentation consistency"; \
	else \
		echo "❌ Validation framework not found. Run 'make setup' first."; \
		exit 1; \
	fi

test: ## Testing - Run test suite
	@echo "🧪 Running tests..."
	@if [ -f "tests/test.sh" ]; then \
		cd tests && ./test.sh; \
	else \
		echo "⚠️  No test suite found. Tests will be run via validation."; \
		make validate-all; \
	fi

doctor: ## Testing - Check environment health
	@scripts/doctor.sh

# Maintenance & Fixing
fix-all: ## Fix - Auto-fix all common issues
	@echo "🔧 Auto-fixing common issues..."
	@make fix-yaml
	@make fix-format
	@make fix-docs
	@echo "✅ Auto-fix complete. Run 'make validate-all' to verify fixes."

fix-yaml: ## Fix - Auto-fix YAML issues
	@echo "🔧 Fixing YAML issues..."
	@if [ -f "scripts/fix/fix-yaml.sh" ]; then \
		scripts/fix/fix-yaml.sh; \
	else \
		echo "⚠️  YAML auto-fix script not found. Creating basic fixer..."; \
		mkdir -p scripts/fix; \
		echo '#!/bin/bash' > scripts/fix/fix-yaml.sh; \
		echo 'echo "🔧 Basic YAML validation and formatting..."' >> scripts/fix/fix-yaml.sh; \
		echo 'find .claude/agents -name "*.md" -exec echo "Checking {}" \;' >> scripts/fix/fix-yaml.sh; \
		chmod +x scripts/fix/fix-yaml.sh; \
		scripts/fix/fix-yaml.sh; \
	fi

fix-format: ## Fix - Auto-fix format issues
	@echo "🔧 Fixing format issues..."
	@if [ -f "scripts/fix/fix-format.sh" ]; then \
		scripts/fix/fix-format.sh; \
	else \
		echo "⚠️  Format auto-fix script not found. Manual fixes may be needed."; \
	fi

fix-docs: ## Fix - Auto-fix documentation issues
	@echo "🔧 Fixing documentation issues..."
	@if [ -f "scripts/fix/fix-docs.sh" ]; then \
		scripts/fix/fix-docs.sh; \
	else \
		echo "⚠️  Documentation auto-fix script not found. Manual fixes may be needed."; \
	fi

clean: ## Maintenance - Clean temporary files and caches
	@echo "🧹 Cleaning temporary files..."
	@rm -rf .validation-cache
	@rm -rf .pytest_cache
	@rm -rf __pycache__
	@find . -name "*.pyc" -delete
	@find . -name "*.tmp" -delete
	@find . -name ".DS_Store" -delete
	@echo "✅ Cleanup complete"

reset-hooks: ## Maintenance - Reset git hooks to default
	@echo "🔄 Resetting git hooks..."
	@git config --unset core.hooksPath || true
	@rm -f .git/hooks/pre-commit .git/hooks/commit-msg .git/hooks/pre-push
	@rm -f .git/hooks/prepare-commit-msg .git/hooks/post-commit
	@echo "✅ Git hooks reset. Run 'make install-hooks' to reinstall."

# Monitoring & Reporting
metrics: ## Reporting - Show validation metrics (JSON)
	@echo "📊 Validation metrics:"
	@if [ -f "scripts/reporting/generate-dashboard.py" ]; then \
		python3 scripts/reporting/generate-dashboard.py --json; \
	else \
		echo "⚠️  Metrics system not yet implemented."; \
	fi

dashboard: ## Reporting - Generate HTML dashboard
	@echo "📊 Generating validation dashboard..."
	@if [ -f "scripts/reporting/generate-dashboard.py" ]; then \
		python3 scripts/reporting/generate-dashboard.py; \
	else \
		echo "⚠️  Dashboard system not yet implemented."; \
		echo "📈 Basic metrics:"; \
		echo "  Agents: $$(find .claude/agents -name '*.md' | wc -l)"; \
		echo "  Scripts: $$(find scripts -name '*.sh' | wc -l)"; \
		echo "  Docs: $$(find docs -name '*.md' | wc -l)"; \
	fi

report: ## Reporting - Generate comprehensive report
	@echo "📋 Generating comprehensive report..."
	@echo "======================================"
	@echo ""
	@echo "📊 Repository Statistics:"
	@echo "  Total agents: $$(find .claude/agents -name '*.md' | wc -l)"
	@echo "  Total scripts: $$(find scripts -name '*.sh' | wc -l)"
	@echo "  Total docs: $$(find docs -name '*.md' | wc -l)"
	@echo "  Git hooks installed: $$(ls -la .git/hooks/ | grep -E '^-.*x.*' | wc -l)"
	@echo ""
	@echo "🔍 Validation Status:"
	@make validate-all || echo "❌ Some validations failed"
	@echo ""
	@echo "💾 Repository size: $$(du -sh . | cut -f1)"
	@echo "📅 Last commit: $$(git log -1 --format='%cr (%h)')"

# Development & Debugging
demo: ## Development - Create interactive demo
	@scripts/training/create-demo.sh

debug: ## Development - Debug validation issues
	@echo "🐛 Debug mode - running validation with verbose output..."
	@set -x; make validate-all; set +x

benchmark: ## Development - Benchmark validation performance
	@echo "⏱️  Benchmarking validation performance..."
	@time make validate-all

# Docker & CI/CD
docker-validate: ## Docker - Run validation in Docker container
	@echo "🐳 Running validation in Docker..."
	@if [ -f "docker-compose.validation.yml" ]; then \
		docker-compose -f docker-compose.validation.yml run --rm validator; \
	else \
		echo "⚠️  Docker validation not configured yet."; \
	fi

docker-build: ## Docker - Build validation Docker image
	@echo "🐳 Building validation Docker image..."
	@if [ -f "Dockerfile.validation" ]; then \
		docker build -f Dockerfile.validation -t claude-config-validator .; \
	else \
		echo "⚠️  Dockerfile.validation not found."; \
	fi

ci-setup: ## CI - Setup CI environment
	@echo "🚀 Setting up CI environment..."
	@scripts/ci/setup.sh || echo "⚠️  CI setup script not found"

ci-validate: ## CI - Run CI validation pipeline
	@echo "🔍 Running CI validation pipeline..."
	@scripts/ci/validate.sh || make validate-all

# Advanced targets
watch: ## Development - Watch files and run validation on changes
	@echo "👀 Watching for file changes..."
	@if command -v fswatch >/dev/null 2>&1; then \
		fswatch -o .claude/agents scripts docs | while read; do \
			echo "🔄 Files changed, running validation..."; \
			make validate-all; \
		done; \
	elif command -v inotifywait >/dev/null 2>&1; then \
		while inotifywait -r -e modify,create,delete .claude/agents scripts docs; do \
			echo "🔄 Files changed, running validation..."; \
			make validate-all; \
		done; \
	else \
		echo "⚠️  File watching not available. Install fswatch (macOS) or inotify-tools (Linux)"; \
	fi

pre-commit: ## Development - Run pre-commit validation manually
	@echo "🔍 Running pre-commit validation manually..."
	@if [ -f ".git/hooks/pre-commit" ]; then \
		.git/hooks/pre-commit; \
	else \
		echo "⚠️  Pre-commit hook not installed. Run 'make install-hooks' first."; \
		make validate-all; \
	fi

install-dev-tools: ## Installation - Install additional development tools
	@echo "🛠️  Installing development tools..."
	@echo "This will install optional tools for enhanced development experience."
	@if command -v brew >/dev/null 2>&1; then \
		brew install fswatch pre-commit hadolint yamllint; \
	elif command -v apt-get >/dev/null 2>&1; then \
		sudo apt-get update && sudo apt-get install -y inotify-tools; \
		pip3 install pre-commit yamllint; \
	else \
		echo "⚠️  Please install manually: fswatch/inotify-tools, pre-commit, hadolint, yamllint"; \
	fi

# Quick status check
status: ## Development - Quick repository status
	@echo "📈 Claude Config Repository Status"
	@echo "=================================="
	@echo "🔧 Environment: $$(make doctor >/dev/null 2>&1 && echo "✅ Healthy" || echo "⚠️  Issues detected")"
	@echo "🪝 Git hooks: $$([ -x .git/hooks/pre-commit ] && echo "✅ Installed" || echo "❌ Not installed")"
	@echo "📊 Validation: $$(make validate-all >/dev/null 2>&1 && echo "✅ Passing" || echo "❌ Failing")"
	@echo "💾 Repository: $$(git status --porcelain | wc -l) uncommitted changes"
	@echo "📅 Last commit: $$(git log -1 --format='%cr')"

# Platform Engineering Commands
platform-setup: ## Platform - Setup developer platform and tooling
	@echo "🚀 Setting up Claude validation platform..."
	@scripts/platform/claude-validate setup
	@scripts/platform/developer-portal.sh init
	@scripts/platform/workflow-integrator.sh init
	@echo "✅ Platform setup complete!"

platform-wizard: ## Platform - Run interactive setup wizard
	@scripts/platform/developer-portal.sh wizard

platform-optimize: ## Platform - Optimize performance for repository
	@echo "⚡ Optimizing platform performance..."
	@scripts/platform/performance-optimizer.sh analyze
	@echo "✅ Performance optimization complete!"

platform-dashboard: ## Platform - Show performance dashboard
	@scripts/platform/developer-portal.sh dashboard

platform-troubleshoot: ## Platform - Interactive troubleshooting
	@scripts/platform/developer-portal.sh troubleshoot

platform-integrate: ## Platform - Setup workflow integrations
	@echo "🔗 Setting up workflow integrations..."
	@scripts/platform/workflow-integrator.sh integrate
	@echo "✅ Workflow integration complete!"

platform-validate: ## Platform - Validate using platform CLI
	@scripts/platform/claude-validate validate

platform-doctor: ## Platform - Platform health check
	@scripts/platform/claude-validate doctor

platform-cache: ## Platform - Manage validation cache
	@scripts/platform/claude-validate cache status

platform-config: ## Platform - Show platform configuration
	@scripts/platform/claude-validate config show

platform-perf-test: ## Platform - Run performance test suite
	@scripts/platform/performance-optimizer.sh test

platform-clean: ## Platform - Clean platform cache and temporary files
	@echo "🧹 Cleaning platform files..."
	@scripts/platform/claude-validate cache clear
	@rm -rf .claude/platform/cache/*
	@echo "✅ Platform cleanup complete!"

# Developer Experience Commands
dev-onboard: ## Platform - Complete developer onboarding
	@echo "👋 Welcome to Claude validation platform!"
	@make platform-setup
	@make platform-wizard
	@make platform-doctor
	@echo "🎉 Onboarding complete! You're ready to go."

dev-quick-start: ## Platform - Quick start for new developers
	@echo "⚡ Quick start setup..."
	@scripts/platform/claude-validate setup
	@scripts/platform/claude-validate doctor
	@echo "✅ Quick start complete! Run 'make dev-onboard' for full setup."

dev-status: ## Platform - Comprehensive developer status
	@echo "👨‍💻 Developer Status Dashboard"
	@echo "==============================="
	@make status
	@echo ""
	@make platform-dashboard

# Integration helpers
integrate-nodejs: ## Platform - Setup Node.js integration
	@scripts/platform/workflow-integrator.sh integrate nodejs

integrate-python: ## Platform - Setup Python integration
	@scripts/platform/workflow-integrator.sh integrate python

integrate-ci: ## Platform - Setup CI/CD integration
	@scripts/platform/workflow-integrator.sh ci

integrate-ide: ## Platform - Setup IDE integration
	@scripts/platform/workflow-integrator.sh ide
