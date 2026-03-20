#!/usr/bin/env bash
# Run each benchmark question in an independent Claude Code session.
#
# Must be run from the project root so .mcp.json is loaded, which gives
# the agent access to the awslabs-aws-iac-mcp-server MCP tools.
#
# Usage:
#   ./benchmarks/run.sh              # run all questions
#   ./benchmarks/run.sh '001-*'      # run questions matching a glob (quote the pattern)

set -euo pipefail

QUESTIONS_DIR="benchmarks/questions"
RESULTS_DIR="benchmarks/results/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$RESULTS_DIR"

# Allow filtering by passing a glob pattern as argument.
PATTERN="${1:-*.md}"

pass=0
fail=0

for q in "$QUESTIONS_DIR"/$PATTERN; do
    [ -f "$q" ] || continue

    name=$(basename "$q" .md)
    question=$(<"$q")
    prompt="@agents/aws-solutions-architect ${question}"

    echo "=== $name ==="

    # Each invocation is an independent Claude Code subprocess:
    #   --dangerously-skip-permissions  bypass all permission checks (no interactive prompts or tool confirmations)
    #   --model sonnet                  matches agents/aws-solutions-architect.md frontmatter (keep in sync)
    #   -p "$prompt"                    print response and exit (--print mode; prompt is a positional arg)
    #
    # .mcp.json is loaded automatically from the project root, so the
    # awslabs-aws-iac-mcp-server tools are available to the agent.
    if claude \
        --dangerously-skip-permissions \
        --model sonnet \
        -p "$prompt" \
        > "$RESULTS_DIR/${name}.txt" 2>&1; then
        pass=$((pass + 1))
        echo "  passed"
    else
        fail=$((fail + 1))
        echo "  FAILED (exit $?)"
    fi
done

echo ""
echo "Results: $pass passed, $fail failed"
echo "Saved to: $RESULTS_DIR"
