{ config, lib, pkgs, ... }:

let
	cfg = config.profiles.desktop.kde;
in
{
	options.profiles.desktop.kde = {
		enable = lib.mkEnableOption "KDE Plasma 6 desktop profile";
	};

	config = lib.mkIf cfg.enable {
		services.xserver.enable = true;

		services.displayManager.sddm = {
			enable = true;
			wayland.enable = true;
		};

		services.displayManager.defaultSession = "plasma";
		services.desktopManager.plasma6.enable = true;

		security.rtkit.enable = true;
		services.pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
		};

		services.libinput.enable = true;

		xdg.portal = {
			enable = true;
			extraPortals = [ pkgs.xdg-desktop-portal-kde ];
		};
	};
}
