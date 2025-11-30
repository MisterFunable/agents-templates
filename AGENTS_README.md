# AGENTS.md

Instructions for AI models working on this repository.

## README Generation Guidelines

When creating or updating README files, follow these principles:

### Tone and Style

- **Direct, not corporate.** Write like you're explaining to a friend, not a client.
- **No fluff.** Every sentence should be useful. If it doesn't help the user run the project, cut it.
- **Scannable.** Users should find what they need in under 60 seconds.
- **No emojis** unless explicitly requested.
- **No em dashes (—).** Use colons, commas, or rewrite the sentence.

### Tone Examples

**Too corporate:**
> "This comprehensive solution enables users to seamlessly export their Medium articles while providing robust image mirroring capabilities..."

**Too casual:**
> "So basically this thing grabs your Medium stuff and dumps it into markdown lol"

**Just right:**
> "Export Medium posts to Markdown. Optionally downloads images locally."

### Structure (in order)

```
# Title + Badges (top right)

One-liner description of what it does.

One sentence on why it's useful.

> Quick note about sample files or important context (optional)

## Setup
  - Requirements (one line)
  - Clone command
  - Docker path (if available)
  - Python/native path

## Commands
  - Tables for CLI options
  - One practical example

## Output
  - Directory structure only
  - What files contain (one line)

## Config/API Setup (if needed)
  - Bullet points, not paragraphs
  - 4-5 steps max

## Rate Limits / Constraints (if applicable)
  - Bullet points

## Troubleshooting
  - Table format: Error | Fix

---
Footer (optional, one line)
```

### Formatting Rules

1. **Use tables** for options, commands, and troubleshooting. Tables are faster to scan than lists.

2. **Code blocks should be copy-paste ready.** Include the full command, not fragments.

3. **One example per concept.** Don't show 5 variations of the same command.

4. **Headings are navigation.** Use `##` for main sections only. Avoid deep nesting (`####`).

5. **Badges go top-right** using: `<div align="right">![Badge](url)</div>`

6. **Blockquotes (`>`)** for important notes that aren't warnings.

7. **Bold** for emphasis on key terms, not for decoration.

### Badge Patterns

Common badges with ready-to-use templates (via [shields.io](https://shields.io)):

| Badge | Code |
|-------|------|
| Python | `![Python](https://img.shields.io/badge/Python-3.7+-blue?logo=python&logoColor=white)` |
| Docker | `![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker&logoColor=white)` |
| License | `![License](https://img.shields.io/badge/License-MIT-green)` |
| AI Generated | `![AI](https://img.shields.io/badge/AI-Generated-blueviolet)` |
| Medium | `![Medium](https://img.shields.io/badge/Medium-12100E?logo=medium&logoColor=white)` |

### Environment Variables

Document env vars in a table format:

| Variable | Required | Description |
|----------|----------|-------------|
| `API_KEY` | Yes | Your API key |
| `DEBUG` | No | Enable debug mode (default: false) |

### Command Output

Only show command output when:
- It confirms success in a non-obvious way
- It helps users verify they did it right
- The output format matters for next steps

Skip output for self-explanatory commands like `git clone` or `pip install`.

### What to Remove

- "Features" lists (users discover features by using the tool)
- "How It Works" sections (implementation details belong in code comments)
- "About" sections that repeat the intro
- Multiple examples showing the same thing with slight variations
- "Prerequisites" as a separate section (inline with Setup)
- Verbose step-by-step tutorials (use numbered bullets instead)
- "License" and "Acknowledgments" unless legally required or specifically requested

### Anti-Patterns

Avoid these common mistakes:

- Don't explain what `git clone` does
- Don't add "Contributing" sections to personal tools
- Don't document every flag if `--help` exists
- Don't use "simply" or "just" (if it were simple, they wouldn't need docs)
- Don't add screenshots unless UI is complex
- Don't write "In order to..." (just write what to do)
- Don't start sentences with "This will..." (just say what it does)

### What to Keep

- Everything needed to get running in 5 minutes
- Common errors and fixes
- Rate limits or constraints that affect usage
- One clear example per command type

### Length Target

- Aim for **80-120 lines** for a typical CLI tool
- If it's longer, you're probably being redundant

### Example Transformation

**Before (verbose):**
```markdown
## Prerequisites

Before you begin, ensure you have the following installed:

- Python 3.7 or higher
- pip package manager
- A RapidAPI account

## Installation

1. First, clone this repository to your local machine:
   ```bash
   git clone https://github.com/user/repo.git
   ```

2. Navigate to the project directory:
   ```bash
   cd repo
   ```

3. Install the required dependencies:
   ```bash
   pip install -r requirements.txt
   ```
```

**After (direct):**
```markdown
## Setup

**Requirements:** Python 3.7+, [RapidAPI key](#getting-your-api-key)

```bash
git clone https://github.com/user/repo.git
cd repo
pip install -r requirements.txt
```
```

## Code Style

This repository uses:
- Python 3.7+ with type hints
- No external formatting tools required
- Docstrings at module level only

## File Descriptions

| File | Purpose |
|------|---------|
| `fetch_medium_posts.py` | Main script - exports Medium posts via RapidAPI |
| `requirements.txt` | Python dependencies |
| `Dockerfile` | Container build instructions |
| `docker-compose.yml` | Container orchestration with volume mounts |
| `Makefile` | Simplified command shortcuts |
| `exports/` | Sample output for reference (not source code) |

## When Updating This Repository

1. Keep the README under 120 lines
2. Test commands before documenting them
3. Update Makefile if adding new workflows
4. Don't add features without updating relevant docs

## Quick Reference

| Do | Don't |
|----|-------|
| Tables for options | Bullet lists for options |
| One example per command | 5 variations of same thing |
| `##` headings only | Deep nesting `####` |
| 80-120 lines total | 300+ line READMEs |
| Copy-paste commands | Fragment commands |
| "Run X" | "In order to run X, you need to..." |
| Direct statements | "This will allow you to..." |
| Requirements inline | Separate Prerequisites section |

## Meta: Writing Agent Instructions

This file serves as both a README template AND a reference for writing other AGENTS.md files.

### Principles for Agent Instruction Files

**1. Constraints over flexibility**
- Specific patterns beat vague principles
- "Use argparse" beats "Choose a good argument parser"
- Defaults with escape hatches

**2. Examples over explanations**
- Show code, not philosophy
- Good vs bad comparisons
- Real patterns, not pseudocode

**3. Tables over prose**
- Faster to scan
- Easier to reference
- Forces conciseness

**4. Actionable over theoretical**
- "Use X" not "X is considered best practice"
- Commands, not descriptions of commands
- Specific file names, not "create a file"

### Structure Pattern for AGENTS.md Files

```markdown
# AGENTS_[TYPE].md

Instructions for AI models working on [TYPE].

## [Core Section 1]
Rules + Examples

## [Core Section 2]
Rules + Examples

## Anti-Patterns
| Don't | Do |

## Quick Reference
| Aspect | Standard |

## When Working on [TYPE]
Checklist of key practices
```

### Testing Your Instructions

**Good test:** Give file to AI, ask it to build something. Does output follow all rules?

**Signs of good instructions:**
- AI asks fewer clarifying questions
- First output needs minimal revision
- Consistent style across sessions
- Less "but what about..." edge cases

**Signs of poor instructions:**
- Too many options ("you could also...")
- Vague terms ("clean", "good", "proper")
- No examples for complex concepts
- Rules that conflict with each other

### Common Pitfalls in Agent Files

| Pitfall | Fix |
|---------|-----|
| "Best practices" without specifics | Name the practice and show example |
| Explaining why too much | Show what, mention why briefly |
| Too many exceptions | Cover 90%, note exceptions exist |
| Mixing concerns | One file per project type |
| Being prescriptive about tools | Specify defaults, allow alternatives |

### Creating New AGENTS Templates

To create a new template (like AGENTS_API.md or AGENTS_MOBILE.md):

1. Use `AGENTS_TEMPLATE.md` - it guides you through research, questions, structure, writing, and validation
2. Follow the 5-phase process to ensure quality and consistency
3. See `examples/template-creation-sample/PROMPT.md` for a walkthrough
4. Reference `CONTRIBUTING.md` for adding it to the repository

The meta-template ensures new templates maintain the same quality and format as existing ones.

See `CONTRIBUTING.md` for adding new templates to this repository.

