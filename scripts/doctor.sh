#!/usr/bin/env bash
# Check that the CLIs this template expects are installed.
set -u
missing=0
for tool in claude git gh node npx uv docker; do
  if command -v "$tool" >/dev/null 2>&1; then
    printf '  ok       %-7s %s\n' "$tool" "$("$tool" --version 2>&1 | head -1)"
  else
    printf '  MISSING  %s\n' "$tool"
    missing=1
  fi
done

if command -v gh >/dev/null 2>&1 && ! gh auth status >/dev/null 2>&1; then
  echo "  gh is installed but not logged in: run 'gh auth login'"
  missing=1
fi

exit "$missing"
