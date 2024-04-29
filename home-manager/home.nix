{ config, pkgs, ... }: {
  programs.zsh.enable = true;
  nixpkgs = {
    config = { allowUnfree = true; };
  };
  programs.neovim.enable = true;
  home.packages = with pkgs; [ tmux ];
  home = {
    username = "geoffeg";
    homeDirectory = "/home/geoffeg";
  };
  programs.tmux = {
    enable = true;
    clock24 = true;
    
    plugins = with pkgs; [
      tmuxPlugins.sensible
    ];
    extraConfig = ''
      set -g status-interval 2
      set -g status-style bg='#222222',fg='#dddddd'
      set -g status-right '#($TMUX_PLUGIN_MANAGER_PATH/tmux-mem-cpu-load/tmux-mem-cpu-load -g 0 --colors --interval 2)#[default]'
      set -ag status-right '#[bg=#22222]#[fg=#ffffff] | #(whoami)@#h | %a %h-%d %H:%M#[default]'
      set -g status-right-length 120

      run '~/.tmux/plugins/tpm/tpm'
    '';
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.05";
}

