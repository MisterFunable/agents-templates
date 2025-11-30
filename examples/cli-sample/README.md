# Git Stats

CLI tool example demonstrating AGENTS_CLI.md guidelines.

Display git repository statistics including commit count, author count, and branch count.

## Setup

**Requirements:** Python 3.9+, git

```bash
cd examples/cli-sample
chmod +x git-stats.py
```

## Usage

```bash
# Current directory
./git-stats.py

# Specific repository
./git-stats.py /path/to/repo

# JSON output
./git-stats.py --format json

# Verbose mode
./git-stats.py -v
```

## Commands

| Flag | Description |
|------|-------------|
| `path` | Path to git repository (default: current directory) |
| `--format` | Output format: text or json (default: text) |
| `-v, --verbose` | Enable verbose output |
| `-h, --help` | Show help message |

## Output

**Text format:**

```
Git Repository Statistics
========================================
Commits:  156
Authors:  3
Branches: 8
```

**JSON format:**

```json
{
  "commits": 156,
  "authors": 3,
  "branches": 8
}
```

## Features Demonstrated

This example shows:
- Argument parsing with argparse
- Multiple output formats
- Error handling with specific exit codes
- Keyboard interrupt handling
- Input validation
- Help text with examples
- Separation of CLI and business logic

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | Error (invalid repo, git failure) |
| 2 | Invalid arguments |
| 130 | Interrupted (Ctrl+C) |

---

Follows AGENTS_CLI.md guidelines

