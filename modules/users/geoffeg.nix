{ pkgs, ... }:

{
  programs.zsh.enable = true;

  users.users.geoffeg = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
    ];
  };

  home-manager.users.geoffeg = import ../../home/geoffeg;
}
