# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a template repository containing instruction files (AGENTS_*.md) that guide AI models to follow consistent patterns when building different types of projects. Think of it as a meta-repository: it doesn't contain traditional code, but rather templates that tell AI how to structure and build projects.

## Repository Structure

```
agents-templates/
├── AGENTS_*.md          # Template files for different project types
│   ├── AGENTS_README.md          # README writing guidelines
│   ├── AGENTS_PYTHON.md          # Python project structure
│   ├── AGENTS_CLI.md             # CLI tool patterns
│   ├── AGENTS_WEBAPP.md          # Web app conventions
│   ├── AGENTS_COMMON.md          # Cross-cutting patterns (error handling, security, performance)
│   ├── AGENTS_PROMPT.md          # Multipurpose prompts for common tasks
│   ├── AGENTS_POETRY.md          # Poetry writing guidelines
│   ├── AGENTS_MACOS_BOOTSTRAP.md # macOS setup automation
│   ├── AGENTS_AIRTABLE.md        # Airtable automations with Python
│   ├── AGENTS_MERMAID.md         # Mermaid diagrams with MCP integration
│   ├── AGENTS_EKS_WEBAPP.md      # EKS web apps (containerized, 12-factor)
│   ├── AGENTS_ADR.md             # Architecture Decision Records
│   ├── AGENTS_ADR_RESEARCH.md    # ADR research methodology
│   ├── AGENTS_TECH_RESEARCH.md   # Technology evaluation and research
│   ├── AGENTS_TEMPLATE.md        # Meta-template for creating templates (V1)
│   ├── AGENTS_TEMPLATE_V2.md     # Optimized meta-template (V2, recommended)
│   ├── AGENTS_CLAUDE_MD.md       # Guidelines for creating CLAUDE.md files (V1)
│   ├── AGENTS_CLAUDE_MD_V2.md    # Optimized CLAUDE.md creation (V2, recommended)
│   ├── TEMPLATE_V2_MIGRATION.md  # Migration guide from V1 to V2
│   └── CLAUDE_MD_V2_COMPARISON.md # CLAUDE.md V1 vs V2 comparison
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

**Use AGENTS_TEMPLATE_V2.md for new templates** (optimized version with efficiency metrics).

The V2 process is streamlined to 65 minutes total:
1. **Scope** (5 min): Define domain, problems solved, target length
2. **Research** (20 min): Time-boxed research of official docs, examples, common mistakes
3. **Structure** (5 min): Create outline with 6 required sections
4. **Write** (30 min): One example per concept, tables over prose
5. **Validate** (5 min): 10-item checklist for quality assurance

**V2 Key Improvements:**
- Target length: 250-350 lines (V1 allowed up to 400)
- Examples: 1-2 per concept (V1 showed 4-6 variants)
- Decision tables instead of prose explanations
- Built-in efficiency metrics
- Clearer mandatory vs optional guidance
- Read time: <10 minutes (V1 was ~15 minutes)

See TEMPLATE_V2_MIGRATION.md for converting existing V1 templates to V2.

## Common Development Tasks

### Adding a New Template

1. Research the domain thoroughly using **AGENTS_TEMPLATE_V2.md** as guide (recommended)
2. Check existing templates for overlaps (review all AGENTS_*.md files)
3. Create `AGENTS_[TYPE].md` following the V2 structure (6 required sections)
4. Validate against 10-item checklist in AGENTS_TEMPLATE_V2.md
5. Check efficiency metrics: 250-350 lines, 1-2 examples/concept, <10 min read time
6. Create example in `examples/[type]-sample/`
7. Update README.md and CLAUDE.md to list the new template

### Creating a CLAUDE.md File

1. Use **AGENTS_CLAUDE_MD_V2.md** as guide (recommended - 50% faster)
2. Follow 4-phase process (Analysis → Pattern Discovery → Write → Validate)
3. Target 150-250 lines (max 300) for optimal results
4. Document 2-3 key architectural patterns with 5-10 line examples
5. Create anti-patterns table (6-8 project-specific items)
6. Write "When Working in This Repository" checklist (6-8 items)
7. Use decision tables instead of prose for guidelines
8. Time-box creation to 40 minutes total (10+10+15+5)

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
| AGENTS_TEMPLATE_V2.md | **Recommended:** Optimized meta-template with efficiency metrics | Creating any new AGENTS_*.md file |
| AGENTS_TEMPLATE.md | Original meta-template (V1) | Reference for comparison, use V2 for new templates |
| AGENTS_CLAUDE_MD_V2.md | **Recommended:** Optimized CLAUDE.md creation (50% faster) | Creating repository context for Claude Code |
| AGENTS_CLAUDE_MD.md | Original CLAUDE.md guidelines (V1) | Reference for comparison, use V2 for new files |
| AGENTS_COMMON.md | Cross-cutting patterns (error handling, security, performance, testing, observability) | When any template needs shared implementation patterns |
| AGENTS_ADR_RESEARCH.md | Research methodology for architectural decisions | Writing ADRs with proper research and analysis |
| TEMPLATE_V2_MIGRATION.md | V1 to V2 migration guide with optimization strategies | Converting existing templates to V2 |
| CONTRIBUTING.md | Contribution guidelines | Before adding new content |
| README.md | Repository overview | Understanding project scope |

## Template Specializations

Recent template enhancements include:

**AGENTS_PYTHON.md:**
- Async/await patterns with asyncio
- Dataclasses vs Pydantic decision guide
- Type checking with mypy (strict mode)
- Security patterns (pip-audit, input validation, SQL injection prevention)
- Edge cases (encoding, circular imports, large files)

**AGENTS_CLI.md:**
- Signal handling (SIGINT/SIGTERM) with cleanup
- Streaming and piping patterns
- Shell completion (argcomplete, click)
- Broken pipe handling

**AGENTS_WEBAPP.md:**
- SEO and meta tags (Next.js Metadata API, JSON-LD)
- Internationalization (next-intl, RTL support)
- Authentication patterns (JWT with jose, OAuth flow)
- PWA support (manifest, service worker, offline-first)

**AGENTS_ADR.md:**
- Domain classification (Development, Infrastructure, Data)
- Domain-specific sections (API contracts, capacity planning, data flow)
- Status lifecycle (Proposed, Accepted, Deprecated, Superseded)

**AGENTS_AIRTABLE.md:**
- Batch operations (create/update/delete in batches of 10)
- Rate limiting (5 requests/second per base)
- Formula query building with escaping
- Common automations (sync, cleanup, deduplication, export)

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

Templates include "See Also" sections linking related templates:

| Template | References |
|----------|------------|
| AGENTS_PYTHON.md | AGENTS_CLI.md, AGENTS_WEBAPP.md |
| AGENTS_CLI.md | AGENTS_PYTHON.md, AGENTS_README.md |
| AGENTS_WEBAPP.md | AGENTS_PYTHON.md, AGENTS_ADR.md |
| AGENTS_ADR.md | AGENTS_ADR_RESEARCH.md, AGENTS_TECH_RESEARCH.md |
| AGENTS_ADR_RESEARCH.md | AGENTS_ADR.md, AGENTS_TECH_RESEARCH.md |
| AGENTS_TECH_RESEARCH.md | AGENTS_ADR.md, AGENTS_ADR_RESEARCH.md |
| AGENTS_MACOS_BOOTSTRAP.md | AGENTS_CLI.md, AGENTS_PYTHON.md |
| AGENTS_AIRTABLE.md | AGENTS_PYTHON.md, AGENTS_CLI.md, AGENTS_COMMON.md |

All templates can reference AGENTS_COMMON.md for shared patterns (error handling, security, performance, testing, observability).

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
3. Review existing templates for patterns and overlaps (check for 50%+ overlap)
4. Follow the 5-phase process for new templates (Research → Question → Structure → Write → Validate)
5. Maintain consistency with existing templates
6. Add "See Also" cross-references to related templates
7. Reference AGENTS_COMMON.md for shared patterns instead of duplicating
8. Create example implementations for new templates
9. Update README.md and CLAUDE.md when adding templates
10. Keep examples simple and focused (under 100 lines, runnable)
