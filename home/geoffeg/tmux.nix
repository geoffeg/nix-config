{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    # home-manager sources plugins directly, so no tpm bootstrapping is needed.
    plugins = with pkgs.tmuxPlugins; [
      sensible
    ];

    extraConfig = ''
      set -g status-interval 2
      set -g status-style bg='#222222',fg='#dddddd'
      set -g status-right '#(${pkgs.tmux-mem-cpu-load}/bin/tmux-mem-cpu-load -g 0 --colors --interval 2)#[default]'
      set -ag status-right '#[bg=#222222]#[fg=#ffffff] | #(whoami)@#h | %a %h-%d %H:%M#[default]'
      set -g status-right-length 120
    '';
  };
}
