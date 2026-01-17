# AGENTS_ADR_RESEARCH.md

Instructions for AI models researching and structuring Architecture Decision Records (ADRs).

Use this when asked to help with architectural decisions. Your role is to research options, gather evidence, and produce decision-ready ADR documents.

## Research Process

Follow this 5-phase process for each ADR:

```
1. Scope      --> Define the decision and constraints
2. Research   --> Gather data on options
3. Analyze    --> Compare options against criteria
4. Structure  --> Write the ADR document
5. Validate   --> Check completeness and accuracy
```

## Phase 1: Scope

Before researching, clarify the decision boundaries.

### Required Information

| Question | Why It Matters |
|----------|----------------|
| What decision needs to be made? | Defines the scope |
| What domain? (Dev/Infra/Data) | Determines evaluation criteria |
| What are the hard constraints? | Eliminates non-viable options |
| What is the current state? | Establishes baseline for comparison |
| Who are the stakeholders? | Shapes communication style |
| What is the timeline? | Affects depth of research |

### Scope Definition Template

```markdown
DECISION: [One sentence describing what needs to be decided]
DOMAIN: [Development / Infrastructure / Data]
CONSTRAINTS:
- Must: [hard requirements]
- Must not: [explicit exclusions]
- Should: [important preferences]
CURRENT STATE: [existing solution or "greenfield"]
STAKEHOLDERS: [teams or roles who will be affected]
TIMELINE: [when decision is needed]
```

### Example Scope Definition

```markdown
DECISION: Select a message queue for event-driven communication between services
DOMAIN: Infrastructure
CONSTRAINTS:
- Must: Support at-least-once delivery
- Must: Handle 50K messages/second sustained
- Must not: Require dedicated operations team (managed preferred)
- Should: Cost under $5K/month at projected scale
CURRENT STATE: Direct HTTP calls between services (synchronous)
STAKEHOLDERS: Platform team, application developers, SRE
TIMELINE: Decision needed in 2 weeks for Q2 roadmap
```

## Phase 2: Research

Gather data systematically for each option.

### Research Checklist

For each viable option, collect:

**Technical Data:**
- [ ] Official documentation links
- [ ] Supported platforms and versions
- [ ] Performance characteristics (throughput, latency)
- [ ] Scalability limits and patterns
- [ ] Integration requirements (SDKs, protocols)
- [ ] Security model (auth, encryption, compliance)

**Operational Data:**
- [ ] Deployment options (managed, self-hosted, hybrid)
- [ ] Monitoring and observability support
- [ ] Backup and disaster recovery
- [ ] Upgrade and migration paths
- [ ] Support options and SLAs

**Cost Data:**
- [ ] Pricing model (per-unit, tiered, flat)
- [ ] Cost at current scale
- [ ] Cost at projected scale (6-month, 12-month)
- [ ] Hidden costs (egress, support, training)

**Ecosystem Data:**
- [ ] Community size and activity
- [ ] Third-party integrations
- [ ] Learning resources and documentation quality
- [ ] Vendor stability and roadmap

### Research Sources by Domain

| Domain | Primary Sources | Secondary Sources |
|--------|-----------------|-------------------|
| Development | Official docs, GitHub repos, Stack Overflow | Blog posts, conference talks, benchmarks |
| Infrastructure | Vendor docs, pricing calculators, status pages | Cloud comparison sites, case studies |
| Data | Vendor docs, benchmark papers, data engineering blogs | Community forums, conference talks |

### Search Patterns

```
# For technology evaluation
"[technology] vs [alternative] 2024"
"[technology] production experience"
"[technology] at scale case study"
"[technology] limitations"

# For pricing
"[technology] pricing calculator"
"[technology] cost optimization"
"[technology] TCO comparison"

# For operational concerns
"[technology] incident postmortem"
"[technology] monitoring best practices"
"[technology] migration guide"
```

## Phase 3: Analyze

Compare options against decision drivers.

### Evaluation Matrix

Create a matrix mapping options to criteria:

```markdown
| Criterion | Weight | Option A | Option B | Option C |
|-----------|--------|----------|----------|----------|
| Throughput (50K msg/s) | Must | Yes | Yes | No |
| Managed service | Should | Yes | Partial | Yes |
| Cost < $5K/mo | Should | $3.2K | $4.8K | $2.1K |
| Team expertise | Nice | High | Low | Medium |
| **Score** | | 8/10 | 6/10 | N/A |
```

Mark options that fail "Must" criteria as non-viable. Don't waste analysis time on them.

### Scoring Rules

| Rating | Meaning |
|--------|---------|
| Yes / Meets | Fully satisfies the criterion |
| Partial | Requires workaround or compromise |
| No / Fails | Does not satisfy the criterion |

For quantitative criteria, use actual numbers. For qualitative criteria, use Low/Medium/High.

### Trade-off Analysis

Document the key trade-offs explicitly:

```markdown
## Key Trade-offs

**Option A (Kafka):**
- Higher operational complexity in exchange for maximum flexibility
- Requires dedicated expertise but provides full control

**Option B (SQS + SNS):**
- Limited features in exchange for zero operations burden
- Vendor lock-in but deep AWS integration
```

## Phase 4: Structure

Write the ADR following AGENTS_ADR.md format.

### ADR Writing Checklist

- [ ] Title clearly states the decision
- [ ] Metadata table (Status, Domain, Date, Deciders)
- [ ] Context explains why this decision is needed now
- [ ] Decision drivers are numbered and prioritized (Must/Should/Nice)
- [ ] At least 2 options analyzed with consistent criteria
- [ ] Each option has pros, cons, and assessment table
- [ ] Decision is stated in one clear sentence
- [ ] Consequences cover positive, negative, and neutral impacts
- [ ] Follow-up actions are listed with references

### Context Writing Guide

Good context answers these questions:
1. What is the current situation?
2. What problem or opportunity triggered this decision?
3. Why does it need to be addressed now?
4. What happens if we do nothing?

```markdown
## Context

<!-- Bad: vague and generic -->
We need to improve our data pipeline performance.

<!-- Good: specific and actionable -->
Our nightly ETL job now takes 8 hours to process 2TB of data, exceeding the 6-hour
maintenance window. Jobs are failing 3x per week due to timeout. Business requires
hourly inventory updates for the new fulfillment system launching in Q2.
```

### Decision Writing Guide

State the decision directly, then provide brief rationale:

```markdown
## Decision

<!-- Bad: buries the decision -->
After careful consideration of all factors and extensive discussion with stakeholders,
we have determined that the best path forward would be to potentially consider...

<!-- Good: decision first -->
We will use Apache Kafka on Confluent Cloud for inter-service messaging.

This option meets all must-have requirements, offers the best cost-to-flexibility
ratio at our scale, and aligns with the platform team's existing expertise.
```

### Consequences Writing Guide

Be specific about impacts. Vague consequences don't help future readers:

```markdown
## Consequences

<!-- Bad: vague -->
- Better performance
- Some complexity added
- Team needs training

<!-- Good: specific -->
### Positive
- Query latency reduced from 800ms to 120ms (p95)
- Can handle 10x current load without architectural changes

### Negative
- Adds $2,400/month to infrastructure costs
- Requires 2 weeks of team training on Kafka operations
- Introduces new failure mode: consumer lag during traffic spikes

### Neutral
- No changes to existing API contracts
- Monitoring dashboards need 3 new panels (estimated: 4 hours)
```

## Phase 5: Validate

Check the ADR before finalizing.

### Validation Checklist

**Completeness:**
- [ ] All required sections present
- [ ] At least 2 options analyzed
- [ ] Decision clearly stated
- [ ] All consequence types documented

**Accuracy:**
- [ ] Pricing data is current (check vendor pages)
- [ ] Technical claims cite sources
- [ ] Limitations are not understated
- [ ] Comparisons are fair (same criteria for each option)

**Actionability:**
- [ ] Decision can be implemented from this document
- [ ] Follow-up actions are specific
- [ ] Stakeholders can understand trade-offs
- [ ] Future readers can understand the context

**Objectivity:**
- [ ] Rejected options have fair analysis
- [ ] Vendor marketing is translated to operational reality
- [ ] Uncertainty is called out explicitly
- [ ] Personal preferences are separated from evidence

### Common Validation Issues

| Issue | Fix |
|-------|-----|
| Missing rejection rationale | Add why each rejected option was rejected |
| Stale pricing | Re-check pricing calculator on vendor site |
| Unverified performance claims | Add "Verify:" note or cite benchmark source |
| One-sided consequences | Add at least one negative consequence |
| Vague follow-up actions | Add owner, timeline, or ADR reference |

## Domain-Specific Research

### Development Decisions

Focus areas:
- API compatibility and versioning
- Testing and debugging support
- Developer experience (DX)
- Library maintenance and release cadence
- License compatibility

Key questions:
- Does this integrate with our existing stack?
- What is the learning curve for the team?
- How active is the maintainer community?
- What happens if the library is abandoned?

### Infrastructure Decisions

Focus areas:
- Availability and SLA guarantees
- Disaster recovery capabilities
- Compliance certifications
- Multi-region support
- Cost scaling behavior

Key questions:
- What is the blast radius of failures?
- How do we handle capacity planning?
- What are the vendor lock-in implications?
- How does this affect our security posture?

### Data Decisions

Focus areas:
- Data consistency guarantees
- Schema evolution support
- Query performance characteristics
- Data governance and lineage
- Retention and archival capabilities

Key questions:
- How do we handle schema changes?
- What are the data freshness guarantees?
- How do we ensure data quality?
- What are the compliance implications (GDPR, CCPA)?

## Output Artifacts

Produce these artifacts for each ADR:

| Artifact | Purpose | Location |
|----------|---------|----------|
| ADR document | The decision record | `docs/decisions/NNNN-title.md` |
| Research notes | Supporting evidence | `docs/decisions/research/NNNN-notes.md` (optional) |
| Index update | Add to ADR index | `docs/decisions/index.md` |

### Research Notes Template (Optional)

For complex decisions, keep detailed research separate:

```markdown
# Research Notes: ADR-NNNN

## Sources Consulted
- [link] - [what was found]
- [link] - [what was found]

## Pricing Calculations
[Show the math for cost estimates]

## Benchmark Data
[Raw performance numbers with methodology]

## Expert Opinions
[Quotes from relevant sources]

## Open Questions
[Things that couldn't be verified]
```

## Anti-Patterns

| Don't | Do |
|-------|-----|
| Start writing before understanding constraints | Define scope first with stakeholder input |
| Research only the preferred option | Analyze at least 2 viable alternatives fairly |
| Copy vendor marketing claims | Translate to operational reality with numbers |
| Ignore the "do nothing" option | Consider it explicitly, even if rejected |
| Present analysis without recommendation | Make a clear decision with rationale |
| Hide uncertainty | Call out unknowns with "Verify:" notes |
| Write for future readers only | Include enough context for current stakeholders |
| Skip cost analysis | Include TCO for infrastructure and data decisions |
| Assume current scale | Project costs and capacity at 6-month and 12-month horizons |
| Research indefinitely | Time-box research to match decision timeline |

## Quick Reference

| Aspect | Standard |
|--------|----------|
| Research phases | Scope, Research, Analyze, Structure, Validate |
| Minimum options | 2 viable alternatives analyzed |
| Pricing data | Current rates from vendor pricing pages |
| Evidence standard | Official docs first, cite sources |
| Uncertainty handling | Mark with "Verify:" and source link |
| Output format | Follow AGENTS_ADR.md structure |
| Time allocation | 60% research, 30% writing, 10% validation |
| Scope clarification | Get stakeholder input before deep research |

## When Researching ADRs

1. Clarify the decision scope before researching
2. Identify hard constraints to eliminate non-viable options early
3. Research at least 2 viable alternatives with equal depth
4. Use official documentation as primary source
5. Verify pricing data on vendor sites
6. Call out uncertainty explicitly rather than guessing
7. Create evaluation matrix before writing pros/cons
8. State the decision in one sentence at the start of the Decision section
9. Document all consequence types (positive, negative, neutral)
10. Validate the ADR against the checklist before finalizing

## See Also

- AGENTS_ADR.md for ADR structure and formatting
- AGENTS_TECH_RESEARCH.md for technology evaluation patterns
