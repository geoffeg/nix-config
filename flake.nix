{
  description = "My first flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
   
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    nixvim = {
      url = "github:nix-community/nixvim/nixos-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, vscode-server, ...}@inputs:
  let
    inherit (self) outputs;
    systems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
    inherit (nixpkgs) lib;
    configLib = import ./lib { inherit lib; };
    specialArgs = { inherit inputs outputs configLib nixpkgs; };
  in
  {

    packages = forAllSystems
      (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; }
      );
    #nixosModules = import ./modules/nixos;
    #homeManagerModules = import ./modules/home-manager;
    nixosConfigurations = {
      nixtest = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          home-manager.nixosModules.home-manager{
            home-manager.extraSpecialArgs = specialArgs;
          }
          ./hosts/nixtest
        ];
      };

      # lore = ...
    };
    
    # homeConfigurations = {
    #   "geoffeg@nixos" = home-manager.lib.homeManagerConfiguration {
    #     pkgs = nixpkgs.legacyPackages.aarch64-linux;
    #     extraSpecialArgs = {inherit inputs outputs;};
    #     modules = [
    #       ./home-manager/home.nix
    #     ];
    #   };
    # };
 };
}
