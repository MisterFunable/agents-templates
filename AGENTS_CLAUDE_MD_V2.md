# AGENTS_CLAUDE_MD_V2.md

**Optimized instructions for creating CLAUDE.md files that maximize AI performance.**

CLAUDE.md provides project context to Claude Code. It encodes architecture, conventions, and workflows to eliminate repetitive explanations.

**Target: 150-250 lines** (max 300)

## CLAUDE.md Structure

Required 8 sections (in order):

```markdown
# CLAUDE.md

## Repository Overview
[2-3 sentences: type, purpose, key tech]

## Repository Structure
[Tree with 2-level depth, 3-5 key directories annotated]

## Core Architecture
[2-3 patterns with 5-10 line examples]

## Common Development Tasks
[3-5 tasks: multi-step only, skip single commands]

## Key Files to Understand
[Table: 5-8 critical files]

## Anti-Patterns
[Don't | Do table: 6-8 project-specific items]

## Quick Reference
[Decisions table: 8-10 items]

## When Working in This Repository
[Checklist: 6-8 essential practices]
```

## Section Guidelines

### 1. Repository Overview (3-5 lines)

**Format:**

```markdown
[Project] is a [type] that [purpose]. Built with [key tech]. [Architecture approach].
```

**Example:**

```markdown
TaskSync is a Python CLI that syncs Jira to Airtable for reporting. Built with Click, pyairtable, and jira-python. Uses OAuth 2.0 with token refresh.
```

**Include:** Type, purpose, 2-3 key technologies, architecture approach (if notable).

**Exclude:** History, team size, vague descriptions ("many features").

---

### 2. Repository Structure (10-15 lines)

**Format: 2-level tree + critical files**

```markdown
## Repository Structure

```
app/
├── src/
│   ├── core/       # Business logic
│   ├── api/        # HTTP endpoints
│   └── db/         # Database layer
├── tests/
└── k8s/            # Kubernetes manifests
```

**Critical files:**
- `src/core/processor.py`: Main orchestration (line 45-120)
- `src/db/schema.sql`: Authoritative schema
```

**Decision guide:**

| Show | Skip |
|------|------|
| Non-obvious directories | Standard dirs (tests/, docs/) |
| Entry points | Generated files |
| 5-8 directories max | Full tree |

---

### 3. Core Architecture (20-30 lines)

**Format: 2-3 patterns, 5-10 line examples**

```markdown
## Core Architecture

### Domain Model

```python
class Task(BaseModel):
    id: str
    status: TaskStatus  # Enum: PENDING, IN_PROGRESS, DONE

    def update(self, **kwargs) -> "Task":
        # Immutable pattern
```

Immutable models. Use `.update()` for changes.

### Service Layer

```python
class TaskService:
    def __init__(self, db: Database):  # DI via constructor
        self.db = db
```

Pattern: Dependency injection, no global state.
```

**Decision guide:**

| Use | When |
|-----|------|
| 1 example | Concept is clear |
| 2 examples | Need contrast (before/after) |
| Link to file | Example >10 lines |

---

### 4. Common Development Tasks (15-25 lines)

**Format: Task → Steps (3-5 tasks)**

```markdown
## Common Development Tasks

### Add API Endpoint

1. Route: `src/api/routes.py` → `@app.post("/tasks")`
2. Handler: `src/api/handlers.py` → implement logic
3. Schema: `src/api/schemas.py` → Pydantic models
4. Test: `tests/integration/test_api.py`

### Run Database Migration

```bash
alembic revision -m "add_users"  # Create
alembic upgrade head              # Apply
```
```

**Decision guide:**

| Include | Exclude |
|---------|---------|
| Multi-step workflows | Single commands (put in Quick Reference) |
| Done weekly+ | One-time setup |
| Non-obvious | Standard dev (git commit, pytest) |

---

### 5. Key Files (8-12 lines)

**Format: Table with 5-8 files**

```markdown
## Key Files to Understand

| File | Purpose | When to Reference |
|------|---------|-------------------|
| src/core/processor.py | Main orchestration | Adding features |
| src/db/schema.sql | Authoritative schema | Data model changes |
| config/settings.py | Validated config | Environment variables |
| tests/conftest.py | Test fixtures | Writing tests |
```

**Selection criteria:**

| Include | Reasoning |
|---------|-----------|
| Changed in >50% of PRs | High-touch files |
| Not obvious from name | `processor.py` not `main.py` |
| Defines patterns | Architecture files |
| Authoritative source | `schema.sql` not ORM models |

**Limit: 5-8 files.** More = unclear architecture.

---

### 6. Anti-Patterns (10-15 lines)

**Format: Don't | Do table (6-8 items)**

```markdown
## Anti-Patterns

| Don't | Do |
|-------|-----|
| Modify `Task` directly | Use `Task.update()` |
| Import `src.db` in templates | Use `src.api.schemas` |
| Catch all exceptions | Raise `AppError`, catch at boundary |
| Store secrets in code | Use `.env` (gitignored) |
| Print for debugging | Use `logger.debug()` |
```

**Decision guide:**

| Include | Exclude |
|---------|---------|
| Project-specific | Generic advice ("write tests") |
| Bypasses architecture | Language basics ("use types") |
| New contributor mistakes | Covered in AGENTS templates |

---

### 7. Quick Reference (10-15 lines)

**Format: Decisions table (8-10 items)**

```markdown
## Quick Reference

| Aspect | Standard |
|--------|----------|
| Python version | 3.11+ |
| Test runner | pytest |
| Database | PostgreSQL 15 + SQLAlchemy 2.0 |
| API framework | FastAPI + Pydantic v2 |
| Auth | OAuth 2.0 + JWT (jose) |
| Config | .env → python-dotenv |
| Formatting | black + isort + ruff |
```

**Categories:**

- Versions (when specific version matters)
- Tools (test runner, formatter)
- Architectural decisions (REST vs GraphQL)
- External services (auth provider)

---

### 8. Checklist (8-12 lines)

**Format: 6-8 essential practices**

```markdown
## When Working in This Repository

1. Run `make setup` after pulling (sync deps + DB)
2. Use feature branches, never commit to `main`
3. Update `schema.sql` when changing models (authoritative)
4. Run `make lint` before committing
5. Add integration test for API changes
6. Use `logger.debug()` not `print()`
```

**Prioritize:**

| Include | Exclude |
|---------|---------|
| Prevents common failures | Obvious ("write clean code") |
| Non-obvious workflows | Team handbook content |
| Saves time | Language advice |

---

## Creation Process (Streamlined)

### Phase 1: Analysis (10 min)

**Read:**
1. README.md (purpose, tech stack)
2. Entry point (app.py, main.py, index.ts)
3. Directory tree (`tree -L 2`)
4. Dependencies (requirements.txt, package.json)

**Search patterns:**

```bash
rg "class.*Error" --type py    # Error handling
rg "def.*Service"              # Service layer
rg "@app\.(get|post)"          # Routes
```

**Identify:**
- Language + framework
- Key directories
- Testing approach
- Configuration method

---

### Phase 2: Pattern Discovery (10 min)

**Git history:**

```bash
git log --oneline -20
git show HEAD~5..HEAD --name-only
```

**Look for:**
- Frequently changed files → Key Files section
- Commit patterns → Anti-Patterns
- File correlations (model + test)

**PR reviews:**
- Review comments → Anti-Patterns
- "Fix" commits → Common mistakes

---

### Phase 3: Write (15 min)

**Order:**
1. Overview (requires understanding)
2. Structure (from tree command)
3. Architecture (from code search)
4. Tasks (from git history)
5. Key Files (from git stats)
6. Anti-Patterns (from PRs)
7. Quick Reference (from code)
8. Checklist (distill above)

**Time each section:** 1-2 minutes max. If longer, simplify.

---

### Phase 4: Validate (5 min)

**Checklist:**

- [ ] Overview: 2-3 sentences, clear type/purpose/tech
- [ ] Structure: 2 levels, 5-8 directories annotated
- [ ] Architecture: 2-3 patterns with examples
- [ ] Tasks: 3-5 multi-step workflows
- [ ] Key Files: 5-8 critical files
- [ ] Anti-Patterns: 6-8 project-specific items
- [ ] Quick Reference: 8-10 decision items
- [ ] Checklist: 6-8 essential practices
- [ ] Length: 150-250 lines (max 300)
- [ ] No README duplication

---

## Domain Quick Patterns

### Web Apps

```markdown
## API Conventions
Endpoints: `/api/v1/resource`
Auth: JWT in `Authorization: Bearer <token>`
Errors: `{"error": "CODE", "message": "...", "timestamp": "..."}`
```

### CLI Tools

```markdown
## CLI Structure
Pattern: `app [global-opts] command [args]`
Options: `--config`, `--verbose`, `--format json|text`
```

### Libraries

```markdown
## Public API
Stable: `Client()`, `process()`, `exceptions.py`
Internal: `_private()`, `utils/`
Deprecation: `warnings.warn()` → remove after 2 versions
```

### Data Pipelines

```markdown
## Pipeline
Stages: Extract → Transform → Load
Idempotency: Use `upsert` not `insert`
Resume: `--resume-from=transform`
```

---

## Anti-Patterns

| Don't | Do |
|-------|-----|
| Duplicate README content | Add internal details, reference README |
| Explain language basics | Explain project patterns |
| Show >15 line examples | Link to file with line numbers |
| Document every file | Document 5-8 critical files only |
| Write generic advice | Write project-specific workflows |
| Skip repository analysis | Complete Phases 1-2 first |
| Exceed 300 lines | Target 150-250, max 300 |
| Use passive voice | Use imperative ("Use X") |

---

## Quick Reference

| Aspect | Standard |
|--------|----------|
| Target length | 150-250 lines (max 300) |
| Required sections | 8 (in specific order) |
| Code examples | 5-10 lines max |
| Key files | 5-8 files |
| Anti-patterns | 6-8 items |
| Quick reference | 8-10 items |
| Checklist | 6-8 items |
| Update frequency | After architecture changes |
| Creation time | ~40 minutes (10+10+15+5) |
| File location | Repository root |

---

## When Creating CLAUDE.md Files

1. Run repository analysis: README, tree, dependencies, git log
2. Search code patterns: errors, services, routes, config
3. Review git history: frequent files, commit patterns, PR reviews
4. Write 8 sections in order (Overview → Checklist)
5. Keep examples 5-10 lines, link if longer
6. Focus on project-specific patterns, not language basics
7. Validate: 10-item checklist, target 150-250 lines
8. Update after major architectural changes

---

## Efficiency Metrics

| Metric | V1 | V2 | Improvement |
|--------|----|----|-------------|
| Target length | 150-400 lines | 150-250 lines | 38% shorter |
| Creation time | 60+ min | 40 min | 33% faster |
| Examples per pattern | 2-3 (Good/Bad) | 1 | 67% reduction |
| Process phases | 5 detailed | 4 streamlined | 20% faster |
| Domain patterns | 4 full sections | Quick reference | 75% shorter |
| Read time | 12 min | 6 min | 50% faster |

---

## See Also

- AGENTS_README.md for public documentation
- AGENTS_ADR.md for architectural decisions
- AGENTS_TEMPLATE_V2.md for creating templates
