# AGENTS_CLI.md

Instructions for AI models building command-line tools.

## CLI Tool Structure

Standard CLI project layout:

```
cli-tool/
├── README.md
├── requirements.txt
├── setup.py or pyproject.toml    # For installable tools
├── src/
│   ├── __init__.py
│   ├── cli.py                     # Main CLI interface
│   ├── core.py                    # Business logic
│   └── utils.py
└── tests/
    └── test_cli.py
```

**Separation of concerns:**
- `cli.py`: Argument parsing, user output, CLI logic
- `core.py`: Core functionality (no print/input calls)
- `utils.py`: Shared helpers

This separation allows:
- Testing business logic without CLI
- Using core functions in other contexts
- Clear responsibility boundaries

## Argument Parsing

Use `argparse` for standard tools:

```python
import argparse

def main():
    parser = argparse.ArgumentParser(
        description="Export Medium posts to Markdown",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    
    parser.add_argument(
        "username",
        help="Medium username to export"
    )
    
    parser.add_argument(
        "-o", "--output",
        default="exports",
        help="output directory (default: exports)"
    )
    
    parser.add_argument(
        "--limit",
        type=int,
        help="maximum number of posts to export"
    )
    
    parser.add_argument(
        "-v", "--verbose",
        action="store_true",
        help="enable verbose logging"
    )
    
    args = parser.parse_args()
    
    # Pass to business logic
    export_posts(args.username, args.output, args.limit, args.verbose)
```

**For complex CLIs:** Use `click` library with subcommands.

## Help Text

**Make `--help` output scannable:**

```
usage: medium-export [-h] [-o OUTPUT] [--limit LIMIT] [-v] username

Export Medium posts to Markdown

positional arguments:
  username              Medium username to export

options:
  -h, --help            show this help message and exit
  -o, --output OUTPUT   output directory (default: exports)
  --limit LIMIT         maximum number of posts to export
  -v, --verbose         enable verbose logging

Examples:
  medium-export @username
  medium-export @username -o output/ --limit 10
```

**Help text rules:**
- Keep descriptions under 60 characters
- Use lowercase for descriptions (unless proper noun)
- Show practical examples at bottom
- One short flag (`-v`) and one long flag (`--verbose`)

## User Output

**Use appropriate channels:**

```python
import sys

# Normal output -> stdout
print("Exported 5 posts to exports/")

# Status updates -> stderr
print("Processing post 3 of 10...", file=sys.stderr)

# Errors -> stderr + exit code
print("Error: API key not found", file=sys.stderr)
sys.exit(1)
```

**Progress indicators for long tasks:**

```python
from tqdm import tqdm

for post in tqdm(posts, desc="Exporting posts"):
    process_post(post)
```

**Exit codes:**

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | General error |
| 2 | Invalid usage/arguments |
| 130 | Interrupted (Ctrl+C) |

## Configuration

**Priority order (highest to lowest):**

1. Command-line arguments
2. Environment variables
3. Config file
4. Defaults

```python
import os

def get_api_key(args):
    # 1. CLI arg
    if args.api_key:
        return args.api_key
    
    # 2. Environment variable
    if env_key := os.getenv("API_KEY"):
        return env_key
    
    # 3. Config file
    if config_key := load_config().get("api_key"):
        return config_key
    
    # 4. Error if no default
    raise ValueError("API key not found. Set --api-key or API_KEY env var")
```

**Config file location:**

```python
from pathlib import Path

# Linux/Mac: ~/.config/app-name/config.yaml
# Windows: %APPDATA%\app-name\config.yaml
def get_config_path():
    if sys.platform == "win32":
        base = Path(os.getenv("APPDATA"))
    else:
        base = Path.home() / ".config"
    
    return base / "app-name" / "config.yaml"
```

## Error Messages

**Be specific and actionable:**

```python
# Bad - vague
print("Error: Something went wrong")

# Good - specific with solution
print("Error: File 'data.json' not found. Check the path and try again.")

# Better - with context
print(f"Error: Cannot read '{filepath}'")
print("  Make sure the file exists and you have read permissions.")
print(f"  Current directory: {os.getcwd()}")
```

**Error message template:**
1. What went wrong
2. Why it might have happened
3. What to do next (if applicable)

## Input Validation

**Validate early, fail fast:**

```python
def main():
    args = parser.parse_args()
    
    # Validate immediately
    if args.limit and args.limit < 1:
        parser.error("--limit must be positive")
    
    output_dir = Path(args.output)
    if output_dir.exists() and not output_dir.is_dir():
        parser.error(f"'{args.output}' exists but is not a directory")
    
    # Continue with validated inputs
    process(args)
```

**Use `parser.error()` for validation errors:**
- Prints usage automatically
- Exits with code 2
- Consistent error formatting

## Interactive Prompts

**Only prompt when necessary:**

```python
import sys

def confirm_overwrite(filepath):
    # Skip prompt if not interactive
    if not sys.stdin.isatty():
        return False
    
    response = input(f"'{filepath}' exists. Overwrite? [y/N]: ")
    return response.lower() == 'y'
```

**Provide non-interactive mode:**

```python
parser.add_argument(
    "-f", "--force",
    action="store_true",
    help="overwrite existing files without prompting"
)
```

## Installation

**Make tool installable with pip:**

```toml
# pyproject.toml
[project.scripts]
mytool = "src.cli:main"
```

**Or with entry points in setup.py:**

```python
setup(
    name="mytool",
    entry_points={
        "console_scripts": [
            "mytool=src.cli:main",
        ],
    },
)
```

**After installation:**

```bash
pip install -e .
mytool --help
```

## Output Formats

**Support common formats:**

```python
parser.add_argument(
    "--format",
    choices=["json", "csv", "text"],
    default="text",
    help="output format"
)

# In code
if args.format == "json":
    print(json.dumps(data, indent=2))
elif args.format == "csv":
    writer = csv.DictWriter(sys.stdout, fieldnames=data[0].keys())
    writer.writeheader()
    writer.writerows(data)
else:
    # Human-readable text
    for item in data:
        print(f"{item['name']}: {item['value']}")
```

**JSON output for scripting:**
- One object per line for streaming
- Pretty-print with `--pretty` flag
- Use `--format json` for machine-readable output

## Environment Variables

**Document all environment variables:**

```python
# In help text or README
"""
Environment variables:
  API_KEY         API key for authentication (required)
  DEBUG           Enable debug logging (default: false)
  CONFIG_PATH     Custom config file location
"""
```

**Naming convention:**
- Prefix with app name: `MYTOOL_API_KEY`
- Use UPPER_SNAKE_CASE
- Boolean values: "true"/"false" or "1"/"0"

## Verbosity Levels

**Standard verbosity flags:**

```python
parser.add_argument(
    "-v", "--verbose",
    action="count",
    default=0,
    help="increase verbosity (-v, -vv, -vvv)"
)

# Map to log levels
log_levels = {
    0: logging.WARNING,    # Default
    1: logging.INFO,       # -v
    2: logging.DEBUG,      # -vv
    3: logging.DEBUG,      # -vvv (with more detail)
}

logging.basicConfig(level=log_levels.get(args.verbose, logging.DEBUG))
```

## File Operations

**Safe file writing:**

```python
from pathlib import Path
import tempfile
import shutil

def safe_write(filepath, content):
    """Write file atomically to prevent corruption."""
    filepath = Path(filepath)
    
    # Write to temp file first
    temp = tempfile.NamedTemporaryFile(
        mode='w',
        dir=filepath.parent,
        delete=False
    )
    
    try:
        temp.write(content)
        temp.flush()
        os.fsync(temp.fileno())
        temp.close()
        
        # Atomic move
        shutil.move(temp.name, filepath)
    except:
        os.unlink(temp.name)
        raise
```

## Signal Handling

**Handle Ctrl+C gracefully:**

```python
import signal
import sys

def signal_handler(signum, frame):
    print("\nInterrupted. Cleaning up...", file=sys.stderr)
    # Cleanup code here
    sys.exit(130)  # Standard exit code for SIGINT

signal.signal(signal.SIGINT, signal_handler)
signal.signal(signal.SIGTERM, signal_handler)
```

**With context manager for cleanup:**

```python
import contextlib

@contextlib.contextmanager
def cleanup_on_exit(cleanup_func):
    try:
        yield
    except KeyboardInterrupt:
        print("\nInterrupted", file=sys.stderr)
        cleanup_func()
        sys.exit(130)
    finally:
        cleanup_func()

# Usage
with cleanup_on_exit(lambda: temp_dir.cleanup()):
    long_running_process()
```

## Streaming and Piping

**Handle piped input:**

```python
import sys

def main():
    if not sys.stdin.isatty():
        # Data is being piped in
        for line in sys.stdin:
            process_line(line.strip())
    else:
        # Interactive mode
        parser.parse_args()
```

**Stream large outputs:**

```python
import sys

def export_records(records):
    for record in records:
        # Write immediately, don't buffer
        sys.stdout.write(json.dumps(record) + "\n")
        sys.stdout.flush()  # Ensure piped consumers receive data
```

**Handle broken pipes:**

```python
import errno

try:
    for item in large_dataset:
        print(json.dumps(item))
except BrokenPipeError:
    # Reader closed pipe (e.g., head -n 10)
    sys.stderr.close()  # Suppress Python error message
    sys.exit(0)
except IOError as e:
    if e.errno == errno.EPIPE:
        sys.exit(0)
    raise
```

## Shell Completion

**Generate completion scripts:**

```python
# For argparse with argcomplete
import argcomplete

parser = argparse.ArgumentParser()
parser.add_argument("--format", choices=["json", "csv", "text"])
argcomplete.autocomplete(parser)
args = parser.parse_args()
```

**Install completion for users:**

```bash
# Bash - add to ~/.bashrc
eval "$(register-python-argcomplete mytool)"

# Zsh - add to ~/.zshrc
autoload -U bashcompinit
bashcompinit
eval "$(register-python-argcomplete mytool)"
```

**For click-based CLIs:**

```python
import click

@click.command()
@click.option('--format', type=click.Choice(['json', 'csv', 'text']))
def main(format):
    pass

# Generate completion script
# mytool --install-completion bash
```

**Document shell completion in README:**

```markdown
## Shell Completion

Enable tab completion:

```bash
# Bash
echo 'eval "$(mytool --completion bash)"' >> ~/.bashrc

# Zsh
echo 'eval "$(mytool --completion zsh)"' >> ~/.zshrc
```
```

## Testing CLIs

**Test with subprocess:**

```python
import subprocess

def test_help_flag():
    result = subprocess.run(
        ["python", "-m", "src.cli", "--help"],
        capture_output=True,
        text=True
    )
    assert result.returncode == 0
    assert "usage:" in result.stdout

def test_invalid_argument():
    result = subprocess.run(
        ["python", "-m", "src.cli", "--invalid"],
        capture_output=True,
        text=True
    )
    assert result.returncode == 2
    assert "unrecognized arguments" in result.stderr
```

**Test piped input:**

```python
def test_piped_input():
    result = subprocess.run(
        ["python", "-m", "src.cli"],
        input="line1\nline2\n",
        capture_output=True,
        text=True
    )
    assert result.returncode == 0
    assert "Processed 2 lines" in result.stdout

def test_signal_handling():
    proc = subprocess.Popen(
        ["python", "-m", "src.cli", "--slow"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    time.sleep(0.5)
    proc.send_signal(signal.SIGTERM)
    _, stderr = proc.communicate()
    assert proc.returncode == 143  # 128 + 15 (SIGTERM)
```

## Common Flags

**Standard flag conventions:**

| Flag | Purpose |
|------|---------|
| `-h, --help` | Show help (automatic with argparse) |
| `-v, --verbose` | Increase verbosity |
| `-q, --quiet` | Suppress output |
| `-V, --version` | Show version |
| `-f, --force` | Skip confirmations |
| `-n, --dry-run` | Show what would happen |
| `-o, --output` | Output file/directory |
| `-c, --config` | Config file path |

## Anti-Patterns

Avoid these mistakes:

| Don't | Do |
|-------|-----|
| Print debug info to stdout | Use stderr or logging module |
| Exit without message on error | Print error message, then exit |
| Prompt in non-interactive context | Check `sys.stdin.isatty()` |
| Parse args manually | Use argparse/click |
| Hardcode file paths | Use Path and relative paths |
| Ignore Ctrl+C | Handle `signal.SIGINT` |
| Long-running task without progress | Show progress bar or status |
| Buffer all output then print | Stream output line by line |
| Crash on broken pipe | Catch `BrokenPipeError`, exit cleanly |
| Ignore `SIGTERM` | Clean up resources before exit |
| Require specific shell | Support bash, zsh, and sh |
| Large memory usage for big files | Stream and process in chunks |

## README Requirements for CLI Tools

**Must include:**
1. Installation command
2. Basic usage example
3. Command table with all flags
4. Environment variables table
5. Exit codes (if non-standard)

**Example command documentation:**

```markdown
## Usage

Basic export:
```bash
mytool username
```

With options:
```bash
mytool username -o output/ --limit 10 --verbose
```

| Flag | Description |
|------|-------------|
| `-o, --output` | Output directory (default: exports) |
| `--limit` | Max items to process |
| `-v, --verbose` | Enable verbose logging |
| `-f, --force` | Skip confirmations |
```

## Quick Reference

| Aspect | Standard |
|--------|----------|
| Argument parser | `argparse` (stdlib) or `click` |
| Progress bars | `tqdm` |
| Output | stdout for results, stderr for status |
| Config format | YAML or TOML |
| Exit on success | `sys.exit(0)` or just return |
| Exit on error | `sys.exit(1)` with message to stderr |
| Signal handling | Catch `SIGINT` and `SIGTERM` |
| Shell completion | `argcomplete` for argparse |
| Piped input | Check `sys.stdin.isatty()` |
| Large data | Stream with generators |

## When Building CLI Tools

1. Separate CLI logic from business logic
2. Make `--help` output clear and scannable
3. Validate inputs early
4. Support non-interactive mode
5. Show progress for long operations
6. Document all environment variables
7. Provide practical examples in help text
8. Handle `SIGINT` and `SIGTERM` for cleanup
9. Support piped input and output
10. Offer shell completion scripts

## See Also

- AGENTS_PYTHON.md for Python code patterns
- AGENTS_README.md for documenting CLI tools

