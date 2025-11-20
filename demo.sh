#!/bin/bash

################################################################################
# Demo Script for Snyk Code Performance Metrics
# 
# This script demonstrates the functionality without running an actual Snyk scan
# Useful for testing the output format and understanding the metrics
################################################################################

cat << 'EOF'

🎯 Snyk Code Performance Metrics - Demo
==========================================

This demo shows what the performance metrics script outputs.

SCENARIO: Scanning a medium-sized Node.js application

EOF

echo "[INFO] Checking prerequisites..."
sleep 1
echo "[INFO] Scanning repository: /home/user/projects/sample-app"
sleep 1
echo "[INFO] Counting lines of code..."
sleep 1
echo "[SUCCESS] Lines of code: 8,450"
echo "[SUCCESS] Files counted: 127"
sleep 1
echo "[INFO] Starting Snyk Code test..."
echo "[INFO] This may take a few minutes depending on repository size..."
sleep 2
echo "[SUCCESS] Snyk Code test completed in 23 seconds (23456ms)"
sleep 1

cat << 'EOF'

================================================================================
                    Snyk Code Test Performance Metrics
================================================================================

Timestamp:              2025-11-20T15:45:30Z
Repository:             sample-app
Repository Path:        /home/user/projects/sample-app

Performance Metrics:
--------------------
Scan Duration:          23 seconds (23456ms)
Lines of Code:          8,450
Files Scanned:          127
Performance Ratio:      367.39 LOC/second

Snyk Code Results:
------------------
Total Issues Found:     6
  High:                 2
  Medium:               3
  Low:                  1

Exit Code:              1

================================================================================

[SUCCESS] Performance metrics capture completed!

EOF

echo ""
echo "📊 JSON Output Example:"
echo "======================"
echo ""

cat << 'EOF'
{
  "timestamp": "2025-11-20T15:45:30Z",
  "repository": {
    "name": "sample-app",
    "path": "/home/user/projects/sample-app"
  },
  "metrics": {
    "scan_duration_seconds": 23,
    "scan_duration_milliseconds": 23456,
    "lines_of_code": 8450,
    "files_scanned": 127
  },
  "snyk_results": {
    "exit_code": 1,
    "total_issues": 6,
    "high_issues": 2,
    "medium_issues": 3,
    "low_issues": 1
  }
}
EOF

echo ""
echo ""
echo "✨ Key Insights from this scan:"
echo "   • Performance: 367 lines of code analyzed per second"
echo "   • Total scan time: 23 seconds for 8,450 lines"
echo "   • Found 6 security issues (2 high, 3 medium, 1 low)"
echo ""
echo "💡 Next Steps:"
echo "   1. Run actual scan: ./snyk_code_performance.sh"
echo "   2. Review the README.md for more options"
echo "   3. Check EXAMPLES.md for advanced usage"
echo ""

