# AGENTS_ADR.md

Instructions for AI models creating Architecture Decision Records (ADRs).

ADRs document significant technical decisions, their context, and rationale. Use this template for decisions spanning Development, Infrastructure, and Data domains.

## Project Structure

Store ADRs in a dedicated directory with consistent naming:

```
docs/
└── decisions/
    ├── 0001-use-postgresql-for-primary-database.md
    ├── 0002-adopt-event-driven-architecture.md
    ├── 0003-migrate-to-kubernetes.md
    ├── 0004-implement-data-lake-on-s3.md
    └── index.md                              # Lists all ADRs with status
```

**Naming convention:** `NNNN-short-title-with-dashes.md`
- Sequential numbering (0001, 0002)
- Lowercase with dashes
- Descriptive but concise (3-7 words)

## ADR Structure

Every ADR follows this structure:

```markdown
# ADR-NNNN: [Title]

| Field | Value |
|-------|-------|
| Status | Proposed / Accepted / Deprecated / Superseded by [ADR-XXXX] |
| Domain | Development / Infrastructure / Data |
| Date | YYYY-MM-DD |
| Deciders | [names or teams] |

## Context

[Why this decision is needed now]

## Decision Drivers

[Numbered list of requirements and constraints]

## Options Considered

[Analysis of each option]

## Decision

[The chosen option with brief rationale]

## Consequences

[Impacts, trade-offs, follow-up actions]
```

## Domain Classification

Classify each ADR by its primary domain:

| Domain | Scope | Examples |
|--------|-------|----------|
| Development | Code, frameworks, libraries, patterns, testing | API design, state management, auth library |
| Infrastructure | Deployment, networking, scaling, security, observability | Cloud provider, container orchestration, CI/CD |
| Data | Storage, pipelines, analytics, governance, ML | Database selection, ETL tools, data catalog |

Cross-domain decisions (e.g., data platform on cloud infrastructure) list the primary domain first.

## Context Section

Explain why this decision is needed. Include:

**Business context:** What problem or opportunity drives this?

```markdown
## Context

Our e-commerce platform processes 50K orders daily with 99.9% uptime requirements.
Current monolithic deployment causes 2-hour maintenance windows for each release.
Business projects 3x growth next year, requiring horizontal scaling capability.
```

**Technical context:** What existing systems or constraints apply?

```markdown
## Context

The data team spends 40% of time on manual data quality checks.
Current batch ETL runs nightly, but business needs hourly inventory updates.
Existing Airflow infrastructure can be extended or replaced.
```

## Decision Drivers Section

List specific requirements that guide the evaluation:

```markdown
## Decision Drivers

1. Must support 10K concurrent connections
2. Must integrate with existing LDAP authentication
3. Should reduce deployment time from 2 hours to under 15 minutes
4. Should maintain cost under $50K/month at projected scale
5. Nice to have: managed service to reduce operational burden
```

Use **Must** for hard requirements, **Should** for important preferences, **Nice to have** for optional benefits.

## Options Section

Analyze each viable option with consistent structure:

```markdown
## Options Considered

### Option 1: PostgreSQL on RDS

**Description:** Managed PostgreSQL with Multi-AZ deployment.

| Criterion | Assessment |
|-----------|------------|
| Concurrent connections | 10K with PgBouncer (meets requirement) |
| LDAP integration | Native support via pg_hba.conf |
| Cost at scale | ~$2,400/month (db.r6g.xlarge Multi-AZ) |
| Operational burden | Low (managed backups, patching, failover) |

**Pros:**
- Team has PostgreSQL expertise
- Mature ecosystem, extensive tooling
- Strong consistency guarantees

**Cons:**
- Vertical scaling has limits
- Complex sharding if needed later

### Option 2: CockroachDB Serverless

**Description:** Distributed SQL with automatic scaling.

| Criterion | Assessment |
|-----------|------------|
| Concurrent connections | Unlimited (serverless architecture) |
| LDAP integration | Requires external auth proxy |
| Cost at scale | ~$4,200/month (estimated based on RUs) |
| Operational burden | Very low (fully managed) |

**Pros:**
- Automatic horizontal scaling
- Strong consistency with distribution
- No connection pooling needed

**Cons:**
- Higher cost at current scale
- Team needs training
- Fewer ORMs support CockroachDB-specific features
```

## Decision Section

State the decision clearly with brief rationale:

```markdown
## Decision

We will use **PostgreSQL on RDS** with PgBouncer for connection pooling.

**Rationale:**
- Meets all must-have requirements
- 40% lower cost than alternatives at projected scale
- Team expertise reduces implementation risk
- Can migrate to Aurora or CockroachDB later if scaling limits are reached
```

Avoid restating the full analysis. Reference the options section for details.

## Consequences Section

Document impacts across three categories:

```markdown
## Consequences

### Positive
- Deployment time reduced to ~10 minutes (from 2 hours)
- Team can ship features independently
- Horizontal scaling enables 10x growth without architectural changes

### Negative
- Increased operational complexity (12 services vs 1 monolith)
- Requires investment in observability tooling
- Team needs distributed systems training

### Neutral
- No change to customer-facing API contracts
- Existing CI/CD pipelines require modification, not replacement

### Follow-up Actions
- [ ] Set up service mesh for inter-service communication (ADR-0015)
- [ ] Implement distributed tracing (spike: 2 weeks)
- [ ] Update runbooks for service-level incident response
```

## Domain-Specific Sections

Add relevant sections based on the domain:

### Development ADRs

```markdown
## API Contract

| Endpoint | Method | Breaking Change |
|----------|--------|-----------------|
| /users | GET | No |
| /users/{id} | GET | No |
| /users | POST | Yes - new required field `email_verified` |

## Migration Path

1. Deploy new service alongside existing (feature flagged)
2. Migrate 10% traffic, monitor for 1 week
3. Gradual rollout to 100% over 3 weeks
4. Deprecate old endpoint after 90 days
```

### Infrastructure ADRs

```markdown
## Capacity Planning

| Metric | Current | 6-Month Projection | 12-Month Projection |
|--------|---------|-------------------|---------------------|
| Requests/sec | 1,200 | 2,400 | 5,000 |
| Storage (TB) | 2.1 | 4.5 | 10 |
| Monthly cost | $12K | $24K | $45K |

## Rollback Plan

1. DNS failover to previous infrastructure (RTO: 5 minutes)
2. Database point-in-time recovery available for 7 days
3. Previous container images retained for 30 days
```

### Data ADRs

```markdown
## Data Flow

```
Source Systems --> Ingestion (Kafka) --> Processing (Spark) --> Storage (Delta Lake) --> Serving (Presto)
```

## Schema Changes

| Table | Change | Backward Compatible |
|-------|--------|---------------------|
| orders | Add column `fulfillment_method` | Yes (nullable) |
| customers | Rename `phone` to `phone_number` | No (alias added) |

## Data Quality

| Check | Threshold | Action if Failed |
|-------|-----------|------------------|
| Null rate for `order_id` | 0% | Block pipeline, alert on-call |
| Duplicate orders | < 0.01% | Log warning, deduplicate downstream |
| Freshness | < 1 hour | Alert if stale, continue processing |
```

## Status Lifecycle

Track ADR status over time:

| Status | Meaning |
|--------|---------|
| Proposed | Under discussion, not yet approved |
| Accepted | Approved and active |
| Deprecated | No longer recommended for new work |
| Superseded | Replaced by another ADR (link to replacement) |

Update status in the header when changes occur:

```markdown
| Status | Superseded by [ADR-0042](0042-migrate-to-aurora.md) |
```

## Anti-Patterns

| Don't | Do |
|-------|-----|
| Write ADRs after implementation is complete | Write ADRs before or during implementation |
| List options without evaluation criteria | Define decision drivers first, then evaluate against them |
| Describe only the chosen option | Document rejected options and why they were rejected |
| Use vague terms like "scalable" or "modern" | Use measurable criteria: "supports 10K connections" |
| Skip consequences section | Document positive, negative, and neutral impacts |
| Leave ADRs in "Proposed" indefinitely | Update status when decision is made or superseded |
| Create ADRs for trivial decisions | Reserve ADRs for decisions with significant impact or reversibility cost |
| Copy-paste marketing content | Translate vendor claims into operational reality |
| Ignore cost implications | Include TCO estimates for infrastructure and data decisions |
| Write for a single audience | Include both technical details and business context |

## Quick Reference

| Aspect | Standard |
|--------|----------|
| Location | `docs/decisions/` |
| Naming | `NNNN-short-title.md` (lowercase, dashes) |
| Required sections | Context, Decision Drivers, Options, Decision, Consequences |
| Status values | Proposed, Accepted, Deprecated, Superseded |
| Domain tags | Development, Infrastructure, Data |
| Evaluation format | Criteria table + Pros/Cons for each option |
| Index file | `index.md` listing all ADRs with status and date |
| Review cycle | Quarterly review for active ADRs |

## When Writing ADRs

1. Confirm the decision warrants an ADR (significant impact, hard to reverse)
2. Identify the primary domain (Development, Infrastructure, Data)
3. Define decision drivers before evaluating options
4. Analyze at least 2 viable options with consistent criteria
5. State the decision clearly in one sentence
6. Document all consequence types (positive, negative, neutral)
7. List follow-up actions with owners or ADR references
8. Get sign-off from relevant stakeholders before marking Accepted
9. Update status when the decision is superseded or deprecated
10. Link related ADRs in both directions

## See Also

- AGENTS_ADR_RESEARCH.md for research process when writing ADRs
- AGENTS_TECH_RESEARCH.md for technology evaluation patterns
