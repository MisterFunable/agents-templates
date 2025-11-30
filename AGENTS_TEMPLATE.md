# AGENTS_TEMPLATE.md

Instructions for AI models creating new AGENTS template files.

Use this when asked to create a new template for a specific project type or domain.

## Process Overview

Creating a template requires 4 phases:

1. **Research** - Gather information about the domain
2. **Question** - Clarify requirements and scope
3. **Structure** - Define template sections
4. **Write** - Create guidelines with examples
5. **Validate** - Test for completeness and clarity

## Phase 1: Research

Before writing any guidelines, research the domain.

### Required Research Steps

**1. Web search for current practices:**

```
Search: "[TOPIC] project structure best practices 2024"
Search: "[TOPIC] common mistakes and anti-patterns"
Search: "[TOPIC] getting started tutorial"
```

**2. Find real-world examples:**

```
Search: "popular [TOPIC] projects on GitHub"
Look for: Project structure, file organization, naming conventions
```

**3. Identify standard tools:**

```
What do most projects use?
- Build tools
- Testing frameworks
- Package managers
- Linters/formatters
```

**4. Check for official style guides:**

```
Search: "[LANGUAGE/FRAMEWORK] official style guide"
Search: "[LANGUAGE/FRAMEWORK] community conventions"
```

### What to Extract from Research

| Information Type | What to Capture | Example |
|-----------------|-----------------|---------|
| Project structure | Standard directory layout | `src/`, `tests/`, `docs/` |
| Naming conventions | Files, functions, classes | camelCase, PascalCase, snake_case |
| Standard tools | Default/recommended tools | pytest, jest, cargo |
| Common patterns | Repeating code structures | Singleton, Factory, Module pattern |
| Anti-patterns | Frequently made mistakes | Global state, tight coupling |

### Research Validation

Before moving to Phase 2, ensure you have:

- [ ] At least 3 real-world project examples
- [ ] Standard directory structure identified
- [ ] Common tool choices documented
- [ ] 5+ anti-patterns discovered
- [ ] Official or widely-accepted style guide (if exists)

## Phase 2: Question

Ask clarifying questions to scope the template properly.

### Critical Questions to Ask

**Scope and boundaries:**
```
- Is this for [specific framework] or general [domain]?
- Should this cover deployment/infrastructure or just development?
- Is this for beginners or experienced developers?
- What size projects? (scripts, small apps, large systems)
```

**Tool preferences:**
```
- Any specific tools you prefer? (or should I use most common ones?)
- Programming language version to target?
- Development environment (local, containerized, cloud)?
```

**Integration with existing templates:**
```
- Does this overlap with existing templates? (check repo)
- Should this reference other templates?
- Is this a standalone or supplementary template?
```

**Constraints:**
```
- Any anti-patterns you specifically want called out?
- Patterns you specifically want mandated?
- Length preference? (standard is 250-300 lines)
```

### Question Framework

Use this template when asking:

> I'm creating AGENTS_[TYPE].md for [PURPOSE]. Before I start, I need to clarify:
>
> **Scope:**
> - [Question about scope]
>
> **Tools:**
> - [Question about tooling]
>
> **Integration:**
> - [Question about existing templates]
>
> While you answer, I'll research [list what you'll search for].

### Decision Rules When Questions Go Unanswered

If user doesn't answer or says "decide for me":

1. **Use most popular tools** - Go with community defaults
2. **Target intermediate users** - Not too basic, not too advanced
3. **Cover core development only** - Skip deployment unless essential
4. **Check for overlaps** - Review existing templates, don't duplicate
5. **Use standard length** - Aim for 250-300 lines

## Phase 3: Structure

Define the template sections based on research and answers.

### Required Sections

Every template MUST have:

```markdown
# AGENTS_[TYPE].md

Instructions for AI models working on [TYPE] projects.

## Project Structure
(Directory layout with explanations)

## [Core Aspect 1]
(Primary guidelines - usually naming, file organization, or architecture)

## [Core Aspect 2]
(Secondary guidelines - usually code style, patterns, or tooling)

## [Additional aspects as needed]
(Configuration, testing, error handling, security, etc.)

## Anti-Patterns
| Don't | Do |
(Common mistakes and fixes)

## Quick Reference
| Aspect | Standard |
(Summary table of key decisions)

## When Working on [TYPE] Projects
(Checklist of essential practices)
```

### Section Planning Template

Before writing, fill this out:

```
TEMPLATE: AGENTS_[TYPE].md

CORE SECTIONS (choose 3-5):
1. [Most important aspect] - covers [what]
2. [Second most important] - covers [what]
3. [Third aspect] - covers [what]
4. [Optional fourth] - covers [what]
5. [Optional fifth] - covers [what]

ANTI-PATTERNS (list 8-12):
- [Pattern 1]: [Why it's bad]
- [Pattern 2]: [Why it's bad]
...

KEY DECISIONS (for Quick Reference):
- [Aspect]: [Standard choice]
- [Aspect]: [Standard choice]
...

EXAMPLES NEEDED (minimum 5):
- [Example of what]
- [Example of what]
...
```

### Section Ordering Rules

1. **Start with structure** - Always begin with project layout
2. **Most to least important** - Core patterns before edge cases
3. **Related topics together** - Group related concerns
4. **End with reference material** - Anti-patterns, Quick Reference, Checklist

## Phase 4: Write

Write the template following strict guidelines.

### Writing Rules

**1. Be specific, not vague:**

```markdown
# Bad - vague
Use good naming conventions for your variables.

# Good - specific
Variables: snake_case, Classes: PascalCase, Constants: UPPER_SNAKE
```

**2. Show code examples:**

```markdown
# Bad - no example
Handle errors appropriately in API calls.

# Good - with example
```python
try:
    response = requests.get(url, timeout=10)
    response.raise_for_status()
except requests.Timeout:
    logger.error(f"Request to {url} timed out")
    return None
```
```

**3. Use tables for comparisons:**

```markdown
# Bad - prose
You should use environment variables for secrets, not hardcoded values.
API keys should never be committed. Use config files for settings.

# Good - table
| Type | Storage Method |
|------|----------------|
| Secrets (API keys) | Environment variables |
| Configuration | Config files (YAML/TOML) |
| Constants | Code (committed) |
```

**4. Give defaults with escape hatches:**

```markdown
# Bad - too prescriptive
Always use PostgreSQL for databases. Never use SQLite.

# Good - default with flexibility
Use PostgreSQL for production databases.
For local development or simple projects, SQLite is acceptable.
```

**5. Cover 90%, acknowledge exceptions:**

```markdown
# Bad - trying to cover everything
Use named exports unless you're exporting a single function from a
file, but if that file might export more in the future, use named
exports anyway, however if...

# Good - simple rule with exception note
Use named exports for all functions and components.
Exception: Single-purpose utility files can use default exports.
```

### Code Example Requirements

**Every code example must:**

1. Be syntactically correct
2. Be copy-paste ready
3. Show realistic use case
4. Include necessary imports
5. Demonstrate the guideline clearly

**Example structure:**

```markdown
## Error Handling

Catch specific exceptions, not broad catches:

```python
import logging

# Good
try:
    data = json.loads(response)
except json.JSONDecodeError as e:
    logging.error(f"Invalid JSON: {e}")
    return None

# Bad - too broad
try:
    data = json.loads(response)
except Exception:
    return None
```
```

### Anti-Patterns Section

Structure: **Don't | Do** table

**Rules:**
- List 8-12 most common mistakes
- Be specific (not "bad naming" but "single-letter variables")
- Provide the correct alternative
- Order by impact (most harmful first)

**Template:**

```markdown
## Anti-Patterns

| Don't | Do |
|-------|-----|
| [Specific bad pattern] | [Specific good pattern] |
| [Another mistake] | [Correct approach] |
| [Common error] | [Right way] |
```

### Quick Reference Section

Structure: **Aspect | Standard** table

**Rules:**
- Summarize key decisions from the template
- One line per decision
- Cover tooling, structure, and patterns
- User can scan this in 30 seconds

**Template:**

```markdown
## Quick Reference

| Aspect | Standard |
|--------|----------|
| Project structure | [Structure choice] |
| Package manager | [Tool name] |
| Testing framework | [Tool name] |
| Code style | [Style guide or rules] |
| [Other key aspect] | [Standard choice] |
```

### Checklist Section

Structure: Numbered or bulleted list

**Rules:**
- 5-10 essential practices
- Action-oriented (verbs)
- Order of operations (if sequential)
- Things easily forgotten

**Template:**

```markdown
## When Working on [TYPE] Projects

1. [First essential step]
2. [Second essential step]
3. [Key practice to remember]
4. [Common thing to check]
5. [Final validation step]
```

## Phase 5: Validate

Test your template before considering it complete.

### Self-Validation Checklist

Run through this list:

**Structure validation:**
- [ ] File named `AGENTS_[TYPE].md`
- [ ] Has "Instructions for AI models working on..." intro
- [ ] Includes Project Structure section
- [ ] Has Anti-Patterns table
- [ ] Has Quick Reference table
- [ ] Has "When Working on..." checklist
- [ ] Length is 200-350 lines

**Content validation:**
- [ ] At least 5 code examples
- [ ] All code examples are syntactically correct
- [ ] Every major guideline has an example
- [ ] No vague terms ("good", "clean", "proper") without definition
- [ ] Tables used for all comparisons
- [ ] No em dashes (—)
- [ ] No corporate language or fluff

**Usefulness validation:**
- [ ] Someone could build a project from scratch using only this
- [ ] Guidelines are specific enough to be unambiguous
- [ ] Covers 90% of common cases
- [ ] Doesn't conflict with existing templates
- [ ] Anti-patterns address real common mistakes
- [ ] Quick Reference captures key decisions

**Example validation:**
- [ ] Each example solves a real problem
- [ ] Examples show both good and bad approaches
- [ ] Code is copy-paste ready
- [ ] Examples use realistic variable names
- [ ] Imports are included where needed

### Cross-Reference Check

Compare against existing templates:

1. **Check for overlaps:**
   - Read AGENTS_README.md, AGENTS_PYTHON.md, AGENTS_CLI.md, AGENTS_WEBAPP.md
   - If 50%+ overlap, consider extending existing template
   - If related but distinct, reference the other template

2. **Check for conflicts:**
   - Same concept, different advice? Resolve it.
   - Example: If AGENTS_PYTHON.md says "use pytest" and you say "use unittest", pick one or explain when to use each

3. **Add cross-references:**
   ```markdown
   For Python CLI tools, also see AGENTS_PYTHON.md and AGENTS_CLI.md
   ```

### Test with Hypothetical Task

Write a hypothetical task and check if template covers it:

```
"Create a [TYPE] project that [does X, Y, Z]"

Can your template guide AI to:
- ✓ Create correct project structure
- ✓ Choose appropriate tools
- ✓ Follow naming conventions
- ✓ Implement patterns correctly
- ✓ Avoid common mistakes

If any ✗, template is incomplete.
```

## Common Problems and Solutions

Issues I've encountered creating templates:

### Problem: Too Vague

**Symptoms:**
- Uses terms like "appropriate", "good", "clean"
- No examples for complex concepts
- Guidelines that could mean multiple things

**Solution:**
- Replace adjectives with specific criteria
- Add code example for every guideline
- Test by asking "could this mean 2 different things?"

**Example fix:**

```markdown
# Vague
Use appropriate error handling

# Specific
Catch specific exceptions with recovery logic:

```python
try:
    data = fetch_data()
except requests.Timeout:
    return cached_data()
except requests.HTTPError as e:
    if e.response.status_code == 404:
        return None
    raise
```
```

### Problem: Too Prescriptive

**Symptoms:**
- Says "always" or "never" without escape hatches
- Mandates specific tools without alternatives
- Doesn't acknowledge exceptions

**Solution:**
- Use "Use X (or Y for Z cases)"
- Give default, note alternatives exist
- Cover 90%, acknowledge 10%

**Example fix:**

```markdown
# Too prescriptive
Always use Redux for state management. Never use Context API.

# Better
Use React Context for simple shared state (theme, auth).
For complex state with many updates, use Zustand or Redux Toolkit.
```

### Problem: Not Actionable

**Symptoms:**
- Describes what to do, not how
- Philosophical rather than practical
- No examples of application

**Solution:**
- Show code, not concepts
- Use commands, not descriptions
- Demonstrate with realistic examples

**Example fix:**

```markdown
# Not actionable
Follow SOLID principles in your code design.

# Actionable
Single Responsibility: Each function does one thing:

```python
# Bad - multiple responsibilities
def process_user(user_data):
    validate(user_data)
    save_to_db(user_data)
    send_email(user_data)
    log_activity(user_data)

# Good - single responsibility
def process_user(user_data):
    if not is_valid(user_data):
        return False
    user = create_user(user_data)
    notify_user(user)
    return True
```
```

### Problem: Missing Context

**Symptoms:**
- Assumes knowledge of tools/patterns
- No explanation of when to use something
- Examples without imports or setup

**Solution:**
- Brief one-line context before guidelines
- Show when/why for non-obvious patterns
- Complete examples with necessary imports

**Example fix:**

```markdown
# Missing context
Use dependency injection:

```python
class UserService:
    def __init__(self, db):
        self.db = db
```

# With context
Use dependency injection for testability:

```python
# Services receive dependencies as parameters
class UserService:
    def __init__(self, db: Database):
        self.db = db
    
    def get_user(self, id: int) -> User:
        return self.db.query(User).get(id)

# Easy to test with mock database
def test_get_user():
    mock_db = MockDatabase()
    service = UserService(mock_db)
    assert service.get_user(1) is not None
```
```

### Problem: Too Long

**Symptoms:**
- Over 400 lines
- Covers edge cases extensively
- Repetitive examples

**Solution:**
- Cover 90% of cases, link to docs for edge cases
- One example per concept
- Combine related sections
- Remove redundancy

**Example fix:**

```markdown
# Too detailed (showing 5 variations)
# Basic import
import { User } from './types';

# Import with type
import type { User } from './types';

# Import multiple
import { User, Post, Comment } from './types';

# Import with rename
import { User as UserType } from './types';

# Import default and named
import React, { useState } from 'react';

# Concise (one example)
Import types separately from values:

```typescript
import type { User } from './types';
import { getUser } from './api';
```
```

### Problem: Conflicts with Existing Templates

**Symptoms:**
- Different advice for same situation
- Tool choice differs from another template
- Pattern conflicts with established guideline

**Solution:**
- Check all existing templates first
- If conflict is unavoidable, explain context
- Add cross-reference to related template
- Consider merging if too much overlap

**Example resolution:**

```markdown
## Package Management

Use npm as default package manager (consistent with AGENTS_WEBAPP.md).

For monorepos or projects with strict lockfiles, use pnpm.

See AGENTS_WEBAPP.md for frontend-specific package guidelines.
```

## Example Creation Flow

Here's a full example of creating AGENTS_API.md:

### Phase 1: Research

```
[Web search] "REST API best practices 2024"
[Web search] "REST API project structure"
[Web search] "OpenAPI common mistakes"

Found:
- Standard structure: routes/, controllers/, middleware/
- Common tools: Express, FastAPI, Go fiber
- Anti-patterns: Nested routes >3 levels, no versioning, exposing errors
```

### Phase 2: Question

```
> I'm creating AGENTS_API.md for REST API development.
> Before I start:
>
> **Scope:**
> - Should this cover both REST and GraphQL, or REST only?
> - Include authentication patterns or just structure?
>
> **Tools:**
> - Language-agnostic or specific to Node.js/Python/Go?
>
> **Integration:**
> - Should this reference AGENTS_PYTHON.md for Python APIs?
```

### Phase 3: Structure

```
TEMPLATE: AGENTS_API.md

CORE SECTIONS:
1. Project Structure - API directory layout
2. Route Organization - URL patterns, versioning
3. Request/Response Handling - Bodies, status codes
4. Error Handling - Consistent error responses
5. Documentation - OpenAPI/Swagger

ANTI-PATTERNS:
- No API versioning
- Exposing internal errors to clients
- Inconsistent response formats
- Missing rate limiting
...

KEY DECISIONS:
- Versioning: URL path versioning (/v1/)
- Format: JSON with consistent structure
- Status codes: RESTful standards
...
```

### Phase 4: Write

```markdown
# AGENTS_API.md

Instructions for AI models building REST APIs.

## Project Structure

Standard API layout:

```
api/
├── routes/          # URL route definitions
│   ├── v1/
│   │   ├── users.py
│   │   └── posts.py
│   └── v2/
├── controllers/     # Request handlers
├── middleware/      # Auth, logging, validation
├── models/          # Data models
└── tests/
```

## Route Organization

Use URL path versioning:

```python
# Good
@app.route('/api/v1/users')
@app.route('/api/v1/users/<id>')

# Bad - no versioning
@app.route('/api/users')
```
...

[Continue with all sections]
```

### Phase 5: Validate

```
✓ Has Project Structure
✓ 6 code examples
✓ Anti-Patterns table with 10 items
✓ Quick Reference table
✓ 285 lines
✓ No conflicts with existing templates
✓ Cross-referenced AGENTS_PYTHON.md
✓ All examples tested
```

## Meta-Guidelines

Guidelines for using this template file:

1. **Don't skip research** - Templates without research lack specificity
2. **Ask questions early** - Better to clarify than assume
3. **Validate thoroughly** - Poor template causes problems for months
4. **Test with real task** - "Build X" should be fully coverable
5. **Update existing over creating new** - Check overlaps first

## Quick Reference

| Phase | Key Activity | Output |
|-------|--------------|---------|
| Research | Web search + examples | List of patterns, tools, anti-patterns |
| Question | Clarify scope & tools | Clear requirements |
| Structure | Define sections | Section outline with topics |
| Write | Create content | Complete template file |
| Validate | Check completeness | Verified, tested template |

## When Creating New Templates

1. Research domain thoroughly (web search + examples)
2. Ask clarifying questions about scope
3. Check existing templates for overlaps
4. Create section outline before writing
5. Write with specific examples, not vague rules
6. Include 8-12 anti-patterns
7. Add Quick Reference and checklist
8. Validate against checklist
9. Test with hypothetical task
10. Create example implementation in `examples/`

---

See `CONTRIBUTING.md` for adding the finished template to the repository.

