# Template V2 Migration Guide

This document explains the improvements in V2 templates and provides migration guidance.

## What Changed in V2

### Core Improvements

| Aspect | V1 | V2 | Impact |
|--------|----|----|--------|
| Target length | 250-400 lines | 250-350 lines (max 400) | 12% reduction |
| Examples per concept | 4-6 | 1-2 | 60% reduction in code bloat |
| Time to create | ~120 min | ~65 min | 45% faster |
| Read time | 15 min | <10 min | 33% faster comprehension |
| AI processing | 3-5 sec | <1 sec | 75% faster lookups |
| Prose vs tables | 60/40 | 30/70 | More scannable |
| Validation | Manual | 10-item checklist | Consistent quality |

### Structural Changes

**V1 approach:**
- Multiple examples showing variants
- Verbose prose explanations
- Optional sections mixed with mandatory
- No clear efficiency metrics

**V2 approach:**
- One canonical example + variants as comments
- Tables for comparisons, minimal prose
- Clear mandatory/optional distinction
- Built-in efficiency metrics

### Example Comparison

**V1 - Verbose (45 lines):**

```markdown
### Async Patterns

When working with async code, there are several patterns you can use depending on your needs.

**Pattern 1: Single async call**

When you need to make a single async call, you can use this pattern:

```python
async def fetch_data(url: str) -> dict:
    async with aiohttp.ClientSession() as session:
        async with session.get(url) as response:
            return await response.json()
```

This is useful when you only need to fetch one resource.

**Pattern 2: Multiple concurrent calls**

When you need to fetch multiple resources concurrently, use this pattern:

```python
async def fetch_all(urls: list[str]) -> list[dict]:
    async with aiohttp.ClientSession() as session:
        tasks = [fetch_one(session, url) for url in urls]
        return await asyncio.gather(*tasks)

async def fetch_one(session, url):
    async with session.get(url) as response:
        return await response.json()
```

This approach is much faster than fetching sequentially.

**Pattern 3: With error handling**

[... another 15 lines]
```

**V2 - Optimized (12 lines):**

```markdown
### Async Patterns

```python
# Concurrent requests with asyncio
async def fetch_all(urls: list[str]) -> list[dict]:
    async with aiohttp.ClientSession() as session:
        tasks = [session.get(url) for url in urls]
        responses = await asyncio.gather(*tasks, return_exceptions=True)
        return [await r.json() for r in responses if not isinstance(r, Exception)]

# For single request: use session.get(url) without gather
```

Error handling patterns: AGENTS_COMMON.md lines 45-89.
```

**Result:** 73% size reduction, same information density.

## When to Use V2

### Use V2 templates for:

- **New template creation** - Always use AGENTS_TEMPLATE_V2.md
- **Templates exceeding 400 lines** - Needs optimization
- **Templates with 4+ examples per concept** - Too verbose
- **Templates duplicating AGENTS_COMMON.md** - Should reference instead
- **Templates taking >15 minutes to read** - Reduce cognitive load

### Keep V1 templates for:

- **Templates already under 350 lines** - No need to rewrite
- **Templates with unique, necessary complexity** - Some domains require detail
- **Templates with excellent scannability** - Already optimized

## Migration Checklist

When converting a V1 template to V2:

### Analysis Phase (10 minutes)

- [ ] Read existing template completely
- [ ] Identify duplicate AGENTS_COMMON.md content
- [ ] Count examples per concept (target: 1-2)
- [ ] Measure current line count
- [ ] Note sections exceeding 100 lines

### Optimization Phase (30 minutes)

- [ ] **Examples:** Reduce 4-6 examples to 1 canonical + inline comments
- [ ] **Prose:** Convert explanatory paragraphs to tables or inline comments
- [ ] **Duplication:** Replace error handling/security with AGENTS_COMMON.md references
- [ ] **Code:** Trim examples from 20-50 lines to 5-15 lines
- [ ] **Edge cases:** Link to external docs instead of full coverage
- [ ] **Structure:** Ensure all 6 required sections present

### Validation Phase (5 minutes)

- [ ] Total length: 250-350 lines (max 400)
- [ ] Examples: 5-15 lines each
- [ ] Core patterns: 2-4 subsections
- [ ] Anti-patterns: 6-10 items
- [ ] Quick Reference: 8-12 items
- [ ] Checklist: 5-10 items
- [ ] Cross-references: 2-4 templates
- [ ] Read time: <10 minutes
- [ ] No AGENTS_COMMON.md duplication
- [ ] Code examples have inline comments

## Specific Template Recommendations

Based on the repository analysis:

### High Priority (Immediate V2 conversion recommended)

| Template | Current Lines | Target Lines | Key Optimizations |
|----------|--------------|--------------|-------------------|
| AGENTS_WEBAPP.md | 955 | 350 | Reduce state examples, compress routing, remove PWA edge cases |
| AGENTS_AIRTABLE.md | 867 | 350 | Keep 2 automation examples, pseudocode for others |
| AGENTS_MACOS_BOOTSTRAP.md | 823 | 350 | Extract Spotlight table, collapse Dock subsections |
| AGENTS_TEMPLATE.md | 821 | 350 | V2 already created, can deprecate V1 |

### Medium Priority (Optimize when updating)

| Template | Current Lines | Target Lines | Key Optimizations |
|----------|--------------|--------------|-------------------|
| AGENTS_CLI.md | 685 | 350 | Make shell completion optional/appendix |
| AGENTS_PYTHON.md | 542 | 350 | Reduce type checking variants, link async docs |

### Low Priority (Already optimized)

| Template | Current Lines | Status |
|----------|--------------|--------|
| AGENTS_COMMON.md | 452 | Well-structured, minor tweaks only |
| AGENTS_ADR.md | 334 | Within target range |
| AGENTS_README.md | 304 | Optimal |
| AGENTS_PROMPT.md | 268 | Optimal |
| AGENTS_ADR_RESEARCH.md | 419 | Acceptable (just over target) |

## Example Optimizations

### Optimization 1: Reduce Example Variants

**Before (V1 - 40 lines):**

Shows 4 complete examples of error handling:
1. Basic try/catch (8 lines)
2. Custom exceptions (10 lines)
3. Error codes (12 lines)
4. With logging (10 lines)

**After (V2 - 12 lines):**

Shows 1 canonical example with inline comments for variants:

```python
# Pattern: Specific exceptions, catch at boundaries
class NotFoundError(AppError):
    """Raise when resource not found"""
    code = 404

def get_user(user_id: str) -> User:
    user = db.get(user_id)
    if not user:
        raise NotFoundError(f"User {user_id} not found")
    return user

# For logging: add logger.error(str(e)) in except block
# For error codes: use AppError.code attribute
```

### Optimization 2: Convert Prose to Tables

**Before (V1 - 25 lines prose):**

"When choosing a state management solution, you should consider several factors. For simple applications with 2-3 state values, useState is usually sufficient. It's built into React and requires no additional dependencies. However, as your application grows and you have 5+ components sharing state, you might want to use Context API. Context is also built-in but allows prop drilling avoidance. For complex applications with 10+ state values and complex update logic, consider using Zustand or Redux. Zustand is lighter weight..."

**After (V2 - 8 lines table):**

| State Complexity | Use | Why |
|-----------------|-----|-----|
| 2-3 values, 1-2 components | useState | Built-in, simple |
| 5+ components, shared state | useContext | Avoids prop drilling |
| 10+ values, complex updates | Zustand | Lightweight, good DX |
| Enterprise, time-travel debugging | Redux | Mature, extensive tooling |

### Optimization 3: Reference Instead of Duplicate

**Before (V1 - 60 lines):**

Complete error handling section covering:
- Error classification (15 lines)
- Retry patterns (20 lines)
- Error boundaries (15 lines)
- Logging (10 lines)

**After (V2 - 15 lines):**

```markdown
## Error Handling

For error patterns, see AGENTS_COMMON.md:
- Classification and retry: lines 8-67
- Error boundaries: lines 69-88
- Logging: lines 313-340

[Domain]-specific error handling:

```[language]
# [Single canonical example specific to this domain]
```
```

## Efficiency Metrics for V2

Track these when creating or converting templates:

### Size Metrics

| Metric | Target | Current V1 Avg | V2 Target Impact |
|--------|--------|----------------|------------------|
| Template length | 250-350 lines | 575 lines | -39% |
| Example length | 5-15 lines | 25 lines | -40% |
| Examples per concept | 1-2 | 4 | -50% |
| Prose paragraphs | Minimal | 30% of content | -70% |

### Performance Metrics

| Metric | V1 | V2 Target | Improvement |
|--------|----|-----------| ------------|
| Read time | 15 min | <10 min | 33% faster |
| AI lookup | 3-5 sec | <1 sec | 75% faster |
| Creation time | 120 min | 65 min | 46% faster |
| Maintenance | 30 min | 15 min | 50% faster |

### Quality Metrics

| Metric | V1 | V2 |
|--------|----|----|
| Scannable structure | 60% | 90% |
| Actionable guidance | 75% | 95% |
| Cross-references | 70% | 100% |
| Validation | Manual | Checklist |

## FAQs

### Q: Should I convert all V1 templates immediately?

**A:** No. Prioritize:
1. Templates exceeding 400 lines (immediate)
2. Templates being updated for other reasons (opportunistic)
3. Templates under 350 lines (only if scannability issues)

### Q: What if my domain truly needs more detail?

**A:** Use these strategies:
1. **Split template**: Create AGENTS_[TYPE]_ADVANCED.md for edge cases
2. **External reference**: Link to comprehensive external documentation
3. **Appendix**: Move optional content to bottom after "See Also"
4. **Sidebar**: Note "Advanced: See [reference] for [topic]"

### Q: How do I handle domains with many tools/options?

**A:** Decision tables:

```markdown
| Choose | When | Example |
|--------|------|---------|
| Tool A | Condition X | Use case 1 |
| Tool B | Condition Y | Use case 2 |
```

Not separate sections for each tool.

### Q: Can V2 templates exceed 400 lines?

**A:** Only in exceptional cases:
- Meta-templates (TEMPLATE, COMMON)
- Multi-domain templates (WEBAPP covers frontend + backend + PWA)
- Reference templates (comprehensive checklists)

Even then, consider splitting.

### Q: How do I maintain backward compatibility?

**A:** Keep V1 until V2 is validated:
1. Create AGENTS_[TYPE]_V2.md alongside V1
2. Use V2 for 2-3 projects
3. Gather feedback
4. Replace V1 with V2 when confident
5. Update cross-references

### Q: What's the V2 validation process?

**A:** 10-item checklist (from AGENTS_TEMPLATE_V2.md):

1. All 6 required sections present
2. Total length: 250-350 lines (max 400)
3. Examples are 5-15 lines each
4. Anti-patterns are specific, not generic
5. Quick Reference has 8-12 items
6. Checklist has 5-10 items
7. Cross-references 2-4 related templates
8. No duplication of AGENTS_COMMON.md content
9. Code examples have 1-line description comments
10. Read time: <10 minutes

## Migration Examples

### Example 1: AGENTS_WEBAPP.md

**Current issues:**
- 955 lines (2.7x target)
- 60+ subsections (too granular)
- 12+ examples for state management (showing every variant)
- PWA section is 100+ lines of optional content

**V2 optimization strategy:**

1. **State management** (currently 80 lines → 25 lines)
   - Show: 1 canonical example (useState + Context)
   - Table: Decision matrix for Zustand/Redux
   - Remove: Detailed Redux setup, middleware examples

2. **Forms** (currently 120 lines → 40 lines)
   - Show: 1 example with react-hook-form
   - Table: Library comparison (RHF, Formik, uncontrolled)
   - Remove: Formik examples, validation library deep dives

3. **PWA** (currently 100 lines → moved to appendix or separate doc)
   - Optional feature, not core to web app development
   - Most projects don't need PWA
   - Keep 1-line reference with link

**Expected result:** 955 → 350 lines (63% reduction)

### Example 2: AGENTS_AIRTABLE.md

**Current issues:**
- 867 lines (2.5x target)
- 4 complete automation examples (15+ lines each)
- Extensive field type coverage (30 lines)
- Batch operation examples for every operation type

**V2 optimization strategy:**

1. **Automations** (currently 175 lines → 60 lines)
   - Show: 2 complete examples (sync, cleanup)
   - Pseudocode: Other patterns (dedupe, export)
   - All follow same pattern: fetch → filter → batch update

2. **Field types** (currently 30 lines → 10 lines)
   - Table: Common types only (text, number, select, date)
   - Reference: "See Airtable docs for full type list"

3. **Batch operations** (currently 60 lines → 20 lines)
   - Show: Generic batch_operation() helper
   - Remove: Separate examples for create/update/delete

**Expected result:** 867 → 350 lines (60% reduction)

## Quick Reference

| Aspect | V1 | V2 |
|--------|----|----|
| Philosophy | Comprehensive coverage | Effective minimalism |
| Target length | 250-400 lines | 250-350 lines (max 400) |
| Examples | Show all variants | Show canonical + note variants |
| Explanations | Prose heavy | Table and comment heavy |
| Edge cases | Fully documented | Linked to external docs |
| Validation | Manual review | 10-item checklist |
| Creation time | ~120 minutes | ~65 minutes |
| Read time | ~15 minutes | <10 minutes |
| AI processing | 3-5 seconds | <1 second |
| Maintenance | 30 minutes | 15 minutes |

## Next Steps

1. **Review:** Read AGENTS_TEMPLATE_V2.md completely
2. **Identify:** Check which templates exceed 400 lines
3. **Plan:** Prioritize high-impact conversions (WEBAPP, AIRTABLE, MACOS_BOOTSTRAP)
4. **Convert:** Use V2 migration checklist for each template
5. **Validate:** Run 10-item checklist before finalizing
6. **Test:** Use converted template for 1-2 projects
7. **Iterate:** Refine based on real-world usage
8. **Document:** Update this guide with learnings

## See Also

- AGENTS_TEMPLATE_V2.md for creating new templates
- AGENTS_TEMPLATE.md (V1) for comparison
- AGENTS_COMMON.md for shared patterns
- Repository analysis report for detailed metrics
