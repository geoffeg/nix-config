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

			EnableTrackingProtection = {
				Value = true;
				Locked = true;
				Cryptomining = true;
				Fingerprinting = true;
			};
		};

		profiles.default = {
			id = 0;
			isDefault = true;

			search = {
				force = true;
				default = "DuckDuckGo";
			};

			settings = {
				"app.normandy.enabled" = false;
				"app.shield.optoutstudies.enabled" = false;
				"beacon.enabled" = false;
				"browser.contentblocking.category" = "strict";
				"browser.discovery.enabled" = false;
				"browser.formfill.enable" = false;
				"browser.newtabpage.activity-stream.feeds.telemetry" = false;
				"browser.newtabpage.activity-stream.telemetry" = false;
				"browser.ping-centre.telemetry" = false;
				"browser.safebrowsing.downloads.remote.enabled" = false;
				"browser.search.suggest.enabled" = false;
				"browser.send_pings" = false;
				"browser.sessionstore.privacy_level" = 2;
				"browser.shell.checkDefaultBrowser" = false;
				"browser.startup.page" = 3;
				"browser.tabs.crashReporting.sendReport" = false;
				"browser.urlbar.quicksuggest.enabled" = false;
				"browser.urlbar.suggest.searches" = false;
				"datareporting.healthreport.uploadEnabled" = false;
				"datareporting.policy.dataSubmissionEnabled" = false;
				"device.sensors.enabled" = false;
				"dom.battery.enabled" = false;
				"dom.event.clipboardevents.enabled" = false;
				"geo.enabled" = false;
				"media.peerconnection.enabled" = false;
				"network.cookie.cookieBehavior" = 1;
				"network.dns.disablePrefetch" = true;
				"network.http.referer.XOriginPolicy" = 2;
				"network.http.sendRefererHeader" = 1;
				"network.predictor.enabled" = false;
				"network.prefetch-next" = false;
				"privacy.donottrackheader.enabled" = true;
				"privacy.firstparty.isolate" = true;
				"privacy.globalprivacycontrol.enabled" = true;
				"privacy.resistFingerprinting" = true;
				"privacy.trackingprotection.enabled" = true;
				"privacy.trackingprotection.pbmode.enabled" = true;
				"signon.rememberSignons" = false;
				"toolkit.telemetry.enabled" = false;
				"toolkit.telemetry.unified" = false;
			};

			extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
				ublock-origin
				multi-account-containers
			];
		};
	};
}
