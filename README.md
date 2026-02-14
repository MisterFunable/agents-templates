# Agents Templates

<div align="right">

![AI](https://img.shields.io/badge/AI-Templates-blueviolet)
![License](https://img.shields.io/badge/License-MIT-green)

</div>

Quick-start templates for AI agents building different types of projects.

Drop these files into your repository to guide AI models on coding style, README structure, and project patterns.

> Each template follows the same format: clear rules, examples, and anti-patterns.

**New here?** See `QUICK_START.md` for a 2-minute walkthrough.

## Templates

### Core Development Templates

| File | Purpose |
|------|---------|
| `AGENTS_README.md` | Guidelines for generating clean, scannable README files |
| `AGENTS_PYTHON.md` | Python project structure, style, and best practices |
| `AGENTS_CLI.md` | Command-line tool patterns and documentation |
| `AGENTS_WEBAPP.md` | Web application structure and frontend conventions |
| `AGENTS_COMMON.md` | Cross-cutting patterns: error handling, security, testing, observability |
| `AGENTS_PROMPT.md` | Multipurpose prompts for common tasks: code review, refactoring, testing, documentation |

### Specialized Templates

| File | Purpose |
|------|---------|
| `AGENTS_MACOS_BOOTSTRAP.md` | macOS system setup and automation scripts |
| `AGENTS_AIRTABLE.md` | Airtable API automations and utilities with Python |
| `AGENTS_MERMAID.md` | Mermaid diagrams for technical documentation with MCP integration |
| `AGENTS_EKS_WEBAPP.md` | **NEW:** Simple web apps for EKS deployment (containerized, 12-factor) |
| `AGENTS_ADR.md` | Architecture Decision Records for documenting technical decisions |
| `AGENTS_ADR_RESEARCH.md` | Research methodology for writing ADRs with proper analysis |
| `AGENTS_TECH_RESEARCH.md` | Technology research and evaluation for engineering + business stakeholders |
| `AGENTS_POETRY.md` | Poetry writing techniques, forms, and revision guidelines |

### Meta Templates

| File | Purpose |
|------|---------|
| `AGENTS_TEMPLATE.md` | Meta-template for creating new AGENTS.md files (V1) |
| `AGENTS_TEMPLATE_V2.md` | **Optimized** meta-template with efficiency metrics (recommended for new templates) |
| `AGENTS_CLAUDE_MD.md` | Guidelines for creating CLAUDE.md files (project context for Claude Code) |
| `TEMPLATE_V2_MIGRATION.md` | Migration guide from V1 to V2 templates with optimization strategies |

## Usage

**1. Pick a template:**

```bash
# Copy the template you need
cp AGENTS_README.md /your-project/AGENTS.md
```

**2. Customize if needed:**

Edit the file to match your project's specific requirements. Most templates work out of the box.

**3. Reference in conversations:**

```
"Follow the guidelines in @AGENTS.md for this project"
```

## Structure

```
agents-templates/
├── README.md                      # This file
├── CLAUDE.md                      # Guide for Claude Code working in this repo
├── QUICK_START.md                 # 2-minute getting started guide
├── CONTRIBUTING.md                # How to add new templates
├── IMPROVEMENTS_SUGGESTIONS.md    # New template ideas and enhancements
│
├── Core Development Templates
│   ├── AGENTS_README.md           # README generation rules
│   ├── AGENTS_PYTHON.md           # Python project guidelines
│   ├── AGENTS_CLI.md              # CLI tool patterns
│   ├── AGENTS_WEBAPP.md           # Web app conventions
│   ├── AGENTS_COMMON.md           # Cross-cutting patterns
│   └── AGENTS_PROMPT.md           # Multipurpose prompts and quick fixes
│
├── Specialized Templates
│   ├── AGENTS_MACOS_BOOTSTRAP.md  # macOS setup automation
│   ├── AGENTS_AIRTABLE.md         # Airtable API automations
│   ├── AGENTS_MERMAID.md          # Mermaid diagrams with MCP
│   ├── AGENTS_EKS_WEBAPP.md       # EKS web apps (containerized)
│   ├── AGENTS_ADR.md              # Architecture Decision Records
│   ├── AGENTS_ADR_RESEARCH.md     # ADR research methodology
│   ├── AGENTS_TECH_RESEARCH.md    # Technology evaluation
│   └── AGENTS_POETRY.md           # Poetry writing
│
├── Meta Templates
│   ├── AGENTS_TEMPLATE.md         # Template creation (V1)
│   ├── AGENTS_TEMPLATE_V2.md      # Optimized template creation (V2, recommended)
│   ├── AGENTS_CLAUDE_MD.md        # CLAUDE.md file creation
│   └── TEMPLATE_V2_MIGRATION.md   # V1 to V2 migration guide
│
└── examples/                      # Reference implementations
    ├── readme-sample/             # Before/after README examples
    ├── python-sample/             # Python script example
    ├── cli-sample/                # CLI tool example
    ├── poetry-sample/             # Poetry examples
    ├── macos-bootstrap-sample/    # macOS automation example
    ├── mermaid-sample/            # Mermaid diagrams with MCP
    ├── eks-webapp-sample/         # EKS web app example (NEW)
    ├── tech-research-sample/      # Example evaluation writeups
    └── template-creation-sample/  # How to use AGENTS_TEMPLATE.md
```

## Philosophy

**Constraints breed clarity.** These templates:
- Prevent scope creep by defining clear patterns
- Reduce back-and-forth by providing upfront style rules
- Keep projects consistent across AI sessions

**Templates, not rigid rules.** Adapt them to your needs. Delete sections that don't apply.

## Examples

See the `examples/` folder for real-world implementations showing:
- Before/after comparisons
- Template application in different project types
- Common adaptations

## Adding New Templates

See `CONTRIBUTING.md` for detailed guidelines.

Quick checklist:
1. **Focused:** One template per project type
2. **Actionable:** Specific rules, not vague principles
3. **Scannable:** Tables and bullets, not paragraphs
4. **Example-driven:** Show good vs bad patterns
5. **Include example:** Add working code to `examples/`

## Why Templates?

AI models work best with explicit instructions. Without templates, you get:
- Verbose READMEs with corporate fluff
- Inconsistent code style across sessions
- Missing critical project structure

With templates, AI models deliver consistent, production-ready output on the first try.

---

Built to reduce friction between humans and AI agents.
