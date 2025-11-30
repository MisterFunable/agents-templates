# README Transformation Example

This document shows how AGENTS_README.md guidelines transform verbose READMEs into scannable ones.

## Before (Verbose, Corporate)

```markdown
# Medium Post Exporter Tool

## About This Project

This comprehensive solution enables users to seamlessly export their Medium articles while providing robust image mirroring capabilities. Built with Python, this tool offers a straightforward approach to archiving your content.

## Features

- Export Medium posts to Markdown format
- Mirror images locally for offline access
- Support for multiple export formats
- Configurable output directories
- Rate limit handling
- Error recovery mechanisms
- Detailed logging capabilities

## Prerequisites

Before you begin, ensure you have the following installed on your system:

- Python 3.7 or higher
- pip package manager
- A valid RapidAPI account and subscription
- Internet connection for API access

## Installation Steps

1. First, you'll need to clone this repository to your local machine:
   ```bash
   git clone https://github.com/username/medium-exporter.git
   ```

2. Next, navigate to the project directory:
   ```bash
   cd medium-exporter
   ```

3. Then, install the required dependencies:
   ```bash
   pip install -r requirements.txt
   ```

## Configuration

In order to use this tool, you need to configure your API credentials...

(continues for 200+ more lines)
```

## After (Direct, Scannable)

```markdown
# Medium Exporter

<div align="right">

![Python](https://img.shields.io/badge/Python-3.9+-blue?logo=python&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker&logoColor=white)

</div>

Export Medium posts to Markdown with optional local image mirroring.

Bypasses Medium's paywall restrictions to archive your own content.

## Setup

**Requirements:** Python 3.9+, [RapidAPI key](#api-setup)

```bash
git clone https://github.com/username/medium-exporter.git
cd medium-exporter
pip install -r requirements.txt
```

## Commands

| Flag | Description |
|------|-------------|
| `username` | Medium username to export (required) |
| `-o, --output` | Output directory (default: exports) |
| `--mirror-images` | Download images locally |
| `--limit N` | Export only N most recent posts |

```bash
python fetch_medium_posts.py @username --mirror-images
```

## API Setup

1. Sign up at [RapidAPI](https://rapidapi.com)
2. Subscribe to [Medium API](https://rapidapi.com/...)
3. Set: `export RAPIDAPI_KEY=your_key_here`

## Troubleshooting

| Error | Fix |
|-------|-----|
| `RAPIDAPI_KEY not found` | Set environment variable |
| `Rate limit exceeded` | Wait or upgrade plan |
```

## Key Changes

| Verbose Pattern | Direct Pattern |
|-----------------|----------------|
| "This comprehensive solution enables..." | "Export Medium posts to Markdown" |
| "Prerequisites" section | Inline with Setup |
| Numbered installation steps | Single code block |
| "Features" list | Discoverable through usage |
| Paragraphs of explanation | Tables for options |
| 200+ lines | ~80 lines |
| Em dashes and corporate language | Colons and direct statements |

## Impact

**Before:**
- Takes 3-5 minutes to find how to run
- Reads like marketing copy
- Lots of scrolling to find commands

**After:**
- Everything visible in 60 seconds
- Reads like technical documentation
- Command table immediately scannable

