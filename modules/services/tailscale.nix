{ config, lib, pkgs, ... }:
let
  hasKde = config.services.desktopManager.plasma6.enable;
in
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
    authKeyFile = config.sops.secrets.tailscaleAuthKey.path;
    extraUpFlags = [
      "--ssh"
      "--accept-dns=true"
      "--accept-routes=true"
      "--shields-up=false"
    ];
    # KTailctl talks to tailscaled as a non-root user.
    extraSetFlags = lib.optionals hasKde [ "--operator=geoffeg" ];
  };

  environment.systemPackages = lib.optionals hasKde [
    pkgs.ktailctl
  ];
}
