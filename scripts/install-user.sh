#!/usr/bin/env bash
# Install this template's user-level setup on the current machine:
#   1. skills in user/skills/ -> ~/.claude/skills/ (existing ones are kept)
#   2. plugin marketplaces and plugins, at user scope
# Safe to re-run. Pass --force to replace skills that are already installed.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
dest="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills"
force=0
[ "${1:-}" = "--force" ] && force=1

echo "Skills -> $dest"
mkdir -p "$dest"
for src in "$root"/user/skills/*/; do
  name="$(basename "$src")"
  if [ -e "$dest/$name" ] || [ -L "$dest/$name" ]; then
    if [ "$force" -eq 0 ]; then
      echo "  keep   $name (already installed)"
      continue
    fi
    rm -rf "${dest:?}/$name"
  fi
  cp -r "$src" "$dest/$name"
  echo "  added  $name"
done

if ! command -v claude >/dev/null 2>&1; then
  echo "claude CLI not found; skipping plugins." >&2
  exit 1
fi

echo "Plugin marketplaces"
for source in \
  anthropics/claude-plugins-official \
  worldflowai/everything-claude-code \
  https://github.com/affaan-m/ECC.git \
  latent-spaces/brag; do
  claude plugin marketplace add "$source" >/dev/null 2>&1 \
    && echo "  added  $source" \
    || echo "  keep   $source (already added, or failed: run 'claude plugin marketplace add $source' to see why)"
done

echo "Plugins"
for plugin in \
  security-guidance@claude-plugins-official \
  everything-claude-code@everything-claude-code \
  ecc@ecc \
  brag@brag; do
  claude plugin install "$plugin" --scope user
done

echo "Done. Start a new Claude Code session to load everything."
