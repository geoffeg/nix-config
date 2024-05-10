{ inputs, outputs, lib, pkgs, configLib,  ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
#  ] ++ (builtins.attrValues outputs.nixosModules);

  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  time.timeZone = lib.mkDefault "America/Chicago";

  home-manager.extraSpecialArgs = { inherit inputs outputs; };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    #nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # See https://jackson.dev/post/nix-reasonable-defaults/
      connect-timeout = 5;
      log-lines = 25;
      min-free = 128000000; # 128MB
      max-free = 1000000000; # 1GB

      # Deduplicate and optimize nix store
      auto-optimise-store = true;

      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };

    # Garbage Collection
    gc = {
      automatic = true;
      options = "--delete-older-than 10d";
    };

  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  nixpkgs = {
    # you can add global overlays here
    #overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    btop
    wget
    zsh
  ];

  users.users.geoffeg = {
    name = "geoffeg";
    isNormalUser = true;
    description = "geoffeg";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = [ pkgs.home-manager ];
  };

  home-manager.users.geoffeg = import (configLib.relativeToRoot "home-manager/home.nix");

  services = {
    openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        # Harden
        PasswordAuthentication = true;
        PermitRootLogin = "no";

        # Automatically remove stale sockets
        StreamLocalBindUnlink = "yes";

        # Allow forwarding ports to everywhere
        GatewayPorts = "clientspecified";
      };

      # hostKeys = [{
      #   path = "${lib.optionalString hasOptinPersistence "/persist"}/etc/ssh/ssh_host_ed25519_key";
      #   type = "ed25519";
      # }];
    };
    tailscale.enable = true;
  };

  hardware.enableRedistributableFirmware = true;
}
