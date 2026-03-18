# AWS Solutions Architect

A Claude Code plugin that provides **AWS cloud architecture guidance** through specialized agents. While implementation-focused plugins help you write code, this one helps you make the architectural decisions that shape your AWS infrastructure: service selection, cost optimization, security review, and Well-Architected alignment.

## What's Included

### Agents

| Agent | Description |
| --- | --- |
| `solutions-architect` | Strategic AWS architecture advisor for service selection, migration strategy, multi-account design, and Well-Architected reviews |
| `cost-optimizer` | FinOps advisor for cost analysis, commitment evaluation (RIs/Savings Plans), right-sizing, and cost estimation |
| `security-reviewer` | AWS security and compliance advisor for IAM review, encryption strategy, and compliance framework alignment (SOC2, HIPAA, PCI) |

### Skills

| Skill | Description |
| --- | --- |
| `/onboard` | Guided project setup: captures AWS environment context for all agents |
| `/well-architected-review` | Framework review across all six Well-Architected pillars |
| `/write-adr` | Architecture Decision Records in MADR format with AWS-specific fields (services affected, cost implications, compliance impact) |
| `/estimate-cost` | Structured cost estimation worksheet with per-service breakdown and scaling projections |

### Bundled MCP Server

This plugin bundles the [AWS IaC MCP server](https://github.com/awslabs/mcp) (`@awslabs/aws-iac-mcp-server`), giving agents access to:

- **CloudFormation template validation** via cfn-lint
- **Compliance checking** via cfn-guard
- **CDK documentation** and best practices
- **CloudFormation resource documentation**

No manual MCP server configuration needed.

## Quick Start

Add the marketplace to your Claude Code project, then install the plugin:

```
/plugin marketplace add cpliakas/claude-code-aws-solutions-architect
/plugin install aws-solutions-architect
```

## Setting Up for Your Project

After installation, run the onboarding skill:

```
/onboard
```

This runs a guided interview that captures your AWS environment context: account structure, services in use, deployment tooling, compliance requirements, and current focus areas. All agents read this shared context automatically.

## Working Examples

### Choose Between AWS Services

> `@agents/solutions-architect Should we use DynamoDB or Aurora for our order tracking system? We have ~2,000 orders/day with complex queries for reporting.`

The solutions-architect evaluates both services against your access patterns, scaling needs, cost profile, and operational maturity, then provides a recommendation with clear trade-offs.

### Review Architecture Against Well-Architected Framework

> `@agents/solutions-architect Can you run a Well-Architected review of our payment processing workload?`

The solutions-architect invokes `/well-architected-review`, scanning your infrastructure code and evaluating the workload across all six pillars. Produces a structured report with prioritized recommendations.

### Estimate Costs for a New Architecture

> `@agents/cost-optimizer Can you estimate the monthly cost for running 3 ECS Fargate tasks with an ALB, RDS Multi-AZ, and ElastiCache?`

The cost-optimizer invokes `/estimate-cost`, producing a per-service cost breakdown with assumptions, optimization opportunities, and scaling projections.

### Review IAM Policies

> `@agents/security-reviewer Does this IAM policy follow least privilege? [paste policy]`

The security-reviewer evaluates the policy against least privilege principles, checks for overly broad permissions, and provides specific tightening recommendations.

### Check CloudFormation Templates for Compliance

> `@agents/security-reviewer Can you check our CloudFormation templates for security issues?`

The security-reviewer uses the bundled MCP server's cfn-guard integration to run compliance checks, then layers on manual review for context-specific risks.

## Architecture

### Agents vs Skills

|  | Agent | Skill |
| --- | --- | --- |
| **What** | A specialist persona with domain expertise | A repeatable procedure |
| **Memory** | Yes, learns across sessions | No, runs the same way each time |
| **Judgment** | Yes, decides how to approach problems | No, follows a defined process |

### Memory

All agents use `memory: project`. The agent definitions ship with the plugin, but each project maintains its own memory in `.claude/agent-memory/`. Project-specific learnings (your account structure, services, decisions) stay in project memory.

```
.claude/agent-memory/aws-solutions-architect/PROJECT.md          # Shared context
.claude/agent-memory/aws-solutions-architect-solutions-architect/ # Solutions Architect memory
.claude/agent-memory/aws-solutions-architect-cost-optimizer/      # Cost Optimizer memory
.claude/agent-memory/aws-solutions-architect-security-reviewer/   # Security Reviewer memory
```

### Agent Collaboration

```
                    ┌─────────────────────┐
                    │ solutions-architect │  Strategic architecture
                    │     (opus, blue)    │  decisions, service
                    │                     │  selection, design reviews
                    └──────────┬──────────┘
                               │
              ┌────────────────┼────────────────┐
              │                                 │
   ┌──────────┴──────────┐          ┌───────────┴──────────┐
   │   cost-optimizer    │          │  security-reviewer   │
   │  (sonnet, yellow)   │          │   (sonnet, red)      │
   │                     │          │                      │
   │  Cost analysis,     │          │  IAM review,         │
   │  FinOps, right-     │          │  compliance,         │
   │  sizing, estimates  │          │  encryption,         │
   │                     │          │  template validation │
   └─────────────────────┘          └──────────────────────┘
```

The solutions-architect is the primary entry point for architecture decisions. When cost or security implications surface, it recommends consulting the relevant specialist agent.

## Repository Structure

```
claude-code-aws-solutions-architect/
├── .claude-plugin/
│   └── marketplace.json
├── .claude/
│   └── settings.json
├── .mcp.json
├── agents/
│   ├── solutions-architect.md
│   ├── cost-optimizer.md
│   └── security-reviewer.md
├── skills/
│   ├── onboard/SKILL.md
│   ├── well-architected-review/SKILL.md
│   ├── write-adr/SKILL.md
│   └── estimate-cost/SKILL.md
├── hooks/
│   └── markdownlint-check.sh
├── CLAUDE.md
├── AGENTS.md
├── README.md
└── LICENSE
```

## License

MIT
