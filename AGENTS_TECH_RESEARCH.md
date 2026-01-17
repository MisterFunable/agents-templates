# AGENTS_TECH_RESEARCH.md

Instructions for AI models researching and evaluating a new technology or platform feature for both engineering and business stakeholders.

This template is for producing a reusable, decision-ready research artifact: what it is, what it costs, how it works, what it breaks, what to build, and whether to adopt it.

## Project Structure (Research Artifacts)

Use this structure for each evaluation:

```
research/
└── [topic-slug]/
    ├── SUMMARY.md                 # 1-2 page exec + technical summary
    ├── TECHNICAL_EVALUATION.md    # Full technical analysis
    ├── BUSINESS_REVIEW.md         # Management / customer narrative
    ├── DECISION_LOG.md            # Key decisions + open questions
    └── REFERENCES.md              # Curated links (official first)
```

If you only create one file, name it `SUMMARY.md` and include both the technical and business sections in it.

## Research Output Requirements

### Voice and audience

- **Two views, same facts:** Write a technical analysis for engineers, then rewrite for business stakeholders with the same conclusions.
- **Be explicit about uncertainty:** If a detail is plan-dependent or might have changed, write “Verify on [source]” and list the exact URL in References.
- **Prefer constraints over opinions:** Use measurable limits (quotas, performance ceilings, compatibility requirements) rather than “it’s scalable” or “it’s easy”.

### Scannability rules

- Use `##` headings for major sections only.
- Use tables for comparisons, limits, trade-offs, and decisions.
- Keep paragraphs short (2-4 lines). Prefer bullets.
### Delivery pipeline requirement (when the feature ships code)

If adopting this technology requires writing and shipping code (extension, plugin, service, IaC, scripts), you MUST include a **Pipeline Demo**:

- Either a minimal **Makefile** with the key steps to build/test/package/release
- Or a minimal **CI workflow snippet** (GitHub Actions/GitLab CI/Circle) showing the same steps

Goal: a reader should be able to run the PoC and understand how changes move to production.

## Technology Research Template (Fill This In)

### 1. Overview

- **What it is**: 1-2 sentences.
- **What problem it solves**: map to real pain points, not generic “productivity”.
- **Target users**:
  - **Developers**: who builds/maintains it?
  - **Operators**: who runs/monitors it?
  - **Business users**: who benefits / changes workflow?

### 2. Availability & Requirements

| Item | Answer |
|------|--------|
| **Maturity** | GA / Beta / Preview |
| **Where it runs** | Cloud / on-prem / hybrid |
| **Supported platforms** | OS / browsers / runtimes |
| **Version requirements** | Minimum versions and deprecations |
| **Account / tenancy needs** | Org plan, workspace setup |
| **Operational prerequisites** | SSO, networking, device mgmt, etc. |

### 3. Pricing & Licensing

| Question | Answer |
|---------|--------|
| **Is it paid?** | Free / paid / add-on |
| **Pricing unit** | Per user / per seat / per run / per GB |
| **Key plan gates** | Which tier unlocks required features |
| **Scale drivers** | What grows cost (users, data, API calls) |
| **Hidden costs** | Support, vendor lock-in, admin time |

If pricing is unclear, list 2-3 scenarios (small team, mid, enterprise) and the cost drivers, then mark “Needs confirmation”.

### 4. Technical Impact

| Area | Impact |
|------|--------|
| **Code changes** | New services, UI, integrations, migrations |
| **Languages/frameworks** | Required + optional |
| **SDKs/APIs** | What we must adopt |
| **Data model changes** | Schemas, identifiers, permissions |
| **Backward compatibility** | What breaks, how to migrate |
| **Non-functional** | Performance, reliability, maintainability |

### 5. Additional Implementation Needs

Cover what teams forget:

- **CI/CD**: build, test, package, deploy.
- **Infra**: hosting, storage, secrets, networking.
- **Security**: authn/authz model, least privilege, data boundaries, audit.
- **Compliance**: PII, retention, regional data, vendor risk.
- **Observability**: logs, metrics, traces, alerting, SLOs.

### 5.1 Pipeline Demo (required if shipping code)

Include one of the following.

#### Option A: Makefile (preferred for quick PoCs)

```make
.PHONY: setup lint test build package release

setup:
	# install deps, pin versions

lint:
	# fast checks (format, lint, typecheck)

test:
	# unit + lightweight integration tests

build:
	# production build artifacts

package:
	# create distributable (zip, image, plugin bundle)

release:
	# publish step (upload artifact, tag, deploy)
```

#### Option B: CI snippet (GitHub Actions example)

```yaml
name: ci
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      - run: npm ci
      - run: npm run lint
      - run: npm test
      - run: npm run build
```

#### Option C: CI snippet (GitLab CI example)

```yaml
stages:
  - test
  - build

default:
  image: node:20
  cache:
    key:
      files:
        - package-lock.json
    paths:
      - node_modules/

lint_and_test:
  stage: test
  script:
    - npm ci
    - npm run lint
    - npm test

build:
  stage: build
  script:
    - npm ci
    - npm run build
  artifacts:
    when: always
    paths:
      - dist/
```

### 6. Use Cases & Value

Describe 2-3 primary workflows and 2-3 secondary ones.

| Use case | User | Value | Why now |
|----------|------|-------|---------|
| [Primary] | [role] | [outcome] | [trigger] |

### 7. Templates & Examples

| Resource | Why it matters | Link |
|----------|----------------|------|
| Official starter | Fastest path to working PoC | [URL] |

Call out **production-grade** examples: auth patterns, testing, CI, monitoring.

### 8. Tutorials & Learning Curve

| Audience | Time to first success | What they must already know | Learning path |
|----------|------------------------|-----------------------------|---------------|
| Dev | [hours/days] | [skills] | [steps] |
| Non-dev | [hours/days] | [skills] | [steps] |

If no tutorial exists, write a “conceptual tutorial”:
- The minimum components
- The simplest end-to-end flow
- A working “Hello World” shape (pseudocode is fine)

### 9. Implementation Feasibility

| Dimension | Assessment |
|----------|------------|
| **Complexity** | Low / Medium / High |
| **Time to PoC** | [estimate] |
| **Time to production** | [estimate] |
| **Ongoing ownership** | Which team and on-call impact |
| **Maintenance risks** | Version drift, policy changes |

Include “what it actually looks like”:

- **Architecture sketch**: components and responsibilities
- **Data flow**: how data is created, stored, aggregated, exposed
- **Operational model**: deploy cadence, rollback, support

### 10. Edge Cases & Risks

| Risk | Trigger | Impact | Mitigation |
|------|---------|--------|------------|
| [Example: quota limits] | [load] | [failure mode] | [fallback] |

Must include:
- **Scalability risks**: limits, rate caps, large datasets
- **Security risks**: data exposure paths, supply chain deps
- **Product risks**: vendor deprecations, roadmap uncertainty

### 11. Alternatives & Custom Solutions

List 2-4 alternatives:

| Option | Pros | Cons | When to choose |
|--------|------|------|----------------|
| Built-in platform feature | | | |
| Custom app | | | |
| Competing vendor | | | |

If proposing a custom build, describe:
- Minimum viable scope
- Approximate architecture
- Cost/effort vs platform feature

### 12. Business Impact

Write this for leadership and customers.

| Topic | Answer |
|------|--------|
| **Customer value** | What improves for end users |
| **Differentiation** | Why we are better vs competitors |
| **Time-to-value** | How quickly customers see benefit |
| **ROI levers** | Fewer hours, fewer tools, fewer errors |
| **Downsides** | Lock-in, training, reliability concerns |

### 13. Decision & Recommendation

| Decision | Recommendation |
|----------|----------------|
| **Adopt?** | Yes / No / Pilot |
| **Scope** | PoC / limited rollout / full |
| **Success criteria** | Measurable outcomes |
| **Exit criteria** | When to stop or switch approaches |

### 14. References

Rules:
- Put **official docs first**.
- Prefer **stable URLs** over marketing landing pages.
- For each link, add a one-line “why it matters”.

## Code/Math Snippets (Use When Helpful)

Use short snippets to make analysis concrete.

### Example: simple TCO calculator (Python)

```python
def monthly_tco(seats: int, price_per_seat: float, admin_hours: float, hourly_rate: float) -> float:
    return seats * price_per_seat + admin_hours * hourly_rate

print(monthly_tco(seats=50, price_per_seat=20.0, admin_hours=10, hourly_rate=120.0))
```

### Example: decision table starter

```text
If we need SSO + audit logs -> require Enterprise tier
If we need offline mode -> likely not feasible
If we need 10k+ writes/day -> test quotas + batching strategy
```

### Example: integration risk checklist

```text
- Auth: how do we store tokens? rotation? revocation?
- Network: outbound allowlist? proxy? timeouts?
- Limits: rate limits? payload caps? concurrency?
- Support: who owns incidents and vendor escalations?
```

## Anti-Patterns

| Don't | Do |
|------|-----|
| Claim “scalable” without numbers | Write the actual limits (quotas, latency, max records/users) and cite sources |
| Copy marketing copy into the evaluation | Translate into operational reality (what breaks, what it costs, what to build) |
| Ignore plan gates until late | Identify which tier you need in the first 20% of the doc |
| Only evaluate happy-path workflows | Include edge cases: permissions, failures, large datasets, partial outages |
| Recommend adoption without an exit plan | Define pilot scope, success criteria, and exit criteria |
| Provide “pros/cons” with no recommendation | Make a call, and list the remaining unknowns explicitly |
| Mix technical and business audiences in one voice | Separate Technical Analysis vs Business Review sections |
| Treat integration as “just API calls” | Document auth, network constraints, compliance, and ownership |
| List 20 links with no curation | Provide 5-12 high-signal references with annotations |

## Quick Reference

| Aspect | Standard |
|--------|----------|
| Output files | `SUMMARY.md`, `TECHNICAL_EVALUATION.md`, `BUSINESS_REVIEW.md`, `DECISION_LOG.md`, `REFERENCES.md` |
| Required sections | Overview, Availability, Pricing, Technical Impact, Implementation Needs, Use Cases, Risks, Alternatives, Business Impact, Recommendation, References |
| Pipeline demo | Required if shipping code: Makefile or CI snippet with build/test/package/release |
| Evidence standard | Official docs first; call out unknowns and plan gates; quantify limits |
| Recommendation format | Adopt / No / Pilot + success criteria + exit criteria |
| Writing style | Tables and bullets; short paragraphs; two-audience split |

## When Working on Technology Research

1. Start from the decision being made (what must be true to adopt).
2. Identify plan gates and hard constraints early (pricing, quotas, security).
3. Map 2-3 concrete workflows end-to-end, including failure modes.
4. Document integration requirements: auth, network, data model, ownership.
5. Compare at least 2 alternatives with clear "when to choose".
6. Produce a recommendation with measurable success + exit criteria.
7. Add curated references with one-line annotations.

## See Also

- AGENTS_ADR.md for documenting architectural decisions
- AGENTS_ADR_RESEARCH.md for ADR research methodology


