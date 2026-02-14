# AGENTS_TEMPLATE_V2.md

Optimized instructions for AI models creating AGENTS_*.md template files.

**Version 2 improvements:**
- Reduced verbosity without losing effectiveness
- Built-in efficiency metrics
- Decision tables over prose explanations
- Clearer mandatory vs optional guidance

## Template Purpose

AGENTS_*.md files guide AI models to follow consistent patterns when building projects. They encode domain expertise as actionable instructions.

**Core principle:** Maximum effectiveness in minimum lines.

**Target metrics:**
- Length: 250-350 lines (hard max: 400)
- Examples: 1-2 per major concept (not 4-6)
- Read time: <10 minutes
- AI processing: <1 second per lookup

## Mandatory Template Structure

Every template MUST include these 6 sections:

```markdown
# AGENTS_[TYPE].md

## [Domain] Structure
[Directory tree + brief annotations]

## Core [Domain] Patterns (2-4 subsections)
[Key concepts with 1 example each]

## Anti-Patterns
[Don't | Do table: 6-10 items]

## Quick Reference
[Aspect | Standard table]

## When Working on [TYPE] Projects
[Checklist: 5-10 essential practices]

## See Also
[Links to 2-4 related templates]
```

**Section order is mandatory.** This creates consistency across all templates.

## Section Guidelines

### 1. Project Structure Section

**Format:**

```
[project-name]/
├── [dir]/          # [1-3 word purpose]
├── [dir]/          # [1-3 word purpose]
└── [dir]/          # [1-3 word purpose]
```

**Rules:**

| Do | Don't |
|----|-------|
| Show 2-3 levels max | Deep nesting (4+ levels) |
| Annotate non-obvious directories | Explain standard dirs (tests/) |
| Keep annotations to 1-5 words | Write full sentences as annotations |
| Include 6-12 directories total | Show every directory or too few |

**Example:**

```markdown
## Python Project Structure

```
project-name/
├── src/
│   ├── core/       # Business logic
│   ├── api/        # HTTP endpoints
│   └── db/         # Database layer
├── tests/
│   ├── unit/       # Fast, isolated
│   └── integration/# With real dependencies
└── docs/           # Architecture decisions
```
```

### 2. Core Patterns Section

**Structure: 2-4 subsections, each with 1 example**

```markdown
## Core [Domain] Patterns

### Pattern Name

[2-3 sentences explaining the pattern]

```[language]
# [1-line description of example]
[5-15 lines of code]
```

[Optional: 1 sentence about when to use or not use]
```

**Efficiency rules:**

- **One example per concept** (not multiple variants)
- **5-15 lines of code** (not 30-50 line functions)
- **Show, don't explain** (code > prose)
- **Reference, don't duplicate** (link to AGENTS_COMMON.md for shared patterns)

**Good example:**

```markdown
### Error Handling

Raise specific exceptions, catch at boundaries.

```python
# Service layer - raise specific errors
def get_user(user_id: str) -> User:
    if not user_id:
        raise ValueError("user_id required")
    user = db.get(user_id)
    if not user:
        raise NotFoundError(f"User {user_id} not found")
    return user

# API layer - catch and format
@app.get("/users/{user_id}")
def get_user_endpoint(user_id: str):
    try:
        return get_user(user_id)
    except NotFoundError as e:
        return {"error": str(e)}, 404
```

Services raise, APIs catch and format responses.
```

**Bad example (too verbose):**

```markdown
### Error Handling

Error handling is crucial in any application. You should use exceptions to signal
errors and handle them at appropriate boundaries. Let me show you several approaches:

**Approach 1: Simple exceptions**

```python
def get_user(user_id):
    if not user_id:
        raise ValueError("user_id is required")
```

**Approach 2: Custom exceptions**

```python
class UserNotFoundError(Exception):
    pass

def get_user(user_id):
    user = db.query(...)
    if not user:
        raise UserNotFoundError(f"User {user_id} not found")
```

**Approach 3: Error codes**

```python
class AppError(Exception):
    def __init__(self, message, code):
        self.message = message
        self.code = code

def get_user(user_id):
    # ... implementation
```

You can choose any of these approaches based on your needs. The key is consistency.
```

**Problem:** 3 examples for same concept, vague guidance ("choose based on needs").

### 3. Anti-Patterns Section

**Format: Don't | Do table**

```markdown
## Anti-Patterns

| Don't | Do |
|-------|-----|
| [Specific bad practice] | [Specific good practice] |
| [Specific bad practice] | [Specific good practice] |
...
```

**Guidelines:**

- **6-10 items** (not 12-15)
- **Domain-specific** (not generic programming advice)
- **Actionable** ("Use X" not "avoid bad practices")
- **Concrete** ("Use snake_case" not "use good naming")

**Good examples:**

```markdown
| Don't | Do |
|-------|-----|
| Use `dict` for configuration | Use Pydantic `BaseSettings` with validation |
| Call database from templates | Pass data via context in views |
| Catch all exceptions silently | Catch specific exceptions, log or re-raise |
| Store secrets in code | Use environment variables or secret managers |
```

**Bad examples (too generic):**

```markdown
| Don't | Do |
|-------|-----|
| Write bad code | Write good code |
| Make mistakes | Be careful |
| Use outdated practices | Use modern approaches |
| Ignore best practices | Follow best practices |
```

### 4. Quick Reference Section

**Format: Aspect | Standard table**

```markdown
## Quick Reference

| Aspect | Standard |
|--------|----------|
| [Decision point] | [Specific choice] |
| [Tool/framework] | [Which one and why] |
...
```

**Purpose:** Fast lookups for common decisions.

**Include:**

- Technology choices (framework, library)
- File organization patterns
- Naming conventions
- Tool configuration

**Limit to 8-12 rows.** More indicates template is trying to cover too much.

**Example:**

```markdown
| Aspect | Standard |
|--------|----------|
| Package manager | Poetry for dependency management |
| Code formatting | black + isort + ruff |
| Type checking | mypy in strict mode |
| Testing | pytest with coverage >80% |
| Async I/O | asyncio + aiohttp for concurrent requests |
| Configuration | Pydantic Settings with .env |
| Secrets | Environment variables, never in code |
| Error handling | Raise at source, catch at boundaries |
```

### 5. When Working Checklist

**Format: Numbered list, 5-10 items**

```markdown
## When Working on [TYPE] Projects

1. [Most critical practice]
2. [Second most critical practice]
...
10. [Tenth most critical practice]
```

**Guidelines:**

- **Prioritize** (most important first)
- **Be specific** ("Run black before committing" not "format code")
- **Actionable** (can be checked off)
- **Avoid obvious** ("Write tests" is too generic)

**Good example:**

```markdown
## When Working on Python Projects

1. Create virtual environment with `python -m venv .venv` before installing
2. Use Pydantic `BaseSettings` for configuration with `.env` file
3. Type hint all function signatures and enable mypy strict mode
4. Separate business logic (core/) from infrastructure (api/, db/)
5. Use `logging` module (not print) with structured logs
6. Handle errors at boundaries: services raise, APIs catch
7. Run `black . && isort . && ruff check` before committing
8. Keep functions under 20 lines; extract helpers if longer
9. Use async/await for I/O-bound operations (API calls, file reads)
10. Reference AGENTS_COMMON.md for error handling and security patterns
```

### 6. See Also Section

**Format: Bullet list with brief context**

```markdown
## See Also

- AGENTS_[RELATED].md for [what aspect]
- AGENTS_COMMON.md for [which shared patterns]
```

**Rules:**

- **Link 2-4 related templates** (not 6+)
- **Explain the connection** ("for API patterns" not just link)
- **Always reference AGENTS_COMMON.md** if using shared patterns

## Template Creation Process (Streamlined)

### Phase 1: Scope (5 minutes)

**Answer these questions:**

| Question | Purpose |
|----------|---------|
| What domain? | Defines template boundaries |
| What problems does it solve? | Ensures usefulness |
| Which templates overlap? | Prevents duplication |
| Target length? | 250-350 lines (max 400) |

**Output:** 1-paragraph scope definition

### Phase 2: Research (20 minutes)

**Research checklist:**

- [ ] Official documentation for primary tool/framework
- [ ] 3-5 production examples (GitHub, blog posts)
- [ ] 2-3 "lessons learned" articles or postmortems
- [ ] Common mistakes (Stack Overflow, Reddit)
- [ ] Related template patterns (read 2-3 AGENTS_*.md files)

**Stop researching after 20 minutes.** More research = diminishing returns.

### Phase 3: Structure (5 minutes)

**Create outline before writing:**

```markdown
# AGENTS_[TYPE].md

## [Type] Project Structure
- [List 2-3 subsections needed]

## Core [Type] Patterns
### [Pattern 1 name]
### [Pattern 2 name]
### [Pattern 3 name]

## Anti-Patterns
- [List 6-10 Don't/Do pairs]

## Quick Reference
- [List 8-12 Aspect/Standard pairs]

## When Working on [Type] Projects
- [List 5-10 checklist items]

## See Also
- [List 2-4 related templates]
```

**Validate outline:**

- [ ] 6 required sections present
- [ ] 2-4 core pattern subsections planned
- [ ] Anti-patterns are domain-specific (not generic)
- [ ] Estimated length: 250-350 lines

### Phase 4: Write (30 minutes)

**Write sections in order:**

1. Project Structure (10 lines)
2. Core Patterns (80-150 lines total)
3. Anti-Patterns (40-60 lines)
4. Quick Reference (20-30 lines)
5. Checklist (15-25 lines)
6. See Also (10 lines)

**Writing rules:**

| Rule | Rationale |
|------|-----------|
| One example per concept | Reduces bloat |
| 5-15 lines of code max | Keeps examples scannable |
| Tables for comparisons | Faster for AI to parse |
| Imperative voice | "Use X" not "You should use X" |
| Reference shared patterns | Link to AGENTS_COMMON.md instead of duplicating |

**Time box:** If section takes >10 minutes, it's too detailed. Simplify.

### Phase 5: Validate (5 minutes)

**Validation checklist:**

- [ ] All 6 required sections present
- [ ] Total length: 250-350 lines (max 400)
- [ ] Examples are 5-15 lines each
- [ ] Anti-patterns are specific, not generic
- [ ] Quick Reference has 8-12 items
- [ ] Checklist has 5-10 items
- [ ] Cross-references 2-4 related templates
- [ ] No duplication of AGENTS_COMMON.md content
- [ ] Code examples have 1-line description comments
- [ ] Read time: <10 minutes

**If validation fails:** Revise before finalizing.

## Efficiency Metrics

Track these metrics to ensure template effectiveness:

| Metric | Target | Red Flag |
|--------|--------|----------|
| Total lines | 250-350 | >400 lines |
| Lines per example | 5-15 | >20 lines |
| Examples per concept | 1-2 | 3+ examples |
| Core pattern subsections | 2-4 | >5 subsections |
| Anti-pattern items | 6-10 | >12 items |
| Quick Reference items | 8-12 | >15 items |
| Checklist items | 5-10 | >12 items |
| Cross-references | 2-4 | >5 references |
| Read time | <10 min | >15 minutes |

**If any metric is in "Red Flag" range:** Refactor for conciseness.

## Cross-Reference Strategy

**When to reference AGENTS_COMMON.md:**

- Error handling patterns
- Security best practices (input validation, secrets)
- Performance optimization (caching, profiling)
- Testing patterns (unit/integration/E2E)
- Observability (logging, metrics, health checks)

**When to reference domain templates:**

- AGENTS_PYTHON.md for Python-specific code
- AGENTS_CLI.md for CLI tool patterns
- AGENTS_WEBAPP.md for web application patterns
- AGENTS_ADR.md for architectural decisions

**How to reference:**

```markdown
## Error Handling

For general error handling patterns, see AGENTS_COMMON.md lines 8-89.

[Domain]-specific error handling:

```[language]
# [Specific example for this domain]
```
```

## Decision Tables Over Prose

**Use tables for:**

- Comparisons ("When to use X vs Y")
- Decision points ("If condition A, use B")
- Tool selection ("Choose X if...")
- Anti-patterns (Don't | Do)
- Quick references (Aspect | Standard)

**Good - decision table:**

```markdown
| Use | When | Why |
|-----|------|-----|
| SQLite | <100K records, single user | Embedded, zero config |
| PostgreSQL | Multi-user, >100K records | Robust, concurrent |
| DynamoDB | Serverless, <10ms latency | Managed, scales automatically |
```

**Bad - prose explanation:**

```
You should consider SQLite for smaller applications with fewer than 100K records, especially if you only have a single user. SQLite is embedded and requires zero configuration, making it ideal for simple use cases.

For multi-user applications with more than 100K records, PostgreSQL is recommended because it handles concurrency well and is very robust.

If you're building a serverless application and need sub-10ms latency, DynamoDB is a good choice since it's fully managed and scales automatically.
```

**Result:** Table is 5 lines vs 6 lines of prose, but table is scannable in 2 seconds vs 30 seconds for prose.

## Template-Specific Optimizations

### For Code-Heavy Domains (Python, CLI, WebApp)

**Optimize by:**

- Show 1 complete example, pseudocode for variants
- Link to external docs for edge cases
- Use inline comments instead of separate explanations

**Before (verbose):**

```markdown
### Async Patterns

When working with async code, you can use several patterns:

**Pattern 1: Single async call**

```python
async def fetch_data():
    async with aiohttp.ClientSession() as session:
        async with session.get(url) as response:
            return await response.json()
```

**Pattern 2: Multiple concurrent calls**

```python
async def fetch_all(urls):
    async with aiohttp.ClientSession() as session:
        tasks = [fetch_one(session, url) for url in urls]
        return await asyncio.gather(*tasks)

async def fetch_one(session, url):
    async with session.get(url) as response:
        return await response.json()
```

**Pattern 3: With error handling**

[... another 15 lines]
```

**After (optimized):**

```markdown
### Async Patterns

```python
# Concurrent requests with asyncio
async def fetch_all(urls: list[str]) -> list[dict]:
    async with aiohttp.ClientSession() as session:
        tasks = [session.get(url) for url in urls]
        responses = await asyncio.gather(*tasks, return_exceptions=True)
        return [await r.json() for r in responses if not isinstance(r, Exception)]

# For single requests, remove gather and use session.get(url) directly
```

For error handling patterns, see AGENTS_COMMON.md lines 45-89.
```

**Savings:** 35+ lines → 12 lines

### For Configuration-Heavy Domains (macOS, Airtable, Infrastructure)

**Optimize by:**

- Show 1-2 examples, reference full config externally
- Use tables for option lists instead of showing every option
- Link to vendor documentation for comprehensive settings

**Before (verbose):**

```markdown
### Spotlight Configuration

You can configure Spotlight categories:

```python
SPOTLIGHT_CATEGORIES = {
    "APPLICATIONS": {"enabled": True, "name": "Applications"},
    "SYSTEM_PREFERENCES": {"enabled": True, "name": "System Preferences"},
    "DIRECTORIES": {"enabled": True, "name": "Folders"},
    "PDF": {"enabled": True, "name": "PDF Documents"},
    "FONTS": {"enabled": False, "name": "Fonts"},
    "MUSIC": {"enabled": True, "name": "Music"},
    "MOVIES": {"enabled": True, "name": "Movies"},
    # ... 12 more categories
}
```
```

**After (optimized):**

```markdown
### Spotlight Configuration

```python
# Configure Spotlight categories (example shows 3, see full list in reference)
SPOTLIGHT_CATEGORIES = {
    "APPLICATIONS": True,
    "PDF": True,
    "FONTS": False,  # Disable to reduce indexing load
    # Full category list: https://developer.apple.com/library/spotlight/
}
```
```

**Savings:** 25+ lines → 8 lines

## Anti-Patterns in Template Creation

| Don't | Do |
|-------|-----|
| Show 4-6 examples per concept | Show 1-2 examples, link for more |
| Duplicate AGENTS_COMMON.md content | Reference common patterns with line numbers |
| Write prose explanations | Use tables and code comments |
| Include optional edge cases | Note edge cases exist, link to docs |
| Explain every code line | Use inline comments for non-obvious parts |
| List every possible tool/option | Show standard choice, note alternatives exist |
| Create templates >400 lines | Target 250-350, max 400 |
| Write before structuring | Create outline first (Phase 3) |
| Skip validation checklist | Check all 10 validation items |
| Research for hours | Time-box research to 20 minutes |

## Quick Reference

| Aspect | Standard |
|--------|----------|
| Target length | 250-350 lines (max 400) |
| Required sections | 6 (Structure, Patterns, Anti-Patterns, Reference, Checklist, See Also) |
| Examples per concept | 1-2 (not 4-6) |
| Example code length | 5-15 lines |
| Anti-pattern items | 6-10 |
| Quick Reference items | 8-12 |
| Checklist items | 5-10 |
| Cross-references | 2-4 related templates |
| Creation time | ~65 minutes (5+20+5+30+5) |
| Read time target | <10 minutes |

## When Creating Templates

1. Define scope in 1 paragraph (5 min)
2. Research for 20 minutes maximum (time-boxed)
3. Create outline with all 6 required sections (5 min)
4. Write sections in order with 1 example per concept (30 min)
5. Use tables for all comparisons and decisions
6. Reference AGENTS_COMMON.md instead of duplicating
7. Keep examples to 5-15 lines of code
8. Validate against 10-item checklist (5 min)
9. Check efficiency metrics (all targets met?)
10. If >400 lines or >15 min read time: simplify before finalizing

## See Also

- AGENTS_COMMON.md for shared patterns (error handling, security, performance, testing)
- AGENTS_CLAUDE_MD.md for creating repository-specific guidance
- CONTRIBUTING.md for repository-wide contribution guidelines
