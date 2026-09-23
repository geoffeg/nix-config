{ pkgs, ... }:

{
  imports = [
    ./packages.nix
    ./vscode.nix
    ./git.nix
    ./kde.nix
    ./zsh.nix
    ./tmux.nix
    ./neovim.nix
    ./ssh.nix
  ];

  home.username = "geoffeg";
  home.homeDirectory = "/home/geoffeg";

  # Matches the NixOS state version this config targets.
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
