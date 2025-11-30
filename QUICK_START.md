# Quick Start Guide

Get started with Agents Templates in 2 minutes.

## What This Repo Does

Provides instruction files for AI models to follow consistent patterns when building projects.

Think of them as style guides, but for entire projects instead of just code.

## How to Use

**Step 1: Pick a template**

```
AGENTS_README.md    → Writing clean READMEs
AGENTS_PYTHON.md    → Python project structure
AGENTS_CLI.md       → Command-line tools
AGENTS_WEBAPP.md    → Web applications
AGENTS_POETRY.md    → Writing poetry (forms, techniques, revision)
AGENTS_TEMPLATE.md  → Creating new templates (meta-template)
```

**Step 2: Copy to your project**

```bash
# Copy the template you need
cp AGENTS_README.md /your-project/AGENTS.md
```

**Step 3: Reference in AI conversations**

```
"Follow @AGENTS.md when building this"
"Generate a README following @AGENTS.md"
"Refactor this code to match @AGENTS.md guidelines"
```

## Examples

See real implementations in `examples/`:

```
examples/
├── readme-sample/      → Before/after README comparison
├── python-sample/      → Python script following guidelines
└── cli-sample/         → CLI tool with proper structure
```

## Common Workflows

### Starting a New Python Project

```bash
cp AGENTS_PYTHON.md my-project/AGENTS.md
cd my-project
```

Then tell your AI:
> "Set up a Python project following @AGENTS.md. Create main.py and requirements.txt."

### Fixing a Messy README

```bash
cp AGENTS_README.md my-project/AGENTS.md
```

Then tell your AI:
> "Rewrite README.md following @AGENTS.md guidelines. Keep all essential information but make it scannable."

### Building a CLI Tool

```bash
cp AGENTS_CLI.md my-tool/AGENTS.md
cp AGENTS_PYTHON.md my-tool/AGENTS_PYTHON.md
```

Then tell your AI:
> "Build a CLI tool that [does X] following @AGENTS.md and @AGENTS_PYTHON.md"

## The Problem This Solves

**Without templates:**
- AI generates verbose READMEs with fluff
- Inconsistent code style across sessions
- Need to repeat preferences every conversation
- Lots of back-and-forth to fix patterns

**With templates:**
- AI follows rules from the start
- Consistent output across projects
- One reference file, infinite uses
- Less revision, more building

## File Structure

```
agents-templates/
│
├── README.md               # Overview of this repo
├── QUICK_START.md         # This file
├── CONTRIBUTING.md        # How to add templates
│
├── AGENTS_README.md       # README writing guide
├── AGENTS_PYTHON.md       # Python project guide
├── AGENTS_CLI.md          # CLI tool guide
├── AGENTS_WEBAPP.md       # Web app guide
│
└── examples/              # Reference implementations
    ├── readme-sample/
    ├── python-sample/
    └── cli-sample/
```

## Tips

**Combine templates:**
Building a Python CLI? Use both AGENTS_PYTHON.md and AGENTS_CLI.md

**Customize freely:**
Edit templates to match your specific needs

**Update during development:**
Add project-specific rules to your AGENTS.md as you go

**Reference in commits:**
"Refactored CLI to match AGENTS.md patterns"

## Next Steps

1. Browse `examples/` to see templates in action
2. Copy a template to your project
3. Start building with consistent AI output
4. Add your own rules as needed

Need a template that doesn't exist? See `CONTRIBUTING.md` for how to add one.

## Creating New Templates

Need a template that doesn't exist?

```bash
# Ask AI to create it
"Create AGENTS_[TYPE].md for [purpose] following @AGENTS_TEMPLATE.md"
```

The AI will:
1. Research the domain
2. Ask clarifying questions
3. Structure the template
4. Write with examples
5. Validate completeness

See `examples/template-creation-sample/PROMPT.md` for a walkthrough.

## FAQ

**Q: Do I need all the templates?**
A: No, just copy what you need for your project type.

**Q: Can I modify the templates?**
A: Yes! They're starting points. Adapt to your needs.

**Q: What if my project needs multiple templates?**
A: Use multiple AGENTS files: `AGENTS_BACKEND.md`, `AGENTS_FRONTEND.md`, etc.

**Q: Will this work with all AI models?**
A: Works best with instruction-following models (GPT-4, Claude, etc.). Results vary by model capability.

**Q: How do I keep templates updated?**
A: Pull latest from this repo periodically, or fork and maintain your own versions.

---

Ready? Pick a template and start building.

