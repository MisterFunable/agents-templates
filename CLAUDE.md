# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a template repository containing instruction files (AGENTS_*.md) that guide AI models to follow consistent patterns when building different types of projects. Think of it as a meta-repository: it doesn't contain traditional code, but rather templates that tell AI how to structure and build projects.

## Repository Structure

```
agents-templates/
├── AGENTS_*.md          # Template files for different project types
│   ├── AGENTS_README.md     # README writing guidelines
│   ├── AGENTS_PYTHON.md     # Python project structure
│   ├── AGENTS_CLI.md        # CLI tool patterns
│   ├── AGENTS_WEBAPP.md     # Web app conventions
│   ├── AGENTS_POETRY.md     # Poetry writing guidelines
│   ├── AGENTS_TEMPLATE.md   # Meta-template for creating templates
│   ├── AGENTS_COMMON.md     # Cross-cutting patterns (error handling, security, etc.)
│   ├── AGENTS_MACOS_BOOTSTRAP.md  # macOS setup automation
│   ├── AGENTS_ADR.md        # Architecture Decision Records
│   └── [others]
├── examples/            # Reference implementations
│   ├── python-sample/
│   ├── cli-sample/
│   ├── readme-sample/
│   ├── poetry-sample/
│   ├── macos-bootstrap-sample/
│   └── [others]
├── README.md           # Project overview
├── QUICK_START.md      # 2-minute getting started guide
└── CONTRIBUTING.md     # Template creation guidelines
```

## Core Architecture

### Template Philosophy

Templates follow a strict structure to maximize AI effectiveness:

1. **Specificity over vagueness**: "Use snake_case" not "use good naming"
2. **Examples over explanations**: Code snippets demonstrate patterns
3. **Tables over prose**: Comparisons use "Don't | Do" tables
4. **Constraints breed clarity**: Clear defaults with escape hatches
5. **Cover 90%, acknowledge 10%**: Focus on common cases, note exceptions

### Template Structure (from AGENTS_TEMPLATE.md)

Every template MUST include:
- **Project Structure**: Directory layout with explanations
- **Core sections** (3-5): Main guidelines for the domain
- **Anti-Patterns**: "Don't | Do" table with 8-12 common mistakes
- **Quick Reference**: Summary table of key decisions
- **Checklist**: "When Working on [TYPE] Projects" with 5-10 essential practices

Target length: 250-300 lines (max 400)

### Creating New Templates

The process (defined in AGENTS_TEMPLATE.md) has 5 phases:
1. **Research**: Web search for practices, examples, tools, anti-patterns
2. **Question**: Clarify scope, tools, integration with existing templates
3. **Structure**: Define sections before writing
4. **Write**: Follow strict guidelines (specific, examples, tables)
5. **Validate**: Self-validation checklist, cross-reference check

## Common Development Tasks

### Adding a New Template

1. Research the domain thoroughly using AGENTS_TEMPLATE.md as guide
2. Check existing templates for overlaps (review all AGENTS_*.md files)
3. Create `AGENTS_[TYPE].md` following the template structure
4. Validate against checklist in AGENTS_TEMPLATE.md
5. Create example in `examples/[type]-sample/`
6. Update README.md to list the new template

### Modifying Existing Templates

1. Read the existing template completely
2. Check CONTRIBUTING.md for guidelines
3. Ensure changes align with template philosophy
4. Maintain existing structure (don't remove required sections)
5. Update examples if needed

### Creating Example Implementations

Examples should:
- Be under 100 lines of code
- Focus on one concept
- Be actually runnable
- Follow the template's guidelines exactly
- Include a README.md following AGENTS_README.md

## Key Files to Understand

| File | Purpose | When to Reference |
|------|---------|-------------------|
| AGENTS_TEMPLATE.md | Template for creating templates | Creating any new AGENTS_*.md file |
| CONTRIBUTING.md | Contribution guidelines | Before adding new content |
| AGENTS_COMMON.md | Cross-cutting patterns | When templates need shared patterns |
| README.md | Repository overview | Understanding project scope |

## Writing Style Requirements

Across all templates and documentation:
- Direct commands: "Use X" not "You should use X"
- No em dashes (—), use regular dashes (-)
- No corporate language or fluff
- No emojis
- Tables over bullet lists for comparisons
- One-line descriptions maximum
- Code examples for every major concept

## Template Cross-References

Templates reference each other when appropriate:
- Python CLI tools → reference AGENTS_PYTHON.md and AGENTS_CLI.md
- All templates → can reference AGENTS_COMMON.md for error handling, security, etc.
- Check for 50%+ overlap before creating new template

## Anti-Patterns to Avoid

| Don't | Do |
|-------|-----|
| Create templates without research | Follow AGENTS_TEMPLATE.md 5-phase process |
| Write vague guidelines ("use good code") | Be specific ("use snake_case for functions") |
| Skip examples | Include 5+ code examples per template |
| Make templates over 400 lines | Target 250-300 lines, max 400 |
| Duplicate existing template content | Check for overlaps, reference other templates |
| Write without validation | Use validation checklist from AGENTS_TEMPLATE.md |
| Skip the example implementation | Create examples/[type]-sample/ |

## Working with Examples

Examples demonstrate template application:
- Each example should map to a specific AGENTS_*.md template
- Examples include BEFORE_AFTER.md or similar documentation showing the template's impact
- Examples are intentionally simple to highlight patterns, not full applications

## Git Workflow

Standard git practices:
- Main branch: `main`
- Commit messages should be descriptive
- Recent commits show iterative updates ("Changes", "Big Update", etc.)

## Testing Changes

Since this is a documentation/template repository, "testing" means:
1. Validate template against checklist (AGENTS_TEMPLATE.md Phase 5)
2. Test with hypothetical task: "Can an AI build [X] using only this template?"
3. Check for conflicts with existing templates
4. Verify examples run correctly

## Quick Reference

| Aspect | Standard |
|--------|----------|
| Template length | 250-300 lines (max 400) |
| Code examples per template | Minimum 5 |
| Anti-patterns table | 8-12 items |
| Example code | Under 100 lines, runnable |
| Writing style | Direct commands, no fluff |
| Structure validation | Use AGENTS_TEMPLATE.md checklist |
| Cross-references | Check all existing templates first |

## When Working in This Repository

1. Read AGENTS_TEMPLATE.md completely before creating new templates
2. Check CONTRIBUTING.md for current guidelines
3. Review existing templates for patterns and overlaps
4. Follow the 5-phase process for new templates (Research → Question → Structure → Write → Validate)
5. Maintain consistency with existing templates
6. Create example implementations for new templates
7. Update README.md when adding templates
8. Keep examples simple and focused
