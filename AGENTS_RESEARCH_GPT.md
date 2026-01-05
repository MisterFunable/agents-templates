# AGENTS_RESEARCH.md

Instructions for AI models conducting technology research and platform feature evaluation.

Use this template when evaluating new technologies, platform features, or tools for adoption.

## Purpose

This template enables systematic evaluation of technologies for:
- Technical feasibility assessment
- Business decision-making
- Customer-facing value justification
- Risk identification and mitigation planning

## Research Process

### Phase 1: Discovery

Before filling the template, gather information:

```
Search: "[TECHNOLOGY] official documentation 2024"
Search: "[TECHNOLOGY] getting started tutorial"
Search: "[TECHNOLOGY] limitations known issues"
Search: "[TECHNOLOGY] vs alternatives comparison"
Search: "[TECHNOLOGY] pricing enterprise"
```

### Phase 2: Validation

Verify information from multiple sources:
- Official documentation (primary source)
- Community forums and discussions
- Production case studies
- Vendor pricing pages

### Phase 3: Documentation

Complete all sections below with specific, actionable information.

---

## Template Sections

### 1. Overview

| Item | Details |
|------|---------|
| Technology/Feature Name | [Name and version] |
| Category | [e.g., Database, API, SDK, Platform Feature] |
| Problem Solved | [One-sentence description] |
| Target Users | [Developers / Operators / Business Users / End Users] |

**Description:**
[2-3 sentence explanation of what this technology does and why it exists]

**Key Capabilities:**
- [Capability 1]
- [Capability 2]
- [Capability 3]

---

### 2. Availability & Requirements

| Aspect | Requirement |
|--------|-------------|
| Minimum Version | [e.g., 2.x.x+, N/A for SaaS] |
| Deployment Model | [Cloud / On-Prem / Hybrid] |
| Platform Support | [Web / Desktop / Mobile / API-only] |
| Maturity Level | [GA / Beta / Preview / Deprecated] |
| Region Availability | [Global / Specific regions] |

**Infrastructure Requirements:**
```
- [Requirement 1: e.g., Node.js 18+]
- [Requirement 2: e.g., React 17+]
- [Requirement 3: e.g., API access tokens]
```

**Dependencies:**
- [SDK/Library 1]
- [SDK/Library 2]

---

### 3. Pricing & Licensing

| Tier | Price | Limits | Features |
|------|-------|--------|----------|
| Free | $0 | [Limits] | [Included features] |
| Standard | $X/mo | [Limits] | [Included features] |
| Pro | $X/mo | [Limits] | [Included features] |
| Enterprise | Custom | [Limits] | [Included features] |

**Cost Projections:**

| Scale | Monthly Cost | Notes |
|-------|--------------|-------|
| Small (1-10 users) | $X | [Assumptions] |
| Medium (10-50 users) | $X | [Assumptions] |
| Large (50+ users) | $X | [Assumptions] |

**Hidden Costs:**
- [e.g., Overage charges, API call limits]
- [e.g., Required add-ons for full functionality]
- [e.g., Support tier requirements]

---

### 4. Technical Impact

**Code Changes Required:**

| Area | Scope | Complexity |
|------|-------|------------|
| New Code | [Lines/Files estimate] | [Low/Medium/High] |
| Modifications | [Files affected] | [Low/Medium/High] |
| Configuration | [Config files needed] | [Low/Medium/High] |

**Technology Stack:**

```
Languages:     [Required languages]
Frameworks:    [Required frameworks]
SDKs:          [Required SDKs]
APIs:          [External APIs needed]
```

**Backward Compatibility:**
- Breaking changes: [Yes/No - details]
- Migration path: [Available/Not available]
- Deprecation timeline: [If applicable]

**Sample Integration:**

```javascript
// Example: Basic integration pattern
import { Client } from '[technology-sdk]';

const client = new Client({
  apiKey: process.env.API_KEY,
  // configuration options
});

// Basic usage pattern
const result = await client.operation({
  param1: 'value1',
  param2: 'value2',
});
```

---

### 5. Implementation Requirements

**CI/CD Changes:**
- [ ] New build steps required
- [ ] New environment variables
- [ ] New deployment targets
- [ ] New test suites

**Infrastructure Updates:**
- [ ] New services to provision
- [ ] Network/firewall changes
- [ ] Storage requirements
- [ ] Compute requirements

**Security Considerations:**
- [ ] Authentication mechanism
- [ ] Authorization/permissions model
- [ ] Data encryption requirements
- [ ] Compliance certifications (SOC2, GDPR, etc.)

**Monitoring Needs:**
- [ ] Logging requirements
- [ ] Metrics to track
- [ ] Alerting thresholds
- [ ] Dashboard requirements

---

### 6. Use Cases & Value

**Primary Use Cases:**

| Use Case | Description | Value |
|----------|-------------|-------|
| [Use Case 1] | [What it enables] | [Benefit] |
| [Use Case 2] | [What it enables] | [Benefit] |
| [Use Case 3] | [What it enables] | [Benefit] |

**Project-Specific Application:**
[Describe how this technology applies to the specific project context]

**Short-term Benefits (0-3 months):**
- [Benefit 1]
- [Benefit 2]

**Long-term Benefits (6-12+ months):**
- [Strategic advantage 1]
- [Strategic advantage 2]

**Comparison to Current Solution:**

| Aspect | Current Solution | New Technology |
|--------|------------------|----------------|
| [Aspect 1] | [Current state] | [Improvement] |
| [Aspect 2] | [Current state] | [Improvement] |
| [Aspect 3] | [Current state] | [Improvement] |

---

### 7. Templates & Examples

**Official Templates:**
- [Template 1 - Link and description]
- [Template 2 - Link and description]

**Community Examples:**
- [Example 1 - Link and description]
- [Example 2 - Link and description]

**Production-Ready Patterns:**

```
Pattern: [Pattern name]
Use when: [Conditions]
Example: [Brief code or architecture snippet]
```

**Applicability Assessment:**

| Template/Example | Relevant to Project | Adaptation Needed |
|-----------------|---------------------|-------------------|
| [Name] | [Yes/No/Partial] | [Low/Medium/High] |

---

### 8. Learning Curve & Documentation

**Official Resources:**

| Resource Type | Available | Quality | Link |
|--------------|-----------|---------|------|
| Quick Start Guide | [Yes/No] | [1-5] | [URL] |
| API Reference | [Yes/No] | [1-5] | [URL] |
| Tutorials | [Yes/No] | [1-5] | [URL] |
| Video Content | [Yes/No] | [1-5] | [URL] |
| Community Forum | [Yes/No] | [1-5] | [URL] |

**Learning Path:**

```
1. [First step - estimated time]
2. [Second step - estimated time]
3. [Third step - estimated time]
Total estimated onboarding: [X hours/days]
```

**Skill Requirements:**

| Skill | Required Level | Team Current Level |
|-------|---------------|-------------------|
| [Skill 1] | [Basic/Intermediate/Advanced] | [Assessment] |
| [Skill 2] | [Basic/Intermediate/Advanced] | [Assessment] |

---

### 9. Implementation Feasibility

**Proof of Concept Scope:**

```
Objective: [What to validate]
Timeline: [Estimated duration]
Resources: [People/tools needed]
Success Criteria: [How to measure success]
```

**Implementation Phases:**

| Phase | Scope | Duration | Dependencies |
|-------|-------|----------|--------------|
| Phase 1 | [Scope] | [Time] | [Dependencies] |
| Phase 2 | [Scope] | [Time] | [Dependencies] |
| Phase 3 | [Scope] | [Time] | [Dependencies] |

**Support & Maintenance:**

| Aspect | Requirement |
|--------|-------------|
| Ongoing maintenance | [Hours/week estimate] |
| Support tier needed | [Free/Paid tier] |
| Update frequency | [How often to update] |
| Breaking change risk | [Low/Medium/High] |

**Complexity Assessment:**

| Dimension | Rating | Justification |
|-----------|--------|---------------|
| Technical complexity | [Low/Medium/High] | [Why] |
| Integration complexity | [Low/Medium/High] | [Why] |
| Operational complexity | [Low/Medium/High] | [Why] |
| **Overall** | **[Low/Medium/High]** | |

---

### 10. Risks & Edge Cases

**Known Limitations:**
- [Limitation 1 - Impact: High/Medium/Low]
- [Limitation 2 - Impact: High/Medium/Low]
- [Limitation 3 - Impact: High/Medium/Low]

**Scalability Concerns:**

| Metric | Limit | Mitigation |
|--------|-------|------------|
| [e.g., Records] | [Limit] | [Workaround] |
| [e.g., API calls] | [Limit] | [Workaround] |
| [e.g., Concurrent users] | [Limit] | [Workaround] |

**Security Risks:**

| Risk | Severity | Mitigation |
|------|----------|------------|
| [Risk 1] | [Critical/High/Medium/Low] | [Mitigation] |
| [Risk 2] | [Critical/High/Medium/Low] | [Mitigation] |

**Edge Cases:**
- [Edge case 1 - How to handle]
- [Edge case 2 - How to handle]

---

### 11. Alternatives Analysis

**Alternative Options:**

| Option | Pros | Cons | Cost |
|--------|------|------|------|
| [Option 1] | [Pros] | [Cons] | [Cost] |
| [Option 2] | [Pros] | [Cons] | [Cost] |
| Build Custom | [Pros] | [Cons] | [Cost] |

**Custom Solution Requirements:**

If building custom:
```
Estimated effort: [Person-months]
Stack: [Technologies needed]
Maintenance: [Ongoing effort]
Risks: [Key risks]
```

**Recommendation:**
[Option X] because [reasoning]

---

### 12. Business Impact

**Investment Required:**

| Category | One-time | Recurring |
|----------|----------|-----------|
| Licensing | $X | $X/month |
| Development | $X | $X/month |
| Infrastructure | $X | $X/month |
| Training | $X | - |
| **Total** | **$X** | **$X/month** |

**Potential ROI:**

| Benefit | Quantified Value | Timeline |
|---------|-----------------|----------|
| [Benefit 1] | [Hours saved / Revenue] | [When realized] |
| [Benefit 2] | [Hours saved / Revenue] | [When realized] |

**Risk/Reward Assessment:**

| Factor | Assessment |
|--------|------------|
| Implementation Risk | [Low/Medium/High] |
| Business Value | [Low/Medium/High] |
| Time to Value | [Short/Medium/Long] |
| Strategic Alignment | [Low/Medium/High] |

**Customer Value Proposition:**
[How does this benefit end customers? What can you tell them?]

---

### 13. References

**Official Documentation:**
- [Doc 1 - URL]
- [Doc 2 - URL]

**Tutorials & Guides:**
- [Tutorial 1 - URL]
- [Tutorial 2 - URL]

**Community Resources:**
- [Resource 1 - URL]
- [Resource 2 - URL]

**Related Technologies:**
- [Related tech 1 - How it relates]
- [Related tech 2 - How it relates]

---

## Output Formats

### Executive Summary Template

```markdown
## [Technology Name] - Executive Summary

**Recommendation:** [Adopt / Trial / Assess / Hold]

**Key Points:**
- [Most important finding 1]
- [Most important finding 2]
- [Most important finding 3]

**Investment:** $X one-time + $X/month recurring

**Timeline:** [Implementation duration]

**Risk Level:** [Low/Medium/High]

**Next Steps:**
1. [Action 1]
2. [Action 2]
```

### Technical Brief Template

```markdown
## [Technology Name] - Technical Brief

**Stack:** [Languages/Frameworks]
**Complexity:** [Low/Medium/High]
**Integration Points:** [Systems affected]

**Implementation Requirements:**
- [Requirement 1]
- [Requirement 2]

**Code Sample:**
[Include minimal working example]

**Risks:**
- [Technical risk 1]
- [Technical risk 2]
```

---

## Anti-Patterns

| Don't | Do |
|-------|-----|
| Skip official documentation | Start with vendor docs |
| Ignore pricing at scale | Model costs for realistic usage |
| Assume current features are permanent | Verify roadmap and deprecation plans |
| Test only happy paths | Validate edge cases and limits |
| Evaluate in isolation | Consider integration complexity |
| Focus only on features | Assess maintenance burden |
| Trust marketing claims | Verify with production case studies |
| Ignore security implications | Audit permissions and data handling |

---

## Quick Reference

| Aspect | Standard |
|--------|----------|
| Research sources | Minimum 3 independent sources |
| Pricing validation | Direct from vendor, within 30 days |
| Code samples | Tested and working |
| Risk assessment | Include mitigations |
| Alternatives | Minimum 2 alternatives evaluated |
| Timeline estimates | Include buffer for unknowns |

---

## When Conducting Technology Research

1. Start with official documentation and current pricing
2. Validate claims with community feedback and case studies
3. Test integration with a minimal proof of concept
4. Document all assumptions and their sources
5. Include both technical and business perspectives
6. Quantify costs and benefits where possible
7. Identify showstoppers early
8. Provide clear recommendation with reasoning
9. Include next steps regardless of recommendation
10. Update research if older than 90 days

---

See `AGENTS_TEMPLATE.md` for template creation guidelines.

