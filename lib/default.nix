# Shared helpers used by flake.nix to wire up hosts and users.
{ inputs }:

let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib;

  # Names of subdirectories of `dir` that contain a host entry module.
  listConfigDirs = dir:
    let
      isConfigDir = name: type:
        type == "directory"
        && (
          builtins.pathExists (dir + "/${name}/default.nix")
          || builtins.pathExists (dir + "/${name}/configuration.nix")
        );
    in
    builtins.attrNames (lib.filterAttrs isConfigDir (builtins.readDir dir));

  hostModulePath = hostsDir: hostname:
    let
      hostDir = hostsDir + "/${hostname}";
      defaultPath = hostDir + "/default.nix";
      configurationPath = hostDir + "/configuration.nix";
    in
    if builtins.pathExists defaultPath then defaultPath else configurationPath;

  # Imports every sibling *.nix file (other than default.nix itself) plus any
  # subdirectory containing its own default.nix. Lets module directories
  # aggregate themselves without hand-maintaining an `imports` list.
  importDir = dir:
    let
      entries = builtins.readDir dir;
      names = builtins.attrNames entries;

      isModuleFile = name:
        name != "default.nix"
        && entries.${name} == "regular"
        && builtins.match ".*\\.nix" name != null;

      isModuleDir = name:
        entries.${name} == "directory"
        && builtins.pathExists (dir + "/${name}/default.nix");
    in
    map (name: dir + "/${name}") (builtins.filter (name: isModuleFile name || isModuleDir name) names);
in
{
  listHosts = listConfigDirs;
  listUsers = listConfigDirs;
  inherit importDir;

  # Build a nixosConfigurations entry for `hostname`, wired up with disko
  # and home-manager. The host module is `default.nix` if present,
  # otherwise `configuration.nix`.
  #
  # The host is expected to set
  # `nixpkgs.hostPlatform`, since no `system` is passed here.
  mkHost = { hostname, hostsDir, extraModules ? [ ] }:
    lib.nixosSystem {
      specialArgs = { inherit inputs importDir; };
      modules = [
        (hostModulePath hostsDir hostname)
        inputs.disko.nixosModules.disko
        inputs.home-manager.nixosModules.home-manager
        {
          networking.hostName = lib.mkDefault hostname;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs importDir; };
        }
      ] ++ extraModules;
    };
}
