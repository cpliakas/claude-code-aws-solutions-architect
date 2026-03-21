---
name: well-architected-review
description: >
  Run an AWS Well-Architected Framework review against a workload or component.
  Use when the user invokes /well-architected-review, the aws-solutions-architect
  agent recommends a framework review, or the user asks about well-architected
  alignment.
user-invokable: true
allowed-tools: Read, Grep, Glob, Bash
argument-hint: "<workload or component description>"
context: fork
---

# Well-Architected Review

Run an AWS Well-Architected Framework review for the workload or component
described in `$ARGUMENTS`.

## Step 1 -- Check for Workload Description

If `$ARGUMENTS` is empty, ask the user to describe the workload, component, or
architecture to review before proceeding. Do not continue until a description
is provided.

## Step 2 -- Gather Context

Before starting the review, gather relevant context:

1. Read shared project context from
   `.claude/agent-memory/aws-solutions-architect/PROJECT.md` if it exists
2. Read the `aws-solutions-architect` agent's project memory from
   `.claude/agent-memory/aws-solutions-architect-aws-solutions-architect/MEMORY.md`
   if it exists
3. Scan the project for CloudFormation templates, CDK code, or Terraform files
   related to the workload:
   - `**/*.template.json`, `**/*.template.yaml`, `**/template.json`, `**/template.yaml`
   - `**/*stack*.ts`, `**/*stack*.py` (CDK)
   - `**/*.tf` (Terraform)
4. If templates are found, validate them using
   `validate_cloudformation_template` and `check_cloudformation_template_compliance`
   via the MCP server

## Step 3 -- Review Each Pillar

Evaluate the workload against all six Well-Architected Framework pillars.
For each pillar, produce:

- **Current state**: What the workload does well in this area
- **Risks identified**: Specific gaps or concerns (rated High/Medium/Low)
- **Recommendations**: Actionable improvements with estimated effort

### Pillar 1: Operational Excellence

Focus areas:

- Organization (team structure, runbooks, operational readiness)
- Prepare (design for operations, deployment practices)
- Operate (monitoring, alerting, incident response)
- Evolve (learn from operations, make improvements)

Key questions:

- How are deployments performed? Is rollback tested?
- What monitoring and alerting is in place?
- Are there runbooks for common operational scenarios?
- How are operational events and incidents tracked?

### Pillar 2: Security

Focus areas:

- Identity and access management (IAM, least privilege, federation)
- Detection (CloudTrail, GuardDuty, SecurityHub)
- Infrastructure protection (VPC, security groups, WAF)
- Data protection (encryption at rest and in transit, key management)
- Incident response (forensic readiness, automation)

Key questions:

- Are IAM policies following least privilege?
- Is encryption enabled for data at rest and in transit?
- Are security monitoring services enabled?
- How are secrets managed?

### Pillar 3: Reliability

Focus areas:

- Foundations (service quotas, network topology)
- Workload architecture (fault isolation, distributed system design)
- Change management (monitoring, auto-scaling, deployment practices)
- Failure management (backups, disaster recovery, fault tolerance)

Key questions:

- How does the workload handle component failures?
- What is the disaster recovery strategy?
- Are backups configured and tested?
- What is the defined RTO and RPO?

### Pillar 4: Performance Efficiency

Focus areas:

- Selection (compute, storage, database, networking)
- Review (benchmarking, load testing)
- Monitoring (performance metrics, alarms)
- Trade-offs (caching, read replicas, edge locations)

Key questions:

- Are services sized appropriately for the workload?
- Is caching used where beneficial?
- Are there performance bottlenecks?
- Has the workload been load tested?

### Pillar 5: Cost Optimization

Focus areas:

- Cloud financial management (cost awareness, budgets)
- Expenditure and usage awareness (tagging, cost allocation)
- Cost-effective resources (right-sizing, pricing models)
- Manage demand and supply (auto-scaling, queue-based architectures)
- Optimize over time (review new services, evaluate alternatives)

Key questions:

- Are resources right-sized based on actual usage?
- Are commitment discounts (Savings Plans, RIs) in use?
- Is cost allocation tagging in place?
- Are there idle or underutilized resources?

### Pillar 6: Sustainability

Focus areas:

- Region selection (carbon intensity, proximity to users)
- User behavior patterns (demand shaping, async processing)
- Software and architecture patterns (efficient algorithms, managed services)
- Data management (lifecycle policies, cold storage tiering)
- Hardware and services (right-sizing, Graviton instances)

Key questions:

- Are resources scaled down during off-peak hours?
- Is data lifecycle management in place (S3 tiering, log retention)?
- Are managed services preferred where appropriate?
- Are Graviton instances used where compatible?

## Step 4 -- Produce the Report

Compile findings into a structured report:

```markdown
# Well-Architected Review: [Workload Name]

> Reviewed on [date]

## Summary

[2-3 sentence overview of the workload's Well-Architected alignment]

**Overall Risk Level:** [Low / Medium / High]

| Pillar | Rating | High Risks | Medium Risks | Low Risks |
| --- | --- | --- | --- | --- |
| Operational Excellence | [Good/Fair/Needs Work] | [N] | [N] | [N] |
| Security | [Good/Fair/Needs Work] | [N] | [N] | [N] |
| Reliability | [Good/Fair/Needs Work] | [N] | [N] | [N] |
| Performance Efficiency | [Good/Fair/Needs Work] | [N] | [N] | [N] |
| Cost Optimization | [Good/Fair/Needs Work] | [N] | [N] | [N] |
| Sustainability | [Good/Fair/Needs Work] | [N] | [N] | [N] |

## Pillar Details

### Operational Excellence

**Rating:** [Good/Fair/Needs Work]

**Current State:**
[What the workload does well]

**Findings:**

| # | Risk | Severity | Recommendation | Effort |
| --- | --- | --- | --- | --- |
| 1 | [description] | [H/M/L] | [action] | [S/M/L] |

[Repeat for each pillar]

## Prioritized Recommendations

[Top 5-10 recommendations across all pillars, ordered by impact and effort]

| Priority | Pillar | Recommendation | Severity | Effort |
| --- | --- | --- | --- | --- |
| 1 | [pillar] | [action] | [H/M/L] | [S/M/L] |
```

## Step 5 -- Present and Offer Next Steps

Present the report and suggest follow-up actions:

- For high-severity security findings: "Ask the `aws-solutions-architect` agent
  for a detailed security review of the affected resources"
- For cost concerns: "Ask the `aws-solutions-architect` agent to estimate costs
  for the affected services"
- For architectural decisions surfaced: "Document key decisions in your project's ADR format"
