{ pkgs, ... }:

{
  users.users.geoffeg = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };
}