{ pkgs ? import <nixpkgs> { } }: rec {

  #################### Packages with external source ####################

  wfview = pkgs.callPackage ./wfview { };
  qcustomplot = pkgs.callPackage ./qcustomplot { };

}