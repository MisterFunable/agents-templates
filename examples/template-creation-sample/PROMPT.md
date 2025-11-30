# Template Creation Example

This shows how to use `AGENTS_TEMPLATE.md` to create a new template.

## Example Request

> "Create an AGENTS.md template for REST API development following @AGENTS_TEMPLATE.md"

## Expected AI Response

The AI should follow the 5-phase process:

### Phase 1: Research

AI performs web searches:
```
- "REST API best practices 2024"
- "REST API project structure"
- "OpenAPI specification patterns"
- "popular REST API frameworks GitHub"
```

Extracts:
- Common structure patterns
- Standard tools (Express, FastAPI, Django REST)
- Anti-patterns (no versioning, poor error handling)

### Phase 2: Question

AI asks:
```
I'm creating AGENTS_API.md. Before I start:

**Scope:**
- Should this cover REST only, or include GraphQL?
- Include authentication patterns?
- Cover rate limiting and caching?

**Tools:**
- Language-specific or language-agnostic?
- Should I specify OpenAPI/Swagger for docs?

**Integration:**
- Should this reference AGENTS_PYTHON.md for Python APIs?

While you answer, I'll continue researching API design patterns.
```

### Phase 3: Structure

AI defines outline:
```
TEMPLATE: AGENTS_API.md

CORE SECTIONS:
1. Project Structure
2. Route Organization
3. Request/Response Handling
4. Error Handling
5. Authentication
6. Documentation

ANTI-PATTERNS:
- No API versioning
- Exposing internal errors
- Inconsistent response format
...

KEY DECISIONS:
- Versioning: URL path (/v1/)
- Format: JSON
- Auth: Bearer tokens
...
```

### Phase 4: Write

AI creates complete template with:
- Directory structure
- Code examples (5+)
- Anti-patterns table
- Quick reference
- Checklist

### Phase 5: Validate

AI checks:
```
✓ All required sections present
✓ 8 code examples included
✓ Anti-patterns table with 10 items
✓ Quick reference table
✓ 290 lines (within range)
✓ No conflicts with existing templates
✓ Hypothetical test passes
```

## What AGENTS_TEMPLATE.md Prevents

### Without the template:

**Problem 1: No research**
```markdown
# AGENTS_API.md

Use good API design principles.
Follow RESTful patterns.
Handle errors properly.
```
❌ Vague, no specifics

**Problem 2: Missing examples**
```markdown
## Error Handling

Always return appropriate HTTP status codes.
Include error messages in responses.
Log errors server-side.
```
❌ No code showing how

**Problem 3: No validation**
```markdown
(Creates 500-line template with redundant sections,
missing Quick Reference, no anti-patterns table)
```
❌ Incomplete structure

### With AGENTS_TEMPLATE.md:

**✓ Research-backed specifics**
```markdown
## Project Structure

Standard REST API layout:

```
api/
├── routes/          # URL endpoints
│   ├── v1/
│   │   ├── users.py
│   │   └── posts.py
├── controllers/     # Business logic
├── middleware/      # Auth, validation
└── tests/
```
```

**✓ Complete code examples**
```markdown
## Error Handling

Return consistent error format:

```python
from flask import jsonify

@app.errorhandler(404)
def not_found(error):
    return jsonify({
        'error': 'Not Found',
        'message': 'The requested resource does not exist',
        'status': 404
    }), 404

# Never expose internal errors
@app.errorhandler(500)
def server_error(error):
    logger.error(f"Internal error: {error}")
    return jsonify({
        'error': 'Internal Server Error',
        'message': 'An unexpected error occurred',
        'status': 500
    }), 500
```
```

**✓ Validated structure**
```
✓ Required sections
✓ Appropriate length
✓ Anti-patterns table
✓ Quick reference
✓ Code examples tested
```

## Key Benefits

| Without AGENTS_TEMPLATE.md | With AGENTS_TEMPLATE.md |
|----------------------------|-------------------------|
| Vague guidelines | Research-backed specifics |
| No examples | 5+ code examples |
| Inconsistent structure | Standard format |
| Missing anti-patterns | 8-12 anti-patterns documented |
| Unvalidated | Validation checklist |
| Conflicts possible | Cross-reference check |
| Long guessing process | Structured approach |

## Usage Pattern

```
User: "Create a template for [TOPIC]"
AI: Follows AGENTS_TEMPLATE.md phases
    1. Research [TOPIC] patterns
    2. Ask clarifying questions
    3. Structure template sections
    4. Write with examples
    5. Validate completeness
Result: High-quality, consistent template
```

## Common Questions

**Q: What if the AI skips questions?**
A: The template includes "Decision Rules When Questions Go Unanswered" - AI uses sensible defaults

**Q: How long should creation take?**
A: ~5-10 minutes with research, or single interaction if requirements are clear

**Q: Can AI create templates without AGENTS_TEMPLATE.md?**
A: Yes, but quality/consistency suffers. This template ensures thorough process.

---

This example demonstrates why AGENTS_TEMPLATE.md is essential for maintaining template quality and consistency.

