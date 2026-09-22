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

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, disko, git-hooks, ... } @ inputs:
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

      mkPreCommitCheck = system: git-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          gitleaks = {
            enable = true;
            name = "gitleaks";
            entry = "${(mkPkgs system).gitleaks}/bin/gitleaks protect --staged --verbose --redact";
            pass_filenames = false;
          };
          nixpkgs-fmt.enable = true;
        };
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

      checks = forAllSystems (system: {
        pre-commit-check = mkPreCommitCheck system;
      });

      devShells = forAllSystems (system: {
        default =
          let
            pkgs = mkPkgs system;
          in
          pkgs.mkShell {
            inherit (self.checks.${system}.pre-commit-check) shellHook;
            packages = [ pkgs.gitleaks ];
          };
      });
    };
}
