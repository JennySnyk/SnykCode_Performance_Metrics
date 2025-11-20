#!/bin/bash

################################################################################
# Snyk Code Test Performance Metrics Script
# 
# This script measures:
# - Time taken for 'snyk code test' scan
# - Vulnerabilities found by severity
# 
# Usage: ./snyk_code_performance.sh [OPTIONS] [REPO_PATH]
#
# Options:
#   -j, --json          Output results in JSON format
#   -o, --output FILE   Save results to a file
#   -h, --help          Show this help message
#
# Requirements:
#   - Snyk CLI (install: npm install -g snyk)
#   - jq for JSON parsing (install: brew install jq) - optional
################################################################################

set -e

# Default values
REPO_PATH="${1:-.}"
OUTPUT_FILE=""
JSON_OUTPUT=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Function to show help
show_help() {
    cat << EOF
Snyk Code Test Performance Metrics Script

Usage: $0 [OPTIONS] [REPO_PATH]

Options:
    -j, --json          Output results in JSON format
    -o, --output FILE   Save results to a file
    -h, --help          Show this help message

Arguments:
    REPO_PATH           Path to the repository to scan (default: current directory)

Examples:
    $0                              # Scan current directory
    $0 /path/to/repo                # Scan specific directory
    $0 -j -o results.json           # Output JSON to file
    $0 --json /path/to/repo         # Scan specific directory with JSON output

Metrics Explained:
    - Scan Duration: Time taken by Snyk Code test (seconds and milliseconds)
    - Vulnerabilities: Issues found by severity (High, Medium, Low)
    
Requirements:
    - Snyk CLI: npm install -g snyk (or see docs.snyk.io for Windows)
    - jq: brew install jq (optional, for parsing vulnerability details)

EOF
    exit 0
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -j|--json)
            JSON_OUTPUT=true
            shift
            ;;
        -o|--output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            ;;
        -*)
            print_error "Unknown option: $1"
            show_help
            ;;
        *)
            REPO_PATH="$1"
            shift
            ;;
    esac
done

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Check prerequisites
print_info "Checking prerequisites..."

if ! command_exists snyk; then
    print_error "Snyk CLI is not installed. Install it with: npm install -g snyk"
    exit 1
fi

if ! command_exists jq; then
    print_warning "jq is not installed. Install it with: brew install jq"
    print_info "Will parse Snyk output without jq (limited vulnerability details)..."
fi

# Verify repository path
if [ ! -d "$REPO_PATH" ]; then
    print_error "Repository path does not exist: $REPO_PATH"
    exit 1
fi

cd "$REPO_PATH" || exit 1
print_info "Scanning repository: $(pwd)"

# Run Snyk Code test and measure time
print_info "Starting Snyk Code test..."
print_info "This may take a few minutes depending on repository size..."

START_TIME=$(date +%s)
START_TIME_MS=$(python3 -c "import time; print(int(time.time() * 1000))" 2>/dev/null || echo "${START_TIME}000")

# Run snyk code test and capture output
SNYK_OUTPUT_FILE=$(mktemp)
SNYK_EXIT_CODE=0

# Capture stdout (JSON) and redirect stderr separately to avoid polluting JSON output
snyk code test --json 2>/dev/null > "$SNYK_OUTPUT_FILE" || SNYK_EXIT_CODE=$?

END_TIME=$(date +%s)
END_TIME_MS=$(python3 -c "import time; print(int(time.time() * 1000))" 2>/dev/null || echo "${END_TIME}000")

# Calculate duration
DURATION=$((END_TIME - START_TIME))
DURATION_MS=$((END_TIME_MS - START_TIME_MS))

print_success "Snyk Code test completed in ${DURATION} seconds (${DURATION_MS}ms)"

# Try to extract additional metrics from Snyk output
ISSUES_FOUND=0
HIGH_ISSUES=0
MEDIUM_ISSUES=0
LOW_ISSUES=0

if [ -f "$SNYK_OUTPUT_FILE" ] && [ -s "$SNYK_OUTPUT_FILE" ]; then
    if command_exists jq; then
        # Parse Snyk SARIF JSON output - filter out any warning lines first
        ISSUES_FOUND=$(grep -v "^Warning" "$SNYK_OUTPUT_FILE" | jq '[.runs[]?.results[]?] | length' 2>/dev/null || echo "0")
        # Count by severity based on Snyk Code priority scores:
        # - High: error level with priorityScore >= 800
        # - Medium: error level with priorityScore < 800 OR warning level
        # - Low: note level
        HIGH_ISSUES=$(grep -v "^Warning" "$SNYK_OUTPUT_FILE" | jq '[.runs[]?.results[]? | select(.level == "error" and .properties.priorityScore >= 800)] | length' 2>/dev/null || echo "0")
        
        # Medium = errors with priority < 800 + all warnings
        MEDIUM_ERRORS=$(grep -v "^Warning" "$SNYK_OUTPUT_FILE" | jq '[.runs[]?.results[]? | select(.level == "error" and .properties.priorityScore < 800)] | length' 2>/dev/null || echo "0")
        MEDIUM_WARNINGS=$(grep -v "^Warning" "$SNYK_OUTPUT_FILE" | jq '[.runs[]?.results[]? | select(.level == "warning")] | length' 2>/dev/null || echo "0")
        MEDIUM_ISSUES=$((MEDIUM_ERRORS + MEDIUM_WARNINGS))
        
        LOW_ISSUES=$(grep -v "^Warning" "$SNYK_OUTPUT_FILE" | jq '[.runs[]?.results[]? | select(.level == "note")] | length' 2>/dev/null || echo "0")
    fi
fi

# Get current timestamp
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Prepare results
REPO_NAME=$(basename "$(pwd)")

if $JSON_OUTPUT; then
    # Output as JSON
    RESULT=$(cat <<EOF
{
  "timestamp": "$TIMESTAMP",
  "repository": {
    "name": "$REPO_NAME",
    "path": "$(pwd)"
  },
  "metrics": {
    "scan_duration_seconds": $DURATION,
    "scan_duration_milliseconds": $DURATION_MS
  },
  "snyk_results": {
    "exit_code": $SNYK_EXIT_CODE,
    "total_issues": $ISSUES_FOUND,
    "high_issues": $HIGH_ISSUES,
    "medium_issues": $MEDIUM_ISSUES,
    "low_issues": $LOW_ISSUES
  }
}
EOF
)
    
    if [ -n "$OUTPUT_FILE" ]; then
        echo "$RESULT" > "$OUTPUT_FILE"
        print_success "Results saved to: $OUTPUT_FILE"
    else
        echo "$RESULT"
    fi
else
    # Output as human-readable text
    cat << EOF

================================================================================
                    Snyk Code Test Performance Metrics
================================================================================

Timestamp:              $TIMESTAMP
Repository:             $REPO_NAME
Repository Path:        $(pwd)

Performance Metrics:
--------------------
Scan Duration:          ${DURATION} seconds (${DURATION_MS}ms)

Snyk Code Results:
------------------
Total Issues Found:     $ISSUES_FOUND
  High:                 $HIGH_ISSUES
  Medium:               $MEDIUM_ISSUES
  Low:                  $LOW_ISSUES

Exit Code:              $SNYK_EXIT_CODE

================================================================================
EOF

    if [ -n "$OUTPUT_FILE" ]; then
        cat << EOF > "$OUTPUT_FILE"
Snyk Code Test Performance Metrics
===================================
Timestamp: $TIMESTAMP
Repository: $REPO_NAME
Repository Path: $(pwd)

Performance Metrics:
- Scan Duration: ${DURATION} seconds (${DURATION_MS}ms)

Snyk Code Results:
- Total Issues: $ISSUES_FOUND
- High: $HIGH_ISSUES
- Medium: $MEDIUM_ISSUES
- Low: $LOW_ISSUES
- Exit Code: $SNYK_EXIT_CODE
EOF
        print_success "Results saved to: $OUTPUT_FILE"
    fi
fi

# Cleanup
rm -f "$SNYK_OUTPUT_FILE"

print_success "Performance metrics capture completed!"

