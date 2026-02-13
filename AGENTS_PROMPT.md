# AGENTS_PROMPT.md

Quick-fix prompts and refinement templates for common AI tasks.

Use these prompts to save time on recurring tasks: image analysis, code review, refactoring, testing, and documentation.

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
- Include accessibility attributes (ARIA labels, alt text, keyboard nav)
- Follow [React/Vue/vanilla] best practices
- Provide component/class names following [naming convention]
```

### Image Optimization

```
Analyze this image for web optimization:
1. Current format, size, dimensions
2. Recommended format (WebP, AVIF, PNG, JPEG)
3. Optimal dimensions for web use
4. Compression settings
5. Conversion command using [imagemagick/sharp/squoosh]
```

## Code Refinement

### Code Review

```
Review this code for:
1. **Bugs**: Logic errors, edge cases, null checks, off-by-one
2. **Performance**: O(n) complexity, unnecessary iterations, memory leaks
3. **Security**: Injection risks, input validation, exposed secrets
4. **Readability**: Naming, structure, unnecessary complexity
5. **Best Practices**: [Python/JavaScript/etc]-specific patterns

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
2. Remove duplication (DRY principle)
3. Improve naming (variables, functions, classes)
4. Add type hints/annotations
5. Simplify complex conditionals
6. Reduce nesting depth
7. Maintain identical behavior

Show before/after for each change with explanation.
```

### Error Fix

```
This code throws an error: [paste error message]

1. Explain the root cause in simple terms
2. Show the exact lines causing it
3. Provide the corrected code
4. Add defensive error handling if needed
5. Suggest a test to prevent regression
```

### Performance Optimization

```
Optimize this code for performance:

**Profile first:**
1. Identify bottlenecks (loops, I/O, algorithms)
2. Measure current performance (time/memory)

**Then optimize:**
1. Algorithm improvements (reduce O(n))
2. Caching opportunities (memoization, query caching)
3. Async/parallel operations
4. Memory usage reduction (generators, streaming)

Show benchmarks before/after. Only optimize proven bottlenecks.
```

### Type Safety

```
Add type safety to this code:

**[Python]**
- Type hints for all function signatures
- Use TypedDict/dataclass for complex types
- Replace dynamic dicts with structured types
- Add mypy/pyright compliance

**[TypeScript]**
- Replace `any` with specific types
- Add interfaces for objects
- Use generics where appropriate
- Enable strict mode compliance

**[Other languages]**
- Follow language-specific type conventions
```

## Testing

### Generate Tests

```
Generate tests for this code:

**Test coverage:**
1. Happy path (expected inputs, typical use cases)
2. Edge cases (empty, null, zero, max values, boundaries)
3. Error cases (invalid inputs, malformed data)
4. Integration with dependencies (mocked)

**Format:**
- Use [pytest/jest/JUnit] framework
- Follow AAA pattern (Arrange, Act, Assert)
- Mock external dependencies (API calls, database, file I/O)
- Clear test names: test_[what]_[scenario]_[expected_result]
```

### Test Data Generation

```
Generate realistic test data for:
- Schema/model: [describe structure or paste schema]
- Use cases: [list scenarios to cover]
- Constraints: [validation rules, required fields]

Provide:
1. Valid examples (happy path, typical data)
2. Invalid examples (should fail validation)
3. Edge cases (boundaries, special characters, unicode)
4. Fixture file format: [JSON/YAML/SQL/CSV]
5. Minimum 5 examples per category
```

## Documentation

### Add Documentation

```
Document this code:

1. Module-level docstring (what file does, main exports)
2. Function docstrings (params, returns, raises, examples)
3. Complex logic comments (explain why, not what)
4. Type annotations (if not present)
5. Usage example (copy-paste ready)

Follow [Python/JavaScript/Java] documentation standards.
Don't document obvious code.
```

### API Documentation

```
Generate API documentation for this endpoint:

Include:
- HTTP method and path
- Description (one line, what it does)
- Authentication (required token, API key, etc.)
- Request parameters (path, query, body with types)
- Request examples (curl + Python/JS code)
- Response format (success case, JSON structure)
- Response examples (200, 201 with sample data)
- Error responses (400, 401, 404, 500 with messages)
- Rate limits (if applicable)

Use OpenAPI/Swagger format if possible.
```

### README Generation

```
Generate README.md for this project:

**Context:**
- Project purpose: [one-line description]
- Tech stack: [Python 3.11, FastAPI, PostgreSQL, etc.]
- Target users: [developers, data scientists, etc.]

**Follow AGENTS_README.md guidelines:**
- Direct, no corporate fluff
- Scannable structure (## headings only)
- Copy-paste ready commands
- One example per concept
- Table format for options/troubleshooting
- No emojis, no em dashes

Sections: Title, Description, Setup, Commands, Output, Config (if needed), Troubleshooting.
```

## Architecture & Design

### Architecture Decision

```
Help me choose between [Option A] and [Option B] for [use case]:

**Context:** [current situation, constraints]

**Compare:**
1. Pros/cons of each approach
2. Performance implications (latency, throughput)
3. Scalability (handling growth)
4. Maintenance complexity (cognitive load, debugging)
5. Cost (infrastructure, licenses, developer time)
6. Learning curve (team expertise)

**Recommend:**
- Best choice for this specific context
- Why it's the better fit
- Migration path if changing later
- Red flags to watch for
```

### Design Pattern Selection

```
Suggest design pattern for this problem:

**Problem:** [describe the challenge]

**Requirements:**
- [constraint 1: must support X]
- [constraint 2: should scale to Y]
- [goal: improve Z]

**Provide:**
1. Recommended pattern (name and category)
2. Why it fits this problem
3. Implementation example (code)
4. Alternative patterns considered (and why rejected)
5. Trade-offs and limitations
```

### Database Schema Design

```
Design database schema for:

**Entities:** [User, Order, Product, etc.]
**Relationships:** [User has many Orders, etc.]
**Constraints:** [Users must have unique email, etc.]
**Scale:** [expected records, query patterns]

**Provide:**
1. ER diagram (text/mermaid format)
2. SQL schema (tables with types, constraints, indexes)
3. Migration script (CREATE TABLE statements)
4. Common queries (SELECT with JOIN, with EXPLAIN)
5. Index strategy (why each index exists)
6. Scalability considerations (partitioning, sharding)
```

## Quick Fixes

### Dependency Update

```
Update dependencies safely for [project]:

1. List outdated packages (compare current vs latest)
2. Check for breaking changes (changelog review)
3. Provide update commands (package manager specific)
4. Highlight required code changes (deprecated APIs, etc.)
5. Suggest testing strategy (which tests to run)
6. Rollback plan (if update fails)
```

### Environment Setup

```
Set up development environment for [project]:

Provide step-by-step:
1. Prerequisites (language version, system tools)
2. Installation commands (copy-paste ready)
3. Environment variables (with .env.example file)
4. Database setup (migrations, seed data)
5. Verification command (to test setup worked)
6. Troubleshooting common issues (table format)

Target OS: [macOS/Linux/Windows/all]
```

### Git Operations

```
Help with git [operation]:

**Operation:** [describe what you want to do]
**Current state:** [describe current branch/commits]

Provide:
1. Exact git commands (copy-paste ready)
2. Explanation of what each command does
3. How to verify success
4. How to undo if something goes wrong
5. Best practices for this operation
```

## Time-Saving Combinations

### Full Feature Implementation

```
Implement [feature name]:

**Requirements:** [detailed description]
**Tech stack:** [language, framework, libraries]

**Deliverables:**
1. Core implementation (following AGENTS_[TYPE].md)
2. Tests (unit + integration, 80%+ coverage)
3. Documentation (code comments + API docs if applicable)
4. Error handling (specific exceptions, clear messages)
5. Logging (structured, appropriate levels)
6. Example usage (runnable code)

Follow best practices from AGENTS_COMMON.md for error handling, security, performance.
```

### Bug Fix Pipeline

```
Fix this bug: [describe issue]

**Current behavior:** [what happens now]
**Expected behavior:** [what should happen]
**Error message:** [paste stack trace if available]
**Steps to reproduce:** [how to trigger the bug]

**Steps:**
1. Reproduce the issue (provide reproduction code)
2. Identify root cause (explain the why)
3. Provide fix with code (show diff)
4. Add test to prevent regression (test code)
5. Document why it happened (comment in code)
```

### Codebase Exploration

```
Explore codebase to understand [specific aspect]:

**Looking for:**
- [what you need to find: authentication flow, data model, etc.]

**Provide:**
1. Relevant files (with file paths)
2. Key functions/classes (with signatures)
3. Data flow diagram (text or mermaid)
4. Dependencies between components
5. Where to make changes for [specific goal]
6. Potential gotchas (things to be careful about)
```

## Refinement Prompts

### Clarity Refinement

```
Improve clarity of this [code/text]:

**Make it:**
- Easier to understand (reduce cognitive load)
- More explicit (no implicit behavior, magic numbers)
- Better named (descriptive, unambiguous)
- Self-documenting (code explains itself)

Without changing behavior or adding unnecessary comments.
```

### Conciseness Refinement

```
Make this more concise:

**Goals:**
- Remove redundancy (DRY violations)
- Simplify complex logic (reduce cyclomatic complexity)
- Reduce nesting (early returns, guard clauses)
- Keep readability (don't sacrifice clarity)

Show character/line count reduction percentage.
```

### Professional Refinement

```
Make this more professional:

**For:** [code/documentation/commit message/email]

**Adjust:**
- Tone (neutral, technical, no slang)
- Terminology (industry standard terms)
- Structure (conventional format for the type)
- Completeness (add missing context, remove assumptions)

Maintain the core message/functionality.
```

## Anti-Patterns

| Don't | Do |
|-------|-----|
| Use generic "fix my code" | Use specific prompts with context |
| Paste code without explaining the goal | State what you want to achieve |
| Ask for "best practices" without constraints | Specify your requirements and constraints |
| Request optimization without profiling | Show performance measurements first |
| Ask for tests without showing the code | Provide the code to be tested |
| Request docs without context | Explain the audience and use case |

## Quick Reference

| Task Type | Key Points | Template Section |
|-----------|-----------|------------------|
| Image fixes | Specific CSS/code changes, accessibility | Image Analysis & Fixes |
| Code review | Severity levels, line numbers, specific issues | Code Refinement → Code Review |
| Refactoring | Maintain behavior, show before/after | Code Refinement → Refactor Request |
| Testing | AAA pattern, edge cases, mocks | Testing → Generate Tests |
| Documentation | Follow standards, don't over-document | Documentation |
| Architecture | Trade-off analysis, context-specific | Architecture & Design |
| Bug fix | Root cause + prevention test | Quick Fixes → Bug Fix Pipeline |

## Using These Prompts

**Step-by-step:**
1. **Copy the prompt** for your task type
2. **Fill in the bracketed [context]** with your specifics
3. **Attach relevant files/screenshots** (code, errors, designs)
4. **Specify constraints** (language version, framework, performance targets)
5. **Reference AGENTS templates** if applicable (e.g., "Follow AGENTS_PYTHON.md")

**Example:**
```
[Copy "Code Review" prompt]
[Replace [Python] with "Python 3.11"]
[Attach the file: api.py]
[Add: "Focus on security issues"]
[Send]
```

## Prompt Chains

For complex tasks, chain prompts in sequence:

**Example: Refactor + Test + Document**
```
1. "Review this code" (Code Review template)
   → Get list of issues

2. "Refactor the issues found" (Refactor Request)
   → Get improved code

3. "Generate tests for refactored code" (Generate Tests)
   → Get test suite

4. "Add documentation" (Add Documentation)
   → Get documented code
```

**Example: Design + Implement + Validate**
```
1. "Design database schema for [feature]" (Database Schema Design)
   → Get schema

2. "Implement [feature] with this schema" (Full Feature Implementation)
   → Get code

3. "Review implementation for issues" (Code Review)
   → Get feedback

4. "Generate tests for [feature]" (Generate Tests)
   → Get tests
```

## When to Use Which Prompt

| Situation | Prompt Template | Additional Context Needed |
|-----------|-----------------|---------------------------|
| Bug visible in screenshot | Error Screenshot Debug | Error message, expected behavior |
| Code works but messy | Refactor Request | What "messy" means (duplication, naming, etc.) |
| Missing tests | Generate Tests | Test framework, coverage requirements |
| Slow performance | Performance Optimization | Current timing, acceptable threshold |
| Need to understand codebase | Codebase Exploration | What you're trying to accomplish |
| Implementing new feature | Full Feature Implementation | Tech stack, detailed requirements |
| Choosing between approaches | Architecture Decision | Constraints, scale, team expertise |
| Need better error messages | Error Fix + Add Documentation | Current errors, user context |
| API needs docs | API Documentation | Authentication, rate limits |
| Setting up project | Environment Setup | Target OS, team skillset |

## Customization Tips

**Adapt prompts to your needs:**

1. **Add your standards**: "Follow our [coding standard link]"
2. **Specify tools**: "Use [pytest/jest/rspec] for testing"
3. **Set constraints**: "Keep response under 100 lines", "No external dependencies"
4. **Define audience**: "Explain for junior developers", "Technical audience only"
5. **Combine prompts**: Merge relevant sections from multiple prompts

**Example customization:**
```
Original: "Generate tests for this code"

Customized: "Generate pytest tests for this code following AGENTS_PYTHON.md.
Include fixtures in conftest.py. Focus on edge cases for the validation logic.
Use factory_boy for test data generation."
```

## Template Combinations

| Goal | Templates to Combine |
|------|---------------------|
| Build Python CLI tool | AGENTS_PYTHON.md + AGENTS_CLI.md + Code Review |
| Create REST API | AGENTS_API.md + Code Review + Generate Tests |
| Fix UI bug | Error Screenshot Debug + Design to Code + Code Review |
| Refactor legacy code | Codebase Exploration + Code Review + Refactor Request |
| Add feature end-to-end | Full Feature Implementation + Generate Tests + Add Documentation |
| Optimize slow endpoint | Performance Optimization + Code Review + Generate Tests |

## Advanced Usage

### Context Layering

Build context progressively for complex tasks:

```
Layer 1: "Explore codebase to understand authentication"
Layer 2: "Review auth code for security issues"
Layer 3: "Refactor auth to use OAuth2"
Layer 4: "Generate tests for OAuth2 implementation"
```

### Iterative Refinement

Use refinement prompts in multiple passes:

```
Pass 1: Clarity Refinement → get clearer code
Pass 2: Conciseness Refinement → get shorter code
Pass 3: Code Review → validate changes
Pass 4: Professional Refinement → polish for production
```

### Validation Loop

Always validate AI output:

```
1. Request code with "Full Feature Implementation"
2. Run "Code Review" on the generated code
3. Fix issues with "Error Fix"
4. Validate with "Generate Tests"
5. Document with "Add Documentation"
```

## When Working with These Prompts

1. **Be specific**: More context = better results
2. **Iterate**: Refine prompts based on initial output
3. **Validate**: Always review AI-generated code/text
4. **Combine**: Use multiple prompts for complex tasks
5. **Customize**: Adapt prompts to your project standards
6. **Reference templates**: Point to AGENTS_*.md for consistent output
7. **Chain thoughtfully**: Order prompts logically (explore → design → implement → test)
8. **Save time**: Bookmark frequently used prompts
9. **Share**: Create project-specific prompt collections
10. **Evolve**: Update prompts based on what works

---

Combine these prompts with relevant AGENTS_*.md templates for best results.
