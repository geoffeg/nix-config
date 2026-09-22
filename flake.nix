{
  description = "geoffeg's NixOS configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, disko, ... } @ inputs:
    let
      lib = nixpkgs.lib;
      ourLib = import ./lib { inherit inputs; };

      # Repo currently targets NixOS hosts only.
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = lib.genAttrs supportedSystems;

      hostsDir = ./hosts;
      hostNames = ourLib.listHosts hostsDir;

      mkPkgs = system:
        import nixpkgs {
          inherit system;
        };
    in
    {
      lib = ourLib;

      nixosConfigurations = lib.genAttrs hostNames (hostname:
        ourLib.mkHost { inherit hostname hostsDir; }
      );

      nixosModules = {
        default = import ./modules;
        common = import ./modules/common;
        desktop = import ./modules/desktop;
      };

      formatter = forAllSystems (system: (mkPkgs system).nixpkgs-fmt);
    };
}
