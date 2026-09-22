{ ... }:

{
	services.openssh = {
		enable = true;
		openFirewall = true;

		settings = {
			PermitRootLogin = "no";
			PasswordAuthentication = true;
			KbdInteractiveAuthentication = true;
			PubkeyAuthentication = true;
			X11Forwarding = false;
			UsePAM = true;
		};
	};
}
