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
		lidSwitch = lib.mkDefault "suspend";
		lidSwitchDocked = lib.mkDefault "ignore";
		lidSwitchExternalPower = lib.mkDefault "suspend";
		extraConfig = ''
			IdleAction=suspend
			IdleActionSec=30min
			HandlePowerKey=suspend
			HandleSuspendKey=suspend
			HandleHibernateKey=hibernate
		'';
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
