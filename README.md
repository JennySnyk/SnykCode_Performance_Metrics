# Snyk Code Performance Metrics

A simple bash script to measure Snyk Code scan performance and capture key metrics.

## 🎯 What It Does

This script captures:
- ⏱️ **Scan Duration** - Time taken for Snyk Code test (seconds and milliseconds)
- 🐛 **Vulnerabilities Found** - Issues by severity (High, Medium, Low)
- 📊 **Exit Code** - Scan result status

## 📋 Prerequisites

### Required

**Snyk CLI** - Must be installed and authenticated

Install Snyk CLI:
```bash
# macOS / Linux / Windows
npm install -g snyk

# Windows alternative (using Scoop)
scoop bucket add snyk https://github.com/snyk/scoop-snyk
scoop install snyk

# Windows alternative (Standalone)
# Download from: https://github.com/snyk/cli/releases
```

Authenticate with Snyk:
```bash
snyk auth
```

> 📖 **Full installation guide**: https://docs.snyk.io/snyk-cli/install-or-update-the-snyk-cli

### Recommended

**jq** - JSON processor (for parsing Snyk vulnerability details)
```bash
# macOS
brew install jq

# Linux (Debian/Ubuntu)
sudo apt-get install jq

# Windows (using Chocolatey)
choco install jq

# Windows (using Scoop)
scoop install jq
```

> **Note**: The script works without jq, but vulnerability breakdown by severity will be limited.

### Running on Windows

This is a bash script, so Windows users need one of these options:

**Option 1: Git Bash** (Recommended - comes with Git for Windows)
```bash
# Download and install Git for Windows
# https://git-scm.com/download/win
# Then run the script in Git Bash terminal
```

**Option 2: WSL (Windows Subsystem for Linux)**
```bash
# Install WSL from Microsoft Store or PowerShell
wsl --install
# Then use Ubuntu or your preferred Linux distribution
```

**Option 3: Cygwin**
```bash
# Download and install Cygwin
# https://www.cygwin.com/
```

> **💡 Tip**: Git Bash is the easiest option for Windows users and comes bundled with Git for Windows.

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/JennySnyk/SnykCode_Performance_Metrics.git
cd SnykCode_Performance_Metrics
```

### 2. Run Setup (Optional)
```bash
# macOS / Linux
./setup.sh

# Windows (Git Bash)
bash setup.sh
```
This will check and install prerequisites automatically.

### 3. Run the Script
```bash
# macOS / Linux
./snyk_code_performance.sh

# Windows (Git Bash or WSL)
bash snyk_code_performance.sh

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
Repository Path:        /home/user/projects/my-project

Performance Metrics:
--------------------
Scan Duration:          12 seconds (12345ms)

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
    "path": "/home/user/projects/my-project"
  },
  "metrics": {
    "scan_duration_seconds": 12,
    "scan_duration_milliseconds": 12345
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
- Measured in both seconds and milliseconds for precision
- Varies based on repository size and complexity

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

### Windows: "command not found" or script won't run
You need a bash environment:
1. **Install Git for Windows** (includes Git Bash): https://git-scm.com/download/win
2. Open **Git Bash** terminal
3. Run the script: `bash snyk_code_performance.sh`

### Scan is slow
- Large repositories take longer
- First scan downloads Snyk rules (slower)
- Subsequent scans are faster due to caching

## 🤝 Contributing

Contributions are welcome! Feel free to submit issues or pull requests.

## 📄 License

This project is provided as-is for performance monitoring purposes.

## 🔗 Resources

- **Snyk CLI Installation**: https://docs.snyk.io/snyk-cli/install-or-update-the-snyk-cli
- **Snyk Code Documentation**: https://docs.snyk.io/products/snyk-code
- **Snyk CLI Commands**: https://docs.snyk.io/snyk-cli/commands

## 💡 Tips

1. **Run setup first**: `./setup.sh` (or `bash setup.sh` on Windows) installs all prerequisites
2. **Try the demo**: `./demo.sh` shows example output without scanning
3. **Use JSON for automation**: Easier to parse and integrate with other tools
4. **Track trends**: Save metrics over time to identify performance patterns
5. **Authenticate once**: `snyk auth` only needs to be done once per machine
6. **Windows users**: Use Git Bash for the easiest experience
7. **Install jq**: Enables detailed vulnerability parsing and better JSON handling

---

**Need help?** Check the [Snyk CLI documentation](https://docs.snyk.io/snyk-cli) or run `./snyk_code_performance.sh --help`

