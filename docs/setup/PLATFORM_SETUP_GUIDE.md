# Platform-Specific Setup Guide

## Overview

This guide provides detailed, platform-specific installation and configuration instructions for the Claude Configuration Repository across macOS, Linux distributions, Windows, and various cloud platforms, ensuring optimal performance and compatibility for each environment.

## macOS Setup (Recommended Platform)

### System Requirements

**Minimum Requirements:**
- macOS 12.0 (Monterey) or later
- 8 GB RAM (16 GB recommended)
- 5 GB free disk space
- Intel x64 or Apple Silicon (M1/M2/M3)

**Optimal Configuration:**
- macOS 14.0 (Sonoma) or later
- 16 GB RAM or more
- SSD storage with 20 GB free space
- Apple Silicon for best performance

### 1. Development Tools Installation

**Xcode Command Line Tools:**

```bash
# Install Xcode Command Line Tools
xcode-select --install

# Verify installation
xcode-select -p
gcc --version
```

**Homebrew Package Manager:**

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH (Apple Silicon)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc

# Add Homebrew to PATH (Intel)
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc

# Verify installation
brew --version
```

### 2. Core Dependencies

**Install Required Packages:**

```bash
# Update Homebrew
brew update

# Install essential packages
brew install \
  git \
  node \
  python@3.11 \
  go \
  wget \
  curl \
  jq \
  yq \
  tree

# Install Claude Code CLI
npm install -g @anthropic/claude-code

# Install Python packages
pip3 install --upgrade pip
pip3 install pyyaml jsonschema requests watchdog

# Verify installations
node --version    # Should be v18+
python3 --version # Should be 3.11+
go version       # Should be 1.19+
claude-code --version
```

### 3. macOS-Specific Configuration

**Terminal Configuration:**

```bash
# Set default shell to Zsh (if not already)
chsh -s /bin/zsh

# Configure Terminal preferences
defaults write com.apple.Terminal "Default Window Settings" -string "Pro"
defaults write com.apple.Terminal "Startup Window Settings" -string "Pro"

# Enable text selection in QuickLook
defaults write com.apple.finder QLEnableTextSelection -bool true
```

**Audio Notifications Setup:**

```bash
# Verify audio system integrity
afplay /System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Bell.m4r

# List available system sounds
ls /System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/
ls /System/Library/Sounds/

# Test different notification sounds
afplay /System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Swish.m4r
afplay /System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/AlertTones/Classic/Note.m4r
afplay /System/Library/Sounds/Glass.aiff
```

**Security Configuration:**

```bash
# Allow Terminal full disk access (manually in System Preferences > Security & Privacy)
# Allow Terminal accessibility access for automation

# Configure Gatekeeper for development
sudo spctl --master-disable  # Only if necessary for development
```

### 4. Installation and Setup

**Clone and Configure Repository:**

```bash
# Navigate to preferred directory
cd ~/Documents/Projects

# Clone repository
git clone https://github.com/damilola-elegbede/claude-config.git
cd claude-config

# Set up environment variables
echo '# Claude Configuration Environment' >> ~/.zshrc
echo 'export CLAUDE_CONFIG_PATH="$HOME/Documents/Projects/claude-config"' >> ~/.zshrc
echo 'export CLAUDE_ENV="development"' >> ~/.zshrc
echo 'export PATH="$CLAUDE_CONFIG_PATH/scripts:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Initialize and sync configuration
claude-code
/sync

# Verify installation
/agent-audit
/test --quick
```

**Performance Optimization:**

```bash
# Optimize for Apple Silicon
if [[ $(uname -m) == "arm64" ]]; then
    echo 'export CLAUDE_ARCH="arm64"' >> ~/.zshrc
    echo 'export CLAUDE_MAX_PARALLEL_AGENTS=12' >> ~/.zshrc
else
    echo 'export CLAUDE_ARCH="x86_64"' >> ~/.zshrc
    echo 'export CLAUDE_MAX_PARALLEL_AGENTS=8' >> ~/.zshrc
fi

# Configure Node.js memory limits
echo 'export NODE_OPTIONS="--max-old-space-size=4096"' >> ~/.zshrc
source ~/.zshrc
```

### 5. macOS-Specific Features

**Spotlight Integration:**

```bash
# Add Claude config directory to Spotlight
mdutil -i on ~/Documents/Projects/claude-config
mdimport ~/Documents/Projects/claude-config

# Create alias for quick access
echo 'alias ccd="cd $CLAUDE_CONFIG_PATH"' >> ~/.zshrc
echo 'alias claude-config="cd $CLAUDE_CONFIG_PATH && claude-code"' >> ~/.zshrc
```

**Automator Workflows (Optional):**

```applescript
-- Create Automator Quick Action for /sync
-- Save as "Claude Sync.workflow"
on run {input, parameters}
    tell application "Terminal"
        activate
        do script "cd ~/Documents/Projects/claude-config && claude-code && /sync"
    end tell
    return input
end run
```

## Linux Setup

### Ubuntu/Debian Distribution

**System Requirements:**
- Ubuntu 20.04 LTS or later / Debian 11 or later
- 8 GB RAM (16 GB recommended)
- 5 GB free disk space
- x86_64 or ARM64 architecture

**1. System Preparation:**

```bash
# Update package lists
sudo apt update && sudo apt upgrade -y

# Install build essentials
sudo apt install -y \
  build-essential \
  software-properties-common \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  wget

# Install Git
sudo apt install -y git
git --version
```

**2. Node.js Installation:**

```bash
# Install Node.js LTS via NodeSource
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify installation
node --version
npm --version

# Install Claude Code CLI
sudo npm install -g @anthropic/claude-code

# Fix potential permission issues
sudo chown -R $(whoami) ~/.npm
sudo chown -R $(whoami) /usr/local/lib/node_modules
```

**3. Python Environment:**

```bash
# Install Python 3.11 and pip
sudo apt install -y \
  python3.11 \
  python3.11-pip \
  python3.11-venv \
  python3.11-dev

# Create symbolic links if needed
sudo ln -sf /usr/bin/python3.11 /usr/bin/python3
sudo ln -sf /usr/bin/pip3 /usr/bin/pip

# Install Python packages
pip3 install --upgrade pip
pip3 install pyyaml jsonschema requests watchdog

# Verify installation
python3 --version
pip3 --version
```

**4. Additional Tools:**

```bash
# Install Go
wget -c https://golang.org/dl/go1.21.0.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc

# Install jq and yq
sudo apt install -y jq
sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
sudo chmod a+x /usr/local/bin/yq

# Install Docker (optional but recommended)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
```

**5. Environment Configuration:**

```bash
# Configure shell environment
cat >> ~/.bashrc << 'EOF'
# Claude Configuration Environment
export CLAUDE_CONFIG_PATH="$HOME/Documents/Projects/claude-config"
export CLAUDE_ENV="development"
export PATH="$CLAUDE_CONFIG_PATH/scripts:$PATH"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin:/usr/local/go/bin"

# Claude development aliases
alias ccd="cd $CLAUDE_CONFIG_PATH"
alias claude-config="cd $CLAUDE_CONFIG_PATH && claude-code"
alias claude-env="cd $CLAUDE_CONFIG_PATH && source venv/bin/activate"
EOF

# Apply changes
source ~/.bashrc

# Create project directory
mkdir -p ~/Documents/Projects
cd ~/Documents/Projects

# Clone repository
git clone https://github.com/damilola-elegbede/claude-config.git
cd claude-config
```

**6. System Service (Optional):**

```bash
# Create systemd service for automatic sync
sudo tee /etc/systemd/system/claude-config-sync.service << 'EOF'
[Unit]
Description=Claude Configuration Sync Service
After=network.target

[Service]
Type=simple
User=YOUR_USERNAME
WorkingDirectory=/home/YOUR_USERNAME/Documents/Projects/claude-config
ExecStart=/usr/bin/python3 scripts/config-sync-daemon.py --start
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Replace YOUR_USERNAME with actual username
sudo sed -i "s/YOUR_USERNAME/$USER/g" /etc/systemd/system/claude-config-sync.service

# Enable and start service
sudo systemctl enable claude-config-sync
sudo systemctl start claude-config-sync
sudo systemctl status claude-config-sync
```

### CentOS/RHEL/Fedora Setup

**1. System Preparation:**

```bash
# CentOS/RHEL
sudo yum update -y
sudo yum groupinstall -y "Development Tools"
sudo yum install -y curl wget git

# Fedora
sudo dnf update -y
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y curl wget git
```

**2. Node.js Installation:**

```bash
# Install Node.js via NodeSource (CentOS/RHEL)
curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
sudo yum install -y nodejs

# Fedora
sudo dnf install -y nodejs npm

# Install Claude Code CLI
sudo npm install -g @anthropic/claude-code
```

**3. Python Environment:**

```bash
# CentOS/RHEL 8+
sudo yum install -y python3.11 python3.11-pip
sudo alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1

# Fedora
sudo dnf install -y python3 python3-pip python3-devel

# Install Python packages
pip3 install --user pyyaml jsonschema requests watchdog
```

## Windows Setup

### System Requirements

- Windows 10 version 1903 or later / Windows 11
- 8 GB RAM (16 GB recommended)
- 10 GB free disk space
- x64 processor

### 1. Windows Subsystem for Linux (Recommended)

**Enable WSL2:**

```powershell
# Run in PowerShell as Administrator
wsl --install
wsl --set-default-version 2

# Install Ubuntu distribution
wsl --install -d Ubuntu

# Restart computer when prompted
```

**Configure WSL2:**

```bash
# In WSL2 Ubuntu terminal
sudo apt update && sudo apt upgrade -y

# Follow Ubuntu setup instructions above
# All Linux commands work in WSL2 environment
```

**Windows-WSL Integration:**

```powershell
# Create PowerShell profile for easy access
New-Item -Path $PROFILE -Type File -Force
Add-Content -Path $PROFILE -Value @"
# Claude Configuration Functions
function Start-Claude {
    wsl -d Ubuntu -e bash -c "cd /home/$env:USER/Documents/Projects/claude-config && claude-code"
}

function Sync-Claude {
    wsl -d Ubuntu -e bash -c "cd /home/$env:USER/Documents/Projects/claude-config && ./scripts/sync-config.sh"
}

Set-Alias -Name claude -Value Start-Claude
Set-Alias -Name claude-sync -Value Sync-Claude
"@

# Reload profile
. $PROFILE
```

### 2. Native Windows Setup (Alternative)

**Install Package Manager:**

```powershell
# Install winget (if not available)
# Download from Microsoft Store or GitHub releases

# Install Chocolatey (alternative)
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

**Install Dependencies:**

```powershell
# Using winget
winget install Git.Git
winget install OpenJS.NodeJS
winget install Python.Python.3
winget install GoLang.Go

# Using Chocolatey
choco install git nodejs python go

# Install Claude Code CLI
npm install -g @anthropic/claude-code

# Install Python packages
pip install pyyaml jsonschema requests watchdog
```

**Environment Configuration:**

```powershell
# Set environment variables
[Environment]::SetEnvironmentVariable("CLAUDE_CONFIG_PATH", "$env:USERPROFILE\Documents\Projects\claude-config", "User")
[Environment]::SetEnvironmentVariable("CLAUDE_ENV", "development", "User")

# Add to PATH
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
[Environment]::SetEnvironmentVariable("PATH", "$currentPath;$env:USERPROFILE\Documents\Projects\claude-config\scripts", "User")

# Restart PowerShell to apply changes
```

**Clone and Setup:**

```powershell
# Navigate to Documents
Set-Location "$env:USERPROFILE\Documents"
New-Item -ItemType Directory -Name "Projects" -Force
Set-Location "Projects"

# Clone repository
git clone https://github.com/damilola-elegbede/claude-config.git
Set-Location claude-config

# Initial setup
claude-code
# Run /sync in Claude CLI
```

### 3. Windows-Specific Features

**Task Scheduler Integration:**

```powershell
# Create scheduled task for automatic sync
$action = New-ScheduledTaskAction -Execute "claude-code" -Argument "/sync"
$trigger = New-ScheduledTaskTrigger -Daily -At 6AM
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive

Register-ScheduledTask -TaskName "Claude Config Sync" -Action $action -Trigger $trigger -Settings $settings -Principal $principal
```

**Windows Terminal Configuration:**

```json
{
  "profiles": {
    "list": [
      {
        "name": "Claude Development",
        "commandline": "wsl -d Ubuntu",
        "startingDirectory": "//wsl$/Ubuntu/home/USERNAME/Documents/Projects/claude-config",
        "icon": "https://github.com/damilola-elegbede/claude-config/raw/main/assets/claude-icon.png"
      }
    ]
  }
}
```

## Cloud Platform Setup

### AWS Cloud9 / EC2 Setup

**1. Launch EC2 Instance:**

```bash
# Recommended instance types:
# - t3.medium (development)
# - t3.large (production)
# - c5.large (performance-focused)

# Connect to instance
ssh -i your-key.pem ubuntu@your-instance-ip
```

**2. Environment Setup:**

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install dependencies (follow Ubuntu setup above)
# ...

# Configure AWS CLI (if needed)
aws configure

# Set up CloudWatch logging (optional)
sudo apt install -y awslogs
sudo systemctl enable awslogs
sudo systemctl start awslogs
```

**3. AWS-Specific Configuration:**

```bash
# Configure CloudWatch agent for monitoring
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << 'EOF'
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/home/ubuntu/.claude/logs/*.log",
            "log_group_name": "claude-config-logs",
            "log_stream_name": "{instance_id}-claude-config"
          }
        ]
      }
    }
  }
}
EOF

# Start CloudWatch agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s
```

### Google Cloud Platform Setup

**1. Create VM Instance:**

```bash
# Create instance via gcloud CLI
gcloud compute instances create claude-config-vm \
  --image-family=ubuntu-2004-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=e2-medium \
  --zone=us-central1-a

# Connect to instance
gcloud compute ssh claude-config-vm
```

**2. GCP-Specific Setup:**

```bash
# Install Google Cloud SDK
curl https://sdk.cloud.google.com | bash
exec -l $SHELL

# Configure service account (if needed)
gcloud auth application-default login

# Set up Cloud Logging
sudo apt install -y google-fluentd
sudo systemctl enable google-fluentd
sudo systemctl start google-fluentd
```

### Azure Setup

**1. Create Virtual Machine:**

```bash
# Create VM via Azure CLI
az vm create \
  --resource-group myResourceGroup \
  --name claude-config-vm \
  --image UbuntuLTS \
  --size Standard_B2s \
  --admin-username azureuser \
  --generate-ssh-keys

# Connect to VM
az vm show --resource-group myResourceGroup --name claude-config-vm --show-details --query publicIps --output tsv
ssh azureuser@<public-ip>
```

**2. Azure-Specific Configuration:**

```bash
# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Configure Azure Monitor
# Follow Azure documentation for VM monitoring setup
```

## Container Platform Setup

### Docker Setup

**Dockerfile for Development:**

```dockerfile
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    nodejs \
    npm \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Claude Code CLI
RUN npm install -g @anthropic/claude-code

# Install Python packages
RUN pip3 install pyyaml jsonschema requests watchdog

# Create non-root user
RUN useradd -m -u 1000 claude
USER claude
WORKDIR /home/claude

# Clone repository
RUN git clone https://github.com/damilola-elegbede/claude-config.git
WORKDIR /home/claude/claude-config

# Setup environment
ENV CLAUDE_ENV=development
ENV PATH="/home/claude/claude-config/scripts:$PATH"

# Default command
CMD ["bash"]
```

**Build and Run:**

```bash
# Build image
docker build -t claude-config:dev .

# Run container
docker run -it --name claude-config-dev \
  -v $(pwd):/workspace \
  claude-config:dev

# Inside container
/sync
/agent-audit
```

### Kubernetes Setup

**Deployment Manifest:**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: claude-config
  namespace: development
spec:
  replicas: 1
  selector:
    matchLabels:
      app: claude-config
  template:
    metadata:
      labels:
        app: claude-config
    spec:
      containers:
      - name: claude-config
        image: claude-config:dev
        env:
        - name: CLAUDE_ENV
          value: "development"
        resources:
          requests:
            memory: "1Gi"
            cpu: "500m"
          limits:
            memory: "2Gi"
            cpu: "1"
        volumeMounts:
        - name: config-storage
          mountPath: /home/claude/.claude
      volumes:
      - name: config-storage
        persistentVolumeClaim:
          claimName: claude-config-pvc
```

## Performance Optimization by Platform

### macOS Optimizations

```bash
# Disable unnecessary visual effects
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock springboard-show-duration -float 0.1
defaults write com.apple.dock springboard-hide-duration -float 0.1

# Optimize Terminal performance
defaults write com.apple.Terminal SecureKeyboardEntry -bool false

# Configure for Apple Silicon
if [[ $(sysctl -n machdep.cpu.brand_string) =~ "Apple" ]]; then
    export CLAUDE_OPTIMIZE_FOR_SILICON=true
    export CLAUDE_MAX_PARALLEL_AGENTS=16
fi
```

### Linux Optimizations

```bash
# Increase file descriptor limits
echo "* soft nofile 65536" | sudo tee -a /etc/security/limits.conf
echo "* hard nofile 65536" | sudo tee -a /etc/security/limits.conf

# Optimize memory management
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf

# Apply changes
sudo sysctl -p
```

### Windows Optimizations

```powershell
# Optimize WSL2 memory usage
# Create .wslconfig in user directory
@"
[wsl2]
memory=8GB
processors=4
localhostForwarding=true
"@ | Out-File -FilePath "$env:USERPROFILE\.wslconfig" -Encoding UTF8

# Restart WSL
wsl --shutdown
```

## Troubleshooting Platform-Specific Issues

### macOS Issues

**Issue: Permission denied errors**

```bash
# Solution: Fix permissions
sudo chown -R $(whoami) ~/.claude
sudo chown -R $(whoami) /usr/local/lib/node_modules
```

**Issue: Audio notifications not working**

```bash
# Solution: Check audio permissions
ls -la /System/Library/PrivateFrameworks/ToneLibrary.framework/
# Grant Terminal microphone access in System Preferences if needed
```

### Linux Issues

**Issue: Node.js installation problems**

```bash
# Solution: Use different installation method
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc
nvm install --lts
nvm use --lts
```

**Issue: Python module import errors**

```bash
# Solution: Fix Python path
export PYTHONPATH="${PYTHONPATH}:/usr/local/lib/python3.11/site-packages"
pip3 install --user --upgrade pip setuptools
```

### Windows Issues

**Issue: WSL2 networking problems**

```powershell
# Solution: Reset WSL2 networking
wsl --shutdown
netsh winsock reset
netsh int ip reset all
netsh winhttp reset proxy
ipconfig /flushdns
```

**Issue: Path issues in PowerShell**

```powershell
# Solution: Refresh environment variables
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
```

## Platform-Specific Testing

### Automated Platform Tests

**test-platform.sh:**

```bash
#!/bin/bash
# Platform-specific testing script

PLATFORM=$(uname -s)
ARCH=$(uname -m)

echo "Testing Claude Config on $PLATFORM ($ARCH)"

# Platform-specific tests
case "$PLATFORM" in
    "Darwin")
        echo "Running macOS-specific tests..."
        # Test audio system
        afplay /System/Library/Sounds/Glass.aiff &>/dev/null && echo "✅ Audio system working"
        # Test Spotlight integration
        mdfind -name "claude-config" &>/dev/null && echo "✅ Spotlight integration working"
        ;;
    "Linux")
        echo "Running Linux-specific tests..."
        # Test systemd service
        systemctl --user is-enabled claude-config-sync &>/dev/null && echo "✅ Systemd service configured"
        # Test container runtime
        docker --version &>/dev/null && echo "✅ Docker available"
        ;;
    "MINGW"*|"MSYS"*)
        echo "Running Windows-specific tests..."
        # Test PowerShell integration
        powershell.exe -Command "Get-Command claude-config" &>/dev/null && echo "✅ PowerShell integration working"
        ;;
esac

# Common tests
echo "Running common tests..."
claude-code --version && echo "✅ Claude Code CLI installed"
python3 --version && echo "✅ Python available"
node --version && echo "✅ Node.js available"

# Configuration tests
cd "$CLAUDE_CONFIG_PATH" || exit 1
./scripts/validate-system.sh && echo "✅ System validation passed"
```

## Next Steps

After completing platform-specific setup:

1. **Configure Development Environment**: Follow [developer environment setup](DEVELOPER_ENVIRONMENT_SETUP.md)
2. **Set Up Container Infrastructure**: Configure [container deployment](CONTAINER_INFRASTRUCTURE.md)
3. **Implement CI/CD**: Set up [deployment pipelines](DEPLOYMENT_PIPELINES.md)
4. **Configure Monitoring**: Implement [monitoring and alerting](../monitoring/MONITORING_SETUP.md)

Your Claude Configuration Repository is now optimized for your specific platform with all necessary dependencies, configurations, and performance optimizations in place.