#!/bin/bash

# Claude Code CLI Installation Script for Ubuntu
# This script installs the Claude Code CLI tool

set -e  # Exit on any error

echo "=== Claude Code CLI Installation Script ==="
echo "Installing Claude Code CLI on Ubuntu..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root"
   exit 1
fi

# Update package list
print_status "Updating package list..."
sudo apt update

# Install required dependencies
print_status "Installing dependencies..."
sudo apt install -y curl wget gpg

# Check if Node.js and npm are installed
if ! command -v node &> /dev/null; then
    print_warning "Node.js not found. Installing Node.js..."
    
    # Install Node.js using NodeSource repository
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    print_status "Node.js is already installed: $(node --version)"
fi

if ! command -v npm &> /dev/null; then
    print_error "npm not found. Please install npm first."
    exit 1
else
    print_status "npm is available: $(npm --version)"
fi

# Install Claude Code CLI via npm
print_status "Installing Claude Code CLI..."
sudo npm install -g @anthropic-ai/claude-code

# Verify installation
if command -v claude-code &> /dev/null; then
    print_status "Claude Code CLI installed successfully!"
    print_status "Version: $(claude-code --version)"
    
    echo ""
    echo "=== Next Steps ==="
    echo "1. Set up your API key by running:"
    echo "   claude-code auth"
    echo ""
    echo "2. Or set the ANTHROPIC_API_KEY environment variable:"
    echo "   export ANTHROPIC_API_KEY=your_api_key_here"
    echo ""
    echo "3. Start using Claude Code CLI:"
    echo "   claude-code --help"
    echo ""
    
else
    print_error "Installation failed. Claude Code CLI not found in PATH."
    exit 1
fi

print_status "Installation completed successfully!"
