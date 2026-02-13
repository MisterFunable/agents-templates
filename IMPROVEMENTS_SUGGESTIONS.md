# Template Improvements & New Suggestions

Comprehensive review of the agents-templates repository with suggestions for new templates, improvements to existing ones, and multipurpose prompts.

## New Template Suggestions

### High Priority Templates

| Template | Purpose | Why It's Needed |
|----------|---------|-----------------|
| `AGENTS_API.md` | REST/GraphQL API design | Missing backend-specific patterns beyond AGENTS_WEBAPP.md |
| `AGENTS_DATABASE.md` | Database schema and migrations | Critical for data-driven applications |
| `AGENTS_TESTING.md` | Test structure across languages | Currently scattered across other templates |
| `AGENTS_DEVOPS.md` | CI/CD, Docker, deployment | Infrastructure patterns not covered |
| `AGENTS_MOBILE.md` | Mobile app development (React Native/Flutter) | Growing demand for mobile guidance |
| `AGENTS_REFACTOR.md` | Code refactoring guidelines | Help AI safely refactor existing code |
| `AGENTS_DOCS.md` | Technical documentation | Beyond README, full docs structure |
| `AGENTS_PROMPT.md` | Multipurpose AI prompts | Quick-fix prompts for common tasks |

### Medium Priority Templates

| Template | Purpose | Why It's Useful |
|----------|---------|-----------------|
| `AGENTS_JUPYTER.md` | Jupyter notebook structure | Data science/research workflows |
| `AGENTS_TERRAFORM.md` | Infrastructure as Code | Cloud infrastructure patterns |
| `AGENTS_BASH.md` | Shell script best practices | Automation and tooling |
| `AGENTS_MICROSERVICES.md` | Microservice architecture | Distributed systems patterns |
| `AGENTS_GAME.md` | Game development patterns | Unity/Godot/Pygame structure |
| `AGENTS_CHROME_EXT.md` | Browser extension development | Manifest, content scripts, background workers |

### Creative Writing Templates

| Template | Purpose | Why It's Needed |
|----------|---------|-----------------|
| `AGENTS_FICTION.md` | Short stories and novels | Complement AGENTS_POETRY.md |
| `AGENTS_ESSAY.md` | Essay and article writing | Non-fiction prose patterns |
| `AGENTS_BLOG.md` | Blog post structure | SEO-friendly, scannable blog content |
| `AGENTS_SCREENPLAY.md` | Script writing | Format, structure, dialogue |

## Improvements to Existing Templates

### AGENTS_README.md

**Current Issues:**
- File is named `AGENTS.md` instead of `AGENTS_README.md`
- Missing anti-patterns section
- No quick reference table

**Suggested Improvements:**
```markdown
## Anti-Patterns

| Don't | Do |
|-------|-----|
| Write installation essays | "Clone repo, run `npm install`" |
| Explain what the project "aims to do" | State what it does |
| Add "Features" section with bullet points | Show in usage examples |
| Use phrases like "seamlessly", "robust" | Use plain language |
| Create deep heading hierarchies (####) | Stick to ## for main sections |

## Quick Reference

| Section | Max Length | Format |
|---------|-----------|--------|
| Description | 2 sentences | Plain text |
| Setup | 5 steps | Code blocks |
| Examples | 1-2 per use case | Copy-paste ready |
| Troubleshooting | Common issues only | Table format |
```

### AGENTS_PYTHON.md

**Suggested Additions:**
```markdown
## Virtual Environment Management

| Tool | When to Use | Command |
|------|-------------|---------|
| venv | Simple projects, standard library | `python -m venv venv` |
| virtualenv | Legacy compatibility | `virtualenv venv` |
| pyenv | Multiple Python versions | `pyenv virtualenv 3.11.0 myenv` |
| poetry | Dependencies + packaging | `poetry shell` |
| conda | Data science, non-Python deps | `conda create -n myenv` |

## Async/Await Patterns

When to use async:
- I/O-bound operations (API calls, file reads, database queries)
- Multiple concurrent operations
- Web servers handling many requests

When NOT to use async:
- CPU-bound operations (use multiprocessing)
- Simple scripts with sequential operations
- Libraries not designed for async

```python
import asyncio
import aiohttp

async def fetch_multiple(urls: list[str]) -> list[dict]:
    async with aiohttp.ClientSession() as session:
        tasks = [fetch_one(session, url) for url in urls]
        return await asyncio.gather(*tasks)

async def fetch_one(session, url: str) -> dict:
    async with session.get(url) as response:
        return await response.json()
```
```

### AGENTS_CLI.md

**Suggested Additions:**
```markdown
## Progress Indicators

For long-running operations, show progress:

```python
from tqdm import tqdm
import time

def process_files(files: list[str]):
    for file in tqdm(files, desc="Processing"):
        process_file(file)
        time.sleep(0.1)
```

## Interactive Prompts

Use `rich` for better UX:

```python
from rich.console import Console
from rich.prompt import Confirm, Prompt

console = Console()

name = Prompt.ask("Enter your name")
proceed = Confirm.ask("Continue with operation?")

if proceed:
    console.print(f"[green]Processing for {name}...[/green]")
```
```

### AGENTS_WEBAPP.md

**Suggested Additions:**
```markdown
## State Management Decision Tree

| App Complexity | State Solution |
|----------------|----------------|
| Simple (< 5 pages) | React Context or useState |
| Medium (5-20 pages) | Zustand or Jotai |
| Complex (20+ pages) | Redux Toolkit |
| Server-first | TanStack Query + URL state |

## Performance Optimization Checklist

Before optimizing, profile with React DevTools Profiler.

| Pattern | When to Apply |
|---------|---------------|
| `React.memo` | Component re-renders with same props |
| `useMemo` | Expensive calculations in render |
| `useCallback` | Passing callbacks to memoized children |
| Code splitting | Route-based or feature-based chunks |
| Lazy loading | Images, modals, off-screen content |
| Virtual lists | > 100 items in a list |
```

### AGENTS_COMMON.md

**Suggested Additions:**
```markdown
## Rate Limiting

Implement rate limiting for external APIs:

```python
from time import time, sleep
from collections import deque

class RateLimiter:
    def __init__(self, max_calls: int, period: float):
        self.max_calls = max_calls
        self.period = period
        self.calls = deque()

    def __call__(self, func):
        def wrapper(*args, **kwargs):
            now = time()
            # Remove calls outside the time window
            while self.calls and self.calls[0] < now - self.period:
                self.calls.popleft()

            if len(self.calls) >= self.max_calls:
                sleep_time = self.period - (now - self.calls[0])
                sleep(sleep_time)

            self.calls.append(time())
            return func(*args, **kwargs)
        return wrapper

@RateLimiter(max_calls=5, period=1.0)  # 5 calls per second
def api_call():
    pass
```

## Feature Flags

Simple feature flag pattern:

```python
from os import environ
from functools import wraps

def feature_flag(flag_name: str, default: bool = False):
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            enabled = environ.get(f"FEATURE_{flag_name}", str(default)).lower() == "true"
            if enabled:
                return func(*args, **kwargs)
            return None
        return wrapper
    return decorator

@feature_flag("NEW_CHECKOUT")
def new_checkout_flow():
    pass
```
```

## New Template: AGENTS_PROMPT.md

This is the multipurpose prompt template you requested:

### Content for AGENTS_PROMPT.md

```markdown
# AGENTS_PROMPT.md

Quick-fix prompts and refinement templates for common AI tasks.

## Image Analysis & Fixes

### Screenshot Analysis
```
Analyze this screenshot and identify:
1. UI/UX issues (alignment, spacing, contrast, accessibility)
2. Broken layouts or visual bugs
3. Missing or unclear elements
4. Responsive design problems
5. Suggested fixes with specific CSS/code changes
```

### Error Screenshot Debug
```
Looking at this error screenshot:
1. Identify the error type and root cause
2. Explain why it's happening
3. Provide the exact fix with code
4. Suggest how to prevent similar errors
```

### Design to Code
```
Convert this design/mockup to code:
- Match spacing, colors, fonts exactly
- Use semantic HTML
- Implement responsive behavior
- Include accessibility attributes
- Follow [framework] best practices
- Provide component/class names
```

### Image Optimization
```
Analyze this image for web optimization:
1. Current format, size, dimensions
2. Recommended format (WebP, AVIF, etc.)
3. Optimal dimensions for web use
4. Compression settings
5. Command to convert using [tool]
```

## Code Refinement

### Code Review
```
Review this code for:
1. **Bugs**: Logic errors, edge cases, null checks
2. **Performance**: O(n) complexity, unnecessary iterations
3. **Security**: Injection risks, validation, secrets
4. **Readability**: Naming, structure, comments
5. **Best Practices**: [Language]-specific patterns

For each issue found:
- Line number
- Problem description
- Severity (critical/high/medium/low)
- Suggested fix with code
```

### Refactor Request
```
Refactor this code to:
1. Extract functions for single responsibilities
2. Remove duplication
3. Improve naming (variables, functions, classes)
4. Add type hints/annotations
5. Simplify complex conditionals
6. Maintain identical behavior

Show before/after for each change.
```

### Error Fix
```
This code throws an error: [error message]

1. Explain the root cause
2. Show the exact lines causing it
3. Provide the corrected code
4. Add error handling if needed
5. Suggest tests to prevent regression
```

### Performance Optimization
```
Optimize this code for performance:

**Profile first:**
1. Identify bottlenecks (loops, I/O, algorithms)
2. Measure current performance

**Then optimize:**
1. Algorithm improvements (better O(n))
2. Caching opportunities
3. Async/parallel operations
4. Memory usage reduction

Show benchmarks before/after.
```

### Type Safety
```
Add type safety to this code:

**[Python]**
- Type hints for all function signatures
- Use TypedDict/dataclass for complex types
- Add mypy checks

**[TypeScript]**
- Replace `any` with specific types
- Add interfaces for objects
- Use generics where appropriate
- Enable strict mode compliance
```

## Testing

### Generate Tests
```
Generate tests for this code:

**Test coverage:**
1. Happy path (expected inputs)
2. Edge cases (empty, null, max values)
3. Error cases (invalid inputs)
4. Integration with dependencies

**Format:**
- Use [testing framework]
- Follow AAA pattern (Arrange, Act, Assert)
- Mock external dependencies
- Clear test names
```

### Test Data Generation
```
Generate realistic test data for:
- Schema/model: [describe structure]
- Use cases: [list scenarios]
- Constraints: [validation rules]

Provide:
1. Valid examples (happy path)
2. Invalid examples (should fail validation)
3. Edge cases (boundaries, special characters)
4. Fixture file format: [JSON/YAML/SQL]
```

## Documentation

### Add Documentation
```
Document this code:

1. Module-level docstring (what file does)
2. Function docstrings (params, returns, raises)
3. Complex logic comments (why, not what)
4. Type annotations
5. Usage example

Follow [language] documentation standards.
```

### API Documentation
```
Generate API documentation for this endpoint:

Include:
- HTTP method and path
- Description (one line)
- Request parameters (path, query, body)
- Request example (curl + code)
- Response format (success)
- Response examples
- Error responses (4xx, 5xx)
- Authentication requirements
- Rate limits
```

### README Generation
```
Generate README.md for this project:

**Context:**
- Project purpose: [describe]
- Tech stack: [list]
- Target users: [describe]

**Follow AGENTS_README.md guidelines:**
- Direct, no fluff
- Scannable structure
- Copy-paste ready commands
- One example per concept
- Table format for options
```

## Architecture & Design

### Architecture Decision
```
Help me choose between [Option A] and [Option B] for [use case]:

**Compare:**
1. Pros/cons of each
2. Performance implications
3. Scalability
4. Maintenance complexity
5. Cost (if applicable)
6. Learning curve

**Recommend:**
- Best choice for this context
- Migration path if changing later
```

### Design Pattern Selection
```
Suggest design pattern for this problem:

**Problem:** [describe]

**Requirements:**
- [list constraints]
- [list goals]

**Provide:**
1. Recommended pattern
2. Why it fits
3. Implementation example
4. Alternative patterns considered
5. Trade-offs
```

### Database Schema Design
```
Design database schema for:

**Entities:** [list]
**Relationships:** [describe]
**Constraints:** [describe]

**Provide:**
1. ER diagram (text/mermaid)
2. SQL schema (with types, keys, indexes)
3. Migration script
4. Common queries (with indexes used)
5. Scalability considerations
```

## Quick Fixes

### Dependency Update
```
Update dependencies safely:

1. List outdated packages
2. Check for breaking changes
3. Provide update commands
4. Highlight required code changes
5. Suggest testing strategy
```

### Environment Setup
```
Set up development environment for [project]:

Provide step-by-step:
1. Prerequisites (language version, tools)
2. Installation commands
3. Environment variables (with .env.example)
4. Database setup (if needed)
5. Verification command
6. Troubleshooting common issues
```

### Git Operations
```
Help with git [operation]:

**Operation:** [describe what you want to do]

Provide:
1. Exact git commands
2. Explanation of what each does
3. How to verify success
4. How to undo if needed
5. Best practices for this operation
```

## Time-Saving Combinations

### Full Feature Implementation
```
Implement [feature name]:

**Requirements:** [describe]

**Deliverables:**
1. Core implementation (following [AGENTS template])
2. Tests (unit + integration)
3. Documentation (code + API if applicable)
4. Error handling
5. Logging
6. Example usage

Follow best practices from AGENTS_COMMON.md.
```

### Bug Fix Pipeline
```
Fix this bug: [describe issue]

**Current behavior:** [describe]
**Expected behavior:** [describe]
**Error message:** [paste if available]

**Steps:**
1. Reproduce the issue
2. Identify root cause
3. Provide fix with code
4. Add test to prevent regression
5. Document why it happened
```

### Codebase Exploration
```
Explore codebase to understand [specific aspect]:

**Looking for:**
- [what you need to understand]

**Provide:**
1. Relevant files (with paths)
2. Key functions/classes
3. Data flow diagram
4. Dependencies between components
5. Where to make changes for [goal]
```

## Refinement Prompts

### Clarity Refinement
```
Improve clarity of this [code/text]:

**Make it:**
- Easier to understand
- More explicit (no magic)
- Better named
- Self-documenting

Without changing behavior.
```

### Conciseness Refinement
```
Make this more concise:

**Goals:**
- Remove redundancy
- Simplify complex logic
- Reduce nesting
- Keep readability

Show character/line reduction.
```

### Professional Refinement
```
Make this more professional:

**For:** [code/documentation/commit message]

**Adjust:**
- Tone (neutral, technical)
- Terminology (industry standard)
- Structure (conventional)
- Completeness (add missing context)
```

## Quick Reference

| Task Type | Key Points | Template Section |
|-----------|-----------|------------------|
| Image fixes | Specific CSS/code changes | Image Analysis & Fixes |
| Code review | Severity levels, line numbers | Code Refinement |
| Testing | AAA pattern, edge cases | Testing |
| Documentation | Standards compliance | Documentation |
| Architecture | Trade-off analysis | Architecture & Design |
| Bug fix | Root cause + test | Quick Fixes |

## Using These Prompts

1. **Copy the prompt** for your task type
2. **Fill in the bracketed [context]**
3. **Attach relevant files/screenshots**
4. **Specify any constraints** or preferences
5. **Reference AGENTS templates** if applicable

## Prompt Chains

For complex tasks, chain prompts:

```
1. First: "Review this code" (Code Review template)
2. Then: "Refactor the issues found" (Refactor Request)
3. Finally: "Generate tests for refactored code" (Generate Tests)
```

## When to Use Which Prompt

| Situation | Prompt Template |
|-----------|----------------|
| Bug visible in screenshot | Error Screenshot Debug |
| Code works but messy | Refactor Request |
| Missing tests | Generate Tests |
| Slow performance | Performance Optimization |
| Need to understand codebase | Codebase Exploration |
| Implementing new feature | Full Feature Implementation |
| Choosing between approaches | Architecture Decision |
| Need better error messages | Error Fix + Add Documentation |

---

Combine these prompts with relevant AGENTS_*.md templates for best results.
```

## Implementation Priority

### Phase 1: Critical Updates (Week 1)
1. Rename `AGENTS.md` to `AGENTS_README.md`
2. Create `AGENTS_PROMPT.md` (the template above)
3. Add anti-patterns to `AGENTS_README.md`
4. Update CLAUDE.md with new template references

### Phase 2: High-Value Templates (Weeks 2-3)
1. `AGENTS_API.md` - REST/GraphQL patterns
2. `AGENTS_DATABASE.md` - Schema and queries
3. `AGENTS_TESTING.md` - Cross-language test patterns
4. `AGENTS_DEVOPS.md` - CI/CD and deployment

### Phase 3: Enhancements (Weeks 4-5)
1. Update existing templates with improvements listed above
2. Create examples for new templates
3. Add cross-references between templates
4. Update README.md with new template listings

### Phase 4: Creative & Specialized (Month 2)
1. `AGENTS_MOBILE.md`
2. `AGENTS_DOCS.md`
3. `AGENTS_REFACTOR.md`
4. Creative writing templates (fiction, essay, blog)

## Cross-Template Integration

### Template Dependency Map
```
AGENTS_COMMON.md (foundation)
├── AGENTS_PYTHON.md
│   ├── AGENTS_CLI.md
│   └── AGENTS_API.md (new)
├── AGENTS_WEBAPP.md
│   └── AGENTS_API.md (new)
├── AGENTS_DATABASE.md (new)
│   └── AGENTS_API.md (new)
└── AGENTS_TESTING.md (new)
    └── All templates reference this
```

### Consistency Checklist

When creating/updating templates, ensure:
- [ ] Anti-patterns section (8-12 items)
- [ ] Quick reference table
- [ ] Minimum 5 code examples
- [ ] Cross-references to related templates
- [ ] Length: 250-300 lines (max 400)
- [ ] Example in examples/ directory
- [ ] Updated in README.md template list
- [ ] Validation against AGENTS_TEMPLATE.md checklist

## Metrics for Success

Track template effectiveness:
- Number of templates created
- Coverage of common development tasks
- User feedback on template clarity
- Example quality and completeness
- Cross-reference completeness
- Consistency across templates

## Next Steps

1. Review these suggestions
2. Prioritize which templates to create first
3. Create `AGENTS_PROMPT.md` for immediate value
4. Update existing templates with improvements
5. Build out high-priority new templates
6. Create examples for each new template
7. Update documentation to reflect changes
