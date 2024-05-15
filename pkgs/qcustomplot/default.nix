{ lib, pkgs, stdenv, fetchurl }:

let srcs = rec {
  version = "2.1.1";
  qcustomplot_super = builtins.fetchurl {
      url = "https://www.qcustomplot.com/release/${version}/QCustomPlot-source.tar.gz";
      sha256 = "sha256:0bqqhx249lksinp5xrxfmmqzkg2gwljxpjspyc0qznvrqzg24bay";
  };
  qcustomplot_sharedlib = builtins.fetchurl {
      url = "https://www.qcustomplot.com/release/${version}/QCustomPlot-sharedlib.tar.gz";
      sha256 = "sha256:1h5l29q82grz94z5ch95vq6hs5clcymbcb3yngqfsh47gsffmmim";
  };
};
in stdenv.mkDerivation {
  name = "qcustomplot";
  version = srcs.version;
  src = srcs.qcustomplot_super;

  # Packages required to build
  nativeBuildInputs = with pkgs; [ qt6.qmake pkg-config qt6.wrapQtAppsHook ];
  
  postUnpack = ''
    tar -xzf ${srcs.qcustomplot_sharedlib}
    mv qcustomplot-sharedlib qcustomplot-source
  '';

  configurePhase = ''
    (cd qcustomplot-sharedlib/sharedlib-compilation && qmake )
  '';

  buildPhase = ''
      ( cd qcustomplot-sharedlib/sharedlib-compilation && make -f Makefile.Release all )
  '';

  installPhase = ''
      mkdir -p $out/lib $out/include
      cp -rf qcustomplot-sharedlib/sharedlib-compilation/libqcustomplot.so* $out/lib/
      cp -rf qcustomplot.h $out/include/
  '';

  # outputs = [ "out" "dev" "lib" ];

  meta = with lib; {
    description = "QCustomPlot is an easy to use plotting widget for Qt.";
    longDescription = ''
      QCustomPlot is a Qt C++ widget for plotting and data visualization. 
      It has no further dependencies and is well documented. 
      This plotting library focuses on making good looking, publication quality 2D plots, 
      graphs and charts, as well as offering high performance for realtime visualization applications. 
      Have a look at the Setting Up and the Basic Plotting tutorials to get started.'';
    homepage = "https://www.qcustomplot.com/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ geoffeg ];
    platforms = platforms.linux;
  };
}
