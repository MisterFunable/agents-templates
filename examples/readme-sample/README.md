# Medium Exporter

<div align="right">

![Python](https://img.shields.io/badge/Python-3.9+-blue?logo=python&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)

</div>

Export Medium posts to Markdown with optional local image mirroring.

Bypasses Medium's paywall restrictions to archive your own content.

> Sample exports included in `examples/` for reference

## Setup

**Requirements:** Python 3.9+, [RapidAPI key](https://rapidapi.com/nishujain199719-vgIfuFHZxVZ/api/medium2)

```bash
git clone https://github.com/username/medium-exporter.git
cd medium-exporter
pip install -r requirements.txt
```

**With Docker:**

```bash
docker compose up
```

## Commands

| Flag | Description |
|------|-------------|
| `username` | Medium username to export (required) |
| `-o, --output` | Output directory (default: exports) |
| `--mirror-images` | Download images locally |
| `--limit N` | Export only N most recent posts |

**Basic export:**

```bash
python fetch_medium_posts.py @username
```

**Download with images:**

```bash
python fetch_medium_posts.py @username --mirror-images -o my-posts/
```

## Output

```
exports/
├── post-title-1.md
├── post-title-2.md
└── images/
    ├── image-123.jpg
    └── image-456.png
```

**Each markdown file contains:**
- Post title and metadata
- Full content with preserved formatting
- Image links (local paths if mirrored)

## API Setup

1. Sign up at [RapidAPI](https://rapidapi.com)
2. Subscribe to [Medium API](https://rapidapi.com/nishujain199719-vgIfuFHZxVZ/api/medium2)
3. Copy your API key
4. Set environment variable: `export RAPIDAPI_KEY=your_key_here`

## Rate Limits

- Free tier: 100 requests/month
- Each post counts as 1 request
- Use `--limit` flag to control usage

## Troubleshooting

| Error | Fix |
|-------|-----|
| `RAPIDAPI_KEY not found` | Set environment variable or add to `.env` file |
| `User not found` | Check username format (include `@`) |
| `Rate limit exceeded` | Wait for quota reset or upgrade plan |
| `Failed to download image` | Image may be deleted; post markdown still exports |

---

This tool follows guidelines from AGENTS_README.md

