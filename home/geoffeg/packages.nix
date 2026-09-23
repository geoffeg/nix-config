{ pkgs, ... }:

{
  home.packages = with pkgs; [
    deskflow
    just
  ];
}
