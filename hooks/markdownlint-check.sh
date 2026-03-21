#!/bin/bash
set -euo pipefail

# Check jq is available before trying to parse hook input
if ! command -v jq &> /dev/null; then
  echo '{"hookSpecificOutput": {"additionalContext": "markdownlint-check.sh: jq is not installed; cannot parse hook input"}}' >&2
  exit 1
fi

input=$(cat)
if ! file_path=$(echo "$input" | jq -re '.tool_input.file_path' 2>/dev/null); then
  echo '{"hookSpecificOutput": {"additionalContext": "markdownlint-check.sh: failed to parse file_path from hook input"}}' >&2
  exit 1
fi

# Only process .md files
if [[ ! "$file_path" =~ \.md$ ]]; then
  exit 0
fi

# Notify Claude if markdownlint is not installed rather than silently skipping
if ! command -v markdownlint &> /dev/null; then
  echo '{"hookSpecificOutput": {"additionalContext": "markdownlint is not installed; markdown linting was skipped. Install with: npm install -g markdownlint-cli"}}' >&2
  exit 0
fi

# Run markdownlint, excluding line-length (MD013) and first-line-heading (MD041)
# which are expected in agent/skill files with YAML frontmatter.
# Capture stdout (lint findings) and stderr (tool errors) separately.
lint_err_file=$(mktemp)
issues=$(markdownlint --disable MD013 MD041 -- "$file_path" 2>"$lint_err_file") || true
lint_err=$(<"$lint_err_file")
rm -f "$lint_err_file"

# If markdownlint exited with no findings but had stderr output, it crashed or
# received an invalid file path — surface the error rather than silently passing.
if [ -z "$issues" ] && [ -n "$lint_err" ]; then
  json_err=$(echo "$lint_err" | jq -Rs .)
  printf '{"hookSpecificOutput": {"additionalContext": %s}}\n' "$json_err"
  exit 1
fi

if [ -z "$issues" ]; then
  exit 0
fi

# Report issues back to Claude as additional context, properly JSON-escaped
json_issues=$(echo "$issues" | head -20 | jq -Rs .)
printf '{"hookSpecificOutput": {"additionalContext": %s}}\n' "$json_issues"
exit 0
