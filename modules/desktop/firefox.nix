{ pkgs, ... }:

{
	programs.firefox = {
		enable = true;

		policies = {
			DisableTelemetry = true;
			DisableFirefoxStudies = true;
			DisablePocket = true;
			DisableAccounts = true;
			DisableSetDesktopBackground = true;
			DisableFormHistory = true;
			DontCheckDefaultBrowser = true;
			OfferToSaveLogins = false;
			PasswordManagerEnabled = false;

			ExtensionSettings = {
				"uBlock0@raymondhill.net" = {
					installation_mode = "force_installed";
					install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
				};
				"@testpilot-containers" = {
					installation_mode = "force_installed";
					install_url = "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi";
				};
			};

			EnableTrackingProtection = {
				Value = true;
				Locked = true;
				Cryptomining = true;
				Fingerprinting = true;
			};
		};

	};
}
