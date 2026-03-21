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
- The single agent uses `yellow` as its color (inherited from the source plugin where
  `aws-solutions-architect` was yellow; blue was reserved for a separate strategic lead agent
  that does not exist in this standalone plugin)

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

This plugin bundles the `awslabs.aws-documentation-mcp-server` package (registered in `.mcp.json` as `awslabs-aws-documentation-mcp-server`) via `uvx`. Agents should use the following MCP tools when relevant:

- `search_documentation`: Search AWS documentation for service capabilities, limits, pricing, and best practices
- `read_documentation`: Fetch a specific AWS documentation page in full
- `read_sections`: Fetch specific sections of an AWS documentation page
- `recommend`: Get related content recommendations for a documentation page

Agents should use these tools proactively when the user's question involves AWS service capabilities, configurations, or best practices rather than relying solely on training data.

### Memory Paths

```
.claude/agent-memory/aws-solutions-architect/PROJECT.md
.claude/agent-memory/aws-solutions-architect-aws-solutions-architect/MEMORY.md
```

### Plugin Versioning

- The `version` field in `marketplace.json` tracks the current release version
- Tag releases with `v<version>` (e.g., `v0.1.0`) when cutting a version
