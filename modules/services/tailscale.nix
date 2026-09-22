{ ... }:
{
	services.tailscale = {
		enable = true;
		openFirewall = true;
		useRoutingFeatures = "client";
		extraUpFlags = [
			"--ssh"
			"--accept-dns=true"
			"--accept-routes=true"
			"--shields-up=false"
		];
	};

	networking.firewall.trustedInterfaces = [ "tailscale0" ];
}
