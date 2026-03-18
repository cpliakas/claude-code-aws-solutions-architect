# aws-solutions-architect

A Claude Code plugin providing an AWS Solutions Architect agent for cloud architecture guidance, service selection, cost optimization, security review, and Well-Architected reviews. Bundles the AWS IaC MCP server for CloudFormation validation, CDK documentation, and compliance checking.

## Authoring Conventions

### Markdown Body

- Always add a blank line between a heading (or bold-text header like `**Triggers:**`) and the following list or paragraph. Omitting the blank line violates MD022/MD032 and can cause rendering issues.

### Agents

- One markdown file per agent in `agents/`
- Follow the agent definition template: frontmatter (name, description, model, memory) + body (jurisdiction, delegation, key knowledge, memory protocol)
- Descriptions must include trigger phrases AND delegation relationships
- All agents use `memory: project` to learn per-project
- Agent names use kebab-case
- The single agent uses `yellow` as its color

### Skills

- One directory per skill in `skills/<skill-name>/`
- Must contain `SKILL.md` with YAML frontmatter
- Skills are opinionated procedures with clear inputs, process steps, and outputs
- Use `$ARGUMENTS` for parameterization
- Use `context: fork` for skills that produce a lot of output (keeps main context clean)

### Agent vs Skill Decision

- If it needs to learn and decide: agent
- If it needs to execute a procedure: skill
- Agents use skills; skills don't use agents
- Agents reference skills with the `/` prefix (e.g., `/well-architected-review`) in their markdown

### MCP Server Usage

This plugin bundles the `@awslabs/aws-iac-mcp-server` via `.mcp.json`. Agents should use the following MCP tools when relevant:

- `validate_cloudformation_template`: Validate CloudFormation template syntax and resource properties
- `check_cloudformation_template_compliance`: Run cfn-guard compliance rules against templates
- `search_cdk_documentation`: Look up CDK construct APIs and official documentation
- `search_cdk_samples_and_constructs`: Find working CDK code examples and patterns
- `search_cloudformation_documentation`: Look up CloudFormation resource types and template syntax
- `cdk_best_practices`: Review or generate CDK code against best practices
- `read_iac_documentation_page`: Read full content from documentation URLs returned by search tools
- `troubleshoot_cloudformation_deployment`: Diagnose CloudFormation deployment failures

Agents should use these tools proactively when the user's question involves IaC templates, CDK constructs, or CloudFormation resources rather than relying solely on training data.

### Memory Paths

```
.claude/agent-memory/aws-solutions-architect/PROJECT.md
.claude/agent-memory/aws-solutions-architect-aws-solutions-architect/MEMORY.md
```

### Plugin Versioning

- The `version` field in `marketplace.json` tracks the current release version
- Tag releases with `v<version>` (e.g., `v0.1.0`) when cutting a version
