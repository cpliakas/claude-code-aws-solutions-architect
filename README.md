# AWS Solutions Architect

A Claude Code plugin that provides an **AWS Solutions Architect agent** for cloud architecture guidance. While implementation-focused plugins help you write code, this one helps you make the architectural decisions that shape your AWS infrastructure: service selection, cost optimization, security review, migration strategy, and Well-Architected alignment.

## What's Included

### Agent

| Agent | Description |
| --- | --- |
| `aws-solutions-architect` | AWS architecture advisor covering service selection, Well-Architected reviews, cost estimation, security review, migration planning, and CDK/CloudFormation guidance |

### Skills

| Skill | Description |
| --- | --- |
| `/well-architected-review` | Framework review across all six Well-Architected pillars |
| `/lookup-aws-service` | Curated capability cards for AWS services: when to use, when not to, pricing, and common misconceptions |

### Bundled MCP Server

This plugin bundles the AWS Documentation MCP server (installed as `awslabs.aws-documentation-mcp-server` via `uvx`, registered in `.mcp.json` as `awslabs-aws-documentation-mcp-server`), giving the agent access to current AWS documentation for any service, resource type, or best practice.

No manual MCP server configuration needed.

## Quick Start

Add the marketplace to your Claude Code project, then install the plugin:

```
/plugin marketplace add cpliakas/claude-code-aws-solutions-architect
/plugin install aws-solutions-architect
```

## Working Examples

### Choose Between AWS Services

> `@agents/aws-solutions-architect Should we use DynamoDB or Aurora for our order tracking system? We have ~2,000 orders/day with complex queries for reporting.`

The agent evaluates both services against your access patterns, scaling needs, cost profile, and operational maturity, then provides a recommendation with clear trade-offs.

### Review Architecture Against Well-Architected Framework

> `@agents/aws-solutions-architect Can you review our architecture against the Well-Architected Framework?`

The agent invokes `/well-architected-review`, scanning your infrastructure code and evaluating the workload across all six pillars. Produces a structured report with prioritized recommendations.

### Look Up a Service You're Not Sure About

> `/lookup-aws-service category:storage`

Returns capability cards for all storage services — when to use each one, when not to, pricing summary, and common misconceptions. Useful before making service selection decisions.

### Estimate Costs for a New Architecture

> `@agents/aws-solutions-architect Can you estimate the monthly cost for running 3 ECS Fargate tasks with an ALB, RDS Multi-AZ, and ElastiCache?`

The agent produces a per-service cost breakdown with assumptions, hidden cost warnings, and optimization opportunities.

## Architecture

### Agent vs Skills

|  | Agent | Skill |
| --- | --- | --- |
| **What** | A specialist persona with domain expertise | A repeatable procedure |
| **Memory** | Yes, learns across sessions | No, runs the same way each time |
| **Judgment** | Yes, decides how to approach problems | No, follows a defined process |

### Memory

The agent uses `memory: project`. The agent definition ships with the plugin, but each project maintains its own memory in `.claude/agent-memory/`. Project-specific learnings (your account structure, services, decisions) stay in project memory.

```
.claude/agent-memory/aws-solutions-architect/PROJECT.md                    # Shared project context
.claude/agent-memory/aws-solutions-architect-aws-solutions-architect/      # Agent memory
```

## Repository Structure

```
claude-code-aws-solutions-architect/
├── .claude-plugin/
│   └── marketplace.json
├── .claude/
│   └── settings.json
├── .mcp.json
├── agents/
│   └── aws-solutions-architect.md
├── benchmarks/
│   ├── run.sh
│   └── questions/
├── skills/
│   ├── well-architected-review/SKILL.md
│   └── lookup-aws-service/
│       ├── SKILL.md
│       └── data/
│           ├── analytics.json
│           ├── compute.json
│           ├── database.json
│           ├── management.json
│           ├── messaging-integration.json
│           ├── migration.json
│           ├── ml.json
│           ├── networking.json
│           ├── security-identity.json
│           └── storage.json
├── hooks/
│   └── markdownlint-check.sh
├── AGENTS.md
├── CLAUDE.md
├── README.md
└── LICENSE
```

## License

MIT
