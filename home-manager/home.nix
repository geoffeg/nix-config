{ config, lib, pkgs, ... }:
let
  plugins = with pkgs; [
    tmuxPlugins.sensible
    tmuxPlugins.sysstat
  ];
in
{
  imports = [
    tmux.nix
  ];
  #programs.zsh.enable = true;
  nixpkgs = {
    config = { allowUnfree = true; };
  };
  programs.neovim.enable = true;
#  home.packages = with pkgs; [ tmux ];
  home = {
    username = "geoffeg";
    homeDirectory = "/home/geoffeg";
  };
#  programs.tmux = {
#    enable = true;
#    clock24 = true;
#    terminal = "tmux-256color";
#    
#    # The run-shell has to come near the end of the file for some reason, but the nix tmux config will
#    # put it earlier in the file. Re-running run-shell doesn't seem to hurt anything...
#    extraConfig = ''
#      set -g default-terminal "xterm-256color"
#      set -g status-interval 1
#      set -g status-style bg='#222222',fg='#dddddd'
#      set -g status-right "#{sysstat_cpu} | #{sysstat_mem} | #{sysstat_swap} | #{sysstat_loadavg} | #[fg=cyan]#(echo $USER)#[default]@#H"
#      set -ag status-right '| %a %h-%d %H:%M#[default]'
#      set -g status-right-length 120
#      set-environment -g COLORTERM "truecolor"
#      ${lib.concatStrings (map (x: ''
#      run-shell ${x.rtp}
#      '') plugins)}
#    '';
#  };

  programs.home-manager.enable = true;
  programs.git.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.05";
}

