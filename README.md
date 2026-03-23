# kuzea-workspace

Application-layer files for Kuzea (OpenClaw AI agent) running on `sancta-claw`.

## Contents

- **skills/** — Claude Code skill definitions (todoist, self-improving-agent, browser, code-agents, coding-local)
- **hooks/** — Claude Code hook handlers (self-improvement)
- **cron-manage.mjs** — OpenClaw cron job manager (gateway RPC client)
- **claude-CLAUDE.md** — Claude Code global context
- **claude-settings.json** — Claude Code settings
- **gitconfig** — git identity for openclaw user
- **git-credential-agenix** — credential helper reading PAT from agenix secret

## Usage from nixos-config

Add this flake as an input:

```nix
inputs.kuzea-workspace.url = "github:alexandru-savinov/kuzea-workspace";
```

Then reference individual packages:

```nix
{ inputs, pkgs, ... }:
let
  ws = inputs.kuzea-workspace.packages.${pkgs.system};
in {
  # Example: deploy a skill
  environment.etc."openclaw/skills/todoist".source = ws.skills-todoist-natural-language;

  # Example: install cron manager
  environment.etc."openclaw/bin/cron-manage.mjs".source = ws.cron-manage;

  # Example: git credential helper (shell script with proper shebang)
  environment.etc."openclaw/bin/git-credential-agenix".source = ws.git-credential-agenix;
}
```

## Development

```sh
nix flake check    # validate
nix build .#cron-manage   # build a single package
```
