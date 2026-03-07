#!/bin/bash
# Reads the GitHub PAT from macOS Keychain at runtime so the token
# is never stored in plain text in .claude.json.
#
# Store the token once with:
#   security add-generic-password -a "github-mcp" -s "claude-mcp" -w

GITHUB_PERSONAL_ACCESS_TOKEN=$(security find-generic-password -a "github-mcp" -s "claude-mcp" -w 2>/dev/null)

if [[ -z "$GITHUB_PERSONAL_ACCESS_TOKEN" ]]; then
  echo "Error: GitHub PAT not found in Keychain. Run: security add-generic-password -a github-mcp -s claude-mcp -w" >&2
  exit 1
fi

export GITHUB_PERSONAL_ACCESS_TOKEN
exec github-mcp-server stdio
