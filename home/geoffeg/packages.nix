{ pkgs, ... }:

{
  home.packages = with pkgs; [
    deskflow
    just
    age
    ssh-to-age
  ];
}
