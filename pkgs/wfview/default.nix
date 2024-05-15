{ lib, pkgs, stdenv, fetchFromGitLab }:

let
  qcustomplot = pkgs.callPackage ../qcustomplot {};

in stdenv.mkDerivation rec {
  pname = "wfview";
  version = "1.64";

  src = fetchFromGitLab {
    owner = "eliggett";
    repo = "wfview";
    rev = "v" + version;
    hash = "sha256-QdrCji+gktrWfJKf9+yPkmdzfXOMIh4lwG2JA8WVUT8=";
  };

  # Packages required to run
  buildInputs = with pkgs; [ libsForQt5.qt5.qtbase libsForQt5.qt5.qtmultimedia libsForQt5.qt5.qtserialport ];

  # Packages required to build
  nativeBuildInputs = with pkgs; [ libsForQt5.qt5.qttools libsForQt5.qt5.wrapQtAppsHook qcustomplot ];

  meta = with lib; {
    description = "Open-source software for the control of modern amateur radios";
    longDescription = ''
      wfview is open-source software for the control of modern Icom radios,
      including the IC-7300, IC-7610, IC-705, IC-R8600 and IC-9700.
      USB and LAN are supported.'';
    homepage = "https://wfview.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ geoffeg ];
    platforms = platforms.linux;
  };
}
