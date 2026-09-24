{ ... }:
{
  # Tailscale's shields-up/exit-node rules are supported on the nftables backend.
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ config.services.tailscale.interfaceName ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  systemd.network.wait-online.enable = true;
  boot.initrd.systemd.network.wait-online.enable = true;

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
