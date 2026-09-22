# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nvidia.nix
      ../../modules/common/default.nix
      ../../modules/desktop
      ../../modules/common/ssh.nix
      ../../modules/users/geoffeg.nix
      ../../modules/laptop/power.nix
    ];

  networking = {
    hostName = "t14"; # Define your hostname.
    networkmanager.enable = true; # Enable the NetworkManager service.
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "keep";
      };
      efi.canTouchEfiVariables = true;
    };
    resumeDevice = "/dev/mapper/cryptroot";
    zswap = {
      enable = true;
      compressor = "zstd";
      maxPoolPercent = 20;
      shrinkerEnabled = true;
    };
    kernel.sysctl = {
      "vm.swappiness" = 100;
    };
    kernelParams = [
      "resume_offset=533760"
    ];
  };

  swapDevices = [{
    device = "/swap/swapfile";
  }];

  time.timeZone = "America/Chicago";

  system.stateVersion = "26.05";
}
