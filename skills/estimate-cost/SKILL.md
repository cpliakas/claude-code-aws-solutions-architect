---
name: estimate-cost
description: >
  Produce a structured AWS cost estimation worksheet for a proposed architecture
  or change. Use when the user invokes /estimate-cost, the cost-optimizer
  recommends a cost projection, or the user asks "how much will this cost?"
user-invokable: true
allowed-tools: Read, Grep, Glob
argument-hint: "<architecture or change description>"
context: fork
---

# Estimate Cost

Produce a structured cost estimation worksheet for the AWS architecture or
change described in `$ARGUMENTS`.

## Step 1 -- Check for Architecture Description

If `$ARGUMENTS` is empty, ask the user to describe the architecture, change,
or workload to estimate before proceeding. Do not continue until a description
is provided.

## Step 2 -- Gather Context

Before producing the estimate, read relevant project context:

1. `.claude/agent-memory/aws-solutions-architect/PROJECT.md` for project
   overview, services in use, and environment topology
2. `.claude/agent-memory/aws-solutions-architect-cost-optimizer/MEMORY.md` for
   existing cost baselines, pricing decisions, and known cost drivers
3. Any infrastructure code (CloudFormation, CDK, Terraform) related to the
   architecture being estimated
4. Ask clarifying questions if critical assumptions are missing (e.g., expected
   request volume, data volume, retention period). Limit to 2-3 clarifying
   questions maximum.

## Step 3 -- Produce the Cost Worksheet

Build the estimate service by service. For each service:

1. Identify the pricing dimensions (compute hours, storage GB, requests,
   data transfer, etc.)
2. State the assumed usage for each dimension
3. Calculate the estimated monthly cost
4. Note the pricing model assumed (on-demand, savings plan, spot, free tier)

Use this format:

```markdown
# Cost Estimate: [Architecture/Change Name]

> Estimated on [date]

## Summary

| | Monthly | Annual |
| --- | --- | --- |
| **Total Estimated Cost** | $X,XXX | $XX,XXX |
| With Savings Plans/RIs | $X,XXX | $XX,XXX |

## Assumptions

- [Key assumption 1 -- e.g., "1,000 requests/second average, 3x peak"]
- [Key assumption 2 -- e.g., "500 GB data stored, growing 10% monthly"]
- [Key assumption 3 -- e.g., "Single region (us-east-1), 3 AZs"]
- [Pricing as of YYYY-MM]

## Service Breakdown

### [Service 1 -- e.g., Amazon ECS (Fargate)]

| Dimension | Usage | Unit Price | Monthly Cost |
| --- | --- | --- | --- |
| vCPU-hours | [N] | $[X]/vCPU-hr | $[N] |
| GB-hours (memory) | [N] | $[X]/GB-hr | $[N] |
| **Subtotal** | | | **$[N]** |

**Configuration:** [e.g., "2 tasks, 0.5 vCPU, 1 GB each, running 24/7"]

### [Service 2 -- e.g., Amazon RDS (PostgreSQL)]

| Dimension | Usage | Unit Price | Monthly Cost |
| --- | --- | --- | --- |
| Instance hours | [N] | $[X]/hr | $[N] |
| Storage (GP3) | [N] GB | $[X]/GB-mo | $[N] |
| Backup storage | [N] GB | $[X]/GB-mo | $[N] |
| **Subtotal** | | | **$[N]** |

**Configuration:** [e.g., "db.t3.medium, Multi-AZ, 100 GB GP3"]

[Repeat for each service]

### Data Transfer

| Path | Volume | Unit Price | Monthly Cost |
| --- | --- | --- | --- |
| Internet egress | [N] GB | $[X]/GB | $[N] |
| Cross-AZ | [N] GB | $0.01/GB | $[N] |
| NAT Gateway processing | [N] GB | $0.045/GB | $[N] |
| **Subtotal** | | | **$[N]** |

## Optimization Opportunities

- [Opportunity 1 -- e.g., "Compute Savings Plan (1-year, no upfront) would
  save ~30% on Fargate costs"]
- [Opportunity 2 -- e.g., "S3 Intelligent-Tiering could reduce storage costs
  by 20-40%"]
- [Opportunity 3 -- e.g., "VPC endpoints for S3/DynamoDB would eliminate NAT
  Gateway charges for those services"]

## Caveats

- Data transfer costs are estimates; actual costs depend on traffic patterns
  and client locations
- Free tier is not included in estimates (assumes production workload beyond
  free tier limits)
- Pricing is region-specific; costs may vary in other regions
- [Any workload-specific caveats]

## Cost Scaling

How costs change as the workload grows:

| Scale Factor | Current | 2x | 5x | 10x |
| --- | --- | --- | --- | --- |
| Monthly cost | $[N] | $[N] | $[N] | $[N] |
| Primary driver | [service] | [service] | [service] | [service] |
```

## Step 4 -- Present and Offer Next Steps

Present the worksheet and suggest follow-up actions:

- "To refine this estimate, I'd recommend checking current pricing in the
  AWS Pricing Calculator"
- For significant spending: "Consider running a commitment analysis with
  the cost-optimizer agent to evaluate Savings Plans or Reserved Instances"
- For architectural alternatives: "If cost is a primary concern, I can
  estimate alternative architectures (e.g., serverless vs. container-based)"
