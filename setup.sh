#!/bin/bash

################################################################################
# Setup Script for Snyk Code Performance Metrics
# 
# This script helps install the prerequisites needed for the performance
# metrics script.
################################################################################

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

command_exists() {
    command -v "$1" &> /dev/null
}

echo "=================================="
echo "  Setup Prerequisites"
echo "=================================="
echo ""

# Check Node.js and npm
print_info "Checking Node.js and npm..."
if ! command_exists node || ! command_exists npm; then
    print_error "Node.js and npm are required but not installed."
    echo "Please install Node.js from: https://nodejs.org/"
    exit 1
else
    NODE_VERSION=$(node --version)
    NPM_VERSION=$(npm --version)
    print_success "Node.js $NODE_VERSION and npm $NPM_VERSION found"
fi

# Check/Install Snyk CLI
print_info "Checking Snyk CLI..."
if ! command_exists snyk; then
    print_warning "Snyk CLI not found. Installing..."
    npm install -g snyk
    
    if command_exists snyk; then
        print_success "Snyk CLI installed successfully"
    else
        print_error "Failed to install Snyk CLI"
        exit 1
    fi
else
    SNYK_VERSION=$(snyk --version)
    print_success "Snyk CLI $SNYK_VERSION found"
fi

# Authenticate Snyk
print_info "Checking Snyk authentication..."
if snyk auth --help &> /dev/null; then
    print_warning "Please authenticate with Snyk if you haven't already:"
    echo "    snyk auth"
fi

# Check Homebrew (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    print_info "Checking Homebrew..."
    if ! command_exists brew; then
        print_warning "Homebrew not found. Install it from: https://brew.sh/"
        print_info "You can still use the script, but cloc won't be installed automatically"
    else
        BREW_VERSION=$(brew --version | head -1)
        print_success "Homebrew found"
        
        # Install cloc
        print_info "Checking cloc..."
        if ! command_exists cloc; then
            print_warning "cloc not found. Installing via Homebrew..."
            brew install cloc
            
            if command_exists cloc; then
                print_success "cloc installed successfully"
            else
                print_warning "Failed to install cloc. The script will use fallback counting."
            fi
        else
            CLOC_VERSION=$(cloc --version | head -1)
            print_success "cloc found: $CLOC_VERSION"
        fi
        
        # Install jq
        print_info "Checking jq..."
        if ! command_exists jq; then
            print_warning "jq not found. Installing via Homebrew..."
            brew install jq
            
            if command_exists jq; then
                print_success "jq installed successfully"
            else
                print_warning "Failed to install jq. The script will parse JSON manually."
            fi
        else
            JQ_VERSION=$(jq --version)
            print_success "jq found: $JQ_VERSION"
        fi
    fi
else
    print_warning "Not running on macOS. Please install cloc and jq manually:"
    echo "  - cloc: https://github.com/AlDanial/cloc"
    echo "  - jq: https://stedolan.github.io/jq/"
fi

# Make the main script executable
print_info "Making snyk_code_performance.sh executable..."
chmod +x snyk_code_performance.sh
print_success "Script is now executable"

echo ""
echo "=================================="
echo "  Setup Summary"
echo "=================================="
echo ""

ALL_GOOD=true

if command_exists snyk; then
    echo "✅ Snyk CLI: Installed"
else
    echo "❌ Snyk CLI: Not installed"
    ALL_GOOD=false
fi

if command_exists cloc; then
    echo "✅ cloc: Installed"
else
    echo "⚠️  cloc: Not installed (optional, but recommended)"
fi

if command_exists jq; then
    echo "✅ jq: Installed"
else
    echo "⚠️  jq: Not installed (optional, but recommended)"
fi

echo ""

if $ALL_GOOD; then
    print_success "All required prerequisites are installed!"
    echo ""
    echo "Next steps:"
    echo "  1. Authenticate with Snyk: snyk auth"
    echo "  2. Run the script: ./snyk_code_performance.sh"
    echo ""
    echo "For more information, see README.md"
else
    print_error "Some required prerequisites are missing. Please install them and run this script again."
    exit 1
fi

