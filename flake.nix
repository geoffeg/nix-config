{
  description = "My first flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
   
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = { self, nixpkgs, home-manager, vscode-server, ...}@inputs: let
    inherit (self) outputs;
    systems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/configuration.nix
          vscode-server.nixosModules.default ({ config, pkgs, ... }: { services.vscode-server.enable = true; })
        ];
      };
    };
    
    homeConfigurations = {
      "geoffeg@nixos" = home-manager.lib.homeManagerConfiguration {
       pkgs = nixpkgs.legacyPackages.aarch64-linux;
       extraSpecialArgs = {inherit inputs outputs;};
       modules = [
         ./home-manager/home.nix
      ];
    };
  };
 };
}
