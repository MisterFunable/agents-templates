# AGENTS_CLAUDE_MD.md

Instructions for AI models creating CLAUDE.md files for code repositories.

CLAUDE.md files provide context to Claude Code (claude.ai/code) when working in a repository. Think of them as project onboarding documents that explain architecture, conventions, and common tasks.

## Purpose of CLAUDE.md

CLAUDE.md files serve three functions:

1. **Orientation**: Help Claude understand the codebase structure and purpose
2. **Conventions**: Document patterns, standards, and decisions specific to this project
3. **Efficiency**: Reduce repetitive explanations by encoding common workflows

**Target length**: 150-300 lines (max 400)

**Update frequency**: After significant architectural changes or when team patterns evolve

## CLAUDE.md Structure

Every CLAUDE.md follows this structure:

```markdown
# CLAUDE.md

## Repository Overview
[1-3 sentences: what this project does]

## Repository Structure
[Directory tree with annotations]

## Core Architecture
[Key architectural patterns, 3-5 subsections]

## Common Development Tasks
[4-8 frequent workflows with steps]

## Key Files to Understand
[Table of critical files with purpose and when to reference]

## Anti-Patterns
[Don't | Do table with 5-8 project-specific mistakes]

## Quick Reference
[Table of common commands, patterns, or decisions]

## When Working in This Repository
[Checklist of 5-10 essential practices]
```

## Repository Overview Section

**Template:**

```markdown
## Repository Overview

[Project name] is a [type: web app, CLI tool, library, service] that [primary purpose].

[1-2 sentences about key technologies or architecture approach]

[Optional: Link to main documentation if extensive]
```

**Good example:**

```markdown
## Repository Overview

TaskFlow is a Python CLI tool that syncs Jira tickets to Airtable for reporting.

Built with Click for CLI, pyairtable for Airtable API, and jira-python for Jira integration.
Uses OAuth 2.0 for authentication with token refresh handling.
```

**Bad example:**

```markdown
## Repository Overview

This is a project we built to solve problems in our workflow. It has many features
and uses various technologies. We've been working on it for 6 months and it's still
evolving. See the README for more details.
```

## Repository Structure Section

**Format: Tree + annotations**

```markdown
## Repository Structure

```
project-name/
├── src/
│   ├── core/           # Business logic (no I/O)
│   ├── api/            # HTTP endpoints
│   ├── db/             # Database models and queries
│   └── utils/          # Shared helpers
├── tests/
│   ├── unit/           # Fast, isolated tests
│   └── integration/    # Tests with real dependencies
├── config/             # Environment-specific settings
└── docs/               # Architecture docs
```

**Key files:**
- `src/core/processor.py`: Main workflow orchestration
- `src/db/schema.sql`: Database schema (authoritative)
```

**Guidelines:**

| Do | Don't |
|----|-------|
| Annotate non-obvious directories | Explain standard directories (tests/, docs/) |
| Highlight entry points | List every file |
| Note authoritative sources | Include generated files |
| Keep tree to 2-3 levels deep | Show full directory tree |

## Core Architecture Section

**Structure: 3-5 key concepts with brief explanation + example**

```markdown
## Core Architecture

### Domain Model

All business entities inherit from `BaseModel`:

```python
class Task(BaseModel):
    id: str
    title: str
    status: TaskStatus  # Enum: PENDING, IN_PROGRESS, DONE
```

Models are immutable after creation. Use `Task.update(status=...)` for changes.

### Service Layer

Services handle business logic and external calls:

```python
class TaskService:
    def __init__(self, db: Database, jira: JiraClient):
        self.db = db
        self.jira = jira

    def sync_task(self, task_id: str) -> Task:
        # Fetch from Jira, update local DB, return Task
```

Pattern: Dependency injection via constructor, no global state.

### Error Handling

All errors inherit from `AppError` with error codes:

```python
class TaskNotFoundError(AppError):
    code = "TASK_NOT_FOUND"
    status = 404
```

Services raise errors, API layer catches and formats responses.
```

**Principles:**

- Each subsection: 1 concept + 1 code example
- Code examples: 5-10 lines maximum
- Explain **why** the pattern exists, not just **what** it is
- Link to fuller documentation if >10 lines needed

## Common Development Tasks Section

**Format: Task → Steps**

```markdown
## Common Development Tasks

### Adding a New API Endpoint

1. Define route in `src/api/routes.py`:
   ```python
   @app.post("/tasks")
   async def create_task(task: TaskCreate) -> TaskResponse:
   ```
2. Implement handler in `src/api/handlers.py`
3. Add Pydantic models to `src/api/schemas.py`
4. Write integration test in `tests/integration/test_api.py`
5. Update OpenAPI docs: `make generate-openapi`

### Running Database Migrations

```bash
# Create migration
alembic revision -m "add_user_table"

# Edit migration in migrations/versions/[hash].py
# Run migration
alembic upgrade head
```

### Debugging Authentication Issues

1. Check token validity: `python -m src.utils.verify_token <token>`
2. Inspect OAuth flow logs: `tail -f logs/oauth.log`
3. Verify credentials in `.env` match OAuth app settings
4. Test with curl: `curl -H "Authorization: Bearer <token>" http://localhost:8000/health`
```

**Guidelines:**

| Include | Exclude |
|---------|---------|
| Tasks done weekly or more | One-time setup tasks |
| Multi-step workflows | Single command tasks (use Quick Reference) |
| Non-obvious sequences | Standard development (git commit, run tests) |
| Debugging workflows | General programming knowledge |

## Key Files to Understand Section

**Format: Table**

```markdown
## Key Files to Understand

| File | Purpose | When to Reference |
|------|---------|-------------------|
| src/core/processor.py | Main sync orchestration | Adding new sync sources |
| src/db/schema.sql | Database schema (authoritative) | Modifying data models |
| config/settings.py | Configuration with validation | Adding new environment variables |
| src/api/middleware.py | Auth, logging, error handling | Debugging request issues |
| tests/conftest.py | Shared test fixtures | Writing new tests |
```

**Criteria for inclusion:**

- Files touched in >50% of changes
- Files that aren't obvious from name
- Files that define critical patterns
- Files that are authoritative (schema.sql not ORM models)

**Limit to 5-10 files.** More than 10 indicates unclear architecture.

## Anti-Patterns Section

**Format: Don't | Do table with project-specific mistakes**

```markdown
## Anti-Patterns

| Don't | Do |
|-------|-----|
| Modify Task objects directly | Use `Task.update()` method |
| Import from `src.db` in templates | Use view models from `src.api.schemas` |
| Catch all exceptions in services | Raise `AppError` subclasses, catch in API layer |
| Store secrets in code or git | Use environment variables in `.env` (gitignored) |
| Make database calls from templates | Pass data via context, query in view |
| Skip transaction for multi-step DB ops | Use `with db.transaction():` context manager |
| Use print() for debugging | Use `logger.debug()` from `src.utils.logger` |
```

**Focus on:**

- Project-specific patterns (not general programming advice)
- Mistakes made by new contributors
- Things that bypass architecture
- Security issues specific to this codebase

**Avoid:**

- Generic advice ("write tests", "use good names")
- Language basics ("don't use global variables")
- Anything covered in AGENTS_COMMON.md

## Quick Reference Section

**Format: Table of commands, patterns, or decisions**

```markdown
## Quick Reference

| Aspect | Standard |
|--------|----------|
| Python version | 3.11+ (type hints required) |
| Test runner | pytest with coverage |
| Database | PostgreSQL 15 with SQLAlchemy 2.0 |
| API framework | FastAPI with Pydantic v2 |
| Auth method | OAuth 2.0 with JWT (jose library) |
| Environment variables | Loaded from `.env` via python-dotenv |
| Code formatting | black + isort + ruff |
| Secrets | 1Password CLI (`op` command) |
```

**Common patterns:**

- Technology versions (when specific version matters)
- Tools and their purposes
- Architectural decisions (sync vs async, REST vs GraphQL)
- External services and auth methods
- Development tools (linters, formatters)

## When Working in This Repository Checklist

**Format: 5-10 essential practices**

```markdown
## When Working in This Repository

1. Run `make setup` after pulling to sync dependencies and database
2. Never commit directly to `main` - use feature branches and PRs
3. Update `src/db/schema.sql` when changing models (authoritative source)
4. Add integration test for any API endpoint change
5. Run `make lint` before committing (black, isort, ruff, mypy)
6. Update OpenAPI docs with `make generate-openapi` after API changes
7. Check OAuth tokens are in `.env` before running locally
8. Use `logger.debug()` not `print()` for debugging
9. Test database migrations in a transaction: `alembic upgrade head && alembic downgrade -1`
10. Review `ARCHITECTURE.md` before adding new service or model
```

**Prioritize:**

- Steps that prevent common failures
- Non-obvious workflows
- Things that save time if done consistently
- Critical hygiene (don't commit secrets, run tests)

**Avoid:**

- Obvious practices ("write clean code")
- Things covered in team handbook
- Language-level advice ("use type hints")

## Creating a CLAUDE.md: Process

### Phase 1: Repository Analysis

**Read these files first:**

1. README.md - project purpose
2. Main entry point (app.py, main.py, index.ts)
3. Directory structure (use `tree -L 2 -I node_modules`)
4. Package/dependency files (requirements.txt, package.json)
5. Tests directory structure

**Identify:**

- Primary language and framework
- Key directories and their purposes
- Entry points and important files
- Testing approach
- Configuration method

### Phase 2: Pattern Recognition

**Search for:**

```bash
# Common patterns
rg "class.*Error" --type py          # Error handling
rg "def.*Service" --type py          # Service layer
rg "@app\.(get|post)" --type py      # API routes
rg "import.*config" --type py        # Configuration
```

**Questions to answer:**

- How are errors handled?
- Where is business logic vs infrastructure code?
- How is configuration managed?
- What's the testing strategy?
- Are there architectural patterns (DI, layers, etc.)?

### Phase 3: Team Pattern Discovery

**Review recent commits:**

```bash
git log --oneline -20
git show HEAD~5..HEAD --name-only
```

**Look for:**

- File types changed frequently (scripts, configs, docs)
- Commit message patterns (tickets, conventional commits)
- Changed files correlation (model + schema, route + test)

### Phase 4: Anti-Pattern Collection

**Sources:**

- PR review comments
- CONTRIBUTING.md or DEVELOPMENT.md
- git commit messages with "fix" or "oops"
- Test edge cases (what mistakes do tests catch?)

### Phase 5: Write and Validate

**Write sections in order:**

1. Repository Overview (requires full understanding)
2. Repository Structure (tree + annotations)
3. Core Architecture (key patterns)
4. Common Development Tasks (from git history)
5. Key Files (frequently changed files)
6. Anti-Patterns (from reviews and commits)
7. Quick Reference (extracted from code)
8. Checklist (distill from above sections)

**Validation checklist:**

- [ ] Overview is 1-3 sentences, clear purpose
- [ ] Structure tree is 2-3 levels, annotated
- [ ] Architecture has 3-5 key concepts with examples
- [ ] Tasks cover 80% of common workflows
- [ ] Key Files table has 5-10 critical files
- [ ] Anti-Patterns are project-specific, not generic
- [ ] Quick Reference has essential tooling/tech
- [ ] Checklist has 5-10 actionable items
- [ ] Total length: 150-300 lines (max 400)
- [ ] No duplicated content from README.md

## Domain-Specific Patterns

### Web Applications

```markdown
## API Conventions

**Endpoint format:** `/api/v1/resource`

**Authentication:** JWT in `Authorization: Bearer <token>` header

**Error responses:**
```json
{
  "error": "RESOURCE_NOT_FOUND",
  "message": "Task with id=123 not found",
  "timestamp": "2024-01-15T10:30:00Z"
}
```

**Rate limiting:** 100 requests/minute per user
```

### CLI Tools

```markdown
## CLI Commands

**Structure:** `appname [global-opts] command [args]`

**Global options:**
- `--config PATH`: Override default config location
- `--verbose, -v`: Enable debug logging
- `--format json|text`: Output format

**Testing CLI:**
```bash
python -m src.cli --help
python -m src.cli sync --dry-run
```
```

### Libraries/Packages

```markdown
## Public API

**Stable (do not change):**
- `Client` class constructor signature
- `process()` method return type
- Error classes in `exceptions.py`

**Internal (can change):**
- `_process_internal()` methods
- `utils/` module functions

**Deprecation:** Mark with `warnings.warn()`, remove after 2 major versions.
```

### Data Pipelines

```markdown
## Pipeline Architecture

**Stages:** Extract → Transform → Load (ETL)

**Idempotency:** All stages can rerun safely. Use `upsert` not `insert`.

**Failure handling:** Each stage logs progress to `pipeline_runs` table.
Resume from last successful stage with `--resume-from=transform`.

**Monitoring:** Check `pipeline_runs` table for failures:
```sql
SELECT * FROM pipeline_runs
WHERE status = 'FAILED'
ORDER BY started_at DESC;
```
```

## Anti-Patterns in CLAUDE.md Files

| Don't | Do |
|-------|-----|
| Duplicate README.md content | Reference README, add details not in public docs |
| Explain the programming language | Explain project-specific patterns |
| Include full code examples (>15 lines) | Link to actual file: "See `src/core/processor.py:45-60`" |
| Document every file | Document 5-10 most critical files |
| Write generic development advice | Write project-specific workflows |
| Create without reading code | Analyze repository first (Phase 1-4) |
| Skip validation checklist | Check all 9 validation items |
| Exceed 400 lines | Target 150-300 lines, max 400 |
| Use passive voice ("can be done") | Use imperative ("Do X") |
| Include outdated information | Add date to sections that may become stale |

## Quick Reference

| Aspect | Standard |
|--------|----------|
| Target length | 150-300 lines (max 400) |
| Structure | 8 required sections |
| Code examples | 5-15 lines max, prefer links for longer |
| Update frequency | After architectural changes |
| Validation | 9-item checklist before finalizing |
| Focus | Project-specific patterns, not general advice |
| Tone | Imperative ("Use X"), not passive ("X can be used") |
| File location | Repository root: `CLAUDE.md` |

## When Creating CLAUDE.md Files

1. Analyze repository structure (Phase 1): README, entry points, directory tree
2. Identify patterns (Phase 2): Search for common class names, imports, patterns
3. Review git history (Phase 3): Frequent file changes, commit patterns
4. Collect anti-patterns (Phase 4): PR comments, fix commits, test edge cases
5. Write sections in order: Overview → Structure → Architecture → Tasks → Anti-Patterns
6. Keep examples under 15 lines (link to files for longer examples)
7. Focus on project-specific patterns, not language basics
8. Validate against 9-item checklist
9. Keep total length under 400 lines (target 150-300)
10. Update after major architectural changes or pattern evolution

## See Also

- AGENTS_README.md for documenting projects publicly
- AGENTS_ADR.md for architectural decision records
- AGENTS_TEMPLATE.md for creating new template types
