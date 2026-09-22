{ config, lib, pkgs, ... }:

{
  services = {
    power-profiles-daemon.enable = true;
    thermald.enable = lib.mkDefault true;
    upower.enable = true;
    tlp.enable = false;
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "powersave";
    powertop.enable = true;
  };

  boot.kernel.sysctl = {
    "vm.laptop_mode" = lib.mkDefault 5;
    "vm.dirty_writeback_centisecs" = lib.mkDefault 1500;
  };

  services.logind = {
    settings.Login = {
      HandleLidSwitch = lib.mkDefault "suspend";
      HandleLidSwitchDocked = lib.mkDefault "ignore";
      HandleLidSwitchExternalPower = lib.mkDefault "suspend";
      IdleAction = lib.mkDefault "suspend";
      IdleActionSec = lib.mkDefault "30min";
      HandlePowerKey = lib.mkDefault "suspend";
      HandleSuspendKey = lib.mkDefault "suspend";
      HandleHibernateKey = lib.mkDefault "hibernate";
    };
  };

  hardware.bluetooth = {
    enable = lib.mkDefault true;
    powerOnBoot = lib.mkDefault false;
  };

  networking.networkmanager.wifi.powersave = lib.mkDefault true;

  environment.systemPackages = with pkgs; [
    acpi
    powertop
  ];
}
