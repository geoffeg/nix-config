{ config, lib, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Optimus laptop: run the dGPU only on demand, render offloaded to iGPU otherwise.
    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      # Fill in with the actual PCI bus IDs from `lspci | grep -E "VGA|3D"`.
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
