# Snyk Code Performance Metrics

A simple bash script to measure Snyk Code scan performance and capture key metrics.

## 🎯 What It Does

This script captures:
- ⏱️ **Scan Duration** - Time taken for Snyk Code test (seconds and milliseconds)
- 📊 **Lines of Code** - Total code lines in your repository
- 📁 **Files Scanned** - Number of source files analyzed
- 🐛 **Vulnerabilities Found** - Issues by severity (High, Medium, Low)
- 📈 **Performance Ratio** - Lines of code processed per second

## 📋 Prerequisites

### Required

**Snyk CLI** - Must be installed and authenticated

Install Snyk CLI:
```bash
npm install -g snyk
```

Authenticate with Snyk:
```bash
snyk auth
```

> 📖 **Full installation guide**: https://docs.snyk.io/snyk-cli/install-or-update-the-snyk-cli

### Recommended (for accurate line counting)

**cloc** - Count Lines of Code tool
```bash
# macOS
brew install cloc

# Linux (Debian/Ubuntu)
sudo apt-get install cloc

# Linux (RHEL/CentOS)
sudo yum install cloc
```

**jq** - JSON processor (for parsing Snyk results)
```bash
# macOS
brew install jq

# Linux (Debian/Ubuntu)
sudo apt-get install jq
```

> **Note**: The script works without cloc and jq, but uses fallback methods with reduced accuracy.

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/JennySnyk/SnykCode_Performance_Metrics.git
cd SnykCode_Performance_Metrics
```

### 2. Run Setup (Optional)
```bash
./setup.sh
```
This will check and install prerequisites automatically.

### 3. Run the Script
```bash
# Scan current directory
./snyk_code_performance.sh

# Scan specific directory
./snyk_code_performance.sh /path/to/your/repo
```

## 💻 Usage

### Basic Commands

```bash
# Scan current directory
./snyk_code_performance.sh

# Scan specific repository
./snyk_code_performance.sh /path/to/repo

# Get JSON output
./snyk_code_performance.sh --json

# Save results to file
./snyk_code_performance.sh -o results.txt

# JSON output to file
./snyk_code_performance.sh --json --output metrics.json /path/to/repo

# View help
./snyk_code_performance.sh --help
```

### Command Options

| Option | Description |
|--------|-------------|
| `-h, --help` | Show help message |
| `-j, --json` | Output results in JSON format |
| `-o, --output FILE` | Save results to a file |

## 📊 Output Examples

### Human-Readable Output

```
================================================================================
                    Snyk Code Test Performance Metrics
================================================================================

Timestamp:              2025-11-20T15:30:45Z
Repository:             my-project
Repository Path:        /Users/jenny/projects/my-project

Performance Metrics:
--------------------
Scan Duration:          12 seconds (12345ms)
Lines of Code:          8,500
Files Scanned:          156
Performance Ratio:      708.33 LOC/second

Snyk Code Results:
------------------
Total Issues Found:     7
  High:                 2
  Medium:               3
  Low:                  2

Exit Code:              1

================================================================================
```

### JSON Output

```json
{
  "timestamp": "2025-11-20T15:30:45Z",
  "repository": {
    "name": "my-project",
    "path": "/Users/jenny/projects/my-project"
  },
  "metrics": {
    "scan_duration_seconds": 12,
    "scan_duration_milliseconds": 12345,
    "lines_of_code": 8500,
    "files_scanned": 156
  },
  "snyk_results": {
    "exit_code": 1,
    "total_issues": 7,
    "high_issues": 2,
    "medium_issues": 3,
    "low_issues": 2
  }
}
```

## 📈 Use Cases

### Track Performance Over Time
```bash
# Create timestamped metrics
DATE=$(date +%Y%m%d_%H%M%S)
./snyk_code_performance.sh --json -o "metrics_${DATE}.json"
```

### Scan Multiple Repositories
```bash
for repo in repo1 repo2 repo3; do
  ./snyk_code_performance.sh --json -o "metrics_${repo}.json" "/path/${repo}"
done
```

### CI/CD Integration
```yaml
# GitHub Actions example
- name: Snyk Code Performance
  run: |
    npm install -g snyk
    snyk auth ${{ secrets.SNYK_TOKEN }}
    ./snyk_code_performance.sh --json --output metrics.json
```

## 🎓 Understanding the Metrics

### Scan Duration
- Time taken for Snyk Code to analyze your code
- Varies based on repository size and complexity

### Lines of Code (LOC)
- Total lines of actual code (excludes comments and blank lines when cloc is used)
- Supports: JavaScript, TypeScript, Python, Java, C/C++, Go, Ruby, PHP, and more

### Performance Ratio
- Lines of code processed per second
- **Typical**: 100-500 LOC/second
- Useful for capacity planning and performance tracking

### Vulnerability Severity
- **High**: Requires immediate attention
- **Medium**: Should be addressed
- **Low**: Consider fixing

> **Note**: Snyk Code provides three severity levels (High, Medium, Low). There is no "Critical" level for Snyk Code.

## 🔧 Troubleshooting

### "Snyk CLI is not installed"
Install Snyk CLI:
```bash
npm install -g snyk
snyk auth
```

### "Authentication required"
Authenticate with Snyk:
```bash
snyk auth
```

### Scan is slow
- Large repositories take longer
- First scan downloads Snyk rules (slower)
- Subsequent scans are faster due to caching

### Line count seems low
Install `cloc` for accurate counting:
```bash
brew install cloc  # macOS
```

## 📝 Supported File Types

The script counts these source code file types:
- JavaScript/TypeScript (`.js`, `.ts`, `.tsx`, `.jsx`)
- Python (`.py`)
- Java (`.java`)
- C/C++ (`.c`, `.cpp`, `.h`)
- C# (`.cs`)
- Go (`.go`)
- Ruby (`.rb`)
- PHP (`.php`)
- Swift (`.swift`)
- Kotlin (`.kt`)
- Rust (`.rs`)
- Scala (`.scala`)
- Shell (`.sh`)

Automatically excludes: `node_modules/`, `.git/`, `vendor/`, `dist/`, `build/`

## 🤝 Contributing

Contributions are welcome! Feel free to submit issues or pull requests.

## 📄 License

This project is provided as-is for performance monitoring purposes.

## 🔗 Resources

- **Snyk CLI Installation**: https://docs.snyk.io/snyk-cli/install-or-update-the-snyk-cli
- **Snyk Code Documentation**: https://docs.snyk.io/products/snyk-code
- **Snyk CLI Commands**: https://docs.snyk.io/snyk-cli/commands

## 💡 Tips

1. **Run setup first**: `./setup.sh` installs all prerequisites
2. **Try the demo**: `./demo.sh` shows example output without scanning
3. **Use JSON for automation**: Easier to parse and integrate with other tools
4. **Track trends**: Save metrics over time to identify performance patterns
5. **Authenticate once**: `snyk auth` only needs to be done once per machine

---

**Need help?** Check the [Snyk CLI documentation](https://docs.snyk.io/snyk-cli) or run `./snyk_code_performance.sh --help`

