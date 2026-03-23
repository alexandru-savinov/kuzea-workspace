{
  description = "Kuzea workspace — application-layer files for OpenClaw AI agent";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      forAllSystems =
        f:
        nixpkgs.lib.genAttrs
          [
            "x86_64-linux"
            "aarch64-linux"
          ]
          (
            system:
            f {
              pkgs = nixpkgs.legacyPackages.${system};
            }
          );
    in
    {
      packages = forAllSystems (
        { pkgs }:
        {
          # Skills — each as a simple source copy
          skills-todoist-natural-language = pkgs.runCommand "skills-todoist-natural-language" { } ''
            cp -r ${./skills/todoist-natural-language} $out
          '';
          skills-self-improving-agent = pkgs.runCommand "skills-self-improving-agent" { } ''
            cp -r ${./skills/self-improving-agent} $out
          '';
          skills-agent-browser = pkgs.runCommand "skills-agent-browser" { } ''
            cp -r ${./skills/agent-browser} $out
          '';
          skills-claude-code-agents = pkgs.runCommand "skills-claude-code-agents" { } ''
            cp -r ${./skills/claude-code-agents} $out
          '';
          skills-coding-agent-local = pkgs.runCommand "skills-coding-agent-local" { } ''
            cp -r ${./skills/coding-agent-local} $out
          '';

          # Hook
          hooks-self-improvement = pkgs.runCommand "hooks-self-improvement" { } ''
            cp -r ${./hooks/self-improvement} $out
          '';

          # Individual files
          cron-manage = pkgs.writeTextFile {
            name = "cron-manage.mjs";
            text = builtins.readFile ./cron-manage.mjs;
            executable = true;
          };

          claude-md = pkgs.writeText "CLAUDE.md" (builtins.readFile ./claude-CLAUDE.md);

          claude-settings = pkgs.writeText "claude-settings.json" (builtins.readFile ./claude-settings.json);

          gitconfig = pkgs.writeText "gitconfig" (builtins.readFile ./gitconfig);

          git-credential-agenix = pkgs.writeShellScript "git-credential-agenix" (
            builtins.readFile ./git-credential-agenix
          );
        }
      );
    };
}
