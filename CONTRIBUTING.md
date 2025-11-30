# Contributing to Agents Templates

Guidelines for adding new templates to this repository.

## Adding a New Template

> **Quick start:** Use `AGENTS_TEMPLATE.md` for step-by-step guidance on creating new templates, including research, validation, and common pitfalls.

**1. Name the file:** Use pattern `AGENTS_[TYPE].md` where TYPE describes the target (e.g., `AGENTS_API.md`, `AGENTS_MOBILE.md`)

**2. Follow this structure:**

```markdown
# AGENTS_[TYPE].md

Instructions for AI models working on [TYPE] projects.

## Project Structure
(Show standard directory layout)

## [Key Aspect 1]
(Guidelines with examples)

## [Key Aspect 2]
(More guidelines)

## Anti-Patterns
(Common mistakes in table format)

## Quick Reference
(Summary table)

## When Working on [TYPE] Projects
(Checklist of key practices)
```

**3. Required sections:**
- Project Structure (directory layout)
- Anti-Patterns table (Don't | Do format)
- Quick Reference table
- Practical examples (code snippets showing good practices)

**4. Writing style:**
- Direct commands ("Use X" not "You should use X")
- Tables over bullet lists for comparisons
- Code examples for every major concept
- One-line descriptions maximum
- No em dashes, no corporate language

**5. Content principles:**
- Actionable over theoretical
- Specific over vague
- Examples over explanations
- Constraints over flexibility

## Template Checklist

Before submitting a new template:

- [ ] File named `AGENTS_[TYPE].md`
- [ ] Contains Project Structure section
- [ ] Contains Anti-Patterns table
- [ ] Contains Quick Reference table
- [ ] At least 3 code examples
- [ ] All examples follow stated guidelines
- [ ] No emojis, no em dashes
- [ ] Tables used for options/comparisons
- [ ] Under 400 lines (aim for 250-300)
- [ ] Example implementation created in `examples/[type]-sample/`

## Adding Examples

**1. Create directory:** `examples/[type]-sample/`

**2. Include:**
- Working code demonstrating the template
- README.md following AGENTS_README.md guidelines
- Any necessary config files

**3. Keep examples:**
- Under 100 lines of code
- Focused on one concept
- Actually runnable
- Well-commented at key points

## Testing Your Template

**1. Use it yourself:** Build a small project following only your template

**2. Check for ambiguity:** Every rule should have one clear interpretation

**3. Verify completeness:** Can someone build a project from scratch using only your template?

**4. Test with AI:** Ask an AI to generate code following your template

## Length Guidelines

| Section | Target Lines |
|---------|-------------|
| Project Structure | 20-30 |
| Main sections | 30-50 each |
| Anti-Patterns | 10-20 |
| Quick Reference | 10-15 |
| Total | 250-300 |

## Common Mistakes

| Don't | Do |
|-------|-----|
| Write essays | Write concise rules |
| Explain why (philosophy) | Show how (examples) |
| Add every edge case | Cover 90% use cases |
| Use vague terms ("clean code") | Use specific patterns |
| Create rigid rules | Provide clear defaults with flexibility |

## Template Ideas

Potential templates to add:

- `AGENTS_API.md` - REST API design and structure
- `AGENTS_MOBILE.md` - Mobile app development
- `AGENTS_DATABASE.md` - Database schema and queries
- `AGENTS_DEVOPS.md` - Deployment and infrastructure
- `AGENTS_TESTING.md` - Test structure and patterns
- `AGENTS_DOCS.md` - Documentation writing
- `AGENTS_REFACTOR.md` - Code refactoring guidelines
- `AGENTS_FICTION.md` - Short story and fiction writing
- `AGENTS_ESSAY.md` - Essay and article writing

## Questions?

Open an issue with:
- Template type you want to add
- What problem it solves
- Why existing templates don't cover it

Keep templates focused. If your template overlaps 50% with an existing one, consider adding a section to the existing template instead.

