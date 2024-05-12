{ config, lib, pkgs, ... }:
let
  plugins = with pkgs; [
    tmuxPlugins.sensible
    tmuxPlugins.sysstat
  ];
in
{
  imports = [
    ./nixvim.nix
    ./tmux.nix
    ./zsh
  ];

  nixpkgs = {
    config = { allowUnfree = true; };
  };
  
  home = {
    username = "geoffeg";
    homeDirectory = "/home/geoffeg";
  };

  home.packages = with pkgs; [ 
    btop
    eza
    fzf
    vim
  ];

  programs = {
    home-manager.enable = true;
    git.enable = true;
    # zsh.enable = true;
  };

  # programs.neovim.enable = true;
  # programs.home-manager.enable = true;
  # programs.git.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.05";
}

