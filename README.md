# claude-code-template

My Claude Code setup (plugins, skills, MCP servers and CLI tools), packaged as a
GitHub template for starting new projects.

## Start a new project

```bash
gh repo create my-project --template BezhoMatiashvili/claude-code-template --private --clone
cd my-project
./scripts/doctor.sh      # checks the CLIs below are installed
```

Then fill in `CLAUDE.md` and delete anything the project doesn't need.

## Set up a new machine (once)

```bash
gh repo clone BezhoMatiashvili/claude-code-template ~/claude-code-template
~/claude-code-template/scripts/install-user.sh
```

This copies the 31 skills into `~/.claude/skills/` and installs the four plugins
at user scope. It is safe to re-run; skills that are already installed are kept
unless you pass `--force`.

## What's in here

| Path | What it is | How it loads |
| --- | --- | --- |
| `.claude/settings.json` | Plugin marketplaces and plugins, auto-approval for the playwright MCP server, git attribution turned off | Project settings, on open |
| `.mcp.json` | playwright MCP server | Project MCP config, on open |
| `mcp/optional-servers.json` | supabase, supabase-staging, digitalocean MCP servers | Copy a block into `.mcp.json` when a project needs it |
| `user/skills/` | 31 skills | Installed to `~/.claude/skills/` by `scripts/install-user.sh`; not loaded from here |
| `user/skill-sources.md` | Which repo and commit each skill came from | Reference |
| `CLAUDE.md` | Starter project instructions | Loaded every session |
| `.env.example` | Environment variables the optional MCP servers read | Copy to `.env` |
| `scripts/doctor.sh` | Checks for claude, git, gh, node, npx, uv, docker | Run by hand |
| `scripts/install-user.sh` | User-level install of skills and plugins | Run by hand |

### Why the skills aren't in `.claude/skills/`

When a skill exists in both `~/.claude/skills/` and a project's `.claude/skills/`,
Claude Code keeps both. Shipping them in the project would list every skill twice
on a machine that already has them. On a machine without the user-level install
(a cloud session, a teammate), copy them into the project instead:

```bash
mkdir -p .claude/skills && cp -r user/skills/* .claude/skills/
```

## Plugins

| Plugin | Marketplace |
| --- | --- |
| `security-guidance` | `anthropics/claude-plugins-official` |
| `everything-claude-code` | `worldflowai/everything-claude-code` |
| `ecc` | `https://github.com/affaan-m/ECC.git` |
| `brag` | `latent-spaces/brag` |

`everything-claude-code` and `ecc` overlap heavily; both are here because both
are enabled in the current setup. `ecc` has two settings to fill in after
install: run `/plugin configure ecc@ecc`. The `chrome-devtools` MCP server comes
with `ecc`.

## MCP servers

- **playwright** is on by default.
- **supabase**, **supabase-staging** and **digitalocean** are in
  `mcp/optional-servers.json`. Copy the block you need into `.mcp.json`, fill in
  `.env`, and export it before starting Claude Code (`set -a; source .env; set +a`).
  If a variable is unset the server still loads with the literal `${VAR}` and
  `claude mcp list` shows a warning.
- Project-specific servers (ones tied to a single project's code or API) are
  left out on purpose. Add them in the project that owns them.

## Not in this repo

- **Claude in Chrome**: a browser extension. Install it from the Chrome Web
  Store and sign in.
- **Skills synced from claude.ai** (docx, pdf, pptx, xlsx, skill-creator and
  others) come with the account.
- **Personal preferences** (model, effort, theme) stay in `~/.claude/settings.json`.
- **Secrets**: `.env` is git-ignored.

## Keep this repo private

`user/skills/apple-design/references/` contains text from Apple's Human Interface
Guidelines, and the third-party skills carry their own licenses.
